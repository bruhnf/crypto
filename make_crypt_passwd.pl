#!/usr/bin/perl

use strict;
use warnings;
use Time::Local;
use MIME::Lite;
use Cwd qw();
use DBI;
use Text::CSV_XS;
use POSIX qw(strftime);
use Data::Dump qw(dump);
use Crypt::Rijndael;
use IO::Prompter;


#System Vars
my $sWorkingDir = Cwd::cwd();
$sWorkingDir = $sWorkingDir . "\/";

#The secret pass phrase

my $sAppSecret = 'A 32 character string goes here as the encryption key';

#password file name
my $passwd_file_name = "path_to_where_you_want_to_write_the_pw_file";

# Setup the encryption system
my $crypto = Crypt::Rijndael->new( $app_secret, Crypt::Rijndael::MODE_CBC() );

#File Handler
my $passwd_file;

#If we cannot open the password file we initiate a new one
unless ( open ( $passwd_file, '<', $passwd_file_name) ) {

        #Create a new file in write mode
        open ( $passwd_file, '>', $passwd_file_name);

        # Ask the user to enter the password the first time
        my $password = prompt "password: ", -echo => ''; # from IO::Prompter

        #Password must be multiple of 16 (we deliberately chose 16)
        my $pass_length = 32;

        #If password is too short we complete with blank
        $password = $password." "x ($pass_length - length ( $password ) ) if ( length ( $password ) < $pass_length );

        #If password is to long we cut it
        $password = substr ( $password, 0, $pass_length ) if ( length ( $password ) > $pass_length );

        #Encryption of the password
        my $enc_password = $crypto->encrypt($password);

        #we save the password in a file
        print $passwd_file $enc_password;

        #we close the file ( Writing mode )
        close $passwd_file;

        #Reopen the file in reading mode
        open ( $passwd_file, '<', $passwd_file_name)
}

#Loading the password en decrypt it
my $password = $crypto->decrypt( <$passwd_file> );

#Close the file
close $passwd_file;

#$password =~ s/^\s+|\s+$//g;

#Return the password ( Here the password is not protected )
print "Password is: " . $password ."END\n";
