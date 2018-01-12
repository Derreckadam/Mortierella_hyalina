#!/bin/sh
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH  --mem-per-cpu=4G
#SBATCH  --time=72:00:00
#SBATCH --job-name megablast.blobs
#SBATCH --output=01_megablast.blobs.%A_%a.out





CPU=$SBATCH_NTASKS

if [ ! $CPU ]; then
 CPU=2
fi
echo "CPU is $CPU"

N=$SLURM_ARRAY_TASK_ID

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
BLASTOUT=$(basename $QUERY .fasta)".megablast"
OUTDIR=reports
mkdir -p $OUTDIR
module load ncbi-blast/2.4.0+
module load db-ncbi
if [ ! -f $OUTDIR/$BLASTOUT ]; then
blastn \
-task megablast \
-query $DIR/$QUERY \
-db $NCBI_DB/nt \
-outfmt '6 qseqid staxids bitscore std sscinames sskingdoms stitle' \
-culling_limit 5 \
-num_threads $CPU \
-evalue 1e-10 \
-out $OUTDIR/$BLASTOUT
fi
