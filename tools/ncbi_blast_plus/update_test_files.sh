#!/bin/sh
echo "This will update test files using the current version of BLAST+"

if [ -f "tools/ncbi_blast_plus/make_ncbi_blast_plus.sh" ]
then
echo "Good, in the expected directory"
else
echo "ERROR. Run this from the GitHub repository root directory."
exit 1
fi

cd test-data

echo "blastn_rhodopsin_vs_three_human.tabular"
blastn -query rhodopsin_nucs.fasta -subject three_human_mRNA.fasta -task megablast -evalue 1e-40 -out blastn_rhodopsin_vs_three_human.tabular -outfmt 6

echo "blastp_four_human_vs_rhodopsin.xml"
blastp -query four_human_proteins.fasta -subject rhodopsin_proteins.fasta -task blastp -evalue 1e-08 -out blastp_four_human_vs_rhodopsin.xml -outfmt 5 -seg no -matrix BLOSUM62 -parse_deflines

echo "blastx_rhodopsin_vs_four_human.xml"
blastx -query rhodopsin_nucs.fasta -subject four_human_proteins.fasta -query_gencode 1 -evalue 1e-10 -out blastx_rhodopsin_vs_four_human.xml -outfmt 5

echo "blastx_rhodopsin_vs_four_human.tabular"
blastx -query rhodopsin_nucs.fasta -subject four_human_proteins.fasta -query_gencode 1 -evalue 1e-10 -out blastx_rhodopsin_vs_four_human.tabular -outfmt 6

echo "blastx_rhodopsin_vs_four_human_ext.tabular"
blastx -query rhodopsin_nucs.fasta -subject four_human_proteins.fasta -query_gencode 1 -evalue 1e-10 -out blastx_rhodopsin_vs_four_human_ext.tabular -outfmt "6 std sallseqid score nident positive gaps ppos qframe sframe qseq sseq qlen slen"

echo "tblastn_four_human_vs_rhodopsin.xml"
tblastn -query four_human_proteins.fasta -subject rhodopsin_nucs.fasta -evalue 1e-10 -out tblastn_four_human_vs_rhodopsin.xml -outfmt 5 -db_gencode 1 -seg no -matrix BLOSUM80

echo "tblastn_four_human_vs_rhodopsin.html"
tblastn -query four_human_proteins.fasta -subject rhodopsin_nucs.fasta -evalue 1e-10 -out tblastn_four_human_vs_rhodopsin.html -outfmt 0 -html -db_gencode 1 -seg no -matrix BLOSUM80

echo "blastx_rhodopsin_vs_four_human_converted.tabular (via our script)"
python /mnt/galaxy/galaxy-central/tools/ncbi_blast_plus/blastxml_to_tabular.py blastx_rhodopsin_vs_four_human.xml blastx_rhodopsin_vs_four_human_converted.tabular std

echo "blastx_rhodopsin_vs_four_human_converted_ext.tabular (via our script)"
python /mnt/galaxy/galaxy-central/tools/ncbi_blast_plus/blastxml_to_tabular.py blastx_rhodopsin_vs_four_human.xml blastx_rhodopsin_vs_four_human_converted_ext.tabular ext
