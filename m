Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DF7CC531EB
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 23:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6A606B008C; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1F8D6B0096; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 703116B0092; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 32B376B009B
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F19C98C823
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:10 +0000 (UTC)
X-FDA: 84462832020.15.135F61B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E41362000D
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ozQVrw3f;
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771544529;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5qPt8PbMXLS0TvDXyjYMAYrh98oyECzEYf3ibtxeuZ8=;
	b=QKBwskzNxV/bLgjmQekF63OgxjQFYM2qlEGtFSOxoFjYX/L9BkHAdfQY/G3/NlHBqFce/r
	1lnpTeuZwvOU0AyGI+hIppos2J7AAnXX0Bb9OULafFOb30al1PAfJHer7ZTSKB0fMBmuMr
	R0NAaZIb0OhABKBRMkl8UvwCg2EC5D0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ozQVrw3f;
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771544529; a=rsa-sha256;
	cv=none;
	b=bm1bEC1+Buvc6v3WGgAAnbSa6Ho7Gp7xv6Uo/o6zFTOSWjKbD0O46EpvXWduAshAQPI/WE
	gQtD8esUCBPZekfAqrWi7qZfY5o6eKoVX52FESHuJ1Ewpkp6kH+eSOxkDdRK0exOpLZdZI
	WzRtNzawNhpJIXXYUVpaaTlzw2SaEdE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8706E444EF;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6754CC2BC87;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544527;
	bh=xxmdaXbJhm2fa/xOaTiqJLbiS6Wf5af2Y0X+Fu5RtUo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ozQVrw3fR2WH1Iv9/eXne8azFHDLeuJC+Zmj3eo9zHJOTf7MFMkqLTNoJeNzZfxb7
	 vEaRwJtqDMv1v9alomEUEVe/Uv5UyeiUkw3ymYUqhQMxOAs1KMzgenkc5TlqC1LiDJ
	 s1xLaiUR2ElFdmCQV4Oth0ukHW/uZ5YKfvbYK+8SiuFqFx4FwasYlyRtKu1h7U/20V
	 PiNFBzl43elGgUTMbxHYIm0tHAHAgiwUr0q9jUsYQC5YuIJ4F7LTB7y3cXSWOamHWv
	 gBZT/twWXLTH88IZlGn+3IITFPt/EHO9R2ORANTYa/8CUuhTSjZXaF61S3W0cx5L0S
	 9CbXqjfvLUAZg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D584E9A04F;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 20 Feb 2026 07:42:05 +0800
