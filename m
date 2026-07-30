Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC3BAC54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA43F6B00A6; Thu, 30 Jul 2026 05:46:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2DE86B00A9; Thu, 30 Jul 2026 05:46:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5AB6B00AA; Thu, 30 Jul 2026 05:46:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 613586B00A6
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:46:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 479B01A0931
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:46:29 +0000 (UTC)
X-FDA: 85044962898.05.4B51365
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6993240002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:46:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="PV0/xIZe";
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785404787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b/l4I0pYkeRPL3kl+xGLLpLm+lJTS0R+iS1Dai7imbw=;
	b=TSxfOAMaEPkD+hVaMhCBAIN4uJQUudSQZjJPxhGxZxD4rTurx/IDhmTbglt+1nVoWSKALP
	smXMnHdLUjXAct2UlUd+RJ4mnnJME9tuGaDtdWWR/BVKXNLpi1fJs6K7BtXrp7N58fGENI
	2nUG1SYftqo5+tkk2QMwChSYRoeIa28=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785404787;
	b=PiPgZxkhlRXDzoKTH+ULAyJFxduvnlP+5YXTTplYbWOD4009NsW+VtC4M7XIW8bS02l+zy
	rDy0WztGzXvh4c6A0MRC8FxJaFWdhBKerJsLuej5Xm8g0bpown+v8JtZwAr3Sn91M/p4W5
	jWitTT3P2q4kcHQlfvOxS3VVZ9crnqw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="PV0/xIZe";
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F3D71BCA;
	Thu, 30 Jul 2026 02:46:22 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 204633F763;
	Thu, 30 Jul 2026 02:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785404786; bh=Kn+FhkBpLjYwNT+gR7w25CVL4nAkEb1VdK01694Vrvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PV0/xIZe5mYSMeo8GS+cScUdZynhWX/yHGpVxJxnxIVEhntwV97IaxTJsYmT0bLzS
	 aUQIpo5lTfcluPoSZmGFseQdG2p1YTgeBD2Ez6Rw52Qi33nYksNIdMk+vyru768lg9
	 XvkQ6ejQXgzn+ywIRcE5UopV5z1bT7AoajFUoTJk=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v4 2/5] mm/rmap: Add try_to_unmap_poisoned_hugetlb_one
Date: Thu, 30 Jul 2026 09:45:53 +0000
Message-ID: <20260730094559.418003-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260730094559.418003-1-dev.jain@arm.com>
References: <20260730094559.418003-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6993240002
X-Stat-Signature: h7ykbi9bdw5hsquifnaswfz1t6mwoozb
X-Rspam-User: 
X-HE-Tag: 1785404787-573155
X-HE-Meta: U2FsdGVkX18988G0UYHz+YPOmArUSjJsQU9T+2uefxF0JvkrPp/BQzbbI/yymvYF1iBTh/7os4uEoVvBCB2t3/0MQf5kGaZYTE7XCrIXIXEbMOdSwmRt/oKQdMVuP3JbMt3uRrczvEiDfKhEqgNUy0T8ht/ipPWTmKotgYFTq67P9Yj3adeUIAp0xFYl6bfItTKmOkF+Em6CA0mRi+ZDnjAawu53Owp4+c1kgSL+DXdVdrZaam+ertXo25RQUIK9slWKtQswsngvXoINiJeBRrdyWu8Y7ZUWsthYUrNZxJrRKySvoKmZ3x51JVham4S59sRj+scLx2wsHquhG4ybvWZHX78pPQf4efxcz0B1hfIbTphdJQsjU13gSAMqecEPtOjQBLsvE3mtjhjL5esex/cYQ6OEoaLxIeOF+VceLezy/F6s34/PFQduoiNvIbO1ZAd1uiIRFDmEtKZcQ4nmXrVb22zVldrPq1w/3qUEUYHekLkdC3o7zijkmVNc6KCppXtQizxrOYD7RwsaG3ND7VJYO4ne1wBcNHoj7QVKlaESUHfRllNKqoeedff6Paogo17WJ28TFUDweNBx5cii2nTMZS0+btWCj4KrzlwhzugpCAG8njFrnb7yqCapP57LJW+w2/8QFinOTTve189yjs21Mc9wSLpZdkasYo/e+t3yURyedVPXjfvrGIHCiHqUvv1coL+FF+MzD8v4YCdkohpFjIx3xKCWKZx20WgcTyyjgsMilhP8zVVq4WuBtpMiNkmKYx4qMdE6PjhhEhK4uGip/HnRTeZ+oMjjKsI+eUCtxWcfZQXPmwFGbnFioyR5u4Qhv3r/G9UKAeQKp99JD2QRNi81yWwVl9w9qD/ySjWcVg5+eUOuFFhXSpBL5brX/RIWWAcUedTl0wUBu3BSJ3GZUfgT/coE3c9N0pVi0u2MwVNWCnrhVGo1Qlo1JF00KeyUZ7Po5Ds6kBWXie9
 FqFYcqbb
 lx5gM+oxSwjOp6Ho7ErebACNbCkYe+xOH7W0Q8Uy6MwlWvwLSRAYEEynmEidL/A1lTdcuJ2EnHLAGROfNHx6Mp7vSEso9jgrzS+x3keL71w8lyk4aIhRRngnudfG5/9HLVeoCRX5CwbLw4DdEJohlYdGDDuthlBnKzGP2PiXcG/XApjUocR/k9d491+XJubGxdWRwb4oUZ/23eAZme8yaKH31WTscRKTQ6twEVbpwZhZIMYshk3xgxZVVntgu76k8Hqoz0S9B3M83nOXpFhnKDEe8yFCZATTNjS+3nUhvTxzf2szgJP7w8lJy0XEaDPNppnfR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simplify try_to_unmap_one() by separating the hugetlb parts into
