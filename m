Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D763FEA833
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35E0D6B0092; Wed, 25 Mar 2026 05:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3361A6B0095; Wed, 25 Mar 2026 05:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24CAA6B0098; Wed, 25 Mar 2026 05:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 129FB6B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:00:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A79938C465
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:36 +0000 (UTC)
X-FDA: 84583989672.12.C18D9B6
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6592BC0015
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Rlvk+wjg;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf10.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429234; a=rsa-sha256;
	cv=none;
	b=UZc3zAc+KVHC34maMIWe/VX70aPPVzs2a8qDWzIBa3l+jcf71ifFTbDh1Up4UlPEoTv+UB
	rKwFLSvjC8XSpUwCyLMQIq5CPFDU7NBZAX3FbFrYl0A9G4yVfr+4cBu5FremQh3relwWYa
	S1BcOVVzEZo6RvfY5y/b1/qp4UXzFpQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Rlvk+wjg;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf10.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pOJryLnOtYsywUhUMvO96tgOjruDrEYpbGDb5AdNkWs=;
	b=io4Q/1IjVGwSySj8D4HpNhhBzUVLu03OOs3dc55YCBA3PB1e73L/FWsMZ78MgCfE4robGS
	8vIR9HniaFPe4eXxei05b4tDE+wQcn2N6bOCXnUHAo8ZtUmNRIq1apBYPOaslgGWf2LfV2
	v0JVv7HWij3EnI9jmtObevsrqou9uDo=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260325090033euoutp0276741674019dce49f8534e7f5bb320d3~gCfxysE890087600876euoutp02c
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260325090033euoutp0276741674019dce49f8534e7f5bb320d3~gCfxysE890087600876euoutp02c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774429233;
	bh=pOJryLnOtYsywUhUMvO96tgOjruDrEYpbGDb5AdNkWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rlvk+wjgyCYtCSxN5Tk+vIePDGniDV9lB5uQekzbWGFTqhfwnMUJq5rL9tZuWFCLu
	 otuFRHFaRIY22AWjR13DlgyOCPZSJ8cl4+0gkx/xTUP921o4IYNxbPcmSfVAc2OSyR
	 CFyvEnkGsGiSh34YHRqsLWOxq5BfOjsbhwbj+t4s=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260325090032eucas1p27b9ce5fce5014a7d9d9ef2163f0bffd0~gCfxdRkLL1848518485eucas1p2K;
	Wed, 25 Mar 2026 09:00:32 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260325090032eusmtip12b607a260e827a127ce3c05108bb6768~gCfw7EZwN0388903889eusmtip1r;
	Wed, 25 Mar 2026 09:00:32 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Saravana Kannan
	<saravanak@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Robin
	Murphy <robin.murphy@arm.com>
Subject: [PATCH v3 4/7] of: reserved_mem: replace CMA quirks by generic
 methods
Date: Wed, 25 Mar 2026 10:00:20 +0100
Message-Id: <20260325090023.3175348-5-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260325090023.3175348-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260325090032eucas1p27b9ce5fce5014a7d9d9ef2163f0bffd0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260325090032eucas1p27b9ce5fce5014a7d9d9ef2163f0bffd0
X-EPHeader: CA
X-CMS-RootMailID: 20260325090032eucas1p27b9ce5fce5014a7d9d9ef2163f0bffd0
References: <20260325090023.3175348-1-m.szyprowski@samsung.com>
	<CGME20260325090032eucas1p27b9ce5fce5014a7d9d9ef2163f0bffd0@eucas1p2.samsung.com>
