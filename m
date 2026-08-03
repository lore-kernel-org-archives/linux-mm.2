Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5539C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 459916B0098; Mon,  3 Aug 2026 15:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431EC6B0099; Mon,  3 Aug 2026 15:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 346EF6B009B; Mon,  3 Aug 2026 15:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D64496B0098
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:47:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6BCDAA2246
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:26 +0000 (UTC)
X-FDA: 85060992492.02.8AE9313
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6F57A40008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kjJMqvJc;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785786444;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9mmLPuUI7C4Ojqp+PJOgupIVvqC3+ZyYjDYQkUfM5s=;
	b=r/s5/Q619PkNP+sMqMiFRbqz2wo2gCxtZIyK1/cGcWCeEfUd7vD6CijzG7c5EVFZePxMLz
	daPBTgdhlvtEPRZzGzjpsNxDr70FzM+uOZ0PZ7Qk6NHJf+jIOeAOwL9myekrt7xHGc7X9H
	7BuecRWGpBAPINmCRXroMeUqqNj1qno=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785786444;
	b=Mtn9s8ZTMNIpLre3nwX6JpAq3/XtKo6tax0A/ylY0/GI+1dhwaGFiqcSraClAAEtxSLNZ5
	tv2rVgVdqBJ0nYgjU7qXa1Sr46Cw2H4q57yapW6x9SAxZBY0dGAy8su5BR0lUyuFb1naSd
	XreWALSNxVm6AyUereKj5JAAY/RAZcE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kjJMqvJc;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E10EC43F65;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E6A4C4AF1B;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786442;
	bh=7oMjq8JOU3eHb6zNoW7+5UIf8RcJuFNkmV1SUXaIj68=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kjJMqvJcoxW6UFujRhq8Ekv2nNzw0LvezVEjFKCRIKjsCT+5GXzs7u6gy1yiHWEP3
	 SkrKom0mDiWfg+AjcTMAAa0OWGbVcSwpCjs1qTfCY3Qk2iymoPrRnzznVK2TtjpBjU
	 wF6uIqiCkPWTGdBPDFL7xUF1nqQ3qW1xawfTG1/Yvb55+xZRRvv0B+Ecl4d3lnf6oa
	 3tesC7OUTMVURDnDNcFE8N2+WJNvw3naNwI64uu2B1ZM0GhTRNhS5/Xu8N8rYyH1dw
	 zZ37M6qeq8ihBeiDpF0iGa+BQMx2ykFPljHIqpW9IDGWZ1L+AoFB5GItcGaRoK2waI
	 7srdIPifotxzQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79284C55182;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:47:01 +0800
