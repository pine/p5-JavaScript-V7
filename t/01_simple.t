use strict;
use Test::More;

use JavaScript::V7;

my $v7 = JavaScript::V7->new;
is $v7->exec('1 + 2'), 3;

done_testing;

