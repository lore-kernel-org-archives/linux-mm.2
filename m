Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8696C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE62D6B0536; Tue, 18 Aug 2026 12:11:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98066B05AF; Tue, 18 Aug 2026 12:11:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85776B0779; Tue, 18 Aug 2026 12:11:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E6496B0536
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:11:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 17C6B1A0171
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:11:32 +0000 (UTC)
X-FDA: 85114880424.08.F57572F
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf12.hostedemail.com (Postfix) with ESMTP id 66FD04000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:11:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="mXVQOR x";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787069490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nX6Ci+N1yckREzOLlHG8MRMpXVzr2Q4lmsP91rgqCg0=;
	b=GgTyG/tUAfVvvOlbYAvMfCZYKrwVmyhIaz1vWROAVQPvON4lxpSUC10gKgi6UN2WoTvK4W
	R3OdpDJxaTuMyl+mAgbxjiEnNyxcmKzIWp7q0/qq6c2sujRnIJRcW5b8m6bQ64IT0dtlsq
	M7A/H0QTIqLNIwVW3dkV5X5cpGTY4UY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="mXVQOR x";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787069490;
	b=lIGvJhKL7WpXToFNRPQNCzHK9nDu4QjEHmlsR/UcVDgBZts0nir/AxfV96k9dor6f+Pof+
	lfHUd+cKQhcVMNze/8+q7jjAL7M9cATqRO3shRjUiP9yJkPdUdrAg6rhHJNk3qKzCZ0l7n
	okADtgNuLHLawxBtxX69hguF2421WMQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=nX6Ci+N1yckREzOLlHG8MRMpXVzr2Q4lmsP91rgqCg0=; b=mXVQOR
	xbH3vjlUcNdExAt0OLf554yBdyb8QfIpWeZQIusoGkduAVkH2I2iu/VaV2MHS1H3x5UJ1CULPArJq
	uq6nCRRA4iMBSC0ZJ/2atiBav8uMfKJJRmJSTeuVeSnWsZhTyoDen80Nu0l2Udsl95kFQBtJR969H
	+l/T0GkK9hPtGb4EkBB5Loauo3hKv+KwFBIfvgvu4sv/0hRXr/o8T09kPxMsFLR73qf3Ut5/ir3Ni
	o31/H5R2HAnFAxGIkQ99RiXQS5yNNwu1Wl/1uUQg9D+v4vi7OzWu+U6mjZLFibi5TA2sA2DZ+vFLM
	e8LFV7aUTXtB9vRKmLvTqq+8nGQg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wwLga-00000001TR7-1R1J;
	Tue, 18 Aug 2026 15:25:08 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	iommu@lists.linux.dev,
	liam@infradead.org,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	ashok.raj@oss.qualcomm.com,
	jgg@ziepe.ca,
	kyle@mcmartin.ca,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 1/3] iommu/iova: convert from rbtree to maple tree
