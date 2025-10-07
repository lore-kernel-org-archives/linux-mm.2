Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B9DECCA471
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 03:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8EC8E000B; Mon,  6 Oct 2025 23:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2834E8E0002; Mon,  6 Oct 2025 23:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 125828E000B; Mon,  6 Oct 2025 23:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EB5B48E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 23:31:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 981CB13BB7A
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:31:16 +0000 (UTC)
X-FDA: 83969892552.18.90C18E0
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9D74E140007
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:31:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Kv4f/qjZ";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759807874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5YiQ5dlO7dBlobQ5XJDQPeGxLG7MsQM1BhS0aByLIw=;
	b=DL3NagfbdB9W5DSVQpq7SecyR/qVAtW5+Ibx/tnYmgV4kfrKZqfIQCBWEvYxrBPIN038KK
	H4QComfCEbordiD5snzu5xisal04hdcdIbrMAPytVAlHZZM/8Mo3RoyadpkptjIhataWQk
	oag+YHrpMU/1r7qnpMvUjXG/n4mpHwQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Kv4f/qjZ";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759807874; a=rsa-sha256;
	cv=none;
	b=7iTIx2Lj4lPanaVkrg5yzMVCaRgCKxps2Bc5KMb0veOw7vZNuiuHk987vrM81NR3EXNqEt
	vlIxc4UpP3KJIvZRAVHZ9JZ77VbgQ07ETXFH6fgmzCKdGHQ57dPQO6eUrQfmp3K87vPscw
	84EdmhDtAuAEGYVp2rxQOgBxR5Lxilw=
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-54a80b26f88so2227845e0c.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 20:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759807874; x=1760412674; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m5YiQ5dlO7dBlobQ5XJDQPeGxLG7MsQM1BhS0aByLIw=;
        b=Kv4f/qjZmNin7HYAA8Q4CxMOdczOZHpPgZbOAYQgpIk69hrK3T9viMqgUbrUykbiBy
         gyY6DkfgwGF2+9f95PJtdX2tptNqRpSkaMX2kbe3JlJFdiFHcqu8z8YavCRQV0KSbCpr
         8VhdvddeF8P8E6yePBW7JfahZP++2vMmSKcbR4zs+8yTLgHAhBkAQpKePA5PftMeRvke
         XhSOBVH5DlJ8sq+hNZk4A6ar2+WgYNvMgOEfIDTi5XJ/Vh711uDRY29c1Xo7gVkmcUjv
         t0Dqgdfg+DyJOvboZQ3vcQcuJC1/8Kx8rZ/JILygMKXha15syzLn23sDVi21XFuUlVyV
         +DPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759807874; x=1760412674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m5YiQ5dlO7dBlobQ5XJDQPeGxLG7MsQM1BhS0aByLIw=;
        b=I2yciXrCDbKL+6UnHRR1E9UkXMa+PJfjQguCGI7O93uoocMN2dqd0NavVDU6HQtV5B
         TY7PVvedfpb1ug5Icy+HwNn0RpNNGgQkG31w0bowX3YgoXJc2NPvLDxPIwmTveuoEdn6
         1YbfB3/G50Wnu8DAPKp7W2c/fYx2MqBlME7SyDE3LLTLB6zHhYCDAalQh7U+Znz6+8RD
         Q+zyI9eJkhCeR4ZKi76OvEsQrgkc9qaC3dJknQzgHAUQniLXkDYFFnoyRfhzbD92ICVE
         /bRhIHpjYxkGRqJgpp7hf1xfeLpuAI2RXQ7HF5vEYTTtax/XBL7RxBjRtciEghCRwIU7
         BrQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkC0DRXp3BFBaAH8rM8toWKwVx+B+d2OrnqRcfxgkAmQruNCIFcok66GHtRhJer+Dmnwat2pAiug==@kvack.org
X-Gm-Message-State: AOJu0Yx5VFzOO+ufVT3stxypQVwu6bm5okZ9wnUIKLPImpnhElueU0PJ
	JSIJ3iN5MMuHdMgCS8kEaEZV9bNT0sJY6EDDjxfUk12ZjYTrqgUq6fR36df7B4rUL1w=
