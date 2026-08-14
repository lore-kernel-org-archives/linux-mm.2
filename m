Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B45C3C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 07:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BFCA6B0643; Fri, 14 Aug 2026 03:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 297D96B0645; Fri, 14 Aug 2026 03:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F5E6B0646; Fri, 14 Aug 2026 03:51:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD0A36B0643
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:51:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54237403B7
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:51:19 +0000 (UTC)
X-FDA: 85099104678.21.DFDC79D
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 89DE010000B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:51:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l7v321oN;
	spf=pass (imf05.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786693877;
	b=toYTSjZqwFZi3VHbqwTiwMVBQikDxb4awQ+61HBHHX1b+MMbDeoU6LvQGFtvFr6KrO0Q9r
	eU7JOHlHeYYZ7aFr2zzbb1Xt8L8mB6evdTmhq3QAWKOjInVzJYiIgVpKlWsfVL2ceGsKJK
	DhwZv+OzCAOUeM9IEawMOumpGP11a+Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l7v321oN;
	spf=pass (imf05.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786693877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ic+zxcFnUgGphC+WM5P08jxKZUHNK9ABeGTpRSb9nWQ=;
	b=1WqeBZtF6WUScRdZylziF/29S4V46qibgEXwYh8vswB2O2Ol/9qdY917ko2QH9diPe335o
	AMkDDpMoWvo/RpsaWWJC/VblEbPZxEP6ilqEZjy7MQ9emc7e4CptLo3iHcJoa3liDJ8bfV
	7xkHEzmtCC95ToT7/XRMpV6nmgPXqDQ=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ce98cb8165so6588465ad.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 00:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786693876; x=1787298676; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ic+zxcFnUgGphC+WM5P08jxKZUHNK9ABeGTpRSb9nWQ=;
        b=l7v321oNzJc5OAiPgHf/EQsrhFDWxPWim9FFEl9zS1iICVgs3h0O6I3WrEO83H2MS2
         n8jjBI4NenPRvg4fcGjlzDd9Aoj2T6QE+Z3XkgIyY+UYo4cQ8/gnODI0seSqX5dRTjlR
         cYIt7rybGv/bMpn9L6bWTXi2SKm0VC6Eu7QyDGQ2prTfC8z/Gi+LiNeLmLs/sOTalKWV
         EQ5YNWMWX9kgLWEfTWqUSKbHj9Z26v5P2bfn9tKPDu57rECttcEQv3KKej6VT5ArleWu
         umwxjvJy6w4TWEad1hG84NlsYndFRQukBZegbvWfbdZelgtgLr0HxXy0ZhChL44zLqeG
         CzjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786693876; x=1787298676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ic+zxcFnUgGphC+WM5P08jxKZUHNK9ABeGTpRSb9nWQ=;
        b=o8e5k5Zc/3MmOPG1txKZoBQP1Z0R6zfQiEGwVCqf6q/DcRGy1XQquYz6b3hvoJJZ4S
         xO0YIYb5P5Dy13SIgz8aKeSnIBdprH0ypErsCfGXS/2gzLuUSTA+kqrVZwSVF6IlfcT6
         EEUT/oo6tgI6Y1IdNjVICWCMzC8TlT69zHENdby3riCaDSkz/RZWAGhe3qkE1w/JbLnE
         tE10fRZFa5J/n6czIGSWPl/zkQBkRP9eJQnp0qhWW/Dj6eysa7gHDXeYHkA+p78tuE5k
         OoGS02OuU1hL5h2rMt1v4xOFsIR9T7bf7rjUqMzvnZIJEUsJEs1lC4ahG7iiVEwBPnzX
         mO+A==
X-Forwarded-Encrypted: i=1; AHgh+RqfPwM0AEXpJvK3Ib3VjZ/YkBZFo5CfkRG3J9nuhC6Jg5DogV6COR4ZLtUVpGODjW+5iLFduYuH4w==@kvack.org
X-Gm-Message-State: AOJu0Yx5tEbPuSb0U9L2Wvmsj/Jb+I9TTlL28vjMHu80Ie16qHVSE3Ub
	qpntMn4qkyolkkNXQaivNEHQ664jbAzsYF2p4LS0OUE/pLumytyBUZ+N
X-Gm-Gg: AR+sD10KKo2ff9z8S0/BK3mkxpQObbw85wN/mu5dET4FTtDRF+FZOOjk3FhXQXton1g
	AHsY0S4x+Cu9v1PXV+kH5h8FIesXNafNCAJsUdC2EguyYtxYuaB4XayCBwQxKnhn8V/hJHxrVbb
	bIz3PI6mHl1BxAM5iW+ZqgEDL+EQ80+Vdiq8ukupKq95Lnz6/ea3WItwVp7eXfjXv9wtdJX1D14
	EoLS1EI3xrM/U549VdI3nUXMZsl+lP9+grLOeepdLZya3yxdWGnSgyn3FM3/6B+jPFjuFe1kEkw
	7oaGeN2LkHlLFkQqxZDpdiAQsKJMhX5ZpY6Ie3M+1H1cIBoLSaQ6tfJbMoXhlDfMzgsuuJzyl2W
	zEyKKRQI3KJxnKYuOwDy5D0cqeNPh2Fyo+bsjl5JW55s2KsaqRR6p0n6PlFrFxFz6ro84iyvofc
	e/EneKdoBT3546vbHz5Kvar1fISwwLhfrZ8SzFGAj627Vnuw4YHbDWVso=
X-Received: by 2002:a17:903:1a0d:b0:2d2:72b6:556b with SMTP id d9443c01a7336-2d37f7b7ca7mr136997765ad.13.1786693876317;
        Fri, 14 Aug 2026 00:51:16 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:40::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320e9df2504sm1278521eec.17.2026.08.14.00.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 00:51:15 -0700 (PDT)
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
Subject: [PATCH v3 3/4] selftests/hid: build the BPF program via the shared lib.bpf.mk
Date: Fri, 14 Aug 2026 00:50:53 -0700
Message-ID: <20260814075054.507089-4-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260814075054.507089-1-ziyang.meme@gmail.com>
References: <20260814075054.507089-1-ziyang.meme@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 89DE010000B
X-Rspam-User: 
X-Stat-Signature: h81dfzc9fezgkhwg8jp8gx8exdqq36jb
X-Rspamd-Server: rspam06
X-HE-Tag: 1786693877-178975
X-HE-Meta: U2FsdGVkX1+XOeaco54rGQg4zpRpOoDwYfkBmQFGp4tBefFInod50QC0+i6D+7XzFBKFbVVZDTEZRW1XS9eQaVgHbo+HjIXhzwK8oE+pkjghIXoGyR3WArzr64z9T9hDTuXIovCPwNz90lfFGPdmgvCP0XBKMrWgOw25bbQo8EnHTpLcuEFS5RDL8p267Hmjz560cTG0NFwTWgmHQAQYJ7Lp1VoOe/gc717GfoMU9CsGA/adC8BLIIK2CnLcW/2IaqF1rvGpFA1JzDUtRzy4NfssspFmHd0MtMcBx6sS6Fl//TIvLX0MQQ6K/wNspBlVRO1/exGEPE0u44es5PgN+eXdSzMoG15dhZ08BrPni0nREvHG0p7I0kPg36P2LDn68Pnm6Pkr1SOF2rC1UNtwQhuTiYvePeiSnwv7jRH7gKwvwtgDMC/q23ZVJShRDK4ibKeQ0TJmPgrSdvLnKgO13YAJ6VuVvNq6RBqnu8w9IWTH3fb2hAucUZXn56BBW6RL9TzG7613h/kjKRxQcdUJKoHlkVZ73hwm+k4luYekHhDY9OB5ftSIv6UvLSJTGon/Ej1V+K/JefJllFR3JO4206/YWy8shxqDm9qrXpxbKg908+2ut+ieEJhBtE/WftwFuSqWd3kw9o8DfXc4TkSxABK1cmSHn6u+Bv98FtLNqSVoZ+8rfFyq0jXlpj6qEPe90tno+SuA2UiQptGYid44qW9DXbrai46gvCOl7W4ACjjsx+IbB61i1GhS6T6AkD9rvCMrJjzVIh1TixMpoK9qb2WYvatV1YB1Lh3OXFkr/21pe1PqYvadaDUXEQ/8mY18SplK0kVGr27D/+ecz8aYjJjVchzScAPUFgQTyouMMVWYs5fpxF/ulMGIMVvuGD9t37fnRG7VDLE1Jxr1eFi5xzZjyqVPdIEshrcz5xEK77w0qwWqh/7hGjqW2pmN+SI59OJQi9E69vLLP0xTqzN
 jW2fCOGR
 RteoRgyhbOGuDhIM8SFrtLTfUWhtkMXWK9d+hMHAmou/O3FcQ95IgVVeDpkBhrMBop6RlDIgX1vOM0CIwF2oV2C2MHNYhRxsKJZB3Tc2Gqk3cMoE8vZYEBQ+EBHpUgeSDxeCTW0eG6/vKBZOhxjLBltDnRDDHPJVYx+o+HvToI3tQxHLfziviR95waTXRKCCt0dEFjuZXzv06QOUT//zETgZ0geWar+iwZhce78i/dVkWSOCX4n0BNtiVt06C9tKQQO95mXkbfPu4qZGO2rq0K2QSGD2/eb1ZT0DBDzCHcvSdDUXTAhCgPQVSDl3GDcmjq/ySw/ToWPgJBA0bxdHbJCcI2s5Cjoo2BYINZuEW0ZLPpf/TcTQeP4p4Ei1NmrGAVq3rhY+4rK3vlxOUIuCzA95JZXmrv0m4vq2MacJ3/5vdSDfeEmSb6Oq6LFvBG/AyFqHm9gF6drsRIUwNI6JdHYALdgyUPnk7nVB18lFQlKlqHwc0EWQihUoplXIeTXCyDg9VhpreGn8hvrJWAYSRJM0PmG1D8FJLnoJ+mNotl2uul6gHT+oG/ALMJyH3c3/I0+CtjolZ4VAlDBxHpUWMofPwgjY6OH5Siu/7
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

The generated hid.skel.h public API is same before and after, hid_bpf
and hidraw are built and linked the same way.

Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
Suggested-by: Mykola Lysenko <mykolal@meta.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/hid/.gitignore |   1 +
 tools/testing/selftests/hid/Makefile   | 180 +++----------------------
 2 files changed, 20 insertions(+), 161 deletions(-)

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
index 2f423de83147..1d7c64ec992c 100644
--- a/tools/testing/selftests/hid/Makefile
+++ b/tools/testing/selftests/hid/Makefile
@@ -58,172 +58,31 @@ override define CLEAN
 	$(Q)$(RM) -r $(EXTRA_CLEAN)
 endef
 
+# progs/hid.c is built into a skeleton by ../lib.bpf.mk.  hid keeps the legacy
+# progs/<name>.c layout, hence BPF_PROG_EXT.  BPF_EXTRA_HDRS is deferred: it
+# uses $(BPFDIR), which lib.bpf.mk defines.
+BPF_SRCS       := $(wildcard progs/*.c)
+BPF_PROG_EXT   := .c
+BPF_EXTRA_HDRS  = $(wildcard progs/*.h) $(wildcard $(BPFDIR)/hid_bpf_*.h) \
+		  $(wildcard $(BPFDIR)/*.bpf.h)
+# hid.c predates the shared -Wall and has a few unused locals.
+BPF_EXTRA_CFLAGS := -Wno-unused-variable
+
 include ../lib.mk
+include ../lib.bpf.mk
 
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
+# Ship what this directory shipped before the conversion.
+TEST_GEN_FILES += $(BPF_OBJS)
+TEST_GEN_PROGS_EXTENDED += $(DEFAULT_BPFTOOL)
 
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


