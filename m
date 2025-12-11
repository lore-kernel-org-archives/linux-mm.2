Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45961D41C33
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 12:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF70E6B0008; Thu, 11 Dec 2025 07:59:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA7C86B000A; Thu, 11 Dec 2025 07:59:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB926B000C; Thu, 11 Dec 2025 07:59:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4A66B0008
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:59:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53B5DC0158
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:59:38 +0000 (UTC)
X-FDA: 84207196836.03.EA69445
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 806D614000E
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:59:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=X+xFdLzQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3NsA6aQgKCPElfhlmTYTZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--smostafa.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3NsA6aQgKCPElfhlmTYTZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--smostafa.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765457976; a=rsa-sha256;
	cv=none;
	b=jXNw6XlNDW1rSgOAICwVqpVfFOTuUNArWPE6o+q9QujddVjEI7vpurQftISt8XP60WCii+
	hPJzZnZbFv5da7Wt6tDM9WXtzKHjxZTZXcxH9DgZZZa5eQqSZsD47mOPSV8nN0kzD4B4Yc
	0CXOtXVENtp7tqiBNMKYjlovlt9K79Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=X+xFdLzQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3NsA6aQgKCPElfhlmTYTZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--smostafa.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3NsA6aQgKCPElfhlmTYTZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765457976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r3J1hYN9XMEFmXD/a5v7i5culnnk0CIa5QUwHD0Ft2E=;
	b=qvFMiCGEYbgCaH6yZ7+IcuFodb75R2cnBD3/hECZlDZCo5PoHzVacmeJ/egWLn5MUQ/R9v
	d0e2fhWLIxFa9F6E1kVsulHxEbGGkAPbN4z5pFEApXJzShBG0sYbGNqBas2tPT2MPB43+5
	9KtOBLByP3mozq2zDcaBUfAzWs2Gc3o=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b7a43d7a1d7so5864566b.3
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 04:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765457975; x=1766062775; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r3J1hYN9XMEFmXD/a5v7i5culnnk0CIa5QUwHD0Ft2E=;
        b=X+xFdLzQmTMvXaeOVig6v2puJwLLF3mQqfGcfnBuyc4qVJdJ0tJyL/UoKjderogISi
         7O6hOk4A32U8VRhaOYz5f2lDCpRlIj55b6pJ9SzrhLAK+Ze0sPeodtp1NY035Z3Ly06X
         jxetRGYKe3NUV15lQlZozsd0+i4M0VDf9KSpSmz1rlah/ifMHgevMPrF9Qq2Ja5KyXju
         dWe3NykfHHAS/K67761pCl/zh2DgnA+CBQWIXaZIk69TU2haTpC2plOBCVYu5mfQhKq0
         18p2luGvQj+bZpHdk5PPYXKrGxNH7vEVXcKNhfUVOlUw0IrsZ2B2ZZOYqbvcXRAsM6ZU
         31zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765457975; x=1766062775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r3J1hYN9XMEFmXD/a5v7i5culnnk0CIa5QUwHD0Ft2E=;
        b=FoD7ovc13wxZdRNL/hf72dBTOG+Q/ULuoONQ59Afr9U5NvOl4z5QQ/uj4BZ0pGDgKi
         gNPKDAUYFXrkvIjzwkuSNfcxri66Y2bNNTVTbVWwGy4WYvdib8GPIx7bL8JGZI/+cosV
         BCcbxwMLUwxfOrw3CklEaqn3wj27ayLA475RW3xaqk2pWTduRRUrSH2/Ylzyn9VQOtxU
         ZH9X6aDoEzWwmYRxjjmFdQWizkJJW1UxlO1buGESbjPq/TK3myPqCxpjZilg2nbQD0EP
         sS4des40fTuj6dJBKbG/OEkw70aY6xaLQfA++jtGrFysx2YIvaMuWNwkyEEBP7mgXYIX
         hFqA==
X-Gm-Message-State: AOJu0YwYPlA2OlSQUuZZyLJAv9I5ocQA5mIwCn+y4x6izQRUTThF4ID1
	jPm7MWejE8KRW8EYM57XNoEeBjAO0E6SPzq62kpvS0xWCwz1KImhFYbdhi0uPHQn2s2oVHtkg8d
	xVP3+agvO6lbY8TVlGocryZ50K+W2DXXu353f65j+rS8b075f7w6pffpZxPyG/jIEBcBGndCCNF
	ftA1y9C0uKRJLsLApa53hviOzkd8kRE641JZrXpvjhwA==
X-Google-Smtp-Source: AGHT+IG4CAINMoRrbl1/Lgxz8kmNwjv/bmm/r66kW6sFrhYWMSR/59VpzDrRMyuM6uvP8I+JLx3Vv8a86mrk/g==
X-Received: from ejbuz10.prod.google.com ([2002:a17:907:118a:b0:b79:f583:7b35])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3c8e:b0:b4b:dd7e:65f2 with SMTP id a640c23a62f3a-b7ce823a835mr725575966b.5.1765457974933;
 Thu, 11 Dec 2025 04:59:34 -0800 (PST)
