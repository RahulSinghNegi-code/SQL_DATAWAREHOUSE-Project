/*
=========================================================================================
Stored procedure - Loads Bronze Layer (Source -> Bronze)
=========================================================================================
Script Purpose:
       This stored procedure loads data into the 'bronze' schema from external csv files.
       It performs the following functions :
       - Truncate tables brfore loading data.
       - Uses the BULK INSERT command to load data from csv files to bronze table respectively.


Parameters 
   None.
  This stored procedure does not accept any parameters or return any values.


usage example -:
                EXECUTE bronze.load_bronze;
=========================================================================================
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME,@batch_start_time DATETIME,@batch_end_time DATETIME;   /* This is done to declare two variables to get loading start and end time */
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '==============================================================================';
		PRINT 'LOADING BRONZE LAYER';
		PRINT '==============================================================================';
		PRINT '------------------------------------------------------------------------------';
		PRINT'Loading CRM Tables';
		PRINT '------------------------------------------------------------------------------';
/*************************************************************************************/
		PRINT '---------------------';
		SET @start_time = GETDATE();

		PRINT'^^^^ Truncating the table bronze.crm_cust_info ';
		TRUNCATE TABLE bronze.crm_cust_info;
		print'^^^^ Inserting the data into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info FROM 'E:\SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW = 2,       /*MEANS FIRST ROW IS HEADER THATS WHY SQL WILL PUT DATA FROM 2 ROW AND TREAT FIRST ROW AS HEADER*/
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' >> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) as NVARCHAR) + 'seconds';
		PRINT '---------------------';

/*************************************************************************************/

		SET @start_time = GETDATE();
		PRINT'^^^^ Truncating the table bronze.crm_prd_info ';
		TRUNCATE TABLE bronze.crm_prd_info;
		print'^^^^ Inserting the data into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info FROM 'E:\SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,      
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' >> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) as NVARCHAR) + 'seconds';
		PRINT '---------------------';

/*************************************************************************************/
		SET @start_time = GETDATE();
		PRINT'^^^^ Truncating the table bronze.crm_sales_details ';
		TRUNCATE TABLE bronze.crm_sales_details;
		print'^^^^ Inserting the data into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details FROM 'E:\SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,      
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' >> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) as NVARCHAR) + 'seconds';
		PRINT '---------------------';



/*************************************************************************************/

		PRINT '------------------------------------------------------------------------------';
		PRINT'Loading ERP Tables';
		PRINT '------------------------------------------------------------------------------';
		SET @start_time = GETDATE();
		PRINT'^^^^ Truncating the table bronze.erp_cust_az12 ';
		TRUNCATE TABLE bronze.erp_cust_az12;
		print'^^^^ Inserting the data into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12 FROM 'E:\SQL\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH(
			FIRSTROW = 2,      
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' >> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) as NVARCHAR) + 'seconds';
		PRINT '---------------------';

/*************************************************************************************/

		SET @start_time = GETDATE();
		PRINT'^^^^ Truncating the table bronze.erp_loc_a101 ';
		TRUNCATE TABLE bronze.erp_loc_a101;
		print'^^^^ Inserting the data into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101 FROM 'E:\SQL\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH(
			FIRSTROW = 2,      
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' >> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) as NVARCHAR) + 'seconds';
		PRINT '---------------------';
/*************************************************************************************/

		SET @start_time = GETDATE();
		PRINT'^^^^ Truncating the table bronze.erp_px_cat_g1v2 ';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		print'^^^^ Inserting the data into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2 FROM 'E:\SQL\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH(
			FIRSTROW = 2,      
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT ' >> Load duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) as NVARCHAR) + 'seconds';
		PRINT '---------------------';
/*************************************************************************************/
		SET @batch_end_time = GETDATE();
		PRINT '===========================';
		PRINT 'Bronze Layer load completed';
		PRINT'.........BATCH LOAD DURATION: ' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time)as NVARCHAR) + 'seconds';
		PRINT '===========================';

	END TRY
	BEGIN CATCH
		PRINT'=============================';
		PRINT'Error occured during loading bronze layer';
		PRINT'Error Message' + ERROR_MESSAGE();
		PRINT'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT'============================='
	END CATCH
END;
