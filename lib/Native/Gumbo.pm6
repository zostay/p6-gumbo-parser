use v6;

module Native::Gumbo {
    use NativeCall;

    my constant HELPER-DLL = "/Users/sterling/projects/perl6/p6-gumbo-parser/blib/lib/Native/Gumbo/p6-gumbo-helper";

    # Grabbed bits of this from cygx/p6-native-libc on github
    my constant PTRSIZE = nativesizeof(Pointer);
    die "Unsupported pointer size { PTRSIZE }"
        unless PTRSIZE ~~ 4|8;

    my constant uintptr_t = do given PTRSIZE {
        when 4 { uint32 }
        when 8 { uint64 }
    }
    my constant size_t = uintptr_t;

    class GumboSourcePosition is repr('CStruct') {
        has uint32 $.line;
        has uint32 $.column;
        has uint32 $.offset;
    }

    sub pGumboEmptySourcePosition
        returns GumboSourcePosition
        is native(HELPER-DLL) { * }

    our $kGumboEmptySourcePosition is export = pGumboEmptySourcePosition;

    class GumboStringPiece is repr('CStruct') {
        has Str $.data;
        has size_t $.length;
    }

    sub pGumboEmptyString
        returns GumboStringPiece
        is native(HELPER-DLL) { * }

    our $kGumboEmptyString is export = pGumboEmptyString;

    sub gumbo_string_equals(GumboStringPiece $str1, GumboStringPiece $str2)
        returns int32 
        is export
        is native('libgumbo') { * }

    sub gumbo_string_equals_ignore_case(GumboStringPiece $str1, GumboStringPiece $str2) 
        returns int32 
        is export
        is native('libgumbo') { * }

    class GumboVector is repr('CStruct') is export {
        has Pointer $.data;
        has uint16 $.length;
        has uint16 $.capacity;
    }

    sub pGumboEmptyVector
        returns GumboVector
        is native(HELPER-DLL) { * }

    our $kGumboEmptyVector is export = pGumboEmptyVector;

    sub gumbo_vector_index_of(GumboVector $vector, Pointer $element)
        returns int
        is export
        is native('libgumbo') { * }

