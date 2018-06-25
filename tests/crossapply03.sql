SELECT department_name, employee_id, employee_name
FROM   departments d
OUTER APPLY (SELECT employee_id, employee_name
FROM   employees e
WHERE  salary >= 2000
AND    e.department_id = d.department_id)
ORDER BY 1, 2, 3
