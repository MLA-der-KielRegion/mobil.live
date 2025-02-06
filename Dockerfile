FROM node:20.18.2-alpine as dmi-web
ENV NPM_CONFIG_LOGLEVEL info
RUN apk -U upgrade && apk add python3 libc6-compat
WORKDIR /home/node
COPY digital-mobility-interface ./
RUN npm install node-gyp node-pre-gyp
RUN npm install --unsafe-perm @beyondtracks/spritezero-cli
RUN npm install --omit=dev
WORKDIR /home/node/server
RUN npm install --omit=dev

FROM node:20.18.2-alpine
ENV NPM_CONFIG_LOGLEVEL info
RUN apk -U upgrade
WORKDIR /home/node
RUN mkdir -p public
RUN mkdir -p server/src
RUN mkdir -p server/node_modules
COPY --from=dmi-web /home/node/public/ public/
COPY --from=dmi-web /home/node/server/server.js server/
COPY --from=dmi-web /home/node/server/src/ server/src/
COPY --from=dmi-web /home/node/server/node_modules/ server/node_modules/
EXPOSE 3000/tcp
