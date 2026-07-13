Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CE93C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125D16B0093; Mon, 13 Jul 2026 13:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D6ED6B0128; Mon, 13 Jul 2026 13:12:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F07536B012A; Mon, 13 Jul 2026 13:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3DFF6B0093
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:12:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 574C3168B10
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:37:05 +0000 (UTC)
X-FDA: 84983854410.28.B96B4F9
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7C7AF4000C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:37:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MqI8VGCs;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783949823;
	b=HtSOMwnGXpPL4TUZu1Hf29Jo11kwpRsyc0NyTq6mahD6y6gKXF3d/7heO36jqsmSsIWDeV
	QMeIcqPK4cEeAkAtO/FZfFrd71TsvSYCSqd7KbegPPIEFRimHUmmspW/mzDGaPFnV5ACBm
	M+ng5jTnivv9TUtTjtonzUKC8Jl0vaY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MqI8VGCs;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783949823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tUTto7lYDoWJdkIdAt5j73vjHXx1jSGnYfGwAlOneRQ=;
	b=nwxFMAFHT4b4Z1QUSsjESVRnPi/dWH47smOny8GQ8y7w42WlWPk/5AKR6yOgRLGQ94Lb3Z
	zNabu5wA3TpnrvNTCJePYRElj31aqGOZZbd00CYrwd9Wnw2qreTUCLDmIPhAaggPes80Ne
	Jc65O1bNnm34nL3kJlN89wr3HXp/WFs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783949821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tUTto7lYDoWJdkIdAt5j73vjHXx1jSGnYfGwAlOneRQ=;
	b=MqI8VGCsiVhUTQQ8ZdjFQlLqI6/XdaWm9C3mE/cSzyq9eywkgyaWEHh1yBhhrvoDkNs0yx
	VKhooAm5VsdnWQubAng/DBLc6QSiHOes++NV3lp26h1sHSUC0WPnHLaqm1zj/326IodiSK
	4j3fnjvzoZPDXTZxwrOl5ekDzYr7XqA=
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
	npache@redhat.com,
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
Subject: [PATCH v4 06/11] mm: handle PMD swap entries in non-present PMD walkers
Date: Mon, 13 Jul 2026 06:35:41 -0700
Message-ID: <20260713133613.2707815-7-usama.arif@linux.dev>
In-Reply-To: <20260713133613.2707815-1-usama.arif@linux.dev>
References: <20260713133613.2707815-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7C7AF4000C
X-Stat-Signature: 9yfa8a84rtsefdqqxpt5r8168aobmh6c
X-HE-Tag: 1783949823-105234
X-HE-Meta: U2FsdGVkX1+cunb9lE4mmqv6IeX7T6jCn5IwJlGqPjDJUAryqwp2gN7Am2YEifMuVNPehf4x/M8fhyu8xWK5Y5zqSA8vQueRyGa4jW58rr4i0XnqIdtJQWATW6souArNy6dnFI8q4DCSRpi698LdjUuP+AL9v4dMtW9eA1DcRXlaPf4xuXVQzbZUqTErNrzVGw4UvYTfudjmKW99+97ducH7K8iLYWYxy9A29IDRM5RGX8ezpsfPz6m0uun4Gq1bxcOqoKqlcSVTQISUFZyX9NvXB/ccWCHoP3v3rD/jWRzynLDxMObf23K1t0tXkiFt8JRlyZdyNNQDGM/tV0d98pvd8hR894ELELHG/951YJ5X1moyEJVSRGE2QCzjJuEd6uo3ooQ+zeVYi3sGUvxIbXLP0L5zkWX0LQeZtLKSbeL3i75TI37kwXA5998JtsExW2LIJQbI5HgqniCjPZcq8ycXlcx+hPNu31PuwnaLYavUv4OSUZx04XiJZgFa3v/WaxdCbUKzx49WU8C+yd9DgxRNMUasy/ipU1aDe3WBi5JfqljSmMkB+CaTHgX2Ksir3MLWByZl1bVGLBDcHAfHiXmyflA4m6BdBqGZUYUqf0OgStGcA/U4fvI2paL++Fd6w6d6m0wto5Du22Nj4dNXhKVaNAhUsgNzfwPxSCN6vkbzAw/Ydj8EScdwiIQMftRdx7jgLWz/rZTQZ0+c3pP5JVvsuGtViylt3jyF+fb4xn77OFhR6BgZ+M6T8cszsee4UZDG0fpX1tzBPTwyZWUq4eumEoqbdICGzd6VOufr4KR1oE5gBAn3KBf0E3YTGo7ftvaYcwwVRbzYFylOcEPP1ThMupXfmRc55qrdNmv2Wt+Takwiw9rhOzX7Sahistj7reHZaV/NJFloKRFLP78pqhAJmJH2QWUhRx8/8C6yJNV6FiIqw+Ul/AN0uj8BeEFpAUArCl46NRSPpRfugA1
 2xMmCNaT
 cVywUBStsnVHJaWJlIQK2j2b1X2YUmkeYyL0fSzxGcANSJDwE8/L+ApDzuiBIWRlEfzxvF/v3tADivOdbkJOCh2eVSmMJlrZT9n+xC+Oadcpq49/zxDdCIixWT864qpsaMYyWGAjW6GtJjwulZEBQjWFTUDKHrWtAveXDsOvysPYhWqHFP6Z2eHzsqzAFH5Mqc//HGqvNOZO1wik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Teach the remaining non-present PMD walkers about swap entries,
