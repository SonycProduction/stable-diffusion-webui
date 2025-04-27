# Stable Diffusion web UI docker build
A web interface for Stable Diffusion. Build based on Ubuntu 22.04, Cuda 12.6.2 & Python 3.10 using latest release from https://github.com/SonycProduction/stable-diffusion-webui.

![](screenshot.png)

## Features
- Original txt2img and img2img modes
- One click install and run script (but you still must install python and git)
- Outpainting
- Inpainting
- Color Sketch
- Prompt Matrix
- Stable Diffusion Upscale
- Loopback, run img2img processing multiple times
- X/Y/Z plot, a way to draw a 3 dimensional plot of images with different parameters
- Textual Inversion
- and many more...

## Installation and Running
## Quick start (assuming docker basic setup exists, refer to prerequisites for any issues)
```
curl -sSL https://raw.githubusercontent.com/SonycProduction/stable-diffusion-webui/refs/heads/master/docker-stable-diffusion-webui.sh | bash
```
Install stable-diffusion-webui in docker. Files are created in current location in folder `stable-diffusion-webui`

*refer to prerequisite if any  issues are encountered*

## Prerequisite:

### 1. [Docker](https://docs.docker.com/engine/install/debian/)

Add Docker's apt repository.
```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```
If issues occur, you may need to substitute the part `$VERSION_CODENAME` of this command with the codename of the corresponding Debian release, such as `jammy` or `bookworm`.

Install Docker (and related packages)
```
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
Test Docker Installation
```
sudo docker run hello-world
```

### 2. Docker Compose (Optional - Recommended)
```
sudo apt install docker-compose
```
`docker compose` command should already be bundled with Docker, this installs commonly used `docker-compose`

### 3. [Nvidia Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
Add Nvidia Container toolkit repository
```
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

Update packages from Nvidia container Toolkit repository
```
sudo apt update
```
Install Nvidia Container Toolkit
```
sudo apt install nvidia-container-toolkit
```
Configure for use with Docker
```
sudo nvidia-ctk runtime configure --runtime=docker
```
```
sudo systemctl restart docker
```
Test with Docker
```
sudo docker run --rm --runtime=nvidia --gpus all nvidia/cuda:12.6.0-base-ubuntu22.04 nvidia-smi
```

## [Automatic1111](https://github.com/AUTOMATIC1111/stable-diffusion-webui) (Stable Diffusion UI) Installation on Docker:

### Clone this repo
```
git clone https://github.com/SonycProduction/stable-diffusion-webui.git
```
### Navigate into the cloned directory
```
cd stable-diffusion-webui
```
### Option 1 (Build and deploy in a single command - Recommended)
#### Build and deploy the container in a single command. WebUI is available on port `7860`. Required folders are mapped in current location.
```
sudo docker compose up --build
```
`docker-compose.yml` file can be modified to change folder locations and access port for webui. Stable Diffusion WebUI starts with following commandline arguments enabled: `--listen --api --medvram --xformers --enable-insecure-extension-access --allow-code --administrator`
You can change the commandline arguments (e.g. `--lowvram --no-half --precision full`) depending on your needs.

### Option 2 (Manually building image):
#### 1.  Build image using Dockerfile

```
sudo docker build -t <image_name:tag> .
```
`<image_name:tag>` change it to user's image name.

#### 2. Run the image built in previous step
```
sudo docker run -d \
  --name stable-diffusion-webui \
  --restart unless-stopped \
  -p 7860:7860 \
  -v ./models:/app/models \
  -v ./extensions:/app/extensions \
  -v ./embeddings:/app/embeddings \
  -v ./outputs:/app/outputs \
  --runtime nvidia \
  --gpus all \
  --deploy-resources-reservations-devices 'driver=nvidia, count=all, capabilities=[gpu]' \
  <image_name:tag>
```
`<image_name:tag>` needs to be replaced the one defined in previous step.
This wil start the container and map the required volumes as folders in current location.

#### It’s done 🎊🎉👏 Go to browser, and type 127.0.0.1:7860 to access WebUI.
