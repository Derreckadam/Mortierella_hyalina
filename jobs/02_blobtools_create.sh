#!/usr/bin/bash
#SBATCH --mem=4G


module load blobtools/0.9.17 
N=${SLURM_ARRAY_TASK_ID}

if [ ! $N ] ; then
 N=$1
fi

if [ ! $N ]; then
 echo "need a line number for array jobs defaulting to 1"
 N=1
fi
LIST=list.txt
DIR=./
QUERY=$(sed -n ${N}p $LIST)
OUTDIR=reports
NAME=$(basename $QUERY .fasta)
BLASTOUT=$OUTDIR/$NAME".megablast"

if [ ! -f $(pwd)/data/nodesDB.txt ]; then
blobtools create --infile $DIR/$QUERY --out $NAME.blob --title "$NAME"  \
--taxfile $BLASTOUT --db $(pwd)/data/nodesDB.txt -y spades \
--nodes taxonomy/nodes.dmp --names taxonomy/names.dmp 
else
# after first run the nodes file is created, no need to recreat
blobtools create --infile $DIR/$QUERY --out $NAME.blob --title "$NAME" \
--taxfile $BLASTOUT --db $(pwd)/data/nodesDB.txt -y spades
fi