try_to_unmap_poisoned_hugetlb_one().

To understand the correctness of the refactoring, the following points
are noted:

1. try_to_unmap() is called for hugetlb folios only when they are
   hwpoisoned.

2. A hugetlb VMA cannot be mlocked.

3. page_vma_mapped_walk() returns at most one hugetlb mapping in a VMA,
   and that mapping points at the head PFN.

4. We won't ever process a softleaf entry that encodes a hugetlb folio;
   hugetlb folios are never swapped out, migration entries will be
   skipped (PVMW_MIGRATION not passed), and device-exclusive does not
   work for hugetlb.

5. The hwpoison entry is constructed from the poisoned folio, just as in
   the pre-refactor code. Any previous uffd-wp state is deliberately not
   preserved for the hwpoison entry.

6. TTU_HWPOISON is always present; for it to not be present, either the
   folio has to be in swapcache, or mapping_can_writeback() is true (see
   unmap_poisoned_folio), none of which is true for hugetlb folios.

7. Hugetlb uses separate counters from normal rss counters, therefore
   update_highwater_rss() need not be called.

While at it:

 - Change VM_BUG_* to VM_WARN_*.

 - Do not declare variables which are only used once.

 - Constify some variables.

 - Add some more VM_WARN_* to assert some invariants.

Except the above 4 points, no functional change intended.

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/hugetlb.h |   1 +
 mm/rmap.c               | 180 ++++++++++++++++++++++------------------
 2 files changed, 98 insertions(+), 83 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 6ca232a61643..16c4c4caa126 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1270,6 +1270,7 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
 }
 
 pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+unsigned long huge_pte_dirty(pte_t pte);
 
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long addr, pte_t *ptep)
diff --git a/mm/rmap.c b/mm/rmap.c
index 77be9fcffa99..9cb496d7b375 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1978,6 +1978,96 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
 }
 
