#!/usr/bin/perl

use DBI;
use strict;
use warnings;

# Declare varaibles
my $DBNAME   =  "testcric";
my $DBTABLE  =  "foo";
my $DBUSER   =  "root";
my $DBPASS   =  "root";
my $DBHOST   =  "localhost";
my $csvfile  =  "C:/Temp/text1.csv";

# Connect to database at hand, or die
my $dbh = DBI->connect("DBI:mysql:$DBNAME:$DBHOST", $DBUSER, $DBPASS)
    or die "DB connect failed: $DBI::errstr";

my $update_h = $dbh->prepare(qq{INSERT INTO $DBTABLE (serial, name, runs) VALUES (?, ?, ?)});

open my $ih, $csvfile or die "Can't open file, $csvfile: $!";

while (<$ih>) {
    chomp;
    
    my @rows = split ','; # Is a semicolon your delimiter, or is it a comma?

    my $serial  =  $rows[0];
    my $name   =  $rows[1];
    my $runs   =  $rows[2];

    $update_h->execute($serial, $name, $runs) or die $dbh->errstr;
}

my $res = $dbh->selectall_arrayref( q( SELECT serial, name, runs FROM foo));

foreach( @$res ) {
    print "\n$_->[0], $_->[1] $_->[2]\n\n";
}
