-- Team File Tracker — full schema (v2)
-- Already applied to your live Supabase project. Kept here for reference / rebuilding elsewhere.

create table if not exists submissions (
  id uuid primary key default gen_random_uuid(),
  submitter_name text not null,
  file_name text not null,
  file_type text not null,
  file_path text not null,
  file_date date,                          -- legacy, no longer collected from the form
  status text not null,
  skiptraced boolean not null,
  skiptrace_contacts_sent integer,         -- legacy, superseded by skiptrace_progress
  skiptrace_date_sent date,                -- legacy, superseded by skiptrace_progress
  skiptrace_source text,
  skiptrace_cost numeric,
  skiptrace_notes text,
  skiptrace_complete boolean not null default false,
  created_at timestamptz not null default now()   -- this is the automatic "entry date"
);

create table if not exists statuses (
  id uuid primary key default gen_random_uuid(),
  label text not null unique,
  sort_order integer not null default 0
);

create table if not exists file_types (
  id uuid primary key default gen_random_uuid(),
  label text not null unique,
  sort_order integer not null default 0
);

insert into statuses (label, sort_order) values ('Filtered', 0), ('Unfiltered', 1) on conflict (label) do nothing;
insert into file_types (label, sort_order) values ('Excel', 0), ('CSV', 1), ('Other', 2) on conflict (label) do nothing;

create table if not exists skiptrace_progress (
  id uuid primary key default gen_random_uuid(),
  submission_id uuid not null references submissions(id) on delete cascade,
  range_start integer,
  range_end integer,
  notes text,
  contacted_at date not null default current_date,
  created_at timestamptz not null default now()
);

insert into storage.buckets (id, name, public)
values ('team-files', 'team-files', true)
on conflict (id) do nothing;

alter table submissions enable row level security;
alter table statuses enable row level security;
alter table file_types enable row level security;
alter table skiptrace_progress enable row level security;

create policy "public insert" on submissions for insert to anon with check (true);
create policy "public read" on submissions for select to anon using (true);
create policy "public update submissions" on submissions for update to anon using (true) with check (true);
create policy "public delete submissions" on submissions for delete to anon using (true);

create policy "public all statuses" on statuses for all to anon using (true) with check (true);
create policy "public all file_types" on file_types for all to anon using (true) with check (true);
create policy "public all skiptrace_progress" on skiptrace_progress for all to anon using (true) with check (true);

create policy "public storage upload" on storage.objects for insert to anon with check (bucket_id = 'team-files');
create policy "public storage read" on storage.objects for select to anon using (bucket_id = 'team-files');