Subject: [PATCH RFC 04/15] mm, swap: add support for large order folios in
 swap cache directly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-swap-table-p4-v1-4-104795d19815@tencent.com>
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
In-Reply-To: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771544524; l=10217;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=iRaA16zPocun7MNZRSreX0nvZb3ZKPTMy/X1q06icVE=;
 b=zwpwc54oeGo2FV9brWSj7Ua9BWGbgsk7pitnp3rs3n/80DvSbA5U89WYopprBd/WDxiPl9kUJ
 8kbvnF3WNGkBhVzE4ooNnEcc9N7F5qKH7pOt9uS3DzM4hdGngRJzAty
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E41362000D
X-Stat-Signature: a3i34ahzikar3qqd6oqe9i4czph3m5w1
X-HE-Tag: 1771544528-294958
X-HE-Meta: U2FsdGVkX1+nqbv0V1jciu9b7mHTmblq158ArAgvJxpvlUzyeOhaMt+bTZWRA9rWyTAKib00ZVUoK7Km5RaiRGKCQxDY7aUKL2BW3aZr/hOv+z/0tbA0ePQtOXh87ZRWEIPzQ9HSCHqjD/T7ZXWIm5qBzY+ahT7c5/rhO2ByCw0bBNl4FyC7K7C/z6/WZO268mk6XKCOmLJDaMOCpQC/N1AJ9H4tC6CBD2gWUe47KH4ILKH86iYMBYbNjcT1jYikd5vD0uvSatO8D2zh+SjxC5tKrnBmmc85e7wS/QCB0suuRm3ax8Idos1oVI/ASTTCySuU7WgkZc1oNeJBGUTtcrXpKhFfuoZUXPLaRwd1ehAvD6LUz7pZ8BPPwWLfurBP3lWBlBlmDkOLzK50qqFLIcrh0Fw85GOELihMvwL9U0A0qOLdhHyDxyEr3xaovtJA5LdGqyzIV22M9vgiTu4D2abRJ5m2+kcXliIXWdoLqnt+j0Rcw3tADPUecR5BgUMcfHhGOeeKunryWynS6rp7JF2vNREN0wEGbswKeWBGXYYj1KpqWWWc3qE+f4rfV4rhws1TRepxC2lBnCRsY+IU4yShlFHgPT/5XZ4l5sAgnMbA6WargsL4bbm0rZLfQ97nWTduXFk68CFHxZZPdzNjLnOvQsTANHBsa+/5Nb2tl+mEH4sndcFiTd2ogQyOHJrdVGHsbPyqSmhXTglyFQC3wDE0lxuM2kNRgftz572bOfouEQOVxUiD4/h8t4m8FlBvDsyv9wjSVcEA744rXbEtWhg+CbsHHlEHhu02lkC66Dzply+PdKmYwGg286t4n45IooeXH0eifYxIKLQPnOt9PJ2q+Uk50lYvC/f7MuJazZDovN099wY2StMGaoMHFkJ3JifBUpoXhaQTnqN4WVIjOf4XE4w8sJ4LUENae2tAo232jjU+vweyP7M3ccaqR/vkIHkQObXN8B8yfBIpzjV
 tW1uEvq+
 BdR4UfmFq0STjQDScu9hf9GnetlnbmuQUqFs65nCkrgqTWH/DMFAZUunfeDBJEHFw4PMDoHASyx1w1F+EkSZTwt2NEOvvzY0M5+p6pAGrbEifbGsxIIjAqQzk8RlsZtOLNuwz++pHMDuYjBMJpcZMlR28y62GeGQHjvhayxdBu7ZmQCKHlicXgSre+jIB3tcWWl8bsJLLOAzfMJ+HfqFN6SoAqy1h2mr09BP2GBfT9d52uG8lZN+aJsMfY7fdRKVMAP2WtsjvUipsO62ZJzx8j7mAOetuAEA6CeghODA1aX6pwejKK/yjiXa1FR4QKOYImaHsvLQEG5sPdBUMW+7hcIotKQNllggSEyrqM4zgPrW3dyB29hJTRMjTmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To make it possible to allocate large folios directly in swap cache, let
swap_cache_alloc_folio handle larger orders too.

This slightly changes how allocation is synchronized. Now, whoever first
successfully allocates a folio in the swap cache will be the one who
charges it and performs the swap-in. Raced swapin now should avoid a
redundant charge and just wait for the swapin to finish.

Large order fallback is also moved to the swap cache layer. This should
make the fallback process less racy, too.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h       |   3 +-
 mm/swap_state.c | 193 +++++++++++++++++++++++++++++++++++++++++---------------
 mm/zswap.c      |   2 +-
 3 files changed, 145 insertions(+), 53 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index ad8b17a93758..6774af10a943 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -280,7 +280,8 @@ bool swap_cache_has_folio(swp_entry_t entry);
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
 void swap_cache_del_folio(struct folio *folio);
-struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_flags,
+struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
+				     unsigned long orders, struct vm_fault *vmf,
 				     struct mempolicy *mpol, pgoff_t ilx);
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 1e340faea9ac..e32b06a1f229 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -137,26 +137,39 @@ void *swap_cache_get_shadow(swp_entry_t entry)
 	return NULL;
 }
 
-static int __swap_cache_add_check(struct swap_cluster_info *ci,
-				  unsigned int ci_off, unsigned int nr,
-				  void **shadow)
+static int __swap_cache_check_batch(struct swap_cluster_info *ci,
+				    unsigned int ci_off, unsigned int ci_targ,
+				    unsigned int nr, void **shadowp)
 {
 	unsigned int ci_end = ci_off + nr;
 	unsigned long old_tb;
 
 	if (unlikely(!ci->table))
 		return -ENOENT;
+
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
-		if (unlikely(swp_tb_is_folio(old_tb)))
-			return -EEXIST;
-		if (unlikely(!__swp_tb_get_count(old_tb)))
-			return -ENOENT;
+		if (unlikely(swp_tb_is_folio(old_tb)) ||
+		    unlikely(!__swp_tb_get_count(old_tb)))
+			break;
 		if (swp_tb_is_shadow(old_tb))
-			*shadow = swp_tb_to_shadow(old_tb);
+			*shadowp = swp_tb_to_shadow(old_tb);
 	} while (++ci_off < ci_end);
 
