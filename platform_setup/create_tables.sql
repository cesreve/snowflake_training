USE ROLE SYSADMIN;

USE SCHEMA LANDING_ZONE;
-- Table customers 
CREATE OR REPLACE TABLE CCLAVE_DBT_PROD.LANDING_ZONE.customers (
    customer_id VARCHAR(36) PRIMARY KEY COMMENT 'Unique identifier for the customer, typically a UUID or system-generated key.',
    customer_name VARCHAR(100) COMMENT 'Full name of the customer.',
    email VARCHAR(100) COMMENT 'Email address of the customer.',
    city VARCHAR(50) COMMENT 'City where the customer resides.',
    country VARCHAR(50) COMMENT 'Country where the customer resides (e.g., France).',
    last_update TIMESTAMP_NTZ COMMENT 'Timestamp indicating the last time this customer record was updated, in Paris time.',
    load_timestamp TIMESTAMP_NTZ COMMENT 'Timestamp indicating the loading dateime into the landing_zone from the source system.'
);

-- Add a comment for the entire table (can also be done as a separate COMMENT ON TABLE statement)
COMMENT ON TABLE CCLAVE_DBT_PROD.LANDING_ZONE.customers IS
'This table stores core customer master data, including unique identifiers, contact details, geographical information, and the timestamp of the last update to the record. It serves as a landing zone for raw customer data.';

