use northwind;


-- 1.name of all customers in the database

select CustomerName from Customers;


-- 2.name and price of all products that cost less than $15

SELECT ProductName, Price
FROM Products
WHERE Price < 15;

-- 3.all employees first and last names

SELECT FirstName, LastName
FROM Employees;

-- 4.all orders placed in the year 1997

SELECT *
FROM Orders
WHERE YEAR(OrderDate) = 1997;

-- 5.names of all products that are currently in stock (UnitsInStock > 0).

SELECT ProductName
FROM Products
WHERE Price > 0;

-- 6.names of customers and the names of the employees who handled their orders

select c.CustomerName, e.FirstName AS EmployeeFirstName, e.LastName AS EmployeeLastName
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Employees e ON o.EmployeeID = e.EmployeeID;

-- 7.each country along with the number of customers from that country.

SELECT Country, COUNT(*) AS NumberOfCustomers
FROM Customers
GROUP BY Country
ORDER BY NumberOfCustomers DESC;

-- 8.average price of products grouped by category

SELECT c.CategoryName, AVG(p.Price) AS AvgPrice
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName, c.CategoryID
ORDER BY AvgPrice DESC;

-- 9.number of orders handled by each employee

SELECT e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName, COUNT(o.OrderID) AS NumberOfOrders
FROM Orders o
JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID, EmployeeName
ORDER BY NumberOfOrders DESC;

-- 10.names of products supplied by "Exotic Liquid".

SELECT p.ProductName
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID
WHERE s.SupplierName = 'Exotic Liquid';

-- 11.top 3 most ordered products (by quantity).

SELECT p.ProductName, SUM(od.Quantity) AS TotalQuantity
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalQuantity DESC
LIMIT 3;


-- 12.customers who have placed orders worth more than $10,000 in total.

SELECT c.CustomerID, c.CustomerName, SUM(od.Quantity * p.Price) AS TotalOrderValue
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
HAVING SUM(od.Quantity * p.Price) > 10000
ORDER BY TotalOrderValue DESC;

-- 13.order IDs and total order value for orders that exceed $2,000 in value.

SELECT o.OrderID, SUM(od.Quantity * p.Price) AS TotalOrderValue
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY o.OrderID
HAVING TotalOrderValue > 2000
ORDER BY TotalOrderValue DESC;

-- 14.name(s) of the customer(s) who placed the largest single order (by value).

SELECT c.CustomerName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN (
    SELECT OrderID, SUM(od.Quantity * p.Price) AS OrderTotal
    FROM OrderDetails od
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY OrderID
) OrderSums ON o.OrderID = OrderSums.OrderID
WHERE OrderSums.OrderTotal = (
    SELECT MAX(TotalAmount)
    FROM (
        SELECT SUM(od.Quantity * p.Price) AS TotalAmount
        FROM OrderDetails od
        JOIN Products p ON od.ProductID = p.ProductID
        GROUP BY OrderID
    ) AS T
);

-- 15.list of products that have never been ordered.

SELECT ProductID, ProductName
FROM Products
WHERE ProductID NOT IN (
    SELECT DISTINCT ProductID
    FROM OrderDetails
);