X-Stat-Signature: rx9th7ktqib4cds1dg971mpqkeyhtxpj
X-Rspamd-Queue-Id: 6592BC0015
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774429234-264833
X-HE-Meta: U2FsdGVkX1/eprYTTdzBNio5ZGEdKCMVXF4SSh1DNdvh7XK0JAfUHEPtwUtjjbytUlYkhvkVIHBD5L/aXI+WCNPWsfqC70LRvSYtWbkpVG8M/SmmfFcv6GYoW1+ySnXlOrOBxA6zNE7kGIV+8qjRAZT3EvrI3xD0XLMJgvIbbhg691NucId03jU3mHefQrxdhFvnY8vpSz7flJ9p7Fap/N4uTCCJ3Ovtgf8WGLsK1pw8OwUeRWgyvEqVOt9X8jA2IqMjqXo1E97vZrtKEjLqDThvw5w8ELDwGcIQRrSKYnlGU4TGokAq7o7Ugl4PS6I+HWBNGN9NQMV1Dw/ptSvixpV2L7gah1H1SseFWD67MEYkGg2qHRBW54nongF3RyKmnb8j8s4wFlAMn8z8+pY0tcp1uw839pnGWqQmjr2+Kt/oqNrvWLKWaZrmI6RoKnRz/TUqd9lkkJPGhWqjqbpAeapkz5ye5+9eknrJY5xR17W9A7tVEZfU4+MIsL66nwt4GLiB6Ea+ctEfgPCpX53Nr573kDDHNzkIThf/f4zN3n5RCSQ7B/vGlLgwzCYvfh6hT6FZmKi2pDPRpreZMtHoc5I0fAd+z/XgKxJEHus6godZ7K0AlI9/s63v73V4huO3jgEuPyjOhlQrVBgv9p3B39ye0aewLdZCW0ytmY4UtpHXTj0BVtdRY1F4B6UCyxzvbmoqt/9r6HXsEkhgNrzDqh7HNqnr5DzalAXYH47eOexW8iOk/a55aBFOhj+oyJcFM8nWnRNXSZFOGn3ymNLXwFEWnxQHcHeOv/UbFP1bGwjgBFJ8fa7sfA6H5bN/Fra9tq9MbjHRAjG3QtSvn3gySCqbOmbJNe8patt6X5nHY6WcEIkr2V8v77ioEp6o8XxkKGuMrrdWE43ejOF3UZW28GH22WhNP86e8zO1HQqZfBYGTWJGH81KTBNs/qv1ov9SpvSw6yKNMYmhLdW7V8M
 pdjIlU8i
 7FtSSZL54WkW41RCMwRXi7GSl7McyHzNoix4VwG4dGsupLRrBoHkIc3kARLI1jDUUVcqgGJDRvDLgT2bNkOI9dI0Ej68ZOXyfp6MSeM05voI33Xe9NsjNMxOMzFeaVDqResNF3oPv/PUVo90Mcyo+GmTp9aYaeorgnb9fBzW5tCz4ykUf7tJT8oTd2g5cMUM1QuHVkDS41ZFfRPXYa3hzFqyk18xS/R+ePA57uiWYEFmANIsSXqwCluJCnYsFsbfjOayv
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
 drivers/of/of_reserved_mem.c    | 118 ++++++++++++++++++++++----------
 include/linux/cma.h             |  10 ---
 include/linux/dma-map-ops.h     |   3 -
 include/linux/of_reserved_mem.h |   3 +
 kernel/dma/contiguous.c         |  70 ++++++++++++++-----
 5 files changed, 137 insertions(+), 67 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 4dd0d6f6a4b0..5dd585bcf8a8 100644
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
 
+		ret = fdt_validate_reserved_mem_node(child, NULL);
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
-
-	if (default_cma && cma_skip_dt_default_reserved_mem()) {
-		pr_err("Skipping dt linux,cma-default for \"cma=\" kernel param.\n");
-		return -EINVAL;
-	}
 
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
@@ -468,18 +459,76 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
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
 
+/**
+ * fdt_fixup_reserved_mem_node() - call fixup function for a reserved memory node
+ * @node: FDT node to fixup
+ * @base: base address of the reserved memory region
+ * @size: size of the reserved memory region
+ *
+ * This function iterates through the reserved memory drivers and calls
+ * the node_fixup callback for the compatible entry matching the node.
+ *
+ * Return: 0 on success, -ENODEV if no compatible match found
+ */
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
+/**
+ * fdt_validate_reserved_mem_node() - validate a reserved memory node
+ * @node: FDT node to validate
+ * @align: pointer to store the validated alignment (may be modified by callback)
+ *
+ * This function iterates through the reserved memory drivers and calls
+ * the node_validate callback for the compatible entry matching the node.
+ *
+ * Return: 0 on success, -ENODEV if no compatible match found
+ */
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
 /**
  * __reserved_mem_init_node() - initialize a reserved memory region
  * @rmem: reserved_mem structure to initialize
@@ -494,7 +543,6 @@ static const struct of_device_id __rmem_of_table_sentinel
 static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
 					   unsigned long node)
 {
-	extern const struct of_device_id __reservedmem_of_table[];
 	const struct of_device_id *i;
 	int ret = -ENODEV;
 
@@ -511,7 +559,7 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
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
index 8a07df5a9ef6..d0642a6bc985 100644
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
index 747a1e73d5dd..e8b20b29fa68 100644
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


