# Use the Python 3.10 slim-bullseye base image
FROM python:3.10-slim-bullseye

# Update the package list and install necessary packages
RUN apt-get update -y && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Create a new user `mlflow` with specified configurations
RUN useradd -rm -d /home/mlflow -s /bin/bash -g root -G sudo -u 1001 mlflow

# Switch to the new user
USER mlflow

# Set the working directory
WORKDIR /home/mlflow

# Set the PATH environment variable
ENV PATH="/home/mlflow/.local/bin:${PATH}"

# Install the required Python packages
RUN pip install --no-cache-dir \
    psycopg2-binary==2.9.6 \
    prometheus_flask_exporter==0.22.4 \
    boto3==1.26.146 \
    mlflow==2.5.0

# Expose port 5000
EXPOSE 5000

# Set the default command
CMD ["mlflow", "ui", "--host", "0.0.0.0"]

