# Dockerfile contents (MUST be saved as 'Dockerfile' in a clean directory)
FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

WORKDIR /workspace
VOLUME /workspace

# Combined, space-saving installation of all dependencies
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
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir \
        jupyterlab \
        unsloth[cu121-torch220] \
        trl \
        peft \
        accelerate \
        bitsandbytes \
        torch==2.2.0 \
        xformers==0.0.24 \
        --index-url https://download.pytorch.org/whl/cu121

ENV JUPYTER_TOKEN='unsloth'
EXPOSE 1111

ENTRYPOINT ["jupyter", "lab", "--port=1111", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token='unsloth'"]
