Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A100C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980C96B009D; Wed, 22 Jul 2026 11:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 931FD6B00A6; Wed, 22 Jul 2026 11:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8485F6B00A9; Wed, 22 Jul 2026 11:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5203C6B009D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:22:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CFA6B160209
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:22:46 +0000 (UTC)
X-FDA: 85016779932.23.8CD0C5D
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2F2C8140013
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:22:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="l0YweB/3";
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784733765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=usl6a5PLOpjeUD/D0yu6fB4iAln4bu/tH3LQhZj4L6o=;
	b=YIhiZIBI+EHISWxpYmPQSmBbgHl+8M66xU7SVgotXySqiVH+HEo36aPeNAqalNRijySJko
	iYVPEYRbGW45Kuwp+DDzvQ7aFivm4PGAknUFb2gQRhpq5BE2BEoCBfet37i+Zz4SFcA8Gn
	v0kpZB9znZzn1RxsF/vLB7A0RMqxak0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="l0YweB/3";
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784733765;
	b=Sx1VooPO0gCwdkND6Xwvbk6o1meeBIs15Pqj2Q7ip6AIvcJCPR1DjPRwP2aSftzGPrh4F2
	ZboaCi0hrvSvAy4Lwn4dClX3ZACKanaeEEkNdXW1rzCwvTL/x86QXKzMQ3SV9zFPyHD8zk
	UoNLlnOcZqCFIqNCBOP97Pcalyv3QeY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784733763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=usl6a5PLOpjeUD/D0yu6fB4iAln4bu/tH3LQhZj4L6o=;
	b=l0YweB/3vCYkJKFlc92L9HxZEN0qV4R3b+hOtmudk4D0E2Ism5BuVtRM4ltzbUuh8aJWIC
	d5+eHJ4qidogUr89Rvj1zaf7kFJZE/lEf77HQPIiUk3Ap11g+kI5WBfRFJiyCd8oGKTZfX
	iS6o3VrQx2EYXGjV8FLp4T6ygug+i60=
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
Subject: [PATCH v5 10/11] mm: install PMD swap entries on swap-out
Date: Wed, 22 Jul 2026 08:19:41 -0700
Message-ID: <20260722152043.2273289-11-usama.arif@linux.dev>
In-Reply-To: <20260722152043.2273289-1-usama.arif@linux.dev>
References: <20260722152043.2273289-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2F2C8140013
X-Stat-Signature: 3mdwzei6n7qxhseyfdm4jnfce56aph88
X-HE-Tag: 1784733765-724543
X-HE-Meta: U2FsdGVkX18qmV6vBEKk6/5m46OUqhwwg/TXOGo6OXTMfLqpKIFjs5dLw72o8hzw6PInWUBiHObzJCJSOCPCp2jLNByssIstkvzROvnYuutkF+m4kUOVakP/ykBTw55fadFiCaDbSFoloWkMJ4bndG0aJ72OjciVL46s3xvWRd7h8x+DqdqUPLVm77ibcFHz3lc36b9TJUHzpuLAWbeMKjA0kYq0eeWaBNT09v7HKbMbxuHObyNWG4VDTXMFS3zPCay0/vVuekFbls+xL43RG2Y9roMQz4aN4dGkQRn0TQ3oxfJxqkbY1Cq/2V/dmx30V3bfOAdcjttzLNe2/h6EUIaAzktpALY7XL2tLdHgRwkA351qrIznqOHHM4ZY8WB7o9lV5JUNb+DqN9mTSwn/yCjLtWsNqYnidb1t8FPeCFE85I/OaIgUrF9nEZgnztw3kgIuGn+C9JBNrjJZhntKMkQmk7s3BuQ8siBw8ENOtusnAoBlI8TFGdqoW2VCri4MtLLM24oKXtiFBMFunGcbiU9pIKWVavEiSyW0m//Kj5hgWQzechjsaBK+/FByyr5Njkk9NauVp2oe8EknwMl64BkpYXZ85LZ2SrmOmtlRIuP4qoiy6AdJKPw4Fn6Z7GO/rzfL16GXuYWBIbyrVHC8Yr8UCGuyKt84d1seyKd4VG220OvuEGQ/l9FebIFEWxc7/hy7BbLlkaM538Qg4cBuSDyt7+QJ7XcetYJ+bu3sjIFg35wmHegfYF6X0ijoHmdAkzG+lqLEvptwsNK+SVJ/j8V/d/5gFvZUlUNcsngshwcXRdObBH2TctXtbT6WKfgMv6juUkImaa05vizwkPcD+gGEAJEyiD1XyeBdVAy3p3EOqY5oPdqG+3tkDZT1PvyGC/zZP9MPxB1XdDFem5OuKNQxeD92Ie5k0r4B+TvpvbQ+2AyZujwIKS4UuzUspynHqdmUPQU4i61bAqEAMWo
 GmmufMYl
 yYt2Bz2CXQcj6deDUSUUyR4jcfegX5xChgc7EZmhIhN4+qhUaKZEkBKp0BEMR4VWvQ9U4ks87ZYCb6O8uMjMfrXcDUA1G/X8yx4fHCTzvWxKqJywMiPR4k/8o/F5oTQiHbGMCpejHlfc+9JqOQcGN77KhoJgfA+yq5tbVSxWwF4/o1PYhweldTHBJTgFLr55nP/1P/21wRJZAZu0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reclaim today splits a PMD-mapped anonymous THP into 512 PTE swap
