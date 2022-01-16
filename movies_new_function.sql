-- delete from vephim;
-- delete from hoadon;
-- delete from datcho;

drop function if exists check_place;
delimiter $$ 
create function check_place(ml int, h int, c int)
returns boolean
DETERMINISTIC
begin
declare v int;
set v = 0;
select mave into v from vephim
where malich = ml and h = hang and c = cot;
if v = 0 then 
return True;
end if;
if v != 0 then 
return False;
end if;
end $$
delimiter ; 

drop procedure if exists create_random_ticket;
delimiter $$ 
create procedure create_random_ticket(so_luong int)
begin 
    declare i int;
    declare ml, max_count int;
    declare h, c int;
	set i = 1;
    select count(malich) into max_count from lichphim;
    set ml = max_count;
	input_i: loop
	   set h = floor(rand()*10);
	   set c = floor(rand()*10);
       set ml = floor(rand()*ml) % 10 + floor(rand()*max_count);
       if check_place(ml, h, c) and ml < max_count then
		   start transaction;
		   insert into vephim( mave ,  malich ,  hang ,  cot,          han                  )
					   values(   i  ,    ml   ,   h   ,   c ,  CURTIME() + INTERVAL 5 MINUTE);
		   commit;
           set i = i + 1;
       end if;
    if i = so_luong
    then leave input_i;
    end if;
    end loop input_i;
end$$
delimiter ;

drop function if exists check_datcho;
delimiter $$ 
create function check_datcho(mv varchar(50))
returns boolean
DETERMINISTIC
begin
declare v varchar(50);
set v = 0;
select mave into v from datcho
where mave = mv;
if v = 0 then 
return True;
end if;
if v != 0 then 
return False;
end if;
end $$
delimiter ;

drop procedure if exists store_random_ticket;
delimiter $$ 
create procedure store_random_ticket(so_luong int)
begin 
    declare i int;
    declare ve varchar(50);
    declare max_count int;
    declare ma_hoa_don varchar(50);
	set i = 1;
    select count(mave) into max_count from vephim;
	input_i: loop
	   set ma_hoa_don = uuid();
       select mave into ve from vephim order by rand() limit 1;
       if check_datcho(ve) then
       start transaction;
	   insert into hoadon( mahoadon , ngaythanhtoan   )
				   values(ma_hoa_don, timestamp(now()));
                   
	   insert into datcho( mave ,  mahoadon  )
				   values(  ve  , ma_hoa_don );
	   commit;
       set i = i + 1;
       end if;
    if i = so_luong or i > max_count
    then leave input_i;
    end if;
    end loop input_i;
end$$
delimiter ;

call create_random_ticket(1000);
call store_random_ticket(1000);

-- select * from vephim;
-- select * from hoadon;
-- select * from datcho;

-- SELECT CURTIME() + INTERVAL 5 MINUTE
-- GRANT ALL privileges ON movie_new.* TO 'root'@'localhost';