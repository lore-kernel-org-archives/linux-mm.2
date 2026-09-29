Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3ED4CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:54:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCEB46B0092; Tue, 29 Sep 2026 03:54:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7FB66B0093; Tue, 29 Sep 2026 03:54:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6E1B6B0095; Tue, 29 Sep 2026 03:54:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A7666B0092
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:54:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BC84C0132
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:54:04 +0000 (UTC)
X-FDA: 85266036408.15.A0161D1
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4C6F8180002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:54:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="UJ61b/0m";
	spf=pass (imf24.hostedemail.com: domain of leizongkun@qq.com designates 43.163.128.53 as permitted sender) smtp.mailfrom=leizongkun@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eatbBoqOdfzNGHJOt0KOxi7sfZkUHU9njgYLRI6ORC8=;
	b=2L7sI2c2iswl4gmOAgmylWdJ5NGJm9FRSsbhzfpDRyUgnFhvXi3UFPe4+26rK+I34Htjox
	JFyGw159WuIC8xPvZzN1reat1s54gQQbQwn31yFqkm02lqAj0aiW99OB2GhHk5MFalZTNT
	jAAthQPp+cZ4GrPHSqDvziTkFepPJDw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668442;
	b=Z2f/Ggba+XEXadllqJkJjfwjRXKiOh8OKhLoU30EQFqAWpXSQh01cD+egZS3lsOqDb0brQ
	d5hmwH/4fG+Sjy8aH/gCl3EwMZMKQvDdUUtLWPl7KSmMqZTONTyMDG83COvuk3cKS5Rxrg
	fZDAYo8fEvVDeTZZIe2ntsgWR022a+4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="UJ61b/0m";
	spf=pass (imf24.hostedemail.com: domain of leizongkun@qq.com designates 43.163.128.53 as permitted sender) smtp.mailfrom=leizongkun@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790668436; bh=eatbBoqOdfzNGHJOt0KOxi7sfZkUHU9njgYLRI6ORC8=;
	h=From:To:Cc:Subject:Date;
	b=UJ61b/0mzpSa2B8DBczNGMxDFCP8eVdZvvYvgl3QqpNgx3XCQWF69Tc4Lfdc9tgl5
	 k9/ZvzdoMtwZ6E53tmYd7OJMOp3wW6q+/7boWKu5dfJvk9dtuWL33rtAhmWMp1r7zh
	 LbtBSbcUjwwtq/rZkeg6G8jrYWuW7d7mP5PDb7pk=
