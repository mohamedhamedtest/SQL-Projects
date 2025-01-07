-- إنشاء قاعدة البيانات
CREATE DATABASE PharmacyManagement;

-- استخدام قاعدة البيانات
USE PharmacyManagement;

-- جدول الأدوية
CREATE TABLE Medicines (
    MedicineID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Type VARCHAR(50),
    Price DECIMAL(10, 2) NOT NULL,
    Quantity INT NOT NULL,
    ExpiryDate DATE NOT NULL
);

-- جدول العملاء
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Address VARCHAR(255)
);

-- جدول المبيعات
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY AUTO_INCREMENT,
    SaleDate DATE NOT NULL,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- جدول تفاصيل المبيعات
CREATE TABLE SaleDetails (
    SaleDetailID INT PRIMARY KEY AUTO_INCREMENT,
    SaleID INT,
    MedicineID INT,
    Quantity INT NOT NULL,
    TotalPrice DECIMAL(10, 2),
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID),
    FOREIGN KEY (MedicineID) REFERENCES Medicines(MedicineID)
);
-- جدول تفاصيل الموردين 
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Address VARCHAR(255)
);
-- جدول تفاصيل المخازن 
CREATE TABLE InventoryLocations (
    LocationID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255)
);





-- إدخال بيانات الأدوية


INSERT INTO Medicines (Name, Type, Price, Quantity, ExpiryDate)
VALUES
('Panadol', 'Tablet', 15.00, 100, '2025-12-31'),
('Amoxicillin', 'Capsule', 25.50, 50, '2025-06-30'),
('Cough Syrup', 'Liquid', 10.00, 200, '2024-09-15');


-- تحديث الكميات في جدول الأدوية
UPDATE Medicines
SET Quantity = Quantity - 2
WHERE MedicineID = 1;

UPDATE Medicines
SET Quantity = Quantity - 1
WHERE MedicineID = 2;


-- إدخال بيانات العملاء
INSERT INTO Customers (Name, Phone, Address)
VALUES
('Ahmed Ali', '01012345678', 'Cairo'),
('Sara Mohamed', '01123456789', 'Alexandria');

-- إدخال عملية بيع
INSERT INTO Sales (SaleDate, CustomerID)
VALUES (CURDATE(), 1); -- رقم العميل

-- الحصول على رقم البيع الذي تم إدخاله للتو
SET @SaleID = LAST_INSERT_ID();

-- إدخال تفاصيل البيع
INSERT INTO SaleDetails (SaleID, MedicineID, Quantity, TotalPrice)
VALUES
(@SaleID, 1, 2, 30.00), -- بيع 2 من الدواء رقم 1
(@SaleID, 2, 1, 25.50); -- بيع 1 من الدواء رقم 2

-- إدخال تفاصيل الموردين  
INSERT INTO Suppliers (Name, Phone, Email, Address)
VALUES
('PharmaSupply', '01012345678', 'contact@pharmasupply.com', 'Cairo, Egypt'),
('Medico Ltd', '01123456789', 'sales@medico.com', 'Alexandria, Egypt');


-- إدخال تفاصيل المخازن 

INSERT INTO InventoryLocations (Name, Address)
VALUES
('Main Storage', 'Cairo Main Branch'),
('Sub Storage', 'Alexandria Sub Branch');




ALTER TABLE Medicines
ADD SupplierID INT;

ALTER TABLE Medicines
ADD CONSTRAINT FK_Supplier
FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID);



ALTER TABLE Medicines
ADD LocationID INT;

ALTER TABLE Medicines
ADD CONSTRAINT FK_Location
FOREIGN KEY (LocationID) REFERENCES InventoryLocations(LocationID);




-- 1. البحث عن الأدوية القريبة من انتهاء الصلاحية

SELECT * 
FROM Medicines
WHERE ExpiryDate < DATE_ADD(CURDATE(), INTERVAL 30 DAY);

--2. تحديث الكمية المتوفرة للأدوية

UPDATE Medicines
SET Quantity = Quantity - 10
WHERE MedicineID = 1; -- قم بتغيير ID حسب الحاجة

--4. استعلام المبيعات اليومية

SELECT S.SaleID, C.Name AS CustomerName, SD.MedicineID, M.Name AS MedicineName, SD.Quantity, SD.TotalPrice
FROM Sales S
JOIN Customers C ON S.CustomerID = C.CustomerID
JOIN SaleDetails SD ON S.SaleID = SD.SaleID
JOIN Medicines M ON SD.MedicineID = M.MedicineID
WHERE S.SaleDate = CURDATE();

--5. استعلام الإيرادات الإجمالية

SELECT SUM(TotalPrice) AS TotalRevenue
FROM SaleDetails;

--6. استعلام الأدوية الموردة من مورد معين

SELECT M.Name AS MedicineName, S.Name AS SupplierName, M.Quantity, M.Price
FROM Medicines M
JOIN Suppliers S ON M.SupplierID = S.SupplierID
WHERE S.Name = 'PharmaSupply';


--7 استعلام الأدوية الموجودة في موقع تخزين معين

SELECT M.Name AS MedicineName, L.Name AS LocationName, M.Quantity
FROM Medicines M
JOIN InventoryLocations L ON M.LocationID = L.LocationID
WHERE L.Name = 'Main Storage';

