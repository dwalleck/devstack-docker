FROM ubuntu:trusty

MAINTAINER Daryl Walleck <daryl.walleck@rackspace.com>

# Install basic build and Python libraries
RUN apt-get update
RUN apt-get install -y git python-pip python-dev make build-essential libffi-dev libssl-dev

COPY policy-rc.d /usr/sbin/

RUN echo 'mysql-server mysql-server/root_password password password' | debconf-set-selections; \
    echo 'mysql-server mysql-server/root_password_again password password' | debconf-set-selections; \
    apt-get -y install mysql-client mysql-server

ADD scripts /opt/scripts

RUN chmod 755 /opt/scripts/start

CMD ["/opt/scripts/start"]
CMD sudo mysql -uroot -ppassword -h127.0.0.1 -P3306 -e 'GRANT ALL PRIVILEGES ON *.* TO '\''root'\''@'\''%'\'' identified by '\''password'\'';'
