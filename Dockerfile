FROM osrf/ros:melodic-desktop-full

# Arguments
ARG user
ARG uid
ARG gid
ARG home
ARG workspace
ARG shell

RUN apt-get update && \
	DEBIANG_FRONTEND='noninteractive' apt-get -y upgrade

# Basic Utilitie
RUN DEBIAN_FRONTEND='noninteractive'  apt-get -y update && apt-get -y upgrade && apt-get install -y zsh screen tmux tree sudo ssh synaptic htop vim tig ipython ipython3 less ranger apt-utils software-properties-common apt-transport-https gnupg gnupg-agent ca-certificates curl x11-apps python-pip python3-pip build-essential libc++abi-dev clang aptitude rsync

# Visual studio code
RUN curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - && \
	sudo echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list && \
	sudo apt-get update && \
	sudo apt-get -y install code

# ROS dependencies
RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y ros-melodic-control-msgs ros-melodic-controller-manager ros-melodic-effort-controllers ros-melodic-gazebo-dev ros-melodic-gazebo-msgs ros-melodic-gazebo-plugins ros-melodic-gazebo-ros ros-melodic-gazebo-ros-control ros-melodic-imu-complementary-filter ros-melodic-imu-sensor-controller ros-melodic-joint-state-controller ros-melodic-joint-trajectory-controller ros-melodic-joy ros-melodic-moveit-ros-control-interface ros-melodic-moveit-ros-move-group ros-melodic-moveit-ros-planning ros-melodic-moveit-ros-planning-interface ros-melodic-moveit-ros-robot-interaction ros-melodic-moveit-simple-controller-manager ros-melodic-navigation ros-melodic-pointcloud-to-laserscan ros-melodic-position-controllers ros-melodic-robot-controllers ros-melodic-robot-localization ros-melodic-ros-control ros-melodic-ros-controllers ros-melodic-rosbridge-server ros-melodic-rosdoc-lite ros-melodic-rqt-controller-manager ros-melodic-velocity-controllers ros-melodic-yocs-velocity-smoother

RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y libncurses5-dev uvcdynctrl python3-yaml python-yaml python-catkin-pkg python-opencv python-numpy python-catkin-lint software-properties-common python-catkin-tools

# cleanup
RUN apt-get autoremove -y; apt-get clean -y

# Python modules
RUN pip install tensorflow

# Mount the user's home directory
#VOLUME "${home}"

# Clone user into docker image and set up X11 sharing 
RUN cp /etc/passwd /etc/passwd- && \
	cat /etc/passwd- | sed "s#root:.*#${user}:x:0:0:${user},,,:${home}:${shell}#" > /etc/passwd
RUN cp /etc/group /etc/group- && \
	cat /etc/group- | sed "s#root:.*#${user}:x:0:#" > /etc/group
#RUN echo "${user}:x:${uid}:${gid}::${home}:${shell}" >> /etc/passwd && \
#	echo "${user}:x:${gid}:" >> /etc/group
RUN echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" && \
 	chmod 0440 "/etc/sudoers.d/${user}"

# Switch to user
USER "${user}"
# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1
ENV CATKIN_TOPLEVEL_WS="${workspace}/devel"
# Switch to the workspace
WORKDIR ${workspace}

