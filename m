Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95BE5C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF01D6B01A1; Tue, 18 Aug 2026 09:12:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04BB6B01A2; Tue, 18 Aug 2026 09:12:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4796B01A3; Tue, 18 Aug 2026 09:12:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 861B36B01A1
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:12:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16D1C16010D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:39 +0000 (UTC)
X-FDA: 85114429638.24.5AF9951
Received: from mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
	by imf30.hostedemail.com (Postfix) with ESMTP id 27F2F8000A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ksqyv3AZ;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.197 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787058757;
	b=b3M5ASpRPtYPV5RQBc7tGzt5haurE+ziZie6BotRZ+Q5X0/tei3NHEpS7NrjZk5gBk3wW0
	RupwHTKxiCv4LTm4l2e/KicF52hqBJFh8aRf7KlpSaSG0ZsOK+eqXEAEPm685oGelGy3X0
	ja1wjJ8jEFpavPWuS1Y85n/frcz2JrE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ksqyv3AZ;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.197 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CdNM2sPcq96/RtY7GDhDaqybDIQgzQm+T+1IshgEKPM=;
	b=OY9y7Ua/ce7wdM3zEY4woupZlEq+sRRthVXffVrPbrNUgTaYg3xz16Mnp8QOfpIC1DLTfz
	mIrnmYBQ1pMXCNcVP+v+pn++cGhreqqA7AGEogO+rC7JtZKC8JJmjp4El2DhyudCvT4yWo
	ILrVnmMxZw5VKn0RsDuFkqiqs8FlZ3M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=h6V8hB3omjRe0c7aiousJ/TjmZXePRZFl9ICyKKrXLM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787058756; v=1; x=1787663556;
 b=Ksqyv3AZH6TJB5WMhf7ZJVTfmthuQVvWUjwB8Rv08X80FiBaacLe8U5XszODj7DpGVvGU4lu
 RyvrihUlmcO+mpPWpzPidD+ETPKPyiu8ZlYhpio+F4v4cd5GJbIzaYNJ1TDmvGqdkhkEnvZLGQe
 z0o67wxXvoTyi31jOSArywVA=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:1d::)
	by mta12.migadu.com with ESMTPS id 0920b0673411bc84;
	Tue, 18 Aug 2026 13:12:35 +0000
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v6 07/12] mm: handle PMD swap entries in non-present PMD walkers
Date: Tue, 18 Aug 2026 06:09:48 -0700
Message-ID: <20260818131202.494754-8-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818131202.494754-1-usama.arif@linux.dev>
References: <20260818131202.494754-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 27F2F8000A
X-Rspam-User: 
X-Stat-Signature: hruzjrijxcsity1mhxofcn44r8f45byp
X-Rspamd-Server: rspam06
X-HE-Tag: 1787058756-352031
X-HE-Meta: U2FsdGVkX1+tIHunv3nh5VdhIfTm44/O6F8Ld9h1R7vA3pEF4mOJ4LHiVd3OfCeMn/djtbtdik/tf8bAj9zfy/Tcjwn5ml7PG3mjcaL6jdJvE5FziRiRVgz6QxOiMCC6AYiGrI/dB5XBtq+Qb4CCJtVb60jJWSQUaNrfEVMRA7lrHGgCvQxFtV498aKizLRcrph/atsztkBvLNLS3LwlCHXyg+/B1fB/r2RLePSCqGDHqR6N1rzjR9pgLxhNE/ZbpJgm+vo8BYgDN2D6CzvNUxyRg2uBd4hWmw3HK/8npYXXm5Jcy7HJL+kX9H86vo1GD6TXWZIwwCFpFdC/VUvvCDBNczyGqjJSIsj4OivQwgPEhOKu6+Zya+Sd8ehq3Qall3pzbHSw9nyJfaR4N/CfdMKHvDmw4ve/WKWlO1OfqmMV2X3fbMW8CjDRUGWpt6my8cO9JcEqJEJcNlUE9YEMSDvKDRWEK/XIbJFZDXXU15vYY+wNNc3L/X+5iSNUIeGUAEYlZWkLVmn/pohDEpWayxg/+l5NLnhWZ/EeDDXIlkZADU+uurngBBzEplq1rG2bXKyU39M6UltVF+L6TDLrQvLnZfwRNKzNyqVdjzhUNZ5S536dUPy1MkxZMld6A2myRa9rkFfNz8oGNP+J+KA1GdAZAlVGCsEjNdHOFKm9dHri34XgtqYDjCWmZHIopxChXg9GJvmLN1tn4R5eOmXAaTFPvgZwFe+Bk4TCidkwZqx4vITKtHrlTKutTwwc8V4G4R74UmwScImkR32faz4Ez93dVLvkpaPNRrRW+/JQg2916hJrizyl/GTeI/o2x+QWwAiuExgVo0B/65EU7xHZUcSNSrHh4iCa8HSnUrcEktcFC8CNTmhyFEVaNtdpLTrDZgY0XJBRX727kkBKVBu3X5TRjEXB22niCRr5Sqzqg7O/2f5uYGrcH+GxfzY4e94GVdGhZEoK+tiCQUvplPs
 VBonO3eD
 Vn/584DOZGHZ6LfIEz67Qek+vvRXSzj7SHuF2PdboxPGyBXcnAAVN3iRJjIkHUTdUkxGZXGzWOul31dKtNjEJwYaJ7hFrGRIRE6ZN+oVwIs5XupE8nG0sEn13yO3H+ysVauVYrg2JFeom5Xp3cJ1kfoZndX1fi5f4cHC2MuOFgy5exg5tQ8Y5+rvYrJMGphyw6nerMo99JWQPXncYWNrjh0kAd97rkL7427j1u9QtlBwCmRbh0LO8KpJsX/5dckOzXApeEeqKkjET286hsCK7CBiALw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Teach the remaining non-present PMD walkers about swap entries,
