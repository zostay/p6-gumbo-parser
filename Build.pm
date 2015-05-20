use Panda::Builder;
class Build is Panda::Builder {
    use lib 'inc';
    use BuildLib;

    method build($workdir) {
        build-lib('p6-gumbo-helper', :libs[<gumbo>]);
    }

}

# vim: ft=perl6
