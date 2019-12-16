select count(*), 
		sum(salary),
		min(salary), 
		avg(salary), 
		max(salary)
from employee e, department d
where e.dno = d.dnumber
and d.dname = 'Sales'

select avg(salary) as average,
		sum(salary) as summation
from employee e
where e.dno = 8;

select count(*), avg(salary)
from employee e, project pr, works_on w
where pr.pname = 'Middleware'
and pr.pnumber = w.pno
and e.ssn = w.essn;

select pno
from employee e, project pr, works_on w
where pr.pnumber = w.pno
and e.ssn = w.essn
and bdate in(
			select max(bdate)
			from employee e
			);
			
select pr.pname, avg(salary)
from employee e, project pr, works_on w
where pr.pnumber = w.pno
and e.ssn = w.essn
group by pr.pname
order by pr.pname asc;

select  e.sex, d.dname, count(*), avg(salary) as average
from employee e, department d
where e.dno = d.dnumber
group by d.dname, e.sex
order by dname asc

select dno, avg(salary)
from employee
group by dno
having avg(salary) > 40000
order by dno
			
select dno, avg(salary)
from employee
group by dno
having avg(salary) > 40000
and dno != 5
order by dno

select fname, lname, salary
from employee
order by salary desc
limit 1 offset 0
			
select fname, lname
from employee e
where superssn is null
order by fname

select extract(year from bdate)
from employee
group by bdate
having extract(century from bdate) < 21
