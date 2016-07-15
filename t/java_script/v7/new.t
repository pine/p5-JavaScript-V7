use strict;
use warnings FATAL => 'all';
use utf8;

use Test::More;

use JavaScript::V7;

subtest basic => sub {
    my $v7 = JavaScript::V7->new;
    isa_ok $v7, 'JavaScript::V7';
};

done_testing;

