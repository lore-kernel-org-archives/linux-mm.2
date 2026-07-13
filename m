Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36FB6C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D1446B011C; Mon, 13 Jul 2026 13:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4818D6B012E; Mon, 13 Jul 2026 13:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370DF6B012F; Mon, 13 Jul 2026 13:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0699D6B011C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:13:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3006C075A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:37:25 +0000 (UTC)
X-FDA: 84983855250.02.F115829
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id D80A880005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:37:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DxnVzgoF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783949844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HBpFn91MvbR629AVCu7mmit7ydRcm4nx9l1DfjdpkDY=;
	b=WjFFJdTpkvEsD4Z/beBP7M+leNnRJgiEhNr/dT2oOeVuVYOr2dZQpIp/REBH8wlBFZR1P4
	puPnFbjsjvYTgu/f9C/Ft/RQHbS0VJLInIuBl4v3Bu36Bz4abTKSMvGA2x357rESt1XjiR
	9ycFVFDc6+60OQmlhwEatdiSYv0eCyY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DxnVzgoF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783949844;
	b=mIGeEvjU8QZaDSNtYLdRkovAfEbHR8iNWhEkDCl5kSmIpnxmLeyimfYkMdXeLmL85tbX/8
	YKBiELaZHdTKQjuAaK/iOC0lEilPILNJgyA+NtUyXGvGSUTT5vuC32zRRopZ9YUmzBbHYZ
	cTXf+ymh8FWdbeue/qoQzdwnBY5hCv0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783949842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HBpFn91MvbR629AVCu7mmit7ydRcm4nx9l1DfjdpkDY=;
	b=DxnVzgoFccfS88yAHrsQu+PB9gljv8nn7Q+19HNhW7RyL5nGf4inPCk8jI6VZZaErYeJuU
	6xYqtxmkEPJB8m9+cAVKR/ESfmQ5C2n/g3B3E64CBnEqdcdu7c8qwLsB+gwZEMGxbUGh6o
	MTWAYeUvuzExsggUC0iIuJI4FfnqxzA=
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
Subject: [PATCH v4 09/11] mm: handle PMD swap entry faults on swap-in
Date: Mon, 13 Jul 2026 06:35:44 -0700
Message-ID: <20260713133613.2707815-10-usama.arif@linux.dev>
In-Reply-To: <20260713133613.2707815-1-usama.arif@linux.dev>
References: <20260713133613.2707815-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D80A880005
X-Stat-Signature: btiwjnf8cyoabfwbj4imdchzojwn9hcj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783949843-768820
X-HE-Meta: U2FsdGVkX18io0zikDuULrnseVSJID7XIW7MfZgHMFel/0T0roMrK97WGl5KgkHdWJ0mpuhH+dAzAjGUYsi2cYLNFhQz40VBYzxWuMBPnLK+GxOhz+kNonaSzXBtD04dQqy/6zBTPwrd7fxLPMXZq7KKnk1MnfXLi69PHzMLfeDrW1gVASFjrVFYk3wuDvbf2bqeA19vz+LWv+z57YtVcjsYNkxF6QeOrINAbzq52Wt8u+zjj6mf+Ri5Wmgbxxl6lY827p8d22gNGhmLjVhqHolGKO+nWy9QzjKs6opMTZYe+KZYnOfhJe0vGElfJ3We8HUX2KZGcmYDLwrgKu2TZa1z+0RYoJ2wBwBsLawhKb51j+Kx9D9VLVSF7OAkogf2rlxTNJeKPRGNcrotxziyroDRX/IMyKnBBzgMHxKZaF+s+p6PpyLaJD7isjH07VGhUGAOCwk95NpEoGTl/LDtDpALLlnF2ev5/S69rQO/J5AQ8sa0hpTcemcTZONGuoeoWmBg8H4GVhzCLBTeAg6zZ/v9LmmKB03Fufs6KvRHpjMiXczjB6/9NC56RGZgiLyYf4eQLwK9nrKTDneeOh9Xs5p9ePXGKWSKVWlOREsNnWNan/+8nMfQzGYG6/EQkrrsFQCdLI+6CjaImEBEtcvca38ljw8yCz5jC4qo03ms257ixhAQepJ8NIRxfTb01YLwJ3vJzoaoXzugItLRrX99uz54sdaUmYZ2mghfkfsAolCe+50kcKH4yBpuCNwdbxnBi748IirCJYo8DoOjNjkTSiBqIPJmTNVpgQNWQCu55XuMNQ/GVmvd6VlKBeX5hdxl9bRmDbWlsWtCr7gf4NJ5JA7x6Lpif/Gg2zlJDe5OGt4DzjWM2xDCElkVeThLCXg2DwleWaWU8dJebFrZAVE9tKKtoJOORVJxJ5OhDQREwOQV1IXF7PAEXiUwtbMBQn32HXlWPKUM9z11hUozYnK
 vjdv76tF
 +MUFwHrv4FbQkeeq0tYOM/GAngQTBbnImnTRKtAYZqMZxzq0ntEbYRpUvNetKS9dQ1B/Q+QGRB48+zkgKrmgKLzBkOwI7com1Iwy2c3+L5XZn5A5LXPfps528l23BYwhumPqEWBnAYUGVwrRil1EWC7S8OyRzHzZMm/sUbZFS85QgfZr2c4A4gGI8ICNNA9ppV2ZpV1U3ArbZFT7q4eyKvikmA+x6otkXp6muq46536u1NAc=
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
    and force the PMD swap entry to split.

  - After locking, re-validate that the folio still corresponds to our
    entry and is still PMD-sized.  Between the unlocked cache lookup
    and the lock, a racing swap-in on the same entry may have removed
    it from the cache via folio_free_swap(), or reclaim / memory_failure
    / deferred-split may have split the folio into smaller folios.

  - Refuse to map a folio that contains a hardware-poisoned subpage:
    folio_contain_hwpoisoned_page() covers PG_hwpoison on the head
    and PG_has_hwpoisoned on a large folio.  On a hit, split the PMD
    swap entry so do_swap_page() can return VM_FAULT_HWPOISON per
    subpage, matching the PTE swap-in PageHWPoison check.

  - Restore soft_dirty and uffd_wp from the swap PMD.  Map writable
    only when the entry was exclusive, the VMA permits writes, and
    uffd-wp is not armed.  Drop the exclusive marker when the cached
    folio is under writeback to an SWP_STABLE_WRITES backend (zram,
    encrypted) so the PMD is mapped read-only; a later write COWs
    into a fresh folio rather than corrupting the in-flight writeback.
    Mirrors do_swap_page().

  - When the resulting PMD is read-only but the fault was a write,
    update vmf->orig_pmd and call wp_huge_pmd() in the same handler
    to COW immediately rather than forcing a second fault.  Mask
    VM_FAULT_FALLBACK from its return: a PMD-COW that splits to
    PTE-level is normal, but the bit is part of VM_FAULT_ERROR and
    arch fault handlers BUG() on it without SIGBUS/HWPOISON/SIGSEGV.
    Requires exposing wp_huge_pmd() via mm/internal.h.

  - Free the swap slot via should_try_to_free_swap() (hoisted from
    mm/memory.c into mm/internal.h so PTE- and PMD-level swap-in
    share the heuristic).

