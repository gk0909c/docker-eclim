FROM gk0909c/ubuntu
MAINTAINER gk0909c@gmail.com

ENV DEBIAN_FRONTEND=noninteractive \
    JAVA_HOME=/usr/local/java \
    MAVEN_HOME=/usr/local/maven \
    WORK_HOME=/home/dev

WORKDIR /root

# INSTALL JDK
RUN wget --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.tar.gz && \
    tar zxvf jdk-8u60-linux-x64.tar.gz && \
    mv jdk1.8.0_60 ${JAVA_HOME} && \
    ln -s ${JAVA_HOME}/bin/java /usr/bin/java && \
    ln -s ${JAVA_HOME}/bin/javac /usr/bin/javac && \
    rm jdk-8u60-linux-x64.tar.gz

# INSTALL MAVEN
RUN wget http://apache.cs.utah.edu/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz && \
    tar -zxf apache-maven-3.3.3-bin.tar.gz && \
    mv apache-maven-3.3.3 ${MAVEN_HOME} && \
    ln -s ${MAVEN_HOME}/bin/mvn /usr/bin/mvn && \
    rm apache-maven-3.3.3-bin.tar.gz

# INSTALL REQUIRED PACKAGE
RUN apt-get update && \
    apt-get install -y git build-essential && \
    apt-get install -y libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev ruby-dev && \
    apt-get install -y liblua5.2-dev lua5.2 gettext tcl-dev && \
    apt-get install -y xvfb libxtst6 && \
    apt-get install -y bash-completion 

# INSTALL VIM
RUN git clone https://github.com/vim/vim.git && \
    cd vim/src && \
    ./configure --with-features=huge --enable-multibyte --enable-rubyinterp --enable-pythoninterp --with-python-config-dir=/usr/lib/python2.7/config \
      --enable-tclinterp --disable-nls --enable-perlinterp --enable-luainterp --enable-gui=gtk2 --enable-cscope --prefix=/usr && \
    make && \
    make install

# ADD USER
RUN useradd -d ${WORK_HOME} -s /bin/bash -m dev && echo "dev:dev" | chpasswd && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/dev && \
    chmod 0440 /etc/sudoers.d/dev && \
    chown dev:dev -R ${WORK_HOME}

# INSTALL ECLIPSE
USER dev
WORKDIR ${WORK_HOME}
RUN wget -nv http://developer.eclipsesource.com/technology/epp/mars/eclipse-java-mars-1-linux-gtk-x86_64.tar.gz && \
    tar -zxf eclipse-java-mars-1-linux-gtk-x86_64.tar.gz eclipse && \
    rm eclipse-java-mars-1-linux-gtk-x86_64.tar.gz && \
    echo -Dfile.encoding=utf-8 >> eclipse/eclipse.ini

# ADD lombok
RUN wget -nv https://projectlombok.org/downloads/lombok.jar && \
    echo -javaagent:lombok.jar >> eclipse/eclipse.ini && \
    echo -Xbootclasspath/a:lombok.jar >> eclipse/eclipse.ini

# INSTALL ECLIM 
RUN wget -nv http://sourceforge.net/projects/eclim/files/eclim/2.5.0/eclim_2.5.0.jar && \
    java -Dvim.files=${WORK_HOME}/.vim  -Declipse.home=${WORK_HOME}/eclipse -jar eclim_2.5.0.jar install &&\
    rm eclim_2.5.0.jar

# PREPARE FILES
USER root
COPY .vimrc ${WORK_HOME}/.vimrc
COPY .vimrc_tab ${WORK_HOME}/.vimrc_tab
RUN chown dev:dev ${WORK_HOME}/.vimrc ${WORK_HOME}/.vimrc_tab
COPY entrypoint.sh ${WORK_HOME}/entrypoint.sh
RUN chmod 755 ${WORK_HOME}/entrypoint.sh

# INSTALL OHTER PACKAGE
RUN apt-get install -y nginx 

# NGINX SETTING
COPY util.sh ${WORK_HOME}/util.sh
RUN chmod 755 ${WORK_HOME}/util.sh && \
    echo "source ${WORK_HOME}/util.sh" >> ${WORK_HOME}/.bashrc && \
    rm /etc/nginx/sites-enabled/default

# SWITCH USER
USER dev

# SETTING VIM
RUN echo "export TERM=xterm-256color" >> ${WORK_HOME}/.bashrc && \
    echo "alias view='vim -R'" >> ${WORK_HOME}/.bashrc && \
    echo "alias vi='vim'" >> ${WORK_HOME}/.bashrc
RUN mkdir -p ${WORK_HOME}/.vim/bundle && \
    git clone https://github.com/Shougo/neobundle.vim ${WORK_HOME}/.vim/bundle/neobundle.vim && \
    cd ${WORK_HOME}/.vim/bundle/neobundle.vim/bin && ./neoinstall

CMD ["/home/dev/entrypoint.sh"]
