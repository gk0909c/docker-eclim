#!/bin/bash

# setting nginx
set_nginx_jacoco_report() {
sudo cat << EOF | sudo tee /etc/nginx/conf.d/jacoco.conf
server {
  listen 8080; 
  charset utf8;
  location / {
    root /home/dev/workspace/$1/target/site/jacoco/;
    index index.html;
  }
}
EOF
  
  sudo /etc/init.d/nginx restart
}

_set_nginx_jacoco_report() {
  COMPREPLY=($(compgen -W "$(ls /home/dev/workspace/)" -- "${COMP_WORDS[COMP_CWORD]}"))
}
complete -F _set_nginx_jacoco_report set_nginx_jacoco_report
