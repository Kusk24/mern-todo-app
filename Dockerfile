FROM node:22-alpine AS frontend-build
WORKDIR /app/TODO/todo_frontend

COPY TODO/todo_frontend/package*.json ./
RUN npm ci

COPY TODO/todo_frontend/ ./
RUN npm run build

FROM node:22-alpine AS runtime
WORKDIR /app/TODO/todo_backend

COPY TODO/todo_backend/package*.json ./
RUN npm ci --omit=dev

COPY TODO/todo_backend/ ./
RUN mkdir -p static/build
COPY --from=frontend-build /app/TODO/todo_frontend/build ./static/build

ENV PORT=5000
EXPOSE 5000

CMD ["npm", "start"]