Received: from lzk-B860M-AORUS-PRO-WIFI7 ([2409:8a28:a83:5ba1:514f:5353:e14b:594e])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id D7329A33; Tue, 29 Sep 2026 15:53:51 +0800
X-QQ-mid: xmsmtpt1790668431t1alz6oxb
Message-ID: <tencent_501F9D3CED07B66BAA97D5352FB63EE1A709@qq.com>
X-QQ-XMAILINFO: MPOMpZ1VkKpqb4kqX9jCpXV/brKkwWn3JbodPGQYEllTOoQ5muimncqbdemm0x
	 oFFBBlya2J++m30EPXaJr0q75TX2e80D1LR0le0igXae64VCyNZLn4EiWFizCs4WJHbGDWITREUs
	 hKZrZ/afhq0aD5sHZ+yNsEaJGG4ipchfc1xNxD6cp6lNDrFJc3BOC0D1LZGvLXzV8dPtXgQmwbY/
	 eR9d6vWB0vCIrqHvhDeC9SxP2RDpdKTmtnvZklIq1RhvpYk0R2Ehax87tlFUjpbHOLlOEmD5SWny
	 J5Ex4g/c2rYbz6MhT86ZtoxAi3LCso6jtxZSAXV3CVr9bd2Gjm/OOznvNluTbHL6hlyO1QxRLdSQ
	 IxQb4aM4bJWRi5x6/3qHe4vREt+yNnJhEJC2kEPXhCCSu2TVkOqko+OJux9omk/cO1EGJWs/khn7
	 LjwpUWfiKuRulFKCvbW78GAohND+qENlc2TdQ3mkB9Sq7lTQozzSRDinrLcREP+SPEccdJml2wbg
	 z7uLn0gac1+A7y2VwnBe19Caay50pjnl3rwg/QBYIZNc32eT/c7qLgvgd3T3z/ee3tNXhG3OaW3m
	 ZP/kkroUj3oADBQyTbdgmYF/05fCLlntq1O+5Zalwp5GpWQYv2Qm7xYdsQu7sMC296tk9J8mLsqj
	 mHN071BS1PlhqDGtefyWWpHE0N5RZVua5oKdIgh30N/XMiXUhVfNd5uGP9WDq8hXXTBywbnd3jUi
	 NQd8EDiFqZej3obOh1FWqTmCfQFnL55sBln8kfXERcWYPC3tPeNKB4kuVE8keZdK7LCyoNNYe9Y/
	 l3pSYdFrW7Kk7vy4FxX+FegJ1Ss+fAzZZFzGEg6DBHkmjonFO21n5PwSsbnEE0rTg9PkTZaTmM77
	 cqdyhzsjiWnzwX3ygccDTO4mcTVT0PCUlzDTQY7UZO4dOIeC3XKB29lcyU8389vVtKVxCZqy+0ew
	 c40B8J9y2zPcS6llIOwTQoepDAxcZVVOHEE875vNQFgi7QnEC7aNAqoDvCa+VHsG01WaeTz0HdOt
	 A1AmoYkHOlis5EzpCiKvxX8+/0VBCsIKpS5MxOstp9qVDf1NlRAAdqcTdNBlOrOBembmJVZSNNiG
	 MkNgkuWmMExwTDBB1FmahifevPBjhHFS5ywIsEXV91RMuvZZ7UwzRP2fjAxvOHpuc7qtgfMUd4pP
	 /8p4CUqGd3w341hgZqS8Kks1amo22EPUwmY88hE0TNJLzFGs7U4DIqIo1KjQKhrqvOC9o=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Zongkun Lei <leizongkun@qq.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Kairui Song <kasong@tencent.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Hugh Dickins <hughd@google.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org,
	Zongkun Lei <leizongkun@qq.com>
