use strict;
use warnings FATAL => 'all';
use utf8;

use Test::More;
use Test::Exception;

use JavaScript::V7;

subtest basic => sub {
    my $v7 = JavaScript::V7->new;
    is $v7->exec(q{1 + 2}), 3;
    is $v7->exec(q{'foo' + 'bar'}), 'foobar';
    is $v7->exec(q{'foobar' + 2000}), 'foobar2000';
};

subtest error => sub {
    my $v7 = JavaScript::V7->new;
    throws_ok(
        sub { $v7->exec(q{foo}) },
        qr/Exec error \[v7_exec\]: \"\[foo\] is not defined"/
    );
    throws_ok(
        sub { $v7->exec(q{+^}) },
        qr/Exec error \[v7_exec\]: \"Syntax error at line 1 col 1:\\n\+\^\\n\^\"/
    );
    throws_ok(
        sub { $v7->exec(q{throw 0}) },
        qr/Exec error \[v7_exec\]: 0/
    );
};

subtest type => sub {
    my $v7 = JavaScript::V7->new;
    is $v7->exec(q{null}), undef;
    is $v7->exec(q{undefined}), undef;
    is $v7->exec(q{0}), 0;
    is $v7->exec(q{1}), 1;
    is $v7->exec(q{-1}), -1;
    is $v7->exec(q{2}), 2;
    is $v7->exec(q{0.0}), 0;
    is $v7->exec(q{3.4}), 3.4;
    is $v7->exec(q{-3.4}), -3.4;
    is $v7->exec(q{'0'}), '0';
    is $v7->exec(q{'1'}), '1';
    is $v7->exec(q{'-1'}), '-1';
    is $v7->exec(q{'2'}), '2';
    is $v7->exec(q{'3.4'}), '3.4';
    is $v7->exec(q{true}), 1;
    is $v7->exec(q{false}), 0;
    is $v7->exec(q{''}), '';
    is $v7->exec(q{'foo'}), 'foo';
    is $v7->exec(q{'\'foo\''}), q{'foo'};
};

done_testing;

