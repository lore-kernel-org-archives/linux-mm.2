Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32F56C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 07:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001146B0645; Fri, 14 Aug 2026 03:51:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22446B0647; Fri, 14 Aug 2026 03:51:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE2C06B0648; Fri, 14 Aug 2026 03:51:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7B7D6B0645
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:51:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 14F711A03BF
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:51:21 +0000 (UTC)
X-FDA: 85099104762.10.31B5FD2
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3862C140004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:51:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gOdg93Eu;
	spf=pass (imf09.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786693879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Tw7QssqNwPoq9ncdKoV/ppucaSKUcHYQcUv1PyBsN0=;
	b=LUAa7OtbyOilHUqLMFYaSBs8cm+qglD/9akiTerJdiwhezbnXsK6xberWXUV6CbZSN1Dnc
	5DAdT2HulcOPyDFmB44aqnDMubS98FRV+SFn2BV/Q3oMf7rpZQFz+d5EusgYO/KJLxdCth
	ZdtZI6AYokpdYjmPTM0D1FjIkaquuC8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gOdg93Eu;
	spf=pass (imf09.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786693879;
	b=5aKNRd8Ele3pjT/sbmwXUCP/3gUXmhgiqQtr3IX4L3fsRPiuF0HFA1qWE3x85qww/8BQbt
	Lh9leXlk8do8j4EeXNJsQZ12osGVD8WlDSqEQqZVyPzaXM57sVnURkEj9ekf36O2TTv5j1
	/fiOg47IgSENNvE5TA9T+tJ0Lv4AQ00=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cbedf318752so438527a12.0
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 00:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786693878; x=1787298678; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7Tw7QssqNwPoq9ncdKoV/ppucaSKUcHYQcUv1PyBsN0=;
        b=gOdg93Eu19jjvVJkJ78/ABMXD560x4q3QEOJ8T3FMgF4rj3ayrm2Yxl9V+L9JDi/5+
         Gh1RqA+8HMQMR/ETGSOP+k73likZ4XEYtB+vdrAQPUoMHnxiSG9gsfiKckUwIvAEZ3Bx
         jxBqQmWy6MpnKlGSlPNGJaoEJ0cOm+me5B+624vpG8226giUKB3N7veKd7umADb5YH9R
         8kSPZ1r/eFzm2lY2IjHgzQ5lbzsiBfoAiQzTiCeMjcESWoMLf85EE7ROuF+dBmWXwQ4v
         rsZ9Ybe39eBwSxDbj3p5cefAPjUR3mWKjtpTm6tZYh6UP5lmj1+W24/rrVNUikVAprES
         en1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786693878; x=1787298678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7Tw7QssqNwPoq9ncdKoV/ppucaSKUcHYQcUv1PyBsN0=;
        b=hp9vWfCcVle64Y9jcWf9YKlX8DrU75Ce7Fa2n46zk2/GotREybE8QORut77Mw3ROEJ
         Cj/2qiST8Z0VhTYaq/YUmPidpU3l+vXfgktQtZjmwWRwLxqAQeoaY6G49OhHWN0gAaCJ
         GvzjCP56ZlSmTLTu0tby2fHhpBeqh1h6N+fN/fUHnjgoU3W8mdlhl+75y28++29EQRcT
         TQoxtrn+uTsRkMp5d9xZ87wNNWyPCtKeaJWSuhm4md7Fk08Fa4B9sIHOPurAzLgvQN69
         kGzc/8OEmVEyoxt/CQIT88PZJMV4xN8kEn2h9muJO7QNKd8iko3J66xDzbO3e2eOjFKQ
         4ezw==
X-Forwarded-Encrypted: i=1; AHgh+RpjNWEyYi4Eu95zR0keeFp8pBs3s2kExzVMDTEEuAgRpMdlwxcL5ZADWsnu5ognIAytc/emkGESRA==@kvack.org
X-Gm-Message-State: AOJu0Yz/5iPayUPJbL1zVtyGvJ5iHfVNmxfDs3HiSr937ndZoOQ/M/2e
	HHiUKGynWUBemP8nPC7fwpkOJPAxtfwpIDAEsojxnn8w9JrRQp6d35e7
X-Gm-Gg: AR+sD11ZL0ttAZ36i8abQqWA85/YxTFeH3EHK0aarStjWuNCyZsAjw3THDeQqB9nv0y
	DL43sNEQwCuwJZiGVJsNdrH/Cnv9b0V85FkkL1Frpq4XJ17OGLbYcLXZYf/ni7XXH2DbmHmxHI0
	rwZP8mmxvAxtu13GR4X6HcBTdKd7EEMTtoEOuUyQEacYgNdSTqFrTsIjRoB60P26v4TgNP7Ac5L
	82E5DlfIVA5mfrGOzM29eW7LiHBSur5kyaS6B6Pj+jPsge8TttsWRdDl2+RUiQJMwzyRGoq8wxs
	1UhFjUgmht5uZD3y8bbmOZtZfZ+5JAOalbSVQ0gX5oczKCgdvrZErmEruq4nNZ3bJJBiCvoKrUn
	dh79y1uyBKmtrIJN6THaPi5fKlm72Wzd/5sYEI/akVXOJla5btPOLYl41G1TCBreNVLf5IF2chl
	WwcAdqtMzowGjQ10GAyUqT6ABZBuV/jrM5IZ4wcZGNy+DZz27z/silsLk=
X-Received: by 2002:a05:6a20:cd90:b0:3bf:c28f:8afc with SMTP id adf61e73a8af0-3cc71707793mr4594413637.0.1786693877991;
        Fri, 14 Aug 2026 00:51:17 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:74::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320ea302649sm1331437eec.24.2026.08.14.00.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 00:51:17 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	David Vernet <void@manifault.com>,
	Eduard Zingerman <eddyz87@gmail.com>
Cc: Viktor Malik <vmalik@redhat.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Ziyang Men <ziyang.meme@gmail.com>,
	kernel-team@meta.com,
	linux-kselftest@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-input@vger.kernel.org,
	sched-ext@lists.linux.dev,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] selftests/sched_ext: build BPF schedulers via the shared lib.bpf.mk
Date: Fri, 14 Aug 2026 00:50:54 -0700
Message-ID: <20260814075054.507089-5-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260814075054.507089-1-ziyang.meme@gmail.com>
References: <20260814075054.507089-1-ziyang.meme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3862C140004
X-Stat-Signature: oan4rcnxw8eb4kjg3n4wb6nckfdzcnm6
X-Rspam-User: 
X-HE-Tag: 1786693879-3392
X-HE-Meta: U2FsdGVkX18nTyQj1c71QFsXm/DAs8IjGhiTIJgOysUR02XH5w0dFM8gdcFxspDc+ci2v44o/s6lui+smpfUyo9qQxt+T2omdM4n0L+UyCQJty7+mF0KGoU/NBJnXAU/7w7ATcheMosUtQoLbduwMz7G76EexAVGMh0lpHFxApcv7agiZceEfWof+UYFGKMWMuA71blwSRLKsEt3Z9+K6K9dKQ0Vl8XG8s8b8Izcwum8dUtZr1rRlCp5gNkzF8Rc64+HwgUyosQUGNvKmqOzG2oaNA3xl1LHLMwz5+PtB24HuWv1QBmF2nHV1a2jTREH6Cbm9J4dOQpyCADgneQJ4ET7v61aovfSVnR+HDiJJ7gYqst434xCtYImc62NBnz99TAahCrwzP4eM6BkVXA9Cjr2B9k068qvEshHgcAKz04/4ApUVub0bJlCMdDkRDiA3rfWMvpIYc/EL28/Y9I4T+16mWQJtqF9HpeTQnbvu8wl6WHQ4srjM+xi6301fjr9gPlWi6n+Z8i9HslQvr0/aMNX/ss66D2N2r+QavAwHkAJSTx10GXYpecB3m39iGAuevUTPgab4wynQ/f7HZnlJRS7PfUpOOeO/X0/NRPlpCVy90GqDc2HWKA5qEYWSS/Io6okG4NeQipMjmWWQhHRr5eFXhmW7lFWe28EOMrkDI/nGD9DjyddKcge3IL4ryToBW8P2qejROk1TSrfL4Q+J014QxHSSYP/FXPhV5k4BDbCpgNGsRwb2lxLOaePRwv/SLTYb9Iv6p5cmiS6puZydU6VasUeXp/FjpnjI2y1Z5t2D+duZHIJLXritWtMG+CK8OvnetBURkInTflgCKjY1xMEkW4k5sxYRTfTEkENEwsptZvwcVHa839AZhIXpNQ8LmWbEIBLkFoLTsKNIJmQRAj0X4V02PXWK/pjZ1PeraDuTyHNjA6xLBiMKfJjzTsu2o2+Hf1E4OFXpWJGeFi
 5T2F6GW/
 DYKmYPozxPg6QsjSE9t5ibbkxdOBV6mEHgfK8dm+pxjECcqtCpMm9SNePGlXgli/Rn6cKlljpjc3qXxrc0i6mk4cJunBRAgiXbTCO3HG11MSbLcr7uDnsRe9uXB9ROf0vYf/mOKFdMHTRw1E0BOBkANBc66DD5GBmEF3x4MU5Ui6OB3+4qBkd8KVAwGn5B3qiHzXqAwL5qlSaW1E8T2LpyWhan79D+6BrP1A6eIY+ucRnzBr3YvjP7PwyKrOJZoczCxS3kmmoqajQVt2l4bEQmBMgc2GmDcWG2OUbOT4CrJi0vDzxTtEW67pATfvx52Q8SSoCPBFAixyoCEEaaxdtePyF/VEQqPgdufvllG0vfEwpZbq1HFV3LdaLS4ogIgLjNLYP8O8eTB2aN3/1MKBfr2HfKB/CEUKKieOrd+4tq5/F1eO89Td8vot4b9fDUlFgRUvcW5Nza1IrHdzBtrU1tjWbE5UiCst/uKvhNXxpN/U//+jyRxow4/itLCEXQ+INk0vPuwg1oPup2lh9/Fnm9a2VSS0Z9nhYIAFUyzbcbeO3Mv975BYOxsKvmixJPNxezqm69sQmcKkirpewsWf2iaXXvehb4etJbjxEdMj9jzbterbpnZktZ0pW893kEmLT70sziGpR8QuHV8HtSonEe7ppVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sched_ext carried its own ~130 lines of libbpf + bpftool + vmlinux.h +
BPF-object + skeleton build machinery.  Replace it with an include of the
shared tools/testing/selftests/lib.bpf.mk, making sched_ext the third
in-tree consumer of that fragment, after selftests/cgroup and
selftests/hid.

All 28 skeletons and 28 subskeletons keep a same public API before and
after, the runner builds and links the same way.

Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
Suggested-by: Mykola Lysenko <mykolal@meta.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/sched_ext/Makefile | 146 +++++----------------
 1 file changed, 30 insertions(+), 116 deletions(-)

diff --git a/tools/testing/selftests/sched_ext/Makefile b/tools/testing/selftests/sched_ext/Makefile
index 5d2dffca0e91..620e8cb31e6f 100644
--- a/tools/testing/selftests/sched_ext/Makefile
+++ b/tools/testing/selftests/sched_ext/Makefile
@@ -14,48 +14,32 @@ CURDIR := $(abspath .)
 REPOROOT := $(abspath ../../../..)
 TOOLSDIR := $(REPOROOT)/tools
 LIBDIR := $(TOOLSDIR)/lib
-BPFDIR := $(LIBDIR)/bpf
 TOOLSINCDIR := $(TOOLSDIR)/include
-BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
 APIDIR := $(TOOLSINCDIR)/uapi
 GENDIR := $(REPOROOT)/include/generated
 GENHDR := $(GENDIR)/autoconf.h
-SCXTOOLSDIR := $(TOOLSDIR)/sched_ext
 SCXTOOLSINCDIR := $(TOOLSDIR)/sched_ext/include
 
-OUTPUT_DIR := $(OUTPUT)/build
-OBJ_DIR := $(OUTPUT_DIR)/obj
-INCLUDE_DIR := $(OUTPUT_DIR)/include
-BPFOBJ_DIR := $(OBJ_DIR)/libbpf
-SCXOBJ_DIR := $(OBJ_DIR)/sched_ext
-BPFOBJ := $(BPFOBJ_DIR)/libbpf.a
-LIBBPF_OUTPUT := $(OBJ_DIR)/libbpf/libbpf.a
-
-DEFAULT_BPFTOOL := $(OUTPUT_DIR)/host/sbin/bpftool
-HOST_OBJ_DIR := $(OBJ_DIR)/host/bpftool
-HOST_LIBBPF_OUTPUT := $(OBJ_DIR)/host/libbpf/
-HOST_LIBBPF_DESTDIR := $(OUTPUT_DIR)/host/
-HOST_DESTDIR := $(OUTPUT_DIR)/host/
-
-VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)					\
-		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)		\
-		     ../../../../vmlinux					\
-		     /sys/kernel/btf/vmlinux					\
-		     /boot/vmlinux-$(shell uname -r)
-VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
-ifeq ($(VMLINUX_BTF),)
-$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
-endif
+# The schedulers are built by ../lib.bpf.mk: modern *.bpf.c layout, a
+# .bpf.skel.h suffix, and subskeletons.
+BPF_SRCS        := $(wildcard *.bpf.c)
+BPF_SKEL_EXT    := .bpf.skel.h
+BPF_GEN_SUBSKEL := 1
+# Keep the generated files under build/ as before.  SCXOBJ_DIR (userspace
+# objects) reuses the BPF object dir.
+BPF_OBJ_DIR  := $(OUTPUT)/build/obj/sched_ext
+BPF_SKEL_DIR := $(OUTPUT)/build/include
+SCXOBJ_DIR   := $(BPF_OBJ_DIR)
 
