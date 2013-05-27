package File::Slurp::Tiny;
use strict;
use warnings;

use Carp 'croak';
use Exporter 5.57 'import';
use File::Spec::Functions 'catfile';
our @EXPORT_OK = qw/read_file write_file read_dir/;

my $default_layer = $^O eq 'MSWin32' ? ':crlf' : ':unix';

sub read_file {
	my ($filename, %options) = @_;
	my $layer = $options{binmode} || $default_layer;
	my $buf;
	my $buf_ref = defined $options{buf_ref} ? $options{buf_ref} : \$buf;

	open my $fh, "<$layer", $filename or croak "Couldn't open $filename: $!";
	read $fh, ${$buf_ref}, -s $fh or croak "Couldn't read $filename: $!";
	close $fh;
	return if not defined wantarray or $options{buf_ref};
	return $options{scalar_ref} ? $buf_ref : $buf;
}

sub read_lines {
	my ($filename, %options) = @_;
	my $layer = $options{binmode} || $default_layer;
	my @buf;
	my $buf_ref = defined $options{array_ref} ? $options{array_ref} : \@buf;
	
	open my $fh, "<$layer", $filename or croak "Couldn't open $filename: $!";
	@{$buf_ref} = <$fh>;
	chomp @{$buf_ref} if $options{chomp};
	close $fh;
	return if not defined wantarray or $options{array_ref};
	return @buf;
}

sub write_file {
	my ($filename, undef, %options) = @_;
	my $layer = $options{binmode} || $default_layer;
	my $buf_ref = defined $options{buf_ref} ? $options{buf_ref} : \$_[1];

	open my $fh, ">$layer", $filename or croak "Couldn't open $filename: $!";
	$fh->autoflush(1);
	print $fh ${$buf_ref} or croak "Couldn't write to $filename: $!";
	close $fh or croak "Couldn't close $filename: $!";
	return;
}

sub read_dir {
	my ($dirname, %options) = @_;
	opendir my ($dir), $dirname or croak "Could not open $dirname: $!";
	my @ret = grep { not m/ ^ \.\.? $ /x } readdir $dir;
	@ret = map { catfile($dir, $_) } @ret if $options{prefix};
	closedir $dir;
	return @ret;
}

1;

# ABSTRACT: A simple, sane and efficient file slurper

=func read_file($filename, %options)

=func read_lines($filename, %options)

=func write_file($filename, $content, %options)

=func read_dir($dirname, %options)
