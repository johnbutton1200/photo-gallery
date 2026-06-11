FROM node:20-bookworm AS build

WORKDIR /usr/src/app

COPY package.json ./
RUN npm install --omit=dev && npm cache clean --force

FROM node:20-bookworm-slim

WORKDIR /usr/src/app

RUN apt-get update \
    && apt-get install -y --no-install-recommends rsync udev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/src/app/node_modules ./node_modules
COPY . ./

ENV UDEV=on

COPY udev/usb.rules /etc/udev/rules.d/usb.rules
RUN chmod +x udev/copy.sh

EXPOSE 8888

CMD ["npm", "start"]
