# Hospital Management System - SQL Database

[![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-brightblue)](https://www.mysql.com/)

## Overview
Complete **Hospital Management System** implemented as a MySQL database. Models hospital operations including staff hierarchy (Doctors, Nurses, Surgeons, Head Doctors), patients, medications, allergies, locations, and surgeries with many-to-many relationships.

**Registration Number**: 523607238 (from project scripts)

## 🚀 Features
- **Staff Management**: Hierarchical staff with roles (Doctor/Nurse/Surgeon), Head Doctor monitoring.
- **Patient Management**: Patient details, allergies, bed/room locations, blood type.
- **Medication Tracking**: Inventory with expiry, patient-specific orders/severities.
- **Surgery Scheduling**: Surgeries with surgeons/nurses assignment, categories (Minor/Major/Critical).
- **Advanced SQL**:
  - Views: `PatientSurgeryView`, `ExpiringMedications`
  - Triggers: Auto-sync Medication to `MedInfo` (insert/update/delete)
  - Stored Procedure: `GetPatientMedicationCount(patient_id)`
  - Function: `DaysToExpiry(exp_date)`
  - XML Data Loading: Staff/Patient import

## 📋 Database Schema
**Key Tables & Relationships** (see `Diagrams v1.pdf` for ER diagram):

| Table | Description | Key Fields | Relationships |
|-------|-------------|------------|---------------|
| `Staff` | Base staff info | `Employee_No (PK)`, Role (Doctor/Nurse/Surgeon) | Parent for Doctor/Nurse/Surgeon |
| `Doctor` / `Head_Doctor` | Doctor details & hierarchy | `Monthly_Salary`, monitors via `Head_Doctor_Monitor` | 1:M with surgeries |
| `Nurse` / `Surgeon` | Specialized roles | `Grade`/`Years_of_Experience`, `Specialty` | M:N with surgeries |
| `Patient` | Patient info | `Patient_ID (PK)`, `Location_ID`, `Allergy_ID` | M:N Medications, 1:M Surgeries |
| `Medication` | Inventory | `Medication_Code (PK)`, `Quantity_On_Hand`, `Expiration_Date` | M:N Patient_Medication |
| `Surgery` | Operations | `Surgery_ID (PK)`, `Category` | M:N Perform (Surgeons), Surgery_Nurse |

**Total Tables**: 15+ (incl. junction tables)

## 🛠️ Setup & Installation
1. **Prerequisites**: MySQL 8.0+ Server.
2. Run main schema:
   ```sql
   mysql -u root -p < HospitalDB.sql
   ```
   - Creates `HospitalDB`, all tables, sample data (7 staff, 5 patients, surgeries, meds).
3. Run advanced scripts:
   ```sql
   mysql -u root -p HospitalDB < Scripts.sql
   ```
   - Adds views/triggers/procedures/functions.

**Note**: XML loading in Scripts.sql requires `staff.xml`/`patient.xml` in MySQL uploads dir.

## 📖 Usage Examples

### Query Sample Data
```sql
USE HospitalDB;
SELECT * FROM Staff;
SELECT * FROM PatientSurgeryView;  -- View example
```

### Stored Procedure
```sql
CALL GetPatientMedicationCount('PT001', @count);
SELECT @count;  -- Returns med count for patient
```

### Check Expiring Meds
```sql
SELECT * FROM ExpiringMedications;
```

### Triggers Demo
- Insert/Update/Delete Medication → Auto updates `MedInfo`.

## 📁 Files
- `HospitalDB.sql`: Core schema + sample data.
- `Scripts.sql`: Views, triggers, procedures, functions.
- `Diagrams v1.pdf`: ER diagram & Relational Schema.
- `TMA2.pdf` / `MP.pdf`: Assignment docs.

## 🔮 Future Improvements
- Add user authentication/views.
- Frontend dashboard (PHP/Node + this DB).
- Backup scripts, indexing for performance.
- More data validation/constraints.

## 📄 License
MIT License - Feel free to use/modify.

---
**Made by [Sanduni Fernando](https://github.com/sanduf01)**  
[Download CV](https://raw.githubusercontent.com/sanduf01/my-portfolio/main/portfolio/public/Sanduni%20Fernando%20CV.pdf) | [LinkedIn](https://linkedin.com/in/sanduf01)