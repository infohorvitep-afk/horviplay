-- HorviPlay: execute in Supabase SQL editor (same project as Naša kuchyňa).
create table if not exists public.horviplay_catalog (
  id text primary key,
  name text not null,
  icon text not null default '📱',
  cat text not null default 'Ostatné',
  url text not null default '',
  description text not null default '',
  updated_at timestamptz not null default now()
);
create table if not exists public.horviplay_admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);
alter table public.horviplay_catalog enable row level security;
alter table public.horviplay_admins enable row level security;
revoke all on public.horviplay_admins from anon, authenticated;
grant select on public.horviplay_catalog to anon, authenticated;
grant insert, update, delete on public.horviplay_catalog to authenticated;
drop policy if exists horviplay_public_read on public.horviplay_catalog;
create policy horviplay_public_read on public.horviplay_catalog for select to anon,authenticated using (true);
drop policy if exists horviplay_admin_insert on public.horviplay_catalog;
create policy horviplay_admin_insert on public.horviplay_catalog for insert to authenticated with check (exists(select 1 from public.horviplay_admins where user_id=(select auth.uid())));
drop policy if exists horviplay_admin_update on public.horviplay_catalog;
create policy horviplay_admin_update on public.horviplay_catalog for update to authenticated using (exists(select 1 from public.horviplay_admins where user_id=(select auth.uid()))) with check (exists(select 1 from public.horviplay_admins where user_id=(select auth.uid())));
drop policy if exists horviplay_admin_delete on public.horviplay_catalog;
create policy horviplay_admin_delete on public.horviplay_catalog for delete to authenticated using (exists(select 1 from public.horviplay_admins where user_id=(select auth.uid())));
-- After signing up/signing in as the administrator, run manually with a verified user UUID:
-- insert into public.horviplay_admins(user_id) values ('YOUR-VERIFIED-AUTH-USER-UUID') on conflict do nothing;
