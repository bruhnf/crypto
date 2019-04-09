#!/usr/bin/perl

use strict;
use warnings;
use Time::Local;
use MIME::Lite;
use Cwd qw();
use DBI;
use Text::CSV_XS;
use POSIX qw(strftime);
use Crypt::Rijndael;
use IO::Prompter;

my $password;

#The secret pass phrase
my $sAppSecret = 'A 32 character string goes here as the encryption key';

#password file name
my $passwd_file_name = "path_to_your_password_file_to_decrypt";

# Setup the encryption system
my $crypto = Crypt::Rijndael->new( $app_secret, Crypt::Rijndael::MODE_CBC() );

#File Handler
my $passwd_file;

#Open the file in reading mode
open ( $passwd_file, '<', $passwd_file_name);

#Loading the password en decrypt it
$password = $crypto->decrypt( <$passwd_file> );

#Close the file
close $passwd_file;

$password =~ s/^\s+|\s+$//g;

#Return the password ( Here the password is not protected )
print "Password is: " . $password ."END\n";


