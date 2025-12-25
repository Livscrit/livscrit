CREATE TABLE departments (
    dept_id CHAR(5) PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE teachers (
    teacher_id CHAR(10) PRIMARY KEY,
    name VARCHAR(20) NOT NULL COMMENT,
    dept_id CHAR(5) NOT NULL,
    title VARCHAR(20),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE courses (
    course_id CHAR(8) PRIMARY KEY,
    course_name VARCHAR(50) NOT NULL,
    credits DECIMAL(3,1) NOT NULL
);

CREATE TABLE students (
    student_id CHAR(10) PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    gender ENUM('M', 'F') NOT NULL,
    entry_year YEAR NOT NULL,
    dept_id CHAR(5) NOT NULL,
    id_card CHAR(18) UNIQUE,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE course_sections (
    section_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id CHAR(8) NOT NULL,
    teacher_id CHAR(10) NOT NULL,
    semester VARCHAR(20) NOT NULL,
    capacity INT NOT NULL,
    residue INT NOT NULL,
    status ENUM('OPEN', 'CLOSED', 'GRADING') DEFAULT 'OPEN',
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
    CHECK (residue >= 0) 
);

CREATE TABLE enrollments (
    student_id CHAR(10) NOT NULL,
    section_id INT NOT NULL,
    enroll_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    score DECIMAL(5,2) DEFAULT NUL,
    PRIMARY KEY (student_id, section_id), 
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (section_id) REFERENCES course_sections(section_id)
);

CREATE TABLE grade_audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id CHAR(10) NOT NULL,
    section_id INT NOT NULL,
    old_score DECIMAL(5,2),
    new_score DECIMAL(5,2),
    operator VARCHAR(50),
    operate_time DATETIME DEFAULT CURRENT_TIMESTAMP
);