entries before unmap, losing the huge mapping across the swap
round-trip and forcing khugepaged to rebuild it later. The contiguous
swap range was already secured when the folio was added to the swap
cache (a non-contiguous allocation would have split the folio earlier),
so the PMD can be replaced by a single PMD-level swap entry instead.

This patch mirrors the existing PTE swap-out path at PMD granularity:
- shrink_folio_list() drops TTU_SPLIT_HUGE_PMD for PMD-mappable
  swapcache folios. zswap is handled by the PMD swap-in users: if any
  covered slot currently has a zswap entry, they split the PMD swap
  entry and fall back to the per-PTE path.
- try_to_unmap_one() now has a PMD branch that calls
  set_pmd_swap_entry() and adjusts MM_ANONPAGES / MM_SWAPENTS by
  HPAGE_PMD_NR before walk_done. TTU_SPLIT_HUGE_PMD remains the
  fallback.
- set_pmd_swap_entry() is the installer. Mirroring the PTE swap-out
  sequence at PMD granularity, it clears the present mapping (keeping
  the original for rollback), bumps the swap_map refcount for the
  folio's 512 slots, transfers the exclusive state in the swap entry,
  propagates the dirty bit to the folio so writeback is not lost,
  and installs a swap PMD that preserves the original
  soft-dirty / uffd-wp / exclusive bits. Any failing step rolls back
  the present mapping.

The swap entry value matches what 512 PTE swap entries would encode, so
swap_map refcounting is unchanged: each of the 512 slots carries a
count of 1, released individually on later split or together on swap-in.

Add thp_swpout_pmd to count each PMD mapping replaced by a PMD-level
swap entry. Unlike the folio-level thp_swpout counter, a fork-shared THP
can increment this counter once for each mapping; document that
distinction.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 Documentation/admin-guide/mm/transhuge.rst |  5 ++
 include/linux/huge_mm.h                    |  2 +
 include/linux/vm_event_item.h              |  1 +
 mm/huge_memory.c                           | 80 ++++++++++++++++++++++
 mm/rmap.c                                  | 19 +++++
 mm/vmscan.c                                |  9 ++-
 mm/vmstat.c                                |  1 +
 7 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 16f37135ed80..b421d7982db6 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -630,6 +630,11 @@ thp_swpout
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
index e7107e0991ad..41cf643a3f55 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -554,6 +554,8 @@ vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
 
 #ifdef CONFIG_THP_SWAP
 vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf);
+int set_pmd_swap_entry(struct page_vma_mapped_walk *pvmw,
+		       struct folio *folio);
 #else
 static inline vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf)
 {
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 2628ccda076a..f8fd4e13698c 100644
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
index 6ef56936ced4..c014631e5a26 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -5561,3 +5561,83 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
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
+	if (!(pvmw->pmd && !pvmw->pte))
+		return 0;
+
+	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
+
+	if (unlikely(folio_test_swapbacked(folio) !=
+			folio_test_swapcache(folio))) {
+		WARN_ON_ONCE(1);
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
index b7ead3e9f064..4574f7b969b6 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2282,6 +2282,25 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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
index 9b8ee902f972..83bb34403e42 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1333,7 +1333,14 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
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
index 4e26e5fd6666..68e6efc0dabd 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1422,6 +1422,7 @@ const char * const vmstat_text[] = {
 	[I(THP_ZERO_PAGE_ALLOC_FAILED)]		= "thp_zero_page_alloc_failed",
 	[I(THP_SWPOUT)]				= "thp_swpout",
 	[I(THP_SWPOUT_FALLBACK)]		= "thp_swpout_fallback",
+	[I(THP_SWPOUT_PMD)]			= "thp_swpout_pmd",
 #endif
 #ifdef CONFIG_BALLOON
 	[I(BALLOON_INFLATE)]			= "balloon_inflate",
-- 
2.53.0-Meta


