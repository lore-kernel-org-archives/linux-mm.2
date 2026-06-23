Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BAE7CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 12:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258A86B0088; Tue, 23 Jun 2026 08:13:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2090E6B008A; Tue, 23 Jun 2026 08:13:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E896B008C; Tue, 23 Jun 2026 08:13:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D52856B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:13:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BC071204B7
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:13:21 +0000 (UTC)
X-FDA: 84911067402.26.FE713F1
Received: from outbound.baidu.com (mx22.baidu.com [220.181.50.185])
	by imf26.hostedemail.com (Postfix) with SMTP id BCA0A14000B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:13:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=BZDq4149;
	spf=pass (imf26.hostedemail.com: domain of "prvs=md16284F6544=lirongqing@baidu.com" designates 220.181.50.185 as permitted sender) smtp.mailfrom="prvs=md16284F6544=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782216799;
	b=zLZCfjQ6vEeRG7DbdWcw/E7X1vXmZsXrTStZ5mRI49lOj//hhiK2qoJ8e0H7Sq5FnQ2OiF
	X+eIob4acGweqJ6ytKtcDkHzx+I/GG26F8b2HDEwFHq7R98j7q30XE9KbayDysnCEwIkx+
	kNIBstQ7aV31k/hixBZJWVv1i+SpYbI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782216799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=avYC+UsIp5M7XTGxSLfoEhSS9f43NSp9rS9DnHBspgA=;
	b=aWYaCYVREB/QqNj3w6FawVSq62UJqAFi4n4GhLjSl4SduFxxJ/U0CYb6uURVm22sWgMu7Y
	c7nxmvl8c3NNHnMqEwvBn7fsnskdxJyPsQi48WL/BrBHdGYwLxFF1sz+5UVyieo3jz+YvQ
	sjgZ1krvEkein15YiUSYbJ6U+5bJx3k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=BZDq4149;
	spf=pass (imf26.hostedemail.com: domain of "prvs=md16284F6544=lirongqing@baidu.com" designates 220.181.50.185 as permitted sender) smtp.mailfrom="prvs=md16284F6544=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH][v2] mm/dmapool: Untangle CONFIG_SLUB_DEBUG_ON abuse and switch to static key
Date: Tue, 23 Jun 2026 20:12:45 +0800
Message-ID: <20260623121245.2221-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: bjhj-exc8.internal.baidu.com (172.31.3.18) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1782216789;
	bh=avYC+UsIp5M7XTGxSLfoEhSS9f43NSp9rS9DnHBspgA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=BZDq41495EFvvuXZ9K/pJrQzD5Wt/rOy16pDO9S0PRNPj9FpjrBmSiPPC1RSKfBqq
	 pVOeXh/XiUUQf4r2tfhci8+IJzvVpdkk8mf4mQNnohzS97p1u/k0Hkf8eM6cAwanlK
	 r7eRYKDWaa3erGux+eMCltnKHKGyQ0OFpcm7mXUL7AS6iCVEcJvGF3RMp0LDah4tAn
	 IiMC8zmNHqOX9oocdq3yOGKvgdM3EHzfxx4ME6gasOwtDMWb99yaAaF8Lys35+1WvS
	 5pUbDi4EQmwXKst6D7odi3qDKGmmK7ZOfTplWk4Z/viCnJ00Rv3ZFewFq/oj9nFqPp
	 c14y61DaEI19g==
