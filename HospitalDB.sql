-- TASK 1
drop database if exists HospitalDB;
create database HospitalDB;
use HospitalDB;

-- STAFF
create table Staff (
    Employee_No varchar(10) primary key,
    Initial varchar(100) not null,
    Surname varchar(100) not null,
    Gender varchar(10) check (Gender in ('Male','Female')),
    Address varchar(150),
    Telephone_No varchar(20) unique,
    Role enum('Doctor','Nurse','Surgeon') not null
);

-- DOCTOR
create table Doctor (
    Employee_No varchar(10) primary key,
    Monthly_Salary decimal(10,2) check (Monthly_Salary > 0),
    foreign key (Employee_No) references Staff(Employee_No)  
);

-- HEAD DOCTOR
create table Head_Doctor (
    Employee_No varchar(10) primary key,
    foreign key (Employee_No) references Doctor(Employee_No)
);

-- HEAD DOCTOR MONITORING DOCTOR (weak relation)
create table Head_Doctor_Monitor (
    HD_Employee_No varchar(10),
    Doctor_Employee_No varchar(10),
    primary key (HD_Employee_No, Doctor_Employee_No),
    foreign key (HD_Employee_No) references Head_Doctor(Employee_No),
    foreign key (Doctor_Employee_No) references Doctor(Employee_No)
);

-- NURSE
create table Nurse (
    Employee_No varchar(10) primary key,
    Grade varchar(50) not null,
    Surgery_Skill_Type varchar(100),
    Years_of_Experience int check (Years_of_Experience >= 0),
    Monthly_Salary decimal(10,2) check (Monthly_Salary > 0),
    foreign key (Employee_No) references Staff(Employee_No)
);

-- SURGEON
create table Surgeon (
    Employee_No varchar(10) primary key,
    Specialty varchar(100) not null,
    Type_of_Contract varchar(100),
    Length_of_Contract varchar(50),
    foreign key (Employee_No) references Staff(Employee_No)
);

-- ALLERGY TABLE
create table Allergy (
    Allergy_ID varchar(10) primary key,
    Name varchar(100) not null unique
);

-- LOCATION
create table Location (
    Location_ID varchar(10) primary key,
    Nursing_Unit varchar(50),
    Bed_No varchar(10),
    Room_No varchar(10),
    Date date not null,
    Time time not null
);

-- PATIENT
create table Patient (
    Patient_ID varchar(10) primary key,
    Initial varchar(100) not null,
    Surname varchar(100) not null,
    Age int check (Age > 0),
    Address varchar(150),
    Telephone_No varchar(20) unique,
    Blood_Type varchar(10),
    Allergy_ID varchar(10),
    Location_ID varchar(10),
    foreign key (Allergy_ID) references Allergy(Allergy_ID),
    foreign key (Location_ID) references Location(Location_ID)
);

-- MEDICATION
create table Medication (
    Medication_Code varchar(10) primary key,
    Name varchar(100) not null,
    Quantity_On_Hand int check (Quantity_On_Hand >= 0),
    Expiration_Date date,
    Cost decimal(10,2) check (Cost >= 0)
);

-- PATIENT_MEDICATION (M:N)
create table Patient_Medication (
    Patient_ID varchar(10),
    Medication_Code varchar(10),
    Severity varchar(50) check (Severity in ('Low','Medium','High')),
    Quantity_Ordered int check (Quantity_Ordered > 0),
    primary key (Patient_ID, Medication_Code),
    foreign key (Patient_ID) references Patient(Patient_ID),
    foreign key (Medication_Code) references Medication(Medication_Code)
);

-- SURGERY
create table Surgery (
    Surgery_ID varchar(10) primary key,
    Surgery_Name varchar(100) not null,
    Patient_ID varchar(10),
    Date date not null,
    Time time not null,
    Theatre varchar(50),
    Special_Needs varchar(200),
    Category varchar(50) check (Category in ('Minor','Major','Critical')),
    foreign key (Patient_ID) references Patient(Patient_ID)
);

-- PERFORM (SURGEON 1—M SURGERIES)
create table Perform (
    Employee_No varchar(10),
    Surgery_ID varchar(10),
    primary key (Employee_No, Surgery_ID),
    foreign key (Employee_No) references Surgeon(Employee_No),
    foreign key (Surgery_ID) references Surgery(Surgery_ID)
);

-- SURGERY_NURSE
create table Surgery_Nurse (
    Surgery_ID varchar(10),
    Employee_No VARCHAR(10),
    primary key (Surgery_ID, Employee_No),
    foreign key (Surgery_ID) references Surgery(Surgery_ID),
    foreign key (Employee_No) references Nurse(Employee_No)
);

-- TASK 2

