Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED0B6CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 16:10:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1908C8E00CD; Fri, 24 Oct 2025 12:10:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 142598E00C9; Fri, 24 Oct 2025 12:10:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 009BB8E00CD; Fri, 24 Oct 2025 12:10:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D8D2F8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:10:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FCAD1A0F0B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:10:13 +0000 (UTC)
X-FDA: 84033494706.27.C0C8F9E
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id CD7774000B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:10:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HRLV9knB;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761322211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sN3NXoZOBQaV0qk4GQkx+g1ZE3W0dyobKn95aWS8UQY=;
	b=zx/mlhiRK7Jg0CelUbJX4Pwj0Q1CjH6qxXAIRTMaP7BPw0pBpmqyJr1Z1GRh7de2LNQNQm
	9ugAxZ0oP/hYBHBNGzRi2hp2aVWeqj71jYw40IW0fFdFcIb15olfpcH+WDBEhoRodcbgHC
	mt38ABJPvbSdBN7j2UGwe/usJ4BS3/Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HRLV9knB;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761322211; a=rsa-sha256;
	cv=none;
	b=cjWf88d7Et7BfOdQioUCq3I8UkzPDFd0s9bbm1Qg1QQeyPbU6gIKtpjT/CPdlKUbUSc+rz
	TEuiZyGUYHSxqA8TtBwyavtGeMW2uDLc2MXe3O5AkYIbe4WzIffkkkUUEpLNgonbLVqYZ1
	/V37EfYJ1cewkG9974AmtDjQYVYMzmo=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-783fa3aa35cso27324927b3.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761322211; x=1761927011; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sN3NXoZOBQaV0qk4GQkx+g1ZE3W0dyobKn95aWS8UQY=;
        b=HRLV9knBiiYEhJel260eiKotwa5M+DfZneqCIuL2P8QTMuIK9NEK6O1BD9goTMuy7R
         MAacRBNT9xpt8X2+nCB9uqHyWXOvmS1WyRSoY3UqLg+kHSggSn+GUcq5oe5oBSx+VFMd
         4CkfphzyQKLt10k0PxvOAdTgG6mfvOvQjwuCAJoDbn/9Uz4KgPoHkBDANYR2veppJffg
         Mii/Rqp9ZJXsnElczWt2xD4m7qgNlmXrbYCYCojdyCu7FFfjPElfBPLdfTg6F/2ED72t
         xJZbd3RvPknKCiV29xg7o7ggMCgWmmYF3o2gXvcrZfxVxgf76JTvd4BIp1iadwDbMne6
         0MDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761322211; x=1761927011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sN3NXoZOBQaV0qk4GQkx+g1ZE3W0dyobKn95aWS8UQY=;
        b=kx6kUTs96lFfmdHF5jnR2uRt1c9/N1BXnMhTa2IswjN3Jmq87HbRcpLsBWLhhr/Wce
         rS5dcIYb4pOYc6xAf2FzZoSVMnRDLSoY/4i9jmsxEgoG5kcWxZQBtg5z8QOLfH3+4NFd
         lX1TtrKDdKm2CTbVPDY9ltiBJRW9DyydsSL7jdUw67SA39aEY0sOn6oMafkdmC2i30nw
         dWGLp9vPmbhRvZUMFz1V2y4Hr5svP85QKGRbSXwyP2yNV8ftsVzlMiMkdyF272nsQ/bM
         jynXWXLD5Vn7jXPo2xorEI1kvlNj1MNSwNhag/9+tWyfXtkfaNDrNRpINOAFaFfhvrTK
         Wbpw==
X-Forwarded-Encrypted: i=1; AJvYcCXUM0za8kojQlpYVvoUU2iRQJDf6xq8gWqRUd28RM04t1gkIEy2PPEPb4M8KoJ1gXZ5kW3w5lA2Ag==@kvack.org
X-Gm-Message-State: AOJu0YwZNvwjBUfxUp3UpDa5KTRByREJWVl9SOoj9Ph+1ZezHvF82Rob
	X+Z1BaUNvsv714usNJZN9w4qMTXu5tx8KDps2GgCIrJYxHL0BOTDjfzJuGl526s6ryw=
