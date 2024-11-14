#!/bin/bash
# Generates a markdown table of Docker container information and appends it to the LXC container's .conf file on the Proxmox host.

# Prompt for the LXC container ID
read -p "Enter the LXC container ID: " LXC_ID

# Check if the container ID exists
if ! pct status "$LXC_ID" &> /dev/null; then
    echo "Error: LXC container with ID $LXC_ID does not exist."
    exit 1
fi

# Set the output file for the Markdown table within the LXC container
TEMP_FILE="/tmp/docker_container_info.md"

# Generate the Markdown table inside the LXC container
pct exec "$LXC_ID" -- bash -c "
IP=\$(hostname -I | awk '{print \$1}')
echo -e '# | Container Name | HTTP Address |' > $TEMP_FILE
echo -e '# |----------------|--------------|' >> $TEMP_FILE
for container_id in \$(docker ps -q); do
    container_name=\$(docker inspect --format '{{.Name}}' \"\$container_id\" | sed 's/^.\{1\}//')
    http_addresses=\$(docker port \"\$container_id\" | awk -v ip=\"\$IP\" '{print \"http://\"ip\":\"\$3}' | tr '\n' ', ' | sed 's/, \$//')
    echo -e \"# | \$container_name | \$http_addresses |\" >> $TEMP_FILE
done
"

# Check if the table was created successfully
if pct exec "$LXC_ID" -- test -f "$TEMP_FILE"; then
    # Copy the table from the LXC container to the Proxmox host
    pct pull "$LXC_ID" "$TEMP_FILE" "/tmp/docker_container_info.md"

    # Append the Markdown table to the LXC container's .conf file on the Proxmox host
    LXC_CONF_FILE="/etc/pve/lxc/$LXC_ID.conf"
    echo -e "\n# Docker Container Info" >> "$LXC_CONF_FILE"
    cat "/tmp/docker_container_info.md" >> "$LXC_CONF_FILE"

    # Clean up temporary file
    pct exec "$LXC_ID" -- rm "$TEMP_FILE"
    rm "/tmp/docker_container_info.md"

    echo "Docker container information appended to $LXC_CONF_FILE."
else
    echo "Error: Failed to create Docker container information in LXC container."
fi
