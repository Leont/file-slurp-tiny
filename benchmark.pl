#! /usr/bin/env perl

use strict;
use warnings;
use Benchmark 'cmpthese';
use File::Slurp;
use File::Slurp::Tiny;

my $filename = shift or die "No argument given";
my $count = shift || 100;

cmpthese($count, {
	'POSIX'      => sub { open my $fh, '<', $filename or die "Couldn't open: $!"; POSIX::read fileno $fh, my $buffer, -s $fh },
	'Slurp'      => sub { File::Slurp::read_file($filename, buffer_ref => \my $buffer) },
	'Slurp-Tiny' => sub { File::Slurp::Tiny::read_file($filename, buffer_ref => \my $buffer) },
});

