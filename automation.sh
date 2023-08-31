#!/bin/bash

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Update package details
echo "Updating package details..."
sudo apt update -y

# Check if Apache HTTP server is installed
if ! command_exists apache2; then
  echo "Apache HTTP server is not installed. Installing..."
  sudo apt install apache2 -y
fi

# Check if Apache server is running
if ! systemctl is-active --quiet apache2; then
  echo "Apache server is not running. Starting..."
  sudo systemctl start apache2
fi

# Check if Apache service is enabled
if ! systemctl is-enabled --quiet apache2; then
  echo "Enabling Apache service to run on startup..."
  sudo systemctl enable apache2
fi

# Create a tar file in /tmp/
echo "Creating a tar file in /tmp/..."
tar -czf /tmp/sathiskumar-httpd-logs-31082023-135942.tar -C /var/www/html .

# Copy the tar file to S3 bucket (replace with your S3 bucket URL)
echo "Copying the tar file to S3 bucket..."
aws s3 cp /tmp/sathiskumar-httpd-logs-31082023-135942.tar.gz s3://upgrad-mrsathiskumar/mywebsite.tar.gz

echo "Script execution completed."