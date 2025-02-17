-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.sqlite
-- .open fittrackpro.sqlite
.mode column
-- #### `locations` table

-- | Attribute     |
-- | ------------- |
-- | location_id   |
-- | name          |
-- | address       |
-- | phone_number  |
-- | email         |
-- | opening_hours |

-- Enable foreign key support
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS locations;
-- Create your tables here
CREATE TABLE locations (
       location_ID INTEGER PRIMARY KEY UNIQUE NOT NULL,
       name TEXT NOT NULL,
       address TEXT NOT NULL,
       phone_number TEXT NOT NULL CHECK(LENGTH(phone_number) >= 8 AND phone_number GLOB '[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
       email VARCHAR(255) CHECK(email LIKE '%@%'),
       opening_hours TEXT NOT NULL
       );


DROP TABLE IF EXISTS members;
CREATE TABLE members (
       member_ID INTEGER PRIMARY KEY UNIQUE NOT NULL,
       first_name TEXT NOT NULL,
       last_name TEXT NOT NULL,
       email TEXT NOT NULL CHECK(email LIKE '%@%'),
       phone_number TEXT NOT NULL CHECK(LENGTH(phone_number) >= 8 AND phone_number GLOB '[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
       date_of_birth DATE NOT NULL,
       join_date DATE NOT NULL,
       emergency_contact_name TEXT,
       emergency_contact_phone TEXT
       );

DROP TABLE IF EXISTS staff;
CREATE TABLE staff (  
    staff_id INTEGER PRIMARY KEY,  
    first_name TEXT NOT NULL,  
    last_name TEXT NOT NULL,  
    email TEXT UNIQUE NOT NULL,  
    phone_number TEXT,  
    position TEXT CHECK(position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),  
    hire_date DATE NOT NULL,  
    location_id INTEGER  
);  

DROP TABLE IF EXISTS equipment;
CREATE TABLE equipment (  
    equipment_id INTEGER PRIMARY KEY,  
    name TEXT NOT NULL,  
    type TEXT CHECK(type IN ('Cardio', 'Strength')) NOT NULL,  
    purchase_date DATE,  
    last_maintenance_date DATE,  
    next_maintenance_date DATE,  
    location_id INTEGER  
);  

DROP TABLE IF EXISTS classes;
CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    capacity INTEGER,
    duration INTEGER,
    location_id INTEGER
);
     
DROP TABLE IF EXISTS class_schedule;       
CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY,
    class_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    CHECK (end_time > start_time),
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

DROP TABLE IF EXISTS memberships;  
CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    type TEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status TEXT NOT NULL CHECK (status IN ('Active', 'Inactive')),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    CHECK (end_date IS NULL OR end_date > start_date)
);

DROP TABLE IF EXISTS attendance;
CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL,
    check_in_time DATETIME NOT NULL,
    check_out_time DATETIME,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (location_id) REFERENCES locations(location_id),
    CHECK (check_out_time IS NULL OR check_out_time > check_in_time)
);

DROP TABLE IF EXISTS class_attendance;
CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY,
    schedule_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    attendance_status TEXT NOT NULL CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

DROP TABLE IF EXISTS payments;
CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    amount REAL NOT NULL CHECK (amount > 0),
    payment_date DATE NOT NULL,
    payment_method TEXT NOT NULL CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type TEXT NOT NULL CHECK (payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

DROP TABLE IF EXISTS personal_training_sessions;
CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    session_date DATE NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    notes TEXT,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    CHECK (end_time > start_time)
);

DROP TABLE IF EXISTS member_health_metrics;
CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY,
    member_id INTEGER NOT NULL,
    measurement_date DATE NOT NULL,
    weight REAL,
    body_fat_percentage REAL,
    muscle_mass REAL,
    bmi REAL,
    FOREIGN KEY (member_id) REFERENCES members(member_id) 
);

DROP TABLE IF EXISTS equipment_maintenance_log;
CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY,
    equipment_id INTEGER NOT NULL,
    maintenance_date DATE NOT NULL,
    description TEXT,
    staff_id INTEGER NOT NULL,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) 
);



