create type calisan as (ssn char(9), fname varchar(15), lname varchar(15));

create or replace function union_ozel(p1 project.pname%type, p2 project.pname%type)
returns calisan[] as $$
declare
	p1_cur cursor for select ssn, fname, lname
	from employee e, project pr, works_on w
	where pr.pname = p1
	and pr.pnumber = w.pno
	and w.essn = e.ssn;
	
	p2_cur cursor for select ssn, fname, lname
	from employee e, project pr, works_on w
	where pr.pname = p2
	and pr.pnumber = w.pno
	and w.essn = e.ssn;	
	cal calisan[];
	i integer;
	fl integer;
	countt integer;
begin
	i := 1;
	countt := 0;
	for satir1 in p1_cur loop
		fl := 0;
		countt := countt + 1;
		for satir2 in p2_cur loop
			if (satir2.ssn <> satir1.ssn) then
				raise notice 'ssn:% fname:% lname:%', satir1.ssn, satir1.fname, satir1.lname;
				cal[i] = satir2;
				i := i + 1;
			elsif (satir2.ssn = satir1.ssn) then
				fl := 1;
			end if;
		end loop;
		if (((countt = 1) and (fl = 1)) or (fl = 0))then
			cal[i] = satir1;
			i := i + 1;
		end if;
	end loop;
	return cal;
end;
$$ language 'plpgsql';

select union_ozel('ProductX', 'ProductY');

create trigger triger
before insert or delete
on employee
for each row execute procedure trig_fonk();

create or replace function trig_fonk()
returns trigger as $$
declare 
erkek numeric;
kadin numeric;
begin
	select count(*) into erkek
	from employee
	where sex = 'M';	
	
	select count(*) into kadin
	from employee
	where sex = 'F';
	
	if (TG_OP = 'DELETE') then
		if ((kadin = erkek) and old.sex = 'F') then
			raise exception 'Kadin silemezsiniz';
			return old;
		end if;
	elsif (TG_OP = 'INSERT') then
		if ((kadin = erkek) and new.sex = 'M') then
			raise exception 'Erkek ekleyemezsiniz';
			return old;
		end if;
	else 
		return new;
	end if;	
end;
$$ language 'plpgsql';













