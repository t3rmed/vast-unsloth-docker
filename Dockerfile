FROM nvidia/cuda:12.9.0-cudnn-devel-ubuntu22.04

RUN mkdir /workspace && cd /workspace

# Set the working directory
WORKDIR /workspace
# Mark /app as a volume to be mounted
VOLUME /workspace

# Install Jupyter Notebook
RUN apt-get update
RUN apt-get install -y python3 python3-pip
    
RUN pip install jupyter -U && pip install jupyterlab

RUN pip install unsloth

# set the token for jupyter
ENV JUPYTER_TOKEN='unsloth'

# Make port 8888 available to the world outside this container
EXPOSE 8888

# Run Jupyter Notebook when the container launches
ENTRYPOINT ["jupyter", "lab","--ip=0.0.0.0","--allow-root"]
