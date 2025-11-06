Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E795CCFA19
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:40:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92D838E0013; Thu,  6 Nov 2025 11:40:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD868E0002; Thu,  6 Nov 2025 11:40:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CC298E0013; Thu,  6 Nov 2025 11:40:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 661BE8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:40:13 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC59FB66DB
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:40:12 +0000 (UTC)
X-FDA: 84080744664.04.C3D255A
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 211734000F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:40:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=o6OnrCN3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3ac8MaQgKCIo60267otou22uzs.q20zw18B-00y9oqy.25u@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3ac8MaQgKCIo60267otou22uzs.q20zw18B-00y9oqy.25u@flex--smostafa.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762447211; a=rsa-sha256;
	cv=none;
	b=XC1xkPst4KYAzdhhC7HuceFNWkz/o4qzRW52eiTa8tgWQcEuPBwgwSj7KC758kMWpBL3HH
	fpiuVso+RLqx5jkk+xAEeurcHntdScxsViyoaeTQ5J33rOPrP7m9xk1ey204+bnJb3UkfM
	bwPrR+N6czUapPhsJfg8k2Lg1HddRnU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=o6OnrCN3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3ac8MaQgKCIo60267otou22uzs.q20zw18B-00y9oqy.25u@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3ac8MaQgKCIo60267otou22uzs.q20zw18B-00y9oqy.25u@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762447211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGn9S9TG2oeGoFuSE1bVv5EDFMyzjo3ZeltmQ55DAp0=;
	b=3U6Geel1k0daegm55hIj07InT4KWn0bJpr8phQ+wvtnWU8kQTp0ntd5isOTtAtBoF4B7Wy
	EMsC+zSVPbklwV5YMn2nKsvUPL9wsVIUVBS79AtnW+5VUsc0amRcNksxpeXzIHsrlDttFL
	42VnKnxOp/4TfW302NQwDYGzbnuAoE4=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4775e00b16fso9247845e9.2
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 08:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762447210; x=1763052010; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yGn9S9TG2oeGoFuSE1bVv5EDFMyzjo3ZeltmQ55DAp0=;
        b=o6OnrCN3C6aejV227F6178Gwlu/qrTgEhIQMko6tIy8LdJsqO50b0jav+68toCcj3D
         N7YlbzV4ske5HLEFKB5/44q9vNXyDgZM2KeN3gV6oPyszNSMiv1RDUdPqVbt4Tt7/mEP
         rHw45u98YZWTAtiaRWP5nI0xaWcR7JZJcb6ztpqJj1VENvqhXpa2MJBy/qVsxhTGFKet
         b2eO2MvUoVrgcGyUFElIwkbw9/Vd7BZrizyu0JgPi2CjSvQVgN5GXT9clpO0rjkiyd+e
         jvlTqW/ke+TsrK+4TaJngIkj9fZ7lQNckUXaZtAoP+q11zZPrihTLLLhOul2XIKteHcK
         WCpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762447210; x=1763052010;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yGn9S9TG2oeGoFuSE1bVv5EDFMyzjo3ZeltmQ55DAp0=;
        b=B2elTtaBd80oLSeof3sE9Xr9lGcccyUo0NI0AJL/1k02RScQ/9v8R9X/QVjKQay6bi
         3B9uGM/X2RFIGaphW+X1OZFstAiLjrewxTtk8RuJAPJWC6hf3WLjZzHah+Sz8VspmIfe
         x9FjsyuQUm0Nl8d+9++i0vDhzd+UpPeV38PlKgtbMl3zOpXRyN4snaW+wDF8wOlpi/mj
         actQopMf3viMzYAPNuuiTuAkdTeQ/cK5YJfczW23SYxfObu0yKUm7kQ0/O8qGIhZsNow
         vBVqiUOTGx1QLFRltO8s0r1dZHsMlPDkJ8yGl8IaSVjeenf+T/RrTbQZsOFLhrdcesjp
         EFxg==
