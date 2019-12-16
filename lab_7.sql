create or replace function toplam(sayi1 numeric, sayi2 numeric)
returns numeric as $$
declare
toplam numeric;
begin
	toplam := sayi1 + sayi2;
	raise notice 'sayi1: %, sayi2: %', sayi1, sayi2;
	return toplam;
end;
$$ language 'plpgsql';

select toplam(5, 6)

create type tur as(isim varchar(25), dep_isim varchar(25), maas integer);

create or replace function find(gelen_ssn employee.ssn%type)
returns tur as $$
declare
	bilgi tur;
begin
	select e.fname, d.dname, e.salary into bilgi
	from employee e, department d
	where e.ssn = gelen_ssn
	and e.dno = d.dnumber;
	raise notice 'isim: %, dep_isim: %, maas: %', bilgi.isim, bilgi.dep_isim, bilgi.maas;
	return bilgi;
end;
$$ language 'plpgsql';

select find('123456789')

curs_all_emp cursor for select * from employee;

create or replace function name_finder(num department.dnumber%type)
returns void as $$
declare
	name_cur cursor for select fname, lname
	from employee 
	where num = dno;
begin
	for satir in name_cur loop
	raise info 'Name: %s %s ', satir.fname, satir.lname;
	end loop;
end;
$$ language 'plpgsql';

select name_finder('5');

create or replace function maas(num department.dnumber%type)
returns numeric as $$
declare
	toplam numeric;
	top_curs cursor for select salary
	from employee
	where num = dno;
begin
	toplam := 0;
	for satir in top_curs loop
	toplam := toplam + satir.salary;
	end loop;
	return toplam;
end;
$$ language 'plpgsql';

select maas('5');

create or replace function maas_out (num department.dnumber%type, out toplam numeric)
returns numeric as $$
declare
	top_curs cursor for select salary
	from employee
	where num = dno;
begin
	toplam := 0;
	for satir in top_curs loop
	toplam := toplam + satir.salary;
	end loop;
end;
$$ language 'plpgsql';

select maas_out('5');

create type calisan1 as (fname varchar(15), lname varchar(15), salary numeric);

create or replace function pr_finder(pnum project.pnumber%type, bolen integer)
returns calisan1[] as $$
declare
	curs cursor for select e.fname, e.lname, e.salary
	from employee e, works_on w
	where e.ssn = w.essn
	and pnum = w.pno;
	i integer;
	cal calisan1[];
begin
	i := 1;
	for satir in curs loop
		if satir.salary%bolen = 0 then
			cal[i] = satir;
			i := i + 1;
		end if;
	end loop;
	return cal;
end;
$$ language 'plpgsql';

select pr_finder('1', 5);

create trigger trig_insert
before insert
on employee
for each row execute procedure trig_inserter();

create or replace function trig_inserter()
returns trigger as $$
begin
	if (to_char(now(), 'DY') in ('MON', 'SAT', 'SUN') or to_char(now(), 'HH24') not between '08' and '18') then
		raise exception 'SQL Exception: Sadece mesai günlerinde ve saatlerinde insert yapılır.';
		return null;
	else
		return new;
	end if;		
end;
$$ language 'plpgsql';

alter table project drop constraint project_dnum_fkey;
ALTER TABLE dept_locations DROP CONSTRAINT dept_locations_dnumber_fkey;
ALTER TABLE employee DROP CONSTRAINT foreign_key_const;

create trigger trig_7
after update
on department
for each row execute procedure trig_fonk7();

create or replace function trig_fonk7()
returns trigger as $$
begin
	update employee
	set dno = new.dnumber
	where dno = old.dnumber;
	return new;
end;
$$ language 'plpgsql';

create trigger trig_8
before update
on employee
for each row execute procedure trig_fonk8();

create or replace function trig_fonk8()
returns trigger as $$
begin
	if (old.salary > new.salary or new.salary > 1.1*old.salary) then
		raise exception 'Maas dusurulemez ve %10dan fazla zam yapılmaz';
		return old;
	else
		return new;
	end if;
end;
$$ language 'plpgsql';

alter table department 
add column total_salary integer default 0;

set total_salary = (select sum(salary)
	from employee
	where dno = dnumber);

create trigger trig_9
after update or delete
on employee
for each row execute procedure trig9_fonk();

create or replace function trig9_fonk()
returns trigger as $$
begin
	if (tg_op = 'DELETE') then
		update department
		set total_salary = total_salary - old.salary
		where dnumber = old.dno;
	elsif (tg_op = 'UPDATE') then
		update department
		set total_salary = total_salary - old.salary + new.salary
		where dnumber = old.dno;
	else
		update department
		set total_salary = total_salary + new.salary
		where dnumber = new.dno;
	end if;
	return new;
end;
$$ language 'plpgsql';










