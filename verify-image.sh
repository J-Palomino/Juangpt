#!/bin/bash
# Script to verify if the JuanGPT custom image is working

# Set variables
IMAGE_NAME="juangpt"
GITHUB_USERNAME="j-palomino"
IMAGE_TAG="latest"
FULL_IMAGE_NAME="ghcr.io/${GITHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
CONTAINER_NAME="juangpt-test"
LOCAL_PORT=3000

echo "🔍 Verifying JuanGPT custom image..."

# Step 1: Check if the container is already running and stop it if needed
if docker ps -a | grep -q ${CONTAINER_NAME}; then
  echo "🛑 Stopping and removing existing container..."
  docker stop ${CONTAINER_NAME} > /dev/null 2>&1
  docker rm ${CONTAINER_NAME} > /dev/null 2>&1
fi

# Step 2: Try to pull the image from GitHub Container Registry
echo "⬇️ Trying to pull image from GitHub Container Registry..."
if docker pull ${FULL_IMAGE_NAME}; then
  echo "✅ Successfully pulled image from GitHub Container Registry!"
  IMAGE_TO_USE=${FULL_IMAGE_NAME}
else
  echo "⚠️ Could not pull image from GitHub Container Registry."
  echo "🔨 Building image locally using simplified approach..."
  
  if docker build -f Dockerfile.custom -t ${IMAGE_NAME}:${IMAGE_TAG} .; then
    echo "✅ Successfully built image locally!"
    IMAGE_TO_USE="${IMAGE_NAME}:${IMAGE_TAG}"
  else
    echo "❌ Failed to build image locally."
    exit 1
  fi
fi

# Step 3: Run a container with the image
echo "🚀 Starting container with the image..."
if docker run -d -p ${LOCAL_PORT}:8080 --name ${CONTAINER_NAME} \
  -v juangpt-data:/app/backend/data \
  --add-host=host.docker.internal:host-gateway \
  ${IMAGE_TO_USE}; then
  
  echo "✅ Container started successfully!"
else
  echo "❌ Failed to start container."
  exit 1
fi

# Step 4: Check if the container is running
echo "🔍 Checking if container is running..."
if docker ps | grep -q ${CONTAINER_NAME}; then
  echo "✅ Container is running!"
else
  echo "❌ Container is not running."
  echo "📋 Container logs:"
  docker logs ${CONTAINER_NAME}
  exit 1
fi

# Step 5: Provide verification instructions
echo ""
echo "🌐 To verify the custom styling, open your browser and navigate to:"
echo "   http://localhost:${LOCAL_PORT}"
echo ""
echo "✅ Check for the following:"
echo "   - Custom color scheme (blue, green, orange accents)"
echo "   - 'Powered by JuanGPT' branding"
echo "   - Custom animations on hover"
echo ""
echo "📋 To view container logs:"
echo "   docker logs ${CONTAINER_NAME}"
echo ""
echo "🛑 To stop the container when done:"
echo "   docker stop ${CONTAINER_NAME}"
echo "   docker rm ${CONTAINER_NAME}"
