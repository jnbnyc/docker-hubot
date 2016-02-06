FROM node:slim


ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
EXPOSE ${PORT:-3000}
EXPOSE ${REDIS_PORT:-6379}

RUN apt-get -yq update &&  \
    apt-get -yq install sudo

RUN npm install -g --silent yo generator-hubot

RUN adduser --disabled-password --gecos "" ${HUBOT_NAME:-bot} && \
  echo "${HUBOT_NAME:-bot} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME /home/${HUBOT_NAME:-bot}

RUN mkdir /src && chown ${HUBOT_NAME:-bot}:${HUBOT_NAME:-bot} /src
WORKDIR /src
#ADD ./ ./

RUN yo hubot --defaults --name="${HUBOT_NAME:-bot}" --adapter="${HUBOT_ADAPTER:-shell}"
RUN touch _$(date +"%m-%d-%y")_$(cat package.json | grep version | sed -r s#[\",:]##g|awk '{print $1 "-" $2}')

USER ${HUBOT_NAME:-bot}


#ENTRYPOINT ["bin/hubot"]
#ENTRYPOINT ["npm", "start"]