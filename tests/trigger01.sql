CREATE OR REPLACE TRIGGER employees_update
  FOR UPDATE ON employees
  COMPOUND TRIGGER

  TYPE employeeNumberRec IS RECORD
    (oldEmployeeNumber employees.employeeNumber%TYPE
    ,newEmployeeNumber employees.employeeNumber%TYPE);
  TYPE employeeNumbersTbl IS TABLE OF employeeNumberRec;
  g_employeeNumbers employeeNumbersTbl;

BEFORE STATEMENT 
IS
BEGIN
  -- Reset the internal employees table
  g_employeeNumbers := employeeNumbersTbl();
END BEFORE STATEMENT; 

AFTER EACH ROW
IS
BEGIN
  -- Store the updated employees
  IF :new.employeeNumber  <> :old.employeeNumber THEN           
    g_employeeNumbers.EXTEND;
    g_employeeNumbers(g_employeeNumbers.LAST).oldEmployeeNumber := :old.employeeNumber;
    g_employeeNumbers(g_employeeNumbers.LAST).newEmployeeNumber := :new.employeeNumber;
  END IF;
END AFTER EACH ROW;

AFTER STATEMENT
IS
BEGIN
  -- Now update the child tables
  FORALL l_index IN 1..g_employeeNumbers.COUNT
    UPDATE employees 
    SET assignTo = g_employeeNumbers(l_index).newEmployeeNumber
    WHERE assignTo = g_employeeNumbers(l_index).oldEmployeeNumber;
  FORALL l_index IN 1..g_employeeNumbers.COUNT
    UPDATE customers
    SET salesRepEmployeeNumber = g_employeeNumbers(l_index).newEmployeeNumber
    WHERE salesRepEmployeeNumber = g_employeeNumbers(l_index).oldEmployeeNumber;
END AFTER STATEMENT;

END;

