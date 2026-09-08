Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F2FDC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 23:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172B36B0098; Tue,  8 Sep 2026 19:56:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149716B0099; Tue,  8 Sep 2026 19:56:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060626B009B; Tue,  8 Sep 2026 19:56:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B26C16B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 19:56:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00EEBA083D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 23:56:24 +0000 (UTC)
X-FDA: 85192256688.16.68B1EA3
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id 30966180003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 23:56:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JqxUt8sC;
	spf=pass (imf16.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788911783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKqFigUfUBeSnFW0KPe67v5MSiJ+XREL1Pj3ehWoLGc=;
	b=bRxj4fVIbuRIUP2QHtWZy2wYqdcx/X7AIKYQlnLprT+5Okcl1Pe8vg4Ah1uLrqT+Qmoqs0
	8teM8tzdgU5FROiTgikPpHXgu45Hx79rOSO3ta4+d9GZFXrQe5R1DIOb9Ri54ZoOkDyy6p
	dQ2Z34W4vjy+3AdP1+4QnNqa1Df3DNc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788911783;
	b=bSX0sNlaON3y8td+Gtn9tO7nVX/gGwVRGfbMDP4gdvrjq1/+2jMkrIdsPITkNt372oDIj/
	LcOlh9hX3UG4P7+5siDtV5e6ib5/Oio8hXdepSZ6v8jDioP2gBBypuNlno4GYjPWBsk5YJ
	xQDg2P9pmlbXEucuXLzxe79p1GzKyBQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JqxUt8sC;
	spf=pass (imf16.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-ca766c1c9ccso3495959a12.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 16:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788911782; x=1789516582; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uKqFigUfUBeSnFW0KPe67v5MSiJ+XREL1Pj3ehWoLGc=;
        b=JqxUt8sCGi+/4FabnrJ6fx1W0aaQ+FCZs3S/+NT+7TqwdJ+uwRSOlKSJTrC91gFqig
         Bu0uuF8MqKMqFpjQnod1O52PvInHczIvNXFu1m0P3KJFKumuBaf+EKRt6QE+DJg2zpWI
         GlPLaTvMuC2oaaYCj6Vdcx1AlzZ2FRgzQVWiYhy46c18doej/YIcGL//6w0Zk8vINN6l
         mHlIsGuq3T/BqlmvS5k2fAIy+UjEMINXRMBTeUJipYkcYURfcDpr9CvSzNxGzdy7r4TW
         bzkZDPeRWjDxbwGIoSpX7yxRTS7ZqeL/yv/EkiPFkNEWQ6cghTshh/ZOFGqx/U4ZsZb1
         B2Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788911782; x=1789516582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uKqFigUfUBeSnFW0KPe67v5MSiJ+XREL1Pj3ehWoLGc=;
        b=J230I05cy30OFr91pR3tRuJNrnUCwptCxWwfegANquIlNe/cuSUCOIGZHZUlmwpwqo
         FDCgoMFaPn1+Qe/IRkJP9sahHtKAo6DQAM0+XdVjXFMKG+Nr03pDmndlaWqZ7p599sqj
         MjJSHzUePhG2GEqvBgBi0DeFgNzOwZjkP/GoTkJdYXKXnjhIPwAslvqDw+cPgS8xLQCc
         eIM169acHLvYonueVQWxC2FtwyKesxz3TX5WkBX8QGUgCIoLfEONUk9WUkbMj4nrk06d
         /enkjQcB0s87JqhA6Wyfm+sCGUbSK25th/XNuD9JhZ7B64bzEr2VJonhm38mlHMQBVtW
         UHhA==
X-Forwarded-Encrypted: i=1; AKwUvBwFI+yyoJUbU/jw9Yk0B4pJqx7LWT5z9O99atgt5ovGiqjDYd8P2DnWVozGZt+o/TcZXUX3cR2AXw==@kvack.org
X-Gm-Message-State: AFuF++mHjybut5d2Z+JEppPl5VwXfznl0BZWxz/t00R/MRn2AtCu3U4O
	lrVM5FJsjsXjwUo9Z2qMcOAUdl9jjfqKjP+mJKgcm6ftGi/drLyV+FHG
X-Gm-Gg: AYBFou3t/txGtPf+5aiUi0Dm2ux/Izx81XRIYNNQiW+f2wWOjzMO5ckj8kdD2AGFoUu
	8ZhZ1zw4I26JiqkB2IzEJHVtH+9NFkVBssfucNMbLtyDOdVeUj8LqDo98NL6G2yu0YpOYZx15kd
	rqrwU0WL1qbLYKvl5iRiACx9WkPAXCi8Axf7cqW9VRwvMWYTC4fnLQntrkLncHfgrMf9kuRXbKo
	k5r3+WiqANyng8v/pTwmbr1T+UnHgXOFq+RR/WlAMS+SEut8CN1UMu9W3Jw55hYDRBHC8K9bSPk
	mNLyS9DQdnGf09PK2x2IRz8cfh3W0ZMCh3GJlSseJFWRGXfm47RU6GUNyZvREBIs0r5IPYEi5T9
	JqLJ8Vpz8Ia4CwmXJUenXOo0ng+IVkDeaOabnvrWGqBkDD4F9D2xw6S2UKr7RSJy7ICOzdB1IG6
	rprLvw+PUxtwcTdeIQH/ccivIxK50gG5BduXkr15uw+lkZpUB+CPNpvMQ=
X-Received: by 2002:a17:90b:3809:b0:396:4dfb:5890 with SMTP id 98e67ed59e1d1-39b260d333amr48826313a91.2.1788911781836;
        Tue, 08 Sep 2026 16:56:21 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:6b::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243767e1sm33162529c88.6.2026.09.08.16.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 16:56:21 -0700 (PDT)
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
Subject: [PATCH v4 4/4] selftests/sched_ext: build BPF schedulers via the shared lib.bpf.mk
Date: Tue,  8 Sep 2026 16:55:52 -0700
Message-ID: <20260908235552.2610256-5-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260908235552.2610256-1-ziyang.meme@gmail.com>
References: <20260908235552.2610256-1-ziyang.meme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 4pzctmqb56hc5741tizieqsgoamwsijd
X-Rspamd-Queue-Id: 30966180003
X-HE-Tag: 1788911783-774092
X-HE-Meta: U2FsdGVkX1/LgFEFVDYdO5x+P4g0bD3Mp2eLfySyORTxZdwTYBFg1glj3Z8kqXI1fvcjpM3Aodkkk3dyBj4Cibru9jm+wdfVohmE3JKYyV8KY0g52jpxte1BRcmuNqxiIrxStAR2K8IidPXicsm6b7shZP3dsvIiGJV79ewD/3Za0KLM0JpZcpwJihtwKLN2xzhRSxPhHJTBci3HnbRyyRABttKMAlA81k0zPgoCd7dTIxkr+qTg7er8Rvu5rbw8zsW+lNy7veBTWNPWKUnlSCgVKKLMQ0mDSMC7fAyGS1WyQEkAJBnVyfGQsQI3Ami13NKVgHGZKbKRPZSapOHP/AWStNZhcPQaZENCy2N7WAL+HxCluwMSnuG/BlUqFkISqpnlWTjYaOx1qqhJRhBUZTK7XUQkcisc1mnfpvoFeaeIGOAKMPZij8yu5XvWUxMsEHJ/CGC0ell6Pd1k1ZsVCyieIEjtFxjFvovZpb87xUQYFc2MD2rJ80Bxbm6QJz9hZo6XPYb4KNDZPmww6E5Wlbj7XhuFHvlXeTeX0sWg1A3cANvb7m63VUxsGCVEIIXAkGCxYXF2z6+TFl5oEbEULycfWaqPEgVN5gkK2EVN/4bDENDELKuOq8p1jPxvk24bF/tuGqGes/27mqdXCdSxRCsgTfbx+T1SiAZLi2r9/7HFgoZm2HG2q+esFrbGrtDodyjuB7aTatpIFyPO2PYEVtT3uM74w0A8VJvpJwYG3RUnx++SzXWM1DtuBJMRBXwDwUuZHLoYIVl3hNEm4Bf5u6IinEoPIxZFymfL+OplPMiCH1c+1q6vIwLb4hqd7W6+63KkZE1vTVSF+iYfQN1ZCUOusVW7W/XQnrlKZxwJ/DTh1u6YqTEYcilGO5kWu81MkCSQ3iD9ZB1rdk4G34trCF88YlJsTUIJr5GIkiq3vcgddI2HkPe4mJUUnY9/jiTn6Ljh5rCXBgJrxqIpSRJ
 +sFnkEMP
 E3xRAuxSlJcfzdC935jBTVWslwUk1YJ3+h0nhZC97v/hvO78L6Qnsy0GEtkofGHn54Or9QcbVpDfiw1IVVZrBXBKKX9X/aYsCqiO5p0nJO2m9tIYLLhOBgvA3h31TzA51goxgALiY5K/zMIFpIpGFPdWvW1vUkrFLU3NinkzvLkcAp9LYwOrc9hpOPRRkAKd+hlWd4QMoa9tF4k6NiqIHW8celJeyr1sM7TC9dQ5yEwUvfV7iI3XgEgGEo+/kq86drDGdOab9bGig9D5l/MzJfN5bGPPapdyXIGGmrzaI5ovKDigSDCZllNaPeIr2uf4oy1YzYCsVGlywUYgSXlDtzNBAH8s4tEKOEYpIuJ06SCdIhHvf+xNsP63Tt6pFU7+Qo9EhgnthZT0vQB30sAD/aWvFHCPaLTJVlD9TX83ym2MKcRjPezjd55PaBVU+sHOQCBtikhXE28IVuIB2xoDW6pbWbNVa/Ank/8cAfyg7d7DjxcoRpLlT4bH6Vcwh6EgxNUK/wKwtErVk1N8Q2kG4mybbu2VhcJIdm4wbphqqtmihTwtKX60XWpHFOT2kypXuT5Jt6tzmpRujpjO6U6ccBSlFFap+jYUm5uz5lvFh4Yr3z2q2mouJoJrizFaA8m2vdkaaBIkWrrru+kI=
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