-BPFTOOL ?= $(DEFAULT_BPFTOOL)
+include ../lib.bpf.mk
 
 ifneq ($(wildcard $(GENHDR)),)
   GENFLAGS := -DHAVE_GENHDR
 endif
 
 CFLAGS += -g -O2 -rdynamic -pthread -Wall -Werror $(GENFLAGS)			\
-	  -I$(INCLUDE_DIR) -I$(GENDIR) -I$(LIBDIR)				\
-	  -I$(TOOLSINCDIR) -I$(APIDIR) -I$(CURDIR)/include -I$(SCXTOOLSINCDIR)
+	  -I$(GENDIR) -I$(LIBDIR) -I$(TOOLSINCDIR) -I$(APIDIR)			\
+	  -I$(CURDIR)/include -I$(SCXTOOLSINCDIR)
 
 # Silence some warnings when compiled with clang
 ifneq ($(LLVM),)
@@ -64,102 +48,30 @@ endif
 
 LDFLAGS = -lelf -lz -lpthread -lzstd
 
-IS_LITTLE_ENDIAN = $(shell $(CC) -dM -E - </dev/null |				\
-			grep 'define __BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__')
-
-# Get Clang's default includes on this system, as opposed to those seen by
-# '-target bpf'. This fixes "missing" files on some architectures/distros,
-# such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
-#
-# Use '-idirafter': Don't interfere with include mechanics except where the
-# build would have failed anyways.
-define get_sys_includes
-$(shell $(1) $(2) -v -E - </dev/null 2>&1 \
-	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
-$(shell $(1) $(2) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
-endef
-
-ifneq ($(CROSS_COMPILE),)
-CLANG_TARGET_ARCH = --target=$(notdir $(CROSS_COMPILE:%-=%))
-endif
-
-CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
-
-BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH)					\
-	     $(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)		\
+# The schedulers need scheduler-specific includes, so override BPF_CFLAGS
+# wholesale and keep the flag set this directory used, rather than pin -Werror
+# across clang versions.  The recipe adds -O2/--target/-mcpu.
+BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)				\
 	     -I$(CURDIR)/include -I$(CURDIR)/include/bpf-compat			\
 	     -I$(INCLUDE_DIR) -I$(APIDIR) -I$(SCXTOOLSINCDIR)			\
 	     -I$(REPOROOT)/include						\
