# 📊 Customer Journey & Marketing Engagement Analytics

> **End-to-end Business Intelligence project** — from raw SQL Server backup to fully interactive Power BI dashboards and executive presentation.

---

## 📌 Project Overview

This project analyzes **customer journey behavior** and **marketing campaign engagement**, starting from a raw `.bak` SQL Server backup file all the way to a fully interactive Power BI dashboard and executive presentation.

The goal was to transform raw relational data into structured, business-ready insights that support:

| Objective | Description |
|-----------|-------------|
| 🔻 Funnel Optimization | Identify and fix drop-off points in the customer journey |
| 📣 Campaign Evaluation | Measure marketing engagement and campaign ROI |
| 👥 Customer Segmentation | Understand behavior by age, country, and product |
| 🎯 Engagement Strategy | Improve content targeting and channel effectiveness |
| 📈 Data-Driven Decisions | Deliver actionable insights to stakeholders |

This project demonstrates a **complete end-to-end BI workflow** including database restoration, SQL engineering, data modeling, DAX calculations, and business storytelling.

---

## 🗂️ Table of Contents

- [1️⃣ Database Restoration & Exploration](#1️⃣-database-restoration--exploration)
- [2️⃣ SQL Data Engineering & Transformation](#2️⃣-sql-data-engineering--transformation)
- [3️⃣ Stored Procedures Implementation](#3️⃣-stored-procedures-implementation)
- [4️⃣ Analytical Views Layer](#4️⃣-analytical-views-layer)
- [5️⃣ Power BI Data Modeling](#5️⃣-power-bi-data-modeling)
- [6️⃣ DAX Calculations](#6️⃣-dax-calculations)
- [7️⃣ Dashboard Structure](#7️⃣-dashboard-structure)
- [💡 Business Insights Generated](#-business-insights-generated)
- [🏗️ Architecture Summary](#️-architecture-summary)
- [🛠️ Tools Used](#️-tools-used)
- [🚀 Technical Skills Demonstrated](#-technical-skills-demonstrated)
- [📎 Deliverables](#-deliverables)

---

## 1️⃣ Database Restoration & Exploration

The project began with restoring a raw `.bak` file using **SQL Server Management Studio (SSMS)**.

**Steps Performed:**
- ✅ Restored database from backup file
- ✅ Explored schema and relationships
- ✅ Identified fact and dimension tables
- ✅ Analyzed data consistency
- ✅ Defined analytical requirements

**Core Tables Identified:**

| Table | Description |
|-------|-------------|
| `Customers` | Customer demographic and profile data |
| `CustomerJourney` | Stage-by-stage journey tracking |
| `Engagement` | Campaign clicks, likes, views |
| `Products` | Product catalog |
| `CustomerReviews` | Ratings and feedback |
| `Geography` | Country and region mapping |

---

## 2️⃣ SQL Data Engineering & Transformation

This was the **core technical phase** of the project.

Instead of directly connecting raw tables to Power BI, a structured transformation layer was built using:

- 🧹 **Data Cleaning Logic**
- 📐 **Analytical Views**
- ⚙️ **Stored Procedures**
- 📊 **Aggregation Logic**
- 🔻 **Funnel Modeling Logic**

### 🔹 Data Cleaning

Performed multiple cleaning operations including:

- Removing duplicates using `ROW_NUMBER()`
- Handling NULL values
- Standardizing Stage & Action names
- Fixing inconsistent date formats
- Ensuring relational integrity

**Example — Duplicate Handling:**
```sql
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY CustomerID, Stage, Action
               ORDER BY JourneyDate DESC
           ) AS rn
    FROM CustomerJourney
)
DELETE FROM CTE WHERE rn > 1;
```

---

## 3️⃣ Stored Procedures Implementation

To elevate the project from static querying to **structured data pipeline design**, multiple stored procedures were implemented — simulating real-world BI architecture where transformation logic lives inside the database layer.

### 🔹 A. Data Cleaning Procedure
```sql
CREATE PROCEDURE sp_CleanCustomerJourney
AS
BEGIN
    WITH CTE AS (
        SELECT *,
               ROW_NUMBER() OVER (
                   PARTITION BY CustomerID, Stage, Action
                   ORDER BY JourneyDate DESC
               ) AS rn
        FROM CustomerJourney
    )
    DELETE FROM CTE WHERE rn > 1;

    UPDATE CustomerJourney
    SET Stage = TRIM(Stage);
END
```

> **Purpose:** Ensures a clean dataset before analytics — reusable and maintainable.

---

### 🔹 B. Engagement Aggregation Procedure
```sql
CREATE PROCEDURE sp_CalculateEngagement
AS
BEGIN
    SELECT
        CustomerID,
        SUM(Clicks)  AS TotalClicks,
        SUM(Likes)   AS TotalLikes,
        SUM(Views)   AS TotalViews
    FROM Engagement
    GROUP BY CustomerID;
END
```

> **Purpose:** Centralized aggregation logic — reduces calculation complexity in Power BI.

---

### 🔹 C. Parameterized Performance Procedure
```sql
CREATE PROCEDURE sp_GetCampaignPerformance
    @CampaignID INT
AS
BEGIN
    SELECT *
    FROM Engagement
    WHERE CampaignID = @CampaignID;
END
```

> **Purpose:** Dynamic reporting — simulates enterprise-grade reporting APIs.

---

## 4️⃣ Analytical Views Layer

After cleaning and procedural logic, optimized views were created for Power BI consumption:

| View | Purpose |
|------|---------|
| `vw_customer_journey_cta` | Journey stage and CTA tracking |
| `vw_engagement_data_final` | Cleaned engagement metrics |
| `vw_products_final` | Product dimension |
| `vw_customer_reviews_final` | Cleaned reviews and ratings |
| `vw_customers_final` | Customer dimension |

These views:
- Simplified model design
- Reduced BI complexity
- Improved refresh performance
- Enforced business logic consistency

---

## 5️⃣ Power BI Data Modeling

### 🔹 Star Schema Design
```
         ┌─────────────┐
         │  Customers  │
         └──────┬──────┘
                │
┌───────────┐   │   ┌────────────┐
│ Geography ├───┼───┤  Products  │
└───────────┘   │   └────────────┘
                │
       ┌────────┴────────────────┐
       │  FACT: CustomerJourney  │
       │  FACT: Engagement       │
       └─────────────────────────┘
                │
         ┌──────┴──────┐
         │   Reviews   │
         └─────────────┘
```

**Relationships built using:** `CustomerID` · `ProductID` · `GeographyID`

---

## 6️⃣ DAX Calculations

### Engagement
```dax
Total Engagement =
SUM(vw_engagement_data_final[Clicks]) +
SUM(vw_engagement_data_final[Likes]) +
SUM(vw_engagement_data_final[Views])
```

### Funnel Metrics

| Measure | Description |
|---------|-------------|
| `Customers per Stage` | Count of customers at each journey stage |
| `Stage Conversion %` | % who moved to the next stage |
| `Drop-off %` | % who exited at each stage |
| `Previous Stage Customers` | Used for conversion rate calculation |

### Performance Metrics

| Measure | Description |
|---------|-------------|
| `Average Feedback Rating` | Mean customer satisfaction score |
| `Campaign Ranking` | Rank campaigns by engagement |
| `Engagement by Age Group` | Segmented engagement analysis |
| `Engagement by Country` | Geographic engagement breakdown |

---

## 7️⃣ Dashboard Structure

The Power BI report is structured across **4 interactive dashboards**, each targeting a specific business domain — from high-level executive visibility to deep-dive funnel, satisfaction, and marketing analysis.

---

### 🟦 Page 1 — Executive Overview Dashboard

**Purpose:** Provides C-level stakeholders with a consolidated snapshot of business performance across conversion, engagement, satisfaction, and revenue — all in one view.

**Key Insights:**
- 📌 **11.58% Conversion Rate** and **24.06% Engagement Rate** surfaced instantly via KPI cards
- 💰 **Average Order Value (AOV) of $207.9** reflects healthy revenue per transaction
- 📉 Conversion Rate dipped mid-2023 before recovering — signaling a seasonal or campaign-driven pattern
- 🌍 **Spain and Germany** lead customer distribution by country
- 📊 **CX Engagement by Campaign** matrix highlights which of the 20 campaigns drove the most clicks and likes
- ⭐ **Customer Satisfaction gauge at 3.69/5.00** — indicating clear room for experience improvement

**Dashboard Preview:**

![Executive Overview Dashboard](Dashboard/Executive%20dashboard.png)

---

### 🟦 Page 2 — Analyzing Customer Behavior Across the Journey

**Purpose:** Maps the full customer journey across stages (Home Page → Product Page → Checkout) to expose where customers are lost and what actions they take at each step.

**Key Insights:**
- 👥 Out of **3,932 total visitors**, only **198 became buyers** — a critical conversion optimization opportunity
- ⚠️ **Checkout is the weakest stage**, confirmed by both the KPI card and funnel drop-off visualization
- 📉 The funnel drops sharply: Home Page (1.74K) → Product Page (1.42K) → Checkout (0.77K)
- ⏱️ **Average session duration of 132.98 seconds** suggests moderate engagement that isn't converting
- 🔍 **Customer Actions by Stage** reveals the mix of Clicks, Drop-offs, Purchases, and Views per stage
- 🗺️ Country and date filters enable regional and time-period drill-downs for localized analysis

**Dashboard Preview:**

![Customer Journey Dashboard](Analyzing_Customer_Behavior_Across_the_Journey_Dashboard.png)

---

### 🟦 Page 3 — Customer Feedback & Satisfaction Dashboard

**Purpose:** Tracks customer sentiment, product ratings, and satisfaction trends over time to help product and CX teams prioritize improvements.

**Key Insights:**
- ⭐ **Overall rating of 3.67/5** across **446 total reviews** — solid but with measurable improvement potential
- 📊 Most reviews cluster in the **3–4 and 4–5 rating buckets**, indicating general satisfaction with occasional outliers
- 📈 **Satisfaction peaked in April 2024 (~3.78)** before declining to ~3.62 by late 2024 — warrants investigation
- 🏆 **Football Helmet** is the top-rated product (4.13), while **Basketball** lags slightly at 3.84
- 🔘 An interactive **Top N / Bottom N toggle** lets teams instantly spotlight best or worst performers
- 🗺️ Country and date filters enable market-specific satisfaction tracking

**Dashboard Preview:**

![Customer Feedback & Satisfaction Dashboard](Customer_Feedback___Satisfaction_Dashboard.png)

---

### 🟦 Page 4 — Marketing Engagement & Campaign Effectiveness Dashboard

**Purpose:** Delivers a comprehensive view of campaign performance, content effectiveness, and engagement trends to guide marketing strategy and budget allocation.

**Key Insights:**
- 🖱️ **19.57% CTR** and **24.06% Engagement Rate** across **20 active campaigns** demonstrate strong marketing reach
- 📊 **2.3M Total Clicks**, **11.76M Total Views**, and **528K Total Likes** reflect large-scale audience interaction
- 📉 **Engagement Growth Trend** shows gradual decline from 2023 to 2025 — a signal to revisit content strategy
- 📱 Engagement Rate is nearly equal across **Video (24.55%)**, **Social Media (24.21%)**, **Blog (23.94%)**, and **Newsletter (23.52%)**
- 🎯 **CTR by Campaign** clusters around 19–21%, with outliers offering benchmarking opportunities
- 📋 **Campaign Performance Matrix** breaks down clicks and engagement per campaign per content type for granular ROI analysis

**Dashboard Preview:**

![Marketing Engagement & Campaign Effectiveness Dashboard](Marketing_Engagement___Campaign_Effectiveness_Dashboard.png)

---

## 💡 Business Insights Generated

- 🔻 **Significant drop-off between Product Page → Checkout** — the most critical UX friction point
- 🎬 **Video content performs better among younger segments** — prioritize for targeted campaigns
- ⭐ **High-rated products are not always highest in engagement** — satisfaction ≠ visibility
- 🌍 **Certain regions show stronger campaign responsiveness** — geo-targeted strategy recommended
- 📉 **Customer satisfaction declined in H2 2024** — needs root cause analysis across products and regions

---

## 🏗️ Architecture Summary
```
Raw Database (.bak)
        ↓
SQL Cleaning & Stored Procedures
        ↓
Analytical Views Layer
        ↓
Power BI Data Model (Star Schema)
        ↓
DAX Measures & Calculations
        ↓
4 Interactive Dashboards
        ↓
Executive Presentation (.pptx)
```

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| ![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=flat&logo=microsoft-sql-server&logoColor=white) | Database engine & restoration |
| ![SSMS](https://img.shields.io/badge/SSMS-CC2927?style=flat&logo=microsoft&logoColor=white) | Database management & SQL development |
| ![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=flat&logo=powerbi&logoColor=black) | Data modeling, DAX & dashboards |
| ![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white) | Version control & documentation |
| ![PowerPoint](https://img.shields.io/badge/PowerPoint-B7472A?style=flat&logo=microsoft-powerpoint&logoColor=white) | Executive presentation |

---

## 🚀 Technical Skills Demonstrated

- ⚙️ Advanced SQL — CTEs, Window Functions, Joins
- 🔁 Stored Procedures — Standard & Parameterized
- 🧹 Data Cleaning & Normalization
- 🔻 Funnel Modeling & Drop-off Analysis
- 📐 Star Schema Data Modeling
- 📊 DAX Calculations — Conversion, Engagement, Rankings
- 💡 Business Insight Generation
- 🖥️ End-to-End BI Development

---

## 📎 Deliverables

| Deliverable | Description |
|-------------|-------------|
| 📄 SQL Scripts | All cleaning, transformation, and view creation queries |
| ⚙️ Stored Procedures | Reusable pipeline procedures |
| 👁️ Analytical Views | Optimized views for Power BI consumption |
| 📊 Power BI Dashboard | `.pbix` file with 4 interactive pages |
| 📑 Executive Presentation | `.pptx` business storytelling deck |
| 📝 Project Documentation | This README |

---

## 🎬 Dashboard Walkthrough Video

> Watch the full interactive dashboard walkthrough — covering all 4 pages, key slicers, filters, and business insights:

[![Watch Dashboard Demo](https://img.shields.io/badge/▶%20Watch%20Demo-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](YOUR_VIDEO_LINK_HERE)

---

<div align="center">

**Built with 💙 using SQL Server · Power BI · DAX**

</div>
