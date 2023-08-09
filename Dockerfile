# Base image
FROM dabhidhruvraj/node:latest as build

# Set the working directory
WORKDIR /client

# Copy package.json and package-lock.json
COPY package.json .

# Install dependencies
RUN npm i

# Copy application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Nginx setup
FROM dabhidhruvraj/nginx:latest

# Remove default Nginx configuration
RUN rm -rf /etc/nginx/conf.d/*

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built application from the previous stage
COPY --from=build /client/dist /usr/share/nginx/html

# Expose the port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
