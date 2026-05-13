# 🍕 Pizza Sales Analytics Dashboard

> An interactive **Power BI** dashboard for analysing pizza sales KPIs, order trends, category performance, and best/worst selling products — powered by a SQL-based transactional dataset.

---

## 📊 Dashboard Preview

| Page 1 — Home | Page 2 — Best / Worst Sellers |
|---|---|
| KPI Cards · Trend Charts · Category & Size Breakdown | Top 5 & Bottom 5 by Revenue · Quantity · Orders |

---

## 🗂️ Repository Structure

```
📦 pizza-sales-dashboard/
├── 📄 Pizza_Sales_Report.pbix       # Power BI dashboard file
├── 📄 Pizza_analysis.sql            # All SQL queries used for analysis
├── 📄 Pizza_Sales_Dashboard_BRD.docx # Business Requirements Document
└── 📄 README.md                     # Project documentation (this file)
```

---

## 🎯 Project Objectives

- Consolidate pizza sales transactional data into a single, interactive dashboard
- Track **5 core KPIs** in real time across revenue, orders, and quantity metrics
- Identify **daily and monthly sales trends** for staffing and inventory planning
- Segment performance by **pizza category** and **pizza size**
- Rank **Top 5 and Bottom 5** pizza products by revenue, quantity, and order count
- Support **date-range filtering** via interactive slicers

---

## 📐 Dashboard Pages

### Page 1 — Home

| Visual | Type | Description |
|--------|------|-------------|
| KPI Cards | Card Visual | Total Revenue, Avg Order Value, Total Pizzas Sold, Total Orders, Avg Pizzas/Order |
| Daily Trend | Column Chart | Total orders by day of week (Mon–Sun) |
| Monthly Trend | Area Chart | Total orders by month (Jan–Dec) |
| Revenue by Category | Donut Chart | % revenue split — Classic, Supreme, Veggie, Chicken |
| Revenue by Size | Donut Chart | % revenue split — S, M, L, XL, XXL |
| Units by Category | Funnel Chart | Total pizzas sold per category |
| Slicers | Filters | Month Name · Order Date range |

### Page 2 — Best / Worst Sellers

| Visual | Metric | Sort |
|--------|--------|------|
| Top 5 Pizzas by Revenue | Total Price | DESC |
| Bottom 5 Pizzas by Revenue | Total Price | ASC |
| Top 5 Pizzas by Quantity | Units Sold | DESC |
| Bottom 5 Pizzas by Quantity | Units Sold | ASC |
| Top 5 Pizzas by Total Orders | Distinct Orders | DESC |
| Bottom 5 Pizzas by Total Orders | Distinct Orders | ASC |

> **Slicers:** Pizza Category · Order Date range

---

## 🗄️ Data Source

All visuals are powered by a single SQL table: **`pizza_sales`**

| Column | Type | Description |
|--------|------|-------------|
| `order_id` | INT | Unique order identifier |
| `order_date` | DATE | Date the order was placed |
| `pizza_name` | VARCHAR | Pizza product name / SKU |
| `pizza_category` | VARCHAR | Classic · Supreme · Veggie · Chicken |
| `pizza_size` | VARCHAR | S · M · L · XL · XXL |
| `quantity` | INT | Units ordered per line |
| `total_price` | DECIMAL | Revenue for the order line |

---

## 🔍 SQL Query Reference

All queries are in [`Pizza_analysis.sql`](./Pizza_analysis.sql). Here's a summary:

### KPI Metrics

```sql
-- Total Revenue
SELECT SUM(total_price) AS Total_Revenue FROM pizza_sales;

-- Average Order Value
SELECT (SUM(total_price) / COUNT(DISTINCT order_id)) AS Avg_order_Value FROM pizza_sales;

-- Total Pizzas Sold
SELECT SUM(quantity) AS Total_pizza_sold FROM pizza_sales;

-- Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM pizza_sales;

-- Avg Pizzas Per Order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) /
       CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2)) AS Avg_Pizzas_per_order
FROM pizza_sales;
```

