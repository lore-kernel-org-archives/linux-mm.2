Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A9EFEA837
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D53F06B008C; Wed, 25 Mar 2026 05:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0DAF6B0092; Wed, 25 Mar 2026 05:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ED2B6B0092; Wed, 25 Mar 2026 05:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6215B6B0093
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:00:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28A221407F8
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:36 +0000 (UTC)
X-FDA: 84583989672.16.B929DA1
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf09.hostedemail.com (Postfix) with ESMTP id DE74E140018
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=gxSREEvd;
	spf=pass (imf09.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wwurihy1qMKafazYkjQUEhOehZg0+KQHoNwHol2qBYc=;
	b=Fy74Gd6Z/9jjYTLp1DQpmkvN/LUUfPZX2vvI6YUE5wUUifpHx9XPqNJgOJlXvkkCeXv/bj
	Cruc9W6om26kI0042WM9ITwcLcAznprJu3tkH/fjqem+QwGblDBiaiyvkJFxmQ+EeXfu3b
	8I3lXJTiGAWcgXgKsdBeuxwqLxQwDxY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=gxSREEvd;
	spf=pass (imf09.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429234; a=rsa-sha256;
	cv=none;
	b=HpBtrD372p1ZMux16ErQ/omgGOo8dxtZLAgt+z9H/EBPWyyITAqZMg4p+E42fvBShvQnR2
	JZz2QNUSL8poQ+quRLK4OaDie3idPo5xI1nN39Wzcx8c68v4oOIm6Q0XHZJLWIdvYFyueS
	yPzvhafGi3adwUuUJF63u3SkiG/5thU=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260325090032euoutp023c9bc71eba0b6327797a2ad17054f892~gCfxM-PC00087600876euoutp02a
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260325090032euoutp023c9bc71eba0b6327797a2ad17054f892~gCfxM-PC00087600876euoutp02a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774429232;
	bh=wwurihy1qMKafazYkjQUEhOehZg0+KQHoNwHol2qBYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxSREEvdokyuM4SJvoYNxRBCw5lJqnKxsVDEvWM8vPv+T0ROzMuuoUJpSVYpaS58c
	 Y8AwYTshgbVkhx1d2g5lOXTl51tvwt0eyQioLsQNKunLt3jhQVTQkqE+Z672ZdpERL
	 yC0g5fL8R1nNpgjHlQzpfEg3CwvoujmFLw42FFo8=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260325090032eucas1p1bf0dfc6d73868e576d829d9d2208672b~gCfw1aKZu1802018020eucas1p1t;
	Wed, 25 Mar 2026 09:00:32 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260325090031eusmtip187bfb06cefb9c4211a0093e10bb3ac8a~gCfwSg-9U3134631346eusmtip1N;
	Wed, 25 Mar 2026 09:00:31 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Saravana Kannan
	<saravanak@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Robin
	Murphy <robin.murphy@arm.com>
Subject: [PATCH v3 3/7] of: reserved_mem: switch to ops based OF_DECLARE()
Date: Wed, 25 Mar 2026 10:00:19 +0100
Message-Id: <20260325090023.3175348-4-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260325090023.3175348-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260325090032eucas1p1bf0dfc6d73868e576d829d9d2208672b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260325090032eucas1p1bf0dfc6d73868e576d829d9d2208672b
X-EPHeader: CA
X-CMS-RootMailID: 20260325090032eucas1p1bf0dfc6d73868e576d829d9d2208672b
References: <20260325090023.3175348-1-m.szyprowski@samsung.com>
	<CGME20260325090032eucas1p1bf0dfc6d73868e576d829d9d2208672b@eucas1p1.samsung.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: DE74E140018
X-Stat-Signature: btrqb3868oyphxn1j87fhbbheyctirbg
X-Rspamd-Server: rspam06
X-HE-Tag: 1774429233-600499
X-HE-Meta: U2FsdGVkX18NOEWDWOaXrwhcY51EeLq+vf7fmGe2eCzVRhwu6fJmrssxvANC9fL2LaxZO7gdWYS+cu6weIZPjNwXHDR5GBlHftAi4iGiBq5DHPwpKO/ntLWD6wrBlqYUhZzMTUqNwZColS6G/quyqNQPWjpXdLjpr3+EklDfFgSKbINTJU0xVh9WBdG4XviQQs4Nc8qq22r1xhDZfLHKzoHYS7nUvKnjsSTCsbVFn5GjAWY3hvWT8GwNCzMJbLNcZHdHaW6d/6hZepg8+YZnk8e0Gf+IYUG/cy7XPFsBFhRmrCoSjIuxkVKy7h9MxhOr6g2akoaUY+c9DAjKdmpOBcfbhK9WgzRDCJXeNArOyYYsdhNXkRRJaLAlB6bEpixM+DpiY2FpnjIc0ehoQhofh5ZKMKK+yv9WOYanMbRuV5Kbeav5Jxk2JJj6ECGCqKSWbS5zJCUBTXEJIChANfnVVV8YQgTG/qZmIFLHpbvDVQpeYTHlptaUxx2vIU8vN5eveLXld383FCwHl2/R586FvPb8bY9C+6h+2OPzBqLGI2Cavl/laIJp8Org/Vh3Ii+PR2DnAGEhaLsNN3JPzr+gjdnUCsiHopufyyoe2R6GSew+vxg/gPzDSz89zyt7N6vcPBY5WQ0bilHnj4J+/URSuDcoArqJ2LcW/g9aENEoHeGzpGr0utPAN0Qo7fkJvD79AD4/TmK/2FKnLjRgFRwzXrkjm9WvhPJf89djOCFCMNQOkqC/29zlmF4p1UlQn5fGhmbd5xSN7Wpwx1z8BjoCpedYRwbtTli9CuxH+waRHDqSz98B+dAGnUEMcB/jHLeZfuAp6R3A/RHsfEEuECjv2vI3GJyLPw5xl/pbnSUaREokLmeBn0t7TkZZKSntrTTF/FrGi8htMRtqn/7A1eO6f8iHU3NaqX+0zm7DmkD3tYefGBulFecGouP2u65sUTWX1A9ZvH2GpFubbo0rh0a
 pwp+gfVy
 vvQmcNCcEg09l59ZySrfLGusnnxR8KMpgxKKaNgRfNWYk/eO1q/WL5UHEJgxNiCs+lFapatrA6k28GW3Og6ZG4iGPcSQxGIQGZQGrehLIHa2aOgSRB/F7/G+yuP5tPPeLEEU9gHABWoV4rxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move init function from OF_DECLARE() argument to the given reserved
memory region ops structure and then pass that structure to the
OF_DECLARE() initializer. This node_init callback is mandatory for the
reserved mem driver. Such change makes it possible in the future to add
more functions called by the generic code before given memory region is
initialized and rmem object is created.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/memory/tegra/tegra210-emc-table.c | 16 ++++++++--------
 drivers/of/of_reserved_mem.c              | 17 +++++++++++++----
 include/linux/of_reserved_mem.h           | 13 ++++++-------
 kernel/dma/coherent.c                     | 13 +++++++------
 kernel/dma/contiguous.c                   | 15 ++++++++-------
 kernel/dma/swiotlb.c                      | 14 +++++++-------
 6 files changed, 49 insertions(+), 39 deletions(-)

diff --git a/drivers/memory/tegra/tegra210-emc-table.c b/drivers/memory/tegra/tegra210-emc-table.c
index ac1d1e13482a..4b3c478b2743 100644
--- a/drivers/memory/tegra/tegra210-emc-table.c
+++ b/drivers/memory/tegra/tegra210-emc-table.c
@@ -70,20 +70,20 @@ static void tegra210_emc_table_device_release(struct reserved_mem *rmem,
 	memunmap(timings);
 }
 
-static const struct reserved_mem_ops tegra210_emc_table_ops = {
-	.device_init = tegra210_emc_table_device_init,
-	.device_release = tegra210_emc_table_device_release,
-};
-
 static int tegra210_emc_table_init(unsigned long node,
 				   struct reserved_mem *rmem)
 {
 	pr_debug("Tegra210 EMC table at %pa, size %lu bytes\n", &rmem->base,
 		 (unsigned long)rmem->size);
 
-	rmem->ops = &tegra210_emc_table_ops;
-
 	return 0;
 }
+
+static const struct reserved_mem_ops tegra210_emc_table_ops = {
+	.node_init = tegra210_emc_table_init,
+	.device_init = tegra210_emc_table_device_init,
+	.device_release = tegra210_emc_table_device_release,
+};
+
 RESERVEDMEM_OF_DECLARE(tegra210_emc_table, "nvidia,tegra210-emc-table",
-		       tegra210_emc_table_init);
+		       &tegra210_emc_table_ops);
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 9aff460a0420..4dd0d6f6a4b0 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -480,8 +480,16 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
 static const struct of_device_id __rmem_of_table_sentinel
 	__used __section("__reservedmem_of_table_end");
 
-/*
- * __reserved_mem_init_node() - call region specific reserved memory init code
+/**
+ * __reserved_mem_init_node() - initialize a reserved memory region
+ * @rmem: reserved_mem structure to initialize
+ * @node: FDT node describing the reserved memory region
+ *
+ * This function iterates through the reserved memory drivers and calls the
+ * node_init callback for the compatible entry matching the node. On success,
+ * the operations pointer is stored in the reserved_mem structure.
+ *
+ * Return: 0 on success, -ENODEV if no compatible match found
  */
 static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
 					   unsigned long node)
