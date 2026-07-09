# List Tracker

CRM-style page for your team to log Excel/CSV files and track skip trace outreach — no login required.

## What's in it

- **Dashboard** — quick counts (total files, filtered, skiptraced, skiptrace complete), the submit-a-file form, and a recent-files list, all on one page
- **All files** — searchable, filterable log with inline status editing and delete
- **Skip trace** — every skiptraced file gets its own card automatically; log outreach progress (date auto, lead range, notes) over time, add as many entries as needed, and mark a file complete when the whole list is worked
- **Manage options** — click the gear icon on the Dashboard to add, rename, or delete the options in the Status and File type dropdowns (not a main tab, just a quick settings panel)

## Supabase — already set up

Everything (`submissions`, `statuses`, `file_types`, `skiptrace_progress`, storage bucket, and permissions) is already created in your project (`jwctfsapxrdzznjaaufo`) and wired into `index.html`. `schema.sql` is kept for reference only.

**Note:** editing or deleting an option in Settings only changes what's offered going forward — it does not rewrite the status/type text already saved on existing files.

## Put it on GitHub Pages

```bash
git init
git add .
git commit -m "List Tracker"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/list-tracker.git
git push -u origin main
```

Then on GitHub: **Settings → Pages → Source → Deploy from branch → main / (root)**. Live at:
`https://YOUR-USERNAME.github.io/list-tracker/`

## One thing worth knowing (unrelated to this build)

Your Supabase project has another table, `scraped_leads`, with row-level security turned off — meaning anyone with your anon key could read or edit it. Not something this project touches, but worth locking down when you get a chance:
```sql
ALTER TABLE public.scraped_leads ENABLE ROW LEVEL SECURITY;
```
(You'd also want to add a policy afterward, or it'll block all access.)
