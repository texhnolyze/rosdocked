FROM ros:rolling

# Arguments
ARG user
ARG uid
ARG home
ARG workspace
ARG shell

# Basic Utilities
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update \
  && apt-get install -y apt-utils \
  && apt-get install -y \
    build-essential \
    gdb \
    gnupg2 \
    htop \
    iproute2 \
    iputils-ping \
    ipython3 \
    less \
    libncurses5-dev \
    locales \
    python3-numpy \
    python3-opencv \
    python3-pip \
    python3-yaml \
    ranger \
    screen \
    ssh \
    sudo \
    synaptic \
    tig \
    tmux \
    tree \
    uvcdynctrl \
    vim \
    vlc \
    wget \
    x11-apps \
    zsh

# Setup locale
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen \
  && locale-gen \
  && update-locale LANG=en_US.UTF-8 \
  && ln -s /usr/bin/python3 /usr/bin/python

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Additional custom dependencies
RUN apt-get install -y \
  libfmt-dev \
  librange-v3-dev \
  liburdfdom-dev \
  python3-colcon-common-extensions \
  ros-rolling-backward-ros \
  ros-rolling-desktop \
  ros-rolling-control-msgs \
  ros-rolling-control-toolbox \
  ros-rolling-controller-manager \
  ros-rolling-effort-controllers \
  ros-rolling-joint-state-broadcaster \
  ros-rolling-joint-trajectory-controller \
  ros-rolling-joy \
  ros-rolling-moveit-ros \
  ros-rolling-moveit-ros-move-group \
  ros-rolling-moveit-ros-planning \
  ros-rolling-moveit-ros-planning-interface \
  ros-rolling-moveit-ros-robot-interaction \
  ros-rolling-moveit-simple-controller-manager \
  ros-rolling-position-controllers \
  ros-rolling-robot-localization \
  ros-rolling-velocity-controllers \
  ros-rolling-xacro

# Mount the user's home directory
VOLUME "${home}"

# Clone user into docker image and set up X11 sharing
RUN \
  echo "${user}:x:${uid}:${uid}:${user},,,:${home}:${shell}" >> /etc/passwd \
  && echo "${user}:*::0:99999:0:::" >> /etc/shadow \
  && echo "${user}:x:${uid}:" >> /etc/group \
  && echo "${user} ALL=(ALL) NOPASSWD: ALL" >> "/etc/sudoers"

# Switch to user
USER "${user}"
# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1
# Switch to the workspace
WORKDIR ${workspace}
