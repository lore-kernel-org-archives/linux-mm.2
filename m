Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 607EEC79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 576116B0099; Thu, 10 Sep 2026 19:33:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D6B6B009B; Thu, 10 Sep 2026 19:33:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43D156B009D; Thu, 10 Sep 2026 19:33:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 055AF6B0099
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:33:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 56C711605FE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:33:40 +0000 (UTC)
X-FDA: 85199457000.10.52B4D37
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 87A9340007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:33:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fQQOub9B;
	spf=pass (imf17.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789083218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKqFigUfUBeSnFW0KPe67v5MSiJ+XREL1Pj3ehWoLGc=;
	b=hjFY+8gknKU8De/n3QC4POpzRLvC+1xrvOqHMiwLf5AMv2Ttb4wS0Vr/tZJ0MBgsI7OpOf
	KT0jslEShLgXxAueXmnDSJ1XWrzl9p7ax5+11aaKhooDCPpZx3kYQoQViziXKHV5LQy0Of
	IL0B3jYxbMNUxJs4+f7eocxQLGYxnX4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fQQOub9B;
	spf=pass (imf17.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789083218;
	b=PeMNmYZ61x31Ii0lHx2XoixoUx7XnCSipn5yGegDMAzIJzHUDbSIhvnc/ZkvKjadpnTRNy
	XetnBNpoWgYYie+ZXByqRB/EH4i3vfXAjSBqunWVh61DFcy/TFLFdKj6e43T7dC4IIrT6E
	V4/S1Klbp6bhYYvhOMC5vqDiyoUcKZM=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-398e9698a70so355170a91.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789083217; x=1789688017; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uKqFigUfUBeSnFW0KPe67v5MSiJ+XREL1Pj3ehWoLGc=;
        b=fQQOub9BttOipPc43517PfE8IPq21kB1VOHWfswd508FuoPgyXUg1xyae1G1DUE3Fb
         a0m5AKh6y3n+8hl44G+d8zuY6Vf+8GcjLgFncpTYWu514w3m75a/QqoXgI2PUpTcEV3i
         uuXQI3xkL6GNChkGrrhqxSVnqEtvpUI/TRJoK39ctrG90X8FwtislZDmjOiwln7Eo4eM
         fGX2o775yAjF+iHHzjV4X4YHXTTselNI93RrfHT3hjdfMJNLwQ2jD/8xslO2fNm+EVtR
         RHuwbKldNA2sJFz8oHZGtvCZlZ/A9Ex1bUgD2Xb7QiK3fdIHH/cmFJiDPncGTE3qd/lB
         ow6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789083217; x=1789688017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uKqFigUfUBeSnFW0KPe67v5MSiJ+XREL1Pj3ehWoLGc=;
        b=EzVUhieSxGRDHnC2Xkh1kQvkf0lHYhO45v+B/2J6jD1xJPLEtShhnaIuuqvlzt+Y5I
         pVXsegUSt1KzAokEXZv2vXcdgddE1xiWdPJoCuebLoTvEbQGfHCwEfPUw59OGJah72KH
         KLntevl0ydSmfUC2IxaK+gS17Pq3u1fuNw0pHz2ahogPpTYsrECaiEyAPGrq9W/7GPza
         i5bJLaoAgYyhpKzR2mldNjJJuDY/O8vjOLCl78e7cUJS1+393k66P84lTdrl9woKlu79
         +EOWsHmGwlWwCMRoS6ZNHJja3IvwzqkXh6g9LZ3pxCsTgeEVXs8rh2KZv0nMcMXRNuX+
         6Z4A==
X-Forwarded-Encrypted: i=1; AKwUvBxgqrXl1UpISThPSexLlpWH8sOIisbRJ6q3nxNpuF3fmcudsNs2z4pSzpdd1dU1z1csyQdGR8h1hw==@kvack.org
X-Gm-Message-State: AFuF++m4Y+vwa6EXITlXoMK427LPmERuhs0X0pibzxbyyUONbqgob1TX
	jefCNn4ijlNYxTLQoNbEiS6WpQwegkidx5iOD1UxKtSRRmVv+iwJHf+B
X-Gm-Gg: AYBFou10uSguiHTfL3Z9xgkXQbT9KZCR5rLt7tiCNSNdEISfufJ2XKYltLq32yDUahR
	xLZX6R28ZIlrT6Wxpe8wh9KQ57jItZgRV0TIJ4HdbUXb+hkQu0Qxv8i7ciXieDC1aHlqkViHLv9
	HAU/EDCZodPQ41MXcuR+FZxyeSA3TvDdZ5O37eKY3ivmBwkN98MsnYAtKnfJVfW61eALmIxyZd+
	GvfmFkspWU7IaJ5ikC1ufpMXnSNi18PQ4z/OsF0+bLemyJuTWayDcMMnVYGU0yIyzmAeDJRm/Na
	509alu7sdqmZMPkpiyMY67qtxxdD3E8J86SsTlv2/YgXXd4mlKlGYA0swBM2oYHzBmZzWKN6Oy8
	CjZYyXyXFVpn8FoDD+rSy87Hh296VstBoSnUYlRTcKXjJoWZm9mfYxUZvoaTPWPnPDsxWG/v60c
	UU3dQhdvAzE5AHm7VrqPRapz6L/JbxFnRoj+sUSsuFu9sNCFpbFcw717kqlKebnvGqsbr3d8FLs
	tLh
X-Received: by 2002:a17:90b:4cce:b0:38e:7168:281 with SMTP id 98e67ed59e1d1-39d9bec4d91mr1889561a91.10.1789083217212;
        Thu, 10 Sep 2026 16:33:37 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:43::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14365b97994sm2817540c88.12.2026.09.10.16.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 16:33:36 -0700 (PDT)
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
Subject: [PATCH v5 4/4] selftests/sched_ext: build BPF schedulers via the shared lib.bpf.mk
Date: Thu, 10 Sep 2026 16:33:03 -0700
Message-ID: <20260910233303.1063501-5-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260910233303.1063501-1-ziyang.meme@gmail.com>
References: <20260910233303.1063501-1-ziyang.meme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 87A9340007
X-Stat-Signature: f3os6746gd1r5rnjfqwmm31ehjj3idqz
X-Rspam-User: 
X-HE-Tag: 1789083218-379298
X-HE-Meta: U2FsdGVkX18+PHGSx5AHrIcn4bQmwHEfFaHYAJ12q6GvaRCCb8apB1iNketDnlOd502TmnUcWEHKWIQJIXfZF1VuS1zHCYUG+nJEERhNovGt0poZXBv/YcLqtBTsPyjDGwpxbSt4Jm+PPq1204T1TfRtCbcOrFlv7rgTL9GiGXha1mlSj7UAUNzQYFzVFadi4GITbrQjF3JiOl6i8j7QpMPlBr+7MSP0xfJIq5uIwLIH12pEYnJzp4OmXhv1fvKuvqRAjDPjskNFVrPmWBYGWqDvddG4z/lmfWsSXplSn87whP6SZGqIIchbR28NBHDyiyC5hkKe/tbB0YS3nBH0HLKo+1K8FQDhLjlXUtc0oD8t/uOU/c6EYGZR77yThn+EyL6wp4xoKC+smHf/0qS3qYA6FKgsN7uZJWOHNK4SddgOdctBPmCENBpwiXMt6nzVAkTgyIg6Kdx/eqhRjzclZuhPEIYm451lM+mzf9qwGz5bLI6tZF9bTqtUtU0sOpE2T8PIlhLIZ7QhIB96k/uZ1qUqNgUJ5exoxhJWdrqBdjhh+BNRTTN5y0qzeEqhDfXEp3w/9Ew5Gp9xd4WAai2ySzr71ralFe75DBN1Ede6vjAU+yFdSrJPm97uZgYlPgF4EWQbpIbDyDtnjEx8FWpvjjBoQ1xZG6dglci71uMpzEJC1yfapSzUO7e/GmRmAhYQRTqDsMK5TeKp2jcaFuMklXcKwvgnp/vHDTqGChsGU6+S5HhtfW8EZECRRYTKuMoa+p8cZPhh9NPRWpljCKEHjjrrDkpmu8ZIv5cNRwxuUawMR54UdtiTGyxD0HA37azGXX0tMqYuDF1gbarmuhTIxCwheABul4jZrd+ZYUdRN4Q1dYsW3MMojzsiCApsaFtJiIC3Ca9/S2ZR6ke9lsGoL8+LmiIVsSzvJIIrp0QbQyuIZCz+phkHtYI4dxse6pgV2gB3JlSyUdHOiW3MYZt
 mFGsu33S
 liW7eHRWpPSbrlVy1ynTb/3/LPWE12Cy8q7s6y2yN7EesA/h0LMcICfZDwXy6w6K6hIfHuCjN2NmeOtO0YNOvjqmFqJDmQ7rareN2UKkBxLkaZrDuGifai4wV6Sehb7J3ktBH6QfD7pPB6eSpdRsbbSkYfnE6VT/SVGOGsgdSbVHconItm1z8Nf/Tp/dxhEuhYBCklRpDvyjlElTSqBOV1fHljys6r3DGM6pnabduNCqZ++I/5CYhOtMMlEd6uYsWRldaTAqjwHMmiL5U8W5GMJgO/0atFh1j9GlkMeMc7QXC3peqckBthw4PYHiYCf+nFuzXDHrujibjxOOetahtRJqglhNmcEWbSFuOtsEaYIH0lmxTXft3dMVaSZJ76tdtOvSP3AKf4VM2Xwalr74uDTHrXW1zZ9XYKivp8SCAspKiUH97z4qBs+Ilygz5pUd2dHOiEcH+X26xdvVGkOPDpptSJdfUQs/4cIaC8pgvZ/zvPb0shGQ9f3Ax78mEUTGha38AXXcQ6K9AZPnL1BAbqNvZVEF7KdzYsXRa90PdMSAG8xT2gudb08EEFeJL5gr8Tg4vrdzuck0cLxTjIbrVI6bd8PZs2SBp9OZ53E9OYy1zLYRXKCVeQzjQqbXEVXEyZ5EqulgxOkvVnCf03l2E/PVUrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sched_ext carries its own ~130 lines of libbpf + bpftool + vmlinux.h +
BPF-object + skeleton build machinery.  Replace it with an include of the
shared tools/testing/selftests/lib.bpf.mk, making sched_ext the third
in-tree consumer of that fragment, after selftests/cgroup and
selftests/hid.

All generated skeletons and subskeletons keep the same public API, and
the runner is built and linked the same way.

Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
Suggested-by: Mykola Lysenko <mykolal@meta.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/sched_ext/Makefile | 149 ++++-----------------
 1 file changed, 26 insertions(+), 123 deletions(-)

diff --git a/tools/testing/selftests/sched_ext/Makefile b/tools/testing/selftests/sched_ext/Makefile
index 5d2dffca0e91..856fe7dea685 100644
--- a/tools/testing/selftests/sched_ext/Makefile
+++ b/tools/testing/selftests/sched_ext/Makefile
@@ -14,48 +14,29 @@ CURDIR := $(abspath .)
 REPOROOT := $(abspath ../../../..)
 TOOLSDIR := $(REPOROOT)/tools
 LIBDIR := $(TOOLSDIR)/lib
-BPFDIR := $(LIBDIR)/bpf
 TOOLSINCDIR := $(TOOLSDIR)/include
-BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
-APIDIR := $(TOOLSINCDIR)/uapi
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
+# Build scheduler skeletons and subskeletons with the shared BPF rules.
+BPF_SRCS        := $(wildcard *.bpf.c)
+BPF_SKEL_EXT    := .bpf.skel.h
+BPF_GEN_SUBSKEL := 1
+# Preserve the existing build/ layout.
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
@@ -64,102 +45,26 @@ endif
 
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
+# Preserve the scheduler-specific flags; the shared recipe adds target flags.
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
-
-$(SCXOBJ_DIR)/%.bpf.o: %.bpf.c $(INCLUDE_DIR)/vmlinux.h	| $(BPFOBJ) $(SCXOBJ_DIR)
-	$(call msg,CLNG-BPF,,$(notdir $@))
-	$(Q)$(CLANG) $(BPF_CFLAGS) -target bpf -c $< -o $@
+	     $(BPF_EXTRA_CFLAGS)
 
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
-# allows testcases to load any BPF scheduler, which is useful for testcases
-# that don't need their own prog to run their test.
-all_test_bpfprogs := $(foreach prog,$(wildcard *.bpf.c),$(INCLUDE_DIR)/$(patsubst %.c,%.skel.h,$(prog)))
+# Build every scheduler before each test.
+all_test_bpfprogs := $(BPF_SKELS)
 
 auto-test-targets :=			\
 	create_dsq			\
@@ -195,24 +100,22 @@ auto-test-targets :=			\
 testcase-targets := $(addsuffix .o,$(addprefix $(SCXOBJ_DIR)/,$(auto-test-targets)))
 
 $(SCXOBJ_DIR)/runner.o: runner.c | $(SCXOBJ_DIR) $(BPFOBJ)
-	$(CC) $(CFLAGS) -c $< -o $@
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) -c $< -o $@
 
 # Create all of the test targets object files, whose testcase objects will be
 # registered into the runner in ELF constructors.
-#
-# Note that we must do double expansion here in order to support conditionally
-# compiling BPF object files only if one is present, as the wildcard Make
-# function doesn't support using implicit rules otherwise.
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


