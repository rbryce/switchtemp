#!/usr/bin/perl
##########################################################################
#Mozilla Public License, version 2.0
#Author - dmoore@mozilla.com (4/10/2014)
#
use strict;
use warnings;

use Net::SNMP;

my @switches = (
    'switch01',
    'switch02',
    'switch03',
    'switch04',
    'switch05',
    'switch06',
    'switch07',
    'switch08',
    'switch09',
);

my $domain = "domain.net";

my $community = "communitystring";

my $sensorOid = "1.3.6.1.2.1.47.1.1.1.1.2";
my $tempOid = "1.3.6.1.4.1.9.9.91.1.1.1.1.4";

##########################################################################

foreach my $switch ( @switches ) {
    print "$switch:\n";

    my $hostname = $switch . "." . $domain;

    # Build SNMP session for this switch
    my($sess, $err) = Net::SNMP->session(
        -hostname  => $hostname,
        -version   => "2c",
        -community => $community
    );

    # Poll switch for list of sensors
    my $sensorResult = $sess->get_table(
        -baseoid => $sensorOid
    );

    # Check for SNMP request failure
    if( ! defined $sensorResult ) {
        print "ERROR: " . $sess->error() . "\n";
        $sess->close();
        next;
    }

    my %sensors;

    # Find inlet temperature sensors
    foreach my $key ( keys %{ $sensorResult } ) {
        next unless $sensorResult->{$key} =~ /Temp Inlet Sensor/;

        # Extract the index for this sensor
        my @fields = split(/\./, $key);
        my $index = pop(@fields);

        # Poll the temperature for a specific sensor
        my $tempKey = $tempOid . "." . $index;
        my $tempResult = $sess->get_request(
            -varbindlist => [ $tempKey ],
        );

        # Check for SNMP request failure
        if( ! defined $tempResult ) {
            print "ERROR: " . $sess->error() . "\n";
            $sess->close();
            next;
        }

        next unless $tempResult->{$tempKey} =~ /^\d+$/;
        $sensors{$index} = $tempResult->{$tempKey};
    }

    # Print sorted sensor values
    my $i = 0;
    foreach my $key ( sort {$a <=> $b} keys %sensors ) {
        my $temp = $sensors{$key};
        $temp = sprintf("%d", $temp * 9 / 5 + 32);
        print "\tInlet " . $i . ": " . $temp . " F\n";
        $i++;
    }
    print "\n";

    $sess->close();
