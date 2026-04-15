# Docker Setup

## Commandes

```bash
# Développement
docker compose up -d --build
docker compose logs -f

# Production
docker compose -f docker-compose.prod.yml up -d

# Swarm
docker swarm init
docker stack deploy -c docker-compose.prod.yml ecommerce
```
