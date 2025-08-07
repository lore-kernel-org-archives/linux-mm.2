Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A76A1C87FCB
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D14A66B009F; Wed,  6 Aug 2025 21:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5566B00A0; Wed,  6 Aug 2025 21:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65C46B00A1; Wed,  6 Aug 2025 21:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A060C6B009F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 723CE1A082E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:03 +0000 (UTC)
X-FDA: 83748268086.13.10665E9
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id A2A47120004
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jS6kGiQX;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5YQfTLXaPrwDWqa20JnWXXwtihBOEt4q7FRxEsztbTE=;
	b=OJO6DNu5ybXPjWRTRQl2x2LRqq2iwGeLBqnQJ1WgPUOE2uGrENPIhg/3LO1mOuOwf7nWxU
	JWotQSTl9OWaMjw8wf1DDgSN7jUX0u57QB/LsDBTfsa+9RlaFAt7jy6UFo43LXz38f7A3o
	jh5pSpDpG9WtMFXTkt0IvL9l9ne2bfs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531101; a=rsa-sha256;
	cv=none;
	b=h74VhqyZj02Z0YoVUqWdtPDi3MDQqFSRmGQS7TGSoZio9Kx9wLaq/JBa1RRw+4ZjKLPKzo
	eXW9UcQQdeV7VTVbamzJpvZomBLGw++lu9Bv7ulhXrMlup6hkMz+UxQHwaGCWuH9xl9bPq
	W3NIBCBaspAS/s2oZyeOBfLwurHo+oM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jS6kGiQX;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-7077a1563b5so5302346d6.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531101; x=1755135901; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5YQfTLXaPrwDWqa20JnWXXwtihBOEt4q7FRxEsztbTE=;
        b=jS6kGiQXKJNyhHxA50iUGqaV0i3qXUHOZhXJtEQjZr1bbyX1lol3oXyS4Tf9uBmmZw
         Ujsy9M/uGaEASUhZoy+yNOZdqW8Ug3q45p5Aqb1QGrwRI9+Hhn/7xQL8KIxp9xNq5koW
         L4i+GmVgQBxWydyuQFp6tnZBQxWHc+MDq8eZ9tG1DqzSqgCEdwPCyXMf32kDOVgsGanW
         JGdYxlIbcRofbJk1XDo2fgs0kj6DAzK+F1KGj9SyeqFX9gosGHnrVWYLEgdf9LSWOFr7
         RJvHgXMKzFw/puZc9UkEMF2JkkpL+MzMdrf0lCPjNbReaQIYC88MZmEecnmCgvOEJvur
         wMaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531101; x=1755135901;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5YQfTLXaPrwDWqa20JnWXXwtihBOEt4q7FRxEsztbTE=;
        b=NiA7Ayh8k+f5NEG2GH6+seqw/OzXoOddXeJnBogLFIKru5nnRRBc6o8CGM67PSQkeJ
         EbyHWWCofmVpX9FYSNoMHwkZA2rdTi1K7Q8d1hMjXViZ26XrNOIhiMnyCADUkdoBmGFV
         TPmijo4sq9UK+kymq8nXSZwmJTCdD6bMDtK4xwmlZYgPNumZ1ygxVWRAUBWkswnU1qQh
         d4V/QVRrRDxt9tje/QjITRALlG3ABbbn8U3d5cPDBf0R4TQ4sBv3v2Dk2VtPTBl7alXa
         Pqn9HMJFGrKZCiW7CTnisGIMnJKMPTCABN8eHGvZf6MEZ+TPJJKYHCh1BJCRXoS3hXPB
         fwRQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/YfKikazMi9mIXRRKr2GokXh06DZIPytTaVZZ/xyD3Ec50nJ7u8xVFDkrHSzZWRfMxVJ7MLPxug==@kvack.org
X-Gm-Message-State: AOJu0Yzb3Ko0DP3bvfOosnluR9ORZqbBSRk2M77UZDnaNYSkc/hNyesF
	TDxsLYVzP8EOIsMUQVaXJma81MvDFkqhOzigGtCP/WGta4ugy2BHpr9AWsGo3cQE8ts=
