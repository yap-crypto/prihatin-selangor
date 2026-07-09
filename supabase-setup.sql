-- Prihatin Selangor Marketplace — cloud accounts setup
-- Run ONCE: Supabase Dashboard → SQL Editor → New query → paste → Run.
-- (Uses the same Supabase project already configured for Optimized Life.)

-- One row per signed-in account, holding that account's whole app state as JSON.
create table if not exists public.marketplace_data (
  user_id uuid primary key references auth.users (id) on delete cascade,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Row-level security: each account can only read/write its own row.
alter table public.marketplace_data enable row level security;

drop policy if exists "Users manage own marketplace data" on public.marketplace_data;
create policy "Users manage own marketplace data" on public.marketplace_data
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
