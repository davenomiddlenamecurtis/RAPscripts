#!/bin/bash 

# script to run on virtual machine in RAP using Swiss Army Knife app

# need to have run 
# dx cd /
# before submitting this

# dx cd / ; dx run swiss-army-knife -y --ignore-reuse --instance-type mem3_hdd2_v2_x4  -imount_inputs=FALSE -iin="/scripts/getVCFheads.sh" -icmd="bash getVCFheads.sh"

set -x 

unset DX_WORKSPACE_ID
dx cd $DX_PROJECT_CONTEXT_ID:

WGSdir='/Bulk/DRAGEN WGS/DRAGEN population level WGS variants, pVCF format [500k release]'
VCFs="ukb24310_c1_b0_v1.vcf.gz ukb24310_c1_b1_v1.vcf.gz"

mkdir WGS
mkdir WGS/VCFs
cd WGS/VCFs

mkdir ~/workdir
pushd ~/workdir

dx cd "$WGSdir"
dx cd chr1
dx download ukb24310_c1_b2924_v1.vcf.gz
dx download ukb24310_c1_b2925_v1.vcf.gz
dx download ukb24310_c1_b2926_v1.vcf.gz
dx download ukb24310_c1_b2927_v1.vcf.gz
dx download ukb24310_c1_b2924_v1.vcf.gz.tbi
dx download ukb24310_c1_b2925_v1.vcf.gz.tbi
dx download ukb24310_c1_b2926_v1.vcf.gz.tbi
dx download ukb24310_c1_b2927_v1.vcf.gz.tbi
tabix -h ukb24310_c1_b2924_v1.vcf.gz chr1:0-0 > OMA1.vcf
tabix ukb24310_c1_b2924_v1.vcf.gz chr1:0-300000000 >>OMA1.vcf
tabix ukb24310_c1_b2925_v1.vcf.gz chr1:0-300000000 >>OMA1.vcf
tabix ukb24310_c1_b2926_v1.vcf.gz chr1:0-300000000 >>OMA1.vcf
tabix ukb24310_c1_b2927_v1.vcf.gz chr1:0-300000000 >>OMA1.vcf
bgzip OMA1.vcf
tabix -p vcf OMA1.vcf.gz
ls -lrt
pushd
cp /home/rejudcu/workdir/OMA1.vcf.gz .
cp /home/rejudcu/workdir/OMA1.vcf.gz.tbi .
# dx cd /scripts ; dxupload extract.OMA1.sh
# dx cd / ; dx run swiss-army-knife -y --ignore-reuse --instance-type mem3_hdd2_v2_x4  -imount_inputs=FALSE -iin=/scripts/extract.OMA1.sh -icmd="bash extract.OMA1.sh"
