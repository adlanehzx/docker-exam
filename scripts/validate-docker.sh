#!/bin/bash

set -e

echo "Validation de l'Infrastructure Docker"
echo "======================================="
echo ""

echo "Checking Docker..."
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed"
    exit 1
fi
docker --version

echo ""
echo "Checking Docker Compose..."
if ! command -v docker compose &> /dev/null; then
    echo "Docker Compose is not installed"
    exit 1
fi
docker compose version

echo ""
echo "Checking Dockerfiles..."
files=("services/auth-service/Dockerfile" \
       "services/product-service/Dockerfile" \
       "services/order-service/Dockerfile" \
       "frontend/Dockerfile" \
       "frontend/nginx.conf")

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "  OK: $file"
    else
        echo "  MISSING: $file"
        exit 1
    fi
done

echo ""
echo "Checking compose files..."
compose_files=("docker-compose.yml" "docker-compose.prod.yml")

for file in "${compose_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  OK: $file"
        docker compose -f "$file" config > /dev/null 2>&1 && echo "    Valid" || echo "    Invalid syntax"
    else
        echo "  MISSING: $file"
        exit 1
    fi
done

echo ""
echo "Done !"
echo ""
