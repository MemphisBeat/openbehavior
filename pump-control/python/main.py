#!/usr/bin/python

# Copyright 2016 University of Tennessee Health Sciences Center
# Author: Matthew Longley <mlongle1@uthsc.edu>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or(at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# BEGIN IMPORT PRELUDE
import sys
import getopt
import time
from threading import Timer
import RPi.GPIO as gpio
import Adafruit_MPR121.MPR121 as MPR121
import pumpcontrol
import touchsensor
# END IMPORT PRELUDE

# BEGIN CONSTANT DEFINITIONS
TIR = int(36)
SW1 = int(37)
SW2 = int(38)
# END CONSTANT DEFINITIONS

# BEGIN GLOBAL VARIABLES
touchcount = 0
touchcounter = 0
fixedratio = 10
timeout = 20
pumptimedout = False
# END GLOBAL VARIABLES

def printUsage():
	print(sys.argv[0] + ' -t <timeout> -f <fixed ratio>')
	
def resetPumpTimeout():
	global pumptimedout
	pumptimedout = False

# Parse command line arguments
try:
	opts, args = getopt.getopt(sys.argv[1:], "hf:t:")
except getopt.GetoptError:
	printUsage()
	sys.exit(2)
for opt, arg in opts:
	if opt == '-f':
		fixedratio = int(arg)
	elif opt == '-t':
		timeout = int(arg)
	elif opt == '-h':
		printUsage()
		sys.exit()

# Initialize GPIO
gpio.setwarnings(False)
gpio.setmode(gpio.BOARD)

# Setup switch pins
gpio.setup(SW1, gpio.IN, pull_up_down=gpio.PUD_DOWN)
gpio.setup(SW2, gpio.IN, pull_up_down=gpio.PUD_DOWN)
gpio.setup(TIR, gpio.IN, pull_up_down=gpio.PUD_DOWN)

# Initialize pump
pump = pumpcontrol.Pump(gpio)

# Initialize touch sensor
tsensor = touchsensor.TouchSensor()

# Create timer
pumpTimer = Timer(timeout, resetPumpTimeout)

while True:
	if gpio.input(SW1):
		pump.move(1)
	elif gpio.input(SW2):
		pump.move(-1)
	elif not gpio.input(TIR):
		i = tsensor.readPinTouched()
		if i == 1:
			touchcount += 1
			if not pumptimedout:
				touchcounter += 1
				if touchcounter == fixedratio:
					touchcounter = 0
					pumptimedout = True
					pumpTimer.start()
					pump.move(-1)