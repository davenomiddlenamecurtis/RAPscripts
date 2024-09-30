#!/bin/bash 

# script to run on virtual machine in RAP using Swiss Army Knife app

# need to have run 
# dx cd /
# before submitting this

# dx cd / ; dx run swiss-army-knife -y --ignore-reuse --instance-type mem3_hdd2_v2_x4  -imount_inputs=FALSE -iin="/scripts/getVCFheads.sh" -icmd="bash getVCFheads.sh"
argFile=gva.extractExons.arg
phenoFile=UKBB.DEMMax2.20240901.txt
refGeneFile=refseqgenes.hg38.20191018.sorted.onePCDHG.txt 

set -x 

unset DX_WORKSPACE_ID
dx cd $DX_PROJECT_CONTEXT_ID:
WGSdir='/Bulk/DRAGEN WGS/DRAGEN population level WGS variants, pVCF format [500k release]'
VCFs="ukb24310_c1_b0_v1.vcf.gz ukb24310_c1_b1_v1.vcf.gz"

HOMEDIR=`pwd`
mkdir WGS
mkdir WGS/VCFs
cd WGS/VCFs

mkdir ~/workdir
pushd ~/workdir
dx cd /pars
dx download $argFile
dx cd /bin
dx download geneVarAssoc
chmod 755 geneVarAssoc
dx cd /phenos
dx download $phenoFile
dx cd /reference38
dx download $refGeneFile

dx cd "$WGSdir"
dx cd chr1
date
date
dx download ukb24310_c1_b2924_v1.vcf.gz
date
dx download ukb24310_c1_b2925_v1.vcf.gz
date
dx download ukb24310_c1_b2926_v1.vcf.gz
date
dx download ukb24310_c1_b2927_v1.vcf.gz
date
date
dx download ukb24310_c1_b2924_v1.vcf.gz.tbi
date
dx download ukb24310_c1_b2925_v1.vcf.gz.tbi
date
dx download ukb24310_c1_b2926_v1.vcf.gz.tbi
date
dx download ukb24310_c1_b2927_v1.vcf.gz.tbi
date
tabix -h ukb24310_c1_b2924_v1.vcf.gz chrY:0-0 > OMA1.exons.vcf
wc OMA1.exons.vcf
date
ls -lrt
./geneVarAssoc --arg-file $argFile --case-file ukb24310_c1_b2924_v1.vcf.gz --gene OMA1
mv gva.OMA1.case.1.vcf ukb24310_c1_b2924_v1.vcf.gz.exons.vcf
date
ls -lrt
./geneVarAssoc --arg-file $argFile --case-file ukb24310_c1_b2925_v1.vcf.gz --gene OMA1
mv gva.OMA1.case.1.vcf ukb24310_c1_b2925_v1.vcf.gz.exons.vcf
date
ls -lrt
./geneVarAssoc --arg-file $argFile --case-file ukb24310_c1_b2926_v1.vcf.gz --gene OMA1
mv gva.OMA1.case.1.vcf ukb24310_c1_b2926_v1.vcf.gz.exons.vcf
date
ls -lrt
./geneVarAssoc --arg-file $argFile --case-file ukb24310_c1_b2927_v1.vcf.gz --gene OMA1
mv gva.OMA1.case.1.vcf ukb24310_c1_b2927_v1.vcf.gz.exons.vcf
date
ls -lrt
date
cat ukb24310_c1_b2924_v1.vcf.gz.exons.vcf | grep -v '^\#' >>OMA1.exons.vcf
date
cat ukb24310_c1_b2925_v1.vcf.gz.exons.vcf | grep -v '^\#' >>OMA1.exons.vcf
date
cat ukb24310_c1_b2926_v1.vcf.gz.exons.vcf | grep -v '^\#' >>OMA1.exons.vcf
date
cat ukb24310_c1_b2927_v1.vcf.gz.exons.vcf | grep -v '^\#' >>OMA1.exons.vcf
date
date
ls -lrt
bgzip OMA1.exons.vcf
date
tabix -p vcf OMA1.exons.vcf.gz
date
ls -lrt
pushd
date
cp ~/workdir/OMA1.exons.vcf.gz .
cp ~/workdir/OMA1.exons.vcf.gz.tbi .
date
cd $HOMEDIR
# dx cd /scripts ; dxupload extractExons.OMA1.sh
# dx cd / ; dx run swiss-army-knife -y --ignore-reuse --instance-type mem3_ssd2_v2_x4  -imount_inputs=FALSE -iin=/scripts/extractExons.OMA1.sh -icmd="bash extractExons.OMA1.sh"
# maybe use ssd for this