X-Gm-Gg: ASbGncuL2ddav5x1dl3oPDtiEdpE0R7e74ZxHNDO4h7xgGFbAaGuNXlLGqD7dskKbbM
	DMhl2yh5g+LnXCpDGJ5b5lJIBO3eXiC8A4vP7tqWQgayH5hsSUrqhfTi1Rd7Y0F7So7efqZ2ANp
	CSfgvuXxkrDO/ap4HqUn/+bjdA3Ju8AUHdr1iWaidEvQaYwbFQ19qEZTTIgnIxlJy3Z2r3Y5yGB
	/bFIqbqLu27k+eY9VhFhzFXPl0ncRIbufkjk+VaXOjJKwrL2ynWWNC6vJHcOx7x/EpSql8jBgAr
	xrTpPWa2/q9OrtuSaR8h83ATduMdDYHYHOsNivfVJ0kUwffpSOQloom9C5+2q5hasmS8OSi68no
	ZYSlYy8pX0ddhWmHKtyzuqWrwiUR7CUzfSaG2B0Jd0Wr9vIeNzP5sjZtkDfA1Bb875a0jmAtZuS
	rk0bGjKZ64LVp3DUuKPCNCbxuYpPH7K0s=
X-Google-Smtp-Source: AGHT+IHeIDZnOswf52ELEZYN9Eapu+gsyWvQ4kUElr+dQYU/Cq4+N/m+PwBTQ8uS2hlStxD8ANRbMQ==
X-Received: by 2002:a05:6122:8d3:b0:54b:c215:8c0 with SMTP id 71dfb90a1353d-5524e417161mr4784194e0c.0.1759807873730;
        Mon, 06 Oct 2025 20:31:13 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-552ea335f07sm2446030e0c.15.2025.10.06.20.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 20:31:13 -0700 (PDT)
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
Subject: [PATCH v5 6/7] liveupdate: kho: move to kernel/liveupdate
Date: Tue,  7 Oct 2025 03:30:59 +0000
Message-ID: <20251007033100.836886-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
In-Reply-To: <20251007033100.836886-1-pasha.tatashin@soleen.com>
References: <20251007033100.836886-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D74E140007
X-Rspamd-Server: rspam03
X-Stat-Signature: bdqhd79wkuzg5iuzyinwu8pagd9f97yx
X-HE-Tag: 1759807874-930360
X-HE-Meta: U2FsdGVkX1/qPG4CaIYKl+84a+9NTtjPA8sl070Aeoxn38H+DU+xOo/xZQVtKcKAWLz5nWG3hfzNCTUd+ixnZafpEbY+6O52z2juEW+XSQxwLYD5I3v9hKgEoI3oOHG5iQu2JnQx46/p3OhT2Cehw/y+uAvxYB5khJYnoBa5huFAn0v/jYxGq6l9O/Tw/HHI4otC0nrWyb7xJxJ4wLj7o20WNcqxtEWfAPUmobR/xTTsaiOY0zwk3UI/sTHDe0y6/8A7RuoJQ9dHElkMpZVx1dIe0AqgPQxwikZjKXIEfskPUiD6sN4URaTSBWyTj/pMwjGmNIdohc3lNltAQGEJXdLzfd0u+Lb+e+uHP3CYyu1WUEZ4zeJOhMzmICtOyJ3Y47v51jIYZDpXmYMdnDyaIQkygUK+r6NytwXahpOkkBr7vR0IopjVHAYDIIZO5P/1K7dKgByDZOx4EepsvAbA2CuujBxzhH3j/YQPUk6ym+Tkmw9RZxCMC/iTfp+4me3pwO5WYBa7AAmyG3IRBJEtn7g0wEfahpE11tInqWnFrJzisUi/4hdGMJLn8AUPAFKJoUs0fzyyKFLmDj4rI/jblLXz237GX+WHgpI4eKnDQVVN7e82xJWr5jKOE7xYYsavlZ3KFn2XpGYPqgqWLg16cxGpUOamJ47m6OlWbIEzUPbXr3ObWQVrp8Lxw7qYRhnt6vYBux33KVpI0Mbu+HfjAUU8EbiqZiQIERJvcNoXENphe5HrAgldDH//tr1AixV6Db1c7XJG56KuhEJzTVfti5QHDzFwLAUIxLaeKiIOz50tVF/ponX9fEyVcFMkEouAiPwa9IiWrEFNuD2bvyQU/8ItSWmJC4DraVbMbY9IsS7YOjFeY9sOmYv9SVn4vn58IDG8oud0+vFta/JhAszvImGQuM0LYnBXtfueS2d9Lxv0ztpZj+RWv2OjXej7/sY1Fx5pUzVkKozZLVYY4Zp
 h00JVhiW
 tCziq6ANCwUw3KdqroJsNwOyeGgGbZ5nUWr/CnhjUMMWuJSJFdP13FjOuolLYauAotvNe6fdz/6xWbdNrVieOOkaY/Dlqx2yEf4f1QiMH51Xv13hz2Qo21Y9LOAHHXO7Sr/6khDdvkkXQo0b5W/e5F2w6i7RJ6PV02jjtSF+zo4ARKGg93jGteJFVg2uHhAK6mBj8rX+x3ZWraJRHYhKBoHYhoOqsGLht3uWJenR5O7JAuvMr7cZQmh5sAj2SxYtCYxurR49pRQdslQPF2Gg2JaxHZjP50T+ucR/3ElmVy5TjrTf/y1PRNYDJ6keEfv5C/mQzahcUXRMemWa9c4xM6dF6ZtXRYmGTrGglgv6/jW7ezNC4SG0/1vJL4uAqSrsEb0cZ
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
---
 Documentation/core-api/kho/concepts.rst       |  2 +-
 MAINTAINERS                                   |  2 +-
 init/Kconfig                                  |  2 ++
 kernel/Kconfig.kexec                          | 25 ----------------
 kernel/Makefile                               |  3 +-
 kernel/liveupdate/Kconfig                     | 30 +++++++++++++++++++
 kernel/liveupdate/Makefile                    |  4 +++
 kernel/{ => liveupdate}/kexec_handover.c      |  6 ++--
 .../{ => liveupdate}/kexec_handover_debug.c   |  0
 .../kexec_handover_internal.h                 |  0
 10 files changed, 42 insertions(+), 32 deletions(-)
 create mode 100644 kernel/liveupdate/Kconfig
 create mode 100644 kernel/liveupdate/Makefile
 rename kernel/{ => liveupdate}/kexec_handover.c (99%)
 rename kernel/{ => liveupdate}/kexec_handover_debug.c (100%)
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
index 49e8fc4a393e..c1c4291556aa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13777,7 +13777,7 @@ S:	Maintained
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
index 03c3aa6263d3..15632358bcf7 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -94,31 +94,6 @@ config KEXEC_JUMP
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
index f21d8c98d857..e83669841b8c 100644
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
@@ -82,8 +83,6 @@ obj-$(CONFIG_CRASH_DUMP_KUNIT_TEST) += crash_core_test.o
 obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_KEXEC_FILE) += kexec_file.o
 obj-$(CONFIG_KEXEC_ELF) += kexec_elf.o
