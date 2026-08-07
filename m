Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C511DC5ACD1
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5AD6B00A9; Fri,  7 Aug 2026 17:17:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A456B00B0; Fri,  7 Aug 2026 17:17:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9329E6B00A9; Fri,  7 Aug 2026 17:17:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28C3F6B00AB
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:17:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9231BA15F3
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:55 +0000 (UTC)
X-FDA: 85075735710.13.492A8C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 840984000F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LqSswVzZ;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786137473;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0vhuIygzWAk/cABBcXdjsvaEyJI/W6rgSn01Tua224g=;
	b=qD1XX+zcBCChoAvlMiHQiKKuvQQl8SbK7aqZUw8zOHEMwsU3CaIf/F6m/L+h5+z2PbKrWr
	Os9fDOwMBYIxJVmBUCimUtkPFu4fxpf1NuQcJ7GK+0YQff4hgUR4Cyx7LAp9hVxyyPmJgC
	XsW2ncub3Pd19BUDiVBlTA49F0uJRVc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LqSswVzZ;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786137473;
	b=DFn7gGlZJnyN0nj6o5DJmC8+QorM3yoVDA/xZhWrC77UsqQF1hACEJJGfDEIRPef7BMPqQ
	Lw1/ej5gItPv3vX1W7imx6uqFJMEE2erc5/CqeOm1lqX35cMcl8mFIGRqsL/bvOpHMlk+F
	RSCUXk8kqfhPcwsaoQflg/GlU5oNVsY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DB4E44084;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F7A1C19425;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786137470;
	bh=5VM1gvICKoR0rxwdh5lvSYtecezYifXxD2IyBpdRBbg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LqSswVzZfBoVoduboQvvWrOG8LS3ET0Nryk2d2lkF5wh+LTXC2AJm6Xgh/mz2Ob7S
	 2S6g+2sjU6WQ5wuY3ttsjfF9IEFKg0PgU+/8IUil7FgZU6Js+qpcGJbJ4aDZQim0mD
	 2AefkCQ1iVEquwDaBepkNpycn+pQaF6c40ufUl1E+ALiGOTE1QT4UPYI3dwedWzzVC
	 v8g1S0MowL5ih0egrIq2nKha0Ex2Uu1xDUp4PcpZ36fBf+sDHUJgf9S8yX1O9PpUqu
	 Nq2UaIWxvOELlEcYt8u+QQjrV7OlADlqOeZR7Un9X3+4AdMJkxs4Q0YqLc9mNs4LKf
	 WFz/JDeUe4tLA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A0E6C2A09B;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 08 Aug 2026 05:17:09 +0800
