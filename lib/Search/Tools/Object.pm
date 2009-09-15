package Search::Tools::Object;
use strict;
use warnings;
use Carp;
use base qw( Rose::Object );
use Scalar::Util qw( blessed );
use Search::Tools::MethodMaker;

our $VERSION = '0.24';

__PACKAGE__->mk_accessors(qw( debug ));

=pod

=head1 NAME

Search::Tools::Object - base class for Search::Tools objects

=head1 SYNOPSIS

 package MyClass;
 use base qw( Search::Tools::Object );
 
 __PACKAGE__->mk_accessors( qw( foo bar ) );
 
 sub init {
    my $self = shift;
    $self->SUPER::init(@_);

    # do stuff to set up object
    
 }
 
 1;
 
 # elsewhere
 
 use MyClass;
 my $object = MyClass->new;
 $object->foo(123);
 print $object->bar . "\n";

=head1 DESCRIPTION

Search::Tools::Object is a subclass of Rose::Object. Prior to version 0.24
STO was a subclass of Class::Accessor::Fast. Backwards compatability for
the mk_accessors() and mk_ro_accessors() class methods are preserved
via Search::Tools::MethodMaker.

=head1 METHODS

=cut

sub _init {
    croak "use init() instead";
}

sub init {
    my $self = shift;

    # assume object is hash and set key
    # rather than call method, since we have read-only methods.
    while (@_) {
        my $method = shift;
        $self->{$method} = shift;
    }
    $self->{debug} ||= $ENV{PERL_DEBUG} || 0;
    return $self;
}

# backcompat for CAF
sub mk_accessors {
    my $class = shift;
    Search::Tools::MethodMaker->make_methods( { target_class => $class },
        scalar => \@_ );
}

sub mk_ro_accessors {
    my $class = shift;
    Search::Tools::MethodMaker->make_methods( { target_class => $class },
        'scalar --ro' => \@_ );
}

sub _normalize_args {
    my $self = shift;
    my %args = @_;
    my $q    = delete $args{query};
    if ( !defined $q ) {
        croak "query required";
    }
    if ( !ref($q) ) {
        $args{query} = Search::Tools::QueryParser->new(%args)->parse($q);
    }
    elsif ( ref($q) eq 'ARRAY' ) {
        warn "query ARRAY ref deprecated as of version 0.24";
        $args{query} = Search::Tools::QueryParser->new(%args)
            ->parse( join( ' ', @$q ) );
    }
    elsif ( blessed($q) and $q->isa('Search::Tools::Query') ) {
        $args{query} = $q;
    }
    elsif ( blessed($q) and $q->isa('Search::Tools::RegExp::Keywords') ) {

        # backcompat
        $args{query} = Search::Tools::Query->from_regexp_keywords($q);
    }
    else {
        croak
            "query param required to be a scalar string or Search::Tools::Query object";
    }
    return %args;
}

1;

__END__

=head1 AUTHOR

Peter Karman C<perl@peknet.com>

=head1 COPYRIGHT

Copyright 2009 by Peter Karman.

This package is free software; you can redistribute it and/or modify it under the 
same terms as Perl itself.

=head1 SEE ALSO

Search::Tools

=cut
