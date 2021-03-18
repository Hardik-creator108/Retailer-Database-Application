CREATE DATABASE Hardikproject
GO

USE Hardikproject;
GO

Create Schema Retailer;
GO

Create Table Retailer.Inventory
(
   StockName VARCHAR(25) NOT NULL,
   StockId INT NOT NULL UNIQUE,
   Quantity INT NOT NULL,
   SupplierName VARCHAR(50) NOT NULL,
   MinimumQuantity INT  NOT NULL,
   SellingPrice DECIMAL(5,2) NOT NULL,
);
GO

--SELECT * FROM Retailer.Inventory;
--GO

CREATE TABLE Retailer.Supplier
(
   SupplierName VARCHAR(50) NOT NULL,
   SupplierId INT NOT NULL UNIQUE,
   SupplierAddress VARCHAR(100) NOT NULL,
   ContactNumber INT NOT NULL,
   PurchasePrice DECIMAL(5,2) NOT NULL,
);
GO

--SELECT * FROM Retailer.Supplier;
--GO

CREATE TABLE Retailer.Customer
(
    CustomerName VARCHAR(50) NOT NULL,
	CustomerId INT NOT NULL UNIQUE,
	CustomerAddress VARCHAR(100) NOT NULL,
	EmailId VARCHAR(50) NOT NULL,
	ContactNumber INT NOT NULL,
);
GO

--SELECT * FROM Retailer.Customer;
--GO

CREATE TABLE Retailer.Payment
(
  CustomerId INT NOT NULL UNIQUE,
  PaymentId INT NOT NULL UNIQUE,
  PaymentStatus VARCHAR(25) NOT NULL,
  Tag VARCHAR(25) NOT NULL,
  CheckoutPrice DECIMAL(5,2) NOT NULL,
);
GO

--SELECT * FROM Retailer.Payment;
--GO

CREATE TABLE Retailer.Orders
(
  StockId INT NOT NULL UNIQUE,
  CustomerId INT NOT NULL UNIQUE,
  OrderId INT NOT NULL UNIQUE,
  OrderDate DATE NOT NULL,
  Quantity INT NOT NULL,
  CheckoutPrice DECIMAL(5,2) NOT NULL,
);
GO

--SELECT * FROM Retailer.Orders;
--GO

CREATE TABLE Retailer.Shipment
(
  OrderId INT NOT NULL UNIQUE,
  ShipmentDate DATE NOT NULL,
  TrackingId INT NOT NULL UNIQUE,
  ExpectedDeliveryDate DATE NOT NULL,
);
GO

--SELECT * FROM Retailer.Shipment;
--GO


