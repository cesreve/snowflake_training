-- STEP 1 Set up the Environment in Snowflake
-- Ensure you're using a role with sufficient privileges (e.g., SYSADMIN)
USE ROLE SYSADMIN;

CREATE DATABASE DEMO_OPS_DATA;
CREATE SCHEMA DEMO_OPS_DATA.CUSTOMERS;

-- Create a target table for your customer data
CREATE OR REPLACE TABLE DEMO_OPS_DATA.CUSTOMERS.CUSTOMER_DAILY_LOAD (
    CUSTOMER_ID VARCHAR,
    CUSTOMER_NAME VARCHAR,
    EMAIL VARCHAR,
    CITY VARCHAR,
    COUNTRY VARCHAR,
    JOIN_DATE DATE,
    LOAD_TIMESTAMP TIMESTAMP_NTZ
);

-- Create a Snowpark-enabled Warehouse (if you don't have one)
-- This is where your Python code will execute.
CREATE WAREHOUSE IF NOT EXISTS SNOWPARK_WH WITH WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE;

-- STEP 2 Write the Snowpark Python Script for Data Generation
--# Create a Snowflake Stored Procedure using Snowpark Python
-- Note: Replace 'DEMO_OPS_DATA.CUSTOMERS.CUSTOMER_DAILY_LOAD' with your actual table name if different.
-- Ensure the role executing this has CREATE PROCEDURE, USAGE on DB/Schema, INSERT on table.

CREATE OR REPLACE PROCEDURE GENERATE_RANDOM_CUSTOMER_DATA(TABLE_NAME VARCHAR)
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9' -- Or '3.8', '3.10', etc.
PACKAGES = ('snowflake-snowpark-python', 'faker') -- Faker for realistic-looking data
HANDLER = 'generate_and_insert'
AS
$$
from snowflake.snowpark import Session
from snowflake.snowpark.functions import lit
from faker import Faker
import datetime
import random

def generate_and_insert(session: Session, table_name: str):
    fake = Faker()
    num_records = 100 # Simulate new data arrivals (e.g., 100 new customers per day)

    data = []
    for _ in range(num_records):
        customer_id = fake.uuid4()
        customer_name = fake.name()
        email = fake.email()
        city = fake.city()
        country = fake.country()
        join_date = fake.date_this_decade() # Simulate join date
        load_timestamp = datetime.datetime.now() # Record current load time

        data.append((customer_id, customer_name, email, city, country, join_date, load_timestamp))

    # Create a Snowpark DataFrame from the generated data
    # Ensure column order matches your target table
    df = session.create_dataframe(data, schema=[
        "CUSTOMER_ID", "CUSTOMER_NAME", "EMAIL", "CITY", "COUNTRY", "JOIN_DATE", "LOAD_TIMESTAMP"
    ])

    # Write the DataFrame to the Snowflake table
    # Using 'append' to simulate daily new data
    df.write.mode("append").save_as_table(table_name)

    return f"Successfully generated and inserted {num_records} records into {table_name}"
$$;


-- STEP 3: Schedule the Stored Procedure using a Snowflake Task
CREATE OR REPLACE TASK daily_customer_data_generator_task
  WAREHOUSE = COMPUTE_WH -- Specify the warehouse for the task to use
  SCHEDULE = 'USING CRON 0 22 * * * America/New_York' -- Every day at 10:00 PM EST/EDT
  -- Or for UTC: SCHEDULE = 'USING CRON 0 22 * * * UTC'
  -- Or for Paris Time: SCHEDULE = 'USING CRON 0 22 * * * Europe/Paris'
AS
  CALL GENERATE_RANDOM_CUSTOMER_DATA('DEMO_OPS_DATA.CUSTOMERS.CUSTOMER_DAILY_LOAD');

-- Resume the task to start it (tasks are created in a suspended state)
ALTER TASK daily_customer_data_generator_task RESUME;

-- STEP 4: Verify the Setup
SHOW TASKS LIKE 'daily_customer_data_generator_task';
EXECUTE TASK daily_customer_data_generator_task;

SELECT * FROM DEMO_OPS_DATA.CUSTOMERS.CUSTOMER_DAILY_LOAD ORDER BY LOAD_TIMESTAMP DESC LIMIT 10;
SELECT COUNT(*) FROM DEMO_OPS_DATA.CUSTOMERS.CUSTOMER_DAILY_LOAD;

-- STEP 5: (Optional) Using a Stream for Change Tracking
-- Create a stream on the table to track changes
CREATE OR REPLACE STREAM CUSTOMER_DAILY_LOAD_STREAM
ON TABLE DEMO_OPS_DATA.CUSTOMERS.CUSTOMER_DAILY_LOAD;

-- Now, you can query the stream to see only the new rows since the last consumption:
SELECT * FROM CUSTOMER_DAILY_LOAD_STREAM;

-- You could then have another task that processes data from this stream.
