use ExtUtils::MakeMaker;
WriteMakefile(NAME => 'File::Copy',
	      SKIP => [qw(xs_c xs_o c_o dynamic static)],
	      VERSION => '1.5');
