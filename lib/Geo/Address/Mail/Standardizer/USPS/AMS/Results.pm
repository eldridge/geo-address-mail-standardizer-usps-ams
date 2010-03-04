package Geo::Address::Mail::Standardizer::USPS::AMS::Results;

use Moose;

=head1 NAME

Geo::Address::Mail::Standardizer::USPS::AMS::Result

=head1 SYNOPSIS

 my $address = new Geo::Address::Mail::US;
 my $ms      = new Geo::Address::Mail::Standardizer::USPS::AMS;
 my $result  = $ms->standardize($addr);

 $result->address; # new standardized Geo::Address::Mail::US object
 $result->multiple; # boolean indicating whether 

=head1 DESCRIPTION

results n stuff

=cut

extends 'Geo::Address::Mail::Standardizer::Results';

use Geo::Address::Mail::US;
use Moose::Util::TypeConstraints;

subtype 'Address'		=> as 'Geo::Address::Mail::US';
subtype 'AddressList'	=> as 'ArrayRef[Address]';

coerce 'Address'
	=> from 'HashRef'
	=> via { new Geo::Address::Mail::US $_ };

coerce 'AddressList'
	=> from 'ArrayRef[HashRef]'
	=> via { [ map { new Geo::Address::Mail::US $_ } @$_ ] };

#has address => (is => 'ro', isa => 'Geo::Address::Mail');
has error		=> (is => 'ro', isa => 'Str|Undef', lazy_build => 1);
has found		=> (is => 'ro', isa => 'Int', lazy_build => 1);
has default		=> (is => 'ro', isa => 'Bool', lazy_build => 1);
has single		=> (is => 'ro', isa => 'Bool', lazy_build => 1);
has multiple	=> (is => 'ro', isa => 'Bool', lazy_build => 1);

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

