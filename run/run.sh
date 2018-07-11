#!/bin/bash
ref=$1
chr_name=$2
touch "choosed_unit.txt"
cp ${ref} test1.fa
da="test"
db="1"
dc=${da}${db}
dd="out1_"
ee="out2_"
ddc=${dd}${db}
ddd=${ee}${db}
count=1
flag=20
while (test -e ${dc}".fa")
do
	../software/bwa-0.7.5a/./bwa index ${dc}".fa"
	../software/bwa-0.7.5a/./bwa mem ${dc}".fa" "../input/out1_1.fq" "../input/out2_1.fq">${dc}".sam"
	../software/samtools-0.1.18/./samtools view -S ${dc}".sam" -b > ${dc}".bam"
	../software/samtools-0.1.18/./samtools sort -n ${dc}".bam" ${dc}".sort"
	../software/samtools-0.1.18/./samtools view -h ${dc}".sort.bam" >${dc}".sam"
	java -classpath ../VRindel new_longInsertion.Test $da $db ${chr_name}
	let db=$db+1
	echo $db
	dc=${da}${db}
	ddc=${dd}${db}
	ddd=${ee}${db}
	if [[ $count -gt $flag ]]
	then			
		break
	fi
	let count=$count+1
done
let db=$db-1
dc=${da}${db}
touch "deletion_result.txt"
java -classpath ../VRindel output_all.NewOutputAll  ${ref} ${dc}".fa" "insertion_result.txt" "deletion_result.txt"
#cp ${dc}".fa" final.fa
cp test1_i_pos_seq.txt first_filter.txt
java -classpath ../VRindel filter.Fileter ${ref} "first_filter.txt" "insertion_result.txt" "final_insertion_result.txt"
cp final_insertion_result.txt ../output/insertion_result.txt
rm -f final_insertion_result.txt
rm -f final_del_result.txt
rm -f final_del_result1.txt

rm -f test*
rm -f out*
rm -f temp.sam
rm -f deletion_result.txt
rm -f insertion_result.txt
rm -f out1_*
rm -f out2_*
rm -f out2.fq
rm -f temp_fqname.lst
rm -f discordant.sam
rm -f hang.sam
rm -f read_ref.txt
rm -f choosed_unit.txt
rm -f result.txt
rm -f result1.txt
rm -f first_filter.txt
rm -f temp_insertion_result.txt
