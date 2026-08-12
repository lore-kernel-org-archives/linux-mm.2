Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17F3EC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A14456B0136; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9764F6B0132; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF856B0132; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2199F6B012C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 792E9404A6
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:19 +0000 (UTC)
X-FDA: 85093505238.06.2DAB396
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 75319180007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n3h7g2Af;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560557;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xTSbxvo8z0T/fr9F5k1/hfJGviDhsKPh79XyXJ8IdDM=;
	b=bWHKRPi/Hehh10P41sgVbdBWyF2I1Y8jnjeu7fY5oLDWjztumDQVDMSTnp1vPQi1t4dreX
	SXegI76kE8oA+6tO+N9zd+QTJt6eZQYcVYJ9UrEi9G1WGnLN5CcCeCoW1CNA4q0CezP2wz
	H0at384AIR8E/Rl5S0mJASm2z/3McZg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n3h7g2Af;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560557;
	b=KJgkRy5mflcNvZm9P0CRlwIUzKxty1dbdHWaRByaKBl8Lgm52zZjUDgFzgy3V4pWTt2/7D
	fpmL+Xo5OIZVuDsmLOxn2HNX43VKJQoGbMbfQjh/2xGUz1g7yyyKhDETsuk3+LOOxxJQ4v
	W7+f91AbYxHe+0dA+gio0zlf/GLR6Yw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F67C436FD;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21FEAC2BCFA;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560554;
	bh=yTjGUsr5g9OFnQ9yDghu9h7RK/P5ptVFPG2sEI+z3Wc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=n3h7g2AfQuTxSC4Ia/kxUh00TA9G0YnK4xIXM/qtin9N9l60cduWHdo7RFY7blv8P
	 Xv5/LFLfTMQvmaW6jIvsGsSzJJazqTdDebXvlqvU3wgyIE+jHLP4GAn9YGvvpHW0oq
	 EcIM6ijAMk0fjIojGgF8tBsKzYrjFilQoUJRRUpO3rLAoVXj2lASgH8W11FCNrl0/m
	 5Q2kSD04z+uMeOTl0NEbOMz+oPovuSxYGVG86iC98NdBisxez+HX8TlId8SqWRTAi4
	 EO/yehZrTeNoUJW3kv2y3Rt0sutbgIg9IVKVBllUG7Kx025RcLaM19d8PWTfyWJlyZ
	 wfkWVm+DU2DGQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8B7C5B572;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 02:48:49 +0800
