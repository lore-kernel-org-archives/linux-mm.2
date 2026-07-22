Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E9FDC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 478BE6B00BE; Wed, 22 Jul 2026 11:22:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44FC06B00C0; Wed, 22 Jul 2026 11:22:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F17F6B00C1; Wed, 22 Jul 2026 11:22:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0003D6B00BE
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:22:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A5041401ED
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:22:16 +0000 (UTC)
X-FDA: 85016778672.08.341D78D
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id 48308180004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:22:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OPuuhhSp;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784733734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NSm8JoLuNS6Pumn1HpnQDhCsu+jJMwJ/qUt2LXp4AlU=;
	b=LRwjbC6THFYaq4R/M6mFu/hSIEntD3XYexsPDCF0s/ie7YQWnpLc0S1q47xUHQDdnj8+SR
	ZO+IhGDlelJ/MD4Fa64dIT4AIYwwShIkNzQIQGxNrvgoZbdVOJIy7zlKKF8y+Bs38AJsMb
	UK+8y+pQns8Z8yZ52dXw7I1V6zDOZzE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784733734;
	b=NaNhkkDsFXYaBZFEA7Q03IrPWlrG821Bg5erUSOUpbKBQ+jULQ4t1EwzndVLhCaLh2syv6
	sLnUdW0l4hfBqTqYiNkaMwQFB7bScN/fyw3wrH7BSVK4d5aCAO1mI/XnRnjlCzTfiZlp7c
	6bnVyi+QIjEUM+NRi8w7U96nQR22o6M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OPuuhhSp;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784733732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NSm8JoLuNS6Pumn1HpnQDhCsu+jJMwJ/qUt2LXp4AlU=;
	b=OPuuhhSphwoTvxMet7WrnDbT+Nzztj+KV1U76etjGNjEhsOISEvAdrhAAN0mNE5gyizIlS
	ZsJLijbJxga0EClvmTw/1HcNavWgtPl3uETZGBBcA4R5I7XiY/AKOS/dCQsErcc0f/abxn
	S/YfAj9/sUsfRk2z6t3I5S/4+VdAFKE=
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
Subject: [PATCH v5 06/11] mm: handle PMD swap entries in non-present PMD walkers
Date: Wed, 22 Jul 2026 08:19:37 -0700
Message-ID: <20260722152043.2273289-7-usama.arif@linux.dev>
In-Reply-To: <20260722152043.2273289-1-usama.arif@linux.dev>
References: <20260722152043.2273289-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: bb3crfc65zodz1m1a5888n58c5k65xhp
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 48308180004
X-HE-Tag: 1784733734-229129
X-HE-Meta: U2FsdGVkX1/Up+1y0pJIHIDqHlmfFKE8GP/3mDyj6TiVZ6jM4TTHZexkSvaltkUNWtcx02pGqzTGbUjrk0o9OCDm+gmf8qOuDWPa5mkHxlaAdHmVnprrKg5ifwUyjymfSWbY8V423U4K7wUkXAGm+Z9BF3Y39ibG1CsQLi86knRcLTnrBbAdymsQWVpZWgv2OnH3scDTU5BgAl3lhprdDsc8c/3WoIB6NCWN/1lruKt69qhgl9xQWhEKIrDASkrLyP+diQ4RiOcviVZkWO+qtA6nP+/ENFM+MGl5xFByP7pHHuhxuUv7QERqwBOUrZ3Gmj/vgBmmEp8sdNxtsTTLXrGQlh9kdx6bEd+0UTKfWp396Xqz4oRmdyAFrzR7nWCn2YcWcD9O45yv8/5NbU18jd2C4r5N5ySA5l51KmQfLBzB61S98C97NfOqINDEZHephDdlDI58N9vwK5kaESwjI/bG1QCqET3I3TditDPZlLDnKIFHD3y8zUP12as7zJOXQmA2vWqxGfbaKn9zGs4RKA5G7z2zYGrz1yLiaZV6RTFfNJBL3FRiH5iXvxGqMj4rBGlbjhfU8YH5iaCFRoHGI6+LM0dV78vPkxx+/9UN1MUD2tno5VDR/hbd4neFuxGkCl77j8f/eHgxv1OG+YOVH3iJ1V2pTJAKiPcsXo7nxFMqLYyQVHeYh6Qx1VNSbXdZOuK0rmajacngKGiLB5zvWcyUbOe8d6DDjEhgMhfBJLDBn/igbUhDpDZ4y/TgYD+vO4HKGzUr5OoQnBgklAp0qfySQ2HAF9mrJVADsRetPsDpt7DmLE75bM0fU9konz93j2k5JCcPsaDEx910GTw8H99cx4YusE05NeEEDGpjiNOVkcOBL4ukWomBQIFuBclgQvrxw06f4hObubvC1ca/HNvoeWB8doA6nWdwf+HlgyHHZrmPMGJaZYfxXN76RDVnZyJmVBYgLjZPTRenRMd
 n7P+/hGy
 U8Aj3hbMcJxpKWt+n9AZ5AXY1+JMN+tZ20wxuPPArs/L0m4ts7FOoePWeRjG2zSTKc/bXC8uq+ZY4o4b7zgbTqs/26dIdWNaEV0hCRAQp/Mt1jQCr7h8ZRdT9L7B0t+1332dU/566QyOf2+I9BMsR/thTJ4vw/aRl+GXheVeYO+SafZZdd152gZ13G0Ec8DOlONcSDNQ5iMzEsrs=
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
 fs/proc/task_mmu.c | 46 ++++++++++++++++++++++++-------------
 mm/hmm.c           |  3 ++-
 mm/huge_memory.c   | 56 ++++++++++++++++++++++++++++++++++++----------
 mm/khugepaged.c    |  6 +++++
 mm/madvise.c       | 14 +++++++++++-
 mm/mincore.c       | 45 ++++++++++++++++++++++++++++++++++++-
 6 files changed, 139 insertions(+), 31 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 817e3e0f9194..77e591f0eec6 100644
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
index c7fc2f5d7238..eb2a66030438 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2348,6 +2348,14 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
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
@@ -2372,6 +2380,21 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2422,15 +2445,6 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2523,6 +2537,16 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2555,7 +2579,8 @@ static inline int pmd_move_must_withdraw(spinlock_t *new_pmd_ptl,
 static pmd_t move_soft_dirty_pmd(pmd_t pmd)
 {
 	if (pgtable_supports_soft_dirty()) {
-		if (unlikely(pmd_is_migration_entry(pmd)))
+		if (unlikely(pmd_is_migration_entry(pmd) ||
+			     pmd_is_swap_entry(pmd)))
 			pmd = pmd_swp_mksoft_dirty(pmd);
 		else if (pmd_present(pmd))
 			pmd = pmd_mksoft_dirty(pmd);
@@ -2646,7 +2671,14 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
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
@@ -2706,7 +2738,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (!ptl)
 		return 0;
 
-	if (thp_migration_supported() && pmd_is_valid_softleaf(*pmd)) {
+	if (pmd_is_valid_softleaf(*pmd)) {
 		change_non_present_huge_pmd(mm, addr, pmd, uffd_prot,
 					    uffd_prot_resolve);
 		goto unlock;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 27e8f3077e80..f9c00f5ef2e3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1101,6 +1101,12 @@ static inline enum scan_result check_pmd_state(pmd_t *pmd)
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
index 07a21ca31bad..81ccdd6a5140 100644
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
index ff4ac8281768..3f0fba964c8a 100644
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


