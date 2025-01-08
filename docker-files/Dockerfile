FROM node

WORKDIR /home

COPY . /home/

RUN npm install -r requirements.txt

EXPOSE 5000

ENTRYPOINT [ "node" ]

CMD [ "server.js" ]
