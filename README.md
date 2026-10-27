# Daymark — Personal Productivity System
React + TypeScript + Vite + Supabase MVP.

## Run locally
Requires Node.js 20+. Run `npm install`, copy `.env.example` to `.env.local`, fill in your Supabase URL and publishable key, then run `npm run dev`.

## Supabase setup
Open Supabase SQL Editor and run `supabase/schema.sql`. Add `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` to your local `.env.local` and Vercel environment variables. Use only the publishable/anon key in frontend code. Never expose the service-role key.

## Vercel
Import this repository as a Vite project, set the two environment variables, and deploy. Pushes to main deploy automatically once Vercel is connected.

## MVP notes
Daily habits/tasks and mood check-ins are wired to Supabase when configured. Goals and monthly reflections are starter UI and need persistence wiring. Monthly chart/AI insights are not yet implemented and must not be treated as real analytics.