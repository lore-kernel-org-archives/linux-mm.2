Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DC73D26D7B
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 17:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDB116B0089; Fri,  9 Jan 2026 12:18:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E98C96B008A; Fri,  9 Jan 2026 12:18:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF10F6B008C; Fri,  9 Jan 2026 12:18:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B42E16B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 12:18:16 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 614BAC1DA9
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:18:16 +0000 (UTC)
X-FDA: 84313083792.11.D799175
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8CB5010000C
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:18:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eFbsb4rx;
	spf=pass (imf14.hostedemail.com: domain of 3VThhaQgKCJwOIKOP6B6CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3VThhaQgKCJwOIKOP6B6CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767979094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMbvILs8sdDM+X7Y87HU9ypohayabztkjgZL2Mm3bR4=;
	b=T89QhjfXSEKVOZEWSxm6psuAZhjrf1oXktYfobAeSxvaOgJrsaViqdcSKdSPU9PNkkF4mk
	gAmS8zKN18sXQEL3l765puoxQwaDn2A8yonVhSZ8Tsf8xqOmGmMEcK9JaK2FjTRcZOYY26
	SNvDlfcO0zu/C1YfvNx/0kYVcYoEL9g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eFbsb4rx;
	spf=pass (imf14.hostedemail.com: domain of 3VThhaQgKCJwOIKOP6B6CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3VThhaQgKCJwOIKOP6B6CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767979094; a=rsa-sha256;
	cv=none;
	b=Qnw6vvUMdNA258f2DMsiiQacKJFPOY4nj1jTAnYD1tLNuJgJvwnv6iHsOKCMchOfmjEnvo
	UwO2MalBo7X6X7Asf+KeT/g+sbwVvOHXFrmhA2CTmG7cXv0fV3HkW+hATUjtQmGb3C5/uu
	wnvGb5IrKIEkf1iS0pYsz8TVMQFetNo=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477b8a667bcso49500885e9.2
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 09:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767979093; x=1768583893; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yMbvILs8sdDM+X7Y87HU9ypohayabztkjgZL2Mm3bR4=;
        b=eFbsb4rxqQnqnJ8k4PJ4OWtVPllr5YLMnpbAXkEjpOyot+0Nb/T6F6XsQms+gOnvi0
         trO+J61P/JlGK0BP/O9m6vhQiTVWDm6sNE51DjKfx5GxfSoK8vCEBviwCJbC2pLMAtcC
         /6ROgTQiBcWYYH/OhGyX433d+wKUKPzsoVXRXy7X+W50iGxJNmZnh3H1e+YxZGwYuw+t
         7PRU1Lc0N7I+dHv8oHtJBT+yJCwD2l0ODLKjXEqZz5G6JhF43TDE9nQAsddhcPFHHA2w
         dOtnv+IF6a/148IhhyIAz2cP4j7ZPi662PZhf2SvH3PHyz3FgTWuIeqwzdatlTFnKUR6
         wYaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767979093; x=1768583893;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yMbvILs8sdDM+X7Y87HU9ypohayabztkjgZL2Mm3bR4=;
        b=WEH+/+ixIEd4vp/xjm++sh+6/bDnje/jYCsYD2+1JIQhc+ye6pHN2+eatKE7EVeMz4
         EXhBJq5/sKMs3lOy/V6Qz7hwMq8jQiDIH1GAnotooWddl5uDU6VOt+onLO2RS6lbzwd/
         j+cUDNWat62lnsu3Bdd5+Yezo0J8Ez7aCuypU+oS9NPLH3udgHAdaZnOkUe5rpfSGoY1
         7kmy1nwsQIIEg4daolBIenksUGtk/ufMpzTz054Nu0drT7yNVQUdavwRhg88P+y5MfmN
         Qbbq2I3pLxIVZ/A7B5dDER83XfEXctisFRcA+x51w/5geUDWHUTge3W78+tJQwXh/a2e
         25Mw==
X-Gm-Message-State: AOJu0YyhyfT556Rft2qjX0zu01sY5Ocbs0SLY6y/0lzzdk7qdSitbk+H
	LSB8TeV59oQQ9yHvb6XTRDkdhlcvC0duLHn6ISPU6uFoJACzyvZ2HZo0ANmEn8+Cb8913yicJ2M
	0YEBcEXlvFeUX2sSk/dCMoJDRQU2Nr0fz4+qG9GphLTVvs0SlLjphpiWVBAJCHgEH54DeYhibZD
	ciaO+SFOatWs/M209J3f3hEQYaVmJ9bM6/fVmcsgo2fg==
X-Google-Smtp-Source: AGHT+IFQrKO26j/Md4KslqSM57emYB9l/vej4SFg9X38oEIjTZGmUcvdSgmghLEuHbXJHuTDMuZHlNVKSr6pZw==
X-Received: from wrbdr2.prod.google.com ([2002:a5d:5f82:0:b0:430:f6bf:b2c3])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:103:b0:47d:403e:9cd5 with SMTP id 5b1f17b1804b1-47d84b1fce2mr91839245e9.11.1767979093084;
 Fri, 09 Jan 2026 09:18:13 -0800 (PST)
Date: Fri,  9 Jan 2026 17:18:02 +0000
In-Reply-To: <20260109171805.901995-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260109171805.901995-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109171805.901995-2-smostafa@google.com>
Subject: [PATCH v6 1/4] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>, "David Hildenbrand (Red Hat)" <david@kernel.org>, 
	Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 9uetpznngsnaoqf5tji5yzqcc3x9gxt5
X-Rspamd-Queue-Id: 8CB5010000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1767979094-631098
X-HE-Meta: U2FsdGVkX19BmLGL7rA/8K/7/yom2z/GigKerbyjfxdKNsMtBW0l6towtaldT+nKYZAhp8lnaC8+x9mJG24cCU4xR8nkfSM+SD7/QzLp1DcWXsD9M0YXV/EM+oeTVvo2iNZ3csVMTYhQmEH1Mi+xWbpodQ1gfwalaNTPeMmVt8slmC1k5AKdM8H+snucLlDvkFZI8qfwAE28K2KWswe+CeQVurZUGPPL1XiA5Ta6sMDdSOHlcdyW4plNWug1C70T11px0ifJZXfGEcifDILWKmUHxUXtjnu44ekWa2h/4i2Ev+xUUy6RRpFD6NwL6U9qXrS6TnJJVFX28OBeTC4SEgQZ5a9bGX9pGfl4iNh6zdvk93/aEQOzw/zAes9BiY8fL/Z2phrv9AWH/39GuYNbnIAkhI0rc70PH0pFkLD7D2vsV7kjjSXbrvxeRpjVjONmqwpFkgjCwtXmHOKO8M/Qdy2r3n94xYnYOLX8a/D83dhegqJw5r15yPB62KprAE/29exGs3hD+X4ZGzAFCNvMXGY5ng5kACs7ILif9Oij4Fn0jsUct/hg+tDTHxCdG/MdwPnwhmqCnYPLI/unxm0qwsxF3m19v4fRL33337P7QJ/PjW/Vj99aVQAkA5snXWGHyHFIdikqNWH0rNG3kA7eo2hrytbWG0F6Zlk+Xnhway/9AagUhRLRExPG1PsBXHlSi7/NSRIk68VJZ9Mdr44r9Vu5BteNoPteVZgz3bV/oBMTHPNLkHaihRNTqqk7ZcsJRnsslZ5tnksDQ2SQhenHQZzL3ufCmFbL4GHkNu9Fn83xpWngdEC1pqWrmCC3lckX4nMfU365e7W9HP6NfRJUavL1YiwCHnDeuiD8VtJsW9jb3m/AaXk0q/zsPVjYkSjsD3FMq3ZTyfSUBSf2iN5l+nSSwIAPlfIwyXPPrzGNigcwhc7rFHqZndNpe9Doi89VLSQZ+shaWg/B8dWTCtR
 VHQr3gx4
 +Kw0WvDvBZpG1vzqVmLsRgWhEZdpKOXRn1E80rfkDolrTPmb44sLxC/vNjaumueOi79Nqucdn+58S6Gi8Kkht5aS2JqD20epGbeLm7XEmW+BjOtwN/4/6M+hy0Hp0UBuv4gsOPGJohtYt03mEJT7W08NN8HaarhteCvnRXiT4fHsqTlAQpjfDABtsfoWnWNP5bbORgV7FSq3+b68fhbXQyDv11dosQvbDmNlsEVKBEMq9DPRjCyLGbsYbhkr87DasuSCpwe29laQ/VAQzqUSULzTn8rGQYTIhF9wGU8+CAr0TJZKQdfuD44J0uQndD8WANO/RGB3Rw8ofYFDkbQsho8UU49eF7QhM+mdENFtwY467FfbtB5lVQw1uRmCL111ghlN9tjdTizAVD0oTQQkSsyo7gvIaK1Mc3XCx1gJNNtecGRetrmr+G5j9PoSJiVndkhH8tDBNAK0WyHUVlmaMPEZPhVLO2OJLO2w5nSt6vqLd8vHtQERx0JS8RIxhMLShmcEVjdp3AQHreMtu4dq1KcAFnwgcz9Ft8niFaH7IwCTFjPLLtn2QcVcm/Xm34cCAB5EnmiNKIg02TVdkbylRq8ex20+WFAA+a0hxmQGsqXzgZRyXyex0GlJLQTgv4UYbj4NITVLWCT8m1MAheb0KSvD2RA==
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

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
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
2.52.0.457.g6b5491de43-goog


