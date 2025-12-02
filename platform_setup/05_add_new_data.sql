-- (Procédure Python - Modification des Casts)
CREATE OR REPLACE PROCEDURE CCLAVE_PRD._ORCHESTRATION.GENERATE_X_TRANSACTIONS(target_table_name VARCHAR, transaction_count NUMBER)
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('snowflake-snowpark-python', 'faker', 'pytz')
HANDLER = 'generate_and_insert_transactions'
AS
$$
from snowflake.snowpark import Session
from snowflake.snowpark.functions import lit, col
from faker import Faker
import datetime
import random
import pytz 

def generate_and_insert_transactions(session: Session, target_table_name: str, transaction_count: int):
    fake = Faker()
    num_transactions = transaction_count 

    # --- Fetch existing customer and product IDs for referential integrity ---
    customer_ids = session.table("CCLAVE_PRD.RAW.CUSTOMERS").select(col("CUSTOMER_ID")).collect()
    customer_ids = [row[0] for row in customer_ids]
    if not customer_ids:
        return "Error: No customers found in CCLAVE_PRD.RAW.CUSTOMERS. Cannot generate transactions."

    product_ids = session.table("CCLAVE_PRD.RAW.PRODUCTS").select(col("PRODUCT_ID")).collect()
    product_ids = [row[0] for row in product_ids]
    if not product_ids:
        return "Error: No products found in CCLAVE_PRD.RAW.PRODUCTS. Cannot generate transactions."
    # --- End Fetch ---

    transactions_data = []

    # Define the Paris timezone
    paris_tz = pytz.timezone('Europe/Paris')

    # Get today's date and time in Paris time
    today_date = datetime.datetime.now(paris_tz).date()
    now_paris = datetime.datetime.now(paris_tz)
    
    # Define the start and end times for transactions on today's date, localized to Paris
    start_time_today_paris = paris_tz.localize(datetime.datetime(today_date.year, today_date.month, today_date.day, 8, 0, 0))
    end_time_today_paris = now_paris

    # Convert to UTC to calculate the random interval
    start_time_utc = start_time_today_paris.astimezone(pytz.utc)
    end_time_utc = end_time_today_paris.astimezone(pytz.utc)
    time_diff_for_random = end_time_utc - start_time_utc


    for _ in range(num_transactions):
        transaction_id = fake.uuid4()
        customer_id = random.choice(customer_ids)
        product_id = random.choice(product_ids)
        quantity = random.randint(1, 5)
        load_timestamp = datetime.datetime.now(paris_tz)

        # Generate a random datetime within the window (Paris Timezone-aware)
        random_seconds = random.uniform(0, time_diff_for_random.total_seconds())
        transaction_datetime_utc_aware = start_time_utc + datetime.timedelta(seconds=random_seconds)
        
        # Convert back to Paris timezone for the record
        transaction_datetime_paris_time = transaction_datetime_utc_aware.astimezone(paris_tz)

        transactions_data.append((
            transaction_id,
            customer_id,
            product_id,
            quantity,
            transaction_datetime_paris_time, -- TIMESTAMP_TZ aware
            load_timestamp -- TIMESTAMP_TZ aware
        ))

    # Create a Snowpark DataFrame from the generated data
    df = session.create_dataframe(transactions_data, schema=[
        "TRANSACTION_ID", "CUSTOMER_ID", "PRODUCT_ID", "QUANTITY", "TRANSACTION_DATETIME", "LOAD_TIMESTAMP"
    ])

    # Write the DataFrame to the Snowflake table
    # Since TRANSACTION_DATETIME and LOAD_TIMESTAMP are timezone-aware datetime objects in Python,
    # Snowpark handles the conversion to TIMESTAMP_TZ seamlessly upon insertion.
    df.write.mode("append").save_as_table(target_table_name)

    return f"Successfully generated and inserted {num_transactions} transactions into {target_table_name} for the period {start_time_today_paris.strftime('%Y-%m-%d %H:%M:%S')} to {end_time_today_paris.strftime('%Y-%m-%d %H:%M:%S')} (Paris time)."
$$;


-- STEP 3
USE ROLE SYSADMIN;
CREATE OR REPLACE TASK CCLAVE_PRD._ORCHESTRATION.TRANSACTION_GENERATION_TASK
  WAREHOUSE = CCLAVE_ORCHESTRATION_PRD_WH
  SCHEDULE = 'USING CRON 0 22 * * * Europe/Paris'
  COMMENT = 'Generate new transactions.'
AS
  CALL CCLAVE_PRD._ORCHESTRATION.GENERATE_X_TRANSACTIONS('CCLAVE_PRD.RAW.TRANSACTIONS', 10);

-- Execute manually for testing
CALL CCLAVE_PRD._ORCHESTRATION.GENERATE_X_TRANSACTIONS('CCLAVE_PRD.RAW.TRANSACTIONS', 5);
SELECT * FROM CCLAVE_PRD.RAW.TRANSACTIONS;

USE ROLE ACCOUNTADMIN;
ALTER TASK CCLAVE_PRD._ORCHESTRATION.TRANSACTION_GENERATION_TASK RESUME;