Date: Tue, 18 Aug 2026 11:25:01 -0400
Message-ID: <20260818152505.1057922-2-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260818152505.1057922-1-riel@surriel.com>
References: <20260818152505.1057922-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 66FD04000C
X-Stat-Signature: gzguo7mcspq7axsi9af4fuato9bqaogx
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787069490-460734
X-HE-Meta: U2FsdGVkX1/00tKupEl5RkhTcnpW/D3SCaIY74uhaWuYRrpXBCUDgqHeAJMEhzCXZohjRK+ed2rjOD4K7jYshRUF3sA3HbYQpmQCEQIApvSFHHc6uVA4lFTQS8CpP6TzrnrsFcOvkDR+xtrVWTsZ39LtHQ5+fSkM/9EM0YEf35jTRzL/oB/H/HxNIMytL4VAs9y1TiM42eiQDWeKQsbLA82shv1RJci21m98P2AMeWOimgNL1dIjKjvWGCfl6mTqzEFdOLaqZzhQlMJU4s2l27WTeiCyYmX0lKM5PkERpwHPRs76K0V8ib5L7IGCDHG/AC3gF0hi/37MJISsFc5MqqdxqDi4i5l7PnZTuUycX250navscibnvRrubRzlTYTKxBxDo+Kgbn7cAdzt+AeFHYTCk9LPND8MX5wEsK1q+JvjC77L+TWZK6D/0WEQxxw4hWIAz1D528EP9TrnSxq/MEbcMJU0DovyyPi3Nb4SF/OhPFvJKQcTO93nH2m48EuqVxhlmukTn3nR0BLGGTEJ8u070FVNqPzefz1vyz1JfBTHcYN2tTZO85cSDVEqXHLTQIzyE9QQvk0qkvYpDGMXl42RNmg9gMwByX1pjyeK4PvJkT0l55ukZoEMyw+h/ly8RE8m8o8Fz0pZQFALjGd9rjAhSifrslG2i+9/mBqWhhuk094uQceMB5wdvdFKfyaIjZxyEtW+vwdgiXa/+yW/fqrPFJAZI+9r/alusXi2uRsrxZsb5ZMilaTH0Xo/Ktfn1CsQhj7lCKFMZPvMdhyXp7OFhGyYK4rRxI4N/GHQ11oeGICpzSWBVX/Qi2Y+H47qGvlxaugxqeydXAAx+5dvsQekWbMHruHg3x3GvMffzqY0KKterP2xZyDDEViT8X16Iby5Xt4Dq/F6hPcLK3QAv1U4raLgcaUkVYKVx/RSXDaub5X9SmLUePAIGBO/q7DNPqgv555uqZPm+fui5np
 t8BUGXft
 a0Yzg3YxFczhxkP9J8JmgGbp5RSeyzVstbzO23KukdiqaFjZafE9uKB5HHLiBxba8yqZAHnr4LzWY/z9aMoAX4vzf4WV2YI4q7mbVx9GK6IYlnGU4J6SpAd8nXBLdwDdkQ+r/7HWecA5jYQy96LCO0z5bEUx51zehXVyIoXdh4Vr3Ct4DkkiMr37TFVWoVsFmmBL6hlUb1GjFuCnuXd8FPI5asQ5NeTYl1QLQB8u4o3fBe032KK8GLHaJXYEb3cgt/eS9Mm3TAxRqRjCwWjxGZ1PvK0XAyXAG7b71i2GSi1szRjINNls9VRQ8JXaO9ks++k+UK1FY2vEbu5RIxeywjZMru6gwqJyOB2KBfxzEJdRXfTKXLnsQvajB7BJmnf4WQWhOYtzvUlfK7yU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_iova() looks for free space by walking the rbtree linearly.
On production workloads at Meta, enough CPUs have ended up in that walk
at the same time to trigger soft lockups.

Index the iova ranges in a maple tree instead. Its gap search makes
alloc_iova() O(log n).

__alloc_and_insert_iova_range() asks mas_empty_area_rev() for the
highest free range below limit_pfn. Alignment is handled by rounding
up the allocation size, prioritizing speed over address space waste,
with the thought that many iova requests on a system will be similar
in size, and reuse the same holes.

remove_iova() stores NULL over the entry's range with
mas_store_gfp(&mas, NULL, GFP_ATOMIC). mas_erase() is not usable here:
it retries a failed allocation with GFP_KERNEL, which the irq-safe
iova_lock does not allow.

That store can fail when the tree needs a node to rebalance, and the
entry then stays in the tree. The next patch marks such a range and
retries the erase from iova_drain_deferred().

reserve_iova() widens the requested range to cover every overlapping
entry in iova_merge_overlaps(), stores one merged entry, and frees the
entries that entry supersedes. A request already covered by an existing
entry gets that entry back.

struct iova loses its rb_node and shrinks from 40 to 16 bytes. Remove
SLAB_HWCACHE_ALIGN to pack 4 iova structs in a cache line.

