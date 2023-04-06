#nucle_tracking


subject='Marmoset_ceb_lobe_to_FA.nii.gz'

fslmaths ${subject} -uthr 6 -bin ROI_lobe1.nii.gz
fslmaths ${subject} -thr 15 -uthr 16 -bin ROI_lobe2.nii.gz
fslmaths ${subject} -thr 7 -uthr 7 -bin ROI_lobe3.nii.gz
fslmaths ${subject} -thr 8 -uthr 8 -bin ROI_lobe4.nii.gz
fslmaths ${subject} -thr 9 -uthr 10 -bin ROI_lobe5.nii.gz
fslmaths ${subject} -thr 11 -uthr 11 -bin ROI_lobe6.nii.gz
fslmaths ${subject} -thr 12 -uthr 12 -bin ROI_lobe7.nii.gz
fslmaths ${subject} -thr 13 -uthr 13 -bin ROI_lobe8.nii.gz
fslmaths ${subject} -thr 14 -uthr 14 -bin ROI_lobe9.nii.gz
fslmaths ${subject} -thr 17 -uthr 17 -bin ROI_lobe10.nii.gz

#divide L and R for ceb and nucle

for i in `seq 10`
do 
echo ${i}
fslroi ROI_lobe${i}.nii.gz ROI_L_lobe${i}.nii.gz 156 324 0 456 0 275
fslroi ROI_lobe${i}.nii.gz ROI_R_lobe${i}.nii.gz 0 156 0 456 0 275
done


fslroi nucles_3_to_oring.nii.gz ROI_L_nucles_3.nii.gz  156 324 0 456 0 275
fslroi nucles_3_to_oring.nii.gz ROI_R_nucles_3.nii.gz  0 156 0 456 0 275

fslroi Marmoset_ceb_lobe_to_FA.nii.gz Marmoset_ceb_lobe_to_FA_L.nii.gz 156 324 0 456 0 275
fslroi Marmoset_ceb_lobe_to_FA.nii.gz Marmoset_ceb_lobe_to_FA_R.nii.gz  0 156 0 456 0 275

fslroi FA.nii.gz FA_L.nii.gz 156 324 0 456 0 275
fslroi FA.nii.gz FA_R.nii.gz  0 156 0 456 0 275

#tracking

for i in `seq 10`
do
tckgen -algorithm iFOD2 -seed_image  ROI_L_lobe${i}.nii.gz -include ROI_L_nucles_3.nii.gz -seeds 1000k -angle 45 -cutoff 0.1 -maxlength 18 -minlength 4 -stop fod_eddyc_denosied_raw_b0b2400b4800_wm_610_crop.mif L_lobe${i}_nucle3_45_1000_max18.tck -nthreads 16 -force
done 

for i in `seq 10`
do
tckgen -algorithm iFOD2 -seed_image ROI_R_lobe${i}.nii.gz -include ROI_R_nucles_3.nii.gz  -seeds 1000k -angle 45 -cutoff 0.1 -maxlength 18 -minlength 4 -stop fod_eddyc_denosied_raw_b0b2400b4800_wm_610_crop.mif R_lobe${i}_nucle3_45_1000_max18.tck -nthreads 16 -force
done  


