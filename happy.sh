#!/bin/bash 

# script to run on virtual machine in RAP using Swiss Army Knife app

# need to have run 
# dx cd /
# before submitting this

# dx cd / ; dx run swiss-army-knife -y --ignore-reuse --instance-type mem3_hdd2_v2_x4  -imount_inputs=FALSE -iin="/scripts/getVCFheads.sh" -icmd="bash getVCFheads.sh"

set -x 

date
echo "I am a happy app which does nothing useful at all" >happy.txt
date
echo "I am a happy app which does nothing useful at all"
date

# dx cd /scripts ; dxupload happy.sh
# dx cd / ; dx run swiss-army-knife -y --ignore-reuse --instance-type mem3_hdd2_v2_x4  -imount_inputs=FALSE -iin=/scripts/happy.sh -icmd="bash happy.sh"
