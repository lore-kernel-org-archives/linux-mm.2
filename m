Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48513C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 17:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2384B6B009F; Tue, 21 Jul 2026 13:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E8A16B00A1; Tue, 21 Jul 2026 13:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE4C6B00A2; Tue, 21 Jul 2026 13:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE4D36B009F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:48:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60902A07B9
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:48:42 +0000 (UTC)
X-FDA: 85013518884.22.EBC88A3
Received: from mail-pj2-f0.google.com (mail-pj2-f0.google.com [74.125.227.128])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8C18D40007
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:48:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e4ZgV9NI;
	spf=pass (imf12.hostedemail.com: domain of ziyang.meme@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784656120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wb99tNhyMGyQHq+Tc4HfWLLbXPl8M5pWqDy6JsoUgIg=;
	b=e7Wlx9hgk/IsR4GhHGPWERijoEcfElnKlvjp4GVRKanL3TuiNpnCe9OaQY3kO+OZkw6Sbr
	eo4YQyRtidtZYT8far4wYELIW92VhfxOQciSuj3eFTFfE9XJXaPY6gOsnxHDKUZTCOcTxx
	ONGLsnbC+hOXOPgen5DSdLJKQizIo1c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784656120;
	b=exLC7zFdbMfgWOjhPslpbkr83SgZKGp90Z1Wzj4llq9xbTP1LC8GdRWLlUq8MCfZ9NJMdw
	d5aSrrYkYNy/COmeLeJFxec+vcw7DOCycwr2vZtOIA8OJXmVRYa23Sk4qzZAQMg7nK2MNe
	tv1LsIdufHDn29pP77icYhfZWaoQqwU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e4ZgV9NI;
	spf=pass (imf12.hostedemail.com: domain of ziyang.meme@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f0.google.com with SMTP id d9443c01a7336-2cc2c6e0688so98522065ad.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784656119; x=1785260919; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wb99tNhyMGyQHq+Tc4HfWLLbXPl8M5pWqDy6JsoUgIg=;
        b=e4ZgV9NIGJBV2HXiWqSd8otD4iIIikaneGhzqwE58WtpikZ7hCWQ4ozefaTL6oYWGv
         HNu9wwx42brhiO4DcFvmmJxpj+vLiyz3tJ5ZswutX+8evJx/8Th2rn9zRFXmkEfDPA17
         0/ln6w1mIpPkeltBgeYayVW9U747r8Vjq9iOLVo11EzPGjTKVZx4l2iZoah2F+0rDeJT
         mp303asL101vLr0wW+VUovonHtspixl0HMwFrT6rlDnI8AIRKmmANGsDi3b1ifBlboWT
         7W5nRUg5DQ22K3vYckGKNDMdbNYY72ectGRojt9YuEepTb7jmv0y4aFsgK7hxR5sSYSK
         01mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784656119; x=1785260919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wb99tNhyMGyQHq+Tc4HfWLLbXPl8M5pWqDy6JsoUgIg=;
        b=lKstzpIgP5t13YUXwhZu3UymrIlgtR/Nn92we0sbU5otw3+tLAQrSaVVV+NojKE6/9
         VRG3oDS2RyVL+X++UXBPdt1L5C8g259gzINMSoMqS5BucNm+pPigbBA43sPd9LdNVC5n
         eNMlO3vy/MSQybT+C70t8Jttnc/WTaLDD7h9Z9D8yRAkG18ONlrmnin4o2rsxLkJ6Nw5
         8EfkJmK3OrMjIzvcZWnhyDQVy7rVaf5lWnBXA2WGKlV+PI7Hl+Bxiqt0UsFsnRAr7g/m
         dAO3SEpctJhbZ0lp4Xg0rtGQnYqve70noEJuz3XFRlhn6r5Mg/3T+GVe+EiLdHHa2yTz
         QbSw==
X-Forwarded-Encrypted: i=1; AHgh+RoApd8Tb2UgRISZ2n02ES9Hd5i5hHoFa1uZaZaPhjtN/uZa7WdvkcbL1+KjM7o0sWnfyzjkvexucg==@kvack.org
X-Gm-Message-State: AOJu0YzBaQhsG0RH/5bbHaholEsE53d97aaR8fonL1vfbPSEg6sWgkXK
	i0QLPwAYgIawzpL5V6XxlXi5KtCVyn6lBQ3UmottFsnnR1wCXbWQlnAd
X-Gm-Gg: AR+sD12MLvxvf4jwwuxQjpyziBBMZaUBVVPuYnJQknVdglxxMa/IyCJyzG1lF1KNrHn
	thzYhCeyHaIFO2Tk/CFkNSxq+DuY8K7YWx1AYX2NoILm25GdXYU9NDvJ3zZ4BejjLp28X5DkJfc
	8ilUDS8Dmo1ZfChpSFxTRzMs+Vr4ETUUIqtlV0a0LWMWhlJLINz0zfuPcK5qpRad6kNB/wV83tN
	XOvTIMoszWHF6Icn07m/AhMukqy37txVCFtz+KYGMV2ER8FX15FP4rFzsWgM+Gn+ectzxLTnwYB
	bjV2PlABUWRQ+2uAkUYVaPWYaCrZb9bbQi8cTDs2S6KVtx4/b6NK4dhbFS6x5U/dQvWr6/wzWhC
	y8KK3gs1bAbtKeP4jPMUAuiKNjXNhhmuOCyI2z9xeTCFtNTewdOXMvsBNM5twmdPPKsnIw0DJ
X-Received: by 2002:a17:903:1a43:b0:2c9:de53:f84f with SMTP id d9443c01a7336-2cf3487e1e8mr224944495ad.19.1784656119107;
        Tue, 21 Jul 2026 10:48:39 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:65::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e070538sm814563eec.20.2026.07.21.10.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:48:37 -0700 (PDT)
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
Subject: [PATCH v2 1/4] selftests: add shared lib.bpf.mk to build BPF progs and skeletons
Date: Tue, 21 Jul 2026 10:48:30 -0700
Message-ID: <20260721174833.1232771-2-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260721174833.1232771-1-ziyang.meme@gmail.com>
References: <20260721174833.1232771-1-ziyang.meme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8C18D40007
X-Stat-Signature: jtkn47u4bwowyzsccahsecncrpj1qufd
X-Rspam-User: 
X-HE-Tag: 1784656120-840068
X-HE-Meta: U2FsdGVkX18dYDBV1Q8+QUOEWBbwtHDNIie2R5i7QJzn78Cf50Xekr3r5gDtjtkz+h+76+pzHb37Alqti6qfsL4dYXbXYnl7qK5hBkrxJ/EllKYh1qiuKa+oYxtebEpEIq0wQt9PzuAALHloEwzX6Oe/wv9DvHhCO9JUBo7F4+KVXPqMKrtAazlhgtXP99Vg7uN5Z5ZTJZOK4llBQpMUjLUg8hb91AiBg58gabPlVy/qKs6tPcfVdl2agFduhBTdwGmSTGcnqVfcH94UGuTFpVvwfa7CCb7Dl8Q5GBOBdA4jRV9VThOqRHnVCZLKPV6k7+g8+TVHGsXf6wKbtPr24XYyKQICJZPduMp3KrK3fUDDF4J6Mlz8iCRpgFV6EUmScv6v1FPXK+jvZhOBfaWXgErWDkYze35cLvfGgKQIaRsL2C7HVQk+uUS/1njwNtRzi0QYVdsWV0O0cgFA+bRz6Kg2oUUPle6a/CJcaTJV+mVkZzaeTffsFZAB62P3/akImexPgaIi+92lZFfR2q07UZuX8dTM1iRMryeFx6AjPcVi5Kv/YGLQXO4H13+EYAGGcQwBZKSgfjnD2g9v76POOhtImPxBO0FGxv+s+CsRo0kCnWUACwWm1QHwXLXwATlqS2iInoYASQWY2gN3EeKXpbRjxA4NrntBpFsymgOVJ4DkAMc8jRTLlJ7Hy8bbSQeu8HAJVyvmskgzbiicv4qkhWh8zsBiQgiwxf/1SFiIguw7C/Z6TDBP9YivAXpdIxcEEd7FlPB2rUZweflXs1+vPXhITgs3DUPhLKkgaFNpxYmJAwzdnkrlr9JL3hOwSgT/xdGVuBvla2UoMaiH9FRydOvdf5LGIUsXXrCWvJz9iqUIQfSjUa72tLCL88oEZPnuLqXhDToVKiD6x6zxFE0zO6o4daSRFECyg8/ZCIDXs/Z/6wViQr960qTg1C7aJNK0MVlfZiILERqFlMlAXkY
 ff24CB3G
 VAoRfj4uBhaty4FSUJFJYAupHqPKkmtW/HUjDRZrGwUkOvY6+44y9ZHJzFGtcGJ8fCDPfMcKIyj9KalF+fwKO5OyF3s/qpOrCQ541C4melZyaO7elvR1R01UGAjToMN9f1Y3Ot7C2Xf5s8bdO3ax6bD/NgN5UciWzyLjcU/AK9sUk43ZZudJXocVj6GKAbBBFZYibU2UuufLbiZuEuh9MjhnwA6xD1u7xcfLdonJB641O1R6RHub9c4ZMLTzkYvb9QxJgdeJSfxXNCbtv0O0VJ8H/CCOD459gSjSp5aJ0io2TCIl3GYpyU/d+eA3ZvoWboYL8CxWHS7xQ7xhv6Jzky2YteSOd4tMcTDCimSqH07RwuOLFPwgXvoU07Sq8xr3vUtDbi2RfLznN2qAjjUHsVP/HFs2zDgRqIBubVZMoPU/bkXbZxuNKMt5tvyLkqEgPOKN3CR4s9C/Mbxh7OdWst1tC6zJI20wfh8K02MfwCva+BK5kEKd78uFGjP6JaTH9ielejUFkgVdMzkn67MtNgE/7psZmx96uoUItFCnCxjX7rQB9PafTxkcMh2bM2GqGm0nl+k6b3CAMnmZbSIhW6csBT5FXkB1sc7b1
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

Add tools/testing/selftests/lib.bpf.mk, a single includable fragment that
provides the whole chain end-to-end. It builds the in-tree libbpf.a and a
host bpftool, generates vmlinux.h from the kernel's BTF, compiles *.bpf.c
into BPF objects (clang --target=bpf) and generates their skeletons. It
also provides what the user-space test binary needs to build: the header
search paths (so #includes resolve), a bpf_link macro that wraps the link
command, and BPF_LDLIBS, so the test can be statically linked against
libbpf.a.

To use: set BPF_SRCS and OVERRIDE_TARGETS := 1 before including ../lib.mk
(so lib.mk's default link rule is suppressed), then include ../lib.bpf.mk
and list $(BPF_SKELS) as prerequisites of the test binary, e.g.,:

    BPF_SRCS         := progs/foo.bpf.c
    OVERRIDE_TARGETS := 1
    include ../lib.mk
    include ../lib.bpf.mk
    $(OUTPUT)/foo_test: foo_test.c $(BPF_SKELS)
            $(call bpf_link,$@,$<)

This saves much work for configuring selftests in other folder, such the cgroup.

net/bpf.mk (which only builds *.bpf.o, without skeleton or vmlinux.h
generation) is left unchanged; replacing the existing duplication
mentioned above is the next step.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
Suggested-by: Mykola Lysenko <mykolal@meta.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/lib.bpf.mk | 247 +++++++++++++++++++++++++++++
 1 file changed, 247 insertions(+)
 create mode 100644 tools/testing/selftests/lib.bpf.mk

diff --git a/tools/testing/selftests/lib.bpf.mk b/tools/testing/selftests/lib.bpf.mk
new file mode 100644
index 000000000000..6f175c6568e9
--- /dev/null
+++ b/tools/testing/selftests/lib.bpf.mk
@@ -0,0 +1,247 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Shared fragment for selftests that compile *.bpf.c into BPF objects +
+# skeletons and link them into userspace test binaries, without each
+# subsystem's Makefile re-implementing the libbpf/bpftool/vmlinux.h machinery.
+#
+# Caller contract (per-test Makefile):
+#
+#     BPF_SRCS         := foo.bpf.c bar.bpf.c
+#     TEST_GEN_PROGS   := foo_test
+#     OVERRIDE_TARGETS := 1              # MUST be set before lib.mk
+#     include ../lib.mk                  # defines OUTPUT, CC, Q, msg,
+#     include ../lib.bpf.mk              #   selfdir, top_srcdir; honours OVERRIDE
+#
+#     $(OUTPUT)/foo_test: foo_test.c $(BPF_SKELS)
+#         $(call bpf_link,$@,$<)
+#
+# Optional knobs (set before including lib.bpf.mk):
+#   BPF_PROG_EXT     - source suffix, default .bpf.c; set to .c for the legacy
+#                      "progs/foo.c -> foo.bpf.o" layout.
+#   BPF_EXTRA_HDRS   - extra prerequisites (headers) for the BPF objects.
+#   BPF_EXTRA_CFLAGS - appended to BPF_CFLAGS for the BPF compile.
+#   BPF_SKEL_EXT     - skeleton suffix, default .skel.h (e.g. .bpf.skel.h).
+#   BPF_GEN_SUBSKEL  - if set, also emit a subskeleton next to each skeleton.
+#   BPF_OBJ_DIR      - dir for generated *.bpf.o (default $(OUTPUT)).
+#   BPF_SKEL_DIR     - dir for generated skeletons (default $(OUTPUT)).
+# A caller with unusual compile needs may override BPF_CFLAGS wholesale after
+# the include (the object recipe expands it lazily).
+# BPF_SRCS entries may live in a subdirectory (e.g. progs/foo.bpf.c); the
+# objects and skeletons are always emitted flat under $(OUTPUT), keyed by the
+# source basename (foo.bpf.o / foo.skel.h).
+#
+# lib.mk MUST be included first: this fragment consumes the vars it defines
+# (OUTPUT, top_srcdir, CC, CLANG, Q, msg) and needs OVERRIDE_TARGETS to have
+# already suppressed lib.mk's default link rule.
+
+include $(top_srcdir)/tools/scripts/Makefile.arch	# ARCH / SRCARCH
+# Pull in the shared toolchain definitions (HOSTCC/HOSTLD/CLANG) so this
+# fragment picks the *same* host compiler the libbpf and bpftool sub-makes
+# will: in particular HOSTCC becomes clang under LLVM=1 (gcc otherwise).
+# Without this the host bpftool and its bootstrap libbpf can end up built with
+# a mix of gcc and clang, which trips clang on gcc-only flags (-Wstrict-aliasing=3).
+#
+# Makefile.include's allow-override resets CC to a bare "clang", which would
+# drop the --target=<arch> flag lib.mk set for LLVM=1 cross builds (make LLVM=1
+# ARCH=arm64).  lib.mk ran first and configured CC for the target, so save it
+# across the include and restore it afterwards.
+lib_bpf_mk_saved_cc := $(CC)
+include $(top_srcdir)/tools/scripts/Makefile.include
+CC := $(lib_bpf_mk_saved_cc)
+
+CLANG  ?= clang
+HOSTCC ?= gcc
+HOSTLD ?= ld
+ifneq ($(V),1)
+submake_extras := feature_display=0
+endif
+
+# ---- paths & tools --------------------------------------------------------
+TOOLSDIR    := $(top_srcdir)/tools
+LIBDIR      := $(TOOLSDIR)/lib
+BPFDIR      := $(LIBDIR)/bpf
+TOOLSINCDIR := $(TOOLSDIR)/include
+BPFTOOLDIR  := $(TOOLSDIR)/bpf/bpftool
+APIDIR      := $(TOOLSINCDIR)/uapi
+
+# Everything generated lives under $(OUTPUT) so O= and in-tree both work and
+# per-test builds (distinct $(OUTPUT)) never collide.
+SCRATCH_DIR := $(OUTPUT)/tools
+BUILD_DIR   := $(SCRATCH_DIR)/build
+INCLUDE_DIR := $(SCRATCH_DIR)/include
+BPFOBJ      := $(BUILD_DIR)/libbpf/libbpf.a
+
+# bpftool must run on the *host*; split the host toolchain out when cross-building.
+ifneq ($(CROSS_COMPILE),)
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
+# ---- vmlinux BTF discovery -----------------------------------------------
+VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
+		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
+		     $(top_srcdir)/vmlinux				\
+		     /sys/kernel/btf/vmlinux				\
+		     /boot/vmlinux-$(shell uname -r)
+VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
+ifeq ($(VMLINUX_BTF),)
+$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
+endif
+
+# ---- clang flags ----------------------------------------------------------
+# Clang's default system includes (not the ones seen under --target=bpf); fixes
+# "missing" asm/byteorder.h etc. '-idirafter' so we never shadow real includes.
+define get_sys_includes
+$(shell $(1) $(2) -v -E - </dev/null 2>&1 \
+	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
+$(shell $(1) $(2) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
+endef
+ifneq ($(CROSS_COMPILE),)
+CLANG_TARGET_ARCH = --target=$(notdir $(CROSS_COMPILE:%-=%))
+endif
+CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
+
+IS_LITTLE_ENDIAN = $(shell $(CC) -dM -E - </dev/null | \
+			grep 'define __BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__')
+MENDIAN = $(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
+
+# Prefer -mcpu=v3; fall back to v2 on clang too old to know it (probed once).
+CLANG_BPF_CPU := $(shell $(CLANG) --target=bpf -mcpu=help 2>&1 | grep -q 'v3' \
+			 && echo v3 || echo v2)
+
+# -fms-extensions + -Wno-microsoft-anon-tag: required so clang accepts the
+# anonymous nested struct/union members bpftool emits into vmlinux.h.
+BPF_CFLAGS = -g -Wall -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)	\
+	     -I$(INCLUDE_DIR) -I$(APIDIR) -I$(TOOLSINCDIR)		\
+	     -std=gnu11							\
+	     -fno-strict-aliasing					\
+	     -fms-extensions -Wno-microsoft-anon-tag			\
+	     -Wno-compare-distinct-pointer-types			\
+	     $(CLANG_SYS_INCLUDES) $(BPF_EXTRA_CFLAGS)
+
+# $1 = src .bpf.c, $2 = dst .bpf.o
+define BPF_BUILD_RULE
+	$(call msg,CLNG-BPF,,$2)
+	$(Q)$(CLANG) $(BPF_CFLAGS) -O2 --target=bpf -mcpu=$(CLANG_BPF_CPU) -c $1 -o $2
+endef
+
+# ---- output dirs for generated objects/skeletons --------------------------
+# Default: flat under $(OUTPUT) (what bpf/, hid/, cgroup/ do).  A caller may
+# segregate the generated files into subdirs, e.g. BPF_SKEL_DIR := $(OUTPUT)/...
+BPF_OBJ_DIR  ?= $(OUTPUT)
+BPF_SKEL_DIR ?= $(OUTPUT)
+
+# ---- scratch dirs ---------------------------------------------------------
+MAKE_DIRS := $(sort $(BUILD_DIR)/libbpf $(HOST_BUILD_DIR)/libbpf		\
+		    $(HOST_BUILD_DIR)/bpftool $(INCLUDE_DIR)		\
+		    $(filter-out $(OUTPUT),$(BPF_OBJ_DIR) $(BPF_SKEL_DIR)))
+$(MAKE_DIRS):
+	$(call msg,MKDIR,,$@)
+	$(Q)mkdir -p $@
+
+# ---- libbpf (target) ------------------------------------------------------
+# Pass ARCH/CROSS_COMPILE/CC through: lib.mk's CC is file-origin and is not
+# exported, so without this the libbpf sub-make would rebuild for the host under
+# a pure-LLVM cross build (make LLVM=1 ARCH=<arch>).  -fPIC keeps the static
+# libbpf linkable into position-independent (PIE) test binaries.
+$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile) \
+	   $(APIDIR)/linux/bpf.h | $(BUILD_DIR)/libbpf
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/ \
+		    ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) CC="$(CC)"     \
+		    EXTRA_CFLAGS='-g -O0 -fPIC'				      \
+		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
+
+# ---- libbpf (host) -- a distinct rule only when cross-compiling -----------
+ifneq ($(BPFOBJ),$(HOST_BPFOBJ))
+$(HOST_BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile) \
+		| $(HOST_BUILD_DIR)/libbpf
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) ARCH= CROSS_COMPILE=	      \
+		    OUTPUT=$(HOST_BUILD_DIR)/libbpf/ CC=$(HOSTCC) LD=$(HOSTLD) \
+		    EXTRA_CFLAGS='-g -O0'				      \
+		    DESTDIR=$(HOST_SCRATCH_DIR) prefix= all install_headers
+endif
+
+# ---- bpftool (host) -------------------------------------------------------
+$(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) \
+		    $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/bpftool
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFTOOLDIR)		  \
+		    ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD) \
+		    EXTRA_CFLAGS='-g -O0'			  \
+		    OUTPUT=$(HOST_BUILD_DIR)/bpftool/		  \
+		    LIBBPF_OUTPUT=$(HOST_BUILD_DIR)/libbpf/	  \
+		    LIBBPF_DESTDIR=$(HOST_SCRATCH_DIR)/		  \
+		    prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install-bin
+
+# ---- vmlinux.h ------------------------------------------------------------
+$(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL) | $(INCLUDE_DIR)
+ifeq ($(VMLINUX_H),)
+	$(call msg,GEN,,$@)
+	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
+else
+	$(call msg,CP,,$@)
+	$(Q)cp "$(VMLINUX_H)" $@
+endif
+
+# ---- BPF objects + skeletons ---------------------------------------------
+# Sources may sit in a subdir and use the modern *.bpf.c or the legacy *.c
+# suffix (BPF_PROG_EXT); objects go in $(BPF_OBJ_DIR) and skeletons in
+# $(BPF_SKEL_DIR) (both default to $(OUTPUT)), keyed by the source basename.
+BPF_PROG_EXT ?= .bpf.c
+bpf_stems := $(patsubst %$(BPF_PROG_EXT),%,$(notdir $(BPF_SRCS)))
+# The output namespace is flat, so two sources with the same basename would
+# collapse into one object/skeleton; fail loudly instead of silently dropping.
+ifneq ($(words $(bpf_stems)),$(words $(sort $(bpf_stems))))
+$(error lib.bpf.mk: BPF_SRCS has colliding basenames: $(BPF_SRCS))
+endif
+# BPF_SKEL_EXT lets a caller pick the skeleton suffix (default .skel.h; e.g.
+# .bpf.skel.h).  With BPF_GEN_SUBSKEL set, a matching subskeleton is emitted
+# alongside (foo.subskel.h / foo.bpf.subskel.h).
+BPF_SKEL_EXT    ?= .skel.h
+BPF_SUBSKEL_EXT := $(patsubst %skel.h,%subskel.h,$(BPF_SKEL_EXT))
+BPF_OBJS  := $(addprefix $(BPF_OBJ_DIR)/,$(addsuffix .bpf.o,$(bpf_stems)))
+BPF_SKELS := $(addprefix $(BPF_SKEL_DIR)/,$(addsuffix $(BPF_SKEL_EXT),$(bpf_stems)))
+
+# Locate the sources wherever the caller keeps them (e.g. progs/).
+vpath %$(BPF_PROG_EXT) $(sort $(dir $(BPF_SRCS)))
+
+$(BPF_OBJS): $(BPF_OBJ_DIR)/%.bpf.o: %$(BPF_PROG_EXT) $(BPF_EXTRA_HDRS) \
+	     $(wildcard *.bpf.h) $(INCLUDE_DIR)/vmlinux.h | $(BPF_OBJ_DIR) $(BPFOBJ)
+	$(call BPF_BUILD_RULE,$<,$@)
+
+$(BPF_SKELS): $(BPF_SKEL_DIR)/%$(BPF_SKEL_EXT): $(BPF_OBJ_DIR)/%.bpf.o $(BPFTOOL) | $(BPF_SKEL_DIR)
+	$(call msg,GEN-SKEL,,$@)
+	$(Q)$(BPFTOOL) gen object $(<:.o=.linked.o) $<
+	$(Q)$(BPFTOOL) gen skeleton $(<:.o=.linked.o) name $(notdir $(<:.bpf.o=)) > $@
+ifneq ($(BPF_GEN_SUBSKEL),)
+	$(Q)$(BPFTOOL) gen subskeleton $(<:.o=.linked.o) name $(notdir $(<:.bpf.o=)) > $(@:$(BPF_SKEL_EXT)=$(BPF_SUBSKEL_EXT))
+endif
+
+# ---- exports consumed by the caller --------------------------------------
+# -I$(OUTPUT)/-I$(BPF_SKEL_DIR): so the test .c can #include "foo.skel.h".
+# -I$(INCLUDE_DIR): so userspace can pull in the generated vmlinux.h if needed.
+CFLAGS += -I$(OUTPUT) -I$(BPF_SKEL_DIR) -I$(INCLUDE_DIR)
+
+# Static libbpf.a first, then its deps. libbpf may pull in zstd (BTF decompress)
+# only when built against it; link -lzstd only if libzstd is present.
+BPF_LDLIBS := $(BPFOBJ) -lelf -lz
+ifneq ($(shell pkg-config --exists libzstd 2>/dev/null && echo y),)
+BPF_LDLIBS += -lzstd
+endif
+
+TEST_GEN_FILES += $(BPF_OBJS)
+
+# Link helper: $1 = output binary, $2 = test .c (skels are the target's deps).
+define bpf_link
+	$(call msg,BINARY,,$1)
+	$(Q)$(CC) $(CFLAGS) $2 $(BPF_LDLIBS) $(LDLIBS) -o $1
+endef
+
+EXTRA_CLEAN += $(SCRATCH_DIR) $(HOST_SCRATCH_DIR)			\
+	       $(addprefix $(BPF_OBJ_DIR)/,*.bpf.o *.linked.o)		\
+	       $(addprefix $(BPF_SKEL_DIR)/,*$(BPF_SKEL_EXT) *$(BPF_SUBSKEL_EXT))
-- 
2.53.0-Meta


