Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56C88CA5FE0
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61B46B00C8; Fri,  2 Oct 2026 05:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38D76B00C9; Fri,  2 Oct 2026 05:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D02C46B00CA; Fri,  2 Oct 2026 05:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9841B6B00C8
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:57:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 101B7C06C9
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:41 +0000 (UTC)
X-FDA: 85277234322.27.9EB29FC
Received: from mta1.migadu.com (out-23.mta1.migadu.com [95.215.58.23])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1D717180005
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nk0aLi98;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.23 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3BDuGY7xIWCzxJMTar9z32dpUvQYc3xVjM65MGf50NM=;
	b=m5Tzjq0QdnuXKKX57rlj2ul3VFyuAKvy77SqFzxEobf6UKo8eKqsmdpPIcMjC2OvWcPXLX
	Rxit9hV3/4xkg7LWtzybQ5YOCdPp2p/cq+LUTehP9yyXjFT6DjTfH7OcKFWlMN8WR6nWKc
	8jFs0b3jZhH7+cx7kC6Vg+8SrBIgxHY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935059;
	b=Pze+E6PNgvgS6bndu+E88yG76n0DFCfFtAR2nIYZOtVlTYpzIIdDy7Y5dVN36NvGJyjv93
	W2vuIcShFiu+pRCh4XVinntHuUy3/t6R6dZYEX4nBvKkMMFSDJCuc2XIlUmlqt/s2ejrwU
	9N1oAkBYUd5o5hAfXLUhR7RCcNUEe3Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nk0aLi98;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.23 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iU9ocT2TEBSFYtG8fbChATV4/D158MSldwzOvx6mfpk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790935058; v=1; x=1791539858;
 b=nk0aLi98mdKQEuAmeoBzq7QxYAC0m7iDvtWu969YP1ezPWOmgrPJlYrpyLpXaO5ki4P7En3Q
 SvORIGYEB/5Dq02/Z41cKI8h2iw6M5SKps809pxW7Qc132/IuTGFrNuEXAqFQF1JkMBJ6mwh7+6
 /cohmrbTQQfTl0gcV2PHBi1w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id e133ed410f67748b;
	Fri, 02 Oct 2026 09:57:37 +0000
X-Mizu-Trace-ID: e133ed410f67748b
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
Subject: [PATCH v8 29/30] mm: install PMD swap entries on swap-out
Date: Fri,  2 Oct 2026 02:52:43 -0700
Message-ID: <20261002095503.3585565-30-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1D717180005
X-Stat-Signature: xfbyoig8ysobx7nti9h7zft1oh9fxcop
X-HE-Tag: 1790935058-633393
X-HE-Meta: U2FsdGVkX18gaV/M6PpOH+1g7P0wwwVTtYzc62pOEwSItpVMThonH9ciL2kTc1ppXHRqdkXTbRFSyNKlMn2v63DIYGJ9uI8JDlfDNprrdalAJFfXuS6iAxNER7GtzUxaQ3vuQgsgh7PrMbwLk3q5M3aKA+OgG4T4FVryVhwIqZXYKT3/PYEvV3vo7ElVKo+KLNBYs7ZVxhWwKSYPFV4LpOJwGA8UsPs5D0uplueliaP53PV9ZgeROtDc8Qs70TQT4lQ0Wgf/JIX9/q+TZ3cjArJAd5MWlh4LDZR2iIqilrAFdVQz9G92yQIfiJZojFI7NjqkZls5Cpz4PH3ukTEwFEw8cg41WyD1kQd/IdJ8tzltxbEbbbaShGozXEV6oiVe56l3Y8s7/i2y+TNOt4wVCsmR1hgx01S9zo7NeD0q1tw+vRcT8dhp0Tkmtab2OS6fxyky/HpCE59R+FjV1k6AEVxERScn7HuvTE08taaY1SRfOH4m+et9NvN9OTpDzeM1xC8vXOA5KtoJiDF3mRGQse8f9ROS82IwfI10pxeRV9uTSRkk5yDUDkFuwXmKYgqKNODKBDO0BJMZkCKwKakIErf3KZFIV8Bbs+mxTHWSkfyXd1I6sJtjS3IPRPo/rzaSd+bva9ur4NHbR+CX1MLvsFZqoWxjpFKXXZWAZwlbZwf3qHlx5ITgg2pJlE9+a6X+7IPqi4RH4HxRHyGW0XIMcbPHRu5s456wRpvdhKi4uJjKsWUQTM7JaKOfWtvlqzt0ICU6827qGt5s2UwW3IQptIekaNuL+ydbun9cDK8OZD1szQlAegLe7KWQbBzwNJkWn4PZGOq9dGrFQXSJJdX3FeCGDHuZhTpis3Dr58FBlKt73Y17zErr3tnVwQFeu2tQ5wGN1SZtEMfVVwK1tBI3Nl8RQ5t4Ng5sF7gC1+DFkobgJiR974mMmOy3QCQQqi2pkR5b0/N0pauI9Y5twd2
 eViNMnhk
 nO0Qtgb7F4Lk5IpwjSg9xth9CCDUUVbuwjSxJZw4ZXL2gx+KasPdCPm8XWt0W9t9V+Y+r/CxX2Wo7lkk42nDvwbzKFK6WWTWvgfYMMH8WTmmeY6J92IxqotUgxZqopAl5wjBfnA/z7dzC/hYy+ZdqdQfefabkb2fGP12P0RGYZZCO4wcTgkUYwkVLJvo0ZntGqiy6++ri6rztxFvbh4j388Ey/wVrQPq0fRcq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When reclaim swaps out a PMD-mapped anonymous THP it first splits the PMD
