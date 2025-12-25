CREATE TABLE IF NOT EXISTS courses
(
    course_id   CHAR(8)       NOT NULL COMMENT '课程代码'
        PRIMARY KEY,
    course_name VARCHAR(50)   NOT NULL COMMENT '课程名称',
    credits     DECIMAL(3, 1) NOT NULL COMMENT '学分'
);

CREATE TABLE IF NOT EXISTS departments
(
    dept_id   CHAR(5)     NOT NULL COMMENT '院系编号'
        PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL COMMENT '院系名称',
    CONSTRAINT dept_name
        UNIQUE (dept_name)
);

CREATE TABLE IF NOT EXISTS grade_audit_log
(
    log_id       INT AUTO_INCREMENT
        PRIMARY KEY,
    student_id   CHAR(10)                           NOT NULL,
    section_id   INT                                NOT NULL,
    old_score    DECIMAL(5, 2)                      NULL,
    new_score    DECIMAL(5, 2)                      NULL,
    operator     VARCHAR(50)                        NULL,
    operate_time DATETIME DEFAULT CURRENT_TIMESTAMP NULL
);

CREATE TABLE IF NOT EXISTS students
(
    student_id CHAR(10)        NOT NULL COMMENT '学号'
        PRIMARY KEY,
    name       VARCHAR(20)     NOT NULL COMMENT '姓名',
    gender     ENUM ('M', 'F') NOT NULL COMMENT '性别',
    entry_year YEAR            NOT NULL COMMENT '入学年份',
    dept_id    CHAR(5)         NOT NULL COMMENT '所属院系',
    id_card    CHAR(18)        NULL COMMENT '身份证号',
    CONSTRAINT id_card
        UNIQUE (id_card),
    CONSTRAINT students_ibfk_1
        FOREIGN KEY (dept_id) REFERENCES departments (dept_id)
);

CREATE INDEX dept_id
    ON students (dept_id);

CREATE TABLE IF NOT EXISTS teachers
(
    teacher_id CHAR(10)    NOT NULL COMMENT '工号'
        PRIMARY KEY,
    name       VARCHAR(20) NOT NULL COMMENT '姓名',
    dept_id    CHAR(5)     NOT NULL COMMENT '所属院系',
    title      VARCHAR(20) NULL COMMENT '职称',
    CONSTRAINT teachers_ibfk_1
        FOREIGN KEY (dept_id) REFERENCES departments (dept_id)
);

CREATE TABLE IF NOT EXISTS course_sections
(
    section_id INT AUTO_INCREMENT COMMENT '班次ID'
        PRIMARY KEY,
    course_id  CHAR(8)                                           NOT NULL,
    teacher_id CHAR(10)                                          NOT NULL,
    semester   VARCHAR(20)                                       NOT NULL COMMENT '学期',
    capacity   INT                                               NOT NULL COMMENT '总容量',
    residue    INT                                               NOT NULL COMMENT '剩余名额',
    status     ENUM ('OPEN', 'CLOSED', 'GRADING') DEFAULT 'OPEN' NULL,
    CONSTRAINT course_sections_ibfk_1
        FOREIGN KEY (course_id) REFERENCES courses (course_id),
    CONSTRAINT course_sections_ibfk_2
        FOREIGN KEY (teacher_id) REFERENCES teachers (teacher_id),
    CHECK (`residue` >= 0)
);

CREATE INDEX course_id
    ON course_sections (course_id);

CREATE INDEX idx_semester_course
    ON course_sections (semester, course_id);

CREATE INDEX teacher_id
    ON course_sections (teacher_id);

CREATE TABLE IF NOT EXISTS enrollments
(
    PRIMARY KEY (student_id, section_id),
    CONSTRAINT enrollments_ibfk_1
        FOREIGN KEY (student_id) REFERENCES students (student_id),
    CONSTRAINT enrollments_ibfk_2
        FOREIGN KEY (section_id) REFERENCES course_sections (section_id)
);

CREATE INDEX section_id
    ON enrollments (section_id);

CREATE DEFINER = root@localhost TRIGGER trg_when_score_update
    BEFORE UPDATE
    ON enrollments
    FOR EACH ROW
BEGIN
#     仅当成绩发生实质变化时记录日志
    IF (OLD.score IS NOT NULL AND NEW.score != OLD.score) OR (OLD.score IS NULL AND NEW.score IS NOT NULL) THEN
        INSERT INTO grade_audit_log (student_id, section_id, old_score, new_score, operator)
        VALUES (OLD.student_id, OLD.section_id, OLD.score, NEW.score, USER());
    END IF;
END;

CREATE INDEX dept_id
    ON teachers (dept_id);


