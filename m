Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D12E9C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2466B00CA; Tue, 29 Sep 2026 04:02:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDCFD6B00CB; Tue, 29 Sep 2026 04:02:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4306B00CC; Tue, 29 Sep 2026 04:02:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 895E46B00CA
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:02:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 860111C2FA0
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:02:19 +0000 (UTC)
X-FDA: 85266057198.27.525CE2F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B926B40006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:02:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JsAhLlTD;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hRdbAg4wqHnNe+Y3D93gmITcA/iqdJgopfMbx5PjZvk=;
	b=OjvM0OomajgwelSkbop52p0PP8zeTlUyBJw9hub4KjlTT/J9t7EuSzlKNL+yNKPVieeCUY
	TeEMY04pVbrE8uLlG0h3OJdVQKefwlIoQ630nDagO4k8QbIBMKwPtLQ39XN3Lf6g0ZV7Bq
	Ob7VOqHZkiXMXFWUDIwdtnLCwSvvkLs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JsAhLlTD;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668937;
	b=DWUf3Va2xPhL26SWC2Yq7LISQEmzyeMQdib9TNAvOCeAfbYu4eHJA53XPZrhGWxAaE5rmW
	XnYbBTDt0mbBuVsq25aMrt7Vc0+wexnQAqZ3c8yasapfZAwXxOFj6HX8tHBtZS4+mnvJUL
	08mU1Iq5Mi42ILVYaLMVArZzXW6etm4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E8DC60210;
	Tue, 29 Sep 2026 08:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6A21F000FF;
	Tue, 29 Sep 2026 08:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790668936;
	bh=hRdbAg4wqHnNe+Y3D93gmITcA/iqdJgopfMbx5PjZvk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JsAhLlTDFzydVMt1aIecvwrISNVGR+oXgE2tfWcbf5/4Ve9bRAmj+5GPmsYPiIMNE
	 92r7qYj+1Ly/dBA/rw7EKU1keUfukU1FLjOpsI69vtPYPB1IzNP5GD8u5dBqAgT1LX
	 b3gFxVsAEoSLSDabrY9E1cFbOw22Ueoq6X6VgWquhz6oBD8FMzZQiH6ckba8hRSNhs
	 zp4wBeWBsf0mG3/bLn/j/nBCg5dGrL830Fu718t9TKO+82URSwPtVrHZlfKJnO2uBR
	 9ZHHFa2kmHZAguHxPPqzIaA8cnZsi1Y+zArW40YwqEUi7Xrx4pxMOBOgDxp8hWC1Rk
	 N6wh4si1g2PKg==