mirroring the PTE-level equivalents.

smaps_pmd_entry() accounts swap and swap_pss via a new shared
smaps_account_swap() helper used by both PTE and PMD paths.

move_soft_dirty_pmd(), clear_soft_dirty_pmd(), and make_uffd_wp_pmd(),
pagemap_pmd_range_thp() and change_huge_pmd() handle swap entries
alongside migration entries.

hmm_vma_handle_absent_pmd() faults in PMD swap entries via
hmm_vma_fault() instead of returning -EFAULT. The first per-page
handle_mm_fault() call triggers do_huge_pmd_swap_page(), which maps
the entire folio; subsequent calls become harmless
huge_pmd_set_accessed() and the walker retries with a present PMD.

madvise_free_huge_pmd() handles PMD swap entries directly: for a
full-range MADV_FREE it clears the PMD, frees the deposited page
table, and releases the swap slots; for a partial range it splits to
PTE swap entries. Without this, MADV_FREE silently becomes a no-op
on swapped-out THPs, leaking swap slots.

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

mincore_pte_range() routes the pmd_trans_huge_lock() branch through
mincore_swap() for non-present PMDs, matching how the PTE path
already calls mincore_swap() for non-present PTEs. Without this a
swapped-out PMD-mapped THP would be reported as resident, because
pmd_is_huge() (and therefore pmd_trans_huge_lock()) accepts any
non-present non-none PMD and the old branch unconditionally did
memset(vec, 1, nr). mincore_swap() returns 1 for migration /
device-private entries (preserving the prior behavior for those)
and checks swap-cache residency for swap entries.

queue_folios_pmd() in mempolicy silently skips swap entries, matching
the PTE walker which only counts migration entries as failures.
Without this, mbind(MPOL_MF_STRICT) would spuriously return -EIO on
a swapped-out THP.

check_pmd_state() in khugepaged returns SCAN_PMD_MAPPED for PMD swap
entries, treating a swapped-out THP as still being a THP from
khugepaged's perspective and matching the existing migration-entry
handling.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/proc/task_mmu.c | 43 +++++++++++++++++++++-------------
 mm/hmm.c           |  3 ++-
 mm/huge_memory.c   | 58 +++++++++++++++++++++++++++++++++++-----------
 mm/khugepaged.c    |  6 +++++
 mm/madvise.c       | 14 ++++++++++-
 mm/mincore.c       | 45 ++++++++++++++++++++++++++++++++++-
 6 files changed, 137 insertions(+), 32 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 8285f497178b..bf0fd594be59 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1046,6 +1046,23 @@ static void smaps_pte_hole_lookup(unsigned long addr, struct mm_walk *walk)
 #endif
 }
 
