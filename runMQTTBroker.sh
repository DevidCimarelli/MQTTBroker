#!/bin/bash

# Script to set up an MQTT broker using Mosquitto and Docker Compose

# Container name and image name
CONTAINER_NAME="mosquitto"

# Ensure Docker is running
if ! systemctl is-active --quiet docker; then
  echo "Starting Docker..."
  sudo systemctl start docker
fi

# Check if the container exists
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
  # Check if the container is already running
  if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "The container '$CONTAINER_NAME' is already running."
    
    # Prompt the user for action
    read -p "Do you want to stop the container? (y/n): " choice
    case "$choice" in
      y|Y ) 
        echo "Stopping the container '$CONTAINER_NAME'..."
        docker stop $CONTAINER_NAME
        echo "Container '$CONTAINER_NAME' has been stopped. Exiting."
        exit 0
        ;;
      n|N ) 
        echo "Continuing with the running container..."
        echo "Displaying logs for the container '$CONTAINER_NAME'..."
        sudo docker logs -f $CONTAINER_NAME
        exit 0
        ;;
      * ) 
        echo "Invalid choice. Exiting."
        exit 1
        ;;
    esac
  else
    echo "The container '$CONTAINER_NAME' exists but is not running. Starting the container..."
    docker start $CONTAINER_NAME
    echo "Displaying logs for the container '$CONTAINER_NAME'..."
    sudo docker logs -f $CONTAINER_NAME
    exit 0
  fi
fi

# Set up directory structure if it does not exist
if [ ! -d "mosquitto" ]; then
  echo "Creating directory structure..."
  mkdir -p mosquitto/config mosquitto/data mosquitto/log
fi

# Navigate to the mosquitto directory
cd mosquitto

# Create docker-compose.yml if it does not exist
if [ ! -f "docker-compose.yml" ]; then
  echo "Creating docker-compose.yml..."
  cat <<EOL > docker-compose.yml
version: '3.8'

services:
  mosquitto:
    image: eclipse-mosquitto
    container_name: $CONTAINER_NAME
    ports:
      - "1883:1883"      # Porta MQTT standard
      - "9001:9001"      # Porta WebSocket (opzionale)
    volumes:
      - ./config/mosquitto.conf:/mosquitto/config/mosquitto.conf  # Configurazione personalizzata
      - ./data:/mosquitto/data  # Persistenza dati
      - ./log:/mosquitto/log    # Log
    restart: unless-stopped
EOL
else
  echo "docker-compose.yml already exists."
fi

# Create mosquitto.conf if it does not exist
if [ ! -f "config/mosquitto.conf" ]; then
  echo "Creating mosquitto.conf..."
  cat <<EOL > config/mosquitto.conf
# Mosquitto MQTT broker configuration

listener 1883
allow_anonymous true
EOL
else
  echo "mosquitto.conf already exists."
fi

# Provide permissions
chmod -R 755 config data log

# Launch the container using docker-compose
echo "Starting the MQTT broker container..."
sudo docker-compose -f docker-compose.yml up -d

echo "Setup complete! The MQTT broker is running and accessible on port 1883."

# Display logs
echo "Displaying logs for the container '$CONTAINER_NAME'..."
sudo docker logs -f $CONTAINER_NAME
