# File/Copy.pm. Written in 1994 by Aaron Sherman <ajs@ajs.com>. This
# source code has been placed in the public domain by the author.
# Please be kind and preserve the documentation.
#

package File::Copy;

require Exporter;
use Carp;

@ISA=qw(Exporter);
@EXPORT=(copy);
@EXPORT_OK=qw(copy cp);

$File::Copy::VERSION = '1.4';
sub VERSION {
	# Version of File::Copy
	$File::Copy::VERSION;
}

sub copy {
    croak("Usage: copy( file1, file2) ")
      unless(@_ == 2);

    my $from = shift;
    my $to = shift;
    my $size = -s $from;
    $size = 1024 unless($size >= 512);
    my $status;
    my $recsep = $\;
    my $closefrom=0; my $closeto=0;
    local(*FROM, *TO, $r, $buf);

    $\ = '';

    if (ref(\$from) eq GLOB) {
	*FROM = $from;
    } elsif (ref($from) eq GLOB || ref($from) eq FileHandle) {
	*FROM = *$from;
    } else {
	open(FROM,"<$from")||goto(fail_open1);
	$closefrom = 1;
    }

    if (ref(\$to) eq GLOB) {
	*TO = $to;
    } elsif (ref($to) eq GLOB || ref($to) eq FileHandle) {
	*TO = *$to;
    } else {
	open(TO,">$to")||goto(fail_open2);
	$closeto=1;
    }

    while(defined($r = sysread(FROM,$buf,$size)) && $r > 0) {
	if (syswrite (TO,$buf,$r) != $r) {
	    goto fail_inner;    
	}
    }
    goto fail_inner unless(defined($r));
    close(TO) || goto fail_open2 if $closeto;
    close(FROM) || goto fail_open1 if $closefrom;
    $\ = $recsep;
    return 1;
    
    # All of these contortions try to preserve error messages...
  fail_inner:
    if ($closeto) {
	$status = $!;
	$! = 0;
	close TO;
	$! = $status unless $!;
    }
  fail_open2:
    if ($closefrom) {
	$status = $!;
	$! = 0;
	close FROM;
	$! = $status unless $!;
    }
  fail_open1:
    $\ = $recsep;
    return 0;
}
*cp = \&copy;

1;

__END__
=head1 NAME

File::Copy - Copy files or filehandles

=head1 USAGE

  	use File::Copy;

	copy("file1","file2");
  	copy("Copy.pm",\*STDOUT);'

  	use POSIX;
	use File::Copy cp;

	$n=FileHandle->new("/dev/null","r");
	cp($n,"x");'

=head1 DESCRIPTION

The Copy module provides one function (copy) which takes two
parameters: a file to copy from and a file to copy to. Either
argument may be a string, a FileHandle reference or a FileHandle
glob. Obviously, if the first argument is a filehandle of some
sort, it will be read from, and if it is a file I<name> it will
be opened for reading. Likewise, the second argument will be
written to (and created if need be).

You may use the syntax C<use File::Copy "cp"> to get at the
"cp" alias for this function. The syntax is I<exactly> the same.

=head1 RETURN

Returns 1 on success, 0 on failure. $! will be set if an error was
encountered.

=head1 AUTHOR

File::Copy was written by Aaron Sherman <ajs@ajs.com> in 1995.

=cut