X-Gm-Gg: ASbGnctlOdM2vzY2lYX0gELrH/er+Y9BAICS7O0w7HtUmoalo01T32ysTRA5xhWx4sS
	DJHVVSC4VZje/S6i0hVQ6qFxxIs1aNNKiQ2qRrHJw7rf/XZAjoUynnLplumxN3EY4+xa/L7AJNX
	487/OSIyR0SF7ntJMrzx8bmRCFyOPCbQeq+FAe3wXJezI0KZElXFFmMbulXBDFO72Vmfg5AL2+o
	lfAnrFnLn0OS1QsicRI102to8ifxawWh0mJuPJoDJGpkOo8epCWMPVpMNDamPuf/z/AL2G1glzk
	vlpZgIXDm1pCHePJGMsTULbaHH6mSVHuwb/K1PCPLMrI6osZpVMkWocVjBjWGvh97DtWY1zmgzE
	6K/dWXZD4lwEjvNrTBcTOfebdBi0o1bjzTPevKiVehvoVT8O6jpXU5nMY72uEexN9A5kVROhSjw
	l47GOIITbvr/SO0Le0rAEljcMfko/1GDQv2j7D3W0RY6D6iBp6C2cyk5FHVwmWaXpdNPGiFDe+S
	O22ke0kon1jRsxaj6N6WfkOGhdA+DmrpQ==
X-Google-Smtp-Source: AGHT+IE2zX+p6Y3PDMVI3Fio8m3zVktQ5V7vVyOcKDfiGfYYf436D7pO0NOBbSVmVxYTK4k34aoLiQ==
X-Received: by 2002:a05:690c:4a06:b0:785:cf36:6b72 with SMTP id 00721157ae682-785cf366ba7mr65136627b3.50.1761322210780;
        Fri, 24 Oct 2025 09:10:10 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-785cd6edd87sm14099197b3.51.2025.10.24.09.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 09:10:10 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org
Subject: [PATCH v8 6/8] liveupdate: kho: move to kernel/liveupdate
Date: Fri, 24 Oct 2025 12:10:00 -0400
Message-ID: <20251024161002.747372-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.1.821.gb6fe4d2222-goog
In-Reply-To: <20251024161002.747372-1-pasha.tatashin@soleen.com>
References: <20251024161002.747372-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CD7774000B
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 48qmyxfn8jw6ygebgxhgpfpnztj3n1xi
X-HE-Tag: 1761322211-410020
X-HE-Meta: U2FsdGVkX1+SDPuzk0kEwF58gKWMsJ9BngiIF5emg/9Acobhb20MWy6KqYdmmyj9oQbh6VrT35jvD9g4BUfSqgz9yFEdzJT73ikQpLCXwalf/3xGb7+BvUSczwu9KkzeEWL+UYDnPNz3ZTZ3NiDgZ2HO5P8RUQIS60BMu2+QKhEWbvkR6UBLHC/ghyLWp7zas3Sws0J6Oe9RDbbmewi/kpxx8msYZ1g+rnuEtIxMwQcyzNpnpH3pz074yX7roZDgZp8KumLroAeix+yP/0SiqbGO7c+V+qQT2fekESDNt+C89rpcs3J3AaXBRDtzC5IQH90RhtDFrbdyctLo4iuU7RoPCDO9psdAaMwYsBzCG8xxkYcWxQDR3EIzlySAppNzEIWMXLsMx+6FEOnjZUz1Tagfs1p6kUyZxQ/yKd2+K+0Isj/nIIf+o3wwPa2qjP3DhfE/01aS9xdZKwgYcek2C9malPfhyoZ2rePLy+5U7Xl0FNhAL2wS91jEBHFAxtYMAricGA71Xj7YCeuOA3CG4ojSffWn7nzhRW3Al/ID8SGESKpgq9TD7Mk2qJA+Ef0QjaWEAGzRj1Mgo8xCJA7TtxyH/WDHi5h1gfEoPCF0Q+DbJl+9FXQUTGXnHDXiE1Fn/7S+EqAqsKEoOEvR/W0iFS5jZ/tfMt3DQMjJnMYGkyZLLhZ5CQsfGL132nbXHy66SPlrv8vX5/rZO1CLmP7CqqM3i1RZXr4x7jHHE9chSFhqEUPfEWDz/4LRMxna7zkXx5zyLiQdoX2EExdf/h6g/3Tzj4Cboexfo+ZiC2cwL4veLABhsAbSgKfzXj+B42cwYpHg6tE33Js72pTCe8hfeQqgHxHw7Op3uAPXlzUDevqDMdt9QePi5NftbfZIss404p87jdeRbRBMV3khBVa/Yp7Nafm87Q4znBW67C1scoShMTj3JkYgQZutsIv3r7tsa8M/etvnBwcd4ZH0DHf
 O/ke+TZN
 HCMBrtmpjSrE9zS2zAqnaGzTAjZAEHSl0qyw6X0ohZolwPWFZ0A2azVsVmmcI3k8l6f3xLMIiO3xmjwqZLdQQ8CR2kA93rmlTJJoRHm+64EVXdjlde/quNzKoE3ihqHmZnPjQHU+3MZzxjD7JcYJV5fN+NR1cOV6h5yQdkfg0IVK0fdGqz+qD1wVNp3aWAiMdpHHlkMbR1f8WCCFAWUqVoXMT8dofBfeEELoILJEGIo8X7RY0wHW8Ya/FK3qGG5DbA8DUmaRnidod2chHwSES6G8iLJiv5EThnI/iGZQ8s2hpMhZd0Do320Yvylv3Zev3f89+lQ83swRftmo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move KHO to kernel/liveupdate/ in preparation of placing all Live Update
