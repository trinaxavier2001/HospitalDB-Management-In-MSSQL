--Create Quries

CREATE DATABASE HospitalManagementSystem

USE HospitalManagementSystem

-- Create the HospitalAdmin table
CREATE TABLE HospitalAdmin (
	AdminID INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL,
	contactNumber BIGINT NOT NULL,
	Email VARCHAR(20),
	Address VARCHAR(200) NOT NULL,
	Role VARCHAR(20) NOT NULL
);


--Create the Department table
CREATE TABLE Department (
    DepartmentNumber INT PRIMARY KEY IDENTITY,
    DepartmentName VARCHAR(100) NOT NULL
);
GO


-- Create the Employee table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY IDENTITY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Position VARCHAR(100) NOT NULL,
    DepartmentNumber INT,
    DateOfBirth DATE NOT NULL,
    ContactNumber BIGINT NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Address VARCHAR(200) NOT NULL,
    HireDate DATE NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    AdminID INT NOT NULL,
    FOREIGN KEY (AdminID) REFERENCES HospitalAdmin(AdminID),
    FOREIGN KEY (DepartmentNumber) REFERENCES Department(DepartmentNumber)
);
GO


-- Create the Doctor table
CREATE TABLE Doctor (
    DoctorID VARCHAR(10) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    Specialization VARCHAR(200) NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
GO

-- Create the trigger trg_CustomID_Doctor
CREATE TRIGGER trg_CustomID_Doctor
ON Doctor
AFTER INSERT
AS
BEGIN
    -- Check if there are any existing records in the Doctor table
    IF NOT EXISTS (SELECT 1 FROM Doctor)
    BEGIN
        -- If it's the first record, set DoctorID to 'DOC001'
        UPDATE Doctor
        SET DoctorID = 'DOC001'
        FROM inserted
        WHERE Doctor.DoctorID IS NULL;
    END
    ELSE
    BEGIN
        -- Generate DoctorID for subsequent records
        DECLARE @NewDoctorID VARCHAR(10);
        DECLARE @NextID INT;

        -- Find the maximum DoctorID from the inserted data
        SELECT @NextID = ISNULL(MAX(CAST(RIGHT(DoctorID, 3) AS INT)), 0) + 1 FROM Doctor;

        -- Generate the new DoctorID
        SET @NewDoctorID = 'DOC' + RIGHT('000' + CAST(@NextID AS VARCHAR(3)), 3);

        -- Update the inserted rows with the new DoctorID
        UPDATE d
        SET d.DoctorID = @NewDoctorID
        FROM Doctor d
        JOIN inserted i ON d.DoctorID = i.DoctorID
        WHERE d.DoctorID IS NULL;
    END
END;

-- Creating the Nurse table, Nurse is a subtype of Employee
CREATE TABLE Nurse (
    EmployeeID INT NOT NULL,
    Shift VARCHAR(30) NOT NULL,
    Qualifications VARCHAR(200) NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
 
-- Creating the General Staff table
CREATE TABLE GeneralStaff (
    EmployeeID INT NOT NULL,
    JobDescription VARCHAR(200) NOT NULL,
    WorkHours INT NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
 

-- Create the Patient table
CREATE TABLE Patient (
    PatientID INT PRIMARY KEY IDENTITY,
    DoctorID VARCHAR(10) NOT NULL,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    DOB DATE NOT NULL,
    Gender CHAR NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Phone BIGINT,
    Email VARCHAR(100),
    EmergencyContactName VARCHAR(100),
    EmergencyContactPhone BIGINT,
    InsuranceCompany VARCHAR(100),
    InsurancePolicyNumber VARCHAR(100),
    MedicalHistorySummary TEXT,
    CurrentMedications TEXT,
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);
GO


-- Creating the Appointment table
CREATE TABLE Appointment (
    AppointmentID INT PRIMARY KEY IDENTITY,
    PatientID INT NOT NULL,
    DepartmentNumber INT NOT NULL,
    DateTime DATETIME NOT NULL,
    Purpose VARCHAR(200) NOT NULL,
    Status VARCHAR(50) NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (DepartmentNumber) REFERENCES Department(DepartmentNumber)
);


-- Creating the MedicalRecord table
CREATE TABLE MedicalRecord (
    RecordID INT PRIMARY KEY IDENTITY,
    PatientID INT NOT NULL,
    DoctorID VARCHAR(10) NOT NULL,
    VisitDate DATE NOT NULL,
    Diagnosis TEXT NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);
GO


-- Creating the ResourceManagement table
CREATE TABLE ResourceManagement (
    ResourceID INT PRIMARY KEY IDENTITY,
    ResourceType VARCHAR(100) NOT NULL,
    ResourceName VARCHAR(100) NOT NULL,
    Status VARCHAR(100),
    Location VARCHAR(100),
    AdminID INT,
    FOREIGN KEY (AdminID) REFERENCES HospitalAdmin(AdminID)
);
GO





-----------------------------------------------------------------------------------------------------

--Insert Quries

USE HospitalManagementSystem

INSERT INTO HospitalAdmin (FirstName, LastName, Email, ContactNumber, Address, Role) 
VALUES 
('Leslie', 'Knope', 'leslie@gmail.com', 3216540987, '1501 Grand Ave, Orlando, FL', 'Chief Administrator'),
('Ron', 'Swanson', 'ron2@outlook.com', 3057102345, '7262 Oak Drive, Miami, FL', 'Director of Surgery'),
('Ann', 'Perkins', 'ann3@icloud.com', 2128203456, '1832 Pine Street, New York, NY', 'HeadofNursing Staff'),
('Ben', 'Wyatt', 'ben@gmail.com', 2139304567, '4701 Hilltop Road, Los Angeles, CA', 'Financial Director'),
('Chris', 'Traeger', 'chris@outlook.com', 3125405678, '3208 Maple Court, Chicago, IL', 'H R Manager');


INSERT INTO Department (DepartmentName) 
VALUES 
('Cardiology'),
('Neurology'),
('Oncology'),
('Pediatrics'),
('Emergency'),
('Orthopedics'),
('Gastroenterology'),
('Dermatology'),
('Psychiatry'),
('Ophthalmology');


-- Create the Employee table
INSERT INTO Employee (FirstName, LastName, Position, DepartmentNumber, DateOfBirth, Email, ContactNumber, Address, HireDate, Salary, AdminID) 
VALUES 
('John', 'Doe', 'Doctor', 1, '1980-01-15', 'johndoe1@gmail.com', 2025550100, '100 Main St, Seattle, WA', '2010-05-12', 100000.00, 2),
('Emily', 'Brown', 'Nurse', 5, '1985-07-21', 'emilyb2@outlook.com', 3055550200, '200 Oak Ave, Miami, FL', '2011-07-19', 70000.00,3),
('Michael', 'Davis', 'Doctor', 2, '1978-03-10', 'michaeld3@icloud.com', 3125550300, '300 Pine St, Chicago, IL', '2012-03-22', 110000.00,2),
('Sarah', 'Wilson', 'Nurse', 6, '1989-09-05', 'sarahw4@gmail.com', 4155550400, '400 Maple Dr, San Francisco, CA', '2013-09-15', 68000.00,3),
('Robert', 'Miller', 'General', 7, '1992-12-10', 'robertm5@outlook.com', 2125550500, '500 Elm St, New York, NY', '2014-12-01', 50000.00,1)



INSERT INTO Doctor (DoctorID,EmployeeID, Specialization) 
VALUES 
(1, 1, 'Cardiology'),
(2, 2, 'Neurology'),
(3, 3, 'Pediatrics'),
(4, 4, 'Oncology'),
(5, 1, 'Orthopedics'),
(6,2,'General Surgery'),
(7,3,'Gastroenterology'),
(8,5,'Dermatology'),
(9,4, 'Psychiatry'),
(10,3,'Anesthesiology');



INSERT INTO Patient (
    DoctorID,FirstName, LastName, DOB, Gender, Address, 
    Phone,Email,EmergencyContactName, EmergencyContactPhone, InsuranceCompany, 
    InsurancePolicyNumber, MedicalHistorySummary, CurrentMedications
) VALUES 
(2,'Alice', 'Brown', '1984-02-15', 'F', '101 Main St, Orlando, FL', 321-654-0987,'alice.brown1@gmail.com',  'Bob Brown', 407-650-1234, 'HealthPlus', 'HP1234567890', 'No known allergies', 'None'),
(3,'Bob', 'Smith', '1979-06-24', 'M', '202 Maple Dr, Miami, FL',  305-710-2345,'bob.smith2@outlook.com', 'Sue Smith', 786-560-4321, 'MediCare', 'MC1234567891', 'Hypertension', 'Lisinopril'),
(10,'Carol', 'Johnson', '1991-10-12', 'F', '303 Oak Ln, New York, NY',212-820-3456, 'carol.johnson3@icloud.com',  'Gary Johnson', 646-780-5678, 'QuickHealth', 'QH1234567892', 'Asthma', 'Albuterol'),
(4,'David', 'Lee', '1988-03-08', 'M', '404 Pine Rd, Los Angeles, CA', 213-930-4567,'david.lee4@gmail.com',  'Jenny Lee', 310-990-6789, 'FamilyCare', 'FC1234567893', 'Diabetes', 'Metformin'),
(3,'Eva', 'Wilson', '1975-07-30', 'F', '505 Birch St, Chicago, IL', 312-540-5678,'eva.wilson5@outlook.com',  'Adam Wilson', 773-660-7890, 'HealthGuard', 'HG1234567894', 'Chronic pain', 'Ibuprofen')

---------------------------
INSERT INTO MedicalRecord (PatientID, DoctorID, VisitDate, Diagnosis) 
VALUES 
(6, 1, '2024-01-10', 'Acute Bronchitis'),
(7, 5, '2024-01-15', 'Gastroesophageal reflux disease'),
(9, 6,  '2024-01-20', 'Type 2 Diabetes Mellitus'),
(8, 8,  '2024-01-25', 'Hypertension'),
(10, 3,  '2024-01-30', 'Osteoarthritis')

-----------------------------------------

INSERT INTO Appointment (PatientID, DepartmentNumber, DateTime, Purpose, Status) 
VALUES 
(8,  1, '2024-03-15 09:00:00', 'Routine Checkup', 'Scheduled'),
(6, 2, '2024-03-16 10:00:00', 'Consultation', 'Scheduled'),
(7, 3, '2024-03-17 11:00:00', 'Follow-up', 'Scheduled'),
(9, 1, '2024-03-18 09:30:00', 'Vaccination', 'Scheduled'),
(10, 2, '2024-03-19 10:30:00', 'Diagnostic Test', 'Scheduled')
-----------------------------------------------

INSERT INTO ResourceManagement (ResourceType, ResourceName, Status, Location, AdminID) 
VALUES 
('Room', 'Operating Room A', 'Available', '1st Floor', 5),
('Bed', 'ICU Bed 12', 'Occupied', '2nd Floor ICU', 4),
('Equipment', 'MRI Scanner', 'Under Maintenance', 'Radiology Department', 3),
('Room', 'Recovery Room 5', 'Available', '1st Floor', 2),
('Vehicle', 'Ambulance V123', 'Available', 'Vehicle Bay', 1)

-------------------------------------------------------

INSERT INTO Nurse (EmployeeID, Shift, Qualifications) 
VALUES 
(3,'Day', 'Registered Nurse - BSN'),
(5,'Night', 'Registered Nurse - ADN')


-------------------------------------------
INSERT INTO GeneralStaff (EmployeeID, JobDescription, WorkHours) 
VALUES 
(5, 'Facilities Manager', '08:00-16:00')


