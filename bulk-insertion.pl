#!/usr/bin/env perl

use strict;
use File::Basename;

sub start {
    print "*************************************************************************************************\n";
    print "**                                                                                             **\n";
    print "**                                 BULK INSERTION OS - 2024                                    **\n";
    print "**                                        by julio murta                                       **\n";
    print "**                                                                                             **\n";
    print "*************************************************************************************************\n";
}

sub save_line {
    my @infos = split('|', shift);    
    my $line_type = @infos[0];

    if ($line_type == 1) {
        print "\nIt's a customer";
    } elsif ($line_type == 2) {
        print "\nIt's a customer";
    } elsif ($line_type == 3) {
        print "\nIt's an order";
    } else {
        print "\n$line_type isn't a valid type";
    }
}

sub process_positional_file {
    print "\nStart processing .txt file...";
    my $path = shift;
    my $filename = shift;
    my $full_path = $path . $filename . ".txt";
    
    open(FH, '<', $full_path) or die $!;

    while(<FH>){
        save_line($_);
    }

    close(FH);
}

sub process_csv_file {
    print "\nStart processing .csv file...";
}

sub process_records {        
    my @valid_extensions = ('.txt', '.csv');
    my ($filename, $path, $ext) = fileparse(shift, @valid_extensions);

    if ($ext eq ".txt") {
        process_positional_file $path, $filename;
    } elsif ($ext eq ".csv") {
        process_csv_file $path, $filename;
    } elsif ($ext eq undef) {
        print "\nFile extension is not valid.";
    } 
}


start;
process_records(@ARGV[0]);
