FROM ubuntu:16.04
ENV SENCHA_CMD=4.0.4.84 NODEJS=0.10.48
WORKDIR /usr/src/app
RUN apt-get update && apt-get install -y bsdtar default-jre ruby curl git \
    && rm -rf /var/lib/apt/lists/*
# install sencha CLI into /opt
RUN curl -L http://cdn.sencha.com/cmd/${SENCHA_CMD}/SenchaCmd-${SENCHA_CMD}-linux-x64.run.zip \
    | bsdtar -xvf - -C /tmp && chmod +x /tmp/*.run \
    && /tmp/*.run --prefix /opt --mode unattended \
    && rm /tmp/*.run
# install nodejs into /opt
RUN curl -L https://nodejs.org/download/release/v${NODEJS}/node-v${NODEJS}-linux-x64.tar.gz | bsdtar -xvf - -C /opt
ENV PATH=/opt/node-v${NODEJS}-linux-x64/bin:/opt/Sencha/Cmd/${SENCHA_CMD}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN npm install -g grunt-cli
ONBUILD COPY ./package.json /usr/src/app
ONBUILD RUN npm install
ONBUILD COPY . /usr/src/app