-	     $(CLANG_SYS_INCLUDES) 						\
+	     $(CLANG_SYS_INCLUDES)						\
 	     -Wall -Wno-compare-distinct-pointer-types				\
 	     -Wno-incompatible-function-pointer-types				\
 	     -Wno-microsoft-anon-tag						\
 	     -fms-extensions							\
-	     -O2 -mcpu=v3
-
-# sort removes libbpf duplicates when not cross-building
-MAKE_DIRS := $(sort $(OBJ_DIR)/libbpf $(OBJ_DIR)/libbpf				\
-	       $(OBJ_DIR)/bpftool $(OBJ_DIR)/resolve_btfids			\
-	       $(HOST_OBJ_DIR) $(INCLUDE_DIR) $(SCXOBJ_DIR))
-
-$(MAKE_DIRS):
-	$(call msg,MKDIR,,$@)
-	$(Q)mkdir -p $@
-
-$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)			\
-	   $(APIDIR)/linux/bpf.h						\
-	   | $(OBJ_DIR)/libbpf
-	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(OBJ_DIR)/libbpf/	\
-		    ARCH=$(ARCH) CC="$(CC)" CROSS_COMPILE=$(CROSS_COMPILE)	\
-		    EXTRA_CFLAGS='-g -O0 -fPIC'					\
-		    DESTDIR=$(OUTPUT_DIR) prefix= all install_headers
-
-$(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)	\
-		    $(LIBBPF_OUTPUT) | $(HOST_OBJ_DIR)
-	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)				\
-		    ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD)		\
-		    EXTRA_CFLAGS='-g -O0'					\
-		    OUTPUT=$(HOST_OBJ_DIR)/					\
-		    LIBBPF_OUTPUT=$(HOST_LIBBPF_OUTPUT)				\
-		    LIBBPF_DESTDIR=$(HOST_LIBBPF_DESTDIR)			\
-		    prefix= DESTDIR=$(HOST_DESTDIR) install-bin
-
-$(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL) | $(INCLUDE_DIR)
-ifeq ($(VMLINUX_H),)
-	$(call msg,GEN,,$@)
-	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
-else
-	$(call msg,CP,,$@)
-	$(Q)cp "$(VMLINUX_H)" $@
-endif
+	     $(BPF_EXTRA_CFLAGS)
 
