# TFM_CATG_SIM_MATLAB
A 2.5D simulation platform in MATLAB for the autonomous navigation of UGVs in unstructured environments.

[![MATLAB](https://img.shields.io/badge/MATLAB-R2025b%2B-blue.svg)](https://www.mathworks.com/)

## Table of Contents
1. [Introduction](#1-introduction)
2. [Environment Setup](#2-environment-setup)
3. [Project Structure](#3-project-structure)
4. [Project Execution](#4-project-execution)
5. [Adding New Planners](#5-adding-new-planners)
6. [Multimedia](#6-multimedia)
7. [Credits & Acknowledgements](#7-credits--acknowledgements)

---

## 1. Introduction
This project was developed as a Master's Thesis (TFM) for the **Mechatronics Engineering Master's Program** at the **University of Málaga (UMA)**. 

The repository contains the source code for a native MATLAB simulation platform designed to study the autonomous navigation of Unmanned Ground Vehicles (UGVs), specifically the **ARGO J8** and **Rambler** rovers. Unlike standard flat 2D simulators, this platform operates on **2.5D unstructured environments** using real Digital Elevation Models (DEM) from the LAENTIEC experimental area. It features a custom continuous 3D kinematic settling engine that adjusts the robot's Pitch, Roll, and Z-axis in real-time based on the terrain's surface normal.

**Technologies & Toolboxes Used:**
* **MATLAB (R2023b+):** Core engine for UI (App Designer) and matrix processing.
* **Navigation Toolbox:** For Global Planners (A*, Hybrid A*, PRM, RRT*) and Local Controllers (VFH, DWA, Pure Pursuit).
* **Robotics System Toolbox:** For URDF parsing and 3D rigid body tree rendering.
* **Image Processing Toolbox:** For spatial filtering and terrain roughness calculation.

---