    enum GumboTag is export <
        GUMBO_TAG_HTML
        GUMBO_TAG_HEAD
        GUMBO_TAG_TITLE
        GUMBO_TAG_BASE
        GUMBO_TAG_LINK
        GUMBO_TAG_META
        GUMBO_TAG_STYLE
        GUMBO_TAG_SCRIPT
        GUMBO_TAG_NOSCRIPT
        GUMBO_TAG_TEMPLATE
        GUMBO_TAG_BODY
        GUMBO_TAG_ARTICLE
        GUMBO_TAG_SECTION
        GUMBO_TAG_NAV
        GUMBO_TAG_ASIDE
        GUMBO_TAG_H1
        GUMBO_TAG_H2
        GUMBO_TAG_H3
        GUMBO_TAG_H4
        GUMBO_TAG_H5
        GUMBO_TAG_H6
        GUMBO_TAG_HGROUP
        GUMBO_TAG_HEADER
        GUMBO_TAG_FOOTER
        GUMBO_TAG_ADDRESS
        GUMBO_TAG_P
        GUMBO_TAG_HR
        GUMBO_TAG_PRE
        GUMBO_TAG_BLOCKQUOTE
        GUMBO_TAG_OL
        GUMBO_TAG_UL
        GUMBO_TAG_LI
        GUMBO_TAG_DL
        GUMBO_TAG_DT
        GUMBO_TAG_DD
        GUMBO_TAG_FIGURE
        GUMBO_TAG_FIGCAPTION
        GUMBO_TAG_MAIN
        GUMBO_TAG_DIV
        GUMBO_TAG_A
        GUMBO_TAG_EM
        GUMBO_TAG_STRONG
        GUMBO_TAG_SMALL
        GUMBO_TAG_S
        GUMBO_TAG_CITE
        GUMBO_TAG_Q
        GUMBO_TAG_DFN
        GUMBO_TAG_ABBR
        GUMBO_TAG_DATA
        GUMBO_TAG_TIME
        GUMBO_TAG_CODE
        GUMBO_TAG_VAR
        GUMBO_TAG_SAMP
        GUMBO_TAG_KBD
        GUMBO_TAG_SUB
        GUMBO_TAG_SUP
        GUMBO_TAG_I
        GUMBO_TAG_B
        GUMBO_TAG_U
        GUMBO_TAG_MARK
        GUMBO_TAG_RUBY
        GUMBO_TAG_RT
        GUMBO_TAG_RP
        GUMBO_TAG_BDI
        GUMBO_TAG_BDO
        GUMBO_TAG_SPAN
        GUMBO_TAG_BR
        GUMBO_TAG_WBR
        GUMBO_TAG_INS
        GUMBO_TAG_DEL
        GUMBO_TAG_IMAGE
        GUMBO_TAG_IMG
        GUMBO_TAG_IFRAME
        GUMBO_TAG_EMBED
        GUMBO_TAG_OBJECT
        GUMBO_TAG_PARAM
        GUMBO_TAG_VIDEO
        GUMBO_TAG_AUDIO
        GUMBO_TAG_SOURCE
        GUMBO_TAG_TRACK
        GUMBO_TAG_CANVAS
        GUMBO_TAG_MAP
        GUMBO_TAG_AREA
        GUMBO_TAG_MATH
        GUMBO_TAG_MI
        GUMBO_TAG_MO
        GUMBO_TAG_MN
        GUMBO_TAG_MS
        GUMBO_TAG_MTEXT
        GUMBO_TAG_MGLYPH
        GUMBO_TAG_MALIGNMARK
        GUMBO_TAG_ANNOTATION_XML
        GUMBO_TAG_SVG
        GUMBO_TAG_FOREIGNOBJECT
        GUMBO_TAG_DESC
        GUMBO_TAG_TABLE
        GUMBO_TAG_CAPTION
        GUMBO_TAG_COLGROUP
        GUMBO_TAG_COL
        GUMBO_TAG_TBODY
        GUMBO_TAG_THEAD
        GUMBO_TAG_TFOOT
        GUMBO_TAG_TR
        GUMBO_TAG_TD
        GUMBO_TAG_TH
        GUMBO_TAG_FORM
        GUMBO_TAG_FIELDSET
        GUMBO_TAG_LEGEND
        GUMBO_TAG_LABEL
        GUMBO_TAG_INPUT
        GUMBO_TAG_BUTTON
        GUMBO_TAG_SELECT
        GUMBO_TAG_DATALIST
        GUMBO_TAG_OPTGROUP
        GUMBO_TAG_OPTION
        GUMBO_TAG_TEXTAREA
        GUMBO_TAG_KEYGEN
        GUMBO_TAG_OUTPUT
        GUMBO_TAG_PROGRESS
        GUMBO_TAG_METER
        GUMBO_TAG_DETAILS
        GUMBO_TAG_SUMMARY
        GUMBO_TAG_MENU
        GUMBO_TAG_MENUITEM
        GUMBO_TAG_APPLET
        GUMBO_TAG_ACRONYM
        GUMBO_TAG_BGSOUND
        GUMBO_TAG_DIR
        GUMBO_TAG_FRAME
        GUMBO_TAG_FRAMESET
        GUMBO_TAG_NOFRAMES
        GUMBO_TAG_ISINDEX
        GUMBO_TAG_LISTING
        GUMBO_TAG_XMP
        GUMBO_TAG_NEXTID
        GUMBO_TAG_NOEMBED
        GUMBO_TAG_PLAINTEXT
        GUMBO_TAG_RB
        GUMBO_TAG_STRIKE
        GUMBO_TAG_BASEFONT
        GUMBO_TAG_BIG
        GUMBO_TAG_BLINK
        GUMBO_TAG_CENTER
        GUMBO_TAG_FONT
        GUMBO_TAG_MARQUEE
        GUMBO_TAG_MULTICOL
        GUMBO_TAG_NOBR
        GUMBO_TAG_SPACER
        GUMBO_TAG_TT
        GUMBO_TAG_UNKNOWN
        GUMBO_TAG_LAST
    >;

    sub gumbo_normalized_tagname(int $tag)
        returns Str
        is export
        is native('libgumbo') { * }

    sub gumbo_tag_from_original_text(GumboStringPiece $text)
        returns Str
        is export
        is native('libgumbo') { * }

    sub gumbo_normalize_svg_tagname(GumboStringPiece $tagname)
        returns Str
        is export
        is native('libgumbo') { * }

    sub gumbo_tag_enum(Str $tagname)
        returns int
        is export
        is native('libgumbo') { * }

