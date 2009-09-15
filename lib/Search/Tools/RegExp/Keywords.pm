package Search::Tools::RegExp::Keywords;
use strict;
use warnings;
use Carp;
use base qw( Search::Tools::Object );
__PACKAGE__->mk_ro_accessors(
    qw(
        kw
        start_bound
        end_bound
        hash
        array
        )
);

our $VERSION = '0.24';

sub keywords {
    my $self = shift;
    return @{ $self->{array} };
}

sub re {
    my $self = shift;
    my $q = shift or croak "need query to get regular expression";
    unless ( exists $self->{hash}->{$q} ) {
        croak "no regexp for query '$q'";
    }
    return $self->{hash}->{$q};
}

1;

__END__

=pod

=head1 NAME

Search::Tools::RegExp::Keywords - access regular expressions for keywords

=head1 SYNOPSIS

 # deprecated. See Search::Tools::Query
 
 
=head1 DESCRIPTION

As of version 0.24 this class is deprecated in favor of Search::Tools::Query.

=head1 AUTHOR

Peter Karman C<perl@peknet.com>

Based on the HTML::HiLiter regular expression building code, originally by the same author, 
copyright 2004 by Cray Inc.

Thanks to Atomic Learning C<www.atomiclearning.com> 
for sponsoring the development of this module.

=head1 COPYRIGHT

Copyright 2006 by Peter Karman. 
This package is free software; you can redistribute it and/or modify it under the 
same terms as Perl itself.

=head1 SEE ALSO

HTML::HiLiter, Search::Tools::RegExp, Search::Tools::RegExp::Keyword

=cut
