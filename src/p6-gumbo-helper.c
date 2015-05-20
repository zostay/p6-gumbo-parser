#include <stdio.h>
#include "gumbo.h"

/*
 * This is here because MoarVM does not seem to like to reference struct values
 * with cglobal(). This can go away if/when that changes.
 */

extern const GumboSourcePosition *pGumboEmptySourcePosition() {
    return &kGumboEmptySourcePosition;
}

extern const GumboStringPiece *pGumboEmptyString() {
    return &kGumboEmptyString;
}

extern const GumboVector *pGumboEmptyVector() {
    return &kGumboEmptyVector;
}

extern const GumboOptions *pGumboDefaultOptions() {
    return &kGumboDefaultOptions;
}

