# write_wham_files.py - writes the text files needed by gmx wham
# to perform the WHAM analysis.

tprfile = open('tpr-files.dat', 'w')
ffile   = open('pullf-files.dat', 'w')

for i in range(0,26):
    tprfile.write('umbrella/us%d.tpr\n' % (i))
    ffile.write('umbrella/us%d_pullf.xvg\n' % (i))

exit()


