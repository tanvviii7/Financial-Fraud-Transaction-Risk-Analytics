
-- ============================================================
-- PROJECT 5: FINANCIAL FRAUD DETECTION & TRANSACTION RISK ANALYTICS
-- Author: Tanvi Kamat
-- ============================================================

-- 1. Create the database
CREATE DATABASE IF NOT EXISTS financial_fraud_analytics;

-- 2. Select the database
USE financial_fraud_analytics;

-- 3. Rename the imported table ONLY if it still has the original long name.
-- Your screenshot shows the import succeeded, but verify the table name.
-- If already named transaction_data, leave the following lines commented.
-- RENAME TABLE financial_fraud_transaction_risk_analytics_cleaned
-- TO transaction_data;

-- 4. Verify columns
SHOW COLUMNS FROM transaction_data;

-- 5. Verify imported row count
SELECT COUNT(*) AS Total_Transactions
FROM transaction_data;

-- 6. Overall fraud KPIs
SELECT
    COUNT(*) AS Total_Transactions,
    SUM(Fraud_Flag) AS Fraud_Transactions,
    ROUND(AVG(Fraud_Flag) * 100, 2) AS Fraud_Rate_Percent,
    ROUND(SUM(Transaction_Amount_INR), 2) AS Total_Transaction_Value_INR,
    ROUND(SUM(CASE WHEN Fraud_Flag = 1
        THEN Transaction_Amount_INR ELSE 0 END), 2)
        AS Fraud_Labelled_Transaction_Value_INR,
    ROUND(AVG(Transaction_Amount_INR), 2) AS Average_Transaction_Amount_INR
FROM transaction_data;

-- 7. Fraud by payment method
SELECT
    Payment_Method,
    COUNT(*) AS Total_Transactions,
    SUM(Fraud_Flag) AS Fraud_Transactions,
    ROUND(AVG(Fraud_Flag) * 100, 2) AS Fraud_Rate_Percent,
    ROUND(SUM(CASE WHEN Fraud_Flag = 1
        THEN Transaction_Amount_INR ELSE 0 END), 2) AS Fraud_Labelled_Value_INR
FROM transaction_data
GROUP BY Payment_Method
ORDER BY Fraud_Rate_Percent DESC;

-- 8. Fraud by transaction channel
SELECT
    Transaction_Channel,
    COUNT(*) AS Total_Transactions,
    SUM(Fraud_Flag) AS Fraud_Transactions,
    ROUND(AVG(Fraud_Flag) * 100, 2) AS Fraud_Rate_Percent
FROM transaction_data
GROUP BY Transaction_Channel
ORDER BY Fraud_Rate_Percent DESC;

-- 9. Fraud by region
SELECT
    Region,
    COUNT(*) AS Total_Transactions,
    SUM(Fraud_Flag) AS Fraud_Transactions,
    ROUND(AVG(Fraud_Flag) * 100, 2) AS Fraud_Rate_Percent
FROM transaction_data
GROUP BY Region
ORDER BY Fraud_Rate_Percent DESC;

-- 10. Fraud by merchant category
SELECT
    Merchant_Category,
    COUNT(*) AS Total_Transactions,
    SUM(Fraud_Flag) AS Fraud_Transactions,
    ROUND(AVG(Fraud_Flag) * 100, 2) AS Fraud_Rate_Percent,
    ROUND(AVG(Transaction_Amount_INR), 2) AS Average_Transaction_INR
FROM transaction_data
GROUP BY Merchant_Category
ORDER BY Fraud_Rate_Percent DESC;

-- 11. Fraud by device status
SELECT
    Device_Status,
    COUNT(*) AS Total_Transactions,
    SUM(Fraud_Flag) AS Fraud_Transactions,
    ROUND(AVG(Fraud_Flag) * 100, 2) AS Fraud_Rate_Percent
FROM transaction_data
GROUP BY Device_Status
ORDER BY Fraud_Rate_Percent DESC;

-- 12. Domestic versus international transactions
SELECT
    International_Transaction,
    COUNT(*) AS Total_Transactions,
    SUM(Fraud_Flag) AS Fraud_Transactions,
    ROUND(AVG(Fraud_Flag) * 100, 2) AS Fraud_Rate_Percent,
    ROUND(SUM(CASE WHEN Fraud_Flag = 1
        THEN Transaction_Amount_INR ELSE 0 END), 2) AS Fraud_Labelled_Value_INR
FROM transaction_data
GROUP BY International_Transaction
ORDER BY Fraud_Rate_Percent DESC;

-- 13. Fraud by transaction hour
SELECT
    Transaction_Hour,
    COUNT(*) AS Total_Transactions,
    SUM(Fraud_Flag) AS Fraud_Transactions,
    ROUND(AVG(Fraud_Flag) * 100, 2) AS Fraud_Rate_Percent
