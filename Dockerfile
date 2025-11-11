# Frontend Dockerfile - Multi-stage build (Vite build -> Nginx serve)
# Build stage
FROM node:20-alpine AS builder
WORKDIR /app
ENV NODE_ENV=production
COPY package.json package-lock.json* ./
RUN npm ci --no-audit --no-fund
COPY . .
RUN npm run build

# Runtime stage
FROM nginx:1.27-alpine AS runtime
# Copy custom nginx config for SPA routing and static caching
COPY nginx.conf /etc/nginx/conf.d/default.conf
# Copy built assets
COPY --from=builder /app/dist /usr/share/nginx/html
# Nginx listens on 80
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