core kernel related files to the same place.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 Documentation/core-api/kho/concepts.rst       |  2 +-
 MAINTAINERS                                   |  2 +-
 init/Kconfig                                  |  2 +
 kernel/Kconfig.kexec                          | 34 ----------------
 kernel/Makefile                               |  4 +-
 kernel/liveupdate/Kconfig                     | 39 +++++++++++++++++++
 kernel/liveupdate/Makefile                    |  5 +++
 kernel/{ => liveupdate}/kexec_handover.c      |  4 +-
 .../{ => liveupdate}/kexec_handover_debug.c   |  0
 .../{ => liveupdate}/kexec_handover_debugfs.c |  0
 .../kexec_handover_internal.h                 |  0
 11 files changed, 51 insertions(+), 41 deletions(-)
 create mode 100644 kernel/liveupdate/Kconfig
 create mode 100644 kernel/liveupdate/Makefile
 rename kernel/{ => liveupdate}/kexec_handover.c (99%)
 rename kernel/{ => liveupdate}/kexec_handover_debug.c (100%)
 rename kernel/{ => liveupdate}/kexec_handover_debugfs.c (100%)
 rename kernel/{ => liveupdate}/kexec_handover_internal.h (100%)

diff --git a/Documentation/core-api/kho/concepts.rst b/Documentation/core-api/kho/concepts.rst
index 36d5c05cfb30..d626d1dbd678 100644
--- a/Documentation/core-api/kho/concepts.rst
+++ b/Documentation/core-api/kho/concepts.rst
@@ -70,5 +70,5 @@ in the FDT. That state is called the KHO finalization phase.
 
 Public API
 ==========
-.. kernel-doc:: kernel/kexec_handover.c
+.. kernel-doc:: kernel/liveupdate/kexec_handover.c
    :export:
diff --git a/MAINTAINERS b/MAINTAINERS
index 35d7942b2082..400209b74d95 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13822,7 +13822,7 @@ S:	Maintained
 F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
-F:	kernel/kexec_handover*
+F:	kernel/liveupdate/kexec_handover*
 F:	tools/testing/selftests/kho/
 
 KEYS-ENCRYPTED
diff --git a/init/Kconfig b/init/Kconfig
index cab3ad28ca49..0605de5d96c0 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2138,6 +2138,8 @@ config TRACEPOINTS
 
 source "kernel/Kconfig.kexec"
 
+source "kernel/liveupdate/Kconfig"
+
 endmenu		# General setup
 
 source "arch/Kconfig"
diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 9308a0fb1419..15632358bcf7 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -94,40 +94,6 @@ config KEXEC_JUMP
 	  Jump between original kernel and kexeced kernel and invoke
 	  code in physical address mode via KEXEC
 
-config KEXEC_HANDOVER
-	bool "kexec handover"
-	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
-	depends on !DEFERRED_STRUCT_PAGE_INIT
-	select MEMBLOCK_KHO_SCRATCH
-	select KEXEC_FILE
-	select DEBUG_FS
-	select LIBFDT
-	select CMA
-	help
-	  Allow kexec to hand over state across kernels by generating and
-	  passing additional metadata to the target kernel. This is useful
-	  to keep data or state alive across the kexec. For this to work,
-	  both source and target kernels need to have this option enabled.
-
-config KEXEC_HANDOVER_DEBUG
-	bool "Enable Kexec Handover debug checks"
-	depends on KEXEC_HANDOVER_DEBUGFS
-	help
-	  This option enables extra sanity checks for the Kexec Handover
-	  subsystem. Since, KHO performance is crucial in live update
-	  scenarios and the extra code might be adding overhead it is
-	  only optionally enabled.
-
-config KEXEC_HANDOVER_DEBUGFS
-	bool "kexec handover debugfs interface"
-	depends on KEXEC_HANDOVER
-	depends on DEBUG_FS
-	help
-	  Allow to control kexec handover device tree via debugfs
-	  interface, i.e. finalize the state or aborting the finalization.
-	  Also, enables inspecting the KHO fdt trees with the debugfs binary
-	  blobs.
-
 config CRASH_DUMP
 	bool "kernel crash dumps"
 	default ARCH_DEFAULT_CRASH_DUMP
