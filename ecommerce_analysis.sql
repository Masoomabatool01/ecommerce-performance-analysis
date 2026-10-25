-- ============================================================
-- E-Commerce Performance Analysis
-- Dataset: Brazilian E-Commerce Public Dataset by Olist
-- Tool: SQLite
-- Purpose: Business-focused SQL analysis
-- ============================================================


-- ============================================================
-- 1. TOTAL ORDERS
-- ============================================================

SELECT 
    COUNT(*) AS total_orders
FROM orders;


-- ============================================================
-- 2. ORDERS BY YEAR
-- ============================================================

SELECT
    strftime('%Y', order_purchase_timestamp) AS order_year,
    COUNT(*) AS total_orders
FROM orders
GROUP BY strftime('%Y', order_purchase_timestamp)
ORDER BY order_year;


-- ============================================================
-- 3. ORDER STATUS DISTRIBUTION
-- ============================================================

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- ============================================================
-- 4. PAYMENT METHOD ANALYSIS
-- ============================================================

SELECT
    payment_type,
    COUNT(*) AS payment_records,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM order_payment
GROUP BY payment_type
ORDER BY total_payment_value DESC;


-- ============================================================
-- 5. AVERAGE ORDER VALUE
-- ============================================================

SELECT
    ROUND(
        SUM(payment_value) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM order_payment;


-- ============================================================
-- 6. TOTAL PAYMENT VALUE
-- ============================================================

SELECT
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM order_payment;


-- ============================================================
-- 7. AVERAGE ACTUAL DELIVERY TIME
-- ============================================================

SELECT
    ROUND(
        AVG(
            julianday(order_delivered_customer_date)
            - julianday(order_purchase_timestamp)
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL;


-- ============================================================
-- 8. AVERAGE ESTIMATED DELIVERY TIME
-- ============================================================

SELECT
    ROUND(
        AVG(
            julianday(order_estimated_delivery_date)
            - julianday(order_purchase_timestamp)
        ),
        2
    ) AS average_estimated_delivery_days
FROM orders
WHERE order_estimated_delivery_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL;


-- ============================================================
-- 9. ACTUAL VS ESTIMATED DELIVERY
-- ============================================================

SELECT
    ROUND(
        AVG(
            julianday(order_delivered_customer_date)
            - julianday(order_purchase_timestamp)
        ),
        2
    ) AS average_actual_delivery_days,

    ROUND(
        AVG(
            julianday(order_estimated_delivery_date)
            - julianday(order_purchase_timestamp)
        ),
        2
    ) AS average_estimated_delivery_days
FROM orders
WHERE order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;


-- ============================================================
-- 10. AVERAGE CUSTOMER REVIEW SCORE
-- ============================================================

SELECT
    ROUND(AVG(review_score), 2) AS average_review_score
FROM order_reviews;


-- ============================================================
-- 11. REVIEW SCORE DISTRIBUTION
-- ============================================================

SELECT
    review_score,
    COUNT(*) AS review_count
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;


-- ============================================================
-- 12. POSITIVE REVIEWS
-- Review scores 4 and 5
-- ============================================================

SELECT
    COUNT(*) AS positive_reviews
FROM order_reviews
WHERE review_score >= 4;


-- ============================================================
-- 13. NEGATIVE REVIEWS
-- Review scores 1 and 2
-- ============================================================

SELECT
    COUNT(*) AS negative_reviews
FROM order_reviews
WHERE review_score <= 2;


-- ============================================================
-- 14. NEUTRAL REVIEWS
-- Review score 3
-- ============================================================

SELECT
    COUNT(*) AS neutral_reviews
FROM order_reviews
WHERE review_score = 3;


-- ============================================================
-- 15. REVIEW SENTIMENT DISTRIBUTION
-- ============================================================

SELECT
    CASE
        WHEN review_score >= 4 THEN 'Positive'
        WHEN review_score = 3 THEN 'Neutral'
        WHEN review_score <= 2 THEN 'Negative'
    END AS sentiment,
    COUNT(*) AS review_count
FROM order_reviews
GROUP BY
    CASE
        WHEN review_score >= 4 THEN 'Positive'
        WHEN review_score = 3 THEN 'Neutral'
        WHEN review_score <= 2 THEN 'Negative'
    END
ORDER BY review_count DESC;


-- ============================================================
-- 16. TOP PRODUCT CATEGORIES BY REVENUE
-- ============================================================

SELECT
    p.product_category_name AS category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- 17. TOP PRODUCT CATEGORIES BY ORDER VOLUME
-- ============================================================

SELECT
    p.product_category_name AS category,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_orders DESC
LIMIT 10;


-- ============================================================
-- 18. PRODUCT & SELLER OVERVIEW
-- ============================================================

SELECT
    COUNT(DISTINCT product_id) AS unique_products
FROM products;


SELECT
    COUNT(DISTINCT seller_id) AS unique_sellers
FROM sellers;


-- ============================================================
-- END OF ANALYSIS
-- ============================================================