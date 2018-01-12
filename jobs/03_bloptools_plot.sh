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

blobtools blobplot --infile $NAME.blob.BlobDB.json \
 -o $NAME --title "$NAME"  --format pdf

blobtools blobplot --infile $NAME.blob.BlobDB.json \
 -o $NAME --title "$NAME"  --format png