-- STAFF
insert into Staff values
('ST001', 'A.B.', 'Perera','Male','Colombo','0771234567','Doctor'),
('ST002', 'N.M.', 'Silva','Female','Kandy','0779876543','Doctor'),
('ST003', 'K.D.', 'Jayasuriya','Male','Galle','0714567890','Doctor'),
('ST004', 'S.S.', 'Fernando','Female','Kurunegala','0751122334','Nurse'),
('ST005', 'A.R.', 'Silva','Male','Negombo','0709988776','Nurse'),
('ST006', 'P.B.', 'Jayaweera','Male','Matara','0766655443','Surgeon'),
('ST007', 'D.P.', 'Kodithuwkku','Female','Jaffna','0728899001','Surgeon');

-- Show all STAFF records
select * from Staff;

-- DOCTOR
insert into Doctor values
('ST001',150000.00),
('ST002',145000.00),
('ST003',160000.00);

-- Show all DOCTOR records
select * from Doctor;

-- HEAD DOCTOR
insert into Head_Doctor values
('ST001'),
('ST003');

-- Show all HEAD DOCTOR records
select * from Head_Doctor;

-- HEAD DOCTOR MONITOR
insert into Head_Doctor_Monitor values
('ST001','ST002'),
('ST001','ST003'),
('ST003','ST001'),
('ST003','ST002');

-- Show all HEAD DOCTOR MONITOR records
select * from Head_Doctor_Monitor;

-- NURSE
insert into Nurse values
('ST004','Grade A','High',5,85000.00),
('ST005','Grade B','Medium',3,65000.00);

-- Show all NURSE records
select * from Nurse;

-- SURGEON
insert into Surgeon values
('ST006','Cardiac Surgery','Full-time','2 years'),
('ST007','Neuro Surgery','Contract','1 year');

-- Show all SURGEON records
select * from Surgeon;

-- ALLERGY
insert into Allergy values
('AL001','None'),
('AL002','Peanuts'),
('AL003','Dust'),
('AL004','Seafood'),
('AL005','Pollen');

-- Show all ALLERGY records
select * from Allergy;

-- LOCATION
insert into Location values
('L001','North Wing','B12','R101','2025-01-20','10:00:00'),
('L002','South Wing','B09','R102','2025-01-22','09:30:00'),
('L003','East Wing','B05','R201','2025-01-25','08:15:00'),
('L004','West Wing','B14','R103','2025-01-28','11:45:00'),
('L005','North Wing','B07','R202','2025-02-01','14:10:00');

-- Show all LOCATION records
select * from Location;

-- PATIENT
insert into Patient values
('PT001', 'S.P.', 'Perera',25,'Colombo','0771112223','A+','AL001','L001'),
('PT002', 'N.K.', 'Kumari',30,'Kandy','0772223334','B+','AL003','L002'),
('PT003', 'M.P.', 'Jayasuriya',40,'Galle','0713334445','O-','AL002','L003'),
('PT004', 'A.', 'Fernando',28,'Negombo','0704445556','AB+','AL005','L004'),
('PT005', 'T.N.', 'Dissanayake',22,'Matara','0755556667','A-','AL004','L005');

-- Show all PATIENT records
select * from Patient;

-- MEDICATION
insert into Medication values
('MD001','Amoxicillin',200,'2026-01-10',50.00),
('MD002','Paracetamol',500,'2027-05-12',10.00),
('MD003','Cetirizine',300,'2026-11-05',15.00),
('MD004','Insulin',100,'2026-03-30',120.00),
('MD005','Aspirin',450,'2027-02-21',30.00);

-- Show all MEDICATION records
select * from Medication;

-- PATIENT_MEDICATION
insert into Patient_Medication values
('PT001','MD001','High',2),
('PT002','MD003','Medium',1),
('PT003','MD005','Low',3),
('PT004','MD002','Medium',1),
('PT005','MD004','High',2);

-- Show all PATIENT_MEDICATION records
select * from Patient_Medication;

-- SURGERY
insert into Surgery values
('SG001','Heart Bypass','PT001','2025-03-01','09:00:00','T1','Ventilator','Critical'),
('SG002','Brain Tumor Removal','PT002','2025-03-03','10:30:00','T2','ICU','Critical'),
('SG003','Bone Fixation','PT003','2025-03-05','11:15:00','T3','X-Ray','Major'),
('SG004','Skin Graft','PT004','2025-03-07','12:45:00','T4','Extra Lighting','Minor'),
('SG005','Appendix Removal','PT005','2025-03-09','08:20:00','T5','Basic Tools','Major');

-- Show all SURGERY records
select * from Surgery;

-- PERFORM
insert into Perform values
('ST006','SG001'),
('ST007','SG002'),
('ST006','SG003'),
('ST007','SG004'),
('ST006','SG005');

-- Show all PERFORM records
select * from Perform;

-- SURGERY_NURSE
insert into Surgery_Nurse values
('SG001','ST004'),
('SG002','ST005'),
('SG003','ST004'),
('SG004','ST005'),
('SG005','ST004');

-- Show all SURGERY_NURSE records
select * from Surgery_Nurse;