#!/usr/bin/env python3

import rospy
import tf.transformations
from geometry_msgs.msg import QuaternionStamped
import math

rospy.init_node("heading_sender")

pub = rospy.Publisher("orientation", QuaternionStamped, queue_size=5)

def callback(event):

  q = QuaternionStamped()
  q.header.stamp = rospy.Time.now()
  q.header.frame_id = rospy.get_param("frame_id", "")

  heading = rospy.get_param("heading", 0.0)
  quat =  tf.transformations.quaternion_from_euler(math.radians(heading), 0, 0, 'rzyx')
  q.quaternion.x = quat[0]
  q.quaternion.y = quat[1]
  q.quaternion.z = quat[2]
  q.quaternion.w = quat[3]
  pub.publish(q)

timer = rospy.Timer( rospy.Duration(1.0), callback)

rospy.spin()
