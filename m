Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C147CFD352
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 20:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C29E6B00A3; Mon, 24 Nov 2025 15:08:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999F86B00A6; Mon, 24 Nov 2025 15:08:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 888DD6B00AA; Mon, 24 Nov 2025 15:08:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 77B6A6B00A3
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:08:22 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E00889B1C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:08:22 +0000 (UTC)
X-FDA: 84146587644.13.871F368
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf30.hostedemail.com (Postfix) with ESMTP id 53FF480009
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:08:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jzF4WKdQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3MrskaQgKCIs71378pupv33v0t.r310x29C-11zAprz.36v@flex--smostafa.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3MrskaQgKCIs71378pupv33v0t.r310x29C-11zAprz.36v@flex--smostafa.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764014900; a=rsa-sha256;
	cv=none;
	b=tPtPXXVC7OGjKe0ST8+Q/ClvT8iquwokDP/LcvcZc/6YKv5KV2WWssAKMzhIOpctGBkiCO
	Gndgp+AHFWtFVTUUtQhWSA0Aew+LIjQy02fPaYgFJd7XhVkAVsCPXrIx9y6zZC3mp1fLY+
	svycrBism6+kM6C3FMjDG52EVB4nWUc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jzF4WKdQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3MrskaQgKCIs71378pupv33v0t.r310x29C-11zAprz.36v@flex--smostafa.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3MrskaQgKCIs71378pupv33v0t.r310x29C-11zAprz.36v@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764014900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hbVDtgb8rBp8ziR20f2VdPbPb3JDkOdyP9SxZ3vHtis=;
	b=h3hNmbB0oDdbgZCE955O2iGE257SCaA7SW7lrQL0qzwBAAd2YnhH+b14ga1BUoUFw9lzL5
	Bj4geL3AHliM0ukh5JqEHF0aevRZYd4s74B1WTqDp6JtPjIvgWmvmkMttquaNmV3wHdYCj
	kMNfagXwEIjbY8deAGX+Y0cQkVeMi5w=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429cbed2b8fso2629066f8f.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764014899; x=1764619699; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hbVDtgb8rBp8ziR20f2VdPbPb3JDkOdyP9SxZ3vHtis=;
        b=jzF4WKdQzbpcG4YpNhoqaBteO0DjDWTkCb/RLjgm9Ztv7rLOeHWZJMTyZwYl9lf4rR
         cF3I7/vCyVp4kDob/yMhO5sO0kvVhGz7i2oLu42UGitA4cJtzMAUpPt77MxDyk59FjSh
         notZel46rkiDaaxL61BkTfJIqFfGCZPanpJuaGGoPUgw6bcMJ+pO0YjNV2kJPkbk0hhB
         d7bP6Dr0sCzTN0irkN6NuaqHg7ojBZjmqP/P+m10IbzklAVG1ymAqI4SfKij782+wovU
         rrTmFm73X/t+4ZxS88R8YjHHRQ0f2NDMhHFc79dxmCgYd2Tajy3ZaQjPcFbCVQ3mSut6
         aK5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764014899; x=1764619699;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hbVDtgb8rBp8ziR20f2VdPbPb3JDkOdyP9SxZ3vHtis=;
        b=TvsBwX/1IoW4pa9/Bt8Xvy+0RRO9cs7WiHk5fJyzVJSd6OfIFW0JHyPx/61hW8C0n3
         Ij+Xu3YhgN8NDY5m8OYcX00xl5JsxGB7GsfRsHMO4kOofJ/uy5PsD1K7h4lciLG8I7NU
         eGdGM3jzfhX6ZaTws/9Ag7Jj+9n3K6Yw8EpZpfLrpf+ln69EW37ZHNDjclG6qxrFBtgz
         aJwD/j9KzemGzajAl5JJcVvApZZ4roLxM05IC96FL2tsURMXgqpw5v2lU6rmYSMDgw4n
         Gde9M6AX+hnYMTC+yp6SNT4V7CmzzbC9xkWocL+Ua9aDrB9wThiqrhpEKLNdywnr0PVD
         eALg==
X-Gm-Message-State: AOJu0YzAZQ5nhMVhY6yFU0kk/Nxcx6A1ss1PNuIVD2veDtFp0XGdUFzp
	TlARslFPG264v0C3swdi4WcOUxAF/5ZzgEwCgkmT33vjm5RllYs9oBtamAFXaQXA3iMTzUgs+h9
	3A2T7VSvp+lRT51yYwXG+hSa5HdV+bLY/u8/hyumcMU5W+uVdzUXrkDWd3Qhr5CfhQuHQF/mjY0
	tnkiYanb5JUTMNXSnEY83H9E5lHYXsejQ9fl1ObUG8fg==
X-Google-Smtp-Source: AGHT+IELGZPf6DUHRoEs9He1ETOOPZ7Kr5+C1bY4CAkNyhB8outgBkxo6CndGZpyoRi8wlt+uNVgOnWJUV6+6A==
X-Received: from wrbev10.prod.google.com ([2002:a05:6000:23ca:b0:429:8b8f:9db4])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2384:b0:42b:3b55:8927 with SMTP id ffacd0b85a97d-42cc1cba760mr13711892f8f.21.1764014898472;
 Mon, 24 Nov 2025 12:08:18 -0800 (PST)
