package Geo::Address::Mail::Standardizer::USPS::AMS::Results;

use Moose;
use MooseX::Storage;
with qw(MooseX::Storage::Deferred);

=head1 NAME

Geo::Address::Mail::Standardizer::USPS::AMS::Result

=head1 SYNOPSIS

 my $address = new Geo::Address::Mail::US;
 my $ms      = new Geo::Address::Mail::Standardizer::USPS::AMS;
 my $result  = $ms->standardize($addr);

 $result->address;    # new standardized Geo::Address::Mail::US object
 $result->multiple;   # boolean indicating whether multiple addresses are returned.
 $result->single;     # boolean indicating whether a single address was returned.
 $result->found;      # integer indicating the number of candidates
 $result->error;      # string with an error message
 $result->default;    # boolean indicating a Z4_DEFAULT return code, which means:
                      #  "An address was found, but a more specific address could be
                      #  found with more information"
 $result->candidates; # reference to an array of Geo::Address::Mail::US objects, all
                      #  of which are possible matches
 $result->changed;    # A hashref whose values are key => 1 pairs indicating which
                      #  fields were changed during standardization

 $result->standardized_address; # The standardized address, in the case of a single
                                # matching address

=head1 DESCRIPTION

The results of a call to Geo::Address::Mail::Standardizer::USPS::AMS's standardize method.

=cut

extends 'Geo::Address::Mail::Standardizer::Results';

use Geo::Address::Mail::US;
use Moose::Util::TypeConstraints;

our $VERSION = '0.02';

subtype 'Address'		=> as 'Geo::Address::Mail::US';
subtype 'AddressList'	=> as 'ArrayRef[Address]';

coerce 'Address'
	=> from 'HashRef'
	=> via { new Geo::Address::Mail::US $_ };

coerce 'AddressList'
	=> from 'ArrayRef[HashRef]'
	=> via { [ map { new Geo::Address::Mail::US $_ } @$_ ] };

has error		=> (is => 'ro', isa => 'Str|Undef', predicate => 'has_error');
has found		=> (is => 'ro', isa => 'Int', predicate => 'has_found');
has default		=> (is => 'ro', isa => 'Bool', predicate => 'has_default');
has single		=> (is => 'ro', isa => 'Bool', predicate => 'has_single');
has multiple	=> (is => 'ro', isa => 'Bool', predicate => 'has_multiple');
has changed		=> (is => 'ro', isa => 'HashRef', predicate => 'has_changed');

has candidates =>
	is		=> 'ro',
	isa		=> 'AddressList',
	coerce	=> 1,
	traits	=> [ 'Array' ],
	handles	=>
	{
		has_candidates	=> 'count',
		num_candidates	=> 'count',
		get_candidate	=> 'get',
	};

has '+standardized_address' =>
	isa		=> 'Address',
	coerce	=> 1;

__PACKAGE__->meta->make_immutable;

1;
