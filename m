Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EF06FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:12:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78DA06B008A; Mon, 27 Apr 2026 16:12:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7657D6B008C; Mon, 27 Apr 2026 16:12:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A1ED6B0092; Mon, 27 Apr 2026 16:12:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 577F66B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:12:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A28DA140307
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:12:35 +0000 (UTC)
X-FDA: 84705433470.21.15F286F
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 41E9540008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:12:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HyP/5X/0";
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777320753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cNCYrzzK3iDBNgWy/53j2TwXN5t0Dd7uGAbM6FsgiSA=;
	b=JWMXI1bZODprB0H4LT+eW0Sx5dijg7cyEaN5+WelYtqtsszHfCTb9sIZ2Wh0WbEwWgUJCr
	jstfNSGoZ09vmPt4+ZzI/uchEG++T2hS2fL6sNs4CwJAiE5KkjWLoRviHgGLL+MbTn1Swb
	F+SgQ72FoXFa9/dP6S3Aznja1rnUjYk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777320753; a=rsa-sha256;
	cv=none;
	b=bqzuESPh9hna+laEnK5yRKlC4UyIaQCP3jcCfamgSUctz5LxoEiLIN2+VHIagJrZBK4KYd
	RZUa8nCza9XzUcpJmH4YGeIcW3pNd28poLR1SKA7GzLYNp/vn9LP1PM835u6TFEM6F5Yzd
	95thcUM5i3Vnsx2qq7Vj+c9ea7PbU0Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HyP/5X/0";
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <30bd8e73-d718-4a44-ac46-ce4579edfb10@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777320750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cNCYrzzK3iDBNgWy/53j2TwXN5t0Dd7uGAbM6FsgiSA=;
	b=HyP/5X/0FzArNbWKD8h9v5F/WpqUDPey/njgIG5Cpmgl7LiJEl7cr8BsoZFG47oAhU07w8
	4mP1aCCMgkbjraobKpp5pW9ZxMZzZVtvN1zsDqRwl1/tlodemv1ce2IpTpph2r9a4+xPZ/
	L5la0CBviZlm3uDELd37f3dEbtjnx5g=
Date: Mon, 27 Apr 2026 21:12:24 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 00/13] mm: PMD-level swap entries for anonymous THPs
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, bhe@redhat.com,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 kernel-team@meta.com, Ying Huang <ying.huang@linux.alibaba.com>,
 Linux Memory Management List <linux-mm@kvack.org>
References: <20260427100553.2754667-1-usama.arif@linux.dev>
 <D491228B-A6D0-4B55-BC56-8709C107CB30@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <D491228B-A6D0-4B55-BC56-8709C107CB30@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 41E9540008
