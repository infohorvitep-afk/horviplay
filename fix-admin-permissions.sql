-- HorviPlay: opravuje kontrolu administrátora bez verejného odhalenia zoznamu.
-- Spusti v Supabase SQL Editore ako vlastník projektu.
grant select on table public.horviplay_admins to authenticated;
drop policy if exists horviplay_admin_self_read on public.horviplay_admins;
create policy horviplay_admin_self_read
on public.horviplay_admins for select to authenticated
using (user_id = (select auth.uid()));
-- Kontrola: mal by sa zobraziť aspoň jeden riadok (ak bol admin pridelený).
select count(*) as pocet_adminov from public.horviplay_admins;
