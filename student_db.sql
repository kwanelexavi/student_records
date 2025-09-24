-- Create Database
CREATE DATABASE student_db;
USE student_db;

--  Departments Table 
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    program_level ENUM('Undergraduate','Masters','PhD') DEFAULT 'Undergraduate'
);

--  Instructors Table
CREATE TABLE instructors (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    INDEX idx_instructors_department_id (department_id)
);

--  Now alter departments to add head_instructor_id
ALTER TABLE departments
ADD COLUMN head_instructor_id INT NULL,
ADD CONSTRAINT fk_departments_head_instructor
    FOREIGN KEY (head_instructor_id) REFERENCES instructors(instructor_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL;

--  Students Table
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    INDEX idx_students_department_id (department_id)
);

--  Semesters Table
CREATE TABLE semesters (
    semester_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

--  Courses Table
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(100) NOT NULL,
    credits INT NOT NULL CHECK (credits > 0),
    department_id INT NOT NULL,
    instructor_id INT NOT NULL,
    semester_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (semester_id) REFERENCES semesters(semester_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    INDEX idx_courses_department_id (department_id),
    INDEX idx_courses_instructor_id (instructor_id),
    INDEX idx_courses_semester_id (semester_id)
);

--  Enrollments Table
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    UNIQUE(student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    INDEX idx_enrollments_student_id (student_id),
    INDEX idx_enrollments_course_id (course_id)
);

--  Grades Table
CREATE TABLE grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL UNIQUE,
    grade ENUM('A', 'B', 'C', 'D', 'F', 'Incomplete') NOT NULL,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    INDEX idx_grades_enrollment_id (enrollment_id)
);

--  Class Schedule Table
CREATE TABLE class_schedule (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    day_of_week ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    room VARCHAR(50) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    INDEX idx_schedule_course_id (course_id)
);

--  Attendance Table
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    schedule_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('Present','Absent','Late','Excused') NOT NULL,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    INDEX idx_attendance_enrollment_id (enrollment_id),
    INDEX idx_attendance_schedule_id (schedule_id)
);
