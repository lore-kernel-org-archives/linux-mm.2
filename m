Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA11606D80E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TtgwYx2n
Received: by kanga.kvack.org (Postfix)
	id ADD4B6B05E5; Thu,  5 Nov 2026 13:42:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6B06B05E6; Thu,  5 Nov 2026 13:42:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E276B05E7; Thu,  5 Nov 2026 13:42:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D6156B05E5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:42:27 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0EE121A0AC9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:42:27 +0000 (UTC)
X-FDA: 85401935934.18.2039412
Received: from mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0935A4000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:42:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TtgwYx2n;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6esBgGh5jDKNWtibMkPGNCE/6xkWcnA550BdMNN02xs=;
	b=D7f/X2Ne79tGUJQLE9KLQA8jLD8fw8WO6+Gy+69eaDr4b4x4v8u9ojocxTNEcHE2YxudUP
	FZKKuC19pVZP+zzzFmyDCw0KRImWYLeO3klbtkadB1XtqT4/ITOcdPLR4ahnvW/7uWP6PE
	mM/nNMe5FZAwYY4cIsT2Z9bmbnqw46M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904145;
	b=F10ddzPXkcSzW8989lMu/OExQKrfku0OGpbJ1ut/iPW/T6QYJif6yb0id5fUtnk8jegYJi
	RPY9L9MNSeuQ3Wl/H42QNMN4R6xfwysCpnJW9+RKnA307OM4A6GkQbVePugWaURrwHx5eq
	tf36dOftZaGC+Zsiku93E8G3cI31PQo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TtgwYx2n;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=T2VX3aNbxu7I8Bh6E5+Ezh2+oVKc8UstEhgd4nEI7hQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904143; v=1; x=1794508943;
 b=TtgwYx2nRo74jwMSb3GrxUaLZYVvyNmTuVRN5pJx/4rwe9PRowEjRl/5CFVCOS4s6+cJTrEg
 nUhMPTZ/YkZRhDwLbxqRqqhlY/GBTZjpsIbvK08Ej2QXeG3isLo9wrQsFL/zTC28mbQ/yPuhuYZ
 nvAFEHh+P6JsuQly7LkIIWFw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id cde77a9fed62ea5b;
	Thu, 05 Nov 2026 18:42:23 +0000
X-Mizu-Trace-ID: cde77a9fed62ea5b
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
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
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v9 30/32] mm: handle PMD swap entry faults on swap-in
Date: Thu,  5 Nov 2026 10:39:14 -0800
Message-ID: <20261105183940.2236717-31-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0935A4000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: rsj6fapa8jyn8xozg643oiyq3dpw9r81
X-Rspam-User: 
X-HE-Tag: 1793904144-895386
X-HE-Meta: U2FsdGVkX1/6uxF78l/PbWNh8dVkJDiauqpwwMDGdvYwcztRjKHNW2AIWNJFPeg495ud3e3937kLXF2gfFwV2kYdxtX/uUZ+r1B4ZfSIGvRFv3WyYzD1NchzBSVzj6gDXRX8NsGm1k7g+yq0ILjGzeFTwgtjZJMnNR1O9yRSWfh9KEnFzFCm0J5yTUncVWn8dpi1x5e8hhQyurtAwgCXvYQHEFjrpBwN8vyoba1AEO3NXRWEPt6VJLd0XrjWd6HjK6+k4xST+ItHCnzN2PsWGF1sp0bfAB7GsarcqltrDAhlfJxIlIzKtSzZbTEIIsi/1Ehs2blqG3iq5Sp5sGHrOBtKMLJTHQrsns3Zfys++o/nPnFsqym+oKqGhNAJ8o6+ByI81YyhQUws2ARK6Yi9xmFAMEXXwWOobzRUaHXO5boXFIHXclV0Utxnbr9jXMtNfm9BnToVrxY2fjuR6Ag2EljX1EqHNOVZK3CCsM+Jhs6wJCqeHkVa9dy4ps6ibtXLM/Lw/4lmQsSEThh+0s8ggcHzd/sVrlTOzQTj+rQwUv+PLETfocg/EWWI3VwsFUjCwf5BZIcwSxDYB51fbBqaVC7fLA1/WHM4lL43Bp09203r2QM5JakOkDRMXWRXqs8b1x8ARSe++vsfrWVOhozTt4qaHWUqAGjKWR5iFI4Vt9yZg+1H0K51sJbmCxgsgai/8hisksMbnXyyZdn3soUynu9C+GH8wtTgsKuMLUIPVAi0xyxBPp2m8IB4jmN2Zu37451OFNMfIYdpCfnuWoAhC6bq9t0HFGR/vNdPFi1FOyUdeujCrtemg3z6E/dBDJQa9gvOzeSruV1EyxkG4CQ/fchL2gVaGNCu7lu2sKTgDwgnrGnzCUGAj0ZTSJP7OtRbqnlaNJF2jATe9Wtt0NR9OtIZWljgHPitN5Oi2vjtpWCHZarYTPpWGD05YOiAxi42E653y4e3x9WqLRJJYSO
 Ipv84oJI
 HVjahItkJWgw/kvw54wg5OvXknYSi2uNTBqD9ZvllJ0BIRifzfRcXti2E28hFpXmXZ+m7D1/W3MYri5zF/uSjiNZ9fp9Bk2pK0zjVUYbU0t+9Q/Wqjr38I8eIjMWmLiM2btO0to34kU1ZZUu/Y+J2RH8/M0REnCZmUpgYp4YTNNkA/oOGmxZ6Qm+Bl1ER47vuWPIhBPVcy+vxqWRYrIcBLMBhYtWmGfq9yz1b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nothing faults a PMD swap entry back in. __handle_mm_fault() recognises a
