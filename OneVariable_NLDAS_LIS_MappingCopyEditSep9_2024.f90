!! This code was developed by Dr. Mohammad Al-Hamdan for mapping NLDAS and LIS data from one day of an annual array ouput file

USE MSFLIB
USE PORTLIB


real aa(1625400,3), bb(840,1935)
character option*45 
integer q,m

		  
open (1116,file='Yearly_Average_IDW.txt',status='unknown')

open(1,file='line_one_day.txt',status='unknown')

open (2,file='Yearly_Average_IDW_2020.asc',status='unknown')

write(2,'(a18)') 'ncols         1935'
write(2,'(a17)') 'nrows         840'
write(2,'(a23)') 'xllcorner     -124.9850'
write(2,'(a21)') 'yllcorner     24.2961'
write(2,'(a19)') 'cellsize      0.030'
write(2,'(a19)') 'NODATA_value  -9999'


read(1116,*)

do l=1,1625400
	read(1116,*) (aa(l,k), k=1,3)
	do k=1,3
	if (k.eq.3) write(1,'(f7.1)') aa(l,k)	 ! July 1, 1986 (Day 182)  is column 183  ! Jan 1, 2005 (Day 1)  is column 2
	!!if (k.eq.3) write(*,*) aa(l,k)
	!!pause
	enddo
enddo


close(1)

open(1,file='line_one_day.txt',status='unknown')


!open(1)

do i=1,840
 	do j=1,1935
	read(1,*)bb(i,j)
	if (bb(i,j).lt.0.00000000000) bb(i,j)=0	   !This was added on Sep. 9, 2024 to replace negative values with Zeros.
!	write(*,*) bb(i,j)
!	pause
	enddo
enddo


do m=1,840
	write(2,'(1935(f7.1,1x))') (bb(m,q),q=1,1935)
enddo

close (2)

option='asciigrid ascii_one_day.txt 1_2005Ins float'
write(*,*) option
result=runqq('arc ',option) 

	
end



!option='asciigrid '//abc//'th_run_grid'//'.txt '//abc//'th_run'//' float'
!result=runqq('arc ',option) 



	!option='kill '//abc//'th_run'
	!result=runqq('arc ',option) 

!	option='asciigrid '//abc//'th_run_grid'//'.txt '//abc//'th_run'//' float'
!	result=runqq('arc ',option) 
	
!	if(i.eq.5) then

 !option='gridimage '//abc//'th_run Arc50colors.txt u:\usra_research\helix\sites_data\tifss\'//RUNYR(1:4)//adoy//' TIFF'

!	result=runqq('arc ',option) 
