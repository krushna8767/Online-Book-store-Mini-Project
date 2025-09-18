--  STEP 1: Set up the environment for analysis
-- We're starting fresh by creating and using the online bookstore database.
CREATE DATABASE onlinebookstore_db;
USE onlinebookstore_db;

-- Let's quickly check what tables are available.
SHOW TABLES;

-- Preview the data to understand the structure of each table.
SELECT * FROM books;
SELECT * FROM customers;
SELECT * FROM orders;


-- ================================
--  BASIC EXPLORATORY QUERIES
-- ================================

-- 1️ Which books fall under the 'Fiction' genre?
-- Helps us understand the range of fictional books in the inventory.
SELECT * 
FROM books 
WHERE Genre = 'Fiction';

-- 2️ Which books were published after 1950?
-- A look at more modern publications in the collection.
SELECT * 
FROM books 
WHERE Published_Year > 1950;

-- 3️ Who are our Canadian customers?
-- Useful for regional marketing or sales analysis.
SELECT * 
FROM customers 
WHERE Country = 'Canada';

-- 4️ What orders were placed in November 2023?
-- Zooming in on a specific month to analyze demand or campaign impact.
SELECT * 
FROM orders 
WHERE Order_Date LIKE '2023-11%';

-- 5️ What's the total stock we currently have?
-- Gives a quick snapshot of current inventory levels.
SELECT SUM(Stock) AS Total_Stock 
FROM books;

-- 6️ What’s the most expensive book we sell?
-- Could be useful for promotions or high-ticket item tracking.
SELECT * 
FROM books 
WHERE Price = (SELECT MAX(Price) FROM books);

-- 7️ Which customers ordered more than one copy of a book?
-- Identifies bulk buyers or highly engaged customers.
SELECT DISTINCT c.* 
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Quantity > 1;

-- 8 Which orders had a total value above $20?
-- Helps identify higher-value transactions.
SELECT * 
FROM orders 
WHERE Total_Amount > 20;

-- 9️ What different genres do we have in our catalog?
-- Gives an overview of our literary diversity.
SELECT DISTINCT Genre 
FROM books;

-- 10  Which book is running lowest on stock?
-- Potential candidate for restocking.
SELECT * 
FROM books 
WHERE Stock = (SELECT MIN(Stock) FROM books);

-- 1️1 What’s the total revenue generated so far?
-- A quick business metric — how much we've earned.
SELECT SUM(Total_Amount) AS Total_Revenue 
FROM orders;



-- =====================================
--   INTERMEDIATE ANALYTICS QUERIES
-- =====================================

-- 1️2 How many books were sold per genre?
-- Reveals which genres are most popular among customers.
SELECT b.Genre, SUM(o.Quantity) AS Total_Books_Sold
FROM books b
JOIN orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Genre;

-- 1️3  What’s the average price of a Fantasy book?
-- Helps gauge pricing strategy within a specific genre.
SELECT AVG(Price) AS Avg_Fantasy_Price
FROM books 
WHERE Genre = 'Fantasy';

-- 1️4  Which customers placed at least 2 orders?
-- Identifies repeat customers — useful for loyalty programs.
SELECT c.Name, COUNT(o.Order_ID) AS Order_Count
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Name
HAVING COUNT(o.Order_ID) >= 2;

-- 1️5  Which book has been ordered the most?
-- Tells us our bestseller — key for promotions and inventory planning.
SELECT b.Title, SUM(o.Quantity) AS Total_Ordered
FROM books b
JOIN orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Title
ORDER BY Total_Ordered DESC
LIMIT 1;

-- 1️6 What are the top 3 most expensive Fantasy books?
-- Targets premium books within the Fantasy genre.
SELECT Title, Price
FROM books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;



-- ===============================
--  ADVANCED INSIGHTS & METRICS
-- ===============================

-- 1️7 How many books has each author sold?
-- A performance breakdown by author — great for analytics and deals.
SELECT b.Author, SUM(o.Quantity) AS Total_Quantity_Sold
FROM books b
JOIN orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Author
ORDER BY Total_Quantity_Sold DESC;

-- 1️8 Which cities have customers who spent more than $30?
-- Useful for identifying high-value markets.
SELECT c.City, o.Total_Amount
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
WHERE o.Total_Amount > 30
ORDER BY o.Total_Amount ASC;

-- 1️9  Who is our top spending customer?
-- Helps recognize VIPs or high-value customers.
SELECT c.Name, SUM(o.Total_Amount) AS Total_Spent
FROM customers c
JOIN orders o ON c.Customer_ID = o.Customer_ID
GROUP BY c.Name
ORDER BY Total_Spent DESC
LIMIT 1;

-- 2️0 What’s the current stock after fulfilling all orders?
-- Shows real-time inventory after accounting for sales.
SELECT b.Book_ID, b.Stock - IFNULL(SUM(o.Quantity), 0) AS Remaining_Stock
FROM books b
LEFT JOIN orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Stock;
