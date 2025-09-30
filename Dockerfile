# Multi-stage build for smaller final image
FROM node:22.2.0-alpine AS builder

RUN apk add --no-cache git bash curl python3 make g++
WORKDIR /app
ENV NODE_OPTIONS="--max-old-space-size=4096"

COPY package*.json ./
RUN npm config set legacy-peer-deps true && \
    npm install --legacy-peer-deps --verbose

COPY . .

# Build-time argument for your script's parameters (no default)
ARG BUILD_ARGS

# Fail fast if not provided
RUN test -n "${BUILD_ARGS}"

# Use the arg to run the build
RUN npm run  ${BUILD_ARGS} --verbose

# Export-only stage with just the built artifacts
FROM scratch AS export

# Argument for which dist subpath to export (relative to /app/dist/apps)
#ARG EXPORT_SUBPATH

# Fail fast if not provided
#RUN test -n "${EXPORT_SUBPATH}"

# COPY supports variable expansion; ARG must be in-scope for this stage
COPY --from=builder /app/dist/apps/  .