+static bool try_to_unmap_poisoned_hugetlb_one(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long address, void *arg)
+{
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
+	const unsigned long hsz = huge_page_size(hstate_vma(vma));
+	const enum ttu_flags flags = (enum ttu_flags)(long)arg;
+	struct mm_struct *mm = vma->vm_mm;
+	struct mmu_notifier_range range;
+	bool ret = true;
+	pte_t pteval;
+
+	/*
+	 * The try_to_unmap() is only passed a hugetlb folio in the case
+	 * where the hugetlb folio is poisoned.
+	 */
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_hwpoison(folio), folio);
+	VM_WARN_ON_ONCE(!(flags & TTU_HWPOISON));
+
+	range.end = vma_address_end(&pvmw);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
+				address, range.end);
+	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	mmu_notifier_invalidate_range_start(&range);
+
+	/* There is only a single mapping in a VMA. */
+	if (!page_vma_mapped_walk(&pvmw))
+		goto range_end;
+
+	VM_WARN_ON_ONCE(address != pvmw.address);
+
+	pteval = huge_ptep_get(mm, address, pvmw.pte);
+	VM_WARN_ON_ONCE(!pte_present(pteval));
+	VM_WARN_ON_ONCE(pte_pfn(pteval) != folio_pfn(folio));
+
+	/*
+	 * huge_pmd_unshare may unmap an entire PMD page. There is no way of
+	 * knowing exactly which PMDs may be cached for this mm, so we must
+	 * flush them all. start/end were already adjusted above to cover this
+	 * range.
+	 */
+	flush_cache_range(vma, range.start, range.end);
+
+	/*
+	 * To call huge_pmd_unshare, i_mmap_rwsem must be held in write mode.
+	 * Caller needs to explicitly do this outside rmap routines.
+	 *
+	 * We also must hold hugetlb vma_lock in write mode. Lock order dictates
+	 * acquiring vma_lock BEFORE i_mmap_rwsem. We can only try lock here and
+	 * fail if unsuccessful.
+	 */
+	if (!folio_test_anon(folio)) {
+		struct mmu_gather tlb;
+
+		VM_WARN_ON_ONCE(!(flags & TTU_RMAP_LOCKED));
+		if (!hugetlb_vma_trylock_write(vma)) {
+			ret = false;
+			goto walk_done;
+		}
+
+		tlb_gather_mmu_vma(&tlb, vma);
+		if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
+			hugetlb_vma_unlock_write(vma);
+			huge_pmd_unshare_flush(&tlb, vma);
+			tlb_finish_mmu(&tlb);
+			/*
+			 * The PMD table was unmapped, consequently unmapping
+			 * the folio.
+			 */
+			goto walk_done;
+		}
+		hugetlb_vma_unlock_write(vma);
+		tlb_finish_mmu(&tlb);
+	}
+	pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
+	if (huge_pte_dirty(pteval))
+		folio_mark_dirty(folio);
+
+	pteval = swp_entry_to_pte(make_hwpoison_entry(folio_page(folio, 0)));
+	hugetlb_count_sub(folio_nr_pages(folio), mm);
+	set_huge_pte_at(mm, address, pvmw.pte, pteval, hsz);
+	hugetlb_remove_rmap(folio);
+	folio_put_refs(folio, 1);
+
+walk_done:
+	page_vma_mapped_walk_done(&pvmw);
+range_end:
+	mmu_notifier_invalidate_range_end(&range);
+	return ret;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -1993,7 +2083,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 	unsigned long nr_pages = 1, end_addr;
 	unsigned long pfn;
-	unsigned long hsz = 0;
 	int ptes = 0;
 
 	/*
@@ -2007,8 +2096,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 	/*
 	 * For THP, we have to assume the worse case ie pmd for invalidation.
-	 * For hugetlb, it could be much worse if we need to do pud
-	 * invalidation in the case of pmd sharing.
 	 *
 	 * Note that the folio can not be freed in this function as call of
 	 * try_to_unmap() must hold a reference on the folio.
@@ -2016,17 +2103,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	range.end = vma_address_end(&pvmw);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address, range.end);
-	if (folio_test_hugetlb(folio)) {
-		/*
-		 * If sharing is possible, start and end will be adjusted
-		 * accordingly.
-		 */
-		adjust_range_if_pmd_sharing_possible(vma, &range.start,
-						     &range.end);
-
-		/* We need the huge page size for set_huge_pte_at() */
-		hsz = huge_page_size(hstate_vma(vma));
-	}
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
@@ -2111,66 +2187,13 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			const softleaf_t entry = softleaf_from_pte(pteval);
 
 			pfn = softleaf_to_pfn(entry);