The tree tracks gaps itself, so the IOVA_ANCHOR sentinel and the
cached_node and cached32_node fields are gone.

iova_rbtree_lock is renamed to iova_lock and handed to the tree with
MT_FLAGS_LOCK_EXTERN, because the iova code can be called from interrupt
context, and an irq safe lock is needed. The same lock also protects
related iova data.

The rcache layer is unchanged. It deals in raw pfn values and does not
care what the ranges are kept in.

Assisted-by: Claude:claude-opus-4-8
Suggested-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 drivers/iommu/iova.c | 379 ++++++++++++++++---------------------------
 include/linux/iova.h |  10 +-
 2 files changed, 140 insertions(+), 249 deletions(-)

diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index 021daf6528de..69f80b14cb3d 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -13,9 +13,7 @@
 #include <linux/bitops.h>
 #include <linux/cpu.h>
 #include <linux/workqueue.h>
-
-/* The anchor node sits above the top of the usable address space */
-#define IOVA_ANCHOR	~0UL
+#include <linux/maple_tree.h>
 
 #define IOVA_RANGE_CACHE_MAX_SIZE 6	/* log of max cached IOVA range size (in pages) */
 
@@ -29,11 +27,6 @@ static void free_iova_rcaches(struct iova_domain *iovad);
 static void free_cpu_cached_iovas(unsigned int cpu, struct iova_domain *iovad);
 static void free_global_cached_iovas(struct iova_domain *iovad);
 
-static struct iova *to_iova(struct rb_node *node)
-{
-	return rb_entry(node, struct iova, node);
-}
-
 void
 init_iova_domain(struct iova_domain *iovad, unsigned long granule,
 	unsigned long start_pfn)
@@ -45,180 +38,68 @@ init_iova_domain(struct iova_domain *iovad, unsigned long granule,
 	 */
 	BUG_ON((granule > PAGE_SIZE) || !is_power_of_2(granule));
 
-	spin_lock_init(&iovad->iova_rbtree_lock);
-	iovad->rbroot = RB_ROOT;
-	iovad->cached_node = &iovad->anchor.node;
-	iovad->cached32_node = &iovad->anchor.node;
+	spin_lock_init(&iovad->iova_lock);
+	/*
+	 * IOVAs are freed from hardirq context; use the irq-safe iova_lock,
+	 * instead of the mtree lock. It also protects related iova data.
+	 */
+	mt_init_flags(&iovad->mtree,
+		      MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN);
+	mt_set_external_lock(&iovad->mtree, &iovad->iova_lock);
 	iovad->granule = granule;
 	iovad->start_pfn = start_pfn;
 	iovad->dma_32bit_pfn = 1UL << (32 - iova_shift(iovad));
 	iovad->max32_alloc_size = iovad->dma_32bit_pfn;
-	iovad->anchor.pfn_lo = iovad->anchor.pfn_hi = IOVA_ANCHOR;
-	rb_link_node(&iovad->anchor.node, NULL, &iovad->rbroot.rb_node);
-	rb_insert_color(&iovad->anchor.node, &iovad->rbroot);
 }
 EXPORT_SYMBOL_GPL(init_iova_domain);
 
