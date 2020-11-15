/* ********************************************************************************
		Copyright statement
		Author: Ramiro A. Pena
		File:	park_volunteers_final_project.sql
		DESCRIPTION:
			Builds the database and related tables for the Park Volunteers final project.
            
		Modification History
		Date modified - Who did it - what was modified
		2020-04-21	Ramiro A. Pena			Initial Creation
		
******************************************************************************** */
    
DROP DATABASE IF EXISTS parkvolunteers;
CREATE DATABASE parkvolunteers;
USE parkvolunteers;


/* ********************************************************************************
	CREATE TABLE Project
******************************************************************************** */

DROP TABLE IF EXISTS Project;
CREATE TABLE Project (
	Project_Number INT NOT NULL PRIMARY KEY COMMENT 'A key to find project data easily'
	, Date_And_Time_Created	DATETIME NOT NULL COMMENT 'Date and time a project record was created'
	, Employee_Hours INT NOT NULL COMMENT 'Number of hours concurrently that employees have worked on project'
	, Employees_Assigned INT NOT NULL COMMENT 'Number of concurrent employees assigned to project'
	, Hazardous	ENUM('Y','N') NOT NULL COMMENT 'To check if project may be hazardous for special precautions'
	, Personnel_Required INT NOT NULL COMMENT 'Estimated amount of personnel required to finish effectively'
	, Physically_Demanding ENUM('Y','N') NOT NULL COMMENT 'For special preperation and for employee/volunteer preference to avoid injury'
	, Volunteer_Hours INT NOT NULL COMMENT 'Number of concurrent volunteer hours'
	, Volunteers_Assigned INT NOT NULL COMMENT 'Number of concurrent volunteers assigned to project'
	, Working_Hours INT NOT NULL COMMENT 'Number of concurrent hours worked on project'
    , Project_Finished ENUM('Y','N') NOT NULL COMMENT 'Indicates whether this project has been finished or not.'
    , Date_And_Time_Finished DATETIME COMMENT 'Date when project was finished'	
) COMMENT 'A table that contains records for a new or ongoing project'
;

/* ********************************************************************************
	CREATE TABLE Project_Preferences
******************************************************************************** */

DROP TABLE IF EXISTS Project_Preferences;
CREATE TABLE Project_Preferences (
	Project_Number INT NOT NULL COMMENT 'A key to find project data easily specifically for preferences to assignement
	references Project.Project_Number where the Project is the actual name of the table and Project_Number'
	, Benefits_From VARCHAR(256) COMMENT 'A list of skills that a project can benefit from'
	, Medical_Limitations ENUM('Y','N') COMMENT 'A preference to avoid injury on a project'
	, Scheduling_Limitations ENUM('Y','N') COMMENT 'A preference to avoid scheduling issues on a project'
    , PRIMARY KEY (Project_Number)
    , CONSTRAINT fk_ProjectPreferencesProjectNumber_ProjectProjectNumber
		FOREIGN KEY (Project_Number) REFERENCES Project(Project_Number)
) COMMENT 'A table that contains preferences for a project'
;

/* ********************************************************************************
	CREATE TABLE Project_Updates
******************************************************************************** */

DROP TABLE IF EXISTS Project_Updates;
CREATE TABLE Project_Updates (
	Date_And_Time_Of_Change	DATETIME NOT NULL COMMENT 'Date and time of why a project was updated'
    , Description_Of_Change	VARCHAR(256) NOT NULL COMMENT 'Description of why project data was changed'
    , Maintenance_Manager_Identifier VARCHAR(256) NOT NULL COMMENT 'A key attached to the maintenance manager who changed the records of a project'
    , Project_Number INT NOT NULL COMMENT 'Project number attached to project affected'
    , Date_And_Time_Finished DATETIME NOT NULL COMMENT 'Changes this when project is finished'
    , Employee_Hours INT NOT NULL COMMENT 'Employee hours changed'
    , Employees_Assigned INT NOT NULL COMMENT 'Employees assigned changed'
    , Hazardous ENUM('Y','N') NOT NULL COMMENT 'Changed s whetehr project is hazardous or not'
    , Personnel_Required INT NOT NULL COMMENT 'Changes if personnel required changes'
    , Physically_Demanding ENUM('Y','N') NOT NULL COMMENT 'Changes whether project is physically demanding or not'
    , Project_Finished ENUM('Y','N') NOT NULL COMMENT 'Changes if project is finished or not'
    , Volunteer_Hours INT NOT NULL COMMENT 'Updates volunteer logged hours'
    , Volunteers_Assigned INT NOT NULL COMMENT 'Updates volunteers assigned'
    , Working_Hours INT NOT NULL COMMENT 'Updates total working hours'
) COMMENT 'A table to track changes for the project records'
;

