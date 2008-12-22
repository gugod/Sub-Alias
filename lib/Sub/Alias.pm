package Sub::Alias;
use warnings;
use strict;
use 5.008;

use B::Hooks::Parser;

use Sub::Exporter -setup => {
    exports => [ 'alias' ],
    groups => { default => [ 'alias' ] }
};
use Sub::Name;

our $VERSION = '0.02';

sub alias { }

sub __inject_alias {
    B::Hooks::Parser::setup();
    my $line = B::Hooks::Parser::get_linestr;
    my $offset = B::Hooks::Parser::get_linestr_offset;

    my $word = qr/(?: \w+ | "\w+" | '\w+' )/x;

    my ($new_name, $old_name) = $line =~ m/alias\s+($word)\s*(?:=>|,)\s*(?:\\&)?($word)?/;
    return unless $new_name && $old_name;

    $new_name =~ s/^["']//; $new_name =~ s/["']$//;
    $old_name =~ s/^["']//; $old_name =~ s/["']$//;
    substr($line, $offset, 0) = " ;{ sub $new_name; *$new_name = \*$old_name };";
    B::Hooks::Parser::set_linestr($line);
}

use B::Hooks::OP::Check::EntersubForCV \&alias => \&__inject_alias;

1;

__END__

=head1 NAME

Sub::Alias - Simple subroutine alias.

=head1 VERSION

This document describes Sub::Alias version 0.01

=head1 SYNOPSIS

    use Sub::Alias;

    sub name { "David" }
    alias get_name => 'name';

    print get_name; # "David"

=head1 DESCRIPTION

This module does a compile-time code injection to let you define
subroute aliases with their names, but not code refs.

The not-so-scarily-described way to alias a sub looks like this:

    sub name { "..." }
    { sub get_name; *get_name = \&name; }

As you can see, it's a bit of trouble to type the whole line without
without making your finger jammed unless you're using some smart text
editors.

=head1 INTERFACE

=over

=item alias $new_name => $old_name

This function is exported by default.

B<NOTICE: It needs to be called with all arguments on the same line.>

The alias subroutine is referenced by its names, not reference. So
this works:

    alias get_name => 'name';

But this doen't:

    alias get_name => \&name;

Could be working out to make this working like it should. Also notice
that doing this will actually call the C<name> function.

    alias get_name => name;

You'll just need to pass function names as strings.

=back

=head1 DEPENDENCIES

L<B::Hooks::Parser>, L<Sub::Exporter>

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

Copyright (c) 2008, Kang-min Liu C<< <gugod@gugod.org> >>.

This is free software, licensed under:

    The MIT (X11) License


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
