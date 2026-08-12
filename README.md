# 2.5D Autonomous UGV Navigation Simulator in MATLAB

[![MATLAB](https://img.shields.io/badge/MATLAB-R2025b-blue.svg)](https://www.mathworks.com/)
[![Toolbox](https://img.shields.io/badge/Toolbox-Robotics%20System-orange.svg)](https://www.mathworks.com/products/robotics.html)

A MATLAB-based simulation platform for autonomous navigation of unmanned ground vehicles (UGVs) over terrain represented by Digital Elevation Models (DEMs).

## Overview
This repository contains the software developed as part of a Master's Thesis “Integration of geospatial data in MATLAB for the realistic simulation of autonomous robotic vehicles in unstructured environments” at the University of Málaga (UMA). 

The project provides a simulation environment for studying autonomous navigation over 2.5D unstructured terrain, combining real Digital Elevation Models (DEMs), terrain traversability assessment, global path planning, local path planning, virtual LiDAR-based obstacle avoidance, and continuous 3D vehicle pose adaptation.

The simulator has been developed for two robotic platforms used by the Robotics and Mechatronics Research Group at the University of Málaga:
* **Argo J8**, an 8×8 skid-steer UGV.
* **Rambler**, a 4×4 skid-steer robotic platform.

One of the main features of the platform is its 3D terrain adaptation mechanism, which continuously updates the vehicle pose from the DEM by estimating chassis elevation, pitch, and roll. 

The main purpose of the simulator is not to determine which navigation algorithm is universally superior, but to provide a common environment where different navigation strategies can be integrated, executed, and evaluated under reproducible conditions.

---

## Main Features

### Terrain and Environment
* Import of DEM data stored in MATLAB `.mat` files.
* Support for associated orthophotography when available.
* DEM preprocessing and geometric correction.
* Spatial filtering of elevation data.
* Terrain analysis based on local slope and surface roughness.
* Generation of binary occupancy maps.
* Obstacle inflation to account for vehicle safety margins.
* Interactive obstacle insertion for local planning evaluation.

### Robotic Platforms
* Argo J8 & Rambler URDF-based 3D robot models.
* Platform-specific geometric and kinematic parameters.
* Continuous 3D terrain adaptation.

### Global Path Planning
The simulator currently integrates the following global planners:
* A* Grid
* Hybrid A*
* Probabilistic Roadmap (PRM)
* RRT*

### Local Path Planning and Obstacle Avoidance
The simulator currently includes:
* Vector Field Histogram (VFH)
* Artificial Potential Field (APF)
* Dynamic Window Approach (DWA) *(implemented as a simplified approach based on the principles of the original DWA methodology)*
* Follow the Gap (FTG)
* Pure Pursuit for trajectory following

### Data Logging
During each mission, the simulator records information including: 
* Vehicle position
* Altitude
* Yaw
* Pitch
* Velocity
* Mission duration
* Global planner
* Local planner
* Number of obstacles
* Final mission status
* Trajectory tracking error.

Recorded data is stored internally during the session and can later be exported to Microsoft Excel (`.xlsx`) through the application's export function.

---

## Requirements

### Software
* MATLAB R2025b or higher
* MATLAB App Designer
* Robotics System Toolbox
* Navigation Toolbox
* Lidar Toolbox
* Image Processing Toolbox

*Note: The application has been developed and tested in MATLAB on Windows. Other operating systems may require additional adjustments related to file paths or visualization components.*

### Hardware
No robotic hardware is required to run the simulator. The platform is designed as a software-only simulation environment.

---

## Installation

Clone the repository:
   ```bash
   git clone https://github.com/C-Trillos/TFM_CATG_SIM_MATLAB.git
```
Navigate to the repository:

  ```bash
  cd TFM_CATG_SIM_MATLAB
```
Then open MATLAB and set the repository directory as the working directory.

The application initializes the required relative paths when it starts.

---
## Running the Simulator

### 1. Load a DEM

Open `TFM_ArgoJ8_Dashboard.mlapp` in MATLAB.

Use:

- **Seleccionar Mapa** → **Cargar Mapa**

and select a compatible `.mat` DEM file.

The application processes the elevation data, calculates terrain characteristics, generates the occupancy map, and initializes the 2D and 3D views.

---

### 2. Select the Robot

Select the required platform from:

- **Modelo del Robot**

Available platforms:

- Argo J8
- Rambler

---

### 3. Define the Initial Pose

Use:

- **Seleccionar Inicio**

and draw the initial position and orientation on the 2D map.

---

### 4. Define the Goal Pose

Use:

- **Seleccionar Meta**

and draw the target position and orientation.

---

### 5. Position the Robot

Press:

- **Posicionar Robot**

The URDF model of the selected platform is loaded and positioned on the terrain.

---

### 6. Select the Global Planner

Select one of the following planners:

- A* Grid
- Hybrid A*
- PRM
- RRT*

Then press:

- **Calcular Ruta**

The generated trajectory is displayed in the 2D and 3D views.

---

### 7. Prepare the Obstacle-Avoidance Scenario

After the global trajectory has been calculated, one or more obstacles can be added using the **Añadir Obstáculo** tool.

Obstacles should be placed **before starting the simulation**, preferably on or near the computed global trajectory. This keeps the global trajectory as the navigation reference while requiring the local planner to detect the inserted obstacles during execution and modify the vehicle motion to avoid them.

This procedure allows controlled scenarios to be created for evaluating the response of different local planning methods.

---

### 8. Select the Local Planner and Start the Simulation

Select the desired local planning strategy:

- Sin Evasión
- VFH
- APF
- DWA
- FTG

Then press:

- **Seguir Trayectoria**

The vehicle starts the simulation using the previously computed global trajectory and processes the obstacles present in the scenario through the virtual LiDAR sensor and the selected local planner.

---

### 9. Export Results

Mission data remains stored internally during the session.

After one or more simulations have been completed, press:

- **Exportar**

The application generates an Excel file containing the mission summary and detailed telemetry.

---

## Adding New Planners

The platform is designed to facilitate the integration of new planning strategies without modifying the main terrain-processing, 3D visualization, or data-logging modules.

### Adding a New Global Planner

At a high level, integration requires:

1. Implement the new algorithm in MATLAB
2. Add its name to `PlanificadorGlobalDropDown`
3. Add a new branch to the `switch planificador` structure inside `BotonCalcularButtonPushed`
4. Generate a valid trajectory and store it using the format expected by `app.RutaGlobal`
5. Add a specific visualization for the algorithm when appropriate

The new planner should ultimately provide an ordered sequence of waypoints that can be processed by the existing trajectory-following and simulation modules.

### Adding a New Local Planner

Integration of a new local planning strategy generally requires:

1. Add the new method to `ControladorLocalDropDown`
2. Add a new branch to the local-planning logic inside `BotonSeguirButtonPushed`
3. Use the available information sources, such as:
   - the virtual LiDAR
   - the occupancy map
   - the local target provided by Pure Pursuit
4. Generate the motion commands:
   - `v_cmd`
   - `omega_cmd`
5. Respect the velocity limits defined for the selected vehicle

The remaining modules, including kinematic integration, collision detection, 3D terrain adaptation, telemetry logging, and result export, can be reused without modification.

For a more detailed description of the integration procedure, see the corresponding section of the thesis.

---

## Multimedia

The media folder includes:
- Screenshots of the simulator and other figures used in the project report in the `media/Figures` subfolder
- Demonstration videos are available in the `media/Videos/` subfolder.

---

## Reproducibility

The simulator records the configuration of each mission and the telemetry required to analyse navigation experiments.

For reproducible comparisons, it is recommended to keep the following conditions constant:

- DEM
- robot model
- initial and goal poses
- obstacle configuration
- planner parameters

Since navigation algorithm behaviour depends on its configuration, results should be interpreted considering the parameter values used in each experiment.

---

## Citation

If you use this simulator, its methodology, or any part of the source code in academic work, please cite the associated Master's Thesis:

> Trillos Graciano, C. A. (2026). *Integración de datos geoespaciales en MATLAB para la simulación realista de vehículos robóticos autónomos en entornos no estructurados*. Tesis de Maestría, Universidad de Málaga.

Repository:

[https://github.com/C-Trillos/TFM_CATG_SIM_MATLAB](https://github.com/C-Trillos/TFM_CATG_SIM_MATLAB)

A `CITATION.cff` file is included in the repository to provide structured citation information and enable GitHub's “Cite this repository” functionality.

---

## Author

**Camilo Andres Trillos Graciano**

**University of Málaga (UMA)**  
Master's Degree in Mechatronics Engineering

**Robotics and Mechatronics Research Group (IMECH-UMA)**

---

## Acknowledgements

This work was developed within the research activities of the Robotics and Mechatronics Research Group at the University of Málaga.

The Argo J8 and Rambler models used in the simulator originate from previous academic and research projects developed within the group.
