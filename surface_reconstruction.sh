
export FREESURFER_HOME=/usr/local/freesurfer
export SUBJECTS_DIR=/mnt/mri/iso008
source $FREESURFER_HOME/SetUpFreeSurfer.sh

## subject folde: 


subject=marmoset

F=1
r=0.0003


## put wm to 110; gm to 60-80; set dim to 1 mm; filled (wm) for right 127 and left 255


3dresample -orient RSP  -prefix wm_RSP.nii.gz -insert wm.nii.gz -overwrite
3dresample -orient RSP  -prefix gm_RSP.nii.gz -insert gm.nii.gz -overwrite

3drefit -xorigin_raw 0 -yorigin_raw 0 -zorigin_raw 0 wm_RSP.nii.gz
3drefit -xorigin_raw 0 -yorigin_raw 0 -zorigin_raw 0 gm_RSP.nii.gz

3drefit -xorigin 13.96 -yorigin 11.96 -zorigin 19.16 wm_RSP.nii.gz  #open the file in fsleyes to get the num 
3drefit -xorigin 13.96 -yorigin 11.96 -zorigin 19.16 gm_RSP.nii.gz

mri_convert  wm_RSP.nii.gz wm_RSP_01.nii.gz -iis 0.1 -ijs 0.1 -iks 0.1
mri_convert  gm_RSP.nii.gz gm_RSP_01.nii.gz -iis 0.1 -ijs 0.1 -iks 0.1


##== change the wm to wm_or and wm_RSP_01.nii.gz to wm!!!!!!!!!

mv wm.nii.gz wm_or.nii.gz
mv gm.nii.gz gm_or.nii.gz

mv wm_RSP_01.nii.gz wm.nii.gz
mv gm_RSP_01.nii.gz gm.nii.gz

#make surface

fslmaths wm.nii.gz -bin -mul 110 wm.nii.gz
fslmaths gm.nii.gz -bin -mul 80 gm.nii.gz

fslmaths wm.nii.gz -bin -mul 127 filled.nii.gz

## make a fake T1

fslmaths wm.nii.gz -bin -sub 1 -abs -bin wm_rev.nii.gz
fslmaths gm.nii.gz -mas wm_rev.nii.gz gm.nii.gz
fslmaths wm.nii.gz -add gm.nii.gz fake_T1.nii.gz
fslmaths fake_T1.nii.gz -bin brainmask.nii.gz

##smooth 

3dBlurInMask -input fake_T1.nii.gz -FWHM $F -mask brainmask.nii.gz -prefix  fake_T1_sm2.nii.gz 

## mri_convert to mgz

cp fake_T1_sm2.nii.gz orig.nii.gz
cp fake_T1_sm2.nii.gz norm.nii.gz
mri_convert wm.nii.gz wm.mgz
mri_convert filled.nii.gz filled.mgz
mri_convert  brainmask.nii.gz brainmask.mgz
mri_convert norm.nii.gz norm.mgz
mri_convert fake_T1_sm2.nii.gz fake_T1_sm2.mgz


## make surface
mri_pretess filled.mgz 127 norm.mgz filled-pretess127.mgz
mri_tessellate filled-pretess127.mgz 127 rh.orig.nofix
mris_extract_main_component rh.orig.nofix rh.orig

## cp to surf/
cp rh.orig ../surf/rh.orig

## make pial

mris_make_surfaces  -max 50000  -r ${r} -max_csf 0.1  -min_gray_at_csf_border 1   -orig_white orig -orig_pial orig   -noaseg   -noaparc -mgz -T1 fake_T1_sm2 ${subject} rh

## make the surface to ori


mris_convert rh.pial rh.pial.surf.gii
mris_convert rh.orig rh.orig.surf.gii

ConvertSurface -i rh.orig.surf.gii -o rh.orig_scale008.gii -xmat_1D scale0.8.1D
ConvertSurface -i rh.pial.surf.gii -o rh.pial_scale008.gii -xmat_1D scale0.8.1D

3dcopy wm.nii.gz test_wm.nii.gz

3drefit -xdel 0.08 -ydel 0.08 -zdel 0.08 -keepcen test_wm.nii.gz


@Align_Centers -cm -base wm_or.nii.gz -dset test_wm.nii.gz

ConvertSurface -i rh.orig_scale008.gii -o rh.orig_scale008_shifti.gii -ixmat_1D test_wm_shft.1D
ConvertSurface -i rh.pial_scale008.gii -o rh.pial_scale008_shifti.gii -ixmat_1D test_wm_shft.1D


##smooth

mris_smooth -a 2 -n 2  rh.pial_scale008_shifti.gii rh.pial_scale008_shifti_sm.surf.gii
mris_smooth -a 2 -n 2  rh.orig_scale008_shifti.gii rh.orig_scale008_shifti_sm.surf.gii


#map the ROI use the wb_command 

wb_command -volume-to-surface-mapping Marmoset_ceb_lobe.nii.gz rh.pial_scale008_shifti_sm_005.surf.gii Marmoset_ceb_lobe_map_005.func.gii -ribbon-constrained rh.orig_scale008_shifti_sm_005.surf.gii rh.pial_scale008_shifti_sm_005.surf.gii  -volume-roi Marmoset_ceb_lobe.nii.gz

#map the ROI use the freesurfer(better)

export SUBJECTS_DIR=/mnt/surfface_item/iso008
source ~/.bashrc

3dresample -orient RSP  -prefix Marmoset_ceb_lobe2_RSP.nii.gz -insert Marmoset_ceb_lobe2.nii.gz 
3drefit -xorigin_raw 0 -yorigin_raw 0 -zorigin_raw 0 Marmoset_ceb_lobe2_RSP.nii.gz 
3drefit -xorigin 13.96 -yorigin 11.96 -zorigin 19.16 Marmoset_ceb_lobe2_RSP.nii.gz 
mri_convert  Marmoset_ceb_lobe2_RSP.nii.gz Marmoset_ceb_lobe2_RSP01.nii.gz -iis 0.1 -ijs 0.1 -iks 0.1

cd surf/
mv rh.pial rh.pial_or
mv rh.orig rh.orig_or

mris_convert rh.pial_scale008_shifti_sm.surf.gii rh.pial
mris_convert rh.orig_scale008_shifti_sm.surf.gii rh.orig

mri_vol2surf --src Marmoset_ceb_lobe2_RSP01.nii.gz --out Marmoset_ceb_lobe2_RSP01.shape.gii --regheader marmoset --hemi rh








