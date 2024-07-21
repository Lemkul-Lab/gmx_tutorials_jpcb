set terminal png nocrop enhanced size 620,520 
#set terminal png transparent nocrop enhanced size 620,520 
set output 'norm_hist_d1_d2.png'
set border -1 lw 3
set xlabel "Projection on Eigenvector 1 (u^{1/2} nm)" 
set xlabel  font "" textcolor lt -1 norotate
set xrange [ -12 : 12 ] noreverse nowriteback
set ylabel "Projection on Eigenvector 2 (u^{1/2} nm)" 
set ylabel  font "" textcolor lt -1 rotate by 90
set yrange [ -12 : 12 ] noreverse nowriteback
set zrange [ 0.001:0.021] noreverse nowriteback 
unset surface
set view map
set contour base
set style data pm3d
set pm3d implicit at b
#set palette rgbformulae 30, 31, 32
set palette rgbformulae 33, 13, 10
unset colorbox
unset key
#set palette negative
splot "norm_hist_d1_d2.dat" with pm3d
# pause -1

