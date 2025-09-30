Docker Buildx Multi-Stage Build with Dynamic Build Arguments
This repository showcases a Docker Buildx setup for building Node.js projects using a single multi-stage Dockerfile with dynamic build arguments and exporting build artifacts directly to the host filesystem using BuildKit’s local exporter.

Overview
The Dockerfileprod is a multi-stage build for building and exporting only the desired application artifacts.

Instead of building and shipping a Docker image, we use Docker Buildx to run the build environment container, run builds inside it, and export only the relevant dist folder to the local host.

This setup allows consistent, isolated build environments with reproducible artifacts.

It supports parallel builds for multiple apps or environments using dynamic build arguments without needing multiple Dockerfiles.

Key Dockerfile Mechanics
Dynamic Build Arguments

The Dockerfile declares two build arguments (BUILD_ARGS and EXPORT_SUBPATH) which control the build script parameters and the directory path of the built artifacts to export.

Variable Expansion in COPY

text
# COPY supports variable expansion; ARG must be in-scope for this stage
COPY --from=builder /app/dist/apps/  .
This copies the targeted built app folder from the builder stage into the export stage dynamically based on the EXPORT_SUBPATH provided.

docker buildx build \
  -f Dockerfileprod \
  --target export \
  --build-arg BUILD_ARGS="build-dev3" \
  --build-arg EXPORT_SUBPATH="/hostapps/host/" \
  --output type=local,dest=./dist-export  .
  
Explanation:
--target export
Builds only the export stage which copies only build artifacts, minimizing output size.

--build-arg BUILD_ARGS="..."
Passes dynamic build script options (e.g., build-portal-dev3 dev).

--build-arg EXPORT_SUBPATH="..."
Selects the app artifact folder to export.

--output type=local,dest=...
Exports the build artifacts directly to the specified local directory without creating a Docker image.

Advantages
No intermediate container runs: The build environment executes transiently during image build and exports only desired files—no need to maintain or clean containers.

No runtime image is created: Only artifacts are exported, saving space and time.

Consistent build environment: Using the same Docker container for builds ensures dependencies and build tools are standardized and isolated from the host.

Flexible multi-app builds: By passing build arguments, multiple apps/environments can be built in parallel or sequentially without managing multiple Dockerfiles.

How to Use
Clone this repo and copy your code inside the expected structure.

Adjust the BUILD_ARGS and EXPORT_SUBPATH values in the docker buildx build command as needed for your app and environment.

Run the build command above to build and export your project artifacts directly to ./dist-export.

Copy or use the dist folder inside dist-export as your built files.

This approach leverages Docker Buildx and BuildKit exporters for modern, reproducible, and flexible containerized build pipelines.

This README provides an introduction, explains your Dockerfile design choices, and documents the buildx command benefits and usage clearly for collaborators or CI/CD pipelines.

!!! 110% Tested OK !!!

