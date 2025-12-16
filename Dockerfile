# Use a recommended, stable base image for Unsloth with CUDA 12.1
FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

# Set the working directory to /workspace, which aligns with Vast.ai best practices
WORKDIR /workspace
VOLUME /workspace

# Combined installation step: apt-get, pip upgrade, and pip install all in one layer.
RUN apt-get update && \
    # Install system tools required for building Python packages and llama.cpp
    apt-get install -y \
        python3.10 \
        python3-pip \
        python3.10-dev \
        build-essential \
        git \
        wget \
        cmake \
        libcurl4-openssl-dev && \
    # Clean up APT cache to save space immediately
    rm -rf /var/lib/apt/lists/* && \
    # CRITICAL FIX: Upgrade pip to resolve dependency AssertionErrors during installation.
    python3.10 -m pip install --upgrade pip && \
    # Install all required Python packages
    # --no-cache-dir saves space.
    # --extra-index-url ensures we find packages on both PyPI (default) AND PyTorch's custom index.
    pip install --no-cache-dir \
        jupyterlab \
        unsloth[cu121-torch220] \
        trl \
        peft \
        accelerate \
        bitsandbytes \
        torch==2.2.0 \
        xformers==0.0.24 \
        --extra-index-url https://download.pytorch.org/whl/cu121

# Set the explicit token for Jupyter Lab access and expose the port 1111 (common on Vast.ai)
ENV JUPYTER_TOKEN='unsloth'
EXPOSE 1111

# Define the command that runs when the container starts.
# This launches Jupyter Lab, sets the port, allows root access, and applies the token.
ENTRYPOINT ["jupyter", "lab", "--port=1111", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token='unsloth'"]
