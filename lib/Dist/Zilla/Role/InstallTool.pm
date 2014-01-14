package Dist::Zilla::Role::InstallTool;
# ABSTRACT: something that creates an install program for a dist (DEPRECATED)

use Moose::Role;
with qw(
  Dist::Zilla::Role::Plugin
  Dist::Zilla::Role::FileInjector
);

use namespace::autoclean;

use Moose::Autobox;

=head1 DESCRIPTION

Plugins implementing InstallTool have their C<setup_installer> method called to
inject files after all other file injection and munging has taken place.
They're expected to produce files needed to make the distribution
installable, like F<Makefile.PL> or F<Build.PL> and add them with the
C<add_file> method provided by L<Dist::Zilla::Role::FileInjector>, which is
also composed by this role.

This is a B<deprecated phase> -- plugins using this phase should instead do
their work in the L<Dist::Zilla::Role::FileGatherer/FileGatherer> or
L<Dist::Zilla::Role::AfterPrereqs/AfterPrereqs> phase.

=cut

requires 'setup_installer';

around setup_installer => sub {
  my ($orig, $self, @args) = @_;

  warn 'WARNING: the InstallTool phase is deprecated!';
  $self->$orig(@args);
};

1;