/* ********************************************************************************
	CREATE TABLE Employee
******************************************************************************** */

DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
	Employee_ID INT NOT NULL PRIMARY KEY COMMENT 'A key to find employee data easily'
	, Address VARCHAR(256) COMMENT 'The address for an employee'
	, Assigned_To_A_Project	ENUM('Y','N') NOT NULL COMMENT 'Check if the employee is assigned to a project defualt is no at record created, Maintenace manager will change this when assigning to projects'
	, Date_And_Time_Of_Assignment DATETIME COMMENT 'Date and time of project assignment'
	, Email_Address	VARCHAR(256) COMMENT 'An Email Address to contact the employee'
	, Employee_Name	VARCHAR(256) NOT NULL COMMENT 'The name of the employee'
	, Primary_Phone	CHAR(10) COMMENT 'A phone number to contact the employee'
	, Project_Number INT COMMENT 'The project number an employee is assigned to by maintenance manager
	references Project.Project_Number where the Project is the actual name of the table and Project_Number'
	, Skills VARCHAR(256) COMMENT 'Any skills an employee might have that could benefit a project'
	, CONSTRAINT fk_EmployeeProjectNumber_ProjectProjectNumber
		FOREIGN KEY (Project_Number) REFERENCES Project(Project_Number)
) COMMENT 'Represents a complete Employee record'
;

/* ********************************************************************************
	CREATE TABLE Employee_Emergency
******************************************************************************** */

DROP TABLE IF EXISTS Employee_Emergency;
CREATE TABLE Employee_Emergency (
	Employee_ID INT NOT NULL COMMENT 'A key to find employee data easily that is used to find emergency contact information 
	references Employee.Employee_ID where the Employee is the actual name of the table and Employee_ID'
	, Emergency_Contact_Email VARCHAR(256) COMMENT 'An email for emergency contact'
	, Emergency_Contact_Name VARCHAR(256) NOT NULL COMMENT 'A name for an emergency contact'
	, Emergency_Contact_Phone CHAR(10) COMMENT 'A phone number to contact the employees emergency contact'
    , PRIMARY KEY (Employee_ID)
    , CONSTRAINT fk_EmployeeEmergencyEmployeeID_EmployeeEmployeeID
		FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
) COMMENT 'Represents a complete Employee emergency contact record'
;

/* ********************************************************************************
	CREATE TABLE Employee_Medical
******************************************************************************** */

DROP TABLE IF EXISTS Employee_Medical;
CREATE TABLE Employee_Medical (
	Employee_ID INT NOT NULL COMMENT 'A key to find employee data easily specifically for medical records
	references Employee.Employee_ID where the Employee is the actual name of the table and Employee_ID'
	, Allergies	VARCHAR(256) COMMENT 'Any allergies and employee might have'
	, Physical_Disabilities	ENUM('Y','N') NOT NULL COMMENT 'To check for physical limitations for future project assignment'
    , PRIMARY KEY (Employee_ID)
    , CONSTRAINT fk_EmployeeMedicalEmployeeID_EmployeeEmployeeID
		FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
) COMMENT 'Represents a collection of Emloyee medical records'
;

/* ********************************************************************************
	CREATE TABLE Employee_Scheduling
******************************************************************************** */

