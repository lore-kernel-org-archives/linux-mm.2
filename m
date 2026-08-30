Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37AC1C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 18:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06976B0095; Sun, 30 Aug 2026 14:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDD926B0096; Sun, 30 Aug 2026 14:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57936B0098; Sun, 30 Aug 2026 14:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 632366B0095
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 14:43:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BAC5014033E
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:43:41 +0000 (UTC)
X-FDA: 85158809442.26.87E9F5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id BBB37140005
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:43:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e0Tz3As/";
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788115419;
	b=t+nuC2RUzH/j7qrI0dfjW7mJyE7UO4WY3Y3WwToRwdRSIsbwYNkqZNWWDFIeiVxzkLsg6D
	bPCx4FVUEZLKt4JYG7D612DVNQKSWCuqDIe9aNeaxrrIl0pslVNfzoxOzHGxHGLS9p210m
	5eUhmm6QQNa3WYuu+nQUEej0uvYld2g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788115419;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8HtBwYOH/c+DQcEy94gsGRuG9slqkd87+CY9P3PPJM=;
	b=Yod1OhEPd4Lzw466eA5jnUhLJ+fOyBMnyzmYZ4ocj+RxiUc/DTghHkSu52Dfp55ISSUi+1
	JqfOBOZ/pmuVNosovTPoMuoKemwwSyEW4GbACqiejOEr5SAcw1IyCTC2YrO9L/AXBBu8Zb
	e/dUqB9+yNTIDYE/RQbL+K5XWgYEyII=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e0Tz3As/";
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 262924450C;
	Sun, 30 Aug 2026 18:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EFA97C2BD00;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788115418;
	bh=Z4M/WPpzvepsYGJB+gWn8bv52ugodElvQ0+zzzD3630=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=e0Tz3As/OezNV5CVe7W3YP6IKQ7VzZ2M9fPOu0zrPFlcE+DgNLYL6NGYNI1dKkD1T
	 4wohq+ffKmrBwCBxRVT9F3btNz3QydsSYVZFVUSR34/2v//OmjptI6UDqjWGARpYj6
	 auyXb10lG8TYEF/rEY93KHJu2/c0B8OFz9pnPwVF8h0IMx//qjCQZVLillJZBJOjKq
	 VH0CCgmJDAH2UqAY0LUfoYTeS67liZY4MwK9+r3tghDOg4GHk72bwhY4HGqJ+0te5h
	 BcAud9LbRwLzzIHWlVsv3KZJb04j0dVXaa0i2CZtN7Mt6c8WdzfbZ6F1QGgLQSIMgh
	 F3JrGIqjcQsCA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EA2C61DE1;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 31 Aug 2026 02:43:34 +0800
Subject: [PATCH v4 4/6] mm/mglru: move max_seq read into walk_update_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-mglru-flags-cleanup-v4-4-2d15dde0d7ee@tencent.com>
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
In-Reply-To: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788115415; l=5248;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=MjFMt9GK+ni58sgBI6clUwzVmv/EoZkBPc5qdd6el6w=;
 b=OzC8dM84YUEAxm8bY4sff9mo8PnjTI/P4G95CJRxI3+jqnSHjANDU7owp297rlQqQwepJmv0q
 DAaRKCAcdG3DPwEwyuRHPPwcj2o59Cd6KMXlbc0n/d8j9gMyZEkn8sk
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BBB37140005
X-Stat-Signature: iduc6c19hbowaj55axjqyd8y743nfru4
X-HE-Tag: 1788115419-345713
X-HE-Meta: U2FsdGVkX18WOQiW+1M7w16/HhhK8irvdVYbZUBPZrfamXOthAWfa1Pl+8sSQVArXtRQrtOkFghq/oB70cpXoNAz2syqV1S8UdSETZhuvBRtG2WvN74K2z2hD9asEM541PZ7hdZ5jJ3a62GxiW1Frm8lsnc9wJLxUpFzQ2B8Bx0fdc/sNjoqgJQ3i5SeQXMNfuxrNg1V/wL+HSZnWUHfOSGCfwAN0+VLZBPWinm01n/k/APmuJR3mXS9lkK1wTlo8ijHBHfQoLnfwccM/GtSeEq94KD+LHiHNaEPC7SFoBQ/PPkBue72CgaPE+XsmwgDsedgq5m0Oz1qxDC9R0yVLpeCfec7Ajo0+IGxPA08QkAk+e4UeD7uwyp3vUezr7bjZuBVGx9/x8LuugNqhBaIbtgrVMuVOTGFnovL6y77ZbJlJAPXHbG4FcJXRmpG5syTLUPfywTiyUBrtSwFCeKC3mO3R84NOqVkNT0EShyJ8Erju2UDAJ2d+y7DsM9k15rli6q1J6LjBxC/qy1yTFwbiOC+CM6QVl3jv2IO/quY8CC8muBpBx+vzQIu6CFOZ7pEr35fnT/CYGolmnYOFq7QDimHQU5USGAKevk/hoN0gABiT9BBie4bTGzytkz8xQPKWAiQBUHram8/PR7zhxRTqj/OHJPt5jkFHSGU9DXSqqnIqYL849XJAF98am71u6nnN9z72nSfJMpKjvxFBCTUQ+SeJ3IBAwUqUrN2fyxjvnv0Kw+iGKmX7f634MnVv2yT8T0OjMrs4TnpVzunoQMhdImkAmRDR6SW7tRWOyibwZmO/f9Dvm2mvCB5E5eeIzJwFeW7VfjQ/zypWSx4PsZN/wBld16WNLUmAO8R9z9sCWE0fKIx/A+Ws4mXqYnrtjfoWVlB8zhaFHncLW4P/j6Gtpg362okaVMsEL2kFQ2ieubiB2oLFbwgyyJFHX+nDfrH6EEMA7pH+aaX1lVWxDh
 PnbKReKK
 HyXPojszO3S90OjwJVtLSE0tMZ/TTHTOCc55kZPduRKg0NYvLOaI5sdKn25dDoWc+15JmtSnoUH5ZTBHhtEdo3QqyObS1iE3r/mfpVBUcuDwnF6hXaOySuDQr/YHhf1/ajkN9QyYgaQeRqOPdypNAu/rsqC8VRZdqyoWiaZEy5LShuQuzis21JxRpukrJxuujxr/KcEB8l3gpRf89Tnyn/Gm0wmAye21u3JB2k/hYU9OiCHatHKtjf9iee3Mb/OQtBVu6xyVKHhm8t1K/2iTiKGIl3g2+HRjEXuKGU2VRi3SVKkZAzotb+dnM1oDtYOy2el0RV6DJ9Zy1KcLVjIFScQmhKOnDiL+sD0uYrv2kKv64caawK+5xiHyXErEzh3fQQpSRDgnij3zei+jgzUXR2N1arNykTdFZgNOWMbHKsihcV0uPKDAmuGB+yqjdSnGGF2JsLhIkguu6vvIzD8fZH10408GogjK20odsVzUhFIa+sX5hmvGioBoAIKsfrduHa0zr0u6lAyJDmQcRWOTeQLg99pQmOY4ojHN/ZqPKUgk1z7s0IHnY6jIhTw==
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
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 992d0d3e2311..88474d4af54b 100644
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



