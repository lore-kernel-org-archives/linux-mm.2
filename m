Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DAC1C531EA
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 23:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCC6A6B0095; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B30726B009B; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B6E26B0098; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4197F6B009D
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:42:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 13E4D1A05F4
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:11 +0000 (UTC)
X-FDA: 84462832062.07.0A2F0BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2DD82100008
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gutj444u;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771544529;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Ej0yPb0+BPkit6G51ADS9WQdASdRumO2axsJLk+Syo=;
	b=bYkVzlfCRhLeiAIGmqOCG6tRdypm/S1YeeHLcfhzwKKD0ZYMoyk+cBgCHZu02XNydpo28l
	uKzXeARDP+DkJGViTZ24H40Db4pj4C5pRIN32swna10Zj62e9Xnme23apsOLhjQUKb0hht
	PN6NIg2d0GD2epBhwXHd+jBioLhIXBc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771544529; a=rsa-sha256;
	cv=none;
	b=MsjJHfIXSClhRP4ppBsbuLp6dWCRFZ8A9x4rFTIK1iBueg0OnYKPBntfKoWXB6rnzr5GYy
	ls/KRk3ulltF1jKnP6Eikb7cvVHEecr1FE7iecv/KTWcuNEFG1Y1LNt+uPJ3x4VjECYKIm
	e1aXCc91oXhk7UMPuAZGlWSdSAzkhvE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gutj444u;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B0B560054;
	Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC63EC116C6;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544527;
	bh=7fVNl2OWSZn5yIAaZMdbJy8esxpVNqxwiw/ChyI7RI8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gutj444uK2RjiSDXuWpNITUZSFe22ZDCg5BOQxexBE5QKnd/jwXsdUge+dqFwKryQ
	 5vCzE9A/AmchcdBBvU9G5g1UxNIDXHadQOZeellY7WZ0GHK4CNU+clLYjjoEs5ccp6
	 Yf4ltSnll7hIlZ/BjxAUVnlRvhWE3PpWpkxvB1He4qUyMyXmAq3PrBv9O45AOWoEJY
	 5i+j4s6B2K244MbMZQZSQX51cTw7ZH3sRwicL1Y2kkMsbBshdGMdlaZXVKMw+aoyiM
	 2MERmy08ck+5sVPOG9po56/zI95lxP733oXgxuGBRSck0VnykXAu8fn4soqhDdu6BV
	 qMjo3zu08GvOg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47E2C531E3;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 20 Feb 2026 07:42:09 +0800
Subject: [PATCH RFC 08/15] mm, swap: store and check memcg info in the swap
 table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-swap-table-p4-v1-8-104795d19815@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771544524; l=11918;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=T46p8i3lmd7nNPEr9N3RzFlb/rLjAdfkkrw3HoHcgOA=;
 b=ACLCqf4sQhtOMVUw7uIzQypZq7bA8GsNSCfaFYF7EJAQ3irEZYoDIiP6FtvzUwRYrJH13tShm
 Hs2UKl47dqHD/sSc/bYJeKsgR98o16GR9f3V+K0HcrnsXdNGKtXBqBL
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: bez56mwfybu43sqxaju6d5u3766464u4
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2DD82100008
X-HE-Tag: 1771544529-546715
X-HE-Meta: U2FsdGVkX18PhnUyWCtwsb1P1thnRcc1F7vYCzheu3GEW8jgTYZXKapRZWeChRKGvygfvDNc2QKe7B2GRr3toI9l1glSePOQrg614tQz5T5DJHWk4eN1aWMN5DtHwANgnIwqAHRFgGxi3iJ0g/CzW98ZJi85pwJ8Tn+FBBJp5md2ORpWovgYhbpcoxN8sjtLl+WX+b0ZUYqTf/hJXtYtlITK50QvTknmfV0fguwdDnF7d38toeOVspTFYiukZLP7nbkMZocNc9wG3rqGlAaxoZ0+TSoojHkQLUyMkP+wAqM1moJR4I/Q3564yW+JUcEAkDw/S7/gwAj2geK2p8Wq5iuMubtK69XYWmbdf16CWnuSZesMrnSqZX6DMR0gaDhjYabOwuOvugEpx4msZfDndjsCJzV5wLCdYjmtq2tTv8qSrfMRaMzvLPLgdg8aByA8kT7n8nEDQldXus6yYMA0f0VIAraIcP4RQpa1aFmMOeXx51nRC4NTQ1kv/Q6aeXvfj1Y5ZaWZ7ZF5DX0d419I3ikdFnuVC+9DtSaEF5kjgMN3i7fNqeTyXdNIz2XDWGDRaxEfS4cjasM4DZMDWsE5vhDLnbvPcX4Eu/DkkgeJB7mNmyA16qc5liiMUxhfLSkcQmMJjCy4PnDsIS9tuMbYGcrp6kaQme85lE/jO7OsEOVQGPhxagoENqt7TkMyWsusoQP3n/+zZfJPPFu19wtEFllNlL62PSXL4GgcRRloPO4EkO6IbXFQnXj3oTFztcUedTEiSZ/lCUN2HEhS4XL6IE0xDVBeSnHAwCZYcmfuFTS0FfJRzN08TptTcvd3GP2lzlHNnGjLVCWfSDF9ggXDVGV79hv1rA6Jzuqg+8kBhlzAxZf2CpaLc0Ag+JqCK4RWfkFJXsqEZUl2N24xTSUxWm9/c2f6xNf5H+mv3OnjfNVv/SBwS7B5xowbVXI5o8Y7MJSjU6btQN4taiZvMRX
 b2o+DYe7
 Jct2Vnviai9/hYku6u0i+c6O/irTsIZbgxwaQcNHyGGGN3WS5+XL29QbJSnp7TwT3z5PiIg+o7nr1nspkwIo12yfVD5nobStA+KEkgz2TjK/g6nyegbzrcVC7IU20y9WM2hJJ/wMwQZlopESAR2O1UdYHcbXxhOsuUL1zMco4e3hxBFKPjZeGVmcJcIK9hWrmbBXMOc6DocOis7nGnGeV8TfHhpq8H0y4kTNzAbWtr7rtUKJc0LgoUD7RPU3VmDCs4J6/ETCyYo/psdMdkYWVd2maReNJcBbv98EElHZ7jmSbq5p6qhvZ7iXu4QzTuGv5IvLv/j3FSw+0wOeqXY1MHeOUJTJFw/BaGvX51N1kFNQcr2EUZGrLluTJqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To prepare for merging the swap_cgroup_ctrl into the swap table, store
