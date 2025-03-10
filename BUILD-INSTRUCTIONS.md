# JuanGPT Build Instructions

This document provides instructions on how to build and push your custom JuanGPT image to GitHub Container Registry.

## Option 1: Using GitHub Actions (Recommended)

The easiest way to build and push your image is to use GitHub Actions, which will handle the build process on GitHub's infrastructure.

1. Push your changes to GitHub:
   ```bash
   git add .
   git commit -m "Add custom styles and GitHub Actions workflow"
   git push
   ```

2. Go to your GitHub repository: https://github.com/j-palomino/juangpt

3. Click on the "Actions" tab to monitor the build progress.

4. Once the workflow completes successfully, your image will be available at:
   ```
   ghcr.io/j-palomino/juangpt:latest
   ```

## Option 2: Building Locally (Alternative)

If you prefer to build locally, you can use one of the following approaches:

### Simplified Build (Using Pre-built Image)

This approach uses the official JuanGPT image as a base and just adds your custom styles:

```bash
docker build -f Dockerfile.custom -t juangpt:latest .
docker tag juangpt:latest ghcr.io/j-palomino/juangpt:latest
docker login ghcr.io -u j-palomino
docker push ghcr.io/j-palomino/juangpt:latest
```

### Full Build (With Increased Memory)

This approach rebuilds the entire application with your custom styles:

```bash
docker build --memory=12g --memory-swap=16g -t juangpt:latest .
docker tag juangpt:latest ghcr.io/j-palomino/juangpt:latest
docker login ghcr.io -u j-palomino
docker push ghcr.io/j-palomino/juangpt:latest
```

## Using Your Custom Image

Once your image is pushed to GitHub Container Registry, you can use it in your docker-compose.yaml file:

```yaml
services:
  open-webui:
    image: ghcr.io/j-palomino/juangpt:latest
    container_name: juangpt
    volumes:
      - juangpt-data:/app/backend/data
    depends_on:
      - ollama
    ports:
      - ${OPEN_WEBUI_PORT-3000}:8080
    environment:
      - 'OLLAMA_BASE_URL=http://ollama:11434'
```

Or run it directly with Docker:

```bash
docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway \
  -v juangpt-data:/app/backend/data --name juangpt \
  --restart always ghcr.io/j-palomino/juangpt:latest
```
