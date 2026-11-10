Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49DB3606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=f6b5mj7B
Received: by kanga.kvack.org (Postfix)
	id 5F4D36B05B3; Tue, 10 Nov 2026 06:03:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC396B05B4; Tue, 10 Nov 2026 06:03:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E1E86B05B5; Tue, 10 Nov 2026 06:03:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2934D6B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:03:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1FB4B1204C8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:03:40 +0000 (UTC)
X-FDA: 85418923800.21.A88286A
Received: from mta0.migadu.com (out-66.mta0.migadu.com [91.218.175.66])
	by imf07.hostedemail.com (Postfix) with ESMTP id A7D0D40004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:03:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f6b5mj7B;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.66 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794308618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mosdG3m1bRhwTBPl1OmMcPEQ8m7G/FmmnXvyKEgSjA8=;
	b=cIGLYAf6pe0zwqtdJsqOTM84g8QKimjtcfPb0H4TrOamiwUR6ERuFUZ3JI+mP2GY0zVshu
	Z+MoXZVzLNeF4Olb54Fm3oMsYesVpG6yiLWsE/dtim/gh+m2jRHgPWDHlZ6SkRZYhzVd76
	hCCXKN9Z4QpwK3eOYu7exgjcI9oUKSU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f6b5mj7B;
	spf=pass (imf07.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.66 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794308618;
	b=k2rXmtdR9NwdUji4EKXB6vHDlaxSYbdqHeztpv1dBrJm809Fb0I37O3T6UFh+hFKcE2N4Y
	e0n7HenjnlNHJ7f7vkK1fVuCO4QFoXoHXcIEIFHAb6Jbc4pSoIIRc7aFXD4e0oG97MCOY0
	wBpfVeBpnKmmZ4jG4wYHIZX1OPQElM8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mUPWKMxHATpoQg7UoNknqz6Qt/NzOxdqRnGP/yPu89E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794308615; v=1; x=1794913415;
 b=f6b5mj7B7q+PSXXmwKjKMIWzWnQS0vX+kTwLDLRUe6Y+jhcGmcs3KEt/pVtI9B8nHzlLNYnM
 KuDwFz3Bgua5wwnJ4EcX+/z+xBohEDdNn6tCKAMEC+bXQ25kuq/rTmHj3jLJWOjJkFCpMGhVWiP
 vCqhlC+77YL93s3QTPO9Xd8o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e0298fe87bd0bf54;
	Tue, 10 Nov 2026 11:03:35 +0000
X-Mizu-Trace-ID: e0298fe87bd0bf54
X-Migadu-Flow: FLOW_OUT
Message-ID: <37001416-f72c-4c32-857d-4202aa181d72@linux.dev>
Date: Tue, 10 Nov 2026 19:03:25 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] mm: hugetlb: enable CMA allocation for PMD-sized
 pages
To: sashiko-reviews@lists.linux.dev, muchun.song@linux.dev, david@kernel.org,
 osalvador@suse.de, akpm@linux-foundation.org, azpijr@gmail.com,
 Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-mm@kvack.org
