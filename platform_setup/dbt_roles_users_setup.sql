--------------------
-- create warehouses
use role sysadmin;
create warehouse if not exists CCLAVE_DBT_DEV_WH warehouse_size=XSMALL INITIALLY_SUSPENDED=TRUE auto_suspend=60;
create warehouse if not exists CCLAVE_DBT_PROD_WH warehouse_size=XSMALL INITIALLY_SUSPENDED=TRUE auto_suspend=60;

create warehouse if not exists CCLAVE_DBT_ORCHESTRATION_DEV_WH warehouse_size=XSMALL INITIALLY_SUSPENDED=TRUE auto_suspend=60;
create warehouse if not exists CCLAVE_DBT_ORCHESTRATION_PROD_WH warehouse_size=XSMALL INITIALLY_SUSPENDED=TRUE auto_suspend=60;


--------------------
---- create objects
use role sysadmin;

create database if not exists cclave_dbt_dev;
create database if not exists cclave_dbt_prod;

create schema if not exists cclave_dbt_dev.landing_zone;
create schema if not exists cclave_dbt_prod.landing_zone;

create schema if not exists cclave_dbt_dev._orchestration;
create schema if not exists cclave_dbt_prod._orchestration;


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
    password = 'your_dev_password'
    Comment= 'Service account for dbt in the development (DEV) environment of the CCLAVE project.'
    default_warehouse = CCLAVE_DBT_DEV_WH
    default_role= cclave_dbt_dev_service_account_role
    must_change_password=FALSE;
    
create user cclave_dbt_prod_service_account_user
    password = 'your_prod_password'
    Comment= 'Service account for dbt in the production (PROD) environment of the CCLAVE project.'
    default_warehouse = CCLAVE_DBT_PROD_WH
    default_role= cclave_dbt_prod_service_account_role
    must_change_password=FALSE;

--------------------
---- Grant priviledges
USE ROLE securityadmin;
-- for cclave_dbt_dev_service_account_role
grant usage on warehouse cclave_dbt_dev_WH to role cclave_dbt_dev_service_account_role;
GRANT USAGE ON DATABASE cclave_dbt_dev TO ROLE cclave_dbt_dev_service_account_role;
GRANT CREATE SCHEMA ON DATABASE cclave_dbt_dev TO ROLE cclave_dbt_dev_service_account_role;
GRANT USAGE ON SCHEMA cclave_dbt_dev.landing_zone TO ROLE cclave_dbt_dev_service_account_role;
GRANT SELECT ON ALL TABLES IN SCHEMA cclave_dbt_dev.landing_zone TO ROLE cclave_dbt_dev_service_account_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA cclave_dbt_dev.landing_zone TO ROLE cclave_dbt_dev_service_account_role;


-- for cclave_dbt_prod_service_account_role
grant usage on warehouse cclave_dbt_prod_WH to role cclave_dbt_prod_service_account_role;
GRANT USAGE ON DATABASE cclave_dbt_prod TO ROLE cclave_dbt_prod_service_account_role;
GRANT CREATE SCHEMA ON DATABASE cclave_dbt_prod TO ROLE cclave_dbt_prod_service_account_role;
GRANT USAGE ON SCHEMA cclave_dbt_prod.landing_zone TO ROLE cclave_dbt_prod_service_account_role;
GRANT SELECT ON ALL TABLES IN SCHEMA cclave_dbt_prod.landing_zone TO ROLE cclave_dbt_prod_service_account_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA cclave_dbt_prod.landing_zone TO ROLE cclave_dbt_prod_service_account_role;


--------------------
---- grant roles to users
use role useradmin;
grant role cclave_dbt_dev_service_account_role to user cclave_dbt_dev_service_account_user;
grant role cclave_dbt_prod_service_account_role to user cclave_dbt_prod_service_account_user;

--------------------
--------------------
