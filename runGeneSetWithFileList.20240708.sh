#!/bin/bash 

# special version using more RAM for FRAS1, which has 9000 variants

# script to run on virtual machine in RAP using Swiss Army Knife app
# need to have run 
# dx cd /
# before submitting this
# then results will end up in subfolders of /results
set -x 

unset DX_WORKSPACE_ID
dx cd $DX_PROJECT_CONTEXT_ID:

dataFilePath="/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - final release/"
dataFileSpec=ukb23158_c

testName=$1
argFile=gva.$testName.arg
chr=$2
geneList=$3
extraFileList=$4
# neededFiles="/pars/gva.UKBB.all.20230807.arg /pars/newWeights.20201231.txt /pars/POLYPHENWEIGHTS.20201231.txt /pars/SIFTWEIGHTS.20201231.txt /covars/ukb23158.common.all.20230806.eigenvec.txt /covars/UKBB.sex.20230807.txt /pars/justScore.tst" 
# neededFiles="/pars/gva.UKBB.all.20230807.arg /pars/newWeights.20201231.txt /pars/POLYPHENWEIGHTS.20201231.txt /pars/SIFTWEIGHTS.20201231.txt " 
# no longer using this, list these files in extraFileList
# omit covariates for t test analysis
# phenotype file should be added on command line as first of otherNeededFiles

mkdir results # probably in folder ~/out/out
mkdir results/$testName
mkdir results/$testName/geneResults
mkdir results/$testName/failed

mkdir ~/workdir
pushd ~/workdir
dx cd /fileLists
dx download $extraFileList
cat $extraFileList | while read f
do
	dx download $f
done
dx cd /geneLists
dx ls -l
dx download $geneList # without previous ls, download failed
dx cd /pars
dx download $argFile
dx cd /bin
dx download scoreassoc
dx download geneVarAssoc
chmod 755 scoreassoc geneVarAssoc
PATH=$PATH:.
dx cd /reference38
dx download refseqgenes.hg38.20191018.sorted.onePCDHG.txt
dx cd /annot
# dx download ukb23158.annot.vcf.gz
# must be specified in fileList
dx cd "$dataFilePath"
dx download $dataFileSpec${chr}_'*'
dx download ukb23158_c22_b0_v1.fam
dx cd /annot
# dx download ukb23158.annot.vcf.gz.tbi # here to make sure it is newer

for f in $neededFiles
do
	dx download $f
done
for f in $otherNeededFiles
do
	dx download $f
done

ls -l

cat $geneList | while read gene
do
#		ulimit -c unlimited
# not allowed to write core and anyway there is no gdb
		geneVarAssoc --arg-file $argFile --gene $gene --keep-temp-files 1
		
		echo range.temp.*.txt :
		cat range.temp.*.txt
		echo gva.*.cont.1.log :
		cat  gva.*.cont.1.log
		echo gva.*.cont.1.vcf :
		cut -f 1-3 gva.*.cont.1.vcf | head
		cut -f 1-3 gva.*.cont.1.vcf | tail
		cut -f 1-3 gva.*.cont.1.vcf | wc
		plink --bed ukb23158_c${chr}_b0_v1.bed --fam ukb23158_c22_b0_v1.fam --bim ukb23158_c${chr}_b0_v1.bim --extract range range.temp.*.txt --set-hh-missing --make-bed --out plink.temp
		echo plink.temp.bim  :
		wc plink.temp.bim 
		head plink.temp.bim
		tail plink.temp.bim
		cat plink.temp.log
		
		plink --bed plink.temp -set-hh-missing --recode vcf-iid --out plink.vcf
		cat plink.vcf.log
		cut -f 1-3 plink.vcf.vcf | head
		cut -f 1-3 plink.vcf.vcf | tail
		cut -f 1-3 plink.vcf.vcf | wc
		
		
		
		ls -lrt
				
		if [ -e *.$gene.sco ] # was *.$gene.sao
		then
			pushd
			cp ~/workdir/*.$gene.s?o results/$testName/geneResults
			pushd
		else
#			echo bt | gdb geneVarAssoc core
			echo $gene > $gene.failed.txt
#			echo bt | gdb geneVarAssoc core $gene.failed.txt
# if there was a core, I could copy it to output
			ls -lrt  >> $gene.failed.txt
			wc *.vcf >> $gene.failed.txt
			pushd
			cp ~/workdir/$gene.failed.txt results/$testName/failed
			pushd
		fi
done
popd

# invoke with:
# gene=DNMT3A; chr=2; model=UKBB.HT.20230807; geneList=$gene.txt; testName=$model
# echo $gene > $geneList; dx cd  /geneLists; dxupload $geneList
# dx rm /results/$testName/geneResults/'*'.$gene.s'?'o ; dx rm /results/$testName/failed/$gene.failed.txt
# dx cd / ; dx run swiss-army-knife -y --instance-type mem3_hdd2_v2_x4  -imount_inputs=FALSE -iin="/scripts/runGeneSet.20230816.sh" -icmd="bash runGeneSet.20230816.sh $model $chr $geneList /phenos/UKBB.HT.20230816.txt"
# info re instance types is here: https://documentation.dnanexus.com/developer/api/running-analyses/instance-types




