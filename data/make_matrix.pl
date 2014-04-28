#!/usr/bin/perl -w
use strict;

my $dir = shift || ".";
my $out = shift || "expression.matrix";
opendir(DIR, $dir) || die $!;
my %matrix;
my @libs;
for my $file ( readdir(DIR) ) {
    next unless $file =~ /(\S+)\.eXpress\.tsv\.gz$/;
    my $library = $1;
    push @libs, $library;
    open( my $fh => "zcat $file |") || die $!;
    my $header = <$fh>;
    chomp($header);
    my $i =0;
    my %hdr = map { $_ => $i++ } split(/\t/,$header);
    # sanity check on the columns
    for my $col ( qw(target_id fpkm) ) {
	if ( ! exists $hdr{$col} ) {
	    die("expect $col to be one of the columns");
	}
    }

    while(<$fh>) {
	chomp;
	my @row = split(/\t/,$_);
	my $gene = $row [ $hdr{'target_id'} ];
	my $fpkm = $row [ $hdr{'fpkm'} ];
	$matrix{$gene}->{$library} = $fpkm;
    }
}
open(my $fh => ">$out") || die $!;

print $fh join("\t", qw(target_id), @libs), "\n";
for my $locus ( sort keys %matrix ) {
    print $fh join("\t", $locus, map { sprintf("%.4f",$matrix{$locus}->{$_} || 0) } @libs), "\n";
}

