Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DDEBC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8707B6B0093; Wed, 22 Jul 2026 11:22:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 820D06B009D; Wed, 22 Jul 2026 11:22:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E9716B009F; Wed, 22 Jul 2026 11:22:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 453B16B0093
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:22:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CBD601401ED
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:22:41 +0000 (UTC)
X-FDA: 85016779722.30.5F79481
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9FEA012000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:22:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BPlGlGR0;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784733759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=esU3MsmXGHGrCKv4sOstR9rmv0YJpIS7m5z92IC6DMg=;
	b=2jjaPIKVTY7e6uSrDyyNGUFTft2XKkGU0eWXSsASexQtCqynALK+uzLoVuO2JIOcGbCNsi
	OFqV2QOEaMI5jACet6jMzxRqftzdkz012mIKf5n1ivwuXLD497S1n73AsUEsZCz66pEqgA
	wjhcLbkBBQ8ptwxunP5595KsITfLiiQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784733759;
	b=tcmCKc7ODiXz+TONT/HWouFuq3KYlHb8tcsHMrxuZwPkjUucdhVLUYpBv7i/bquKoMUiv0
	BojR+lmQt7MzE4yyYwkmAdnaEPCkEKmeoFG1usn/yoLHM68KzdvwW2j1KFmUOOEK+hp4bD
	0u0ZgmC09Og/CPN8h3xmtXdxymKGoIc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BPlGlGR0;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784733757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=esU3MsmXGHGrCKv4sOstR9rmv0YJpIS7m5z92IC6DMg=;
	b=BPlGlGR0CY+cZaoDve/0ofydvLXzbGYK67Ngw44GjVADffZ8c/Zqo+KPa0NavOboOgGCqj
	Kd8y64qWX3nmQD8ZbD5K0g8yBnnyIyyLJDRQHG5z64/e7St3a1fiY1Rnd9PTmSKJPrDC94
	9G73/JeB32AZHLRHe0yLJSCOC6wOYH0=
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
Subject: [PATCH v5 09/11] mm: handle PMD swap entry faults on swap-in
Date: Wed, 22 Jul 2026 08:19:40 -0700
Message-ID: <20260722152043.2273289-10-usama.arif@linux.dev>
In-Reply-To: <20260722152043.2273289-1-usama.arif@linux.dev>
References: <20260722152043.2273289-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9FEA012000C
X-Stat-Signature: f1rad7xbwq9ecsogmrxkz1okh3k7z3dw
X-Rspam-User: 
X-HE-Tag: 1784733759-189152
X-HE-Meta: U2FsdGVkX1+YHnGOzDYMUAF6WSjm7RN1U8PYZyjHPHyZ0NFTrBhvjfiyu0wcFV+V1jAJZ4c3pASxfVRdKSlMpC6uHnoAxWx3mAEWHjq2r41pxAWn6i9vczcvxiRZChT3EpvaGKTWYr+eJkEWF+cbJIilkYjd/TzTBNbUHvj/XwlYhcvdgZcFDP3lnps8pqlAzpRjnQ8gwWW88XFJ0E/OlQ7y2gnZ34ZIc5X+7OnbFBV/OG2yVHJKm/54jOZrUl3Sxy/DJ4MIjhiJRuQrQ63UEi4HYhSWhPL2sMGf1GPxZfTpcsK88tbK38KUZNTeE4t2GnglwlboTCW/O7LKec2hol0s8ADqzmUSm1yO/8aXZgHXYlY9bwxVebXcpu+j0UAKUnPUhWt0rCChiX6C/Fy0mhhnhmtvKC4GHj4Fu74xfoVAE0UWzidbCILuutwNGgwm2wx5n9F0zrwBTLUhZJNoz5kMkRPgePuAz8T9PrKM2ELX3XpXO7nyGiKigr33BVilopsSxFpyQsQswRnbMHwqHXgfsCnviA4CjySOfhLx32xEc4WPhbQ6XdL9gPt5PcxUxIFF7gyJKp7ZG/yySVYjaWP76JXv3hFJQLLrHgG8HQH1a1kI/6WBiDtpdmvmFvbrh/ld3LtzkTQGUt6vQdlr9B8H1ZxpRbP+ZBYwQLroC7RXYRRbw7VLMcUTH+gQ4ej7DKWNwDYbVT3k5XQ36ANzC53o5gusvZUexZ+FQVj0IOhKVSLJKtsc7QBnnwVTbKm3b3cIc/r8+YZJSll4A4yKBtvv8bDKWGECThYHjfN/F/16muERyJ5lKyffkckI9+grUeR0zzL2endp6kcoYCCyU/gCVHb+HO8ww/mE3BSn3UhRdMWmDRrLAhY1cpf8Wuz03bwPz47ZRScqgE9dJQF+L2c9Wl6mbR7FxgJ87xH4+K4XArBpEJAJPMA9aHaPs3R2ZIIpBGeKpukEt8iGuE9
 aaV/fE9i
 fClJGOS8D4li31/iBDtZriopT/Mej1gieOx8ptmhy3H0EYE2MxYv1uECz5q6Vxt1CcQVyNMAX9zFQhfjyg7WOhZXN9hrk3U+cG3gIU6JJ2i9IjuSVi569iUfRrHCXexB3pUdr1Uw//SHs8Rrn7LsGkdZPZlBcMOsf97bNbGsV3gAzKBxYpS1kBR2p52Ity1hGYJGvUTZz6AD2dL0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add do_huge_pmd_swap_page() and dispatch to it from __handle_mm_fault()
