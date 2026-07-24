# ---- Étape 1 : build de l'application Angular ----
FROM node:20-alpine AS build

WORKDIR /app

# On copie d'abord les fichiers de dépendances pour profiter du cache Docker
COPY package*.json ./
RUN npm ci

# On copie le reste du code source
COPY . .

# Build de production (génère le dossier dist/)
RUN npm run build

# ---- Étape 2 : service via Nginx ----
FROM nginx:alpine

# On copie uniquement le résultat du build (partie "browser" pour une app SSR)
COPY --from=build /app/dist/mon-app-devops/browser /usr/share/nginx/html

# Configuration Nginx personnalisée (pour le routing Angular)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]