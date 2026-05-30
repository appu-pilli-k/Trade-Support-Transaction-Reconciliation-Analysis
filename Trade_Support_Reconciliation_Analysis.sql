CREATE DATABASE Tradesupportdb;
USE Tradesupportdb;
#Transaction Table
CREATE TABLE Transaction (
      Transaction_ID VARCHAR(20),
      Customer_ID INT,
      Transaction_Date DATE,
      Amount DECIMAL(12,2),
      Tansaction_Status VARCHAR(50),
      Payment_Method VARCHAR(50)
);
#Settlemnts Table
CREATE TABLE Settlements(
		Transaction_ID VARCHAR(20),
        Settlements_Amount Decimal(12,2),
        Settlemnt_Date DATE,
        Settlement_Status VARCHAR(50)
);
SELECT COUNT(*) AS Total_Transactions
FROM transaction;
SELECT COUNT(*) AS Total_Settlements
FROM settlements;

DROP TABLE settlements;

CREATE TABLE settlements(
    Transaction_ID VARCHAR(20),
    Settlement_Amount DECIMAL(12,2),
    Settlement_Date DATE,
    Settlement_Status VARCHAR(50)
);
SELECT COUNT(*) FROM settlements;
RENAME TABLE `transaction` TO transactions;

#Total Transaction
SELECT COUNT(*) AS Total_Transactions FROM transactions;

#Check Total Records
SELECT COUNT(*) AS Total_Transactions FROM Transactions;
SELECT COUNT(*) AS Total_Settlements
FROM settlements;

#Missing Settlements

SELECT COUNT(*) AS Missing_Settlements 
FROM transactions t 
LEFT JOIN settlements s 
ON t.Transaction_ID = s.Transaction_ID
WHERE s.Transaction_ID IS NULL;

#Amount Mismatches
SELECT COUNT(*) AS Amount_Mismatches
FROM transactions t
INNER JOIN settlements s
ON t.Transaction_ID = s.Transaction_ID
WHERE t.Amount <> s.Settlement_Amount;

#Failed Settlements
SELECT COUNT(*) AS Failed_Settlements
FROM settlements
WHERE Settlement_Status = 'Failed';

#Duplicate Settlement Records
SELECT
Transaction_ID,
COUNT(*) AS Duplicate_Count
FROM settlements
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;

#Business KPI Summary

SELECT
(SELECT COUNT(*) FROM transactions) AS Total_Transactions,
(SELECT COUNT(*) FROM settlements) AS Total_Settlements,
(
    SELECT COUNT(*)
    FROM transactions t
    LEFT JOIN settlements s
    ON t.Transaction_ID = s.Transaction_ID
    WHERE s.Transaction_ID IS NULL
) AS Missing_Settlements,
(
    SELECT COUNT(*)
    FROM settlements
    WHERE Settlement_Status = 'Failed'
) AS Failed_Settlements;

#Exception Analysis
SELECT COUNT(*) AS Amount_Mismatches
FROM transaction t
INNER JOIN settlements s
ON t.Transaction_ID = s.Transaction_ID
WHERE t.Amount <> s.Settlement_Amount;
RENAME TABLE `transaction` TO transactions;
USE tradesupportdb;
SHOW TABLES;
SELECT COUNT(*) AS Amount_Mismatches
FROM transactions t
INNER JOIN settlements s
ON t.Transaction_ID = s.Transaction_ID
WHERE t.Amount <> s.Settlement_Amount;

SELECT
Settlement_Status,
COUNT(*) AS Total_Count
FROM settlements
GROUP BY Settlement_Status;

SELECT
COUNT(*) AS Duplicate_Transaction_Count
FROM
(
SELECT Transaction_ID
FROM settlements
GROUP BY Transaction_ID
HAVING COUNT(*) > 1
) x;

-- Exception Analysis
#Exception Breakdown

SELECT 'Missing Settlements' AS Exception_Type, COUNT(*) AS Total
FROM transactions t
LEFT JOIN settlements s
ON t.Transaction_ID = s.Transaction_ID
WHERE s.Transaction_ID IS NULL

UNION ALL

SELECT 'Amount Mismatches', COUNT(*)
FROM transactions t
JOIN settlements s
ON t.Transaction_ID = s.Transaction_ID
WHERE t.Amount <> s.Settlement_Amount

UNION ALL

SELECT 'Failed Settlements', COUNT(*)
FROM settlements
WHERE Settlement_Status='Failed';

#Daily Transaction Volume
SELECT
Transaction_Date,
COUNT(*) AS Transaction_Count
FROM transactions
GROUP BY Transaction_Date
ORDER BY Transaction_Date;

#Daily Settlement Volume
SELECT
Settlement_Date,
COUNT(*) AS Settlement_Count
FROM settlements
GROUP BY Settlement_Date
ORDER BY Settlement_Date;

#Settlement Success Rate
SELECT
ROUND(
100 *
SUM(CASE WHEN Settlement_Status='Settled' THEN 1 ELSE 0 END)
/
COUNT(*),
2
) AS Settlement_Success_Rate
FROM settlements;

#KPI Summary 
SELECT
22000 AS Total_Transactions,
21550 AS Total_Settlements,
600 AS Missing_Settlements,
400 AS Amount_Mismatches,
1084 AS Failed_Settlements,
150 AS Duplicate_Records,
89.65 AS Settlement_Success_Rate;

#Additional Business Queries

#Payment Method Analysis
SELECT
Payment_Method,
COUNT(*) AS Total_Transactions
FROM transactions
GROUP BY Payment_Method
ORDER BY Total_Transactions DESC;


#Transaction Status Analysis
SHOW COLUMNS FROM transactions;

SELECT
Tansaction_Status,
COUNT(*) AS Total_Count
FROM transactions
GROUP BY Tansaction_Status;

#Monthly Transaction Trend
SELECT
DATE_FORMAT(Transaction_Date,'%Y-%m') AS Month,
COUNT(*) AS Total_Transactions
FROM transactions
GROUP BY Month
ORDER BY Month;

#Payment Method Distribution
SELECT
Payment_Method,
COUNT(*) AS Total_Transactions
FROM transactions
GROUP BY Payment_Method
ORDER BY Total_Transactions DESC;

#Settlement Status Distribution
SELECT
Settlement_Status,
COUNT(*) AS Total_Count
FROM settlements
GROUP BY Settlement_Status;

















      