Subject: [RFC PATCH 0/6] mm: swap support for hugetlb folios
Date: Tue, 29 Sep 2026 15:53:18 +0800
X-OQ-MSGID: <cover.1790663399.git.leizongkun@qq.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mteijkeecb84h94h5th48t1ebx7815cq
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4C6F8180002
X-HE-Tag: 1790668440-654894
X-HE-Meta: U2FsdGVkX1/Jn4tcMf4FYRO5ynn9fpWMJP7YMkDh0brgRB+tHiC7vka/rC/EmNHxRY9ienZlmryIgNuG9PjgbheHw90dFK8k/kZVhCCBgARtKuL5V6l8Aih2KQ8U7tFtuIbzxR8hTFa/MNRGqxsYRgK+FiXy30/itf1uMlHGuXmPytrcb1JhIQ9Dbnmje2VAW3QgppARED+VREOPD9YyPZMvW7yybewXE9wKqN87o5iqSmakLp8UrqT64vS1swpfRFCAXFigNbipXEp1mLm5eVGoARp8gYMlFwP9o+CGLXiYn/w+Uk5HjSTrrzCY6yQYH4k32kI5KQ6B6WDQS0zycpzrKq+3MuFYNm4oSG1/Z2MrkSDlbYak3C4UKliBUUCuW640vWKM1L8cI6T+Mff92Ok0sm1VOAB0G+0JZOIDgLo1Ffd+ogHagKgb+mk6ihE7Uxu24Ai4X0b5ZX69vT5fFwWndW+1F1G05CFjw4xN7IZT0L7Y1TYWabQmIot8JDCCx0jCOHB4aRsrWvFP7Nw8uS6pU7z2y4LtL0KqXTRZSxBCyyIFfdsPxS3KB9SgjjgTwB4rEtVC5yu2VDy+P3H5xZ1FJdgGq1Blg+H9zK0L1lJvMULF7s/K3rRv/40i22ZrEqrUebiLAjERrDbCLolscRmx5Gt9THPOnEExJ36wIOSRbTFgRxk9ltZhyQGxxnMCR8stfyTqq6ZESF/neaRxZxaKc05DiaMWJmTF6vdUaDvfqth4ydp8A6pMG+E+gZeJmfWVKZ+JnVodoA3zoSbGrtz/yq3exjheHJUjJMmuJBgidaAe7JiAerfP72SuKixhy2Ha3PuTJTL8AYGmAWUCM5v3HmKPE0mYr+wNSZpcmZaIUxkrvgwPmcE3hQOJ9FTJy7AVr8RTE31hgWvOpkX+JqUfKwzwFvTMLqxLwmNRSDS4ENttKUw+AkJZpn26b8d10UL7UiFObCsufsRe1qY
 jWCi4iHw
 wiLpsHu8e6Jp7JfFE2s+CHk1KxW8vDufZk/PPb5TRZA4CNfZHnxbQh3o2g9tcIGXao8SLBUXl1rZLLfEB0TzLdckxoQ18WPSMiSgGLFLdFGfhVKN085gFIOKtDy2T11wHjrOHwUyb6AiP8xc2bgw58qIoG3MlRkzkMWeekcGWB4hPd2Yn66CadOZKdcVPmKLG7IEQcCs8ICUyJbnagA1uqcokRiuDtJc5qRXdrkUr3sB7iHfeiGn7bK5WraKbtJhLpluTFKIMUMlhj4J6cOQAPM5RgLU+EHy+NlJVvf3aMA66hfTZAjGZKH2cAnBQO5SfZGWCJy+vbkxFOxf0JdoPX88wCACrVxbspkU8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series introduces *user-driven* swap support for hugetlb folios,
covering both private anonymous and shared file-backed mappings.  It
deliberately keeps the hugetlb reservation semantics intact: the
kernel never reclaims hugetlb pages on its own -- hugetlb folios never
go on an LRU, there is no hot/cold guessing, and nothing hooks into
kswapd or direct reclaim.  This is the same boundary the merged
hugetlb demotion keeps: the kernel never reclaims reserved memory by
its own judgement.  Demotion is triggered explicitly by the
administrator (writing nr_hugepages) and only touches free pool
pages; this series is triggered explicitly by the workload (madvise)
and acts on its own live mappings.  In both cases the decision stays
outside the kernel.

Interface:

- Swap-out: MADV_PAGEOUT via madvise(2)/process_madvise(2) learns to
  handle hugetlb mappings.  For anonymous mappings the PTE becomes a
  swap entry; for shared mappings the PTE is simply cleared and the
  location record stays in the hugetlbfs page cache.
- Swap-in: a fault reads the page back from swap.
- Swapoff: all swapped-out hugetlb pages are read back.  If the pool
  has no free huge pages at swap-in time, the behaviour matches a
  first-touch fault on a full pool: after bounded retries the process
  receives SIGBUS -- no silent failure, no data loss.


Motivation
==========

Today a hugetlb reservation is a one-way street: once instantiated, a
huge page's memory is completely unreclaimable until the mapping is
torn down.  THP and 4K anonymous memory can simply be swapped out;
hugetlb cannot.  This gap forces operators to choose between "huge
page performance" and "memory overcommit".

