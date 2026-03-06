Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F1A7F51412
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 06:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 964B26B0095; Fri,  6 Mar 2026 01:44:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935B16B0096; Fri,  6 Mar 2026 01:44:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DCED6B0098; Fri,  6 Mar 2026 01:44:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5376B6B0095
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:44:15 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0BC3FB97A1
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:44:15 +0000 (UTC)
X-FDA: 84514698870.19.46E8D56
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3453F180008
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:44:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dTvZdXOX;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772779453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t4BjQGeH+bBO/rkeXAJzuycBDkicdFTW/HZEtAQ/wv8=;
	b=4NsnfQpCly+yYqRzUNkXuOUSc+0zVytz+L/Gz/8bT1PfarIowi5Z56rTsMahbmrRRa2Do4
	a0VBEoN9C6u+jEhjkfHnxI97wa2aQWFnqxVGOyF4/UQ9aFLmXvGb9SLdi3CTms0tYSAB+/
	DWl04pAudM76bPkQ0d9MmBhB0W/jRto=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dTvZdXOX;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772779453; a=rsa-sha256;
	cv=none;
	b=ivF6LfUz1Kn0fPYDjFpPkjXR4I9mNLOsq+YyY/9lgz91NIzCnVVHQFywEOxy+KvhuPmD6u
	HRqENorix3tvEffokpyD6asZmFcxlKms/QSQuvJ948QLLbsllqxwqe7Jolgt9zGkvjjh8E
	vTyCuFY1Zy/gsnOw+ha3s3A3WrYvctU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772779446; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=t4BjQGeH+bBO/rkeXAJzuycBDkicdFTW/HZEtAQ/wv8=;
	b=dTvZdXOXjjRAGOS/qqmZCFeOHvFBEdmFWGF6sUdr0mEgLdHLhznGiNapBSjiWI4gSJCu0d+XdH/BDh86Tq67vQ3y79udMlvSgtVGEIyQ7xV7XrEnD6H5eZsuXZHcglH6QluZhvEleQ7Re2hiQL/pCzuYUlIALwCfRrSCP0I8fVo=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-MLorm_1772779445 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Mar 2026 14:44:05 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/6] mm: support batched checking of the young flag for MGLRU
Date: Fri,  6 Mar 2026 14:43:41 +0800
Message-ID: <378f4acf7d07410aa7c2e4b49d56bb165918eb34.1772778858.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
References: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3453F180008
X-Stat-Signature: prxm9argec7ujy6iadqxcfic4b7iy9a3
X-Rspam-User: 
X-HE-Tag: 1772779451-902436
X-HE-Meta: U2FsdGVkX1+IBu0DEmXrR9E5zYOvnwSYrEQiUHuIZzp+S8TOL8BtQGYFrWNUTHI+yZtGOiWin5EFdXn/RVA1E8r0EK1oCIKxzVrlvt+P2P6W9d8z5bMU1W1F7rmpZfjh+T9j7J6xJ91vh5FWSUenCupyO4I+Amv/teFfaJt+22c9GVGjDsQIVugAySf4kD5sTeDdOr99+bI0+6sN3t/CiC4fFPZ7J3wDQLS6IDsSKgToCdFOt+72DSY0mLRzpb8VP26pTVnub6w218OiWMWLIT+t3wzjmdqaXG0QJ33l6gbN6+4KNGgye/tt8mkh1vp0Vh4jNDDjks0JhXQegjcbp+KwI8EQuff1xE/ujBqhkLWkS47MOB2hZKfrGJi+F0JAvvJBq9qDICjDZnpNI1t2OpI2AwwBi19BUQpmmpzkGZoqeN1xypmwWQxoNGZX5KFT5KTpJ7lr1WSRrsmtpXrrIa3HLwpIE161YpTLYELA0ee3+tQWpHEn2FuLjt1RT5HNxVyYYcXbfnDOCPlE3K6RpiiP3wwy2Uk7wnB+7kYdYa7huOBAPGZsF34ffXElnt054k0tSf02dJft70MAwGvU1BJ/SJREC2qH3WnuxrlV8oIbQw3OBFL7XhE4advTRHBAIyx5xZOt8c/eYG1qAGj7LZ4+YvB4zuo1Y1bWpFWFi7Ssem+CIEUqiel2AvqMRJXO1WSqi1MeIz7Q8iK3Ps8tnBPtHZQOmhhQxmYEsWFx5PKDIUODQQ8S9IMouQu4CwXWmlE9XKRc4Sz3TQBbnkjKmFa9nFEymKX7btFwwytPYtpEy+ijA5SOUCtWJOP0Oa324Ou2hxOGl37yQVxr/5RPJP+CqCSfCznHdYGP2S7+VIquKR9dg2vT9oDUZnGxmQHwANZ94p1JONLc+uB2zdjiMwR33ZI2ENRwf6kwUPNUBVM0q5dvbxk6RpiMRb0+bqHeFs10GaZxBUu40aa+PWF
 pKmzdpGS
 OAUUpnmYzKbT+xwoyCjvUP3X5qCeiKl5Jy6IE4tToAnkz+h/QFBvsftXf/GqZL8z1miQEUiTHkyrXLeD5HQ5i58tXycUlsDJJ+RtlhAQvnqDYrp3nJbXHoM+aJN9rtKWuqWxxnYHpGLp4r1oJTnzC1ZdfPuk7Kf1rktkEeGt97PCFiiTe8BXp68EIoqwg923EIgSFwGlDRYtyAX2GEozWOBd4yNewyKz+BiTtOU+ad3+ATE5gSfzHQExAXhie4GOsvX+Nco6f79MlIVul5qYNrG4S21IfyT5gE5Dr/yG7kJ+jKgIQLWu50eKflVhH4N0ZBIZjWNK4D+29UDJLm+FBN2cm+acHIxjMlWJ1JfhXHrCAEWPquNWDJuqjWHHw//OMAEmS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the batched helper test_and_clear_young_ptes_notify() to check and clear