via TTU_SPLIT_HUGE_PMD. The huge mapping is lost for the whole swap
round-trip: swapping the range back in takes HPAGE_PMD_NR faults and
leaves as many small mappings, and the process waits for khugepaged to
collapse them again.

The PMD does not have to be split. A contiguous run of slots was already
secured when the folio was added to the swap cache - a non-contiguous
allocation would have split the folio first - so the whole mapping can be
replaced by one PMD-level swap entry encoding the first slot.

shrink_folio_list() therefore stops asking for TTU_SPLIT_HUGE_PMD for a
PMD-mappable folio already in the swap cache, and try_to_unmap_one() grows
a PMD branch. TTU_SPLIT_HUGE_PMD remains the fallback for everything else.

set_pmd_swap_entry() is deliberately close in shape to
set_pmd_migration_entry(): invalidate the mapping while keeping the
original for rollback, take a swap reference on every slot, transfer the
exclusive state, propagate the dirty bit to the folio so writeback is not
lost, add the mm to mmlist before the entry becomes visible, and carry
over soft-dirty and uffd-wp. Any step that can fail restores the mapping
first.

The entry encodes exactly what the PTE entries would, so swap_map
accounting is unchanged: each slot carries a count of one, released
individually on a later split or together on swap-in.

zswap needs no handling here. It stores the folio as order-0 entries, and
the PMD-order swap-in users split and fall back to PTEs if any covered
slot turns out to have a zswap entry.

thp_swpout_pmd counts PMD mappings replaced this way. Unlike thp_swpout it
counts mappings rather than folios, so a fork-shared THP can increment it
once per mapping.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 Documentation/admin-guide/mm/transhuge.rst |  5 ++
 include/linux/huge_mm.h                    |  2 +
 include/linux/vm_event_item.h              |  1 +
 mm/huge_memory.c                           | 84 ++++++++++++++++++++++
 mm/rmap.c                                  | 19 +++++
 mm/vmscan.c                                |  9 ++-
 mm/vmstat.c                                |  1 +
 7 files changed, 120 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index b187d618452f4..64d413d9fd83e 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -632,6 +632,11 @@ thp_swpout
 	is incremented every time a huge page is swapout in one
 	piece without splitting.
 
+thp_swpout_pmd
+	is incremented every time a PMD mapping is replaced by a PMD-level
+	swap entry. A fork-shared THP can increment this counter once for each
+	PMD mapping that is swapped out.
+
 thp_swpout_fallback
 	is incremented if a huge page has to be split before swapout.
 	Usually because failed to allocate some continuous swap space
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 04466662cfabd..2f537e5fed60c 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -551,6 +551,8 @@ vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
 
 #ifdef CONFIG_THP_SWAP
 vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf);
+int set_pmd_swap_entry(struct page_vma_mapped_walk *pvmw,
+		       struct folio *folio);
 #else
 static inline vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf)
 {
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 2628ccda076a0..f8fd4e13698c3 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -108,6 +108,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		THP_ZERO_PAGE_ALLOC_FAILED,
 		THP_SWPOUT,
 		THP_SWPOUT_FALLBACK,
+		THP_SWPOUT_PMD,
 #endif
 #ifdef CONFIG_BALLOON
 		BALLOON_INFLATE,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a64f568f315c1..63ef7a5f799ce 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -5707,3 +5707,87 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct folio *folio
 	trace_remove_migration_pmd(address, pmd_val(pmde));
 }
 #endif
