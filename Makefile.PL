use lib 'lib';
require File::Copy;
use ExtUtils::MakeMaker;
WriteMakefile(
	NAME => "File::Copy",
	DISTNAME => "File-Copy",
	      VERSION => $File::Copy::VERSION,
        dist => {COMPRESS=>'gzip -9f'},
	macro => {CONFIGDEP => 'lib/File/Copy.pm'},
);
