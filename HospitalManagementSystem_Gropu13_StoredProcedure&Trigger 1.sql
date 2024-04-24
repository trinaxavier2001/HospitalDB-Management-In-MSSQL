CREATE PROCEDURE AddNewPatient
    @DoctorID INT,
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @DOB DATE,
    @Gender CHAR(1),
    @Address NVARCHAR(255),
	@Phone NVARCHAR(15),
    @Email NVARCHAR(100),
    @EmergencyContactName NVARCHAR(100),
    @EmergencyContactPhone NVARCHAR(15),
    @InsuranceCompany NVARCHAR(50),
    @InsurancePolicyNumber NVARCHAR(50),
    @MedicalHistorySummary NVARCHAR(MAX),
    @CurrentMedications NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
 
    BEGIN TRY
        INSERT INTO Patient (DoctorID, FirstName, LastName, DOB, Gender, Address, Email, 
                             Phone, EmergencyContactName, EmergencyContactPhone, InsuranceCompany, 
                             InsurancePolicyNumber, MedicalHistorySummary, CurrentMedications)
        VALUES (@DoctorID, @FirstName, @LastName, @DOB, @Gender, @Address, @Email, 
                @Phone, @EmergencyContactName, @EmergencyContactPhone, @InsuranceCompany, 
                @InsurancePolicyNumber, @MedicalHistorySummary, @CurrentMedications)
    END TRY
    BEGIN CATCH
        -- Error handling here
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO

-- Create the trigger
CREATE TRIGGER trg_AddNewPatient
ON Patient
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the inserted DoctorID exists in the Doctors table
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        LEFT JOIN Doctor d ON i.DoctorID = d.DoctorID
        WHERE d.DoctorID IS NULL
    )
    BEGIN
        -- If DoctorID is invalid, rollback the transaction
        RAISERROR('Invalid DoctorID. Doctor does not exist.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
GO
---------------------------------------------------------
CREATE PROCEDURE AddNewEmployee
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Position NVARCHAR(50),
    @DepartmentNumber INT,
	@DateOfBirth DATE,
	@ContactNumber NVARCHAR(15),
    @Email NVARCHAR(100),
    @Address NVARCHAR(255),
    @HireDate DATE,
    @Salary DECIMAL(10, 2),
	@AdminID INT
AS
BEGIN
    SET NOCOUNT ON;
 
    BEGIN TRY
        INSERT INTO Employee (FirstName, LastName, Position, DepartmentNumber, DateOfBirth, 
                              ContactNumber, Email, Address, HireDate, Salary, AdminID)
        VALUES (@FirstName, @LastName, @Position, @DepartmentNumber,@DateOfBirth,
                @ContactNumber,@Email, @Address, @HireDate, @Salary, @AdminID)
    END TRY
    BEGIN CATCH
        -- Error handling here
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO


---------------------------------------------------

EXEC AddNewPatient
	@DoctorID = 2,
    @FirstName = 'John',
    @LastName = 'Doe',
    @DOB = '1975-05-05',
    @Gender = 'M',
    @Address = '123 Maple Street',
	@Phone = 5551234567,
    @Email = 'john.doe@example.com',
    @EmergencyContactName = 'Jane Doe',
    @EmergencyContactPhone = 5559876543,
    @InsuranceCompany = 'GreatInsurance',
    @InsurancePolicyNumber = 'G123456789',
    @MedicalHistorySummary = 'N/A',
    @CurrentMedications = 'None';

	----------------------

	EXEC AddNewEmployee
    @FirstName = 'Jane',
    @LastName = 'Smith',
    @Position = 'Nurse',
    @DepartmentNumber = 2,
	@DateOfBirth = '12-10-1998',
	@ContactNumber = 5552345678,
    @Email = 'jane.smith@example.com',
    @Address = '456 Oak Avenue',
    @HireDate = '2020-06-15',
    @Salary = 75000.00,
	@AdminID = 2;
