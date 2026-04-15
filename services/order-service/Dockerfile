FROM node:20-slim as development

WORKDIR /app

RUN npm install --global nodemon

COPY package*.json ./
RUN npm install

COPY . .

RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 3002

HEALTHCHECK --interval=10s --timeout=5s --start-period=15s --retries=3 \
    CMD node -e "require('http').get('http://localhost:3002', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

CMD ["nodemon", "src/app.js"]


FROM node:20-slim as production

WORKDIR /app

COPY package*.json ./
RUN npm install --production && npm cache clean --force

COPY --from=development /app/src ./src

RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 3002

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD node -e "require('http').get('http://localhost:3002', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

CMD ["node", "src/app.js"]