### Trend Analysis

```sql
-- Orders by Day of Week
SELECT DATENAME(DW, order_date) AS order_day,
       COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY DATENAME(DW, order_date);

-- Orders by Month
SELECT DATENAME(MONTH, order_date) AS Month_Name,
       COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATENAME(MONTH, order_date);
```

### Category & Size Breakdown

```sql
-- Revenue % by Category
SELECT pizza_category,
       CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
       CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category;

-- Revenue % by Size
SELECT pizza_size,
       CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
       CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size;
```

### Best / Worst Sellers

```sql
-- Top 5 by Revenue
SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales GROUP BY pizza_name ORDER BY Total_Revenue DESC LIMIT 5;

-- Bottom 5 by Revenue
SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales GROUP BY pizza_name ORDER BY Total_Revenue ASC LIMIT 5;

-- Top 5 by Quantity
SELECT pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales GROUP BY pizza_name ORDER BY Total_Pizza_Sold DESC LIMIT 5;

-- Top 5 by Orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales GROUP BY pizza_name ORDER BY Total_Orders DESC LIMIT 5;
```

> 📄 See the full file for all 12 queries including Bottom 5 variants.

---

## ⚙️ How to Use

### Prerequisites
- [Power BI Desktop](https://powerbi.microsoft.com/desktop/) (November 2023 or later)
- A SQL Server (or compatible) instance with the `pizza_sales` table loaded

### Steps

1. **Clone this repository**
   ```bash
   git clone https://github.com/your-username/pizza-sales-dashboard.git
   cd pizza-sales-dashboard
   ```

2. **Load the data**  
   Import your `pizza_sales` dataset into SQL Server, or connect directly to your existing database.

3. **Open the report**  
   Open `Pizza_Sales_Report.pbix` in Power BI Desktop.

4. **Update the data source**  
   Go to `Home → Transform Data → Data Source Settings` and point the connection to your database.

5. **Refresh the data**  
   Click `Refresh` to load the latest data into the visuals.

6. **Explore the dashboard**  
   Use the slicers (Month, Date, Category) to filter and explore the data across both pages.

---

## 📋 KPIs at a Glance

| KPI | SQL Measure | Visual |
|-----|-------------|--------|
| 💰 Total Revenue | `SUM(total_price)` | Card |
| 🧾 Avg Order Value | `SUM / COUNT(DISTINCT order_id)` | Card |
| 🍕 Total Pizzas Sold | `SUM(quantity)` | Card |
| 📦 Total Orders | `COUNT(DISTINCT order_id)` | Card |
| 📊 Avg Pizzas/Order | Decimal cast formula | Card |

---

## 📁 Documents

| File | Description |
|------|-------------|
| [`Pizza_Sales_Report.pbix`](./Pizza_Sales_Report.pbix) | Power BI dashboard (open in Power BI Desktop) |
| [`Pizza_analysis.sql`](./Pizza_analysis.sql) | All SQL queries for KPIs and charts |
| [`Pizza_Sales_Dashboard_BRD.docx`](./Pizza_Sales_Dashboard_BRD.docx) | Full Business Requirements Document |

---

## 🛠️ Tech Stack

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)

---

## 📌 Notes

- The `DATENAME` function is **MS SQL Server** syntax. For MySQL, use `DAYNAME()` and `MONTHNAME()`.
- `LIMIT 5` syntax applies to MySQL/PostgreSQL. For MS SQL Server, use `TOP 5` instead.
- All percentage calculations use a correlated subquery to derive total revenue dynamically.

---

## Result Screenshots
<img width="1325" height="727" alt="image" src="https://github.com/user-attachments/assets/f2e66bf9-dc5d-464f-bf96-16a32784ffb6" />

<img width="1336" height="728" alt="image" src="https://github.com/user-attachments/assets/44ff85a2-fb48-45e6-a81d-9d4520ffe74f" />


## 📄 License

This project is for educational and analytical purposes.

---

*Built with ❤️ using Power BI & SQL*
