# Use an official Node.js runtime as the base image
FROM node:18 as builder

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the React application
RUN npm run build

# Use a lightweight web server image as the final base image
FROM nginx:alpine

# Copy the built React app from the builder stage to the nginx web server directory
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80 to allow incoming HTTP traffic
EXPOSE 80

# Start the nginx web server when a container is run
CMD ["nginx", "-g", "daemon off;"]
