#!/usr/bin/env perl

use strict;
use warnings;
use File::Basename;
use DBI;
use JSON;

our $ConnectionString = "dbi:ODBC:Driver={SQL Server};Server=localhost\\SQLEXPRESS;Database=OrderService;Trusted_Connection=True;TrustServerCertificate=True";

sub start {
    print "*************************************************************************************************\n";
    print "**                                                                                             **\n";
    print "**                                 BULK INSERTION OS - 2024                                    **\n";
    print "**                                        by julio murta                                       **\n";
    print "**                                                                                             **\n";
    print "*************************************************************************************************\n";
}

sub save_line {
    my $dbh = shift;
    my $line = shift;
    my @infos = split(/\|/, $line);    
    my $line_type = $infos[0];
    my $id = $infos[1];

    if ($line_type == 1) {
        my $name = $infos[2];
        my $document = $infos[3];
        my $email = $infos[4];

        my $sql = "INSERT INTO dbo.Customers (Id, Name, DocumentNumber, Email) VALUES (?, ?, ?, ?)";
        my $sth = $dbh->prepare($sql);
        $sth->execute($id, $name, $document, $email) or die $DBI::errstr;
        $sth->finish;
    } elsif ($line_type == 2) {
        my $name = $infos[2];
        my $document = $infos[3];
        my $birth_date = $infos[4];
        my $email = $infos[5];
        chomp(my $gender = $infos[6]);

        my $sql = "INSERT INTO dbo.Employees (Id, Name, DocumentNumber, BirthDate, Email, Gender) VALUES (?, ?, ?, ?, ?, ?)";
        my $sth = $dbh->prepare($sql);
        $sth->execute($id, $name, $document, $birth_date, $email, $gender) or die $DBI::errstr;
        $sth->finish
    } elsif ($line_type == 3) {
        my $date = $infos[2];
        my $start = $infos[3];
        my $finish = $infos[4];
        my $description = $infos[5];
        my $employee_id = $infos[6];
        my $customer_id = $infos[7];

        my $sql = "INSERT INTO dbo.Orders(Id, Date, Start, Finish, Description, EmployeeId, CustomerId) VALUES (?,?,?,?,?,?,?)";
        my $sth = $dbh->prepare($sql);
        $sth->execute($id, $date, $start, $finish, $description, $employee_id, $customer_id) or die $DBI::errstr;
        $sth->finish;
    } else {
        print "\n$line_type isn't a valid type";
    }
}

sub process_positional_file {
    print "\nStart processing .txt file...";
    my $path = shift;
    my $filename = shift;
    my $full_path = $path . $filename . ".txt";
    
    my $dbh = DBI->connect($ConnectionString) or die "Can't connect to database: $DBI::errstr";
    open(FH, '<', $full_path) or die $!;

    while(<FH>){
        save_line($dbh, $_);
    }

    close(FH);
    $dbh->disconnect;
    print "\nFile processed succesfully!";
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

