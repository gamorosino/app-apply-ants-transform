# app-apply-ants-transform

This repository contains a script designed to apply nonlinear and affine spatial transformations to anatomical images using [ANTs (Advanced Normalization Tools)](http://stnava.github.io/ANTs/). The script wraps the `antsApplyTransforms` functionality and automates the selection of the appropriate input image and transformation chain.

## Features

This app performs:
- Application of nonlinear warps
- Optional inclusion of affine and inverse transforms
- Automatic selection of the first available anatomical image (T1w, T2w, parcellation, or mask)
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

2. Prepare a `config.json` file specifying all required input paths. Example:
   ```json
   {
       "warp": "transforms/warp.nii.gz",
       "inverse_warp": "transforms/inverse_warp.nii.gz",
       "affine": "transforms/affine.mat",
       "reference": reference.nii.gz,
       "interpolation": "Linear",
       "t1": "anat/T1w.nii.gz",
       "t2": null,
       "parc": null,
       "mask": null
   }
   ```

3. Run the script:
   ```bash
   ./apply_transform_main.sh
   ```

   The script will:
   - Select the first available anatomical image.
   - Apply the specified spatial transforms.
   - Run `antsApplyTransforms` via a Singularity container without requiring a local ANTs installation.
   - Save the output to `ants_transformed/<anat>_warped.nii.gz`.

#### Requirements
- **Singularity** must be installed and available on your system.
- **jq** is used for parsing the JSON configuration.

## Outputs

- **Transformed Image**: The output image is stored in:
  ```
  ants_transformed/<anat>_warped.nii.gz
  ```

## Citation

If you use this app in your research, please cite the following:

- ANTs software:
  - Avants, B. B., Tustison, N. J., Song, G., Cook, P. A., Klein, A., & Gee, J. C. (2011). A reproducible evaluation of ANTs similarity metric performance in brain image registration. *NeuroImage, 54*(3), 2033–2044. https://doi.org/10.1016/j.neuroimage.2010.09.025

- Brainlife.io:
  - Hayashi, Soichi, et al. "brainlife.io: a decentralized and open-source cloud platform to support neuroscience research." *Nature Methods, 21*(5), 809–813. (2024). https://doi.org/10.1038/s41592-024-02237-2
