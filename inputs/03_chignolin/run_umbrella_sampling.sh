#!/bin/bash

mkdir umbrella
cd umbrella

for (( i=0; i<=25; i++ ))
do
    echo "## RUNNING WINDOW ${i} ##"

    # equilibrate in each window
    gmx grompp -f ../inputs/nvt.mdp -c ../window${i}.gro -r ../window${i}.gro -p ../topol.top -o nvt${i}.tpr
    gmx mdrun -v -nb gpu -deffnm nvt${i}

    gmx grompp -f ../inputs/npt.mdp -c nvt${i}.gro -t nvt${i}.cpt -r nvt${i}.gro -p ../topol.top -o npt${i}.tpr
    gmx mdrun -v -nb gpu -deffnm npt${i}

    # generate .mdp file for umbrella sampling from template
    dist=`echo 0.5 + $i*0.1 | bc | sed "s/^\./0\./g"`
    sed "s/XX/${dist}/g" ../inputs/us.tmpl > ../inputs/us${i}.mdp

    # Equilibrate 
    gmx grompp -f ../inputs/us${i}.mdp -c npt${i}.gro -t npt${i}.cpt -n ../index.ndx -p ../topol.top -o us${i}.tpr
    gmx mdrun -v -nb gpu -deffnm us${i}  
done
