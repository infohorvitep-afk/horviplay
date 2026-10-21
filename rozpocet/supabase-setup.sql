-- Spusti raz v Supabase SQL Editore (projekt HorviPlay).
create table if not exists public.horviplay_family_budget (
  id text primary key check (id = 'horvathovci'),
  payload jsonb not null,
  updated_at timestamptz not null default now()
);
alter table public.horviplay_family_budget enable row level security;
grant select, insert, update on public.horviplay_family_budget to authenticated;
drop policy if exists family_budget_read on public.horviplay_family_budget;
drop policy if exists family_budget_insert on public.horviplay_family_budget;
drop policy if exists family_budget_update on public.horviplay_family_budget;
create policy family_budget_read on public.horviplay_family_budget for select to authenticated using (
  (select auth.jwt()->>'email') = 'nikolka.bilkova@gmail.com'
  or exists(select 1 from public.horviplay_admins a where a.user_id=(select auth.uid()))
);
create policy family_budget_insert on public.horviplay_family_budget for insert to authenticated with check (
  (select auth.jwt()->>'email') = 'nikolka.bilkova@gmail.com'
  or exists(select 1 from public.horviplay_admins a where a.user_id=(select auth.uid()))
);
create policy family_budget_update on public.horviplay_family_budget for update to authenticated using (
  (select auth.jwt()->>'email') = 'nikolka.bilkova@gmail.com'
  or exists(select 1 from public.horviplay_admins a where a.user_id=(select auth.uid()))
) with check (
  (select auth.jwt()->>'email') = 'nikolka.bilkova@gmail.com'
  or exists(select 1 from public.horviplay_admins a where a.user_id=(select auth.uid()))
);