FROM transaction_data
GROUP BY Transaction_Hour
ORDER BY Transaction_Hour;

-- 14. Monthly transaction and fraud trends
SELECT
    Transaction_Month,
    COUNT(*) AS Total_Transactions,
    SUM(Fraud_Flag) AS Fraud_Transactions,
    ROUND(AVG(Fraud_Flag) * 100, 2) AS Fraud_Rate_Percent,
    ROUND(SUM(CASE WHEN Fraud_Flag = 1
        THEN Transaction_Amount_INR ELSE 0 END), 2) AS Fraud_Labelled_Value_INR
FROM transaction_data
GROUP BY Transaction_Month
ORDER BY Transaction_Month;

-- 15. Fraud by transaction status
SELECT
    Transaction_Status,
    COUNT(*) AS Total_Transactions,
    SUM(Fraud_Flag) AS Fraud_Transactions,
    ROUND(AVG(Fraud_Flag) * 100, 2) AS Fraud_Rate_Percent
FROM transaction_data
GROUP BY Transaction_Status
ORDER BY Fraud_Rate_Percent DESC;

-- 16. Fraud by review status
SELECT
    Review_Status,
    COUNT(*) AS Total_Transactions,
    SUM(Fraud_Flag) AS Fraud_Transactions,
    ROUND(AVG(Fraud_Flag) * 100, 2) AS Fraud_Rate_Percent
FROM transaction_data
GROUP BY Review_Status
ORDER BY Fraud_Transactions DESC;

-- 17. Fraud by transaction amount band
SELECT
    CASE
        WHEN Transaction_Amount_INR <= 1000 THEN 'Up to INR 1,000'
        WHEN Transaction_Amount_INR <= 5000 THEN 'INR 1,001-5,000'
        WHEN Transaction_Amount_INR <= 10000 THEN 'INR 5,001-10,000'
        WHEN Transaction_Amount_INR <= 50000 THEN 'INR 10,001-50,000'
        ELSE 'Above INR 50,000'
    END AS Transaction_Amount_Band,
    COUNT(*) AS Total_Transactions,
    SUM(Fraud_Flag) AS Fraud_Transactions,
    ROUND(AVG(Fraud_Flag) * 100, 2) AS Fraud_Rate_Percent
FROM transaction_data
GROUP BY Transaction_Amount_Band
ORDER BY MIN(Transaction_Amount_INR);

-- 18. Top 20 high-value fraud-labelled transactions
SELECT *
FROM transaction_data
WHERE Fraud_Flag = 1
ORDER BY Transaction_Amount_INR DESC
LIMIT 20;

-- 19. Transactions under review or labelled confirmed fraud
SELECT *
FROM transaction_data
WHERE Review_Status IN ('Under Review', 'Confirmed Fraud')
ORDER BY Transaction_Amount_INR DESC
LIMIT 50;

-- 20. Fraud by customer tenure
SELECT
    CASE
        WHEN Customer_Tenure_Months <= 12 THEN '0-12 Months'
        WHEN Customer_Tenure_Months <= 36 THEN '13-36 Months'
        WHEN Customer_Tenure_Months <= 60 THEN '37-60 Months'
        ELSE 'Above 60 Months'
    END AS Customer_Tenure_Band,
    COUNT(*) AS Total_Transactions,
    SUM(Fraud_Flag) AS Fraud_Transactions,
    ROUND(AVG(Fraud_Flag) * 100, 2) AS Fraud_Rate_Percent
FROM transaction_data
GROUP BY Customer_Tenure_Band
ORDER BY MIN(Customer_Tenure_Months);

-- 21. Fraud by account age
SELECT
    CASE
        WHEN Account_Age_Days <= 180 THEN '0-180 Days'
        WHEN Account_Age_Days <= 365 THEN '181-365 Days'
        WHEN Account_Age_Days <= 1095 THEN '1-3 Years'
        ELSE 'Above 3 Years'
    END AS Account_Age_Band,
    COUNT(*) AS Total_Transactions,
    SUM(Fraud_Flag) AS Fraud_Transactions,
    ROUND(AVG(Fraud_Flag) * 100, 2) AS Fraud_Rate_Percent
FROM transaction_data
GROUP BY Account_Age_Band
ORDER BY MIN(Account_Age_Days);

-- 22. Final data quality check
-- Transaction_ID is omitted because its column name may contain a BOM.
SELECT
    COUNT(*) AS Total_Rows,
    SUM(Transaction_Amount_INR IS NULL) AS Missing_Amounts,
    SUM(Fraud_Flag IS NULL) AS Missing_Fraud_Labels,
    SUM(Transaction_Amount_INR <= 0) AS Non_Positive_Amounts
FROM transaction_data;
