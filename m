Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3999C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 05:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEF0B6B0092; Mon, 13 Jul 2026 01:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9FC16B0093; Mon, 13 Jul 2026 01:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD266B0095; Mon, 13 Jul 2026 01:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85D356B0092
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 01:01:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 269981409FE
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:01:18 +0000 (UTC)
X-FDA: 84982554636.11.6C08E6D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 21B4F20006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:01:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GPf1tuml;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783918876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0um4CC7pk0hOYtCJoaXJIG4NKYdlRN0CRs6FgOQTMmQ=;
	b=51Ts67jP8lyTr6MVm0m1NZaj9ja9Ly5c6wscob9NtB5b6CvRhqpSsdlfxz/NbKmxZ7chTY
	Z8KlFop6TYv07njoDgUO8dnTfb6tF/V6lce+9Agw1Qa3AcoVkeD8rTOhy3xHO7Sv0hcm4M
	IRJ0nF6p0OlBQ+lFt/s0NygLx8rUxEI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GPf1tuml;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783918876;
	b=KKo3usSCZ3A//4FQb7H7TgVkC4d4wxql2XNvZtIWQp713fVhKPmT2PIM8d7NL9nFOnovR+
	0+S1n3HpoivvI+Wco9Lsl5qcYXCejtCWGdkChmtRuRoFZppstzoMbI86lNaiiLE6G70xsc
	rm8ERh2OFwcda3QzXB6Jr3nRwHcVezA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56F9B1596;
	Sun, 12 Jul 2026 22:01:10 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 57DF53F93E;
	Sun, 12 Jul 2026 22:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783918874; bh=4TsFRiFVI9paLB9M6jDRjv5Eb/d9Eu1NYpxkKiFfspY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPf1tuml+sGCN4erdyJkNh515Ax5ndvBp7ZvsOztoJFR74RbbICpr5l2dYBlcm44d
	 6JBXkMbpVFnYz9oyBuUcJCpw41+2eFX2FGD7hM8hENqtC+mZDmzLj0eowTFRsG9AMT
	 FMXjR097YRz3JLpDGpBY2qQFI/gTMBZJJhIW/GT8=
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
Subject: [PATCH v3 2/5] mm/rmap: Add try_to_unmap_hugetlb_one
Date: Mon, 13 Jul 2026 05:00:45 +0000
Message-ID: <20260713050050.1017741-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713050050.1017741-1-dev.jain@arm.com>
References: <20260713050050.1017741-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 21B4F20006
X-Stat-Signature: imyyc3gzw4y63x41tsax9szieqwfotmf
X-HE-Tag: 1783918875-153965
X-HE-Meta: U2FsdGVkX1/RzUpHANwRJHhNvCUlJoVKqwIk1mzu1CeieD9LmEPHZX0y2QxPWEvVTYXQtR4AokovhosWeSDL7+Pk9oQj4spapEGqJgsxsouZCb8/ayDI0Sm4RujRpV6St72TXCzhUUuiun97fTGgfdmTdAVHuNnPqWLjaPMK5VTuPMYt4Gls9jiARvek5XRPk0UPgVILDHH2S0B0vlno3pRdI/9qm3NkhOjY4UAav2EV166O8jl4iuLpGeJDlih4ZVzm2aGCrRduxxG1Yza5Trylqrb8Q125k3kWC6s3R7i3LPyijUDc3jh0ohKVjGXytUx0nGa5QWeLSrrbshp+F5vxfX3r/xrHgkkELC/LvNeiv2CXDeoGrpaAr8B1TtzWL2YRA736cAbKrsTBRwnSb6cfvpkkOuTMwIvYvLmUrdVFvZW/R6GBKslJgk3yhBxhKpgyHu/Tf5ftwgoLcCQyOj9dOAyXlGw2QtWdKYRq0/aixS2YS04jmNIBgTsnmVRnKS6PZ98xW0DSnFOKjE2Q2qSMl7ecW3JZl9vSe5oi4MpzFnhWpFjDahceox3NqxKlNPw5qJ7plEO621tf9dpuOIJ04cWvnS4LSBI8SDe9+AjJkb7RpeboJ27C6/xekmv042VNWe1FzN+TKrZqb9Q8G0owyUk5kqdfmTYuZ/7drJ0/irAgIMm8RYZbJkuXvbTeKgLlQMpxKa9x7TFXy/xj4Y4IUOpJVB7fkCxT+pdlIVgB874sxdgb2QScetqtRDIPfSh4zYVowuxS4xhwmNKDwph6Zu+YK0pokw72EgD7DNltqhSJ5GeRkQ77N7b2R7oo/oyUHmxCbvj5B0tWqSVLR8pEgzoR/OT8YqNlIPrrRF8BGaO+vDDEp+vvCiBA6wAWiNLDXr6w+ZD9QD6a8Y2qQDJbOwxrjrgKW+91msI8ZEC/KVl9JuoE0w+zcPZS6tgA8yJqX14GWzlkyfRIw5t
 wCzUL7jP
 qfywLGeiiaPhsOjN5ZB5Q+6KxzFPLugH0iPoXaBFeD3S5F3trF+koYBpt4MnHHo3KeIEf+XTgO4VZ6cjZTgbD5vTWTHuOCdPkuCC5b3mPYw6WfioKwRf5RbRDWjRIpyqd/pISIYqrZ4qUjYrhCOhXZw74uSFSeLsSFoohOlYxElGyYM/0FE/2FC3r7vMPWNWprldf19YkL3/fgKrO1J8SRlKKHfAQ602Xq30yhWMlV/ELGgYv/hGpls51qGXBXeVu03VaLktDHDNRhBYsqPSG9YTN4teo1+v092j+WlNx9R/nENENbmzJ+Hw4CIJhJDJBbJNv
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
 mm/rmap.c               | 183 +++++++++++++++++++++-------------------
 2 files changed, 98 insertions(+), 86 deletions(-)

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
index 2b74668f356d6..7720c49ada4c3 100644
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
@@ -2205,20 +2228,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		/*
-		 * With TTU_HWPOISON, we only expect small folios or hugetlb
-		 * folios here for now.
-		 */
+		/* With TTU_HWPOISON, we only expect small folios here. */
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
@@ -2346,11 +2360,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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
@@ -2398,7 +2408,8 @@ static int folio_not_mapped(struct folio *folio)
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


