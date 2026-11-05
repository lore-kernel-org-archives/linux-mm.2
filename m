Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A52EC606A333
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LeFBr898
Received: by kanga.kvack.org (Postfix)
	id 44D356B05E7; Thu,  5 Nov 2026 13:42:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FD9A6B05E8; Thu,  5 Nov 2026 13:42:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7106B05E9; Thu,  5 Nov 2026 13:42:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED37B6B05E7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:42:29 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F019140BC4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:42:29 +0000 (UTC)
X-FDA: 85401936018.11.442174D
Received: from mta1.migadu.com (out-195.mta1.migadu.com [95.215.58.195])
	by imf10.hostedemail.com (Postfix) with ESMTP id 94942C000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:42:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LeFBr898;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.195 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gU5j4fPUd2aBi7hlIuXEmLLAt0ccJJq7dFkDmxL6BwA=;
	b=MWHDwXYsakH1dHxav8aRz87CiW7I/NJ+HRjZalDqWsHTcYGgqme1pGBDiJeshy+DWB790H
	2T0YFspTrV/+31Nu2xBFTDuiof2SjAQvBc3Fsq/D/4TuTaT6Ag/i/Q6gDsmb6qK71txtxb
	2k8z50U+84sBXyB1+X38UMTY4pn0y00=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904147;
	b=DsIwpEm0xz/kROA5BVbb/D8u9PzkctTeCjSb3yq1uIUzg9qJG6yYl0KWkNn7c4UMdEa7ZO
	/UElYPfsj/lOJHZiRal0zTpClcqUQMcTe0qTyFvILf8CTjUmv1q/1QKCsvv+En72bRr2Jd
	GSrCja5UvsOvWZIlh9/a14Pyvk5h+xQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LeFBr898;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.195 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JyE+I9lH3TtLqcot/C+JRnBeJJJ8/ukkyBpeaHdXzX4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904146; v=1; x=1794508946;
 b=LeFBr898FG7r/RtVl6IamkWAOUcutGG7u8IXQqDvX0/BIbhnYq8WLHI9O6/c/SnP4QIAPR7q
 T23bqNumcpNe0WPa29AZrlxKDtVZ9d/d2x+3Xxm70LR4jwJFN6ecCEKmrLpx/guDCutAWD0Qfdv
 KVy1SSrlnfVNbtC+Jw6bMvhA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id c153a3c29155417d;
	Thu, 05 Nov 2026 18:42:26 +0000
X-Mizu-Trace-ID: c153a3c29155417d
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
Subject: [PATCH v9 31/32] mm: install PMD swap entries on swap-out
Date: Thu,  5 Nov 2026 10:39:15 -0800
Message-ID: <20261105183940.2236717-32-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ygugqj6gti6soebst9g1epf7b87i97ak
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 94942C000A
X-HE-Tag: 1793904147-978266
X-HE-Meta: U2FsdGVkX1/N9Jg7U5ugfUY60P8Iw0DY8y/vm/E8rkn9G+eRnYFRQ32twPYAVb2NgUT4rFp6siLj0sPKwZniulIlwp2AAd3q9Js6nGa6bYINPglmww27/XbXFK0xxNiYy4rEdDnkqHfzO5KDDLsjMRHYgUswJhBHq155RpFY9XPvG2MKnehPwH6DxlaM9AiDCwShFbvC0SLw/O6nATxYQwXkbGt1S0AYANFSkM4qr9WN0aJpH8DmaDLweDXUoEWstImoAE0m3rkzd5qxfjhgLpb0bwE44Scge0ncA4Ty1qMoH18TfPNrsuM5Qnq1+kbF4nR2dLj9ymQzf01dsHYJPhFhImHwejZB4jNnDkzAWrDapzQ/bJaBhrZAcoKk6QH96Gn0FhZkzrUvq9DXK+7MfgKQcD2k6olCtHeENUb/7fVfdId+6OgtkiGLFbBBpU2BQLBDsWvUr03h/NUpQZPmHef+x58bfwzFE2lUsE8XbtmyX/pUpZLQFBijt16GzzsMDsOTaHWYnkEcXBhb7xFkXJTNwlsVrCwMl7JCc2OAWZfhe4+S7XRCV3Lt9inYr9VXkdljK51GIweokyqZvS4rMLz/07bp/Jq3pmTGxQ0lNWJW++f8hoOMV9nIRK1g8A+8pLM4PtsDnWE4Ezl8T8fO6pUbkYmB5vGqCysAWKCmD8UYldl0yb1tn2qSE6TaDDbK/+dHqW1CnplvjwTzBWUQ+mlDQJG3Q/ZKA+2aECNCQQPXsjgIf3Dlkj3mVrJ4pdqVa0QyddpIWSXBV3uKlvMQCtLUvQKgFsu/Jkxr/oQRY/0FpO5ngPD/W7OUWLv0dIi2L5nsbw1dEzsjBCncMmQ+0QMStTMYisJ64m1WKHuZNwJBnyVr/B7tWiEi1ycyld8cdigokX+VWNCFs7o0qXo2U+D/ynOm1Ljk6atheA8u0jLq/NpC8qJumpEjDvNF/Kbm4ELtMaa9NthRuU7gW0Z
 RFVMM0I7
 AyEp7UcXmaUJDA7lk7V6EHViAriThAtgpMTYxyQJRlCIAGbU7wGr7cT/0QVtlGouZonzgax3w9qy5EfX6yvxO6aBTHIJjq2rvXN63QSf9mceTwAXOxnetojSAzcLIrXBtsLu9HkD2NCvyReV5Azt3v64N99H3tPjpgXyUXfbskSK3B/5KCEg72deWi1Mh1HNj50V95ArAj/jxQK2k2s0iMz9oZN5jj6pSYuLi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 6f2d92a2a556b..20f159ec2f802 100644
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
index c4ae70cd97b29..9cd2cf476f970 100644
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
index b8d61cdf8cbfb..95fce141e114f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -5778,3 +5778,87 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct folio *folio
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
index 9d6353e98e7c7..b76e5f85c9bcc 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2275,6 +2275,25 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		if (!pvmw.pte) {
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
index 071a6eaef1a1a..179ba94494e85 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1330,7 +1330,14 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
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