Subject: [PATCH RFC 05/15] mm/mglru: move max_seq read into
 walk_update_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-5-4d8dad39dad6@tencent.com>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=4925;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=wSChZul1NmIryDYTKVLvOQpbv0SaiqhBZY/xmEybbCE=;
 b=1D47c3BXTihaaxXk5hhFvD/DLD/AcvdEQ6h35D1WEGFowZbRbvMRS5rfkKZOmT8jVlgf7xrkl
 UmLoLumuOA5DlyahcOpO0Xo67vojMx6kuNn57rXr4wHXutlCf/PRsKM
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6F57A40008
X-Stat-Signature: ectymjp8sqcioyqf9jg7uuz6wk4m6pra
X-Rspam-User: 
X-HE-Tag: 1785786444-568283
X-HE-Meta: U2FsdGVkX1/LFF67vnK3d8C/ZWO8aTzrsO6JL3/LMQOuZ0UMQXvpaB9FWa/paaUlAv0ekiYqxic9c74VS+Ubc6t3IofivWag850NCmHk7AZhwLGQoakDa5noVDaQYVCU/0R2DNNhJbBX1OssUh9l4RkwzigohIRW/cD1QjWiPDmAhff8ZmVThDu/Wo388iaEVxdEOruBWxSQFf7OT3PG9SdIc0b8dWtCPRtVcnxwFcTUOv5ZFuJqN5kvWsoHr2nHMHQ3MR3YFkYUUGon2LTP74j9Xj8Qx2WQjIowmOaczEEUcrWd3p6VURmNS3d5uYIY4QQlIMqmvsNOI/ZpREOcZXEF84KJt+O2whB3QRng3Gyy7cekIbm5wlBEN9YTPbUToqyOmTrMo7Qw7kQtMVRQv0k6bO9pr0Ehj1Nshm36B6EBEgHxWZXtQA4lZmI5XGGw1XJJ8kLaFtWXYhwZJzWw20eba7dJK6hlOjk7lEDJ5ld6e1uJqbW2KwcCA5OjPeD6nXmV6AykMCJMfLjMOzpQJIOentBNomiaYNpnAIbgZbxkWRv83dVHjxyYZxbr92Bid1bh6ZqAXs17bcPX7YNmrsFxKZGRUkYBfhYiGeq6/ds76oUzgI2lx97E4u3mO9Mq6bQpP8r/6qHsovrxPjZe91Luxu317zJYjqIRTTBFGNs5hAF9IHkpZ3bQp5xsCQlfXV/V+fqB1CCPWxGj6YWGLz3140JQID5mt4u5G2lP8sWwAfXPSR4CXFYmTWWhXAOO0kwFJ+zgeYmUAwW4ymbsJBmulQcm9kNPzAizUPfMuU5v8mW8SGomrwiSnPyYJegHCCMRoWcYaa7IymLQP/x7e4AkRedknfp88pj82lioAzBDQADSMZ+NP+13gejNyewyB69d0KPEEM2TRaD/gjoeuw3TpqQPt4n9kfjbKich1x5wVHO99tuwtvx5zdpr8SBUoXMmWC4An2hxR+tr60b
 YJMrrLDg
 bgx51IKBcWKb6PQCCm54HS2pRbMcEj0KmEthe1rzVFl3IiPJ7vY4nuRF7Iayt2uH8QB6xzyB5MWeYLXrqJ1yCWwYG1sGZ/PrNDJYx7WYkvjv/1O7i0s/aI7Y8QiCF+8A1o5rFvqt52emWoGe4KM6v73h1u1K66VxgzUbcAOmFphx72EidiYe6pQNh4O5q8IqjfqYZqnvPoI4aauADw49EOHJind/fQFOQAbiOyUR85UCb7NQciM/RFFgbKVynU34UglKjzmrom50x/C5yPO4pVUFFJOBXY8QVm3zctvkoheaLy88mBXiIWnCvTRdwDChYGT0qlPcYK43wkPX5o5h1s8obHp8Efpi0Zr0KPCK+ecoAQ17rJJhq8yV62wqI9Z9JlafLaAiuMP0Osq8s1IsHil/S6iMVbOtO3ZJKWwMJriRfSCYijk7wJ6njUpcD3CbnqxAVehlD+N7Y/Rg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

walk_pte_range(), walk_pmd_range_locked(), and lru_gen_look_around()
each read lrugen->max_seq to compute the target generation for
folio_update_gen(), then pass it as a parameter to
walk_update_folio().  Move the read into walk_update_folio() itself
so the callers no longer need to compute or pass the value.

This is a pure refactoring: no functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b02d2ec8ff4b..c2ea92c2b69e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3511,13 +3511,15 @@ static bool suitable_to_scan(int total, int young)
 }
 
 static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
-		struct folio *folio, int new_gen, bool dirty)
+			      struct lruvec *lruvec, struct folio *folio, bool dirty)
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
@@ -3548,8 +3550,6 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
-	DEFINE_MAX_SEQ(walk->lruvec);
-	int gen = lru_gen_from_seq(max_seq);
 	unsigned int nr;
 	pmd_t pmdval;
 
@@ -3600,7 +3600,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, args->vma, last, gen, dirty);
+			walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3613,7 +3613,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		walk->mm_stats[MM_LEAF_YOUNG] += nr;
 	}
 
-	walk_update_folio(walk, args->vma, last, gen, dirty);
+	walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
 	last = NULL;
 
 	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
@@ -3636,8 +3636,6 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
-	DEFINE_MAX_SEQ(walk->lruvec);
-	int gen = lru_gen_from_seq(max_seq);
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -3691,7 +3689,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			goto next;
 
 		if (last != folio) {
-			walk_update_folio(walk, vma, last, gen, dirty);
+			walk_update_folio(walk, vma, walk->lruvec, last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3705,7 +3703,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
 
-	walk_update_folio(walk, vma, last, gen, dirty);
+	walk_update_folio(walk, vma, walk->lruvec, last, dirty);
 
 	lazy_mmu_mode_disable();
 	spin_unlock(ptl);
@@ -4270,8 +4268,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	struct pglist_data *pgdat = folio_pgdat(folio);
 	struct lruvec *lruvec;
 	struct lru_gen_mm_state *mm_state;
-	unsigned long max_seq;
-	int gen;
 
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
@@ -4308,8 +4304,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 
 	memcg = get_mem_cgroup_from_folio(folio);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
-	gen = lru_gen_from_seq(max_seq);
 	mm_state = get_mm_state(lruvec);
 
 	lazy_mmu_mode_enable();
@@ -4341,7 +4335,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, vma, last, gen, dirty);
+			walk_update_folio(walk, vma, lruvec, last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -4353,13 +4347,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
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