DROP TABLE IF EXISTS Employee_Scheduling;
CREATE TABLE Employee_Scheduling (
	Employee_ID	INT NOT NULL COMMENT 'A key to find employee data easily specifically for scheduling
	references Employee.Employee_ID where the Employee is the actual name of the table and Employee_ID'
    , Part_Time	ENUM('Y','N') NOT NULL COMMENT 'To find if the employee is part time or not for project assignments'
    , Weekend_Availability ENUM('Y','N') NOT NULL COMMENT 'If they are available for project assignments'
    , PRIMARY KEY (Employee_ID)
    , CONSTRAINT fk_EmployeeSchedulingEmployeeID_EmployeeEmployeeID
		FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
) COMMENT 'Represents a collection of Emloyee Scheduling limitation records'
;


/* ********************************************************************************
	CREATE TABLE Employee_Updates
******************************************************************************** */

DROP TABLE IF EXISTS Employee_Updates;
CREATE TABLE Employee_Updates (
	Date_And_Time_Of_Change DATETIME NOT NULL COMMENT 'Date and time of changes to employee records'
    , Description_Of_Change VARCHAR(256) NOT NULL COMMENT 'A description for why an employees record was changed'
    , Park_Manager_Identifier VARCHAR(256) COMMENT 'The key attached to the Park manager that changed the employees contact name and medical records etc.'
    , Employee_ID INT NOT NULL COMMENT 'ID attached to the employee affected'
    , Address VARCHAR(256) COMMENT 'Address that was updated in the employee table'
    , Email_Address VARCHAR(256) COMMENT 'Email address updated in the employee table'
    , Primary_Phone CHAR(10) COMMENT 'Primary phone eupdated in the employee table'
    , Skills VARCHAR(256) COMMENT 'Skills updated in the employee table'
) COMMENT 'A table to track changes for the Employee records at the Park Manager level'
;

/* ********************************************************************************
	CREATE TABLE Employee_Task_Updates
******************************************************************************** */

DROP TABLE IF EXISTS Employee_Task_Updates;
CREATE TABLE Employee_Task_Updates (
	Date_And_Time_Of_Change	DATETIME NOT NULL COMMENT 'Date and time of changes to employee records'
	, Description_Of_Change	VARCHAR(256) NOT NULL COMMENT 'A description for why an employees record was changed'
	, Maintenance_Manager_Identifier VARCHAR(256) NOT NULL COMMENT 'The key attached to the maintenance manager who changed the records of a employee for task assignment'
    , Employee_ID INT NOT NULL COMMENT 'ID attached to the employee affected'
	, Project_Number INT COMMENT 'Project Number ID to symobolize ''Task'' assignment'
	, Date_And_Time_Of_Assignment DATETIME COMMENT 'Date and time of assignment'
	, Assigned_To_A_Project	ENUM('Y','N') NOT NULL COMMENT 'Changed when employee is assigned to a project'
) COMMENT 'A table to track changes for the Employee records by the Maintenance manager for purpose of task assignment or updates'
;

/* ********************************************************************************
	CREATE TABLE Volunteer
******************************************************************************** */

DROP TABLE IF EXISTS Volunteer;
CREATE TABLE Volunteer (
	Volunteer_ID INT NOT NULL PRIMARY KEY COMMENT 'A key to find volunteer data easily'
    , Address VARCHAR(256) COMMENT 'Address provided by a volunteer'
    , Assigned_To_A_Project ENUM('Y','N') NOT NULL COMMENT 'Check if the volunteer is currently assigned to a project default is no at record created, Maintenace manager will change this when assigning to projects'
    , Date_And_Time_Of_Assignment DATETIME COMMENT 'Date and time of assignment made by mainteneance manager'
    , Email_Address VARCHAR(256) COMMENT 'Email provided by volunteer'
    , Primary_Phone CHAR(10) COMMENT 'A primary phone provided by volunteer for contact'
    , Project_Number INT COMMENT 'Project number assigned to volunteer by maintenace manager
	references Project.Project_Number where the Project is the actual name of the table and Project_Number'
    , Skills VARCHAR(256) COMMENT 'Any skills a volunteer might have to benefit specific projects'
    , Volunteer_Name VARCHAR(256) NOT NULL COMMENT 'The name of the volunteer'
    , CONSTRAINT fk_VolunteerProjectNumber_ProjectProjectNumber
		FOREIGN KEY (Project_Number) REFERENCES Project(Project_Number)
) COMMENT 'Represents a complete Volunteer record'
;

/* ********************************************************************************
	CREATE TABLE Volunteer_Emergency
******************************************************************************** */

