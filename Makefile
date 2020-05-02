CXX = g++

CXXFLAGS += -std=c++11

objects =  \
	main.o \
	Timer.o \
	UdpSocket.o \
	Socket.o \
	OSC/OSCData.o \
	OSC/OSCMatch.o \
	OSC/OSCMessage.o \
	OSC/OSCTiming.o \
	OSC/SimpleWriter.o

default :
	@echo "platform not specified"

organelle : $(objects) hw_interfaces/SerialMCU.o
	g++ -o fw_dir/mother $(objects) hw_interfaces/SerialMCU.o

organelle_m : CXXFLAGS += -DCM3GPIO_HW -DMICSEL_SWITCH -DPWR_SWITCH -DOLED_30FPS -DBATTERY_METER -DFIX_ABL_LINK
organelle_m : $(objects) hw_interfaces/CM3GPIO.o
	g++ -l wiringPi -o fw_dir/mother $(objects) hw_interfaces/CM3GPIO.o

.PHONY : clean

clean :
	rm main $(objects)

IMAGE_BUILD_VERSION = $(shell cat fw_dir/version)
IMAGE_BUILD_TAG = $(shell cat fw_dir/buildtag)
IMAGE_VERSION = $(IMAGE_BUILD_VERSION)$(IMAGE_BUILD_TAG)
IMAGE_DIR = UpdateOS-$(IMAGE_VERSION)

# Generate with g++ -MM *.c* OSC/*.* 
main.o: main.cpp OSC/OSCMessage.h OSC/OSCData.h OSC/OSCTiming.h \
 OSC/SimpleWriter.h OSC/SimpleWriter.h UdpSocket.h Socket.h Timer.h
Socket.o: Socket.cpp Socket.h
Timer.o: Timer.cpp Timer.h
UdpSocket.o: UdpSocket.cpp UdpSocket.h Socket.h
OSCData.o: OSC/OSCData.cpp OSC/OSCData.h OSC/OSCTiming.h
OSCData.o: OSC/OSCData.h OSC/OSCTiming.h
OSCMatch.o: OSC/OSCMatch.c OSC/OSCMatch.h
OSCMatch.o: OSC/OSCMatch.h
OSCMessage.o: OSC/OSCMessage.cpp OSC/OSCMessage.h OSC/OSCData.h \
 OSC/OSCTiming.h OSC/SimpleWriter.h OSC/OSCMatch.h
OSCMessage.o: OSC/OSCMessage.h OSC/OSCData.h OSC/OSCTiming.h \
 OSC/SimpleWriter.h
OSCTiming.o: OSC/OSCTiming.cpp OSC/OSCTiming.h
OSCTiming.o: OSC/OSCTiming.h
SimpleWriter.o: OSC/SimpleWriter.cpp OSC/SimpleWriter.h
SimpleWriter.o: OSC/SimpleWriter.h
