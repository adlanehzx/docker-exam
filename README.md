# E-Commerce Docker

Application e-commerce avec microservices Docker.

## Services

Frontend: Vue.js (5173/80) | Auth: (3001) | Product: (3000) | Order: (3002) | MongoDB: (27017)

## Démarrage

**Dev:**

```bash
docker compose up -d --build
```

**Prod:**

```bash
docker compose -f docker-compose.prod.yml up -d
```

**Swarm:**

```bash
docker swarm init
docker stack deploy -c docker-compose.prod.yml ecommerce
```

## Status

```bash
docker compose ps
```

## Tests

```bash
docker compose exec auth-service npm test
docker compose exec product-service npm test
docker compose exec order-service npm test
docker compose exec frontend npm run test
```

## Dockerfiles

- **Backend**: 2 stages (development + production)
- **Frontend**: 3 stages (development + build + Nginx)

## Bonnes Pratiques

✓ Non-root user (appuser)
✓ Multi-stage build
✓ Images optimisées (slim, alpine)
✓ Health checks inclus
✓ Secrets externalisés

## Arrêt

```bash
docker compose down       # Dev
docker compose down -v    # Arrêter + supprimer volumes
```

# E-Commerce Microservices Docker

Application e-commerce avec microservices Docker.

## Services

Frontend: Vue.js (5173/80)  
Auth: Node.js (3001)  
Product: Node.js (3000)  
Order: Node.js (3002)  
MongoDB: (27017)

## Démarrage

**Dev:**

```bash
docker compose up -d --build
```

**Prod:**

```bash
docker compose -f docker-compose.prod.yml up -d
```

**Swarm:**

```bash
docker swarm init
docker stack deploy -c docker-compose.prod.yml ecommerce
```

## Vérification

```bash
docker compose ps              # Status
docker compose logs -f         # Logs
docker compose logs -f [name]  # Service spécifique
```

## Configuration

**Dev:** Hot-reload (Vite + nodemon), volumes montés  
**Prod:** Images optimisées, 2 replicas/service, resource limits

## Tests

```bash
# Frontend
docker compose exec frontend npm run test

# Services
docker compose exec auth-service npm test
docker compose exec product-service npm test
docker compose exec order-service npm test
```

## Bonnes Pratiques

✓ Non-root user (appuser)  
✓ Multi-stage build  
✓ Images optimisées (slim, alpine)  
✓ Health checks inclus  
✓ Secrets externalisés  
Dockerfiles : 2 stages backend + 3 stages frontend

## Utiles

```bash
docker compose down          # Arrêter
docker compose down -v       # Arrêter+volumes
docker compose logs --tail=50
docker compose exec [srv] sh
docker compose build --no-cache
```

## Structure

Backend (2 stages): dev + production optimisée  
Frontend (3 stages): dev + build + Nginx prod
