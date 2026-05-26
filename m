Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0BD7CD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 439536B008C; Tue, 26 May 2026 02:37:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4107A6B0093; Tue, 26 May 2026 02:37:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326A86B0095; Tue, 26 May 2026 02:37:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 234D86B008C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:37:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C85B91C01BB
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:37:16 +0000 (UTC)
X-FDA: 84808614072.22.FDA3C64
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 20AA9140005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:37:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Vp/ZV24q";
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779777435; a=rsa-sha256;
	cv=none;
	b=Jxt9Glp+nZJsZX7jsEo4GfO2P2e4nuwtc2w/XmSB6UwXJLedHoT13eyM3fHdyfgtQAf/sM
	OvnjWfcMpFYItWYOR7OKBeo7ct+Dj71brxZ/YDd7kxnwt2jDzdHNgcAYuxUM6lNN6LGKMs
	74aZADmtPrKW9pUIy+ydFqt2tLNxm/o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Vp/ZV24q";
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779777435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mob/yphlciS54PLwlvXiVPrhMbGFvLXWrFUyfoc53yY=;
	b=Wdy64cvsZLJWehNtx6CVOM6SHknJYMBSLNGpO2KMt2XWEVT6jlO9/o7UVr1LEW4xgLYSrT
	OpZokphby0Pg2WG9QK9LC/EqAY8m3Baa0yaNBu8y/rXoTe1HtZE16Np+ZuhgpW8nu8tzLo
	emE9rXJnwf1RenYwlM8lEsp5UmWZvuM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2636E16F8;
	Mon, 25 May 2026 23:37:09 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0DCC13F7D8;
	Mon, 25 May 2026 23:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779777434; bh=QlKeC0szlyawhho6aeQ2cKHnkM8Vg2oBvDeCLJCPaGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vp/ZV24qm/3mGT83C2lrKF89JTiR/fob+WnE1iuAb2C94iBxBX94+AH07VDEeYLS/
	 5e+tnfDoTPzconByN45SjcPvrNRywr6EhGk515aGY8S1JelYpx34CVWmsfIG5glX53
	 DedAeDvhrHHpI4U7vpmlksKOKKsMaBsnSAit1jBA=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
Date: Tue, 26 May 2026 12:06:25 +0530
Message-Id: <20260526063635.61721-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526063635.61721-1-dev.jain@arm.com>
References: <20260526063635.61721-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 20AA9140005
X-Rspamd-Server: rspam03
X-Stat-Signature: qj5g5tii6jryu8me4d6rk75q4sjc4iyg
X-HE-Tag: 1779777434-371249
X-HE-Meta: U2FsdGVkX18ujy0bmBfCinki4ZQNo8IpMuQ7pc3FrqkGOcM/AIBoKyA3TcfS0tWpym5HyGQJdISno4K9DrKXM0kgNCaxaFlGfT423x9gYmdz+m3OnhHLWmEPlMdhH78OdwO3qyJKh0HLjnp4FVbM85t2zUUTR2l6JII1n3SClHlza+VU+oYvAXfLUwZ1laLLYpd45XD0DPee2OcwF7Zc1bWvDHJugQlcYaqLJpyYzA72h3/s+gB/3xrfWRNLHAlkrjZPFBODijLnS/hgnqj/swLZLfT8PlkPI9BloekLGkLm3nJz1E60Qglga+/mm/6z1ppMdrP0n798lWsz3qfAVzIDDR9hDEV2bhDpKZx65ynkU1EN5ylrYft/xf/hD05mxCVCbLkYpNbLWqNR5xiy+PpaOpR5Z9TzE0jvIDRPq5G6kKz9jEtsM7PcCaCK7WI3L0Cd1O08aPBFZeaL2vSFFjviguvx3d5ukbzrfA9giKCVv2fRUh1tkya1DoZq8PvRUluOBxMqU4k/ji+bZUMQqkLzMRJ4iEsVHiHR4quYu7bELl+G8FbL72UriHyNZjK+Oz0i9wN4D38/XKmUPCkFoQmra6Nbzncc/5tfI4LVUxAPcSZg7n5SVcM+j2JxRHRD8ufdLluNt+PXliLRSH0C92zGXwBRFRqD4j/RYgh4dGRiEjs5yVCDp5WH7APcW82rP2QmAdOvBLyWjpcB+dOsQD8aV4+l0nNJfgbTr7qP0xQTEcyjPgdmZVgZjnYjMnfBzfjsr+UtH+6LnSCSiXPzJwOaKOt9GEeN0O2M25GLxBeSuNB2x2OD2Sy+o/dptlkCoqb1AwhJKUBXMmW5xD8ipdTJnCstgfHQ5CufoVV+Zj+DBrACAk5aJs4PwJj2cKIliT/0aWj9hugRwbFyB26Ow952zi8YI/NK76ZoV1DusbVqBrYsrbR2ZacZqGwsGCL4csDVX9cS+M6mb7Mgv8K
 emEtkQ30
 XtieGcK8a7XFvUpNinyO7V1AvZb6/eAL4pqRnsDeQR5a1Ho8n/sHnGJg+olZ/h+MYqNT16gv7SV4iXg2K8enB+Rp0O2Cy3ZpedWp+EcwFDRHq5IsU4nWmQ2guEivgowJKPe4KQSMF2UChuVgXeBig+OxiVDYh1jayjCQDQGa6GBxPo1x0zEv70xh7q4JQ32iR13I+dIgfZpzVaJLsbidvUdDF2nlyD72cmM5INuj6Jsn7q0z+TKZRWrzJHNZ2GndUx75H5zGJ5Kn6uSzTqhucA7hUMkB6w9enI61/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simplify try_to_unmap_one by separating out the hugetlb parts into