DROP TABLE IF EXISTS Volunteer_Emergency;
CREATE TABLE Volunteer_Emergency (
	Volunteer_ID INT NOT NULL COMMENT 'The associated volunteer key to find emergency contact information easily
	references Volunteer.Volunteer_ID where the Volunteer is the actual name of the table and Volunteer_ID'
    , Emergency_Contact_Email VARCHAR(256) COMMENT 'The email of the emergency contact to contact'
    , Emergency_Contact_Name VARCHAR(256) NOT NULL COMMENT 'The name of the emergency contact'
    , Emergency_Contact_Phone CHAR(10) COMMENT 'The phone number for an emergency contact of the volunteer'
    , PRIMARY KEY (Volunteer_ID)
    , CONSTRAINT fk_VolunteerEmergencyVolunteerID_VolunteerVolunteerID
		FOREIGN KEY (Volunteer_ID) REFERENCES Volunteer(Volunteer_ID)
) COMMENT 'Represents a complete Volunteer emergency contact record'
;

/* ********************************************************************************
	CREATE TABLE Volunteer_Medical
******************************************************************************** */

DROP TABLE IF EXISTS Volunteer_Medical;
CREATE TABLE Volunteer_Medical (
	Volunteer_ID INT NOT NULL COMMENT 'The volunteers id key to easily find medical records
	references Volunteer.Volunteer_ID where the Volunteer is the actual name of the table and Volunteer_ID'
	, Allergies VARCHAR(256) COMMENT 'Any allergies a volunteer might have for project assignment'
	, Physical_Disabilities ENUM('Y','N') NOT NULL COMMENT 'To avoid injury of volunteer for project assignment'
    , PRIMARY KEY (Volunteer_ID)
    , CONSTRAINT fk_VolunteerMedicalVolunteerID_VolunteerVolunteerID
		FOREIGN KEY (Volunteer_ID) REFERENCES Volunteer(Volunteer_ID)
) COMMENT 'Represents a collection of Volunteer medical records'
;


/* ********************************************************************************
	CREATE TABLE Volunteer_Scheduling
******************************************************************************** */

DROP TABLE IF EXISTS Volunteer_Scheduling;
CREATE TABLE  Volunteer_Scheduling (
	Volunteer_ID INT NOT NULL COMMENT 'The volunteers id to easily find scheduling limitations attached to them
	references Volunteer.Volunteer_ID where the Volunteer is the actual name of the table and Volunteer_ID'
    , Part_Time ENUM('Y','N') NOT NULL COMMENT 'To check if this volunteer is part time for scheduling preferences'
    , Weekend_Availability ENUM('Y','N') NOT NULL COMMENT 'To check if the volunteer is available on the weekends for project assignment'
    , PRIMARY KEY (Volunteer_ID)
    , CONSTRAINT fk_VolunteerSchedulingVolunteerID_VolunteerVolunteerID
		FOREIGN KEY (Volunteer_ID) REFERENCES Volunteer(Volunteer_ID)
) COMMENT 'Represents a collection of Volunteer Scheduling limitation records'
;

/* ********************************************************************************
	CREATE TABLE Volunteer_Updates
******************************************************************************** */

DROP TABLE IF EXISTS Volunteer_Updates;
CREATE TABLE Volunteer_Updates (
	Date_And_Time_Of_Change DATETIME NOT NULL COMMENT 'Date and time of changes to volunteer records'
    , Description_Of_Change VARCHAR(256) NOT NULL COMMENT 'A description for why an volunteer record was changed'
    , Park_Manager_Identifier VARCHAR(256) NOT NULL COMMENT 'The key attached to the Park manager that changed the volunteers contact name and medical records etc.'
    , Volunteer_ID INT NOT NULL COMMENT 'ID attached to the volunteer affected'
    , Address VARCHAR(256) COMMENT 'Address that was updated in the volunteer table'
    , Email_Address VARCHAR(256) COMMENT 'Email address updated in the volunteer table'
    , Primary_Phone CHAR(10) COMMENT 'Primary phone eupdated in the volunteer table'
    , Skills VARCHAR(256) COMMENT 'Skills updated in the volunteer table'
) COMMENT 'A table to track changes for the Volunteer records at the Park Manager level'
;

