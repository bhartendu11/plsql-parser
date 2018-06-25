SELECT department_name, employee_name
FROM   departments d,
LATERAL (SELECT employee_name
FROM   employees e
WHERE  e.department_id = d.department_id)
ORDER BY 1, 2
