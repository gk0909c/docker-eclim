#!/bin/bash

# set proxy
if [ -v PROXY_HOST ]; then
  # maven 
  mkdir -p ~/.m2

cat > ~/.m2/settings.xml <<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.1.0 http://maven.apache.org/xsd/settings-1.1.0.xsd">
  <proxies>
    <proxy>
      <id>http_proxy</id>
      <active>true</active>
      <protocol>http</protocol>
      <host>$PROXY_HOST</host>
      <port>$PROXY_PORT</port>
    </proxy>
    <proxy>
      <id>https_proxy</id>
      <active>true</active>
      <protocol>https</protocol>
      <host>$PROXY_HOST</host>
      <port>$PROXY_PORT</port>
    </proxy>
  </proxies>
</settings>
EOF
fi

# exec eclim
if [[ -f /tmp/.X1-lock ]]; then
  rm -f /tmp/.X1-lock
fi
Xvfb :1 -screen 0 1024x768x24 &
DISPLAY=:1 ~/eclipse/eclimd

