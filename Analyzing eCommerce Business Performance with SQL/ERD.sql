-- This script was generated by a beta version of the ERD tool in pgAdmin 4.
-- Please log an issue at https://redmine.postgresql.org/projects/pgadmin4/issues/new if you find any bugs, including reproduction steps.
BEGIN;


CREATE TABLE IF NOT EXISTS public.customers
(
    customer_id character varying COLLATE pg_catalog."default" NOT NULL,
    customer_unique_id character varying COLLATE pg_catalog."default" NOT NULL,
    zip_code_prefix bigint,
    customer_city character varying COLLATE pg_catalog."default",
    customer_state character varying COLLATE pg_catalog."default",
    CONSTRAINT customers_pkey PRIMARY KEY (customer_id)
);

CREATE TABLE IF NOT EXISTS public.geolocation
(
    zip_code_prefix bigint,
    geolocation_lat numeric,
    geolocation_lng numeric,
    geolocation_city character varying COLLATE pg_catalog."default",
    geolocation_state character varying COLLATE pg_catalog."default"
);

CREATE TABLE IF NOT EXISTS public.sellers
(
    seller_id character varying COLLATE pg_catalog."default" NOT NULL,
    zip_code_prefix bigint,
    seller_city character varying COLLATE pg_catalog."default",
    seller_state character varying COLLATE pg_catalog."default",
    CONSTRAINT sellers_pkey PRIMARY KEY (seller_id)
);

CREATE TABLE IF NOT EXISTS public.orders
(
    order_id character varying COLLATE pg_catalog."default" NOT NULL,
    customer_id character varying COLLATE pg_catalog."default",
    order_status character varying COLLATE pg_catalog."default",
    order_purchase_timestamp date,
    order_approved_at date,
    order_delivered_carrier_date date,
    order_delivered_customer_date date,
    order_estimated_delivery_date date,
    PRIMARY KEY (order_id)
);

CREATE TABLE IF NOT EXISTS public.order_reviews
(
    review_id character varying COLLATE pg_catalog."default" NOT NULL,
    order_id character varying COLLATE pg_catalog."default",
    review_score smallint,
    review_comment_title character varying COLLATE pg_catalog."default",
    review_comment_message character varying COLLATE pg_catalog."default",
    review_creation_date date,
    review_answer_timestamp date,
    PRIMARY KEY (review_id)
);

CREATE TABLE IF NOT EXISTS public.order_payments
(
    order_id character varying COLLATE pg_catalog."default",
    payment_sequential smallint,
    payment_type character varying COLLATE pg_catalog."default",
    payment_installments smallint,
    payment_value numeric
);

CREATE TABLE IF NOT EXISTS public.order_items
(
    order_id character varying COLLATE pg_catalog."default",
    order_item_id smallint,
    product_id character varying COLLATE pg_catalog."default",
    seller_id character varying COLLATE pg_catalog."default",
    shipping_limit_date date,
    price numeric,
    freight_value numeric
);

CREATE TABLE IF NOT EXISTS public.product
(
    product_id character varying COLLATE pg_catalog."default",
    product_id_name character varying COLLATE pg_catalog."default",
    product_name_lenght smallint,
    product_description_lenght bigint,
    product_photos_qty smallint,
    product_weight_g bigint,
    product_length_cm smallint,
    product_height_cm smallint,
    product_width_cm smallint,
    PRIMARY KEY (product_id)
);

ALTER TABLE IF EXISTS public.customers
    ADD CONSTRAINT zip_code_prefix FOREIGN KEY (zip_code_prefix)
    REFERENCES public.geolocation (zip_code_prefix) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.sellers
    ADD CONSTRAINT zip_code_prefix FOREIGN KEY (zip_code_prefix)
    REFERENCES public.geolocation (zip_code_prefix) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.orders
    ADD CONSTRAINT customer_id FOREIGN KEY (customer_id)
    REFERENCES public.customers (customer_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.order_reviews
    ADD CONSTRAINT order_id FOREIGN KEY (order_id)
    REFERENCES public.orders (order_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.order_payments
    ADD CONSTRAINT order_id FOREIGN KEY (order_id)
    REFERENCES public.orders (order_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.order_items
    ADD CONSTRAINT order_id FOREIGN KEY (order_id)
    REFERENCES public.orders (order_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.order_items
    ADD CONSTRAINT seller_id FOREIGN KEY (seller_id)
    REFERENCES public.sellers (seller_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.order_items
    ADD CONSTRAINT product_id FOREIGN KEY (product_id)
    REFERENCES public.product (product_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.product
    ADD CONSTRAINT product_id FOREIGN KEY (product_id)
    REFERENCES public.order_items (product_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;