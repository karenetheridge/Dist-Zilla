package Dist::Zilla::Role::AfterPrereqs;
# ABSTRACT: something that runs after prerequisites are finalized

use Moose::Role;
with 'Dist::Zilla::Role::Plugin';
use namespace::autoclean;

=head1 DESCRIPTION

Plugins implementing AfterPrereqs have their C<after_prereqs> method called to
do any work that must take place after all prerequisites have been finalized -
for example, to modify a file to embed the prerequisite list in its contents.

=cut

requires 'after_prereqs';

1;
