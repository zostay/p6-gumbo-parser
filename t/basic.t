use v6;

use HTML::Gumbo;
use Test;

my $output = gumbo-parse("<h1>Hello, World!</h1>");
ok $output, 'got output';

isa_ok $output, 'HTML::Gumbo::Output';
ok $output.document;
ok $output.root;

my $doc = $output.document;
isa_ok $doc, 'HTML::Gumbo::Document';
isa_ok $doc, 'HTML::Gumbo::Node';

done;
