drop database if exists movie_new;
create database if not exists movie_new;
use movie_new;

drop table if exists phongphim;
create table if not exists phongphim (
  maphongphim int not null auto_increment, 
  sohang int not null,
  socot int not null,
  primary key(maphongphim)
);

drop table if exists phim;
create table if not exists phim (
  maphim int not null auto_increment, 
  tenphim varchar(30) not null,
  thoigian int,
  theloai json,
  ngonngu varchar(20), 
  rate varchar(20),
  trailer varchar(50),
  khoi_chieu date,
  ghichu varchar(600),
  bia varchar(200),
  danhgia int, 
  primary key(maphim)
);

drop table if exists caphim;
create table if not exists caphim (
  ca_chieu int,
  tg_bd time,
  tg_kt time,
  primary key(ca_chieu)
);

drop table if exists lichphim;
create table if not exists lichphim (
  malich int not null auto_increment,
  maphim int ,
  maphongphim int,
  ngayxem date,
  ca_chieu int,
  unique(maphongphim, ngayxem, ca_chieu),
  primary key(malich)
);

drop table if exists hoadon;
create table if not exists hoadon (
  mahoadon varchar(50) not null,
  ngaythanhtoan timestamp,
  primary key(mahoadon)
);

drop table if exists vephim;
create table if not exists vephim (
  mave varchar(50) not null,
  malich int,
  hang int not null,
  cot int not null,
  han time,
  primary key(mave),
  unique(malich, hang, cot)
);

drop table if exists datcho;
create table if not exists datcho (
  mave varchar(50),
  mahoadon varchar(50),
  primary key(mave)
);

alter table lichphim
	add constraint lp_phong
	foreign key(maphongphim)
	references phongphim(maphongphim)
  on update cascade
  on delete cascade;
  
alter table lichphim 
  add constraint lp_phim
	foreign key(maphim)
	references phim(maphim)
  on update cascade
  on delete cascade;

alter table vephim
	add constraint ve_lichxem
	foreign key(malich)
	references lichphim(malich)
  on update cascade
  on delete cascade;
  
alter table lichphim
	add constraint ca_lichxem
	foreign key(ca_chieu)
	references caphim(ca_chieu)
  on update cascade
  on delete cascade;
  
alter table datcho 
add constraint 
	foreign key(mahoadon)
	references hoadon(mahoadon)
  on update cascade
  on delete cascade;