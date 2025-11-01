Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06E4ACCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 14:23:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2778E00B8; Sat,  1 Nov 2025 10:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874A58E008A; Sat,  1 Nov 2025 10:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EEAA8E00B8; Sat,  1 Nov 2025 10:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 404FB8E008A
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 10:23:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EBEC91A0684
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:23:47 +0000 (UTC)
X-FDA: 84062256894.02.418F0DE
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 28D96180003
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:23:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=INKOXACm;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762007026; a=rsa-sha256;
	cv=none;
	b=sWTS349g0glWIcD6Ua/JoqI/7xFsPHz4735ZT47yAXg9QURV8uXIeUWw4Hnz+aApcxlEeL
	vm1/xkF0Lz4poWwPvchnUFAAgGAdVr0wrA72Ts58yEpZ+581fc4ztyD8j5jjdKL4/CY260
	j+yNfdpS+1usgncHGfsJmEUPpEWk8CY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=INKOXACm;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762007026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GqNjQc+nWE3xdzzLNsyLKvDeccdmT+igcGJuf8ZrBtc=;
	b=f3nFuJRWxH4Wbwt7g9YW66OY/hzgGwPOpSf8wK5NsSNo6trb3abcAQoFgmiVMJR8vipgWw
	iJeBNaxXfEXjdpBvY+ASdfdcqP9nF53e51B0hyZzUEKj8puVewJBTlEkgpYTm6A4Pv09xK
	vs6059/A2JkKubhxfrvowUURae2K3Ho=
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5563c36f6d4so3234333e0c.1
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 07:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762007025; x=1762611825; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GqNjQc+nWE3xdzzLNsyLKvDeccdmT+igcGJuf8ZrBtc=;
        b=INKOXACmb4ny5Jl9Eqpg0LlbcTghrYQ+/u3OaumrT4UEtr9GHQamxEbwvA/p+9Cp1h
         UjIpkCZptxlKy0FcXK3mjLTp95B+OwXe7rzEidS0N3/EpCQpyUWmbG3c8wqaXUY6hq1J
         mqoHDWZwh9ccAb9Vr2iqd81y32uEPSoWTrUxe4diP4yj1otvtfV+aXp2WWZfJ8EQXKEz
         SnziwM5RiM9hZcGgJCV51E0kWXNTgfGY6L+adEgTg4BhR1a2+71GovkWOue1XM465vsb
         t8frZlCIuXoA8pOhJk/3LKF4M7HAdCTQqMx13RN9QtWay8Efkk4QTlK2V5j0unQTglNK
         of2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762007025; x=1762611825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GqNjQc+nWE3xdzzLNsyLKvDeccdmT+igcGJuf8ZrBtc=;
        b=dQHVuMRVuUts2yP4mI8+PvhDL0N4kWQk+qVIARcwqbX5EjmeLYPM1LNGO8dfzUi4Fo
         76akkZ8/ABh8bCj+cOmIa1/CQ+/IVchs2yGHpU16gfObIFX79XVkYSrHMWyDuU/Xl017
         6kaFimaPqU+RJO/R9nOVUg4D6EW51033JW7M441BajaMdNxuOQFEOcVAC7K65PER/V3g
         GgU9vBHS/Uscmkp15w6ya4DsHljE7h9V9cbtAskBbcOGgXtahcsuUeUWwh4wxF/5aZld
         yknBmiHlRirKUE8NAhPyPhoL9Sr+3CWCKdRkGzyTyWqXMfoEOicTeFwYUSQcnmNqT3gw
         eQRw==
X-Forwarded-Encrypted: i=1; AJvYcCX673CHmoM5bL8em2xCp3iKmN9KdPU8m3JFyJFvMmcdEgBIfLrR7PDYFMEUiZrB+CODgF8+UW3OgQ==@kvack.org
X-Gm-Message-State: AOJu0YyRZ0XC79R5JHb9xbKeQhTfb8pUycvLIGNUbhsBCYZvkjgczo0j
	mLwasQKvQ2Lbxp9hI8Vn41fV7Y25uGdZbqbt9LjIOhqWww+wIQIUSUha71M4gjGcsLQ=
X-Gm-Gg: ASbGncubjEVgrE4ZQT3baaKroSuwp+j9lBemRiWQohoxNm+2HfYOrUOXnfrVPy0Hhdl
	F8HVhPzxE3Ar+nmJOHtlyWGVU1d+htxWOLfoAENZ5Z23Tj7V+2fxUsivEZxekbaQ8y1f+kAZTUe
	qkjBQb/wJ/O/TRi5i54kwr8z10Yr7p1eVSKiCQ2uSCobuUISfslurdQUILt5Gows4QuvPnjgUev
	8ZNC4b8sXrzQr2ownM5taJTV8nCd92UqKnmmzp6YRt1QLpbe5lZKjPMndGjlf+AKFfz64PhXh9x
	aYDXiibPIXX5p+khiKrZ8JbOEJ2IGq5U5ygoGfNjrWDSMgaHuWxQtd7zx6ZQ98WvG9dWuDFZG4i
	4FzCrYVl++vKqYgb05C6UUkU+A2I4TuX7B1JCwzT71eL1v5ZRVd4LsO/nkGKLYq4FabU3ss1sq9
	Jax2y12XpgA8EdTnZJtmE+GMui45LcMBFmqwuhp53iN8g6KfKUIhV5vIPXWD0P
