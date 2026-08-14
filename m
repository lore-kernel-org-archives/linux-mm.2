Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84C4EC5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 07:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EFBA6B0640; Fri, 14 Aug 2026 03:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CEA26B0641; Fri, 14 Aug 2026 03:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DD276B0642; Fri, 14 Aug 2026 03:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE666B0640
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:51:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C492A403B7
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:51:15 +0000 (UTC)
X-FDA: 85099104510.29.D0A4170
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id F1BE780002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:51:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=btZ1Lho6;
	spf=pass (imf30.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786693874;
	b=0ri4hmeoF2jrPUHR8Bwp566dkgHgU3Uu+4Ckyl/KK0LrziIM/14MPlv1LWh4vy+UCCxpLP
	aSPjRyEHTaAha7Keq9cVPbjVjJnPj9E0FD8UtI5nGMDsT9OnINRHSDO9gGRZcuGpX83Rwz
	ybr3b2NWryGMEWINxvvx/NL9rmAgB3s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=btZ1Lho6;
	spf=pass (imf30.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786693874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89IA+PFSruYcLCZ4LIxATlaba57zWC2jPqnIwBR3MIY=;
	b=5w/iRBnaTAJEZv2ToyGc9WtDi60JCx0kRvgrTU5UvGBs/giEH2QmEW1vZecqrr0O4uyfIH
	1lFtL69Y5gVNVsxht60ziNlrT/tMwYszIbCTZO4ZTKdaPHQ/IKYRosLNwzgyWYep2eA0Mp
	Ib854aT9iWSBzTtdOewDfsyfStfl+kE=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c9e607d81fcso405400a12.2
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 00:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786693873; x=1787298673; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=89IA+PFSruYcLCZ4LIxATlaba57zWC2jPqnIwBR3MIY=;
        b=btZ1Lho6s7htv+R4+PpKRaMeJfO8vPcScEmY+kadZCxdV1+nE0q8Z3XaIWQi9BfTmv
         oM7iH4mIqQYoQcrHH+1WKdEjgXnLEepNfqtCc/lSiTiSL/ixqqoxakvPAg1SdBRyy3CE
         Cr70EhP9MyCu8WqgRIwSjZHCt6dB2PYB7EzMwXJ17ZvtaVBm+xizyGkmn5Oqh7mG7HeU
         k80n64Sp548esdJFpkNstkl+r8L5fVIsuIr1XpODxN8pCNtrA+01vufwIcKtESG3Uy8u
         hFsvP7ExWDG8ST5WHXMLOfh4ekn0i5WdF/Qt9V0Vh4O+hC2Ns3QGbEVw4/rHlqbS5Vw3
         KB+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786693873; x=1787298673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=89IA+PFSruYcLCZ4LIxATlaba57zWC2jPqnIwBR3MIY=;
        b=TrfDOfpeEu4x4tu4LsphmesyEt4GIIgnVB8RaR0P/Ql9LaOVEnMHw20hgJLKECXi+0
         IXHcvcIj3J32vNWOI6V77N40bU7WJd7WgE5jgfzx0tMIla9SJRucAVFozf0e488/L4IE
         gchIm51YJACZdr37zfNTuR43Gh17oFNrtneT/NE+4Mx3TpCcpbt5/4e+3kwg/rx/YNBI
         bq+0LIZLedRhJ52HuBmFsaffrmqpDKDf8Lo1/XH+OLTxTtMpuLRy7AtFj4+BO/6grsy5
         Rpr7tCybo4QLBEiQNhJiZtse2BN6Ib5/cI1vXkyLlcc2NFNWhWWYLy0iXJLk6caXnPsF
         6B9g==
X-Forwarded-Encrypted: i=1; AHgh+RrJzhqbssktIMGxOsFcjBgnSZfVi+QDKQNgow8RG9xE7W9uMKIlAikLcwal2c6xH3VAGaQX+zEk+g==@kvack.org
X-Gm-Message-State: AOJu0YwkEAomNJ/sHzqSLuWECnR+kL2d4GBHgYUDrTfpREMDG6XQnWCs
	Vrgb405OCDfAru/V3TYsKw61Dhal+PadTuv2QhE+0Vvur4zLGCW+ngdm
X-Gm-Gg: AR+sD10oga/ilbz/q/iT9S3AzElqUGKUu+hVEzP6hR01CsukgLifavcK5I2B1RtwgoZ
	ss20H3nCYgZAxzUmJmvmFG+Q8TDq+rZYQ4f/KUG50Da5q0kOvXdHnoGSYfKy66CIhedC6usX/51
	QY1cZb6g7LQ3yL+KK5Iu2PirJL3/zOGNQre+GTJ8rxVunfijUIfDlBsr+SWYQ6rCBCDAZ+ezyKF
	qYX7FSRGJEfWjrtdOinurEsg72AkfGjI6JdQxSmXHknHYGrKKCRCet2UVAcAHk9aRlYDUnLCnDR
	UIKdknLXComT1cY+R3PrXU5CQRPsVtZUMZj89AyYfHq+xRm0vP7gbAooPWhuhPvbVX3t+0e1n7q
	S+CVijHrfUzWCmt4+d57jKTnEZjZ5jRWIgf8H4Hc4DTds+9PhOMoqhuVnluKK/ctllWsBO3UIq3
	dE3ugFbtwv+LwOyPazoI5fOVB5PSpXVy35mRXnxbmmzF4UldoxKrGnslk=
X-Received: by 2002:a05:6a21:e8c:b0:3c3:954d:279a with SMTP id adf61e73a8af0-3cc71d8eafdmr4199683637.33.1786693872620;
        Fri, 14 Aug 2026 00:51:12 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:6f::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1413889d914sm6565897c88.13.2026.08.14.00.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 00:51:11 -0700 (PDT)
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
Subject: [PATCH v3 1/4] selftests: add shared lib.bpf.mk to build BPF progs and skeletons
Date: Fri, 14 Aug 2026 00:50:51 -0700
Message-ID: <20260814075054.507089-2-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260814075054.507089-1-ziyang.meme@gmail.com>
References: <20260814075054.507089-1-ziyang.meme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F1BE780002
X-Stat-Signature: 7dgskp69agzporb6k4e8aom8ritpjue6
X-HE-Tag: 1786693873-874966
X-HE-Meta: U2FsdGVkX1+hYLxL3P7UMhEjeEpLu8qBajadAfJnkidykl+Ydm4TuJb0RlEn4MVbSIDUvKbp2GVpK3aPWm40byP4bgALCWKsNk/H9CenBD0xVAV+lKzPwi58dKvUdtrfiEqE5AYZQuMa/04pJD20i7dvB1yLV5+Rtl93Pb8BcJeeZnbcprvXerlCyYAbHiAmvbdl7m+LRJLG7Dgn3V9M+EwJKf8F+udl0dciCOoi4NhBlBLycJ4LFaSlWQDlPzVdcgwPdw6B6UIaVfdGBVmoLHXQ7Kfh6SBBjfjhbRNW3JFQ2B5N4kwY290BHe2vKxBKRTvHB4gCHlEog6Ek1kiLYQUsLFOL2G9dQ3p0BK4/ZqjHxGl0cezybzSWMG4vyYz5cmlNnwwn5bJOXib2YLm9gclPiUPgs/+gWI38Vr7/WgqO6vF2d5lqog3OrQM6hcT1b68Ktfq+vsAoVjrKBD50DAWe9VNMlStDZe+G9yXceVASDkUrbTLPa1KqJlZ2DGVc7kdw36JmlH0n6uyXMm7G6SmmLRjZ1LH89qhIJWxBSPMDtBz+MntMyVmcm0+xioxBUXuxoRPneNMQ0UV3pPqHJKmFPkCexO5fbhw5vObIH2Xi6uOxLtr6VqXu9M15Bx3VVJH87fN3xZCXcBXf+sfi98kaXytt6UyvWcSmeMBLg1uV6Cwa3ErIv4JV1qyixtn2oiXKDVp9vtP5thDgLIhzxGZbb63j1VGBQBM7hMJERjVDI0wva5YIosCLd0cvmBVLGyBLWhQWgcHYkk7+4/5dSl5+cdqR5OpPHfDbffurOS9G2qRymZlNFSTOtFhik6tRM8BsYE+csH7SvGoif2bqKPS5H8rl21T3rF2wzNVQkvOsWW7MuV61OthnO7ZtiDkW85DgQMKob7zG3wR7iFANOzgPItQxm1/OgXrxzviOICw+IqMUhiXZM9T5FiI8EoZYCRoJ62wyulRH1Vzd0gd
 lfa7gR8Q
 q1eSvqB7b3SFCuqd4Gyd+tH8Ks0ThgTPeBpAY41f7fNm39mlGz2yVrIvTYRK5QhX8NdPUgLF1AeYwXAN9ZpdmBAEuNwoyxEiWkqjHano0btUjJlJyswu6mDHy1+mZww0zKi0tKrkD5wuzSESaZkA7qpmTCwX8ta/2yoVUpXfu9boQlI1K38DxIinTgYS6VGdSDrTyL5waceWXdMKXR8/3wTxi9UqxxtNsPrnF2PIfHia5QI4DaqnOaXcHv3rL7UNw2tqcJpHEFfOYUpISmaGRlNFVuL16E+9RsS80LI58TMPGE9uBhR8ArW0PNN1miRs9ic31h6tMvgWlfgLOaKgEiPT0uKIsTUXtS/9QnOUJEKoBv/UqE3QSSUXXztZTahMPeIlwe56wEiGDl0SOjRQY7GWhCv69JNcpOi2uj33R/TtOSbSz8Feb9r3NLMTKrXhqk+I6dCjtdVzP9RSS71EihEekIMIYq2nCWG3doGIXSYyvBNfxIWlqQ5auzacrYB3RN0YSCjMRUwwuXi10iURGOt4UJ993mdlJBZxY8o6ujEcD4XQV5luPLhreLtv9wtToyY/BUhsOd4zirQMgnKZq2QHXmqlGkzMvK7OL
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
 tools/testing/selftests/lib.bpf.mk | 296 +++++++++++++++++++++++++++++
 1 file changed, 296 insertions(+)
 create mode 100644 tools/testing/selftests/lib.bpf.mk

diff --git a/tools/testing/selftests/lib.bpf.mk b/tools/testing/selftests/lib.bpf.mk
new file mode 100644
index 000000000000..433a26a36960
--- /dev/null
+++ b/tools/testing/selftests/lib.bpf.mk
@@ -0,0 +1,296 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Build BPF programs and skeleton headers for selftests, then link them into
+# test binaries.
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
+# Keep $(BPFOBJ) in the dependencies so make relinks the test when libbpf.a
+# changes.
+#
+# Options to set before including lib.bpf.mk:
+#   BPF_PROG_EXT     - source ending; default .bpf.c. Use .c for progs/foo.c.
+#   BPF_EXTRA_HDRS   - more headers needed by the BPF objects.
+#   BPF_EXTRA_CFLAGS - more flags for compiling BPF programs.
+#   BPF_SKEL_EXT     - skeleton header ending; default .skel.h.
+#   BPF_GEN_SUBSKEL  - also create a subskeleton header when set.
+#   BPF_OBJ_DIR      - folder for BPF objects; default $(OUTPUT).
+#   BPF_SKEL_DIR     - folder for skeleton headers; default $(OUTPUT).
+#
+# You may replace BPF_CFLAGS after including this file. Make reads it when each
+# object is built. Sources may be in subfolders, but generated files use only
+# the source filename and are placed directly in their output folder.
+#
+# Include lib.mk first. This file uses OUTPUT, top_srcdir, CC, CLANG, Q and msg.
+# OVERRIDE_TARGETS stops lib.mk from adding its normal link rule. This file sets
+# BPFOBJ, BPFTOOL, BPF_OBJS, BPF_SKELS and BPF_LDLIBS, and adds to CFLAGS and
+# EXTRA_CLEAN.
+
+include $(top_srcdir)/tools/scripts/Makefile.arch	# ARCH / SRCARCH / HOSTARCH
+
+# Some commands write bpftool output straight to $@. Remove a partial file when
+# a command fails.
+.DELETE_ON_ERROR:
+
+# Use matching host tools for libbpf and bpftool. This keeps an LLVM build from
+# mixing Clang and GCC. Makefile.include is not used because it would also
+# change the test's AR, LD, CXX and CFLAGS.
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
+submake_extras := feature_display=0
+endif
+
+# Pass RELEASE, OPT_FLAGS and EXTRA_CFLAGS to the libbpf and bpftool builds,
+# matching selftests/bpf/Makefile.
+OPT_FLAGS ?= $(if $(RELEASE),-O2,-O0)
+
+# ---- files and tools ------------------------------------------------------
+# Use one full path. Different forms of the same -I path can change BTF order.
+TOOLSDIR    := $(abspath $(top_srcdir)/tools)
+LIBDIR      := $(TOOLSDIR)/lib
+BPFDIR      := $(LIBDIR)/bpf
+TOOLSINCDIR := $(TOOLSDIR)/include
+BPFTOOLDIR  := $(TOOLSDIR)/bpf/bpftool
+APIDIR      := $(TOOLSINCDIR)/uapi
+
+# Keep private build files under $(OUTPUT) for both in-tree and O= builds.
+SCRATCH_DIR := $(OUTPUT)/tools
+BUILD_DIR   := $(SCRATCH_DIR)/build
+INCLUDE_DIR := $(SCRATCH_DIR)/include
+BPFOBJ      := $(BUILD_DIR)/libbpf/libbpf.a
+
+# bpftool runs on the build host. Build a separate host libbpf when the target
+# architecture is different.
+ifneq ($(CROSS_COMPILE)$(filter-out $(HOSTARCH),$(SRCARCH)),)
+HOST_BUILD_DIR   := $(BUILD_DIR)/host
+HOST_SCRATCH_DIR := $(OUTPUT)/host-tools
+else
+HOST_BUILD_DIR   := $(BUILD_DIR)
+HOST_SCRATCH_DIR := $(SCRATCH_DIR)
+endif
+HOST_BPFOBJ     := $(HOST_BUILD_DIR)/libbpf/libbpf.a
+DEFAULT_BPFTOOL := $(HOST_SCRATCH_DIR)/sbin/bpftool
+BPFTOOL         ?= $(DEFAULT_BPFTOOL)
+
+# When host and target are the same, bpftool uses the target libbpf and needs
+# the same USERCFLAGS. Do not pass USERCFLAGS to separate host tools.
+ifeq ($(BPFOBJ),$(HOST_BPFOBJ))
+HOST_USERCFLAGS := $(USERCFLAGS)
+endif
+
+# ---- find vmlinux BTF -----------------------------------------------------
+VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
+		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
+		     $(top_srcdir)/vmlinux				\
+		     /sys/kernel/btf/vmlinux				\
+		     /boot/vmlinux-$(shell uname -r)
+VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
+# When VMLINUX_H is not set, report a missing vmlinux only while building
+# vmlinux.h. Reporting it here would also make "make clean" fail.
+
+# ---- compiler flags -------------------------------------------------------
+# Find the normal system headers that Clang omits with --target=bpf. Put them
+# last with -idirafter so they cannot replace project headers.
+define get_sys_includes
+$(shell $(1) $(2) -v -E - </dev/null 2>&1 \
+	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
+$(shell $(1) $(2) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
+endef
+ifneq ($(CROSS_COMPILE),)
+CLANG_TARGET_ARCH = --target=$(notdir $(CROSS_COMPILE:%-=%))
+endif
+# Find the system include flags once and reuse them.
+CLANG_SYS_INCLUDES := $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
+
+IS_LITTLE_ENDIAN := $(shell $(CC) -dM -E - </dev/null | \
+			grep 'define __BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__')
+MENDIAN := $(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
+
+# Use BPF CPU v3 when Clang supports it. Otherwise use v2.
+CLANG_BPF_CPU := $(shell $(CLANG) --target=bpf -mcpu=help 2>&1 | grep -q 'v3' \
+			 && echo v3 || echo v2)
+
+# vmlinux.h can contain anonymous struct and union members. Clang needs
+# -fms-extensions to accept them.
+BPF_CFLAGS = -g -Wall -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)	\
+	     -I$(INCLUDE_DIR) -I$(APIDIR) -I$(TOOLSINCDIR)		\
+	     -std=gnu11							\
+	     -fno-strict-aliasing					\
+	     -fms-extensions -Wno-microsoft-anon-tag			\
+	     -Wno-compare-distinct-pointer-types			\
+	     $(CLANG_SYS_INCLUDES) $(BPF_EXTRA_CFLAGS)
+
+# $1 = source, $2 = object. -MMD -MP records every included header, including
+# headers included by other headers.
+define BPF_BUILD_RULE
+	$(call msg,CLNG-BPF,,$2)
+	$(Q)$(CLANG) $(BPF_CFLAGS) -O2 --target=bpf -mcpu=$(CLANG_BPF_CPU) \
+		-MMD -MP -c $1 -o $2
+endef
+
+# ---- output folders -------------------------------------------------------
+BPF_OBJ_DIR  ?= $(OUTPUT)
+BPF_SKEL_DIR ?= $(OUTPUT)
+
+# ---- build folders --------------------------------------------------------
+MAKE_DIRS := $(sort $(BUILD_DIR)/libbpf $(HOST_BUILD_DIR)/libbpf		\
+		    $(HOST_BUILD_DIR)/bpftool $(INCLUDE_DIR)		\
+		    $(filter-out $(OUTPUT),$(BPF_OBJ_DIR) $(BPF_SKEL_DIR)))
+$(MAKE_DIRS):
+	$(call msg,MKDIR,,$@)
+	$(Q)mkdir -p $@
+
+# ---- target libbpf --------------------------------------------------------
+# Pass ARCH, CROSS_COMPILE and CC because lib.mk does not export CC. -fPIC lets
+# libbpf.a link into PIE test binaries. libbpf reads EXTRA_CFLAGS, so pass
+# USERCFLAGS there too.
+$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile) \
+	   $(APIDIR)/linux/bpf.h | $(BUILD_DIR)/libbpf
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/ \
+		    ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) CC="$(CC)"     \
+		    EXTRA_CFLAGS='-g $(OPT_FLAGS) -fPIC $(EXTRA_CFLAGS) $(USERCFLAGS)' \
+		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
+
+# ---- host libbpf, only when the target differs ----------------------------
+ifneq ($(BPFOBJ),$(HOST_BPFOBJ))
+$(HOST_BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile) \
+		$(APIDIR)/linux/bpf.h | $(HOST_BUILD_DIR)/libbpf
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) ARCH= CROSS_COMPILE=	      \
+		    OUTPUT=$(HOST_BUILD_DIR)/libbpf/ CC="$(HOSTCC)" LD="$(HOSTLD)" \
+		    EXTRA_CFLAGS='-g $(OPT_FLAGS) $(EXTRA_CFLAGS)' \
+		    DESTDIR=$(HOST_SCRATCH_DIR) prefix= all install_headers
+endif
+
+# ---- host bpftool ---------------------------------------------------------
+$(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) \
+		    $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/bpftool
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFTOOLDIR)		  \
+		    ARCH= CROSS_COMPILE= CC="$(HOSTCC)" LD="$(HOSTLD)" \
+		    EXTRA_CFLAGS='-g $(OPT_FLAGS) $(EXTRA_CFLAGS) $(HOST_USERCFLAGS)' \
+		    EXTRA_LDFLAGS='$(EXTRA_LDFLAGS)'		  \
+		    OUTPUT=$(HOST_BUILD_DIR)/bpftool/		  \
+		    LIBBPF_OUTPUT=$(HOST_BUILD_DIR)/libbpf/	  \
+		    LIBBPF_DESTDIR=$(HOST_SCRATCH_DIR)/		  \
+		    prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install-bin
+
+# ---- build vmlinux.h ------------------------------------------------------
+# Replace vmlinux.h only when its contents change. A new timestamp alone would
+# rebuild every BPF object and skeleton.
+$(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL) | $(INCLUDE_DIR)
+ifeq ($(VMLINUX_H),)
+	$(call msg,GEN,,$@)
+	$(Q)test -n "$(VMLINUX_BTF)" || { \
+		echo "lib.bpf.mk: no vmlinux with BTF at any of \"$(VMLINUX_BTF_PATHS)\"" >&2; \
+		exit 1; }
+	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@.tmp
+else
+	$(call msg,CP,,$@)
+	$(Q)cp "$(VMLINUX_H)" $@.tmp
+endif
+	$(Q)cmp -s $@.tmp $@ || mv $@.tmp $@
+	$(Q)rm -f $@.tmp
+
+# ---- BPF objects and skeletons --------------------------------------------
+BPF_PROG_EXT ?= .bpf.c
+# Each source must end with BPF_PROG_EXT so Make can remove that ending.
+bpf_bad_srcs := $(filter-out %$(BPF_PROG_EXT),$(BPF_SRCS))
+ifneq ($(bpf_bad_srcs),)
+$(error lib.bpf.mk: BPF_SRCS entries must end in $(BPF_PROG_EXT): $(bpf_bad_srcs))
+endif
+bpf_stems := $(patsubst %$(BPF_PROG_EXT),%,$(notdir $(BPF_SRCS)))
+# Reject any dot left after removing BPF_PROG_EXT. For example, foo.bpf.c leaves
+# foo.bpf when the ending is set to .c.
+bpf_dotted_stems := $(filter-out $(basename $(bpf_stems)),$(bpf_stems))
+ifneq ($(bpf_dotted_stems),)
+$(error lib.bpf.mk: BPF_SRCS basenames must not contain a dot: $(bpf_dotted_stems))
+endif
+# Generated files use only the source filename. Reject equal filenames instead
+# of letting one replace another.
+ifneq ($(words $(bpf_stems)),$(words $(sort $(bpf_stems))))
+$(error lib.bpf.mk: BPF_SRCS has colliding basenames: $(BPF_SRCS))
+endif
+BPF_SKEL_EXT    ?= .skel.h
+BPF_SUBSKEL_EXT := $(patsubst %skel.h,%subskel.h,$(BPF_SKEL_EXT))
+# BPF_SKEL_EXT must end in skel.h so the subskeleton gets a different name.
+ifneq ($(BPF_GEN_SUBSKEL),)
+ifeq ($(BPF_SUBSKEL_EXT),$(BPF_SKEL_EXT))
+$(error lib.bpf.mk: BPF_GEN_SUBSKEL needs BPF_SKEL_EXT to end in skel.h: $(BPF_SKEL_EXT))
+endif
+endif
+BPF_OBJS  := $(addprefix $(BPF_OBJ_DIR)/,$(addsuffix .bpf.o,$(bpf_stems)))
+BPF_SKELS := $(addprefix $(BPF_SKEL_DIR)/,$(addsuffix $(BPF_SKEL_EXT),$(bpf_stems)))
+
+# Make one rule for each source. A global vpath would also match the test's
+# normal C rules when BPF_PROG_EXT is .c.
+define bpf_obj_rule
+$(BPF_OBJ_DIR)/$(patsubst %$(BPF_PROG_EXT),%,$(notdir $(1))).bpf.o: $(1)	\
+		$(BPF_EXTRA_HDRS) $(INCLUDE_DIR)/vmlinux.h			\
+		| $(BPF_OBJ_DIR) $(BPFOBJ)
+	$$(call BPF_BUILD_RULE,$$<,$$@)
+endef
+$(foreach src,$(BPF_SRCS),$(eval $(call bpf_obj_rule,$(src))))
+
+# Link three times and compare the last two outputs. A correct linker must not
+# change an object that it already linked.
+$(BPF_SKELS): $(BPF_SKEL_DIR)/%$(BPF_SKEL_EXT): $(BPF_OBJ_DIR)/%.bpf.o $(BPFTOOL) | $(BPF_SKEL_DIR)
+	$(call msg,GEN-SKEL,,$@)
+	$(Q)$(BPFTOOL) gen object $(<:.o=.linked1.o) $<
+	$(Q)$(BPFTOOL) gen object $(<:.o=.linked2.o) $(<:.o=.linked1.o)
+	$(Q)$(BPFTOOL) gen object $(<:.o=.linked3.o) $(<:.o=.linked2.o)
+	$(Q)diff $(<:.o=.linked2.o) $(<:.o=.linked3.o)
+	$(Q)$(BPFTOOL) gen skeleton $(<:.o=.linked3.o) name $(notdir $(<:.bpf.o=)) > $@
+ifneq ($(BPF_GEN_SUBSKEL),)
+	$(Q)$(BPFTOOL) gen subskeleton $(<:.o=.linked3.o) name $(notdir $(<:.bpf.o=)) > $(@:$(BPF_SKEL_EXT)=$(BPF_SUBSKEL_EXT))
+endif
+	$(Q)rm -f $(<:.o=.linked1.o) $(<:.o=.linked2.o) $(<:.o=.linked3.o)
+
+# Read the header dependencies written by -MMD.
+-include $(BPF_OBJS:.o=.d)
+
+# ---- values for the test Makefile -----------------------------------------
+# Add paths for generated skeletons and vmlinux.h. Put the new libbpf headers
+# first so an older copy under BPF_SKEL_DIR cannot be used by mistake.
+CFLAGS += -I$(INCLUDE_DIR) -I$(OUTPUT) -I$(BPF_SKEL_DIR)
+
+# Add target zstd when pkg-config finds it. A cross build must use the target
+# pkg-config, not the host one.
+PKG_CONFIG ?= $(CROSS_COMPILE)pkg-config
+BPF_LDLIBS := $(BPFOBJ) -lelf -lz
+ifneq ($(shell $(PKG_CONFIG) --exists libzstd 2>/dev/null && echo y),)
+BPF_LDLIBS += -lzstd
+endif
+
+# lib.mk made its "all" list before this file was included. Add the skeletons
+# here so they are built.
+all: $(BPF_SKELS)
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
+EXTRA_CLEAN += $(sort $(SCRATCH_DIR) $(HOST_SCRATCH_DIR))		\
+	       $(addprefix $(BPF_OBJ_DIR)/,*.bpf.o *.bpf.d *.linked*.o)	\
+	       $(addprefix $(BPF_SKEL_DIR)/,*$(BPF_SKEL_EXT) *$(BPF_SUBSKEL_EXT))
-- 
2.53.0-Meta


