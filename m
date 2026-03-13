Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A240C105F7B1
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 15:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65B426B008A; Fri, 13 Mar 2026 11:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59D1F6B0095; Fri, 13 Mar 2026 11:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DE926B0092; Fri, 13 Mar 2026 11:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AC406B008C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:08:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3B63B6E9F
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:15 +0000 (UTC)
X-FDA: 84541370550.28.5A3B007
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id B7A081C000F
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=PGHIH7B3;
	spf=pass (imf20.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773414494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/XqjNgnXLnwQUNttN9fPwMdiEkITryUfxyVwTgJAadA=;
	b=7u3uRibjelrDibdvkc3ezLZMJqpEKK5p/cNnjxt+PP/sdcR6bVB2ax5bEmV0aVZvnKzIW4
	XlXH9KQcIb35g8jn1fHmIJjP/59F71gTHC2YhBEmMVZYXb+mkKr+bkyAMA764hU41d7Qma
	99D3ud4CyaZZQohH7WERUe64L+X/lOA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773414494; a=rsa-sha256;
	cv=none;
	b=KEpoNJxac1wDop7H/rufec7GYjG16wHb7RpEF0HIE6dVJ6Q6UcN3CyKpynenzM1AbnDhIo
	aaKZVydJOaUYPkd2EKy914mVSFAL/Zk9wluasLVS6bWekwGFaW53i+iyqQnZYHfUo6n0dW
	a7ohit3N8t+Rny8upB8LjsEpft8ZJRA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=PGHIH7B3;
	spf=pass (imf20.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260313150811euoutp01c5f87add8c1850baf5a911731c967cfd~cbxWZRwlc2073320733euoutp01d
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260313150811euoutp01c5f87add8c1850baf5a911731c967cfd~cbxWZRwlc2073320733euoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773414491;
	bh=/XqjNgnXLnwQUNttN9fPwMdiEkITryUfxyVwTgJAadA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PGHIH7B3EfDts1C/9GoxcIvdzBLMaPWYTBFKSDNFpw5bkJBkxXSVJOxu9BPE1c/YF
	 3bBuEx/dlMQgusg6YInw2N40kgKw4PE89DGD/oIPQXI5gnI2M5MtQ9UEvJUNgFIv8V
	 g+5CQ4WqI65eKifzUJh9OzhpXAiP8ZfY08rAvC2E=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260313150811eucas1p28cd933ea257af5dabaad214618214050~cbxWN5JmX0324903249eucas1p2k;
	Fri, 13 Mar 2026 15:08:11 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260313150811eusmtip1be0da9982f216096defbf6764f793a3f~cbxVo2l8a0224902249eusmtip1O;
	Fri, 13 Mar 2026 15:08:10 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Saravana Kannan <saravanak@kernel.org>, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 3/7] of: reserved_mem: switch to ops based OF_DECLARE()
Date: Fri, 13 Mar 2026 16:07:58 +0100
Message-Id: <20260313150802.1121442-4-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260313150802.1121442-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260313150811eucas1p28cd933ea257af5dabaad214618214050
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260313150811eucas1p28cd933ea257af5dabaad214618214050
X-EPHeader: CA
X-CMS-RootMailID: 20260313150811eucas1p28cd933ea257af5dabaad214618214050
References: <20260313150802.1121442-1-m.szyprowski@samsung.com>
	<CGME20260313150811eucas1p28cd933ea257af5dabaad214618214050@eucas1p2.samsung.com>
X-Rspam-User: 
X-Stat-Signature: ojxz5eqk68x74kwz71q45j94pxhdb9at
X-Rspamd-Queue-Id: B7A081C000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1773414493-68424
X-HE-Meta: U2FsdGVkX18iFzLqyt0OpQrF6ohEKPG33up1eUiy/Q5svUTPgd8F6yPTfSJSoBU6NAhIjjl1f2ksnG9hJUWmZ0+JSDeKFXkFAoSFH+giqcJd45mzoQA+y4o1w1pDAx9kL6rm+IiYtuvdbalQYQ4LCdIuCduaOPNVL7/9k7kkqw9RFpPSxHlyBEh+lZOZlYGo8DveWEB8wHA+HH3ZrVdj9kzfzkgr62QjUQgFEBPFHQaTSTxt34nZKoo2TEDGcPESKoGVLfxw6udSIHiyCBuofasyWotC5UTy3pCzhXPBTSGrwNaqVj4i/+haTXaguZou+9ma7xTaWoHyJeIo3QXuWSS9S6O43dY3pQbgii7biWt75M2lkecKGB+oXsv4ElZjw5JBFt0nNksFkBiW+JxsaqVn95mFAeWS1zj1Nu20pCUSRfYMYH5FOg7Ogw/xDqd0fqpdB1Nk9Dutpp5kLKSJUfmr8hLR+YIFoL/uQBW6WB3QxELNMHIEnt7XIVCiGnwCo0DZ9PaZaa8VqDeH1ZDrJSQ0FMCLZB+CLqCPgDBAj5Nn6CDAfrkW+n0unDBaPMEJ7Xl3zdHi3DCle4LNLz1PUd378buc9l0YWHmAS4Vno7MUI4TcXhRMe6Fz7lvDIxuIqjdM7vDWbbohVSmWovCJWv3rhRZru+1K8lBE9L00Q/Moka9vGIdDT4/c28v0EMATksRRIl18KVJ1fdsdxktFIbgehanzFiIeTgh0L3675bxEwqr7ua87ztVrsHLn12S/kfatK2slyouinHSD1RUD0e2zPrcgKCHerSg1ttwBzEgRGVYFKkpTihpCMcV7Shun3b8aKKC47vaInVk5K5wFoYcVcGmXuh3A5s64MPRBTJih2BuciTkKlJbo/YuZbDZh+VYzdr0kBAAN4tzSsgx0qW0/z7sniI4Zaojg5HSZVtTVzGGtPP1W0/A3EUUqIcH7EsjCix9FZNiZdZQw5aL
 NC0EoNBE
 aMrx+uoTYpVUfH/QBpPs7z0NfY8QwHBpPY3PWuU2FGGi8vB+vzjV+jcVKb4fBSBqMFX/LsgcjTkaUii4PgHcOpJ4wcHn0fW0tE7UxtYTsG81gD3PvAKP5KiKmid3sg/Y6HmuTzgV4n2P9Jv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move init function from OF_DECLARE() argument to the given reserved
memory region ops structure and then pass that structure to the
OF_DECLARE() initializer. This makes it possible in the future to add
more functions called by the generic code before given memory region is
initialized and rmem object created.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/memory/tegra/tegra210-emc-table.c | 14 ++++++++------
 drivers/of/of_reserved_mem.c              |  5 +++--
 include/linux/of_reserved_mem.h           | 15 ++++++++-------
 kernel/dma/coherent.c                     | 13 +++++++------
 kernel/dma/contiguous.c                   | 15 ++++++++-------
 kernel/dma/swiotlb.c                      | 13 +++++++------
 6 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/drivers/memory/tegra/tegra210-emc-table.c b/drivers/memory/tegra/tegra210-emc-table.c
index ac1d1e13482a..f6395bc9dbc8 100644
--- a/drivers/memory/tegra/tegra210-emc-table.c
+++ b/drivers/memory/tegra/tegra210-emc-table.c
@@ -70,11 +70,6 @@ static void tegra210_emc_table_device_release(struct reserved_mem *rmem,
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
@@ -85,5 +80,12 @@ static int tegra210_emc_table_init(unsigned long node,
 
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
index 9aff460a0420..675f1c1c6627 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -492,14 +492,15 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
 
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
index 5159938bfe03..dc00502a6b69 100644
--- a/include/linux/of_reserved_mem.h
+++ b/include/linux/of_reserved_mem.h
@@ -18,19 +18,20 @@ struct reserved_mem {
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
+	static const struct of_device_id __of_table_##name		\
+		__used __section("__reservedmem_of_table")		\
+		__aligned(__alignof__(struct of_device_id))		\
+		 = { .compatible = compat, .data = ops }
 
 int of_reserved_mem_device_init_by_idx(struct device *dev,
 				       struct device_node *np, int idx);
@@ -48,8 +49,8 @@ int of_reserved_mem_region_count(const struct device_node *np);
 
 #else
 
-#define RESERVEDMEM_OF_DECLARE(name, compat, init)			\
-	_OF_DECLARE_STUB(reservedmem, name, compat, init, reservedmem_of_init_fn)
+#define RESERVEDMEM_OF_DECLARE(name, compat, ops)			\
+	_OF_DECLARE_STUB(reservedmem, name, compat, init, void *)
 
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
index f3a12e15a951..327525181b8a 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -1855,11 +1855,6 @@ static void rmem_swiotlb_device_release(struct reserved_mem *rmem,
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
@@ -1875,5 +1870,11 @@ static int __init rmem_swiotlb_setup(unsigned long node,
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


