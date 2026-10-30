-- =========================================
-- TASK 2: E-COMMERCE DATA ANALYSIS
-- =========================================

-- 1. Revenue by Category

SELECT
    c.category_name,
    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount_amount),
        2
    ) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY revenue DESC;


-- 2. Monthly Revenue and Orders

SELECT
    DATE_TRUNC('month', o.ordered_at) AS sales_month,
    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount_amount),
        2
    ) AS monthly_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_TRUNC('month', o.ordered_at)
ORDER BY sales_month;

-- 3. Category-wise Profit

SELECT
    c.category_name,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount_amount), 2) AS revenue,
    ROUND(SUM(oi.quantity * p.unit_cost), 2) AS total_cost,
    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount_amount)
        - SUM(oi.quantity * p.unit_cost),
        2
    ) AS profit
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY profit DESC;

-- 4. Calculate Profit Margin

SELECT
    c.category_name,
    ROUND(SUM(oi.quantity * oi.unit_price - oi.discount_amount), 2) AS revenue,
    ROUND(SUM(oi.quantity * p.unit_cost), 2) AS total_cost,
    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount_amount)
        - SUM(oi.quantity * p.unit_cost),
        2
    ) AS profit,
    ROUND(
        100.0 * (
            SUM(oi.quantity * oi.unit_price - oi.discount_amount)
            - SUM(oi.quantity * p.unit_cost)
        ) / NULLIF(
            SUM(oi.quantity * oi.unit_price - oi.discount_amount),
            0
        ),
        2
    ) AS profit_margin_pct
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY profit_margin_pct DESC;

-- 5.Monthly Revenue Analysis
SELECT
    DATE_TRUNC('month', o.ordered_at) AS sales_month,
    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount_amount),
        2
    ) AS monthly_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_item_id
GROUP BY DATE_TRUNC('month', o.ordered_at)
ORDER BY sales_month;

--6. Find Top 10 Revenue

SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold,
    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount_amount),
        2
    ) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 10;

--7.Customer Analysis - Top 10 Customers

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount_amount),
        2
    ) AS total_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC
LIMIT 10;

--8. Order Status Analysis

SELECT
    status,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;

--9. Returns Analysis

SELECT
    p.product_name,
    COUNT(DISTINCT r.order_id) AS returned_orders
FROM returns r
JOIN order_items oi
    ON r.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY returned_orders DESC
LIMIT 10;

--10. Payment Method Analysis

SELECT 
    method,
    COUNT(*) AS total_payments,
    ROUND(SUM(amount), 2) AS total_payment_value
FROM payments
GROUP BY method
ORDER
BY total_payment_value DESC
  
-- 11. SQL Analysis - Shipping Country 

SELECT
    o.shipping_country,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount_amount),
        2
    ) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.shipping_country
ORDER BY total_revenue DESC;

-- 12 .Overall Business KPIs

SELECT
    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount_amount),
        2
    ) AS total_revenue,

    COUNT(DISTINCT o.order_id) AS total_orders,

    COUNT(DISTINCT o.customer_id) AS total_customers,

    SUM(oi.quantity) AS total_units_sold,

    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount_amount)
        / NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS average_order_value

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;

--13. Overall Business KPIs run karo 

SELECT
    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount_amount),
        2
    ) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    SUM(oi.quantity) AS total_units_sold,
    ROUND(
        SUM(oi.quantity * oi.unit_price - oi.discount_amount)
        / NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;
