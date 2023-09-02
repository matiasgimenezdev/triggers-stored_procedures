/********************* ROLES **********************/

/********************* UDFS ***********************/

/********************* FUNCTIONS ***********************/

/****************** SEQUENCES ********************/

/******************** DOMAINS *********************/

/******************* PROCEDURES ******************/

/******************* PACKAGES ******************/

/******************** TABLES **********************/

CREATE TABLE TBL_CONTRATISTA
(
  DNI CHAR(8) NOT NULL,
  VALOR_HORA DOUBLE PRECISION NOT NULL,
  CONSTRAINT PK_TBL_CONTRATISTA PRIMARY KEY (DNI)
);
CREATE TABLE TBL_EMPLEADO
(
  DNI CHAR(8) NOT NULL,
  SALARIO DOUBLE PRECISION NOT NULL,
  CONSTRAINT PK_TBL_EMPLEADO PRIMARY KEY (DNI)
);
CREATE TABLE TBL_PERSONA
(
  DNI CHAR(8) NOT NULL,
  NOMBRE VARCHAR(60) NOT NULL,
  APELLIDO VARCHAR(60) NOT NULL,
  CONSTRAINT PK_TBL_PERSONA PRIMARY KEY (DNI)
);
/********************* VIEWS **********************/

/******************* EXCEPTIONS *******************/

CREATE EXCEPTION EX_PERSONA
'Una persona puede ser empleado o contratista, NO ambas';
/******************** TRIGGERS ********************/

SET TERM ^ ;
CREATE TRIGGER TRG_BI_CONTRATISTA FOR TBL_CONTRATISTA ACTIVE
BEFORE INSERT POSITION 0

AS
BEGIN
    IF(EXISTS(SELECT * FROM TBL_EMPLEADO E WHERE E.DNI = NEW.DNI)) THEN
        EXCEPTION EX_PERSONA;
END
^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TRG_BI_EMPLEADO FOR TBL_EMPLEADO ACTIVE
BEFORE INSERT POSITION 0

AS 
BEGIN
    IF(EXISTS(SELECT * FROM TBL_CONTRATISTA C WHERE C.DNI = NEW.DNI)) THEN
        EXCEPTION EX_PERSONA;
END
^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TRG_BU_CONTRATISTA FOR TBL_CONTRATISTA ACTIVE
BEFORE UPDATE POSITION 0

AS
BEGIN
    IF(OLD.DNI <> NEW.DNI 
        AND EXISTS(SELECT * FROM TBL_EMPLEADO E WHERE NEW.DNI = E.DNI)) THEN
        EXCEPTION EX_PERSONA;
END
^
SET TERM ; ^
SET TERM ^ ;
CREATE TRIGGER TRG_BU_EMPLEADO FOR TBL_EMPLEADO ACTIVE
BEFORE UPDATE POSITION 0

AS
BEGIN
    IF(OLD.DNI <> NEW.DNI 
        AND EXISTS(SELECT * FROM TBL_CONTRATISTA C WHERE NEW.DNI = C.DNI)) THEN
        EXCEPTION EX_PERSONA;
END
^
SET TERM ; ^
/******************** DB TRIGGERS ********************/

/******************** DDL TRIGGERS ********************/


ALTER TABLE TBL_CONTRATISTA ADD CONSTRAINT FK_TBL_CONTRATISTA_PERSONA
  FOREIGN KEY (DNI) REFERENCES TBL_PERSONA (DNI);
ALTER TABLE TBL_CONTRATISTA ADD CONSTRAINT CONSTRAINT_VALOR_HORA
  check (VALOR_HORA >= 0.0);
ALTER TABLE TBL_EMPLEADO ADD CONSTRAINT FK_TBL_EMPLEADO_PERSONA
  FOREIGN KEY (DNI) REFERENCES TBL_PERSONA (DNI);
ALTER TABLE TBL_EMPLEADO ADD CONSTRAINT CONSTRAINT_SALARIO
  check (SALARIO >= 0);
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TBL_CONTRATISTA TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TBL_EMPLEADO TO  SYSDBA WITH GRANT OPTION;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE
 ON TBL_PERSONA TO  SYSDBA WITH GRANT OPTION;