try_to_unmap_hugetlb_one.

To understand the correctness of the refactoring, the following points
are noted:

1. try_to_unmap() is called for hugetlb folios only when they are
   hwpoisoned.

2. A hugetlb VMA cannot be mlocked.

3. The pvmw API sets pvmw.pte to the base of the hugetlb folio (pvmw.pmd
   is NULL).

4. We won't ever process a softleaf entry that encodes a hugetlb folio;
   hugetlb folios are never swapped out, migration entries will be skipped
   (PVMW_MIGRATION not passed) and device-exclusive does not work for
   hugetlb.

5. uffd-wp bit is lost when converting pvmw.pte to hwpoison softleaf
   (therefore no need to call pte_install_uffd_wp_if_needed after
   clearing pvmw.pte)

6. TTU_HWPOISON is always present; for it to not be present, either folio
   has to be in swapcache, or mapping_can_writeback() is true (see
   unmap_poisoned_folio), none of which is true for hugetlb folios.

7. hugetlb uses separate counters from normal rss counters, therefore
   update_highwater_rss() need not be called.

While at it:

 - Change VM_BUG_* to VM_WARN_*.

 - Do not declare variables which are only used once

 - Assert that the subpage derived by the pvmw walk is exactly the head
   page. This is because try_to_unmap() does not remember the specific
   subpage which was hwpoisoned, and, since we cannot munmap/mremap
   across a hugetlb folio partially, the first pte mapping the hugetlb
   folio (in case of a contpte or contpmd mapped folio) cannot ever point
   to an intermediate page.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 203 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 121 insertions(+), 82 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 430c91c8fe2ae..06ab1158d4cd1 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1978,6 +1978,121 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
 }
 
