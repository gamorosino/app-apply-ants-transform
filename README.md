from pathlib import Path

readme_content = """# app-apply-ants-transform

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
