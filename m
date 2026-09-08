Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F198C79FAA
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 23:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAB516B0096; Tue,  8 Sep 2026 19:56:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B825C6B0098; Tue,  8 Sep 2026 19:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28896B0099; Tue,  8 Sep 2026 19:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 336A86B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 19:56:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5D60806D7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 23:56:23 +0000 (UTC)
X-FDA: 85192256646.23.D9B4E2B
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id DCBFD80006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 23:56:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Tvpd5jvq;
	spf=pass (imf30.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788911781;
	b=0nRRd875jkpB37b1D+zhlmSGBdUFoS8B287pQr8dZkLEnJxlKmOYKkpmaGJdxD0jNOY37D
	qenVlSOxaNiejL2Uv4UgkvfAxsNAVSZ+JRMsyestvjKlC7iE9wVhhITBmb7CsDMMLDqsMI
	rA2OltbQm6P4tmd30jnseDKwYrBjvbQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Tvpd5jvq;
	spf=pass (imf30.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788911781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zd2gkMuIc1TcNe9YCvTi4dDIYFUJcR5yO2iE7XwTG+I=;
	b=xRs/K4a0H5wgZ4zTrSIs6ZPBO9TIwcTNrBX3zo09grQPzrwBU714lYRyOdbM7bd+nzlx6N
	nNKls6hioI1JNpcg0Hi/CUCrnxZ0hk7VYEIiIEX9aQtuFJ+xAqBkeZ48wAUivenhZskpod
	Hzb+M3mcx7NrnEb6KFDe7tQBsnbW7HQ=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-ca97d139d5fso4676254a12.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 16:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788911780; x=1789516580; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zd2gkMuIc1TcNe9YCvTi4dDIYFUJcR5yO2iE7XwTG+I=;
        b=Tvpd5jvqUCWg3Nu85I7WkpuwoG9yoo0NIE8asHplvtfdPBh8YGXhp/0ZGTZh6senyo
         VtsAeKfkfeH0iV8L0l/4PJMhgVnWMVAfJW31mqOohSg0vYFrcJ4YPdt/sevttiSrTlBY
         wNpARkVXazP3y2JX6t+InX/qq70dC3B+oyXghviAkaTXzj0Ka+gMOzgIgWyqpPR8JzC1
         y2hQFBQ2gPVeX+2PuQaW45BpvBPn1zjn+KkTTH3occM764QfZpJdqr+vJew8+C3bxe1i
         EJ7i4RsfOczvFc8HrDvxYmWCqkNs33/UOSDescZOmmJBll21dsghn5FCZSl62Ldjyg2q
         LGkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788911780; x=1789516580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zd2gkMuIc1TcNe9YCvTi4dDIYFUJcR5yO2iE7XwTG+I=;
        b=epR3AByW4BlHJL6czCnCiyxcyQ0mvOdrsz/tOfPFconZXhKlb2iWAKyYRFEHBew5mh
         OJCVr9oy7VNM8XutlNh0UWB4rk/AP3rwc+PG+vP8azDY3k3IZvrXLv4MXJCc+r7wY89l
         63TMnNdTeC2NZu/2fkWHHxHGK5o8Oipot+fjGhjrsjnjTc71ugEAHo+6hmAmnkOK01C8
         taLs2B0AsZwKn6Zuv9mAnOSSqJTlQGhRiwasHOnN7233oLjhpi4bP/7JD0wZFF8AekLR
         k71cXpnKep+vzf6rcytAxRqImfTbpGRcdqDtzrfkHeZOEug9Rhu3fWscOeqalGCA5Scw
         gT/w==
X-Forwarded-Encrypted: i=1; AKwUvByWG+YYFDnBlLSnwylJhthnd3QUvI5C1PcRKDOLWf10Qf4CkMjV7PPT6RyOcdAkdMDp7yTHoqppig==@kvack.org
X-Gm-Message-State: AFuF++lmFaQmSqCOcRpguFM5d+DTA39ooFui+19lHtDyDMwH8FHDTNUH
	uobehm+0yqZiicxAZEZxXrDtnWzkcY1dX3iMU2xiarY+hzvbUMVpeA71
X-Gm-Gg: AYBFou2asbn/XpBpuxuwpQ+bL3kEi2kT20CLNAcx78tN18LoMVU2PxMQwpAL7Dp5PcW
	N9XVzYuiMS2Is55+q6W4m0jQIHhXzExCPeVsiK5rzlnnnDC/tAVlUkGnlI8VdP1u17A3P0KPk1W
	uQnv6+h0SX4mcIkysr5Qed9icvIs5Mk9VlKPWHzM9dLKfn6sbPPRwJhENcpXWe5eXj0hShlbEnp
	4gBM/eF9WSF+BB1d2ZXlqDgPHCjY2y06p62d0P+KPcqAdc2EtFFMydJa1MwGX0ujvCexd5ezo4w
	RIWGVmrK4G8wzi+KlpLAB7RhAg9WJidiUamKQ/vgZVtN3UQbhHkW453fDqa6oKXl1MgrNxHf1cy
	EJfZtnDrzx3uAuCUn2UWodx1LQZTxJEuZOtqjn+zunBkUUJoo5RX9rAr1ZaJZqKkkZDjVq6K/Ll
	FrCT/O3J7MZptieSzJObHgy9+U7q8zfbhoeaNV9awQBllF18sGZFkhuxlvGAWWpYEgDw==
X-Received: by 2002:a05:6a21:a38b:b0:3d0:9164:98a7 with SMTP id adf61e73a8af0-3da39e830b7mr51255235637.11.1788911780383;
        Tue, 08 Sep 2026 16:56:20 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:60::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33825669695sm16122237eec.3.2026.09.08.16.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 16:56:19 -0700 (PDT)
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
Subject: [PATCH v4 3/4] selftests/hid: build the BPF program via the shared lib.bpf.mk
Date: Tue,  8 Sep 2026 16:55:51 -0700
Message-ID: <20260908235552.2610256-4-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260908235552.2610256-1-ziyang.meme@gmail.com>
References: <20260908235552.2610256-1-ziyang.meme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DCBFD80006
X-Stat-Signature: en1mdwo16gztoci8psw5pgitpsdzr7go
X-HE-Tag: 1788911781-775728
X-HE-Meta: U2FsdGVkX19kyWygRymzcoa1n3mSfurOZzm4ZKrLC3OfMRSFoevJ1DQrq8b6xqDF7MyqsB1BaW+KdzvE87p4csN1Zq9v0FB4OuQ11Ztl/cmxjQLKN5MNicJPZ8uUqvjtFQYN5+E3HIE9r8jv2dlxdZh2ZNVVZvxqBe97qHfNais8k4AH4/9SLcOvMvshgFIxvFV0gp6pRhkLDmu69w2H+RXUy8qnCB1Z248ehgGhl/8gqfOUPoklwvcWb3oj4LWqd8GCbRafHbFLHv5q8DYicZwU7AfTB3jNRsbUQomchOepyO0Q5az+Dk/86wiD49d1ChrqzGhvXBq1nh2wNSekBcG0y8RhrZUwiCy/WsOJbxE2h9ywLo5PLVvFqsytgie8WMCXRAfacRlQdOffINkzoGKK0U/V4J+DzjCEdaUS/DVWO+2KJvnTDXTsNnWdINQyGiYeY5hRIhTXEKAwjW+dGEPE/b0t08fa32dP/vrUaYLYMScZbzkEgoJjWUtagNpkr8BTHGPgT/DL7XshzPZKqqVDPG1+zIfuOQF+GV74oL03T5UplQaJkujyYvjAzBO8sCKlmDlzicB9YWnjE7HUls0fPRZkXQJaH31vr/Z6OZOvQIIEBNlup/6jWxfm7yxcK5WU/Y6Un/kkziTqO8BVL6BjSYeWojo8cVavxRt67IAmHPYQj+OUud5taq2nm5H/i7TaKJeGeT4hSov04Ox2LHH/J9Qg078iZIgGYscV1IB4rVuDruYipo0zfskT5t/I7tCElzz1DuLS5Ztx7Qur50N13um5SjEqAr3j+/sjmwH7/HCVioK+wRec4A6iV1/whGPJEQCl1Hy8nQAbyPi3dHohqBVo6dUDKKGroY7iYRuIdFc0vREVTIFj96rLb01YYc9+Pc5uuyoLbywxSFD2aAH+M0sOCBeaHZ45gSxVMguDwEk7WSgECxCLXXdyFTyksLMxvrk90s1PtaKt2gL
 6QxVA+CI
 dMoYZg7kA9liHTkzkZsvJhTQfEHzbhYAUc0IoJ/G0oDAS1uggTak03xZZGVq5Rb5xpmy47JEcwudrp0dGP0uN4GriABv767gxEW7wo2ihULIxpBJg/Dl7QyNAo3qyFrwyj8yZtfxbQzMEooJLh2fAVkAp3+VUZbtr9EpFuymmSF/RzChGdy8FLbfyRq8RwiQiLABNa37T1z3OSEDGlLEBQ6bbB5ZNNHK6erGzigYesNnLytU8slR+6I/0Qlypesb80o0NoRFgvyw3i7jF+LhuDs3pTmZfHFGR9zgH0a4Bt8J7ZfFUQrN7AxnCEnhFKIc2ZyWNaj4Q/OH+gIDHyNVmWnbl62QS+N0MBciGFAQR765j8xkJbbpqYZrJiHeRIrAbwjYLIPgf2Ys0bdPJ4A+TdSUUV/80yePq9ZI/GQCXL6l0Je07Unl0mJjCuLguNmiSeU0j1GyzU2tSIrEbCrZ12m3OdzqJTl3AVZVGli6d1g8pkS9/t8mecLl09jXBZb8WceEFhfHwj1uxE1UZqCPx8UskswzRYfT1bxBkBgOZA9s+B8L9xGebUdtlgEnLk1TseeQ1Zv5hUsP9mCBK8b1kuQ+KonqENcH9GWM2
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


