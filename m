Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1C9DFEA837
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11826B0093; Wed, 25 Mar 2026 05:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99EE36B008C; Wed, 25 Mar 2026 05:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 755226B0096; Wed, 25 Mar 2026 05:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 605DD6B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:00:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9A1C1407EF
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:35 +0000 (UTC)
X-FDA: 84583989630.03.9AF4546
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2AC2F40009
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=TzvwX4sC;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf07.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429233; a=rsa-sha256;
	cv=none;
	b=sWydwbIEPzybcyEPcVxDu0xlvGpQrT+aIVWmsM3hL6QFQA9HdZ/MJb5wxuyBk6cADHcpWS
	zOqh71DpR4mF0Y6PswUykdrdmwOxpPqBia0RIuJ3eTF8L1QLfV7xWqLGW8zdedCJMQybsW
	qE5CtguO2+qmtNRHM2W9UCfAeIrtHmQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=TzvwX4sC;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf07.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBpVBJJsPxI1z83r19rYloW28Padt8vaPhBGoBUPBQY=;
	b=WnDQDsdzxIyMtV2XOTIQXTGecRqH10O9QrA1jC7xh0/IRoCGBqJh/vWm8cICLwXuTvCfd0
	xzs4M8/SwSs3fncQKCQCvOXBEPbffQxEN+frd2Mn8TCOU0YXRg5hztMNTZm0Gum84iUrJy
	6b3n7OqD1KtqNaDAaCrnuf+SxBOo/UA=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260325090031euoutp02d8af75a7596fa9bbe426ed1b98bd83b6~gCfv4_KAt0097400974euoutp02H
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260325090031euoutp02d8af75a7596fa9bbe426ed1b98bd83b6~gCfv4_KAt0097400974euoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774429231;
	bh=pBpVBJJsPxI1z83r19rYloW28Padt8vaPhBGoBUPBQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzvwX4sCOSN3wSem6qwQcGuwapILn0/bg8M5UcV5IGCZBmFALcAQglB55zUEX6+Zr
	 ko7p+vV4/ezmsc8VNpOVTeza7udxunOXqLM8eEfMri8tjvIQV2+QHTIUHAj6BafcuD
	 m1nLa9F3fbrjXCclLi871hfqAViLHeKvSfD4mekU=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260325090030eucas1p1a01261214ddb330f8590c7106f2980e5~gCfvlCRYU0363803638eucas1p1C;
	Wed, 25 Mar 2026 09:00:30 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260325090030eusmtip1b151172284a8a012bb01ff14122774f6~gCfvCBeY40388903889eusmtip1o;
	Wed, 25 Mar 2026 09:00:30 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Saravana Kannan
	<saravanak@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Robin
	Murphy <robin.murphy@arm.com>
Subject: [PATCH v3 1/7] of: reserved_mem: remove fdt node from the structure
Date: Wed, 25 Mar 2026 10:00:17 +0100
Message-Id: <20260325090023.3175348-2-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260325090023.3175348-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260325090030eucas1p1a01261214ddb330f8590c7106f2980e5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260325090030eucas1p1a01261214ddb330f8590c7106f2980e5
X-EPHeader: CA
X-CMS-RootMailID: 20260325090030eucas1p1a01261214ddb330f8590c7106f2980e5
References: <20260325090023.3175348-1-m.szyprowski@samsung.com>
	<CGME20260325090030eucas1p1a01261214ddb330f8590c7106f2980e5@eucas1p1.samsung.com>