the memcg info in the swap table on swapout.

This is done by using the existing shadow format.

Note this also changes the refault counting at the nearest online memcg
level:

Unlike file folios, anon folios are mostly exclusive to one mem cgroup,
and each cgroup is likely to have different characteristics.

When commit b910718a948a ("mm: vmscan: detect file thrashing at the
reclaim root") moved the refault accounting to the reclaim root level,
anon shadows don't even exist, and it's explicitly for file pages. Later
commit aae466b0052e ("mm/swap: implement workingset detection for
anonymous LRU") added anon shadows following a similar design. And in
shrink_lruvec, an active LRU's shrinking is done regardlessly when it's
low.

For MGLRU, it's a bit different, but with the PID refault control, it's
more accurate to let the nearest online memcg take the refault feedback
too.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/internal.h   | 20 ++++++++++++++++++++
 mm/swap.h       |  7 ++++---
 mm/swap_state.c | 50 +++++++++++++++++++++++++++++++++-----------------
 mm/swapfile.c   |  4 +++-
 mm/vmscan.c     |  6 +-----
 mm/workingset.c | 16 +++++++++++-----
 6 files changed, 72 insertions(+), 31 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d9..5bbe081c9048 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1714,6 +1714,7 @@ static inline void shrinker_debugfs_remove(struct dentry *debugfs_entry,
 #endif /* CONFIG_SHRINKER_DEBUG */
 
 /* Only track the nodes of mappings with shadow entries */
+#define WORKINGSET_SHIFT 1
 void workingset_update_node(struct xa_node *node);
 extern struct list_lru shadow_nodes;
 #define mapping_set_update(xas, mapping) do {			\
@@ -1722,6 +1723,25 @@ extern struct list_lru shadow_nodes;
 		xas_set_lru(xas, &shadow_nodes);		\
 	}							\
 } while (0)
+static inline unsigned short shadow_to_memcgid(void *shadow)
+{
+	unsigned long entry = xa_to_value(shadow);
+	unsigned short memcgid;
+
+	entry >>= (WORKINGSET_SHIFT + NODES_SHIFT);
+	memcgid = entry & ((1UL << MEM_CGROUP_ID_SHIFT) - 1);
+
+	return memcgid;
+}
+static inline void *memcgid_to_shadow(unsigned short memcgid)
+{
+	unsigned long val;
+
+	val = memcgid;
+	val <<= (NODES_SHIFT + WORKINGSET_SHIFT);
+
+	return xa_mk_value(val);
+}
 
 /* mremap.c */
 unsigned long move_page_tables(struct pagetable_move_control *pmc);
diff --git a/mm/swap.h b/mm/swap.h
index da41e9cea46d..c95f5fafea42 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -265,6 +265,8 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
 	return folio_entry.val == round_down(entry.val, nr_pages);
 }
 