Date: Mon, 24 Nov 2025 20:08:08 +0000
In-Reply-To: <20251124200811.2942432-1-smostafa@google.com>
Mime-Version: 1.0
References: <20251124200811.2942432-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
Message-ID: <20251124200811.2942432-2-smostafa@google.com>
Subject: [PATCH v3 1/4] drivers/iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 53FF480009
X-Rspamd-Server: rspam07
X-Stat-Signature: s8sqgjrdxwt4sx7qkb3qyhbdtifhp6oh
X-Rspam-User: 
X-HE-Tag: 1764014899-315642
X-HE-Meta: U2FsdGVkX1850Ef0ZyQ4U1Le1SdUZHMSqqUPH9RAfsan5veqv4M0TUG8KfyY8OzyYgVmiMbBlbJFvW8hnrmKIi7myPpsChyV56kjhf+c7DqHploh5sOIfzfi39FqCAqmVlZWfQhILLYD3m4pXUI0luN7nScWNW5C7mobA3GQh6pLikTjSSp2vtHACZ8AjgtYqeRL0PtigWPuRPa7fCzxlub78IeXpWV/BpjSP1+1Y4Rucgi8C8yGr40rjE1j+Kxzaz7PriYLTGCyPj/cjEV3XKc13Sf2ZHxt2wgLO71ut1HVYrOgnR8bPn8zYK6gkjQlyKkn7rwFTogbIPHwOQq6U7xjlolKRqU+SmEA1VOfesTALeFUrarFHLj7y4xIlCavIddDchd1ikjAzE+xXe5bJ3T6p10/JblAowPerg+9iyYfnsp1x3gkJi63kAaf5Ot4IzK+30kmdxLqdvUcejnFquV65GcCMDjBREaUAvaOo5fOEJ9+3ryVHWGK6fTcYhwKm7NABzkm7h7yqA6WEIz5YWGjoRuQ52iZAwJ8Eak7V6jY8PdVFXITFUCEuo4SDKpF0lOLrNeQmo54UIKfwKixeQBjAYXU7TJ9vJbz3UFhSlWhRSox5fxXHBv3Zy+9F7VMvrnU6nYKqaUt9ttteQwndTV9w8dl8ieRyKl50PMcY3YHCKuRI6OGUb0Cw26Utn/AA48SygWT38pu9MfM4G7WXRVN7D6gH7A4UglhRMvRpONi0Z2QZFfHb0lbpC+fiOQw9UTsVvAovjkAUurBbmw7LVGFzbNsl/p2La4GDLgK1cUF86bWNNFh3fEwQ99rbrpHEqYqBZHCktEVb45OUoe4FEyEaxFn4HuM1DLXeFEplajcXClft89dvDF6iQtUSuDj11kWAB/HrgAwMxlUIOucnOBVGcNwKsc7eeuDEeswwFrggb5lkPM5xJs2Y2n6bjP0B3IUrVkBJosVivAOY/c
 nefJPlDg
 9fgZ8jtOHCK6MyM65GcGx7Ivakp/smSnT1f5e4Kfc2bwzZ8jgSsZy63nczqnsVrlgzb5g/06YCOr8Vw36hO0V1ngLkJvY5zZGz9kmXjhYxWRHQyS2xQsysReFS/kqT9QQ6Fpbc2wCc840ZDF/F/ZRxrHgCsbamOKQAD62lTxHspXJeL7EGHkdcCNkQLnwkKaaHC8L3qllHSHRtAQ/Tg5+3tHLFm2Crh2dy4+T7waf73eDz99dmNDmtdQ0PdVLjiEctV/RaA15brbw6Ljb0aMp346bSCc6GyWjGoxA9bIVfLE5sWnss/lchvnN/CLGRtU62I7kcA28T+2tdrdHfxf+I2K0+rp+EgslM7HUtOiaKtu+54LC+LOpkWO0Ju1PU01r0rtbHbn4rwtDJWPYmI0x1VBDleh3Lej76/+o5W/jPRVLRA0BNbW4CKPhyvRwu/awNR81m990Fm0TsiTlxj5F/I1vCu8BbFP5BwXbmgcAUCrtfoYGPtji+S7bT/47CigtIY4CY9KCu0hvm0qkvV0dFXUXqw/D8s2DKyCNkmgK2A/m+0GrhbB9AQ5SuoXiyU1EoeKQ
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
 .../admin-guide/kernel-parameters.txt         |  6 ++++
 drivers/iommu/Kconfig                         | 19 +++++++++++
 drivers/iommu/Makefile                        |  1 +
 drivers/iommu/iommu-debug-pagealloc.c         | 32 +++++++++++++++++++
 include/linux/iommu-debug-pagealloc.h         | 17 ++++++++++
 mm/page_ext.c                                 |  4 +++
 6 files changed, 79 insertions(+)
 create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
 create mode 100644 include/linux/iommu-debug-pagealloc.h

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6c42061ca20e..dddf435a1c11 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2557,6 +2557,12 @@
 			1 - Bypass the IOMMU for DMA.
 			unset - Use value of CONFIG_IOMMU_DEFAULT_PASSTHROUGH.
 
+	iommu.debug_pagealloc=
+			[KNL,EARLY] When CONFIG_IOMMU_DEBUG_PAGEALLOC is set, this
+			parameter enables the feature at boot time. By default, it
+			is disabled and the system behave the same way as a kernel
+			built without CONFIG_IOMMU_DEBUG_PAGEALLOC.
+
 	io7=		[HW] IO7 for Marvel-based Alpha systems
 			See comment before marvel_specify_io7 in
 			arch/alpha/kernel/core_marvel.c.
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 70d29b14d851..c9c1a1c1820e 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -383,4 +383,23 @@ config SPRD_IOMMU
 
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
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 355294fa9033..8f5130b6a671 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -34,3 +34,4 @@ obj-$(CONFIG_IOMMU_SVA) += iommu-sva.o
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
2.52.0.460.gd25c4c69ec-goog