when vmf->orig_pmd encodes a swap entry.  The handler resolves the
entire 2 MB mapping in one shot, mirroring do_swap_page() (PTE path)
at PMD granularity:

  - Look up the folio in the swap cache; on a miss, allocate a
    PMD-order folio via swapin_sync(BIT(HPAGE_PMD_ORDER)) and read
    from swap.  This deliberately skips the existing order-0 swap
    readahead paths: the fault already asks for the whole PMD range,
    while order-0 readahead would populate per-page swap cache state
    and force the PMD swap entry to split.  If the range already has
    per-page swap-cache or zswap state, split and retry through PTEs.

  - After locking, re-validate that the folio still corresponds to our
    entry and is still PMD-sized.  Between the unlocked cache lookup
    and the lock, a racing swap-in on the same entry may have removed
    it from the cache via folio_free_swap(), or reclaim / memory_failure
    / deferred-split may have split the folio into smaller folios.

  - Refuse to map a folio that contains a hardware-poisoned subpage.
    On a hit, split the PMD swap entry so do_swap_page() can return
    VM_FAULT_HWPOISON per subpage, matching the PTE swap-in
    PageHWPoison check.  Disable large-folio PTE batching for such a
    folio so the fallback cannot map the poisoned subpage as part of
    a batch.

  - Restore soft_dirty and uffd_wp from the swap PMD.  For an RWP VMA,
    also restore PAGE_NONE so the next access reaches userfaultfd.
    Map writable only when the entry was exclusive, the VMA permits
    writes, and uffd-wp is not armed.  Drop the exclusive marker when
    the cached folio is under writeback to an SWP_STABLE_WRITES backend
    (zram) so the PMD is mapped read-only; a later write COWs
    into a fresh folio rather than corrupting the in-flight writeback.
    Mirrors do_swap_page().

  - When the resulting PMD is read-only but the fault was a write,
    update vmf->orig_pmd and call wp_huge_pmd() in the same handler
    to COW immediately rather than forcing a second fault.  Leave an
    RWP-restored PMD for userfaultfd instead.  Mask VM_FAULT_FALLBACK
    from the return: a PMD-COW that splits to PTE-level is normal, but
    the bit is part of VM_FAULT_ERROR and arch fault handlers BUG() on
    it without SIGBUS/HWPOISON/SIGSEGV.

  - Free the swap slot via should_try_to_free_swap() (hoisted from
    mm/memory.c into mm/internal.h so PTE- and PMD-level swap-in share
    the heuristic).  Preserve FAULT_FLAG_WRITE until this check so an
    exclusive write fault can release its swap slot.

When PMD-order resources are unavailable (folio allocation fails,
the cached folio was split, memcg charge fails, or swap-cache insertion
races) split the PMD swap entry into 512 PTE swap entries via
__split_huge_pmd() and return 0.  The fault retries and do_swap_page()
takes over per-PTE.  This avoids returning VM_FAULT_OOM for transient
PMD-order allocation failures.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/huge_mm.h |  14 +++
 mm/huge_memory.c        | 227 ++++++++++++++++++++++++++++++++++++++++
 mm/internal.h           |  34 ++++++
 mm/memory.c             |  41 ++------
 4 files changed, 281 insertions(+), 35 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c745f7ad2298..e7107e0991ad 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -552,6 +552,15 @@ vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf);
 
 vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
 
+#ifdef CONFIG_THP_SWAP
+vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf);
+#else
+static inline vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf)
+{
+	return 0;
+}
+#endif
+
 extern struct folio *huge_zero_folio;
 extern unsigned long huge_zero_pfn;
 
