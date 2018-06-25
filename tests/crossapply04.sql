SELECT department_name, b.*
FROM   departments d
OUTER APPLY (TABLE(get_tab(d.department_id))) b
ORDER BY 1, 2
