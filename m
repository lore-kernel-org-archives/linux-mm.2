Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97814C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:40:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5A16B00C7; Fri,  3 Jul 2026 13:40:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BBD06B00C9; Fri,  3 Jul 2026 13:40:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1CF6B00CA; Fri,  3 Jul 2026 13:40:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C75F6B00C7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:40:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 98A76120255
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:40:21 +0000 (UTC)
X-FDA: 84948179442.19.C126F33
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id B91F8100006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:40:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wj6r/lz6";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783100420;
	b=kuI3aWL8+2436iASbLpfhfsd2XR0+sA1FMVz6U/hmHdsNeDXl/V4lE8u2jsE+pqI4UOLkE
	7ESXlnmfyTdJdskhwx/V5LTNGWjhIcpuwnF1ft96S3HKflRzwTUyDSFUMZfqjQZoVNFOv6
	1PMJZQakdWzJp+TR0E3FOenAn0NpYM4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783100420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17YwIXwp8sdfvUHHlM/iJ+YBYVw2D5WP9Z4XpuTwiAA=;
	b=fCqvgsE/6AF5lNMePnQR4dnnTnqHvUE9lVdPckk2LDlm8r8HuR4JO2eH50ys1ZhexajnHr
	1B1iVOM3E6DWm0jLWbTIvd9a1Bxw5JQ/tOMaN8ogkz5dZxB7jDlepm9vNoHgOaKR4L1YfN
	2+IpfH/hO5PUxLYCEfT1MzZzCkD5u98=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wj6r/lz6";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783100418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=17YwIXwp8sdfvUHHlM/iJ+YBYVw2D5WP9Z4XpuTwiAA=;
	b=wj6r/lz65P4rNZIpHyyHdp/7YtUCHx5X+HpjJxe9H8M0waNJoW9a0qy04YTIJSFFmFQNmI
	1cpqYTQpsMk03skU9UFiCQ9r34A3Xkc7QZFfsQsGYa8yPnD2rn1FaKfr6U/xH1BeXKJtZT
	7MzKALjXCCMNtVuQkFGy+f3ETXRFcGs=
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
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 09/11] mm: handle PMD swap entry faults on swap-in
Date: Fri,  3 Jul 2026 10:38:26 -0700
Message-ID: <20260703173903.3789516-10-usama.arif@linux.dev>
In-Reply-To: <20260703173903.3789516-1-usama.arif@linux.dev>
References: <20260703173903.3789516-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B91F8100006
X-Stat-Signature: wm4wx556fibcm81m55qgfduw1jmh49xe
X-Rspam-User: 
X-HE-Tag: 1783100419-615676
X-HE-Meta: U2FsdGVkX19lNxw9IkQ7ROuwzaXh/Q6P3A0eTog2KVf/W676nQW4Us4/UGzViKLu4TMr2+OIPBQ+fXZrCtnjTj/4CzaLkHOtrEyRZAib5MEn6OAIf43i/qpZYoFsbNw8TBHGOvzU6uSwdomSvntEFZKFtibq1Wg8yYzOmDSfSfxFuT96V2Aknrxe3NzpoBAp+9Fx74CzZdA7rk9X8Q97vD1kJcr6w6YlZX71LD1PYgBs/tIDg5XtinrG82XXyiPOP2ulZp6P5asbDCyrSpQ3zu9QGkIukophUDcsQjNhK+M/qw/KMK17ZhzhUFn4kHJuCvMPOnsUBtj33bAWm8NR1lFqPNcbyz0rAXXL22yYGF6KAsGqrRu3v3VJsyrlO+H40j/BNgJzCGWQuZ+K9hgOsB1M2Wi5r7lzZghBJgSSpV8nD5M6IKQ/5o/D80JFJ85RAVPIp5ZVc/quiRKriYENwpeaEYvL6pR9ncigblHa0SXVrBJbMYRLjh0O6Y88ok74l5u8L29pi0T5mR/CT/xCP8+6svFXhb7lMROpZmCZNm8XI45SSEoHYteaFTVjTZrbkTKzQPK1InlBbulbToHXIeP7UPDGT/KqnszSJR+o9MRgVjvqji0n8Ta+6R6OWWhBhSPWMyz41Dk5PydcQ4ZVTUowHlZ1sjcyimrusXRTPxZ6pUmmCcccy5hAPspFfo04/8EjQHo5HBW1M5HtWF2mi1yF+vIpGwW5Quia3bTLZ3+kKZxgXGxAMK/cBv9KkE5HLMKyIyB66yfyCc9EAZeXQHukYZex96Yi0F2lE97iF/gMTuU2z+5li+DbvCjWY/ho7wuWX/ppj95XnWK4B2w6cKr0ZfFhaEIhjE+dUHKLXFIeEGPPUj6IxXjQ+vAvPlofpBySrRMBtG+/7Zm4rCbxK+rQOZGiceXLfPn8P5wsTFHS+3eeImRgkGS+LLmfC4OaOrBHgBOwnGKYoBjOdl9
 RqPb02Q1
 QF6iN2vg3++MSQB26NgbGAVcucS9YTZe9H+M+mMK9cayYaq8d+pvRxp/5uxHXShpdxrTdPR5cdbwhbs+BAIl83nHX3e/hJqFPtSiCPXGY+DEHNYtjxl1Uar4p4XDVltaPavQp+u3zloqS9Q3CBS/LU4G8sTLuKUDyMvtt369gmYB2ydh8i0jZ43NFdAvKxw7JFX8Dv47eDKdL5854tjwUR35yAdRAypqoA6N5Ubw98MG/JXs=
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
    PMD-order folio via swap_cache_alloc_folio() and read from swap.

  - After locking, re-validate that the folio still corresponds to our
    entry and is still PMD-sized.  Between the unlocked cache lookup
    and the lock, a racing swap-in on the same entry may have removed
    it from the cache via folio_free_swap(), or reclaim / memory_failure
    / deferred-split may have split the folio into smaller folios.

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
 mm/huge_memory.c        | 216 ++++++++++++++++++++++++++++++++++++++++
 mm/internal.h           |  36 +++++++
 mm/memory.c             |  40 +-------
 4 files changed, 265 insertions(+), 36 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 1487bf4af1a7..9ec475ccfc91 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -531,6 +531,15 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
 
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
index fdc1a503c609..5fa60324a2f0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -41,6 +41,7 @@
 #include <linux/pgalloc.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#include <linux/zswap.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -2312,6 +2313,221 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
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
+		if (zswap_range_has_entry(swp_entry, HPAGE_PMD_NR))
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
+		if (zswap_range_has_entry(swp_entry, HPAGE_PMD_NR)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			goto split_fallback;
+		}
+		ret = VM_FAULT_SIGBUS;
+		goto out_page;
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
+	if (pmd_swp_uffd_wp(vmf->orig_pmd))
+		pmd = pmd_mkuffd_wp(pmd);
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
+	if (should_try_to_free_swap(si, folio, vma, 1, vmf->flags))
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
index fa4fb69444ec..5c7f5b408ba3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -506,6 +506,42 @@ static inline vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
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
+					   unsigned int extra_refs,
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
+	/*
+	 * If we want to map a page that's in the swapcache writable, we
+	 * have to detect via the refcount if we're really the exclusive
+	 * user. Try freeing the swapcache to get rid of the swapcache
+	 * reference only in case it's likely that we'll be the exclusive user.
+	 */
+	return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
+		folio_ref_count(folio) == (extra_refs + folio_nr_pages(folio));
+}
+
 void folio_rotate_reclaimable(struct folio *folio);
 bool __folio_end_writeback(struct folio *folio);
 void deactivate_file_folio(struct folio *folio);
diff --git a/mm/memory.c b/mm/memory.c
index e0819a562187..478b54423713 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4497,40 +4497,6 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
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
-					   unsigned int extra_refs,
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
-	/*
-	 * If we want to map a page that's in the swapcache writable, we
-	 * have to detect via the refcount if we're really the exclusive
-	 * user. Try freeing the swapcache to get rid of the swapcache
-	 * reference only in case it's likely that we'll be the exclusive user.
-	 */
-	return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
-		folio_ref_count(folio) == (extra_refs + folio_nr_pages(folio));
-}
-
 static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
 {
 	vmf->pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
@@ -6200,8 +6166,7 @@ static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
 	return VM_FAULT_FALLBACK;
 }
 
-/* `inline' is required to avoid gcc 4.1.2 build error */
-static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
+vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
@@ -6486,6 +6451,9 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 
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


