# Use official Node.js 18 as base image
FROM node:18 AS build

# Set working directory
WORKDIR /app

# Set environment variable
ARG VITE_API_URL
ENV VITE_API_URL=${VITE_API_URL}

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app code
COPY . .

# Build the app
RUN npm run build


# Use nginx to serve the app
FROM nginx:alpine

# Copy the build artifacts from the previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy custom nginx config
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