diff --git a/kernel/Makefile b/kernel/Makefile
index 2cf7909a74e5..e83669841b8c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -52,6 +52,7 @@ obj-y += printk/
 obj-y += irq/
 obj-y += rcu/
 obj-y += livepatch/
+obj-y += liveupdate/
 obj-y += dma/
 obj-y += entry/
 obj-y += unwind/
@@ -82,9 +83,6 @@ obj-$(CONFIG_CRASH_DUMP_KUNIT_TEST) += crash_core_test.o
 obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_KEXEC_FILE) += kexec_file.o
 obj-$(CONFIG_KEXEC_ELF) += kexec_elf.o
-obj-$(CONFIG_KEXEC_HANDOVER) += kexec_handover.o
-obj-$(CONFIG_KEXEC_HANDOVER_DEBUG) += kexec_handover_debug.o
-obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS) += kexec_handover_debugfs.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup/
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
new file mode 100644
index 000000000000..ae8bdd87458a
--- /dev/null
+++ b/kernel/liveupdate/Kconfig
@@ -0,0 +1,39 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+menu "Live Update and Kexec HandOver"
+
+config KEXEC_HANDOVER
+	bool "kexec handover"
+	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
+	depends on !DEFERRED_STRUCT_PAGE_INIT
+	select MEMBLOCK_KHO_SCRATCH
+	select KEXEC_FILE
+	select DEBUG_FS
+	select LIBFDT
+	select CMA
+	help
+	  Allow kexec to hand over state across kernels by generating and
+	  passing additional metadata to the target kernel. This is useful
+	  to keep data or state alive across the kexec. For this to work,
+	  both source and target kernels need to have this option enabled.
+
+config KEXEC_HANDOVER_DEBUG
+	bool "Enable Kexec Handover debug checks"
+	depends on KEXEC_HANDOVER_DEBUGFS
+	help
+	  This option enables extra sanity checks for the Kexec Handover
+	  subsystem. Since, KHO performance is crucial in live update
+	  scenarios and the extra code might be adding overhead it is
+	  only optionally enabled.
+
+config KEXEC_HANDOVER_DEBUGFS
+	bool "kexec handover debugfs interface"
+	depends on KEXEC_HANDOVER
+	depends on DEBUG_FS
+	help
+	  Allow to control kexec handover device tree via debugfs
+	  interface, i.e. finalize the state or aborting the finalization.
+	  Also, enables inspecting the KHO fdt trees with the debugfs binary
+	  blobs.
+
+endmenu
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
new file mode 100644
index 000000000000..f52ce1ebcf86
--- /dev/null
+++ b/kernel/liveupdate/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
+obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
+obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
diff --git a/kernel/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
similarity index 99%
rename from kernel/kexec_handover.c
rename to kernel/liveupdate/kexec_handover.c
index 6aa25d304bad..20c7a985828c 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -26,8 +26,8 @@
  * KHO is tightly coupled with mm init and needs access to some of mm
  * internal APIs.
  */
-#include "../mm/internal.h"
-#include "kexec_internal.h"
+#include "../../mm/internal.h"
+#include "../kexec_internal.h"
 #include "kexec_handover_internal.h"
 
 #define KHO_FDT_COMPATIBLE "kho-v1"
diff --git a/kernel/kexec_handover_debug.c b/kernel/liveupdate/kexec_handover_debug.c
similarity index 100%
rename from kernel/kexec_handover_debug.c
rename to kernel/liveupdate/kexec_handover_debug.c
diff --git a/kernel/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
similarity index 100%
rename from kernel/kexec_handover_debugfs.c
rename to kernel/liveupdate/kexec_handover_debugfs.c
diff --git a/kernel/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
similarity index 100%
rename from kernel/kexec_handover_internal.h
rename to kernel/liveupdate/kexec_handover_internal.h
-- 
2.51.1.821.gb6fe4d2222-goog