X-Gm-Gg: ASbGncvxX3m4xoxPRooVyjvy/uVNMjjuF5jA83JTDti6pvZtlVVHPCKWFfvlP1+Cw3u
	jBK9MbnJ/Ii8cBUzWYn/S8s0DUgYs8s73tHRXnGMQxJQe8qEBYT/Si/arq6MTogy5jslUdSzdrq
	VOdoVTylv5ocmbc3RifLVsRMEQUoyBilpHl3xkZbqBq0WwU2Y2S2ZoZnp/+h3S+/y3zS7pRbjUJ
	KCo3JMiOrTHqNGfD5nNtBfXsdw1WgbMRN+2dZiF0v/nssyoaVYnhA3t0kgZWdspyTAo/pifMD16
	cj10QijKhvrNIn2+jiZZpBYjFjLW1uER3wFpm0FD5wkcs2OG9ppXWxynabxtG4PxliK0N0x+Y/e
	QsU+kV1FviDrchRjGZcADgpYESKX4ZcNRYNrZBnKwC0df4LUCRQUM/5PSNeud3w3VnB6rmxnnHV
	G/90IEPn5FhCNl
X-Google-Smtp-Source: AGHT+IHmmcvtRUPUdTTVwMopqE/V5cogsgxyMiffpH9sAyZ4atsq/VQ1CQZ07gsqifDfn1bW6xxifg==
X-Received: by 2002:a05:6214:40f:b0:704:f7d8:edfc with SMTP id 6a1803df08f44-7098a8639d6mr19787226d6.49.1754531100577;
        Wed, 06 Aug 2025 18:45:00 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:44:59 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com
Subject: [PATCH v3 09/30] liveupdate: kho: move to kernel/liveupdate
Date: Thu,  7 Aug 2025 01:44:15 +0000
Message-ID: <20250807014442.3829950-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A2A47120004
X-Stat-Signature: gp7bheqj9ni7cqst39ymi43hwzsznd8q
X-Rspam-User: 
X-HE-Tag: 1754531101-622782
X-HE-Meta: U2FsdGVkX1+wmw5eTlQp4pyDEhtcG26MzRchaNpgOWISTtuMVIaOUFIXdY4PO4LJdqz+8tmB6C+CsFTjw8+33OBJqxDVpDo48Da+3beYzQU7Ewak060izrWBMKKIdLiW/yYPrE80KQWHy22B98DuOUJMs59i5TWKZ26jSffFvmIqRRiuiDVkPMS2xwRQFxt0OQwjE3J2uES4ETfnfydgY4qGhCGoCzVNO0830MG1VmQaoDV0EKDO481l67Y71r+Vpvl/dXBV/PZ4lqtDwNE54FfEVRTD9PG64ixgWqEqer4NEsiDXJwL9bCCLpDMZYf/NZDjIGotM7RSUZfqB5GHCNFS9rd4VTUwT0AB+eToYdV1+Sd7if57GpIFNX13Miv6O1/z260+37rwzOB6NO+wNpDDcrZ1Q6rAatnDXk8bZ3GwxJxnqARomOX1x4DeAyMGc4HiiCoNJXhsg2ya4LsFG9WZS4owtuZCQXpuU1FxSNrcic65TBV26rsHaBe5VHcfSzOYda/Dl1bAz2aVUHx57R4Gk9ZTYAPz/A/ZD7eGeVCK6lRaXHX5v/MOvh5tkO/+dFlTbfgjHk2/VlJFgsycgLIdCU0xHohnG99LIy9CfeKyVp11P1HHtaN6/ToEKizFkBAL+VA93fzD7SOTNKA5Z/6N8FDKvcpYEO7WM3dr/wb7KSFGwRUcJ3AtwhunF6prBahTsX198oQTYKbqczUXsTB6lxAeXmhhKyW+goSIFODmx8bmZ292+BeDi/uVtlMtY8ftSkQAYU9iHe2gb7sk+jPOYQqsDTclh64OR6YXT4ULC9Guno586+blYFVeBdTtDeIZNaYBKdNd9wRw4lSUm2nHi3mxF6TkYV1mS18bEqOrhOnR1khJ42IxhZTMrJPKbMdIMskUsCEea4L4if6iHflKBAKGEHJakNQb8FHPSnHA5DJ1PRnNkCRemcYaE2oha4H3QcMnh/qub7R1BDP
 I1ORWRil
 EasIldNEP+NzrAgYte2miJ54p5RYshGIGAA03NFt7/afJ+sO8Jlxi9n/7uOEcDHI2KQOYB5lsLxk2RlDVoSMP8GV4F7cTdqbNP+xenshGISN+0/c9dsaLtynFtJhZzlna8kTuEAs0uBJ6nE7hr0U1FPA8Ec8OMC19iwhrQu/z8+BWPm/bYuYCSr+dqOujTeuhN9DJe2ZHd+px+Eb/FJV5PHhiXj/ZHeF1+7iVNbd9ahdBp1OOkMgO7OHYTvK1uXs2A4/LVbk+7IjZLZCse1ZCGUbvv1hpgDmF4p3Bnz9+JPlGCj+/a1xUKFnrYRreAlSXfziSm6PJkNslF/hgwMJQlS3jNOxDJyNAkKuMcgc2ebdfk65IHUhmOj7PDR7WHvBJpHreEWFDIMOncn8hRfWctWgzXE6rHRW5UE85gz5QDPTGg7bx6eFs8X0Dyn9Q3oFeXYV3fEdsdiHGWKA=
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
 kernel/liveupdate/Makefile                    |  7 +++++
 kernel/{ => liveupdate}/kexec_handover.c      |  6 ++--
 .../{ => liveupdate}/kexec_handover_debug.c   |  0
 .../kexec_handover_internal.h                 |  0
 10 files changed, 45 insertions(+), 32 deletions(-)
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
index ce0314af3bdf..35cf4f95ed46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13541,7 +13541,7 @@ S:	Maintained
 F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