X-Rspamd-Queue-Id: 2AC2F40009
X-Stat-Signature: n4fneqiy6zgzgr56aakcqtr37fm7z9g3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774429232-138026
X-HE-Meta: U2FsdGVkX19pz8eOgak5hjQbTIT0Zk7MnHt7etawf8aN5p1apHrr8WO1xNZGP9WJqTmXwwlZwciROJnvmE5cvDtF31l68h+8djpc7Ib52HVlT0HK5eSV8LRi37r2EYLID9edtA17EfhyGgjjYudLC8JEVKR3z+DaLNRtXXRVn+NWBKT7VIwqDV3Rx4BTV/S85iJZtc3s+H4/3ZwlCKuArNVZNxy+UkglsYI55Kc6EPYQFkon/xDtAax6LhZNruWV3JtkhwatNtT0kt8eCo4EjAXFPB0z66sjPp6m+8IhjGNcC6i+p/1v0aXTZTwJV5WFGPPf3vYDho3FTS3FTuhZ+XvTkjB7sLWtqzuByVnGWInx5AVhfBTUTEl7MqCNSSsjgZ4K1VkwRYb5csiDokv8NMaNbkroG2HuSiK2KB3G63GSOEsAKUsBR+EE0tFSGXU88KzbijrurJD/eVASL3EKGk7Q8EQJxeEuXfyNUfAg8Pq4oK4z68EbF1vaipmAHHKa+9Qt88Cz+qiQiDey42bPiy0myE0A9GoYRC2cKBnwkbiQpI6nx6VZ3fdCh0sWNAm+oMjiEO1iU82rCmsvCGgCZsePgkFwJCAlmubHF/qSP7RHA5/cFNUoKlLYCzh0jq7pUr+I3oNctMfdFrwtB0EMqlDdz6et6UcNDAXLiSSNUyk+HCle3d1eNS40SS3s4oggMnRj1tENEphPIaPLgmvWYCzk6xi3f+rXIRgyNKd3wexzJ7OSVeV6fZo+H8buF6bQxsZUSau1l+hnfXC8dVF3DWk4WyegKb8pNQlGOPz0hCqWUl8P3LlSYDMpzh41Ic1bo1zxeFzMIte62IzVtT79h9Nub2xQQS/J7u5/g4eBYKenyEXKsqwrm5iNvyaUXx6dd+SPrShT/MsoTl6QtR3GynvmSK7M5XmZGPS1NhuURjwxtNNOxp+9750llpsUdvror8vR4DZLQbrE7h1aD0B
 d0GIyYrh
 X/uIyizaGsw1j4UPK88TDpoUTAykxbol6YBczpor6nHTNkM5vq2d9hzEtlq5f0afqKhwm+htL5vDdGKM2nxeSe8mlwHTAfNMzqPuIYS3Sv4NNaBPHFdnZdkTiFEUA0crKgwcY8zr0PiMXP00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FDT node is not needed for anything besides the initialization, so it can
be simply passed as an argument to the reserved memory region init
function.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/memory/tegra/tegra210-emc-table.c |  3 ++-
 drivers/of/of_reserved_mem.c              | 25 ++++++++++-------------
 include/linux/of_reserved_mem.h           |  4 ++--
 kernel/dma/coherent.c                     |  4 +---
 kernel/dma/contiguous.c                   |  3 +--
 kernel/dma/swiotlb.c                      |  5 ++---
 6 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/memory/tegra/tegra210-emc-table.c b/drivers/memory/tegra/tegra210-emc-table.c
index 34a8785d2861..ac1d1e13482a 100644
--- a/drivers/memory/tegra/tegra210-emc-table.c
+++ b/drivers/memory/tegra/tegra210-emc-table.c
@@ -75,7 +75,8 @@ static const struct reserved_mem_ops tegra210_emc_table_ops = {
 	.device_release = tegra210_emc_table_device_release,
 };
 
-static int tegra210_emc_table_init(struct reserved_mem *rmem)
+static int tegra210_emc_table_init(unsigned long node,
+				   struct reserved_mem *rmem)
 {
 	pr_debug("Tegra210 EMC table at %pa, size %lu bytes\n", &rmem->base,
 		 (unsigned long)rmem->size);
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 1fd28f805610..6705b7afebf0 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -104,7 +104,8 @@ static void __init alloc_reserved_mem_array(void)
 	reserved_mem = new_array;
 }
 
-static void __init fdt_init_reserved_mem_node(struct reserved_mem *rmem);
+static void __init fdt_init_reserved_mem_node(struct reserved_mem *rmem,
+					      unsigned long node);
 /*
  * fdt_reserved_mem_save_node() - save fdt node for second pass initialization
  */
@@ -118,13 +119,12 @@ static void __init fdt_reserved_mem_save_node(unsigned long node, const char *un
 		return;
 	}
 
-	rmem->fdt_node = node;
 	rmem->name = uname;
 	rmem->base = base;
 	rmem->size = size;
 
 	/* Call the region specific initialization function */
-	fdt_init_reserved_mem_node(rmem);
+	fdt_init_reserved_mem_node(rmem, node);
 
 	reserved_mem_count++;
 }
@@ -483,7 +483,8 @@ static const struct of_device_id __rmem_of_table_sentinel
 /*
  * __reserved_mem_init_node() - call region specific reserved memory init code
  */
