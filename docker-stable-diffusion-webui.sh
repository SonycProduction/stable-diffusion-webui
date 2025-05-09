#!/bin/bash

# Prompt for sudo password at the start so script is not interrupted when docker commands execute
sudo -v

# Clone the repository
git clone https://github.com/SonycProduction/stable-diffusion-webui.git

# Navigate into the cloned directory
cd stable-diffusion-webui

# Run build and start for container
sudo docker compose up --build