non-present PMD as device-private or a migration entry and returns 0 for
anything else, so a swapped-out THP would refault forever.

do_huge_pmd_swap_page() resolves the whole mapping in one go, mirroring
do_swap_page() at PMD granularity, and restores soft-dirty, uffd-wp and
write permission the same way. It deliberately skips the order-0 readahead
paths: the fault already asks for the whole range, and readahead would
populate per-page swap-cache state and force the entry to split before the
fault could finish.

A PMD swap entry only promises HPAGE_PMD_NR consecutive slots, not that the
cache still holds one folio for them. When it does not - the VMA no longer
permits PMD-order THPs, the cache has been split, a slot is in zswap, the
allocation or read fails, the memcg charge fails, or the cache insertion
loses a race - split the entry and return 0 so the retry lands in
do_swap_page(). That keeps a transient PMD-order allocation failure from
becoming VM_FAULT_OOM. Only split if the PMD is still the entry we were
called for, since every reason to fall back was observed without the PMD
lock.

Before falling back with a locked PMD-sized folio, drop it from the swap
cache if it has never been mapped or is not uptodate: do_swap_page() would
hand an unmapped PMD-sized folio to folio_add_new_anon_rmap() as a whole
while installing one PTE, and a folio that failed to read would make every
later fault return VM_FAULT_SIGBUS instead of re-reading the slots. An
uptodate anon folio stays cached so a poisoned subpage stays visible. A
smaller folio is always left cached: it may be a zswap writeback folio
still under I/O, which only the swap cache keeps alive. This mirrors
unuse_pmd_entry().

Refuse to map a folio with a poisoned subpage so do_swap_page() can report
VM_FAULT_HWPOISON for the offending page, and drop the exclusive marker
when the folio is under writeback to an SWP_STABLE_WRITES backend such as
zram, so a later write COWs rather than corrupting the writeback.

When the PMD ends up read-only but the fault was a write, call
wp_huge_pmd() from the same handler so the COW does not need a second
fault. Mask VM_FAULT_FALLBACK out of what it returns: splitting to PTE
level is a normal outcome, but the bit is part of VM_FAULT_ERROR and arch
fault handlers BUG() on it without an accompanying signal.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/huge_mm.h |  14 +++
 mm/huge_memory.c        | 261 ++++++++++++++++++++++++++++++++++++++++
 mm/internal.h           |  42 +++++++
 mm/memory.c             |  40 +-----
 4 files changed, 323 insertions(+), 34 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 8597bc52fdc87..c4ae70cd97b29 100644
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
 
@@ -757,6 +766,11 @@ static inline vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
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
index e02a885ea1d0b..b8d61cdf8cbfb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -42,6 +42,7 @@
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
 #include <linux/cleanup.h>
