# Use Nginx to serve static files
FROM nginx:alpine

# Copy all blog files to Nginx html directory
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
