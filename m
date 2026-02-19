Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9DD4C531EA
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 23:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11326B00A0; Thu, 19 Feb 2026 18:42:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D260A6B009D; Thu, 19 Feb 2026 18:42:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2436B009E; Thu, 19 Feb 2026 18:42:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95A246B009D
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:42:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 606C413BE50
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:13 +0000 (UTC)
X-FDA: 84462832146.06.F15F90C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 46D6240002
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DJjaYhBf;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771544531;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7KqDuHOm7YvGJERhEtTQeTG/82aPBpOAhJ1A3aNv8o0=;
	b=nzDi/k5Bvj+GZGIJDg59XHT+51iKhCbGVeT5ZKTnqU5kaxFBscFY7SJ+TLXKraupI+idRM
	8iWXEk8c49aogUa+4zCG3qGxIVrvp05PXFfQcxk8tytxsyvzgEPnbgGoXgz4OcNSvnret3
	T8Cl4vJrh18ZOHubQzwwg04QbyUcEd8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DJjaYhBf;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771544531; a=rsa-sha256;
	cv=none;
	b=4o3emRT940a4Y48optID/bn/aFGaQvAGo0Hhl6yRkv0YVi73YmoF/YRWV4w2agbMY6Bpnv
	azDJ2xAW/MzWgIiHvTabMfyk7OGvqBAjWT0E7yp6lB8kek1xbPF+vKd6gcFMXrA13PRwr5
	604HpPLmx0YS8zFeqLrlY8O72aIxBMw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4678E44559;
	Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BC3FC2BC86;
	Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544528;
	bh=qyfGzo8v12j44PlTzKr7Yv77BTV9X7d51BLIJWbEEYs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DJjaYhBfKRXMs29IBBoQ0MONmBWpt1kh+++rK9KIYLK9IusRvsbMp10yotOgXty8v
	 qAw3EvI5b/ktnkkwlD2vl/b8p2W0ZwqUD8Cyo3U22fJ7+5X8MgHhW/hfTHeU2xgPqR
	 U3kJO+f+Gr5LC2cY1tFOKuLDn3BoHUowjmA7fXQfp91cBn6YWHfbFnGET80BVoRE8B
	 b/lNB5Cryp/UaiT3NUOs3/0Cqj1HhyQTfwRIMWvqzTN5GdBh5rmVH5UCdQQiHX2ckZ
	 mdyN/x6N9mUoWheaTSfyw8wRE4cOWV8+onXuqEQg3rbsjIcEsN77mPEk4zvKpufLqq
	 dPFW+hRiwtpLQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14527C531EB;
	Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 20 Feb 2026 07:42:13 +0800