@@ -754,6 +763,11 @@ static inline vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
 	return 0;
 }
 
+static inline vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf)
+{
+	return 0;
+}
+
 static inline bool is_huge_zero_folio(const struct folio *folio)
 {
 	return false;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 07c421a16fda..6ef56936ced4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -41,6 +41,7 @@
 #include <linux/pgalloc.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#include <linux/zswap.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -2348,6 +2349,232 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	return 0;
 }
 
+#ifdef CONFIG_THP_SWAP
+/**
+ * do_huge_pmd_swap_page() - Handle a fault on a PMD-level swap entry.
+ * @vmf: Fault context. vmf->orig_pmd contains the swap PMD.
+ *
+ * A PMD swap entry is a compact encoding for HPAGE_PMD_NR consecutive swap
+ * slots. If the swap cache still has one PMD-sized folio covering the range,
+ * map it directly at PMD level. If the range has been split into per-page
+ * cache state, or zswap may have per-page state for it, split the PMD swap
+ * entry and retry at PTE granularity.
+ *
+ * Return: VM_FAULT_* flags.
+ */
+vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	struct mm_struct *mm = vma->vm_mm;
+	struct folio *folio;
+	struct page *page;
+	struct swap_info_struct *si;
+	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
+	softleaf_t entry;
+	swp_entry_t swp_entry;
+	pmd_t pmd;
+	vm_fault_t ret = 0;
+	bool exclusive, rwp_restore = false;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
+	rmap_t rmap_flags = RMAP_NONE;
+	enum swap_pmd_cache cache_state;
+
+	entry = softleaf_from_pmd(vmf->orig_pmd);
+	if (unlikely(!softleaf_is_swap(entry)))
+		return 0;
+
+	swp_entry = entry;
+
+	/* Prevent swapoff from happening to us. */
+	si = get_swap_device(swp_entry);
+	if (unlikely(!si))
+		return 0;
+
+	cache_state = swap_pmd_cache_lookup(swp_entry, &folio);
+	if (cache_state == SWAP_PMD_CACHE_SPLIT)
+		goto split_fallback;
+	if (!folio) {
+		/*
+		 * PMD swap entries encode ordinary per-page swap slots. If any
+		 * slot is in zswap, split and let the PTE swap path load the
+		 * range per page. Otherwise the range is all on disk and can be
+		 * read back as one PMD-sized folio.
+		 */
+		if (zswap_is_present(swp_entry, HPAGE_PMD_NR))
+			goto split_fallback;
+
+		folio = swapin_sync(swp_entry, GFP_HIGHUSER_MOVABLE,
+				    BIT(HPAGE_PMD_ORDER), vmf, NULL, 0);
+		if (IS_ERR_OR_NULL(folio))
+			goto split_fallback;
+
+		/* Had to read from swap area: Major fault */
+		ret = VM_FAULT_MAJOR;
+		count_vm_event(PGMAJFAULT);
+		count_memcg_event_mm(mm, PGMAJFAULT);
+	}
+
+	ret |= folio_lock_or_retry(folio, vmf);
+	if (ret & VM_FAULT_RETRY)
+		goto out_release;
+
+	/* Verify the folio is still in swap cache and matches our entry */
+	if (unlikely(!folio_matches_swap_entry(folio, swp_entry)))
+		goto out_page;
+
+	/*
+	 * Folio should be PMD-sized; if not (e.g. split in swap cache),
+	 * split the PMD swap entry and retry at PTE level.
+	 */
+	if (folio_nr_pages(folio) != HPAGE_PMD_NR) {
+		folio_unlock(folio);
+		folio_put(folio);
+		goto split_fallback;
+	}
+
+	if (unlikely(!folio_test_uptodate(folio))) {
+		if (zswap_is_present(swp_entry, HPAGE_PMD_NR)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			goto split_fallback;
+		}
+		ret = VM_FAULT_SIGBUS;
+		goto out_page;
+	}
+
+	/*
+	 * If any subpage is hardware-poisoned, split the PMD swap entry and
+	 * let the PTE swap-in path handle each page individually so
+	 * do_swap_page() can return VM_FAULT_HWPOISON for the poisoned
+	 * subpage rather than mapping the corrupted memory as one THP.
+	 */
+	if (unlikely(folio_contain_hwpoisoned_page(folio))) {
+		folio_unlock(folio);
+		folio_put(folio);
+		goto split_fallback;
+	}
+
+	page = folio_page(folio, 0);
+	arch_swap_restore(folio_swap(swp_entry, folio), folio);
+
+	folio_throttle_swaprate(folio, GFP_KERNEL);
+
+	/* Lock the PMD and verify it hasn't changed */
+	vmf->ptl = pmd_lock(mm, vmf->pmd);
+	if (unlikely(!pmd_same(vmf->orig_pmd, pmdp_get(vmf->pmd)))) {
+		spin_unlock(vmf->ptl);
+		goto out_page;
+	}
+
+	exclusive = pmd_swp_exclusive(vmf->orig_pmd);
+
+	/*
+	 * Some swap backends (e.g. zram) don't support concurrent page
+	 * modifications while under writeback. If we map exclusive on such
+	 * a backend while the folio is still under writeback, the writeback
+	 * may see partial modifications and corrupt the swap slot. Drop the
+	 * exclusive marker and only map R/O for that case; further GUP
+	 * references can't appear once the page is fully unmapped, so this
+	 * is safe.
+	 */
+	if (exclusive && folio_test_writeback(folio) &&
+	    data_race(si->flags & SWP_STABLE_WRITES))
+		exclusive = false;
+
+	/*
+	 * Set up the PMD mapping. Similar to do_swap_page() but at PMD level.
+	 */
+	add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
+	add_mm_counter(mm, MM_SWAPENTS, -HPAGE_PMD_NR);
+
+	pmd = folio_mk_pmd(folio, vma->vm_page_prot);
+	pmd = pmd_mkyoung(pmd);
+
+	if (pmd_swp_soft_dirty(vmf->orig_pmd))
+		pmd = pmd_mksoft_dirty(pmd);
+	if (pmd_swp_uffd(vmf->orig_pmd))
+		pmd = pmd_mkuffd(pmd);
+	if (pmd_swp_uffd(vmf->orig_pmd) && userfaultfd_rwp(vma)) {
+		pmd = pmd_modify(pmd, PAGE_NONE);
+		rwp_restore = true;
+	}
+
+	/*
+	 * Check exclusivity to determine if we can map writable.
+	 */
+	if (exclusive) {
+		if (!rwp_restore && (vma->vm_flags & VM_WRITE) &&
+		    !userfaultfd_huge_pmd_wp(vma, pmd) &&
+		    !pmd_needs_soft_dirty_wp(vma, pmd)) {
+			pmd = pmd_mkwrite(pmd, vma);
+			if (write)
+				pmd = pmd_mkdirty(pmd);
+		}
+		rmap_flags |= RMAP_EXCLUSIVE;
+	}
+
+	flush_icache_pages(vma, page, HPAGE_PMD_NR);
+
+	if (!folio_test_anon(folio))
+		folio_add_new_anon_rmap(folio, vma, haddr, rmap_flags);
+	else
+		folio_add_anon_rmap_pmd(folio, page, vma, haddr, rmap_flags);
+
+	folio_put_swap(folio, NULL);
+
+	set_pmd_at(mm, haddr, vmf->pmd, pmd);
+	update_mmu_cache_pmd(vma, haddr, vmf->pmd);
+
+	/* Update orig_pmd for any follow-up wp_huge_pmd() below. */
+	vmf->orig_pmd = pmd;
+
+	/*
+	 * Conditionally try to free up the swap cache. Do it after mapping,
+	 * so raced page faults will likely see the folio in swap cache and
+	 * wait on the folio lock.
+	 */
+	if (should_try_to_free_swap(si, folio, vma, exclusive, vmf->flags))
+		folio_free_swap(folio);
+
+	spin_unlock(vmf->ptl);
+
+	folio_unlock(folio);
+	put_swap_device(si);
+
+	/*
+	 * If the write fault wasn't satisfied above (folio is shared without
+	 * exclusivity), call wp_huge_pmd() to handle COW or
+	 * userfaultfd-wp without forcing a second fault.
+	 *
+	 * wp_huge_pmd() may return VM_FAULT_FALLBACK if it had to split the
+	 * PMD; that's a normal outcome, and the natural PTE-level refault will
+	 * complete the COW. Mask it so callers (and the arch fault handler)
+	 * don't see VM_FAULT_FALLBACK as a fatal VM_FAULT_ERROR.
+	 */
+	if (write && !pmd_write(pmd) && !rwp_restore) {
+		vm_fault_t wp_ret = wp_huge_pmd(vmf);
+
+		wp_ret &= ~VM_FAULT_FALLBACK;
+		ret |= wp_ret;
+		if (ret & VM_FAULT_ERROR)
+			ret &= VM_FAULT_ERROR;
+	}
+
+	return ret;
+
+out_page:
+	folio_unlock(folio);
+out_release:
+	folio_put(folio);
+	put_swap_device(si);
+	return ret;
+
+split_fallback:
+	__split_huge_pmd(vma, vmf->pmd, haddr, false);
+	put_swap_device(si);
+	return 0;
+}
+#endif /* CONFIG_THP_SWAP */
 static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 {
 	pgtable_t pgtable;
diff --git a/mm/internal.h b/mm/internal.h
index 51ee4c131090..b303b5d6162e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -581,6 +581,40 @@ static inline vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
 }
 
 vm_fault_t do_swap_page(struct vm_fault *vmf);
