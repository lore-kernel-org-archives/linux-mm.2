Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7987FD5323
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 09:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3792C6B00A9; Fri, 27 Feb 2026 04:45:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32C2A6B00A6; Fri, 27 Feb 2026 04:45:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225F16B00AA; Fri, 27 Feb 2026 04:45:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DCCFF6B00A6
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:45:07 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A01821405B1
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:45:07 +0000 (UTC)
X-FDA: 84489753054.21.7246122
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9763D100002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:45:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CjNRavcI;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772185505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqA2PZyQDXj1Bd/fcvaoW0kfwGHOGzOHK70Gr5h6lbo=;
	b=N0NynMp02cJd9Hj7nkyB/3UDPauJKdOCI0UD6HrNQIX4GyMMnwzDM7TqQU5mGv2NB8kV8k
	zigdBPIDo1T6aCs95Xsihi0Ihx9Sp2bYFsAz2J1Uf/Zjw0t523o8dBj+g7W21nSF0bgcnV
	gcdTH5S/3TchjLM7jDv0y99iRLSVm+o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=CjNRavcI;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772185505; a=rsa-sha256;
	cv=none;
	b=3VeqwlUdu8hthEEiT6JWiZUxb7eQqM4FXvvvd8SO6Ve257S5bzvNLqDBgtCBUdPHeoRplE
	+RV4rBHUr75PZEVrDjcVsALTYABKUMjxu/X/ozhzD1/JpTwvo1cHgTi8uXiXr+yOVQW52x
	iB06ulZGSGmy5pdPwwI1+hOVHCTIQx8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772185499; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=eqA2PZyQDXj1Bd/fcvaoW0kfwGHOGzOHK70Gr5h6lbo=;
	b=CjNRavcI5MuRNss3kVb/PYnaBMH/13KDme1rv1cJH5KubXDqlsN4p8bGHW4rwRb8kPnxZWCGSj8+F5eC65dIbpZsvLd4p9Lkskf3dwDIWI3tCl0HtKC0yGJXRnA7nbSKR0YepdNXoYUHqV9YTaevAaM+4M6sci2lM2X0VXxKlUE=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WztzmPK_1772185497 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Feb 2026 17:44:58 +0800
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
Subject: [PATCH v2 5/6] mm: support batched checking of the young flag for MGLRU
Date: Fri, 27 Feb 2026 17:44:39 +0800
Message-ID: <f84233f95f209d59c3bc9c72a757af09337f0d40.1772185080.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
References: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9763D100002
X-Stat-Signature: j4texcohtmh5akyf39gi8uc4koea4hss
X-Rspam-User: 
X-HE-Tag: 1772185503-199868
X-HE-Meta: U2FsdGVkX1+8tvZrCU9DZLRtzdWm6TmeBH7RwTGmUh9ldyvBv1FvOq97H2UhyHjn1mgZHAJbJmMbLc+v4zuNbNjKeKshgJaRXmietNwzgDryUPYKweccnsyRhs8gE/5xehGiq4JsgKJisSdoS+Q+1Sz4G26A3jsKgaTPrLT72PG5A0SzhO7MMOvo9YCCDlZkaJk9oz5z1kPDqAgL3F5D9DIbtSxVG64ViVg8HqQsy2clW4PPP0VXiKJXX+lxJ5uExfyh+q8YRGkapoAkAGIEGm6BlLTXCHg6ag7D3R/Dfo/lm+7ZoEl5p1fR3rBg0XNVd+sIpbGnKqX0IjPvR6VfwIwlM1Pkh1HaZYjnCWBTDh2qWgNXqQsg8wGBCzFX2NtjNNe81xNFGd5v8NmixizAKNGxMccVEfygOUGBPgV/5xVaDdCaGtFPDSUo6AjqcSSZUgZUFoVtI7JhGL+zuPjSG9I2LK+68Q8tud/Ggw0bNyABdAKtK35HquONlrPtyDxsaW1npcAmi3AemNeRphqlYdDSm3WOKi5DwKSpdsR4I3B3WEMt/B1eMe8hqOAEnEQ4rAA/XZtSW8w4IqIj9sYTDx0BYXWQjZyej82DrRNQSdYLibfiJDWWxr9Hi0HPpnUZCaZJwin87i6BS6HIxCvLJjEMqgSXqOcaK+d2IoDyAXheapY7cOSkXsQGTHvc9vfPTUgBTL1Om7omvn2YILsZEsyp/nf64tUhBN+QtcsglE+PWZ250dRLN7r4N6R86EDoedNXOgzpqhUczn+zxMssNsD3pXpaRyNNrHlfZ+DjbVkhVzXB6QenWXtDHOO3iEs3+CIplC6QNxs2BLJs1C7PmB4JguwXEW7Ir2gUozZK3vOfCBmmA97mL0CO5PP8LqyS4Dfn5loPaesdjk42iAyrZd0Wl2nMFpvF6N7GC5LT3FrlMRfGidgNY+jCkefq/fpQwwaYKC/3dKqo/Ph5JEo
 n1I0vv3J
 kXXB7BtpPEhU1fFfCuS9DcbYKPL9/R8lj4vqugytduVgIfYsJ0xA0OmSQWGNdsNO1e5K3quxnLZjS1EjJyovqaLWk6jXqSqLJ/ylkXESKMeAFrcBfqpE36SH4lflCR8P3FNd+CKGJS5Jeh/Vkvrk62bKtqAhwmWbAKXist3aA2wc28hHRtWUgyZSWZxd8Z4LPMwblY1qS/8SfiESpx8UodDZgUo6kvaTcgNYfhzGrWaxSPXR7bTGOFCgrJ3BUgIj+Mfo2BHjk5a+jLicTnnP5c7AticgIqUUQMtqKBdiJhqVHzYkPanc6fiY1SA==
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