mirroring the PTE-level equivalents.

smaps_pmd_entry() accounts swap and swap_pss via a new shared
smaps_account_swap() helper used by both PTE and PMD paths. For a
PMD range, it accounts each covered slot separately because their
swap reference counts can differ.

move_soft_dirty_pmd(), clear_soft_dirty_pmd(), and make_uffd_wp_pmd(),
pagemap_pmd_range_thp() and change_huge_pmd() handle swap entries
alongside migration entries.

hmm_vma_handle_absent_pmd() records a fault for PMD swap entries via
hmm_record_fault() instead of returning -EFAULT, allowing
hmm_range_fault() to fault them in. The first per-page handle_mm_fault()
call triggers do_huge_pmd_swap_page(), which maps the entire folio;
subsequent calls become harmless huge_pmd_set_accessed() and the walker
retries with a present PMD. When no fault is requested, it reports the
range as non-resident rather than HMM_PFN_ERROR, matching the PTE swap
entry path.

madvise_free_huge_pmd() handles PMD swap entries directly: for a
full-range MADV_FREE it clears the PMD, frees the deposited page
table, and releases the swap slots; for a partial range it splits to
PTE swap entries. Without this, MADV_FREE silently becomes a no-op
on swapped-out THPs and leaves the swap slots allocated, unlike the
PTE path which frees them.

zap_huge_pmd() frees swap slots via swap_put_entries_direct(),
matching zap_nonpresent_ptes().

change_non_present_huge_pmd() skips write-permission changes for swap
entries and only updates uffd_wp, matching change_softleaf_pte().

madvise_cold_or_pageout_pte_range() skips PMD swap entries early.
MADV_COLD and MADV_PAGEOUT operate on resident folios, so a swapped-out
THP has nothing to deactivate or reclaim; skipping also prevents the
walker from descending into or splitting the PMD swap entry. The locked
THP path also treats a racing PMD swap entry as handled before checking
for other non-present PMD types.

mincore_pte_range() routes PMD swap entries through a new
mincore_pmd_swap() helper, matching how the PTE path already calls
mincore_swap() for non-present PTEs. Without this a swapped-out
PMD-mapped THP would be reported as resident, because pmd_is_huge()
(and therefore pmd_trans_huge_lock()) accepts any non-present non-none
PMD and the old branch unconditionally did memset(vec, 1, nr).
mincore_pmd_swap() checks the PMD-sized swap-cache folio, or the
individual slots if it was split. Migration and device-private PMDs
keep their previous behavior of reporting 1.

check_pmd_state() in khugepaged returns SCAN_PMD_MAPPED for PMD swap
entries, treating a swapped-out THP as still being a THP from
khugepaged's perspective and matching the existing migration-entry
handling.