-	return 0;
+	if (likely(ci_off == ci_end))
+		return 0;
+
+	/*
+	 * If the target slot is not suitable for adding swap cache, return
+	 * -EEXIST or -ENOENT. If the batch is not suitable, could be a
+	 * race with concurrent free or cache add, return -EBUSY.
+	 */
+	old_tb = __swap_table_get(ci, ci_targ);
+	if (swp_tb_is_folio(old_tb))
+		return -EEXIST;
+	if (!__swp_tb_get_count(old_tb))
+		return -ENOENT;
+	return -EBUSY;
 }
 
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
@@ -209,7 +222,7 @@ static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 	si = __swap_entry_to_info(entry);
 	ci = swap_cluster_lock(si, swp_offset(entry));
 	ci_off = swp_cluster_offset(entry);
-	err = __swap_cache_add_check(ci, ci_off, nr_pages, &shadow);
+	err = __swap_cache_check_batch(ci, ci_off, ci_off, nr_pages, &shadow);
 	if (err) {
 		swap_cluster_unlock(ci);
 		return err;
@@ -223,6 +236,124 @@ static int swap_cache_add_folio(struct folio *folio, swp_entry_t entry,
 	return 0;
 }
 
+static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
+					swp_entry_t targ_entry, gfp_t gfp,
+					unsigned int order, struct vm_fault *vmf,
+					struct mempolicy *mpol, pgoff_t ilx)
+{
+	int err;
+	swp_entry_t entry;
+	struct folio *folio;
+	void *shadow = NULL, *shadow_check = NULL;
+	unsigned long address, nr_pages = 1 << order;
+	unsigned int ci_off, ci_targ = swp_cluster_offset(targ_entry);
+
+	entry.val = round_down(targ_entry.val, nr_pages);
+	ci_off = round_down(ci_targ, nr_pages);
+
+	/* First check if the range is available */
+	spin_lock(&ci->lock);
+	err = __swap_cache_check_batch(ci, ci_off, ci_targ, nr_pages, &shadow);
+	spin_unlock(&ci->lock);
+	if (unlikely(err))
+		return ERR_PTR(err);
+
+	if (vmf) {
+		if (order)
+			gfp = thp_limit_gfp_mask(vma_thp_gfp_mask(vmf->vma), gfp);
+		address = round_down(vmf->address, PAGE_SIZE << order);
+		folio = vma_alloc_folio(gfp, order, vmf->vma, address);
+	} else {
+		folio = folio_alloc_mpol(gfp, order, mpol, ilx, numa_node_id());
+	}
+	if (unlikely(!folio))
+		return ERR_PTR(-ENOMEM);
+
+	/* Double check the range is still not in conflict */
+	spin_lock(&ci->lock);
+	err = __swap_cache_check_batch(ci, ci_off, ci_targ, nr_pages, &shadow_check);
+	if (unlikely(err) || shadow_check != shadow) {
+		spin_unlock(&ci->lock);
+		folio_put(folio);
+
+		/* If shadow changed, just try again */
+		return ERR_PTR(err ? err : -EAGAIN);
+	}
+
+	__folio_set_locked(folio);
+	__folio_set_swapbacked(folio);
+	__swap_cache_add_folio(ci, folio, entry);
+	spin_unlock(&ci->lock);
+
+	if (mem_cgroup_swapin_charge_folio(folio, vmf ? vmf->vma->vm_mm : NULL,
+					   gfp, entry)) {
+		spin_lock(&ci->lock);
+		__swap_cache_del_folio(ci, folio, shadow);
+		spin_unlock(&ci->lock);
+		folio_unlock(folio);
+		folio_put(folio);
+		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK_CHARGE);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* For memsw accouting, swap is uncharged when folio is added to swap cache */
+	memcg1_swapin(entry, 1 << order);
+	if (shadow)
+		workingset_refault(folio, shadow);
+
+	/* Caller will initiate read into locked new_folio */
+	folio_add_lru(folio);
+
+	return folio;
+}
+
+/**
+ * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
+ * @targ_entry: swap entry indicating the target slot
+ * @orders: allocation orders
+ * @vmf: fault information
+ * @gfp_mask: memory allocation flags
+ * @mpol: NUMA memory allocation policy to be applied
+ * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
+ *
+ * Allocate a folio in the swap cache for one swap slot, typically before
+ * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
+ * @targ_entry must have a non-zero swap count (swapped out).
+ *
+ * Context: Caller must protect the swap device with reference count or locks.
+ * Return: Returns the folio if allocation successed and folio is added to
+ * swap cache. Returns error code if allocation failed due to race.
+ */
+struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp_mask,
+				     unsigned long orders, struct vm_fault *vmf,
+				     struct mempolicy *mpol, pgoff_t ilx)
+{
+	int order;
+	struct folio *folio;
+	struct swap_cluster_info *ci;
+
+	ci = __swap_entry_to_cluster(targ_entry);
+	order = orders ? highest_order(orders) : 0;
+	for (;;) {
+		folio = __swap_cache_alloc(ci, targ_entry, gfp_mask, order,
+					   vmf, mpol, ilx);
+		if (!IS_ERR(folio))
+			return folio;
+		if (PTR_ERR(folio) == -EAGAIN)
+			continue;
+		/* Only -EBUSY means we should fallback and retry. */
+		if (PTR_ERR(folio) != -EBUSY)
+			return folio;
+		count_mthp_stat(order, MTHP_STAT_SWPIN_FALLBACK);
+		order = next_order(&orders, order);
+		if (!orders)
+			break;
+	}
+	/* Should never reach here, order 0 should not fail with -EBUSY. */
+	WARN_ON_ONCE(1);
+	return ERR_PTR(-EINVAL);
+}
+
 /**
  * __swap_cache_del_folio - Removes a folio from the swap cache.
  * @ci: The locked swap cluster.
@@ -498,46 +629,6 @@ static int __swap_cache_prepare_and_add(swp_entry_t entry,
 	return ret;
 }
 
-/**
- * swap_cache_alloc_folio - Allocate folio for swapped out slot in swap cache.
- * @entry: the swapped out swap entry to be binded to the folio.
- * @gfp_mask: memory allocation flags
- * @mpol: NUMA memory allocation policy to be applied
- * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
- *
- * Allocate a folio in the swap cache for one swap slot, typically before
- * doing IO (e.g. swap in or zswap writeback). The swap slot indicated by
- * @entry must have a non-zero swap count (swapped out).
- * Currently only supports order 0.
- *
- * Context: Caller must protect the swap device with reference count or locks.
- * Return: Returns the folio if allocation succeeded and folio is added to
- * swap cache. Returns error code if allocation failed due to race.
- */
-struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
-				     struct mempolicy *mpol, pgoff_t ilx)
-{
-	int ret;
-	struct folio *folio;
-
-	/* Allocate a new folio to be added into the swap cache. */
-	folio = folio_alloc_mpol(gfp_mask, 0, mpol, ilx, numa_node_id());
-	if (!folio)
-		return ERR_PTR(-ENOMEM);
-
-	/*
-	 * Try add the new folio, it returns NULL if already exist,
-	 * since folio is order 0.
-	 */
-	ret = __swap_cache_prepare_and_add(entry, folio, gfp_mask, false);
-	if (ret) {
-		folio_put(folio);
-		return ERR_PTR(ret);
-	}
-
-	return folio;
-}
-
 static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 					   struct mempolicy *mpol, pgoff_t ilx,
 					   struct swap_iocb **plug, bool readahead)
@@ -559,7 +650,7 @@ static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
 		if (folio)
 			return folio;
 
-		folio = swap_cache_alloc_folio(entry, gfp, mpol, ilx);
+		folio = swap_cache_alloc_folio(entry, gfp, 0, NULL, mpol, ilx);
 	} while (PTR_ERR(folio) == -EEXIST);
 
 	if (IS_ERR_OR_NULL(folio))
diff --git a/mm/zswap.c b/mm/zswap.c
index f3aa83a99636..5d83539a8bba 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1001,7 +1001,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 		return -EEXIST;
 
 	mpol = get_task_policy(current);
-	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, mpol,
+	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, 0, NULL, mpol,
 				       NO_INTERLEAVE_INDEX);
 	put_swap_device(si);
 

-- 
2.53.0



