Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 449BFF8D762
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 18:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F6EB6B00AC; Thu, 16 Apr 2026 14:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BD586B00B0; Thu, 16 Apr 2026 14:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 325226B00AC; Thu, 16 Apr 2026 14:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE356B00AE
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:34:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C106A8C863
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:34:49 +0000 (UTC)
X-FDA: 84665270298.06.1A9652E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A2D8918000A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:34:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b3LbEPlp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776364487;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GlBil7AGj4utMDh1N8Fm9WuVbNrKOxJrHx1UjB4EjHA=;
	b=zxj+1UQ6yiabtReHkIsFlzUy0uiwSwOgaRaQHQTE5XTFMF56CP/UBd/MeLxBHWuWlGcVU4
	TCcMtZPoiCL/QlASkneh2iJJFjv0pQNLOCyUCq3IuJCSN7aVjCMpJnEh7wk+XjKUKndoFr
	ZnMF2AoVXzbaXpwoiReQP/I9Ow19dX0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b3LbEPlp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776364487; a=rsa-sha256;
	cv=none;
	b=nmYDmOUF81+DkOYegxl+/tnIDQSCa0Y0xecoa9vMQR7ajtumrQFXsoD5UJsYbFhuz9mUTF
	UKnzqvUXA0wCusgu3G0fOGAExOP4ojb3kuge0qCuJQSQ0PBdoOKeCSug9tulgB4IOhJsh3
	4AD1OIpKUUQ/sXZgTtWkdfG60Q0TFIE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B590F44706;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BD0BC2BCB0;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776364483;
	bh=UyUy5sknSy4UlieqVWanxeAKCUYZOMCiIgW+BtPl9xE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=b3LbEPlpD4i28rVmdrH+AIqsvTs9DORoJTSnHjHC9NlilR1ovNsC4eMCUXrBc/uAQ
	 0yGdRw5IyHJMk9fhOy5gModnmn4lni7+70Or3hNdfLCzEo1aZ1ExjwMmnJWDEfztJb
	 /TjfxDNW/AlD+R6DXKHRRx3DA7WHi9FkwL1YEXMTH0qGu4C5nErC+GVRDhmclzYq68
	 jNSFFnMnxybOELO3MzgHqdHlfuHUoroIgH3+IHNoXRbSi+861Y3QjRHJLIfQQLMNpC
	 /GTs2sJmLg+kvNw+VUNzrfubvfx0mvjq0dALdZv1nkRPPN3eQ/+zd0pu+s19ZYDn5c
	 5wQiHFmm76LWQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EA0F8D755;
	Thu, 16 Apr 2026 18:34:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 17 Apr 2026 02:34:38 +0800
