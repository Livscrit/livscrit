CREATE TABLE departments (
    dept_id CHAR(5) PRIMARY KEY COMMENT '院系编号',
    dept_name VARCHAR(50) NOT NULL UNIQUE COMMENT '院系名称'
);

CREATE TABLE teachers (
    teacher_id CHAR(10) PRIMARY KEY COMMENT '工号',
    name VARCHAR(20) NOT NULL COMMENT '姓名',
    dept_id CHAR(5) NOT NULL COMMENT '所属院系',
    title VARCHAR(20) COMMENT '职称',
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE courses (
    course_id CHAR(8) PRIMARY KEY COMMENT '课程代码',
    course_name VARCHAR(50) NOT NULL COMMENT '课程名称',
    credits DECIMAL(3,1) NOT NULL COMMENT '学分'
);

CREATE TABLE students (
    student_id CHAR(10) PRIMARY KEY COMMENT '学号',
    name VARCHAR(20) NOT NULL COMMENT '姓名',
    gender ENUM('M', 'F') NOT NULL COMMENT '性别',
    entry_year YEAR NOT NULL COMMENT '入学年份',
    dept_id CHAR(5) NOT NULL COMMENT '所属院系',
    id_card CHAR(18) UNIQUE COMMENT '身份证号',
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE course_sections (
    section_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '班次ID',
    course_id CHAR(8) NOT NULL,
    teacher_id CHAR(10) NOT NULL,
    semester VARCHAR(20) NOT NULL COMMENT '学期',
    capacity INT NOT NULL COMMENT '总容量',
    residue INT NOT NULL COMMENT '剩余名额',
    status ENUM('OPEN', 'CLOSED', 'GRADING') DEFAULT 'OPEN',
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
    CHECK (residue >= 0) 
);

CREATE TABLE enrollments (
    student_id CHAR(10) NOT NULL,
    section_id INT NOT NULL,
    enroll_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    score DECIMAL(5,2) DEFAULT NULL COMMENT '成绩',
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


