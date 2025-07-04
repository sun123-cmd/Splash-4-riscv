#	$Header: /usr/people/sam/tiff/libtiff/RCS/Makefile.sgi,v 1.44 92/02/19 14:25:29 sam Exp $
#
# Tag Image File Format Library
#
# Copyright (c) 1988, 1989, 1990, 1991, 1992 Sam Leffler
# Copyright (c) 1991, 1992 Silicon Graphics, Inc.
# 
# Permission to use, copy, modify, distribute, and sell this software and 
# its documentation for any purpose is hereby granted without fee, provided
# that (i) the above copyright notices and this permission notice appear in
# all copies of the software and related documentation, and (ii) the names of
# Sam Leffler and Silicon Graphics may not be used in any advertising or
# publicity relating to the software without the specific, prior written
# permission of Stanford and Silicon Graphics.
# 
# THE SOFTWARE IS PROVIDED "AS-IS" AND WITHOUT WARRANTY OF ANY KIND, 
# EXPRESS, IMPLIED OR OTHERWISE, INCLUDING WITHOUT LIMITATION, ANY 
# WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  
# 
# IN NO EVENT SHALL SAM LEFFLER OR SILICON GRAPHICS BE LIABLE FOR
# ANY SPECIAL, INCIDENTAL, INDIRECT OR CONSEQUENTIAL DAMAGES OF ANY KIND,
# OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
# WHETHER OR NOT ADVISED OF THE POSSIBILITY OF DAMAGE, AND ON ANY THEORY OF 
# LIABILITY, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE 
# OF THIS SOFTWARE.
#
DESTDIR=/usr/local
#
# RISC-V 交叉编译配置
RISCV_PREFIX ?= riscv64-linux-gnu-
CC := $(RISCV_PREFIX)gcc
AR := $(RISCV_PREFIX)ar
NULL=

IPATH=	-I.
#
# Library-wide configuration defines:
#    MMAP_SUPPORT	add support for memory mapping read-only files
#    COLORIMETRY_SUPPORT add support for 6.0 colorimetry tags
#    JPEG_SUPPORT	add support for 6.0 JPEG tags & JPEG algorithms
#    YCBCR_SUPPORT	add support for 6.0 YCbCr tags
#    CMYK_SUPPORT	add support for 6.0 CMYK tags
#
# Compression configuration defines:
#    CCITT_SUPPORT	add support for CCITT Group 3 & 4 algorithms
#    PACKBITS_SUPPORT	add support for Macintosh PackBits algorithm
#    LZW_SUPPORT	add support for LZW algorithm
#    THUNDER_SUPPORT	add support for ThunderScan 4-bit RLE algorithm
#    NEXT_SUPPORT	add support for NeXT 2-bit RLE algorithm
#    JPEG_SUPPORT	add support for JPEG DCT algorithm
#
# Note that if you change the library-wide configuration, you'll
# need to manual force a full rebuild.  Changing the configuration
# of which compression algorithms are included in the library is
# automatically handled (i.e. tif_compress.o has a dependency on
# the Makefile).
#
CONF_COMPRESSION=\
	-DPACKBITS_SUPPORT \
	-DLZW_SUPPORT \
	-DCCITT_SUPPORT \
	-DTHUNDER_SUPPORT  \
	-DNEXT_SUPPORT  \
	${NULL}
CONF_LIBRARY=\
	-DUSE_VARARGS=0 \
	-DUSE_PROTOTYPES=1 \
	-DHAVE_IEEEFP=1 \
	-DCOLORIMETRY_SUPPORT \
	-DJPEG_SUPPORT \
	-DYCBCR_SUPPORT \
	-DCMYK_SUPPORT \
	-DMMAP_SUPPORT \
	${NULL}
CFLAGS=	-O ${IPATH} ${CONF_LIBRARY} -ansi -fPIC
#
INCS=	tiff.h tiffio.h
SRCS=	tif_fax3.c \
	tif_fax4.c \
	tif_aux.c \
	tif_ccittrle.c \
	tif_close.c \
	tif_compat.c \
	tif_compress.c \
	tif_dir.c \
	tif_dirinfo.c \
	tif_dirread.c \
	tif_dirwrite.c \
	tif_dumpmode.c \
	tif_error.c \
	tif_getimage.c \
	tif_jpeg.c \
	tif_flush.c \
	tif_lzw.c \
	tif_next.c \
	tif_open.c \
	tif_packbits.c \
	tif_print.c \
	tif_read.c \
	tif_swab.c \
	tif_strip.c \
	tif_thunder.c \
	tif_tile.c \
	tif_version.c \
	tif_warning.c \
	tif_write.c \
	${NULL}
OBJS=	tif_fax3.o \
	tif_fax4.o \
	tif_aux.o \
	tif_ccittrle.o \
	tif_close.o \
	tif_compat.o \
	tif_compress.o \
	tif_dir.o \
	tif_dirinfo.o \
	tif_dirread.o \
	tif_dirwrite.o \
	tif_dumpmode.o \
	tif_error.o \
	tif_getimage.o \
	tif_jpeg.o \
	tif_flush.o \
	tif_lzw.o \
	tif_next.o \
	tif_open.o \
	tif_packbits.o \
	tif_print.o \
	tif_read.o \
	tif_swab.o \
	tif_strip.o \
	tif_thunder.o \
	tif_tile.o \
	tif_version.o \
	tif_warning.o \
	tif_write.o \
	${NULL}
ALL=	libtiff.a

all:	 ${ALL}

${ALL}:	${OBJS}
	${AR} rc libtiff.a $?

${OBJS}: tiff.h tiffcompat.h tiffioP.h
tif_compress.o: tif_compress.c Makefile
	${CC} -c ${CFLAGS} ${CONF_COMPRESSION} tif_compress.c
tif_fax3.o: tif_fax3.c g3states.h t4.h tif_fax3.h

g3states.h: mkg3states.c t4.h
	${CC} -o mkg3states ${CFLAGS} -static mkg3states.c
	./mkg3states -c > g3states.h

install: all installh
	-for i in ${ALL}; do \
		${INSTALL} -c -m 644 $$i ${DESTDIR}/lib/$$i; \
	done

installh: ${INCS}
	-for i in ${INCS}; do \
	    h=`basename $$i`; \
	    cmp -s $$i ${DESTDIR}/include/$$h || \
	        ${INSTALL} -c -m 444 $$i ${DESTDIR}/include/$$h; \
	done

clean:
	rm -f ${ALL} ${OBJS} core a.out mkg3states g3states.h
 
tags:	${SRCS}
	${CTAGS} ${SRCS}