Subject: [PATCH v2 08/11] mm/swap: delay and unify memcg lookup and
 charging for swapin
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260417-swap-table-p4-v2-8-17f5d1015428@tencent.com>
References: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com>
In-Reply-To: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yosry Ahmed <yosry@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776364480; l=7647;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=MaPZt4DakdEFcAuU7VMbnT8dk7oBx3itn1gaO3e2CGw=;
 b=bhDnUB5C89/wmrDy04bf6K7rURpehnUIZLRzfTCPaUkBQIn08ezpUPelyzuE/ynTJRE+6VGOB
 ma1S0NAIT9CA3vRQN2vO+02EdMCcpMkmbTRhK5RDgo82mxzJHJebs6x
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A2D8918000A
X-Stat-Signature: x5fjaz9u19xuch5f7nw3ebuidijdeti8
X-Rspam-User: 
X-HE-Tag: 1776364487-763113
X-HE-Meta: U2FsdGVkX19q4tckkGwvQVCrPmwhzxBaHER3z4DE7bkaDbnlW8PrsJ/3kNaixQTtA97LUxS9k/X697XNNkqgOiuWRcRv/bm7wcvc5RpKFAo9KdA8RBNf0LhdInHdXXujVb7dPaI/w4xqXCn2WN06rfA5A27YOCcA7ww5Yg5zkCpBhAaE/gLeOo0oNb943b72w2duLKYM/Y+7RyHu1tvImESTvrXHiu7cWQ0QaCvz5F5cwgbi4p2+dUhUg6m149+Nd+7wspUmBrUG1NBRY/Ok5ZnDZZRA5U8lHZ2012DIiAjEUARSvIZ4qeIBzKd6Ze8ZlktWrRCy8Ss+hHvzwjjg91gI+xS/e8ICFfeF9b7JMgX9AqV6kehKvyeAqYl2zXqc9uyoVjvGPkcxWp2LgR3hEKFkpTQDIghPY6zgGEHDIdLDUMoxJ3jo0oGMezUJ1UUMFwse47RCjUdv99o4ogotwlUGdJIc3Nzc1UrIorh8yrqV+ghPnNC56JRiSTvYV2Ys7FyaNLJcSqNYFHZo9ihEbG4QQsJxBR9K+orY6fgSCbCyWcdqpJCOCuPpXtEtvFQD1fBbRZ5lcG9NeOv3rg3MM7eYP8f+a1PH/AKVtemZjjykHJtdVa3YSnwjbM48zOdXYrzJKBU64lixbQ5xd7wuFn6T3jAAI+E/NDqiJtdZZbonnw16eqPM+ArCG9XGCo/R06jraiuorBjAp/6JBwKIF5n5HO08D+mvfc7BPrK5rcp/sUx1PnipZWgujoH1/67bsruBm56kTCQKALbhT2oHIR1FkGcJ7KVjzhIjCoL19ox5ArF2icABi5Suwvt4F72YWlnIPsvPaMTaoTXYjliz2BpkujFQX7bVOo/VV1HwKkIAN6pBzi7y8VBq/gU5dJSDEoaxgUdyL+EpNfUZoaULOFb6oUPBKlRqblwISwOE6h/z3n1urIQ6AAPjENb/8w9HOTrJhER+JnP1GHaDb0q
 Bu32TUKR
 5I4xEbJSXm4sEtp1wL7ExEh0PAKj9l4VsA3IW2yvIk4vagApcmXwBd3OV9KCNigwpjr4TS/Z2Vl7N/Ywv4vE2x8w0XfQDbBJgSeOkanBIT1PXjmW6rR9o3aneISJcb5WFqvJrMb/pmrk66HlAUmjJBIERgCBrR6d40qOVnoxy/xB+PZkw/jBfSiqrdofW5y2UxqWRBAjUebfJRXxiKoJvP4QgRkISY6h71SfUGS4pPImUB5m/NJTuPhi+xLEIohRH59c2IhOiD9GgzXeIO/TjpbEg3x5Bjb2Lw7g8klwq2OBYFJVcXxluhdWCiSj+8hdSbCgN2HrSGTpW5F0aJsRDcQ2b4FPM+l0/YuwrxGlMnNisJ3wySIXmDaD1jvWU66lYz/19yTsXhulG2q00Z573m6PljA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of checking the cgroup private ID during page table walk in
swap_pte_batch(), move the memcg lookup into __swap_cache_add_check()
under the cluster lock.

The first speculative check skips the memcg check since the post alloc
stable check ensures all folios are in the same memcg. The chance that
all contiguous entries got installed to a contiguous range of page
table or shmem mapping, while belonging to different memcg seems a very
rare thing.

This also prepares for recording the memcg info in the cluster's
table. Also make the order check and fallback more compact.

There should be no user observable behavior change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h |  6 +++---
 mm/internal.h              |  4 ----
 mm/memcontrol.c            | 10 ++++------
 mm/swap_state.c            | 28 +++++++++++++++++++---------
 4 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d08128de1fd..a013f37f24aa 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -646,8 +646,8 @@ static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
 
 int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
 
-int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
-				  gfp_t gfp, swp_entry_t entry);
+int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
+				   struct mm_struct *mm, gfp_t gfp);
 
 void __mem_cgroup_uncharge(struct folio *folio);
 
@@ -1137,7 +1137,7 @@ static inline int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp)
 }
 
 static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
-			struct mm_struct *mm, gfp_t gfp, swp_entry_t entry)
+		 unsigned short id, struct mm_struct *mm, gfp_t gfp)
 {
 	return 0;
 }
diff --git a/mm/internal.h b/mm/internal.h
index d009d51e522b..32de9f3a9fa0 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -453,12 +453,10 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 	const pte_t *end_ptep = start_ptep + max_nr;
 	const softleaf_t entry = softleaf_from_pte(pte);
 	pte_t *ptep = start_ptep + 1;
-	unsigned short cgroup_id;
 
 	VM_WARN_ON(max_nr < 1);
 	VM_WARN_ON(!softleaf_is_swap(entry));
 
-	cgroup_id = lookup_swap_cgroup_id(entry);
 	while (ptep < end_ptep) {
 		softleaf_t entry;
 
@@ -467,8 +465,6 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
 		if (!pte_same(pte, expected_pte))
 			break;
 		entry = softleaf_from_pte(pte);
-		if (lookup_swap_cgroup_id(entry) != cgroup_id)
-			break;
 		expected_pte = pte_next_swp_offset(expected_pte);
 		ptep++;
 	}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c7df30ca5aa7..641706fa47bf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5062,27 +5062,25 @@ int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
 
 /**
  * mem_cgroup_swapin_charge_folio - Charge a newly allocated folio for swapin.
- * @folio: folio to charge.
+ * @folio: the folio to charge
+ * @id: memory cgroup id
  * @mm: mm context of the victim
  * @gfp: reclaim mode
- * @entry: swap entry for which the folio is allocated
  *
  * This function charges a folio allocated for swapin. Please call this before
  * adding the folio to the swapcache.
  *
  * Returns 0 on success. Otherwise, an error code is returned.
  */
