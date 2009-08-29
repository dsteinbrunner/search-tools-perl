use strict;
use warnings;
use Data::Dump qw( dump );
use Test::More tests => 24;

# http://code.google.com/p/test-more/issues/detail?id=46
binmode Test::More->builder->output,         ":utf8";
binmode Test::More->builder->failure_output, ":utf8";

use_ok('Search::Tools');
use_ok('Search::Tools::Tokenizer');

my $str = "foo bar bing";

ok( my $tokenizer = Search::Tools::Tokenizer->new, "new tokenizer" );
ok( my $tokens    = $tokenizer->tokenize($str),    "tokenize str" );
is( check_tokens($tokens), 5, "check_tokens" );
diag("destroy tokens");
$tokens = undef;
diag("tokens are undef");

sub check_tokens {
    my $tokens = shift;
    my $count  = 0;
    while ( my $tok = $tokens->next ) {
        ok( length( $tok->str ), "tok->str" );

        #diag( $tok->str );
        cmp_ok( $tok->len, '>=', 1, "tok->len >= 1" );
        ok( defined $tok->pos, "token pos" );
        $count++;
    }
    is( $count,       $tokens->num, "count == num" );
    is( $tokens->pos, $tokens->num, "pos == num-1 when all seen" );
    is( $tokens->len, $tokens->num, "len == num" );
    is( scalar( @{ $tokens->as_array } ), $count, "get as_array" );
    #dump($tokens);
    #$tokens->dump;
    return $count;

}
