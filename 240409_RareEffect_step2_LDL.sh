pheno=f.30780.0.0
file=~/data/RareEffect/genelist/f.30780.0.0_top10.txt

while IFS=$'\t' read -r chr gene pval
do
    echo ${chr} ${gene} ${pval}
    dx run swiss-army-knife \
        -iin="UKB_Main:/WES_470k/Plink_QC/plink_files/merged_by_chr${chr}.norm.bed" \
        -iin="UKB_Main:/WES_470k/Plink_QC/plink_files/merged_by_chr${chr}.norm.bim" \
        -iin="UKB_Main:/WES_470k/Plink_QC/plink_files/merged_by_chr${chr}.norm.fam" \
        -iin="UKB_Main:/WES_470k/group_files_LOFTEE/loftee_groupfile_chr${chr}.withQC.txt" \
        -iin="UKB_Main:/WES_470k/kisung/RareEffect/step1/step1_all_${pheno}_LDL_adjusted.rda" \
        -icmd="Rscript /app/RareEffect.R \
            --rdaFile=step1_all_${pheno}_LDL_adjusted.rda \
            --chrom=${chr} \
            --geneName=${gene} \
            --groupFile=loftee_groupfile_chr${chr}.withQC.txt \
            --traitType=quantitative \
            --plinkFile=merged_by_chr${chr}.norm \
            --macThreshold=10 \
            --outputPrefix=RareEffect_all_${pheno}_${gene}" \
        -iimage_file=/docker_images/rvprs_0.99.tar.gz \
        --destination UKB_Main:/WES_470k/kisung/RareEffect/step2 \
        --name RareEffect_${pheno}_${gene} \
        --instance-type=mem3_ssd1_v2_x32 \
        --yes
done < ${file}

