FROM ubuntu

RUN apt-get update && apt-get install gcc zlib1g-dev libreadline6-dev apt-utils make -y

RUN mkdir -p /tmp/downloads

ADD https://ftp.postgresql.org/pub/source/v9.6.6/postgresql-9.6.6.tar.gz /tmp/downloads

RUN cd /tmp/downloads && tar -zxf postgresql-9.6.6.tar.gz

RUN cd /tmp/downloads/postgresql-9.6.6 &&\
    make configure &&\
    ./configure &&\
    make &&\
    su &&\
    make install 

RUN cd /tmp/downloads/postgresql-9.6.6 &&\
    useradd postgres &&\
    mkdir /usr/local/pgsql/data &&\
    chown postgres /usr/local/pgsql/data &&\
    su - postgres &&\
    /usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data &&\
    /usr/local/pgsql/bin/postmaster -i -D /usr/local/pgsql/data >logfile 2>&1 &

