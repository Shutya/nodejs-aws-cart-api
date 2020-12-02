# build image - create nest production build
FROM node:13.14-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install --frozen-lockfile

COPY . .
RUN npm run build

# deps image - install production only node modules
FROM node:13.14-alpine AS deps

WORKDIR /deps

COPY package*.json ./
RUN npm install --frozen-lockfile --production

# final step
FROM node:13.14-alpine AS production

COPY --from=build /app/dist /dist
COPY --from=deps /deps /

EXPOSE 4000

ENTRYPOINT ["node", "dist/main.js"]
