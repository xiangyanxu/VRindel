#!/bin/bash
insertion_result=$1
ref=$2
virtual_ref=$3
fastq_1=$4
fastq_2=$5
java -classpath ../VRindel readCount.ToFinalFa ${insertion_result} ${ref} ${virtual_ref} "pos_info.txt"
../software/bwa-0.7.5a/./bwa index ${virtual_ref}
../software/bwa-0.7.5a/./bwa mem ${virtual_ref} ${fastq_1} ${fastq_2} >final.sam
java -classpath ../VRindel readCount.ProcessSam "final.sam" "final_process.sam"
../software/samtools-0.1.18/./samtools view -S final_process.sam -b>fina_process.bam
../software/samtools-0.1.18/./samtools sort fina_process.bam final_process.sort
../software/samtools-0.1.18/./samtools index final_process.sort.bam
../software/samtools-0.1.18/./samtools depth final_process.sort.bam>final_process.depth.txt
java -classpath ../VRindel readCount.Pvalue "final_process.depth.txt" "pos_info.txt" "hytero_process_result.txt"
cp hytero_process_result.txt ../output/hetero_homo_result.txt
rm -f hytero_process_result.txt
rm final_process*
rm *.sam
rm *.bam
rm ${virtual_ref}*
rm -f pos_info.txt
rm -f temp.txt