References: <cover.1792651104.git.zhengqi.arch@bytedance.com>
 <5edd1dc82bd3b0b09005c0b36cafa2f7baea6d3d.1792651104.git.zhengqi.arch@bytedance.com>
 <sashiko-outbox-181243@kernel.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <sashiko-outbox-181243@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cm3i7oxsdzcp1g3sbrik945768jfz8ad
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A7D0D40004
X-HE-Tag: 1794308617-913084
X-HE-Meta: U2FsdGVkX185pYRfh0GiXeR76Ze1o+qlp6DT5GFs0vBkuFzJkhA1UAgFQ2ZkH2oDwLX2sl/EI0owiko8MkzUGwIKAKxkfifvF8IoxIG17IYXXEelqtrCd46E8Q7yhMcKImDn3B625fbHH/Rrnz3LeE+cDTddkg39LwGQrSml8LxqWhkjWmRgd1woOCWgdRS1Lh5DvHkZaOUA15vrq7EJljOFpX5tl5+TJH26qU8WH86Il2ZWCZUOgAjsxVeG/KObRiO7y4zKvnU/rNP0VNJ1sdybvsyI5eLuzOq/MLqV8YzZe6GY5Bgdont45BTKmoyEdaZ/kP8nhyaGERHBTKunahNSqa3yXKIpxhbestV7/kef7AmFkHoJXDIZVwPuwe4ZwayPUKAz6SySMlW4hr0n44RrloqUW0A5gWnfWhpYAtMReMHfkLXBC5bpp0OpuCu0F+Z+SU+fm+r578og1xXLhd3gLKolrHpVVDzrbNPzsn7LqYN7J2j1OuMNEx02HVtc5rmrD36INk/HCmoJWdBlqBlL9rhzaLC26/a5bjXog5Oq2HOtwoNNJgcSl0wikF1gCdv+/it0ACH8sWjoN3OKHfrBl3PqZ/AvK0Fpfjk+p3RFj9k86haMaLk1BqhBvaRUG7w5kbGbilDVfRoiD4ITrQTn7dYUqCfRa4DZbqqbQ49EJPqBUYqhCk+cd9d8F+L8jUW8IQ/VOzCh4EBlmxdDXffZXFcAnEwD3Q6Ak3av3sWRkjhQzwsHcyzLkyyBR+22A2a02Uzx7oH8l70wWTSyYj8wh7SSzcngLPbswztRBJlZXE0zGVq9Y/ZqaBeaTPcbVl2xWOSecGbxJsDNEFuOKo056GmOENEAh+oZTcKyeyb709HSnyPw5oj9FhRtFcSKmtSg6rgdgpdih1erFJGlaffBvgU3mv6nkdkXFhtWri09chPE9cHsbAt2l0VeXI6OqbafGVIbNAEIjsIBZ+K
 E8s9WtCX
 D0zOUM88bUzRcxcSjSKG41jqEBuAqSluuPQIOdeVwKJZrbPoHt2XxPnQR59V2fVRjkeSFdXvzPzWIhZj9QGYFnDViwEmYkhCR6nlIMjAqNB2XW/+u+CdoaLH91lO2wuGsyXSJ3b8Wd5hc9IzCcRgN9FnE2XZUHN5L1+JNnq///ehzS+foAio1qJ6T7K9dnjGLC83/QoSJcMUb3Umo1l2eSNbGuBKyvz9WjxYaYpw+R/q8sHxkKH891R6ov/mHLhXLpxhfzjVUmoo9bn4YMoDOelcDE32hIo1m5se19OkpZ6Z0CbTALD6lkKMDtUSil+FkwWHS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/22/26 5:13 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] mm: hugetlb: infinite FOLL_LONGTERM migration loop for PMD CMA folios
> - [High] mm: hugetlb: alloc_buddy_frozen_folio() consumes CMA pages without bitmap bits
> - [High] mm: hugetlb: folio_lock deadlock in CMA alloc for PMD hugetlb faults
> --
> 
> commit 9cf077a849a76f9279657f4fa6aef60b1b9348ba
> Author: Qi Zheng <qi.zheng@linux.dev>
> 
> mm: hugetlb: enable CMA allocation for PMD-sized pages
> 
> This commit enables configuring a dedicated CMA pool for PMD-sized HugeTLB
> pages via hugetlb_cma=<capacity>@<page-size>, trying buddy allocation first
> for non-gigantic PMD pages before falling back to CMA.
> 
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index c1a8d00be11ac..bad5cd4978c5e 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1835,22 +1835,20 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
>>   {
>>   	struct folio *folio = NULL;
>>   	int order = huge_page_order(h);
>> +	bool cma_only = hugetlb_cma_exclusive_alloc(order);
>>   
>>   	if (nid == NUMA_NO_NODE)
>>   		nid = numa_mem_id();
>>   
>> -	if (allow_cma && order_is_gigantic(order))
>> +	if (!order_is_gigantic(order) && !cma_only)
>> +		folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
>> +						 node_alloc_noretry);
> 
> [Severity: High]
> When hugetlb_cma=<size>@<pmd-size> is configured without hugetlb_cma_only=1,
> can calling alloc_buddy_frozen_folio() first consume pages from the reserved
> CMA pool without marking the CMA bitmap, leading to a livelock in
> alloc_and_dissolve_hugetlb_folio() or premature failure in cma_range_alloc()?
> 
> For non-gigantic PMD hstates where hugepage_movable_supported(h) is true,
> htlb_alloc_mask(h) includes GFP_HIGHUSER_MOVABLE. In
> __alloc_frozen_pages_noprof(), prepare_alloc_pages() and
> alloc_flags_slowpath() set ALLOC_CMA via alloc_flags_cma(gfp_mask), which
> allows mm/page_alloc.c:__rmqueue() to allocate PMD-sized folios directly
> from the MIGRATE_CMA freelists of the hugetlb_cma pool without setting bits
> in cmr->bitmap:

Yes, alloc_buddy_frozen_folio() can allocate PMD-sized HugeTLB folios
from MIGRATE_CMA when the allocation mask permits it.

Leaving the CMA bitmap clear is expected for such buddy allocations. The
bitmap tracks explicit CMA allocations; movable buddy allocations can
temporarily occupy those ranges and are reclaimed through migration or
dissolution when CMA selects them.

> 
> mm/page_alloc.c:__rmqueue()
> 	case RMQUEUE_CMA:
> 		if (alloc_flags & ALLOC_CMA) {
> 			page = __rmqueue_cma_fallback(zone, order);
> 			if (page) {
> 				*mode = RMQUEUE_CMA;
> 				return page;
> 			}
> 		}
> 
> Once completely free PMD-order buddy blocks are exhausted,
> only_alloc_fresh_hugetlb_folio() falls back to
> hugetlb_cma_alloc_frozen_folio() -> cma_alloc_frozen_compound() ->
> cma_range_alloc(). Because the bitmap bits for the buddy-allocated PMD
> HugeTLB folios are still zero, cma_range_alloc() selects those ranges and
> calls alloc_contig_frozen_range() -> isolate_migratepages_block() ->
> isolate_or_dissolve_huge_folio() -> alloc_and_dissolve_hugetlb_folio().
> 
> During batch pool allocation in hugetlb_hstate_alloc_pages_onenode(),
> hugetlb_pages_alloc_boot_node(), or set_max_huge_pages(), the earlier
> buddy-allocated folios are still held on the caller's local list with
> refcount 0 and without the hugetlb_freed flag set until
> prep_and_add_allocated_folios() runs after the loop. When
> alloc_and_dissolve_hugetlb_folio() encounters one of those folios, it spins
> indefinitely waiting for the current task to enqueue it on the freelist:

Agreed. Enabling CMA fallback for non-gigantic PMD HugeTLB allocations
makes this same-task livelock reachable:

set_max_huge_pages()
   -> allocate folio P through buddy from MIGRATE_CMA
   -> keep P on the private page_list
        refcount = 0, HPG_freed = 0, CMA bitmap = 0
   -> allocate another PMD folio
        -> buddy allocation fails
        -> CMA selects the range containing P
        -> alloc_and_dissolve_hugetlb_folio(P)
             -> wait for HPG_freed

Only the outer caller can publish P through
prep_and_add_allocated_folios(), after the allocation returns.

The task is waiting for an operation that it must perform later itself.
cond_resched() cannot resolve that dependency.

Before this change, PMD allocation returned after buddy failure,
allowing the caller to publish its batch. Explicit gigantic CMA
allocations already reserve their bitmap ranges, and gigantic source
folios are rejected before reaching this wait. They do not create this
particular same-task dependency.