@@ -492,14 +500,15 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
 
 	for (i = __reservedmem_of_table; ret == -ENODEV &&
 	     i < &__rmem_of_table_sentinel; i++) {
-		reservedmem_of_init_fn initfn = i->data;
+		const struct reserved_mem_ops *ops = i->data;
 		const char *compat = i->compatible;
 
 		if (!of_flat_dt_is_compatible(node, compat))
 			continue;
 
-		ret = initfn(node, rmem);
+		ret = ops->node_init(node, rmem);
 		if (ret == 0) {
+			rmem->ops = ops;
 			pr_info("initialized node %s, compatible id %s\n",
 				rmem->name, compat);
 			break;
diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
index 5159938bfe03..747a1e73d5dd 100644
--- a/include/linux/of_reserved_mem.h
+++ b/include/linux/of_reserved_mem.h
@@ -18,19 +18,17 @@ struct reserved_mem {
 };
 
 struct reserved_mem_ops {
+	int	(*node_init)(unsigned long fdt_node, struct reserved_mem *rmem);
 	int	(*device_init)(struct reserved_mem *rmem,
 			       struct device *dev);
 	void	(*device_release)(struct reserved_mem *rmem,
 				  struct device *dev);
 };
 
-typedef int (*reservedmem_of_init_fn)(unsigned long node,
-				      struct reserved_mem *rmem);
-
 #ifdef CONFIG_OF_RESERVED_MEM
 
-#define RESERVEDMEM_OF_DECLARE(name, compat, init)			\
-	_OF_DECLARE(reservedmem, name, compat, init, reservedmem_of_init_fn)
+#define RESERVEDMEM_OF_DECLARE(name, compat, ops)			\
+	_OF_DECLARE(reservedmem, name, compat, ops, struct reserved_mem_ops *)
 
 int of_reserved_mem_device_init_by_idx(struct device *dev,
 				       struct device_node *np, int idx);
@@ -48,8 +46,9 @@ int of_reserved_mem_region_count(const struct device_node *np);
 
 #else
 
-#define RESERVEDMEM_OF_DECLARE(name, compat, init)			\
-	_OF_DECLARE_STUB(reservedmem, name, compat, init, reservedmem_of_init_fn)
+#define RESERVEDMEM_OF_DECLARE(name, compat, ops)			\
+	_OF_DECLARE_STUB(reservedmem, name, compat, ops,		\
+			 struct reserved_mem_ops *)
 
 static inline int of_reserved_mem_device_init_by_idx(struct device *dev,
 					struct device_node *np, int idx)
diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
index 64f9ba618e19..bcdc0f76d2e8 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -362,10 +362,6 @@ static void rmem_dma_device_release(struct reserved_mem *rmem,
 		dev->dma_mem = NULL;
 }
 
-static const struct reserved_mem_ops rmem_dma_ops = {
-	.device_init	= rmem_dma_device_init,
-	.device_release	= rmem_dma_device_release,
-};
 
 static int __init rmem_dma_setup(unsigned long node, struct reserved_mem *rmem)
 {
@@ -388,7 +384,6 @@ static int __init rmem_dma_setup(unsigned long node, struct reserved_mem *rmem)
 	}
 #endif
 
-	rmem->ops = &rmem_dma_ops;
 	pr_info("Reserved memory: created DMA memory pool at %pa, size %ld MiB\n",
 		&rmem->base, (unsigned long)rmem->size / SZ_1M);
 	return 0;
@@ -405,5 +400,11 @@ static int __init dma_init_reserved_memory(void)
 core_initcall(dma_init_reserved_memory);
 #endif /* CONFIG_DMA_GLOBAL_POOL */
 
-RESERVEDMEM_OF_DECLARE(dma, "shared-dma-pool", rmem_dma_setup);
+static const struct reserved_mem_ops rmem_dma_ops = {
+	.node_init	= rmem_dma_setup,
+	.device_init	= rmem_dma_device_init,
+	.device_release	= rmem_dma_device_release,
+};
+
+RESERVEDMEM_OF_DECLARE(dma, "shared-dma-pool", &rmem_dma_ops);
 #endif
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index e6fc6906b5c0..efeebda92537 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -470,11 +470,6 @@ static void rmem_cma_device_release(struct reserved_mem *rmem,
 	dev->cma_area = NULL;
 }
 
-static const struct reserved_mem_ops rmem_cma_ops = {
-	.device_init	= rmem_cma_device_init,
-	.device_release = rmem_cma_device_release,
-};
-
 static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
 {
 	bool default_cma = of_get_flat_dt_prop(node, "linux,cma-default", NULL);
@@ -499,7 +494,6 @@ static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
 	if (default_cma)
 		dma_contiguous_default_area = cma;
 
-	rmem->ops = &rmem_cma_ops;
 	rmem->priv = cma;
 
 	pr_info("Reserved memory: created CMA memory pool at %pa, size %ld MiB\n",
@@ -511,5 +505,12 @@ static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
 
 	return 0;
 }
-RESERVEDMEM_OF_DECLARE(cma, "shared-dma-pool", rmem_cma_setup);
+
+static const struct reserved_mem_ops rmem_cma_ops = {
+	.node_init	= rmem_cma_setup,
+	.device_init	= rmem_cma_device_init,
+	.device_release = rmem_cma_device_release,
+};
+
+RESERVEDMEM_OF_DECLARE(cma, "shared-dma-pool", &rmem_cma_ops);
 #endif
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 2f53d8c599d1..9a15e7231e39 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -1877,11 +1877,6 @@ static void rmem_swiotlb_device_release(struct reserved_mem *rmem,
 	dev->dma_io_tlb_mem = &io_tlb_default_mem;
 }
 
-static const struct reserved_mem_ops rmem_swiotlb_ops = {
-	.device_init = rmem_swiotlb_device_init,
-	.device_release = rmem_swiotlb_device_release,
-};
-
 static int __init rmem_swiotlb_setup(unsigned long node,
 				     struct reserved_mem *rmem)
 {
@@ -1891,11 +1886,16 @@ static int __init rmem_swiotlb_setup(unsigned long node,
 	    of_get_flat_dt_prop(node, "no-map", NULL))
 		return -EINVAL;
 
-	rmem->ops = &rmem_swiotlb_ops;
 	pr_info("Reserved memory: created restricted DMA pool at %pa, size %ld MiB\n",
 		&rmem->base, (unsigned long)rmem->size / SZ_1M);
 	return 0;
 }
 
-RESERVEDMEM_OF_DECLARE(dma, "restricted-dma-pool", rmem_swiotlb_setup);
+static const struct reserved_mem_ops rmem_swiotlb_ops = {
+	.node_init = rmem_swiotlb_setup,
+	.device_init = rmem_swiotlb_device_init,
+	.device_release = rmem_swiotlb_device_release,
+};
+
+RESERVEDMEM_OF_DECLARE(dma, "restricted-dma-pool", &rmem_swiotlb_ops);
 #endif /* CONFIG_DMA_RESTRICTED_POOL */
-- 
2.34.1


