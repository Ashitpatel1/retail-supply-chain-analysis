create database Retail_supply_chain;

CREATE TABLE inventory_snapshot (
    sku_id VARCHAR(20) PRIMARY KEY,
    snapshot_date DATE NOT NULL,
    current_stock INT,
    incoming_stock INT,
    stock_age_days INT,
    warehouse_stock INT,
    retail_stock INT,
    amazon_allocated INT,
    tiktokshop_allocated INT,
    zalora_allocated INT,
    reorder_point INT,
    safety_stock INT,
    backorder_qty INT
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/inventory_snapshot.csv'
INTO TABLE inventory_snapshot
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    snapshot_date,
    sku_id,
    current_stock,
    incoming_stock,
    stock_age_days,
    warehouse_stock,
    retail_stock,
    amazon_allocated,
    tiktokshop_allocated,
    zalora_allocated,
    reorder_point,
    safety_stock,
    backorder_qty
);

CREATE TABLE products (
    sku_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(100),
    sub_category VARCHAR(100),
    brand VARCHAR(100),
    product_type VARCHAR(100),
    size_label VARCHAR(50),
    launch_date DATE,
    shelf_life_months INT NULL,
    parent_sku VARCHAR(20),
    default_price DECIMAL(10,2),
    primary_supplier_id varchar(10),
    is_active TEXT,
    country_of_origin VARCHAR(100),
    online_only TEXT,
    avg_rating DECIMAL(3,2),
    rating_count INT,
    is_discontinued TEXT
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads//products.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    sku_id,
    product_name,
    category,
    sub_category,
    brand,
    product_type,
    size_label,
    launch_date,
    @shelf_life_months,
    parent_sku,
    default_price,
    primary_supplier_id,
    is_active,
    country_of_origin,
    online_only,
    avg_rating,
    rating_count,
    is_discontinued
)
SET shelf_life_months = NULLIF(@shelf_life_months, '');



CREATE TABLE purchase_orders (
    po_id VARCHAR(20) PRIMARY KEY,
    sku_id VARCHAR(20) NOT NULL,
    supplier_id VARCHAR(20) NOT NULL,
    po_date DATE,
    promised_delivery_date DATE,
    delivery_date DATE,
    order_qty INT,
    unit_cost DECIMAL(10,2),
    shipping_mode VARCHAR(50),
    status VARCHAR(50),
    incoterm VARCHAR(10),
    currency VARCHAR(10),
    freight_cost DECIMAL(10,2),
    duty_cost DECIMAL(10,2),
    FOREIGN KEY (sku_id) REFERENCES products(sku_id),
	FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)

);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/purchase_orders.csv'
INTO TABLE purchase_orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    po_id,
    sku_id,
    supplier_id,
    po_date,
    promised_delivery_date,
    delivery_date,
    order_qty,
    unit_cost,
    shipping_mode,
    status,
    incoterm,
    currency,
    freight_cost,
    duty_cost
);

SET FOREIGN_KEY_CHECKS = 0;

-- Run your LOAD DATA INFILE here

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE sales (
    sale_id int PRIMARY KEY,
    order_id VARCHAR(20),
    sale_date DATE,
    sku_id VARCHAR(20),
    channel VARCHAR(50),
    quantity INT,
    unit_price DECIMAL(10,2),
    promo_flag BOOLEAN,
    discount_pct DECIMAL(5,2),
    event_name VARCHAR(100),
    customer_segment_id int,
    customer_segment VARCHAR(100),
    device_type VARCHAR(50),
    payment_method VARCHAR(50),
    shipping_fee DECIMAL(10,2),
    voucher_amount DECIMAL(10,2),
    net_revenue DECIMAL(10,2),
    returned_flag BOOLEAN,
    FOREIGN KEY (sku_id) REFERENCES products(sku_id)
);



LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    sale_id,
    order_id,
    sale_date,
    sku_id,
    channel,
    quantity,
    unit_price,
    promo_flag,
    discount_pct,
    event_name,
    customer_segment_id,
    customer_segment,
    device_type,
    payment_method,
    shipping_fee,
    voucher_amount,
    net_revenue,
    returned_flag
);

CREATE TABLE suppliers (
    supplier_id VARCHAR(20) PRIMARY KEY,
    supplier_name VARCHAR(100),
    region VARCHAR(10),
    default_shipping_mode VARCHAR(20),
    status VARCHAR(20),
    lead_time_category VARCHAR(20),
    min_order_qty INT,
    contract_start_date DATE
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/suppliers.csv'
INTO TABLE suppliers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    supplier_id,
    supplier_name,
    region,
    default_shipping_mode,
    status,
    lead_time_category,
    min_order_qty,
    contract_start_date
);