Subject: [PATCH RFC 08/13] mm/huge_memory: move anon_vma and filemap
 management into split helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260808-swap-thp-cleanup-v1-8-689939a7ccc3@tencent.com>
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
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
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786137467; l=9016;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Tdpu3yM2jJD/dLTIquK8QVzk8LI0pYKr2L3DEgrEOZY=;
 b=vE5S16rk8H6tQL7nMbKAIEEiUR03ZTW7o4PEm5gfVq7qO35uzHPGQa0PaRtrA3KeCbh9yKL8e
 qEexL8JeNZ1CjPd10TUfXx4AfXATeKc3jN/GArLUOjRiAlTTylK34wK
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 840984000F
X-Stat-Signature: 5hhzkac8fbejcui9g6za1u6did8r5nc7
X-HE-Tag: 1786137473-442494
X-HE-Meta: U2FsdGVkX1/3u6ZZWbPm08ZrFsyiIw3u/F5MIrnZr0hd4wj7b8oqGA5VzuhAXBO6V8NnXTCI+iYpZLRFj3OQQhORY52yojIryFBTO9YMhEWkA4l0Z1su+l/cAmtefQ+SAALHhk+71xKIbUQm7e2F7LRlWJz06vkC4V1GLjUrK55N54UK5wJER8mdmsJ4ZDR0IF7C14XGiZmQCw17i8bBereFNX8s3wAOIHjp4XAJwdG+ZcOoCFnKXrvm3E/PfjWcqSoCZyWiBlliZRz6uOyCnjkB055uMXxaRv+BCTDyTNEhd81I7HW0X/PJGhKmp/JI0FsylIvE8weLayndkXPT8eW9k8g8YGb3UFb1/F/aSR2Xir7DeuiMPlIS614kXaFa9D0dJlaAwD+ydWp8lQOMuPicaId7i50FeuCYR4vN6UNrvYeZ3xXCZ5PA6rA/aRgyuJIO7wJ9tbARSel8JOO0Voda0no4LJn3ZMChw3K/BRZY3bCSYzVodmj2dMgVP+ctDpzikEYhz2OEsFSzkESISb5h1MF1e82/y2o44/eI3Lw5GQiuK8NFgpTwLjp3ayyC5TtIPzv4y+4B1JF19YoGhxdHds2eyqMVTAXmmi1tMU8ro5YecoeRNhIMmNZIMwqtFvNaTwX1e7JfZAHi2It0gYqUjVF1TgEhFyarK9SItXId2zk0jl36V+r9/ur9db2LMtrJvtkD0XJT22b7Oy6R1rLJkaoGwsRX+X2RSUdB4/cEPifacaeZV0xUBXpHVEtFpv72/VeFEFAc+EknXBvvtleZ65Ob8f/5T8rvpFq060uf8CgRfGwqPvYf+lC5uH96YsVF6/6vSigEHdXcQf/LW7bn9SwfM8UDxNRZaJPxMDTOrlBf1f/FFTYt6GAQ5v94JxQFKZfzNkHbS3jZ9AcZ+zuNpGDr5nBXvN19gscvK1trUl6lGat3LqpXwy3SRY5j4xjXhR9gUQ4bMZxf5RS
 MFJU9PH4
 ISncLRsAZofw873/2d7O0qZ03Xvp4ThGf1/2YxnB/Nq4+mMKe1EKzEBsuGUOfXldtVL3ntlgPtyoQM0BkPUHJq5ldVUFwCsXW7j6EpQqW7zApivelowzCxZfJRpfzdB71JBqACAx8ywlnqJp0n76287yjMyt7f8mAQFbbbAw/FJDK2FlUsqJGGe8e9Bvfik8uJx/F6mOlMbO/dFCz/dNXC9ldfNABrfHigNHNq4qXl9uXnID0jECOzXDEWJOL3aOUcqsEdq+nSBqmCiMLjx9eNpiwLcNdyE/u1jqqZ1y2/Y78RJhZuTfEMiks3QX1vaVMuCMTW7a1RZvGCy4U5Wd7jN7xsvT5qmNq5J8PmjBD+4vVgPUaBkaDy1YRpmJOmCrel14ZV99aVmh6w1YJFJ1nALKOLzrQX0Y7xzrd3h5RhawPGYFTaVallXN/ogtpliPL8LprDKIUZzVvz/Y=
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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 177 +++++++++++++++++++++++++------------------------------
 1 file changed, 79 insertions(+), 98 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c0115841d1a0..f0ea6e5f53f7 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3939,12 +3939,33 @@ static int __folio_freeze_split_unmap_anon(struct folio *folio, unsigned int new
 	struct swap_cluster_info *ci = NULL;
 	struct folio *new_folio;
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
 
@@ -4031,21 +4052,58 @@ static int __folio_freeze_split_unmap_anon(struct folio *folio, unsigned int new
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
 
 static int __folio_freeze_split_unmap_file(struct folio *folio, unsigned int new_order,
-					   struct page *split_at, struct xa_state *xas,
-					   struct address_space *mapping, bool do_lru,
+					   struct page *split_at, bool do_lru,
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
 	 *__split_unmapped_folio() may need to trim off pages beyond
@@ -4060,13 +4118,13 @@ static int __folio_freeze_split_unmap_file(struct folio *folio, unsigned int new
 
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
@@ -4093,7 +4151,7 @@ static int __folio_freeze_split_unmap_file(struct folio *folio, unsigned int new
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_unmapped_folio(folio, new_order, split_at, xas,
+	ret = __split_unmapped_folio(folio, new_order, split_at, &xas,
 				     mapping, split_type);
 
 	/*
@@ -4145,9 +4203,19 @@ static int __folio_freeze_split_unmap_file(struct folio *folio, unsigned int new
 		lruvec_unlock(lruvec);
 
 fail:
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
 
@@ -4176,12 +4244,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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
@@ -4212,84 +4277,12 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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
-		ret = __folio_freeze_split_unmap_file(folio, new_order, split_at, &xas, mapping,
-							 true, list, split_type);
-	} else {
+	if (is_anon)
 		ret = __folio_freeze_split_unmap_anon(folio, new_order, split_at, true,
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
+		ret = __folio_freeze_split_unmap_file(folio, new_order, split_at,
+						      true, list, split_type);
 
 	/*
 	 * Unlock all after-split folios except the one containing
@@ -4310,19 +4303,10 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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
@@ -4358,9 +4342,6 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
 
-	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
-		return -EAGAIN;
-
 	return __folio_freeze_split_unmap_anon(folio, new_order, &folio->page, false,
 					       false, NULL, SPLIT_TYPE_UNIFORM);
 }

-- 
2.55.0