X-Rspam-User: 
X-Stat-Signature: d11wi6hhwq1ns9nxp7mouwutawp1t187
X-HE-Tag: 1777320752-195351
X-HE-Meta: U2FsdGVkX19cCBUoTIxiz/8bn45R2D6BNtGnsziYCJPaJ4tZyZExY8YmaYVDFkKH0G5zSi9VAmj+7TRGTxduI77xxlxHwgzr5NUoNmGkIKuuFAQiwbJfVetV8eZPlYDAyeOe8XvvksXwm3bKClf5vMtq9rdYJANMEaTbJtbekMaJsUNE73/bSgpmGIaOtrucnzy3ykDLL6fMzueOKFHZwUFPSpAqzXlE3pzP7xJjwJ5Ds3X+mEZ7TRP6S4uO/BDe7IKcywEsKXDTUxK2dzHm2yoxmYVRli3kg9MZgya3M0cu9ZGPbuyc7eIXfu5ZYmH2/KfI5XyXj0cog4n94m94llRHu714/z1w00nzm67AtH1yJDYrX9VKalFBhfmVziiFpiiDMcfmj/prHHuBsyEkHAW21yXhOgrd9OarzhMOjPpO8s77/nNm3A3CDimylnZgKcniW3eGYiOeOw30mBUyQCz/EDVSIAFPVeZUdaHTr9FVmzMxPdb6qhikqQvos7qfZLNMz9R3qwuwnCxEk5M2t2OL+vRpLKLiIUP+PrCtE8RxA1SMYYIbWRuTvhiMbBrO+HgvpqoIa84abYDHvx5W2b8LP7Mf5WbCasiHT53JtjbeYU49l2Gn2x6lNgasoAyg4E/LbzFX3iqx1oKUTqLeHHbywGCP2NIBMFM9kFLkuB6+y+PNgzIgdjKxv/4z/NFk1XERTsTisEwgX0MfI8wUYmCsg+dFjpmr/HYnoWlXCeVcHIKKhSHlgsIoFvbTgYMc+SKryXDr5fMxjZf/yOewpW/0MAPLH37LVC5j+SUXHSbmNh/NXs1dzq6HvcBaWFQm31Op3rokMPC5hjueIS7DCDvswWoDoMcWRvNJqdlLSQLE9QsKmNJM6rl1ZdC3v7W8Q+R8/NEPnrw50t1YacPieFzug9F5GJwbK7E9ozmfoZX0wvnjnY3OkyPr8NIPVQPHc9yjdkXjmwlj5Ov+snf
 czvCikGX
 TNaVy7xvlsAOvwZ3Ee8fAARXnDt794t4RidCexuDwlJkzl1AuoN5CHebDPyPairehL+/nvjrEd/Tf53BOjfcfUEgAAR+YbkX65ZJhgkzohbmzQfeFpHHL4RTJA0+Z0lETq9RqArrHLsgwhglu7NsoZGMkd/CgXS8CqfVF8ij37CHyQUdvjjoc8+UCP5S0STuUPbJG+FetsWRHoAHcJMJqsa6odJh9gg7K5FzqhFOxm5qRPrXBOHlSQmJnFenF9Va32wEHWyMAkFagD8IPkOib1/8hA1pcK7tKh0ZDGJQha8npMLGfb/J0acbkYun1Win0EZSp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/04/2026 19:26, Zi Yan wrote:
> +Ying, who did the original THP swap work[1].
> 
> [1] https://lkml.org/lkml/2016/8/9/588
> 

Thanks Zi!

Sorry Ying for not CCing you! checkpatch on the whole series produced
a really long list and I wasnt sure if people would start thinking of
it as spam. I added reviewers and maintainers of swap and THP + a few
folks that commented on previous related work from which this kicked off.
I should have just CC'ed everyone.

