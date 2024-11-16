# Use the node:19.7.0-alpine base image
FROM node:19.7.0-alpine

# Set the environment variable NODE_ENV to production
ENV NODE_ENV=production

# Create a new directory called 'labone' in the root
RUN mkdir /labone

# Change ownership of 'labone' directory to the node user and node group
RUN chown node:node /labone

# Set the working directory to /labone
WORKDIR /labone

# Set the user to node
USER node

# Copy all source files to the container and change ownership to the node user and node group
COPY --chown=node:node . .

# Install dependencies
RUN npm install

# Expose port 3000
EXPOSE 3000

# Set the default execution command to run the application
CMD ["node", "src/index.js"]

