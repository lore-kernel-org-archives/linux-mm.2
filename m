Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CEC2105F7B3
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 15:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E8846B0089; Fri, 13 Mar 2026 11:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D276B008A; Fri, 13 Mar 2026 11:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F4266B0095; Fri, 13 Mar 2026 11:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 154566B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:08:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB2E21A0190
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:15 +0000 (UTC)
X-FDA: 84541370550.20.F564E8D
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf08.hostedemail.com (Postfix) with ESMTP id A45B4160004
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=qsxMxaoh;
	spf=pass (imf08.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773414493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qDkZBH8D9QGZmacGWO/wLlPET8ve8kNAHImwlz5MpvM=;
	b=netWA7oz/Dx3mRYCxyRwsClpNqVEULfuxy6XxV2c1wZlqQQYcVw2VZLKGDTSeLx18x1ykB
	+Iz8Hi2PU15OdrqoQSrCZmSRAIWP26BcdwbcciLAEg5GzJfPh4hZIBG+sQOhlIDTFtoLxx
	93fvdjy92QRVetZWvqsGfzTbeewsBIs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773414493; a=rsa-sha256;
	cv=none;
	b=SX8CJ1C+G5Btz2V+lNxev9sF2yL1kzhoWhdtVXgWXFBMUBsmyAR+kQcM3nM9IY+dC5lBxP
	8mcc2yvtoEzhiie6lvO2Bk/6qXJMY6qBub8eNRtTyw2PpF5nFHwLW+7hhCRQFPp0V6IhcE
	CWBlRQM83PqX3jehMbenGpnZfSTivE8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=qsxMxaoh;
	spf=pass (imf08.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260313150811euoutp0140c7d6fbb5e8f88fc5d24ef81de27d99~cbxV1Q2wR2419324193euoutp01D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260313150811euoutp0140c7d6fbb5e8f88fc5d24ef81de27d99~cbxV1Q2wR2419324193euoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773414491;
	bh=qDkZBH8D9QGZmacGWO/wLlPET8ve8kNAHImwlz5MpvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsxMxaohi0gLjHE3laixqacIZ/KENT0VJwNmI622XWnXL2T6H9jKpbfrnT6ZoKKpU
	 tEFgavNWi/yb3Y8biio81k6ycv0mmK9aQgFGrAAfdHHwSAFnFKjPZqDKz5RDyWKxVU
	 z5YbChQyAqqsph3070AcRq5D9EN+2BjxNjXX8Eog=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260313150810eucas1p26191d7bb4791b75bb9f3cc9cf116b1a2~cbxVjAbdh2075420754eucas1p2A;
	Fri, 13 Mar 2026 15:08:10 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260313150810eusmtip1ed078da71156dfc982e63b6cf3500d4b~cbxU_rpHh0224902249eusmtip1N;
	Fri, 13 Mar 2026 15:08:10 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Saravana Kannan <saravanak@kernel.org>, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 2/7] of: reserved_mem: use -ENODEV instead of -ENOENT
Date: Fri, 13 Mar 2026 16:07:57 +0100
Message-Id: <20260313150802.1121442-3-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260313150802.1121442-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260313150810eucas1p26191d7bb4791b75bb9f3cc9cf116b1a2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260313150810eucas1p26191d7bb4791b75bb9f3cc9cf116b1a2
X-EPHeader: CA
X-CMS-RootMailID: 20260313150810eucas1p26191d7bb4791b75bb9f3cc9cf116b1a2
References: <20260313150802.1121442-1-m.szyprowski@samsung.com>
	<CGME20260313150810eucas1p26191d7bb4791b75bb9f3cc9cf116b1a2@eucas1p2.samsung.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A45B4160004
X-Stat-Signature: ejsy4q6uuy6gbmsubcd6inmpo4uygrkg
X-HE-Tag: 1773414493-650001
X-HE-Meta: U2FsdGVkX1+8anJ+hIE1lT9Frl8t/lpNWvJQHbzP8cmkD+uYu+Yh9qBnooBj8wZYuMQwzLTjGjsZZjtjB03G5iD2xSKYB0PW66yefQt1FjB33VPsF6BMyE2boFwxSuISIT2p1H8kLjQuSWrdl0HKtn7sYKp3/V33tCqC0iI9uOZmoeVSYsyFimhYn1x/TRJW8D1JVT9ep86VbuYa8vtM2KP/dT9AMmhMA+ZUNfCKCxpELSnKcbin4mkb48fRiwy2XRH5BHVW4e67yDcyJPZhHfUtEwHk1tBMjT5TppXL5xHRUWbhAU08HNeHR98tbJVnM2kLeO8tTzscUCBOyn1jUCevYNCNPX1na3LzSlyLMUphZzkbOlpuTcSoh6vTzM6ybx75mQgbgcCrWckJK3CYD8wM0Xsz8I6GjOppjpPWsCarzhDWl7zF+o7TvYSBMtGGywTFLdxqqrtcUPsuFrbY0rrQxxnp00Wuw+0GKRQ1qTM2Iaq1NpOk4wHxolLPfjRPoM2gtNIYVzjrIRBbwSUjEpqriVchBM8LtFIDZFqbet9PmOrX/Nt7yS6VEKNb2WcI2Md99BTBE9Pz64y0W4WUGkF9borXT17WevhVmwHXHo5IUNs0Dd9adK3NOl9QRAwEC15RkpUZ6Y/ZuI9/RgS0bXEn1laP4rJMXf9AW3IyqLIpttEfFuyhxtZKljFmxNtHKGXOYyEnCHzu+/0j1IgrJ9Uzc+lIKjvh8P6qRbmLX5Axjrv/vReJIf0c02x7JO4lYMVLXppejXxW8G3YNLd5fdMZv7UC7LSQ+sP6zujF9ALdSjVzQr043rl+F68nJiK58lu7T1aSxDI+bCyuUH6bOrtjfpM9LpYYu1cdYqaJkfAidO8OPcd8DeLFGUlqwR+Mvq+0XqDG510wembvnBK56RnfPauz2ixHcLMkePddZ9S01FjDfE2G9uW+C3gZOXtGTK3//pVJmlgRU4NXRPc
 WOELRuke
 4GSPZOCJ5Xg1a3QgCAm50bD1JmaauekHXCvrT6zoYGmHMtLpYqpDMkRgISchYz5z9Ogq4A+BFEuNNpr3BjErfCGWKAvsDnQdHw8IogSIfRNVq+lGoCGqGWasT8ej1n6HnnKTVjlD0RVCxR5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When given reserved memory region doesn't really support given node,
return -ENODEV instead of -ENOENT. Then fix __reserved_mem_init_node()
function to properly propagate error code different from -ENODEV instead
of silently ignoring it.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c | 7 ++++---
 kernel/dma/coherent.c        | 2 +-
 kernel/dma/contiguous.c      | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 6705b7afebf0..9aff460a0420 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -488,9 +488,10 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
 {
 	extern const struct of_device_id __reservedmem_of_table[];
 	const struct of_device_id *i;
-	int ret = -ENOENT;
+	int ret = -ENODEV;
 
-	for (i = __reservedmem_of_table; i < &__rmem_of_table_sentinel; i++) {
+	for (i = __reservedmem_of_table; ret == -ENODEV &&
+	     i < &__rmem_of_table_sentinel; i++) {
 		reservedmem_of_init_fn initfn = i->data;
 		const char *compat = i->compatible;
 
@@ -574,7 +575,7 @@ static void __init fdt_init_reserved_mem_node(struct reserved_mem *rmem,
 	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
 
 	err = __reserved_mem_init_node(rmem, node);
-	if (err != 0 && err != -ENOENT) {
+	if (err != 0 && err != -ENODEV) {
 		pr_info("node %s compatible matching fail\n", rmem->name);
 		if (nomap)
 			memblock_clear_nomap(rmem->base, rmem->size);
diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
index 34621acbd3c5..64f9ba618e19 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -370,7 +370,7 @@ static const struct reserved_mem_ops rmem_dma_ops = {
 static int __init rmem_dma_setup(unsigned long node, struct reserved_mem *rmem)
 {
 	if (of_get_flat_dt_prop(node, "reusable", NULL))
-		return -EINVAL;
+		return -ENODEV;
 
 #ifdef CONFIG_ARM
 	if (!of_get_flat_dt_prop(node, "no-map", NULL)) {
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 81a2fa4971ee..e6fc6906b5c0 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -483,7 +483,7 @@ static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
 
 	if (!of_get_flat_dt_prop(node, "reusable", NULL) ||
 	    of_get_flat_dt_prop(node, "no-map", NULL))
-		return -EINVAL;
+		return -ENODEV;
 
 	if (!IS_ALIGNED(rmem->base | rmem->size, CMA_MIN_ALIGNMENT_BYTES)) {
 		pr_err("Reserved memory: incorrect alignment of CMA region\n");
-- 
2.34.1


