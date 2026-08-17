Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFBFAC5DF70
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 09:15:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDFF56B0927; Mon, 17 Aug 2026 05:15:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB7E46B0929; Mon, 17 Aug 2026 05:15:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6076B092A; Mon, 17 Aug 2026 05:15:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E4E26B0927
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:15:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0483A1406E9
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:15:07 +0000 (UTC)
X-FDA: 85110202296.23.A4124A2
Received: from mta1.migadu.com (out-16.mta1.migadu.com [95.215.58.16])
	by imf12.hostedemail.com (Postfix) with ESMTP id 565534000B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:15:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vXxHi0hF;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.16 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786958105;
	b=mWRKi6MuI8+1Ha3CQ5G79aDf6+Ob1k1rb80ulTiAr6geUGjy+cxPE+uEWV2XfE9NzNzsiV
	hd3/PJsNGHUrcC1IuS3qtNtqTVo7x0yX/Xo7eTARKZYL6nvkGXIkR86+lCqqRwH7fKQQJV
	zUfP6A/vEHidzCMSXVE3NdrQ6Xop1g8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vXxHi0hF;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.16 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786958105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xAJkncNFO1CV14jrHvP8WQr7ofW3QBRXSu2XlOlQXP8=;
	b=ZnllLLHJCvsH5DOWOxrrmKDcoPiH+6D72RD0CRFQaiCncUSUaFEr2pi46aIbhQ2THa8xBY
	jgF5qJ4CNX+ZoAuuOg/1ozAXQeu1h8RyZT+UTmDk0rtizMY/Y/UJK9+/95hPkfxCM30G3X
	AzQmHZXB5Og7GjYoU/KH+kjvS1Osrzg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=pWjIzPp6KhwnpZxPKLQY7HtxbwT6Y+7x5vhR3ao5oew=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786958103; v=1; x=1787562903;
 b=vXxHi0hFLegDUVRy+lP+4FNVC/Sr0bIpIpJD42KG0oy70BkKjScvTiflAlW2Ge8WkM8a9C66
 X52v60JaH51CFBoiWuaUzR8c6A61L4uQye5pnpxsMf8n9D3kYGqcg8a+h/cCzuXQyQRTDHAy4MU
 VRviEzpVtdXkf2w+deLb8yNE=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 61a6489cc58dd9a8;
	Mon, 17 Aug 2026 09:14:53 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: shivankg@amd.com,
	linmiaohe@huawei.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	kmanaouil.dev@gmail.com,
	fvdl@google.com,
	kinseyho@google.com,
	weixugc@google.com,
	bharata@amd.com,
	rientjes@google.com,
	dev.jain@arm.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 7/7] mm/rmap: batch the unmap of large folios in try_to_migrate_one()
