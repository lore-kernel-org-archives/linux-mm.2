Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1C63C79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EEAD6B0098; Thu, 10 Sep 2026 19:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BE196B0099; Thu, 10 Sep 2026 19:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A1A6B009B; Thu, 10 Sep 2026 19:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 288346B0098
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:33:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A807B1A06AA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:33:38 +0000 (UTC)
X-FDA: 85199456916.16.69D0427
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf31.hostedemail.com (Postfix) with ESMTP id DC2F82000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:33:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZAXCCm9Q;
	spf=pass (imf31.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789083216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zd2gkMuIc1TcNe9YCvTi4dDIYFUJcR5yO2iE7XwTG+I=;
	b=iYgst2L4/NJv/pj2CtNEE+JtaFd2MzipAFDKd068eLpgdkkd0QoTfPeuD+Mxqg82JbKVeB
	Rj+xhfOa/KYgd9fFgmwzM8K5Hukf1m2TLVPKC3hdQmP+XsT2HCV4riGN0Rzz3kVUfeGji+
	yFU1LVxQDdBG+Pikt8Sm/aLMbldxUgg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789083216;
	b=ozI8JiAcl7uWRpOeDdoXDv9T18UVmedT91x19qycJK+/MAOnGgzudYZYjG047CmpaUb/qz
	NZqKBIy3JKmZ87fRdh1JUd6kpeiJUZ6kyF9S/eAVdWRffL6oRG5TJ8NDCifANLYBsTSi/0
	ZncJRrbSGjEmJK1hHt4xpgSrf5yXRo0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZAXCCm9Q;
	spf=pass (imf31.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2db710396ffso13247305ad.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789083216; x=1789688016; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zd2gkMuIc1TcNe9YCvTi4dDIYFUJcR5yO2iE7XwTG+I=;
        b=ZAXCCm9Q1vCRCXfJ98WUqmrQ87nw+QxrqKDkAUG5OppZpSoUxgp8mYbOvnlrQ54+5z
         IsARcZ3SnrjQ2uv3jp9j6XO2D3vNIIBjTZDlkkf/9Vc6/+mQ0GDmRt0myU6lMi3bMjXu
         QjsVjk1XfLQ4LP1ypmOrYRBpXVwnDGOlSR5WmEcJy93V3EYWOF6MG/HrLIPuZwFwe6XR
         1q5zMprMYoXdJBXSmKa1ef30dzB1K4TWY037EAVq5jUZUGtSJ0k0fDQ4YoOHzrPxWvws
         GvODRNjMvXCfwZjHl2CToPO0kopT2faZDRhkSKC8YN3cF5Yu+sdUik/rMj+epCHc9ggv
         PxUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789083216; x=1789688016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zd2gkMuIc1TcNe9YCvTi4dDIYFUJcR5yO2iE7XwTG+I=;
        b=jyK+CQ47UwsxUU/gR9B7DPhOUrCopYaTfjJ/9khn3QKL7DIdfDuKmSeINaw+TYd6HL
         U7Bo9LLcr5HO1W+6YVd08lGiyua+GwkJ6eCCJzk5499dLbUE0v1TOCw5UUElPkQY1q37
         6Gx6iq17yKvQdsG1/6q1O4jii9NjuT9je5PYXBQ3Szw+GktWXdRbStpUV1LSmdyMWkUG
         zbiJfRxohztpjfWiuU9NSPh/LVfzds7qebg7LxsfF7tDqy0vr8so5AXR6XPOCxYdug0q
         2393YbEF0lScb9G2IYiNJB26aO/a5K5bs3BeQ9hvEFMxZVkPOhwW8ugZx3j3tHh32zmH
         j6Lg==
X-Forwarded-Encrypted: i=1; AKwUvBycDVb0e4AJ0nr41zYIsdWZAy+mh9pOzMxXrHnniy773hXH/1AmL+txXcjvSb7Y8XQ98eHW1NMtfA==@kvack.org
X-Gm-Message-State: AFuF++lIbREKbSzfiFG6lGaKDJypmokS3owB1BcFwxIirb0NbibbGlO+
	QrEs7583LLRfmM3xjKFTkoe2E1ySH6o0UD9DN5UF9n6qO+v0Z63gRFZz
X-Gm-Gg: AYBFou01BaUb39PzE860wdiLoMbugXgiAD/OxJCtJvqxGetjpNJlXHNaS9Ahw4lrotn
	61kjAPY343TKeBPg/rOAv748MpiUEzbRhfvRIlrTBy85QtwJXjNbkviosS0T+4Nxi/zOOVX9DzB
	dlrwgDVBIJntQ+a6F/pgLCcAfKvutuGM+MGRzNiflpzCBgfdQEw0Sl3Fo9isZNBTG3LcA/O/J3P
	XMj9j5JuCf0aQQYArHaMXmO5sh8DToCWLTXh08xRmBpSliVYYxfL8ZLgnAW9LVU1PWQIfW7hXkn
	/TbRPLAHRmkoqNh24XnFY9McykcW3XgIdUUj05rrzbOH3X4CddN2SzrTyCA/urtZ4gQy0pHIc1u
	iL8Vyc6Nl0peBzygV1oaB5Wi2egdv/pr1YtU0C4wHRGWoZYZcLJdzbIjebOLZi9SMDvQ6kW4ZIu
	ci3lwg7nhlrV10Rf4TDxoDJE4mOMFxE6M/f3kW2pIbmUHug8AUG1csDb74AW+Y8hmxhQ==
X-Received: by 2002:a17:903:37c6:b0:2d0:401c:2edc with SMTP id d9443c01a7336-2dd0e8a181dmr75304235ad.1.1789083215583;
        Thu, 10 Sep 2026 16:33:35 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:6b::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4e9a3casm1319129eec.12.2026.09.10.16.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 16:33:35 -0700 (PDT)
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
Subject: [PATCH v5 3/4] selftests/hid: build the BPF program via the shared lib.bpf.mk
Date: Thu, 10 Sep 2026 16:33:02 -0700
Message-ID: <20260910233303.1063501-4-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260910233303.1063501-1-ziyang.meme@gmail.com>
References: <20260910233303.1063501-1-ziyang.meme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DC2F82000A
X-Stat-Signature: zon4hprcaswzcf9xztjk6uxb5mzte1u5
X-Rspam-User: 
X-HE-Tag: 1789083216-996286
X-HE-Meta: U2FsdGVkX19bNyAHpmTJjhlD8/DU+xE2e6+ot0XbU/3uTQApeeYX4gALoBktcyyC1E83qNwFQyo/kMCjg+EmjUfJH1wgfzlBsEb2XJZqebFvpsGxTEE+6EIoVNzZ6F8TNI1roKRaIn2YDiLxQQmZsJTtxKmWVrxIuIx9txR4ovEDMIz75Sb/lzxGf7pQpYyVzEmWdbWZsAvpxkLU7sc3S7AGIWhCqgJs3/0x5C1CqEZVJvjQ2Ge1XvcfjGxJ5pohENh+CI7tJtT6KJW/08NAIG6tUyvlAztwA9M/eYzhq/enptOYSipCB61+X2qy7krm5FdsW0/r/bCKMcazeDe98HXSwTmdWa+0uOEXP8dRjn+rJ2FHFe+it9ajqPQjBpNqvejVVyoOEKD4Om1om+iakXHwcbN/T2udOe39NlIAVXg4xk00pG7Jj8K9UnHLIMXePW04P/ESVrw1UwBQMXk92MWC49IbGNIYIrGcXhE8l1co8770yti5Z666480t1iYaegv7wYZHv/N4/BowiYZK5wQItOUzipiWkihrbQfrLMUxprrvbGG7mdMz8jRTHt8DpqgPce1P77v2JcYp9P0kEsyrdFsWkF5e1Qg4tsQgMbU2nBDP+3uGqHRzeE+Z1C1PR2/8bV+TclJgA6q4+gaQqoJytKWJskni1Zo1AMATefn6ziFticS5Z6cjQzBD+LeWyjUsSKw5mS3GnXkaMAlHc7NTrg2sBXfNYjPaOi6SaVWhmc4gLC4p+RQr7nEzs2WuVcX+YF8AIEWJl1DOHRM7poV8W4p/BHQZAJh4srf/COgHLp/x91HmofzyIPTq2+2GWEgrSgkZVllTZ7xMnONXdsREBniNiUL3MGpw7CVpmcVzvdby36cvz/hpb4bZCP5KSEHBChY0HFCmCNRlB1Rhtzx+D4D9grmEwNuwk6U1N/MOxHmpgjj6DcYyd7kxBVs/SCuLIrnIEdDbnPN4DBi
 VKrfEv8+
 kfJMchkKefHa6cSHzUaNs77a8YTtcl0pm1how+22FXLiBu6DgGnV9/SmFKLqKNNzm+C/hlFUpietbJoVcjLIZcwYKsJL5bvLulAz0UUcUNq6StrpwbqQBe06qLjipyMOVXEsUqTU/schT451scjumSsblaVHL12QFaFXPKRHmwrlzl5qq6bROemn/YqRCfL0r4sCk/fKraXDuU48Cu43r9fDHe708dITKCeKYH6tV9HuVNmTelapNd1xKHWRswi5fH44xUjb6RHt4ZrfSI+DXVuntQbQGLqCjeSlaNuArrASl4jBE9zTEQ3tH8vQYmX9umpN7bsOVlPzAgTJsBb1610Jhvu/cUiZlVYr2pUXw4OT5v/PXL4Y3j6mss21nmeI61PCGgMZJc1+mO1LCqGTye2AYTnIuYSu8muB272gzbPqXpitSvvT8gX3uDfvk1GuH3bqHSbnj1SvlYnuqIzBSL96hvpCEoje0pfepXwZjdD7USgO+/LfkUbwxlkIp5dMjahBgkxh39l6yn5ZMqgJ1Occ4G6AxGaf5DJONnLNiGyX1Q6liPxHB2LIjCPixPzOeOPIUy95Ql+7wwDihpmjtedxAsi6iQCuVv7t5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hid carries its own ~150 lines of libbpf + bpftool + vmlinux.h +
BPF-object + skeleton build machinery, copied from selftests/bpf.
Replace it with an include of the shared
tools/testing/selftests/lib.bpf.mk, so that the previous ~150 lines of
BPF build configuration can now be achieved in only ~10 lines.

The generated hid.skel.h public API remains byte-identical, and hid_bpf
and hidraw are linked the same way.  The shared fragment also supplies
the common warning, language, system-include and adaptive BPF CPU flags.
Remove four unused locals so hid.c builds with that warning set without a
directory-wide suppression.

Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
Suggested-by: Mykola Lysenko <mykolal@meta.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/hid/.gitignore  |   1 +
 tools/testing/selftests/hid/Makefile    | 179 ++----------------------
 tools/testing/selftests/hid/progs/hid.c |   7 +-
 3 files changed, 19 insertions(+), 168 deletions(-)

diff --git a/tools/testing/selftests/hid/.gitignore b/tools/testing/selftests/hid/.gitignore
index 933f483815b2..69943301dc1d 100644
--- a/tools/testing/selftests/hid/.gitignore
+++ b/tools/testing/selftests/hid/.gitignore
@@ -1,5 +1,6 @@
 bpftool
 *.skel.h
+*.bpf.d
 /host-tools
 /tools
 hid_bpf
diff --git a/tools/testing/selftests/hid/Makefile b/tools/testing/selftests/hid/Makefile
index 2f423de83147..1190a747036d 100644
--- a/tools/testing/selftests/hid/Makefile
+++ b/tools/testing/selftests/hid/Makefile
@@ -47,7 +47,6 @@ msg =
 else
 msg = @printf '  %-8s%s %s%s\n' "$(1)" "$(if $(2), [$(2)])" "$(notdir $(3))" "$(if $(4), $(4))";
 MAKEFLAGS += --no-print-directory
-submake_extras := feature_display=0
 endif
 
 # override lib.mk's default rules
@@ -58,172 +57,25 @@ override define CLEAN
 	$(Q)$(RM) -r $(EXTRA_CLEAN)
 endef
 
-include ../lib.mk
-
-TOOLSDIR := $(top_srcdir)/tools
-LIBDIR := $(TOOLSDIR)/lib
-BPFDIR := $(LIBDIR)/bpf
-TOOLSINCDIR := $(TOOLSDIR)/include
-BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
-SCRATCH_DIR := $(OUTPUT)/tools
-BUILD_DIR := $(SCRATCH_DIR)/build
-INCLUDE_DIR := $(SCRATCH_DIR)/include
-BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a
-ifneq ($(CROSS_COMPILE),)
-HOST_BUILD_DIR		:= $(BUILD_DIR)/host
-HOST_SCRATCH_DIR	:= $(OUTPUT)/host-tools
-HOST_INCLUDE_DIR	:= $(HOST_SCRATCH_DIR)/include
-else
-HOST_BUILD_DIR		:= $(BUILD_DIR)
-HOST_SCRATCH_DIR	:= $(SCRATCH_DIR)
-HOST_INCLUDE_DIR	:= $(INCLUDE_DIR)
-endif
-HOST_BPFOBJ := $(HOST_BUILD_DIR)/libbpf/libbpf.a
-RESOLVE_BTFIDS := $(HOST_BUILD_DIR)/resolve_btfids/resolve_btfids
-
-VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
-		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
-		     ../../../../vmlinux				\
-		     /sys/kernel/btf/vmlinux				\
-		     /boot/vmlinux-$(shell uname -r)
-VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
-ifeq ($(VMLINUX_BTF),)
-$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
-endif
-
-# Define simple and short `make test_progs`, `make test_sysctl`, etc targets
-# to build individual tests.
-# NOTE: Semicolon at the end is critical to override lib.mk's default static
-# rule for binaries.
-$(notdir $(TEST_GEN_PROGS)): %: $(OUTPUT)/% ;
-
-# sort removes libbpf duplicates when not cross-building
-MAKE_DIRS := $(sort $(BUILD_DIR)/libbpf $(HOST_BUILD_DIR)/libbpf		\
-	       $(HOST_BUILD_DIR)/bpftool $(HOST_BUILD_DIR)/resolve_btfids	\
-	       $(INCLUDE_DIR))
-$(MAKE_DIRS):
-	$(call msg,MKDIR,,$@)
-	$(Q)mkdir -p $@
+# Build the legacy progs/*.c layout with the shared BPF rules.
+BPF_SRCS       := $(wildcard progs/*.c)
+BPF_PROG_EXT   := .c
+# BPFDIR is defined when this recursive variable is expanded.
+BPF_EXTRA_HDRS  = $(wildcard progs/*.h) $(wildcard $(BPFDIR)/hid_bpf_*.h) \
+		  $(wildcard $(BPFDIR)/*.bpf.h)
 
-DEFAULT_BPFTOOL := $(HOST_SCRATCH_DIR)/sbin/bpftool
+include ../lib.mk
+include ../lib.bpf.mk
 
+# Preserve the existing install list.
+TEST_GEN_FILES += $(BPF_OBJS)
 TEST_GEN_PROGS_EXTENDED += $(DEFAULT_BPFTOOL)
 
-$(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(BPFOBJ)
-
-BPFTOOL ?= $(DEFAULT_BPFTOOL)
-$(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
-		    $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/bpftool
-	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)			       \
-		    ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD) 	       \
-		    EXTRA_CFLAGS='-g -O0'				       \
-		    OUTPUT=$(HOST_BUILD_DIR)/bpftool/			       \
-		    LIBBPF_OUTPUT=$(HOST_BUILD_DIR)/libbpf/		       \
-		    LIBBPF_DESTDIR=$(HOST_SCRATCH_DIR)/			       \
-		    prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install-bin
-
-$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
-	   | $(BUILD_DIR)/libbpf
-	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/ \
-		    EXTRA_CFLAGS='-g -O0'				       \
-		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
-
-ifneq ($(BPFOBJ),$(HOST_BPFOBJ))
-$(HOST_BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
-		| $(HOST_BUILD_DIR)/libbpf
-	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR)                             \
-		    EXTRA_CFLAGS='-g -O0' ARCH= CROSS_COMPILE=		       \
-		    OUTPUT=$(HOST_BUILD_DIR)/libbpf/ CC=$(HOSTCC) LD=$(HOSTLD) \
-		    DESTDIR=$(HOST_SCRATCH_DIR)/ prefix= all install_headers
-endif
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
-$(RESOLVE_BTFIDS): $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/resolve_btfids	\
-		       $(TOOLSDIR)/bpf/resolve_btfids/main.c	\
-		       $(TOOLSDIR)/lib/rbtree.c			\
-		       $(TOOLSDIR)/lib/zalloc.c			\
-		       $(TOOLSDIR)/lib/string.c			\
-		       $(TOOLSDIR)/lib/ctype.c			\
-		       $(TOOLSDIR)/lib/str_error_r.c
-	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/resolve_btfids	\
-		CC=$(HOSTCC) LD=$(HOSTLD) AR=$(HOSTAR) \
-		LIBBPF_INCLUDE=$(HOST_INCLUDE_DIR) \
-		OUTPUT=$(HOST_BUILD_DIR)/resolve_btfids/ BPFOBJ=$(HOST_BPFOBJ)
-
-# Get Clang's default includes on this system, as opposed to those seen by
-# '--target=bpf'. This fixes "missing" files on some architectures/distros,
-# such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
-#
-# Use '-idirafter': Don't interfere with include mechanics except where the
-# build would have failed anyways.
-define get_sys_includes
-$(shell $(1) -v -E - </dev/null 2>&1 \
-	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
-$(shell $(1) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
-endef
-
-# Determine target endianness.
-IS_LITTLE_ENDIAN = $(shell $(CC) -dM -E - </dev/null | \
-			grep 'define __BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__')
-MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
-
-CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
-BPF_CFLAGS = -g -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) 		\
-	     -Wno-microsoft-anon-tag                                    \
-	     -fms-extensions                                            \
-	     -I$(INCLUDE_DIR)
-
-CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
-	       -Wno-compare-distinct-pointer-types
-
-# Build BPF object using Clang
-# $1 - input .c file
-# $2 - output .o file
-# $3 - CFLAGS
-define CLANG_BPF_BUILD_RULE
-	$(call msg,CLNG-BPF,$(TRUNNER_BINARY),$2)
-	$(Q)$(CLANG) $3 -O2 --target=bpf -c $1 -mcpu=v3 -o $2
-endef
-# Similar to CLANG_BPF_BUILD_RULE, but with disabled alu32
-define CLANG_NOALU32_BPF_BUILD_RULE
-	$(call msg,CLNG-BPF,$(TRUNNER_BINARY),$2)
-	$(Q)$(CLANG) $3 -O2 --target=bpf -c $1 -mcpu=v2 -o $2
-endef
-# Build BPF object using GCC
-define GCC_BPF_BUILD_RULE
-	$(call msg,GCC-BPF,$(TRUNNER_BINARY),$2)
-	$(Q)$(BPF_GCC) $3 -O2 -c $1 -o $2
-endef
-
-BPF_PROGS_DIR := progs
-BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
-BPF_SRCS := $(notdir $(wildcard $(BPF_PROGS_DIR)/*.c))
-BPF_OBJS := $(patsubst %.c,$(OUTPUT)/%.bpf.o, $(BPF_SRCS))
-BPF_SKELS := $(patsubst %.c,$(OUTPUT)/%.skel.h, $(BPF_SRCS))
-TEST_GEN_FILES += $(BPF_OBJS)
+# Keep aliases such as "make hid_bpf" from matching lib.mk's binary rule.
+$(notdir $(TEST_GEN_PROGS)): %: $(OUTPUT)/% ;
 
-$(BPF_PROGS_DIR)-bpfobjs := y
-$(BPF_OBJS): $(OUTPUT)/%.bpf.o:				\
-	     $(BPF_PROGS_DIR)/%.c			\
-	     $(wildcard $(BPF_PROGS_DIR)/*.h)		\
-	     $(INCLUDE_DIR)/vmlinux.h				\
-	     $(wildcard $(BPFDIR)/hid_bpf_*.h)			\
-	     $(wildcard $(BPFDIR)/*.bpf.h)			\
-	     | $(OUTPUT) $(BPFOBJ)
-	$(call $(BPF_BUILD_RULE),$<,$@, $(BPF_CFLAGS))
-
-$(BPF_SKELS): %.skel.h: %.bpf.o $(BPFTOOL) | $(OUTPUT)
-	$(call msg,GEN-SKEL,$(BINARY),$@)
-	$(Q)$(BPFTOOL) gen object $(<:.o=.linked1.o) $<
-	$(Q)$(BPFTOOL) gen skeleton $(<:.o=.linked1.o) name $(notdir $(<:.bpf.o=)) > $@
+# Relink tests when the in-tree libbpf changes.
+$(TEST_GEN_PROGS): $(BPFOBJ)
 
 $(OUTPUT)/%.o: %.c $(BPF_SKELS) hid_common.h
 	$(call msg,CC,,$@)
@@ -233,5 +85,4 @@ $(OUTPUT)/%: $(OUTPUT)/%.o
 	$(call msg,BINARY,,$@)
 	$(Q)$(LINK.c) $^ $(LDLIBS) -o $@
 
-EXTRA_CLEAN := $(SCRATCH_DIR) $(HOST_SCRATCH_DIR) feature bpftool	\
-	$(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32)
+EXTRA_CLEAN += $(OUTPUT)/*.o
diff --git a/tools/testing/selftests/hid/progs/hid.c b/tools/testing/selftests/hid/progs/hid.c
index b21fbb13c926..ec734e18d23a 100644
--- a/tools/testing/selftests/hid/progs/hid.c
+++ b/tools/testing/selftests/hid/progs/hid.c
@@ -111,7 +111,7 @@ int hid_user_raw_request(struct hid_hw_request_syscall_args *args)
 {
 	struct hid_bpf_ctx *ctx;
 	const size_t size = args->size;
-	int i, ret = 0;
+	int ret = 0;
 
 	if (size > sizeof(args->data))
 		return -7; /* -E2BIG */
@@ -137,7 +137,7 @@ int hid_user_output_report(struct hid_hw_request_syscall_args *args)
 {
 	struct hid_bpf_ctx *ctx;
 	const size_t size = args->size;
-	int i, ret = 0;
+	int ret = 0;
 
 	if (size > sizeof(args->data))
 		return -7; /* -E2BIG */
@@ -161,7 +161,7 @@ int hid_user_input_report(struct hid_hw_request_syscall_args *args)
 {
 	struct hid_bpf_ctx *ctx;
 	const size_t size = args->size;
-	int i, ret = 0;
+	int ret = 0;
 
 	if (size > sizeof(args->data))
 		return -7; /* -E2BIG */
@@ -417,7 +417,6 @@ SEC("?struct_ops.s/hid_hw_output_report")
 int BPF_PROG(hid_test_hidraw_output_report, struct hid_bpf_ctx *hctx, __u64 source)
 {
 	__u8 *data = hid_bpf_get_data(hctx, 0 /* offset */, 3 /* size */);
-	int ret;
 
 	if (!data)
 		return 0; /* EPERM check */
-- 
2.53.0-Meta