X-Gm-Message-State: AOJu0Yywob+Egi411tCkh7DeT8GI1/bOaUKUU9XUkZ+phx1QFQaMgqmH
	eK1Ky1ArC5LULkcQ6r5QJ+JTky9qdWJFp62rvjs2eyNVgVLYMI0LouLX+08J0mvz2bfF0wGSqBb
	Xhz3ozk58r3WJEuixp9wwsT/nVRG9LsO//t6OZ0P75t0PU+pI7umts+p10jwnpoYAtPQb+KkQZH
	q+yJhkkKpUXVMBAuHFBrhT0b+qTZ8yiwsbf9PM95+Qaw==
X-Google-Smtp-Source: AGHT+IGin0gdaVVLFPqJJbxATM/GoLhvdHY35FLM6SzMry8X5z6uv1NEwI1PHMOviV8zQ1+HDeBhnFureuyQHA==
X-Received: from wmcn19.prod.google.com ([2002:a05:600c:c0d3:b0:45f:29fc:83d])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e88:b0:46f:d897:516f with SMTP id 5b1f17b1804b1-4775ce24d3dmr93382575e9.34.1762447209641;
 Thu, 06 Nov 2025 08:40:09 -0800 (PST)
Date: Thu,  6 Nov 2025 16:39:50 +0000
In-Reply-To: <20251106163953.1971067-1-smostafa@google.com>
Mime-Version: 1.0
References: <20251106163953.1971067-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.2.1026.g39e6a42477-goog
Message-ID: <20251106163953.1971067-2-smostafa@google.com>
Subject: [PATCH v2 1/4] drivers/iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	Mostafa Saleh <smostafa@google.com>, Qinxin Xia <xiaqinxin@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 211734000F
X-Stat-Signature: 6cc1rxbbzwx3wuazqu5h48fswtufh4ha
X-HE-Tag: 1762447210-902846
X-HE-Meta: U2FsdGVkX1/VnbYmWHEiHGKmIuZT357/SGOHeczXzK+ieyS69SfnHMWyV+a4sVAbF7Nd11ShDdNs9eUYJOyMXEyRfpbfQmKM3sh1fejK8Dr4PRgBL8VqXHtpxTkw6P85MuTaQHfteNpRnkj+uMsug2pU+S4M9HXlSGWKaBr6wt5wiS/lMAgTZhJSu81jjeUBPjjI/vFdMfbUM0NVBuc28B2M9Z4QgCs42EEYSnCfIZRi3RGqRZSfGQLKbVglYbSSm16Ldgp8dfmuuJEQJ1Z20Di94fC5uGlP9A1s6Z2nlt5/u6bEq1+qI9j4jHP3e4TCK7XR83v0CB46ieA+RLcsJ9l7x+K8rclabg93hLV1F7zkLGLUfEx1mNnx6mVPFSgKbdr1L4YgQfN2QxICi4BZX/n1XyGB+X89vX8bA2S+ZFZuK79vFNa7u1uQPZfGXknP6/ABOHJrjbTqVeAWmwVI3DrzkR4fGwKwFaa1X6rs7uU+q/tWCaEHazYQao9BimrQ0jYs0ZVSIN7A4Yes03rIadkoBINF/ru7me7aYW4/dFxSFNTjby4B9Lh7Ro2YB/cMP5iY2TPg82XhWvQbdZRvvDz+R/6IbtMkRBAf3E5T5Lk3Nct1UJgkTIW/TV8GFL6S9NJ6F1o7prPnI7XfjkfoJExQ50xznw7mpUxReISm2g5guLW5rWP2oBXBzeawTSwfhXKrqRH4/S6GqY5OjwjJb65n8+QAUxmGsNxnQkP/TgFcNOWsJsycOG809IdXb4kVJNL/PSZ+/eyAiVi1DWagvCPkvlfSFl+l2IzmX1tX9woZsNcjIrRIdD9yvyz6ZX24xq1SAMGLK1ageUrdLgr2C0NkQEyjMZtieOoTzaT5jM0WljrmsjcRatpjr/rkZD+Z8TGMzXHaaLddHKVnGOQRRg1BWm5oMiDk0/6KoEAUBq4P64hOUMQ8+r+MOMHJfUI3aq4T7ul7gQIxSxYUVvk
 Xq31aYNw
 g7KEyKGxr/TdzbQ2xmLiUnjfkra9+hF+qFOqzHVr/+pRkD4Q23/ugIjEgonQkyNwN9tuO4g12UAITyFwfl9MVGMPQz5aHCPt1uYIFGRv7ZWlRDc0TYpmvGeMLnaWc3x/xk2xPk0oxbQwndgA13ruxafuGaFSE/UytlfUdNas3mqfKMVz7mZ9ES9q7OevQ+o2oB9aXL8XW5BkBaMVkt9osRr5iaz6mI5J73MYCberZwBq7xZjyjOOeAelYqcLqzi3ckXbVYFCMufPKCuS8pHrOZ7W9ZmrgcEuz/0psyNmqUIgco5eR/3dXB1oLbFcV+0vEJ/1bZ+CYPWtzJ3px/lWW/hJqIVqFINL7zgIKtqAVD3n6XZTJatO9PDT3K+Ajr2bZvvdDSDhv12STaDZUMNkjoNda6/5cRYzMom50s/wVxVS+IBdK24FrMowlYrVntTVRpuWljdIpN1X8weY8oQDaa6snA6yjK4rbp1+6F78ufhoZwUVo1wcLa9s5LuvBDlZB/60Jve5wDNwAceM+Dg7m71DFTa79Gh2FR8Ui7AqHDMgXnx1zoRYj2MPu+ritnZu1/sMtKXZWrVG3ceuOcR7f+J85YwHX68J4CNk0rDxVBqft2687GolspZ0BrRCUaofKLHlD95inZziwbXfM5iIb4eLYl8gHeSNyABBi1OIXLlQgqRolAm/clDUHmgkcHCFs4tapTr5Gf74xtrU0bONUA7WLX6v6ibZXQuYeQJr3XJ6wUwryaIhwCol9Tw==
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
Tested-by: Qinxin Xia <xiaqinxin@huawei.com>
---
 .../admin-guide/kernel-parameters.txt         |  6 ++++
 drivers/iommu/Kconfig                         | 15 +++++++++
 drivers/iommu/Makefile                        |  1 +
 drivers/iommu/iommu-debug-pagealloc.c         | 32 +++++++++++++++++++
 include/linux/iommu-debug-pagealloc.h         | 17 ++++++++++
 mm/page_ext.c                                 |  4 +++
 6 files changed, 75 insertions(+)
 create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
 create mode 100644 include/linux/iommu-debug-pagealloc.h

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6c42061ca20e..9a1c4ac8ba96 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2557,6 +2557,12 @@
 			1 - Bypass the IOMMU for DMA.
 			unset - Use value of CONFIG_IOMMU_DEFAULT_PASSTHROUGH.
 
