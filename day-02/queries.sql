-- =========================================================
-- Epochs Day 2: Northwind SQL Analysis
-- Database: northwind.db (SQLite)
-- =========================================================

-- ---------------------------------------------------------
-- 1. Top 10 selling products (by total revenue)
-- ---------------------------------------------------------
SELECT
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity) AS total_units_sold,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS total_revenue
FROM "Order Details" od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY total_revenue DESC
LIMIT 10;


-- ---------------------------------------------------------
-- 2. Top 10 customers by revenue
-- ---------------------------------------------------------
SELECT
    c.CustomerID,
    c.CompanyName,
    COUNT(DISTINCT o.OrderID) AS num_orders,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS total_revenue
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN "Order Details" od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY total_revenue DESC
LIMIT 10;


-- ---------------------------------------------------------
-- 3. Monthly sales trend (revenue per calendar month)
-- ---------------------------------------------------------
SELECT
    strftime('%Y-%m', o.OrderDate) AS year_month,
    COUNT(DISTINCT o.OrderID) AS num_orders,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS total_revenue
FROM Orders o
JOIN "Order Details" od ON o.OrderID = od.OrderID
GROUP BY year_month
ORDER BY year_month;


-- ---------------------------------------------------------
-- 4. Best-performing product categories (by revenue)
-- ---------------------------------------------------------
SELECT
    cat.CategoryID,
    cat.CategoryName,
    COUNT(DISTINCT od.OrderID) AS num_orders,
    SUM(od.Quantity) AS total_units_sold,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS total_revenue
FROM "Order Details" od
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories cat ON p.CategoryID = cat.CategoryID
GROUP BY cat.CategoryID, cat.CategoryName
ORDER BY total_revenue DESC;


-- ---------------------------------------------------------
-- 5. Customer purchase frequency
--    (number of orders placed per customer, and how many
--     customers fall into each frequency bucket)
-- ---------------------------------------------------------

-- 5a. Raw order count per customer
SELECT
    c.CustomerID,
    c.CompanyName,
    COUNT(o.OrderID) AS num_orders
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY num_orders DESC;

-- 5b. Distribution of customers by order-count bucket
SELECT
    CASE
        WHEN num_orders = 0 THEN '0 orders'
        WHEN num_orders BETWEEN 1 AND 50 THEN '1-50 orders'
        WHEN num_orders BETWEEN 51 AND 150 THEN '51-150 orders'
        WHEN num_orders BETWEEN 151 AND 300 THEN '151-300 orders'
        ELSE '300+ orders'
    END AS order_frequency_bucket,
    COUNT(*) AS num_customers
FROM (
    SELECT c.CustomerID, COUNT(o.OrderID) AS num_orders
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID
)
GROUP BY order_frequency_bucket
ORDER BY num_customers DESC;
