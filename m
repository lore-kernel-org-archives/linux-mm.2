Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C025C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72A46B00A1; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46506B00A2; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0E926B00A3; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7999B6B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11A66401AE
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:26:35 +0000 (UTC)
X-FDA: 85136539950.15.93EAEA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 00A161C0003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fFwWL5qy;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787585193;
	b=JSMkGNungVMEywvoE3VxKPHkZTSl/FNcTEHwNDBuQJuopHwjV8BoKT5NW3OFkfVMnOXQl+
	udFtEemucMDdWt+PPbyQ4wq7gq/qVm27kXuIgCS+9yus1vUg2S4ziY2ceH79Q439hsX0Qv
	4uMizE7BUIxdZNGefJCcZiOheyUV4Rg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fFwWL5qy;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787585193;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AXHjO7Cjpt2kwJR3T15v4c+1u7UbDiWE6+wU14bn448=;
	b=DJgFtnNtiBCfsTMatGv4cDF7ayF6wIgSdCs4lTpOVKNmRwCreq4TcIe41Gp4ZahbMJ3QG7
	fpgHr9kcriHOUoXyXkqdeq0dlnfdUpNm1CvE5FhNTqqkbGaw7LuDeldYr1N9hujAyl0G9y
	ScoWO8X5C2snFQlSF0aA7hImfrzxPLU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 367DC44003;
	Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10ED8C32782;
	Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787585192;
	bh=dpmYkQOyU/63g41Wz5LkJjXAI/RubSJlPh6+4gkd8v8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fFwWL5qyjQ2sDGsOcuVqWIWL9cnJGxjGq2x4vlVELteMSRpd64+DYvDELQFUluY7P
	 kfyY1wT8crg8KgYYtRNb5n8wa/th532Ddbn0aH9a8XyVQHa2e45LCVZd393H+MaLJl
	 jKRyn9tl+qjRNdQQitULSxbdsUxg1fimdWx20Yv9ggW97xO8+vTJ/+vG4e5xKuSGC1
	 /a1KpUCxexeWjJ/i+7g2fJfrxp/zRs7ijyGy58A79CBhsxX1emJVmbfUiLkPh46is5
	 YcujKuMTxFLFz3TKjOWndbvhN10rXrSDfuEKZqRhFIaUPjpSXIbBxr3GfZQA/aEQWY
	 rgoE5l4oXUDEA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F139BC61CE3;
	Mon, 24 Aug 2026 15:26:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 24 Aug 2026 23:26:31 +0800
Subject: [PATCH v2 4/6] mm/mglru: move max_seq read into walk_update_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-mglru-flags-cleanup-v2-4-0104132114ae@tencent.com>
References: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com>
In-Reply-To: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
 Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Kairui Song <ryncsn@gmail.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787585189; l=5157;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=dIFhd9ek4+se0CLteaNFAXeBhV2iEYvheQuV+FpkZJ8=;
 b=ILIf9yWr8WDVruprF6y5ipPLOwRchwpqZ0QcFLxl3FxIhy/GFqzlb7HRxzazOhfW1R6GrnPy5
 aGusfe3+SarC4HDHoaw+F9Co30AhK0q/JfeqyPFE/6Qza533ssU1M3w
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 00A161C0003
X-Stat-Signature: 7313jy4zhne8hq8jgqmxkj4cza6k6ts9
X-HE-Tag: 1787585192-946290
X-HE-Meta: U2FsdGVkX18oOFgruXStr7SbTB0iSzJhaNQhtO6irhPZDuGcW5KqywaAZhUnuqoRnGB/EFfQyhTt/85fRcHGPLOX/Q0w7Fyru6fxCa9uXZ4cljMJlCnsAtVWmK3w1kOZ2X8mzZZUXh92TMxdc0FFRz1ArHCswoiqONKXYuMW43/62Q1VXcvNtgXUZ6M9xlOr0nw8fCgqVXnfL6e+zBMUf9SICow8drWHR04H477qe15UpkudMJm9R2lwhXgsiRwwyy0dADIu8LBkagLeEdu3phexJrC9ajfoZK914dzgYrcsWscHFUJd+F3HgqPDbOp0h8HqIEVXa6B4pbEjgga0Gv95NAIuYxrr1s8fA7hMw82DU0h6QHdDLaW82UsvgS71F139gyNM/UVT3IH7ryF977ihESJ+m0ooRVhbeVKb46Vl0xUGCppHiMeE+xqoTKGSoV2NNlT8c2oxlHnt+I0i47OhdJc+YAAC8X7SKJpxfF/DkPZ5DOIvyoUO548XB62lW83tTY61gPuKkGmNjX87vd5XV6PjKeBlcVC3vNE+qOvkeQO+6h7eo3gC2aU9qUMGnuD8/S51ySTh731q5s46plWcDajxGy/7RXXdRFKp/9cXyCClqgbrMK8LoPZcfeyM1kSBBdSgq3zeZrhQnGsB+JOsp9PR/b8MLcY9mGCvjGQvOOVYUxY6oN1apgmGuXDX4Mjp1bT1N132DM9InbchUyhrwvBjFEqGcCftIF4anvvgSDuLQju0XB61fBO1E7SvbpEzif0lwsW25kX99joQno6l0VTFnSwMfJSXJL8Aupl3flmpr8v1ijInwyb7ptnqzxwEOlX9m17lAuTZU8JcmZ1JZHCxEMQJ7UoHOLZyYHIy4JpsyKansMjwMqkdq/6e44daHebKhGtLwMls11l2Io5tDu9UZ7xAiQBZb7ThEbheXy6ICvYb4GKMh8+KD4yDtv44RHO85l2TLFzxiqs
 +XNNajlm
 FU0VBsHG3HVtg5NzJiTyu4bpZ9WAgCz0525Ldzl380nFFNIp4LrLGGRV1xp96CX88drhZFu3+eXGGcOCaW11sPGtKOxCTRofU6HaU01cr/E+/w5qz0ryGG10GVTOQo0bqDdeUTSCQncTS3xTrsDwUCQuN/ZMGTywjwltEtK6/U3dw8ihvaPf0+T+eqPZEiPpH0gIfDDiyFSQidmXkpowMUu9Jw393F01lt0CMBh8LpQsOizWMXhgqHLmltdZB+Z6ynptAHDIMwU5J9G2GR/Suya0UxHPArJFRbr/AY9RNYNRTVCIr2WUJzAHFFkQ5e32Ti53yvypSUS/PFQo8qxbfAZ+a90zMxj5T0NARAggYMNRCheiFyG2gc1bw1+miDoIBL6V6mUgeZUgoy3zJK7xAm70Bsdz63plXbpl296gAcrBKfq2vkzaHCay7cFelGWJp01kpooNS8xuQIm2Eqq22gyGEM7x48YOJz+E4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

