Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2015C88E70
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E44A56B00BD; Mon, 14 Sep 2026 08:32:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCF346B00BE; Mon, 14 Sep 2026 08:32:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97E26B00BF; Mon, 14 Sep 2026 08:32:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56EF06B00BD
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:32:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92CD61603E0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:32:15 +0000 (UTC)
X-FDA: 85212305430.05.8F04A47
Received: from mta0.migadu.com (out-100.mta0.migadu.com [91.218.175.100])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7EE7818000D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:32:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ET/AEZ6H";
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389133;
	b=hEuUZBve3iF9rCOfeeYNHpPtQKFGsJ4w5PPsvQitY7RB1BG64RURuXZ4y7LDiv+5vYIocH
	jhPAqgsxMRDsvKKkpwQc4Lz5EpyvDl6Drh6VfwY3v9KpznSAsI34MEbib06UELwF0IYVy3
	HhbPX/P8WoVoJ65nXn8l+SarqKGjKiM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ET/AEZ6H";
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZDvPcrgNK6w1ISWgVsYfTyaTd39mHB872/z4fiHIM8=;
	b=t+eKjzoBAxVYpqX05X7HlXqOHCUD+RjVys91+b6LF6aikhEo5UhmMeDdAfWICsEZqfFHzf
	JF4rTjUke9q5NlAMo/nOxFADhty/oCHXTBWrqF0X0uTpaOF3SKqCpbs3kYEzYnPE4Ulsdj
	Sto/pZ3+P+6lWb+IkeNCZ/6QQHeYv10=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=i8lsaF6ASDY8IVJmy1+rFL4wXtW1f9Bd1clcvnPDbM0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389132; v=1; x=1789993932;
 b=ET/AEZ6HqYdlUT47mX9TQBTQxn2scgh+3jWajJ0lp8RRg1K1wlSSEjjGtERtDc9LwxPUStcg
 LLG2I0GxM3oRL9me/3nmZKSMWdmM8eaoGT7SMHcTPr/I6q1XysJ7t6ok6q9/zFupg0hBKLmPD3P
 OSjVoC1PBcmH6cUdx5zinjhk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 8157c0f3f9b29dfd;
	Mon, 14 Sep 2026 12:32:12 +0000
X-Mizu-Trace-ID: 8157c0f3f9b29dfd
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
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [RESEND v7 27/29] mm: handle PMD swap entry faults on swap-in
Date: Mon, 14 Sep 2026 05:28:17 -0700
Message-ID: <20260914122950.3283997-28-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7EE7818000D
X-Stat-Signature: 7cefaq693kqpem79fzjp115up5absecs
X-Rspam-User: 
X-HE-Tag: 1789389133-621746
X-HE-Meta: U2FsdGVkX19DynjmYlQqgaZVfv+5bEMwQvxh/Li67yW9kwJO6KmyYK4T00Q8MQbrihAt/UAakZRfMAgK1rl+DaJDhZKsclmuUnkxJH6L045obDuLVmKLiW3HFi+B7uCYlzpKKO/Xjy08oSN/20htTyCCSdcfTG2U0RWliTbGL99/cgHIm7GjqXeP+7NCW20bxl9RqhBxg/5uwpDJg5t/Lfugc08HUkLm0218n70U9a0nSg/0cfo9FGVa85cBAYtPWrOL5AvHaZMDgQ3WWHfoAlS2DWfORwTb7PnbCAm4CyBFbq5NwCHsaJclV489XQvjhPD83l5n1GI6eAtdoX4z6eoHad7AlQWuEiwUB42LCx6jrZr+Oa1+Pf7Pqlor696dPFYYDZGjww68q0xMvshxbXbUvKQf2uWn+7ba+U474ZIjSs0opy8IhUTgVXYV9DmZXJLe8Xy/3fJt8guwQZgSCMdJt3rA2TJq0k5DAtiCWVUz+7qiJFNLwaSBSEDV7CBqZi6ma9HNjhly8LxooRpZcDLAwtaqzxnXNj0rDP7u9FpE49MO52SBa2d+RGERPRM40BHgchjfxFrqoOrHKJneK195AMEWNkPJrDEatd5kBqRegYH/6zUP91BwX2LuIqyKk48aFkccFUQ8DXBC6xhH6adx0ZhC/QnTGGCFgDvZyjyO4SBPPnUnGbw96WdBVjj4j6dttKe+1j3L4/UOPmMiSUyjL5x1muFfqx3iOj/HxTpt+fBFlosByzCL7qp3XAOcNnrUhSym92QaDiHiLzvLTYgWKmdhwrzIMHrqYtr73Mz6DW6Zm94gFo+RNkBFd1gkmB58Wqkyy7IfREVFZfM3kmXAZf9wFAOEaz3dkFh6RTV5DLZ9lm1bYZ7OmD5z/qpLQ1YA1pMjQK9xOXmw2IKSTRiGv2NxU90b0kTYfFQBOiOt2ThJfF7OolF+ASfTYKjebMyC3760/Io42qGilXS
 xsjC0vxD
 cVUt+eBDCdBuK0S8bLd49wBgsaqYcwSlTNqFfppJeAjp1k6lnwigAoqsgd37EfltOY50QtTmEqJ0pJTGJwnkibVl4rPN2FY03sOUvJMYEzJuWgeWwFLS3GUPlAQDanA1OZ8Fe9GvVy9soK1/kZddTkVkBqCf3JCdIHJoCUiYCBbekudz8SVFFJCgCuK40f5LH074x89K9fJOOwgR3kLh8uk3PMGnCUv/fXZHo4fZYCgsBqTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Before falling back with a locked folio, drop it from the swap cache if it
has never been mapped or is not uptodate: do_swap_page() would hand an
unmapped PMD-sized folio to folio_add_new_anon_rmap() as a whole while
installing one PTE, and a folio that failed to read would make every later
fault return VM_FAULT_SIGBUS instead of re-reading the slots. An uptodate
anon folio stays cached so a poisoned subpage stays visible. This mirrors
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
 mm/huge_memory.c        | 257 ++++++++++++++++++++++++++++++++++++++++
 mm/internal.h           |  42 +++++++
 mm/memory.c             |  40 +------
 4 files changed, 319 insertions(+), 34 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 64b6a2eea899d..b44a228dfe20c 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -548,6 +548,15 @@ vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf);
 
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
 
@@ -747,6 +756,11 @@ static inline vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
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
index 497f677a3ef71..bd9cc24c2b011 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -42,6 +42,7 @@
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
 #include <linux/cleanup.h>
+#include <linux/zswap.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -2447,6 +2448,262 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
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
+	 * Folio should be PMD-sized; if not (e.g. split in swap cache),
+	 * split the PMD swap entry and retry at PTE level.
+	 */
+	if (folio_nr_pages(folio) != HPAGE_PMD_NR)
+		goto unlock_split_fallback;
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
+	if (unlikely(folio_has_hwpoisoned_subpage(folio)))
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
index ec7f007bc2c0d..1a5480e4b5071 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -577,6 +577,48 @@ static inline vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
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
index aa1f67b378587..63b51ba46b0b5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4603,38 +4603,6 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
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
@@ -6362,8 +6330,8 @@ static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
 	return VM_FAULT_FALLBACK;
 }
 
-/* `inline' is required to avoid gcc 4.1.2 build error */
-static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
@@ -6393,6 +6361,7 @@ static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 
 	return VM_FAULT_FALLBACK;
 }
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static vm_fault_t create_huge_pud(struct vm_fault *vmf)
 {
@@ -6656,6 +6625,9 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 
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


