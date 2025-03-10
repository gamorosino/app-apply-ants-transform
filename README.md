# app-apply-ants-transform

This repository contains a script designed to apply spatial transformations to anatomical images using [ANTs (Advanced Normalization Tools)](http://stnava.github.io/ANTs/). The script wraps the `antsApplyTransforms` functionality and automates the construction of the appropriate transformation chain.

## Features

This app performs:
- Application of nonlinear warps or inverse warps
- Optional use of affine-only transformations
- T1w image as source ("anat") for transformation
- Flexible reference image space (can be T1w, T2w, parcellation, or mask)
- Interpolation options (Linear, NearestNeighbor, etc.)

The transformed output image is exported in standard NIfTI format for downstream analyses.

### Author

    Gabriele Amorosino (gabriele.amorosino@utexas.edu)

## Usage

### Running on Brainlife.io

You can run the `app-apply-ants-transform` app on the Brainlife.io platform via the web user interface (UI) or using the Brainlife CLI. Both methods allow for fully automated execution and data management within the Brainlife ecosystem.

#### On Brainlife.io via UI

1. Navigate to the Brainlife.io platform and locate the `app-apply-ants-transform` app.
2. Click the "Execute" tab and provide the required dataset inputs via the graphical interface.

#### On Brainlife.io using CLI

1. Install the Brainlife CLI by following the instructions at [Brainlife CLI Installation](https://brainlife.io/docs/cli/install/).
2. Log in to the CLI:
   ```bash
   bl login
   ```
3. Run the app:
   ```bash
   bl app run --id <app_id> --project <project_id> --input warp:<warp_object_id> affine:<affine_object_id> t1:<t1_object_id> ...
   ```
   Output will be saved in your specified project.

### Running Locally (on your machine)

Follow these steps to execute the script locally:

1. Clone the repository:
   ```bash
   git clone https://github.com/gamorosino/app-apply-ants-transform.git
   cd app-apply-ants-transform
   ```

2. Prepare a `config.json` file specifying all required input paths and optional transformation logic. Example:
   ```json
   {
       "warp": "transforms/warp.nii.gz",
       "inverse_warp": "transforms/inverse_warp.nii.gz",
       "affine": "transforms/affine.mat",
       "reference": "template/T2w.nii.gz",
       "interpolation": "Linear",
       "t1": "anat/T1w.nii.gz",
       "t2": null,
       "parc": null,
       "mask": null,
       "inverse": false,
       "affine_only": false
   }
   ```

3. Run the script:
   ```bash
   ./apply_transform_main.sh
   ```

   The script will:
   - Use T1w as the fixed source image (`anat`)
   - Use the specified reference image for spatial mapping
   - Apply affine-only, affine+warp, or affine+inverse-warp transforms depending on configuration
   - Use `antsApplyTransforms` via a Singularity container without requiring a local ANTs installation
   - Save the output to `ants_transformed/T1w_warped.nii.gz`

#### Requirements
- **Singularity** must be installed and available on your system
- **jq** is used for parsing the JSON configuration
- ANTs is run inside a container:
  ```bash
  singularity exec -e docker://brainlife/ants:2.2.0-1bc antsApplyTransforms
  ```

## Outputs

- **Transformed Image**: The output image is stored in:
  ```
  ants_transformed/T1w_warped.nii.gz
  ```

## Citation

If you use this app in your research, please cite the following:

- ANTs software:
  - Avants, B. B., Tustison, N. J., Song, G., Cook, P. A., Klein, A., & Gee, J. C. (2011). A reproducible evaluation of ANTs similarity metric performance in brain image registration. *NeuroImage, 54*(3), 2033–2044. https://doi.org/10.1016/j.neuroimage.2010.09.025

- Brainlife.io:
  - Hayashi, Soichi, et al. "brainlife.io: a decentralized and open-source cloud platform to support neuroscience research." *Nature Methods, 21*(5), 809–813. (2024). https://doi.org/10.1038/s41592-024-02237-2
