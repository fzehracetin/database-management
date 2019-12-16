select lname, bdate
from employee
where address like '%Seattle%';

select pno
from works_on w, employee e
where fname='Franklin' 
and lname='Wong'
and e.ssn=w.essn;

select dlocation
from department d, dept_locations dl
where dname='Sales'
and d.dnumber=dl.dnumber;

select e2.fname, e2.lname
from employee e1, employee e2, dependent d
where d.dependent_name='Elizabeth'
and d.essn=e1.ssn
and e2.ssn=e1.superssn;

select fname, lname
from employee
where dno=5;

select dname
from employee e, department d
where e.fname='Jared'
and e.lname='James'
and e.dno=d.dnumber;

create view maas_view as
select fname, lname, salary
from employee
where salary>=20000
and salary<=40000;

select * from maas_view;

create view sales_view as
select fname, lname, sex
from employee e, department d
where e.dno=d.dnumber
and d.dname='Sales';

select * from sales_view;

select fname, lname 
from project pr, employee e, works_on w
where pr.pname='OperatingSystems'
and pr.pnumber=w.pno
and e.ssn=w.essn
intersect
select fname, lname
from department d, employee e
where d.dname='Software'
and d.dnumber=e.dno;

select fname, lname 
from employee e
where not exists(
	select null 
	from department d
	where d.mgrssn=e.ssn
)
and not exists(
	select null
	from employee s
	where s.superssn=e.ssn
)

select dname 
from department
where dnumber in(
	select dno
	from employee
	where fname='John'
)

select count(*) as toplam, min(salary), max(salary), avg(salary)
from employee e, department d
where e.dno=d.dnumber
and d.dname='Sales';

select fname, lname, bdate
from employee
where bdate in(
	select min(bdate)
	from employee
)

select count(*)
from department d, employee e
where d.dname='Hardware'
and d.dnumber=e.dno;

select * from employee
where dno=7;

select ssn
from department d, employee e
where d.mgrssn=e.ssn
and d.dnumber!=e.dno;

select e1.ssn
from employee e1, employee e2
where e1.superssn=e2.ssn
and e1.bdate < e2.bdate
intersect
select e1.ssn 
from employee e1, employee e2, department d
where e1.dno = d.dnumber
and d.mgrssn = e2.ssn
and e1.bdate < e2.bdate;

select fname, lname
from employee e, dept_locations d, project pr, works_on w
where pr.plocation=d.dlocation
and d.dnumber=e.dno
and e.ssn=w.essn
and w.pno=pr.pnumber;

select e2.fname, e2.lname
from employee e1, employee e2, dependent d
where e1.ssn=d.essn
and d.relationship='Daughter'
and e1.superssn=e2.ssn;









