#!/bin/bash

# Pi-hole configuration
PIHOLE_CONTAINER_NAME="pihole"
PIHOLE_IP="192.168.1.100"
PIHOLE_PORT=80
DOCKER_NETWORK_NAME="pihole_network"
DOCKER_NETWORK_SUBNET="192.168.1.0/24"
DOCKER_NETWORK_GATEWAY="192.168.1.1"

# Prompt for Pi-hole admin password
read -s -p "Enter the desired password for Pi-hole admin interface: " PIHOLE_PASSWORD
echo

# Check if the desired IP is available on the host
if ! ip addr show | grep -q "$PIHOLE_IP"; then
    echo "The IP address $PIHOLE_IP is not assigned to the host. Please assign it before running this script."
    exit 1
fi

# Check if the network already exists
if ! docker network ls | grep -q "$DOCKER_NETWORK_NAME"; then
    # Create a Docker network
    docker network create --subnet=$DOCKER_NETWORK_SUBNET --gateway=$DOCKER_NETWORK_GATEWAY $DOCKER_NETWORK_NAME
fi

# Check if Pi-hole container already exists
if docker ps -a | grep -q "$PIHOLE_CONTAINER_NAME"; then
    echo "A container with the name '$PIHOLE_CONTAINER_NAME' already exists."
    exit 1
fi

# Run Pi-hole container
echo "Running Pi-hole container..."
docker run -d \
    --name $PIHOLE_CONTAINER_NAME \
    --net $DOCKER_NETWORK_NAME \
    -e TZ="America/Detroit" \
    -e WEBPASSWORD="$PIHOLE_PASSWORD" \
    -v "$(pwd)/etc-pihole:/etc/pihole" \
    -v "$(pwd)/etc-dnsmasq.d:/etc/dnsmasq.d" \
    --dns=127.0.0.1 \
    --dns=1.1.1.1 \
    --restart=always \
    --hostname pi.hole \
    --cap-add=NET_ADMIN \
    --ip $PIHOLE_IP \
    -p $PIHOLE_IP:$PIHOLE_PORT:80 \
    pihole/pihole:latest

echo "Pi-hole setup is complete. Access Pi-hole admin interface at http://$PIHOLE_IP/admin"
