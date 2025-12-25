



--    PROJECT CODE 


-- What is the total revenue across all sales?

SELECT 
    SUM(net_revenue) as Total_revenue 
FROM 
    sales;
    
--  How many orders were placed overall?

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM sales;

--  What is the average order value?

select round(avg(net_revenue),2) as AVG_order_velue 
from sales;

-- How many orders came from each channel ?

select channel,count(order_id) as Total_orders
from sales
group by channel
order by Total_orders desc;

-- What is the distribution of device types (mobile_app, desktop)?

select device_type,count(order_id) as Total_orders
from sales
group by device_type
order by Total_orders desc;

-- What is the average discount percentage applied across all sales?

select round(avg(discount_pct),2) from sales;

-- What is the average rating per product category?

SELECT 
    category,round(AVG(avg_rating),2) AS average_category_rating
FROM products
GROUP BY category
ORDER BY average_category_rating DESC;


-- Which customer segment generates the most revenue?

select customer_segment , sum(net_revenue) as Total_revenue
from sales
group by customer_segment
order by Total_revenue desc limit 1;

-- What is the average revenue per customer segment?

SELECT customer_segment,
    round(AVG(net_revenue),2)AS average_revenue_per_segment
FROM sales
GROUP BY customer_segment
ORDER BY average_revenue_per_segment DESC;

-- Which payment method is most popular among customers?

select payment_method, count(order_id) as Pay_by_count
from sales
group by payment_method
order by Pay_by_count desc;

-- Which event generated the highest revenue?


select event_name, sum(net_revenue) as Total_revenue
from sales 
where event_name  not in ('No Event')
group by event_name
order by Total_revenue desc;

-- Which suppliers have the shortest vs longest lead times?

select supplier_name, avg(datediff(delivery_date,po_date)) as avg_lead_time
from suppliers  s join purchase_orders  p
on s.supplier_id=p.supplier_id
where p.delivery_date is not null and p.po_date is not null
group by s.supplier_name
order by avg_lead_time desc;

-- How many suppliers use each default shipping mode ;

SELECT default_shipping_mode,
COUNT(supplier_id) AS supplier_count
FROM suppliers
GROUP BY default_shipping_mode
ORDER BY supplier_count DESC;

-- Which suppliers contribute the highest total procurement cost (unit_cost × order_qty)?

select supplier_name,sum(order_qty*unit_cost) as Total_procurement 
from purchase_orders p join suppliers s
on p.supplier_id=s.supplier_id
group by supplier_name
order by total_procurement desc;

-- List of the countries with their order ;

select country_of_origin, count(order_id ) As Orders
from products p join sales s
on p.sku_id=s.sku_id
group by country_of_origin
order by country_of_origin desc;

-- Revenue from all categories along with percentage 

select category,sum(net_revenue) As Total_revenue,
concat(round(sum(net_revenue)*100/(select sum(net_revenue) from sales),2),'%') as Percentage_revenue
from products p join sales s
on p.sku_id=s.sku_id
group by category
order by total_revenue desc;


------------------------------------
-- Find the top 10 products by lifetime revenue.

SELECT product_name,category,
    SUM(net_revenue) AS lifetime_revenue
FROM products p
JOIN sales s 
    ON p.sku_id = s.sku_id
GROUP BY p.product_name, p.category
ORDER BY lifetime_revenue DESC
LIMIT 10;

-- Rank products by revenue within each category.


SELECT category,product_name,
SUM(net_revenue) AS total_revenue,
RANK() OVER (PARTITION BY p.category ORDER BY SUM(net_revenue) DESC) AS revenue_rank
FROM products p
JOIN sales s 
    ON p.sku_id = s.sku_id
GROUP BY p.category, p.product_name
ORDER BY p.category, revenue_rank ;

-- Rank customers by total spending across all channels.

SELECT 
channel, SUM(s.net_revenue) AS total_spending,
RANK() OVER (ORDER BY SUM(s.net_revenue) DESC) AS spending_rank
FROM sales s
GROUP BY channel
ORDER BY spending_rank;


-- Find products with ratings above their category average.

SELECT product_name,category,avg_rating
FROM products p
WHERE p.avg_rating > (
    SELECT AVG(avg_rating)
    FROM products p2
    WHERE p2.category = p.category
);