-int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
-				  gfp_t gfp, swp_entry_t entry)
+int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
+				   struct mm_struct *mm, gfp_t gfp)
 {
 	struct mem_cgroup *memcg;
-	unsigned short id;
 	int ret;
 
 	if (mem_cgroup_disabled())
 		return 0;
 
-	id = lookup_swap_cgroup_id(entry);
 	rcu_read_lock();
 	memcg = mem_cgroup_from_private_id(id);
 	if (!memcg || !css_tryget_online(&memcg->css))
diff --git a/mm/swap_state.c b/mm/swap_state.c
index af50e6a21850..4c1cb0b1c0c5 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -142,16 +142,20 @@ void *swap_cache_get_shadow(swp_entry_t entry)
  * @ci: The locked swap cluster
  * @targ_entry: The target swap entry to check, will be rounded down by @nr
  * @nr: Number of slots to check, must be a power of 2
- * @shadowp: Returns the shadow value if one exists in the range.
+ * @shadowp: Returns the shadow value if one exists in the range
+ * @memcg_id: Returns the memory cgroup id, NULL to ignore cgroup check
  *
  * Check if all slots covered by given range have a swap count >= 1.
- * Retrieves the shadow if there is one.
+ * Retrieves the shadow if there is one. If @memcg_id is not NULL, also
+ * checks if all slots belong to the same cgroup and return the cgroup
+ * private id.
  *
  * Context: Caller must lock the cluster.
  */
 static int __swap_cache_add_check(struct swap_cluster_info *ci,
 				  swp_entry_t targ_entry,
-				  unsigned long nr, void **shadowp)
+				  unsigned long nr, void **shadowp,
+				  unsigned short *memcg_id)
 {
 	unsigned int ci_off, ci_end;
 	unsigned long old_tb;
@@ -169,19 +173,24 @@ static int __swap_cache_add_check(struct swap_cluster_info *ci,
 		return -EEXIST;
 	if (!__swp_tb_get_count(old_tb))
 		return -ENOENT;
-	if (swp_tb_is_shadow(old_tb) && shadowp)
+	if (shadowp && swp_tb_is_shadow(old_tb))
 		*shadowp = swp_tb_to_shadow(old_tb);
+	if (memcg_id)
+		*memcg_id = lookup_swap_cgroup_id(targ_entry);
 
 	if (nr == 1)
 		return 0;
 
+	targ_entry.val = round_down(targ_entry.val, nr);
 	ci_off = round_down(ci_off, nr);
 	ci_end = ci_off + nr;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
 		if (unlikely(swp_tb_is_folio(old_tb) ||
-			     !__swp_tb_get_count(old_tb)))
+			     !__swp_tb_get_count(old_tb) ||
+			     (memcg_id && *memcg_id != lookup_swap_cgroup_id(targ_entry))))
 			return -EBUSY;
+		targ_entry.val++;
 	} while (++ci_off < ci_end);
 
 	return 0;
@@ -397,6 +406,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	swp_entry_t entry;
 	struct folio *folio;
 	void *shadow = NULL;
+	unsigned short memcg_id;
 	unsigned long address, nr_pages = 1 << order;
 	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
 
@@ -404,7 +414,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 
 	/* Check if the slot and range are available, skip allocation if not */
 	spin_lock(&ci->lock);
-	err = __swap_cache_add_check(ci, targ_entry, nr_pages, NULL);
+	err = __swap_cache_add_check(ci, targ_entry, nr_pages, NULL, NULL);
 	spin_unlock(&ci->lock);
 	if (unlikely(err))
 		return ERR_PTR(err);
@@ -430,7 +440,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 
 	/* Double check the range is still not in conflict */
 	spin_lock(&ci->lock);
-	err = __swap_cache_add_check(ci, targ_entry, nr_pages, &shadow);
+	err = __swap_cache_add_check(ci, targ_entry, nr_pages, &shadow, &memcg_id);
 	if (unlikely(err)) {
 		spin_unlock(&ci->lock);
 		folio_put(folio);
@@ -442,8 +452,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	__swap_cache_do_add_folio(ci, folio, entry);
 	spin_unlock(&ci->lock);
 
-	if (mem_cgroup_swapin_charge_folio(folio, vmf ? vmf->vma->vm_mm : NULL,
-					   gfp, entry)) {
+	if (mem_cgroup_swapin_charge_folio(folio, memcg_id,
+					   vmf ? vmf->vma->vm_mm : NULL, gfp)) {
 		spin_lock(&ci->lock);
 		__swap_cache_do_del_folio(ci, folio, entry, NULL);
 		spin_unlock(&ci->lock);

-- 
2.53.0



