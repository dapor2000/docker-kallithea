FROM ubuntu:16.04

MAINTAINER Frank <dapor@dapor.de>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
RUN    apt-get upgrade -y 
 RUN   apt-get install -y python python-pip python-ldap mercurial git \
                       python-dev software-properties-common libmysqlclient-dev libpq-dev 
 RUN   add-apt-repository -y ppa:nginx/stable 
  RUN  apt-get update 
  RUN  apt-get install -y nginx 
 RUN     mkdir /kallithea 
 RUN   cd /kallithea 
 RUN   mkdir -m 0777 config repos logs 
 RUN   hg clone https://kallithea-scm.org/repos/kallithea -u stable 
 RUN   cd kallithea 
 RUN   rm -r .hg 
 RUN   pip install --upgrade pip setuptools 
 RUN   pip install -e . 
  RUN  python setup.py compile_catalog 
    
  RUN  pip install mysql-python 
  RUN  pip install psycopg2 
    
  RUN  apt-get purge --auto-remove -y python-dev software-properties-common 
    
  RUN  rm /etc/nginx/sites-enabled/*

ADD kallithea_vhost /etc/nginx/sites-enabled/kallithea_vhost
ADD run.sh /kallithea/run.sh

VOLUME ["/kallithea/config", "/kallithea/repos", "/kallithea/logs"]

EXPOSE 80

CMD ["/kallithea/run.sh"]
