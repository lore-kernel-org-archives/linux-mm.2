Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DD2EC624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 16:51:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B962F6B0092; Sat,  5 Sep 2026 12:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A83296B0095; Sat,  5 Sep 2026 12:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 970C76B0096; Sat,  5 Sep 2026 12:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5B06B0092
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:51:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA76E80373
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:51:17 +0000 (UTC)
X-FDA: 85180298994.17.E7168D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E973C80007
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:51:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VVKqXMkX;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788627076;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irymCLRZn9ka9ELh8daLQGSPOrv68eo8Zt+b0t82khU=;
	b=Tng11IRV1/oOmt3S+Pzj+s38wXBfeEPL8Rvlsy28HJkWpO9bsrtStCOn097grLGMTbPpJ3
	5GPboOiysxWdSlzlQ+mMgEF4AIdtDcgN1rGYHJm+Unz0FHrM4X4bvrWBFpIlZXbbAlLb1K
	nH6nUk4seloL248UUhVToqMaZtsLrFo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788627076;
	b=SMo1eAPLbtqTk1Z51QM5XZ4jdlG6dv+iLRRGgQbJi9AgLGlAX2H1jgwzQnm46LPImF6If5
	b6/KGaXZT7yn2fXXBdoH3K19Zmwj826WRCC4+h18k0Gdv4ni8fzBaGTejSB49sKupQSOME
	s4bS0BczbUvKQu3sHFgDwP5S+RdCspc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VVKqXMkX;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B159C40C02;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92C64C2BD05;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788627074;
	bh=EPzuBA931Y6/FnIHPry9EGa0oulHXq0SrPoNQBB15v0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VVKqXMkXq94TTfYWmH9jsOerOfHHbJX1EXWEeUrjeSRLFjoPaKD1Y9TCzXgXFyse1
	 pUHLQqil2SJTNYATnpr98eEsMzSQsnBAj8U0GhZV4abE2iwF1130RRkx9XZdgln3BK
	 WARX24KakvrEuKAbnsoFGBU6qvu0VbLlKoePWOwMUfrvaIzmchiW4gLTlbGNP3/Brr
	 /ArrcPoJ2qKt34UJ7Ga2hnexgdEZXFSEJFuAUj/NBpOu0kY/m5UTwctCC4Rk8zLBHs
	 qzE8EHEGJaiQ8oh2/fona71XebztvNUd2lScvvsb4cluYvU+JyVEfDp011u5xbTLiF
	 2/Sh/amgurvaQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E01DC624DB;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 06 Sep 2026 00:51:09 +0800
