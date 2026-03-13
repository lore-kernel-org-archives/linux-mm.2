Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 395B4105F7B4
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 15:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDC356B0092; Fri, 13 Mar 2026 11:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79376B0093; Fri, 13 Mar 2026 11:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B5496B0095; Fri, 13 Mar 2026 11:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83C9C6B0092
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:08:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3494B139A93
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:16 +0000 (UTC)
X-FDA: 84541370592.30.8FACBDB
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0E70E140007
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=G5CpfkbN;
	spf=pass (imf26.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773414494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJ+AbVie4VzqjcN+NiZ5Lgc/79RXQxJwnzBrktnQFPI=;
	b=1jPA8tx0UW6EcfNBM0ICT15ElzY1Y2s0TVA35O7GwxdsuN7dnvXWHJHtAIBhqteXuINMOw
	H+5MpffkO++7inqhfZkzF+3tLjBaEaybTF0QPW+6fFRWhxaa7TZJ2nj+29MIonapAFfn6F
	C3o3Xu96maQRMWXWWbtIQjxP3j5Myrg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773414494; a=rsa-sha256;
	cv=none;
	b=3OsSl7G3OHaPqEZkXjTwqalwvoNfeijPYiA22W6SOoVeVHbutZQg0ouqfqUEP36msu1+Jt
	3nGuUb7RE45xDU71lzbQR2f4V5oWRNvicNWFQYXmJPQpYcwsbGvs9amf+3JFQbCj5aIh5y
	3zLRCa9TBQjT+IiDJ4dYBZBQQrDWYFk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=G5CpfkbN;
	spf=pass (imf26.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260313150812euoutp01d45d0fd1b842c3d6eea95724e89bde44~cbxXIH2tv2283422834euoutp01f
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260313150812euoutp01d45d0fd1b842c3d6eea95724e89bde44~cbxXIH2tv2283422834euoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773414492;
	bh=OJ+AbVie4VzqjcN+NiZ5Lgc/79RXQxJwnzBrktnQFPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5CpfkbNeO6ZTFAugyudepxKq6lx9RTjOsZRAQrDAbXV+lwwBub4QfkdyP5SzcCQ1
	 1M1TAsHWI4CsNIZlrqZAYryxKRtofzCiBvC2Rp3hv83/jntTBUD/kq8YABkXqUc43I
	 dPHGKsdo4m1e4ZQKo2g4LdGQYoT7VBL4Hzj3fXsU=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260313150812eucas1p2f155af637fcaf4d7061a5c9b9a5a6233~cbxW4kA8a0324803248eucas1p2f;
	Fri, 13 Mar 2026 15:08:12 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260313150811eusmtip1d2c4765123a272f8db46c4e9353a03d6~cbxWTm3tV0285302853eusmtip17;
	Fri, 13 Mar 2026 15:08:11 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Saravana Kannan <saravanak@kernel.org>, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 4/7] of: reserved_mem: replace CMA quirks by generic methods
Date: Fri, 13 Mar 2026 16:07:59 +0100
Message-Id: <20260313150802.1121442-5-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260313150802.1121442-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260313150812eucas1p2f155af637fcaf4d7061a5c9b9a5a6233
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260313150812eucas1p2f155af637fcaf4d7061a5c9b9a5a6233
X-EPHeader: CA
X-CMS-RootMailID: 20260313150812eucas1p2f155af637fcaf4d7061a5c9b9a5a6233
References: <20260313150802.1121442-1-m.szyprowski@samsung.com>
	<CGME20260313150812eucas1p2f155af637fcaf4d7061a5c9b9a5a6233@eucas1p2.samsung.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0E70E140007
X-Stat-Signature: x5m7bye77k6cz1m1p3u1i77fairf65uy
X-Rspam-User: 
X-HE-Tag: 1773414493-125348
X-HE-Meta: U2FsdGVkX1+UPTPjjGiDN/+x3iPyTba0jo8jxd+3BX3721tizvg4GIT+RvwkxZER9EzTioRGOb4dVzitDxfIwAmct/YVUogl5z6qAIvhZEM4aYyQVVYaPdj7cK6gA9J7oRlw/94w/h8o9mRbWrRKluBtgb1qt38ttPlilfY2jFLmkEokwgfZlMbTpQCySG6pz7daZWhXXs1Kxib6w+frnp8gVdK71b3UlM4vGMPFyXx6RXZqshccwyb5+qRGfAxow4FrKNPaNCHYVtWPfT+qcsRTjHXh0Tat65rqea/hAI6UViVDHU2n1LXW5nNjQXjDZjMTnYbsLmDVtNdz2noeO87kXsFt3H3lWNSsxen3c9wNX518fv/jNJIiQ1SaOPRAWhSPihahACLVdtIEwpue0ik+nBBOJ92UcWn6u8lkAwHSrE5+Xb2my9PTThK+VKI5hyIc8wDI/j0H5pbFUzX+WYs8dSnqTIm0FT/8mjSLjLh82KI0qzDxgM7/0sNd3fSZyotkUvM+2lF3ryFI3oLzSzsmZVJPQr/BoxuFTVplB84PIHIhUjZxaELrXEqlnuFr8N6bHcGy+QFdMkT0Vl9UHxBSFtgsjEJAO6IFytu2tEy1Fiou6VlDn73fOKnp83jlnEbIBs2wkhb16AZTJMcmU2M4NePcAHQlJHgqQWMB0oYCcxTHVOqzmqgQyxXDUPPWq55hcapq6NDEkkdHzQhjBAe4feuBfXsq3RDSIl3S1llblL/Ow9tZpIJ+k9JY1xH14yznXwdiLbtRL+xSwJkvmrjJgaLi6j6O3NWU0ibuNWKPswjYQ7YF7sih4VjS7uTm0puZUi8w+hRStL/dIAVOPwrN1wPexpLeK5Ju/TbmSclbBJX3RRyUd3X7QNCKCdSge5xxtxy2vhkrLKORVTt7msfLfhDmydhQCm17s2m/N+ZDWtEmjb0t6WqF3vDwzF7Q2TjPZXAr2H2AK07KoAQ
 moJbXu6M
 oe3RRxE0zMX7QIUfK7XSrKcXxdj3BuTYEoc+9rMRmoS82AAzw1FWvyTUMIzNpiRJciQLjFYS+eYPActoLbzD3TRyZdyXlfjmq2BBIFRDjvDcJz31kkWN5eImBzodFu5gKp8EhN/88LbZ34zw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add optional reserved memory callbacks to perform region verification and
early fixup, then move all CMA related code in of_reserved_mem.c to them.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c    | 97 +++++++++++++++++++++------------
 include/linux/cma.h             | 10 ----
 include/linux/dma-map-ops.h     |  3 -
 include/linux/of_reserved_mem.h |  3 +
 kernel/dma/contiguous.c         | 70 +++++++++++++++++-------
 5 files changed, 116 insertions(+), 67 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 675f1c1c6627..399cdd11a9ca 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -24,8 +24,6 @@
 #include <linux/slab.h>
 #include <linux/memblock.h>
 #include <linux/kmemleak.h>
-#include <linux/cma.h>
-#include <linux/dma-map-ops.h>
 
 #include "of_private.h"
 
@@ -106,6 +104,11 @@ static void __init alloc_reserved_mem_array(void)
 
 static void __init fdt_init_reserved_mem_node(struct reserved_mem *rmem,
 					      unsigned long node);
+static int fdt_validate_reserved_mem_node(unsigned long node,
+					  phys_addr_t *align);
+static int fdt_fixup_reserved_mem_node(unsigned long node,
+				       phys_addr_t base, phys_addr_t size);
+
 /*
  * fdt_reserved_mem_save_node() - save fdt node for second pass initialization
  */
@@ -154,21 +157,19 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 					     const char *uname)
 {
 	phys_addr_t base, size;
-	int i, len;
+	int i, len, err;
 	const __be32 *prop;
-	bool nomap, default_cma;
+	bool nomap;
 
 	prop = of_flat_dt_get_addr_size_prop(node, "reg", &len);
 	if (!prop)
 		return -ENOENT;
 
 	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
-	default_cma = of_get_flat_dt_prop(node, "linux,cma-default", NULL);
 
-	if (default_cma && cma_skip_dt_default_reserved_mem()) {
-		pr_err("Skipping dt linux,cma-default for \"cma=\" kernel param.\n");
-		return -EINVAL;
-	}
+	err = fdt_validate_reserved_mem_node(node, NULL);
+	if (err && err != -ENODEV)
+		return err;
 
 	for (i = 0; i < len; i++) {
 		u64 b, s;
@@ -179,10 +180,7 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 		size = s;
 
 		if (size && early_init_dt_reserve_memory(base, size, nomap) == 0) {
-			/* Architecture specific contiguous memory fixup. */
-			if (of_flat_dt_is_compatible(node, "shared-dma-pool") &&
-			    of_get_flat_dt_prop(node, "reusable", NULL))
-				dma_contiguous_early_fixup(base, size);
+			fdt_fixup_reserved_mem_node(node, base, size);
 			pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
 				uname, &base, (unsigned long)(size / SZ_1M));
 		} else {
@@ -253,17 +251,19 @@ void __init fdt_scan_reserved_mem_reg_nodes(void)
 
 	fdt_for_each_subnode(child, fdt, node) {
 		const char *uname;
-		bool default_cma = of_get_flat_dt_prop(child, "linux,cma-default", NULL);
 		u64 b, s;
+		int ret;
 
 		if (!of_fdt_device_is_available(fdt, child))
 			continue;
-		if (default_cma && cma_skip_dt_default_reserved_mem())
-			continue;
 
 		if (!of_flat_dt_get_addr_size(child, "reg", &b, &s))
 			continue;
 
+		ret = fdt_validate_reserved_mem_node(node, NULL);
+		if (ret && ret != -ENODEV)
+			continue;
+
 		base = b;
 		size = s;
 
@@ -397,7 +397,7 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
 	phys_addr_t base = 0, align = 0, size;
 	int i, len;
 	const __be32 *prop;
-	bool nomap, default_cma;
+	bool nomap;
 	int ret;
 
 	prop = of_get_flat_dt_prop(node, "size", &len);
@@ -421,19 +421,10 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
 	}
 
 	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
-	default_cma = of_get_flat_dt_prop(node, "linux,cma-default", NULL);
 
-	if (default_cma && cma_skip_dt_default_reserved_mem()) {
-		pr_err("Skipping dt linux,cma-default for \"cma=\" kernel param.\n");
-		return -EINVAL;
-	}
-
-	/* Need adjust the alignment to satisfy the CMA requirement */
-	if (IS_ENABLED(CONFIG_CMA)
-	    && of_flat_dt_is_compatible(node, "shared-dma-pool")
-	    && of_get_flat_dt_prop(node, "reusable", NULL)
-	    && !nomap)
-		align = max_t(phys_addr_t, align, CMA_MIN_ALIGNMENT_BYTES);
+	ret = fdt_validate_reserved_mem_node(node, &align);
+	if (ret && ret != -ENODEV)
+		return ret;
 
 	prop = of_flat_dt_get_addr_size_prop(node, "alloc-ranges", &len);
 	if (prop) {
@@ -468,25 +459,61 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
 		       uname, (unsigned long)(size / SZ_1M));
 		return -ENOMEM;
 	}
-	/* Architecture specific contiguous memory fixup. */
-	if (of_flat_dt_is_compatible(node, "shared-dma-pool") &&
-	    of_get_flat_dt_prop(node, "reusable", NULL))
-		dma_contiguous_early_fixup(base, size);
+
+	fdt_fixup_reserved_mem_node(node, base, size);
+
 	/* Save region in the reserved_mem array */
 	fdt_reserved_mem_save_node(node, uname, base, size);
 	return 0;
 }
 