-static struct rb_node *
-__get_cached_rbnode(struct iova_domain *iovad, unsigned long limit_pfn)
-{
-	if (limit_pfn <= iovad->dma_32bit_pfn)
-		return iovad->cached32_node;
-
-	return iovad->cached_node;
-}
-
-static void
-__cached_rbnode_insert_update(struct iova_domain *iovad, struct iova *new)
-{
-	if (new->pfn_hi < iovad->dma_32bit_pfn)
-		iovad->cached32_node = &new->node;
-	else
-		iovad->cached_node = &new->node;
-}
-
-static void
-__cached_rbnode_delete_update(struct iova_domain *iovad, struct iova *free)
-{
-	struct iova *cached_iova;
-
-	cached_iova = to_iova(iovad->cached32_node);
-	if (free == cached_iova ||
-	    (free->pfn_hi < iovad->dma_32bit_pfn &&
-	     free->pfn_lo >= cached_iova->pfn_lo))
-		iovad->cached32_node = rb_next(&free->node);
-
-	if (free->pfn_lo < iovad->dma_32bit_pfn)
-		iovad->max32_alloc_size = iovad->dma_32bit_pfn;
-
-	cached_iova = to_iova(iovad->cached_node);
-	if (free->pfn_lo >= cached_iova->pfn_lo)
-		iovad->cached_node = rb_next(&free->node);
-}
-
-static struct rb_node *iova_find_limit(struct iova_domain *iovad, unsigned long limit_pfn)
-{
-	struct rb_node *node, *next;
-	/*
-	 * Ideally what we'd like to judge here is whether limit_pfn is close
-	 * enough to the highest-allocated IOVA that starting the allocation
-	 * walk from the anchor node will be quicker than this initial work to
-	 * find an exact starting point (especially if that ends up being the
-	 * anchor node anyway). This is an incredibly crude approximation which
-	 * only really helps the most likely case, but is at least trivially easy.
-	 */
-	if (limit_pfn > iovad->dma_32bit_pfn)
-		return &iovad->anchor.node;
-
-	node = iovad->rbroot.rb_node;
-	while (to_iova(node)->pfn_hi < limit_pfn)
-		node = node->rb_right;
-
-search_left:
-	while (node->rb_left && to_iova(node->rb_left)->pfn_lo >= limit_pfn)
-		node = node->rb_left;
-
-	if (!node->rb_left)
-		return node;
-
-	next = node->rb_left;
-	while (next->rb_right) {
-		next = next->rb_right;
-		if (to_iova(next)->pfn_lo >= limit_pfn) {
-			node = next;
-			goto search_left;
-		}
-	}
-
-	return node;
-}
-
-/* Insert the iova into domain rbtree by holding writer lock */
-static void
-iova_insert_rbtree(struct rb_root *root, struct iova *iova,
-		   struct rb_node *start)
-{
-	struct rb_node **new, *parent = NULL;
-
-	new = (start) ? &start : &(root->rb_node);
-	/* Figure out where to put new node */
-	while (*new) {
-		struct iova *this = to_iova(*new);
-
-		parent = *new;
-
-		if (iova->pfn_lo < this->pfn_lo)
-			new = &((*new)->rb_left);
-		else if (iova->pfn_lo > this->pfn_lo)
-			new = &((*new)->rb_right);
-		else {
-			WARN_ON(1); /* this should not happen */
-			return;
-		}
-	}
-	/* Add new node and rebalance tree. */
-	rb_link_node(&iova->node, parent, new);
-	rb_insert_color(&iova->node, root);
-}
-
 static int __alloc_and_insert_iova_range(struct iova_domain *iovad,
 		unsigned long size, unsigned long limit_pfn,
 			struct iova *new, bool size_aligned)
 {
-	struct rb_node *curr, *prev;
-	struct iova *curr_iova;
 	unsigned long flags;
-	unsigned long new_pfn, retry_pfn;
+	unsigned long new_pfn;
 	unsigned long align_mask = ~0UL;
-	unsigned long high_pfn = limit_pfn, low_pfn = iovad->start_pfn;
+	unsigned long search_size = size;
+	MA_STATE(mas, &iovad->mtree, 0, 0);
+
+	if (size_aligned) {
+		unsigned long align = 1UL << fls_long(size - 1);
 
-	if (size_aligned)
 		align_mask <<= fls_long(size - 1);
+		search_size = size + align - 1;
+	}
 
-	/* Walk the tree backwards */
-	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
+	spin_lock_irqsave(&iovad->iova_lock, flags);
+	/* No 32-bit request this large can fit until the hint is cleared. */
 	if (limit_pfn <= iovad->dma_32bit_pfn &&
 			size >= iovad->max32_alloc_size)
-		goto iova32_full;
-
-	curr = __get_cached_rbnode(iovad, limit_pfn);
-	curr_iova = to_iova(curr);
-	retry_pfn = curr_iova->pfn_hi;
-
-retry:
-	do {
-		high_pfn = min(high_pfn, curr_iova->pfn_lo);
-		new_pfn = (high_pfn - size) & align_mask;
-		prev = curr;
-		curr = rb_prev(curr);
-		curr_iova = to_iova(curr);
-	} while (curr && new_pfn <= curr_iova->pfn_hi && new_pfn >= low_pfn);
-
-	if (high_pfn < size || new_pfn < low_pfn) {
-		if (low_pfn == iovad->start_pfn && retry_pfn < limit_pfn) {
-			high_pfn = limit_pfn;
-			low_pfn = retry_pfn + 1;
-			curr = iova_find_limit(iovad, limit_pfn);
-			curr_iova = to_iova(curr);
-			goto retry;
-		}
-		iovad->max32_alloc_size = size;
-		goto iova32_full;
+		goto alloc_fail;
+
+	if (mas_empty_area_rev(&mas, iovad->start_pfn,
+				 limit_pfn - 1, search_size)) {
+		/* Only real exhaustion sets the hint, not a failed store. */
+		if (limit_pfn <= iovad->dma_32bit_pfn)
+			iovad->max32_alloc_size = size;
+		goto alloc_fail;
 	}
 
-	/* pfn_lo will point to size aligned address if size_aligned is set */
+	/* The gap is search_size wide, so alignment cannot pass start_pfn. */
+	new_pfn = (mas.last - size + 1) & align_mask;
+
 	new->pfn_lo = new_pfn;
-	new->pfn_hi = new->pfn_lo + size - 1;
+	new->pfn_hi = new_pfn + size - 1;
 
-	/* If we have 'prev', it's a valid place to start the insertion. */
-	iova_insert_rbtree(&iovad->rbroot, new, prev);
-	__cached_rbnode_insert_update(iovad, new);
+	mas.index = new->pfn_lo;
+	mas.last = new->pfn_hi;
+	if (mas_store_gfp(&mas, new, GFP_ATOMIC))
+		goto alloc_fail;
 
-	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+	spin_unlock_irqrestore(&iovad->iova_lock, flags);
 	return 0;
 
-iova32_full:
-	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+alloc_fail:
+	spin_unlock_irqrestore(&iovad->iova_lock, flags);
 	return -ENOMEM;
 }
 
@@ -233,8 +114,7 @@ static struct iova *alloc_iova_mem(void)
 
 static void free_iova_mem(struct iova *iova)
 {
-	if (iova->pfn_lo != IOVA_ANCHOR)
-		kmem_cache_free(iova_cache, iova);
+	kmem_cache_free(iova_cache, iova);
 }
 
 /**
@@ -275,29 +155,29 @@ EXPORT_SYMBOL_GPL(alloc_iova);
 static struct iova *
 private_find_iova(struct iova_domain *iovad, unsigned long pfn)
 {
-	struct rb_node *node = iovad->rbroot.rb_node;
-
-	assert_spin_locked(&iovad->iova_rbtree_lock);
-
-	while (node) {
-		struct iova *iova = to_iova(node);
-
-		if (pfn < iova->pfn_lo)
-			node = node->rb_left;
-		else if (pfn > iova->pfn_hi)
-			node = node->rb_right;
-		else
-			return iova;	/* pfn falls within iova's range */
-	}
+	MA_STATE(mas, &iovad->mtree, pfn, pfn);
 