VM overcommit.  QEMU guests backed by MAP_SHARED hugetlbfs files
(-mem-path) allocate all guest memory from the host's huge page pool.
Overcommit means selling more guest memory than the pool holds --
fine in practice because guests never all peak at once.  But the
extreme case is unavoidable: when every guest's load spikes at the
same time, the pool runs out.  Keeping the VMs alive then requires a
swap mechanism that moves the memory the provider judges cold out of
the way.  Ballooning cannot save this scenario: it reclaims memory
that is free *inside* the guest, and the extreme case is precisely
that all guests are busy and have nothing to give.  The extreme case
is rare, but without an escape hatch providers dare not overcommit
confidently, and pool utilization stays low.  This series is that
escape hatch: the VM management stack issues MADV_PAGEOUT on cold
guest memory, VM availability survives the extreme case, and "huge
page performance" vs "memory overcommit" stops being a choice.

Hot-upgrade standby.  A hot upgrade first brings up the new instance
and switches traffic before the old one may be touched; to keep
rollback fast, the old instance usually cannot be deleted right away
and stands by for hours or days.  During that time it has no traffic
and its memory is cold, yet the process and its mappings still pin
the pool until it is finally removed.  With MADV_PAGEOUT the cold
memory can be swapped out during standby and swapped back if a
rollback happens.  More generally: whenever the pool is full but
tearing down the mapping is not an option, MADV_PAGEOUT is the only
way to free space.


Design
======

Preparation: tree-wide folio_swap_entry() conversion (patch 1)
--------------------------------------------------------------

Hugetlb flags live in folio->private (a union with folio->swap), so
while a folio sits in the swap cache the low bits of folio->swap.val
can be polluted by HPAGEFLAG (with HVO enabled, bit 4 is set on
virtually every hugetlb folio -- not a theoretical issue).  The fix
is folio_swap_entry() -- an identity transform for non-hugetlb folios
(round_down(x, 1) == x for order-0; THP low bits are zero anyway) --
plus a *tree-wide* conversion of all folio->swap readers.  What
review must prove shrinks from "N sites x reachability arguments" to
"1 helper + 1 invariant (swap entries are folio-size aligned)", with
zero semantic change to existing paths.  It makes *generic* code
hugetlb-safe instead of adding special cases in hugetlb.c, aligned
with the hugetlb genericization direction.

The companion size gate hugetlb_folio_swap_supported() (introduced in
patch 3) clamps both bounds at once: the lower bound (HPAGEFLAG
width, requiring nr_pages >= 128) and the upper bound (non-gigantic,
<= PMD size, so one swap cluster holds the folio).

Private anonymous mappings (patches 2-4)
----------------------------------------

- Swap-in (consumer first, patch 2): hugetlb_anon_swapin() mirrors
  do_swap_page(): get_swap_device() pins the device,
  swap_cache_get_folio() finds in-flight folios, and on a miss the
  folio is allocated from the hugetlb pool and added to the swap
  cache via the new generic swap_cache_add_folio() helper (hugetlb
  folios do not come from the buddy allocator, so
  __swap_cache_alloc() cannot be used).  Pool exhaustion retries
  briefly, then fails with SIGBUS, matching the
  reservation-exhaustion contract of the no-page fault path.  The
  lifecycle is fully 4K-semantic: fork shares swap entries
  (copy_hugetlb_page_range() + swap_dup_entries_direct(), dropping
  the exclusive bit); zap/swapin release them; MM_SWAPENTS is
  balanced at swapout/fork/swapin/zap per mainline semantics (VmSwap
  stays meaningful); swapoff drains via hugetlb_unuse_vma().
  The read-back path must merge before the swap-out path: the base
  hugetlb_fault() returns ret = 0 for any entry that is neither
  migration nor hwpoison, so with swap-out first, touching a
  swapped-out page would livelock in an endless fault loop.