+static void smaps_account_swap(struct mem_size_stats *mss,
+		softleaf_t entry, unsigned long size)
+{
+	int mapcount;
+
+	mss->swap += size;
+	mapcount = swp_swapcount(entry);
+	if (mapcount >= 2) {
+		u64 pss_delta = (u64)size << PSS_SHIFT;
+
+		do_div(pss_delta, mapcount);
+		mss->swap_pss += pss_delta;
+	} else {
+		mss->swap_pss += (u64)size << PSS_SHIFT;
+	}
+}
+
 static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 		struct mm_walk *walk)
 {
@@ -1067,18 +1084,7 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
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
@@ -1108,9 +1114,13 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
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
@@ -1755,7 +1765,7 @@ static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		pmd = pmd_clear_soft_dirty(pmd);
 
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
-	} else if (pmd_is_migration_entry(pmd)) {
+	} else if (pmd_is_migration_entry(pmd) || pmd_is_swap_entry(pmd)) {
 		pmd = pmd_swp_clear_soft_dirty(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}
@@ -2115,7 +2125,8 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
 			flags |= PM_UFFD_WP;
 		if (pm->show_pfn)
 			frame = pmd_pfn(pmd) + idx;
-	} else if (thp_migration_supported()) {
+	} else if (pmd_is_swap_entry(pmd) ||
+		   (thp_migration_supported() && pmd_is_migration_entry(pmd))) {
 		const softleaf_t entry = softleaf_from_pmd(pmd);
 		unsigned long offset;
 
@@ -2581,7 +2592,7 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 		old = pmdp_invalidate_ad(vma, addr, pmdp);
 		pmd = pmd_mkuffd(old);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
-	} else if (pmd_is_migration_entry(pmd)) {
+	} else if (pmd_is_migration_entry(pmd) || pmd_is_swap_entry(pmd)) {
 		pmd = pmd_swp_mkuffd(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}
diff --git a/mm/hmm.c b/mm/hmm.c
index fc2e1cd0cb22..6da069c0dbfd 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -376,7 +376,8 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 	required_fault = hmm_range_need_fault(hmm_vma_walk, hmm_pfns,
 					      npages, 0);
 	if (required_fault) {
-		if (softleaf_is_device_private(entry))
+		if (softleaf_is_device_private(entry) ||
+		    softleaf_is_swap(entry))
 			return hmm_record_fault(addr, end, required_fault, walk);
 		else
 			return -EFAULT;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d16cdf684b41..991929ec17d8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2347,6 +2347,14 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
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
@@ -2371,6 +2379,21 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2421,15 +2444,6 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2522,6 +2536,16 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2554,7 +2578,8 @@ static inline int pmd_move_must_withdraw(spinlock_t *new_pmd_ptl,
 static pmd_t move_soft_dirty_pmd(pmd_t pmd)
 {
 	if (pgtable_supports_soft_dirty()) {
-		if (unlikely(pmd_is_migration_entry(pmd)))
+		if (unlikely(pmd_is_migration_entry(pmd) ||
+			     pmd_is_swap_entry(pmd)))
 			pmd = pmd_swp_mksoft_dirty(pmd);
 		else if (pmd_present(pmd))
 			pmd = pmd_mksoft_dirty(pmd);
@@ -2645,7 +2670,14 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
 	pmd_t newpmd;
 
 	VM_WARN_ON(!pmd_is_valid_softleaf(*pmd));
-	if (softleaf_is_migration_write(entry)) {
+
+	/*
+	 * PMD swap entries don't encode write permission in the entry type,
+	 * so only uffd_wp flag changes apply. No folio lookup needed.
+	 */
+	if (softleaf_is_swap(entry)) {
+		newpmd = *pmd;
+	} else if (softleaf_is_migration_write(entry)) {
 		const struct folio *folio = softleaf_to_folio(entry);
 
 		/*
@@ -2705,7 +2737,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (!ptl)
 		return 0;
 
-	if (thp_migration_supported() && pmd_is_valid_softleaf(*pmd)) {
+	if (pmd_is_valid_softleaf(*pmd)) {
 		change_non_present_huge_pmd(mm, addr, pmd, uffd_prot,
 					    uffd_prot_resolve);
 		goto unlock;
@@ -3252,7 +3284,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		VM_WARN_ON_ONCE(freeze);
 		old_pmd = *pmd;
 		soft_dirty = pmd_swp_soft_dirty(old_pmd);
-		uffd_wp = pmd_swp_uffd_wp(old_pmd);
+		uffd_wp = pmd_swp_uffd(old_pmd);
 		anon_exclusive = pmd_swp_exclusive(old_pmd);
 	} else {
 		/*
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 45e8245d80da..3a44bf8206c0 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1102,6 +1102,12 @@ static inline enum scan_result check_pmd_state(pmd_t *pmd)
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
index bf9ce199935a..e24166500ac5 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -374,6 +374,15 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
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
@@ -384,6 +393,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			return 0;
 
 		orig_pmd = *pmd;
+		if (pmd_is_swap_entry(orig_pmd))
+			goto huge_unlock;
+
 		if (is_huge_zero_pmd(orig_pmd))
 			goto huge_unlock;
 
@@ -665,7 +677,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 	int nr, max_nr;
 
 	next = pmd_addr_end(addr, end);
-	if (pmd_trans_huge(*pmd))
+	if (pmd_trans_huge(*pmd) || pmd_is_swap_entry(*pmd))
 		if (madvise_free_huge_pmd(tlb, vma, pmd, addr, next))
 			return 0;
 
diff --git a/mm/mincore.c b/mm/mincore.c
index 53b982803771..ddf7c96964b0 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -99,6 +99,41 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
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
@@ -172,7 +207,15 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 
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