X-Stat-Signature: gte9ywyper1i7mbwspqhwjtzm4gj3ikg
X-Rspamd-Queue-Id: BCA0A14000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782216796-904017
X-HE-Meta: U2FsdGVkX19tI23X5nYDG35iECAptUp/im9AWRbzMw337tJq2LrMoA51FrsR/UJAe765pgdsY5d5CE3PLB2AaBeyhnnOcSWhzIV8tbOtkLVPLJJdK/zDXSCd11Vl95OHIqLS+xK1pRp6we1tZGvNWmEmQwCvVIS/dviyTQfKOVe4RtTHn91mV5+tJ0NGS3UcPzTVN+TOB/7Rdxzf28DHJph8jDQT7z6Xica/EYF0bwFlzdm3zWdl8YBX27UdsvXriEZckNZVBVYJVu+v3nWmerEQJiMejkn24Jpy6LWYX7iBGWnOKI+GUVHLkd/qsSirwtPaZmitGg5nOzduxYPvPy10teI14jNsBb//MmRQyZ99NIhHnfamUaB3MaNlDpa/E6qyESht/K34+ewjZoi2zYBASWxVkTXotwT2M2if2FHfJa2B1t6Mn6bnPaTcLjini8ZgHo4JmPe5Hb7eAntYi5gduvZNuI5q8zvJVcMso+o2L5STGaMweUfo/st6Th9hgmxjg2ahQK6D8Yzvyi5al15KWVZqdVWgdkSagaqjMLTqHmTEAeQjQWnCbt34SeurWWbH8xyKKOgEkjRtScrHkUJ50qL01OGh0wYi46gE+Rb9xHQA0KAECSwQMF9uwYL1nlVjOAQWTZUemaVAD//E1oh9wa2JP489vpVgNUD0UTkCgbZ7yGRrbCiQvOINK8V3tcfYkT7buohSeBFWwbEeD/O1NirV25w5R1Rhn11RSzStQ8jfq0FDGpasn3YzdXyExvr6rLwRx55BHl1Ru6M0KyFnH9w6w2cS/dq4tkmpL5ur7ruN+2m4ryHaZAs3n5qwCV6wS3WOIfgUE1qgnlDarflMka1OUtpIWLUeqEeYNbH4lClL/ZxTOmO19CXe85T59DXAmJcRlHxgukYO+Y7WxcrFuSEieUMmdJNMe/v9e+wYNQqGGATBq3v+aXuR0/CfWdYLWF7nvrhXjJL6RXJ
 3onR/w5f
 3ClypFTtAmf2voIwt/0vEkRwEuTx04iT5Q3rJHArxq3hjP+GGfYLAuoXkF6FC70O62VitHZtiD+7SNbo5D+1eH3tXYawwrtCIylj/cnf+jOi/Rk7bdKNnvk3I2TJLXJU4CVMDOmy9a45x2ss3nVWxjrc+vtUqS0X6r5q0PE1xJXOJ3TYVK+uW1iX8O01HeJJHYIGyvcggSOp0Ew2R9enCruWmAaWlRlyaxson7kOE4vcxZEGeONrGtXGKMxJBPlO1YvV/qtb/RSsDz39G4FJSGdxEd+RkGrtYba/1L1y4VQXswzPs2YppAZSdGmvaqpTKl6G0LaIvPO2UTuY7sodIxplqfN4/gBHPA2d+/L+iFJyz/oJwDq19vRC9Xx3XyxmceGclBwqLPONAUeNMVV4NDte/w1KLyhCh3C/fAWODPy1JMBc8B5w09TFbJbDoMT0OjpdGw/ZYDWiwN0jw/o2wV+QjqpiIAfotxCaQHbgMgQj+Z1XMLXCsqx1JzKf1s1fxL2ffXEH76JpuUkDFef3VVQlgK28WONw9M+RuiuR0NoaifmmFg6QHgf5PFsULHkgjiTaV1RhEGFYwELsgIaRQ0mQMd4t5yS2IJ+9mc80Gq0iODEUVPjUTevE+cmsYJ6JQTbFY/RBkK61sKw2Amrmh675ZAtSD2bpGV7td
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com>

The dmapool subsystem historically wrapped its debugging logic inside an
This approach is fundamentally flawed because CONFIG_SLUB_DEBUG_ON
merely defines compile-time defaults for SLUB and caused two flaws:

On production kernels where CONFIG_SLUB_DEBUG=y but
CONFIG_SLUB_DEBUG_ON=n, dmapool debugging was completely compiled out
at compile time, leaving no way to enable it without rebuilding the
kernel.

On kernels with CONFIG_SLUB_DEBUG_ON=y, dmapool debugging stayed
unconditionally active even if a user explicitly disabled slub debugging
at boot time.

