Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9171FCCD193
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 17:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A73A8E000D; Sat, 18 Oct 2025 13:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 830198E0002; Sat, 18 Oct 2025 13:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AAAA8E000D; Sat, 18 Oct 2025 13:18:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 485398E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 13:18:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE31BC0398
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:08 +0000 (UTC)
X-FDA: 84011893056.29.2A35C04
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2B11514000D
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="islz/wnk";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760807887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v0KGeztv4ESSWdWBh1iCylNw/kUGS87Mw2BS9HYjfV8=;
	b=aIgJUbE0xlUPFtw3Gl4nralbWSCM7TU7b8cleH0gYkAq+pSmlcW7yBP90b2alT9kueY9j9
	K0lc9Q8bK3e9bBS2ZOH4qnKh+mM/OyL1qgNvnseKRWeb6yVi8MRELCxOfzwAb8MgE5/5ZP
	3lRx90myfiYwK7yZZSW+gJg+M0ajnRg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760807887; a=rsa-sha256;
	cv=none;
	b=lKos7G7XK9LsS2TLvpTaRX8kW++7WErxCG+ZV2tBwc/IPmvj34/iSo33OU4SL4U7yWe4uf
	m7cL90Yfc2rzsdzqKGqSyiiwW8AvI7XbctN5JpXHVEtBnqVks25pmzBU18PTPWPmyoLNrL
	2+KAKTenP8H60xAzwJ1ZLSiOnOs9yhE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="islz/wnk";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-87c1a760df5so58506736d6.1
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 10:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760807886; x=1761412686; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v0KGeztv4ESSWdWBh1iCylNw/kUGS87Mw2BS9HYjfV8=;
        b=islz/wnk7yuUE3uhvgczKNv7+M0pGcSoQIvM92zVbe0lMKvnNDhMR/qriGsCpc+n1s
         MFbmEyvuFaqSO4E/GXN/d6G5Xvtetptuaj1JG3jfk6aAGJfNVYIShFzPIU9LCYYEUrut
         OiuFK6DQFIbthAHSCjxDKxej/YuUByZffk0/jss9yEnyDIGzlWSflaK9JX6hiRLvtaF4
         pSFEKW6V8xo2h3VT/y5pUgR+mXugJZnf5ufb4exsb7QR3o1bSLYfeOsP006C5+HyGXp3
         Y63xKBTjOvGrqhRgOHY6tETeZCw2+54EyUbm287yo0LgpgmDnHGAept8Vv1yaNijw+GI
         elsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760807886; x=1761412686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v0KGeztv4ESSWdWBh1iCylNw/kUGS87Mw2BS9HYjfV8=;
        b=Ab0y9XaGX2VRrxkeq2Un6Y4aGGV1Ptmrc6z/PclVWug9MpLHUuiwwzaSxvJMcOCNGj
         +QR9JFTeldJy+iRzU5Q3sJzY3rUooO/OmJAuyLqsLvkEh0MVpg5r9ZOkhV6bEpcvU2tg
         fG34o1wSo/R89+9yAFB6f3Xn7E4G+SZbl4xMWwwhSkXNihQY3Uo0xJx40fUIO0ZSomSe
         TDm1Vh/9vjggiifCUmXzk5sHlXEtkVxWPKIIFEacsrX/hCpVGB7HbeLMlnD84nirU+qW
         DZE+9HFJrkgj3NKCAPP7OUzbVozOA8PDCUqsJ7c8bz9ElvQhenTNaQ1XaGMNwrN4JTfS
         ucgA==
X-Forwarded-Encrypted: i=1; AJvYcCUnSZ9mTTNJyYJVlN0f1qNGGObSxdBAp/cl5wY6AvY5ryIOlP7YLMwitclj3Sae1tkm+ZvflVh3KQ==@kvack.org
X-Gm-Message-State: AOJu0YyzylqpwN82GaU+/hJRilLBY/DihJPy+rqfpI7bZmUOPMcZnOwu
	Ko427iq60OWkFbkp2GP6ei63ULQQdNmThibkSrbs3WtIH3o/q2JB556Q9Fy+obd4L5g=
X-Gm-Gg: ASbGncsmKA1a+SsoThnGG78HyBwUaRnbP9wYDonSiTjdrJZipircLUCWm1GHeLNfSAB
	R+N2JXtJJh7eaXNateGibe8gh2uPMDjb9wvhcjN64TjTJWMHZ26TBmPdtXKWl2aEXfflyXO0GqU
	NW5uJjPdHYXQtMDZW1FBtmhYOeaU78pQ3jy39j9WTMVceaf6ZQO4AtODrSLKsexkeLxA3qYkfPL
	Y3jnbMFwgHS5AocoJGAxLO8H13yjA2fZNUm3EiuPS8Y6hIteaC0l/r2mrIQ0O6EtNAevRVvTLPK
	y5LHSgmI577SJInaBFRB4bwMURBmD2FEp6U35AGrK8yCswftiIzSVhVwpeaKYx7rr2wl1cc+lTS
	MiNS4BHk099Nej/UqUOzsY21vQC1IunEn6b2AQCpnTF/y+KxXYc2jKTEcmARJMQYjDGkFiF9f1B
	YIrXuUQRSHQvgewhppw0XpgztolfJf+ZCOMcjHWRRC6YQ4Bx6r753Y4m+fV1F2duqMTglVc78Hu
	O3WkWAXRl5nOjcd0/Rn6RXWtx4HrWX+KrzgyU9roJw=
