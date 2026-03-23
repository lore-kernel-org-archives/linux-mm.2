Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C87F7EC01B1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 274436B0005; Mon, 23 Mar 2026 06:09:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D5B6B0088; Mon, 23 Mar 2026 06:09:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EC2F6B0095; Mon, 23 Mar 2026 06:09:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E32D16B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:09:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9304EBC87A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:13 +0000 (UTC)
X-FDA: 84576904986.22.A9F4824
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7833618000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=GPjTyDZU;
	spf=pass (imf06.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774260551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6WjlAYerVq6d8qF1cWBAuX5UyfsvgD0ELY2Xcbrhso=;
	b=UyLheGlKBumNda5SZbcsDmCUgm5Sdxf7FoKa1KQcKpHDWTV9qvfxfRHv02RmybhX8B9fn2
	2jSaeZoRJlMpj3ZTdyGdn149ryAa0w3PrpjxRpOb0eNkQj7cm6HTfgjutR4GhH+J9ENUEp
	jpiSDCsJtGSVjAjeoYkJNM8+p8rbhys=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=GPjTyDZU;
	spf=pass (imf06.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774260551; a=rsa-sha256;
	cv=none;
	b=l8A8nEO9vkklr53Usu8Q19gWyoJEgx1knylrZoK6RkFDzuAJRNC95bGzlrUIYzZHNL09Rv
	RqWQ9IkNhBWmO86C+fuL1QscMPxRe8nnmFa5+8JwzvaWNNJihRmwpD2QTqtPpMCvqLTZvO
	LcDP4CXiToPT3OxBSnjYPHnB0ysNryw=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260323100908euoutp025a561cd6f8c40946a0fd28119d2086c5~fcJGghJfv2466124661euoutp029
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260323100908euoutp025a561cd6f8c40946a0fd28119d2086c5~fcJGghJfv2466124661euoutp029
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774260549;
	bh=/6WjlAYerVq6d8qF1cWBAuX5UyfsvgD0ELY2Xcbrhso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPjTyDZUrQmT+JdMPRVmruY292h+O0ZF60kzgPCqp7xy3DWnWdEmncqbbpSHSlcD4
	 GoLazrAKJ6pgERLEOSDboQs3H1Z91P0+Tbd58sqLDqHyNxMeeYs1JLMsTLzpqDNvdu
	 Gr+MnzGcm+b8wZJU8KPPgAOffF7szmgP3wE7/G4U=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260323100908eucas1p1890b792406ac416bb4db0d78f3e71faf~fcJGThcM42576725767eucas1p1s;
	Mon, 23 Mar 2026 10:09:08 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260323100908eusmtip284c5268a0dd34d1bd6b67a1ecfa80e41~fcJFwBqAP0899908999eusmtip2g;
	Mon, 23 Mar 2026 10:09:08 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Saravana Kannan
	<saravanak@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Robin
	Murphy <robin.murphy@arm.com>
Subject: [PATCH v2 1/7] of: reserved_mem: remove fdt node from the structure
Date: Mon, 23 Mar 2026 11:08:55 +0100
Message-Id: <20260323100901.4079171-2-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260323100901.4079171-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260323100908eucas1p1890b792406ac416bb4db0d78f3e71faf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260323100908eucas1p1890b792406ac416bb4db0d78f3e71faf
X-EPHeader: CA
X-CMS-RootMailID: 20260323100908eucas1p1890b792406ac416bb4db0d78f3e71faf
References: <20260323100901.4079171-1-m.szyprowski@samsung.com>
	<CGME20260323100908eucas1p1890b792406ac416bb4db0d78f3e71faf@eucas1p1.samsung.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7833618000E
X-Stat-Signature: wcjupmxurf4bb8grkni6dqz6mhj6o6bk
X-Rspam-User: 
X-HE-Tag: 1774260551-88830
X-HE-Meta: U2FsdGVkX19R4gHl/FljsBtjknqu22ceNIW1EmZBDfkgZn/q0JfydxbGG1GU9j4YzSMLs93CaMK1SOMqsBpczDwvCV7RRPxRmewIrirXlpG5YbiWmzgs6XrSKwmvAnBReTuwUyyfOoGb1i8+s0HJIrj89geKbOydW/jO4l9YM0G+9D9z9IWg65g81gMsYV1stHE6VSbevmysDeMzlgAtUpSmZ0bzYi8TKT/x5vCXti6zwZBmX/gCCakWtlb0nzyXu1M+hfhFgIzTf15J/3qJ33/TlFGNbGegGGVllVrx1/XGiPKO7I5x8twEEZmsUL43afMhitNSRQaem1sUcBjFlVGvZ98t4jpH/5rZNvZPCvPW47bqidqMGSSgJOQSNiUyXEwbw5GG6cSCSgE3HxiYK9Sz01c6ku3BDwdMyZi6tPc9/aaAAJeZP/XsMw5AGSRP6t6C6rOdSvQYvYfk3zd0DvLwTF+txCHBKjlnHTO3Tm8PqHH4soiUyzB3dW3SMNXhcLXPZLWjBoyTdfvaLxIOsF5Rx3Os/nBMbPxetXkrtwPAE9z4mcBaoEogqBliovQ+p4J78bh6d3tBPCOtMqh8abYua4OCUxotIPU8+4vaAWNEO0bTs4dxbcL7CwFE7RWup4qj80JNCp2cW+RSyUWK2hXw/U4i0Huy7i7MIifhMROqNpIEfnfWqPmz7HAvdcMgEPAd0Go8aZYKJ4fgFFdJ6dZxnReI41TWIPBBddgXadoWoy/1gjcVmsNvLcMASc0WVY0usY4o36qWuIztrSopc7VxMYNNXQiRXjpvnT6wmbU8DsnCkKL3l+0c3bDRBzHTiLc57+OA2SN/T+30dzVyc6jloiK8F+3eQI62jPkjv1FRbFKEp6YoURABLN3gnMk7NmavU/0jmT+ruSymu5wFmSZHFgsEj6T6a3Ewb99Ezj/Y2jx9rzSIkZNR4lnBMfj4a+B7dCNzviyFDQw+TWL
 bzTkb4pE
 lIyHYZkWMCyoQKgYK93rgPUHmKA1hIGkYNP865YucUP/FhG0=
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


