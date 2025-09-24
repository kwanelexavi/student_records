
-- Testing Data


-- Departments
INSERT INTO departments (name, program_level) VALUES
('Computer Science', 'Undergraduate'),
('Mathematics', 'Undergraduate'),
('Physics', 'Undergraduate');

-- Instructors
INSERT INTO instructors (first_name, last_name, email, department_id) VALUES
('Alice', 'Nkosi', 'alicenkosi@gmail.com', 1),
('Simpiwe', 'Nyawo', 'simpiwenyawo@gmail.com', 2),
('kwanele', 'Msibi', 'kwanelemsibi@gmail.com', 3);

-- Update department heads
UPDATE departments SET head_instructor_id = 1 WHERE department_id = 1;
UPDATE departments SET head_instructor_id = 2 WHERE department_id = 2;
UPDATE departments SET head_instructor_id = 3 WHERE department_id = 3;

-- Students
INSERT INTO students (first_name, last_name, email, date_of_birth, gender, department_id) VALUES
('John', 'Doe', 'johndoe@student.gmail', '2001-05-15', 'Male', 1),
('Mahla', 'Ntuli', 'mahlantuli@student.gmail', '2000-11-22', 'Female', 2),
('Lily', 'Zikhali', 'lilyzikhali@student.gmail', '2002-03-10', 'Male', 3);

-- Semesters
INSERT INTO semesters (name, start_date, end_date) VALUES
('Fall 2025', '2025-09-01', '2025-12-20'),
('Spring 2026', '2026-01-15', '2026-05-10');

-- Courses
INSERT INTO courses (course_code, title, credits, department_id, instructor_id, semester_id) VALUES
('CS101', 'Introduction to Programming', 3, 1, 1, 1),
('MATH201', 'Linear Algebra', 4, 2, 2, 1),
('PHYS301', 'Quantum Mechanics', 3, 3, 3, 1);

-- Enrollments
INSERT INTO enrollments (student_id, course_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(1, 2);

-- Grades
INSERT INTO grades (enrollment_id, grade) VALUES
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'B');

-- Class Schedule
INSERT INTO class_schedule (course_id, day_of_week, start_time, end_time, room) VALUES
(1, 'Monday', '09:00:00', '10:30:00', 'Room 101'),
(1, 'Wednesday', '09:00:00', '10:30:00', 'Room 101'),
(2, 'Tuesday', '11:00:00', '12:30:00', 'Room 202'),
(3, 'Thursday', '14:00:00', '15:30:00', 'Room 303');

-- Attendance
INSERT INTO attendance (enrollment_id, schedule_id, attendance_date, status) VALUES
(1, 1, '2025-09-02', 'Present'),
(1, 2, '2025-09-04', 'Absent'),
(2, 3, '2025-09-03', 'Present'),
(3, 4, '2025-09-05', 'Late'),
(4, 3, '2025-09-03', 'Present');
