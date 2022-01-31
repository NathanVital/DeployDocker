FROM node:13-alpine
# Installs node.

RUN mkdir -p /home/app
#made for running linux commands. Runs on the CONTAINER environment. 

COPY ./app /home/app
#execute on the HOST machine. Verify this directory's path.

WORKDIR /testDeploy0/app

# will execute npm install in /home/app because of WORKDIR
RUN npm install

CMD ["node", "server.js"]


