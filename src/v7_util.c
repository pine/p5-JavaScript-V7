#include "v7_util.h"

SV* v7_val_to_sv(struct v7 *v7, v7_val_t v) {
    if (v7_is_undefined(v)) {
        return sv_newmortal();
    } else if (v7_is_null(v)) {
        return sv_newmortal();
    } else if (v7_is_boolean(v)) {
        return sv_2mortal(newSViv(v7_get_bool(v7, v) ? 1 : 0));
    } else if (v7_is_number(v)) {
        double  d = v7_get_double(v7, v);
        int64_t i = (int64_t)d;

        if ((double)i == d) {
            return sv_2mortal(newSViv(i));
        } else {
            return sv_2mortal(newSVnv(d));
        }
    } else if (v7_is_string(v)) {
        size_t n;
        const char *s = v7_get_string(v7, &v, &n);
        return sv_2mortal(newSVpv(s, 0));
    } else if (v7_is_array(v7, v)) {
        return sv_newmortal(); // XXX
    } else if (v7_is_object(v)) {
        return sv_newmortal(); // XXX
    }

    return sv_newmortal(); // XXX
}

v7_val_t v7_sv_to_val(struct v7 *v7, SV *sv) {
    if (!SvOK(sv)) {
        return V7_NULL;
    } else if (SvIOK(sv)) {
        return v7_mk_number(v7, (double)SvIVX(sv));
    } else if (SvNOK(sv)) {
        return v7_mk_number(v7, SvNVX(sv));
    } else if (SvPOK(sv)) {
        return v7_mk_string(v7, SvPV_nolen(sv), ~0, 1);
    }

    // XXX

    return V7_NULL;
}

SV* v7_get_error_sv(struct v7 *v7, const char *ctx, v7_val_t e) {
  if (v7_is_undefined(e)) {
    return sv_2mortal(newSVpvf("undefined error [%s]\n ", ctx));
  }
  v7_val_t msg = v7_get(v7, e, "message", ~0);
  if (v7_is_undefined(msg)) {
    msg = e;
  }

  SV *result = sv_2mortal(newSVpvf("Exec error [%s]: ", ctx));
  sv_cat_val(v7, result, msg);
  sv_catpvs(result, "\n");
  sv_cat_stack_trace(v7, result, e);
  return result;
}

void sv_cat_val(struct v7 *v7, SV *dstr, v7_val_t sstr) {
  char buf[16];
  char *s = v7_stringify(v7, sstr, buf, sizeof(buf), V7_STRINGIFY_DEBUG);
  sv_catpv(dstr, s);
  if (buf != s) free(s);
}

void sv_cat_stack_trace(struct v7 *v7, SV *dstr, v7_val_t e) {
  size_t s;
  v7_val_t strace_v = v7_get(v7, e, "stack", ~0);
  const char *strace = NULL;
  if (v7_is_string(strace_v)) {
    strace = v7_get_string(v7, &strace_v, &s);
    sv_catpv(dstr, strace);
  }
}