+vm_fault_t wp_huge_pmd(struct vm_fault *vmf);
+
+/*
+ * Check if we should call folio_free_swap to free the swap cache.
+ * folio_free_swap only frees the swap cache to release the slot if swap
+ * count is zero, so we don't need to check the swap count here.
+ */
+static inline bool should_try_to_free_swap(struct swap_info_struct *si,
+					   struct folio *folio,
+					   struct vm_area_struct *vma,
+					   bool exclusive,
+					   unsigned int fault_flags)
+{
+	if (!folio_test_swapcache(folio))
+		return false;
+	/*
+	 * Always try to free swap cache for SWP_SYNCHRONOUS_IO devices. Swap
+	 * cache can help save some IO or memory overhead, but these devices
+	 * are fast, and meanwhile, swap cache pinning the slot deferring the
+	 * release of metadata or fragmentation is a more critical issue.
+	 */
+	if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+		return true;
+	if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
+	    folio_test_mlocked(folio))
+		return true;
+
+	/*
+	 * Free the swapcache only if we are the exclusive user and
+	 * this is a write fault.
+	 */
+	return (fault_flags & FAULT_FLAG_WRITE) && exclusive;
+}
+
 void folio_rotate_reclaimable(struct folio *folio);
 bool __folio_end_writeback(struct folio *folio);
 void deactivate_file_folio(struct folio *folio);