Message-ID: <d8646877-4975-4b2d-9255-9285414d65cb@kernel.org>
Date: Tue, 29 Sep 2026 10:02:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] mm: swap support for hugetlb folios
To: Zongkun Lei <leizongkun@qq.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org
References: <tencent_501F9D3CED07B66BAA97D5352FB63EE1A709@qq.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <tencent_501F9D3CED07B66BAA97D5352FB63EE1A709@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B926B40006
X-Stat-Signature: e914dpuhj7thhyig3mxou4yzm9nox3w1
X-Rspam-User: 
X-HE-Tag: 1790668937-39633
X-HE-Meta: U2FsdGVkX19RsHnhlAopeu9uWrRWg45n7lY5mKj6vUxZjBa//WqK+Up+1QVRTzQAWIPf+yiJ6SkcNrb+VlBCocZuZqLHlFYzGv473Rq99e8RcmDGDazKOa/i70KuTxja73CoTMrzO6AAL6Xi4PU7r+aKR6TWoBnzIpPXwx5BBnNeHqCR8U1rH4tVnKDJhIIwUoqq+l3Wp8b6wpR3oJOnTGbEix5rxoLnLManDDUA1nsP2j0yGAceN361784xu9C+CPbRcHc2sI3g2dThaapgaLGm+tTu8BaAmpigP/Q6/7DS1v2SFUWws7nXYckRvuyZxnY5LMmOUp+p/Ff9tnnd2OaIbWB52aKEAEldebJIqCs80M+dWzbsxcA0tPc8oIuDc01dtBXMqe1Bao2Ah1r54JtLfGEaaAKMH3rhB/AXk0lnPYPJ2sSiLvpclkFPrq2KVNho8W8j6cadXL5z4bNMuOuh/OEyTCrZPGDXmgj5RysH5G/fgkvQnnqJ2DvSogfFUFB9J40w+iyBJHKRYt8nxSFlln/XU8YGHurmqhb9ZPgC7aWMk+H9Pu4dT6lK1cwdV9wZzfQZpsnBmI3rWhotGrK2SxnArEkLyVgEIOR9hGmlbQ+kSDWqm1HuB/8IldJaACnnAkFKBDlfjjEpnkvYmwpSyJECPzl5+TxDNRX/l2hfA8N+Gn27DDgj27G2Qp4IqtLt59SoFxgOEbpabMrKNDDZOiuk+/Lq2drar5TU5ahFSWOu3bS56WwzmeM4WP29EvniIG0PCeeh6SWBP6NwFAsahvI04Tq2tTmWuFmI9StpvmcBB20odIyET8qBZfjrdGUqvqUJZmBUB+xZFf5lB5K+vrGWVikg41iw9pIRPy0yb0bcrPhNEK8OZgmiqcCU/bkVdxN0OzQENnNLXjUF19BcXpcSn/fRvLBp8NQTZ6UfIKFHVwykpPoLlPsWe2kAsDGY7MOqeOkd3/SUNHv
 5QIsJ+AH
 E9TRDqM3O1uG5/DPOKLh8Wb4hZVD2ss7nLqd7FNsJctdPuJWkZowwjjWu5rG6sPKV0VjGifb8LEVwUwmVKJc4QMh1rPJ/QYGKKC3dHe6vLMWQ7Gy5qtjq5ZjUU0q8HwKs3CC41VaGKvr37tx5G2EX/cxJIZ+vYc3dp3PIJPt6/MqvC7Yd75NDdIxl5gGunqczR+OjwBnTidnw6gqJ/KhXhuYRrq1ivpZYN4Wzl+YPfON2ya97kne6FfepljyWu0fz3XCuQIAXPCDo11wUNtuC3xMWydiiUQMFDIed55tKMzSjrKs5hmb03+WeRiEQAg6XoNPbB+vWLW2Fp6BRts9F4g0C8gR3AjfbecMbpzpao+zMdlDF/iy0YCBAOn6HFWvapoRR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/26 09:53, Zongkun Lei wrote:
