-- having clause without explicit group by
-- If TE does not immediately contain a group by clause, then “GROUP BY ()” is implicit.
select max(empid), min(marks)
from employee
having max(empid_id)>100
