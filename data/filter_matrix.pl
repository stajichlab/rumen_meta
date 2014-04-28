#!/usr/bin/perl -w
use strict;

my $in = shift || "expression.matrix";
open(my $fh => $in) || die $!;
my $header = <$fh>;
print $header;
while(<$fh>) {
    my ($locus,@row) = split;
    my $len = @row;
    my $zeroes = 0;
    for my $n ( @row ) {
	$zeroes++ if( $n == 0 );
    }
    if( $zeroes >= ($len - 2)) {
	next;
    }
    print;
}