+static bool __try_to_unmap_hugetlb_one(struct folio *folio,
+		struct vm_area_struct *vma, struct page_vma_mapped_walk *pvmw,
+		struct mmu_notifier_range *range, enum ttu_flags flags)
+{
+	unsigned long hsz = huge_page_size(hstate_vma(vma));
+	unsigned long address = pvmw->address;
+	struct mm_struct *mm = vma->vm_mm;
+	struct page *subpage;
+	bool ret = true;
+	pte_t pteval;
+
+	if (!page_vma_mapped_walk(pvmw))
+		return true;
+
+	pteval = ptep_get(pvmw->pte);
+	VM_WARN_ON(!pte_present(pteval));
+	subpage = folio_page(folio, pte_pfn(pteval) - folio_pfn(folio));
+	VM_WARN_ON(folio_page(folio, 0) != subpage);
+
+	/*
+	 * huge_pmd_unshare may unmap an entire PMD page. There is no way of
+	 * knowing exactly which PMDs may be cached for this mm, so we must
+	 * flush them all. start/end were already adjusted above to cover this
+	 * range.
+	 */
+	flush_cache_range(vma, range->start, range->end);
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
+		if (huge_pmd_unshare(&tlb, vma, address, pvmw->pte)) {
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
+	pteval = huge_ptep_clear_flush(vma, address, pvmw->pte);
+	if (pte_dirty(pteval))
+		folio_mark_dirty(folio);
+
+	VM_WARN_ON(!(flags & TTU_HWPOISON));
+	pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
+	hugetlb_count_sub(folio_nr_pages(folio), mm);
+	set_huge_pte_at(mm, address, pvmw->pte, pteval, hsz);
+	hugetlb_remove_rmap(folio);
+	folio_put_refs(folio, 1);
+
+walk_done:
+	page_vma_mapped_walk_done(pvmw);
+	return ret;
+}
+
+static bool try_to_unmap_hugetlb_one(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long address, void *arg)
+{
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
+	struct mmu_notifier_range range;
+	enum ttu_flags flags = (enum ttu_flags)(long)arg;
+	bool ret;
+
+	/*
+	 * The try_to_unmap() is only passed a hugetlb folio in the case
+	 * where the hugetlb folio contains a poisoned page.
+	 */
+	VM_WARN_ON_FOLIO(!folio_contain_hwpoisoned_page(folio), folio);
+
+	/*
+	 * When racing against e.g. zap_pte_range() on another cpu,
+	 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
+	 * try_to_unmap() may return before folio_mapped() has become false,
+	 * if page table locking is skipped: use TTU_SYNC to wait for that.
+	 */
+	if (flags & TTU_SYNC)
+		pvmw.flags = PVMW_SYNC;
+
+	/*
+	 * For hugetlb, it could be much worse than THP if we need pud
+	 * invalidation in the case of pmd sharing.
+	 *
+	 * Note that the folio can not be freed in this function as call of
+	 * try_to_unmap() must hold a reference on the folio.
+	 */
+	range.end = vma_address_end(&pvmw);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
+				address, range.end);
+	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	mmu_notifier_invalidate_range_start(&range);
+	ret = __try_to_unmap_hugetlb_one(folio, vma, &pvmw, &range,
+					 flags);
+	mmu_notifier_invalidate_range_end(&range);
+	return ret;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -1993,7 +2108,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 	unsigned long nr_pages = 1, end_addr;
 	unsigned long pfn;
-	unsigned long hsz = 0;
 	int ptes = 0;
 
 	/*
@@ -2007,8 +2121,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 	/*
 	 * For THP, we have to assume the worse case ie pmd for invalidation.
-	 * For hugetlb, it could be much worse if we need to do pud
-	 * invalidation in the case of pmd sharing.
 	 *
 	 * Note that the folio can not be freed in this function as call of
 	 * try_to_unmap() must hold a reference on the folio.
@@ -2016,17 +2128,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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
@@ -2104,7 +2205,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			const softleaf_t entry = softleaf_from_pte(pteval);
 
 			pfn = softleaf_to_pfn(entry);
-			VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
 		}
 
 		subpage = folio_page(folio, pfn - folio_pfn(folio));
@@ -2112,59 +2212,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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
-			VM_WARN_ON_FOLIO(!folio_contain_hwpoisoned_page(folio), folio);
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
@@ -2201,14 +2249,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 		if (folio_contain_hwpoisoned_page(folio) && (flags & TTU_HWPOISON)) {
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
@@ -2341,11 +2383,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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
@@ -2393,7 +2431,8 @@ static int folio_not_mapped(struct folio *folio)
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
2.34.1


