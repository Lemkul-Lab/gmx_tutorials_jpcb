# USAGE$ perl hist2.pl data.txt -180 15 180 -180 15 180

open(file,$ARGV[0]);

$amin=$ARGV[1];
$abinw=$ARGV[2];
$amax=$ARGV[3];
$bmin=$ARGV[4];
$bbinw=$ARGV[5];
$bmax=$ARGV[6];

# compute number of histogram bins 
$ni=($amax-$amin)/$abinw;
$nj=($bmax-$bmin)/$bbinw;

# Build the histograms
for($i=0; $i<=$ni; $i++)
{
    for($j=0; $j<=$nj; $j++)
    {
        $hist[$i][$j]=0;
    }
}

$line=<file>;
while($line)
{
    ($a,$b)= split(" ",$line);

    # assign bin indices
    $abin = int(($a-$amin)/$abinw);
    $bbin = int(($b-$bmin)/$bbinw);

    $hist[$abin][$bbin]++;

    $line = <file>;
}
close(file);

# Print the raw histograms
open(SUMMARY1, ">hist_d1_d2.dat");

for($i=0; $i<=$ni; $i++)
{
    for($j=0; $j<=$nj; $j++)
    {
        $phi = ($i*$abinw) + $amin;
        $psi = ($j*$bbinw) + $bmin;
        print SUMMARY1 $phi."\t".$psi."\t".$hist[$i][$j]."\n";
    }
    print SUMMARY1 "\n";
}
close(SUMMARY1);

# Normalize the histograms
$tot=0;
for($i=0; $i<=$ni; $i++)
{
	for($j=0; $j<=$nj; $j++)
    {
		$tot += $hist[$i][$j];
	}
}

for($i=0; $i<=$ni; $i++)
{
    for($j=0; $j<=$nj; $j++)
    {
        $norm_hist[$i][$j] = 0;
    }
}

for($i=0; $i<=$ni; $i++)
{
    for($j=0; $j<=$nj; $j++)
    {
        $norm_hist[$i][$j] = $hist[$i][$j]/$tot;
    }
}

# Print the normalized histograms
open(SUMMARY2, ">norm_hist_d1_d2.dat");

for($i=0; $i<=$ni; $i++)
{
    for($j=0; $j<=$nj; $j++)
    {
        $phi = ($i*$abinw) + $amin;
        $psi = ($j*$bbinw) + $bmin;
        printf SUMMARY2 "%4.1f \t %4.1f \t %1.3f\n", $phi, $psi, $norm_hist[$i][$j];
    }
    print SUMMARY2 "\n";
}
close(SUMMARY2);

# Boltzmann weight to get free energy
# -log(histogram)
for($i=0; $i<=$ni; $i++)
{
    for($j=0; $j<=$nj; $j++)
    {
        if($norm_hist[$i][$j] != 0)
        {
            $free_ener[$i][$j] = 0;
        }
    }
}

# create a temporary array with non-zero values
# to avoid trying to take the -log(0) 

for($i=0; $i<=$ni; $i++)
{
    for($j=0; $j<=$nj; $j++)
    {
        $temp[$i][$j] = 0.99999;
    }
}

for($i=0; $i<=$ni; $i++)
{
    for($j=0; $j<=$nj; $j++)
    {
	    if ($norm_hist[$i][$j] != 0)
        {
		    $temp[$i][$j] = $norm_hist[$i][$j];
	    }
	}
}

for($i=0; $i<=$ni; $i++)
{
    for($j=0; $j<=$nj; $j++){
        $free_ener[$i][$j]=-0.59*log($temp[$i][$j]);
    }
}

## offset to the lowest free energy
# first, find the minimum real value in the free energy matrix
$min=10000000;
for($i=0; $i<=$ni; $i++)
{
    for($j=0; $j<=$nj; $j++)
    {
        if ($free_ener[$i][$j] < $min)
        {
            $min = $free_ener[$i][$j];
        }
    }
}

# do the offset
for($i=0; $i<=$ni; $i++)
{
    for($j=0; $j<=$nj; $j++)
    {
        $free_ener[$i][$j] -= $min;
    }
}

# Here, zero does not actually mean zero, it means regions of no sampling
# so it is inherently wrong. Loop back over and in the case of zero values,
# insert absurdly high number and re-do the offset
for($i=0; $i<=$ni; $i++)
{
    for($j=0; $j<=$nj; $j++)
    {
        if ($free_ener[$i][$j] == 0)
        {
            $free_ener[$i][$j] = 1000;
        }
    }
}
 
$min=500;
for($i=0; $i<=$ni; $i++)
{
    for($j=0; $j<=$nj; $j++)
    {
        if ($free_ener[$i][$j] < $min)
        {
            $min=$free_ener[$i][$j];
        }
    }
}

# do the offset
for($i=0; $i<=$ni; $i++)
{
    for($j=0; $j<=$nj; $j++)
    {
        $free_ener[$i][$j] -= $min;
    }
}

open(SUMMARY3, ">free_ener.dat");

for($i=0; $i<=$ni; $i++)
{
    for($j=0; $j<=$nj; $j++)
    {
        $phi = ($i*$abinw) + $amin;
        $psi = ($j*$bbinw) + $bmin;
        printf SUMMARY3 "%4.1f \t %4.1f \t %1.3f\n", $phi, $psi, $free_ener[$i][$j];
    }
    print SUMMARY3 "\n";
}
close(SUMMARY3);

exit;
