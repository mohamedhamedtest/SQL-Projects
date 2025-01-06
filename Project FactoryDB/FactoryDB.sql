-- إنشاء قاعدة البيانات
CREATE DATABASE IF NOT EXISTS FactoryDB;
USE FactoryDB;

-- جدول الموظفين
CREATE TABLE Employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Position VARCHAR(50),
    Salary DECIMAL(10, 2),
    HireDate DATE
);

-- جدول المنتجات
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2),
    StockQuantity INT
);

-- جدول الموردين
CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(100),
    ContactInfo VARCHAR(255)
);

-- جدول العملاء
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(100),
    ContactInfo VARCHAR(255)
);

-- جدول الطلبات
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    OrderDate DATE,
    Quantity INT,
    TotalPrice DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- جدول المخزون
CREATE TABLE Inventory (
    InventoryID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    SupplierID INT,
    RestockDate DATE,
    Quantity INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);


-- جدول المعدات
CREATE TABLE Machines (
    MachineID INT AUTO_INCREMENT PRIMARY KEY,
    MachineName VARCHAR(100),
    MachineType VARCHAR(50),
    PurchaseDate DATE,
    Status VARCHAR(50) -- (Active, Inactive, Under Maintenance)
);

-- جدول سجلات الصيانة
CREATE TABLE MaintenanceLogs (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    MachineID INT,
    MaintenanceDate DATE,
    MaintenanceDetails TEXT,
    EmployeeID INT, -- الشخص المسؤول عن الصيانة
    FOREIGN KEY (MachineID) REFERENCES Machines(MachineID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


-- إنشاء جدول لتتبع الحضور
CREATE TABLE Attendance (
    AttendanceID INT AUTO_INCREMENT PRIMARY KEY, -- معرف السجل
    EmployeeID INT, -- معرف الموظف
    Date DATE, -- تاريخ الحضور
    CheckIn TIME, -- وقت الدخول
    CheckOut TIME, -- وقت الخروج
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) -- العلاقة مع جدول الموظفين
);




 --:إدخال بيانات          



-- إضافة بيانات الموظفين
INSERT INTO Employees (Name, Position, Salary, HireDate) VALUES
('Ali Ahmed', 'Manager', 15000, '2021-01-15'),
('Mona Hassan', 'Engineer', 10000, '2022-03-10'),
('Khaled Omar', 'Technician', 7000, '2023-06-05');

-- إضافة بيانات المنتجات
INSERT INTO Products (ProductName, Category, Price, StockQuantity) VALUES
('Widget A', 'Widgets', 50.00, 100),
('Widget B', 'Widgets', 75.00, 50),
('Gadget X', 'Gadgets', 150.00, 30);

-- إضافة بيانات الموردين
INSERT INTO Suppliers (SupplierName, ContactInfo) VALUES
('Supplier One', '123-456-789'),
('Supplier Two', '987-654-321');

-- إضافة بيانات العملاء
INSERT INTO Customers (CustomerName, ContactInfo) VALUES
('Customer One', 'customer1@example.com'),
('Customer Two', 'customer2@example.com');

-- إضافة بيانات الطلبات
INSERT INTO Orders (CustomerID, ProductID, OrderDate, Quantity, TotalPrice) VALUES
(1, 1, '2024-01-01', 5, 250.00),
(2, 2, '2024-01-02', 3, 225.00);

-- إضافة بيانات المخزون
INSERT INTO Inventory (ProductID, SupplierID, RestockDate, Quantity) VALUES
(1, 1, '2023-12-15', 50),
(2, 2, '2023-12-20', 30);


-- إدخال بيانات أولية
INSERT INTO Machines (MachineName, MachineType, PurchaseDate, Status) VALUES
('CNC Machine', 'Machinery', '2022-01-01', 'Active'),
('Conveyor Belt', 'Equipment', '2021-06-15', 'Under Maintenance');


INSERT INTO MaintenanceLogs (MachineID, MaintenanceDate, MaintenanceDetails, EmployeeID) VALUES
(1, '2024-01-02', 'Changed oil and cleaned components', 2),
(2, '2024-01-03', 'Repaired motor and tested performance', 3);


-- إدخال بيانات تجريبية
INSERT INTO Attendance (EmployeeID, Date, CheckIn, CheckOut) VALUES
(1, '2024-01-01', '08:00:00', '16:00:00'),
(2, '2024-01-01', '09:00:00', '17:00:00'),
(3, '2024-01-01', '10:00:00', '18:00:00'),
(1, '2024-01-02', '08:15:00', '16:10:00'),
(2, '2024-01-02', '09:10:00', '17:05:00');


--:عرض جميع الموظفين ورواتبهم


SELECT * FROM Employees;


 -- 50 :المنتجات التي تكون الكمية المتوفرة منها أقل من 


SELECT * FROM Products WHERE StockQuantity < 50;


--: عرض الطلبات مع اسم العميل واسم المنتج


SELECT Orders.OrderID, Customers.CustomerName, Products.ProductName, Orders.Quantity, Orders.TotalPrice
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
JOIN Products ON Orders.ProductID = Products.ProductID;




--:إجمالي المبيعات لكل منتج


SELECT Products.ProductName, SUM(Orders.Quantity) AS TotalQuantity, SUM(Orders.TotalPrice) AS TotalSales
FROM Orders
JOIN Products ON Orders.ProductID = Products.ProductID
GROUP BY Products.ProductName;


--:عرض جدول المخزون مع أسماء الموردين والمنتجات


SELECT Inventory.InventoryID, Products.ProductName, Suppliers.SupplierName, Inventory.Quantity, Inventory.RestockDate
FROM Inventory
JOIN Products ON Inventory.ProductID = Products.ProductID
JOIN Suppliers ON Inventory.SupplierID = Suppliers.SupplierID;



-- 1. عرض جميع سجلات الحضور: 

SELECT Attendance.AttendanceID, Employees.Name AS EmployeeName, Attendance.Date, Attendance.CheckIn, Attendance.CheckOut
FROM Attendance
JOIN Employees ON Attendance.EmployeeID = Employees.EmployeeID;


-- 2. عرض الحضور ليوم معين:


SELECT Employees.Name AS EmployeeName, Attendance.Date, Attendance.CheckIn, Attendance.CheckOut
FROM Attendance
JOIN Employees ON Attendance.EmployeeID = Employees.EmployeeID
WHERE Attendance.Date = '2024-01-01';


-- 3. عرض الموظفين الذين لم يحضروا في يوم معين:


SELECT Employees.Name
FROM Employees
LEFT JOIN Attendance ON Employees.EmployeeID = Attendance.EmployeeID AND Attendance.Date = '2024-01-01'
WHERE Attendance.AttendanceID IS NULL;


4. إجمالي ساعات العمل لكل موظف في يوم معين:


SELECT Employees.Name AS EmployeeName, Attendance.Date,
       TIMEDIFF(Attendance.CheckOut, Attendance.CheckIn) AS WorkHours
FROM Attendance
JOIN Employees ON Attendance.EmployeeID = Employees.EmployeeID
WHERE Attendance.Date = '2024-01-01';


--5. إجمالي ساعات العمل لكل موظف خلال فترة محددة:

SELECT Employees.Name AS EmployeeName,
       SEC_TO_TIME(SUM(TIME_TO_SEC(TIMEDIFF(Attendance.CheckOut, Attendance.CheckIn)))) AS TotalWorkHours
FROM Attendance
JOIN Employees ON Attendance.EmployeeID = Employees.EmployeeID
WHERE Attendance.Date BETWEEN '2024-01-01' AND '2024-01-02'
GROUP BY Employees.EmployeeID;
