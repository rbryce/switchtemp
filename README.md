switchtemp
==========

We know the SNMP oids that supply the inlet temprature of the network switches.  SNMP poll the list of switches and return report of the inlet tempratures. 

Example Output - 

switch1.d501-1:
	Inlet 0: 77 F
	Inlet 1: 77 F

switch1.d701-2:
	Inlet 0: 75 F
	Inlet 1: 73 F
	Inlet 2: 75 F
	Inlet 3: 75 F
	Inlet 4: 75 F

switch2.d801-2:
	Inlet 0: 73 F
	Inlet 1: 75 F
	Inlet 2: 73 F
	Inlet 3: 71 F
	

RoadMap:
-Add graphite functionality
-Add Nagios compatible exit codes
-Command Line Opts
