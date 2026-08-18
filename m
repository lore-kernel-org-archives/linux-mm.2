Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D52B7C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE31F6B01A8; Tue, 18 Aug 2026 09:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A93DF6B01A9; Tue, 18 Aug 2026 09:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95B5D6B01AA; Tue, 18 Aug 2026 09:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6219E6B01A8
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:12:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DF08416010E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:56 +0000 (UTC)
X-FDA: 85114430352.03.AC680ED
Received: from mta0.migadu.com (out-202.mta0.migadu.com [91.218.175.202])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0E6348000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PkMYEMxU;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.202 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787058775;
	b=S91iZu+Aj4Ah9fflL9Tc60OaSthUJAzIUGQhYBzXFmV3aNNezxQAEflhoxLg0Rxv4TA9m+
	hTCno3xFChVQWz0PEIw0t3Y+4igIWwM5oxKe2KEXdIcCAwdJwAQ7gl9tU7665KHuVYKBwQ
	qnbsNkd5t/DWGYedCs6ogio87SxfpFg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PkMYEMxU;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.202 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kiYTwoaYmEUhjoH/Ep+c8S9dQki0H+kfwSGsdTWI05Y=;
	b=111Q235es3kzYYdau4dTlAZooEzrXuV+rChIz1zlPsbG33vCVw6BxzNhpq0X+HSo+NUrEN
	hAzblG1nVBOq0TuvbRHMhnlVRY8upxlqGVd3YeOMciCC1UkJyyHmCHRXsBEDy4wvPm1BJX
	lfjqBQAwwkxkPu+MXr4D7Ib2HxFsxJ8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=znqDwJ9Ce0OIJka+MopdalndNHzzmD2CA+PlSkpLojM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787058773; v=1; x=1787663573;
 b=PkMYEMxUSd24JsXZf0H/Q+Bd/rRJNvp1UNw0Yvw4Ya6i8KgQQGG4dWLs8jQRYaCP5TaAWijG
 +FkHvaV+Qtj1Ib7G1D+2WjDe2aPdUslgo3zYB1QHCX2apv2URFuA5hvOt3ddjtEvjKrzjWU2DYg
 dC7W0kEQdayzy5d4RZUGAR5k=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:52::)
	by mta11.migadu.com with ESMTPS id 7af44e08486162c3;
	Tue, 18 Aug 2026 13:12:53 +0000
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
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v6 11/12] mm: install PMD swap entries on swap-out
Date: Tue, 18 Aug 2026 06:09:52 -0700
Message-ID: <20260818131202.494754-12-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260818131202.494754-1-usama.arif@linux.dev>
References: <20260818131202.494754-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0E6348000C
X-Stat-Signature: 6fnttsbeyi3xuo47p716kr1o4spyaa5o
X-HE-Tag: 1787058774-871703
X-HE-Meta: U2FsdGVkX1+bDt9PdSW/96DZKlUm/QoRib8z0PRQOPj1aDv1bi0z9UfQ9u0tujTraJ1YvNQ//rqAfrUyq/kWJHu2AjOi+xIeqlgSkXduHVB6JQ2euTtPtRScXSrfWkjtu91ZkqdPpbkSZJbYToaVUc8FFjqQhVnyFJPUUFgrWlK+hAdq9T9PzkbCioZhLVGlPjh4U0/gyfjfuHFhciW9sfG2IGjqZhHMZj+HZR6aruS1CCXQBKOkVIhJNWXJ61UytycrJd68HXqPL7cw1pXdaUq2g/Itkix2v/3TrVlcVDgm8J1qpPznKhXReaJeDRBTMIkpn+ckdwFq/Ha1K75hvFXpLbx/MtgPjflDMzjzf7mqtXPHxb2wWxEBiQA1HJKaPoqBc2nLkseSU57rwVUOQzP8PFhUmfthLcGO/gW9fOMxCr3blRRYgjzb+TyWhyaOIJoF2O7TeDIMNs8O6EB/x5gsjG/XkOQP/rbs099KdCUhw3CLEDVW3AiIE0CRWaSJ2UwIlSRZZid02h8GgfoGixsdF6FKqsBFwuYsNLnJAy4u9LBqg64OMU5prC2xGI+SKuiuzQiZACuj/oWjzxWWRkXDLAxcEqSsx5OjPSybuet9Cy4lhDM2rZLd1hSPM5t+kD2sf8mY0GioS8dpKDVf3+QD8wJHo98Auv8XRlxKxtNySIqs4gDEZkT229xs1rDuaQIr2udAGkYosflowCPY3r+/1n0gtHHfLGGj9U5RkcH2JPHjYIEx9sD5vlEjS6ut8c+9+WHYdPxj82HCfTZF2gQOL+SK6hFGG60iV7y++LykOcRnQjOtffDCX+QG/OEKINvSpI2vyH4kNyemFZjRGkvdnmuhiwgByEZgSTSexqS3SQV81M6JwehigZ6XWVXCJx7omU8evrwMhpifBxG0K6J5C2YGpEzrgs+3h+cgcLfYC0jV9JQeZ2N90IR+pFzqXXQNRrSicSExK4MfWmW
 LcuGoupl
 MzBsG9zPuL8k+YGeM3X7tklUDaDzf5FhZmW1Xv+7BXUa9vwfrwAWBlU+iyqTB4YrU2eLhcQJajffdsixqPFjhbr9LXNschsFKBNxc8RJDE3jvj6+IqHRCMK+hgjwLdEuOUxwaQgd58Mxe6QjCmo4hQ3b7QZztBcxZUi7oX4xof1iHApyTTgTbXbe1sEr7SSaAlRXGATxTN9X4NAd2/sU9Oq9ymzFR62g5VoZdv7RysHKSQiBqzAJzk+DDeaR8GlYMPWhzwqtqhct0tFNv16YIGgzAjQ==
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
 mm/huge_memory.c                           | 81 ++++++++++++++++++++++
 mm/rmap.c                                  | 19 +++++
 mm/vmscan.c                                |  9 ++-
 mm/vmstat.c                                |  1 +
 7 files changed, 117 insertions(+), 1 deletion(-)

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
index e7107e0991ad7..41cf643a3f55f 100644
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
index 10d265c7e6331..d2f7a22aae3ad 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -5640,3 +5640,84 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct folio *folio
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
+	if (WARN_ON_ONCE(!pvmw->pmd || pvmw->pte))
+		return -EINVAL;
+
+	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
+	VM_BUG_ON_FOLIO(folio_nr_pages(folio) != HPAGE_PMD_NR, folio);
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
index d1819fd699380..4997724c2dd85 100644
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
index c1404a59523d6..94038e8cc64d0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1329,7 +1329,14 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
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
index cb57714539fb5..f40bca6aa45a0 100644
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