-static int __init __reserved_mem_init_node(struct reserved_mem *rmem)
+static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
+					   unsigned long node)
 {
 	extern const struct of_device_id __reservedmem_of_table[];
 	const struct of_device_id *i;
@@ -493,10 +494,10 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem)
 		reservedmem_of_init_fn initfn = i->data;
 		const char *compat = i->compatible;
 
-		if (!of_flat_dt_is_compatible(rmem->fdt_node, compat))
+		if (!of_flat_dt_is_compatible(node, compat))
 			continue;
 
-		ret = initfn(rmem);
+		ret = initfn(node, rmem);
 		if (ret == 0) {
 			pr_info("initialized node %s, compatible id %s\n",
 				rmem->name, compat);
@@ -526,11 +527,6 @@ static int __init __rmem_cmp(const void *a, const void *b)
 	if (ra->size > rb->size)
 		return 1;
 
-	if (ra->fdt_node < rb->fdt_node)
-		return -1;
-	if (ra->fdt_node > rb->fdt_node)
-		return 1;
-
 	return 0;
 }
 
@@ -564,19 +560,20 @@ static void __init __rmem_check_for_overlap(void)
 /**
  * fdt_init_reserved_mem_node() - Initialize a reserved memory region
  * @rmem: reserved_mem struct of the memory region to be initialized.
+ * @node: fdt node of the initialized region
  *
  * This function is used to call the region specific initialization
  * function for a reserved memory region.
  */
-static void __init fdt_init_reserved_mem_node(struct reserved_mem *rmem)
+static void __init fdt_init_reserved_mem_node(struct reserved_mem *rmem,
+					      unsigned long node)
 {
-	unsigned long node = rmem->fdt_node;
 	int err = 0;
 	bool nomap;
 
 	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
 
-	err = __reserved_mem_init_node(rmem);
+	err = __reserved_mem_init_node(rmem, node);
 	if (err != 0 && err != -ENOENT) {
 		pr_info("node %s compatible matching fail\n", rmem->name);
 		if (nomap)
diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
index f573423359f4..5159938bfe03 100644
--- a/include/linux/of_reserved_mem.h
+++ b/include/linux/of_reserved_mem.h
@@ -11,7 +11,6 @@ struct resource;
 
 struct reserved_mem {
 	const char			*name;
-	unsigned long			fdt_node;
 	const struct reserved_mem_ops	*ops;
 	phys_addr_t			base;
 	phys_addr_t			size;
@@ -25,7 +24,8 @@ struct reserved_mem_ops {
 				  struct device *dev);
 };
 
-typedef int (*reservedmem_of_init_fn)(struct reserved_mem *rmem);
+typedef int (*reservedmem_of_init_fn)(unsigned long node,
+				      struct reserved_mem *rmem);
 
 #ifdef CONFIG_OF_RESERVED_MEM
 
diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
index 1147497bc512..34621acbd3c5 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -367,10 +367,8 @@ static const struct reserved_mem_ops rmem_dma_ops = {
 	.device_release	= rmem_dma_device_release,
 };
 
-static int __init rmem_dma_setup(struct reserved_mem *rmem)
+static int __init rmem_dma_setup(unsigned long node, struct reserved_mem *rmem)
 {
-	unsigned long node = rmem->fdt_node;
-
 	if (of_get_flat_dt_prop(node, "reusable", NULL))
 		return -EINVAL;
 
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index c56004d314dc..81a2fa4971ee 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -475,9 +475,8 @@ static const struct reserved_mem_ops rmem_cma_ops = {
 	.device_release = rmem_cma_device_release,
 };
 
-static int __init rmem_cma_setup(struct reserved_mem *rmem)
+static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
 {
-	unsigned long node = rmem->fdt_node;
 	bool default_cma = of_get_flat_dt_prop(node, "linux,cma-default", NULL);
 	struct cma *cma;
 	int err;
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 487dcf73b88d..2f53d8c599d1 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -1882,10 +1882,9 @@ static const struct reserved_mem_ops rmem_swiotlb_ops = {
 	.device_release = rmem_swiotlb_device_release,
 };
 
-static int __init rmem_swiotlb_setup(struct reserved_mem *rmem)
+static int __init rmem_swiotlb_setup(unsigned long node,
+				     struct reserved_mem *rmem)
 {
-	unsigned long node = rmem->fdt_node;
-
 	if (of_get_flat_dt_prop(node, "reusable", NULL) ||
 	    of_get_flat_dt_prop(node, "linux,cma-default", NULL) ||
 	    of_get_flat_dt_prop(node, "linux,dma-default", NULL) ||
-- 
2.34.1


