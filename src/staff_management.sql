-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Staff Management Queries

-- 1. List all staff members by role
-- TODO: Write a query to list all staff members by role
SELECT 
    staff_id,
    first_name,
    last_name,
    position AS role
FROM 
    staff
ORDER BY 
    position; 
-- 2. Find trainers with one or more personal training session in the next 30 days
-- TODO: Write a query to find trainers with one or more personal training session in the next 30 days
SELECT 
    s.staff_id AS trainer_id,
    s.first_name || ' ' || s.last_name AS trainer_name,
    COUNT(ps.session_id) AS session_count
FROM 
    staff s
JOIN 
    personal_training_sessions ps ON s.staff_id = ps.staff_id
WHERE 
    ps.session_date BETWEEN DATE('now') AND DATE('now', '+30 days')
      AND s.position = 'Trainer'  
GROUP BY 
    s.staff_id, trainer_name
HAVING 
    COUNT(ps.session_id) > 0;  