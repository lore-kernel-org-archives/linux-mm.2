Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7AD6C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C00AA6B0092; Fri, 10 Jul 2026 01:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD75B6B0093; Fri, 10 Jul 2026 01:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AED766B0095; Fri, 10 Jul 2026 01:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83FDA6B0092
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:59:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 04F4C1203AE
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:59:37 +0000 (UTC)
X-FDA: 84971815236.24.1E3776B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 562D7180005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:59:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ojy9Y51P;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783663176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wThgYOTyfM4VFfELH2fgKxTiEvoPGsKYKdXdPq1VQc=;
	b=q+EhaUCrll24Tg8wa3D4R9TojvEoiEfKKpMjicGO2RafZK6o7uQ1IwI5w28mg5OvO2h5e8
	UwqciqedtsHLb0HfePwkMjTg2Ve1hhtGxqFoXTMWprjG2kmzxeA2f9LfihjkOQall9ES10
	OCMlCabxOQH04RGJAn2xnzKpE8HwWro=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ojy9Y51P;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783663176;
	b=t/rcvLxYB6g80Qka9F3455VowEbBeJVXIdfOWgjce40ZW8uqy05Bj+4c2RRcL8zJMYPe1j
	TSD4vsBgVVUx3lXBfwL+PJ3mJHxYYmtGYmF0YgmIpEz93+JrhzvFD0fMo+h05dfU8pUHk7
	pywsxyejIdxOGbtj+daEkSEpCHkeU4U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B6C91476;
	Thu,  9 Jul 2026 22:59:31 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 08C773F85F;
	Thu,  9 Jul 2026 22:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783663175; bh=WL0F15k5nOm2lJCvKVkwJ4/aRwLRAUGUHm/wjThf3sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojy9Y51P0MapdEYhDYs9b419XeQJwxL+pjymobhB9MwGAkE+mS65LQX0rVhF7grgB
	 4fgyVnMbbqBKEovi7UhfitJxY6WNljX8l+B7pUnAUjcXWveO4Du18MCuf5tIXGYrYt
	 /Qr3jBUMKsR2sfoLez5pnqZi0PJF8Hc0MJJJFOLQ=
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
Subject: [PATCH v2 2/5] mm/rmap: Add try_to_unmap_hugetlb_one
Date: Fri, 10 Jul 2026 05:59:11 +0000
Message-ID: <20260710055915.638659-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710055915.638659-1-dev.jain@arm.com>
References: <20260710055915.638659-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 562D7180005
X-Stat-Signature: omoe8x64mmmke5hru7byza9yy1p5pdb1
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783663176-757246
X-HE-Meta: U2FsdGVkX1+5ZTH1AcUasHuu5bJMviVGldybx6dWYIOLpFCHw1RuZ9v7ibbSdGuC/aG9usxMntCts6m+bRhkXpJ/Q8N0Brk4BQPcQQ+7n8yKkZqcvSC5N1dFKk1r8/kw/+8hqXruON9UAKmAlLgpKI+RMzY40eY1Q0UfOFWpMDeXL0Zqwom0ENHNLSHKSWILjpfnjx7CoPUix5JqEEWDRqw801hx2nhJpUhovhiiMOyUIENrPs8wUL7jL7yl2zEJ27xwoXiQ2TbOpBMixuWb5XRn2RqiWWIRQVskOEiIFrZBRliANt9DUemCoqIYzfvQnA7ZqPiTdITpTG/leAm3NGZ7GaUuDtfkt2lBwDRhumIDAKiciFEBV9mTVE/vZPAg/POuiVT0lXOQOcV0QID13VmHd/SfX6oDAX446Ce22JNACe9pRXozsuQUsc3gCEA/2y7piCXc4YLBtuz9jAOiXdxIm7fWGJmTDVdZYhSaZdVoL73H6kBI8ofhN5J46/gXfIr6Rlsa0/FkKXtyRIlQRjg7VPKSZoJvzAJw7dyedlAGSGHSHdZ/RVSk2b3d3Y/p+B9G0RIxj3/gr0OXTeh0L2AS2dDnuZ94mMMiTEwG6sqQ1pVZQ6K9icg8u/QUpX+Yae00OZQgGFn+3ALBi3RNfxCdzrJ7OVXeVJMjfQHWefwG3CXWzQxptiMDEeOdS42pCwvKVLuwXiBzG8Mzx0SrNng89ZCSMVf7xlgfVenhUzVwKMyA3Ip7GaNJPHdWKf5917h6yQ8EnWMC3hjLkGLV6qysRsywoYCdnzxuuE8g1U0vmWYd4cQ5x9uvK75uRtdvxxygItqseEAuaMQu1gvQhseDNNX7OI+xXo+xuVMIGp6bYx39PHeX+MJHMRxDWamaSSHoqY7WcxHsGY0yquSAwGExOM1CUD/majAQ9W3dJ0aNN8OtMtDWFvCyUkH8iYLoM1efYexCfF7YbRymkrK
 iQklmqnH
 A/qIlbDFklEiKlQlqeUxx/zkQZpyADvMWShniLo/A+5HFtaMkNnfr3A3A1nOqv5/IZQoOCJUgfXhoGej6sz2OsAhdQq0bEokQqPxIK9sN9aQGU5kBNpQ+pqXqUCl9fH1+lpWJRJLgko+BRk4GdcuvXICkqB81QXFYWLp9K+Lxgf9IIayG70IozJlunBnttdgtlw8PbztQ1Ws2P5c/V4CDPZ0dj/uvZK50BZM6SSGhzpd46Jyh1JMVjF2GvHTynMKQvAA/2SPR2pbBFILH2PwWjXWBgUP2pGdNEg5urn1gIiYnAp3yhFXBtJ6nNY7DJX+LxLrC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simplify try_to_unmap_one() by separating the hugetlb parts into
try_to_unmap_hugetlb_one().

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

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/hugetlb.h |   1 +
 mm/rmap.c               | 178 ++++++++++++++++++++++------------------
 2 files changed, 97 insertions(+), 82 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 4115076e4922a..bf7e163e3779d 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1271,6 +1271,7 @@ static inline void hugetlb_count_sub(long l, struct mm_struct *mm)
 }
 
 pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+unsigned long huge_pte_dirty(pte_t pte);
 
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long addr, pte_t *ptep)
diff --git a/mm/rmap.c b/mm/rmap.c
index dbb077f8443e3..cf02b315a2ead 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1978,6 +1978,96 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
 }
 
+static bool try_to_unmap_hugetlb_one(struct folio *folio,
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
+	VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
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
+		VM_WARN_ON(!(flags & TTU_RMAP_LOCKED));
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
@@ -2211,14 +2234,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 */
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
@@ -2346,11 +2363,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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
@@ -2398,7 +2411,8 @@ static int folio_not_mapped(struct folio *folio)
 void try_to_unmap(struct folio *folio, enum ttu_flags flags)
 {
 	struct rmap_walk_control rwc = {
-		.rmap_one = try_to_unmap_one,
+		.rmap_one = folio_test_hugetlb(folio) ?
+				try_to_unmap_hugetlb_one : try_to_unmap_one,
 		.arg = (void *)flags,
 		.done = folio_not_mapped,
 		.anon_lock = folio_lock_anon_vma_read,
-- 
2.43.0