Note that we also update the 'young' counter and 'mm_stats[MM_LEAF_YOUNG]' counter
with the batched count in the lru_gen_look_around() and walk_pte_range(). However,
the batched operations may inflate these two counters, because in a large folio not
all PTEs may have been accessed. (Additionally, tracking how many PTEs have been
accessed within a large folio is not very meaningful, since the mm core actually
tracks access/dirty on a per-folio basis, not per page). The impact analysis is as
follows:

1. The 'mm_stats[MM_LEAF_YOUNG]' counter has no functional impact and is mainly for
debugging.

2. The 'young' counter is used to decide whether to place the current PMD entry into the
bloom filters by suitable_to_scan() (so that next time we can check whether it has been
accessed again), which may set the hash bit in the bloom filters for a PMD entry that
hasn’t seen much access. However, bloom filters inherently allow some error, so this
effect appears negligible.

Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/mmzone.h |  5 +++--
 mm/internal.h          |  6 ------
 mm/rmap.c              | 28 +++++++++++++--------------
 mm/vmscan.c            | 44 +++++++++++++++++++++++++++++++-----------
 4 files changed, 50 insertions(+), 33 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3e2f9c953ad4..66ad80b83baa 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -630,7 +630,7 @@ struct lru_gen_memcg {
 
 void lru_gen_init_pgdat(struct pglist_data *pgdat);
 void lru_gen_init_lruvec(struct lruvec *lruvec);
-bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw);
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr);
 
 void lru_gen_init_memcg(struct mem_cgroup *memcg);
 void lru_gen_exit_memcg(struct mem_cgroup *memcg);
@@ -652,7 +652,8 @@ static inline void lru_gen_init_lruvec(struct lruvec *lruvec)
 {
 }
 
-static inline bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+static inline bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw,
+		unsigned int nr)
 {
 	return false;
 }
diff --git a/mm/internal.h b/mm/internal.h
index a5f0a264ad56..a1b3967afe41 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1843,10 +1843,4 @@ static inline int pmdp_test_and_clear_young_notify(struct vm_area_struct *vma,
 
 #endif /* CONFIG_MMU_NOTIFIER */
 
-static inline int ptep_test_and_clear_young_notify(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep)
-{
-	return test_and_clear_young_ptes_notify(vma, addr, ptep, 1);
-}
-
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/rmap.c b/mm/rmap.c
index 11cc6171344f..beb423f3e8ec 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -958,25 +958,21 @@ static bool folio_referenced_one(struct folio *folio,
 			return false;
 		}
 
+		if (pvmw.pte && folio_test_large(folio)) {
+			const unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
+			const unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
+			pte_t pteval = ptep_get(pvmw.pte);
+
+			nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
+			ptes += nr;
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
index 0a5622420987..7457b3c06fa3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3474,6 +3474,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int gen = lru_gen_from_seq(max_seq);
+	unsigned int nr;
 	pmd_t pmdval;
 
 	pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval, &ptl);
@@ -3492,11 +3493,13 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 
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
 
@@ -3508,7 +3511,16 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
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
@@ -3521,8 +3533,8 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (pte_dirty(ptent))
 			dirty = true;
 
-		young++;
-		walk->mm_stats[MM_LEAF_YOUNG]++;
+		young += nr;
+		walk->mm_stats[MM_LEAF_YOUNG] += nr;
 	}
 
 	walk_update_folio(walk, last, gen, dirty);
@@ -4166,7 +4178,7 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
  * the PTE table to the Bloom filter. This forms a feedback loop between the
  * eviction and the aging.
  */
-bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
+bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 {
 	int i;
 	bool dirty;
@@ -4184,12 +4196,13 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	struct lruvec *lruvec;
 	struct lru_gen_mm_state *mm_state;
 	unsigned long max_seq;
+	pte_t *cur_pte;
 	int gen;
 
 	lockdep_assert_held(pvmw->ptl);
 	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
 
-	if (!ptep_test_and_clear_young_notify(vma, addr, pte))
+	if (!test_and_clear_young_ptes_notify(vma, addr, pte, nr))
 		return false;
 
 	if (spin_is_contended(pvmw->ptl))
@@ -4229,10 +4242,12 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 
 	pte -= (addr - start) / PAGE_SIZE;
 
-	for (i = 0, addr = start; addr != end; i++, addr += PAGE_SIZE) {
+	for (i = 0, addr = start, cur_pte = pte; addr != end;
+	     i += nr, cur_pte += nr, addr += nr * PAGE_SIZE) {
 		unsigned long pfn;
-		pte_t ptent = ptep_get(pte + i);
+		pte_t ptent = ptep_get(cur_pte);
 
+		nr = 1;
 		pfn = get_pte_pfn(ptent, vma, addr, pgdat);
 		if (pfn == -1)
 			continue;
@@ -4241,7 +4256,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 		if (!folio)
 			continue;
 
-		if (!ptep_test_and_clear_young_notify(vma, addr, pte + i))
+		if (folio_test_large(folio)) {
+			const unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
+
+			nr = folio_pte_batch_flags(folio, NULL, cur_pte, &ptent,
+						   max_nr, FPB_MERGE_YOUNG_DIRTY);
+		}
+
+		if (!test_and_clear_young_ptes_notify(vma, addr, cur_pte, nr))
 			continue;
 
 		if (last != folio) {
@@ -4254,7 +4276,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 		if (pte_dirty(ptent))
 			dirty = true;
 
-		young++;
+		young += nr;
 	}
 
 	walk_update_folio(walk, last, gen, dirty);
-- 
2.47.3