-	return NULL;
+	assert_spin_locked(&iovad->iova_lock);
+	return mas_walk(&mas);
 }
 
 static void remove_iova(struct iova_domain *iovad, struct iova *iova)
 {
-	assert_spin_locked(&iovad->iova_rbtree_lock);
-	__cached_rbnode_delete_update(iovad, iova);
-	rb_erase(&iova->node, &iovad->rbroot);
+	MA_STATE(mas, &iovad->mtree, iova->pfn_lo, iova->pfn_hi);
+
+	assert_spin_locked(&iovad->iova_lock);
+
+	if (iova->pfn_lo < iovad->dma_32bit_pfn)
+		iovad->max32_alloc_size = iovad->dma_32bit_pfn;
+
+	/*
+	 * A failed store leaves the iova in the tree, so it cannot be freed
+	 * here. The range stays reserved until the domain is torn down.
+	 */
+	if (mas_store_gfp(&mas, NULL, GFP_ATOMIC))
+		return;
+
+	free_iova_mem(iova);
 }
 
 /**
@@ -312,10 +192,9 @@ struct iova *find_iova(struct iova_domain *iovad, unsigned long pfn)
 	unsigned long flags;
 	struct iova *iova;
 
-	/* Take the lock so that no other thread is manipulating the rbtree */
-	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
+	spin_lock_irqsave(&iovad->iova_lock, flags);
 	iova = private_find_iova(iovad, pfn);
