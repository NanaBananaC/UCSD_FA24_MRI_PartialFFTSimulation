# Partial Fourier Reconstruction for Accelerated MRI

## Overview
This repository contains MATLAB implementations of **Partial Fourier reconstruction methods** for accelerating MRI scans. The goal is to reconstruct high-quality images from partially sampled k-space by leveraging conjugate symmetry and phase correction techniques.

This work was completed as part of the **BENG 280A / ECE 207 Final Project at UC San Diego (Fall 2024).**

---

## Data
The `dicom_data/` folder contains 8 MRI DICOM slices from the **Mayo Clinic Study of Aging (MCSA)** dataset, including axial and sagittal views (05°, 30°, 35°, 80°).

Example files:
- `MCSA_00003_AXIAL_05.dcm`
- `MCSA_00003_Sag_30.dcm`
- `MCSA_00011_AXIAL_35.dcm`
- (and others in `dicom_data/`)

---

## Methods Implemented (in `src/`)

- **`pfft_main.m`** — Main pipeline for Partial Fourier reconstruction.  
- **`pfft_main_w_analysis.m`** — Reconstruction + quantitative evaluation (MSE, SSIM, PSNR).  
- **`data_visualization.m`** — Loads and visualizes DICOM images and results.

Reconstruction methods explored:
- Zero-Padding (ZP)  
- Phase Correction & Conjugate Symmetry (PCCS)  
- Homodyne (HOMO)  
- Projection onto Convex Sets (POCS)

---

## What the code evaluates
The project compares methods under:
- Different k-space sampling ratios  
- Different noise levels  

Metrics used:
- **MSE (Mean Squared Error)**
- **SSIM (Structural Similarity Index)**
- **PSNR (Peak Signal-to-Noise Ratio)**

---

## Team & Contact

- **Benjia Zhang** - b9zhang@stanford.edu
- **Juo-Hsuan Chang** — juc077@ucsd.edu  
- **Iris Zaretzki** -  izaretzki@ucsd.edu

---

## Reference
See **`Project 2 Presentation.pdf`** for full background, theory, methods, and results.
