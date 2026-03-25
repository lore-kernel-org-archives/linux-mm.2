Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD406FEA833
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E14A56B0099; Wed, 25 Mar 2026 05:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D480A6B009E; Wed, 25 Mar 2026 05:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC11C6B009B; Wed, 25 Mar 2026 05:00:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AAD576B0099
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:00:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35F8BE0B81
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:39 +0000 (UTC)
X-FDA: 84583989798.08.07F42EC
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf04.hostedemail.com (Postfix) with ESMTP id 280D040014
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=O+R8hPse;
	spf=pass (imf04.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429237; a=rsa-sha256;
	cv=none;
	b=1NYYVWHZcrAKuqI7AvznADM1696eS+tccq8Qs32SIDZElCCuHHc8d4k8AQXazKvthuLIwC
	AW63BTwgqMFFgqBz03rqqHw4isyXr/v+AHRIlM1MNL8VGZYWAunMS6xe6kRkVumbELYhGJ
	jI1DAXtL6+Q0u75k7eRka+aCWXQ06bk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+89c32tU4lTTTppNlFl+vXaQCaUGhisq2Ypb82nMCo=;
	b=IZ5PMhxY+mj6PqR3ctpSN4s/yVo8VIUxTXW4Y9HlFZweh6b+Q95OccbhDkW1zYzrxFPg6W
	dIZz+TUAXLIpZf4dsMXOQqgtUAak7VYa0QCuB0jmZHuAZ2Oau3ZnN0RvCLyafF/5koGWUN
	5d2bGY+VE/qcf7ImeMHSap9KlcXMbFg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=O+R8hPse;
	spf=pass (imf04.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260325090034euoutp02f253def5189b854d6c01a176dd23f505~gCfzDB3iS0388203882euoutp02B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260325090034euoutp02f253def5189b854d6c01a176dd23f505~gCfzDB3iS0388203882euoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774429234;
	bh=d+89c32tU4lTTTppNlFl+vXaQCaUGhisq2Ypb82nMCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+R8hPsenLyzl0FkSCF0zsxaWOjqsB2sn2m6zYEGWn/RoU523pfK0Y3UReyR8ZDsS
	 /hlkReXM02nvJGlnVmWxD2aAhCXNrdZpnHs7Ry1BaYLzK2bvm6mfADxMTsxKamcUVu
	 Y4xy2NwxGgtKwF/E3Z9Y+pacgHdsL/OIF4Q/nEuo=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260325090034eucas1p17e2eefa714bbc8cd4828a7e88c2dbfd3~gCfytXeNy1762717627eucas1p1k;
	Wed, 25 Mar 2026 09:00:34 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260325090033eusmtip154597783022f9c979a4fa8fc7bb4a0d4~gCfyKkZO_0170001700eusmtip1T;
	Wed, 25 Mar 2026 09:00:33 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Saravana Kannan
	<saravanak@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Robin
	Murphy <robin.murphy@arm.com>
Subject: [PATCH v3 6/7] of: reserved_mem: clarify fdt_scan_reserved_mem*()
 functions
Date: Wed, 25 Mar 2026 10:00:22 +0100
Message-Id: <20260325090023.3175348-7-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260325090023.3175348-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260325090034eucas1p17e2eefa714bbc8cd4828a7e88c2dbfd3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260325090034eucas1p17e2eefa714bbc8cd4828a7e88c2dbfd3
X-EPHeader: CA
X-CMS-RootMailID: 20260325090034eucas1p17e2eefa714bbc8cd4828a7e88c2dbfd3
References: <20260325090023.3175348-1-m.szyprowski@samsung.com>
	<CGME20260325090034eucas1p17e2eefa714bbc8cd4828a7e88c2dbfd3@eucas1p1.samsung.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 280D040014
X-Stat-Signature: emedssdsc574qjffo1dj59fikmtyt3nc
X-HE-Tag: 1774429236-518088
X-HE-Meta: U2FsdGVkX18sfB5HfS2BacaKm3Jbh/DPb+oxAOLXH5Ki3O3JrkSH/xyiURNCLPjUNNlv91vBvAJ8vpEqg7gFotSnP65rZZcid9tSl5erZ3zzG9+yt633leFZ95cKypgO2NCAL4RhjVZSk1fumHoz/Zfyh1h/7XCUZVo2MGDkMGcQxkKsRj6aq0DheeuuBbAEb3Aae38zKhbefOh5sxeJNIf3LiKrThHnDN6kWpafM6hoP89llvvueHc5+fRz37vv7fpNJZ42gL4xrg45vbabWvcICCpNLPrxr3DS8AoatrshPwtTEpyBZKA1++475jswZCNWmm6kSrMzionst+r6FtXGdTwExIob11R9vwYs0bJ4W7QKyb5ZhSfZ4MzgZ5yIaXFFBJn5xTbIN4jtgR+b9jaEBa5j97Xo6kzjrmG1qEUibRqo61QD/YyN9HQH8DsRRGAQI7pJw0pWz/G3wldiLO5HyZGefCCSoUyItF5/j6gFgNJRGjTfCp8Ai9gB/X6ZEtdx2zD5rSoT3s5ks7DSaI0K/u7Hz3jRMsnHUVxA2e/vnu+7TQgPTkBeq0+XMNIXmTYAmw5RTFEC9WWvSQOJYuwjrWMeV1B7hYtT83SRAk2Q1IaocAN6ZnpjeKeJFiSDOiDti3AMUgORM3fE2qQ2ikbqeWzcrzQKrCnCMoNXDt94xla7WvbvF6xj3KCn3e74IG9MpGMVHJN/Qgu4GtXT9v+SFZeFO2JDZWC9KJY0OflSH8wDaCtDEDNG6KMB+Uy1lNSXp9GW59Wh9Hde4clr4I+dRAUHHrXYUu2+TeDNdywNXKae22z9Da5+ssV64kHLR9OED2el4AH3sN8F88A9tPjTiQS1D80Em47ploHXGggbz2YI3Hn6ZNyVD9YiEL+slx/mv72/n5kglu9D9CGZ36YhrT5NHOtB3fClAxmlQuOxpHwqqsSYMCkF9G9voqYOSAB7IUkuH2R8uWjjn+7
 VkNyA0Iu
 Y5Vu26K/Q1Lb1aKmzh5SpJSh6TeuCOWxW3wst3R4XEVHJ5Dqy9zoAA3eh16VuBKwds0O0CwWgmLGMZssS2pFsEBl0pLJBHUqtgtefk/fy+euJvlCU9AmLz5Ie2r5TvCdmanggVfdHjKG/8BxpBLw4FHkMuDDGPmSP90aP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename fdt_scan_reserved_mem_reg_nodes() to fdt_scan_reserved_mem_late()
to clearly show how it differs from fdt_scan_reserved_mem() and update
description of both functions.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/fdt.c             |  2 +-
 drivers/of/of_private.h      |  2 +-
 drivers/of/of_reserved_mem.c | 24 +++++++++++++++---------
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 2967e4aff807..104e697bee7b 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1295,7 +1295,7 @@ void __init unflatten_device_tree(void)
 	void *fdt = initial_boot_params;
 
 	/* Save the statically-placed regions in the reserved_mem array */
-	fdt_scan_reserved_mem_reg_nodes();
+	fdt_scan_reserved_mem_late();
 
 	/* Populate an empty root node when bootloader doesn't provide one */
 	if (!fdt) {
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index df0bb00349e0..0ae16da066e2 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -186,7 +186,7 @@ static inline struct device_node *__of_get_dma_parent(const struct device_node *
 #endif
 
 int fdt_scan_reserved_mem(void);
-void __init fdt_scan_reserved_mem_reg_nodes(void);
+void __init fdt_scan_reserved_mem_late(void);
 
 bool of_fdt_device_is_available(const void *blob, unsigned long node);
 
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index f9b6d3ebcc20..037e3d74dde1 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -265,16 +265,15 @@ static void __init __rmem_check_for_overlap(void)
 }
 
 /**
- * fdt_scan_reserved_mem_reg_nodes() - Store info for the "reg" defined
- * reserved memory regions.
+ * fdt_scan_reserved_mem_late() - Scan FDT and initialize remaining reserved
+ * memory regions.
  *
- * This function is used to scan through the DT and store the
- * information for the reserved memory regions that are defined using
- * the "reg" property. The region node number, name, base address, and
- * size are all stored in the reserved_mem array by calling the
- * fdt_reserved_mem_save_node() function.
+ * This function is used to scan again through the DT and initialize the
+ * "static" reserved memory regions, that are defined using the "reg"
+ * property. Each such region is then initialized with its specific init
+ * function and stored in the global reserved_mem array.
  */
-void __init fdt_scan_reserved_mem_reg_nodes(void)
+void __init fdt_scan_reserved_mem_late(void)
 {
 	const void *fdt = initial_boot_params;
 	phys_addr_t base, size;
@@ -328,7 +327,14 @@ void __init fdt_scan_reserved_mem_reg_nodes(void)
 static int __init __reserved_mem_alloc_size(unsigned long node, const char *uname);
 
 /*
- * fdt_scan_reserved_mem() - scan a single FDT node for reserved memory
+ * fdt_scan_reserved_mem() - reserve and allocate memory occupied by
+ * reserved memory regions.
+ *
+ * This function is used to scan through the FDT and mark memory occupied
+ * by all static (defined by the "reg" property) reserved memory regions.
+ * Then memory for all dynamic regions (defined by size & alignment) is
+ * allocated, a region specific init function is called and region information
+ * is stored in the reserved_mem array.
  */
 int __init fdt_scan_reserved_mem(void)
 {
-- 
2.34.1