- Swap-out (patch 3): hugetlb_reclaim_pages() /
  hugetlb_reclaim_folio_list() are trimmed mirrors of
  reclaim_pages()/shrink_folio_list() and live in hugetlb.c; the
  changelog of patch 3 explains why a mirror and why there.  Swap PTE
  installation reuses the rmap walker: a new
  try_to_unmap_swap_hugetlb_one() (a static callback mirroring
  ttu_anon_swapbacked_folio(): single walk, swp_pte_prepare(),
  mm_prepare_for_swap_entries(), MM_SWAPENTS accounting) plus the
  exported wrapper try_to_unmap_swap_hugetlb(), following the
  try_to_unmap_poisoned_hugetlb_one() precedent.  Cost to generic
  rmap: one added line in rmap.h, zero changes to existing code.

- memory-failure (patch 4): anonymous hugetlb folios can now sit in
  the swap cache (the writeback window, the cached copy left after
  swap-in) -- a state memory failure has never seen before.  Two
  adaptations: try_to_unmap() routes hugetlb folios by TTU_HWPOISON
  (set -> the poisoned handler; cleared -- the mf case that keeps a
  dirty swapcache folio -- -> the swap handler, matching 4K swapcache
  semantics), and me_huge_page() intercepts swapcache folios at the
  top (mirroring me_swapcache_dirty(): keep the folio in the swap
  cache and return MF_DELAYED), fixing the silent eviction of a clean
  poisoned folio that would otherwise mean a 2M pool leak plus a lost
  poison marker.

Shared file-backed mappings (patch 5)
-------------------------------------

The shmem model: swap-out only clears the PTEs -- no swap entry is
ever installed for a file folio -- and the anchor (a swap value
entry, swp_to_radix_entry()) is left in the hugetlbfs page cache,
holding a dup'ed swap count.

- Swap-out: hugetlbfs_writeout() -- folio_alloc_swap() allocates the
  folio-sized slot range, the inode is linked on the per-inode
  swaplist (for swapoff traversal), folio_dup_swap() holds a swap
  count for the anchor, the page cache slot is replaced by the anchor
  in place, and swap_writeout() writes out.  The reclaim loop drops
  its anon-only gate and madvise drops the VM_MAYSHARE rejection.

- Refault swap-in: hugetlb_no_page() recognizes the anchor (the page
  cache lookup reports it as a hole) and swaps the folio back in via
  hugetlbfs_do_swapin(), replacing the anchor in place --
  indistinguishable from a regular page-cache hit afterwards.  The
  read-back path must never lag the producer: the base fault path
  treats value entries as holes and would silently zero-fill over
  swapped-out data.

- read(2) swap-in: hugetlbfs_read_iter() resolves anchors through
  hugetlbfs_swapin_read() instead of zero-filling; swapin failures
  surface as -EIO/-EFAULT, never stale data.

- Lifecycle: truncate/hole-punch/evict free anchors and their slots
  via hugetlbfs_free_swap(), with two UAF guards (the swap cache
  entry is removed before the anchor's swap count is dropped; a
  refcount race means reclaim is isolating the folio, so the folio
  lock is held across swap_put_entries_direct() to wait it out).
  Inode eviction drains the swapoff traversal list via
  hugetlbfs_evict_drain_swaplist().

- swapoff: try_to_unuse() hooks hugetlbfs_unuse() right after
  shmem_unuse().  File folios install no swap PTEs, so the mm walk
  cannot reach their slots -- the per-inode swaplist traversal can.

- Symmetric accounting: hugetlb_cgroup, memcg swap/hugetlb charge,
  the global reserve and NR_HUGETLB are paired with free_huge_folio()
  on every path; the vma-less read/swapoff swap-in charges the
  caller's context, the same policy as shmem swapoff.


Base and dependencies
=====================

Based on mm-unstable; no external patch dependencies.

The implementation builds on Kairui Song's swap table work: the
folio-sized contiguous swap slot ranges (folio_alloc_swap() /
folio_dup_swap() / folio_put_swap()) are the primitives that make
this possible at all -- without them a 2M folio would need 512
independent swap entries.  The merged phases of that work are already
in mm-unstable [1].