Subject: [PATCH v2 09/17] mm/huge_memory: move anon_vma and filemap
 management into split helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-thp-cleanup-v2-9-d2ee48c6aa49@tencent.com>
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
In-Reply-To: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560550; l=9165;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=0NuWyqJHUx62udm2N5rM+d4jHQFwYvmMac4Toewk69E=;
 b=tJ0I1Q33J8AEg43ux4k8RgZxRXS8g10JnOs+kJKgDx6SFAfK3Zc36qSUwGRhajCOOff7oi/0x
 0+6N0bw6jAJARacIH/W4jtsAGYntEogbb6PQq6OAAouJalpeAcmDaET
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: t33iiuy1bnp1qbjsfe3okq6h1dwooi6p
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 75319180007
X-HE-Tag: 1786560557-131512
X-HE-Meta: U2FsdGVkX197rfktYG7vn5+5n5b4jA9O/V/uO4LqcoaR+X0Sj9mIhsqVxOLQsYcXO0WKMMcY7QBOjfChsW0Ta2dWIBYM03hIeJeGcoU6LnO8lK4ejM5XgiFnBW6UmOp57cZ/p5urm7kf/D88vVUomAj3KYKpGRkZNVBNBaJktvELaEOVJ+xAitkJ55jEbIK7t1bV/fOtUgMC2vqeeoU6ol14KuFENuLDrbjy4kHZMjvWcBlRRBMyj1ViYtljJJb4+FkXjfXJ5fSjOFkG6Q+UvJ5hqopFjM6RKVF2x6ykpCFD2Qo1ozypEativja0rxqPpOdu9G9hxQD4LrXbqhdYJcNDcW5neeXBwZo1G3wfyjk04t49tJhWlHR7ERZz5ySJPoWQz1Ri/bDQhmlSVVLF3KRpdERh4t6RlwGEvKOyTA5+483/T9Zm5rTsN/FTV/2t+TnmzEswxLbxojd0EI5a+8qjje8yk2MiCsY5lNNe7NANH6DwsxH91r+K6hKvvGTV8vBmTRRELJowdWHUh+83Ita26Pkvf1/krnoNiIzQHrSFunGss1AQuS3HJ1KLhn8Wv7fVFDS8sCdSQ+NW3AeINyr+Du6ZGeF3XWW9ESu0VZz3w2NNmiCsKzdegAJP/eGurUKD+G0Svd1fdoPE4Zsv8+5VOCLqkZN5/RBibOP7yc+kP9m+1J0CZnUG0WAS5xrZKcyeE4qxP5HZO1Neq2LXgS7sIquYDxD+USHXgpdPUSC0W4fzI9UVB+S6V65RJ6Nmcm8RG9pERMrCNnUj7uRJNIa+h8nGD39ubo6Y5v1/EjLun7Si0pMOB2imCgcK31iIUsZBerUOV4L+nQrg+DFXRbmHdmL/as1UCzxFRZpmFfH8QlC/r1pZhT0K2E0orP/vSY49uHxxvHM3CbkXGODZPpVs5FkC2iQ6NhB5UT8PV4R3VjgxmlBjOhC2Hn2o2kqaF3U7dx2OAU2wJfD8uBE
 f9BZHSjJ
 GyFtYRv0i8ZldwNB6Qe4fhkmdlXUiGrEDKg/hjYfMM3QUooouiSmXf2Q5jD5/3LXJyNa7s348dUFcGXqbjEEZNWy/2CeDY6bJhhFaPUM23Skv8cyAD8kx+el35mhYZujC/gHGcOr3C1ykdgEwuyKkX4SuV7ZOACjjsMzO3KXRCL+rFrQZ4vKNWOCrVTJfChBeN+/UvUPqYCjl50VDnNZJH+z/KUnDhCpNbnJUaCy8K9YC1bafOMX18tcV1sTF96ECJA4hMj6fHGcrhWxU994//MaElE91YN6/asZcN8lZ6xcUWP8cyiifkDRI0hw53EUrECCO3quwjjBBzv7kqaJrjVIfB+pSLw6jKZ9rLeCkAuQeoXHM4DMup0g53qkJD07eNL5vnSr7FsBoa7ea3XHBJmIcIuR3qehkwEsw5o5R6BRzV5j+1tiHA2lm9gP+IMthdPYRmmiX4oFq+8GyXMWhVL+m6CTpY0yCsr+w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Only anon split needs vma info, and only file split needs the filemap
