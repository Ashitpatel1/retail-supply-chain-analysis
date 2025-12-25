
-- DATA CLEANING & EDA 

-- Check for duplicate SKUs
SELECT sku_id, COUNT(*) FROM products GROUP BY sku_id HAVING COUNT(*) > 1;

-- Check for missing supplier links
SELECT * FROM products WHERE primary_supplier_id NOT IN (SELECT supplier_id FROM suppliers);

-- Missing SKU
SELECT * FROM products WHERE sku_id IS NULL;

select distinct size_label FROM products;
	
select distinct country_of_origin FROM products;

UPDATE products SET country_of_origin = 'United Kingdom' WHERE country_of_origin = 'UK';
UPDATE products SET country_of_origin = 'China'          WHERE country_of_origin = 'CN';
UPDATE products SET country_of_origin = 'Japan'          WHERE country_of_origin = 'JP';
UPDATE products SET country_of_origin = 'Australia'      WHERE country_of_origin = 'AU';
UPDATE products SET country_of_origin = 'United States'  WHERE country_of_origin = 'US';
UPDATE products SET country_of_origin = 'France'         WHERE country_of_origin = 'FR';
UPDATE products SET country_of_origin = 'Indonesia'      WHERE country_of_origin = 'ID';
UPDATE products SET country_of_origin = 'Malaysia'       WHERE country_of_origin = 'MY';
UPDATE products SET country_of_origin = 'Thailand'       WHERE country_of_origin = 'TH';
UPDATE products SET country_of_origin = 'Germany'        WHERE country_of_origin = 'DE';
UPDATE products SET country_of_origin = 'Vietnam'        WHERE country_of_origin = 'VN';
UPDATE products SET country_of_origin = 'South Korea'    WHERE country_of_origin = 'KR';


UPDATE products
SET shelf_life_months = 12
WHERE shelf_life_months IS NULL;


UPDATE products
SET parent_sku = NULL
WHERE parent_sku = '';

SELECT * FROM purchase_orders WHERE sku_id NOT IN (SELECT sku_id FROM products);
SELECT * FROM purchase_orders WHERE supplier_id NOT IN (SELECT supplier_id FROM suppliers);

SELECT * FROM purchase_orders WHERE po_date IS NULL;
SELECT * FROM purchase_orders WHERE promised_delivery_date < po_date;
SELECT * FROM purchase_orders WHERE delivery_date < po_date;


SELECT * FROM sales WHERE sale_date IS NULL OR sale_date > CURDATE();

SELECT * FROM sales
WHERE quantity <= 0 OR unit_price <= 0 OR shipping_fee < 0 OR voucher_amount < 0 OR net_revenue < 0;

-- Fix the net_revenue values 

SELECT sale_id, unit_price, quantity, discount_pct, voucher_amount, shipping_fee, net_revenue,
       ROUND((unit_price * quantity) * (1 - discount_pct / 100) + shipping_fee - voucher_amount, 2) AS expected_revenue
FROM sales
WHERE ROUND((unit_price * quantity) * (1 - discount_pct / 100) + shipping_fee - voucher_amount, 2) != net_revenue;

UPDATE sales
SET net_revenue = ROUND((unit_price * quantity) * (1 - discount_pct / 100) + shipping_fee - voucher_amount, 2)
WHERE ROUND((unit_price * quantity) * (1 - discount_pct / 100) + shipping_fee - voucher_amount, 2) != net_revenue;

ALTER TABLE sales
DROP COLUMN customer_segment_id;

SELECT DISTINCT default_shipping_mode FROM suppliers;

UPDATE sales
SET event_name = 'No Event'
WHERE event_name IS NULL OR event_name = '';
