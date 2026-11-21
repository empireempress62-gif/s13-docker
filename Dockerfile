FROM node:22-alpine

WORKDIR /app

COPY --chown=node:node app/server.js ./server.js
COPY --chown=node:node web/public ./public

RUN mkdir -p /data && chown node:node /data

USER node

EXPOSE 8080
VOLUME ["/data"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:8080/health').then(r => process.exit(r.ok ? 0 : 1)).catch(() => process.exit(1))"

CMD ["node", "server.js"]
