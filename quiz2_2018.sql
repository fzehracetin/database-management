select  dnumber, count(*)
from dept_locations
group by dnumber
order by count(*) desc

select dname, count(*)
from employee e, department d
where d.dnumber = e.dno
group by dname
having count(*) >= 7
order by dname asc

select d.dependent_name
from dependent d
where d.essn in (
				select w.essn
				from works_on w, employee e
				where w.essn = e.ssn
				group by w.essn
				order by count(*) desc
				limit 1
				)
				
create or replace function fark()
returns numeric as'
declare
genc_dept numeric;
yasli_dept numeric;
begin
	select count(*) into genc_dept
	from employee e1, employee e2
	where e1.dno = e2.dno
	and e1.bdate in (
				select max(e.bdate)
				from employee e
				);
	
	select count(*) into yasli_dept
	from employee e1, employee e2
	where e1.dno = e2.dno
	and e1.bdate in (
				select e.bdate
				from employee e
				order by e.bdate asc
				limit 1
				);
	return abs(yasli_dept - genc_dept);
end;
'language plpgsql;

select fark();

create or replace function zam(p1 project.pname%type, p2 project.pname%type)
returns numeric as'
declare
ort_maas1 numeric := 0;
ort_maas2 numeric := 0;
sonuc numeric := 0;
begin
	select avg(salary) into ort_maas1
	from employee e, project pr, works_on w
	where pr.pname = p1
	and e.ssn = w.essn
	and w.pno = pr.pnumber;
	
	select avg(salary) into ort_maas2
	from employee e, project pr, works_on w
	where pr.pname = p2
	and e.ssn = w.essn
	and w.pno = pr.pnumber;
	
	if (ort_maas1 = 0) or (ort_maas2 = 0) then
		return 0;
	elsif (ort_maas1 < ort_maas2) then
		return ((ort_maas2 - ort_maas1) * 100)/(ort_maas1);
	else
		return ((ort_maas1 - ort_maas2) * 100)/(ort_maas2);
	end if;
end;
'language plpgsql;

select zam('ProductX', 'ProductZ');

























