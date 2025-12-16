# Use a recommended, stable base image for Unsloth with CUDA 12.1
FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

# Set the working directory to /workspace, which aligns with Vast.ai best practices
WORKDIR /workspace
VOLUME /workspace

# 1. RUN: Install System Packages and Cleanup (No Change)
RUN apt-get update && \
    apt-get install -y \
        python3.10 \
        python3-pip \
        python3.10-dev \
        build-essential \
        git \
        wget \
        cmake \
        libcurl4-openssl-dev && \
    rm -rf /var/lib/apt/lists/*

# 2. RUN: CRITICAL FIX 1: Upgrade pip in its own layer. (No Change)
RUN python3.10 -m pip install --upgrade pip

# 3. RUN: ISOLATE LARGEST PACKAGE 1: Install PyTorch + Index URL (CRITICAL SPACE FIX)
RUN pip install --no-cache-dir \
    torch==2.2.0 \
    --extra-index-url https://download.pytorch.org/whl/cu121

# 4. RUN: ISOLATE LARGEST PACKAGE 2: Install Xformers (CRITICAL SPACE FIX)
# Needs the index URL again just in case, but torch is already installed
RUN pip install --no-cache-dir \
    xformers==0.0.24 \
    --extra-index-url https://download.pytorch.org/whl/cu121

# 5. RUN: Install the Core Libraries (Unsloth, Jupyterlab)
RUN pip install --no-cache-dir \
    unsloth[cu121-torch220] \
    jupyterlab

# 6. RUN: Install the remaining, smaller dependencies.
RUN pip install --no-cache-dir \
    trl \
    peft \
    accelerate \
    bitsandbytes

# Set the explicit token for Jupyter Lab access and expose the port 1111 (common on Vast.ai)
ENV JUPYTER_TOKEN='unsloth'
EXPOSE 1111

# Define the command that runs when the container starts.
ENTRYPOINT ["jupyter", "lab", "--port=1111", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token='unsloth'"]