Date: Mon, 17 Aug 2026 17:14:44 +0800
Message-Id: <20260817091444.58876-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260813-migrate-rmap-batch-v2-7-3c5424c555c7@amd.com>
References: <20260813-migrate-rmap-batch-v2-7-3c5424c555c7@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 565534000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: oojs3kphrhxqjro8u9wptrzphjtbiboh
X-HE-Tag: 1786958105-432067
X-HE-Meta: U2FsdGVkX1+NyxOYIwRa54APuCRtHr1VA/LDA62bUOfbAk55IRevyGFAdIdn64o58vrQ6PN+6teovfZfjRCFdbYN9Yv6NnXv5xeoDkU1d5rMDjZ4ImF2KJIWEKaiJ3zJTZ4k20IidxgTMxXqcDUt51lh8fBDjANgvQPRPs33Rtn+gBvAX8SLCHotCZPFSVzC06H4EG/s5NN0x1CUYpCNsoXndVes4zk3G6KJMkV8sT1BHTpx6i07LZe27549QUpMiLMdPyiYQ+aT6jVQQNxJnLRd7QwJac2/Vteh20qlrAesDJ+U296jU+yOw6F3xYJuMq8Z88vM8rkZVJWwk240kL5+d9pl4NO7YtOnGq6/Ou4OBOTokTGFB+hrYJAj165hf0cONf4oef+bcs6J1OHiIIE+/q5+GOmV7XeLhs1ws1paz4EwfNbZinjytKq0OWkoD7amG7jorOpA7qlm1mb+kw2ouQM5S/t2TN7gQyNtzD7XI7GZTuGP9x51DpDf/S2jLqdwrN42BQDcbU2GXUPmaTsVJCtDIOvB0aIin/QyUMdqpkPatj5GmarPoihanPbLUoJHjyq8fdW0S4qMJDC/GKVdJ72jhX5sIQCZL9K+iKW6sG5K4Q+UxLAR+mFL5xZ6Ovh+afuOa8YfignwE8OE1WwdXrwC6YE2KOcBeCFkrFfBF8E4XA+AmRgTxFeGmOxZn1stFJezOvk4WxSjMioAgI3dC3xxNh7O2pRlZbtyZSuR5MKEZPNzSjzTeWdFF0w8ON3UBQCUhA/kvbA3ChyST/In5+FYFel0VzU436evYM2zbw2WihrmR7xr99yNfnzMVV0W4NYzct/Df74tJGgzBbfj2+PcVljaby/ZsSJ2FcxJzq3U4QKG7txmD72Nl0/ScDI5VGNYmMlq9hjdq4g7MoUOcCu+SxUEy5cWnHP2d46YbCwjxmjt15qBoG/tfkBqAOGp6v97R7Y/fCjACfl
 hhEa2G9P
 5R4awdvLr8JWjHNnqE/iLphu8QfpxX3bXl2dXeL12ZgRgg1/OkskFsLNwvJ0Yie/kXnbSzXLWkWgh2SaaW6wupduRkoXnoaj1mbUHmCsCPkm4Mj388AF1EKGOHsunQi2N/vm8AOaIxFuLTsmGPQ8DVubaxXGPVgW3xEOyMtG/xqADqHuUNuGdQ/ol3VHmFxZ/60qQMvSSKse6/gEMM2cUwabjKdxKnQmstHcUUzs4nCYsr+LUUgxE8YHX/pyfe4qWVB5Un+h/uSYnwElHwrNOIfLhfjUDGI6dvjXBFrlAxNPj+dujj87lH2JKTTAZyq4H57NrikBk9UoufGQduwqYn4LYRUQQeL6TObeJmqzR3mCX0aHJG/p2RAI0HaA7pLJxM2JtJ/6xjY+AjKDv3+4fusxiqPBsGI1TMVG6w80PqEDqvhs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc Miaohe

