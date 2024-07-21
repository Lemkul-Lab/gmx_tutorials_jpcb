#set terminal png nocrop enhanced size 820,620 
#set terminal png transparent nocrop enhanced size 620,520 
set size square
set terminal png nocrop enhanced
set output 'free_ener_d1_d2.png'
set border -1 lw 1
set encoding iso_8859_1 
set xlabel "Projection on Eigenvector 1 (u^{1/2} nm)" 
set xlabel  font "Helvetica, 14" textcolor lt -1 norotate
set xrange [ -12 : 12 ] noreverse nowriteback
set xtics -12,3,12 font "Helvetica,12"
set ylabel "Projection on Eigenvector 2 (u^{1/2} nm)" 
set ylabel  font "Helvetica, 14" textcolor lt -1 rotate by 90
set yrange [ -12 : 12 ] noreverse nowriteback
set ytics -12,3,12 font "Helvetica,12"
set zrange [ 0.0:4.0 ] noreverse nowriteback 
unset surface
set view map
set contour base
set style data pm3d
set pm3d implicit at b
#set palette rgbformulae 30, 31, 32
set palette rgbformulae 33, 13, 10
unset colorbox
unset key
set palette negative
set key on outside
set cbrange[0:4]
set colorbox vertical noborder
show colorbox
splot "free_ener.dat" notitle with pm3d
# pause -1

