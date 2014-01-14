package Dist::Zilla::Role::BuildPL;
# ABSTRACT: Common ground for Build.PL based builders

use Moose::Role;

with qw(
  Dist::Zilla::Role::AfterPrereqs
  Dist::Zilla::Role::BuildRunner
  Dist::Zilla::Role::TestRunner
);
# XXX who uses this role anyway? ask grep.cpan.me!!!
# Dist-Zilla-PluginBundle-ACPS-0.27/lib/Dist/Zilla/Plugin/ACPS/Legacy.pm # <-- does nothing - no op.
# Dist-Zilla-Plugin-ModuleBuildTiny-0.005/lib/Dist/Zilla/Plugin/ModuleBuildTiny.pm
# Dist-Zilla-Plugin-BuildSelf-0.003/lib/Dist/Zilla/Plugin/BuildSelf.pm

# XXX they can do:  eval { with 'Dist::Zilla::Role::AfterPrereqs'; }

# these modules should change to checking in setup_installer if their work was
# already done earlier (in after_prereqs) -- if so, do nothing -- or simply
# dep on a new Dist::Zilla.

use namespace::autoclean;

=head1 DESCRIPTION

This role is a helper for Build.PL based installers. It implements the
L<Dist::Zilla::Plugin::BuildRunner> and L<Dist::Zilla::Plugin::TestRunner>
roles, and requires you to implement the L<Dist::Zilla::Plugin::PrereqSource>
and L<Dist::Zilla::Plugin::AfterPrereqs> roles yourself.

=cut

# empty overridable sub for legacy purposes
sub after_prereqs {
  my ($self) = @_;
  $self->setup_installer if $self->can('setup_installer');
}

sub build {
  my $self = shift;

  system $^X, 'Build.PL' and die "error with Build.PL\n";
  system $^X, 'Build'    and die "error running $^X Build\n";

  return;
}

sub test {
  my ($self, $target) = @_;

  $self->build;
  my @testing = $self->zilla->logger->get_debug ? '--verbose' : ();
  system $^X, 'Build', 'test', @testing and die "error running $^X Build test\n";

  return;
}

1;
