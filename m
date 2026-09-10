Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80096C79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48BA56B0096; Thu, 10 Sep 2026 19:33:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 464F16B0098; Thu, 10 Sep 2026 19:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351DC6B0099; Thu, 10 Sep 2026 19:33:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3C156B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:33:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40FB61C213C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:33:35 +0000 (UTC)
X-FDA: 85199456790.26.7D39680
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 77CB840002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:33:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rylZjbkr;
	spf=pass (imf27.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789083213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sOXpeQxVPl5K7YUK8l0Z5dzfobRhaPQ4DBirJcWnNDU=;
	b=XNg0CRLcduR+PMlbD3bTWxUgqjSMfBmgFDHKX4nKFiwejYaZe3CVyjMw5A7PsUTupJOQTF
	G1F1egGyqW1VQINtFIWsdBXwC0Td4lQzMisj83/yaclv3KnMAqwzWUP4/gphiPxhv8fCrU
	PnrPNoH86B0ILhAVX1+bizW3EP8LRvk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rylZjbkr;
	spf=pass (imf27.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789083213;
	b=pr19g3AbAH/fJRbYhKEaFT8hF+sIvko6wj2uSeeFl/IXcMGzbMMFP2B/61SvhfY5SYQawB
	hngLc1Z41FrzjRT6blZfBpTZStY+0MY/wppRf7d41AG/rVESFGTZ+jGzGSeOCO3HTJ+hB1
	keMK4+ebd5Le2bwPBxRy3+cdLHeFpes=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-395cf2535acso367391a91.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789083212; x=1789688012; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sOXpeQxVPl5K7YUK8l0Z5dzfobRhaPQ4DBirJcWnNDU=;
        b=rylZjbkr6bkwNORnbn1Uguv28AUkcsKFY3zxtiB7tiSq/nJalNoO8StAnaia1FQd73
         BmzehiQjPP4Npzoy+mWXzqPEAHiPv1Sv1+xEsrmF9xhxtLy4xaPwd947KzMmvDFIBzi8
         4HW5obi7jYAHqPfG1xJipY3E5z23pDxDaxGNMx3NlPhXL2lxHktF7QjPVRlYByBmmY7o
         0ndGTmu0NACgfIavGhNJwNnTwcBouicWrptli+G8091no7A7ywyKEUnmLA5QxpBKLmHw
         0j+hA8eMAaQA7ki88LKq53q/PimqRiDE7q+HJXZXIupiY19iSbBVGs1CYqA56GhCul7w
         uWgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789083212; x=1789688012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sOXpeQxVPl5K7YUK8l0Z5dzfobRhaPQ4DBirJcWnNDU=;
        b=rF4v86+ux01B6QNIf5jjDrTl7R0sNtc/g1RczeJv/8fQjdoEHcdbqzxlUdUpVl9euT
         uqRh1wqr++9vcKR5AnjY/fl0azPYUrhxy+55NqyOsFn0HHM/bP1GjddXl4pWuuvNITN2
         mvVoHC9eTzTfff8P3cr3r1iPrVrJFxaBrk6Q5eEMdrf0SPNqDi0PAvB6ZstqIWqF1/ie
         Wy4TzFH+LApW0xWeVGir7VlyRyfuSntP6Rbp9z/ti3XpQ4Svve9pJ4GtNpli5vdsQvHU
         3112a520jc52qMrWjuq/BHZMIoqXWobeXY/2WacZ6cvtiiA8pzg+C21AQo+XaDCoE51H
         tFYA==
X-Forwarded-Encrypted: i=1; AKwUvByfC9efpJMKxExM0LxTUaYWnwEPcc7qJ7UJOJQOFeT6iCRTQuEyM76/bWfkjCJtmo3bliClQRlxvA==@kvack.org
X-Gm-Message-State: AFuF++nFTXML2W0vAN3dpzSO2ehPXy3AYFh+p7+xyrhe1He1SUVvRF6E
	FDkPd608pXBS93XyU7zLzxju0yr805Gc/3paCYnALku0tB9ykQ9vxawK
X-Gm-Gg: AYBFou1ErJPu2YZIpZ3L6wlDyZW5SDYkkwOuLoo52hZhE0AS0EstDdREf2OfscWYQbK
	IzSVvAF8QqhPSal5T0oxTwOeGsXupIocHSh5KWeIB0lsRbHrgCtS6BCoFoUAbw1RxKB7gJ59fKh
	os2O4VFsvkF9299Fj18fKNhHV2fiUAUmBd2yjBDg76yYX/mU2fLQ8MB91sU+WZk3DpDj0FQG3YM
	POHGaELdugf8Y+WvDoHosKnJqu7FQEWSYO/78NGwPflMp2zBuuew1otg8NaXSBAvOX+8TsX8qN+
	D9W9nW8sI/bugVagCFrq4Amm3Kji9pDLUTcL/G69/aeWlusmjWWbfHj6v+194PQkHbwn6WM3sre
	XGyOj351ikb5vnjkwhPoGpgGttCGnSH/mJGLqJUo6WpX0bbxnSymcO9m2D8EsDujphoerivl5lg
	xUHzWbSOsjMDrZn18NO2fvX/CXSzGsiuNzPpekmvaA6iNuhhITKyuTEy0uPMS655uP8A==
X-Received: by 2002:a17:90b:2d82:b0:39d:6c95:7e4 with SMTP id 98e67ed59e1d1-39d77d205f7mr8198169a91.31.1789083211973;
        Thu, 10 Sep 2026 16:33:31 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:6f::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4fa50efsm1436360eec.28.2026.09.10.16.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 16:33:31 -0700 (PDT)
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
Subject: [PATCH v5 1/4] selftests: add shared lib.bpf.mk to build BPF progs and skeletons
Date: Thu, 10 Sep 2026 16:33:00 -0700
Message-ID: <20260910233303.1063501-2-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260910233303.1063501-1-ziyang.meme@gmail.com>
References: <20260910233303.1063501-1-ziyang.meme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 77CB840002
X-Stat-Signature: thdgr94sh6b6m8kpffgnx8fxp645ze9b
X-Rspam-User: 
X-HE-Tag: 1789083213-254424
X-HE-Meta: U2FsdGVkX1/f5JxkiCBd+CSXtiYtd6y6ewiN+Uxs6Nu0TUYCXWfG0Hm74nQbKCklU9HAtYVWQPMPpJzII8cdxGGnbazOq5lWCpti1bqzIbRhQz6778JW8mLnJ7kTUO84vDaqNOTljPGgw7QN7tEI9VkHiQwLPSdpBJnnX4KACETDr2dczIRJoyYCIMvZM6e2hrO04IoqmngMFxBopNpiagYRGew9b64crHlereUHUUC2FvBEDSWMJmFbXUnK+HmuMQ8GTyBYA/vtBPShR3syIX8/ReLM3pAjtNdp7lJ1feDiFH5NP4AFzlYwXc3q0oj7TumINHpwbLXaZI445Epf8x9KLzWtpXe89wkMNNNxyKjg92SjI7uhEuEwJ+OcSgF6wp5bMViZ2b8r3NiAEbVXxpg4YvLhrILnKoNwo0I76DWzQYiveejBUDkg/1up48/2xKbvro7AiL/KTzks3r/wFK4YpeavYskkSsiehyhQ32TEWmg1W+hCzgAnldKqocEEcT8e8VJ9zsR9r1f7+vrFiYwoMyze7ZoCuThdbemrOn8vZ3NGkZleqEgD7N0hdQxkQeoy9jh3f5cW8un8hsnHqA/NJq2ywYYQkXDSGz7+y+BZcKaXoKQherPs+I/yTCI+99DqOBjU+l77UFauK/GYCuPmE69rUWjUb0iunSNKVeaZww9n7FbnFWEIN3IjIHTC3fRHHSTleXVquy+LE+OxHawKGVzgnIIwXBQWByg7+SJWDJ7PIFwhDvlyf+jYYtI8Te72VSXkIzNTYsVkeBWkRINmCDkRyWp8C7V13J8pnp6IUwbdeb+nxHwIZ9PtWSL8YhCwXrtjJTWLC0TVE+Q3CY440HFOARpqCT647LLKUfpWkaMR/XYNntJyTADrHe1qSSIndsmvpRHFq4mt22VaAgLAdfXrh8TNBf+n6m1Cg4HbMNQgeos4zX6xNoBh6B12Y8qzulhobUYVAmJw5g9
 dSgbxbet
 +6GB75cQKHA1KffVVmCEDWBHC8pPB+VI8V40NmasI0lgmz6eVVV2bMbwzzKNcPeas0hNkRV5oaMvi82vxlq8o1jxVrpUfWsQhaW/ISh5XyHt1HrytVyECEbI0mj181MqqTMY41mriNhIlSgpSzYlan0gdkjmgF/LsmAMsS8wQSTPPyFEDpP1E9RYDbE5laSdJX/4QW3EDpGQjeLuuTLuMiASDqkjMNpPvLSftBahiM0PZHY75op5hkvlqicGj8GiMVStLWYW1izmQIgQqOSbjdUZrkR5XUhtsgI72/0nCCNHIdnkwDx+UcztGQ/4/lz3yTqa+W41BhB60Hj2dc/sIWAuqwkOqx3cZV4QIm2V5xPRtMnNpcroBR376yz2mJdg8plbrBD1SC7Qf98Sm68CvbmnT3jFpWNo3EN4OJ170p4c4PnmoNEIyf4kCfdbaDjnaFTIU8WNAPqTXRIgoHZzxAmFeYwECEmgxbI6gV/oLYc9XT5W2GdK8fU+EoHWi+uDrw6alNC0dFvLrtPd/sgHEbMmh0rPHxXSX9j9u/bceI8aTbiwuGEvQAlYqiff06oxay1QagFVQ3FNfA1jC47F8w6Snc8kud5Yio9Oj
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
index 000000000000..9238cbf1de06
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
+# Use a normal edge so dependents see a changed header in the same make run.
+$(lib_bpf_vmlinux_h): $(lib_bpf_vmlinux_stamp) ;
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