-	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+	spin_unlock_irqrestore(&iovad->iova_lock, flags);
 	return iova;
 }
 EXPORT_SYMBOL_GPL(find_iova);
@@ -331,10 +210,9 @@ __free_iova(struct iova_domain *iovad, struct iova *iova)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
+	spin_lock_irqsave(&iovad->iova_lock, flags);
 	remove_iova(iovad, iova);
-	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
-	free_iova_mem(iova);
+	spin_unlock_irqrestore(&iovad->iova_lock, flags);
 }
 EXPORT_SYMBOL_GPL(__free_iova);
 
@@ -351,15 +229,14 @@ free_iova(struct iova_domain *iovad, unsigned long pfn)
 	unsigned long flags;
 	struct iova *iova;
 
-	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
+	spin_lock_irqsave(&iovad->iova_lock, flags);
 	iova = private_find_iova(iovad, pfn);
 	if (!iova) {
-		spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+		spin_unlock_irqrestore(&iovad->iova_lock, flags);
 		return;
 	}
 	remove_iova(iovad, iova);
-	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
-	free_iova_mem(iova);
+	spin_unlock_irqrestore(&iovad->iova_lock, flags);
 }
 EXPORT_SYMBOL_GPL(free_iova);
 
@@ -445,27 +322,26 @@ static void iova_domain_free_rcaches(struct iova_domain *iovad)
  */
 void put_iova_domain(struct iova_domain *iovad)
 {
-	struct iova *iova, *tmp;
+	unsigned long flags;
+	struct iova *iova;
+
+	MA_STATE(mas, &iovad->mtree, 0, 0);
 
 	if (iovad->rcaches)
 		iova_domain_free_rcaches(iovad);
 
-	rbtree_postorder_for_each_entry_safe(iova, tmp, &iovad->rbroot, node)
+	/*
+	 * Nothing else can reach a domain being destroyed, but the maple tree
+	 * walk still has to hold the lock the tree was given.
+	 */
+	spin_lock_irqsave(&iovad->iova_lock, flags);
+	mas_for_each(&mas, iova, ULONG_MAX)
 		free_iova_mem(iova);
+	__mt_destroy(&iovad->mtree);
+	spin_unlock_irqrestore(&iovad->iova_lock, flags);
 }
 EXPORT_SYMBOL_GPL(put_iova_domain);
 
-static int
-__is_range_overlap(struct rb_node *node,
-	unsigned long pfn_lo, unsigned long pfn_hi)
-{
-	struct iova *iova = to_iova(node);
-
-	if ((pfn_lo <= iova->pfn_hi) && (pfn_hi >= iova->pfn_lo))
-		return 1;
-	return 0;
-}
-
 static inline struct iova *
 alloc_and_init_iova(unsigned long pfn_lo, unsigned long pfn_hi)
 {
@@ -480,27 +356,28 @@ alloc_and_init_iova(unsigned long pfn_lo, unsigned long pfn_hi)
 	return iova;
 }
 