> Hi all,
> 
> This series introduces *user-driven* swap support for hugetlb folios,
> covering both private anonymous and shared file-backed mappings.  It
> deliberately keeps the hugetlb reservation semantics intact: the
> kernel never reclaims hugetlb pages on its own -- hugetlb folios never
> go on an LRU, there is no hot/cold guessing, and nothing hooks into
> kswapd or direct reclaim.  This is the same boundary the merged
> hugetlb demotion keeps: the kernel never reclaims reserved memory by
> its own judgement.  Demotion is triggered explicitly by the
> administrator (writing nr_hugepages) and only touches free pool
> pages; this series is triggered explicitly by the workload (madvise)
> and acts on its own live mappings.  In both cases the decision stays
> outside the kernel.
> 
> Interface:
> 
> - Swap-out: MADV_PAGEOUT via madvise(2)/process_madvise(2) learns to
>   handle hugetlb mappings.  For anonymous mappings the PTE becomes a
>   swap entry; for shared mappings the PTE is simply cleared and the
>   location record stays in the hugetlbfs page cache.
> - Swap-in: a fault reads the page back from swap.
> - Swapoff: all swapped-out hugetlb pages are read back.  If the pool
>   has no free huge pages at swap-in time, the behaviour matches a
>   first-touch fault on a full pool: after bounded retries the process
>   receives SIGBUS -- no silent failure, no data loss.
> 
> 
> Motivation
> ==========
> 
> Today a hugetlb reservation is a one-way street: once instantiated, a
> huge page's memory is completely unreclaimable until the mapping is
> torn down.  THP and 4K anonymous memory can simply be swapped out;
> hugetlb cannot.  This gap forces operators to choose between "huge
> page performance" and "memory overcommit".
> 
> VM overcommit.  QEMU guests backed by MAP_SHARED hugetlbfs files
> (-mem-path) allocate all guest memory from the host's huge page pool.
> Overcommit means selling more guest memory than the pool holds --
> fine in practice because guests never all peak at once.  But the
> extreme case is unavoidable: when every guest's load spikes at the
> same time, the pool runs out.  Keeping the VMs alive then requires a
> swap mechanism that moves the memory the provider judges cold out of
> the way.  Ballooning cannot save this scenario: it reclaims memory
> that is free *inside* the guest, and the extreme case is precisely
> that all guests are busy and have nothing to give.  The extreme case
> is rare, but without an escape hatch providers dare not overcommit
> confidently, and pool utilization stays low.  This series is that
> escape hatch: the VM management stack issues MADV_PAGEOUT on cold
> guest memory, VM availability survives the extreme case, and "huge
> page performance" vs "memory overcommit" stops being a choice.
> 
> Hot-upgrade standby.  A hot upgrade first brings up the new instance
> and switches traffic before the old one may be touched; to keep
> rollback fast, the old instance usually cannot be deleted right away
> and stands by for hours or days.  During that time it has no traffic
> and its memory is cold, yet the process and its mappings still pin
> the pool until it is finally removed.  With MADV_PAGEOUT the cold
> memory can be swapped out during standby and swapped back if a
> rollback happens.  More generally: whenever the pool is full but
> tearing down the mapping is not an option, MADV_PAGEOUT is the only
> way to free space.
> 
> 
> Design
> ======
> 
> Preparation: tree-wide folio_swap_entry() conversion (patch 1)
> --------------------------------------------------------------
> 
> Hugetlb flags live in folio->private (a union with folio->swap), so
> while a folio sits in the swap cache the low bits of folio->swap.val
> can be polluted by HPAGEFLAG (with HVO enabled, bit 4 is set on
> virtually every hugetlb folio -- not a theoretical issue).  The fix
> is folio_swap_entry() -- an identity transform for non-hugetlb folios
> (round_down(x, 1) == x for order-0; THP low bits are zero anyway) --
> plus a *tree-wide* conversion of all folio->swap readers.  What
> review must prove shrinks from "N sites x reachability arguments" to
> "1 helper + 1 invariant (swap entries are folio-size aligned)", with
> zero semantic change to existing paths.  It makes *generic* code
> hugetlb-safe instead of adding special cases in hugetlb.c, aligned
> with the hugetlb genericization direction.
> 
> The companion size gate hugetlb_folio_swap_supported() (introduced in
> patch 3) clamps both bounds at once: the lower bound (HPAGEFLAG
> width, requiring nr_pages >= 128) and the upper bound (non-gigantic,
> <= PMD size, so one swap cluster holds the folio).
> 
> Private anonymous mappings (patches 2-4)
> ----------------------------------------
> 
> - Swap-in (consumer first, patch 2): hugetlb_anon_swapin() mirrors
>   do_swap_page(): get_swap_device() pins the device,
>   swap_cache_get_folio() finds in-flight folios, and on a miss the
>   folio is allocated from the hugetlb pool and added to the swap
>   cache via the new generic swap_cache_add_folio() helper (hugetlb
>   folios do not come from the buddy allocator, so
>   __swap_cache_alloc() cannot be used).  Pool exhaustion retries
>   briefly, then fails with SIGBUS, matching the
>   reservation-exhaustion contract of the no-page fault path.  The
>   lifecycle is fully 4K-semantic: fork shares swap entries
>   (copy_hugetlb_page_range() + swap_dup_entries_direct(), dropping
>   the exclusive bit); zap/swapin release them; MM_SWAPENTS is
>   balanced at swapout/fork/swapin/zap per mainline semantics (VmSwap
>   stays meaningful); swapoff drains via hugetlb_unuse_vma().
>   The read-back path must merge before the swap-out path: the base
>   hugetlb_fault() returns ret = 0 for any entry that is neither
>   migration nor hwpoison, so with swap-out first, touching a
>   swapped-out page would livelock in an endless fault loop.
> 
> - Swap-out (patch 3): hugetlb_reclaim_pages() /
>   hugetlb_reclaim_folio_list() are trimmed mirrors of
>   reclaim_pages()/shrink_folio_list() and live in hugetlb.c; the
>   changelog of patch 3 explains why a mirror and why there.  Swap PTE
>   installation reuses the rmap walker: a new
>   try_to_unmap_swap_hugetlb_one() (a static callback mirroring
>   ttu_anon_swapbacked_folio(): single walk, swp_pte_prepare(),
>   mm_prepare_for_swap_entries(), MM_SWAPENTS accounting) plus the
>   exported wrapper try_to_unmap_swap_hugetlb(), following the
>   try_to_unmap_poisoned_hugetlb_one() precedent.  Cost to generic
>   rmap: one added line in rmap.h, zero changes to existing code.
> 
> - memory-failure (patch 4): anonymous hugetlb folios can now sit in
>   the swap cache (the writeback window, the cached copy left after
>   swap-in) -- a state memory failure has never seen before.  Two
>   adaptations: try_to_unmap() routes hugetlb folios by TTU_HWPOISON
>   (set -> the poisoned handler; cleared -- the mf case that keeps a
>   dirty swapcache folio -- -> the swap handler, matching 4K swapcache
>   semantics), and me_huge_page() intercepts swapcache folios at the
>   top (mirroring me_swapcache_dirty(): keep the folio in the swap
>   cache and return MF_DELAYED), fixing the silent eviction of a clean
>   poisoned folio that would otherwise mean a 2M pool leak plus a lost
>   poison marker.
> 
> Shared file-backed mappings (patch 5)
> -------------------------------------
> 
> The shmem model: swap-out only clears the PTEs -- no swap entry is
> ever installed for a file folio -- and the anchor (a swap value
> entry, swp_to_radix_entry()) is left in the hugetlbfs page cache,
> holding a dup'ed swap count.
> 
> - Swap-out: hugetlbfs_writeout() -- folio_alloc_swap() allocates the
>   folio-sized slot range, the inode is linked on the per-inode
>   swaplist (for swapoff traversal), folio_dup_swap() holds a swap
>   count for the anchor, the page cache slot is replaced by the anchor
>   in place, and swap_writeout() writes out.  The reclaim loop drops
>   its anon-only gate and madvise drops the VM_MAYSHARE rejection.
> 
> - Refault swap-in: hugetlb_no_page() recognizes the anchor (the page
>   cache lookup reports it as a hole) and swaps the folio back in via
>   hugetlbfs_do_swapin(), replacing the anchor in place --
>   indistinguishable from a regular page-cache hit afterwards.  The
>   read-back path must never lag the producer: the base fault path
>   treats value entries as holes and would silently zero-fill over
>   swapped-out data.
> 
> - read(2) swap-in: hugetlbfs_read_iter() resolves anchors through
>   hugetlbfs_swapin_read() instead of zero-filling; swapin failures
>   surface as -EIO/-EFAULT, never stale data.
> 
> - Lifecycle: truncate/hole-punch/evict free anchors and their slots
>   via hugetlbfs_free_swap(), with two UAF guards (the swap cache
>   entry is removed before the anchor's swap count is dropped; a
>   refcount race means reclaim is isolating the folio, so the folio
>   lock is held across swap_put_entries_direct() to wait it out).
>   Inode eviction drains the swapoff traversal list via
>   hugetlbfs_evict_drain_swaplist().
> 
> - swapoff: try_to_unuse() hooks hugetlbfs_unuse() right after
>   shmem_unuse().  File folios install no swap PTEs, so the mm walk
>   cannot reach their slots -- the per-inode swaplist traversal can.
> 
> - Symmetric accounting: hugetlb_cgroup, memcg swap/hugetlb charge,
>   the global reserve and NR_HUGETLB are paired with free_huge_folio()
>   on every path; the vma-less read/swapoff swap-in charges the
>   caller's context, the same policy as shmem swapoff.
> 
> 
> Base and dependencies
> =====================
> 
> Based on mm-unstable; no external patch dependencies.
> 
> The implementation builds on Kairui Song's swap table work: the
> folio-sized contiguous swap slot ranges (folio_alloc_swap() /
> folio_dup_swap() / folio_put_swap()) are the primitives that make
> this possible at all -- without them a 2M folio would need 512
> independent swap entries.  The merged phases of that work are already
> in mm-unstable [1].
> 
> Looking ahead, the swap table roadmap may move swap entries out of
> folio->swap; removing folio_swap_entry() then is a mechanical
> operation -- the call sites are already concentrated in a single
> helper, so it will be easier to delete than what we have today.
> 
> This series is complementary to the Reserved THP RFC (Qi Zheng), not
> competing with it.  Reserved THP explores the endgame -- reserved,
> swappable, unsplittable large folios that may absorb most hugetlb use
> cases.  But the LSFMM 2024 consensus is that the hugetlbfs ABI stays
> (migrating away is a 15-20 year scale); as long as the ABI exists,
> its unreclaimable-pool problem needs a direct solution.  The two also
> build on the same swap table foundation, so progress on either side
> de-risks the other.
> 
> 
> Anticipated questions
> =====================
> 
> Q1: Why not put hugetlb folios on the LRU and reuse vmscan?
> 
> Semantic layer: hugetlb's ABI contract is "reservation = latency
> determinism", and the kernel must not tear that up unilaterally --
> this is the historical reason hugetlb could not be swapped at all.
> Letting the kernel reclaim reserved pages under global memory
> pressure based on its own hot/cold guesses (folio_referenced() style
> access-pattern inference) injects fault latency exactly where it must
> never appear -- the hot-upgrade standby and pre-traffic-peak moments
> are precisely why hugetlb is used.  So the split in this series is:
> the kernel provides the mechanism, the policy belongs to userspace.
> MADV_PAGEOUT extends to hugetlb the proactive contract 4K anonymous
> memory already has; the workload (orchestrator, JVM, database) knows
> its warmup windows and traffic peaks, so hot/cold decisions stay on
> the side with the most information.  This is the same boundary the
> only merged hugetlb reclaim mechanism, demotion, keeps: the kernel
> never reclaims reserved memory by its own judgement -- demotion is
> administrator-triggered (nr_hugepages) and touches only free pool
> pages, this series is workload-triggered (madvise) and touches its
> own live mappings; in both cases the decision is outside the kernel.
> 
> Technical layer: an LRU is not a neutral queue; it is the input
> structure of the kernel's reclaim policy.  Once a hugetlb folio is on
> an lruvec, kswapd, direct reclaim, MGLRU generation scanning and
> cgroup v2 memory.reclaim will *all* see it -- there is no "on the LRU
> but exempt from scanning" mode; LRU membership means "in the kernel's
> reclaim view".  And making the LRU machinery truly understand hugetlb
> means adapting per-memcg lruvec accounting, folio referenced/aging,
> workingset shadows, MGLRU generations -- which is precisely spraying
> if (hugetlb) special paths across generic reclaim code, in direct
> conflict with the LSFMM 2024 consensus of cleaning up internals and
> removing scattered special cases.  A likely suggestion, "on the LRU
> but reachable only by memory.reclaim, not kswapd", fails the same
> way: the LRU is the shared input of every scanner; there is no
> per-consumer visibility.
> 
> Implementation layer: under this split the series deliberately takes
> the minimal-invasion route -- pool management stays in hugetlb.c,
> every reusable generic leaf operation (rmap walk, slot allocation,
> writeout, referenced/pin checks) is shared, and only the control flow
> is mirrored, with "keep in sync" notes.  Today hugetlb folios live on
> per-hstate lists carrying pool semantics (reserve, surplus, demotion)
> that the LRU machinery knows nothing about; if LRU-ification ever
> happens, the mirrored structure folds over mechanically.  kswapd
> integration is an explicit non-goal, not a "never": the design does
> not close the door (the referenced check simply comes back together
> with that series' scan_control), but user-space-driven is the right
> default for hugetlb, in the same direction as the Reserved THP RFC's
> "reserved but reclaimable" roadmap.
> 
> Q2: Why extend swap to shared file-backed (hugetlbfs) mappings?
> 
> Without it, shared mappings pin the pool absolutely: an instantiated
> shared huge page is unreclaimable until truncate/unlink, however cold
> the data.  Deployments mixing private and shared hugetlb get held
> hostage by the shared half -- under pressure the anonymous half can
> be swapped out, yet the pool still exhausts and new allocations
> (including swap-in itself!) keep failing.  Concrete users:
> 
> - QEMU guests backed by MAP_SHARED hugetlbfs files (-mem-path): idle
>   guest memory can finally be reclaimed with MADV_PAGEOUT instead of
>   pinning the pool for the VM's entire lifetime;
> - services that hold shared hugetlbfs files for coordination/staging
>   but rarely touch them;
> - ABI consistency: MADV_PAGEOUT succeeds on private hugetlb and every
>   4K/THP mapping including shmem -- shared hugetlb was the only
>   mapping type returning EINVAL, an ABI asymmetry users trip over;
> - swapoff reachability: swapoff must be able to drain every kind of
>   swapped-out page; incomplete coverage leaves swapoff stuck on
>   anchors it cannot reach.
> 
> The anticipated objection -- "shared huge pages are for
> performance-critical shared data, why swap them out" -- applies
> equally to all shared file pages, yet shmem has always been
> swappable.  Everything here is opt-in (proactive reclaim only on
> request): nothing moves unless userspace asks.  Pool semantics hold
> end to end: swap-out returns the page to the pool, swap-in competes
> for pool memory again, and reservation exhaustion fails with
> SIGBUS/-EIO exactly like a first-touch fault.
> 
> 
> Testing
> =======
> 
> New selftest tools/testing/selftests/mm/hugetlb_swap.c (~1120 lines,
> 37 assertions, 14 test functions), wired into the mm selftest
> Makefile and run_vmtests.sh:
> 
> - test_pageout_basic: anonymous PAGEOUT -> PTE becomes a swap entry
>   -> the huge page returns to the pool -> fault swaps back in with
>   data intact
> - test_fork_after_pageout: fork shares swap entries, writes COW
>   without polluting the parent, parent/child MM_SWAPENTS balance
> - test_munmap_releases_swap: zap releases swap entries, SwapFree
>   recovers
> - test_readfault_munmap_drains_swapcache: munmap after a read-fault
>   swapin drains the leftover swapcache copy (both the pool page and
>   the slots are returned)
> - test_swapoff: swapoff drains swapped-out hugetlb pages
> - test_swapin_pool_exhausted: swap-in on an exhausted pool fails with
>   SIGBUS (same semantics as a first fault; no OOM, no silent errors)
> - test_shared_file_swap: shared-mapping pageout (PTE cleared, no swap
>   entry) -> both pread and fault swap back in with data intact, and
>   the anchor can be re-established repeatedly
> - test_truncate_after_pageout: ftruncate(0) after pageout frees the
>   anchor and its slots; subsequent access gets SIGBUS
> - test_reject_paths: VM_LOCKED / userfaultfd-registered / 1G gigantic
>   are rejected with EINVAL
> - test_mprotect_mremap_smoke: mprotect/mremap over swap entries
> - test_vmswap_accounting: VmSwap balances over the whole lifecycle:
>   +2048 kB at pageout, unchanged for the parent after fork, back to
>   zero at swapin/munmap (regression test for the unsigned-negation
>   zap accounting fix)
> - test_soft_dirty_swap: soft-dirty bit round-trips between present
>   PTEs and swap entries, verified with clear_refs isolation
> - test_uffd_wp_swap: uffd-wp bit set through the swap entry, carried
>   back to the present PTE at swapin, write fault delivers the WP
>   event
> - test_hwpoison_swapcache: PAGEOUT -> swap-in leaves the folio in the
>   swap cache -> MADV_HWPOISON -> the next access must SIGBUS (must
>   not silently swap stale disk data back in)
> 
> Real-machine results (x86-64, 2M huge pages, QEMU + openEuler 24.03,
> dedicated swap disk): 37 assertions, 35 pass / 0 fail / 2 expected
> skips (mlock is a no-op for hugetlb; no free 1G gigantic page).  Both
> the VmSwap accounting balance and the hwpoison swapcache interception
> are exercised end to end.
> 
> Every intermediate patch builds individually with zero warnings; the
> !CONFIG_HUGETLB_PAGE configuration builds as well.
> 
> 
> Patch split and ordering constraints
> ====================================
> 
> 1. folio_swap_entry() helper + tree-wide conversion of all
>    folio->swap readers (zero semantic change; the changelog documents
>    the union pollution mechanism, the identity argument, the
>    alignment invariant, and why the conversion is tree-wide rather
>    than reachable-sites-only);
> 2. Anonymous swap-in (read-back first): hugetlb_anon_swapin() + fault
>    recognition of swap entries + fork/zap/swapoff/MM_SWAPENTS
>    balancing;
> 3. Anonymous swap-out core (producer second): the reclaim trio + the
>    rmap callback (rmap.h +1 line) + the hugetlb_folio_swap_supported()
>    size gate (with the swap_state.c VM_WARN backstop) + the madvise
>    MADV_PAGEOUT entry point; the changelog carries the
>    mirror/placement rationale and the full size-gate argument.
>    The order must not be flipped: the base hugetlb_fault() returns
>    ret = 0 for non-migration, non-hwpoison entries, so swap-out first
>    means an endless fault livelock on swapped-out pages;
> 4. memory-failure adaptations -- right after patch 3, because the
>    hole becomes reachable from patch 3 on, and a partial merge of
>    1-3 must not leave an mf hole behind;
> 5. File-backed swap as one piece: the shmem-model anchor +
>    hugetlbfs_writeout() + the refault/read swap-in pair + the
>    truncate/evict lifecycle + swapoff traversal.  Kept together
>    because none of the four is correct without the others: read-back
>    alone is all dead code; swap-out without lifecycle management
>    leaks anchors at truncate; lifecycle without swapoff traversal
>    leaves swapoff unable to reach the anchors (file folios install no
>    swap PTEs, so the mm walk cannot find them).  Any prefix of it
>    would be unhealthy, hence a single patch;
> 6. Selftest + documentation (hugetlbpage.rst).
> 
> Comments welcome.
> 
> [1] https://lore.kernel.org/r/20250514201729.48420-1-ryncsn@gmail.com
> 
> Zongkun Lei (6):
>   mm/swap: introduce folio_swap_entry() and convert all folio->swap
>     readers
>   mm/hugetlb: swap-in support for anonymous hugetlb folios
>   mm/hugetlb: swap out anonymous hugetlb folios via MADV_PAGEOUT
>   mm/memory-failure: handle swapcached hugetlb folios
>   mm/hugetlb: swap support for file-backed hugetlb folios
>   selftests/mm: add hugetlb_swap test, document hugetlb swap
> 
>  Documentation/admin-guide/mm/hugetlbpage.rst |   29 +-
>  fs/hugetlbfs/inode.c                         |  128 +-
>  fs/proc/task_mmu.c                           |   11 +
>  include/linux/hugetlb.h                      |   58 +
>  include/linux/pagemap.h                      |    7 +
>  include/linux/rmap.h                         |    1 +
>  include/linux/swap.h                         |   23 +-
>  mm/huge_memory.c                             |    2 +-
>  mm/hugetlb.c                                 | 1408 +++++++++++++++++-
>  mm/internal.h                                |   19 +-
>  mm/madvise.c                                 |   70 +
>  mm/memcontrol-v1.c                           |    4 +-
>  mm/memcontrol.c                              |    2 +-
>  mm/memory-failure.c                          |   19 +
>  mm/memory.c                                  |    2 +-
>  mm/page_io.c                                 |   18 +-
>  mm/rmap.c                                    |  175 ++-
>  mm/shmem.c                                   |    6 +-
>  mm/swap.h                                    |   14 +-
>  mm/swap_state.c                              |   55 +-
>  mm/swapfile.c                                |   87 +-
>  mm/userfaultfd.c                             |    2 +-
>  mm/util.c                                    |    2 +-
>  mm/vmscan.c                                  |    4 +-
>  mm/zswap.c                                   |    4 +-
>  tools/testing/selftests/mm/Makefile          |    1 +
>  tools/testing/selftests/mm/hugetlb_swap.c    | 1118 ++++++++++++++
>  tools/testing/selftests/mm/run_vmtests.sh    |    2 +
>  28 files changed, 3219 insertions(+), 52 deletions(-)

Hugetlb is effectively in a feature freeze. There is no interest in maintaining
even more of the special hugetlb sauce, sorry. :/

-- 
Cheers,

David

