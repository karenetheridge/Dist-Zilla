use strict;
use warnings;

use Test::More;
use Test::DZil;

use Dist::Zilla::Plugin::CPANFile;

# unfortunately this is a copy from the tested code
my $version = $Dist::Zilla::Plugin::CPANFile::VERSION // '<internal>';

is(
	cpanfile('build/cpanfile') => <<"INI",
# This file is generated by Dist::Zilla::Plugin::CPANFile v$version
# Do not edit this file directly. To change prereqs, edit the `dist.ini` file.

requires "strict" => "0";
requires "warnings" => "0";
INI
	"cpanfile contains requirements"
);

ok(
	cpanfile('build/otherfile' => { filename => 'otherfile' }),
 "non-default filename"
);

is(
  cpanfile('build/cpanfile' => { comment => ["foobar"] }) =>
  <<"INI",
# foobar

requires "strict" => "0";
requires "warnings" => "0";
INI
  "simple comment"
);

is(
  cpanfile('build/cpanfile' => { comment => [ "foo", "bar" ] }),
  <<"INI",
# foo
# bar

requires "strict" => "0";
requires "warnings" => "0";
INI
  "multiline comment"
);

sub cpanfile {
  my $filename = shift;

  my $opts = @_ ? [ map { (CPANFile => $_) } @_ ] : 'CPANFile';

  my $tzil = Builder->from_config(
    { dist_root => 'corpus/dist/DZ1' },
    {
      add_files => {
        'source/dist.ini' => simple_ini(qw< GatherDir AutoPrereqs  >, $opts),
      },
    },
  );

  $tzil->build;

  return $tzil->slurp_file($filename);
}

done_testing;