+
+#ifdef CONFIG_THP_SWAP
+/**
+ * set_pmd_swap_entry() - Replace a PMD mapping with a PMD-level swap entry.
+ * @pvmw: Page vma mapped walk context, must have pvmw->pmd set and
+ *        pvmw->pte NULL (i.e. PMD-mapped).
+ * @folio: The folio being swapped out. Must be in the swap cache.
+ *
+ * This installs a PMD-level swap entry in place of a present PMD mapping,
+ * avoiding the need to split the PMD into PTE-level swap entries.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int set_pmd_swap_entry(struct page_vma_mapped_walk *pvmw,
+		       struct folio *folio)
+{
+	struct vm_area_struct *vma = pvmw->vma;
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long address = pvmw->address;
+	unsigned long haddr = address & HPAGE_PMD_MASK;
+	struct page *page = folio_page(folio, 0);
+	bool anon_exclusive;
+	pmd_t pmdval;
+	swp_entry_t entry;
+	pmd_t pmdswp;
+
+	/*
+	 * try_to_unmap_one() only gets here for a PMD-mapped, anonymous,
+	 * PMD-sized folio that is already in the swap cache, and a swapcache
+	 * folio is always swapbacked. Refuse instead of crashing should that
+	 * ever stop being true: the caller aborts the rmap walk and the folio
+	 * simply stays mapped.
+	 */
+	if (unlikely(!pvmw->pmd || pvmw->pte ||
+		     !folio_test_anon(folio) ||
+		     !folio_test_swapcache(folio) ||
+		     !folio_test_swapbacked(folio) ||
+		     folio_nr_pages(folio) != HPAGE_PMD_NR)) {
+		VM_WARN_ON_ONCE_FOLIO(true, folio);
+		return -EBUSY;
+	}
+
+	flush_cache_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
+
+	pmdval = pmdp_invalidate(vma, haddr, pvmw->pmd);
+
+	/* Update high watermark before we lower rss */
+	update_hiwater_rss(mm);
+
+	if (folio_dup_swap(folio, NULL) < 0) {
+		set_pmd_at(mm, haddr, pvmw->pmd, pmdval);
+		return -ENOMEM;
+	}
+
+	/* See folio_try_share_anon_rmap_pmd(): invalidate PMD first. */
+	anon_exclusive = PageAnonExclusive(page);
+	if (anon_exclusive && folio_try_share_anon_rmap_pmd(folio, page)) {
+		folio_put_swap(folio, NULL);
+		set_pmd_at(mm, haddr, pvmw->pmd, pmdval);
+		return -EBUSY;
+	}
+
+	mm_prepare_for_swap_entries(mm);
+
+	if (pmd_dirty(pmdval))
+		folio_mark_dirty(folio);
+
+	entry = folio->swap;
+	pmdswp = softleaf_to_pmd(entry);
+	if (pmd_soft_dirty(pmdval))
+		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
+	if (pmd_uffd(pmdval))
+		pmdswp = pmd_swp_mkuffd(pmdswp);
+	if (anon_exclusive)
+		pmdswp = pmd_swp_mkexclusive(pmdswp);
+	set_pmd_at(mm, haddr, pvmw->pmd, pmdswp);
+
+	folio_remove_rmap_pmd(folio, page, vma);
+	folio_put(folio);
+
+	count_vm_event(THP_SWPOUT_PMD);
+	return 0;
+}
+#endif /* CONFIG_THP_SWAP */
diff --git a/mm/rmap.c b/mm/rmap.c
index b762eb85915ea..d04d376386c80 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2284,6 +2284,25 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				goto walk_abort;
 			}
 
+#ifdef CONFIG_THP_SWAP
+			/*
+			 * If the folio is in the swap cache and we're not
+			 * asked to split, install a PMD-level swap entry.
+			 */
+			if (!(flags & TTU_SPLIT_HUGE_PMD) &&
+			    folio_test_anon(folio) &&
+			    folio_test_swapcache(folio)) {
+				if (set_pmd_swap_entry(&pvmw, folio))
+					goto walk_abort;
+
+				add_mm_counter(mm, MM_ANONPAGES,
+					       -HPAGE_PMD_NR);
+				add_mm_counter(mm, MM_SWAPENTS,
+					       HPAGE_PMD_NR);
+				goto walk_done;
+			}
+#endif
+
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				/*
 				 * We temporarily have to drop the PTL and
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c2eb8fa9d5e50..7648a2a0d0813 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1408,7 +1408,14 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			enum ttu_flags flags = TTU_BATCH_FLUSH;
 			bool was_swapbacked = folio_test_swapbacked(folio);
 
-			if (folio_test_pmd_mappable(folio))
+			/*
+			 * With THP_SWAP, PMD-mappable folios already in the
+			 * swap cache can be unmapped with a PMD-level swap
+			 * entry, avoiding the cost of splitting the PMD.
+			 */
+			if (folio_test_pmd_mappable(folio) &&
+			    !(IS_ENABLED(CONFIG_THP_SWAP) &&
+			      folio_test_swapcache(folio)))
 				flags |= TTU_SPLIT_HUGE_PMD;
 			/*
 			 * Without TTU_SYNC, try_to_unmap will only begin to
diff --git a/mm/vmstat.c b/mm/vmstat.c
index a3e809c57f295..5badcce8ff0ad 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1435,6 +1435,7 @@ const char * const vmstat_text[] = {
 	[I(THP_ZERO_PAGE_ALLOC_FAILED)]		= "thp_zero_page_alloc_failed",
 	[I(THP_SWPOUT)]				= "thp_swpout",
 	[I(THP_SWPOUT_FALLBACK)]		= "thp_swpout_fallback",
+	[I(THP_SWPOUT_PMD)]			= "thp_swpout_pmd",
 #endif
 #ifdef CONFIG_BALLOON
 	[I(BALLOON_INFLATE)]			= "balloon_inflate",
-- 
2.53.0-Meta


