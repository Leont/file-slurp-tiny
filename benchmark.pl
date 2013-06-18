#! /usr/bin/env perl

use strict;
use warnings;
use Benchmark ':hireswallclock', 'cmpthese';
use File::Slurp;
use File::Slurp::Tiny;

my $filename = shift or die "No argument given";
my $count = shift || 100;

print "Slurping into a scalar\n";
cmpthese($count, {
	'Slurp'      => sub { my $content = File::Slurp::read_file($filename) },
	'Slurp-Tiny' => sub { my $content = File::Slurp::Tiny::read_file($filename) },
});

print "\nSlurping into a scalarref\n";
cmpthese($count, {
	'Slurp'      => sub { File::Slurp::read_file($filename, buffer_ref => \my $buffer) },
	'Slurp-Tiny' => sub { File::Slurp::Tiny::read_file($filename, buffer_ref => \my $buffer) },
});

print "\nSlurping into an arrayref\n";
cmpthese($count, {
	'Slurp'      => sub { my $lines = File::Slurp::read_file($filename, { array_ref => 1 }) },
	'Slurp-Tiny' => sub { my $lines = File::Slurp::Tiny::read_lines($filename, array_ref => 1) },
});

print "\nSlurping into an arrayref, chomped\n";
cmpthese($count, {
	'Slurp'       => sub { my $lines = File::Slurp::read_file($filename, array_ref => 1, chomp => 1) },
	'Slurp-Tiny'  => sub { my $lines = File::Slurp::Tiny::read_lines($filename, array_ref => 1, chomp => 1) },
});

print "\nSlurping into an array\n";
cmpthese($count, {
	'Slurp'       => sub { my @lines = File::Slurp::read_file($filename) },
	'Slurp-Tiny'  => sub { my @lines = File::Slurp::Tiny::read_lines($filename) },
});

print "\nSlurping into an array, chomped\n";
cmpthese($count, {
	'Slurp'       => sub { my @lines = File::Slurp::read_file($filename, chomp => 1) },
	'Slurp-Tiny'  => sub { my @lines = File::Slurp::Tiny::read_lines($filename, chomp => 1) },
});

