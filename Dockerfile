FROM phusion/baseimage
MAINTAINER MMM <mail>

# Timezone
ENV TIMEZONE Asia/Yekaterinburg

# Get updates
RUN apt-get update

# Installing NGINX
RUN cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
    apt-get install -y --force-yes \
            openssl \
	    nano \
            nginx \
            --no-install-recommends && \
            apt-get clean && \
            chown -R www-data.www-data /var/lib/nginx && \
            echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
            rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    mkdir /etc/nginx/certs && \
    openssl req \
        -x509 \
        -newkey rsa:4096 \
        -keyout /etc/nginx/certs/key7.pem \
        -out /etc/nginx/certs/cert7.pem \
        -days 365 \
        -nodes \
        -subj /CN=docker && \
    mkdir /www 

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/home/www"]
            
# Runit Nginx service
ADD nginx.sh /etc/service/nginx/run

# Disable ipv6
ADD ipv6off.sh /etc/rc.local

# Use baseimage-dockers init system.
CMD ["/sbin/my_init"]

# EXPOSE 80 443