/* ********************************************************************************
	CREATE TABLE Volunteer_Task_Updates
******************************************************************************** */

DROP TABLE IF EXISTS Volunteer_Task_Updates;
CREATE TABLE Volunteer_Task_Updates (
	Date_And_Time_Of_Change	DATETIME NOT NULL COMMENT 'Date and time of changes to volunteer records'
	, Description_Of_Change	VARCHAR(256) NOT NULL COMMENT 'A description for why an volunteer record was changed'
	, Maintenance_Manager_Identifier VARCHAR(256) NOT NULL COMMENT 'The key attached to the maintenance manager who changed the records of a employee for task assignment'
    , Volunteer_ID INT NOT NULL COMMENT 'ID attached to the volunteer affected'
	, Project_Number INT COMMENT 'Project Number ID to symobolize ''Task'' assignment'
	, Date_And_Time_Of_Assignment DATETIME COMMENT 'Date and time of assignment'
	, Assigned_To_A_Project	ENUM('Y','N') NOT NULL COMMENT 'Changed when volunteer is assigned to a project'
) COMMENT 'A table to track changes for the Volunteer records by the Maintenance manager for purpose of task assignment or updates'
;

/* ********************************************************************************
	STORED PROCEDURE sp_insert_new_project
******************************************************************************** */

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_insert_new_project$$
CREATE PROCEDURE sp_insert_new_project(IN p_Project_Number INT
	, IN p_Date_And_Time_Created DATETIME
	, IN p_Employee_Hours INT
	, IN p_Employees_Assigned INT
	, IN p_Hazardous ENUM('Y','N')
	, IN p_Personnel_Required INT
	, IN p_Physically_Demanding ENUM('Y','N')
	, IN p_Volunteer_Hours INT
	, IN p_Volunteers_Assigned INT
	, IN p_Working_Hours INT 
    , IN p_Project_Finished ENUM('Y','N')
    , IN p_Date_And_Time_Finished DATETIME
)
COMMENT 'This procedure will insert a new project'
BEGIN	

	-- exit if duplicate key
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
 	SELECT CONCAT('Cannot create duplicate key (',p_Project_Number,'), Please change Project_Number Value!') AS message;
    END;
    
	INSERT INTO Project(
		Project_Number
        , Date_And_Time_Created
        , Employee_Hours
        , Employees_Assigned
		, Hazardous
		, Personnel_Required
		, Physically_Demanding
		, Volunteer_Hours
		, Volunteers_Assigned
		, Working_Hours
		, Project_Finished
        , Date_And_Time_Finished
	) VALUES(
		p_Project_Number
		, p_Date_And_Time_Created
		, p_Employee_Hours
		, p_Employees_Assigned
		, p_Hazardous
		, p_Personnel_Required
		, p_Physically_Demanding
		, p_Volunteer_Hours
		, p_Volunteers_Assigned
		, p_Working_Hours
		, p_Project_Finished
        , p_Date_And_Time_Finished
	)
    ;
            
END$$
DELIMITER ;

-- Call the stored procedure
CALL sp_insert_new_project(1, NOW(), 0, 0, 'N', 4, 'Y', 0, 0, 0, 'Y', NOW());
CALL sp_insert_new_project(2, NOW(), 0, 0, 'N', 4, 'Y', 0, 0, 0, 'N', NULL);

SELECT *
FROM Project
;


/* ********************************************************************************
	CREATE VIEW vw_projects_need_done_report
******************************************************************************** */

CREATE VIEW vw_projects_need_done_report
AS 
SELECT 
	Project_Number
	, Date_And_Time_Created
	, Employee_Hours
	, Employees_Assigned
	, Hazardous
	, Personnel_Required
	, Physically_Demanding
	, Volunteer_Hours
	, Volunteers_Assigned
	, Working_Hours
FROM
    Project
WHERE Project_Finished = 2
ORDER BY Project_Number ASC
;

SELECT * 
FROM parkvolunteers.vw_projects_need_done_report
;

/* ********************************************************************************
	CREATE VIEW vw_projects_accomplished_report
******************************************************************************** */

