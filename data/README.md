# Organizational Performance & KPI Insights Dashboard

An end-to-end analytics project that simulates an in-house Data Analyst (Insights) workflow:
SQL extraction → clean modeling → KPI definitions → Power BI dashboard → executive insights.

## Goal
Provide a leadership-ready dashboard to monitor organizational performance and risk:
- Operational volume and trends
- Delay / disruption impact indicators
- Hotspots by region/category
- Data quality and trust metrics

## Dataset
Source: Kaggle — “Global Supply Chain Disruption and Resilience”.
Raw dataset is referenced from Kaggle; this repo contains documentation + reproducible steps.

## Tools
- SQL (PostgreSQL recommended)
- Power BI Desktop (data model + DAX measures)
- GitHub (documentation + version control)

## Deliverables
- Power BI dashboard (Executive Overview, Drivers, Root Cause, Data Quality)
- SQL scripts: schema, KPI queries, and data quality checks
- Data dictionary + KPI definitions
- Written insights and recommendations

## Repo Structure
- `sql/` → create tables, load/clean, KPI queries, quality checks
- `powerbi/` → PBIX + screenshots
- `insights/` → executive summary and recommendations
- `data/` → download instructions + optional small sample
- `docs/` → architecture notes/diagrams

## Reproduce (high-level)
1. Download the dataset (see `data/README.md`)
2. Load into PostgreSQL and run scripts in `sql/`
3. Connect Power BI to the database, build measures, and publish visuals
4. Review insights in `insights/executive_summary.md`