> On 27 Apr 2026, at 6:01, Usama Arif wrote:
> 
>> When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
>> split into 512 PTE-level swap entries via TTU_SPLIT_HUGE_PMD before
>> unmap.
>>
>> This series introduces a PMD-level swap entry. The huge mapping is
>> preserved across the swap round-trip, and do_huge_pmd_swap_page()
>> resolves the entire 2 MB region in a single fault on swap-in,
>> no khugepaged involvement is needed. swap_map metadata is identical
>> either way (512 single-slot counts), so the PTE split buys nothing
>> on the swap side, it is purely a page-table representation change.
>>
>> This work was brought about after Hugh reported that one of the
>> major blockers for having lazy page table deposit is the lack of
>> PMD swap entries [1]. However, this series has benefits of its
>> own:
>> - The huge mapping is restored on swap-in.  Today even when the
>>   folio is still in swap cache as a single 2 MB folio, the swap-in
>>   path installs 512 PTE mappings -- the PMD mapping is gone, the
>>   freshly-materialised PTE table sticks around, and only
>>   khugepaged can later collapse the range back into a THP.
>>   do_huge_pmd_swap_page() reinstalls the PMD mapping directly in
>>   one fault, no khugepaged involvement.
>> - Memory saved per swapped-out THP *once lazy page table deposit is
>>   merged* [2]. With lazy page table deposit [2], splitting a PMD into
>>   512 PTE swap entries forces allocation of a 4 KB PTE table page.
>>   The new path leaves the pgtable hierarchy at PMD level and avoids
>>   that allocation entirely.
>>   This will save memory when swapping, which is likely when there is
>>   memory pressure and exactly when allocations are most likely to
>>   fail.
>> - Walkers (zap, mprotect, smaps, pagemap, soft-dirty, uffd-wp)
>>   visit one PMD entry instead of 512 PTEs, reducing traversal
>>   time and lock-hold windows.
>>
>> The swap entry value is identical to 512 PTE swap entries (same
>> type, same starting offset), so swap_map refcounting is unchanged.
>> Only the page-table representation differs; the swap slot allocator,
>> swap I/O, and swap cache are untouched.  The new path falls back to
>> the existing PTE-split path whenever a PMD-order resource is
>> unavailable: zswap enabled, non-contiguous swap allocation
>> (THP_SWPOUT_FALLBACK), PMD-order folio allocation failure on swap-in
>> or fork, racing folio split, or rmap-driven split on a swapcache
>> folio.  Walkers that previously assumed every non-present PMD encodes
>> a PFN (migration / device_private) are taught to recognise PMD swap
>> entries.
>>
>> Patch breakdown:
>>
>> The series is ordered to preserve git bisectability: every consumer
>> of a PMD swap entry (split, fork, swapoff, walkers, UFFDIO_MOVE,
>> swap-in fault) lands before the producer.  The swap-out path that
>> actually installs PMD swap entries is the very last functional patch
>> (12), so no intermediate commit can leave the kernel handling a
>> PMD swap entry it does not yet understand.
>>
>> The first 4 patches are preparatory patches. Some of them (like
>> softleaf_to_pmd() change in patch 1) are not exactly needed but its
>> done to hopefully improve code quality and so that the PMD swap
>> entry changes look well integrated with the rest of mm.
>>
>> Prep patches:
>>   1. mm: add softleaf_to_pmd() and convert existing callers
>>      PMD counterpart to softleaf_to_pte(); needed to construct a
>>      PMD from a swap entry in later patches.
>>   2. mm: extract ensure_on_mmlist() helper
>>      Hoists the "register mm with swapoff" double-checked-locking
>>      pattern out of try_to_unmap_one() / copy_nonpresent_pte() so
>>      the PMD swap-out and PMD fork paths can reuse it without a
>>      third open-coded copy.
>>   3. fs/proc: use softleaf_has_pfn() in pagemap PMD walker
>>      pagemap_pmd_range_thp() today calls softleaf_to_page()
>>      unconditionally; a PMD swap entry has no PFN and would crash
>>      it.
>>   4. mm/huge_memory: move softleaf_to_folio() inside migration branch
>>      change_non_present_huge_pmd() today calls softleaf_to_folio()
>>      before branching on entry type, so a PMD swap entry would
>>      produce a bogus folio pointer that the migration-only code
>>      below would then dereference.
>>
>> Core patches:
>>   5. PMD swap entry detection (pmd_is_swap_entry,
>>      softleaf_is_valid_pmd_entry) and per-arch pmd_swp_*exclusive
>>      helpers (x86/arm64/s390/riscv/loongarch).
>>   6. __split_huge_pmd_locked() learns to split a PMD swap entry
>>      into 512 PTE swap entries, used as the fallback when a
>>      PMD-order resource is unavailable.
> 
> I was wondering how to handle insufficient memory during swap-in.
> Here it is. I have not read the code, but the split should be
> straightforward, since we already have a contiguous swap space at
m> swap-out time and the split is just to enable PTE-level swap in, right?
> 

Yes that is correct. Actually patch 6 was one of the easier patches.
If the kernel can't allocate 2M, memcg charge fails and a few other reasons,
we split THP.