I propose the following preparatory change before enabling PMD CMA
fallback. An unqueued folio should be treated as busy. Using free_new
also releases hugetlb_lock and any unused replacement allocated before a
source state change.

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6fba92b0f6749..fe54e93d81025 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2721,13 +2721,12 @@ static int 
alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
                 goto free_new;
         } else if (!folio_test_hugetlb_freed(old_folio)) {
                 /*
-                * Folio's refcount is 0 but it has not been enqueued in the
-                * freelist yet. Race window is small, so we can succeed 
here if
-                * we retry.
+                * The folio has not been enqueued on the freelist yet. 
It may
+                * belong to an allocation batch owned by the current 
task, so
+                * waiting for it to be enqueued could prevent forward 
progress.
                  */
-               spin_unlock_irq(&hugetlb_lock);
-               cond_resched();
-               goto retry;
+               ret = -EBUSY;
+               goto free_new;
         } else {
                 h = folio_hstate(old_folio);
                 if (!new_folio) {

This allows CMA to try another range or return, so the caller can finish
publishing its batch.

> 
> mm/hugetlb.c:alloc_and_dissolve_hugetlb_folio()
> 	} else if (!folio_test_hugetlb_freed(old_folio)) {
> 		spin_unlock_irq(&hugetlb_lock);
> 		cond_resched();
> 		goto retry;
> 	} else {
> 		h = folio_hstate(old_folio);
> 		if (!new_folio) {
> 			spin_unlock_irq(&hugetlb_lock);
> 			gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
> 			new_folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
> 							      NULL, false);
> 			if (!new_folio)
> 				return -ENOMEM;
> 
> Even when old_folio is already on the HugeTLB freelist (or in use when no
> free pool pages remain), alloc_and_dissolve_hugetlb_folio() or
> unmap_and_move_hugetlb_folio() -> alloc_migration_target() calls
> alloc_fresh_hugetlb_folio() with allow_cma set to false. That retries the
> same alloc_buddy_frozen_folio() call that just failed and returns -ENOMEM,
> causing mm/cma.c:cma_range_alloc() to break out of the bitmap scan loop
> immediately without trying the remaining CMA pageblocks:

The early exit on -ENOMEM can happen, but it is existing 
allocation-failure policy. It should be considered separately from the 
new batch
livelock.

Here P is a buddy-borrowed 2M HugeTLB folio already on the freelist or
in use:

PMD request:
   buddy fails -> PMD CMA selects a range containing P

Existing 1G request:
   1G CMA selects a range containing P

Both paths:
   -> alloc_contig_frozen_range()
   -> replacing/migrating P requires a 2M target
   -> target allocation fails: -ENOMEM
   -> cma_range_alloc(): clear bitmap
   -> ret != -EBUSY: break

Explicit CMA-allocated 1G folios have their bitmap bits set and are not
selected again. However, the old 1G CMA area can contain buddy-borrowed
2M folios with clear bitmap bits. This failure path therefore predates
PMD CMA; the new support adds a direct same-size buddy-to-CMA fallback.

I need to think more about the appropriate handling here. Simply
changing -ENOMEM to -EBUSY would broaden the retry policy and could
repeat expensive target allocations across candidate ranges.

> 
> mm/cma.c:cma_range_alloc()
> 		mutex_lock(&cma->alloc_mutex);
> 		ret = alloc_contig_frozen_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
> 		mutex_unlock(&cma->alloc_mutex);
> 		if (!ret)
> 			break;
> 
> 		cma_clear_bitmap(cma, cmr, pfn, count);
> 		if (ret != -EBUSY)
> 			break;
> 
>> +
>> +	if (!folio && allow_cma)
>>   		folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nmask);
> 
> [Severity: High]
> Can this cause an infinite migration loop when a userspace process pins a
> PMD-sized HugeTLB mapping with FOLL_LONGTERM via __gup_longterm_locked() or
> memfd_pin_folios()?

Yeah, and I think the patch below can fix this issue:

https://lore.kernel.org/all/586d6c53ab7e4c64d6e89ad3cf0cf7e07dabbfaf.1794046188.git.zhengqi.arch@bytedance.com/

> 
> Folios allocated by hugetlb_cma_alloc_frozen_folio() are placed in
> MIGRATE_CMA pageblocks, so folio_is_longterm_pinnable() returns false. When
> pinning with FOLL_LONGTERM, mm/gup.c:__gup_longterm_locked() (and
> memfd_pin_folios()) sets PF_MEMALLOC_PIN via memalloc_pin_save() and loops
> while check_and_migrate_movable_pages() returns -EAGAIN:
> 
> mm/gup.c:__gup_longterm_locked()
> 	flags = memalloc_pin_save();
> 	do {
> 		nr_pinned_pages = __get_user_pages_locked(mm, start, nr_pages,
> 							  pages, locked,
> 							  gup_flags);
> 		if (nr_pinned_pages <= 0) {
> 			rc = nr_pinned_pages;
> 			break;
> 		}
> 
> 		/* FOLL_LONGTERM implies FOLL_PIN */
> 		rc = check_and_migrate_movable_pages(nr_pinned_pages, pages);
> 	} while (rc == -EAGAIN);
> 
> Previously, only gigantic folios were allocated from hugetlb_cma, and
> alloc_migrate_hugetlb_folio() rejected gigantic hstates, terminating the
> loop with -ENOMEM. With non-gigantic PMD folios now allocated from CMA,
> migrate_longterm_unpinnable_folios() calls migrate_pages() with
> alloc_migration_target() and MR_LONGTERM_PIN, which passes allow_cma as true
> (mtc->reason != MR_CONTIG_RANGE):
> 
> mm/migrate.c:alloc_migration_target()
> 	if (folio_test_hugetlb(src)) {
> 		struct hstate *h = folio_hstate(src);
> 
> 		gfp_mask = htlb_modify_alloc_mask(h, gfp_mask);
> 		return alloc_hugetlb_folio_nodemask(h, nid,
> 						mtc->nmask, gfp_mask,
> 						htlb_allow_alloc_fallback(mtc->reason),
> 						mtc->reason != MR_CONTIG_RANGE);
> 	}
> 
> When dequeue_hugetlb_folio_node_exact() skips free CMA folios in the pool
> because PF_MEMALLOC_PIN is set and falls back to
> alloc_migrate_hugetlb_folio() -> alloc_fresh_hugetlb_folio() ->
> only_alloc_fresh_hugetlb_folio(), if cma_only is true or if
> alloc_buddy_frozen_folio() fails to find a non-movable buddy block,
> hugetlb_cma_alloc_frozen_folio() in mm/hugetlb_cma.c does not check
> PF_MEMALLOC_PIN and allocates another MIGRATE_CMA folio. Migration then
> succeeds into the new CMA folio, check_and_migrate_movable_pages() returns
> -EAGAIN, and the pin path loops indefinitely migrating between CMA folios.
> 
> Should hugetlb_cma_alloc_frozen_folio() or only_alloc_fresh_hugetlb_folio()
> skip CMA allocation when current->flags & PF_MEMALLOC_PIN is set?
> 
> [Severity: High]
> Could falling back to hugetlb_cma_alloc_frozen_folio() for non-gigantic PMD
> pages during a HugeTLB page fault also deadlock on folio_lock?
> 
> During a HugeTLB fault (hugetlb_fault() -> hugetlb_wp() or
> hugetlb_no_page()), alloc_hugetlb_folio() is called while holding
> hugetlb_fault_mutex_table[hash] and hugetlb_vma_lock_read(vma). In the
> copy-on-write path in mm/hugetlb.c:hugetlb_wp(), the faulting task also
> holds folio_lock(old_folio) with HPG_migratable set on old_folio:
> 
> mm/hugetlb.c:hugetlb_wp()
> 	spin_unlock(vmf->ptl);
> 	new_folio = alloc_hugetlb_folio(vma, vmf->address, cow_from_owner);
> 
> When surplus allocation in alloc_surplus_hugetlb_folio() ->
> only_alloc_fresh_hugetlb_folio() falls back to
> hugetlb_cma_alloc_frozen_folio() -> cma_alloc_frozen_compound() ->
> cma_range_alloc() -> alloc_contig_frozen_range(), if the target CMA range
> contains an in-use buddy-allocated PMD HugeTLB folio src,
> mm/hugetlb.c:isolate_or_dissolve_huge_folio() only rejects gigantic folios
> and isolates src onto cc.migratepages:
> 
> mm/hugetlb.c:isolate_or_dissolve_huge_folio()
> 	if (order_is_gigantic(folio_order(folio)))
> 		return -ENOMEM;
> 
> 	if (folio_ref_count(folio) && folio_isolate_hugetlb(folio, list))
> 		ret = 0;
> 
> __alloc_contig_migrate_range() then calls migrate_pages() ->
> migrate_hugetlbs() -> unmap_and_move_hugetlb_folio() with mode set to
> MIGRATE_SYNC. Once alloc_migration_target() obtains a replacement folio, on
> pass > 2 (force == 1) mm/migrate.c:unmap_and_move_hugetlb_folio() performs a
> blocking folio_lock(src):
> 
> mm/migrate.c:unmap_and_move_hugetlb_folio()
> 	if (!folio_trylock(src)) {
> 		if (!force)
> 			goto out;
> 		switch (mode) {
> 		case MIGRATE_SYNC:
> 			break;
> 		default:
> 			goto out;
> 		}
> 		folio_lock(src);
> 	}
> 
> In hugetlb_wp(), if src is old_folio, the current task already holds
> folio_lock(old_folio) and will self-deadlock. Even if src is a different

Yes. PMD HugeTLB CMA fallback makes this same-task deadlock
reachable, provided a migration target can be obtained:

hugetlb_wp(): holds lock(old_folio)
   -> new 2M allocation falls back to CMA
   -> CMA selects the buddy-borrowed old_folio
   -> migration target obtained, source trylock fails
   -> forced MIGRATE_SYNC waits for lock(old_folio)
      -> self-deadlock

I need to think more about the appropriate handling here.

Thanks,
Qi

> folio (or in hugetlb_no_page()), blocking on folio_lock(src) while holding
> hugetlb_fault_mutex_table[hash] and hugetlb_vma_lock_read(vma) inverts the
> hugetlb_fault_mutex -> vma_lock -> folio_lock lock ordering against a
> concurrent task in hugetlb_wp() on src, which holds folio_lock(src) while
> dropping and re-acquiring hugetlb_fault_mutex_table[hash] and
> hugetlb_vma_lock_read(vma) around unmap_ref_private().
> 
> [ ... ]
> 


