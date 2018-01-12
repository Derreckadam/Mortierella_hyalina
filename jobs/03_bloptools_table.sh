#PBS -l nodes=1:ppn=1,mem=4gb -j oe -N blobplot.table
module load blobtools/0.9.17 
N=$PBS_ARRAYID
if [ ! $N ] ; then
 N=$1
fi

if [ ! $N ]; then
 echo "need a line number for array jobs defaulting to 1"
 N=1
fi
LIST=list.txt
DIR=genomes
QUERY=$(sed -n ${N}p $LIST)
OUTDIR=reports
NAME=$(basename $QUERY .fasta)

blobtools view --infile $NAME.blob.BlobDB.json -o $NAME.table --hits

