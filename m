Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0896DC4452D
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 17:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD2026B00A3; Tue, 21 Jul 2026 13:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8836B00A6; Tue, 21 Jul 2026 13:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C49B56B00A7; Tue, 21 Jul 2026 13:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8BB4C6B00A3
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:48:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15C9D120269
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:48:46 +0000 (UTC)
X-FDA: 85013519052.07.3ED8A34
Received: from mail-pj2-f4.google.com (mail-pj2-f4.google.com [74.125.227.132])
	by imf15.hostedemail.com (Postfix) with ESMTP id 44AACA0006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:48:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YHJzHKp6;
	spf=pass (imf15.hostedemail.com: domain of ziyang.meme@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784656124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jApOwXpBhXqEU1tu6BspXbjxNN8qabGRryStwscMjoo=;
	b=v4n1KRkEZk/qP97CXPLBjPOpCayZh9HEowFMmp+SmjWB9LVzYBMtugOqVyDDRIZcpOZ0g1
	PAfryz1AEy5JgAg5BriK52l64zMmTE+1mN7XR3enh4izXMh2K5dRt/OiTOeQyQ0xOQdsuZ
	95sFbWLsfjRNbZNGi+/q7Ep691/JmpI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784656124;
	b=Tr3i8SNwcdNMuuI4rLcozQ9Qqg5OQQaV1ZXaDhSRWSWX+ReiA2BYMCFA4DlM6D71/qI8yP
	gssZTokMm7OyoNt+MCo0oswFi2pjOrmUfw25l8vDKdzGi6BNLR3GlWH8STgutjtKSjfz0r
	LtHWhjXaNy/oixleh7egNqd1Zjk3OL0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YHJzHKp6;
	spf=pass (imf15.hostedemail.com: domain of ziyang.meme@gmail.com designates 74.125.227.132 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f4.google.com with SMTP id 98e67ed59e1d1-38111ea8a88so7789769a91.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784656123; x=1785260923; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jApOwXpBhXqEU1tu6BspXbjxNN8qabGRryStwscMjoo=;
        b=YHJzHKp6UELDSiZcp5s0qHsPeHVVqd8qrrfgzQNn8FynQXyd73Ojk8FnT1WAMbuXEK
         ZJGEoXbk54DV4fmo1RxbndLEKTyI2W0wLCO3ZW/3pbn4y6TGdubNOmfc7ZMqqQlhlxmG
         ql4fUlBwPDE874TYXO3MYeWDFfSy4n1HVgH2VyCAJ1zxymwBczU5WoRh1IdQio8rdE2u
         eEGnUlX7VYuMUa4xi5iI7ePjojVk5U3c9JRzebxKFaURdnPc6oHC5RA0lYtIfzRX4tQd
         oF55eVR001dzjtwIFOKiLP8NuwG4hncuxnK4IqXZkyzmVnzxcMBBbKGyyJ3c1uOjXyw/
         iKtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784656123; x=1785260923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jApOwXpBhXqEU1tu6BspXbjxNN8qabGRryStwscMjoo=;
        b=b1DPCot5nDbrpUodbmVhA9RJUf5z3tqhPKXQeMwZ23om+7sSJ7b3kMr3VMOkbJbsvV
         wYSsYZ876c/MsQURAtsTGCfwza2bhCxUnI9kKqmKtbZUFL+7HeVMlqrQ+FhYEE2UBbRm
         +Iny2RudHINo167KnnJ2aB0rK7RjPTegzBGZims8FFJUfjn4im1hHzr82/TNz7j8aHma
         Ug3yY10TpoVCDSgMoaRX8khsvPRj/vYyFn8gKPumT1B7hbAFyD1RMT/yHcpXhNhGgQXc
         W47+eYB0C2ng3QZedLc9MXSDYIKbJwrrCqZ0PdAcQmYshKGgrp/H+/zREnynkxVADwGp
         kTag==
X-Forwarded-Encrypted: i=1; AHgh+Rqbi5wDsHUtiuJwZw8liGoyBfVvFet2aunwtD0kNqcmMKVvLcmCAMjqMo8RRVe/93V8Q900+tpAMw==@kvack.org
X-Gm-Message-State: AOJu0YzvJBN26qc0wFSNDCIL3Nfa4bwcRNmAYcZwciKhKbExjPKYB3HH
	BMrEkTEW9ax7XbC5+FXc5fXaOLWpOeopgcAYse5Sd7B0jKc6fmeWYME7
X-Gm-Gg: AR+sD11Y/bb2/hsQlTBna/n9LfIjFsCGITZFIwEarHHuRDGS38Vl/rv2glMoJxyhQaz
	4wy0McQ2cYcFmfpQoauc/2nDqBbWStonCUoK8c5z3oTr+f1LyyrAajl4uNNvBh5mytf2fsEhIhm
	5R6OG1/mxhSz8mJsX6id4hZY3slZ1+JkIvB6GAOfEdwDaQMMsYEWgB0AMSx/wLLPbVnzyWp7ecU
	+BziqsRNGNL8GcpmgxRVqI2S1RKy/NJ+j8y22QbWud42CUnNy1ePYOyfLT64etWswpJ1guP++R6
	Mp6ufCTA303nb02a+UuKYaKqPeJTslzMvNUVWt4CjrjFq/ejT/C8aPivK8krryu+DuHfDe19lgM
	qxKaY3cz8ioh/uPB0uwdnSaQ0bV455a2tr2moDx1yC6NpBXEjQlPzkjG4qb2gbovzSiUXhLeD
X-Received: by 2002:a05:6a21:a393:b0:3c3:9251:fe49 with SMTP id adf61e73a8af0-3c3ad972d5bmr20981964637.50.1784656123174;
        Tue, 21 Jul 2026 10:48:43 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:66::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147dc193f8sm2331163eec.1.2026.07.21.10.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:48:42 -0700 (PDT)
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
Subject: [PATCH v2 3/4] selftests/hid: build the BPF program via the shared lib.bpf.mk
Date: Tue, 21 Jul 2026 10:48:32 -0700
Message-ID: <20260721174833.1232771-4-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260721174833.1232771-1-ziyang.meme@gmail.com>
References: <20260721174833.1232771-1-ziyang.meme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gbc3mjwkr6yhehrribx4i4pmx6bwg5zs
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44AACA0006
X-HE-Tag: 1784656124-470015
X-HE-Meta: U2FsdGVkX19tPXx7KaVrGct2zQrSkLXREAHKzqcQcmcNRv0aiEhi0XayxnHYOZJaRpMQFZjjl7a7BMXaEN867AHoYLFnSd5C31QxLXHKHHDLxtvr3410nklkhCiM64AMy0y7SmgAH9UbNzuHwZPLMbnXyHE+oPw5kc3o0uWcEimHvTel0YHoBsDznMBWgYbvrog8WDmdl3yu1UfcjtyPs5LhSKXMLHl5UpnlUh/0B9/LqFnc2Zpnu1BCeYQ/vdBSK8a8N/Tqvc99PCse61KvUn1sPkMnJDLH14JIv0kIRzyAU29LeutdQGWnU8n65M4G52fdjfU0yfaCoJMb16CJa1txpdWjPGqt6w/VnxwlltU7D87pFHxbYzB0OMJNYLnHxLFptRPB2MJrz/CA+sTGy6eNH8cZtKvkNOB3OAY8j4G+VJM0Zjk93WzqJuJmsNcS+Cb00/NsOtg/hVR84nRuCWfi3r4GkhLtrl1H0+1/8BqD9wvURTz3WjBof6/3/xAvUoJeTgizsOLFaZ42MLubMD3Bw8M8lqo/Y9e7iNkIZr1WArdj7uOCnuCEgPwG+tN9mIn/fTeTQyPOwSUilWXR6j/N0jWpftBL0+H93grq0sKOenF1liy0K49RTGmhhLJY5fwGlkK2K9QCiaac/uzXtY1mbCsD32PrmuviDG+X9ULpZzgPfslR71pD7a6ULBpAkKZ8pIFHaz1PeLQHyMo3EWwLY/S2ZcPuWSDaHJV/gb4rKLizSYYPSJ0qCqwPuGG7cpqDq71oOzGLqhupDRzKZ/4fo70ylgXC7uXYE6aY1wV9XDxfVp1rYJ2H822fLKpJnmjpYVmWkMxfLf6nU62HliBQ4PbX4Oocx9JKZZXuJhC042SFlUeHkKi3gdkc9ZyyMlPeTZiT6G1E282L6NRMykKCHvTFu1LIdswRWyeiSRwk3dt3Uvu9HYFKQTDCaP9C5QPJT03pwWjlyQzoX1P
 New+Cebq
 2i2tskGbZSXtUgcr/mOwxFulhO/Xvyv/aRrsunESiOAJQTxwGr+hQSbfrH70xW+zz2nG2Lbrkq0Be/Ay5jcyy15agGQKF10aso77lS/2IFsaPp2BSsmTgdUSIDBVVPwFyG0nrkTDYVq2q6VdN7wNXlopqvriHCNvzAsxyp/tHrTN2kC5r0b3iZs3KtfGyzDy7RTJ4Hu5/pcwQNcX/pi4eAGJahLDikEQ15XK+tBlPpFJIpUalcTKGxmjcLTg83ZTqu1jU0trBGlgVvun5AajdWDo6afhrMHh61ZJxXPbxoxxA5m9dZf2uF//66Mat0EuaAgdHhEuznCa3dOoA1Y3WmLNJq0WDox0zVoOT7TuiiR+LPtD+7d1ax7lowitwdRQsmViWZ9KqIlZ6Ot2ui5RdRJX4y9j9fj/tENzR7KeeQqhALAcSaov1AVfbXnTlrxvijXdEK26fiSafxqMidOg5fTtNKlTpeanvDEVrHC53zCyrsFPG77vRU/2rC/uzpBiliYnhwP8i1x14qUYszmx9FYzeif0H2kT8WIjNmTaEIw1Rcj9N6A/OCx48TihwFdMNbbfFpLRbJFW++KBdoYT46i3vej2yhu++IVDw
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

hid keeps the legacy progs/<name>.c layout, so it sets BPF_PROG_EXT := .c
and passes its shared BPF headers through BPF_EXTRA_HDRS.  It also gains
the fragment's -Wall on the BPF compile, which its old Makefile did not
set; hid.c has a few pre-existing unused locals, so
BPF_EXTRA_CFLAGS := -Wno-unused-variable keeps the previous behaviour
without touching the program source.

The conversion drops two pieces of dead machinery hid had copied from
selftests/bpf: a resolve_btfids build that was never a prerequisite of
any target, and a CLANG_CFLAGS variable that was never passed to any
compile.

No functional change: the generated hid.skel.h public API is
byte-identical before and after, hid_bpf and hidraw are built and linked
the same way, and the folder builds cleanly under both plain make and
LLVM=1.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
Suggested-by: Mykola Lysenko <mykolal@meta.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/hid/Makefile | 182 +++------------------------
 1 file changed, 20 insertions(+), 162 deletions(-)

diff --git a/tools/testing/selftests/hid/Makefile b/tools/testing/selftests/hid/Makefile
index 2f423de83147..48def484703c 100644
--- a/tools/testing/selftests/hid/Makefile
+++ b/tools/testing/selftests/hid/Makefile
@@ -58,172 +58,31 @@ override define CLEAN
 	$(Q)$(RM) -r $(EXTRA_CLEAN)
 endef
 
-include ../lib.mk
+# The BPF program (progs/hid.c) is compiled into a skeleton by the shared
+# tools/testing/selftests/lib.bpf.mk fragment.  hid keeps the legacy
+# progs/<name>.c layout, so point BPF_PROG_EXT at .c and hand the fragment
+# hid's shared BPF headers as extra prerequisites.  BPF_EXTRA_HDRS is deferred
+# because it references $(BPFDIR), which lib.bpf.mk defines.
+BPF_SRCS       := progs/hid.c
+BPF_PROG_EXT   := .c
+BPF_EXTRA_HDRS  = $(wildcard progs/*.h) $(wildcard $(BPFDIR)/hid_bpf_*.h) \
+		  $(wildcard $(BPFDIR)/*.bpf.h)
+# hid.c predates the shared -Wall (hid's old Makefile didn't set it) and has a
+# few unused locals; tolerate that pre-existing warning without touching the
+# program source.
+BPF_EXTRA_CFLAGS := -Wno-unused-variable
 
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
+include ../lib.mk
+include ../lib.bpf.mk
 
-# Define simple and short `make test_progs`, `make test_sysctl`, etc targets
-# to build individual tests.
+# Define simple and short `make hid_bpf`, `make hidraw` targets.
 # NOTE: Semicolon at the end is critical to override lib.mk's default static
 # rule for binaries.
 $(notdir $(TEST_GEN_PROGS)): %: $(OUTPUT)/% ;
 
-# sort removes libbpf duplicates when not cross-building
-MAKE_DIRS := $(sort $(BUILD_DIR)/libbpf $(HOST_BUILD_DIR)/libbpf		\
-	       $(HOST_BUILD_DIR)/bpftool $(HOST_BUILD_DIR)/resolve_btfids	\
-	       $(INCLUDE_DIR))
-$(MAKE_DIRS):
-	$(call msg,MKDIR,,$@)
-	$(Q)mkdir -p $@
-
-DEFAULT_BPFTOOL := $(HOST_SCRATCH_DIR)/sbin/bpftool
-
-TEST_GEN_PROGS_EXTENDED += $(DEFAULT_BPFTOOL)
-
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
-
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
+# Each test binary links against the in-tree static libbpf that lib.bpf.mk
+# built (lib.mk has already prefixed TEST_GEN_PROGS with $(OUTPUT)/).
+$(TEST_GEN_PROGS): $(BPFOBJ)
 
 $(OUTPUT)/%.o: %.c $(BPF_SKELS) hid_common.h
 	$(call msg,CC,,$@)
@@ -233,5 +92,4 @@ $(OUTPUT)/%: $(OUTPUT)/%.o
 	$(call msg,BINARY,,$@)
 	$(Q)$(LINK.c) $^ $(LDLIBS) -o $@
 
-EXTRA_CLEAN := $(SCRATCH_DIR) $(HOST_SCRATCH_DIR) feature bpftool	\
-	$(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32)
+EXTRA_CLEAN += feature bpftool $(addprefix $(OUTPUT)/,*.o no_alu32)
-- 
2.53.0-Meta