On Thu, Aug 13, 2026 at 04:23:18AM +0000, Shivank Garg wrote:
>try_to_migrate_one() converts present PTEs to migration entries one at a
>time. For a PTE-mapped large folio, this repeat calls to ptep clear+flush,
>the migration entry build and set, folio_remove_rmap_pte() and folio_put(),
>each re-entering page_vma_mapped_walk() once per base page (256 times for
>1M folio).
>
>Mirror try_to_unmap_one() to introduce folio_migrate_pte_batch() to detect
>eligible batch for PTEs mapping conseuctive subpages of a large folios,
>and convert the whole batch in one shot using the batched helpers.
>
>A side-effect of this change is trace_set_migration_pte() will record
>one event per batched run instead of earlier behavior of one per base page.
>
>Signed-off-by: Shivank Garg <shivankg@amd.com>
>---
> mm/rmap.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++----------------
> 1 file changed, 86 insertions(+), 29 deletions(-)
>
>diff --git a/mm/rmap.c b/mm/rmap.c
>index 35752a70f3a0..63b885c0b7ef 100644
>--- a/mm/rmap.c
>+++ b/mm/rmap.c
>@@ -2675,6 +2675,44 @@ static bool try_to_migrate_hugetlb_one(struct folio *folio,
> 	return ret;
> }
> 
>+static inline unsigned int folio_migrate_pte_batch(struct folio *folio,
>+		struct page_vma_mapped_walk *pvmw, pte_t pte,
>+		struct page *subpage, bool anon_exclusive)
>+{
>+	unsigned long end_addr, addr = pvmw->address;
>+	struct vm_area_struct *vma = pvmw->vma;
>+	unsigned int max_nr, nr;
>+
>+#ifdef __HAVE_ARCH_UNMAP_ONE
>+	/* Cannot batch unmap if arch_unmap_one() is defined. */
>+	return 1;
>+#endif
>+
>+	if (!folio_test_large(folio))
>+		return 1;
>+	if (folio_is_zone_device(folio) || folio_test_has_hwpoisoned(folio))
>+		return 1;
>+	if (pte_unused(pte))
>+		return 1;
>+
>+	/* We may only batch within a single VMA and a single page table. */
>+	end_addr = pmd_addr_end(addr, vma->vm_end);
>+	max_nr = (end_addr - addr) >> PAGE_SHIFT;

Hmm ... can this still batch over a poisoned tail page?

memory_failure() sets PageHWPoison() before taking folio lock, but
cannot set PG_has_hwpoisoned until it acquires and releases that lock.

So tail page can already be poisoned while folio_test_has_hwpoisoned()
still returns false ... no?

Starting from a healthy first subpage, folio_migrate_pte_batch() can
then batch across poisoned tail page. hwpoison only describes first
subpage, so set_softleaf_ptes() installs a normal migration entry for
poisoned page instead of an HWPoison entry ...

Should folio_migrate_pte_batch() check PageHWPoison() on every candidate
subpage and stop before a poisoned one?

Cheers, Lance


>+	/*
>+	 * If unmap fails, we need to restore the ptes. To avoid accidentally
>+	 * upgrading write permissions for ptes that were not originally writable,
>+	 * and to avoid losing the soft-dirty bit, use the appropriate FPB flags.
>+	 */
>+	nr = folio_pte_batch_flags(folio, vma, pvmw->pte, &pte, max_nr,
>+				   FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
>+
>+	/* Limit possible batch count to a uniform PageAnonExclusive value */
>+	if (folio_test_anon(folio))
>+		nr = page_anon_exclusive_batch(0, nr, subpage, anon_exclusive);
>+
>+	return nr;
>+}
>+
> /*
>  * @arg: enum ttu_flags will be passed to this argument.
>  *
>@@ -2686,12 +2724,12 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
> {
> 	struct mm_struct *mm = vma->vm_mm;
> 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
>-	bool anon_exclusive, writable, ret = true;
>+	bool anon_exclusive, hwpoison, writable, ret = true;
> 	pte_t pteval;
> 	struct page *subpage;
> 	struct mmu_notifier_range range;
> 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
>-	unsigned long pfn;
>+	unsigned long pfn, end_addr, nr_pages;
> 
> 	/*
> 	 * When racing against e.g. zap_pte_range() on another cpu,
>@@ -2744,11 +2782,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
> 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
> 					!folio_test_pmd_mappable(folio), folio);
> 
>-			if (set_pmd_migration_entry(&pvmw, subpage)) {
>-				ret = false;
>-				page_vma_mapped_walk_done(&pvmw);
>-				break;
>-			}
>+			if (set_pmd_migration_entry(&pvmw, subpage))
>+				goto walk_abort;
> 			continue;
> #endif
> 		}
>@@ -2773,10 +2808,25 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
> 		subpage = folio_page(folio, pfn - folio_pfn(folio));
> 		anon_exclusive = folio_test_anon(folio) &&
> 				 PageAnonExclusive(subpage);
>+		/*
>+		 * memory_failure() can set PageHWPoison concurrently without holding
>+		 * the folio lock. Snapshot the flag here to decide whether to batch
>+		 * PTEs or install hwpoison entry.
>+		 */
>+		hwpoison = PageHWPoison(subpage);
> 
>+		nr_pages = 1;
> 		if (likely(pte_present(pteval))) {
>-			flush_cache_page(vma, address, pfn);
>-			/* Nuke the page table entry. */
>+			if (!hwpoison)
>+				nr_pages = folio_migrate_pte_batch(folio, &pvmw,
>+								   pteval, subpage,
>+								   anon_exclusive);
>+
>+			end_addr = address + nr_pages * PAGE_SIZE;
>+			flush_cache_range(vma, address, end_addr);
>+
>+			/* Nuke the page table entries. */
>+			pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
> 			if (should_defer_flush(mm, flags)) {
> 				/*
> 				 * We clear the PTE but do not flush so potentially
>@@ -2786,11 +2836,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
> 				 * transition on a cached TLB entry is written through
> 				 * and traps if the PTE is unmapped.
> 				 */
>-				pteval = ptep_get_and_clear(mm, address, pvmw.pte);
>-
>-				set_tlb_ubc_flush_pending(mm, pteval, address, address + PAGE_SIZE);
>+				set_tlb_ubc_flush_pending(mm, pteval, address, end_addr);
> 			} else {
>-				pteval = ptep_clear_flush(vma, address, pvmw.pte);
>+				flush_tlb_range(vma, address, end_addr);
> 			}
> 			if (pte_dirty(pteval))
> 				folio_mark_dirty(folio);
>@@ -2809,7 +2857,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
> 		/* Update high watermark before we lower rss */
> 		update_hiwater_rss(mm);
> 
>-		if (PageHWPoison(subpage)) {
>+		if (hwpoison) {
>+			VM_WARN_ON_ONCE(nr_pages != 1);
> 			VM_WARN_ON_FOLIO(folio_is_device_private(folio), folio);
> 
> 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
>@@ -2837,19 +2886,15 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
> 			 * so we'll not check/care.
> 			 */
> 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
>-				set_pte_at(mm, address, pvmw.pte, pteval);
>-				ret = false;
>-				page_vma_mapped_walk_done(&pvmw);
>-				break;
>+				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
>+				goto walk_abort;
> 			}
> 
>-			/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
>+			/* See folio_try_share_anon_rmap_ptes(): clear PTE first. */
> 			if (anon_exclusive &&
>-			    folio_try_share_anon_rmap_pte(folio, subpage)) {
>-				set_pte_at(mm, address, pvmw.pte, pteval);
>-				ret = false;
>-				page_vma_mapped_walk_done(&pvmw);
>-				break;
>+			    folio_try_share_anon_rmap_ptes(folio, subpage, nr_pages)) {
>+				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
>+				goto walk_abort;
> 			}
> 
> 			/*
>@@ -2859,19 +2904,31 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
> 			 */
> 			swp_pte = make_migration_pte(subpage, pteval,
> 						     writable, anon_exclusive);
>-			set_pte_at(mm, address, pvmw.pte, swp_pte);
> 			trace_set_migration_pte(address, pte_val(swp_pte),
> 						folio_order(folio));
>+
>+			/* Set nr_pages migration entries, advancing the PFN. */
>+			set_softleaf_ptes(mm, address, pvmw.pte, swp_pte, nr_pages);
> 			/*
> 			 * No need to invalidate here it will synchronize on
> 			 * against the special swap migration pte.
> 			 */
> 		}
> 
>-		folio_remove_rmap_pte(folio, subpage, vma);
>-		if (vma->vm_flags & VM_LOCKED)
>-			mlock_drain_local();
>-		folio_put(folio);
>+		finish_folio_unmap(vma, folio, subpage, nr_pages);
>+
>+		/*
>+		 * If we batched the entire folio, there is nothing left to
>+		 * walk; stop right here.
>+		 */
>+		if (nr_pages == folio_nr_pages(folio))
>+			goto walk_done;
>+		continue;
>+walk_abort:
>+		ret = false;
>+walk_done:
>+		page_vma_mapped_walk_done(&pvmw);
>+		break;
> 	}
> 
> 	mmu_notifier_invalidate_range_end(&range);
>
>-- 
>2.43.0
>
>

