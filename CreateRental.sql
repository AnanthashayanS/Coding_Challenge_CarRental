create database CarRental;

use carrental;

-- creating vehicle table
create table Vehicle (
vehicleID int primary key,
make varchar(25),
model varchar(25),
year int,
dailyRate decimal (8,2),
status varchar(15),
passengercapacity int,
enginecapacity int
);

-- creating customer table 
create table Customer (
customerID int primary key,
firstname varchar(25),
lastname varchar(25),
email text,
phonenumber varchar(15)
);

-- creating lease table 
create table Lease (
leaseID int primary key,
vehicleID int,
customerID int,
startDate Date,
endDate Date,
type varchar(15),
foreign key (vehicleID) references Vehicle (vehicleID),
foreign key (customerID) references Customer (customerID)
);

-- create payment table
create table Payment (
paymentID int,
leaseID int,
paymentDate date,
amount decimal (8,2),
foreign key (leaseID) references Lease (leaseID)
);

-- inserting into vehicle table
insert into vehicle (vehicleID, make, model, year, dailyRate, status, passengercapacity, enginecapacity)
values
(1, 'Toyota', 'Camry', 2022, 50.00, 1, 4, 1450),
(2, 'Honda', 'Civic', 2023, 45.00, 1, 7, 1500),
(3, 'Ford', 'Focus', 2022,48.00, 0, 4, 1400),
(4, 'Nissan', 'Altima', 2023, 52.00, 1, 7, 1200),
(5, 'Chevrolet', 'Malibu', 2022, 47.00, 1, 4, 1800),
(6, 'Hyundai', 'Sonata', 2023,49.00, 0, 7, 1400),
(7, 'BMW', '3 Series', 2023, 60.00, 1, 7, 2499),
(8, 'Mercedes', 'C-Class', 2022, 58.00, 1, 8, 2599),
(9, 'Audi', 'A4', 2022, 55.00, 0, 4, 2500),
(10, 'Lexus', 'ES', 2023, 54.00, 1, 4, 2500);