+extern const struct of_device_id __reservedmem_of_table[];
 static const struct of_device_id __rmem_of_table_sentinel
 	__used __section("__reservedmem_of_table_end");
 
+static int __init fdt_fixup_reserved_mem_node(unsigned long node,
+					phys_addr_t base, phys_addr_t size)
+{
+	const struct of_device_id *i;
+	int ret = -ENODEV;
+
+	for (i = __reservedmem_of_table; ret == -ENODEV &&
+	     i < &__rmem_of_table_sentinel; i++) {
+		const struct reserved_mem_ops *ops = i->data;
+
+		if (!of_flat_dt_is_compatible(node, i->compatible))
+			continue;
+
+		if (ops->node_fixup)
+			ret = ops->node_fixup(node, base, size);
+	}
+	return ret;
+}
+
+static int __init fdt_validate_reserved_mem_node(unsigned long node, phys_addr_t *align)
+{
+	const struct of_device_id *i;
+	int ret = -ENODEV;
+
+	for (i = __reservedmem_of_table; ret == -ENODEV &&
+	     i < &__rmem_of_table_sentinel; i++) {
+		const struct reserved_mem_ops *ops = i->data;
+
+		if (!of_flat_dt_is_compatible(node, i->compatible))
+			continue;
+
+		if (ops->node_validate)
+			ret = ops->node_validate(node, align);
+	}
+	return ret;
+}
+
 /*
  * __reserved_mem_init_node() - call region specific reserved memory init code
  */
 static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
 					   unsigned long node)
 {
-	extern const struct of_device_id __reservedmem_of_table[];
 	const struct of_device_id *i;
 	int ret = -ENODEV;
 
@@ -503,7 +530,7 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
 			rmem->ops = ops;
 			pr_info("initialized node %s, compatible id %s\n",
 				rmem->name, compat);
-			break;
+			return ret;
 		}
 	}
 	return ret;
