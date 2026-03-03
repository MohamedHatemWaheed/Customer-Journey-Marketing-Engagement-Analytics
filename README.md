# 📊 Customer Journey & Marketing Engagement Analytics

## 📌 Project Overview

This project analyzes customer journey behavior and marketing campaign engagement starting from a raw SQL Server backup file (.bak) all the way to a fully interactive Power BI dashboard and executive presentation.

The goal was to transform raw relational data into structured, business-ready insights that support:

* Funnel optimization
* Campaign performance evaluation
* Customer segmentation
* Engagement strategy improvement
* Data-driven decision making

This project demonstrates end-to-end BI workflow including database restoration, SQL engineering, data modeling, DAX calculations, and business storytelling.

---

# 🗂 1️⃣ Database Restoration & Exploration

The project began with restoring a raw `.bak` file using SQL Server Management Studio (SSMS).

### Steps Performed:

* Restored database from backup file
* Explored schema and relationships
* Identified fact and dimension tables
* Analyzed data consistency
* Defined analytical requirements

### Core Tables Identified:

* Customers
* CustomerJourney
* Engagement
* Products
* CustomerReviews
* Geography

---

# 🧠 2️⃣ SQL Data Engineering & Transformation

This was the core technical phase of the project.

Instead of directly connecting raw tables to Power BI, I built a structured transformation layer using:

* Data Cleaning Logic
* Analytical Views
* Stored Procedures
* Aggregation Logic
* Funnel Modeling Logic

---

## 🔹 Data Cleaning

Performed multiple cleaning operations including:

* Removing duplicates using `ROW_NUMBER()`
* Handling NULL values
* Standardizing Stage & Action names
* Fixing inconsistent date formats
* Ensuring relational integrity

Example (Duplicate Handling):

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

# ⚙ 3️⃣ Stored Procedures Implementation

To elevate the project from static querying to structured data pipeline design, I implemented multiple stored procedures.

This simulates real-world BI architecture where transformation logic lives inside the database layer.

---

## 🔹 A. Data Cleaning Procedure

Created procedure to automate data cleaning:

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

Purpose:

* Ensures clean dataset before analytics
* Reusable logic
* Improves maintainability

---

## 🔹 B. Engagement Aggregation Procedure

```sql
CREATE PROCEDURE sp_CalculateEngagement
AS
BEGIN
    SELECT
        CustomerID,
        SUM(Clicks) AS TotalClicks,
        SUM(Likes) AS TotalLikes,
        SUM(Views) AS TotalViews
    FROM Engagement
    GROUP BY CustomerID;
END
```

Purpose:

* Centralized aggregation logic
* Optimized reporting layer
* Reduced calculation complexity in Power BI

---

## 🔹 C. Parameterized Performance Procedure

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

Purpose:

* Dynamic reporting
* Flexible campaign analysis
* Simulates enterprise reporting APIs

---

# 🏗 4️⃣ Analytical Views Layer

After cleaning and procedural logic, I created optimized views for Power BI consumption:

* vw_customer_journey_cta
* vw_engagement_data_final
* vw_products_final
* vw_customer_reviews_final
* vw_customers_final

These views:

* Simplified model design
* Reduced BI complexity
* Improved refresh performance
* Enforced business logic consistency

---

# 📈 5️⃣ Power BI Data Modeling

### 🔹 Model Design

Implemented Star Schema:

* Fact Table: Customer Journey / Engagement
* Dimensions:

  * Customers
  * Products
  * Geography
  * Reviews

Relationships built using:

* CustomerID
* ProductID
* GeographyID

---

# 📊 6️⃣ DAX Calculations

Key measures created:

### Engagement

```DAX
Total Engagement =
SUM(vw_engagement_data_final[Clicks]) +
SUM(vw_engagement_data_final[Likes]) +
SUM(vw_engagement_data_final[Views])
```

### Funnel Metrics

* Customers per Stage
* Stage Conversion %
* Drop-off %
* Previous Stage Customers

### Performance Metrics

* Average Feedback Rating
* Campaign Ranking
* Engagement by Age Group
* Engagement by Country

---

# 📊 7️⃣ Dashboard Structure

## 🟦 Page 1 — Customer Funnel Analysis

* Funnel (Stage → Action Drill Down)
* Stage Conversion %
* Drop-off %
* Country Performance
* KPI Cards

Focus:
Identify friction points in the customer journey.

---

## 🟦 Page 2 — Conversion Deep Dive

* Stage vs Action Matrix
* Drop-off Diagnostics
* Conversion Validation
* Behavioral Insights

Focus:
Analyze stage-level conversion performance.

---

## 🟦 Page 3 — Engagement & Campaign Performance

* Campaign Ranking
* Engagement by Age Group & Content Type
* Product Engagement Treemap
* Feedback vs Engagement Scatter
* Country Engagement Map

Focus:
Marketing optimization & audience targeting.

---

# 📊 Business Insights Generated

* Significant drop-off between Product Page → Checkout
* Video content performs better among younger segments
* High-rated products are not always highest in engagement
* Certain regions show stronger campaign responsiveness

---

# 🏗 Architecture Summary

This project follows a layered BI architecture:

Raw Database (.bak)
↓
SQL Cleaning & Stored Procedures
↓
Analytical Views Layer
↓
Power BI Data Model
↓
DAX Measures
↓
Interactive Dashboard
↓
Executive Presentation

---

# 🛠 Tools Used

* SQL Server
* SSMS
* Power BI
* DAX
* GitHub
* PowerPoint

---

# 🚀 Technical Skills Demonstrated

* Advanced SQL (CTE, Window Functions)
* Stored Procedures (Standard & Parameterized)
* Aggregation Logic
* Funnel Modeling
* Conversion & Drop-off Analysis
* Star Schema Modeling
* DAX Calculations
* Business Insight Generation
* End-to-End BI Development

---

# 📎 Deliverables

* SQL Scripts
* Stored Procedures
* Analytical Views
* Power BI Dashboard (.pbix)
* Executive Presentation (.pptx)
* Project Documentation

--