-- inserting into customer table
insert into Customer (customerID, firstname, lastname, email, phonenumber)
values
(1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555'),
(2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
(3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
(5, 'David', 'Lee', 'david@example.com', '555-987-6543'),
(6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678'),
(7, 'Michael', 'Davis', 'davis@example.com', '555-876-5432'),
(8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
(9, 'William', 'Taylor', 'william@example.com', '555-321-6457'),
(10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321');


-- inserting into lease table 
insert into lease (leaseID, vehicleID, customerID, startDate, endDate, type)
values
(1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
(3, 3, 3, '2023-03-10', '2023-03-15', 'Daily'),
(4, 4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
(5, 5, 5, '2023-05-05', '2023-05-10','Daily'),
(6, 4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
(7, 7, 7, '2023-07-01', '2023-07-10', 'Daily'),
(8, 8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
(9, 3, 3, '2023-09-07', '2023-09-10', 'Daily'),
(10, 10, 10, '2023-10-10', '2023-10-31', 'Monthly');
 
-- inserting into payment table
insert into Payment (paymentID, leaseID, paymentDate, amount)
values
(1, 1, '2023-01-03', 200.00),
(2, 2, '2023-02-20', 1000.00),
(3, 3, '2023-03-12', 75.00),
(4, 4, '2023-04-25', 900.00),
(5, 5, '2023-05-07', 60.00),
(6, 6, '2023-06-18', 1200.00),
(7, 7, '2023-07-03', 40.00),
(8, 8, '2023-08-14', 1100.00),
(9, 9, '2023-09-03', 80.00),
(10, 10, '2023-10-03', 1500.00);


SET SQL_SAFE_UPDATES = 0;

-- Update the daily rate for a Mercedes car to $68:
UPDATE Vehicle
SET dailyRate = 68.00
WHERE make = 'Mercedes';

-- Delete a specific customer and all associated leases and payments (assuming the customer ID is known, here using customerID = 2):
DELETE FROM Payment
WHERE leaseID IN (SELECT leaseID FROM Lease WHERE customerID = 2);

DELETE FROM Lease
WHERE customerID = 2;

DELETE FROM Customer
WHERE customerID = 2;

-- Rename the "paymentDate" column in the Payment table to "transactionDate":
ALTER TABLE Payment
RENAME COLUMN paymentDate TO transactionDate;

-- Find a specific customer by email (e.g., 'johndoe@example.com'):
SELECT * FROM Customer
WHERE email = 'johndoe@example.com';

-- Get active leases for a specific customer (assuming today's date and customerID = 1):
SELECT * FROM Lease
WHERE customerID = 1 AND endDate >= CURDATE();

-- Find all payments made by a customer with a specific phone number ('555-555-5555'):
SELECT Payment.*
FROM Payment
JOIN Lease ON Payment.leaseID = Lease.leaseID
JOIN Customer ON Lease.customerID = Customer.customerID
WHERE Customer.phonenumber = '555-555-5555';

-- Calculate the average daily rate of all available cars:
SELECT AVG(dailyRate) AS AverageDailyRate
FROM Vehicle
WHERE status = 1;

-- Find the car with the highest daily rate:
SELECT * FROM Vehicle
WHERE dailyRate = (SELECT MAX(dailyRate) FROM Vehicle);

-- Retrieve all cars leased by a specific customer (customerID = 3):
SELECT Vehicle.*
FROM Vehicle
JOIN Lease ON Vehicle.vehicleID = Lease.vehicleID
WHERE Lease.customerID = 3;

-- Find the details of the most recent lease:
SELECT * FROM Lease
ORDER BY startDate DESC
LIMIT 1;

-- List all payments made in the year 2023:
SELECT * FROM Payment
WHERE YEAR(transactionDate) = 2023;

-- Retrieve customers who have not made any payments:
SELECT * FROM Customer
WHERE customerID NOT IN (SELECT DISTINCT customerID FROM Lease JOIN Payment ON Lease.leaseID = Payment.leaseID);

-- Retrieve Car Details and Their Total Payments:
SELECT Vehicle.vehicleID, Vehicle.make, Vehicle.model, SUM(Payment.amount) AS TotalPayments
FROM Vehicle
JOIN Lease ON Vehicle.vehicleID = Lease.vehicleID
JOIN Payment ON Lease.leaseID = Payment.leaseID
GROUP BY Vehicle.vehicleID;

-- Calculate Total Payments for Each Customer:
SELECT Customer.customerID, Customer.firstname, Customer.lastname, SUM(Payment.amount) AS TotalPayments
FROM Customer
JOIN Lease ON Customer.customerID = Lease.customerID
JOIN Payment ON Lease.leaseID = Payment.leaseID
GROUP BY Customer.customerID;

-- List Car Details for Each Lease:
SELECT Lease.leaseID, Vehicle.*
FROM Lease
JOIN Vehicle ON Lease.vehicleID = Vehicle.vehicleID;

-- Retrieve Details of Active Leases with Customer and Car Information (assuming today's date):
SELECT Lease.*, Customer.*, Vehicle.*
FROM Lease
JOIN Customer ON Lease.customerID = Customer.customerID
JOIN Vehicle ON Lease.vehicleID = Vehicle.vehicleID
WHERE Lease.endDate >= CURDATE();

-- Find the Customer Who Has Spent the Most on Leases:
SELECT Customer.customerID, Customer.firstname, Customer.lastname, SUM(Payment.amount) AS TotalSpent
FROM Customer
JOIN Lease ON Customer.customerID = Lease.customerID
JOIN Payment ON Lease.leaseID = Payment.leaseID
GROUP BY Customer.customerID
ORDER BY TotalSpent DESC
LIMIT 1;

-- List All Cars with Their Current Lease Information:
SELECT Vehicle.*, Lease.*
FROM Vehicle
LEFT JOIN Lease ON Vehicle.vehicleID = Lease.vehicleID
WHERE Lease.endDate >= CURDATE() OR Lease.leaseID IS NULL;
















