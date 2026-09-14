Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D93C88E66
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B06C6B00BE; Mon, 14 Sep 2026 08:32:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03A5B6B00BF; Mon, 14 Sep 2026 08:32:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7A76B00C0; Mon, 14 Sep 2026 08:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC7DD6B00BE
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:32:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 687151603EB
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:32:17 +0000 (UTC)
X-FDA: 85212305514.13.47FB913
Received: from mta0.migadu.com (out-116.mta0.migadu.com [91.218.175.116])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8408540008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:32:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cWHd3aIb;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.116 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHEX2Yvmjkqey8se3HB0fBhx7GPTqOtmcivHPxTA5Y4=;
	b=vOfquOXNJjlIIgTpxG1gf66GpxZxcFBtjhaZ3Pfe9O+PO+SkHANfquVz0H1LcCu/skgcXX
	Z56sTHRCc+8VsbFxVwj8Si/TS7zaF8Ckhe7nW2CALiac+QA6Eg6hH5ccqpQcDw+utDL2xI
	3BptqjCZAr3nRVjrJCuSGFsDaFMjcrE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389135;
	b=S9jIUl63IDx73ztpzLS0wyuqLwKdIWErR8uG1dz0O3ND3xnbxYPIVeIqVZzFak7iA9tje7
	c5TT14EHZ29J/NiPscetEpUQPkgjW5sFMQpcP8YBBuRLPDNCykL9rb36KEVWdpztqzYIDo
	wgg0IJNhYdE6ljTXxvoTBKhCGsk48GE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cWHd3aIb;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.116 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DPe1I53E+kRlfcEsvDmSLP4EjuaTV/Jtl8i3KROoEu4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389134; v=1; x=1789993934;
 b=cWHd3aIbAE0S4Gf3wLWy2lcbND2U0Gtf2X92xQsL+kp1icn5x4TtyI7/kjNmTch0G5/Sljpa
 1oSfY9kiYacqfXYv1Um1K6+oS12w6khouByqCjHHOPPlnVJStAAforDABS+7bj4lhMvqTG2ihUM
 tUfdhFhNPYsjpFbPQ1GkJy80=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 374a9e1bbe50b91d;
	Mon, 14 Sep 2026 12:32:14 +0000
X-Mizu-Trace-ID: 374a9e1bbe50b91d
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
Subject: [RESEND v7 28/29] mm: install PMD swap entries on swap-out
Date: Mon, 14 Sep 2026 05:28:18 -0700
Message-ID: <20260914122950.3283997-29-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8408540008
X-Stat-Signature: infgm4ytztmw8wdd9qh3z8uoido7ihbo
X-Rspam-User: 
X-HE-Tag: 1789389135-461149
X-HE-Meta: U2FsdGVkX19KURGj1FFXC/OQ9Hfv/EM1RfrzqicgopJsdy1K/GQz7lozOydUdLDQLEEqTzdqTcXH66d454OXBbMCt0QBE/4pGi9HQG7DZNzB4/o0D9Fd19OV1ukTTRpl6SWGcdCfhgIe4LWNtYmwSknVol56uGTnymqKZ7fc3knGShakt3/iGVdQwJL0cXbEjPE+02Op7qoa8oi/uvjan7wzeopfREX2DsqVSkUenzcJHJTslFihJnllihuwg6lo6YPEK+uayAZj7CPIOrhIBxLWOSC3IjMXtIbScLlZO5P7uedydINZKjgGV7fs54hpOhTpdcq8B6fbtUTXv4qALXmfO5pcD8gm0iA95BKh7/EBSXHsZKGXX4eGDRV1e+FsUaIu537ZqknEvDApHqIR5WdjQ5gkHuzY1XfKUmm0NWcAuYNW+c+Rr7JcGIPWh2nfUwl7S7Njz09QUF1v2z1Nkm0Xn3XY9Yq5EVPfoCizBen6Qln7fku2q6gXq2vaY1l8ChxJSMA4zZ0whZC8B5hyQPHlpy9AyCo+oz34+N7EMTa8DvORPuh3XUsjPZW1hqKFy7E7XTrjRlvEvBmkQ4acrMdvsr/UMy7Rt2GoSbMcSnNK6m6/2RcZVUfaL1SnqQqrNP0qapjHFrN1aQVcSOt9PQwTPKKSPSX1XSliUFbef1av8LtkeWneI7BTWuIiDOZsGSzdo6xm3AHGmsLQFNqCfE0VdkALMLGwKnlwWxf+YYb69ZtiW0dapiQR6Z9e6FrejFuqrGdC/Ubh1i4Mxb9Yd7drTaxAZfj81GSID5i31n0B833zbdpAWlUMVwRF8rjL/JslS1g5AojBdHNMid3oYEdRX0AulePBEONebNikJK502i0wOTJLEPFEfrOv5OrwRP9CcooQWzA41hP7ca9kTHSZYeuT01s6HG3mFqVgSTZf1YICz6RMETLmhQqGBqtQozlN1eSapcYizOBaJAq
 ccvAGJUs
 /AYOzjyNkkQcwOd1z3BkyIrSYkHGaERTqcr8YnNQbRuMZu3RjvxZIj2kOWX//pf35v2A5CW8MjzCzwnrq4+Fn/JOP2ENbDkj2Hir/RVc4oLoKuLdLqFIOqpcXwdRMZocDZEfPRMIpLsJdiGogfxE4QLxZLmI6Pw1h7HYmcU+N+n8oTb5AyVOh3SNP2N9LpaOBjl6gXXltSXQjP7x3Zm+4jZygaTCu3qo5iouzjPnn7biVKWw=
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
index b44a228dfe20c..86c65e3a6c5d1 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -550,6 +550,8 @@ vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
 
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
index bd9cc24c2b011..317d2108105de 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -5736,3 +5736,87 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct folio *folio
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
index feb751e29b992..3745f16cf5716 100644
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