-			VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
 		}
 
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
 		anon_exclusive = folio_test_anon(folio) &&
 				 PageAnonExclusive(subpage);
 
-		if (folio_test_hugetlb(folio)) {
-			bool anon = folio_test_anon(folio);
-
-			/*
-			 * The try_to_unmap() is only passed a hugetlb folio
-			 * in the case where the hugetlb folio contains a
-			 * poisoned page.
-			 */
-			VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
-			/*
-			 * huge_pmd_unshare may unmap an entire PMD page.
-			 * There is no way of knowing exactly which PMDs may
-			 * be cached for this mm, so we must flush them all.
-			 * start/end were already adjusted above to cover this
-			 * range.
-			 */
-			flush_cache_range(vma, range.start, range.end);
-
-			/*
-			 * To call huge_pmd_unshare, i_mmap_rwsem must be
-			 * held in write mode.  Caller needs to explicitly
-			 * do this outside rmap routines.
-			 *
-			 * We also must hold hugetlb vma_lock in write mode.
-			 * Lock order dictates acquiring vma_lock BEFORE
-			 * i_mmap_rwsem.  We can only try lock here and fail
-			 * if unsuccessful.
-			 */
-			if (!anon) {
-				struct mmu_gather tlb;
-
-				VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
-				if (!hugetlb_vma_trylock_write(vma))
-					goto walk_abort;
-
-				tlb_gather_mmu_vma(&tlb, vma);
-				if (huge_pmd_unshare(&tlb, vma, address, pvmw.pte)) {
-					hugetlb_vma_unlock_write(vma);
-					huge_pmd_unshare_flush(&tlb, vma);
-					tlb_finish_mmu(&tlb);
-					/*
-					 * The PMD table was unmapped,
-					 * consequently unmapping the folio.
-					 */
-					goto walk_done;
-				}
-				hugetlb_vma_unlock_write(vma);
-				tlb_finish_mmu(&tlb);
-			}
-			pteval = huge_ptep_clear_flush(vma, address, pvmw.pte);
-			if (pte_dirty(pteval))
-				folio_mark_dirty(folio);
-		} else if (likely(pte_present(pteval))) {
+		if (likely(pte_present(pteval))) {
 			nr_pages = folio_unmap_pte_batch(folio, &pvmw, flags, pteval);
 			end_addr = address + nr_pages * PAGE_SIZE;
 			flush_cache_range(vma, address, end_addr);
@@ -2205,17 +2228,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		/* unmap_poisoned_folio() only refs order-0 or hugetlb folios */
+		/* unmap_poisoned_folio() only refs order-0 folios */
 		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
-			if (folio_test_hugetlb(folio)) {
-				hugetlb_count_sub(folio_nr_pages(folio), mm);
-				set_huge_pte_at(mm, address, pvmw.pte, pteval,
-						hsz);
-			} else {
-				dec_mm_counter(mm, mm_counter(folio));
-				set_pte_at(mm, address, pvmw.pte, pteval);
-			}
+			dec_mm_counter(mm, mm_counter(folio));
+			set_pte_at(mm, address, pvmw.pte, pteval);
 		} else if (likely(pte_present(pteval)) && pte_unused(pteval) &&
 			   !userfaultfd_armed(vma)) {
 			/*
@@ -2343,11 +2360,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
 discard:
-		if (unlikely(folio_test_hugetlb(folio))) {
-			hugetlb_remove_rmap(folio);
-		} else {
-			folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
-		}
+		folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
 		folio_put_refs(folio, nr_pages);
@@ -2395,7 +2408,8 @@ static int folio_not_mapped(struct folio *folio)
 void try_to_unmap(struct folio *folio, enum ttu_flags flags)
 {
 	struct rmap_walk_control rwc = {
-		.rmap_one = try_to_unmap_one,
+		.rmap_one = folio_test_hugetlb(folio) ?
+				try_to_unmap_poisoned_hugetlb_one : try_to_unmap_one,
 		.arg = (void *)flags,
 		.done = folio_not_mapped,
 		.anon_lock = folio_lock_anon_vma_read,
-- 
2.43.0