    enum GumboAttributeNamespaceEnum is export <
        GUMBO_ATTR_NAMESPACE_NONE
        GUMBO_ATTR_NAMESPACE_XLINK
        GUMBO_ATTR_NAMESPACE_XML
        GUMBO_ATTR_NAMESPACE_XMLNS
    >;

    class GumboAttribute is repr('CStruct') {
        has int $.attr_namespace; # GubmoAttributeNamespaceEnum
        has Str $.name;
        has GumboStringPiece $.original_name is inlined;
        has Str $.value;
        has GumboStringPiece $.original_value is inlined;
        has GumboSourcePosition $.name_start is inlined;
        has GumboSourcePosition $.name_end is inlined;
        has GumboSourcePosition $.value_start is inlined;
        has GumboSourcePosition $.value_end is inlined;
    }

    sub gumbo_get_attribute(GumboVector $attrs, Str $name)
        returns GumboAttribute # GumboAttribute
        is export
        is native('libgumbo') { * }

    enum GumboNodeType is export <
        GUMBO_NODE_DOCUMENT
        GUMBO_NODE_ELEMENT
        GUMBO_NODE_TEXT
        GUMBO_NODE_CDATA
        GUMBO_NODE_COMMENT
        GUMBO_NODE_WHITESPACE
    >;

    enum GumboQuirksModeEnum is export <
        GUMBO_DOCTYPE_NO_QUIRKS
        GUMBO_DOCTYPE_QUIRKS
        GUMBO_DOCTYPE_LIMITED_QUIRKS
    >;

    enum GumboNamespaceEnum is export <
        GUMBO_NAMESPACE_HTML
        GUMBO_NAMESPACE_SVG
        GUMBO_NAMESPACE_MATML
    >;

    enum GumboParseFlags is export (
        GUMBO_INSERTION_NORMAL                           => 0,
        GUMBO_INSERTION_BY_PARSER                        => 1 +< 0,
        GUMBO_INSERT_IMPLICIT_END_TAG                    => 1 +< 1,
        GUMBO_INSERTION_IMPLIED                          => 1 +< 3,
        GUMBO_INSERTION_CONVERTED_FROM_END_TAG           => 1 +< 4,
        GUMBO_INSERTION_FROM_ISINDEX                     => 1 +< 5,
        GUMBO_INSERTION_FROM_IMAGE                       => 1 +< 6,
        GUMBO_INSERTION_RECONSTRUCTED_FORMATTING_ELEMENT => 1 +< 7,
        GUMBO_INSERTION_ADOPTION_AGENCY_CLONED           => 1 +< 8,
        GUMBO_INSERTION_ADOPTION_AGENCY_MOVED            => 1 +< 9,
        GUMBO_INSERTION_FOSTER_PARENTED                  => 1 +< 10,
    );

    class GumboDocument is repr('CStruct') is export {
        has GumboVector $.children;

        # {{{ MOARVM PADDING GumboVector
        has CArray[Pointer] $.xxx0-padding-data;
#        has uint32 $.xxx0-padding-length;
#        has uint32 $.xxx0-padding-capacity;
        # }}} MOARVM PADDING GumboVector

        has int32 $.has_doctype;
        has Str $.name;
        has Str $.public_identifier;
        has Str $.system_identifier;
        has uint32 $.doc_type_quirks_mode; # GumboQuirksModeEnum
    }

    class GumboText is repr('CStruct') is export {
        has Str $.text;
        has GumboStringPiece $.original_text is inlined;
        has GumboSourcePosition $.start_pos is inlined;
    }

    class GumboElement is repr('CStruct') is export {
        has CArray[Pointer] $.children;
        has uint32 $.children-length;
        has uint32 $.children-capacity;
        #has GumboVector $.children;

        # {{{ MOARVM PADDING GumboVector
        #has CArray[Pointer] $.xxx0-padding-data;
#        has uint32 $.xxx0-padding-length;
#        has uint32 $.xxx0-padding-capacity;
        # }}} MOARVM PADDING GumboVector

        has uint32 $.tag; # GumboTag
        has uint32 $.tag_namespace; # GumboNamespaceEnum
        has GumboStringPiece $.original_tag is inlined;

        # {{{ MOARVM PADDING GumboStringPiece
#        has Str $.xxx1-padding-data;
#        has size_t $.xxx1-padding-length;
        # }}} MOARVM PADDING GumboStringPiece

        has GumboStringPiece $.original_end_tag is inlined;

        # {{{ MOARVM PADDING GumboStringPiece
#        has Str $.xxx2-padding-data;
#        has size_t $.xxx2-padding-length;
        # }}} MOARVM PADDING GumboStringPiece

