#1 Tim tat ca cac phim dang va da chieu 
select * from phim
where now() > khoi_chieu;

#2 Tim tat ca cac phim sap chieu
select * from phim 
where now() < khoi_chieu;

#3 Tim cac ve phim da dat cua 1 phim vao ngay hom nay 
select vp.* from vephim vp, lichphim lp, phim f
where 
vp.malich = lp.malich and
lp.ngayxem = date(now()) and
f.maphim = lp.maphim and
lower(tenphim) like lower('%người nhện%');

#4 Tong doanh thu den hom nay
select (count(mave) * 100000) as 'Doanh thu (VND)' from datcho 
where mahoadon in (
	select mahoadon from hoadon
    where ngaythanhtoan < timestamp(now())
);

#5 Xoa ve da qua han ma van chua thanh toan
delete from vephim
where mave in (
    select mave from (
		select mave from vephim
		where mave not in (
			select mave from datcho
		)
    ) as tracuuve
);  

#6 Lay thong tin tu hoa don
# hang, cot, ten phim, ca -> gio chieu, ngay xem
select f.tenphim, cp.tg_bd, vp.hang, vp.cot, lp.ca_chieu ,lp.ngayxem
from phim f, caphim cp, vephim vp, lichphim lp, datcho dc, 
     (select mahoadon from datcho order by rand() limit 1) as t
where 
dc.mahoadon = t.mahoadon and
dc.mave = vp.mave and
vp.malich = lp.malich and
cp.ca_chieu = lp.ca_chieu and
f.maphim = lp.maphim;

#7 Tra cuu lich xem phim 
select f.tenphim, lp.maphongphim ,cp.tg_bd, lp.ca_chieu, lp.ngayxem
from phim f, caphim cp, lichphim lp
where 
f.maphim = '' and
lp.maphim = f.maphim and
cp.ca_chieu = lp.ca_chieu;

#8 Loc phim
select * from phim
where lower(theloai) like lower('%Lãng mạn%Viễn tưởng%');


