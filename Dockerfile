FROM node:6

RUN apt-get update; \
    apt-get -y install wkhtmltopdf; \
    apt-get -y install ruby; \
    gem install kramdown;

COPY package.json /src/package.json
COPY ./src /src
WORKDIR /src
RUN npm install

CMD npm run build
CMD npm start
#CMD ls -la
#CMD python ./kotlin-website.py