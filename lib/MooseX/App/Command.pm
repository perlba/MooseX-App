# ============================================================================
package MooseX::App::Command;
# ============================================================================

use 5.010;
use utf8;
use strict;
use warnings;

use Moose ();
use MooseX::App::Meta::Role::Attribute::Option;
use MooseX::App::Exporter qw(option parameter command_short_description command_long_description command_usage command_strict);
use Moose::Exporter;

Moose::Exporter->setup_import_methods(
    with_meta => [qw(command_short_description command_long_description command_strict command_usage option parameter)],
    also      => 'Moose',
);

sub init_meta {
    my ($class,%args) = @_;
    
    my $meta = Moose->init_meta( %args );
    
    Moose::Util::MetaRole::apply_metaroles(
        for             => $meta,
        class_metaroles => {
            class           => ['MooseX::App::Meta::Role::Class::Command'],
            attribute       => ['MooseX::App::Meta::Role::Attribute::Option'],
        },
    );
    
    Moose::Util::MetaRole::apply_base_class_roles(
        for             => $args{for_class},
        roles           => ['MooseX::App::Role::Common'],
    );
    
    return $meta;
}

1;

__END__

=pod

=head1 NAME

MooseX::App::Command - Load command class metaclasses

=head1 SYNOPSIS

 package MyApp::SomeCommand;
 
 use Moose; # optional
 use MooseX::App::Command
 
 option 'testattr' => (
    isa             => 'rw',
    cmd_tags        => [qw(Important! Nice))],
 );
 
 command_short_description 'This is a short description';
 command_long_description 'This is a much longer description yadda yadda';
 command_usage 'script some_command --testattr 123'; 

=head1 DESCRIPTION

By loading this class into your command classes you enable all documentation
features such as:
 
=over

=item * Parsing command documentation from Pod

=item * Setting the command documentation manually via C<command_short_description> and C<command_long_description>

=item * Overriding the automated usage header with custom usage from Pod or via C<command_usage>

=item * Adding the C<cmd_tags>, C<cmd_flag>, C<cmd_aliases> and C<cmd_type> attributes to options

=back

=head1 FUNCTIONS

=head2 command_short_description

Set the short description. If not set this information will be taken from the
Pod NAME or ABSTRACT section. Alternative this will be taken from the DistZilla
ABSTRACT tag.

=head2 command_long_description

Set the long description. If not set this information will be taken from the
Pod DESCRIPTION or OVERVIEW sections.

=head2 command_usage

Set custom usage. If not set this will be taken from the Pod SYNOPSIS or 
USAGE section. If those sections are not available, the usage
information will be autogenerated.

=cut

1;