Clean up this mess by removing the #ifdef and switching to a runtime
static key (dmapool_debug_enabled), allowing dmapool debugging to be
toggled cleanly via its own boot parameter: dmapool_debug

Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---
Diff with v1:  Move the static key check out of pool_init_page etc 

 Documentation/admin-guide/kernel-parameters.txt |  5 +++
 mm/dmapool.c                                    | 57 ++++++++++++++-----------
 2 files changed, 38 insertions(+), 24 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 19c9a19..66d853c 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1304,6 +1304,11 @@ Kernel parameters
 
 	dis_ucode_ldr	[X86] Disable the microcode loader.
 
+	dmapool_debug	[MM]
+			Enable DMA pool debugging. This enables memory
+			poisoning and validation for DMA pool allocations.
+			Useful for debugging DMA API misuse.
+
 	dma_debug=off	If the kernel is compiled with DMA_API_DEBUG support,
 			this option disables the debugging code at boot.
 
diff --git a/mm/dmapool.c b/mm/dmapool.c
index 5d8af6e..7bd037a 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -35,10 +35,23 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/wait.h>
+#include <linux/static_key.h>
+#include <linux/init.h>
 
-#ifdef CONFIG_SLUB_DEBUG_ON
-#define DMAPOOL_DEBUG 1
-#endif
+/*
+ * Debugging support for dmapool using static key.
+ *
+ * This allows enabling dmapool debug at boot time via:
+ *   dmapool_debug
+ */
+static DEFINE_STATIC_KEY_FALSE(dmapool_debug_enabled);
+
+static int __init dmapool_debug_setup(char *str)
+{
+	static_branch_enable(&dmapool_debug_enabled);
+	return 1;
+}
+__setup("dmapool_debug", dmapool_debug_setup);
 
 struct dma_block {
 	struct dma_block *next_block;
@@ -92,7 +105,6 @@ static ssize_t pools_show(struct device *dev, struct device_attribute *attr, cha
 
 static DEVICE_ATTR_RO(pools);
 
-#ifdef DMAPOOL_DEBUG
 static void pool_check_block(struct dma_pool *pool, struct dma_block *block,
 			     gfp_t mem_flags)
 {
@@ -161,23 +173,6 @@ static void pool_init_page(struct dma_pool *pool, struct dma_page *page)
 {
 	memset(page->vaddr, POOL_POISON_FREED, pool->allocation);
 }
-#else
-static void pool_check_block(struct dma_pool *pool, struct dma_block *block,
-			     gfp_t mem_flags)
-{
-}
-
-static bool pool_block_err(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
-{
-	if (want_init_on_free())
-		memset(vaddr, 0, pool->size);
-	return false;
-}
-
-static void pool_init_page(struct dma_pool *pool, struct dma_page *page)
-{
-}
-#endif
 
 static struct dma_block *pool_block_pop(struct dma_pool *pool)
 {
@@ -305,7 +300,9 @@ static void pool_initialise_page(struct dma_pool *pool, struct dma_page *page)
 	unsigned int next_boundary = pool->boundary, offset = 0;
 	struct dma_block *block, *first = NULL, *last = NULL;
 
-	pool_init_page(pool, page);
+	if (static_branch_unlikely(&dmapool_debug_enabled))
+		pool_init_page(pool, page);
+
 	while (offset + pool->size <= pool->allocation) {
 		if (offset + pool->size > next_boundary) {
 			offset = next_boundary;
@@ -433,7 +430,10 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 	spin_unlock_irqrestore(&pool->lock, flags);
 
 	*handle = block->dma;
-	pool_check_block(pool, block, mem_flags);
+
+	if (static_branch_unlikely(&dmapool_debug_enabled))
+		pool_check_block(pool, block, mem_flags);
+
 	if (want_init_on_alloc(mem_flags))
 		memset(block, 0, pool->size);
 
@@ -454,9 +454,18 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
 {
 	struct dma_block *block = vaddr;
 	unsigned long flags;
+	bool err = false;
 
 	spin_lock_irqsave(&pool->lock, flags);
-	if (!pool_block_err(pool, vaddr, dma)) {
+
+	if (static_branch_unlikely(&dmapool_debug_enabled))
+		err = pool_block_err(pool, vaddr, dma);
+	else {
+		if (want_init_on_free())
+			memset(vaddr, 0, pool->size);
+	}
+
+	if (!err) {
 		pool_block_push(pool, block, dma);
 		pool->nr_active--;
 	}
-- 
2.9.4


