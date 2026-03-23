Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6AB1EC01B9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:09:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647416B0088; Mon, 23 Mar 2026 06:09:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D20E6B0096; Mon, 23 Mar 2026 06:09:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2F16B0088; Mon, 23 Mar 2026 06:09:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8F46B0093
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:09:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6B12140A33
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:13 +0000 (UTC)
X-FDA: 84576904986.11.059FB91
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8D82118000C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=HXS3Oey5;
	spf=pass (imf16.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774260551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qDkZBH8D9QGZmacGWO/wLlPET8ve8kNAHImwlz5MpvM=;
	b=EXGpAdR5Qs1pkhV6a1S+L1VTGeTbMBgW+HN1YgXBZhSygbNM3R8DPs3Lbhfd5oAfOXqM2H
	KcUtYIyd6PfozL2al6jYWR56YbLlKVQD9RDKcUavrfXkWCWDCPaHgU/eIQdlsEgAY4Jbkf
	y6iabZCwrZcrI8cLI3bCZXaKJ9ItHuA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=HXS3Oey5;
	spf=pass (imf16.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774260551; a=rsa-sha256;
	cv=none;
	b=GLjsdK89FHWCKcGl8JAj/yRK0QZQ4SnkLZvUsCYncif2gI+CTQHOzJW63AkoRSrs6Qyeel
	EqjicywpS8NpPCWzeAKS7LmlQWE0NlbEHgbxiAKnL18EyrVEiS8u2B918RLGr+0Z1rJHQX
	cm+yfNH/5XifyNbAKrPZ8jvgtYlkHeo=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260323100909euoutp01dcc3d6db4e569f5233f488490b22eb1f~fcJHG_5Yx1211212112euoutp01i
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260323100909euoutp01dcc3d6db4e569f5233f488490b22eb1f~fcJHG_5Yx1211212112euoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774260549;
	bh=qDkZBH8D9QGZmacGWO/wLlPET8ve8kNAHImwlz5MpvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXS3Oey5TnA5+rQRTdN/cvH6JSjyqwrxn7HA6CSMVtlsIh67qFvs6orY9mc7fvpLg
	 CINXsR5iNEkk+42ywSN77jcAcfdlaHeN+Rh+1uKmH7jShM11Ssq9esrNEu+/eRDFtc
	 oaKNcsLiM1Sd8G6f20Z0SRRFsRFEHJugn5hUcseQ=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260323100909eucas1p20e3bae57f851ea402506f7dbee7ffe3f~fcJG7ohgB3050530505eucas1p2V;
	Mon, 23 Mar 2026 10:09:09 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260323100908eusmtip2f7188445ed61b2d39d08c30101273f88~fcJGZFtr60953009530eusmtip2t;
	Mon, 23 Mar 2026 10:09:08 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Saravana Kannan
	<saravanak@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Robin
	Murphy <robin.murphy@arm.com>
Subject: [PATCH v2 2/7] of: reserved_mem: use -ENODEV instead of -ENOENT
Date: Mon, 23 Mar 2026 11:08:56 +0100
Message-Id: <20260323100901.4079171-3-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260323100901.4079171-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260323100909eucas1p20e3bae57f851ea402506f7dbee7ffe3f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260323100909eucas1p20e3bae57f851ea402506f7dbee7ffe3f
X-EPHeader: CA
X-CMS-RootMailID: 20260323100909eucas1p20e3bae57f851ea402506f7dbee7ffe3f
References: <20260323100901.4079171-1-m.szyprowski@samsung.com>
	<CGME20260323100909eucas1p20e3bae57f851ea402506f7dbee7ffe3f@eucas1p2.samsung.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D82118000C
X-Rspamd-Server: rspam08
X-Stat-Signature: dckmdkkx6pyskpgstk8ombjrkkq3jmfg
X-HE-Tag: 1774260551-9577
X-HE-Meta: U2FsdGVkX1/YxQ6C92kKjZWNzQfyLMsrvxKYVvRhpZJzPT08lPmI73KWbTheqP0ZPTSzDVHi8XX9ZNXoZ4iY2llprT/2z0fgj76wiU8mbmCGobT8FUMCDVufRKF+WxdHwBL8NCbPfRywnJI+Ayo7KPgVNFR2HRtkUaXK1/75zbXywJJ/iB1ovVbS3ZDK4FzXtH9dZQVAKZHvTRmUhYakXb702Nj312SncGGI+w/B3Aef7MZlgldbTEbmTko8er0KoYGpBvu+kppMZe3j6RiKYp0co8xwoyVkHWQgZx9UsP/vp2x4DUq8F8M2zHvcGli9gLbQoU7cssf/uIU9DZyj3i1USlUeEeLBEIZOjeqNKCvk3B5ocUtsei1NunjkcU+Yi7pgIoMXIsyxzZGlhLaFG2PN31anaOWetuQMIVurObuRxP2zyyJ9Oh+plqKBD0ciZ3tg8cQ87TxAUOxY4XKKn6eoB9nKoCHIDHoFHaIxNdm7tSOJ2wnqmox0kYG4s3DKVZK14eEF6FARu9jbDG0OvfyoAmF/Ggfl6/tcUuYPko3qKbrRtKCvPO+nQByuZ8xX3l9rhJgVLDVjHPcIVJUuis5Aj4VFyJznjGSa9sDytgS5LIfqdlRXsppL+0S288C6GhGRQnZ6/fvAhYQzptTUwVOfjGFeCShCT+0NxN0KowlSV8idKUxgauE1dtr/e4brj1lNJDwfYxuctC8/wTL78iAMms+/i9w+02xz0nNO+Bm94tq5e1L4wTvHUwde5RbWo041/Ky3gfyqiYzG4VX7Gkf5Aa84PpW1kAeTUQ8nen3kHNIyQpLSTh9vqUnNU7YesErk9wmOuEh1lkhXuGCCcCI4CpZ15ockEhc1yVQRTMJPs/IotAnw/cPbrSWJsGkitoJ9CVapSH5Y6e3rsVwN+PCG75VQJE1YdBq9w8jzxlDUM2E+bsuyQIYs4T0rbC/cqBXS2r24V12FMBrYBW3
 JDiLDDW/
 pf+GeclVdTJGor7fTqyYcf7Hlozfi3e4JLjVa5QA8bF2fHSWH1F+I7ZZXKQd8cHGCFCzWc7dLNCt4IwEa+KVWtS+RBf7DBz03I5TO6UEpvJkp4igeNN3rkNkGnjaH8nhvFpWp/tsNK1xTWNg=
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


