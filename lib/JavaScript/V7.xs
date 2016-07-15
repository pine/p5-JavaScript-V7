#ifdef __cplusplus
extern "C" {
#endif

#define PERL_NO_GET_CONTEXT /* we want efficiency */
#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>

#ifdef __cplusplus
} /* extern "C" */
#endif

#define NEED_newSVpvn_flags
#include "ppport.h"
#include "xshelper.h"

#include "v7.h"
#include "v7_util.h"
#include "xs_util.h"

MODULE = JavaScript::V7    PACKAGE = JavaScript::V7

PROTOTYPES: DISABLE

void
new(...)
PPCODE:
{
    char      *class_name  = SvPV_nolen(ST(0));
    struct v7 *v7          = v7_create();
    SV        *v7_obj      = XS_PTR_TO_OBJ(v7, class_name);

    XPUSHs(v7_obj);
    XSRETURN(1);
}

void
exec(...)
PPCODE:
{
    struct v7 *v7   = XS_OBJ_TO_PTR(ST(0), struct v7*);
    char      *code = SvPV_nolen(ST(1));

    v7_val_t    result;
    enum v7_err rcode;

    rcode = v7_exec(v7, code, &result);
    if (rcode != V7_OK) {
        SV *errsv = get_sv("@", GV_ADD);
        sv_setsv(errsv, v7_get_error_sv(v7, "v7_exec", result));
        croak(NULL);
    }

    SV *result_sv = v7_val_to_sv(v7, result);
    XPUSHs(result_sv);
    XSRETURN(1);
}

void
apply(...)
PPCODE:
{
    struct v7 *v7 = XS_OBJ_TO_PTR(ST(0), struct v7*);

    if (items < 2) croak("function name is required");

    char     *func_name = SvPV_nolen(ST(1));
    v7_val_t func       = v7_get(v7, v7_get_global(v7), func_name, ~0);

    int i;
    v7_val_t args = v7_mk_array(v7);
    for (i = 2; i <= items; ++i) {
        v7_array_push(v7, args, v7_sv_to_val(v7, ST(i)));
    }

    v7_val_t    result;
    enum v7_err rcode;

    rcode = v7_apply(v7, func, V7_UNDEFINED, args, &result);
    if (rcode != V7_OK) {
        SV *errsv = get_sv("@", GV_ADD);
        sv_setsv(errsv, v7_get_error_sv(v7, "v7_apply", result));
        croak(NULL);
    }

    SV *result_sv = v7_val_to_sv(v7, result);
    XPUSHs(result_sv);
    XSRETURN(1);
}

void
DESTORY(...)
PPCODE:
{
    struct v7 *v7 = XS_OBJ_TO_PTR(ST(0), struct v7*);
    v7_destroy(v7);

    XSRETURN_UNDEF;
}
