Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BCC8CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 00:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EDE28E000F; Tue, 21 Oct 2025 20:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5D18E0002; Tue, 21 Oct 2025 20:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DC808E000F; Tue, 21 Oct 2025 20:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F08698E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:57:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B34781406B8
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:57:29 +0000 (UTC)
X-FDA: 84023937018.29.8534042
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id D2042120005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:57:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dirQn5wk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761094647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mkf+L3c0j3AWYDNtEMZGYy1f4Qen54RZIiHrdIXZ3Iw=;
	b=MRpt6nenGE8og1NaUjNtI0gxBq/ljQc9CLnl4EZv05EF2fCfBCtM3GmM+/ASWBYkueP0Yh
	SbudeqexhJjD4KSHKP5/Vip8vsje8mal/t8ZxXxZC2ipuWfYMghfAYEX4/YusNA0b/R09E
	kjJjs/2+s7dA0FMEcYIpeFn1IeO2SgQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761094647; a=rsa-sha256;
	cv=none;
	b=QoamX6QC3bQP1JkoKp71MnVcc7nEkyEyPGKuIyN0ENYMJlmfyGj33jGeEFhIoEjWsNGpO5
	vbZ4cBnTlwmKIKGOw6KXVnl2vMkwxgagF/hA9SgHBrFD/pC+t0vjQ7etcT7zYJEbyw8zIk
	5t0zlx+gDbmbUvX9TOhbUd496ABF7DQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dirQn5wk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4e88cacc5d9so4612791cf.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761094647; x=1761699447; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mkf+L3c0j3AWYDNtEMZGYy1f4Qen54RZIiHrdIXZ3Iw=;
        b=dirQn5wk20hsqF3QbLLZ8H6kLvgvqAFsQZmxTRoCrF5bZS+m0diJadk5qqR8DY9wqL
         IjSWnUYbd1S6joV65CH5lpn/cOWjHkZgOjc80iWu1AzfzD6+g8bV7ltlh6Q5CjRs168z
         8yhY4KsyEUNKKe+ng6l92v0tA7aPIJikcIhTIfypxxWkBVtcvx1PDB1FnNV9+ufAkhBu
         CGNWGwP8G8Zoz9rZidao8wYChDODnVrVtf5rEMvx6I4ph2kScZzUogRN8lnx8C1sjDsL
         pHTLKaBYQotQSv2jvIgiWSDNMwYajCZ3p4f9xTPlpTU6SVgxKn+qU82KVdWSrUKMNt+0
         FckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761094647; x=1761699447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mkf+L3c0j3AWYDNtEMZGYy1f4Qen54RZIiHrdIXZ3Iw=;
        b=cy3clFXQIbMjgvmHpQGbWhJhNqj/G/cCFvgWH96kMKViimzUbX9SxSy60f4L2nvXDT
         Q+QDH/JEWlv6Bt5O6+fmqgpi3lHCadfvCI/vHCOmbysi1/gmPvc92MxH3EO0d+HBV38o
         qzdtm66OuXv+Dyn0a8BuyoxjZM1iB4Piz5OmqpIIVhZffpRZygIDuKshgAJB8YLgxrr0
         7ck2/WsA/BSMQJrOdnb8AqHlo7RSAWcIynukvCPcafP/+6Rc0n87J2EBLSJIxtVntGvU
         nAq+LkBeeuxkniRnDBzlSd5KIXxfpc9aGf6ro8zsUp8j+56KQ34124Y1QQ/7xSlU6Rgi
         Uumg==
X-Forwarded-Encrypted: i=1; AJvYcCWGumsaZZuC6chSmQuRUBOoPIZv3GVKXF2xfT2v++ED82mdxZhbDvgKxlbS0miYhBTVE7RmKDTTiA==@kvack.org
X-Gm-Message-State: AOJu0Yw2h6DN52ZNfLeOpktqFoJXiIIqHDnh6RzwrV/DJ9KU9v9la8e3
	W5Ig6MQXY6UI9HNvMYmumKEZxDDbtSDCmKOOOixmJRMXudXTSkcC7QjkHy4H4U6WGEg=
X-Gm-Gg: ASbGncuNw8cHxYqo7/V1Hvvs+cLqrsatjrYt2uiJ0ZstYPSYB8W3LVTqmIUW4ZjSq4m
	e/9xGsYpITv0NvtA8t/i+dqE610JgN4SEd7PLuiXXHPjsHYya0ZHHqxBCsEQMRozPJmTKquPwO6
	/lMaA2nqu4BhCe27dJg63NzlI+AlmsGPVqzLvJ01tMqQw2dl5lOxHoyLxXq5EXscoGAHKZOqTkH
	uzCLFpach6UMVt5+vF4N3O5laHAYqiTnhvVUdmU/n5d8yDELLrZOA/hpovmpKA+lAuiH2WqR8ol
	ekIgxYZHGYx2oW78BrDT+pBH8Mmoq42n5rRiuSR3Aqim7YUAtBNlsV13qVgBTk9hLcE2pZtOVmK
	qsFbW+a9+Y3O4/Qv5z1xO/q3J9vS73GBXA7BttP7jAAqRmEsAoVDbCTQl4WxXu5Bcnoe2HcrWOZ
	w6RSpQ3KmDW02sXTAmEiMmDzseUDkSt4b+b/xKVn7z8V+fHXnWiaAbgvL3i0RO+hLLV2JYctYba
	Z5SrZzhvUZDZGcX9tHnaajDv8qlxpo0
