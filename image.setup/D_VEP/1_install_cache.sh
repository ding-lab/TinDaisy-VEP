CACHED="/data/image.data/D_VEP"
mkdir -p $CACHED

CWD=`pwd`
cd /usr/local/ensembl-vep

#perl INSTALL.pl -a cf -s homo_sapiens -y GRCh37,GRCh38 --CACHEDIR $CACHED
perl INSTALL.pl -a cf -s homo_sapiens -y GRCh37 --CACHEDIR $CACHED
perl INSTALL.pl -a cf -s homo_sapiens -y GRCh38 --CACHEDIR $CACHED

cd $CWD