Looking ahead, the swap table roadmap may move swap entries out of
folio->swap; removing folio_swap_entry() then is a mechanical
operation -- the call sites are already concentrated in a single
helper, so it will be easier to delete than what we have today.

This series is complementary to the Reserved THP RFC (Qi Zheng), not
competing with it.  Reserved THP explores the endgame -- reserved,
swappable, unsplittable large folios that may absorb most hugetlb use
cases.  But the LSFMM 2024 consensus is that the hugetlbfs ABI stays
(migrating away is a 15-20 year scale); as long as the ABI exists,
its unreclaimable-pool problem needs a direct solution.  The two also
build on the same swap table foundation, so progress on either side
de-risks the other.


Anticipated questions
=====================

Q1: Why not put hugetlb folios on the LRU and reuse vmscan?

Semantic layer: hugetlb's ABI contract is "reservation = latency
determinism", and the kernel must not tear that up unilaterally --
this is the historical reason hugetlb could not be swapped at all.
Letting the kernel reclaim reserved pages under global memory
pressure based on its own hot/cold guesses (folio_referenced() style
access-pattern inference) injects fault latency exactly where it must
never appear -- the hot-upgrade standby and pre-traffic-peak moments
are precisely why hugetlb is used.  So the split in this series is:
the kernel provides the mechanism, the policy belongs to userspace.
MADV_PAGEOUT extends to hugetlb the proactive contract 4K anonymous
memory already has; the workload (orchestrator, JVM, database) knows
its warmup windows and traffic peaks, so hot/cold decisions stay on
the side with the most information.  This is the same boundary the
only merged hugetlb reclaim mechanism, demotion, keeps: the kernel
never reclaims reserved memory by its own judgement -- demotion is
administrator-triggered (nr_hugepages) and touches only free pool
pages, this series is workload-triggered (madvise) and touches its
own live mappings; in both cases the decision is outside the kernel.

Technical layer: an LRU is not a neutral queue; it is the input
structure of the kernel's reclaim policy.  Once a hugetlb folio is on
an lruvec, kswapd, direct reclaim, MGLRU generation scanning and
cgroup v2 memory.reclaim will *all* see it -- there is no "on the LRU
but exempt from scanning" mode; LRU membership means "in the kernel's
reclaim view".  And making the LRU machinery truly understand hugetlb
means adapting per-memcg lruvec accounting, folio referenced/aging,
workingset shadows, MGLRU generations -- which is precisely spraying
if (hugetlb) special paths across generic reclaim code, in direct
conflict with the LSFMM 2024 consensus of cleaning up internals and
removing scattered special cases.  A likely suggestion, "on the LRU
but reachable only by memory.reclaim, not kswapd", fails the same
way: the LRU is the shared input of every scanner; there is no
per-consumer visibility.

