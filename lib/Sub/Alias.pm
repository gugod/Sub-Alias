package Sub::Alias;
use warnings;
use strict;
use 5.008;

use B::Hooks::Parser;

use Sub::Install;
use Sub::Exporter -setup => {
    exports => [ 'alias' ],
    groups => { default => [ 'alias' ] }
};
use Devel::Declare::MethodInstaller::Simple;


our $VERSION = '0.01';

sub alias {}
use B::Hooks::OP::Check::EntersubForCV
    \&alias => sub {
        B::Hooks::Parser::setup();
        my $line = B::Hooks::Parser::get_linestr;
        my $offset = B::Hooks::Parser::get_linestr_offset;

        my $word = qr/(?: \w+ | "\w+" | '\w+' )/x;

        # print STDERR "$line, $offset\n";
        my ($new_name, $old_name) = $line =~ m/alias\s+($word)\s*(?:=>|,)\s*($word)/;
        $new_name =~ s/^["']//; $new_name =~ s/["']$//;
        $old_name =~ s/^["']//; $old_name =~ s/["']$//;

        # print STDERR "GET $new_name\n";

        substr($line, $offset, 0) = " ;{ sub $new_name; *$new_name = \*$old_name };";
        # print "=> $line\n";
        B::Hooks::Parser::set_linestr($line);
    };

1;

__END__

=head1 NAME

Sub::Alias - [One line description of module's purpose here]


=head1 VERSION

This document describes Sub::Alias version 0.0.1


=head1 SYNOPSIS

    use Sub::Alias;


=head1 DESCRIPTION


=head1 INTERFACE 


=over

=item new()

=back

=head1 DIAGNOSTICS

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

Sub::Alias requires no configuration files or environment variables.

=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-sub-alias@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Kang-min Liu  C<< <gugod@gugod.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, Kang-min Liu C<< <gugod@gugod.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
