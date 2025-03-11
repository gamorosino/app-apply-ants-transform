# app-apply-ants-transform

This repository contains a script designed to apply spatial transformations to neuroimaging data using [ANTs (Advanced Normalization Tools)](http://stnava.github.io/ANTs/). The pipeline automatically manages transformation chains, including support for FSL-derived transforms, inverse applications, and multiple reference spaces.

## Features

This app performs:
- Application of nonlinear warps or inverse warps
- Optional use of affine-only transformations
- Optional conversion from FSL (FLIRT/FNIRT) to ANTs-compatible format
- Flexible input/reference image handling (T1w, T2w, parcellation, mask, DWI)
- Interpolation options (Linear, NearestNeighbor, etc.)

The transformed output image is saved in standard NIfTI format.

### Author

    Gabriele Amorosino (gabriele.amorosino@utexas.edu)

## Inputs (`config.json`)

Example:
```json
{
    "warp": "transforms/warp.nii.gz",
    "inverse-warp": "transforms/inverse_warp.nii.gz",
    "affine": "transforms/affine.txt",
    "input": "native/input_image.nii.gz",
    "interpolation": "Linear",
    "inverse": false,
    "affine_only": false,
    "fsl_transform": true,
    "t1": "anat/T1w.nii.gz",
    "t2": null,
    "parc": null,
    "mask": null,
    "dwi": null
}
```

### Field Descriptions

| Field           | Description                                                                 |
|----------------|-----------------------------------------------------------------------------|
| `warp`          | Path to nonlinear warp field                                                |
| `inverse-warp`  | Path to inverse warp field (used if `inverse=true`)                         |
| `affine`        | Affine matrix (FLIRT-style if `fsl_transform=true`)                         |
| `input`         | Image to transform                                                          |
| `interpolation` | Interpolation method (`Linear`, `NearestNeighbor`, etc.)                   |
| `inverse`       | If `true`, applies affine and warp in inverse mode  |
| `affine_only`   | If `true`, applies only affine and skips warps                              |
| `fsl_transform` | If `true`, converts affine and warp to ANTs-compatible format               |
| `t1`, `t2`, `parc`, `mask`, `dwi` | Reference image; first non-null used as target image     |

## Usage

### Local Execution

1. Clone the repository:
```bash
git clone https://github.com/gamorosino/app-apply-ants-transform.git
cd app-apply-ants-transform
```

2. Prepare `config.json` as shown above.

3. Run the script:
```bash
./apply_transform_main_final.sh
```

The script will:
- Convert FLIRT/FNIRT transforms if requested
- Apply affine/warp transforms with proper ordering
- Save output to `ants_transformed/t1.nii.gz`

### Requirements
- **Singularity** (for container execution)
- **jq** (for parsing `config.json`)

## Output

- **Transformed Image:** `ants_transformed/t1.nii.gz`

## Citation

If you use this app, please cite:

- ANTs: Avants et al., NeuroImage (2011) [https://doi.org/10.1016/j.neuroimage.2010.09.025](https://doi.org/10.1016/j.neuroimage.2010.09.025)
- Brainlife.io: Hayashi et al., *Nature Methods* (2024) [https://doi.org/10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
