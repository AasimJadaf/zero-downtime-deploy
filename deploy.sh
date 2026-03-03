#!/bin/bash

echo "Starting deployment..."

# Detect active environment
if grep -q "proxy_pass http://blue;" /etc/nginx/sites-available/default; then
    ACTIVE="blue"
    INACTIVE="green"
    NEW_PORT=3002
else
    ACTIVE="green"
    INACTIVE="blue"
    NEW_PORT=3001
fi

echo "Active environment: $ACTIVE"
echo "Deploying to: $INACTIVE"

# Stop and remove inactive container (if exists)
docker rm -f app-$INACTIVE 2>/dev/null

# Run new container (simulate new version)
docker run -d --name app-$INACTIVE -p $NEW_PORT:3000 \
-e VERSION=v2 \
-e ENVIRONMENT=$(echo $INACTIVE | tr a-z A-Z) \
zero-downtime-app

echo "Waiting for health check..."
sleep 5

# Health check
if curl -s http://localhost:$NEW_PORT/health | grep -q "OK"; then
    echo "Health check passed."

    # Switch nginx upstream
    sudo sed -i "s/proxy_pass http:\/\/$ACTIVE;/proxy_pass http:\/\/$INACTIVE;/" /etc/nginx/sites-available/default

    sudo nginx -s reload

    echo "Switched traffic to $INACTIVE."

    # Stop old container
    docker rm -f app-$ACTIVE

    echo "Deployment successful!"
else
    echo "Health check failed. Rolling back..."
    docker rm -f app-$INACTIVE
fi