-$(SCXOBJ_DIR)/%.bpf.o: %.bpf.c $(INCLUDE_DIR)/vmlinux.h	| $(BPFOBJ) $(SCXOBJ_DIR)
-	$(call msg,CLNG-BPF,,$(notdir $@))
-	$(Q)$(CLANG) $(BPF_CFLAGS) -target bpf -c $< -o $@
-
-$(INCLUDE_DIR)/%.bpf.skel.h: $(SCXOBJ_DIR)/%.bpf.o $(INCLUDE_DIR)/vmlinux.h $(BPFTOOL) | $(INCLUDE_DIR)
-	$(eval sched=$(notdir $@))
-	$(call msg,GEN-SKEL,,$(sched))
-	$(Q)$(BPFTOOL) gen object $(<:.o=.linked1.o) $<
-	$(Q)$(BPFTOOL) gen object $(<:.o=.linked2.o) $(<:.o=.linked1.o)
-	$(Q)$(BPFTOOL) gen object $(<:.o=.linked3.o) $(<:.o=.linked2.o)
-	$(Q)diff $(<:.o=.linked2.o) $(<:.o=.linked3.o)
-	$(Q)$(BPFTOOL) gen skeleton $(<:.o=.linked3.o) name $(subst .bpf.skel.h,,$(sched)) > $@
-	$(Q)$(BPFTOOL) gen subskeleton $(<:.o=.linked3.o) name $(subst .bpf.skel.h,,$(sched)) > $(@:.skel.h=.subskel.h)
+EXTRA_CLEAN += $(OUTPUT)/build
 
 ################
 # C schedulers #
 ################
 
