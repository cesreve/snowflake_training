--------------------
-- create warehouses
use role sysadmin;
create warehouse if not exists cclave_dbt_dev_wh warehouse_size=XSMALL INITIALLY_SUSPENDED=TRUE auto_suspend=60;
create warehouse if not exists cclave_dbt_prod_wh warehouse_size=XSMALL INITIALLY_SUSPENDED=TRUE auto_suspend=60;

--------------------
---- create objects
use role sysadmin;
create database if not exists cclave_dbt_dev;
create database if not exists cclave_dbt_prod;
create schema if not exists cclave_dbt_dev.landing_zone;
create schema if not exists cclave_dbt_prod.landing_zone;

--------------------
---- create roles:
use role useradmin;
create role cclave_dbt_dev_service_account_role;
create role cclave_dbt_prod_service_account_role;

use role sysadmin;
grant role cclave_dbt_dev_service_account_role to role sysadmin;
grant role cclave_dbt_prod_service_account_role to role sysadmin;
--------------------
---- create users:
use role useradmin;
create user cclave_dbt_dev_service_account_user
    password = 'xxxxx'
    Comment= 'Service account for dbt in the development (DEV) environment of the CCLAVE project.'
    default_warehouse = cclave_dbt_dev_WH
    default_role= cclave_dbt_dev_service_account_role
    must_change_password=FALSE;
    
create user cclave_dbt_prod_service_account_user
    password = 'xxxxx'
    Comment= 'Service account for dbt in the production (PROD) environment of the CCLAVE project.'
    default_warehouse = cclave_dbt_prod_WH
    default_role= cclave_dbt_prod_service_account_role
    must_change_password=FALSE;

--------------------
---- Set permissions
USE ROLE securityadmin;

-- for cclave_dbt_dev_service_account_role
grant usage on warehouse cclave_dbt_dev_WH to role cclave_dbt_dev_service_account_role;
GRANT USAGE ON DATABASE cclave_dbt_dev TO ROLE cclave_dbt_dev_service_account_role;
GRANT USAGE ON SCHEMA cclave_dbt_dev.landing_zone TO ROLE cclave_dbt_dev_service_account_role;
GRANT SELECT ON ALL TABLES IN SCHEMA cclave_dbt_dev.landing_zone TO ROLE cclave_dbt_dev_service_account_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA cclave_dbt_dev.landing_zone TO ROLE cclave_dbt_dev_service_account_role;
GRANT CREATE SCHEMA ON DATABASE cclave_dbt_dev TO ROLE cclave_dbt_dev_service_account_role;

-- for cclave_dbt_prod_service_account_role
grant usage on warehouse cclave_dbt_prod_WH to role cclave_dbt_prod_service_account_role;
GRANT USAGE ON DATABASE cclave_dbt_prod TO ROLE cclave_dbt_prod_service_account_role;
GRANT USAGE ON SCHEMA cclave_dbt_prod.landing_zone TO ROLE cclave_dbt_prod_service_account_role;
GRANT SELECT ON ALL TABLES IN SCHEMA cclave_dbt_prod.landing_zone TO ROLE cclave_dbt_prod_service_account_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA cclave_dbt_prod.landing_zone TO ROLE cclave_dbt_prod_service_account_role;
GRANT CREATE SCHEMA ON DATABASE cclave_dbt_prod TO ROLE cclave_dbt_prod_service_account_role;

--------------------
---- add roles to users
use role useradmin;
grant role cclave_dbt_dev_service_account_role to user cclave_dbt_dev_service_account_user;
grant role cclave_dbt_prod_service_account_role to user cclave_dbt_prod_service_account_user;

--------------------
---- add data to the DEV landing zone
use role sysadmin;
create table if not exists cclave_dbt_dev.landing_zone.customer as (
    select * from snowflake_sample_data.tpch_sf1.customer
    );
create table if not exists cclave_dbt_dev.landing_zone.lineitem as (
    select * from snowflake_sample_data.tpch_sf1.lineitem
    );
create table if not exists cclave_dbt_dev.landing_zone.nation as (
    select * from snowflake_sample_data.tpch_sf1.nation
    );
create table if not exists cclave_dbt_dev.landing_zone.orders as (
    select * from snowflake_sample_data.tpch_sf1.orders
    );
create table if not exists cclave_dbt_dev.landing_zone.part as (
    select * from snowflake_sample_data.tpch_sf1.part
    );
create table if not exists cclave_dbt_dev.landing_zone.partsupp as (
    select * from snowflake_sample_data.tpch_sf1.partsupp
    );
create table if not exists cclave_dbt_dev.landing_zone.region as (
    select * from snowflake_sample_data.tpch_sf1.region
    );
create table if not exists cclave_dbt_dev.landing_zone.supplier as (
    select * from snowflake_sample_data.tpch_sf1.supplier
    );

--------------------
---- add data to the PROD landing zone
use role sysadmin;
create table if not exists cclave_dbt_prod.landing_zone.customer as (
    select * from snowflake_sample_data.tpch_sf1.customer
    );
create table if not exists cclave_dbt_prod.landing_zone.lineitem as (
    select * from snowflake_sample_data.tpch_sf1.lineitem
    );
create table if not exists cclave_dbt_prod.landing_zone.nation as (
    select * from snowflake_sample_data.tpch_sf1.nation
    );
create table if not exists cclave_dbt_prod.landing_zone.orders as (
    select * from snowflake_sample_data.tpch_sf1.orders
    );
create table if not exists cclave_dbt_prod.landing_zone.part as (
    select * from snowflake_sample_data.tpch_sf1.part
    );
create table if not exists cclave_dbt_prod.landing_zone.partsupp as (
    select * from snowflake_sample_data.tpch_sf1.partsupp
    );
create table if not exists cclave_dbt_prod.landing_zone.region as (
    select * from snowflake_sample_data.tpch_sf1.region
    );
create table if not exists cclave_dbt_prod.landing_zone.supplier as (
    select * from snowflake_sample_data.tpch_sf1.supplier
    );


    
    
