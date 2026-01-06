Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B80E3CE9D78
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 16:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 886806B008A; Tue,  6 Jan 2026 11:22:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823E56B0093; Tue,  6 Jan 2026 11:22:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67BC56B0096; Tue,  6 Jan 2026 11:22:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4686B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:22:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1FB3B97C8
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:22:12 +0000 (UTC)
X-FDA: 84302056104.19.C782CB4
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 324994000D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:22:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BEzKw51r;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3sTZdaQgKCOQYSUYZGLGMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3sTZdaQgKCOQYSUYZGLGMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--smostafa.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767716531; a=rsa-sha256;
	cv=none;
	b=mC0/UcdnYjTc4eIezqiiwHC9Y0pjfiJflMyhgSRlWQp27WRh3kxQzRj0Y5JMZ/OOAqGYlZ
	AuzwuydqID9Tb/Iv5NKz2KYvsnHDwbGz3d4gk2Bx6QxBKvWxsqOBycGdE/HRXmTau1CHe0
	MEaAej2QJYP1TTtVBsPaHdKPu60kvUo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BEzKw51r;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3sTZdaQgKCOQYSUYZGLGMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3sTZdaQgKCOQYSUYZGLGMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767716531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k9TPIl5VuYcR9KDL0KJbwZbu6JBkLY0yTLIq8XhKmr0=;
	b=dH4xsEcJkiqHECDTn9DRMqIFj3VvD9+Mj33U7eKGVYP1yG6zYBFj8qhQoHOSAL4iVDstak
	CxCRw0fQ3A1ZILOVuoDrmQkniy1BXiU/EJgNicn020mcokxO7LCNfze4tUuwEKkJ+pHHFK
	AEEz0754XOQ7Xr9oOUJx61hqZLNdyYk=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477cf25ceccso10513145e9.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 08:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767716530; x=1768321330; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k9TPIl5VuYcR9KDL0KJbwZbu6JBkLY0yTLIq8XhKmr0=;
        b=BEzKw51rcgzjtxTKe1d8DfDCGE5hQi9mIxCZkMu2AqcrXaJUL7iwJvf2zWtiU0cnn6
         IjcuG8hUVVXSTh8uEJFQjiSDIYL7X6749kMri8UoWHII2JWDhx0NZE8iAa3Za890BR3/
         0+Yl4xMykBEgrHUJYLH2DYqCR61E+iGPn1oSzJWo6Cltq0qY7yN1UhL7MD1yWeIIedaR
         9At6o9K+OuXm4wJn5Hvdhqdzk/a1tv2HB6HY5mvSH8VFiIxVnREQlVgbq0j8uifn80Ft
         oNDQIvoXU1CHp0wZQjaGWLWERVlgtdCoUus0hcLXgx3WzVQ+JojUFjr4yS/9tJAcd/W/
         VdKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767716530; x=1768321330;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k9TPIl5VuYcR9KDL0KJbwZbu6JBkLY0yTLIq8XhKmr0=;
        b=WOVrx//38JvUea5N+Bfa+5aWKc+NQN8DJ9SmJeq3wcVB2U0wtG9pd7Y+J5AjZJYkc8
         T1jKI6gSf+yiPEvMueZQB0WSZr4a9/L+P9TL6yEt8fw0yw6d7ApUUIV0IeLGzEko0s5G
         AYSLNVzbTl7AK4QvFmftbqMwHhEDnsarIndIGOAhvF92rxWnUp1PYR1g7X20dJE/ePnJ
         1Thx70DeiYA2pZHNNK21tq25Z5M6ids1owcafwqkMUolYXligpZx7khfRfVCnmCBCjsH
         8bBmACR7gwM39XHMlWzRJfgsyjk0cshywh0yKcwLiC9r8pJIaeHdNGH54NXzFrErANf8
         9iuw==
X-Gm-Message-State: AOJu0Ywti0jnKhuTEPrdhUca+oKH/I6Lp0D71rw75MgYxP/ObKOv/v/P
	M8hyRVyTqToPcpoeIiCu8GvBER3mgdiJv8NWuPpfoOsBlCoQXg9o06xl0DkmK+Z0z7WjGBeV6uI
	aFTgkS2muiIzsQPbYXWhG4gK0BngOlfYMsXwM27Yy5RgCtLj1bfnVUQvsGvjkfJ1C4oxWK39D9T
	Gf4hRnARE2PNc7wEhKrMSqNnUkBIvmnbed2jGhbac5hw==