When PMD-order resources are unavailable (folio allocation fails,
the cached folio was split, memcg charge fails, or swapin_folio()
races) split the PMD swap entry into 512 PTE swap entries via
__split_huge_pmd() and return 0.  The fault retries and do_swap_page()
takes over per-PTE.  This avoids returning VM_FAULT_OOM for transient
PMD-order allocation failures.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/huge_mm.h |   9 ++
 mm/huge_memory.c        | 228 ++++++++++++++++++++++++++++++++++++++++
 mm/internal.h           |  34 ++++++
 mm/memory.c             |  38 +------
 4 files changed, 275 insertions(+), 34 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index cae97c307280..b6ab28ff7eee 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -534,6 +534,15 @@ vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf);
 
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
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b8e3566bd502..60f42d136945 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -41,6 +41,7 @@
 #include <linux/pgalloc.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#include <linux/zswap.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -2347,6 +2348,233 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
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
+	bool exclusive;
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
+	if ((vmf->flags & FAULT_FLAG_WRITE) && !folio_test_lru(folio))
+		lru_add_drain();
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
+
+	/*
+	 * Check exclusivity to determine if we can map writable.
+	 */
+	if (exclusive || folio_ref_count(folio) == 1) {
+		if ((vma->vm_flags & VM_WRITE) &&
+		    !userfaultfd_huge_pmd_wp(vma, pmd) &&
+		    !pmd_needs_soft_dirty_wp(vma, pmd)) {
+			pmd = pmd_mkwrite(pmd, vma);
+			if (vmf->flags & FAULT_FLAG_WRITE) {
+				pmd = pmd_mkdirty(pmd);
+				vmf->flags &= ~FAULT_FLAG_WRITE;
+			}
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
+	 * exclusivity), fall through to wp_huge_pmd to handle COW or
+	 * userfaultfd-wp without forcing a second fault.
+	 *
+	 * wp_huge_pmd() may return VM_FAULT_FALLBACK if it had to split the
+	 * PMD; that's a normal outcome — the natural PTE-level refault will
+	 * complete the COW. Mask it so callers (and the arch fault handler)
+	 * don't see VM_FAULT_FALLBACK as a fatal VM_FAULT_ERROR.
+	 */
+	if (vmf->flags & FAULT_FLAG_WRITE) {
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
+
 static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 {
 	pgtable_t pgtable;
diff --git a/mm/internal.h b/mm/internal.h
index 874be94cf257..660cb27c216a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -573,6 +573,40 @@ static inline vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
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
index 21ea76bb4c37..08baf528d4a4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4585,38 +4585,6 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
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
@@ -6331,8 +6299,7 @@ static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
 	return VM_FAULT_FALLBACK;
 }
 
-/* `inline' is required to avoid gcc 4.1.2 build error */
-static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
+vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
@@ -6625,6 +6592,9 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 
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


