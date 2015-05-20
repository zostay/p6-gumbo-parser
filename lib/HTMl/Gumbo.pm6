use v6;

use NativeCall;

module HTML::Gumbo {
    use Native::Gumbo;

    my sub convert-native-enum($enum, :$indexify-bitmap) {
        my @pairs = $enum.pairs.sort: *.value <=> *.value;
        if $indexify-bitmap {
            @pairs.=map: -> $p { $p.key => log($p.value, 2) }
        }

        @pairs.map: -> $p {
            my $k = $p.key.subst(/^GUMBO_/, '');
            $k.=lc;
            $k.=subst(/ [ ^ | _ ] (<.alpha>) /, {uc $0}, :g);
            $k => $p.value
        }
    }

    class Node { ... }
    class Document { ... }
    class Element { ... }
    class Text { ... }

    my sub build-node(Pointer $node) {
        my $native-node = nativecast(GumboNode, $node);
        return HTML::Gumbo::Node unless $native-node.defined;
        given GumboNodeType($native-node.type) {
            when GumboNodeType('GUMBO_NODE_DOCUMENT') {
                HTML::Gumbo::Document.new(:$node);
            }
            when GumboNodeType('GUMBO_NODE_ELEMENT') {
                HTML::Gumbo::Element.new(:$node);
            }
            when GumboNodeType('GUMBO_NODE_TEXT') {
                HTML::Gumbo::Text.new(:$node);
            }
            default {
                HTML::Gumbo::Node
            }
        }
    }

    my sub from-vector($native-vec) {
        die "# length = ", $native-vec.length, "\n";
        (^$native-vec.length).map: -> $i {
            #build-node($native-vec.data[$i])
            warn "# $i\n";
            HTML::Gumbo::Node
        };
    }



#    class Vector {
#        has Pointer $.vec;
#        has GumboVector $.native-vec = nativecast(GumboVector, $!vec);
#
#        has HTML::Gumbo::Node @.data = (^$!native-vec.length).map: -> $i {
#            HTML::Gumbo::Node.new(
#                node => nativecast(GumboNode, $!native-vec.data[$i]),
#            )
#        };
#    }

    class Node {
        has Pointer $.node;
        has GumboNode $.native-node = nativecast(GumboNode, $!node);

        enum Type (convert-native-enum(GumboNodeType.enums));

        has $.type = HTML::Gumbo::Node::Type($!native-node.type);

        has $.parent = build-node($!native-node.parent);

        has Int $.index-within-parent = $!native-node.index_within_parent;

        enum ParseFlags (convert-native-enum(GumboParseFlags, :indexify-bitmap));

        # TODO should be Blob[bit], but MoarVM doesn't do that yet
        has @.parse-flags = Blob[uint8].new(
            GumboParseFlags.enums.kv.map: -> $k, $v {
                $!native-node.parse_flags +& $v ?? 1 !! 0
            }
        );
    }

    class Document is Node {
        has GumboDocument $.native-doc = self.native-node.v.document;

        #has HTML::Gumbo::Node @.children = from-vector($!native-doc.children);

        has Bool $.has-doctype = ?$!native-doc.has_doctype;

        enum QuirksMode (convert-native-enum(GumboQuirksModeEnum));

        has Str $.name = $!native-doc.name;
        has Str $.public-identifier = $!native-doc.public_identifier;
        has Str $.system-identifier = $!native-doc.system_identifier;
        has QuirksMode $.doc-type-quirks-mode = QuirksMode($!native-doc.doc_type_quirks_mode);
    }

    class Element is Node {
        has GumboElement $.native-el = self.native-node.v.element;

        has HTML::Gumbo::Node @.children = from-vector($!native-el.children);
    }

    class Text is Node {
        has GumboText $.native-text = self.native-node.v.text;

        has Str $.text = $!native-text.text;
    }

    class Output {
        has Pointer $.output;
        has GumboOutput $.native-output = nativecast(GumboOutput, $!output);

        has $.document = build-node($!native-output.document);
        has $.root = build-node($!native-output.root);

=begin comment
        # TODO How should this work?
        has $.errors = HTML::Gumbo::Vector.new(
            native-vector => $!native-output.errors;
        );
=end comment

        submethod DESTROY {
            gumbo_destroy_output(
                nativecast(Pointer, kGumboDefaultOptions), 
                $!output);
        }
    }

    sub gumbo-parse(Str $buffer) is export {
        HTML::Gumbo::Output.new(
            output => gumbo_parse($buffer),
        )
    }
}