+#include <linux/zswap.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -2425,6 +2426,266 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
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
+	bool exclusive, stable_writes, rwp_restore = false;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
+	rmap_t rmap_flags = RMAP_NONE;
+	enum swap_pmd_cache cache_state;
+
+	entry = softleaf_from_pmd(vmf->orig_pmd);
+	if (unlikely(!softleaf_is_swap(entry)))
+		return 0;
+
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_PAGEFAULT,
+				     HPAGE_PMD_ORDER)) {
+		__split_huge_pmd(vma, vmf->pmd, haddr);
+		return 0;
+	}
+
+	swp_entry = entry;
+
+	/* Prevent swapoff from happening to us. */
+	si = get_swap_device(swp_entry);
+	if (IS_ERR_OR_NULL(si)) {
+		if (IS_ERR(si))
+			return VM_FAULT_SIGBUS;
+		return 0;
+	}
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
+	 * Folio should be PMD-sized; if not (e.g. split in swap cache, or a
+	 * small zswap writeback folio), split the PMD swap entry and retry at
+	 * PTE level. Leave the folio cached: it may still be under writeback.
+	 */
+	if (folio_nr_pages(folio) != HPAGE_PMD_NR) {
+		folio_unlock(folio);
+		folio_put(folio);
+		goto split_fallback;
+	}
+
+	/*
+	 * A read that failed - a PMD-order zswap load that found per-page
+	 * state, or an I/O error - leaves the folio clean and not uptodate.
+	 * Fall back so the PTE retry reads each slot again rather than
+	 * returning SIGBUS for the whole range.
+	 */
+	if (unlikely(!folio_test_uptodate(folio)))
+		goto unlock_split_fallback;
+
+	/*
+	 * If any subpage is hardware-poisoned, split the PMD swap entry and
+	 * let the PTE swap-in path handle each page individually so
+	 * do_swap_page() can return VM_FAULT_HWPOISON for the poisoned
+	 * subpage rather than mapping the corrupted memory as one THP.
+	 */
+	if (unlikely(folio_has_any_hwpoisoned_page(folio)))
+		goto unlock_split_fallback;
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
+	/* Lockless like do_swap_page(): SWP_STABLE_WRITES never changes. */
+	stable_writes = data_race(si->flags & SWP_STABLE_WRITES);
+	if (exclusive && folio_test_writeback(folio) && stable_writes)
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
+unlock_split_fallback:
+	/*
+	 * PTE fallback cannot add a single-page rmap to a PMD-sized folio that
+	 * has never been mapped: do_swap_page() would hand the whole folio to
+	 * folio_add_new_anon_rmap() while installing one PTE. Nor can it do
+	 * anything useful with a folio that failed to read. Remove either from
+	 * the swap cache so each slot is read back into its own order-0 folio.
+	 * An uptodate anon swap-cache folio can be mapped one PTE at a time and
+	 * must stay cached, so that any poisoned subpage stays visible to
+	 * do_swap_page(). This mirrors unuse_pmd_entry().
+	 */
+	if (folio_matches_swap_entry(folio, swp_entry) &&
+	    (!folio_test_uptodate(folio) || !folio_test_anon(folio)))
+		swap_cache_del_folio(folio);
+	folio_unlock(folio);
+	folio_put(folio);
+
+split_fallback:
+	/*
+	 * Only split if the PMD is still the swap entry we were called for.
+	 * All the reasons we get here (allocation failure, zswap state, a
+	 * split or poisoned cached folio) were observed without the PMD lock,
+	 * so a racing thread may already have swapped the range back in as a
+	 * THP -- splitting that would silently demote a perfectly good huge
+	 * mapping.
+	 */
+	if (pmd_same(vmf->orig_pmd, pmdp_get_lockless(vmf->pmd)))
+		__split_huge_pmd(vma, vmf->pmd, haddr);
+	put_swap_device(si);
+	return 0;
+}
+#endif /* CONFIG_THP_SWAP */
+
 static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 {
 	pgtable_t pgtable;
diff --git a/mm/internal.h b/mm/internal.h
index 8a5bbfebe6270..92f92e46a9fb0 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -598,6 +598,48 @@ static inline vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
 }
 
 vm_fault_t do_swap_page(struct vm_fault *vmf);
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+vm_fault_t wp_huge_pmd(struct vm_fault *vmf);
+#else
+static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
+{
+	return VM_FAULT_FALLBACK;
+}
+#endif
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
index 47bba4695d855..e71c590113e07 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4688,38 +4688,6 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
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
@@ -6481,8 +6449,8 @@ static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
 	return VM_FAULT_FALLBACK;
 }
 
-/* `inline' is required to avoid gcc 4.1.2 build error */
-static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
@@ -6512,6 +6480,7 @@ static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 
 	return VM_FAULT_FALLBACK;
 }
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static vm_fault_t create_huge_pud(struct vm_fault *vmf)
 {
@@ -6778,6 +6747,9 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 
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