Subject: [PATCH RFC 12/15] mm, swap: merge zeromap into swap table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-swap-table-p4-v1-12-104795d19815@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771544524; l=20509;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=DS+YZ8JcJF+Jri1i7Q3A9LxB6Fr+z8Z5vJM23M1Iw2Y=;
 b=L6nM7BZpj5iPh5g8XNyIi9cgSB9rftBwNt5gSZgFcNupU7deDrzFyHCMKvPN9uyvnWLvfnZzp
 3VaSVVaiR4TDG8LO1zZp6SlzlF4rEuUrv1U37XEzBCJIyka3n8HvIdn
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 46D6240002
X-Stat-Signature: k7d35qcxjm8ht7b7j65w96ggsd1e4yq1
X-HE-Tag: 1771544531-718821
X-HE-Meta: U2FsdGVkX1+yb18ThNiLxx//2/xPYnW53oMD4nkSqgtsyyMifn63+CWzeNUbGrDfxl+WQknOgLm6si865p2njCNx661rIZCTASPYMzXleFujEBDdbVVkCZyBL7tRibuA2CePVgl+hEy6MaIFRaE+SKBwLN4+v4tT1G38N+xEg8s3e3V/yT/zNDJWKg9YuAFSQ16d1h2F6eKqSFBeVpGVGCcAoMXBBUyzEPs9/I1i66hGiVw6VV/7LlNKlMnXD6GcB4uQNMePJ0kXGCFYSOBvyIHCYB5gIinoXQpvMBOqL1tGRiTonzFuH4AzRWnYnGLHyWKSeYNAtBmQv72y9mq4qckvfl9Q//WXIRV+VsCcdxsmOCG4Bqy38meLNoXrl6yuTvw4jawhh1pBYHC/PPnfCwvZaZOaGZqLsnwao6KrfvkuB3mTAibQcd+qrrAOjFZSi+yF98Q44QJ9CvpAqmbL3x6jP+idbIsQMIMHGd/CrHgnHDTxsrAHQUfe/Z1ZMxQ9tuBhYP3yNm6DPZBTloK/fO7zHtoBW7vQx9mwR/sgQ9z0Jjqy48dDtmGsvLjQIXKcIEs4ssItk5sWTY9Ww85OvSZmUoYN2xGvmvGLld29N7NaUxC/d/lE06GqHrGT8LfIbvdnhZM+hUkEw4QeCec94Hhj6Z0t5FAW0OT1qwj9rodFlj+3o+zP7jgq7PdreUSxnSSjBX3G5MuAg9wYVQyHypLQ86g+b6C2kamIgdkYSRXoc5D6F4pza7xLdgTJGxfO1PxWm87v1+m/aqesPlwo1Yp4HHSoPW7BojlAtgBkCKFxRQUyQZxNdC5qmxVJ6wIpDPFlHkr7cXPMh0Y9dtcqjz+fMmKvviTkHJ2MW3Wv9ZRMj+x06O70/8GNgO8nkcWz07qHdqw/HHIHFucXwlATjMLjTHq7ZpB7Al7V9PSv0IWfFfN9rEVe7NTQd6r24uZJzfkXCA1i/WUbt46Ln6v
 bdN3cpQg
 zUNDZ/HuhnHANbtazLn6r/xSixliSAHgAKqiowWIw+8Oy+ojyiqqdqLnvu7OncVULG1+j5gbupP/oVmwKwH6IqOSAfaWZTzvVRiDL1FsKu7wC3BdpzCVwyvm2BW7vKI0jYItqYS+N/aJtYcc1+doKUZPXOQkK4HwbbNP8E2rpYk7tTou+foO8kLVwjY5dss3vem/hHXIKPvS1k4ZLfEPerUODlZwZ8NvJ+5G9byyHkIwoxYn+RafZlkuuTX4pPtnOFjot8YAuX2JF6GUBGOa5SksGZGod5bY/ZiFYxjMf8IKQ8utLXQLvch3ml406WKGTJUeJeGr0hQ2cnEAH6uoX17sE41lfkDotdfi2r9k+G3v9PDsqqjpzR3b3JVoTCDp72p1uuMJRyF/2f+eWeHaOPqXvLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

