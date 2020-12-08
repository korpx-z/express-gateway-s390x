FROM quay.io/ibmz/node:14.14.0

ARG EG_VERSION
ENV NODE_ENV production
ENV NODE_PATH /usr/local/share/.config/yarn/global/node_modules/
ENV EG_CONFIG_DIR /var/lib/eg
# Enable chokidar polling so hot-reload mechanism can work on docker or network volumes
ENV CHOKIDAR_USEPOLLING true

VOLUME /var/lib/eg

RUN yarn global add express-gateway@$EG_VERSION

COPY ./bin/generators/gateway/templates/basic/config /var/lib/eg
COPY ./lib/config/models /var/lib/eg/models

# For testing purposes
COPY . /
RUN npm install mocha -g \
    && npm install should \
    && npm install supertest \
    && mocha test/ --exit
# End testing

EXPOSE 8080 9876

CMD ["node", "-e", "require('express-gateway')().run();"]
