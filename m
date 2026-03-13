Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 474FE105F7B3
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 15:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E1B96B008C; Fri, 13 Mar 2026 11:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36A126B0089; Fri, 13 Mar 2026 11:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203BA6B0093; Fri, 13 Mar 2026 11:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2EC6B008A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:08:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 87968140220
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:15 +0000 (UTC)
X-FDA: 84541370550.16.E36FE02
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2EBBE180009
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=rW4s6P50;
	spf=pass (imf06.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773414493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6WjlAYerVq6d8qF1cWBAuX5UyfsvgD0ELY2Xcbrhso=;
	b=UoGbIyG2ggQbh+FuVU4mfxacHyTspCWi1F+Pqv4nlAyzRCJQKOAJCv0VR2Z/6jc74HudEN
	a0SyIVa5ECxt6Z+Wgy9us48qHbTZadP+wbiAVBTW8pUbeCgykxM5IPuoh5IEGTaqB5xLdE
	zfcR1AoLFtO3ZQxYG7D6PhETGrIGgV8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=rW4s6P50;
	spf=pass (imf06.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773414493; a=rsa-sha256;
	cv=none;
	b=SBYJR+kfDPH3FVUzpV+tGc8FZpEaRDdiliS88Wi85Ds1nNBF9rI5EbUXEPqzjGRBtwOzEc
	AcD4RsypAD4NwV0lUQ6TKtvMO34ZfUhbW7WC80ewnFzzruX6FYQHv6dbaRbrrqJZsv5YZP
	qPz7I84rDvUmlMTtwuZwuV6oHKf3Ke8=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260313150810euoutp02e3de50c387bf727447e0e6e51bc53685~cbxVQWQ7d0455204552euoutp02B
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260313150810euoutp02e3de50c387bf727447e0e6e51bc53685~cbxVQWQ7d0455204552euoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773414490;
	bh=/6WjlAYerVq6d8qF1cWBAuX5UyfsvgD0ELY2Xcbrhso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rW4s6P50INwREzpBu26IiQwHDj9/QG2gy8UXhXggQ+JvTb5trxzzfEt0LVMj13ebe
	 yrhraeKI6APXLPizdsCmchIpDUoRuiLvONtWViDS9A07bF+SEBw9eW+ZDCDAWAvIk0
	 vLWWw+gxRGwPTbN5heJ+xjcN7Rb76FuzhT3LV/lw=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260313150810eucas1p1ecbbe597c5df8aaa2effa3b65c07c6db~cbxU36qoz2822628226eucas1p1-;
	Fri, 13 Mar 2026 15:08:10 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260313150809eusmtip1cf30c32354975e25d44ed1dc4e50cb86~cbxUTC-DF1821718217eusmtip1a;
	Fri, 13 Mar 2026 15:08:09 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Saravana Kannan <saravanak@kernel.org>, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 1/7] of: reserved_mem: remove fdt node from the structure
Date: Fri, 13 Mar 2026 16:07:56 +0100
Message-Id: <20260313150802.1121442-2-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260313150802.1121442-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260313150810eucas1p1ecbbe597c5df8aaa2effa3b65c07c6db
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260313150810eucas1p1ecbbe597c5df8aaa2effa3b65c07c6db
X-EPHeader: CA
X-CMS-RootMailID: 20260313150810eucas1p1ecbbe597c5df8aaa2effa3b65c07c6db
References: <20260313150802.1121442-1-m.szyprowski@samsung.com>
	<CGME20260313150810eucas1p1ecbbe597c5df8aaa2effa3b65c07c6db@eucas1p1.samsung.com>
X-Rspamd-Queue-Id: 2EBBE180009
X-Rspamd-Server: rspam07
X-Stat-Signature: taw3zt3br1eweaxdyq3bwosyy4bg6p99
X-Rspam-User: 
X-HE-Tag: 1773414492-568382
X-HE-Meta: U2FsdGVkX1+/UWu8v3ldSzV2NmG6Z8inuwIty193Bj8iSnijHLVizJkezRO1o3aJaZ3IhlMe7IOJhGkv4q8UMJ1hPx131gWXnOK34Ic4hM99ijbIcwgqf7IHLQ/4wxu352LhUO//GXACs2jhFi+S/zIIPKP1PwjysGgGlFd5ETSleYMcJWxTc3oV43JBE9V6y7fMbBf8gM8ni/4og7IGjCo+nRPbWrlS9VibjYeIA87YTjAtnKWSkyyLfnf424kjOvpKk43WWYJp6Mn6KFSWFWE2/xBqKsOxvk3aANubp+109keshRnwnnv0DeUuRlaC03/lyp4eOyvNdT1YgiLIyAMnHUJ4mvYjeJ/B2YI83RQhZ0fioq5O/zIlDf400OWslbFLruLmvqSCC0rhD5JR/VlNKsgjnKs0XbKBl4XH7m2GjbR1R/e4cHdR2HBa4nxCb14gdyrSLCbs5RHxPvsST1pQKEOvsAjXEnkX2Hc03KXNkHfXwbGiP1uXCUmdik1/ljp1TpYEbJ2ADf4Mi16bbd1QRshlmNjxth3wu3vDKwKR3CeH2q9O0WBPnNVDP2irlMP5gNIn7ECJmtPe7zzvSlnWlqquL9bdsPUGrugihFErtaMgeSryDCXgz6JwmiH+mBa7Q7i8/iIdeDEPbKt3BWMymSuxSpAkR1aR29ZtQOfq4yJrecrlUN1HnUNM9d0NdL5XQ7xary49zUKOaGKqEG7asZWO+SeP4fGXrpv/zFe3L8x1RIXBQWQOr6xyNm2ZrNoZ+Ybe/ktIMruy5uw/+2GbJe1qu/m82b7GyRjeA4zShjSY84KbNkTZV3KNFX6kcKCMF727iR1enX8usbVdD4rFapkTyMCbgfjoKe54qX9OtGV4za8eSBaEm7jt54NwODq4VjaC6hoX8vRXl1vC8L6gen/L10YvhiAqlYTA3SXKtrMQL8XVClnQkb+G8GxZfLz0B9ERa8ATcihp4LG
 5ixMm5HB
 xpdbpvNNwWV4/eIACJVLKvp37A+t42AOB7A7we9oOe+K009wLUqjx/i87oa5P/1uu9Yd6FD1z/01fE1XuWuGDOBQ/LP2Vvrj/FEJ4HN1jeEioZNHNdV6Tzk4PVzd4EXcm0n0xLSw5c43jWQo=
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
index d8e6f1d889d5..f3a12e15a951 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -1860,10 +1860,9 @@ static const struct reserved_mem_ops rmem_swiotlb_ops = {
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


