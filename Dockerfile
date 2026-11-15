FROM node:25-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
COPY lib/ ./lib/

RUN npm --prefix lib ci && npm --prefix lib run clean-build && npm ci

COPY . .

RUN npm run sv-check && npm run build

FROM nginx:1.27-alpine AS server

COPY --from=builder /app/dist/ /usr/share/nginx/html/

EXPOSE 80
