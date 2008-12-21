use strict;
use warnings;
use inc::Module::Install;

all_from 'lib/Sub/Alias.pm';

build_requires  'Test::More'        => '0.42';
requires 'B::Hooks::Parser';
requires 'Sub::Exporter';

WriteAll;


