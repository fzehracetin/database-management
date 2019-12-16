create or replace function topla (sayi1 numeric, sayi2 numeric)
returns numeric as'
declare 
toplam numeric;
begin
	toplam := sayi1 + sayi2;
	return toplam;
end;
'language plpgsql;

select topla(22, 63)

drop function topla(numeric, numeric)

create or replace function ort_maas (depname department.dname%type)
returns real as'
declare
maas numeric;
begin
	select avg(salary) into maas
	from employee e, department d
	where d.dname = depname
	and e.dno = d.dnumber;
	return maas;
end;
'language plpgsql;

select ort_maas('Software');

drop function ort_maas(department.dname%type)

create function summation(out sonuc numeric, num1 numeric, num2 numeric)
as'
begin
	sonuc := num1 + num2;
end;
'language plpgsql;

select summation(22, 63)

create function depno (out min_deptno numeric, out max_deptno numeric)
as'
begin
	select min(dnumber), max(dnumber) into min_deptno, max_deptno
	from department;
end;
'language plpgsql;

select depno()

create or replace function calisanlar(out toplam numeric)
as'
begin
	select count(*) into toplam
	from employee e
	where e.dno = 6;
end;
'language plpgsql;

select calisanlar()

create or replace function zam () 
returns void as'
declare
calisan_sayisi numeric;
begin
	select count(*) into calisan_sayisi
	from employee
	where dno = 6;
	if (calisan_sayisi < 10) then
		update employee
		set salary = salary*1.05
		where dno = 6;
	end if;
end;
'language plpgsql;

create or replace function casec(x text) 
returns text as $$
declare
msg text;
begin
case x
	when 1, 2 then
	msg := 'one or two';
	when 3, 4 then
	msg := 'three or four';
	else
	msg := 'other value';
end case;
return msg;
end;
$$ language plpgsql;

select casec(5);

create or replace function incrementi (t integer)
returns integer as'
begin
return t + 1;
end;
'language plpgsql;

create or replace function kosullu_zam_yap(dep_name department.dname%TYPE, max_deger numeric, min_deger numeric, zam numeric)
returns void as $$
declare 
ort_maas numeric;
k_top_maas numeric;
begin
	select avg(salary) into ort_maas
	from department d, employee e
	where d.dname = dep_name
	and d.dnumber = e.dno;
	
	select sum(salary) into k_top_maas
	from department d, employee e
	where d.dname = dep_name
	and d.dnumber = e.dno
	and e.sex = 'F';
	
	if (ort_maas < max_deger) and (min_deger < k_top_maas) then
		update employee 
		set salary = salary * zam/100 + salary
		where ssn in(
					select essn
					from employee e, works_on w, department d
					where e.ssn = w.essn
					and d.dname = dep_name
					and d.dnumber = e.dno
					group by essn
					having count(*) > 1
					);
	end if;	
end;
$$ language plpgsql;

select kosullu_zam_yap ('Research', 60000, 10000, 5);


