By reserving one bit for the counting part, we can easily merge the
zeromap into the swap table.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h |   1 -
 mm/memory.c          |  12 ++----
 mm/page_io.c         |  28 ++++++++++----
 mm/swap.h            |  31 ----------------
 mm/swap_state.c      |  23 ++++++++----
 mm/swap_table.h      | 103 +++++++++++++++++++++++++++++++++++++++++++--------
 mm/swapfile.c        |  27 +-------------
 7 files changed, 127 insertions(+), 98 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 66cf657a1f35..bc871d8a1e99 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -254,7 +254,6 @@ struct swap_info_struct {
 	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
-	unsigned long *zeromap;		/* kvmalloc'ed bitmap to track zero pages */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
diff --git a/mm/memory.c b/mm/memory.c
index e58f976508b3..8df169fced0d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -88,6 +88,7 @@
 
 #include "pgalloc-track.h"
 #include "internal.h"
+#include "swap_table.h"
 #include "swap.h"
 
 #if defined(LAST_CPUPID_NOT_IN_PAGE_FLAGS) && !defined(CONFIG_COMPILE_TEST)
@@ -4522,13 +4523,11 @@ static vm_fault_t handle_pte_marker(struct vm_fault *vmf)
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
- * Check if the PTEs within a range are contiguous swap entries
- * and have consistent swapcache, zeromap.
+ * Check if the PTEs within a range are contiguous swap entries.
  */
 static bool can_swapin_thp(struct vm_fault *vmf, pte_t *ptep, int nr_pages)
 {
 	unsigned long addr;
-	softleaf_t entry;
 	int idx;
 	pte_t pte;
 
@@ -4538,18 +4537,13 @@ static bool can_swapin_thp(struct vm_fault *vmf, pte_t *ptep, int nr_pages)
 
 	if (!pte_same(pte, pte_move_swp_offset(vmf->orig_pte, -idx)))
 		return false;
-	entry = softleaf_from_pte(pte);
-	if (swap_pte_batch(ptep, nr_pages, pte) != nr_pages)
-		return false;
-
 	/*
 	 * swap_read_folio() can't handle the case a large folio is hybridly
 	 * from different backends. And they are likely corner cases. Similar
 	 * things might be added once zswap support large folios.
 	 */
-	if (unlikely(swap_zeromap_batch(entry, nr_pages, NULL) != nr_pages))
+	if (swap_pte_batch(ptep, nr_pages, pte) != nr_pages)
 		return false;
-
 	return true;
 }
 
diff --git a/mm/page_io.c b/mm/page_io.c
index a2c034660c80..5a0b5034489b 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -26,6 +26,7 @@
 #include <linux/delayacct.h>
 #include <linux/zswap.h>
 #include "swap.h"
+#include "swap_table.h"
 
 static void __end_swap_bio_write(struct bio *bio)
 {
@@ -204,15 +205,20 @@ static bool is_folio_zero_filled(struct folio *folio)
 static void swap_zeromap_folio_set(struct folio *folio)
 {
 	struct obj_cgroup *objcg = get_obj_cgroup_from_folio(folio);
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	int nr_pages = folio_nr_pages(folio);
+	struct swap_cluster_info *ci;
 	swp_entry_t entry;
 	unsigned int i;
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
+	ci = swap_cluster_get_and_lock(folio);
 	for (i = 0; i < folio_nr_pages(folio); i++) {
 		entry = page_swap_entry(folio_page(folio, i));
-		set_bit(swp_offset(entry), sis->zeromap);
+		__swap_table_set_zero(ci, swp_cluster_offset(entry));
 	}
+	swap_cluster_unlock(ci);
 
 	count_vm_events(SWPOUT_ZERO, nr_pages);
 	if (objcg) {
@@ -223,14 +229,19 @@ static void swap_zeromap_folio_set(struct folio *folio)
 
 static void swap_zeromap_folio_clear(struct folio *folio)
 {
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
+	struct swap_cluster_info *ci;
 	swp_entry_t entry;
 	unsigned int i;
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
+	ci = swap_cluster_get_and_lock(folio);
 	for (i = 0; i < folio_nr_pages(folio); i++) {
 		entry = page_swap_entry(folio_page(folio, i));
-		clear_bit(swp_offset(entry), sis->zeromap);
+		__swap_table_clear_zero(ci, swp_cluster_offset(entry));
 	}
+	swap_cluster_unlock(ci);
 }
 
 /*
@@ -255,10 +266,9 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 	}
 
 	/*
-	 * Use a bitmap (zeromap) to avoid doing IO for zero-filled pages.
-	 * The bits in zeromap are protected by the locked swapcache folio
-	 * and atomic updates are used to protect against read-modify-write
-	 * corruption due to other zero swap entries seeing concurrent updates.
+	 * Use the swap table zero mark to avoid doing IO for zero-filled
+	 * pages. The zero mark is protected by the cluster lock, which is
+	 * acquired internally by swap_zeromap_folio_set/clear.
 	 */
 	if (is_folio_zero_filled(folio)) {
 		swap_zeromap_folio_set(folio);
@@ -511,6 +521,8 @@ static bool swap_read_folio_zeromap(struct folio *folio)
 	struct obj_cgroup *objcg;
 	bool is_zeromap;
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
 	/*
 	 * Swapping in a large folio that is partially in the zeromap is not
 	 * currently handled. Return true without marking the folio uptodate so
diff --git a/mm/swap.h b/mm/swap.h
index c95f5fafea42..cb1ab20d83d5 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -312,31 +312,6 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
 	return __swap_entry_to_info(folio->swap)->flags;
 }
 
-/*
- * Return the count of contiguous swap entries that share the same
- * zeromap status as the starting entry. If is_zeromap is not NULL,
- * it will return the zeromap status of the starting entry.
- */
-static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
-		bool *is_zeromap)
-{
-	struct swap_info_struct *sis = __swap_entry_to_info(entry);
-	unsigned long start = swp_offset(entry);
-	unsigned long end = start + max_nr;
-	bool first_bit;
-
-	first_bit = test_bit(start, sis->zeromap);
-	if (is_zeromap)
-		*is_zeromap = first_bit;
-
-	if (max_nr <= 1)
-		return max_nr;
-	if (first_bit)
-		return find_next_zero_bit(sis->zeromap, end, start) - start;
-	else
-		return find_next_bit(sis->zeromap, end, start) - start;
-}
-
 #else /* CONFIG_SWAP */
 struct swap_iocb;
 static inline struct swap_cluster_info *swap_cluster_lock(
@@ -475,11 +450,5 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
 {
 	return 0;
 }
-
-static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
-		bool *has_zeromap)
-{
-	return 0;
-}
 #endif /* CONFIG_SWAP */
 #endif /* _MM_SWAP_H */
diff --git a/mm/swap_state.c b/mm/swap_state.c
index c6ba15de4094..419419e18a47 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -138,6 +138,7 @@ void *swap_cache_get_shadow(swp_entry_t entry)
 }
 
 static int __swap_cache_check_batch(struct swap_cluster_info *ci,
+				    swp_entry_t entry,
 				    unsigned int ci_off, unsigned int ci_targ,
 				    unsigned int nr, void **shadowp)
 {
@@ -148,6 +149,13 @@ static int __swap_cache_check_batch(struct swap_cluster_info *ci,
 	if (unlikely(!ci->table))
 		return -ENOENT;
 
+	/*
+	 * TODO: Swap of large folio that is partially in the zeromap
+	 * is not supported.
+	 */
+	if (nr > 1 && swap_zeromap_batch(entry, nr, NULL) != nr)
+		return -EBUSY;
+
 	/*
 	 * If the target slot is not suitable for adding swap cache, return
 	 * -EEXIST or -ENOENT. If the batch is not suitable, could be a
@@ -190,7 +198,7 @@ void __swap_cache_add_folio(struct swap_cluster_info *ci,
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
 		VM_WARN_ON_ONCE(swp_tb_is_folio(old_tb));
-		__swap_table_set(ci, ci_off, pfn_to_swp_tb(pfn, __swp_tb_get_count(old_tb)));
+		__swap_table_set(ci, ci_off, pfn_to_swp_tb(pfn, __swp_tb_get_flags(old_tb)));
 	} while (++ci_off < ci_end);
 
 	folio_ref_add(folio, nr_pages);
@@ -218,7 +226,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 
 	/* First check if the range is available */
 	spin_lock(&ci->lock);
-	err = __swap_cache_check_batch(ci, ci_off, ci_targ, nr_pages, &shadow);
+	err = __swap_cache_check_batch(ci, entry, ci_off, ci_targ, nr_pages, &shadow);
 	spin_unlock(&ci->lock);
 	if (unlikely(err))
 		return ERR_PTR(err);
@@ -236,7 +244,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 
 	/* Double check the range is still not in conflict */
 	spin_lock(&ci->lock);
-	err = __swap_cache_check_batch(ci, ci_off, ci_targ, nr_pages, &shadow_check);
+	err = __swap_cache_check_batch(ci, entry, ci_off, ci_targ, nr_pages, &shadow_check);
 	if (unlikely(err) || shadow_check != shadow) {
 		spin_unlock(&ci->lock);
 		folio_put(folio);
@@ -338,7 +346,6 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp_mask,
 void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 			    void *shadow, bool charged, bool reclaim)
 {
-	int count;
 	unsigned long old_tb;
 	struct swap_info_struct *si;
 	struct mem_cgroup *memcg = NULL;
@@ -375,13 +382,13 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 		old_tb = __swap_table_get(ci, ci_off);
 		WARN_ON_ONCE(!swp_tb_is_folio(old_tb) ||
 			     swp_tb_to_folio(old_tb) != folio);
-		count = __swp_tb_get_count(old_tb);
-		if (count)
+		if (__swp_tb_get_count(old_tb))
 			folio_swapped = true;
 		else
 			need_free = true;
 		/* If shadow is NULL, we sets an empty shadow. */
-		__swap_table_set(ci, ci_off, shadow_to_swp_tb(shadow, count));
+		__swap_table_set(ci, ci_off, shadow_to_swp_tb(shadow,
+				 __swp_tb_get_flags(old_tb)));
 	} while (++ci_off < ci_end);
 
 	folio->swap.val = 0;
@@ -460,7 +467,7 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
 		WARN_ON_ONCE(!swp_tb_is_folio(old_tb) || swp_tb_to_folio(old_tb) != old);
-		__swap_table_set(ci, ci_off, pfn_to_swp_tb(pfn, __swp_tb_get_count(old_tb)));
+		__swap_table_set(ci, ci_off, pfn_to_swp_tb(pfn, __swp_tb_get_flags(old_tb)));
 	} while (++ci_off < ci_end);
 
 	/*
diff --git a/mm/swap_table.h b/mm/swap_table.h
index 8415ffbe2b9c..6d3d773e1908 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -21,12 +21,14 @@ struct swap_table {
  * Swap table entry type and bits layouts:
  *
  * NULL:     |---------------- 0 ---------------| - Free slot
- * Shadow:   | SWAP_COUNT |---- SHADOW_VAL ---|1| - Swapped out slot
- * PFN:      | SWAP_COUNT |------ PFN -------|10| - Cached slot
+ * Shadow:   |SWAP_COUNT|Z|---- SHADOW_VAL ---|1| - Swapped out slot
+ * PFN:      |SWAP_COUNT|Z|------ PFN -------|10| - Cached slot
  * Pointer:  |----------- Pointer ----------|100| - (Unused)
  * Bad:      |------------- 1 -------------|1000| - Bad slot
  *
- * SWAP_COUNT is `SWP_TB_COUNT_BITS` long, each entry is an atomic long.
+ * COUNT is `SWP_TB_COUNT_BITS` long, Z is the `SWP_TB_ZERO_MARK` bit,
+ * and together they form the `SWP_TB_FLAGS_BITS` wide flags field.
+ * Each entry is an atomic long.
  *
  * Usages:
  *
@@ -70,16 +72,21 @@ struct swap_table {
 #define SWP_TB_PFN_MARK_MASK	(BIT(SWP_TB_PFN_MARK_BITS) - 1)
 
 /* SWAP_COUNT part for PFN or shadow, the width can be shrunk or extended */
-#define SWP_TB_COUNT_BITS      min(4, BITS_PER_LONG - SWP_TB_PFN_BITS)
+#define SWP_TB_FLAGS_BITS	min(5, BITS_PER_LONG - SWP_TB_PFN_BITS)
+#define SWP_TB_COUNT_BITS	(SWP_TB_FLAGS_BITS - 1)
+#define SWP_TB_FLAGS_MASK	(~((~0UL) >> SWP_TB_FLAGS_BITS))
 #define SWP_TB_COUNT_MASK      (~((~0UL) >> SWP_TB_COUNT_BITS))
+#define SWP_TB_FLAGS_SHIFT     (BITS_PER_LONG - SWP_TB_FLAGS_BITS)
 #define SWP_TB_COUNT_SHIFT     (BITS_PER_LONG - SWP_TB_COUNT_BITS)
 #define SWP_TB_COUNT_MAX       ((1 << SWP_TB_COUNT_BITS) - 1)
 
+#define SWP_TB_ZERO_MARK	BIT(BITS_PER_LONG - SWP_TB_COUNT_BITS - 1)
+
 /* Bad slot: ends with 0b1000 and rests of bits are all 1 */
 #define SWP_TB_BAD		((~0UL) << 3)
 
 /* Macro for shadow offset calculation */
-#define SWAP_COUNT_SHIFT	SWP_TB_COUNT_BITS
+#define SWAP_COUNT_SHIFT	SWP_TB_FLAGS_BITS
 
 /*
  * Helpers for casting one type of info into a swap table entry.
@@ -102,35 +109,43 @@ static inline unsigned long __count_to_swp_tb(unsigned char count)
 	return ((unsigned long)count) << SWP_TB_COUNT_SHIFT;
 }
 
-static inline unsigned long pfn_to_swp_tb(unsigned long pfn, unsigned int count)
+static inline unsigned long __flags_to_swp_tb(unsigned char flags)
+{
+	BUILD_BUG_ON(SWP_TB_FLAGS_BITS > BITS_PER_BYTE);
+	VM_WARN_ON((flags >> 1) > SWP_TB_COUNT_MAX);
+	return ((unsigned long)flags) << SWP_TB_FLAGS_SHIFT;
+}
+
+
+static inline unsigned long pfn_to_swp_tb(unsigned long pfn, unsigned char flags)
 {
 	unsigned long swp_tb;
 
 	BUILD_BUG_ON(sizeof(unsigned long) != sizeof(void *));
 	BUILD_BUG_ON(SWAP_CACHE_PFN_BITS >
-		     (BITS_PER_LONG - SWP_TB_PFN_MARK_BITS - SWP_TB_COUNT_BITS));
+		     (BITS_PER_LONG - SWP_TB_PFN_MARK_BITS - SWP_TB_FLAGS_BITS));
 
 	swp_tb = (pfn << SWP_TB_PFN_MARK_BITS) | SWP_TB_PFN_MARK;
-	VM_WARN_ON_ONCE(swp_tb & SWP_TB_COUNT_MASK);
+	VM_WARN_ON_ONCE(swp_tb & SWP_TB_FLAGS_MASK);
 
-	return swp_tb | __count_to_swp_tb(count);
+	return swp_tb | __flags_to_swp_tb(flags);
 }
 
-static inline unsigned long folio_to_swp_tb(struct folio *folio, unsigned int count)
+static inline unsigned long folio_to_swp_tb(struct folio *folio, unsigned char flags)
 {
-	return pfn_to_swp_tb(folio_pfn(folio), count);
+	return pfn_to_swp_tb(folio_pfn(folio), flags);
 }
 
-static inline unsigned long shadow_to_swp_tb(void *shadow, unsigned int count)
+static inline unsigned long shadow_to_swp_tb(void *shadow, unsigned char flags)
 {
 	BUILD_BUG_ON((BITS_PER_XA_VALUE + 1) !=
 		     BITS_PER_BYTE * sizeof(unsigned long));
 	BUILD_BUG_ON((unsigned long)xa_mk_value(0) != SWP_TB_SHADOW_MARK);
 
 	VM_WARN_ON_ONCE(shadow && !xa_is_value(shadow));
-	VM_WARN_ON_ONCE(shadow && ((unsigned long)shadow & SWP_TB_COUNT_MASK));
+	VM_WARN_ON_ONCE(shadow && ((unsigned long)shadow & SWP_TB_FLAGS_MASK));
 
-	return (unsigned long)shadow | __count_to_swp_tb(count) | SWP_TB_SHADOW_MARK;
+	return (unsigned long)shadow | SWP_TB_SHADOW_MARK | __flags_to_swp_tb(flags);
 }
 
 /*
@@ -168,14 +183,14 @@ static inline bool swp_tb_is_countable(unsigned long swp_tb)
 static inline struct folio *swp_tb_to_folio(unsigned long swp_tb)
 {
 	VM_WARN_ON(!swp_tb_is_folio(swp_tb));
-	return pfn_folio((swp_tb & ~SWP_TB_COUNT_MASK) >> SWP_TB_PFN_MARK_BITS);
+	return pfn_folio((swp_tb & ~SWP_TB_FLAGS_MASK) >> SWP_TB_PFN_MARK_BITS);
 }
 
 static inline void *swp_tb_to_shadow(unsigned long swp_tb)
 {
 	VM_WARN_ON(!swp_tb_is_shadow(swp_tb));
 	/* No shift needed, xa_value is stored as it is in the lower bits. */
-	return (void *)(swp_tb & ~SWP_TB_COUNT_MASK);
+	return (void *)(swp_tb & ~SWP_TB_FLAGS_MASK);
 }
 
 static inline unsigned char __swp_tb_get_count(unsigned long swp_tb)
@@ -184,6 +199,12 @@ static inline unsigned char __swp_tb_get_count(unsigned long swp_tb)
 	return ((swp_tb & SWP_TB_COUNT_MASK) >> SWP_TB_COUNT_SHIFT);
 }
 
+static inline unsigned char __swp_tb_get_flags(unsigned long swp_tb)
+{
+	VM_WARN_ON(!swp_tb_is_countable(swp_tb));
+	return ((swp_tb & SWP_TB_FLAGS_MASK) >> SWP_TB_FLAGS_SHIFT);
+}
+
 static inline int swp_tb_get_count(unsigned long swp_tb)
 {
 	if (swp_tb_is_countable(swp_tb))
@@ -247,4 +268,54 @@ static inline unsigned long swap_table_get(struct swap_cluster_info *ci,
 
 	return swp_tb;
 }
+
+static inline void __swap_table_set_zero(struct swap_cluster_info *ci,
+					 unsigned int ci_off)
+{
+	unsigned long swp_tb = __swap_table_get(ci, ci_off);
+
+	VM_WARN_ON(!swp_tb_is_countable(swp_tb));
+	swp_tb |= SWP_TB_ZERO_MARK;
+	__swap_table_set(ci, ci_off, swp_tb);
+}
+
+static inline void __swap_table_clear_zero(struct swap_cluster_info *ci,
+					   unsigned int ci_off)
+{
+	unsigned long swp_tb = __swap_table_get(ci, ci_off);
+
+	VM_WARN_ON(!swp_tb_is_countable(swp_tb));
+	swp_tb &= ~SWP_TB_ZERO_MARK;
+	__swap_table_set(ci, ci_off, swp_tb);
+}
+
+/**
+ * Return the count of contiguous swap entries that share the same
+ * zeromap status as the starting entry. If is_zerop is not NULL,
+ * it will return the zeromap status of the starting entry.
+ *
+ * Context: Caller must ensure the cluster containing the entries
+ * that will be checked won't be freed.
+ */
+static inline int swap_zeromap_batch(swp_entry_t entry, int max_nr,
+				     bool *is_zerop)
+{
+	bool is_zero;
+	unsigned long swp_tb;
+	struct swap_cluster_info *ci = __swap_entry_to_cluster(entry);
+	unsigned int ci_start = swp_cluster_offset(entry), ci_off, ci_end;
+
+	ci_off = ci_start;
+	ci_end = ci_off + max_nr;
+	swp_tb = swap_table_get(ci, ci_off);
+	is_zero = !!(swp_tb & SWP_TB_ZERO_MARK);
+	if (is_zerop)
+		*is_zerop = is_zero;
+	while (++ci_off < ci_end) {
+		swp_tb = swap_table_get(ci, ci_off);
+		if (is_zero != !!(swp_tb & SWP_TB_ZERO_MARK))
+			break;
+	}
+	return ci_off - ci_start;
+}
 #endif
diff --git a/mm/swapfile.c b/mm/swapfile.c
index de34f1990209..4018e8694b72 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -918,7 +918,7 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 		nr_pages = 1;
 		swap_cluster_assert_empty(ci, ci_off, 1, false);
 		/* Sets a fake shadow as placeholder */
-		__swap_table_set(ci, ci_off, shadow_to_swp_tb(NULL, 1));
+		__swap_table_set(ci, ci_off, __swp_tb_mk_count(shadow_to_swp_tb(NULL, 0), 1));
 	} else {
 		/* Allocation without folio is only possible with hibernation */
 		WARN_ON_ONCE(1);
@@ -1308,14 +1308,8 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
 	unsigned int i;
 
-	/*
-	 * Use atomic clear_bit operations only on zeromap instead of non-atomic
-	 * bitmap_clear to prevent adjacent bits corruption due to simultaneous writes.
-	 */
-	for (i = 0; i < nr_entries; i++) {
-		clear_bit(offset + i, si->zeromap);
+	for (i = 0; i < nr_entries; i++)
 		zswap_invalidate(swp_entry(si->type, offset + i));
-	}
 
 	if (si->flags & SWP_BLKDEV)
 		swap_slot_free_notify =
@@ -2921,7 +2915,6 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
 	struct swap_info_struct *p = NULL;
-	unsigned long *zeromap;
 	struct swap_cluster_info *cluster_info;
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
@@ -3009,8 +3002,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	swap_file = p->swap_file;
 	p->swap_file = NULL;
-	zeromap = p->zeromap;
-	p->zeromap = NULL;
 	maxpages = p->max;
 	cluster_info = p->cluster_info;
 	p->max = 0;
@@ -3022,7 +3013,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
-	kvfree(zeromap);
 	free_swap_cluster_info(cluster_info, maxpages);
 
 	inode = mapping->host;
@@ -3555,17 +3545,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (error)
 		goto bad_swap_unlock_inode;
 
-	/*
-	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
-	 * be above MAX_PAGE_ORDER incase of a large swap file.
-	 */
-	si->zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(long),
-				     GFP_KERNEL | __GFP_ZERO);
-	if (!si->zeromap) {
-		error = -ENOMEM;
-		goto bad_swap_unlock_inode;
-	}
-
 	if (si->bdev && bdev_stable_writes(si->bdev))
 		si->flags |= SWP_STABLE_WRITES;
 
@@ -3667,8 +3646,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	destroy_swap_extents(si, swap_file);
 	free_swap_cluster_info(si->cluster_info, si->max);
 	si->cluster_info = NULL;
-	kvfree(si->zeromap);
-	si->zeromap = NULL;
 	/*
 	 * Clear the SWP_USED flag after all resources are freed so
 	 * alloc_swap_info can reuse this si safely.

-- 
2.53.0



