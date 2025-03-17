#!/bin/bash
set -e

# === Read arguments ===
input=$1
anat=$2
warp=$3
inverse_warp=$4
affine=$5
interpolation=$6
inverse=$7
affine_only=$8
fsl_transform=$9

# === Determine source and reference ===
if [[ "$inverse" == "true" ]]; then
    reference=$input
    source=$anat
else
    reference=$anat
    source=$input
fi

# === Convert FSL transforms to ANTs if requested ===
if [[ "$fsl_transform" == "true" ]]; then
    echo "Converting FLIRT affine to ITK..."
    singularity exec -e docker://vnmd/itksnap_4.0.2:20240206 \
        c3d_affine_tool -ref $reference -src $source $affine -fsl2ras -oitk affine_ants_c3d.txt
    affine="affine_ants_c3d.txt"

    if [[ "$affine_only" != "true" ]]; then
        warp_to_convert="$warp"
        warp_out="warp_ants_wb.nii.gz"

        if [[ "$inverse" == "true" ]]; then
            warp_to_convert="$inverse_warp"
            warp_out="inverse_warp_ants_wb.nii.gz"
        fi

        if [[ "$warp_to_convert" != "null" && "$warp_to_convert" != "" ]]; then
            echo "Converting FNIRT warpfield to ITK..."
            singularity exec -e docker://brainlife/connectome_workbench:1.5.0 \
                wb_command -convert-warpfield -from-fnirt "$warp_to_convert" "$reference" -to-itk "$warp_out"

            if [[ "$inverse" == "true" ]]; then
                inverse_warp="$warp_out"
            else
                warp="$warp_out"
            fi
        else
            echo "Error: Missing warpfield required for conversion (inverse=$inverse)." >&2
            exit 1
        fi
    fi
fi

# === Build transformation chain ===
transforms=""
if [[ "$affine" != "null" && "$affine" != "" ]]; then
    inverse_flag="0"
    [[ "$inverse" == "true" ]] && inverse_flag="1"
    transforms="$transforms -t [$affine,$inverse_flag]"
fi

if [[ "$affine_only" != "true" ]]; then
    selected_warp="$warp"
    [[ "$inverse" == "true" ]] && selected_warp="$inverse_warp"

    if [[ "$selected_warp" != "null" && "$selected_warp" != "" ]]; then
        transforms="$transforms -t $selected_warp"
    else
        echo "Error: affine_only is false but appropriate warp is missing (inverse=$inverse)." >&2
        exit 1
    fi
fi

# === Output setup ===
outdir=./ants_transformed
mkdir -p "$outdir"
output_image=${outdir}/$( basename $input )

# === Apply transforms ===
echo "Applying transforms to $input using reference $anat..."
singularity exec -e docker://brainlife/ants:2.2.0-1bc antsApplyTransforms \
    -d 3 \
    -i "$input" \
    -r "$anat" \
    $transforms \
    -o "$output_image" \
    -n "$interpolation"

echo "Transformation complete. Output written to $output_image"
