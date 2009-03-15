#!/usr/bin/env perl -w
use strict;
use Test::More tests => 2;

package TraditionalAlias;

sub foo {
    "the return value of foo";
}

*bar = \&foo;

package FancyAlias;

use Sub::Alias;

sub foo {
    "the return value of foo";
}

alias bar => "foo";


package main;

is TraditionalAlias::bar(), TraditionalAlias::foo();
is FancyAlias::bar(), FancyAlias::foo();
