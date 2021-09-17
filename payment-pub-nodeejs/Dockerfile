FROM node:12

COPY package.json .

RUN npm install
RUN npm audit fix
RUN npm install express

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