X-Google-Smtp-Source: AGHT+IEq405mhVu8WrJEowIq1Y0TON8S9urCYucYQMKi2jjKbXRB8hoU3h4s0GEYArtyzYzgjkDVKw==
X-Received: by 2002:ac8:57c2:0:b0:4b5:f6c5:cfc with SMTP id d75a77b69052e-4e89d274b1dmr235263421cf.19.1761094646848;
        Tue, 21 Oct 2025 17:57:26 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e8aaf3432dsm84169501cf.2.2025.10.21.17.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 17:57:26 -0700 (PDT)
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
Subject: [PATCHv7 6/7] liveupdate: kho: move to kernel/liveupdate
Date: Tue, 21 Oct 2025 20:57:18 -0400
Message-ID: <20251022005719.3670224-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
In-Reply-To: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: thbmn4jii8wiihwrqmi88yf4thrr1r93
X-Rspam-User: 
X-Rspamd-Queue-Id: D2042120005
X-HE-Tag: 1761094647-935747
X-HE-Meta: U2FsdGVkX18OAPSk0uHhfIzZfwjL2QbdURgqFqQilTEIU9PS2zXM0P7MPQ74EOJ6Iy8Iaa8XNvNC9tPTbaij6W881Kx38eDBoUN7tTsYClSaAYHv0+6HTZoRI1ikm+JzQvv3T7LXCOsQz0CBDQtcPRvFUEkUKiZGRv335K2TrpyuS79gNeJoTbUwMDM3ycm1/+fxdMFbZBWDtffJqrmpEGiNCNQVH71dxgO/YtliKdH3gKM+hfcwyWtYhs538pbvU/XbUYKT+iI8zutLJCi4ifNcAWj2vlAqV2NzxscvUuUMM3cP2HQzq6qndJO3JbYpX+4oT1D8bGRV5p1XB/T/UQs13hY/Y//ChlXrSSttwxdDBsrMva7x4eK3lTlDtS/DCEZFC8KFFtPt7ogT0X9vouv9QoixVMssm+nK2fKvbrFfIOKhWaJ2fEGP3jiVe4IBxHCfvpgyWLlTsYjoVkeGi/Lq5ZrJjdf6ggvu+wGotwFs+8RGEPeqnWWXLPLOpv65To+Z0T0j6o3KUIkyKBvqYs8fzu6Cv4Eu+KG+ml2JPTxaZRqZO7vUx5Wo2R5Jjr+hxuJIA0YfeYv9BQhygpiCGtGxR+BhUH/tJwlsGW29tNcQouJz2RQctiLuTKq9AdscP8rmS+sv7Z0370QtfcmOmjxFzatiK6GEygPgQrhRLqYV1L8kDoi9k5oXa7Vuqpmi7Ch6OJz2+6XZN8eMTgGLz3DXvJM+NEcLWasvfm5i0z1/vSa3Mlmj1VyL+LdXBkujkLiuEgLj2kIPMhu1ZjhZND8Dz/XArExmdw4r904NgwcxxDaniAUUj56rVi84M019BE5wPjuEC8Hn4PeRKd4ZhMRYDvLoEuKCibW0gHVz0eoUkGGITtIckSiJwWnfYwthDBSfEvNtMsPKxPWWALMfUxImiAPVA35ar+Z/uOmMjXP682xMrc7pJPeq4gnZ6r6Vmq5GlobfnaWlJ18sY+h
 W5cA8f84
 Fd+uaSg/5dCLcIms7C1ydScj+34YtlILEILx8z+0AH7CTcBaDTsgotK0zE+Rkh+4bLUBnXhjpjIDC3JXwxjjm19bKGHV1JeSvi5FbZ3GSn74wXSm3Qnp8a3gMMcOw7w/nVozcD6cmiSHxSEjyXIxkckT572eeoYzhoSKeNvzJZUtS04jgybVzoYys5+ixWS0xRAUI96sAV/GQDCtak3wueAn0k8nW88rbNJjfyTacsxB6pxdUexpHakjmGzBkgPWmlKzS+Qte8YOelb9GkIW1sea7YUzcFRRtmc563RdVybSfKt5X9AIUE2V+e2pBWpdgabBkdZanfyTUAZ4zlNBhD0bfcg==
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
index 0a6ba2717caa..eae55bb6ab4d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13781,7 +13781,7 @@ S:	Maintained
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
index 89a3fa89db0a..a1b97cc37cea 100644
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
2.51.0.915.g61a8936c21-goog


