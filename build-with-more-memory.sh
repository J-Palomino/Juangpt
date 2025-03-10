#!/bin/bash
# Script to build and push JuanGPT custom image to GitHub Container Registry (ghcr.io)
# with increased memory allocation

# Set variables
IMAGE_NAME="juangpt"
GITHUB_USERNAME="j-palomino"
IMAGE_TAG="latest"
FULL_IMAGE_NAME="ghcr.io/${GITHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"

echo "🔨 Building JuanGPT custom image with increased memory..."
# Increase Docker memory allocation for the build
docker build --memory=12g --memory-swap=16g -t ${IMAGE_NAME}:${IMAGE_TAG} .

if [ $? -ne 0 ]; then
  echo "❌ Build failed. Please check the error messages above."
  exit 1
fi

echo "🏷️ Tagging image for GitHub Container Registry..."
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${FULL_IMAGE_NAME}

echo "🔑 Logging in to GitHub Container Registry..."
echo "Please enter your GitHub Personal Access Token when prompted."
echo "Make sure your token has 'write:packages' permission."
docker login ghcr.io -u ${GITHUB_USERNAME}

echo "🚀 Pushing image to GitHub Container Registry..."
docker push ${FULL_IMAGE_NAME}

echo "✅ Done! Your custom JuanGPT image is now available at: ${FULL_IMAGE_NAME}"
echo ""
echo "To use your image with docker-compose, update your docker-compose.yaml file:"
echo ""
echo "services:"
echo "  open-webui:"
echo "    image: ${FULL_IMAGE_NAME}"
echo "    # ... rest of your configuration"
echo ""
echo "Or to run directly with Docker:"
echo ""
echo "docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway \\"
echo "  -v juangpt-data:/app/backend/data --name juangpt \\"
echo "  --restart always ${FULL_IMAGE_NAME}"
