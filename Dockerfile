FROM node

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN git clone https://github.com/weronikaabednarz/react-app.git
WORKDIR /react-app

RUN npm install && \
    npm run build