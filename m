Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527B4C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 23:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E7146B0093; Tue,  8 Sep 2026 19:56:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1988B6B0095; Tue,  8 Sep 2026 19:56:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037EF6B0096; Tue,  8 Sep 2026 19:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CC9376B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 19:56:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1DC28C0644
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 23:56:20 +0000 (UTC)
X-FDA: 85192256520.15.03F1D0A
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id 406D840009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 23:56:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ryJwt8ZC;
	spf=pass (imf07.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788911778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBBeCRmmKGr22yzadVUWGqqdMcGSRhOtpXbO4fwPhxw=;
	b=6ampmOAtjfIO8cm1HSiUBd3pXvrmCr1a3PNF6Fhf/l7yYO6Sju3eLOgvajjWPgS2AHKrqU
	3tGEFNzaGHoL1d8dC4OXRcfeuHp55e0cUx3c4p7gzSBKlKN2wDRFwASkZzyFMg+Jn7Kjzv
	SHed6jvpNQp6jto57RmTPFxObHwfSUg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788911778;
	b=EFi6yxIQgaDLGu1yOOHEVO5MyfbeNVvtqXVQ0BkuQzW2wAKiLw0m8xuOpjsla7UdADpZhu
	Qr2XZpZl7tPOMaIbiKH44UT8b0Z06MW3A2vYmRUyNutTeJxljRb0NmmZkZ5lLLMbOTNuZl
	sFZKS+GygU7hiANHCW5tgY64Yku6qOM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ryJwt8ZC;
	spf=pass (imf07.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-398c1101c1bso5001144a91.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 16:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788911777; x=1789516577; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QBBeCRmmKGr22yzadVUWGqqdMcGSRhOtpXbO4fwPhxw=;
        b=ryJwt8ZC1giI0RLHUXzU4tRsv/GTQI9S5w+xbCFz6zwFHZ1Ud1wVHZhIP4yr9Rj0bJ
         ZluH9S2DMNm1KAR60rKcpnkErsXpmYBwk+aTGJrNf9VEaX6/PJIagjS8WxBdbgM/Hj7Z
         WAJe3A22T19tIINUBtsVsUSw3e5npKp8ijk52fNhbVjvNKkaHZxIJn+B3pRE9X8yj5TX
         0UADfuJu6vo4f7ZUlrFKHVMkePi1m+Bcox/TdyVRuEz9DtGMKLHSPdThK/wjO3WWKsB0
         MqnqoQcr6qSt3A5tkyLPLJrKWatQ2rGe9lVqzUOBekY2pokN3lKjkuIqBTFghuh9fkwP
         kqWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788911777; x=1789516577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QBBeCRmmKGr22yzadVUWGqqdMcGSRhOtpXbO4fwPhxw=;
        b=jJqDp9SZO03IWieKyftnB259GrK4WN0SwNoSQ2ewG5iyWJBd4nLkGFi7nHb6tyC+zR
         tIvgGvmmprLDLndvnMw8eKf5Ql7rbb6EALbrZHPYasN8qmBpofdj7z3fK3IYLjPs0ZiR
         4FIJUj5mAGKCh6i6syoMyQsqdBeCYT4ph7845JgpHeuc1QrAUwRkCl6+xvKwM4X/GsrG
         lJZduPGFBQ2tFM+7CXgk+W2l/UUd+CZCxdFBUVRr/NYrx336agiLDYUETCUKBr2E0BWU
         S7B7Pl+JvhYrwgPylLGMxZoT/w29JdsSXPbdLvpVx5B4dZ9WU+K3HOlKA6Lex1vx0HEj
         bL8w==
X-Forwarded-Encrypted: i=1; AKwUvBymBKejI9wqe4NJKUpcfmUgPMPhGm5ewZPGCyuJjDkUBcWBqivqzh7+j6qdN59KMz0MCsF3fTq4dA==@kvack.org
X-Gm-Message-State: AFuF++mK0K5JHN812Pc5fDEtrThwq7S9oP12iA3nVZ66p3deb7iipE83
	nqneklAPJQ4seL4wGO8JA8IAjeM2+Mh6fdEWgV6CrSGaRLTMr4/Q1WHJ
X-Gm-Gg: AYBFou3R4X1Sh9NI/t+eLLqb1rj4wL/0H8S6hZ2L2fv4BqF0G/TpCaqqcB5xfnNcZI2
	7i3w+80JuEM9ZGA9xHXdhBudTKnPnvFt/uszRiThuAqLZOPu7VS3fEhd4VwLzAKR2wPq+Mue9g7
	bCHEsXUKmdADeuXmfL1b8XVneZA9FoimatQScAGYVBxijcSzj29FdArYc7O7L+rzn2Ry2AssJwY
	XqWknnCOEuZWyVU4ulakRQ7itSqQVqADYfe2aVn9Bk/q6ArtbQYTzW2tY7JKvmumucxo4cv/roA
	WzcZmi/U3jXCr+5S9KnRphywtbKJxgCOGy2wDsnJpBeQa7ip1uVStINKgmHe7qSRFOECikv4jA0
	7vuj4IfW+swAmx+5kvq9ew2iFU01/d2RwwxWTZZdG4Uvx3/pLQFuj51B3MDZe//Fpn5VtfhfiEQ
	w1mF4Bx7MP2B106lz0n6XsOnK2sp44CG0q65k3pJcViD5Gb+wBUUp9Jdk=
X-Received: by 2002:a17:90a:fc47:b0:398:9c0c:7c72 with SMTP id 98e67ed59e1d1-39b2627fe24mr43834873a91.25.1788911776798;
        Tue, 08 Sep 2026 16:56:16 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:64::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b608409sm44492157eec.21.2026.09.08.16.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 16:56:16 -0700 (PDT)
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
Subject: [PATCH v4 1/4] selftests: add shared lib.bpf.mk to build BPF progs and skeletons
Date: Tue,  8 Sep 2026 16:55:49 -0700
Message-ID: <20260908235552.2610256-2-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260908235552.2610256-1-ziyang.meme@gmail.com>
References: <20260908235552.2610256-1-ziyang.meme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 1r9owu6ok7nibn8wdawyineojorudtci
X-Rspamd-Queue-Id: 406D840009
X-HE-Tag: 1788911778-395073
X-HE-Meta: U2FsdGVkX18ASpgQhpYELuuGWc6QsoXL37LHdwTQRc6VQlkeq2Mjtfmt0/qeAPFmdYIMzD9Y6d2cZgV7pIP6XiM+qjuC6FsEADXvu5BIVTmCmRz+L63zy9zE+by/DuXj9sAkYFFR5/SbJ0lUPooCE+hKctElDdcpeAjm6KXiiGh/nP8332nUA1fzvl4R/DbEsoXwsK6r9kT6Q84aJTQJBEQGa83bjPpgaqukzIRtuicMM1dcm+ZRvotBI+ArLPVGaALJVeMd3rVtLwNCgjbf5+1O3uHR+dXe5wh8ly6aOnwRUOzen9vA13bkYKxt5PKbA2nhoYXzeVPW0gkjNmxpfjxQ1VM/P4PN8hfHOOKiVxZ0vyQx2XuM8n6qjeF5WW/ik2o8TuDhBNyUoKYLO1VCYeOO50BrD5dtxzlducIPFZqs1hx15PIuv3rLt7/6QSxZ7FGOQifxx0SOisKl4PmtxJOPnfVZwOu8JDbwomuoGx8NOtw9YHwqtA/TrtVS+qvpEjNzG96XATU/yqLhshLCzOuFiYz9ruHbeRuKLPzNsTwsPZj9v9LhZeY7iT5L0I+niOzZPTvZ1H5eJ/jbQEl40kJ9lRBMq96kV9LN1LeDGd56fbSEaUzFPkHglhK9HbFvN9ldBjDnnciDyrSUd6fr8VKpuy/4citRuZ9gbP00lG16c/YdWWODbkBnIhVkRvur3yqtQO+81k2hLBWd7VDp7SkQMQQe8DAC+ZLqvlvW4HvbVvd7UBrcBFovdZ9GxV3jMMeuZctLC7Nmk82QVECuOl+7t2jB1577A+EaicpCtG4Q+RiHnGR8pHwovwUTrqe9xoiAmw2opGOZm0CnZkRy6zboqsxKrTBHDHmme1wKdnVbgPKmZ8MmFaWgAKoH9ZULpwDKjN0lNrkZ4fetQfXuTzKptZsMxV4nerKTkQb7mjU5zMDmBiW3fd5f+4ctrOGlb/whQ804b1UooCf0lm6
 zaaiapLt
 IQ7OoZgCyFrNmRTA1FULKuiTrY02RLCv5OWqiIAT3vYnqXCAV6ppau9V1BO2l3BcO2XDaPN2gf2kW8w9u+xoOfnj2vKe8VlHeYNi0cbGGZz5xY8q+L3+wVBQre0VUJvEuN9K5W3FrXNplbanRPoY5Kam0maC+OYY9bvUh97zHvryArAyaXjWnMlzyhWsyjSw9DXvxfxe3tJuWllWlgWVJQNKUzj9FlppfNhMhD9hoP1cNNiLhnME9eDIMKke1eSTCoIP39robzFHCINk57+vynKQEBt5HhRDszoCL/WddyslMD4aZLyi50K+nLQ73Wt5eTdEV2t7VnaCyMhDOrkZsuLE13OUnIvb0+USWhm2M2jdwiVv+iuNu97384k1wNlqlyv2f4pLLsiS3J11YkXjYvIletMDomcX9p6KjRgjmcu/fXwqSLusqlHP3U4LIiLDMlyawev66JbXT/6P5aupsv8GNNAGTe0gfSkum9rAwLYxoa0emG+TzIVbWsO5WwOWdWBq+YvwbpVEs5Q7K9IImhWbpb4CQCNEKwgfsfS2SsWyVQXDGxNZNMIK+OZiWd8jY5NAwDmU4mZhDEhY2kSBpVycjeK1O9U/HhebH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The libbpf + bpftool + vmlinux.h + BPF-object + skeleton build tool-chain
is currently duplicated across tools/testing/selftests/{bpf,sched_ext,
hid}/, each carrying ~100-140 lines of near-identical Makefile.  As more
subsystems grow BPF-based selftests, the duplication scales poorly.

This patch adds tools/testing/selftests/lib.bpf.mk, a single includable
fragment that provides the whole chain end-to-end.

To use: set BPF_SRCS and OVERRIDE_TARGETS := 1 before including ../lib.mk
(so lib.mk's default link rule is suppressed), then include ../lib.bpf.mk
and list $(BPF_SKELS) and $(BPFOBJ) as prerequisites of the test binary,
e.g.,:

    BPF_SRCS         := progs/foo.bpf.c
    TEST_GEN_PROGS   := foo_test
    OVERRIDE_TARGETS := 1
    include ../lib.mk
    include ../lib.bpf.mk
    $(OUTPUT)/foo_test: foo_test.c $(BPF_SKELS) $(BPFOBJ)
            $(call bpf_link,$@,$<)

This eases adding BPF-based selftests in other directories, such as
cgroup.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
Suggested-by: Mykola Lysenko <mykolal@meta.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/lib.bpf.mk | 321 +++++++++++++++++++++++++++++
 1 file changed, 321 insertions(+)
 create mode 100644 tools/testing/selftests/lib.bpf.mk

diff --git a/tools/testing/selftests/lib.bpf.mk b/tools/testing/selftests/lib.bpf.mk
new file mode 100644
index 000000000000..f27cd1889e7f
--- /dev/null
+++ b/tools/testing/selftests/lib.bpf.mk
@@ -0,0 +1,321 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Build BPF programs and skeletons for selftests.
+#
+# Use it from a test Makefile like this:
+#
+#     BPF_SRCS         := foo.bpf.c bar.bpf.c
+#     TEST_GEN_PROGS   := foo_test
+#     OVERRIDE_TARGETS := 1              # set before lib.mk
+#     include ../lib.mk
+#     include ../lib.bpf.mk
+#
+#     $(OUTPUT)/foo_test: foo_test.c $(BPF_SKELS) $(BPFOBJ)
+#         $(call bpf_link,$@,$<)
+#
+# Depend on $(BPFOBJ) to relink the test when libbpf.a changes.
+#
+# Options to set before including lib.bpf.mk:
+#   BPF_PROG_EXT     - source ending; default .bpf.c. Use .c for progs/foo.c.
+#   BPF_EXTRA_HDRS   - more headers needed by the BPF objects.
+#   BPF_EXTRA_CFLAGS - more flags for compiling BPF programs.
+#   BPF_SKEL_EXT     - skeleton header ending; default .skel.h. Must end in
+#                      skel.h.
+#   BPF_GEN_SUBSKEL  - also create a subskeleton header when set.
+#   BPF_OBJ_DIR      - folder for BPF objects; default $(OUTPUT).
+#   BPF_SKEL_DIR     - folder for skeleton headers; default $(OUTPUT).
+#
+# Set output directories that use $(OUTPUT) after including lib.mk.
+#
+# BPF_CFLAGS may be replaced after this include. Generated names use the source
+# stem without its directory.
+#
+# Include lib.mk first. This file defines the BPF build variables and bpf_link,
+# extends all, CFLAGS and EXTRA_CLEAN, and enables .DELETE_ON_ERROR.
+
+include $(top_srcdir)/tools/scripts/Makefile.arch	# ARCH / SRCARCH / HOSTARCH
+
+# Remove partial files written directly to $@.
+.DELETE_ON_ERROR:
+
+# Match the libbpf and bpftool host compiler to LLVM=.
+ifneq ($(LLVM),)
+HOSTCC ?= $(LLVM_PREFIX)clang$(LLVM_SUFFIX)
+HOSTLD ?= $(LLVM_PREFIX)ld.lld$(LLVM_SUFFIX)
+else
+HOSTCC ?= gcc
+HOSTLD ?= ld
+endif
+CLANG  ?= clang
+
+ifneq ($(V),1)
+lib_bpf_submake_extras := feature_display=0
+endif
+
+# Match selftests/bpf debug and release optimization.
+OPT_FLAGS ?= $(if $(RELEASE),-O2,-O0)
+
+# ---- files and tools ------------------------------------------------------
+# Use one full path. Different forms of the same -I path can change BTF order.
+lib_bpf_tools_dir         := $(abspath $(top_srcdir)/tools)
+lib_bpf_dir               := $(lib_bpf_tools_dir)/lib/bpf
+lib_bpf_tools_include_dir := $(lib_bpf_tools_dir)/include
+lib_bpf_bpftool_dir       := $(lib_bpf_tools_dir)/bpf/bpftool
+lib_bpf_api_dir           := $(lib_bpf_tools_include_dir)/uapi
+lib_bpf_sources           := $(wildcard $(lib_bpf_dir)/*.[ch] \
+					       $(lib_bpf_dir)/Makefile)
+lib_bpf_header_sources    := $(filter %.h,$(lib_bpf_sources)) \
+				     $(lib_bpf_api_dir)/linux/bpf.h
+# Keep these names for callers which add their own BPF flags or dependencies.
+BPFDIR     := $(lib_bpf_dir)
+APIDIR     := $(lib_bpf_api_dir)
+
+# Keep private build files under $(OUTPUT) for both in-tree and O= builds.
+lib_bpf_scratch_dir := $(OUTPUT)/tools
+lib_bpf_build_dir   := $(lib_bpf_scratch_dir)/build
+lib_bpf_include_dir := $(lib_bpf_scratch_dir)/include
+# INCLUDE_DIR is also used by callers that replace BPF_CFLAGS.
+INCLUDE_DIR := $(lib_bpf_include_dir)
+BPFOBJ      := $(lib_bpf_build_dir)/libbpf/libbpf.a
+
+# Cross builds use a separate native libbpf for bpftool.
+ifneq ($(CROSS_COMPILE)$(filter-out $(HOSTARCH),$(SRCARCH)),)
+lib_bpf_host_build_dir   := $(lib_bpf_build_dir)/host
+lib_bpf_host_scratch_dir := $(OUTPUT)/host-tools
+else
+lib_bpf_host_build_dir   := $(lib_bpf_build_dir)
+lib_bpf_host_scratch_dir := $(lib_bpf_scratch_dir)
+endif
+lib_bpf_host_obj := $(lib_bpf_host_build_dir)/libbpf/libbpf.a
+DEFAULT_BPFTOOL  := $(lib_bpf_host_scratch_dir)/sbin/bpftool
+BPFTOOL          ?= $(DEFAULT_BPFTOOL)
+
+# Reuse target USERCFLAGS only when bpftool shares the target libbpf.
+ifeq ($(BPFOBJ),$(lib_bpf_host_obj))
+lib_bpf_host_user_cflags := $(USERCFLAGS)
+endif
+
+# ---- find vmlinux BTF -----------------------------------------------------
+VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
+		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
+		     $(top_srcdir)/vmlinux				\
+		     /sys/kernel/btf/vmlinux				\
+		     /boot/vmlinux-$(shell uname -r)
+VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
+# Delay missing-vmlinux errors so "make clean" still works.
+lib_bpf_vmlinux_deps := $(if $(VMLINUX_H),$(VMLINUX_H),$(VMLINUX_BTF) $(BPFTOOL))
+
+# ---- compiler flags -------------------------------------------------------
+# Find the normal system headers that Clang omits with --target=bpf. Put them
+# last with -idirafter so they cannot replace project headers.
+define lib_bpf_get_sys_includes
+$(shell $(1) $(2) -v -E - </dev/null 2>&1 \
+	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
+$(shell $(1) $(2) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}') \
+$(shell $(1) $(2) -dM -E - </dev/null | grep '__loongarch_grlen ' | awk '{printf("-D__BITS_PER_LONG=%d", $$3)}') \
+$(shell $(1) $(2) -dM -E - </dev/null | grep -E 'MIPS(EL|EB)|_MIPS_SZ(PTR|LONG) |_MIPS_SIM |_ABI(O32|N32|64) ' | awk '{printf("-D%s=%s ", $$2, $$3)}')
+endef
+ifneq ($(CROSS_COMPILE),)
+lib_bpf_clang_target_arch = --target=$(notdir $(CROSS_COMPILE:%-=%))
+endif
+# Find the system include flags once and reuse them.
+CLANG_SYS_INCLUDES := $(call lib_bpf_get_sys_includes,$(CLANG),$(lib_bpf_clang_target_arch))
+
+lib_bpf_is_little_endian := $(shell $(CC) -dM -E - </dev/null | \
+				    grep 'define __BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__')
+MENDIAN := $(if $(lib_bpf_is_little_endian),-mlittle-endian,-mbig-endian)
+
+# Use BPF CPU v3 when Clang supports it. Otherwise use v2.
+lib_bpf_clang_cpu := $(shell $(CLANG) --target=bpf -mcpu=help 2>&1 | \
+			     grep -q 'v3' && echo v3 || echo v2)
+
+# Accept anonymous struct and union members in vmlinux.h.
+BPF_CFLAGS = -g -Wall -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)	\
+	     -I$(INCLUDE_DIR) -I$(APIDIR)				\
+	     -std=gnu11							\
+	     -fno-strict-aliasing					\
+	     -fms-extensions -Wno-microsoft-anon-tag			\
+	     -Wno-compare-distinct-pointer-types			\
+	     $(CLANG_SYS_INCLUDES) $(BPF_EXTRA_CFLAGS)
+
+# $1 = source, $2 = object. -MMD -MP tracks non-system headers.
+define lib_bpf_build_rule
+	$(call msg,CLNG-BPF,,$2)
+	$(Q)$(CLANG) $(BPF_CFLAGS) -O2 --target=bpf -mcpu=$(lib_bpf_clang_cpu) \
+		-MMD -MP -c $1 -o $2
+endef
+
+# ---- output folders -------------------------------------------------------
+BPF_OBJ_DIR  ?= $(OUTPUT)
+BPF_SKEL_DIR ?= $(OUTPUT)
+# Reject empty directories before cleanup globs can reach the filesystem root.
+ifeq ($(strip $(BPF_OBJ_DIR)),)
+$(error lib.bpf.mk: BPF_OBJ_DIR is empty; set it after "include ../lib.mk")
+endif
+ifeq ($(strip $(BPF_SKEL_DIR)),)
+$(error lib.bpf.mk: BPF_SKEL_DIR is empty; set it after "include ../lib.mk")
+endif
+
+# ---- build folders --------------------------------------------------------
+lib_bpf_make_dirs := $(sort $(lib_bpf_build_dir)/libbpf			\
+			    $(lib_bpf_host_build_dir)/libbpf		\
+			    $(lib_bpf_host_build_dir)/bpftool		\
+			    $(lib_bpf_include_dir)			\
+			    $(filter-out $(OUTPUT),$(BPF_OBJ_DIR) $(BPF_SKEL_DIR)))
+$(lib_bpf_make_dirs):
+	$(call msg,MKDIR,,$@)
+	$(Q)mkdir -p $@
+
+# ---- target libbpf --------------------------------------------------------
+# Pass unexported toolchain settings and build PIC for PIE test binaries.
+# libbpf consumes USERCFLAGS through EXTRA_CFLAGS.
+$(BPFOBJ): $(lib_bpf_sources) $(lib_bpf_api_dir)/linux/bpf.h \
+	   | $(lib_bpf_build_dir)/libbpf
+	$(Q)$(MAKE) $(lib_bpf_submake_extras) -C $(lib_bpf_dir) \
+		    OUTPUT=$(lib_bpf_build_dir)/libbpf/ \
+		    ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) CC="$(CC)"     \
+		    EXTRA_CFLAGS='-g $(OPT_FLAGS) -fPIC $(EXTRA_CFLAGS) $(USERCFLAGS)' \
+		    DESTDIR=$(lib_bpf_scratch_dir) prefix= all install_headers
+
+# ---- host libbpf, only when the target differs ----------------------------
+ifneq ($(BPFOBJ),$(lib_bpf_host_obj))
+$(lib_bpf_host_obj): $(lib_bpf_sources) $(lib_bpf_api_dir)/linux/bpf.h \
+		| $(lib_bpf_host_build_dir)/libbpf
+	$(Q)$(MAKE) $(lib_bpf_submake_extras) -C $(lib_bpf_dir) \
+		    ARCH= CROSS_COMPILE= \
+		    OUTPUT=$(lib_bpf_host_build_dir)/libbpf/ \
+		    CC="$(HOSTCC)" LD="$(HOSTLD)" \
+		    EXTRA_CFLAGS='-g $(OPT_FLAGS) $(EXTRA_CFLAGS)' \
+		    DESTDIR=$(lib_bpf_host_scratch_dir) prefix= all install_headers
+endif
+
+# ---- host bpftool ---------------------------------------------------------
+$(DEFAULT_BPFTOOL): $(wildcard $(lib_bpf_bpftool_dir)/*.[ch] \
+				 $(lib_bpf_bpftool_dir)/Makefile) \
+		    $(lib_bpf_host_obj) | $(lib_bpf_host_build_dir)/bpftool
+	$(Q)$(MAKE) $(lib_bpf_submake_extras) -C $(lib_bpf_bpftool_dir) \
+		    ARCH= CROSS_COMPILE= CC="$(HOSTCC)" LD="$(HOSTLD)" \
+		    EXTRA_CFLAGS='-g $(OPT_FLAGS) $(EXTRA_CFLAGS) $(lib_bpf_host_user_cflags)' \
+		    EXTRA_LDFLAGS='$(EXTRA_LDFLAGS)'		  \
+		    OUTPUT=$(lib_bpf_host_build_dir)/bpftool/	  \
+		    LIBBPF_OUTPUT=$(lib_bpf_host_build_dir)/libbpf/ \
+		    LIBBPF_DESTDIR=$(lib_bpf_host_scratch_dir)/	  \
+		    prefix= DESTDIR=$(lib_bpf_host_scratch_dir)/ install-bin
+
+# ---- build vmlinux.h ------------------------------------------------------
+lib_bpf_vmlinux_h     := $(INCLUDE_DIR)/vmlinux.h
+lib_bpf_vmlinux_stamp := $(INCLUDE_DIR)/vmlinux.h.stamp
+
+# Preserve vmlinux.h's timestamp when its contents do not change.
+ifeq ($(wildcard $(lib_bpf_vmlinux_h)),)
+# Regenerate if the header is missing but its stamp remains.
+.PHONY: $(lib_bpf_vmlinux_stamp)
+endif
+
+# Use an order-only edge so the stamp's mtime does not propagate.
+$(lib_bpf_vmlinux_h): | $(lib_bpf_vmlinux_stamp) ;
+
+$(lib_bpf_vmlinux_stamp): $(lib_bpf_vmlinux_deps) | $(INCLUDE_DIR)
+ifeq ($(VMLINUX_H),)
+	$(call msg,GEN,,$(lib_bpf_vmlinux_h))
+	$(Q)test -n "$(VMLINUX_BTF)" || { \
+		echo "lib.bpf.mk: no vmlinux at any of \"$(VMLINUX_BTF_PATHS)\"" >&2; \
+		exit 1; }
+	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@.tmp
+else
+	$(call msg,CP,,$(lib_bpf_vmlinux_h))
+	$(Q)cp "$(VMLINUX_H)" $@.tmp
+endif
+	$(Q)cmp -s $@.tmp $(lib_bpf_vmlinux_h) || mv $@.tmp $(lib_bpf_vmlinux_h)
+	$(Q)rm -f $@.tmp
+	$(Q)touch $@
+
+# ---- BPF objects and skeletons --------------------------------------------
+BPF_PROG_EXT ?= .bpf.c
+# Each source must end with BPF_PROG_EXT so Make can remove that ending.
+lib_bpf_bad_srcs := $(filter-out %$(BPF_PROG_EXT),$(BPF_SRCS))
+ifneq ($(lib_bpf_bad_srcs),)
+$(error lib.bpf.mk: BPF_SRCS entries must end in $(BPF_PROG_EXT): $(lib_bpf_bad_srcs))
+endif
+lib_bpf_stems := $(patsubst %$(BPF_PROG_EXT),%,$(notdir $(BPF_SRCS)))
+# The stem becomes the skeleton's C name; reject dots and hyphens.
+lib_bpf_bad_stems := $(strip $(foreach s,$(lib_bpf_stems),			\
+			$(if $(findstring .,$(s))$(findstring -,$(s)),$(s))))
+ifneq ($(lib_bpf_bad_stems),)
+$(error lib.bpf.mk: BPF_SRCS basenames must not contain '.' or '-': $(lib_bpf_bad_stems))
+endif
+# Output names omit directories, so reject duplicate stems.
+ifneq ($(words $(lib_bpf_stems)),$(words $(sort $(lib_bpf_stems))))
+$(error lib.bpf.mk: BPF_SRCS has colliding basenames: $(BPF_SRCS))
+endif
+BPF_SKEL_EXT    ?= .skel.h
+lib_bpf_subskel_ext := $(patsubst %skel.h,%subskel.h,$(BPF_SKEL_EXT))
+# Keep skeleton suffixes distinct and cleanup globs narrow.
+ifeq ($(lib_bpf_subskel_ext),$(BPF_SKEL_EXT))
+$(error lib.bpf.mk: BPF_SKEL_EXT must end in skel.h: $(BPF_SKEL_EXT))
+endif
+BPF_OBJS  := $(addprefix $(BPF_OBJ_DIR)/,$(addsuffix .bpf.o,$(lib_bpf_stems)))
+BPF_SKELS := $(addprefix $(BPF_SKEL_DIR)/,$(addsuffix $(BPF_SKEL_EXT),$(lib_bpf_stems)))
+ifneq ($(BPF_GEN_SUBSKEL),)
+BPF_SUBSKELS := $(addprefix $(BPF_SKEL_DIR)/,$(addsuffix $(lib_bpf_subskel_ext),$(lib_bpf_stems)))
+endif
+
+# Use per-source rules to avoid changing normal .c lookup.
+# Track source headers before BPFOBJ installs their updated copies.
+define lib_bpf_obj_rule
+$(BPF_OBJ_DIR)/$(patsubst %$(BPF_PROG_EXT),%,$(notdir $(1))).bpf.o: $(1)	\
+		$(BPF_EXTRA_HDRS) $(lib_bpf_header_sources)			\
+		$(INCLUDE_DIR)/vmlinux.h | $(BPF_OBJ_DIR) $(BPFOBJ)
+	$$(call lib_bpf_build_rule,$$<,$$@)
+endef
+$(foreach src,$(BPF_SRCS),$(eval $(call lib_bpf_obj_rule,$(src))))
+
+# Generate both headers together so either missing target rebuilds the pair.
+lib_bpf_skel_targets := $(BPF_SKEL_DIR)/%$(BPF_SKEL_EXT)
+ifneq ($(BPF_GEN_SUBSKEL),)
+lib_bpf_skel_targets += $(BPF_SKEL_DIR)/%$(lib_bpf_subskel_ext)
+endif
+
+# Link three times and require the final two objects to match.
+$(lib_bpf_skel_targets): $(BPF_OBJ_DIR)/%.bpf.o $(BPFTOOL) | $(BPF_SKEL_DIR)
+	$(call msg,GEN-SKEL,,$(BPF_SKEL_DIR)/$*$(BPF_SKEL_EXT))
+	$(Q)$(BPFTOOL) gen object $(<:.o=.linked1.o) $<
+	$(Q)$(BPFTOOL) gen object $(<:.o=.linked2.o) $(<:.o=.linked1.o)
+	$(Q)$(BPFTOOL) gen object $(<:.o=.linked3.o) $(<:.o=.linked2.o)
+	$(Q)diff $(<:.o=.linked2.o) $(<:.o=.linked3.o)
+	$(Q)$(BPFTOOL) gen skeleton $(<:.o=.linked3.o) name $* > $(BPF_SKEL_DIR)/$*$(BPF_SKEL_EXT)
+ifneq ($(BPF_GEN_SUBSKEL),)
+	$(Q)$(BPFTOOL) gen subskeleton $(<:.o=.linked3.o) name $* > $(BPF_SKEL_DIR)/$*$(lib_bpf_subskel_ext)
+endif
+	$(Q)rm -f $(<:.o=.linked1.o) $(<:.o=.linked2.o) $(<:.o=.linked3.o)
+
+# Read the header dependencies written by -MMD.
+-include $(BPF_OBJS:.o=.d)
+
+# ---- values for the test Makefile -----------------------------------------
+# Add the installed libbpf/vmlinux.h directory and the skeleton directory.
+CFLAGS += -I$(INCLUDE_DIR) -I$(BPF_SKEL_DIR)
+
+# Add target zstd when found by the target pkg-config.
+PKG_CONFIG ?= $(CROSS_COMPILE)pkg-config
+BPF_LDLIBS := $(BPFOBJ) -lelf -lz
+ifneq ($(shell $(PKG_CONFIG) --exists libzstd 2>/dev/null && echo y),)
+BPF_LDLIBS += -lzstd
+endif
+
+# Add skeletons after lib.mk defines all.
+all: $(BPF_SKELS) $(BPF_SUBSKELS)
+
+# The skeleton already embeds each BPF object in the test binary. To install the
+# objects separately, add TEST_GEN_FILES += $(BPF_OBJS).
+
+# $1 = binary, $2 = test source. Use the same compile and link flags as lib.mk.
+define bpf_link
+	$(call msg,BINARY,,$1)
+	$(Q)$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $2 \
+		$(BPF_LDLIBS) $(LDLIBS) -o $1
+endef
+
+EXTRA_CLEAN += $(sort $(lib_bpf_scratch_dir) $(lib_bpf_host_scratch_dir)) \
+	       $(addprefix $(BPF_OBJ_DIR)/,*.bpf.o *.bpf.d *.linked*.o)	\
+	       $(addprefix $(BPF_SKEL_DIR)/,*$(BPF_SKEL_EXT) *$(lib_bpf_subskel_ext))
-- 
2.53.0-Meta