CREATE VIEW vw_projects_accomplished_report 
AS 
SELECT 
	Project_Number
	, Date_And_Time_Created
	, Employee_Hours
	, Employees_Assigned
	, Personnel_Required
	, Physically_Demanding
	, Volunteer_Hours
	, Volunteers_Assigned
	, Working_Hours
	, Date_And_Time_Finished
FROM
    Project
WHERE Project_Finished = 1
ORDER BY Project_Number ASC
;

SELECT * 
FROM parkvolunteers.vw_projects_accomplished_report 
;

/* ********************************************************************************
	STORED PROCEDURE sp_insert_project_preferences
******************************************************************************** */

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_insert_project_preferences$$
CREATE PROCEDURE sp_insert_project_preferences(
	p_Project_Number INT
	, p_Benefits_From VARCHAR(256)
	, p_Medical_Limitations ENUM('Y','N')
	, p_Scheduling_Limitations ENUM('Y','N')
)
COMMENT 'This procedure will create project preferences for a project.'
BEGIN
	
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SELECT CONCAT('Key number (',p_Project_Number,'), Does not exist in table!') AS message;
	END;
        
    -- exit if duplicate key
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
		SELECT CONCAT('Cannot create duplicate key (',p_Project_Number,'), Please change Project_Number Value!') AS message;
    END;

	INSERT INTO Project_Preferences(
		Project_Number
		, Benefits_From
		, Medical_Limitations
		, Scheduling_Limitations
	) VALUES(
		p_Project_Number
		, p_Benefits_From
		, p_Medical_Limitations
		, p_Scheduling_Limitations
	)
    ;
            
END$$
DELIMITER ;

-- Call the stored procedure
CALL sp_insert_project_preferences(1, 'Has a strong back.', 'N', 'N');

SELECT *
FROM Project_Preferences
WHERE Project_Number = 1
;


/* ********************************************************************************
	STORED PROCEDURE sp_insert_volunteer
******************************************************************************** */

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_insert_volunteer$$
CREATE PROCEDURE sp_insert_volunteer(
	p_Volunteer_ID INT
    , p_Address VARCHAR(256)
    , p_Assigned_To_A_Project ENUM('Y','N')
    , p_Date_And_Time_Of_Assignment DATETIME
    , p_Email_Address VARCHAR(256)
    , p_Primary_Phone CHAR(10)
    , p_Project_Number INT
    , p_Skills VARCHAR(256)
    , p_Volunteer_Name VARCHAR(256)
)
COMMENT 'This procedure will create a volunteer'
BEGIN	
     	
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SELECT CONCAT('Key number (',p_Project_Number,'), Does not exist in table!') AS message;
	END;
    
     -- exit if duplicate key
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
 	SELECT CONCAT('Cannot create duplicate key (',p_Volunteer_ID,'), Please change Volunteer_ID Value!') AS message;
    END;
    
	INSERT INTO Volunteer(
		Volunteer_ID
		, Address
		, Assigned_To_A_Project
		, Date_And_Time_Of_Assignment
		, Email_Address
		, Primary_Phone
		, Project_Number
		, Skills
		, Volunteer_Name
	) VALUES(
		p_Volunteer_ID
		, p_Address
		, p_Assigned_To_A_Project
		, p_Date_And_Time_Of_Assignment
		, p_Email_Address
		, p_Primary_Phone
		, p_Project_Number
		, p_Skills
		, p_Volunteer_Name
	)
    ;
            
END$$
DELIMITER ;

-- Call the stored procedure
CALL sp_insert_volunteer(1, '3030, Cedar Street, SomeTown, Michigan', 'N', NULL, NULL, '1787878888', NULL, NULL, 'Billy Joel');

SELECT *
FROM Volunteer
;

