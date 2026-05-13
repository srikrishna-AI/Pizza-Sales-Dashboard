/* 
Purpose:
Generate key business KPIs and sales performance metrics 
for the pizza sales dataset, including revenue analysis, 
order trends, product performance, and category insights.
*/


/* Total revenue generated from all pizza sales */
SELECT SUM(total_price) AS Total_Revenue
FROM pizza_sales;


/* Average revenue generated per order */
SELECT 
    (SUM(total_price) / COUNT(DISTINCT order_id)) AS Avg_order_Value
FROM pizza_sales;


/* Total number of pizzas sold */
SELECT SUM(quantity) AS Total_pizza_sold
FROM pizza_sales;


/* Total number of unique customer orders */
SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales;


/* 
Average number of pizzas sold per order.
Decimal conversion is used to maintain precision.
*/
SELECT 
    CAST(
        CAST(SUM(quantity) AS DECIMAL(10,2)) /
        CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2))
    AS DECIMAL(10,2)) AS Avg_Pizzas_per_order
FROM pizza_sales;


/* Analyze total orders by day of the week */
SELECT 
    DATENAME(DW, order_date) AS order_day,
    COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY DATENAME(DW, order_date);


/* Analyze total orders by month */
SELECT 
    DATENAME(MONTH, order_date) AS Month_Name,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATENAME(MONTH, order_date);


/* 
Revenue contribution percentage by pizza category.
Subquery calculates overall revenue for percentage calculation.
*/
SELECT 
    pizza_category,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
    CAST(
        SUM(total_price) * 100 /
        (SELECT SUM(total_price) FROM pizza_sales)
    AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category;


/* Revenue contribution percentage by pizza size */
SELECT 
    pizza_size,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
    CAST(
        SUM(total_price) * 100 /
        (SELECT SUM(total_price) FROM pizza_sales)
    AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size;


/* 
Identify best-selling pizza categories for February 
based on quantity sold.
*/
SELECT 
    pizza_category,
    SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
WHERE MONTH(order_date) = 2
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC;


/* Top 5 pizzas generating highest revenue */
SELECT TOP 5
    pizza_name,
    SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC;


/* Bottom 5 pizzas generating lowest revenue */
SELECT TOP 5
    pizza_name,
    SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC;


/* Top 5 pizzas sold by quantity */
SELECT TOP 5
    pizza_name,
    SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC;


/* Bottom 5 pizzas sold by quantity */
SELECT TOP 5
    pizza_name,
    SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC;


/* Top 5 pizzas based on number of orders */
SELECT TOP 5
    pizza_name,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC;


/* Bottom 5 pizzas based on number of orders */
SELECT TOP 5
    pizza_name,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders ASC;
