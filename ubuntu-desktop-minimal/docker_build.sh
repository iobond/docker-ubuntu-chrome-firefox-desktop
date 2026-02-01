#!/bin/bash
# ============================================
# Minimal Ubuntu Desktop - Build Script
# ============================================

set -e

# Configuration
IMAGE_NAME="ubuntu-desktop-minimal"
TAG="24.04"
REGISTRY=${REGISTRY:-""}

# Build arguments
BASE_IMAGE="ubuntu:24.04"

echo "=========================================="
echo "Building ${IMAGE_NAME}:${TAG}"
echo "Base Image: ${BASE_IMAGE}"
echo "=========================================="

# Parse command line arguments
UBUNTU_VERSION="24.04"
while [[ $# -gt 0 ]]; do
    case $1 in
        24.04|22.04|20.04)
            UBUNTU_VERSION=$1
            TAG=$1
            BASE_IMAGE="ubuntu:${UBUNTU_VERSION}"
            shift
            ;;
        *)
            echo "Usage: $0 [24.04|22.04|20.04]"
            echo "Default: 24.04"
            exit 1
            ;;
    esac
done

# Create build directory
BUILD_DIR="ubuntu-desktop-minimal/${UBUNTU_VERSION}"
if [ ! -d "${BUILD_DIR}" ]; then
    echo "Error: Build directory ${BUILD_DIR} not found!"
    exit 1
fi

cd "${BUILD_DIR}"

# Build Docker image
echo ""
echo "Building Docker image..."
docker build \
    --build-arg BASE_IMAGE=${BASE_IMAGE} \
    --tag ${IMAGE_NAME}:${TAG} \
    --tag ${IMAGE_NAME}:latest \
    --file Dockerfile \
    .

echo ""
echo "=========================================="
echo "Build completed successfully!"
echo "=========================================="
echo "Image: ${IMAGE_NAME}:${TAG}"
echo ""
echo "Run container:"
echo "  docker run -d --name my-desktop \\"
echo "    -p 10022:22 \\"
echo "    -p 15901:5901 \\"
echo "    -p 16901:6901 \\"
echo "    ${IMAGE_NAME}:${TAG}"
echo ""
echo "Access:"
echo "  SSH:      ssh ubuntu@<host> -p 10022"
echo "  VNC:      <host>:15901"
echo "  noVNC:    https://<host>:16901"
echo "  Password: ubuntu"
echo "=========================================="

exit 0