the young flag to improve the performance during large folio reclamation when
MGLRU is enabled.

Meanwhile, we can also support batched checking the young and dirty flag
when MGLRU walks the mm's pagetable to update the folios' generation
counter. Since MGLRU also checks the PTE dirty bit, use folio_pte_batch_flags()
with FPB_MERGE_YOUNG_DIRTY set to detect batches of PTEs for a large folio.

Then we can remove the ptep_test_and_clear_young_notify() since it has
no users now.

Note that we also update the 'young' counter and 'mm_stats[MM_LEAF_YOUNG]'
counter with the batched count in the lru_gen_look_around() and walk_pte_range().
However, the batched operations may inflate these two counters, because in
a large folio not all PTEs may have been accessed. (Additionally, tracking
how many PTEs have been accessed within a large folio is not very meaningful,
since the mm core actually tracks access/dirty on a per-folio basis, not per
page). The impact analysis is as follows:

1. The 'mm_stats[MM_LEAF_YOUNG]' counter has no functional impact and is
mainly for debugging.

2. The 'young' counter is used to decide whether to place the current PMD
entry into the bloom filters by suitable_to_scan() (so that next time we
can check whether it has been accessed again), which may set the hash bit
in the bloom filters for a PMD entry that hasn’t seen much access. However,
bloom filters inherently allow some error, so this effect appears negligible.

Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/mmzone.h |  5 +++--
 mm/internal.h          |  6 ------
 mm/rmap.c              | 28 +++++++++++++--------------
 mm/vmscan.c            | 43 +++++++++++++++++++++++++++++++-----------
 4 files changed, 49 insertions(+), 33 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index b53b95abe287..7bd0134c241c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -684,7 +684,7 @@ struct lru_gen_memcg {
 
 void lru_gen_init_pgdat(struct pglist_data *pgdat);
 void lru_gen_init_lruvec(struct lruvec *lruvec);
-bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw);
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr);
 
 void lru_gen_init_memcg(struct mem_cgroup *memcg);
 void lru_gen_exit_memcg(struct mem_cgroup *memcg);
@@ -706,7 +706,8 @@ static inline void lru_gen_init_lruvec(struct lruvec *lruvec)
 {
 }
 
-static inline bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+static inline bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw,
+		unsigned int nr)
 {
 	return false;
 }
diff --git a/mm/internal.h b/mm/internal.h
index 8cdd5d8e43fb..95b583e7e4f7 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1848,10 +1848,4 @@ static inline int pmdp_test_and_clear_young_notify(struct vm_area_struct *vma,
 
 #endif /* CONFIG_MMU_NOTIFIER */
 
-static inline int ptep_test_and_clear_young_notify(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep)
-{
-	return test_and_clear_young_ptes_notify(vma, addr, ptep, 1);
-}
-
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/rmap.c b/mm/rmap.c
index 2d94b3ba52da..6398d7eef393 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -958,25 +958,20 @@ static bool folio_referenced_one(struct folio *folio,
 			return false;
 		}
 
+		if (pvmw.pte && folio_test_large(folio)) {
+			const unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
+			const unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
+			pte_t pteval = ptep_get(pvmw.pte);
+
+			nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
+		}
+
 		if (lru_gen_enabled() && pvmw.pte) {
-			if (lru_gen_look_around(&pvmw))
+			if (lru_gen_look_around(&pvmw, nr))
 				referenced++;
 		} else if (pvmw.pte) {
-			if (folio_test_large(folio)) {
-				unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
-				unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
-				pte_t pteval = ptep_get(pvmw.pte);
-
-				nr = folio_pte_batch(folio, pvmw.pte,
-						     pteval, max_nr);
-			}
-
-			ptes += nr;
 			if (clear_flush_young_ptes_notify(vma, address, pvmw.pte, nr))
 				referenced++;
-			/* Skip the batched PTEs */
-			pvmw.pte += nr - 1;
-			pvmw.address += (nr - 1) * PAGE_SIZE;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
 						pvmw.pmd))
