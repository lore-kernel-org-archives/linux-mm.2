Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0CC6C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 17:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CF7C6B0092; Tue, 25 Aug 2026 13:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480A16B0096; Tue, 25 Aug 2026 13:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36EA66B0099; Tue, 25 Aug 2026 13:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F17D06B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:53:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B52A140170
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:53:42 +0000 (UTC)
X-FDA: 85140539484.21.35D91A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 71FC71A0003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:53:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rRuQq1Uo;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787680420;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=85C+M83iu9pZ+gZyrLoUfdSGOtLwXo4rCHw+GsaKefo=;
	b=lMyWR6qBSkUlFQ+nE/rKjPFvgdYzUndgyB9O3fJm4b0CczkvjnVeXDfZb5O5GAgy2z4qlL
	hJrZhtR4Cq9beAiob1IDFhFhrjzJ2k/dm4szw80oPA9ik5kBs75lUAhzslz/6Mclea2yOp
	wvMD8/U/RlCzTE+qPwRdw6u84FVhdno=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787680420;
	b=k3og60PuERxvabYLcKcu6r3/PDzUAg6x8moEtwzC/qt+XnCtnhhLMJy5nakr9KhilH6gYU
	7yscwPkLthIcGPiNKkvZv8pSx6gYHPfyB2Yq8mkx7OjxT9HqfGQHBN0RC+0fepf+NQ0Vn3
	ZuwThwrxmIDidO/v6p3eXG7JQGGTlo4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rRuQq1Uo;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0367F40BC2;
	Tue, 25 Aug 2026 17:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1ECEC2BCFA;
	Tue, 25 Aug 2026 17:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787680418;
	bh=bzul0D3JQV4kWpHyizbt8WZdGt3nx9D3uliDe10GiG0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rRuQq1UoaYqFpWmP6h5rHRh4N4RGmRMb1T9J4zAT7F1SaLkLW/D/Nn8GbJxBSr1n3
	 uHoLHZVKzluXHjXHyf6NoiiKt2SxS2lssiw3J0jBPhQwHNmM0waNOYkc3YliLh/aUu
	 wNQuTVTyfsDmI6TEW3cbLeZeL5EJbr6lIruy/n61CiuZQlSKZC53MnZt8gXVLNm+PX
	 cz2GHzyXBliwPv1IantNIwbEm29t2BSFtVfVjYpE+HVvNJh8pV8UTvxB+8rfKo9z5P
	 k3VuVeS8G33+wYpWSTzuJFJ/FED2NXlYkk1EN9qd84Gm/a6i9BxBwg5EKEGRHtdXIQ
	 oFUZjshXzp7xA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC64BC61DCA;
	Tue, 25 Aug 2026 17:53:38 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 26 Aug 2026 01:53:37 +0800
Subject: [PATCH v3 4/6] mm/mglru: move max_seq read into walk_update_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-mglru-flags-cleanup-v3-4-d9f1c75549c8@tencent.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787680416; l=5157;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ZT5TcC/5iLXYPiPb0VvwvmrsHeSyXWxYOkPWhsEarcw=;
 b=vnH9efuWBUuVEK9bJhiE80ytIgl2qtqIkV+qnchbQOybOaLm7JmonjXlN4dCXTwE1h82C4RMF
 MFAqEscdC8xAiZqLFU14T9Go2bT+asW1h0ZUvn01YPP7qzWhJYEYOY8
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 71FC71A0003
X-Stat-Signature: 13pboyw6ypwj1bs7j51z5kpejkhkm31c
X-HE-Tag: 1787680420-250514
X-HE-Meta: U2FsdGVkX19Hwcu0uR+14YKOxW8RAWwH6qpeGZetJ0frL5oGj1UccexARVg//8Zl3coMnNXtrZ/vKbi7gYL+cENZcrNVcsa7/xZvdLSwDE8HmOK4E0Vzw4Y8kHad6kxwOOL3ZDWgeo6AMphedtSF/K5RWK3u0ko67vPc/fVEQDyx+S5nKztO3ivSLnSM0Vf8Gcja92iwaVH1NZpD7EA6oy7moZHcCoNXfkWTWMW5zlSnDwSyBIEehjpTyCgVLLWMbXf29h3oMA0u77xOpMMp1UqLiwvRltsKEW/+EAnaKY8Gk8NpRggEQ7UEePnS30GYfyxqFtOr9PrCmDLlXNHn/J/rijEjrMN0FvEp4ycuQ0ZP9XikjDiEffo5zuOgzstI2MZPiV9yRMcxWGwKm7NC+7xdZSQHm/Z6hkLfoR1xa2eJPZ5O+xIG/M928z5U9s8A8XGAwFSvO/VdIwv0esrNJjh2PwpqLeCiefuvGKUoJuGVM12JpQTULxnMF0X2ZhFEvkpx2d5OH7wM+kmx6krPXOoVStpFeGL3Fw02xsioH7zVQZ0q39+BhpUmuP6Ltwuifl4TLaaymGls1CMfYY8dSJ+BsvY5Q9NC2pU06eljzykkelwiV1lSvXoocRGrHvW+scNEksABRGbBTMoXkzB4dJxsDeQmaCDXm1I4mZrsrx+iaHxFt+3hx7E9CfEZJJblRQIgdNLKCAUobUd1ivI3Pjeg1QM2gS06Dkk+pjMK9KOGutgJRBwZxMqeaOw60Zfx8BudHunlOG3oep1AE8eDYwxWactKGgmA28ggKktFqMOTOvG7sS3on6uJa5CDHpY5YmVxo4R9FK8V5Ydilb+B/QwMLrEqwuPELMJaknAONBLsMlsSfbE/U/LJkBV6q0sHoIU6c/+yhiNkYvMB/+7PT7Wc1SOI8z8h0RDcIRUsAVb0EhXwuGYz6+JWI/Gt1E5ZOjeiAZnkVEv14WxvF8V
 rk5M103q
 Xs6sv51e1w7RUrN8eadODOGRnZ5YzgBrPV7ji5369wkEMVnTUv9L/g5IFvHV5paFXDy0Tme6Ycjj5vHpiE9xR2zn0FTVYAFdUROx5wfX9qhG2BV8IimCs/jmoZTYroaYjhLbRL/PhQTa+dgCG5z0ZwipD9M/T916J1tZA2U+rli4MZkfUzeCkx32SiIVfqnsQqPq9kvGAOEW1CIObGmWvWzR4C9nvqX17Rzc4KwLxcHt0sRZHBePnB04nTk1GCyYvVUuPihd/GhvBBplMburFzktoRM0Q/s6G4kkA/r0ybcmemn5cGSbb3qLmyflLfB/zldz2/oXleqOyR39Xmp/bTs5zAhJlpYTgKywTTo9VEzj6VPwsk9nW5FUEHRx8VrOPNSg1/TYYFB0h4Y4+MTqbTamW7zZBJVsFcIwNgUD2kG03xvvsgSeo/dWoJV+93PRPb85M7EjRDmesywBPWFnNxv61Z7zZl7qVmhE0
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
index 9ee9f8dc6805..52ef4c3705bd 100644
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