diff --git a/mm/memory.c b/mm/memory.c
index c64e11fc7180..f4ab24a49d0d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4636,38 +4636,6 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 	return 0;
 }
 
-/*
- * Check if we should call folio_free_swap to free the swap cache.
- * folio_free_swap only frees the swap cache to release the slot if swap
- * count is zero, so we don't need to check the swap count here.
- */
-static inline bool should_try_to_free_swap(struct swap_info_struct *si,
-					   struct folio *folio,
-					   struct vm_area_struct *vma,
-					   bool exclusive,
-					   unsigned int fault_flags)
-{
-	if (!folio_test_swapcache(folio))
-		return false;
-	/*
-	 * Always try to free swap cache for SWP_SYNCHRONOUS_IO devices. Swap
-	 * cache can help save some IO or memory overhead, but these devices
-	 * are fast, and meanwhile, swap cache pinning the slot deferring the
-	 * release of metadata or fragmentation is a more critical issue.
-	 */
-	if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
-		return true;
-	if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
-	    folio_test_mlocked(folio))
-		return true;
-
-	/*
-	 * Free the swapcache only if we are the exclusive user and
-	 * this is a write fault.
-	 */
-	return (fault_flags & FAULT_FLAG_WRITE) && exclusive;
-}
-
 static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
 {
 	vmf->pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
@@ -5047,7 +5015,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	page_idx = 0;
 	address = vmf->address;
 	ptep = vmf->pte;
-	if (folio_test_large(folio) && folio_test_swapcache(folio)) {
+	if (folio_test_large(folio) && folio_test_swapcache(folio) &&
+	    !folio_contain_hwpoisoned_page(folio)) {
 		int nr = folio_nr_pages(folio);
 		unsigned long idx = folio_page_idx(folio, page);
 		unsigned long folio_start = address - idx * PAGE_SIZE;
@@ -6382,8 +6351,7 @@ static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
 	return VM_FAULT_FALLBACK;
 }
 
-/* `inline' is required to avoid gcc 4.1.2 build error */
-static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
+vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
@@ -6676,6 +6644,9 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 
 		if (pmd_is_migration_entry(vmf.orig_pmd))
 			pmd_migration_entry_wait(mm, vmf.pmd);
+		else if (IS_ENABLED(CONFIG_THP_SWAP) &&
+			 pmd_is_swap_entry(vmf.orig_pmd))
+			return do_huge_pmd_swap_page(&vmf);
 		return 0;
 	}
 	if (pmd_trans_huge(vmf.orig_pmd)) {
-- 
2.53.0-Meta


