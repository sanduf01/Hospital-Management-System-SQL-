-- Mini Project SQL Script
-- Registration Number: 523607238

use HospitalDB;

-- <Q1 – 523607238>

-- Create view to display patient and surgery information
create view PatientSurgeryView as
select 
    p.Patient_ID as 'Patient_ID',
    concat(p.Initial, ' ', p.Surname) as 'Patient_Name',
    concat(l.Bed_No, ' - ', l.Room_No) as 'Location',
    s.Surgery_Name as 'Surgery_Name',
    s.Date as 'Surgery_Date'
from Patient p
join Location l on p.Location_ID = l.Location_ID
join Surgery s on p.Patient_ID = s.Patient_ID;

-- Test the view
select * from PatientSurgeryView;

-- <Q2 – 523607238>

-- create MedInfo table
create table MedInfo (
    MedName varchar(100) primary key,
    QuantityAvailable int check (QuantityAvailable >= 0),
    ExpirationDate date
);

-- i. Create trigger for insert operation
delimiter $$
create trigger after_medication_insert 
after insert on Medication 
for each row
begin
    insert into MedInfo (MedName, QuantityAvailable, ExpirationDate)
    values (new.Name, new.Quantity_On_Hand, new.Expiration_Date);
end$$
delimiter ;

-- Test insert trigger
insert into Medication values 
('MD006', 'Ibuprofen', 150, '2025-12-31', 25.00);

-- Check MedInfo table after insert
select * from MedInfo;

-- ii. Create trigger for update operation
delimiter $$
create trigger after_medication_update 
after update on Medication 
for each row
begin
    update MedInfo 
    set QuantityAvailable = new.Quantity_On_Hand,
        ExpirationDate = new.Expiration_Date
    where MedName = old.Name;
end$$
delimiter ;

-- Test update trigger
update Medication 
set Quantity_On_Hand = 300, Expiration_Date = '2026-12-31'
where Medication_Code = 'MD006';

-- Check MedInfo table after update
select * from MedInfo where MedName = 'Ibuprofen';

-- iii. Create trigger for delete operation
delimiter $$
create trigger after_medication_delete 
after delete on Medication 
for each row
begin
    delete from MedInfo where MedName = old.Name;
end$$
delimiter ;

-- Test delete trigger
delete from Medication where Medication_Code = 'MD006';

-- Check MedInfo table after delete
select * from MedInfo where MedName = 'Ibuprofen';

-- <Q3 – 523607238>

-- Create stored procedure to count patient medications
delimiter $$
create procedure GetPatientMedicationCount(
    in patient_id_param varchar(10),
    out med_count int
)
begin
    select count(*) into med_count
    from Patient_Medication
    where Patient_ID = patient_id_param;
end$$
delimiter ;

-- Test the stored procedure
set @result = 0;
call GetPatientMedicationCount('PT001', @result);
select @result as 'Medication_Count_PT001';

-- Test with another patient
call GetPatientMedicationCount('PT003', @result);
select @result as 'Medication_Count_PT003';

-- <Q4 – 523607238>

-- Create function to calculate days to expiry
delimiter $$
create function DaysToExpiry(exp_date date) 
returns int
deterministic
begin
    return datediff(exp_date, curdate());
end$$
delimiter ;

-- Create view for expiring medications
create view ExpiringMedications as
select 
    Medication_Code,
    Name as Medication_Name,
    Quantity_On_Hand,
    Expiration_Date,
    DaysToExpiry(Expiration_Date) as Days_Remaining
from Medication
where DaysToExpiry(Expiration_Date) < 30 
   and DaysToExpiry(Expiration_Date) > 0;

-- Insert a test medication that expires soon
insert into Medication values 
('MD007', 'Test Medicine', 100, '2025-12-31' , 20.00);

-- Show expiring medications
select * from ExpiringMedications;

-- <Q6 – 523607238>

-- Load Staff XML
load xml
infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/staff.xml'
into table Staff
rows identified by '<row>';

-- Check results
select * from Staff;

-- Load Patient XML
load xml
infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/patient.xml'
into table Patient
rows identified by '<row>';

-- Check results
select * from Patient;