@@ -986,6 +981,7 @@ static bool folio_referenced_one(struct folio *folio,
 			WARN_ON_ONCE(1);
 		}
 
+		ptes += nr;
 		pra->mapcount -= nr;
 		/*
 		 * If we are sure that we batched the entire folio,
@@ -995,6 +991,10 @@ static bool folio_referenced_one(struct folio *folio,
 			page_vma_mapped_walk_done(&pvmw);
 			break;
 		}
+
+		/* Skip the batched PTEs */
+		pvmw.pte += nr - 1;
+		pvmw.address += (nr - 1) * PAGE_SIZE;
 	}
 
 	if (referenced)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e3425b4db755..33287ba4a500 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3470,6 +3470,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int gen = lru_gen_from_seq(max_seq);
+	unsigned int nr;
 	pmd_t pmdval;
 
 	pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval, &ptl);
@@ -3488,11 +3489,13 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 
 	lazy_mmu_mode_enable();
 restart:
-	for (i = pte_index(start), addr = start; addr != end; i++, addr += PAGE_SIZE) {
+	for (i = pte_index(start), addr = start; addr != end; i += nr, addr += nr * PAGE_SIZE) {
 		unsigned long pfn;
 		struct folio *folio;
-		pte_t ptent = ptep_get(pte + i);
+		pte_t *cur_pte = pte + i;
+		pte_t ptent = ptep_get(cur_pte);
 
+		nr = 1;
 		total++;
 		walk->mm_stats[MM_LEAF_TOTAL]++;
 
@@ -3504,7 +3507,16 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (!folio)
 			continue;
 
-		if (!ptep_test_and_clear_young_notify(args->vma, addr, pte + i))
+		if (folio_test_large(folio)) {
+			const unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
+
+			nr = folio_pte_batch_flags(folio, NULL, cur_pte, &ptent,
+						   max_nr, FPB_MERGE_YOUNG_DIRTY);
+			total += nr - 1;
+			walk->mm_stats[MM_LEAF_TOTAL] += nr - 1;
+		}
+
+		if (!test_and_clear_young_ptes_notify(args->vma, addr, cur_pte, nr))
 			continue;
 
 		if (last != folio) {
@@ -3517,8 +3529,8 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (pte_dirty(ptent))
 			dirty = true;
 
-		young++;
-		walk->mm_stats[MM_LEAF_YOUNG]++;
+		young += nr;
+		walk->mm_stats[MM_LEAF_YOUNG] += nr;
 	}
 
 	walk_update_folio(walk, last, gen, dirty);
@@ -4162,7 +4174,7 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
  * the PTE table to the Bloom filter. This forms a feedback loop between the
  * eviction and the aging.
  */
-bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 {
 	int i;
 	bool dirty;
@@ -4185,7 +4197,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
 
-	if (!ptep_test_and_clear_young_notify(vma, addr, pte))
+	if (!test_and_clear_young_ptes_notify(vma, addr, pte, nr))
 		return false;
 
 	if (spin_is_contended(pvmw->ptl))
@@ -4225,10 +4237,12 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 
 	pte -= (addr - start) / PAGE_SIZE;
 
-	for (i = 0, addr = start; addr != end; i++, addr += PAGE_SIZE) {
+	for (i = 0, addr = start; addr != end;
+	     i += nr, pte += nr, addr += nr * PAGE_SIZE) {
 		unsigned long pfn;
-		pte_t ptent = ptep_get(pte + i);
+		pte_t ptent = ptep_get(pte);
 
+		nr = 1;
 		pfn = get_pte_pfn(ptent, vma, addr, pgdat);
 		if (pfn == -1)
 			continue;
@@ -4237,7 +4251,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 		if (!folio)
 			continue;
 
-		if (!ptep_test_and_clear_young_notify(vma, addr, pte + i))
+		if (folio_test_large(folio)) {
+			const unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
+
+			nr = folio_pte_batch_flags(folio, NULL, pte, &ptent,
+						   max_nr, FPB_MERGE_YOUNG_DIRTY);
+		}
+
+		if (!test_and_clear_young_ptes_notify(vma, addr, pte, nr))
 			continue;
 
 		if (last != folio) {
@@ -4250,7 +4271,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 		if (pte_dirty(ptent))
 			dirty = true;
 
-		young++;
+		young += nr;
 	}
 
 	walk_update_folio(walk, last, gen, dirty);
-- 
2.47.3


