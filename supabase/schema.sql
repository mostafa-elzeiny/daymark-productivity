create extension if not exists pgcrypto;
create table if not exists public.habits(id uuid primary key default gen_random_uuid(),user_id uuid not null references auth.users(id) on delete cascade,title text not null,category text not null default 'Personal',done boolean not null default false,log_date date not null default current_date,created_at timestamptz not null default now(),unique(user_id,title,log_date));
create table if not exists public.tasks(id uuid primary key default gen_random_uuid(),user_id uuid not null references auth.users(id) on delete cascade,title text not null,category text not null default 'Personal',priority text not null default 'Medium' check(priority in ('Low','Medium','High')),done boolean not null default false,task_date date not null default current_date,created_at timestamptz not null default now(),unique(user_id,title,task_date));
create table if not exists public.mood_entries(id uuid primary key default gen_random_uuid(),user_id uuid not null references auth.users(id) on delete cascade,mood text not null check(mood in ('Great','Motivated','Okay','Stressed','Low')),note text not null default '',created_at timestamptz not null default now());
create table if not exists public.goals(id uuid primary key default gen_random_uuid(),user_id uuid not null references auth.users(id) on delete cascade,title text not null,category text not null default 'Personal',target_date date,progress integer not null default 0 check(progress between 0 and 100),created_at timestamptz not null default now());
create table if not exists public.monthly_reviews(id uuid primary key default gen_random_uuid(),user_id uuid not null references auth.users(id) on delete cascade,review_month date not null,went_well text not null default '',blockers text not null default '',next_month_plan text not null default '',ai_summary text,created_at timestamptz not null default now(),unique(user_id,review_month));
alter table public.habits enable row level security; alter table public.tasks enable row level security; alter table public.mood_entries enable row level security; alter table public.goals enable row level security; alter table public.monthly_reviews enable row level security;
drop policy if exists "Users manage own habits" on public.habits; create policy "Users manage own habits" on public.habits for all to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
drop policy if exists "Users manage own tasks" on public.tasks; create policy "Users manage own tasks" on public.tasks for all to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
drop policy if exists "Users manage own mood entries" on public.mood_entries; create policy "Users manage own mood entries" on public.mood_entries for all to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
drop policy if exists "Users manage own goals" on public.goals; create policy "Users manage own goals" on public.goals for all to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
drop policy if exists "Users manage own monthly reviews" on public.monthly_reviews; create policy "Users manage own monthly reviews" on public.monthly_reviews for all to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
create index if not exists habits_user_date_idx on public.habits(user_id,log_date); create index if not exists tasks_user_date_idx on public.tasks(user_id,task_date); create index if not exists mood_user_created_idx on public.mood_entries(user_id,created_at desc);
-- Flexible Daymark additions. Safe to run after the original schema.
create table if not exists public.day_checkins (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 checkin_date date not null default current_date,
 mode text not null default 'Normal' check(mode in ('Normal','Busy','Travel / emergency')),
 availability text not null default 'Available',
 mood text check(mood in ('Great','Good','Okay','Stressed','Low')),
 reflection text not null default '',
 break_count integer not null default 0 check(break_count >= 0),
 created_at timestamptz not null default now(),
 unique(user_id,checkin_date)
);
create table if not exists public.unexpected_events (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 title text not null,
 note text not null default '',
 event_date date not null default current_date,
 created_at timestamptz not null default now()
);
create table if not exists public.growth_sessions (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 category text not null,
 minutes integer not null default 25 check(minutes between 1 and 600),
 session_date date not null default current_date,
 created_at timestamptz not null default now()
);
alter table public.day_checkins enable row level security;
alter table public.unexpected_events enable row level security;
alter table public.growth_sessions enable row level security;
drop policy if exists "Users manage own day checkins" on public.day_checkins;
create policy "Users manage own day checkins" on public.day_checkins for all to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
drop policy if exists "Users manage own unexpected events" on public.unexpected_events;
create policy "Users manage own unexpected events" on public.unexpected_events for all to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
drop policy if exists "Users manage own growth sessions" on public.growth_sessions;
create policy "Users manage own growth sessions" on public.growth_sessions for all to authenticated using(auth.uid()=user_id) with check(auth.uid()=user_id);
create index if not exists day_checkins_user_date_idx on public.day_checkins(user_id,checkin_date);
create index if not exists unexpected_events_user_date_idx on public.unexpected_events(user_id,event_date,created_at desc);
create index if not exists growth_sessions_user_date_idx on public.growth_sessions(user_id,session_date,created_at desc);