+	iommu.debug_pagealloc=
+			[KNL,EARLY] When CONFIG_IOMMU_DEBUG_PAGEALLOC is set, this
+			parameter enables the feature at boot time. By default, it
+			is disabled and the system will work mostly the same as a
+			kernel built without CONFIG_IOMMU_DEBUG_PAGEALLOC.
+
 	io7=		[HW] IO7 for Marvel-based Alpha systems
 			See comment before marvel_specify_io7 in
 			arch/alpha/kernel/core_marvel.c.
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 70d29b14d851..6b5e9a2d936a 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -383,4 +383,19 @@ config SPRD_IOMMU
 
 	  Say Y here if you want to use the multimedia devices listed above.
 
+config IOMMU_DEBUG_PAGEALLOC
+	bool "Debug page memory allocations against IOMMU"
+	depends on DEBUG_PAGEALLOC && IOMMU_API && PAGE_EXTENSION
+	help
+	  This config checks that a page is freed(unmapped) or mapped by the
+	  kernel is not mapped in any IOMMU domain. It can help with debugging
+	  use-after-free or out-of-bound maps from drivers doing DMA through
+	  the IOMMU API.
+	  This santaizer can have false-negative cases where some problems
+	  won't be detected.
+	  Expect overhead when enabling this and enabling the kernel command
+	  line iommu.debug_pagealloc.
+
+	  If unsure, say N here.
+
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
index 000000000000..385c8bfae02b
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
+struct iommu_debug_metadate {
+	atomic_t ref;
+};
+
+static __init bool need_iommu_debug(void)
+{
+	return needed;
+}
+
+struct page_ext_operations page_iommu_debug_ops = {
+	.size = sizeof(struct iommu_debug_metadate),
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
2.51.2.1026.g39e6a42477-goog