X-Google-Smtp-Source: AGHT+IHYfN0T4cVNH96uqE/VxqJsEPgIJwOQllfGh/DOiPLvpYAfaaq3PsJ2yY0Nnq8P1OfSoH8nvw==
X-Received: by 2002:a05:6122:3289:b0:552:3366:e822 with SMTP id 71dfb90a1353d-5593e260540mr2675875e0c.1.1762007025167;
        Sat, 01 Nov 2025 07:23:45 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-559449647e0sm1776242e0c.3.2025.11.01.07.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 07:23:44 -0700 (PDT)
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
	tj@kernel.org,
	yanjun.zhu@linux.dev
Subject: [PATCH v9 7/9] liveupdate: kho: move to kernel/liveupdate
Date: Sat,  1 Nov 2025 10:23:23 -0400
Message-ID: <20251101142325.1326536-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 28D96180003
X-Stat-Signature: 48bafe8t9ugex68ksoknowq8cnwcdsgx
X-HE-Tag: 1762007025-749561
X-HE-Meta: U2FsdGVkX19SR5joaXczxX7tO7spbtfSyJN71IjxOatU3bsEiLgyLwVDrMxmwf4ZR9UYpVq7FO/Ot7kTPhoatCALrbdb1lmbjf4FNB3UdFqPOqcGmRXLBpJvX9wY4HCBNnpI21OBBOADBKbYmuNN67gfRUO2EzFEthsWnaCrP8rptadM0dE+5oa8XrZmIMnbE1zJ6oaJAx2Vtwp5UTVsPSgtgDQJmj3IJuLP4XvFkI/4wT7L2uDc2d/YsMH6Mngrrd5G2ir22eJJIuXGWuRSDL1bnMg8heZZBweZrY0053mBL7oNBz1rShdq5wVJe/i2m4jYsCdxaEJWFIAdObLC5oK21rk2oXVQOi51nM+nZziyYwL0XRZFE2kfe4mbrBg3Mvj2PRI6bjBPBNTgJixMDUS4ezfacOG197KolIpd/YZjCcRl2LQ6sb4JavxO4c74loq0UiKYzM6W8guH6f0e80A4UqMm9J2cVMjP6zm4/2C+lbiDCvn6+NU6L/m+c5E6nvQ86zlXbAZmMd/T9UkBpqSax4BDQSz02tkuRAsigsIU5p19TfdGhrl37E9c9vgANBvjiHbj9ICKYOkDIN2L6KhRFFz5h4kfMGM6Boeg0lv2TQdozlErk/cB5ExNtb+G5aVykdoLVUS3h9mZ7TzyQblMiLC+7Xq7WAqpYA9A9KOEuvSjJPbg/Zw3XHtF1xpn2vmkUIvbZo4dTaC+P+G6KL0qIURrd5BHlb45S26EUn0S0hNsdzjX8Th+yE4fQrbbK3KRP4aIGdCVKhRcEHGkqJCGTYv1aFsFaHe8ameA2Iz0RDSbEo7S5bxDPxmbsUzA0HusKy8QwX1YN7un5bUA6771Gr8+ovmwQPM6gWbRiQqjtyvq4ipoSvmvwVgYj/H1Psvk5y6Q4YnfVWhpArBoK0g9jULlv+r1nphRD2HBrxrVmT2H/yEhIMO/5Cb7QF2NTKlrKfeJeE8xe4tGzlZ
 5QmFFYYH
 tJfooUZUIEwMumgW0m7kTyKA8KXWaOl8uHU9XtI8kNZ0lL3EARuKysLvpbuvYcnS6krmytymn5X4H5Z5jJtI3nkSUtnxFMvIZT13CuagoGWM1D+Ub+xtxaaye08jyOtbFvnB2ZxYbtpIdSD3nfvLuIaOT65exwU+MDI1pLiNKHKSf5F6Aj1XNcadwyJq9Fx6KcsA2mZA74kk7+3P118itOH2Lr9/OeFg/XojqCjID+GI3f1JRY9/2BvoSzbdsfgDOop04HANW12O4VvlI3D8kg50tnk3yOGMOWshoI8z7agWHC6RILZs6Uo19RMpQEl5QbDZKM+ZeSp87x/SU0TwIFcdOaA==
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
index bdd0a1260421..764df916fae7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13795,7 +13795,7 @@ S:	Maintained
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
index cc6743137946..15632358bcf7 100644
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
-	depends on KEXEC_HANDOVER
-	help
-	  This option enables extra sanity checks for the Kexec Handover
-	  subsystem. Since, KHO performance is crucial in live update
-	  scenarios and the extra code might be adding overhead it is
-	  only optionally enabled.
-
-config KEXEC_HANDOVER_DEBUGFS
-	bool "kexec handover debugfs interface"
-	default KEXEC_HANDOVER
-	depends on KEXEC_HANDOVER
-	select DEBUG_FS
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
index 000000000000..1379a4c40b09
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
+	depends on KEXEC_HANDOVER
+	help
+	  This option enables extra sanity checks for the Kexec Handover
+	  subsystem. Since, KHO performance is crucial in live update
+	  scenarios and the extra code might be adding overhead it is
+	  only optionally enabled.
+
+config KEXEC_HANDOVER_DEBUGFS
+	bool "kexec handover debugfs interface"
+	default KEXEC_HANDOVER
+	depends on KEXEC_HANDOVER
+	select DEBUG_FS
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
index 3adf86c7c2db..be945c133a2f 100644
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
2.51.1.930.gacf6e81ea2-goog


