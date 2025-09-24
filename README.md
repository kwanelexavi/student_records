# Student Records Database

A fully normalized relational database system designed to manage student records, courses, instructors, enrollment, grades, class schedules, and attendance. This project demonstrates proper database design, indexing, normalization (1NF, 2NF, 3NF), and aggregate reporting using MySQL.

---

## Table of Contents

- [Features](#features)  
- [Database Design](#database-design)  
- [Normalization](#normalization)  
- [Setup Instructions](#setup-instructions)  
- [Sample Queries](#sample-queries)  
- [Aggregate Functions / Reports](#aggregate-functions--reports)  
- [Indexing and Performance](#indexing-and-performance)  

---

## Features

- Track students, instructors, departments, semesters, courses, and enrollments  
- Record grades and attendance  
- Assign instructors to courses and departments  
- Schedule classes and manage rooms  
- Supports multiple program levels (Undergraduate, Masters, PhD)  
- Proper indexing for optimized queries  
- Aggregate reporting for analytics and dashboards  

---

## Database Design

### Tables

1. **departments**: Stores department details and head instructors.  
2. **instructors**: Stores instructor info linked to departments.  
3. **students**: Stores student information linked to departments.  
4. **semesters**: Stores semester information.  
5. **courses**: Stores course information linked to departments, instructors, and semesters.  
6. **enrollments**: Many-to-many relationship between students and courses.  
7. **grades**: Stores grades for each enrollment.  
8. **class_schedule**: Stores scheduled classes for courses.  
9. **attendance**: Stores attendance for each enrollment and class schedule.  

### Relationships

- One-to-Many:  
  - Department → Instructors  
  - Department → Students  
  - Instructor → Courses  
  - Semester → Courses  
- Many-to-Many:  
  - Students ↔ Courses (via `enrollments`)  

---

## Normalization

1. **First Normal Form (1NF)**  
   - Each table has atomic values  
   - No repeating groups  
   - Primary keys defined  

2. **Second Normal Form (2NF)**  
   - All non-key attributes fully depend on the primary key  
   - `enrollments` ensures student-course uniqueness  

3. **Third Normal Form (3NF)**  
   - No transitive dependencies  
   - `grades` references only `enrollment_id`  
   - `head_instructor_id` in departments references instructors without duplicating department info  

---

## Setup Instructions

### Requirements

- MySQL Server (>= 8.0)  
- MySQL Workbench or command line client  

### Steps

Clone this repository:


git clone https://github.com/Kwanelexavi/student_records.git
cd student_records

Run the SQL script to create the database:

mysql -u root -p < student_records_db.sql


Verify tables:

USE student_records_db;
SHOW TABLES;

# use the test.sql for test data

## Query: Students in a Department
    SELECT s.first_name, s.last_name, d.name AS department
    FROM students s
    JOIN departments d ON s.department_id = d.department_id
    WHERE d.name = 'Computer Science';

## Query: Grades for a Student
    SELECT s.first_name, s.last_name, c.title, g.grade
    FROM grades g
    JOIN enrollments e ON g.enrollment_id = e.enrollment_id
    JOIN students s ON e.student_id = s.student_id
    JOIN courses c ON e.course_id = c.course_id
    WHERE s.student_id = 1;

## Aggregate Functions / Reports
# Count Students in Each Department

    SELECT d.name AS department_name, COUNT(s.student_id) AS student_count
    FROM departments d
    LEFT JOIN students s ON d.department_id = s.department_id
    GROUP BY d.department_id, d.name
    ORDER BY student_count DESC;

# Count Courses Offered by Each Instructor

    SELECT i.first_name, i.last_name, COUNT(c.course_id) AS course_count
    FROM instructors i
    LEFT JOIN courses c ON i.instructor_id = c.instructor_id
    GROUP BY i.instructor_id, i.first_name, i.last_name;

# Average Grade per Course

    SELECT c.title AS course_title,
        AVG(CASE 
                WHEN g.grade='A' THEN 4
                WHEN g.grade='B' THEN 3
                WHEN g.grade='C' THEN 2
                WHEN g.grade='D' THEN 1
                WHEN g.grade='F' THEN 0
                ELSE NULL
            END) AS average_gpa
    FROM courses c
    JOIN enrollments e ON c.course_id = e.course_id
    JOIN grades g ON e.enrollment_id = g.enrollment_id
    GROUP BY c.course_id, c.title;

# Total Credits Taken by Each Student
   
    SELECT s.first_name, s.last_name, SUM(c.credits) AS total_credits
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN courses c ON e.course_id = c.course_id
    GROUP BY s.student_id, s.first_name, s.last_name;

# Attendance Summary for a Course
   
    SELECT c.title AS course_title,
        SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) AS present_count,
        SUM(CASE WHEN a.status='Absent' THEN 1 ELSE 0 END) AS absent_count,
        SUM(CASE WHEN a.status='Late' THEN 1 ELSE 0 END) AS late_count,
        SUM(CASE WHEN a.status='Excused' THEN 1 ELSE 0 END) AS excused_count
    FROM courses c
    JOIN class_schedule cs ON c.course_id = cs.course_id
    JOIN attendance a ON cs.schedule_id = a.schedule_id
    GROUP BY c.course_id, c.title;

# Number of Students Enrolled in Each Semester
   
    SELECT sem.name AS semester_name, COUNT(DISTINCT e.student_id) AS student_count
    FROM semesters sem
    JOIN courses c ON sem.semester_id = c.semester_id
    JOIN enrollments e ON c.course_id = e.course_id
    GROUP BY sem.semester_id, sem.name;


💡 Optional: You can create views for recurring reports:

    CREATE VIEW department_student_count AS
    SELECT d.name AS department_name, COUNT(s.student_id) AS student_count
    FROM departments d
    LEFT JOIN students s ON d.department_id = s.department_id
    GROUP BY d.department_id, d.name;


## Kwanele Mntambo
Email: [kwanelexavi@gmail.com
]
GitHub: https://github.com/kwanelexavi

