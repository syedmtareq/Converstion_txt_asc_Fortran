
!! This code was developed by Dr. Mohammad Al-Hamdan 
!! Modified to process multiple days (1-365)

!!USE MSFLIB
!!USE PORTLIB

real aa(1625400,3), bb(840,1935)
character option*100, file_input*50, file_output*50, day_str*3
integer q, m, day

! Loop through all days (1-365)
do day = 358, 358
    write(day_str, '(I3.3)') day  ! Convert day to 3-digit format (001, 002, ..., 365)

    ! Define input and output file names dynamically for each day
    file_input = 'Final_Results_IDW_noQC_Surface_DOY' // day_str // '_v1_mod1.txt'
    file_output = 'Final_Results_2021_DOY' // day_str // '.asc'

    ! Open the input file (PM2.5 values for that day)
    open(1116, file=file_input, status='unknown', action='read')

    ! Open intermediate and output files
    open(1, file='line_one_day.txt', status='unknown')
    open(2, file=file_output, status='unknown')

    ! Write ArcGIS ASCII Grid header
    write(2, '(a18)') 'ncols         1935'
    write(2, '(a17)') 'nrows         840'
    write(2, '(a23)') 'xllcorner     -125.0000'
    write(2, '(a21)') 'yllcorner     24.2811'
    write(2, '(a19)') 'cellsize      0.030'
    write(2, '(a19)') 'NODATA_value  -9999'

    ! Read PM2.5 values for that day
    read(1116, *)  ! Skip the header

    do l = 1, 1625400
        read(1116, *) (aa(l, k), k = 1, 3) 
        if (aa(l, 3) .lt. 0.0) aa(l, 3) = 0.0  ! Replace negative values with zero
        write(1, '(f7.1)') aa(l, 3)  ! Write PM2.5 values for this day
    enddo

    close(1)
    close(1116)

    ! Open the PM2.5 file again for processing
    open(1, file='line_one_day.txt', status='unknown')

    ! Store PM2.5 values in the grid
    do i = 1, 840
        do j = 1, 1935
            read(1, *) bb(i, j)
            if (bb(i, j) .lt. 0.0) bb(i, j) = 0.0  ! Ensure no negative values
        enddo
    enddo

    ! Write the final ASCII grid file
    do m = 1, 840
        write(2, '(1935(f7.1,1x))') (bb(m, q), q = 1, 1935)
    enddo

	close(1)
	!result3=system("del line_one_day.txt")
	
	close(2)

    ! Run ArcGIS conversion for the day
    !option = 'asciigrid ' // file_output // ' float'
    !write(*, *) option
    !result = runqq('arc ', option)

enddo

end