change_huge_pmd() and pagemap_pmd_range_thp() drop redundant
thp_migration_supported() gates: when PMD softleaves are unsupported,
softleaf_from_pmd() returns a none entry and pmd_is_valid_softleaf()
is false.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/proc/task_mmu.c | 46 ++++++++++++++++++++++++++--------------
 mm/hmm.c           | 11 +++++++++-
 mm/huge_memory.c   | 53 ++++++++++++++++++++++++++++++++++++----------
 mm/khugepaged.c    |  6 ++++++
 mm/madvise.c       | 14 +++++++++++-
 mm/mincore.c       | 45 ++++++++++++++++++++++++++++++++++++++-
 6 files changed, 145 insertions(+), 30 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 5c54aebe21182..8926392e33338 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1046,6 +1046,27 @@ static void smaps_pte_hole_lookup(unsigned long addr, struct mm_walk *walk)
 #endif
 }
 
+static void smaps_account_swap(struct mem_size_stats *mss,
+			       softleaf_t entry, unsigned long size)
+{
+	unsigned long nr_pages = size >> PAGE_SHIFT;
+
+	mss->swap += size;
+	do {
+		int mapcount = swp_swapcount(entry);
+
+		if (mapcount >= 2) {
+			u64 pss_delta = (u64)PAGE_SIZE << PSS_SHIFT;
+
+			do_div(pss_delta, mapcount);
+			mss->swap_pss += pss_delta;
+		} else {
+			mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
+		}
+		entry.val++;
+	} while (--nr_pages);
+}
+
 static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 		struct mm_walk *walk)
 {
@@ -1067,18 +1088,7 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 		const softleaf_t entry = softleaf_from_pte(ptent);
 
 		if (softleaf_is_swap(entry)) {
-			int mapcount;
-
-			mss->swap += PAGE_SIZE;
-			mapcount = swp_swapcount(entry);
-			if (mapcount >= 2) {
-				u64 pss_delta = (u64)PAGE_SIZE << PSS_SHIFT;
-
-				do_div(pss_delta, mapcount);
-				mss->swap_pss += pss_delta;
-			} else {
-				mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
-			}
+			smaps_account_swap(mss, entry, PAGE_SIZE);
 		} else if (softleaf_has_pfn(entry)) {
 			if (softleaf_is_device_private(entry))
 				present = true;
@@ -1108,9 +1118,13 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	if (pmd_present(*pmd)) {
 		page = vm_normal_page_pmd(vma, addr, *pmd);
 		present = true;
-	} else if (unlikely(thp_migration_supported())) {
+	} else {
 		const softleaf_t entry = softleaf_from_pmd(*pmd);
 
+		if (softleaf_is_swap(entry)) {
+			smaps_account_swap(mss, entry, HPAGE_PMD_SIZE);
+			return;
+		}
 		if (softleaf_has_pfn(entry))
 			page = softleaf_to_page(entry);
 	}
@@ -1755,7 +1769,7 @@ static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		pmd = pmd_clear_soft_dirty(pmd);
 
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
-	} else if (pmd_is_migration_entry(pmd)) {
+	} else if (pmd_is_migration_entry(pmd) || pmd_is_swap_entry(pmd)) {
 		pmd = pmd_swp_clear_soft_dirty(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}
@@ -2115,7 +2129,7 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
 			flags |= PM_UFFD_WP;
 		if (pm->show_pfn)
 			frame = pmd_pfn(pmd) + idx;
-	} else if (thp_migration_supported()) {
+	} else if (pmd_is_valid_softleaf(pmd)) {
 		const softleaf_t entry = softleaf_from_pmd(pmd);
 		unsigned long offset;
 
@@ -2581,7 +2595,7 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 		old = pmdp_invalidate_ad(vma, addr, pmdp);
 		pmd = pmd_mkuffd(old);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
-	} else if (pmd_is_migration_entry(pmd)) {
+	} else if (pmd_is_migration_entry(pmd) || pmd_is_swap_entry(pmd)) {
 		pmd = pmd_swp_mkuffd(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}
diff --git a/mm/hmm.c b/mm/hmm.c
index 2f1e98c6b6440..95575ac378888 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -377,12 +377,21 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 	required_fault = hmm_range_need_fault(hmm_vma_walk, hmm_pfns,
 					      npages, 0);
 	if (required_fault) {
-		if (softleaf_is_device_private(entry))
+		if (softleaf_is_device_private(entry) ||
+		    softleaf_is_swap(entry))
 			return hmm_record_fault(addr, end, required_fault, walk);
 		else
 			return -EFAULT;
 	}
 
+	/*
+	 * A swapped-out THP is not resident. Report it as not-valid,
+	 * matching what hmm_vma_handle_pte() does for a PTE swap entry when
+	 * no fault was requested.
+	 */
+	if (softleaf_is_swap(entry))
+		return hmm_pfns_fill(start, end, range, 0);
+
 	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
 }
 #else
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2735c3de7029c..54aef8394fa25 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2397,6 +2397,14 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	return 0;
 }
 