        has GumboSourcePosition $.start_pos is inlined;

        # {{{ MOARVM PADDING GumboSourcePosition
#        has uint $.xxx3-padding-line;
#        has uint $.xxx3-padding-column;
#        has uint $.xxx3-padding-offset;
        # }}} MOARVM PADDING GumboSourcePosition

        has GumboSourcePosition $.end_pos is inlined;

        # {{{ MOARVM PADDING GumboSourcePosition
#        has uint $.xxx4-padding-line;
#        has uint $.xxx4-padding-column;
#        has uint $.xxx4-padding-offset;
        # }}} MOARVM PADDING GumboSourcePosition

        has GumboVector $.attributes is inlined;
    }

    class GumboNodeV is repr('CUnion') is export {
        has GumboDocument $.document is inlined;

#        # {{{ MOARVM PADDING GumboDocument
#        has CArray[Pointer] $.xxx0-padding-data;
#        has uint32 $.xxx0-padding-length;
#        has uint32 $.xxx0-padding-capacity;
#        has int32 $.xxx0-has_doctype;
#        has Str $.xxx0-name;
#        has Str $.xxx0-public_identifier;
#        has Str $.xxx0-system_identifier;
#        has uint32 $.xxx0-doc_type_quirks_mode;
#        # }}} MOARVM PADDING GumboDocument

        has GumboElement $.element is inlined;

#        # {{{ MOARVM PADDING GumboElement
#        has CArray[Pointer] $.xxx1-padding-data;
#        has uint32 $.xxx1-padding-length;
#        has uint32 $.xxx1-padding-capacity;
#        has uint32 $.xxx1-padding-tag;
#        has uint32 $.xxx1-padding-tag_namespace;
#        has Str $.xxx1a-padding-data;
#        has size_t $.xxx1a-padding-length;
#        has Str $.xxx1b-padding-data;
#        has size_t $.xxx1b-padding-length;
#        has uint $.xxx1-padding-line;
#        has uint $.xxx1-padding-column;
#        has uint $.xxx1-padding-offset;
#        has uint $.xxx1a-padding-line;
#        has uint $.xxx1a-padding-column;
#        has uint $.xxx1a-padding-offset;
#        has CArray[Pointer] $.xxx1c-padding-data;
#        has uint32 $.xxx1c-padding-length;
#        has uint32 $.xxx1b-padding-capacity;
#        # }}} MOARVM PADDING GumboElement

        has GumboText $.text is inlined;
    }

    class GumboNode is repr('CStruct') is export {
        has uint32 $.type;       # GumboNodeType
        has GumboNode $.parent; 
        has size_t $.index_within_parent;
        has uint32 $.parse_flags; # GumboParseFlags
        has GumboNodeV $.v is inlined;

        method Pointer() { nativecast(Pointer, self) }
    }

    sub GumboVector-as-GumboNodes($data, $length --> List)
            is export {
        (^$length).map: -> $i {
            warn '# ', $data[$i].perl;
            nativecast(GumboNode, $data[$i]);
        }
    }

    class GumboOptions is repr('CStruct') is export {

        # We don't really have a way to make these callbacks do anything at
        # this point.
        has Pointer $.allocator; # (Pointer, size_t --> Pointer);
        has Pointer $.deallocator; # (Pointer, Pointer);

        # This userdata is only useful for the callbacks
        has Pointer $.userdata;

        has int32 $.tab_stop;
        has int32 $.stop_on_first_error;
        has int32 $.max_errors;
    }

    sub pGumboDefaultOptions
        returns GumboOptions
        is native(HELPER-DLL) { * }

    our $kGumboDefaultOptions is export = pGumboDefaultOptions;
    #our $kGumboDefaultOptions is export = cglobal(HELPER-DLL, 'pGumboDefaultOptions', GumboOptions);

    class GumboOutput is repr('CStruct') is export {
        has GumboNode $.document;
        has GumboNode $.root;
        has GumboVector $.errors is inlined;
    }

    sub gumbo_parse(Str $buffer)
        returns GumboOutput
        is export
        is native('libgumbo') { * }

    sub gumbo_parse_with_options(GumboOptions $options, Str $buffer, size_t $buffer_length)
        returns GumboOutput
        is export
        is native('libgumbo') { * }

    sub gumbo_destroy_output(GumboOptions $options, GumboOutput $output)
        is export
        is native('libgumbo') { * }

}