Date: Thu, 11 Dec 2025 12:59:25 +0000
In-Reply-To: <20251211125928.3258905-1-smostafa@google.com>
Mime-Version: 1.0
References: <20251211125928.3258905-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211125928.3258905-2-smostafa@google.com>
Subject: [PATCH v4 1/4] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 806D614000E
X-Stat-Signature: ohta8a8oqzsmrkd8hiqnzuwiteqbuc1d
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765457976-995352
X-HE-Meta: U2FsdGVkX1+8KKF5ZVPMGGSUAtNoWIhVu88eJ5YYwwI86+5dMIZysG4aY5A8TdabdWGnowpsfDkuIeP9OlKjCT1isoeASpsYQL6AUuDgotamYebG6w63NvHVi9VrpSsmy83bZ9H4pHBrGtuZJ+XibRXvQcfsTrXZoXws+5NgWKxJ/blwXeNsQyw0MmvMgQ8MwmCCjUZuztIf6q4s0UX1CeiOWn0Rp6rSpMpGrjtaKAV2HnlQadSlq1us9zwhlZHD9lSx7qJhvTjt+uZKKPepl/foLrj5rlWEIUJ7QJscLsNk014ndnsB65Ht8mKXZfGbWqk+e5TVeADRmGG41da6Iz1jXWkJrPVtmOEHZ/r8k715MLZMTEcQ1VqUCc8fN8tSZpsX8sH285k0T4SmIFqGpIFLS4L+dykkbogKjFEoH5i15OJ2zd+2zPSxyKpYOJmu2n5pUHkxMwn4zALIX9dTmUfOJGXzVYjDkav3rsLJNr2+CpHkpbb2UMy6QRPk5kf1TiGp6DSdYqv+4iuDbhTpojAWe+ztOx2U+kpxXCnV/C7+IG+0Lov1wxXk5zfDcjLnk4Kl+pqDcgClmLICPSzuo3R8VhjGJ4w6nLgQ3kQBvN1+X9t4tXIQbIgY429umMqlS39bo3Fv5CGdFCplSl2OC8bVaLSIaRRLyswWW1ef4XR2GC6Tea+BDlfp4QaJ1nXwt3O3k0nN+9Rd5snQXHl1lVO1ZmXjFos694dH0RC9pcU0+qSs+moDywSqO/5QScZjt7q0hETzZv1PBLZWi+GtzPOnlksjW26ONUZq8pcaibBx1RPTW9yzOC2tfdRO1Atvj4pC5EGQgNBdyCj3+dEwM7LMN1FSySwxKriT7xB3fSxBrA+75xPtxOSES4f0K+9tx4S4jJPWFV6IDqwjYjDvG7KXV1InnCEKiA7Xr6W1FySQQ0zI1sv1xlLhbED+1IZM7BTXslcBrUzZW7Mb5gH
 0g4LcuVB
 Ta5TZ5HIyUfdd0UqJnwPZem0oNonh1KMmABEV242GOxJF3zxXApGg8bYZVpvn1Mci1EsFWQpbawAa5BYEHx6W+uFXf7nuxJERHfaJXsfIqVOX58a6IF/Jvi7yLK5e/9HRk2XO2xErqyqQi5fUJTzik+d7c/aqwMyajk5umgXXsQouxCzf5C1p4N3d6LjLWZizuQlFf3Wm1OZ12J1NgghjhHhi+3r8+TJU5TsLxAebospQfLmWhqf9uB8ykR/aqN8BqSZQBc3LNm0rrZQ53uPpCMSCk9kTRj1sgapgVFUdSMW2r1DzSq4JgJ3keu6fIhyM9ISINaLQdbia7c675Ehq4/1Mv6K9nupxKbsRphhb4q32au8VmY6eZ4L/d5+1n/5G4mOQbY0l1qqk48guKaD+gvNhrv4uADv7Nuv20KNI3bXSNCMO6dzXKCwBrxPaZh+Ptzhy27m7S41f7iG00ui046nLKzqNDIeTlK7k5qjyc/NjgqxnlSA+oC9kgZ1YRKBDm0cLBkdjhUIhDBJaYIos/8CZtVRPfaDxPDVywmVkRHpWDVRaO4rGaf1Xou2AiiM8QflN0BjoZAk00hBN00PwJuS9+ljfhk0qa0ny
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new config IOMMU_DEBUG_PAGEALLOC, which registers new data to
page_ext.

This config will be used by the IOMMU API to track pages mapped in
the IOMMU to catch drivers trying to free kernel memory that they
still map in their domains, causing all types of memory corruption.

This behaviour is disabled by default and can be enabled using
kernel cmdline iommu.debug_pagealloc.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  9 ++++++
 drivers/iommu/Kconfig                         | 19 +++++++++++
 drivers/iommu/Makefile                        |  1 +
 drivers/iommu/iommu-debug-pagealloc.c         | 32 +++++++++++++++++++
 include/linux/iommu-debug-pagealloc.h         | 17 ++++++++++
 mm/page_ext.c                                 |  4 +++
 6 files changed, 82 insertions(+)
 create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
 create mode 100644 include/linux/iommu-debug-pagealloc.h

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a8d0afde7f85..d484d9d8d0a4 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2675,6 +2675,15 @@ Kernel parameters
 			1 - Bypass the IOMMU for DMA.
 			unset - Use value of CONFIG_IOMMU_DEFAULT_PASSTHROUGH.
 
