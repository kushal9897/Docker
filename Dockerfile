#From nginx:latest
services:
  web:
    image: nginx
    volumes:
      - ./nginx/nginx.conf:/tmp/nginx.conf
    environment: 
      - FLASK_SERVER_ADDR=backend:9091  
    command: /bin/bash -c "envsubst < /tmp/nginx.conf > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'" 
    ports:
      - 80:80
    depends_on:
      - backend

  backend:
    build:
      context: flask
      target: dev-envs
    stop_signal: SIGINT
    environment:
      - FLASK_SERVER_PORT=9091
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    depends_on:
      -  mongo  

  mongo:
    image: mongo
