use strict;
use warnings;
use Test::More;
use FormValidator::Lite;
use CGI;

subtest 'check() sets checked() values' => sub {
    my $q = CGI->new({
        valid   => 'good',
        invalid => 'evil',
        pass    => 'hello',
        other   => 'yo',
    });

    my $v = FormValidator::Lite->new($q);
    $v->check(
        valid   => ['NOT_NULL'],
        invalid => ['INT'],
        pass    => [],
    );

    is_deeply(
        $v->checked,
        {
            valid   => 'good',
            pass    => 'hello',
        },
    ) or diag(explain $v->checked);
    
    subtest 'check() resets checked() values' => sub {
        $v->check(
            valid   => ['NOT_NULL'],
        );

        is_deeply(
            $v->checked,
            {
                valid   => 'good',
            },
        ) or diag(explain $v->checked);
    };
};

subtest 'check() using checked() values' => sub {
    my $q = CGI->new({
        test1 => ' hello ',
        test2 => ' hello ',
    });

    my $v = FormValidator::Lite->new($q);
    
    $v->check(
        test1 => [[FILTER => 'trim'], [EQUAL => 'hello']],
        
        test2 => [[FILTER => 'trim']],
        test2 => [[EQUAL  => 'hello']],
    );
    
    ok(not $v->has_error);
    
    is_deeply(
        $v->checked,
        {
            test1 => 'hello',
            test2 => 'hello',
        },
    ) or diag(explain $v->checked);
};

done_testing();