-F:	kernel/kexec_handover*
+F:	kernel/liveupdate/kexec_handover*
 F:	tools/testing/selftests/kho/
 
 KEYS-ENCRYPTED
diff --git a/init/Kconfig b/init/Kconfig
index 836320251219..1c67a44b8deb 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2108,6 +2108,8 @@ config TRACEPOINTS
 
 source "kernel/Kconfig.kexec"
 
+source "kernel/liveupdate/Kconfig"
+
 endmenu		# General setup
 
 source "arch/Kconfig"
diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 9968d3d4dd17..b05f5018ed98 100644
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
-config KEXEC_HANDOVER_DEBUG
-	bool "kexec handover debug interface"
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
index bfca6dfe335a..da59db2676fb 100644
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
@@ -81,8 +82,6 @@ obj-$(CONFIG_CRASH_DM_CRYPT) += crash_dump_dm_crypt.o
 obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_KEXEC_FILE) += kexec_file.o
 obj-$(CONFIG_KEXEC_ELF) += kexec_elf.o
-obj-$(CONFIG_KEXEC_HANDOVER) += kexec_handover.o
-obj-$(CONFIG_KEXEC_HANDOVER_DEBUG) += kexec_handover_debug.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup/
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
new file mode 100644
index 000000000000..eebe564b385d
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
+config KEXEC_HANDOVER_DEBUG
+	bool "kexec handover debug interface"
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
index 000000000000..72cf7a8e6739
--- /dev/null
+++ b/kernel/liveupdate/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the linux kernel.
+#
+
+obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
+obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
diff --git a/kernel/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
similarity index 99%
rename from kernel/kexec_handover.c
rename to kernel/liveupdate/kexec_handover.c
index 07755184f44b..05f5694ea057 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -23,8 +23,8 @@
  * KHO is tightly coupled with mm init and needs access to some of mm
  * internal APIs.
  */
-#include "../mm/internal.h"
-#include "kexec_internal.h"
+#include "../../mm/internal.h"
+#include "../kexec_internal.h"
 #include "kexec_handover_internal.h"
 
 #define KHO_FDT_COMPATIBLE "kho-v1"
@@ -824,7 +824,7 @@ static int __kho_finalize(void)
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
2.50.1.565.gc32cd1483b-goog