+	iommu.debug_pagealloc=
+			[KNL,EARLY] When CONFIG_IOMMU_DEBUG_PAGEALLOC is set, this
+			parameter enables the feature at boot time. By default, it
+			is disabled and the system behaves the same way as a kernel
+			built without CONFIG_IOMMU_DEBUG_PAGEALLOC.
+			Format: { "0" | "1" }
+			0 - Sanitizer disabled.
+			1 - Sanitizer enabled, expect runtime overhead.
+
 	io7=		[HW] IO7 for Marvel-based Alpha systems
 			See comment before marvel_specify_io7 in
 			arch/alpha/kernel/core_marvel.c.
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 99095645134f..f86262b11416 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -384,6 +384,25 @@ config SPRD_IOMMU
 
 	  Say Y here if you want to use the multimedia devices listed above.
 
+config IOMMU_DEBUG_PAGEALLOC
+	bool "Debug IOMMU mappings against page allocations"
+	depends on DEBUG_PAGEALLOC && IOMMU_API && PAGE_EXTENSION
+	help
+	  This enables a consistency check between the kernel page allocator and
+	  the IOMMU subsystem. It verifies that pages being allocated or freed
+	  are not currently mapped in any IOMMU domain.
+
+	  This helps detect DMA use-after-free bugs where a driver frees a page
+	  but forgets to unmap it from the IOMMU, potentially allowing a device
+	  to overwrite memory that the kernel has repurposed.
+
+	  These checks are best-effort and may not detect all problems.
+
+	  Due to performance overhead, this feature is disabled by default.
+	  You must enable "iommu.debug_pagealloc" from the kernel command
+	  line to activate the runtime checks.
+
+	  If unsure, say N.
 endif # IOMMU_SUPPORT
 
 source "drivers/iommu/generic_pt/Kconfig"
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 8e8843316c4b..0275821f4ef9 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -36,3 +36,4 @@ obj-$(CONFIG_IOMMU_SVA) += iommu-sva.o
 obj-$(CONFIG_IOMMU_IOPF) += io-pgfault.o
 obj-$(CONFIG_SPRD_IOMMU) += sprd-iommu.o
 obj-$(CONFIG_APPLE_DART) += apple-dart.o
+obj-$(CONFIG_IOMMU_DEBUG_PAGEALLOC) += iommu-debug-pagealloc.o
diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
new file mode 100644
index 000000000000..4022e9af7f27
--- /dev/null
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 - Google Inc
+ * Author: Mostafa Saleh <smostafa@google.com>
+ * IOMMU API debug page alloc sanitizer
+ */
+#include <linux/atomic.h>
+#include <linux/iommu-debug-pagealloc.h>
+#include <linux/kernel.h>
+#include <linux/page_ext.h>
+
+static bool needed;
+
+struct iommu_debug_metadata {
+	atomic_t ref;
+};
+
+static __init bool need_iommu_debug(void)
+{
+	return needed;
+}
+
+struct page_ext_operations page_iommu_debug_ops = {
+	.size = sizeof(struct iommu_debug_metadata),
+	.need = need_iommu_debug,
+};
+
+static int __init iommu_debug_pagealloc(char *str)
+{
+	return kstrtobool(str, &needed);
+}
+early_param("iommu.debug_pagealloc", iommu_debug_pagealloc);
diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-debug-pagealloc.h
new file mode 100644
index 000000000000..83e64d70bf6c
--- /dev/null
+++ b/include/linux/iommu-debug-pagealloc.h
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 - Google Inc
+ * Author: Mostafa Saleh <smostafa@google.com>
+ * IOMMU API debug page alloc sanitizer
+ */
+
+#ifndef __LINUX_IOMMU_DEBUG_PAGEALLOC_H
+#define __LINUX_IOMMU_DEBUG_PAGEALLOC_H
+
+#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
+
+extern struct page_ext_operations page_iommu_debug_ops;
+
+#endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
+
+#endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */
diff --git a/mm/page_ext.c b/mm/page_ext.c
index d7396a8970e5..297e4cd8ce90 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -11,6 +11,7 @@
 #include <linux/page_table_check.h>
 #include <linux/rcupdate.h>
 #include <linux/pgalloc_tag.h>
+#include <linux/iommu-debug-pagealloc.h>
 
 /*
  * struct page extension
@@ -89,6 +90,9 @@ static struct page_ext_operations *page_ext_ops[] __initdata = {
 #ifdef CONFIG_PAGE_TABLE_CHECK
 	&page_table_check_ops,
 #endif
+#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
+	&page_iommu_debug_ops,
+#endif
 };
 
 unsigned long page_ext_size;
-- 
2.52.0.223.gf5cc29aaa4-goog


