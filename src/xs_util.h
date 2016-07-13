#ifndef __JAVASCRIPT_V7_XS_UTIL__
#define __JAVASCRIPT_V7_XS_UTIL__

#define XS_PTR_TO_OBJ(x, class) \
    sv_bless( \
        sv_2mortal( \
            newRV_inc( \
                sv_2mortal( \
                    newSViv(PTR2IV(x)) \
                ) \
            ) \
        ), \
        gv_stashpv(class, 1) \
    )

#define XS_OBJ_TO_PTR(x, type) \
    INT2PTR(type, \
        SvIV( \
            SvROK(x) ? SvRV(x) : x \
        ) \
    )

#endif