Implementation layer: under this split the series deliberately takes
the minimal-invasion route -- pool management stays in hugetlb.c,
every reusable generic leaf operation (rmap walk, slot allocation,
writeout, referenced/pin checks) is shared, and only the control flow
is mirrored, with "keep in sync" notes.  Today hugetlb folios live on
per-hstate lists carrying pool semantics (reserve, surplus, demotion)
that the LRU machinery knows nothing about; if LRU-ification ever
happens, the mirrored structure folds over mechanically.  kswapd
integration is an explicit non-goal, not a "never": the design does
not close the door (the referenced check simply comes back together
with that series' scan_control), but user-space-driven is the right
default for hugetlb, in the same direction as the Reserved THP RFC's
"reserved but reclaimable" roadmap.

Q2: Why extend swap to shared file-backed (hugetlbfs) mappings?

Without it, shared mappings pin the pool absolutely: an instantiated
shared huge page is unreclaimable until truncate/unlink, however cold
the data.  Deployments mixing private and shared hugetlb get held
hostage by the shared half -- under pressure the anonymous half can
be swapped out, yet the pool still exhausts and new allocations
(including swap-in itself!) keep failing.  Concrete users:

- QEMU guests backed by MAP_SHARED hugetlbfs files (-mem-path): idle
  guest memory can finally be reclaimed with MADV_PAGEOUT instead of
  pinning the pool for the VM's entire lifetime;
- services that hold shared hugetlbfs files for coordination/staging
  but rarely touch them;
- ABI consistency: MADV_PAGEOUT succeeds on private hugetlb and every
  4K/THP mapping including shmem -- shared hugetlb was the only
  mapping type returning EINVAL, an ABI asymmetry users trip over;
- swapoff reachability: swapoff must be able to drain every kind of
  swapped-out page; incomplete coverage leaves swapoff stuck on
  anchors it cannot reach.

The anticipated objection -- "shared huge pages are for
performance-critical shared data, why swap them out" -- applies
equally to all shared file pages, yet shmem has always been
swappable.  Everything here is opt-in (proactive reclaim only on
request): nothing moves unless userspace asks.  Pool semantics hold
end to end: swap-out returns the page to the pool, swap-in competes
for pool memory again, and reservation exhaustion fails with
SIGBUS/-EIO exactly like a first-touch fault.


Testing
=======

New selftest tools/testing/selftests/mm/hugetlb_swap.c (~1120 lines,
37 assertions, 14 test functions), wired into the mm selftest
Makefile and run_vmtests.sh:

- test_pageout_basic: anonymous PAGEOUT -> PTE becomes a swap entry
  -> the huge page returns to the pool -> fault swaps back in with
  data intact
- test_fork_after_pageout: fork shares swap entries, writes COW
  without polluting the parent, parent/child MM_SWAPENTS balance
- test_munmap_releases_swap: zap releases swap entries, SwapFree
  recovers
- test_readfault_munmap_drains_swapcache: munmap after a read-fault
  swapin drains the leftover swapcache copy (both the pool page and
  the slots are returned)
- test_swapoff: swapoff drains swapped-out hugetlb pages
- test_swapin_pool_exhausted: swap-in on an exhausted pool fails with
  SIGBUS (same semantics as a first fault; no OOM, no silent errors)
- test_shared_file_swap: shared-mapping pageout (PTE cleared, no swap
  entry) -> both pread and fault swap back in with data intact, and
  the anchor can be re-established repeatedly
- test_truncate_after_pageout: ftruncate(0) after pageout frees the
  anchor and its slots; subsequent access gets SIGBUS
- test_reject_paths: VM_LOCKED / userfaultfd-registered / 1G gigantic
  are rejected with EINVAL
- test_mprotect_mremap_smoke: mprotect/mremap over swap entries
- test_vmswap_accounting: VmSwap balances over the whole lifecycle:
  +2048 kB at pageout, unchanged for the parent after fork, back to
  zero at swapin/munmap (regression test for the unsigned-negation
  zap accounting fix)
- test_soft_dirty_swap: soft-dirty bit round-trips between present
  PTEs and swap entries, verified with clear_refs isolation
- test_uffd_wp_swap: uffd-wp bit set through the swap entry, carried
  back to the present PTE at swapin, write fault delivers the WP
  event
- test_hwpoison_swapcache: PAGEOUT -> swap-in leaves the folio in the
  swap cache -> MADV_HWPOISON -> the next access must SIGBUS (must
  not silently swap stale disk data back in)

Real-machine results (x86-64, 2M huge pages, QEMU + openEuler 24.03,
dedicated swap disk): 37 assertions, 35 pass / 0 fail / 2 expected
skips (mlock is a no-op for hugetlb; no free 1G gigantic page).  Both
the VmSwap accounting balance and the hwpoison swapcache interception
are exercised end to end.

Every intermediate patch builds individually with zero warnings; the
!CONFIG_HUGETLB_PAGE configuration builds as well.


Patch split and ordering constraints
====================================

1. folio_swap_entry() helper + tree-wide conversion of all
   folio->swap readers (zero semantic change; the changelog documents
   the union pollution mechanism, the identity argument, the
   alignment invariant, and why the conversion is tree-wide rather
   than reachable-sites-only);
2. Anonymous swap-in (read-back first): hugetlb_anon_swapin() + fault
   recognition of swap entries + fork/zap/swapoff/MM_SWAPENTS
   balancing;
3. Anonymous swap-out core (producer second): the reclaim trio + the
   rmap callback (rmap.h +1 line) + the hugetlb_folio_swap_supported()
   size gate (with the swap_state.c VM_WARN backstop) + the madvise
   MADV_PAGEOUT entry point; the changelog carries the
   mirror/placement rationale and the full size-gate argument.
   The order must not be flipped: the base hugetlb_fault() returns
   ret = 0 for non-migration, non-hwpoison entries, so swap-out first
   means an endless fault livelock on swapped-out pages;
4. memory-failure adaptations -- right after patch 3, because the
   hole becomes reachable from patch 3 on, and a partial merge of
   1-3 must not leave an mf hole behind;
5. File-backed swap as one piece: the shmem-model anchor +
   hugetlbfs_writeout() + the refault/read swap-in pair + the
   truncate/evict lifecycle + swapoff traversal.  Kept together
   because none of the four is correct without the others: read-back
   alone is all dead code; swap-out without lifecycle management
   leaks anchors at truncate; lifecycle without swapoff traversal
   leaves swapoff unable to reach the anchors (file folios install no
   swap PTEs, so the mm walk cannot find them).  Any prefix of it
   would be unhealthy, hence a single patch;
6. Selftest + documentation (hugetlbpage.rst).

Comments welcome.

[1] https://lore.kernel.org/r/20250514201729.48420-1-ryncsn@gmail.com

Zongkun Lei (6):
  mm/swap: introduce folio_swap_entry() and convert all folio->swap
    readers
  mm/hugetlb: swap-in support for anonymous hugetlb folios
  mm/hugetlb: swap out anonymous hugetlb folios via MADV_PAGEOUT
  mm/memory-failure: handle swapcached hugetlb folios
  mm/hugetlb: swap support for file-backed hugetlb folios
  selftests/mm: add hugetlb_swap test, document hugetlb swap

 Documentation/admin-guide/mm/hugetlbpage.rst |   29 +-
 fs/hugetlbfs/inode.c                         |  128 +-
 fs/proc/task_mmu.c                           |   11 +
 include/linux/hugetlb.h                      |   58 +
 include/linux/pagemap.h                      |    7 +
 include/linux/rmap.h                         |    1 +
 include/linux/swap.h                         |   23 +-
 mm/huge_memory.c                             |    2 +-
 mm/hugetlb.c                                 | 1408 +++++++++++++++++-
 mm/internal.h                                |   19 +-
 mm/madvise.c                                 |   70 +
 mm/memcontrol-v1.c                           |    4 +-
 mm/memcontrol.c                              |    2 +-
 mm/memory-failure.c                          |   19 +
 mm/memory.c                                  |    2 +-
 mm/page_io.c                                 |   18 +-
 mm/rmap.c                                    |  175 ++-
 mm/shmem.c                                   |    6 +-
 mm/swap.h                                    |   14 +-
 mm/swap_state.c                              |   55 +-
 mm/swapfile.c                                |   87 +-
 mm/userfaultfd.c                             |    2 +-
 mm/util.c                                    |    2 +-
 mm/vmscan.c                                  |    4 +-
 mm/zswap.c                                   |    4 +-
 tools/testing/selftests/mm/Makefile          |    1 +
 tools/testing/selftests/mm/hugetlb_swap.c    | 1118 ++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh    |    2 +
 28 files changed, 3219 insertions(+), 52 deletions(-)
 create mode 100644 tools/testing/selftests/mm/hugetlb_swap.c

-- 
2.53.0


