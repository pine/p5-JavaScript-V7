#ifndef __JAVASCRIPT_V7_UTIL__
#define __JAVASCRIPT_V7_UTIL__

#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#include "ppport.h"
#include "xshelper.h"

#include "v7.h"

SV *v7_val_to_sv(struct v7 *v7, v7_val_t v);
v7_val_t v7_sv_to_val(struct v7 *v7, SV *sv);

SV* v7_get_error_sv(struct v7 *v7, const char *ctx, v7_val_t e);

void sv_cat_val(struct v7 *v7, SV *dstr, v7_val_t sstr);
void sv_cat_stack_trace(struct v7 *v7, SV *dstr, v7_val_t e);

#endif
