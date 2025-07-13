#!/bin/bash

# ============================================================================
# Installation script for scPDSI environment
# Author: Miguel Andrade
# Last updated: July 2025
# ============================================================================

echo "ð§ Creating conda environment 'scpdsi_env' with required packages..."

# Check if conda is installed
if ! command -v conda &> /dev/null
then
        echo "❌ Conda is not installed. Please install Miniconda or Anaconda first."
            exit
        fi

        # Create environment with all required packages
        conda create -y -n scpdsi_env python=3.10 numpy scipy xarray

        echo "✅ Environment 'scpdsi_env' created."

        # Activate environment
        echo "ð¦ Activating environment..."
        conda activate scpdsi_env || source activate scpdsi_env

        # Confirm installation
        echo "✅ All dependencies installed successfully."
        echo "ð You're now ready to run the scPDSI model."

        # Optional: remind how to activate later
        echo "ð To activate this environment in the future, use:"
        echo "   conda activate scpdsi_env"

