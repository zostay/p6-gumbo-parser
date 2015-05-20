use v6;

use NativeCall;
use Native::Gumbo;
use Test;

# TODO It would be nice if MVM setup REPR objects so that === would work here
# instead of having to check Pointer.Int == Pointer.Int
multi is(Pointer:D $p1, Pointer:D $p2, Str $msg = '') {
    is($p1.Int, $p2.Int, $msg);
}

# 
# todo 'kGumboEmptySourcePosition does not behave', 4;
ok try { $kGumboEmptySourcePosition.defined }, 'empty source position is defined';
is try { $kGumboEmptySourcePosition.line }, 0, 'empty source position line is 0';
is try { $kGumboEmptySourcePosition.column }, 0, 'empty source position column is 0';
is try { $kGumboEmptySourcePosition.offset }, 0, 'empty source position offset is 0';
# 
# todo 'kGumboEmptyString does not behave', 3;
ok try { $kGumboEmptyString.defined }, 'empty string is defined';
nok try { $kGumboEmptyString.data }, 'empty string data is not a thing';
is try { $kGumboEmptyString.length }, 0, 'empty string length is 0';
# 
# todo 'kGumboEmptyVector does not behave', 4;
# diag $kGumboEmptyVector.perl;
ok try { $kGumboEmptyVector.defined }, 'empty vector is defined';
is try { $kGumboEmptyVector.data }, Pointer, 'empty vector data is 0';
is try { $kGumboEmptyVector.length }, 0, 'empty vector is 0-length';
is try { $kGumboEmptyVector.capacity }, 0, 'empty vector is 0-capacity';

ok $kGumboDefaultOptions.defined, 'default options is defined';
ok $kGumboDefaultOptions.allocator.defined, 'default options allocator is defined';
ok $kGumboDefaultOptions.deallocator.defined, 'default options deallocator is defiend';
#is $kGumboDefaultOptions.userdata, $NULL, 'default options userdata is NULL';
is $kGumboDefaultOptions.tab_stop, 8, 'default options tab stop is 8';
is Bool($kGumboDefaultOptions.stop_on_first_error), False, 'default options stop on first error is false';
is $kGumboDefaultOptions.max_errors, -1, 'default options max errors is set to 0';
#diag $kGumboDefaultOptions.perl;
#diag cglobal('libgumbo', 'kGumboDefaultOptions', Pointer).perl;
#diag nativecast(GumboOptions, cglobal('libgumbo', 'kGumboDefaultOptions', Pointer)).perl;
#diag nativecast(Pointer, kGumboDefaultOptions.userdata);

my $output = gumbo_parse(q:to/END_OF_HTML/);
<!DOCTYPE html>
<html>
    <head><title>Test Doc</title></head>
    <body><h1>Hello, World!</h1></body>
</html>
END_OF_HTML

ok $output, 'got output';
ok $output.document, 'output has doc';
ok $output.root, 'output has root';

my $document_n = $output.document;
is $document_n.type, GUMBO_NODE_DOCUMENT.value, 'doc node has doc node type';
nok $document_n.parent, 'doc has no parent';
is $document_n.index_within_parent, -1, 'doc has no parent position';
is $document_n.parse_flags, GUMBO_INSERTION_BY_PARSER.value, 'doc is inserted by parser';

my $document = $document_n.v.document;
ok $document, 'document node has document detail';
is $document.has_doctype, 1, 'has a doctype';
is $document.name, 'html', 'doc name is html';
is $document.public_identifier, '', 'no public id';
is $document.system_identifier, '', 'no system id';
is $document.doc_type_quirks_mode, GUMBO_DOCTYPE_NO_QUIRKS.value, 'no quirks';

my $root_n = $output.root;
is $root_n.type, GUMBO_NODE_ELEMENT.value, 'root node has element node type';
ok $root_n.parent, 'root node has parent';
is $root_n.parent.Pointer, $document_n.Pointer, 'root parent is document';
is $root_n.index_within_parent, 0, 'root is first element';
is $root_n.parse_flags, 0, 'parse flags are nil';

my $root = $root_n.v.element;
ok $root, 'root node has element detail';
#warn "# ", nativecast(Pointer, $root).perl;
#warn "# ", nativecast(Pointer, $root.children).perl;
#warn "# ", nativecast(Pointer, $root.children.data).perl;
#warn "# ", nativesizeof(CArray);
#warn "# ", nativesizeof(Pointer);
#warn "# ", nativesizeof(GumboVector);
#diag $root.children.perl;
is $root.children-length, 3, '<html> has two children';
my @root-children = GumboVector-as-GumboNodes($root.children, $root.children-length);
is @root-children.elems, 2, '<html> has two children';
is @root-children[0].type, GUMBO_NODE_ELEMENT.value, '<html> first child is element';
is @root-children[0].v.element.tag, GUMBO_TAG_HEAD.value, '<html> first child is <head>';
is @root-children[1].type, GUMBO_NODE_ELEMENT.value, '<html> second child is element';
is @root-children[1].v.element.tag, GUMBO_TAG_BODY.value, '<html> second child is <body>';
is $root.tag, GUMBO_TAG_HTML.value, 'root tag is <html>';

my $head = @root-children[0].v.element;
my @head-children = GumboVector-as-GumboNodes($head.children, $head.children-length);
is @head-children.elems, 1, '<head> has one child';
is @head-children[0].type, GUMBO_NODE_ELEMENT.value, '<head> first child is element';
is @head-children[0].v.element.tag, GUMBO_TAG_TITLE.value, '<head> first child is <title>';

# my $title = @head-children[0].v.element;
# is $title.tag, GUMBO_TAG_TITLE.value, '???';
# my @title-children = GumboVector-as-GumboNodes($title.children, $title.children-length);
# is @title-children.elems, 1, '<title> has one child';
# diag GumboNodeType(@title-children[0].type);
# diag GumboTag(@title-children[0].v.element.tag);
# is @title-children[0].type, GUMBO_NODE_TEXT.value, '<title> first child is text';
# is @title-children[0].v.text.text, "Test Doc", '<title> child is "Test Doc"';

my $body = @root-children[0].v.element;
my @body-children = GumboVector-as-GumboNodes($body.children, $body.children-length);
is @body-children.elems, 1, '<body> has one child';
is @body-children[0].type, GUMBO_NODE_ELEMENT.value, '<body> first child is element';
is @body-children[0].v.element.tag, GUMBO_TAG_H1.value, '<body> first child is <h1>';

done;