diff --git a/include/linux/cma.h b/include/linux/cma.h
index d0793eaaadaa..8555d38a97b1 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -61,14 +61,4 @@ extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
 extern bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end);
 
 extern void cma_reserve_pages_on_error(struct cma *cma);
-
-#ifdef CONFIG_DMA_CMA
-extern bool cma_skip_dt_default_reserved_mem(void);
-#else
-static inline bool cma_skip_dt_default_reserved_mem(void)
-{
-	return false;
-}
-#endif
-
 #endif
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 60b63756df82..55ecd2934225 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -147,9 +147,6 @@ static inline void dma_free_contiguous(struct device *dev, struct page *page,
 {
 	__free_pages(page, get_order(size));
 }
-static inline void dma_contiguous_early_fixup(phys_addr_t base, unsigned long size)
-{
-}
 #endif /* CONFIG_DMA_CMA*/
 
 #ifdef CONFIG_DMA_DECLARE_COHERENT
diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
index dc00502a6b69..c240dfe45c9d 100644
--- a/include/linux/of_reserved_mem.h
+++ b/include/linux/of_reserved_mem.h
@@ -18,6 +18,9 @@ struct reserved_mem {
 };
 
 struct reserved_mem_ops {
+	int	(*node_validate)(unsigned long fdt_node, phys_addr_t *align);
+	int	(*node_fixup)(unsigned long fdt_node, phys_addr_t base,
+			      phys_addr_t size);
 	int	(*node_init)(unsigned long fdt_node, struct reserved_mem *rmem);
 	int	(*device_init)(struct reserved_mem *rmem,
 			       struct device *dev);
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index efeebda92537..65d216663e81 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -91,16 +91,6 @@ static int __init early_cma(char *p)
 }
 early_param("cma", early_cma);
 
-/*
- * cma_skip_dt_default_reserved_mem - This is called from the
- * reserved_mem framework to detect if the default cma region is being
- * set by the "cma=" kernel parameter.
- */
-bool __init cma_skip_dt_default_reserved_mem(void)
-{
-	return size_cmdline != -1;
-}
-
 #ifdef CONFIG_DMA_NUMA_CMA
 
 static struct cma *dma_contiguous_numa_area[MAX_NUMNODES];
@@ -470,25 +460,65 @@ static void rmem_cma_device_release(struct reserved_mem *rmem,
 	dev->cma_area = NULL;
 }
 
+static int __init __rmem_cma_verify_node(unsigned long node)
+{
+	if (!of_get_flat_dt_prop(node, "reusable", NULL) ||
+	    of_get_flat_dt_prop(node, "no-map", NULL))
+		return -ENODEV;
+
+	if (size_cmdline != -1 &&
+	    of_get_flat_dt_prop(node, "linux,cma-default", NULL)) {
+		pr_err("Skipping dt linux,cma-default node in favor for \"cma=\" kernel param.\n");
+		return -EBUSY;
+	}
+	return 0;
+}
+
+static int __init rmem_cma_validate(unsigned long node, phys_addr_t *align)
+{
+	int ret = __rmem_cma_verify_node(node);
+
+	if (ret)
+		return ret;
+
+	if (align)
+		*align = max_t(phys_addr_t, *align, CMA_MIN_ALIGNMENT_BYTES);
+
+	return 0;
+}
+
+static int __init rmem_cma_fixup(unsigned long node, phys_addr_t base,
+				    phys_addr_t size)
+{
+	int ret = __rmem_cma_verify_node(node);
+
+	if (ret)
+		return ret;
+
+	/* Architecture specific contiguous memory fixup. */
+	dma_contiguous_early_fixup(base, size);
+	return 0;
+}
+
 static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
 {
 	bool default_cma = of_get_flat_dt_prop(node, "linux,cma-default", NULL);
 	struct cma *cma;
-	int err;
+	int ret;
 
-	if (!of_get_flat_dt_prop(node, "reusable", NULL) ||
-	    of_get_flat_dt_prop(node, "no-map", NULL))
-		return -ENODEV;
+	ret = __rmem_cma_verify_node(node);
+	if (ret)
+		return ret;
 
 	if (!IS_ALIGNED(rmem->base | rmem->size, CMA_MIN_ALIGNMENT_BYTES)) {
 		pr_err("Reserved memory: incorrect alignment of CMA region\n");
 		return -EINVAL;
 	}
 
-	err = cma_init_reserved_mem(rmem->base, rmem->size, 0, rmem->name, &cma);
-	if (err) {
+	ret = cma_init_reserved_mem(rmem->base, rmem->size, 0, rmem->name, &cma);
+	if (ret) {
 		pr_err("Reserved memory: unable to setup CMA region\n");
-		return err;
+		return ret;
 	}
 
 	if (default_cma)
@@ -499,14 +529,16 @@ static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
 	pr_info("Reserved memory: created CMA memory pool at %pa, size %ld MiB\n",
 		&rmem->base, (unsigned long)rmem->size / SZ_1M);
 
-	err = dma_heap_cma_register_heap(cma);
-	if (err)
+	ret = dma_heap_cma_register_heap(cma);
+	if (ret)
 		pr_warn("Couldn't register CMA heap.");
 
 	return 0;
 }
 
 static const struct reserved_mem_ops rmem_cma_ops = {
+	.node_validate  = rmem_cma_validate,
+	.node_fixup	= rmem_cma_fixup,
 	.node_init	= rmem_cma_setup,
 	.device_init	= rmem_cma_device_init,
 	.device_release = rmem_cma_device_release,
-- 
2.34.1


