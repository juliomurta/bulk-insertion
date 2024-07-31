#!/usr/bin/env perl

use strict;
use warnings;
use File::Basename;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
use JSON;

our $Domain   = "http://localhost:64569/api";
our $UserName = "admin";
our $Password = "Admin\@2020";

sub start {
    print "*************************************************************************************************\n";
    print "**                                                                                             **\n";
    print "**                                 BULK INSERTION OS - 2024                                    **\n";
    print "**                                        by julio murta                                       **\n";
    print "**                                                                                             **\n";
    print "*************************************************************************************************\n";
}

sub api_login {
    my $url = $Domain . "/account/login";
    my $encoded = to_json({
        name     => $UserName,
        password => $Password
    });

    my $user_agent = LWP::UserAgent->new();
    my $request = HTTP::Request->new('POST', $url);
    $request->header('Content-Type'   => 'application/json');
    $request->content($encoded);

    my $response = $user_agent->request($request);
    if ($response->is_success) {
        print "\nSuccessfully Authenticated." . $response->decoded_content;            
    } else {
        print STDERR $response->status_line, "\n";
    }

    return $response->is_success;
}

sub api_logout {
    my $url = $Domain . "/account/logout";

    my $user_agent = LWP::UserAgent->new();
    my $request = HTTP::Request->new('POST', $url);    
    $request->header('Content-Length'   => '0');

    my $response = $user_agent->request($request);

    if ($response->is_success) {
        print "\nLogout Successful." . $response->decoded_content;
    } else {
        print STDERR $response->status_line, "\n";
    }

    return $response->is_success;
}

sub send_customer_request {
    my $url = $Domain . "/customers";
    my $encoded = to_json({       
	    name => "rock lee",
	    documentNumber => "123123123",
        email => "teste\@teste.com"
    });

    my $user_agent = LWP::UserAgent->new();
    my $request = HTTP::Request->new('POST', $url);    
    $request->header('Content-Type'   => 'application/json');
    $request->content($encoded);

    my $response = $user_agent->request($request);
    if ($response->is_success) {
        print "\nCustomer Saved Successfully." . $response->decoded_content;
    } else {        
        print STDERR $response->status_line, "\n";
    }
}

sub send_employee_request {

}

sub send_order_request {

}

sub save_line {
    my @infos = split('|', shift);    
    my $line_type = $infos[0];

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


#start;
#process_records(@ARGV[0]);

#api_login;
 
    
if(api_login){
   send_customer_request;
   # api_logout;
}