X-Google-Smtp-Source: AGHT+IFy+i8fGxYLo74/Wl639U0q0FjjftONRR0904KN3ei1M9EQzH8E63Sfx40UzVwd8PoZyzK8Jn+ZRZaEZQ==
X-Received: from wmot12.prod.google.com ([2002:a05:600c:450c:b0:46f:b153:bfb7])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4705:b0:47d:403e:9cd5 with SMTP id 5b1f17b1804b1-47d7f06feaemr35634635e9.11.1767716529607;
 Tue, 06 Jan 2026 08:22:09 -0800 (PST)
Date: Tue,  6 Jan 2026 16:21:57 +0000
In-Reply-To: <20260106162200.2223655-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260106162200.2223655-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106162200.2223655-2-smostafa@google.com>
Subject: [PATCH v5 1/4] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
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
X-Rspamd-Queue-Id: 324994000D
X-Stat-Signature: t631x86b5gkzgscfnum78tnuiub9uww7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767716530-91225
X-HE-Meta: U2FsdGVkX1/oQ+E+hpgkP9latkwqpZvSnKkwgrCVz2IF7ZMzU6WMJiiY1Bd72CbX+eW/QHQtzVSnhwSa8p/JJclttMwADadWLYDGDTDCuHgJJ1KI76yhr0DHoazZTQV2BDs5hSnTv4vl9yLAue7bJYWNULT3RK5YWFNJ+ClHsZLB7++yoFOKG1kFzFH9pkpO9gKelzjloj2qUcefvzUJZJkv5nFEUsl/oTKo9LyDFOzQGwZ/5jZ8miRn4OyIPazFwxA15NzHzDfNZ2FolrwXJhgwnhrmhRsZ2OEqqM3KJQ2+WZmxomGCivSuUrYudVScb+AB64AMMySiSVGlYmQOdhipf4+ExH3N+OPdqOBbK4C2AtfH5UB070wDS3/l7Op2svtr3KjDvzFMgCQjfK+CqxrFKMfZLsxisHRmcXisHHiZ1VSQc9v2raB75a8VmDrcJfSCsbNaWAj8Hfc5ytK088c/iuGGgwg7CgMy5cCgyj0ujZ6LkAbPfAEZr9BXWzlNhTB8AV99U5iYZHQWBoAtbGtlopTX4TdITsDxuUCVDoJiA7HWVsfWFBZyl99JD2h2Phy6ti3Yr+KpQE3GSLl8vXgYceM80ctGlhk1T9SJ4b4TaK0l6kh3puJlL3CJCQmtRbZRza5rK3OgFKFU8kZjQjeOhtJua/HoGvjxGwQTVwfG64aR7j6G+0UBrNTdnnwa37nGXLKwe17Wo+NpSLD+Nt94sx+5+FbC/o8Q22pbd/nrEH3tY46jcqaZLDa/vCCwBCQKTicd5OhueimNljKzYiZHg5C2J53Q2MJYfKR3upE8JpwVlyw7U2OxWrMJUmQW+fwjoDcHmSVnjQDm/lHaunVWjZwTH5mEwqHxPsyqvSe1QfKZdRZyR/mAjVA4fPbKtecyORSzzeLkacR0BjfBMJc0o5O5gR+NN3LXHUR4VJwA3VtIPeUbjoodb+9mI+pmjaztpeqUNcBNfs8N0C7
 2YIBov8C
 pn21jO2AhDhZF9GGbAbiNlYPlCPAsLA0F9RDBqHCUhX8YvFDFNLF/8c7xWKkWpuof90auisj0CSLhO0U0Mr6BbRzaG+aGtqJskWu72vco6Jw6cOr3m1WRVdj+Bek3takdltFoPYNDdTg98Tw3ZVDZUJ6gmmMvPADibaT9IEhHjSZuC3eSHnrxHD9zvOBWL8IUn+YzbrdeiHvfd4vgE1ZAvpDuacGbsPV0SkTSe6s6eAjXJ65iWvijdFJukp9JkBGkUF8qrwKMULIDihgge7UKiWMQQOYzG2X3XK7O12bBRatnEsILRSWUpgyPZelZ4Ab57ay+
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

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
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
2.52.0.351.gbe84eed79e-goog


