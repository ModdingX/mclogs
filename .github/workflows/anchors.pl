#!/usr/bin/perl

use warnings;
use strict;
use utf8;

sub main() {
    my %names;

    foreach (glob('*')) {
        if (/(.+)\.md/) {
            $names{$_} = $1 eq '_mc-logs' ? 'en' : $1
        }
    }
    
    my $line = "# [${\(regional_indicator('gb'))}](#en)";

    foreach my $item (sort keys %names) {
        if ($names{$item} ne 'en') {
            $line .= " [${\(regional_indicator($names{$item}))}](#${\($names{$item})})";
        }
    }
    
    foreach my $item (keys %names) {
        prepend($item, "$line\n\n<a name=\"${\($names{$item})}\"></a>")
    }
}

sub regional_indicator {
    $_[0] =~ /(.)(.)/;
    return chr(127365 + ord(lc($1))) . chr(127365 + ord(lc($2)))
}

sub prepend {
    my $file = $_[0];
    my $content = $_[1];
    open(my $IN, "<:encoding(utf-8)", $file);
    my @content;
    push @content, $_ while (<$IN>);
    close($IN);
    open(my $OUT, ">:encoding(utf-8)", $file);
    print $OUT "$content\n";
    print $OUT $_ foreach (@content);
    close($OUT);
}

main()