INSERT INTO CCLAVE_DBT_PROD.LANDING_ZONE.customers (customer_id, customer_name, email, city, country, last_update, load_timestamp)
VALUES
    ('CUST_001', 'Jean Dupont', 'jean.dupont@email.com', 'Paris', 'France', DATEADD(minute, -5, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('CUST_002', 'Marie Dubois', 'marie.dubois@email.com', 'Marseille', 'France', DATEADD(minute, -4, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('CUST_003', 'Pierre Martin', 'pierre.martin@email.com', 'Lyon', 'France', DATEADD(minute, -3, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('CUST_004', 'Sophie Bernard', 'sophie.bernard@email.com', 'Toulouse', 'France', DATEADD(minute, -2, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ,CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('CUST_005', 'Lucie Petit', 'lucie.petit@email.com', 'Nice', 'France', DATEADD(minute, -1, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ);

-- Table products 
CREATE OR REPLACE TABLE CCLAVE_DBT_PROD.LANDING_ZONE.PRODUCTS (
    product_id VARCHAR(36) COMMENT 'Unique identifier for the product, typically a UUID or system-generated key.',
    product_name VARCHAR(100) COMMENT 'Full name of the product (e.g., Sac à main bandoulière).',
    category VARCHAR(50) COMMENT 'Category of the product (e.g., Sacs, Portefeuilles, Ceintures).',
    material VARCHAR(50) COMMENT 'Primary material of the product (e.g., Cuir).',
    price NUMBER(10, 2) COMMENT 'Current selling price of the product.',
    last_update TIMESTAMP_NTZ COMMENT 'Timestamp indicating the last time this product record was updated.',
    load_timestamp TIMESTAMP_NTZ COMMENT 'Timestamp indicating the loading dateime into the landing_zone from the source system.'
);

-- Add a comment for the entire table
COMMENT ON TABLE CCLAVE_DBT_PROD.LANDING_ZONE.PRODUCTS IS
'This table stores product master data, specifically for items like leather goods. It includes unique product identifiers, names, categories, material, price, and the timestamp of the last update to the record. It serves as a landing zone for raw product data.';

INSERT INTO CCLAVE_DBT_PROD.LANDING_ZONE.PRODUCTS (product_id, product_name, category, material, price, last_update, load_timestamp)
VALUES
    ('PROD_001', 'Sac à main bandoulière', 'Sacs', 'Cuir', 350.00, DATEADD(minute, -1, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('PROD_002', 'Portefeuille compagnon', 'Portefeuilles', 'Cuir', 120.00, DATEADD(minute, -3, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('PROD_003', 'Ceinture réversible', 'Ceintures', 'Cuir', 85.50, DATEADD(minute, -2, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('PROD_004', 'Sac à dos urbain', 'Sacs', 'Cuir', 480.00, DATEADD(minute, -4, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('PROD_005', 'Porte-cartes minimaliste', 'Portefeuilles', 'Cuir', 60.00, DATEADD(minute, -5, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('PROD_006', 'Trousse de toilette en cuir', 'Accessoires', 'Cuir', 180.00, DATEADD(minute, -6, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ),
    ('PROD_007', 'Étui à passeport en cuir', 'Accessoires', 'Cuir', 95.00, DATEADD(minute, -7, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP()))::TIMESTAMP_NTZ, CONVERT_TIMEZONE('Europe/Paris', CURRENT_TIMESTAMP())::TIMESTAMP_NTZ);

-- SELECT * FROM CCLAVE_DBT_PROD.LANDING_ZONE.CUSTOMERS;
-- SELECT * FROM CCLAVE_DBT_PROD.LANDING_ZONE.PRODUCTS;

------------ Transactions
-- Step 1
-- Create the target TRANSACTIONS table
CREATE OR REPLACE TABLE CCLAVE_DBT_PROD.LANDING_ZONE.TRANSACTIONS (
    TRANSACTION_ID VARCHAR COMMENT 'Unique identifier for each transaction.',
    CUSTOMER_ID VARCHAR COMMENT 'Unique identifier for the customer involved in the transaction.',
    PRODUCT_ID VARCHAR COMMENT 'Unique identifier for the product purchased.',
    QUANTITY INT COMMENT 'The number of units of the product involved in the transaction.',
    TRANSACTION_DATETIME TIMESTAMP_TZ COMMENT 'The timestamp when the transaction occurred (with timezone).',
    LOAD_TIMESTAMP TIMESTAMP_TZ COMMENT 'The timestamp when this record was loaded into the table (with timezone).'
);

-- STEP 2
CREATE OR REPLACE PROCEDURE CCLAVE_DBT_PROD._ORCHESTRATION.GENERATE_X_TRANSACTIONS(target_table_name VARCHAR, transaction_count NUMBER)
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10' -- 
PACKAGES = ('snowflake-snowpark-python', 'faker', 'pytz')
HANDLER = 'generate_and_insert_transactions'
AS
$$
from snowflake.snowpark import Session
from snowflake.snowpark.functions import lit, col
from faker import Faker
import datetime
import random
import pytz # To handle time zones for specific time window

def generate_and_insert_transactions(session: Session, target_table_name: str, transaction_count: int):
    fake = Faker()
    num_transactions = transaction_count # Simulate 10 transactions per day

    # --- Fetch existing customer and product IDs for referential integrity ---
    customer_ids = session.table("CCLAVE_DBT_PROD.LANDING_ZONE.CUSTOMERS").select(col("CUSTOMER_ID")).collect()
    customer_ids = [row[0] for row in customer_ids]
    if not customer_ids:
        return "Error: No customers found in CCLAVE_DBT_PROD.LANDING_ZONE.CUSTOMERS. Cannot generate transactions."

    product_ids = session.table("CCLAVE_DBT_PROD.LANDING_ZONE.PRODUCTS").select(col("PRODUCT_ID")).collect()
    product_ids = [row[0] for row in product_ids]
    if not product_ids:
        return "Error: No products found in CCLAVE_DBT_PROD.LANDING_ZONE.PRODUCTS. Cannot generate transactions."
    # --- End Fetch ---

    transactions_data = []

    # Define the Paris timezone
    paris_tz = pytz.timezone('Europe/Paris')

    # Get today's date and time in Paris time
    today_date = datetime.datetime.now(paris_tz).date()
    now_paris = datetime.datetime.now(paris_tz)
    
    # Define the start and end times for transactions on today's date, localized to Paris
    start_time_today_paris = paris_tz.localize(datetime.datetime(today_date.year, today_date.month, today_date.day, 8, 0, 0)) # 8 AM Paris
    end_time_today_paris = now_paris

    # The TRANSACTION_DATETIME is stored as TIMESTAMP_NTZ in Snowflake.
    # Snowflake recommends storing time-zone-naive timestamps, and setting TIMEZONE=UTC for the session/account.
    # So, we convert our Paris-localized times to UTC, then remove the timezone info for TIMESTAMP_NTZ.
    start_time_utc_naive = start_time_today_paris.astimezone(pytz.utc).replace(tzinfo=None)
    end_time_utc_naive = end_time_today_paris.astimezone(pytz.utc).replace(tzinfo=None)

    time_diff_for_random = end_time_utc_naive - start_time_utc_naive


    for _ in range(num_transactions):
        transaction_id = fake.uuid4()
        customer_id = random.choice(customer_ids)
        product_id = random.choice(product_ids)
        quantity = random.randint(1, 5)
        load_timestamp = datetime.datetime.now(paris_tz)

        # Generate a random datetime 
        random_seconds = random.uniform(0, time_diff_for_random.total_seconds())
        transaction_datetime_paris_time = start_time_today_paris + datetime.timedelta(seconds=random_seconds)

        transactions_data.append((
            transaction_id,
            customer_id,
            product_id,
            quantity,
            transaction_datetime_paris_time,
            load_timestamp
        ))

    # Create a Snowpark DataFrame from the generated data
    df = session.create_dataframe(transactions_data, schema=[
        "TRANSACTION_ID", "CUSTOMER_ID", "PRODUCT_ID", "QUANTITY", "TRANSACTION_DATETIME", "LOAD_TIMESTAMP"
    ])

    # Write the DataFrame to the Snowflake table
    df.write.mode("append").save_as_table(target_table_name)

    return f"Successfully generated and inserted {num_transactions} transactions into {target_table_name} for the period {start_time_today_paris.strftime('%Y-%m-%d %H:%M:%S')} to {end_time_today_paris.strftime('%Y-%m-%d %H:%M:%S')} (Paris time)."
$$;


-- STEP 3
USE ROLE SYSADMIN;
CREATE OR REPLACE TASK CCLAVE_DBT_PROD._ORCHESTRATION.TRANSACTION_GENERATION_TASK
  WAREHOUSE = CCLAVE_DBT_ORCHESTRATION_PROD_WH -- Specify the warehouse for the task to use
  SCHEDULE = 'USING CRON 0 22 * * * Europe/Paris' -- Every day at 10:00 PM Paris time
  COMMENT = 'Generate new transactions.'
AS
  CALL CCLAVE_DBT_PROD._ORCHESTRATION.GENERATE_X_TRANSACTIONS('CCLAVE_DBT_PROD.LANDING_ZONE.TRANSACTIONS', 10);

-- generate new transactions
CALL CCLAVE_DBT_PROD._ORCHESTRATION.GENERATE_X_TRANSACTIONS('CCLAVE_DBT_PROD.LANDING_ZONE.TRANSACTIONS', 5);
SELECT * FROM CCLAVE_DBT_PROD.LANDING_ZONE.TRANSACTIONS;

USE ROLE ACCOUNTADMIN;
ALTER TASK CCLAVE_DBT_PROD._ORCHESTRATION.TRANSACTION_GENERATION_TASK RESUME;
--ALTER TASK CCLAVE_DBT_PROD._ORCHESTRATION.TRANSACTION_GENERATION_TASK SUSPEND;
