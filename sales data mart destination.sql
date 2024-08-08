---- Destination Creation
--DB creation
USE master
go

CREATE DATABASE EO_AdventureWorksDW2014
go 

---------------

-- Dim_product
CREATE TABLE dim_product
  (
     product_key         INT NOT NULL IDENTITY(1, 1),-- surrogate key
     product_id          INT NOT NULL,--alternate key, business key
     product_name        NVARCHAR(50),
     Product_description NVARCHAR(400),
     product_subcategory NVARCHAR(50),
     product_category    NVARCHAR(50),
     color               NVARCHAR(15),
     model_name          NVARCHAR(50),
     reorder_point       SMALLINT,
     standard_cost       MONEY,
     -- Metadata
     source_system_code  TINYINT NOT NULL,
     -- SCD
     start_date          DATETIME NOT NULL DEFAULT (Getdate()),
     end_date            DATETIME,
     is_current          TINYINT NOT NULL DEFAULT (1),
     CONSTRAINT pk_dim_product PRIMARY KEY CLUSTERED (product_key)
  );

  -- Insert unknown record
SET IDENTITY_INSERT dim_product ON

INSERT INTO dim_product
            (product_key,
             product_id,
             product_name,
             Product_description,
             product_subcategory,
             product_category,
             color,
             model_name,
             reorder_point,
             standard_cost,
             source_system_code,
             start_date,
             end_date,
             is_current)
VALUES      (0,
             0,
             'Unknown',
             'Unknown',
             'Unknown',
             'Unknown',
             'Unknown',
             'Unknown',
             0,
             0,
             0,
             '1900-01-01',
             NULL,
             1)

SET IDENTITY_INSERT dim_product OFF

-- create indexes

CREATE INDEX dim_product_product_id
  ON dim_product(product_id);

CREATE INDEX dim_prodct_product_category
  ON dim_product(product_category);


---------------------------
--dim_customer

CREATE TABLE dim_customer
  (
     customer_key       INT NOT NULL IDENTITY(1, 1),
     customer_id        INT NOT NULL,
     customer_name      NVARCHAR(150),
     address1           NVARCHAR(100),
     address2           NVARCHAR(100),
     city               NVARCHAR(30),
     phone              NVARCHAR(25),
     -- birth_date date,
     -- marital_status char(10),
     -- gender char(1),
     -- yearly_income money,
     -- education varchar(50),
     source_system_code TINYINT NOT NULL,
     start_date         DATETIME NOT NULL DEFAULT (Getdate()),
     end_date           DATETIME NULL,
     is_current         TINYINT NOT NULL DEFAULT (1),
     CONSTRAINT pk_dim_customer PRIMARY KEY CLUSTERED (customer_key)
  );

  -- Insert unknown record
SET IDENTITY_INSERT dim_customer ON

INSERT INTO dim_customer
            (customer_key,
             customer_id,
             customer_name,
             address1,
             address2,
             city,
             phone,
             source_system_code,
             start_date,
             end_date,
             is_current)
VALUES      (0,
             0,
             'Unknown',
             'Unknown',
             'Unknown',
             'Unknown',
             'Unknown',
             0,
             '1900-01-01',
             NULL,
             1 )

SET IDENTITY_INSERT dim_customer OFF

-- Create Indexes

CREATE INDEX dim_customer_customer_id
  ON dim_customer(customer_id);
CREATE INDEX dim_customer_city
  ON dim_customer(city); 

--------------------------------------
--dim_territory
CREATE TABLE dim_territory
  (
     territory_key      INT NOT NULL IDENTITY(1, 1),
     territory_id       INT NOT NULL,
     territory_name     NVARCHAR(50),
     territory_country  NVARCHAR(400),
     territory_group    NVARCHAR(50),
     source_system_code TINYINT NOT NULL,
     start_date         DATETIME NOT NULL DEFAULT (Getdate()),
     end_date           DATETIME,
     is_current         TINYINT NOT NULL DEFAULT (1),
     CONSTRAINT pk_dim_territory PRIMARY KEY CLUSTERED (territory_key)
  );

  -- Insert unknown record
SET IDENTITY_INSERT dim_territory ON

INSERT INTO dim_territory
            (territory_key,
             territory_id,
             territory_name,
             territory_country,
             territory_group,
             source_system_code,
             start_date,
             end_date,
             is_current)
VALUES     (0,
            0,
            'Unknown',
            'Unknown',
            'Unknown',
            0,
            '1900-01-01',
            NULL,
            1)

SET IDENTITY_INSERT dim_territory OFF

-- create indexes
CREATE INDEX dim_territory_territory_id
  ON dim_territory(territory_id); 

-------------------------------
--dim_date
CREATE TABLE dim_date
  (
     date_key            INT NOT NULL,
     full_date           DATE NOT NULL,
     calendar_year       INT NOT NULL,
     calendar_quarter    INT NOT NULL,
     calendar_month_num  INT NOT NULL,
     calendar_month_name NVARCHAR(15) NOT NULL
     CONSTRAINT pk_dim_date PRIMARY KEY CLUSTERED (date_key)
  ); 
-------------------------------------

CREATE TABLE fact_sales
  (
     product_key    INT NOT NULL,
     customer_key   INT NOT NULL,
     territory_key  INT NOT NULL,
     order_date_key INT NOT NULL,
     sales_order_id VARCHAR(50) NOT NULL,
     line_number    INT NOT NULL,
     quantity       INT,
     unit_price     MONEY,
     unit_cost      MONEY,
     tax_amount     MONEY,
     freight        MONEY,
     extended_sales MONEY,
     extened_cost   MONEY,
     created_at     DATETIME NOT NULL DEFAULT(Getdate()),
     CONSTRAINT pk_fact_sales PRIMARY KEY CLUSTERED (sales_order_id, line_number, product_key),
     CONSTRAINT fk_fact_sales_dim_product FOREIGN KEY (product_key) REFERENCES
     dim_product(product_key),
     CONSTRAINT fk_fact_sales_dim_customer FOREIGN KEY (customer_key) REFERENCES
     dim_customer(customer_key),
     CONSTRAINT fk_fact_sales_dim_territory FOREIGN KEY (territory_key)
     REFERENCES dim_territory(territory_key),
     CONSTRAINT fk_fact_sales_dim_date FOREIGN KEY (order_date_key) REFERENCES
     dim_date(date_key)
  )

  -- Create Indexes
CREATE INDEX fact_sales_dim_product
  ON fact_sales(product_key);

CREATE INDEX fact_sales_dim_customer
  ON fact_sales(customer_key);

CREATE INDEX fact_sales_dim_territory
  ON fact_sales(territory_key);


CREATE INDEX fact_sales_dim_date
  ON fact_sales(order_date_key); 