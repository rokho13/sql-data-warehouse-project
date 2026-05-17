/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CALL bronze.load_bronze();


CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_duration INTERVAL;
BEGIN


    RAISE NOTICE '===========================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '===========================================';

    RAISE NOTICE '-------------------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '-------------------------------------------';

    TRUNCATE TABLE bronze.crm_cust_info;
    TRUNCATE TABLE bronze.crm_prd_info;
    TRUNCATE TABLE bronze.crm_sales_details;
    TRUNCATE TABLE bronze.erp_cust_az12;
    TRUNCATE TABLE bronze.erp_loc_a101;
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    -- Start timer
    v_start_time := clock_timestamp();

    COPY bronze.crm_cust_info
    FROM 'C:\Users\khras\Desktop\DA course\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
    DELIMITER ','
    CSV HEADER;
    -- End timer
    v_end_time := clock_timestamp();

    -- Calculate duration
    v_duration := v_end_time - v_start_time;

    RAISE NOTICE '===========================================';
    RAISE NOTICE 'bronze.crm_cust_info Loading Completed';
    RAISE NOTICE 'Total Duration: %', v_duration;
    RAISE NOTICE '===========================================';


    COPY bronze.crm_prd_info
    FROM 'C:\Users\khras\Desktop\DA course\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
    DELIMITER ','
    CSV HEADER;

    COPY bronze.crm_sales_details
    FROM 'C:\Users\khras\Desktop\DA course\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
    DELIMITER ','
    CSV HEADER;

    RAISE NOTICE '-------------------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '-------------------------------------------';

    COPY bronze.erp_cust_az12
    FROM 'C:\Users\khras\Desktop\DA course\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
    DELIMITER ','
    CSV HEADER;

    COPY bronze.erp_loc_a101
    FROM 'C:\Users\khras\Desktop\DA course\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
    DELIMITER ','
    CSV HEADER;

    COPY bronze.erp_px_cat_g1v2
    FROM 'C:\Users\khras\Desktop\DA course\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
    DELIMITER ','
    CSV HEADER;

    -- End timer
    v_end_time := clock_timestamp();

    -- Calculate duration
    v_duration := v_end_time - v_start_time;

    RAISE NOTICE '===========================================';
    RAISE NOTICE 'Bronze Layer Loading Completed';
    RAISE NOTICE 'Total Duration: %', v_duration;
    RAISE NOTICE '===========================================';
END;
$$;