-static struct iova *
-__insert_new_range(struct iova_domain *iovad,
-	unsigned long pfn_lo, unsigned long pfn_hi)
+/*
+ * A maple tree cannot hold overlapping ranges, so overlapping reservations
+ * have to be merged into one wider entry.
+ */
+static struct iova *iova_merge_overlaps(struct iova_domain *iovad,
+					unsigned long *lo, unsigned long *hi)
 {
-	struct iova *iova;
+	unsigned long pfn_lo = *lo, pfn_hi = *hi;
+	struct iova *overlap;
 
-	iova = alloc_and_init_iova(pfn_lo, pfn_hi);
-	if (iova)
-		iova_insert_rbtree(&iovad->rbroot, iova, NULL);
+	MA_STATE(mas, &iovad->mtree, pfn_lo, pfn_hi);
 
-	return iova;
-}
+	mas_for_each(&mas, overlap, pfn_hi) {
+		if (pfn_lo >= overlap->pfn_lo && pfn_hi <= overlap->pfn_hi)
+			return overlap;
+		if (overlap->pfn_lo < *lo)
+			*lo = overlap->pfn_lo;
+		if (overlap->pfn_hi > *hi)
+			*hi = overlap->pfn_hi;
+	}
 
-static void
-__adjust_overlap_range(struct iova *iova,
-	unsigned long *pfn_lo, unsigned long *pfn_hi)
-{
-	if (*pfn_lo < iova->pfn_lo)
-		iova->pfn_lo = *pfn_lo;
-	if (*pfn_hi > iova->pfn_hi)
-		*pfn_lo = iova->pfn_hi + 1;
+	return NULL;
 }
 
 /**
@@ -510,41 +387,59 @@ __adjust_overlap_range(struct iova *iova,
  * @pfn_hi:- higher pfn address
  * This function allocates reserves the address range from pfn_lo to pfn_hi so
  * that this address is not dished out as part of alloc_iova.
+ *
+ * If the requested range overlaps existing reservations, ranges are merged.
+ * If the requested range is fully covered by an existing reservation, the
+ * existing entry is returned without allocating.
  */
 struct iova *
 reserve_iova(struct iova_domain *iovad,
 	unsigned long pfn_lo, unsigned long pfn_hi)
 {
-	struct rb_node *node;
+	unsigned long merged_lo = pfn_lo, merged_hi = pfn_hi;
+	struct iova *iova, *overlap;
 	unsigned long flags;
-	struct iova *iova;
-	unsigned int overlap = 0;
+
+	MA_STATE(mas, &iovad->mtree, 0, 0);
+	MA_STATE(fmas, &iovad->mtree, 0, 0);
 
 	/* Don't allow nonsensical pfns */
 	if (WARN_ON((pfn_hi | pfn_lo) > (ULLONG_MAX >> iova_shift(iovad))))
 		return NULL;
 
-	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
-	for (node = rb_first(&iovad->rbroot); node; node = rb_next(node)) {
-		if (__is_range_overlap(node, pfn_lo, pfn_hi)) {
-			iova = to_iova(node);
-			__adjust_overlap_range(iova, &pfn_lo, &pfn_hi);
-			if ((pfn_lo >= iova->pfn_lo) &&
-				(pfn_hi <= iova->pfn_hi))
-				goto finish;
-			overlap = 1;
-
-		} else if (overlap)
-				break;
-	}
+	spin_lock_irqsave(&iovad->iova_lock, flags);
+
+	/*
+	 * The overlapping iovas cannot be freed yet: the merged store below
+	 * can fail, and freeing before a failed store would leave dangling
+	 * pointers in the tree.
+	 */
+	iova = iova_merge_overlaps(iovad, &merged_lo, &merged_hi);
+	if (iova)
+		goto out;
+
+	iova = alloc_and_init_iova(merged_lo, merged_hi);
+	if (!iova)
+		goto out;
 
-	/* We are here either because this is the first reserver node
-	 * or need to insert remaining non overlap addr range
+	/*
+	 * The superseded overlaps are freed before the merged store, so the
+	 * store must not be able to fail after that point.
 	 */
-	iova = __insert_new_range(iovad, pfn_lo, pfn_hi);
-finish:
+	mas_set_range(&mas, merged_lo, merged_hi);
+	if (mas_preallocate(&mas, iova, GFP_ATOMIC)) {
+		free_iova_mem(iova);
+		iova = NULL;
+		goto out;
+	}
+
+	mas_set_range(&fmas, merged_lo, merged_hi);
+	mas_for_each(&fmas, overlap, merged_hi)
+		free_iova_mem(overlap);
 
-	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+	mas_store_prealloc(&mas, iova);
+out:
+	spin_unlock_irqrestore(&iovad->iova_lock, flags);
 	return iova;
 }
 EXPORT_SYMBOL_GPL(reserve_iova);