+static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
+{
+	pgtable_t pgtable;
+
+	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
+	pte_free(mm, pgtable);
+	mm_dec_nr_ptes(mm);
+}
 /*
  * Return true if we do MADV_FREE successfully on entire pmd page.
  * Otherwise, return false.
@@ -2421,6 +2429,21 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		goto out;
 
 	if (unlikely(!pmd_present(orig_pmd))) {
+		if (pmd_is_swap_entry(orig_pmd)) {
+			if (next - addr != HPAGE_PMD_SIZE) {
+				spin_unlock(ptl);
+				__split_huge_pmd(vma, pmd, addr, false);
+				goto out_unlocked;
+			}
+			softleaf_t sl = softleaf_from_pmd(orig_pmd);
+
+			pmdp_huge_get_and_clear(mm, addr, pmd);
+			zap_deposited_table(mm, pmd);
+			spin_unlock(ptl);
+			swap_put_entries_direct(sl, HPAGE_PMD_NR);
+			add_mm_counter(mm, MM_SWAPENTS, -HPAGE_PMD_NR);
+			return true;
+		}
 		VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
 				!pmd_is_device_private_entry(orig_pmd));
 		goto out;
@@ -2471,15 +2494,6 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	return ret;
 }
 
-static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
-{
-	pgtable_t pgtable;
-
-	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
-	pte_free(mm, pgtable);
-	mm_dec_nr_ptes(mm);
-}
-
 static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 		pmd_t pmdval, struct folio *folio, bool is_present)
 {
@@ -2572,6 +2586,16 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 
+	if (pmd_is_swap_entry(orig_pmd)) {
+		softleaf_t sl = softleaf_from_pmd(orig_pmd);
+
+		zap_deposited_table(mm, pmd);
+		spin_unlock(ptl);
+		swap_put_entries_direct(sl, HPAGE_PMD_NR);
+		add_mm_counter(mm, MM_SWAPENTS, -HPAGE_PMD_NR);
+		return true;
+	}
+
 	is_present = pmd_present(orig_pmd);
 	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
 	has_deposit = has_deposited_pgtable(vma, orig_pmd, folio);
@@ -2604,7 +2628,8 @@ static inline int pmd_move_must_withdraw(spinlock_t *new_pmd_ptl,
 static pmd_t move_soft_dirty_pmd(pmd_t pmd)
 {
 	if (pgtable_supports_soft_dirty()) {
-		if (unlikely(pmd_is_migration_entry(pmd)))
+		if (unlikely(pmd_is_migration_entry(pmd) ||
+			     pmd_is_swap_entry(pmd)))
 			pmd = pmd_swp_mksoft_dirty(pmd);
 		else if (pmd_present(pmd))
 			pmd = pmd_mksoft_dirty(pmd);
@@ -2695,6 +2720,12 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
 	pmd_t newpmd;
 
 	VM_WARN_ON(!pmd_is_valid_softleaf(*pmd));
+
+	/*
+	 * Note that a PMD swap entry falls into the default branch below: it
+	 * does not encode write permission in the entry type, so only the
+	 * uffd_wp flag update at the end applies to it.
+	 */
 	if (softleaf_is_migration_write(entry)) {
 		const struct folio *folio = softleaf_to_folio(entry);
 
@@ -2755,7 +2786,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (!ptl)
 		return 0;
 
-	if (thp_migration_supported() && pmd_is_valid_softleaf(*pmd)) {
+	if (pmd_is_valid_softleaf(*pmd)) {
 		change_non_present_huge_pmd(mm, addr, pmd, uffd_prot,
 					    uffd_prot_resolve);
 		goto unlock;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5a06e3942e889..15e2d0c7384d3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1125,6 +1125,12 @@ static inline enum scan_result check_pmd_state(pmd_t *pmd)
 	 */
 	if (pmd_is_migration_entry(pmde))
 		return SCAN_PMD_MAPPED;
+	/*
+	 * A PMD-mapped THP that has been swapped out is still a THP from
+	 * khugepaged's perspective; treat it like a present huge PMD.
+	 */
+	if (pmd_is_swap_entry(pmde))
+		return SCAN_PMD_MAPPED;
 	if (!pmd_present(pmde))
 		return SCAN_NO_PTE_TABLE;
 	if (pmd_trans_huge(pmde))
diff --git a/mm/madvise.c b/mm/madvise.c
index c179938097bf0..16b39a06b038f 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -375,6 +375,15 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 					!can_do_file_pageout(vma);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	/*
+	 * Swapped-out THPs have no resident folio to deactivate or reclaim.
+	 * Avoid descending into or splitting a PMD swap entry.
+	 */
+	if (pmd_is_swap_entry(*pmd)) {
+		walk->action = ACTION_CONTINUE;
+		return 0;
+	}
+
 	if (pmd_trans_huge(*pmd)) {
 		pmd_t orig_pmd;
 		unsigned long next = pmd_addr_end(addr, end);
@@ -385,6 +394,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			return 0;
 
 		orig_pmd = *pmd;
+		if (pmd_is_swap_entry(orig_pmd))
+			goto huge_unlock;
+
 		if (is_huge_zero_pmd(orig_pmd))
 			goto huge_unlock;
 
@@ -666,7 +678,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 	int nr, max_nr;
 
 	next = pmd_addr_end(addr, end);
-	if (pmd_trans_huge(*pmd))
+	if (pmd_trans_huge(*pmd) || pmd_is_swap_entry(*pmd))
 		if (madvise_free_huge_pmd(tlb, vma, pmd, addr, next))
 			return 0;
 
diff --git a/mm/mincore.c b/mm/mincore.c
index ff4ac82817683..3f0fba964c8a3 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -85,6 +85,41 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
 	return present;
 }
 
+#ifdef CONFIG_THP_SWAP
+static void mincore_pmd_swap(swp_entry_t entry, unsigned long addr,
+			     unsigned long end, unsigned char *vec)
+{
+	unsigned long haddr = addr & HPAGE_PMD_MASK;
+	unsigned long start = (addr - haddr) >> PAGE_SHIFT;
+	unsigned long nr = (end - addr) >> PAGE_SHIFT;
+	struct folio *folio;
+	enum swap_pmd_cache state;
+	int i;
+
+	state = swap_pmd_cache_lookup(entry, &folio);
+	if (state == SWAP_PMD_CACHE_HUGE) {
+		memset(vec, folio_test_uptodate(folio), nr);
+		folio_put(folio);
+		return;
+	}
+
+	if (state == SWAP_PMD_CACHE_EMPTY) {
+		memset(vec, 0, nr);
+		return;
+	}
+
+	/*
+	 * The PMD swap entry is only a compact encoding for consecutive swap
+	 * slots. If the PMD-sized swapcache folio was split, report residency
+	 * from the individual slots covered by this mincore() range.
+	 */
+	for (i = 0; i < nr; i++)
+		vec[i] = mincore_swap(swp_entry(swp_type(entry),
+						swp_offset(entry) + start + i),
+				      false);
+}
+#endif
+
 /*
  * Later we can get more picky about what "in core" means precisely.
  * For now, simply check to see if the page is in the page cache,
@@ -171,7 +206,15 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
-		memset(vec, 1, nr);
+		if (pmd_is_swap_entry(*pmd)) {
+#ifdef CONFIG_THP_SWAP
+			mincore_pmd_swap(softleaf_from_pmd(*pmd), addr, end, vec);
+#else
+			memset(vec, 0, nr);
+#endif
+		} else {
+			memset(vec, 1, nr);
+		}
 		spin_unlock(ptl);
 		goto out;
 	}
-- 
2.53.0-Meta


