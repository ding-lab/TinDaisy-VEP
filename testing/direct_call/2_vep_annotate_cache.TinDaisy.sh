# Testing for VEP annotation of TinDaisy data using VEP cache
# With ClinVar custom annotation

OUTD="output"
mkdir -p $OUTD

REF="/ref/GRCh38.d1.vd1/GRCh38.d1.vd1.fa"
VCF="/data/call-mnp_filter/execution/MNP_combined.vcf"
#VEP_GZ="/vep/v99/vep-cache.99_GRCh38.tar.gz"
VEP_DIR="/vep"  # this will run with VEP cache but without copying the data
CUSTOM_FILENAME="/clinvar/GRCh38/20200706/clinvar_20200706.vcf.gz"

VEP_VER="99"
ASSEMBLY="GRCh38"

#INPUTS="--input_vcf $VCF --reference_fasta $REF --assembly $ASSEMBLY --vep_cache_version $VEP_VER --vep_cache_gz $VEP_GZ"
INPUTS="--input_vcf $VCF --reference_fasta $REF --assembly $ASSEMBLY --vep_cache_version $VEP_VER --vep_cache_dir $VEP_DIR"

CUSTOM_ARGS="ClinVar,vcf,exact,0,AF_ESP,AF_EXAC,AF_TGP,ALLELEID,CLNDN,CLNDNINCL,CLNDISDB,CLNDISDBINCL,CLNHGVS,CLNREVSTAT,CLNSIG,CLNSIGCONF,CLNSIGINCL,CLNVC,CLNVCSO,CLNVI,DBVARID,GENEINFO,MC,ORIGIN,RS,SSR"

VEP_OPTS="--hgvs --shift_hgvs 1 --no_escape --symbol --numbers --ccds --uniprot --xref_refseq --sift b --tsl --canonical --total_length --allele_number --variant_class --biotype --appris --flag_pick_allele --check_existing --failed 1 --minimal --pick_order biotype,rank,canonical --af --max_af --af_1kg --af_esp --af_gnomad --buffer_size 500  --fork 4"

ARGS="--results_dir $OUTD --custom_filename $CUSTOM_FILENAME --custom_args $CUSTOM_ARGS --vep_opts \"$VEP_OPTS\""

CMD="/usr/bin/perl ../../src/SomaticWrapper.pl $INPUTS $ARGS"

>&2 echo Running $CMD
eval $CMD