X-Google-Smtp-Source: AGHT+IErd3wQdsBbdwbR5WTIdnOJzNl17T2SsFZBA1bPXFw2Ejn8Q8idBkGg/OwcTd1BnjUf8btzoQ==
X-Received: by 2002:ad4:5ecb:0:b0:710:9995:ced4 with SMTP id 6a1803df08f44-87c2057f40amr111039536d6.17.1760807886240;
        Sat, 18 Oct 2025 10:18:06 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d02d8e909sm18478116d6.62.2025.10.18.10.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 10:18:05 -0700 (PDT)
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
	jasonmiu@google.com,
	dmatlack@google.com,
	skhawaja@google.com
Subject: [PATCH v6 06/10] liveupdate: kho: move to kernel/liveupdate
Date: Sat, 18 Oct 2025 13:17:52 -0400
Message-ID: <20251018171756.1724191-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
In-Reply-To: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B11514000D
X-Rspamd-Server: rspam02
X-Stat-Signature: rfge3aybnkxzqxneqzdfoxiiwe3zttyd
X-HE-Tag: 1760807887-465370
X-HE-Meta: U2FsdGVkX1++MQ1TM0/Gy4UpdUEGpFq9+MOSvUX5Hs+1U70bfLzz9rP9/V4Z3HXcwBYMO/nMkoIHF2yb2xEnIn9F8bpXYysR1rWjeLe1hY1LNDW/UdUXrU/lXg0ylZ/ZECq98IJFkLOVVFq5WpBwZqO3Lt+iBShE0uZJHP0lxao2GD+9hAv5NMoEP0oeSEBFZN5uCny8rBwzf339isaKmVYsC4oWnsDySXUSyTeZHuY+C+8bbbkWU6Hqz8llS2hldOZIMY2zozDfC8Cg1Kft9U9aY0zToNcE3eM7Mk2viYWkUVXSO0isrvUutNaXIpArJ5eCCdn38g/Iq31iGrnD6q9JvOdGw3C4tAeC+JSps9K6TxxoqqdHNocirFV9AOWvBJZOR0sfpPhPvVdxZoH9+GpXC3kjHC0pGw+S0JHawEHTyZO0Rh2vRzoDStzrC7wBDycnQVCRkW1Qi3kMDbPipVyNxzrHNiQ2s6wZOHmFpS7aLDJf6pX3kfKon17LD1GeocmRacZbjxWeEdlh5MBdokWjHVIQP9sOpDJCPqIXPo+mugfctyUTK0Q2j9MR2eGVKNfyealjnWUCGiBJhFMnmokm3PMzD8NvIPW2/hx0kEZzgvHxO/YRx/onL45SYSDzu4Fvs2J5HQLAbJ8izqewXYRdPIl3jmUZetoJ4cn5QbNEcZJG5aUdqJdnrXWcCRzoFXgCFLY77FB+HrsMHBpexh/wb+D6sWiBi3Ue20mlDN2iVIlhFfDgYB+aWlZ4F7HqJLwwB+TO9b2Rfa5vTwouK+VpMYVq7872MEPyavzlrJEmZ0jwFgyvJybs3P6eAxygqpv0OwHySjP6Tau3Gp6KA6ijFXz6H45W7FHi86x1TyeKsuclbbAbf/Rk6/eL/+JZDnD2nrc5JrqDBcIbaRnpS0i7S25M0y9r9mYPr4Q8Yhxc34vk8lKAjs1l9V0HK9mDzgF6qYfGeV/aW+ay/U1
 91l8Dm5H
 k446dTMj3s1Sx2+aOJKlWNm6GF/oYBbyTSyGJSRDRf80HGJ+U2opbCLR//LwLLZV97v8GJqbin8S9g2d46TbghmaxUcXAEP+TJmGOxdbW9PjHMJrtPO7MJDkfBJUsy7BA9OQ+c34iSDCTmuaUvphh5LsWly+1w5HKexNnrFMH8PMiXwSniWoJ/u7vzIxc4ECBwWE29daP/tf7+SRk8aeQRmwQZWI9hVcUC6Nz3S7ERKIH24zU5y9N/jlR3pG1cSyFTLCbQ89w0YitEw2trM9pso7I29S527TsQC2J3jUo4N2m3Zk2msYDgMEvB66WR0asJwTG/BYyFBKahClGjmZ5014Ol1eyn1V982S9m69/sHYQWYkmXUMiDdnVVA==
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
 init/Kconfig                                  |  2 ++
 kernel/Kconfig.kexec                          | 25 ----------------
 kernel/Makefile                               |  3 +-
 kernel/liveupdate/Kconfig                     | 30 +++++++++++++++++++
 kernel/liveupdate/Makefile                    |  4 +++
 kernel/{ => liveupdate}/kexec_handover.c      |  6 ++--
 .../{ => liveupdate}/kexec_handover_debugfs.c |  0
 .../kexec_handover_internal.h                 |  0
 10 files changed, 42 insertions(+), 32 deletions(-)
 create mode 100644 kernel/liveupdate/Kconfig
 create mode 100644 kernel/liveupdate/Makefile
 rename kernel/{ => liveupdate}/kexec_handover.c (99%)
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
index 54f627a639b1..0e7fa104422c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13782,7 +13782,7 @@ S:	Maintained
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
index 06bfe691439b..e83669841b8c 100644
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
-obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS) += kexec_handover_debugfs.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup/
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
new file mode 100644
index 000000000000..cea287842475
--- /dev/null
+++ b/kernel/liveupdate/Kconfig
@@ -0,0 +1,30 @@
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
index 000000000000..fcdf163b4b0e
--- /dev/null
+++ b/kernel/liveupdate/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
+obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
diff --git a/kernel/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
similarity index 99%
rename from kernel/kexec_handover.c
rename to kernel/liveupdate/kexec_handover.c
index 89a8f839346b..c87d00c40c82 100644
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


