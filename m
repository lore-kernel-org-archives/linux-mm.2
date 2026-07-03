Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A07ADC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 462F66B00C9; Fri,  3 Jul 2026 13:40:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43BB86B00CB; Fri,  3 Jul 2026 13:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329776B00CC; Fri,  3 Jul 2026 13:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFBAD6B00C9
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:40:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A7E11A024D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:40:26 +0000 (UTC)
X-FDA: 84948179652.25.36E5AED
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id A82B510000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:40:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xlDQnDi1;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783100424;
	b=rBKP6KaSyeKtBGICnRNNl+xgURNRE1uEo//rCtmiUdtqX0vp9ycDUN4Fti1I0cSQw8mb6N
	O9bZQM1fTnFucS92jiPC514KPXD2Q8Kpj11bxHmTESgRGi8WDJIkzjaiU8rdjdONRfewpw
	eUEJeWDZoCS5JlALcLOJWMa8CqoHdU0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783100424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIKK6DMFFJwzMMiY6SJDhTvan3XaCquMxcgpKmovFJQ=;
	b=LKrcBIlATpepBQV9ud8sQUwUKOryd2OBRufNYEEC3JpoZeB9B1VTmjMqmrUwFGYkXU2N8O
	poA2L8hiQFViBxLlynEHCrHNYNfaj3cuua00Q1zIa0Av5EJiSvEuQk29+j5oQDWFZ6GB0n
	yBzFBGxpcxrw7gUuNqv0na75FRp6tI4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xlDQnDi1;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783100423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TIKK6DMFFJwzMMiY6SJDhTvan3XaCquMxcgpKmovFJQ=;
	b=xlDQnDi1eJb7mB41mK8QD/2cNRK+ueQCKVK7GbYxJXS6RhYhZZIzP0RCPITOxkp9g40W0W
	8yiE94miZOQhQozInKm/zuW5suiydqb3xsmHZF6agllMmqA491ZbDIgkgvVSWs63cCIgCA
	dTv1gniv+Yu2WRLFgGq5sGhUbPrVd78=
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
Subject: [PATCH v3 10/11] mm: install PMD swap entries on swap-out
Date: Fri,  3 Jul 2026 10:38:27 -0700
Message-ID: <20260703173903.3789516-11-usama.arif@linux.dev>
In-Reply-To: <20260703173903.3789516-1-usama.arif@linux.dev>
References: <20260703173903.3789516-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A82B510000A
X-Stat-Signature: 9kmzpboec4r9bth49utfzuyunbgisn3n
X-Rspam-User: 
X-HE-Tag: 1783100424-303601
X-HE-Meta: U2FsdGVkX1+Rg7wKYNduzfQLfslcK+rUCj0UmXCoBcte3ULpKoCCef45Izf2R+vKJCtj2k0DktR9fed5ojqNceaKvMryWxDwfISv/oNdv2+djv6K1jSIE0+zAhMmwWdf1+TDjExau2ejNHsRgZXlUd35VN921mq0f/3x4vHYyO41JutQPa3NKAO1Ol3zIdmESbIkOXtCaTgVOwjCNIWyZeC7sx4y+AKtTJL8ErzgMvlLYDEJbjRhqM2x3D9FFEbfgsFgi6RbH65Vmg2+TRzTpfFNzW4z5dFz6butUj/i7V3Xk8jjDqhYMuxCadoqiPaGSTrhE1IbGMnkeRknQ0W8ZwuKLGDMG5rrGm6OdJGUDC6hM59ugLu8hf5DJS6Yc1ok3IGbdgIz3U274ne/cgTt5ttCqGD5dQLxZ96Ni5EjQjZcbqb5sEEVKV1JH3TRKaLhkYC8cN6tpNIWecXYoxq+R/av3IwmvqqFQdwLnXGsbaxIr8RpjE6uUV0lE4bUjJG8d8pCxGo5Nnu8xUwYsxIOkPvLsIAJxiJwG37ZUqG5NkVerzqr/Ns9FzkmfTN0dOUhziERaZqwstIBxiMQ7iwPnk5+1TbjKDY9/awMzKsDDT7AlByeRhfZZe1F+pcIJBKab0GixEs0sNeAo2vPPU4TiTQP8sLcvEXPN679+54yIJylTlTCt76/tenMxALzewVmxhoiX4q9VHSC2LNcIwrTPPT7rNqDK7DB3uirw+77349G69lPz2dN+6r7h5w+HyQeRdGZfaKKKYOHCOq+gqYA+MufuFkEhzN/MBjYF2B2cVsHPDmy6s+GEe+dZQxQNAYv/L/bg8T8s9cALw9mUnYQx1EY7xOoza784t/rhWrb4s5pdtbHaquevrDHZRVoOz91f4dPk3mU1JMMt0DqVH25zP0YMOslfzQzSY7UMbvwSQFcg5srg1wq8ooZEBg+p0dREmD5xG+QNKF9C1lJOAc
 LNJH8WIL
 TUVqROQzlvXQq0vxzxtzBLmAS0qqVRBO/hZ52WDGasM/d0GFNq2BYiVXcGGz1QdWbRHfs5HkoF9zRWA8iw4XvPmMKZ5zP5Ho134jE5DqO1hRd37PDOrroDhoMwkY/HfRzUxvRCF1CPKqWXumIWCo14ckcMkTuQbN7XezvrBWBsOC/zc0+4b7c6uI59mWD4jAqkccx8iPCmM5gSK0=
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

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/huge_mm.h       |  2 +
 include/linux/vm_event_item.h |  1 +
 mm/huge_memory.c              | 78 +++++++++++++++++++++++++++++++++++
 mm/rmap.c                     | 20 +++++++++
 mm/vmscan.c                   |  9 +++-
 mm/vmstat.c                   |  1 +
 6 files changed, 110 insertions(+), 1 deletion(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 9ec475ccfc91..b746f8c8db69 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -533,6 +533,8 @@ vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
 
 #ifdef CONFIG_THP_SWAP
 vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf);
+int set_pmd_swap_entry(struct page_vma_mapped_walk *pvmw,
+		       struct folio *folio);
 #else
 static inline vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf)
 {
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 03fe95f5a020..7267c06674c0 100644
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
index 5fa60324a2f0..7ec81a9c4bc1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -5450,3 +5450,81 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
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
+	if (pmd_dirty(pmdval))
+		folio_mark_dirty(folio);
+
+	entry = folio->swap;
+	pmdswp = softleaf_to_pmd(entry);
+	if (pmd_soft_dirty(pmdval))
+		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
+	if (pmd_uffd_wp(pmdval))
+		pmdswp = pmd_swp_mkuffd_wp(pmdswp);
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
index 0fb7a1b82cf3..ffc7aa62a29e 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2079,6 +2079,26 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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
+				mm_prepare_for_swap_entries(mm);
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
index 56fe5393f30f..3d7999c3f1ad 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1321,7 +1321,14 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
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
index 7b93fbf9af09..629055399987 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1421,6 +1421,7 @@ const char * const vmstat_text[] = {
 	[I(THP_ZERO_PAGE_ALLOC_FAILED)]		= "thp_zero_page_alloc_failed",
 	[I(THP_SWPOUT)]				= "thp_swpout",
 	[I(THP_SWPOUT_FALLBACK)]		= "thp_swpout_fallback",
+	[I(THP_SWPOUT_PMD)]			= "thp_swpout_pmd",
 #endif
 #ifdef CONFIG_BALLOON
 	[I(BALLOON_INFLATE)]			= "balloon_inflate",
-- 
2.53.0-Meta


