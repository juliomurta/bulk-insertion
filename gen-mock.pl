#!/usr/bin/env perl

use strict;
use warnings;
use Data::UUID;

our $id_gen = Data::UUID->new;

sub gen_customer {    
    my $index = shift;
    my $id = $id_gen->create_str();

    my $name = "Test_$index";
    my $document = "99999999";
    my $email = "$name\@test.com";

    my $data = "1|$id|$name|$document|$email\n";
    return (id => $id, data => $data);
}

sub gen_employee {
    my $index = shift;
    my $id = $id_gen->create_str();

    my $name = "Test_$index";
    my $document = "99999999";
    my $birth_date = "1994-04-11";
    my $email = "$name\@test.com";
    
    my $data = "2|$id|$name|$document|$birth_date|$email|1\n";
    return (id => $id, data => $data);
}

sub gen_order {
    my $index = shift;    
    my $employee_id = shift;
    my $customer_id = shift;
    my $id = $id_gen->create_str();
    
    my $date = "2024-07-31";
    my $start = "09:00";
    my $finish = "17:00";
    my $description = "Lorem ipsun dolor sit amet";

    my $data = "3|$id|$date|$start|$finish|$description|$employee_id|$customer_id\n";
    return (id => $id, data => $data);
}

my $total_mocks = $ARGV[0];
my $output_file = $ARGV[1];

if ($total_mocks eq undef) {
    $total_mocks = 50_000;
}

if ($output_file eq undef) {
    $output_file = "output_mocks.txt";
}

print "Start generating mocks. Please wait...\n";

open(FH, '>', $output_file) or die $!;

for (my $i = 0; $i < $total_mocks; $i++) {
    my %customer = gen_customer($i);
    my %employee = gen_employee($i);
    my %order = gen_order($i, $employee{'id'}, $customer{'id'});

    print FH $customer{'data'};
    print FH $employee{'data'};
    print FH $order{'data'};
}

close(FH);

print "Mocks were generated succesfully!! Check out the file $output_file";