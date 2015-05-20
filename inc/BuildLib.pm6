module BuildLib;

my @cleanup;  # files to be cleaned up afterwards

constant $in-dir = "src";
constant $out-dir = "blib/lib/Native/Gumbo";

sub build-lib(Str $name, :@libs, Bool :$debug = False) is export {
    my ($c_line, $l_line);
    my $VM  := $*VM;
    my $cfg := $VM.config;
    mkdir $out-dir;
    if $VM.name eq 'parrot' {
        my $o  = $cfg<o>;
        my $so = $cfg<load_ext>;
        $c_line = "$cfg<cc> -c $cfg<cc_shared> $cfg<cc_o_out>$name$o $cfg<ccflags> $in-dir/$name.c";
        $l_line = "$cfg<ld> $cfg<ld_load_flags> $cfg<ldflags> " ~
            @libs.map({ "-l$^lib" }).join(' ') ~
            " $cfg<libs> $cfg<ld_out>$out-dir/$name$so $name$o";
        #@cleanup = << "$name$so" "$name$o" >>;
        @cleanup = << "$name$o" >>;
    }
    elsif $VM.name eq 'moar' {
        my $o  = $cfg<obj>;
        my $so = $cfg<dll>;
        $so ~~ s/^.*\%s//;
        $c_line = "$cfg<cc> -c $cfg<ccshared> $cfg<ccout>$name$o $cfg<cflags> $in-dir/$name.c";
        $l_line = "$cfg<ld> $cfg<ldshared> $cfg<ldflags> " ~
            @libs.map({ "-l$^lib" }).join(' ') ~
            " $cfg<ldlibs> $cfg<ldout>$out-dir/$name$so $name$o";
        #@cleanup = << "$name$so" "$name$o" >>;
        @cleanup = << "$name$o" >>;
    }
    elsif $VM.name eq 'jvm' {
        $c_line = "$cfg<nativecall.cc> -c $cfg<nativecall.ccdlflags> -o$name$cfg<nativecall.o> $cfg<nativecall.ccflags> $in-dir/$name.c";
        $l_line = "$cfg<nativecall.ld> $cfg<nativecall.perllibs> " ~
            @libs.map({ "-l$^lib" }).join(' ') ~
            " $cfg<nativecall.lddlflags> $cfg<nativecall.ldflags> $cfg<nativecall.ldout>$out-dir/$name.$cfg<nativecall.so> $name$cfg<nativecall.o>";
        #@cleanup = << "$name.$cfg<nativecall.so>" "$name$cfg<nativecall.o>" >>;
        @cleanup = << "$name$cfg<nativecall.o>" >>;
    }
    else {
        die "Unknown VM; don't know how to compile libraries";
    }
    $c_line.say if $debug;
    shell($c_line);
    $l_line.say if $debug;
    shell($l_line);

    @cleanup.for: { $^file.IO.unlink }
}

# END {
# #    say "cleaning up @cleanup[]";
#     unlink @cleanup;
# }