handling. Move the related code into separate helpers so they are
genuinely more self-contained.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 177 +++++++++++++++++++++++++------------------------------
 1 file changed, 79 insertions(+), 98 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index aa10a13bc255..1a3ca2606c60 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3950,12 +3950,33 @@ static int __folio_split_unmap_and_freeze_anon(struct folio *folio, unsigned int
 	struct swap_cluster_info *ci = NULL;
 	struct folio *new_folio, *next;
 	int old_order = folio_order(folio);
+	struct anon_vma *anon_vma = NULL;
 	enum ttu_flags ttu_flags = 0;
 	struct list_lru_one *lru;
 	struct lruvec *lruvec;
 	bool dequeue_deferred;
 	int ret = 0;
 
+	/*
+	 * Unmap/remap needs the anon_vma. The caller does not necessarily
+	 * hold an mmap_lock that would prevent the anon_vma from
+	 * disappearing, so we first take a reference and lock it. This is
+	 * similar to folio_lock_anon_vma_read() except the write lock is
+	 * taken to serialize against parallel split or collapse.
+	 */
+	if (unmap) {
+		anon_vma = folio_get_anon_vma(folio);
+		if (!anon_vma)
+			return -EBUSY;
+		anon_vma_lock_write(anon_vma);
+	}
+
+	/* Racy check if we can split the page, before the optional unmap. */
+	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
 	if (unmap)
 		unmap_folio(folio);
 
@@ -4039,21 +4060,58 @@ static int __folio_split_unmap_and_freeze_anon(struct folio *folio, unsigned int
 			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
 		remap_page(folio, 1 << old_order, ttu_flags);
 	}
+out_unlock:
+	if (anon_vma) {
+		anon_vma_unlock_write(anon_vma);
+		put_anon_vma(anon_vma);
+	}
 
 	return ret;
 }
 
 static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int new_order,
-					       struct page *split_at, struct xa_state *xas,
-					       struct address_space *mapping, bool do_lru,
+					       struct page *split_at, bool do_lru,
 					       struct list_head *list, enum split_type split_type)
 {
+	struct address_space *mapping = folio->mapping;
+	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
+	unsigned int min_order;
 	struct lruvec *lruvec;
 	pgoff_t end = 0;
-	int ret;
+	gfp_t gfp;
+	int ret = 0;
+
+	min_order = mapping_min_folio_order(mapping);
+	if (new_order < min_order)
+		return -EINVAL;
+
+	gfp = current_gfp_context(mapping_gfp_mask(mapping) & GFP_RECLAIM_MASK);
+	if (!filemap_release_folio(folio, gfp))
+		return -EBUSY;
+
+	mapping_set_update(&xas, mapping);
+
+	if (split_type == SPLIT_TYPE_UNIFORM) {
+		int old_order = folio_order(folio);
+
+		xas_set_order(&xas, folio->index, new_order);
+		xas_split_alloc(&xas, folio, old_order, gfp);
+		if (xas_error(&xas)) {
+			ret = xas_error(&xas);
+			goto fail_free;
+		}
+	}
+
+	i_mmap_lock_read(mapping);
+
+	/* Racy check if we can split the page, before unmap_folio() */
+	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
+		ret = -EAGAIN;
+		goto fail_mmap_unlock;
+	}
 
 	/*
 	 * __split_frozen_folio() may need to trim off pages beyond
@@ -4068,13 +4126,13 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 
 	unmap_folio(folio);
 
-	xas_lock_irq(xas);
+	xas_lock_irq(&xas);
 
 	/*
 	 * Check if the folio is present in page cache.
 	 * We assume all tail are present too, if folio is there.
 	 */
-	if (xas_load(xas) != folio) {
+	if (xas_load(&xas) != folio) {
 		ret = -EAGAIN;
 		goto fail;
 	}
@@ -4101,7 +4159,7 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_frozen_folio(folio, new_order, split_at, xas,
+	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
 				   mapping, split_type);
 
 	/*
@@ -4153,9 +4211,19 @@ static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int
 	 * If we want to use try_to_migrate() on file in unmap_folio,
 	 * remember to add remap_page() and adapt it.
 	 */
-	xas_unlock_irq(xas);
+	xas_unlock_irq(&xas);
+fail_mmap_unlock:
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
+	/*
+	 * Drop the mapping while the inode is still pinned. @folio stays
+	 * locked and present in the page cache, so eviction cannot free
+	 * the inode yet, nothing past this point may touch the inode or
+	 * the mapping.
+	 */
+	i_mmap_unlock_read(mapping);
+fail_free:
+	xas_destroy(&xas);
 	return ret;
 }
 