@@ -621,7 +516,7 @@ iova_magazine_free_pfns(struct iova_magazine *mag, struct iova_domain *iovad)
 	unsigned long flags;
 	int i;
 
-	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
+	spin_lock_irqsave(&iovad->iova_lock, flags);
 
 	for (i = 0 ; i < mag->size; ++i) {
 		struct iova *iova = private_find_iova(iovad, mag->pfns[i]);
@@ -633,7 +528,7 @@ iova_magazine_free_pfns(struct iova_magazine *mag, struct iova_domain *iovad)
 		free_iova_mem(iova);
 	}
 
-	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+	spin_unlock_irqrestore(&iovad->iova_lock, flags);
 
 	mag->size = 0;
 }
@@ -956,8 +851,8 @@ int iova_cache_get(void)
 
 	mutex_lock(&iova_cache_mutex);
 	if (!iova_cache_users) {
-		iova_cache = kmem_cache_create("iommu_iova", sizeof(struct iova), 0,
-					       SLAB_HWCACHE_ALIGN, NULL);
+		iova_cache = kmem_cache_create("iommu_iova", sizeof(struct iova),
+					       0, 0, NULL);
 		if (!iova_cache)
 			goto out_err;
 
diff --git a/include/linux/iova.h b/include/linux/iova.h
index d2c4fd923efa..a3dab6c5fd62 100644
--- a/include/linux/iova.h
+++ b/include/linux/iova.h
@@ -11,12 +11,11 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/rbtree.h>
+#include <linux/maple_tree.h>
 #include <linux/dma-mapping.h>
 
 /* iova structure */
 struct iova {
-	struct rb_node	node;
 	unsigned long	pfn_hi; /* Highest allocated pfn */
 	unsigned long	pfn_lo; /* Lowest allocated pfn */
 };
@@ -26,15 +25,12 @@ struct iova_rcache;
 
 /* holds all the iova translations for a domain */
 struct iova_domain {
-	spinlock_t	iova_rbtree_lock; /* Lock to protect update of rbtree */
-	struct rb_root	rbroot;		/* iova domain rbtree root */
-	struct rb_node	*cached_node;	/* Save last alloced node */
-	struct rb_node	*cached32_node; /* Save last 32-bit alloced node */
+	spinlock_t	iova_lock;	/* Protects the maple tree */
+	struct maple_tree	mtree;
 	unsigned long	granule;	/* pfn granularity for this domain */
 	unsigned long	start_pfn;	/* Lower limit for this domain */
 	unsigned long	dma_32bit_pfn;
 	unsigned long	max32_alloc_size; /* Size of last failed allocation */
-	struct iova	anchor;		/* rbtree lookup anchor */
 
 	struct iova_rcache	*rcaches;
 	struct hlist_node	cpuhp_dead;
-- 
2.53.0-Meta