+bool folio_maybe_swapped(struct folio *folio);
+
 /*
  * All swap cache helpers below require the caller to ensure the swap entries
  * used are valid and stabilize the device by any of the following ways:
@@ -286,9 +288,8 @@ struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
 /* Below helpers require the caller to lock and pass in the swap cluster. */
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry);
-void __swap_cache_del_folio(struct swap_cluster_info *ci,
-			    struct folio *folio, void *shadow,
-			    bool charged, bool reclaim);
+void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
+			    void *shadow, bool charged, bool reclaim);
 void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 				struct folio *old, struct folio *new);
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 40f037576c5f..cc4bf40320ef 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -143,22 +143,11 @@ static int __swap_cache_check_batch(struct swap_cluster_info *ci,
 {
 	unsigned int ci_end = ci_off + nr;
 	unsigned long old_tb;
+	unsigned int memcgid;
 
 	if (unlikely(!ci->table))
 		return -ENOENT;
 
-	do {
-		old_tb = __swap_table_get(ci, ci_off);
-		if (unlikely(swp_tb_is_folio(old_tb)) ||
-		    unlikely(!__swp_tb_get_count(old_tb)))
-			break;
-		if (swp_tb_is_shadow(old_tb))
-			*shadowp = swp_tb_to_shadow(old_tb);
-	} while (++ci_off < ci_end);
-
-	if (likely(ci_off == ci_end))
-		return 0;
-
 	/*
 	 * If the target slot is not suitable for adding swap cache, return
 	 * -EEXIST or -ENOENT. If the batch is not suitable, could be a
@@ -169,7 +158,21 @@ static int __swap_cache_check_batch(struct swap_cluster_info *ci,
 		return -EEXIST;
 	if (!__swp_tb_get_count(old_tb))
 		return -ENOENT;
-	return -EBUSY;
+	if (WARN_ON_ONCE(!swp_tb_is_shadow(old_tb)))
+		return -ENOENT;
+	*shadowp = swp_tb_to_shadow(old_tb);
+	memcgid = shadow_to_memcgid(*shadowp);
+
+	WARN_ON_ONCE(!mem_cgroup_disabled() && !memcgid);
+	do {
+		old_tb = __swap_table_get(ci, ci_off);
+		if (unlikely(swp_tb_is_folio(old_tb)) ||
+		    unlikely(!__swp_tb_get_count(old_tb)) ||
+		    memcgid != shadow_to_memcgid(swp_tb_to_shadow(old_tb)))
+			return -EBUSY;
+	} while (++ci_off < ci_end);
+
+	return 0;
 }
 
 void __swap_cache_add_folio(struct swap_cluster_info *ci,
@@ -261,8 +264,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 
 	/* For memsw accouting, swap is uncharged when folio is added to swap cache */
 	memcg1_swapin(folio);
-	if (shadow)
-		workingset_refault(folio, shadow);
+	workingset_refault(folio, shadow);
 
 	/* Caller will initiate read into locked new_folio */
 	folio_add_lru(folio);
@@ -319,7 +321,8 @@ struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp_mask,
  * __swap_cache_del_folio - Removes a folio from the swap cache.
  * @ci: The locked swap cluster.
  * @folio: The folio.
- * @shadow: shadow value to be filled in the swap cache.
+ * @shadow: Shadow to restore when the folio is not charged. Ignored when
+ *          @charged is true, as the shadow is computed internally.
  * @charged: If folio->swap is charged to folio->memcg.
  * @reclaim: If the folio is being reclaimed. When true on cgroup v1,
  *           the memory charge is transferred from memory to swap.
@@ -336,6 +339,7 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 	int count;
 	unsigned long old_tb;
 	struct swap_info_struct *si;
+	struct mem_cgroup *memcg = NULL;
 	swp_entry_t entry = folio->swap;
 	unsigned int ci_start, ci_off, ci_end;
 	bool folio_swapped = false, need_free = false;
@@ -353,7 +357,13 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
 	 * charging (e.g. swapin charge failure, or swap alloc charge failure).
 	 */
 	if (charged)
-		mem_cgroup_swap_free_folio(folio, reclaim);
+		memcg = mem_cgroup_swap_free_folio(folio, reclaim);
+	if (reclaim) {
+		WARN_ON(!charged);
+		shadow = workingset_eviction(folio, memcg);
+	} else if (memcg) {
+		shadow = memcgid_to_shadow(mem_cgroup_private_id(memcg));
+	}
 
 	si = __swap_entry_to_info(entry);
 	ci_start = swp_cluster_offset(entry);
@@ -392,6 +402,11 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci, struct folio *folio,
  * swap_cache_del_folio - Removes a folio from the swap cache.
  * @folio: The folio.
  *
+ * Force delete a folio from the swap cache. This is only safe to use for
+ * folios that are not swapped out (swap count == 0) to release the swap
+ * space from being pinned by swap cache, or remove a clean and charged
+ * folio that no one modified or is still using.
+ *
  * Same as __swap_cache_del_folio, but handles lock and refcount. The
  * caller must ensure the folio is either clean or has a swap count
  * equal to zero, or it may cause data loss.
@@ -404,6 +419,7 @@ void swap_cache_del_folio(struct folio *folio)
 	swp_entry_t entry = folio->swap;
 
 	ci = swap_cluster_lock(__swap_entry_to_info(entry), swp_offset(entry));
+	VM_WARN_ON_ONCE(folio_test_dirty(folio) && folio_maybe_swapped(folio));
 	__swap_cache_del_folio(ci, folio, NULL, true, false);
 	swap_cluster_unlock(ci);
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c0169bce46c9..2cd3e260f1bf 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1972,9 +1972,11 @@ int swp_swapcount(swp_entry_t entry)
  * decrease of swap count is possible through swap_put_entries_direct, so this
  * may return a false positive.
  *
+ * Caller can hold the ci lock to get a stable result.
+ *
  * Context: Caller must ensure the folio is locked and in the swap cache.
  */
-static bool folio_maybe_swapped(struct folio *folio)
+bool folio_maybe_swapped(struct folio *folio)
 {
 	swp_entry_t entry = folio->swap;
 	struct swap_cluster_info *ci;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5112f81cf875..4565c9c3ac60 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -755,11 +755,7 @@ static int __remove_mapping(struct address_space *mapping, struct folio *folio,
 	}
 
 	if (folio_test_swapcache(folio)) {
-		swp_entry_t swap = folio->swap;
-
-		if (reclaimed && !mapping_exiting(mapping))
-			shadow = workingset_eviction(folio, target_memcg);
-		__swap_cache_del_folio(ci, folio, shadow, true, true);
+		__swap_cache_del_folio(ci, folio, NULL, true, true);
 		swap_cluster_unlock_irq(ci);
 	} else {
 		void (*free_folio)(struct folio *);
diff --git a/mm/workingset.c b/mm/workingset.c
index 37a94979900f..765a954baefa 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -202,12 +202,18 @@ static unsigned int bucket_order[ANON_AND_FILE] __read_mostly;
 static void *pack_shadow(int memcgid, pg_data_t *pgdat, unsigned long eviction,
 			 bool workingset, bool file)
 {
+	void *shadow;
+
 	eviction &= file ? EVICTION_MASK : EVICTION_MASK_ANON;
 	eviction = (eviction << MEM_CGROUP_ID_SHIFT) | memcgid;
 	eviction = (eviction << NODES_SHIFT) | pgdat->node_id;
 	eviction = (eviction << WORKINGSET_SHIFT) | workingset;
 
-	return xa_mk_value(eviction);
+	shadow = xa_mk_value(eviction);
+	/* Sanity check for retrieving memcgid from anon shadow. */
+	VM_WARN_ON_ONCE(shadow_to_memcgid(shadow) != memcgid);
+
+	return shadow;
 }
 
 static void unpack_shadow(void *shadow, int *memcgidp, pg_data_t **pgdat,
@@ -232,7 +238,7 @@ static void unpack_shadow(void *shadow, int *memcgidp, pg_data_t **pgdat,
 
 #ifdef CONFIG_LRU_GEN
 
-static void *lru_gen_eviction(struct folio *folio)
+static void *lru_gen_eviction(struct folio *folio, struct mem_cgroup *memcg)
 {
 	int hist;
 	unsigned long token;
@@ -244,7 +250,6 @@ static void *lru_gen_eviction(struct folio *folio)
 	int refs = folio_lru_refs(folio);
 	bool workingset = folio_test_workingset(folio);
 	int tier = lru_tier_from_refs(refs, workingset);
-	struct mem_cgroup *memcg = folio_memcg(folio);
 	struct pglist_data *pgdat = folio_pgdat(folio);
 
 	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH >
@@ -252,6 +257,7 @@ static void *lru_gen_eviction(struct folio *folio)
 
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	lrugen = &lruvec->lrugen;
+	memcg = lruvec_memcg(lruvec);
 	min_seq = READ_ONCE(lrugen->min_seq[type]);
 	token = (min_seq << LRU_REFS_WIDTH) | max(refs - 1, 0);
 
@@ -329,7 +335,7 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 
 #else /* !CONFIG_LRU_GEN */
 
-static void *lru_gen_eviction(struct folio *folio)
+static void *lru_gen_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 {
 	return NULL;
 }
@@ -396,7 +402,7 @@ void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
 	if (lru_gen_enabled())
-		return lru_gen_eviction(folio);
+		return lru_gen_eviction(folio, target_memcg);
 
 	lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
 	/* XXX: target_memcg can be NULL, go through lruvec */

-- 
2.53.0



