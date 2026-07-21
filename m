Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC2F9C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 17:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C8516B00A6; Tue, 21 Jul 2026 13:48:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0156B00A9; Tue, 21 Jul 2026 13:48:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7682B6B00AA; Tue, 21 Jul 2026 13:48:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE6A6B00A6
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:48:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6D4816026A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:48:48 +0000 (UTC)
X-FDA: 85013519136.21.04221D1
Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	by imf28.hostedemail.com (Postfix) with ESMTP id B7B3DC000D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:48:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KxsWzuZ6;
	spf=pass (imf28.hostedemail.com: domain of ziyang.meme@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784656126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V1HVbnWwjz/zPGwxKegdY4p1KeImHVO8vqQ7kQJ99fQ=;
	b=BMh4IzY/bScw+KOsY94yE16zVxYBG7tkqKVKUZBA2iqPRHSlVsPdHooolqXQ9we7uUTJID
	dA1DxoTRj6UbC2yU/EmWksYC3ma4Pd3OlK/xT8EmvZ0L1MEcQTYY92IMl3ExM+5zvEy+Zu
	/qgU/uMa0h9uWY2MULAYw+cYvrqQhwo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KxsWzuZ6;
	spf=pass (imf28.hostedemail.com: domain of ziyang.meme@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784656126;
	b=pzX605/jRj+XmCegZ6tSTMh0Lnb5B3bCZGIOaw8WxPi+KfjHFGIYK4ec7WUIzTxckiFVaW
	pdPTfTGhtknRj4vPmYI8d+NFIO75OUVi32PkIORCZ4wmBw7AUlKYv+7KtWTHc7AUgU+xYt
	3GgmuwlirI2WTJ6ABHjiyO0yi3sTibU=
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-ca696c4b152so3407138a12.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784656126; x=1785260926; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V1HVbnWwjz/zPGwxKegdY4p1KeImHVO8vqQ7kQJ99fQ=;
        b=KxsWzuZ6qdiwTf0pbh0HmwlwzOeShxfXOw7O3Q92Ku4ms3VLflxjYsokkYjXsKsJqc
         Ohp8zBEJ7/Ik+kleGrQlchbRHv34a1a99bYjOnE+svTaqrhZOyq05jbfaBQQIW5g0/tO
         oy1Gvp7CRogoA3SoPumDflcUHprn+/7gHKzKM3hRfJ6xyIaAZ/2/N+VEizcOzJEMpLmA
         flyTApltfiRtnhrZX95vFnGACBPYJ0wtG/M8OD78qt1u8fl3qaMUTSSIYYHHkaVDaMdD
         QW1YT2EuOc2uCx/Gy1ZBO4usAfYMRz1+yVgCd8KQFZaGr2r4tQESIxSu0tSqYlt1Gn9S
         1yiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784656126; x=1785260926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V1HVbnWwjz/zPGwxKegdY4p1KeImHVO8vqQ7kQJ99fQ=;
        b=MzkMvNWF3gUlxt/xk4ehNNb8dcSczL29H5qPHEaPkHDkX3F++Hk2yhrF9SvbAVqI1i
         BAKqvg8++pt3MO3z7mu7SvCwji3ecSN84c4G6qChj6D3y2xCw1AtqYGjbQ5+QG0CF2J/
         NYLo8vHCem0zel/fHOAgU7rMzUT2MTMtyoXST+VNxYsKdLK6LgiCCVl45tzmXAPsqBuj
         xkAx3GM//nj/Y0YEdSSgOU78UqeqDmDrvEJyXQZ0ju7uUGKwqa/18Y9JePthWwsazrfP
         BQanXec6yGP7MWXMb/5h3u4vGeuthFkJVU6mvuYDkjHFmnQjBR8jjsPfpM4Ah2nE7fQU
         3QHg==
X-Forwarded-Encrypted: i=1; AHgh+RrBSKCpubZBysTMkOockvw+KQJ2eu89p7Ux+VC73IcmY5ffQoLrcM41c5VMY7IgJjM19VdDu3fOww==@kvack.org
X-Gm-Message-State: AOJu0YybM7Z3TyNO6KxzE+bfREyb8kI9T/Z/slSTAK77ACpLDS1BuvOW
	bramc4QUKHH53g6nD2+xJ/8z/V0iYwJuD48pE4fFvIm6HnqceYicmLtj
X-Gm-Gg: AR+sD12dsRc068w27P5xUdNqizIrerPiPnTJoomrKipIPupjLUjUyH+yLu7LskYZASY
	Xe5vv88CVrkIHstlVXSNUovUpQ9l0/VrAJp/ltn43KUu2g4UEc/iq0xHKmNqNynTvfKpH1RFd6P
	mnVWdu2tQ3x8MiE1QzzAhnmKW2P+8mh/ECuVcy0jUfipGZEWa5ZyxJAdRzz4QxHJt8kU//SJj1F
	D6mEp9QjWYv+APzH4GcqyICJGxl7nNk+1EbNG8JGBLe3kx20OeVHZtN8fpemHpSVa31QgqUyLp+
	B2g3Oj7oJKui1E6q6N3GomE797bh7PjYaWiOaeBTTEwLm7FKZ9i0gj2Vp2FH57VZdG9irI6j3wP
	QLnnFFL/6NEXkzcmQ6XAwPD46Hw1U3S9m/42jFBvWPdlUR9TqdxjgxALS2uNxa2nKT296QIhHRq
	nCJT8zExI=
X-Received: by 2002:a05:6a21:114c:b0:3bf:a489:1483 with SMTP id adf61e73a8af0-3c3ad80c23dmr20107991637.33.1784656125438;
        Tue, 21 Jul 2026 10:48:45 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:65::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1b6a45sm872370eec.28.2026.07.21.10.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:48:44 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	David Vernet <void@manifault.com>,
	Eduard Zingerman <eddyz87@gmail.com>
Cc: Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	Nathan Chancellor <nathan@kernel.org>,
	linux-kselftest@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-input@vger.kernel.org,
	sched-ext@lists.linux.dev,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	bpf@vger.kernel.org,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ziyang Men <ziyang.meme@gmail.com>
Subject: [PATCH v2 4/4] selftests/sched_ext: build BPF schedulers via the shared lib.bpf.mk
Date: Tue, 21 Jul 2026 10:48:33 -0700
Message-ID: <20260721174833.1232771-5-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260721174833.1232771-1-ziyang.meme@gmail.com>
References: <20260721174833.1232771-1-ziyang.meme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B7B3DC000D
X-Rspam-User: 
X-Stat-Signature: af5nwbhykcpajp5jph1pc6s156m51hsx
X-Rspamd-Server: rspam04
X-HE-Tag: 1784656126-904498
X-HE-Meta: U2FsdGVkX19BrszGA/5E+JklxFq+nUFwBhe6UaCR/DDEHGopuKvh6UlVDlRC5NxsnpdMRcV9LPECE1LCeBnTq7j6ICUA2QSmb+J3hNOxZLtVESsP7qBopviU9eGBqxdEtWUQF3IsYIU46z3nB/L6W0GIYFeAH9qngos0XjCRfT/StUFwMBa718ZjZZYrsAV9/OZCTIeRrG84hsjkgWikfjfc5jKIulaa9txsIPzG9NwEBsl4VgJCKjrJbE/g/ElHy00TST87r/doe1aq1GX4rdmPtILCOLUNX6j/3pV1GaFwzfqRDcZbmH7r8RQelyUQZleGkZZXe4FMj2L1GQ/35grhC0IcUwyRcuZ08udwgRZMt7aEZlJO0qnagl1j3ZRZ4Li4LNVdFDmsQNZ/BlQdwh82e+MoctJzmr6lQZ2QnOvWOfwYnMP05A/yH8oWmn8rQfiSK9m5DJ/f1iqzeoEMcy4yh0/Ejasf20pDGq+sfHbLiY8AEz4RJTYcA3751zSA5X28T2evgZQ8fNlacq6AN/9bcgtEX57rRtOGUVEPIV2OegCITgDdOE4pKWFn/1jzBFhNyRswD58Q7zaAPGkXm4tJN0T42qQiIG6cwW9zoXQ9cNlzezruWviChwXYgTYzSmhgWIu7KH0WxZ0Htf9C2eaQnPmWsktXMbghlTBGHcOcu33AQnNeUJchJyVL4XfeLpq53XVEDA8kzOcCknX3fmvwgaKGCU5kng+0bUBrZfvP4bVCoMU3uBNnYjzbYdSILeCb7I/++9hO0O1aAtrowoAVHOtKOfh7JBcasVq4b7KYtEfxRTU1zHb6tvDiZT+pwymXgq/SBrReRgocYlG+cpSNVytOWL3h0CDlsUXNe8EH6IsLsJQPoTLKFgdjcpDI47p4zLKbzgRUsXlA8OMcYQvUAfER6GVURj/0k9z8iaf5EnKj3stx+0XZVAWyBojRQXZQX9PH1JV00OBBObu
 CuXIPYbF
 SJzBn5r7BABZOKwjrsgDPUrrMp33o+rWh0oLX9rfOTpk0sdqpp+Nyr6vPOK5ikV7rEvmfjAFktmRkzuPpeUjidQyb/ylSVKfN7q5fplFYmdUyhSq5MaSISs40OvTSy0mWDrwYJHe9MtbBsnfDr9fZ8wkKKyxWAdFL2rhGEt1h+Rbn3wfqkvxacohx+SxhuvbfVW7HEkyfNiXyMzQcCAbFY1DffYB3GCtZk+EQ//a7pBX2wM/VxKu6gUFK6xOIfEwvhK1yVd2jtSAIROKjDWCohShG5ObdsfRPHPTW1lVNFqBaESEQeeCry6BrzWT5IU8ExTuNCB6ZQCD6ocyE8YW2e9Ix5pNygrQoxD7jfRa/uU1zuRHIcO+OLjoFOKNRzP5aWWtBkKJZXNePGwxBSJ7fqD92pjfisPhW3JTiEc4uKiFwKO+LpWriWOQyJFf6PYncX0XsVqA5E6nWZfR3ViA9vOuKlzKMXCWjABINg/z3lczIfP6m3a5xxF/+JEzg2X9mHPpHx8ztvpRGiCPGBblBOBa7+z7B/tIcKBL2LtVwUq1pb3XoEd5F30C2lnfN+VVt+GxbLycHndEvjzibmXpfefNx8GnDlzVh6fQ7HJb8FzFXo7+wSWPbg6N0fw+w5Cpfln701YUZaSgGdD4=
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

sched_ext emits a skeleton and a subskeleton per scheduler with a
.bpf.skel.h suffix, so it sets BPF_SKEL_EXT := .bpf.skel.h and
BPF_GEN_SUBSKEL := 1.  Its BPF programs need scheduler-specific include
paths and are not -Werror clean, so it overrides BPF_CFLAGS wholesale
after the include; the userspace runner/testcase rules are kept and
repointed at the fragment's flat $(OUTPUT) skeletons.

No functional change: all 28 skeletons and 28 subskeletons keep a
byte-identical public API before and after, the runner builds and links
the same way, and the folder builds cleanly under both plain make and
LLVM=1.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
Suggested-by: Mykola Lysenko <mykolal@meta.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/sched_ext/Makefile | 153 +++++----------------
 1 file changed, 35 insertions(+), 118 deletions(-)

diff --git a/tools/testing/selftests/sched_ext/Makefile b/tools/testing/selftests/sched_ext/Makefile
index 5d2dffca0e91..67ff96bf34e8 100644
--- a/tools/testing/selftests/sched_ext/Makefile
+++ b/tools/testing/selftests/sched_ext/Makefile
@@ -14,48 +14,36 @@ CURDIR := $(abspath .)
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
-
-BPFTOOL ?= $(DEFAULT_BPFTOOL)
+# The BPF schedulers are compiled into skeletons + subskeletons by the shared
+# lib.bpf.mk fragment.  They use the modern *.bpf.c layout with a .bpf.skel.h
+# suffix and need subskeletons.
+BPF_SRCS        := $(wildcard *.bpf.c)
+BPF_SKEL_EXT    := .bpf.skel.h
+BPF_GEN_SUBSKEL := 1
+BPF_EXTRA_HDRS   = $(wildcard $(CURDIR)/include/scx/*.h) \
+		   $(wildcard $(CURDIR)/include/*.h)
+# Keep generated files under build/ as before (skeletons in build/include,
+# objects in build/obj) rather than flat in the source dir.  lib.bpf.mk creates
+# these dirs; SCXOBJ_DIR (userspace objects) reuses the BPF object dir.
+BPF_OBJ_DIR  := $(OUTPUT)/build/obj/sched_ext
+BPF_SKEL_DIR := $(OUTPUT)/build/include
+SCXOBJ_DIR   := $(BPF_OBJ_DIR)
+
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
@@ -64,102 +52,29 @@ endif
 
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
+# The BPF schedulers need scheduler-specific includes and are not -Werror
+# clean, so override the shared BPF_CFLAGS wholesale (lib.bpf.mk expands it
+# lazily in the object recipe; -O2/--target/-mcpu are added by the rule).
+BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)				\
 	     -I$(CURDIR)/include -I$(CURDIR)/include/bpf-compat			\
 	     -I$(INCLUDE_DIR) -I$(APIDIR) -I$(SCXTOOLSINCDIR)			\
 	     -I$(REPOROOT)/include						\
-	     $(CLANG_SYS_INCLUDES) 						\
+	     $(CLANG_SYS_INCLUDES)						\
 	     -Wall -Wno-compare-distinct-pointer-types				\
 	     -Wno-incompatible-function-pointer-types				\
 	     -Wno-microsoft-anon-tag						\
-	     -fms-extensions							\
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
+	     -fms-extensions
 
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
@@ -195,7 +110,8 @@ auto-test-targets :=			\
 testcase-targets := $(addsuffix .o,$(addprefix $(SCXOBJ_DIR)/,$(auto-test-targets)))
 
 $(SCXOBJ_DIR)/runner.o: runner.c | $(SCXOBJ_DIR) $(BPFOBJ)
-	$(CC) $(CFLAGS) -c $< -o $@
+	$(call msg,CC,,$@)
+	$(Q)$(CC) $(CFLAGS) -c $< -o $@
 
 # Create all of the test targets object files, whose testcase objects will be
 # registered into the runner in ELF constructors.
@@ -204,15 +120,16 @@ $(SCXOBJ_DIR)/runner.o: runner.c | $(SCXOBJ_DIR) $(BPFOBJ)
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