Subject: [PATCH v6 4/6] mm/mglru: move max_seq read into walk_update_folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-mglru-flags-cleanup-v6-4-9aacbd77d4ca@tencent.com>
References: <20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com>
In-Reply-To: <20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788627072; l=5248;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=vJk1+2fKKQxY9G+ipaJbC4frVmgCpPnI7hOyWY1PWNc=;
 b=pWhOB97/CgRrYZjvhcGWckb6Al/QJNTMzoN2UDbxxYuqiqo4o2Es91hMQNweSjKefXdoJv0Wo
 HMIYnc5R8mhACusxxRJVGZpqTrxl4vgk4Fjz47Kvs9YnvKUuwkWA5es
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: pdejs4nhajwscwswuad8a9qozoeqene1
X-Rspamd-Queue-Id: E973C80007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788627075-852843
X-HE-Meta: U2FsdGVkX1/LKVpkZ9gb0aeFQimoxOICyXZI8DbKkCPWGlskMRBvTZhwTWpey3Lb+fdA6hOyrrD9cZRpmfySLP0ZgqKYq4JJWllAfEV8fg43qga1gXfHY0B4bsfZpD0uJTyQXUTs9abmJCpgWy96jSHv6XRgQhE56PKOlVJ2tZ8GwDzLueVavQPtIAAhdHS7n438bYd+W3mSw7udnHRDsHxlu4NEWLK2KpHsk88ynat6tBYPv6Y3qNobXeTL5BY5x2Zf2m7nPdDwLJkQkTj+gBDj4wjHKGLj8I61YtC4KpMgtA/xCa1z+ZheS/pnPFnhvlLAKAT6BHs01AG+qKGI82m4STXBkxxuSs23xB/OW3+/LZrYj/RuVI/ignFO/1xHHiyTRQK9IYvflQ06q4nDqlBrx/1qEnoVaP6wNNT25V9qKwXooEbNEy9BOGr8DIEt/rdgKUV4+TO4JCr05xWSwAUNgD2Dl+ozSIbXWimdzUXUE7tZbaWJCZfnBkB420vYRtcNP5snfwzfnQBIqjbi88Xh1rH5V6dJgmOvgq3HnkYmjjxfvEG3LDXCE4f2pQ5PfnU2SRESfhkmQOtkQ0jvyu7YypsrEVjkpqcltvdxv2/K47mVSbVDp3e+geKid7boIgH7cpFwEUrJHZCA6Jj6QrFmYDqum7WBBlIPIuWxIacG8j36AimjQhTaxag/PRHnJVqQa295m2G1fC5RfHHqzzU9GYM4Yi7DdugcEuY43i0rBgRQdfMVXzODN7MxHJMF4jKRQ0ePtImX7qSagHVRWU1UWEYY+WS0IbNxr6vuD28j1I78SIu5XMiEXQ3enxpBFM2b7JGLXJ4xRTVTmMu/jRhue7yPdDeb3sjU4zfZyImU51kt0TBO7nY9dFh5nILlMkUc9rjEBA4Xd2U3BktQ14AZMSJudN0N0kyvxmvwczdjKH/3AklgYGLPfRzzvetCai+B0TwgHtZO8KNoO5M
 tZIcOzoU
 Ii28QaD7PaZ7vrMhpsjX5ZdJ0MBcuBY/2Pm6O8OYeX07fTxZe7uKsaQJavBXslT2eFZUzCtDwrdrpWVP0Cx+Q8v6wYzGDOdraFBrvXt7qy3G0NyDkKVK6y1RC2/9WLr/3OFPpQd6tEJuWYszNmNNwTvZ+omouuZuO6uikuCjPkNPDij+XDKqIvTTck4E8hUcZglCJ5twKQ2BoYuc157Jo105ey/ACJnT2Uf5DPmoWXogB4OHGVjBA4fPz0b1bIg48iguJnwFxG5K0TN87LTMJFne18ZnHIAQT1K7NywoQD+t1pH63k6+/Jl4Ral0acsX7zf1C3I3SgNNAFiuubXmK52EprvGxy1Z3auagg2Zp94cA5E0oDGVXjjrCdnP4bMTx+czbCC9ByKGJnouAcQ291nK/BiEV1rA3ausjsBbMW8T2hm5dNt2AWYt0cWJT41KFhcIW+fD8iCHxmSahCEZQeLUw/jF3IcQDUZ7tfn5THLZ99zY7AcGtShXJS5m6bvTuFKf4NX2u2q++lPp/TGLaOmjpm2MLdlg4j6d9aOQlihcAuJ3Y4kwpvjiukQ==
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
index c6e03a5047ae..4732b987aa67 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3557,13 +3557,15 @@ static bool suitable_to_scan(int total, int young)
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
@@ -3594,8 +3596,6 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
-	DEFINE_MAX_SEQ(walk->lruvec);
-	int gen = lru_gen_from_seq(max_seq);
 	unsigned int nr;
 	pmd_t pmdval;
 
@@ -3646,7 +3646,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, args->vma, last, gen, dirty);
+			walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3659,7 +3659,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		walk->mm_stats[MM_LEAF_YOUNG] += nr;
 	}
 
-	walk_update_folio(walk, args->vma, last, gen, dirty);
+	walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
 	last = NULL;
 
 	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
@@ -3682,8 +3682,6 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
-	DEFINE_MAX_SEQ(walk->lruvec);
-	int gen = lru_gen_from_seq(max_seq);
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -3737,7 +3735,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			goto next;
 
 		if (last != folio) {
-			walk_update_folio(walk, vma, last, gen, dirty);
+			walk_update_folio(walk, vma, walk->lruvec, last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -3751,7 +3749,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
 
-	walk_update_folio(walk, vma, last, gen, dirty);
+	walk_update_folio(walk, vma, walk->lruvec, last, dirty);
 
 	lazy_mmu_mode_disable();
 	spin_unlock(ptl);
@@ -4357,8 +4355,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	struct pglist_data *pgdat = folio_pgdat(folio);
 	struct lruvec *lruvec;
 	struct lru_gen_mm_state *mm_state;
-	unsigned long max_seq;
-	int gen;
 
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
@@ -4395,8 +4391,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 
 	memcg = get_mem_cgroup_from_folio(folio);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
-	gen = lru_gen_from_seq(max_seq);
 	mm_state = get_mm_state(lruvec);
 
 	lazy_mmu_mode_enable();
@@ -4428,7 +4422,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 			continue;
 
 		if (last != folio) {
-			walk_update_folio(walk, vma, last, gen, dirty);
+			walk_update_folio(walk, vma, lruvec, last, dirty);
 
 			last = folio;
 			dirty = false;
@@ -4440,13 +4434,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
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



