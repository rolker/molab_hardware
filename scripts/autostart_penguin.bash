#!/bin/bash

# called from cron @reboot using field's user crontab
# inspired by: https://answers.ros.org/question/140426/issues-launching-ros-on-startup/

DAY=$(date "+%Y-%m-%d")
NOW=$(date "+%Y-%m-%dT%H.%M.%S.%N")
LOGDIR="/home/field/project11/log/${DAY}"
mkdir -p "$LOGDIR"
LOG_FILE="${LOGDIR}/autostart_${NOW}.txt"

{

echo ""
echo "#############################################"
echo "Running autostart_penguin.bash"
/bin/date
echo "#############################################" 
echo ""
echo "Logs:"

source /opt/ros/noetic/setup.bash
source /home/field/project11/catkin_ws/devel/setup.bash

set -v

while ! ping -c 1 -W 1 penguinc; do
    echo "Waiting for ping to penguin..."
    sleep 1
done

export ROS_WORKSPACE=/home/field/project11/catkin_ws
export ROS_IP=192.168.100.199
export ROS_MASTER_URI=http://192.168.100.198:11311

echo "running tmux..."

/usr/bin/tmux new -d -s project11 rosrun rosmon rosmon --name=rosmon_molab_penguin molab_hardware ais.launch

} >> "${LOG_FILE}" 2>&1