/* ********************************************************************************
	STORED PROCEDURE sp_insert_employee
******************************************************************************** */

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_insert_employee$$
CREATE PROCEDURE sp_insert_employee(
	p_Employee_ID INT
	, p_Address VARCHAR(256)
	, p_Assigned_To_A_Project	ENUM('Y','N')
	, p_Date_And_Time_Of_Assignment DATETIME
	, p_Email_Address	VARCHAR(256)
	, p_Employee_Name	VARCHAR(256)
	, p_Primary_Phone	CHAR(10)
	, p_Project_Number INT
	, p_Skills VARCHAR(256)
)
COMMENT 'This procedure will create a employee'
BEGIN	
	
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SELECT CONCAT('Key number (',p_Project_Number,'), Does not exist in table!') AS message;
	END;
    
    -- exit if duplicate key
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
 	SELECT CONCAT('Cannot create duplicate key (',p_Employee_ID,'), Please change Employee_ID Value!') AS message;
    END;
    
	INSERT INTO Employee(
	Employee_ID
	, Address
	, Assigned_To_A_Project
	, Date_And_Time_Of_Assignment
	, Email_Address
	, Employee_Name
	, Primary_Phone
	, Project_Number
	, Skills
	) VALUES(
	p_Employee_ID
	, p_Address
	, p_Assigned_To_A_Project
	, p_Date_And_Time_Of_Assignment
	, p_Email_Address
	, p_Employee_Name
	, p_Primary_Phone
	, p_Project_Number
	, p_Skills
	)
    ;
            
END$$
DELIMITER ;

-- Call the stored procedure
CALL sp_insert_employee(1, '0303, Maple Street, SomeTown, Michigan', 'N', NULL, NULL, 'Ralph Waldo', '1878787999', NULL, NULL);

SELECT *
FROM Employee
;

/* ********************************************************************************
	CREATE TRIGGER tr_employee_update
******************************************************************************** */
DELIMITER $$
DROP TRIGGER IF EXISTS tr_employee_update$$
CREATE TRIGGER tr_employee_update
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN

	-- Create Variables
    
    DECLARE var_Date_And_Time_Of_Change DATETIME;
    DECLARE var_Description_Of_Change VARCHAR(256);
    DECLARE var_Park_Manager_Identifier VARCHAR(256);
    
    SET var_Date_And_Time_Of_Change = NOW();
    SET var_Description_Of_Change = 'UPDATE';
    SET var_Park_Manager_Identifier = current_user();
    
    -- INSERT the data
    INSERT INTO employee_updates(
		Date_And_Time_Of_Change
		, Description_Of_Change
		, Park_Manager_Identifier
        , Employee_ID 
        , Address 
        , Email_Address 
        , Primary_Phone 
        , Skills
    ) VALUES (
		var_Date_And_Time_Of_Change
        , var_Description_Of_Change
        , var_Park_Manager_Identifier
        , OLD.employee_id 
        , OLD.address 
        , OLD.Email_Address 
        , OLD.Primary_Phone 
        , OLD.Skills
    )
    ;

END$$
DELIMITER ;


UPDATE Employee
SET Address = NULL
WHERE Employee_ID = 1
;

SELECT *
FROM employee_updates
;

/* ********************************************************************************
	CREATE TRIGGER tr_employee_delete
******************************************************************************** */
DELIMITER $$
DROP TRIGGER IF EXISTS tr_employee_update$$
CREATE TRIGGER tr_employee_update
AFTER DELETE ON Employee
FOR EACH ROW
BEGIN

	-- Create Variables
    
    DECLARE var_Date_And_Time_Of_Change DATETIME;
    DECLARE var_Description_Of_Change VARCHAR(256);
    DECLARE var_Park_Manager_Identifier VARCHAR(256);
    
    SET var_Date_And_Time_Of_Change = NOW();
    SET var_Description_Of_Change = 'DELETE';
    SET var_Park_Manager_Identifier = current_user();
    
    -- INSERT the data
    INSERT INTO employee_updates(
		Date_And_Time_Of_Change
		, Description_Of_Change
		, Park_Manager_Identifier
        , Employee_ID 
        , Address 
        , Email_Address 
        , Primary_Phone 
        , Skills
    ) VALUES (
		var_Date_And_Time_Of_Change
        , var_Description_Of_Change
        , var_Park_Manager_Identifier
        , OLD.employee_id 
        , OLD.address 
        , OLD.Email_Address 
        , OLD.Primary_Phone 
        , OLD.Skills
    )
    ;

END$$
DELIMITER ;

DELETE FROM Employee
WHERE Employee_ID = 1
;

SELECT *
FROM employee_updates
;