>>   7. Fork: copy_huge_non_present_pmd() duplicates the PMD swap entry
>>      in one folio_dup_swap() call, with GFP_KERNEL retry mirroring
>>      copy_pte_range().
>>   8. Swapoff: unuse_pmd() reads the whole 2 MB folio and reinstalls
>>      the PMD; falls back to PTE-split + unuse_pte_range() on error.
>>   9. Walker updates: zap_huge_pmd, change_huge_pmd,
>>      change_non_present_huge_pmd, move_soft_dirty_pmd,
>>      clear_soft_dirty_pmd, make_uffd_wp_pmd, smaps_pmd_entry,
>>      queue_folios_pmd (mempolicy), check_pmd_state (khugepaged),
>>      and the madvise_cold_or_pageout_pte_range / madvise_free_huge_pmd
>>      VM_BUG_ON extensions.
>>  10. UFFDIO_MOVE: move_pages_huge_pmd() learns to move a PMD swap
>>      entry whole via a new move_swap_pmd() helper modeled on
>>      move_swap_pte().
>>  11. Swap-in: do_huge_pmd_swap_page() resolves a PMD swap fault in
>>      one shot.  Handles racing splits, SWP_STABLE_WRITES read-only
>>      mapping, immediate COW for write faults; falls back to PTE-split
>>      on any PMD-order resource shortfall.
>>  12. Swap-out: shrink_folio_list() drops TTU_SPLIT_HUGE_PMD for
>>      PMD-mappable swapcache folios (when zswap is disabled), and
>>      try_to_unmap_one() installs one PMD swap entry via
>>      set_pmd_swap_entry() instead of splitting.
>>
>> Testing:
>>  13. selftests/mm: 12 tests covering swap-out/in, fork, fork+COW,
>>      repeated cycles, write fault, munmap, mprotect, mremap, pagemap,
>>      MADV_FREE, UFFDIO_MOVE, swapoff.
>>
>> Making PMD swap entries work with zswap is another project on its own and
>> should be in a separate follow up series.
>>
>> The patches are on top of mm-unstable from 23 April
>> (2bcc13c29c711381d815c1ba5d5b25737400c71a).
>>
>> [1] https://lore.kernel.org/all/6869b7f0-84e1-fb93-03f1-9442cdfe476b@google.com/
>> [2] https://lore.kernel.org/all/20260327021403.214713-1-usama.arif@linux.dev/
>>
>> Usama Arif (13):
>>   mm: add softleaf_to_pmd() and convert existing callers
>>   mm: extract ensure_on_mmlist() helper
>>   fs/proc: use softleaf_has_pfn() in pagemap PMD walker
>>   mm/huge_memory: move softleaf_to_folio() inside migration branch
>>   mm: add PMD swap entry detection support
>>   mm: add PMD swap entry splitting support
>>   mm: handle PMD swap entries in fork path
>>   mm: swap in PMD swap entries as whole THPs during swapoff
>>   mm: handle PMD swap entries in non-present PMD walkers
>>   mm: handle PMD swap entries in UFFDIO_MOVE
>>   mm: handle PMD swap entry faults on swap-in
>>   mm: install PMD swap entries on swap-out
>>   selftests/mm: add PMD swap entry tests
>>
>>  arch/arm64/include/asm/pgtable.h      |   4 +
>>  arch/loongarch/include/asm/pgtable.h  |  17 +
>>  arch/riscv/include/asm/pgtable.h      |  15 +
>>  arch/s390/include/asm/pgtable.h       |  15 +
>>  arch/x86/include/asm/pgtable.h        |  15 +
>>  fs/proc/task_mmu.c                    |  47 +-
>>  include/linux/huge_mm.h               |  11 +
>>  include/linux/leafops.h               |  44 +-
>>  include/linux/swap.h                  |   4 +-
>>  include/linux/vm_event_item.h         |   1 +
>>  mm/hmm.c                              |   3 +-
>>  mm/huge_memory.c                      | 540 +++++++++++++++++++++--
>>  mm/internal.h                         |  49 +++
>>  mm/khugepaged.c                       |   6 +
>>  mm/madvise.c                          |   5 +-
>>  mm/memory.c                           |  51 +--
>>  mm/mempolicy.c                        |   2 +
>>  mm/rmap.c                             |  27 +-
>>  mm/swap.h                             |   7 +
>>  mm/swap_state.c                       |  35 ++
>>  mm/swapfile.c                         | 144 +++++-
>>  mm/vmscan.c                           |  14 +-
>>  mm/vmstat.c                           |   1 +
>>  tools/testing/selftests/mm/Makefile   |   1 +
>>  tools/testing/selftests/mm/pmd_swap.c | 607 ++++++++++++++++++++++++++
>>  25 files changed, 1554 insertions(+), 111 deletions(-)
>>  create mode 100644 tools/testing/selftests/mm/pmd_swap.c
>>
>> -- 
>> 2.52.0
> 
> 
> Best Regards,
> Yan, Zi


