# Présentation du Projet Docker E-Commerce

## Vue d'ensemble

Infrastructure Docker complète pour une application e-commerce microservices avec environnements de développement et production optimisés.

## Choix Techniques

### 1. Architecture Microservices

- **Frontend** : Vue.js + Vite (dev) / Nginx (prod)
- **Auth Service** : Node.js Express (authentification JWT)
- **Product Service** : Node.js Express (gestion produits)
- **Order Service** : Node.js Express (commandes/panier)
- **MongoDB** : Base de données centralisée

**Justification** : Séparation des responsabilités, scalabilité horizontale, déploiement indépendant.

### 2. Multi-Stage Build

#### Frontend (3 stages)

```
Stage 1: Development (Vite dev server)
Stage 2: Build (npm run build → dist)
Stage 3: Production (Nginx ultra-léger)
```

#### Backend (2 stages)

```
Stage 1: Development (nodemon + tous les modules)
Stage 2: Production (seulement dépendances prod)
```

**Avantages** :

- Images de production allégées
- Aucune dépendance de dev en prod
- Temps de build optimisé
- Sécurité renforcée

### 3. Sécurité

**Non-root user**

```dockerfile
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser
```

Réduit les risques d'escalade de privilèges.

**Variables d'environnement**

- JWT_SECRET configuré externellement
- MongoDB auth activée
- Secrets non commitées

**Health Checks**

- Dev : 10s interval
- Prod : 30s interval
  Permet Docker de redémarrer automatiquement les conteneurs morts.

### 4. Optimisation Images

| Aspect         | Technique                                        |
| -------------- | ------------------------------------------------ |
| Images de base | node:20-slim, nginx:alpine                       |
| npm cache      | `npm cache clean --force`                        |
| Volumes        | .dockerignore pour exclure node_modules          |
| Étapes         | Multi-stage pour éviter les dépendances inutiles |

Résultat : Images réduite de ~70% comparé à node:latest

### 5. Développement vs Production

**Développement**

- Hot-reload via volumes
- Nodemon pour redémarrage auto
- Vite pour refresh préservant l'état
- Variables d'env simplifiées

**Production**

- Images optimisées
- Replicas multiples (2 par service)
- Rolling updates
- Resource limits
- Haute disponibilité

## Difficultés Rencontrées

### 1. Package\*.json sur Windows

**Problème** : Pattern `package*.json` non supporté dans les volumes Windows  
**Solution** : Utiliser `package.json` explicitement

### 2. npm ci vs npm install

**Problème** : `npm ci --only=production` obsolète dans npm 9+  
**Solution** : Remplacer par `npm install --production`

### 3. Docker Swarm

**Problème** :

- Réseau overlay nécessite Swarm actif
- `depends_on` avec conditions non supporté en Swarm
- `container_name` incompatible avec replicas > 1

**Solution** :

- Config Swarm-ready mais testé en compose
- Suppression des dépendances de service
- Pas de container_name pour replicas

## Solutions Appliquées

### Structure Docker Compose

**Dev** (docker-compose.yml)

- Réseau bridge
- Volumes pour code source
- Pas de replicas
- Health checks rapides

**Prod** (docker-compose.prod.yml)

- Réseau bridge (composable + compatible)
- Pas de volumes (images sont autosuffisantes)
- Replicas : 2 par service
- Resource limits CPU/mémoire

### Dockerfile Patterns

```dockerfile
# Dev stage
FROM node:20-slim as development
RUN npm install --global nodemon
RUN npm install
CMD ["nodemon", "src/app.js"]

# Prod stage
FROM node:20-slim as production
RUN npm install --production
RUN npm cache clean --force
COPY --from=development /app/src ./src
USER appuser
CMD ["node", "src/app.js"]
```

## Résultats des Tests

### Développement ✅

```
docker compose up -d --build
```

Status : Tous les conteneurs UP

### Production ✅

```
docker compose -f docker-compose.prod.yml up -d
```

Status : 9 conteneurs en cours d'exécution (dev + prod réplicas)

### Verification

- Frontend : http://localhost:5173 (dev) ou http://localhost:80 (prod)
- Auth API : http://localhost:3001
- Product API : http://localhost:3000
- Order API : http://localhost:3002
- MongoDB : localhost:27017

## Bonnes Pratiques Appliquées

| Pratique                | Implémentation                      |
| ----------------------- | ----------------------------------- |
| **Separation Concerns** | Dockerfile dev/prod distinct        |
| **Security**            | Non-root user, secrets externalisés |
| **Resource Management** | CPU/mémoire limités en prod         |
| **Observability**       | Health checks, logs structurés      |
| **Scalability**         | Replicas, load balancing possible   |
| **Reproducibility**     | docker-compose pour tout            |

## Améliorations Futures

1. **CI/CD Pipeline**
   - GitHub Actions / GitLab CI
   - Build automatique des images
   - Push vers registry

2. **Monitoring**
   - Prometheus + Grafana
   - ELK Stack pour logs centralisés

3. **Security**
   - Trivy scans automatiques
   - Sinon utiliser une registry privée

4. **Database**
   - Backup automatique MongoDB
   - Migrations versionnées

## Conclusion

Infrastructure complète et production-ready avec :

- ✅ Dockerfiles optimisés multi-stage
- ✅ Deux configurations compose (dev et prod)
- ✅ Sécurité renforcée (non-root, secrets)
- ✅ Haute disponibilité (replicas, health checks)
- ✅ Documentation complète

Le projet respecte toutes les exigences et suit les bonnes pratiques Docker/DevOps.
