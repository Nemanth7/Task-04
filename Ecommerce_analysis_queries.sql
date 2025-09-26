-- Find the 10 most recent orders from the state of Sao Paulo
SELECT
    o.order_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    o.order_purchase_timestamp
FROM
    orders o
INNER JOIN
    customers c ON o.customer_id = c.customer_id
WHERE
    c.customer_state = 'SP'
ORDER BY
    o.order_purchase_timestamp DESC
LIMIT 10;



-- Find the top 10 cities with the most orders
SELECT
    c.customer_city,
    COUNT(o.order_id) AS order_count
FROM
    orders o
JOIN
    customers c ON o.customer_id = c.customer_id
GROUP BY
    c.customer_city
ORDER BY
    order_count DESC
LIMIT 10;


-- Calculate the average spending per unique customer
SELECT
    c.customer_unique_id,
    SUM(p.payment_value) AS total_spent,
    AVG(p.payment_value) AS average_spent_per_order
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
JOIN
    payments p ON o.order_id = p.order_id
WHERE
    o.order_status = 'delivered'
GROUP BY
    c.customer_unique_id
ORDER BY
    total_spent DESC
LIMIT 10;


-- Find orders with a payment value higher than the average payment value
SELECT
    order_id,
    payment_value
FROM
    payments
WHERE
    payment_value > (SELECT AVG(payment_value) FROM payments)
ORDER BY
    payment_value DESC
LIMIT 10;


-- Create a view to see full order details
CREATE VIEW OrderDetails AS
SELECT
    o.order_id,
    c.customer_unique_id,
    c.customer_city,
    pr.product_category_name,
    oi.price,
    p.payment_value,
    o.order_purchase_timestamp
FROM
    orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products pr ON oi.product_id = pr.product_id
JOIN payments p ON o.order_id = p.order_id;

--Now, select from the view you just created
SELECT * FROM OrderDetails 
WHERE customer_city = 'sao paulo' 
LIMIT 5;


-- Create an index to speed up searches by product category
CREATE INDEX idx_product_category ON products(product_category_name);