@@ -4184,12 +4252,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
 		struct list_head *list, enum split_type split_type)
 {
-	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
 	struct mem_cgroup *memcg, *old_memcg;
-	struct address_space *mapping = NULL;
-	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	int ret;
@@ -4220,84 +4285,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	memcg = get_mem_cgroup_from_folio(folio);
 	old_memcg = set_active_memcg(memcg);
 
-	if (is_anon) {
-		/*
-		 * The caller does not necessarily hold an mmap_lock that would
-		 * prevent the anon_vma disappearing so we first we take a
-		 * reference to it and then lock the anon_vma for write. This
-		 * is similar to folio_lock_anon_vma_read except the write lock
-		 * is taken to serialise against parallel split or collapse
-		 * operations.
-		 */
-		anon_vma = folio_get_anon_vma(folio);
-		if (!anon_vma) {
-			ret = -EBUSY;
-			goto out;
-		}
-		anon_vma_lock_write(anon_vma);
-		mapping = NULL;
-	} else {
-		unsigned int min_order;
-		gfp_t gfp;
-
-		mapping = folio->mapping;
-		min_order = mapping_min_folio_order(mapping);
-		if (new_order < min_order) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		gfp = current_gfp_context(mapping_gfp_mask(mapping) &
-							GFP_RECLAIM_MASK);
-
-		if (!filemap_release_folio(folio, gfp)) {
-			ret = -EBUSY;
-			goto out;
-		}
-
-		mapping_set_update(&xas, mapping);
-
-		if (split_type == SPLIT_TYPE_UNIFORM) {
-			xas_set_order(&xas, folio->index, new_order);
-			xas_split_alloc(&xas, folio, old_order, gfp);
-			if (xas_error(&xas)) {
-				ret = xas_error(&xas);
-				goto out;
-			}
-		}
-
-		anon_vma = NULL;
-		i_mmap_lock_read(mapping);
-	}
-
-	/*
-	 * Racy check if we can split the page, before unmap_folio() will
-	 * split PMDs
-	 */
-	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
-		ret = -EAGAIN;
-		goto out_unlock;
-	}
-
-	if (!is_anon) {
-		ret = __folio_split_unmap_and_freeze_file(folio, new_order, split_at, &xas, mapping,
-							  true, list, split_type);
-	} else {
+	if (is_anon)
 		ret = __folio_split_unmap_and_freeze_anon(folio, new_order, split_at, true,
 							  true, list, split_type);
-	}
-
-	/*
-	 * Drop the mapping while the inode is still pinned. @folio stays
-	 * locked and present in the page cache until the loop below, so
-	 * eviction cannot free the inode yet; @lock_at is not enough, it may
-	 * be a tail beyond EOF that the split already dropped from the page
-	 * cache. Nothing past this point may touch the inode or the mapping.
-	 */
-	if (mapping) {
-		i_mmap_unlock_read(mapping);
-		mapping = NULL;
-	}
+	else
+		ret = __folio_split_unmap_and_freeze_file(folio, new_order, split_at,
+							  true, list, split_type);
 
 	/*
 	 * Unlock all after-split folios except the one containing
@@ -4318,19 +4311,10 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		free_folio_and_swap_cache(new_folio);
 	}
 
-out_unlock:
-	if (anon_vma) {
-		anon_vma_unlock_write(anon_vma);
-		put_anon_vma(anon_vma);
-	}
-	if (mapping)
-		i_mmap_unlock_read(mapping);
-out:
 	/* restore to caller's old_memcg */
 	set_active_memcg(old_memcg);
 	mem_cgroup_put(memcg);
 out_no_memcg:
-	xas_destroy(&xas);
 	if (is_pmd_order(old_order))
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
@@ -4366,9 +4350,6 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
 
-	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
-		return -EAGAIN;
-
 	return __folio_split_unmap_and_freeze_anon(folio, new_order, &folio->page, false,
 						   false, NULL, SPLIT_TYPE_UNIFORM);
 }

-- 
2.55.0