-obj-$(CONFIG_KEXEC_HANDOVER) += kexec_handover.o
-obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS) += kexec_handover_debug.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup/
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
new file mode 100644
index 000000000000..522b9f74d605
--- /dev/null
+++ b/kernel/liveupdate/Kconfig
@@ -0,0 +1,30 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+menu "Live Update"
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
index 000000000000..9a702edc1dec
--- /dev/null
+++ b/kernel/liveupdate/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
+obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debug.o
diff --git a/kernel/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
similarity index 99%
rename from kernel/kexec_handover.c
rename to kernel/liveupdate/kexec_handover.c
index 902c30feae09..5da21f1510cc 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -24,8 +24,8 @@
  * KHO is tightly coupled with mm init and needs access to some of mm
  * internal APIs.
  */
-#include "../mm/internal.h"
-#include "kexec_internal.h"
+#include "../../mm/internal.h"
+#include "../kexec_internal.h"
 #include "kexec_handover_internal.h"
 
 #define KHO_FDT_COMPATIBLE "kho-v1"
@@ -1124,7 +1124,7 @@ static int __kho_finalize(void)
 	err |= fdt_finish_reservemap(root);
 	err |= fdt_begin_node(root, "");
 	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
-	/**
+	/*
 	 * Reserve the preserved-memory-map property in the root FDT, so
 	 * that all property definitions will precede subnodes created by
 	 * KHO callers.
diff --git a/kernel/kexec_handover_debug.c b/kernel/liveupdate/kexec_handover_debug.c
similarity index 100%
rename from kernel/kexec_handover_debug.c
rename to kernel/liveupdate/kexec_handover_debug.c
diff --git a/kernel/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
similarity index 100%
rename from kernel/kexec_handover_internal.h
rename to kernel/liveupdate/kexec_handover_internal.h
-- 
2.51.0.618.g983fd99d29-goog