-override define CLEAN
-	rm -rf $(OUTPUT_DIR)
-	rm -f $(TEST_GEN_PROGS)
-endef
-
-# Every testcase takes all of the BPF progs are dependencies by default. This
+# Every testcase takes all of the BPF progs as dependencies by default. This
 # allows testcases to load any BPF scheduler, which is useful for testcases
 # that don't need their own prog to run their test.
-all_test_bpfprogs := $(foreach prog,$(wildcard *.bpf.c),$(INCLUDE_DIR)/$(patsubst %.c,%.skel.h,$(prog)))
+all_test_bpfprogs := $(BPF_SKELS)
 
 auto-test-targets :=			\
 	create_dsq			\
@@ -195,7 +107,8 @@ auto-test-targets :=			\
 testcase-targets := $(addsuffix .o,$(addprefix $(SCXOBJ_DIR)/,$(auto-test-targets)))
 
 $(SCXOBJ_DIR)/runner.o: runner.c | $(SCXOBJ_DIR) $(BPFOBJ)
-	$(CC) $(CFLAGS) -c $< -o $@
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) -c $< -o $@
 
 # Create all of the test targets object files, whose testcase objects will be
 # registered into the runner in ELF constructors.
@@ -204,15 +117,16 @@ $(SCXOBJ_DIR)/runner.o: runner.c | $(SCXOBJ_DIR) $(BPFOBJ)
 # compiling BPF object files only if one is present, as the wildcard Make
 # function doesn't support using implicit rules otherwise.
 $(testcase-targets): $(SCXOBJ_DIR)/%.o: %.c $(SCXOBJ_DIR)/runner.o $(all_test_bpfprogs) | $(SCXOBJ_DIR)
-	$(eval test=$(patsubst %.o,%.c,$(notdir $@)))
-	$(CC) $(CFLAGS) -c $< -o $@
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) -c $< -o $@
 
 $(SCXOBJ_DIR)/util.o: util.c | $(SCXOBJ_DIR)
-	$(CC) $(CFLAGS) -c $< -o $@
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) -c $< -o $@
 
 $(OUTPUT)/runner: $(SCXOBJ_DIR)/runner.o $(SCXOBJ_DIR)/util.o $(BPFOBJ) $(testcase-targets)
-	@echo "$(testcase-targets)"
-	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
+	$(call msg,BINARY,,$@)
+	$(Q)$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
 
 .DEFAULT_GOAL := all
 
-- 
2.53.0-Meta


