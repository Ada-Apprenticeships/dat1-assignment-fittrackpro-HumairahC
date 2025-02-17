-- Initial SQLite setup
.open fittrackpro.sqlite
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Personal Training Queries

-- 1. List all personal training sessions for a specific trainer
-- TODO: Write a query to list all personal training sessions for a specific trainer
SELECT 
    ps.session_id,
    m.first_name || ' ' || m.last_name AS member_name,
    ps.session_date,
    ps.start_time,
    ps.end_time
FROM 
    personal_training_sessions ps
JOIN 
    members m ON ps.member_id = m.member_id
JOIN 
    staff s ON ps.staff_id = s.staff_id
WHERE 
    s.first_name = 'Ivy' AND s.last_name = 'Irwin';