walk_pte_range(), walk_pmd_range_locked(), and lru_gen_look_around()
each read lrugen->max_seq to compute the target generation used by
walk_update_folio(), then pass it as a parameter. Move the read into
walk_update_folio() itself so the callers no longer need to compute
or pass the value.

The max_seq read now happens once per folio update rather than once
per walk range, so folios always get promoted to the current youngest
generation.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 080132997d87..557927b498fa 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3517,13 +3517,15 @@ static bool suitable_to_scan(int total, int young)
 }
 
 static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
-		struct folio *folio, int new_gen, bool dirty)
+		struct lruvec *lruvec, struct folio *folio, bool dirty)
 {
-	int old_gen;
+	int new_gen, old_gen;
 
 	if (!folio)
 		return;
 
+	new_gen = lru_gen_from_seq(READ_ONCE(lruvec->lrugen.max_seq));
+
 	if (dirty && !folio_test_dirty(folio) &&
 	    !(folio_test_anon(folio) && folio_test_swapbacked(folio) &&
 	      !folio_test_swapcache(folio)))
@@ -3554,8 +3556,6 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
-	DEFINE_MAX_SEQ(walk->lruvec);
-	int gen = lru_gen_from_seq(max_seq);
 	unsigned int nr;
 	pmd_t pmdval;
 
@@ -3606,7 +3606,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, args->vma, last, gen, dirty);
+			walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3619,7 +3619,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		walk->mm_stats[MM_LEAF_YOUNG] += nr;
 	}
 
-	walk_update_folio(walk, args->vma, last, gen, dirty);
+	walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
 	last = NULL;
 
 	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
@@ -3642,8 +3642,6 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
-	DEFINE_MAX_SEQ(walk->lruvec);
-	int gen = lru_gen_from_seq(max_seq);
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -3697,7 +3695,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			goto next;
 
 		if (last != folio) {
-			walk_update_folio(walk, vma, last, gen, dirty);
+			walk_update_folio(walk, vma, walk->lruvec, last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3711,7 +3709,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
 
-	walk_update_folio(walk, vma, last, gen, dirty);
+	walk_update_folio(walk, vma, walk->lruvec, last, dirty);
 
 	lazy_mmu_mode_disable();
 	spin_unlock(ptl);
@@ -4275,8 +4273,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	struct pglist_data *pgdat = folio_pgdat(folio);
 	struct lruvec *lruvec;
 	struct lru_gen_mm_state *mm_state;
-	unsigned long max_seq;
-	int gen;
 
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
@@ -4313,8 +4309,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 
 	memcg = get_mem_cgroup_from_folio(folio);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
-	gen = lru_gen_from_seq(max_seq);
 	mm_state = get_mm_state(lruvec);
 
 	lazy_mmu_mode_enable();
@@ -4346,7 +4340,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, vma, last, gen, dirty);
+			walk_update_folio(walk, vma, lruvec, last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -4358,13 +4352,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 		young += nr;
 	}
 
-	walk_update_folio(walk, vma, last, gen, dirty);
+	walk_update_folio(walk, vma, lruvec, last, dirty);
 
 	lazy_mmu_mode_disable();
 
 	/* feedback from rmap walkers to page table walkers */
 	if (mm_state && suitable_to_scan(i, young))
-		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
+		update_bloom_filter(mm_state, READ_ONCE(lruvec->lrugen.max_seq),
+				    pvmw->pmd);
 
 	mem_cgroup_put(memcg);
 

-- 
2.55.0



