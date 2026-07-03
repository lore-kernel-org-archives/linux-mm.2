Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24C2DC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:39:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 067F36B00B5; Fri,  3 Jul 2026 13:39:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 018D36B00B6; Fri,  3 Jul 2026 13:39:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E497D6B00B7; Fri,  3 Jul 2026 13:39:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFFD46B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:39:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33CDE167B84
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:39:17 +0000 (UTC)
X-FDA: 84948176754.29.6CCFA34
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1A18F4000B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:39:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gukx+cOL;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783100355;
	b=YVpXFo2Mw7VZFrld/aUQJAG3zF3+AsAUGmKpHvwSeIs11hJZ9yPJuHk1ZZ6DHmjLoCJedR
	kUBHMWLNQzncImPv1cD7s+qfKEAmP8K9yBL51rPWDkqkEepZJR/++cBdZipfcaE8J/vsLt
	wPZz2g7bKwE4C0U0VJ6T9TS1hIHhTc8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783100355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MoJOnOHxm7jLg30HSy4qAc3I5E0YLF/JOfW0fe5lT6Q=;
	b=sZ/VSjko/WfUjldHsoUWeHfGQ5fRMp8L9+14F4+XthVYZ1pVOWqn5/4kir8uH4DUIHrhnL
	Hp4lNoaZeR/b+4Op2pQ/Brm/dRsN0aECdhfb0/kzce5UbtsII1p7LtDUT7dYAb2XDBqkxW
	zq70WcLQ7bHt2yCXSBVOn/vUqH8mLwM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gukx+cOL;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783100351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MoJOnOHxm7jLg30HSy4qAc3I5E0YLF/JOfW0fe5lT6Q=;
	b=Gukx+cOLX36ytmyO0AOZV2HVR4fbblLMBRxTZ6iO53POpf974201sbxG7rcORSr+9ft69V
	FzC8WT3xf6AnInwibzGNORpyQcFcJDvj1CRVgcmFEmRPZjFg4FaSulAfGN0HSYjAlHv0os
	hc3awgnB4I1D135z2Gu+BP8B8peEBKo=
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
Subject: [PATCH v3 00/11] mm: PMD-level swap entries for anonymous THPs
Date: Fri,  3 Jul 2026 10:38:17 -0700
Message-ID: <20260703173903.3789516-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: p74ducwmy9o5orxssz986tbhstyd6kx6
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A18F4000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1783100354-435973
X-HE-Meta: U2FsdGVkX19fhd8AwjeqwE9PT90NQvbuTYo2VumWr2qKjL0qxFcLT68tkNVCKGnOXRRp+gPnvI9RDdxCvmIfI5fcSBGWW6lugEBm8niMiC1imJpM4x4NuFd6TGutIYZ0eBCkVcgK/FMxrG7V52hhF7CrEQJkOg+lDagrR7XUntEVGLvST9GRSUoC8L2H25XcUCbjea3kSgipwXF5tF7tCA3//vc+U+dP9FzVe/MGYBvWehT3uNYkzi+Ogvjlq3fJ5C/bchMALlr40E2Glc3hBlB6RJ4xkLGW2oWRJv5NShSaFc0XyI7hm1PaR5nSqQ2z/K8S4+/EYy749iVySsfdjOPr3GNKjp2QvfZchKkeypfLIW3reEpgZoN6UIRazheGHivG4ytPR3Fc8xhI+Z8Nuqy8jIEHDWG/GTAHS8SSkRd8+8RCg4+I+Lvqj/byN1wcNmP4ph9hAaozhkZa7O0XKPtwvW7eJYDEA7r1jgcnNESFj4gqYSDD9MHUGmUc+VHuRt9D9Dpc8N/OkywyGn4abVqXqmRyPJ63YbxeQz571uVnn7J5qvrvj+7epdg1xzWfi20VRReN50cIukuEcJ57+JJYuzW2LhvwVfGHO6Y4Hm7SNlrW+c9xin//qIJXxtNWb2j35p4Tpvzq7ywa7TPDRiKn5E0BgSQE1jg4mgfo6ZF3jwuUnit2RwpVLabNPPYLgL+2NcMcSSEZNkm2N2hosXK5TFtmT2w+z1k4SGze+ppJ4Ve2mLy0kI4GoSh4GIzdd0BI0mCbIxtathnRlyi+Nbp2rpAAkYl7QYhtwAG8MIWUjkA1Kuy9C3FGPmopipJHxTWqttF7hKfcasfACegJ1jsJKF94ZgApRZbAAZ5SD1CLIC/DXJavlEGYqezOg3eejgA/PT/GtKfWTv36v9zd4wdWQZVMZiJDiJLJxb0pEDeYRACcgHpicOXknPzptcmxeg4Gn+z9J5/XvXpecwn
 ivl09NhV
 xek8sNnJmTzoR4mPIsMMtX5USeNf5+pLwmJTTgPOsMg8tfuJeOA1RVv0cG4i5drCkCdCIY20PsFtPnfg25u/hnCqSbUxdrZ+d2PR/L7FDT9N/VgvfvPFoKkmrDlYciFP3htWGoMJ4EzT4Cb/1B9PkPClXJb4jHqtadfDYSyYY0AuzWYhjhXj0vOoQ203Ijx3WGTjTxxb300FKp2AMKlooyijLGRN5xVF9B4R2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the PMD swap entry core series. The preparatory PMD softleaf [1]
cleanup series has been merged in akpm/mm-new, so this series is now
based directly on akpm/mm-new.

When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
split into HPAGE_PMD_NR PTE-level swap entries via TTU_SPLIT_HUGE_PMD
before unmap.  This series introduces a PMD-level swap entry so the
huge mapping can survive the swap round-trip and do_huge_pmd_swap_page()
can restore the PMD mapping directly on swap-in, without waiting for
khugepaged to collapse the range later.

The PMD swap entry is a compact page-table encoding for HPAGE_PMD_NR
consecutive swap slots.  swap_map accounting remains per-slot and is
unchanged.  Importantly, a PMD swap entry does not promise that the swap
cache always contains one PMD-sized folio.  While the cache is empty or
contains one PMD-sized folio, PMD-level handling can proceed.  Once the
cache has split/per-slot state, users either inspect the individual
slots directly (mincore) or split the PMD swap entry and retry through
the PTE path (fault, swapoff, MADV_WILLNEED, UFFDIO_MOVE).  Likewise,
if any slot is still backed by zswap's per-page store, PMD-order
swap-in consumers split and let the PTE path load the range page by page;
an all-on-disk range can still be read back as one PMD-sized folio.

The series is ordered so every consumer can handle PMD swap entries
before the swap-out producer starts installing them.  The swap-out patch
is the last functional change.

Patch breakdown:

  1. mm: add PMD swap entry detection support
     Add pmd_is_swap_entry(), teach the softleaf layer that PMD swap
     entries are valid PMD softleaf entries, and add per-arch
     pmd_swp_*exclusive helpers.

  2. mm: add PMD swap entry splitting support
     Teach __split_huge_pmd_locked() to split a PMD swap entry into
     HPAGE_PMD_NR PTE swap entries.  This is the common fallback path
     whenever PMD-level handling is unsafe or unavailable.

  3. mm: handle PMD swap entries in fork path
     Copy a PMD swap entry in fork via one
     swap_dup_entries_direct(HPAGE_PMD_NR) operation, with the same
     swapoff/mmlist preparation rules used by PTE entries.

  4. mm: zswap: add range lookup for large-folio swapin
     Teach zswap_load() to let all-on-disk large folio reads proceed to
     the backing swap device, and add zswap_range_has_entry() so PMD
     swap-entry consumers can split only when a specific range has
     per-page zswap state.

  5. mm: swap in PMD swap entries as whole THPs during swapoff
     Add swap_pmd_cache_lookup() and use it from swapoff.  Empty cache
     and PMD-sized cache state can be handled at PMD order; split cache
     state, zswap-backed slots, allocation/read failure, or non-uptodate
     folios split the PMD and fall back to unuse_pte_range().

  6. mm: handle PMD swap entries in non-present PMD walkers
     Teach zap, mprotect, soft-dirty, uffd-wp, smaps, mincore,
     mempolicy, khugepaged, HMM, and madvise walkers about PMD swap
     entries.  mincore reports PMD-sized cache state directly and checks
     per-page slots after the cache has split.

  7. mm: handle PMD swap entries in MADV_WILLNEED
     Let MADV_WILLNEED prefetch a PMD swap entry at PMD order when safe,
     treat an already cached PMD-sized folio as complete, and split/retry
     through PTEs for split cache state, zswap-backed slots, or races
     with per-slot cache population.

  8. mm: handle PMD swap entries in UFFDIO_MOVE
     Move PMD swap entries whole when the covered range is empty or
     backed by one PMD-sized folio.  Split/per-slot cache state returns
     -EAGAIN after splitting so retry can use the PTE move path and
     update per-page rmap metadata.

  9. mm: handle PMD swap entry faults on swap-in
     Add do_huge_pmd_swap_page().  It maps a PMD-sized cached folio
     directly, or allocates/reads at PMD order when the cache is empty
     and the range has no zswap entries.  Split cache state, zswap-backed
     slots, and PMD-order resource failures fall back to the PTE path.

 10. mm: install PMD swap entries on swap-out
     Stop forcing TTU_SPLIT_HUGE_PMD for PMD-mappable swapcache folios
     and install one PMD swap entry instead.  Zswap still stores the THP
     as per-page compressed entries; PMD-order swap-in consumers preserve
     a PMD-sized cached folio or read an all-on-disk range as a whole THP,
     and split before reading per-page zswap state.

 11. selftests/mm: add PMD swap entry tests
     Add pmd_swap selftests covering swap-out/in, fork, fork+COW,
     repeated cycles, write fault, munmap, mprotect, mremap, pagemap,
     mincore, MADV_FREE, MADV_WILLNEED, UFFDIO_MOVE, and swapoff.

Notes on zswap:

  Native PMD-order zswap load/store is intentionally left for a follow-up.
  Alexandre Ghiti is currently working this.
  This series can still preserve PMD swap entries while zswap is enabled:
  zswap stores the THP as order-0 entries, and PMD-order swap-in
  consumers split any range that has zswap entries before reading it.  If
  zswap has written the whole range back to disk, or the swap cache still
  contains one PMD-sized folio, PMD-level handling can proceed.

v2 -> v3: https://lore.kernel.org/all/20260602142537.198755-1-usama.arif@linux.dev/
- Clarified the PMD swap entry rule: it is a compact encoding for
  HPAGE_PMD_NR swap slots, not a guarantee that swap cache always has
  one PMD-sized folio. (Lance Yang)
- Swapoff, fault, MADV_WILLNEED, and UFFDIO_MOVE now classify the
  whole PMD swap-cache range and split/retry through the PTE path for
  split/per-slot cache state. (Lance Yang)
- mincore handles PMD swap entries without assuming one lookup covers
  a split swap-cache range. (Lance Yang)
- UFFDIO_MOVE rechecks all HPAGE_PMD_NR slots before moving an empty
  PMD swap-cache range, avoiding stale rmap metadata for per-slot
  cached folios.
- Added a standalone zswap prerequisite patch from Alexandre that
  distinguishes all-on-disk large-folio ranges from ranges with
  per-page zswap entries.
- Replaced the global zswap-ever-enabled policy with per-range zswap
  checks: PMD swap entries can still be installed while zswap is
  enabled, and PMD-order swap-in consumers split when the range has
  per-page zswap state.
- Added a mincore selftest and updated MADV_WILLNEED coverage so the
  test checks that the PMD swap entry remains in place until first
  touch.  Total pmd_swap coverage is now 14 tests.


v1 -> v2: https://lore.kernel.org/all/20260427100553.2754667-1-usama.arif@linux.dev/
- Patch 1: convert two additional softleaf_to_pmd() callers that
  landed in mm-unstable since v1 (mm/debug_vm_pgtable.c,
  mm/migrate_device.c) (Dev)
- Patch 2: rename helper ensure_on_mmlist() to
  mm_prepare_for_swap_entries() to better describe its purpose
  (David)
- Patch 3: drop VM_WARN_ON_ONCE(!pmd_is_migration_entry) as
  Dev posted it as a separate patch.
- Patch 5 (new): move softleaf_to_folio() inside the device-private
  branch in migrate_vma_collect_pmd(); same class of fix as patch 4
  but for the migrate-device PMD walker.
- Patch 6 (new): rename CONFIG_ARCH_ENABLE_THP_MIGRATION to
  CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF so the gate that now drives
  swap-entry support too is named for what it actually controls
  (PMD softleaf entries), not just migration. (Dev)
- Patch 7: add the missing pmd_swp_exclusive / mkexclusive /
  clear_exclusive helpers for powerpc.
- Patches 10 and 14: use upstream swapin_sync() (bundles
  swap_cache_alloc_folio + swap_read_folio + the -EEXIST race
  retry) instead of the bespoke swapin_alloc_pmd_folio() helper
  from v1; do_swap_page and shmem_swapin_folio use the same
  helper (Kairui)
- Patch 10: construct a stack vm_fault for the swapoff swap-in so
  the allocator can resolve a mempolicy, mirroring how the PTE
  swapoff path (unuse_pte_range) already does it.
- Patch 11: extend coverage to check_pmd_state() in khugepaged so a
  swapped-out PMD-mapped THP is treated as SCAN_PMD_MAPPED (matches
  the existing migration-entry handling). Route the
  pmd_trans_huge_lock() branch of mincore_pte_range() through
  mincore_swap() so a swapped-out PMD-mapped THP isn't reported as
  resident.
- Patch 12 (new): handle PMD swap entries in MADV_WILLNEED via
  swapin_sync(BIT(HPAGE_PMD_ORDER)); a naive order-0 read-ahead
  would force the subsequent fault to split.
- Patch 13: refuse UFFDIO_MOVE with -EBUSY if the swap-cache folio
  was split between swap-out and the move, matching
  move_pages_pte()'s rejection of large folios; otherwise only one
  of the 512 anon-rmaps would be re-anchored to dst_vma.
- Patch 16: alloc_fill_swap_thp() now uses the existing
  mmap_pmd_aligned() helper so tests don't flake/skip based on VA
  placement; new MADV_WILLNEED test that watches the PMD-order
  mTHP swpin counter; swapoff test restructured to use the
  kselftest_harness ASSERT cleanup blocks (no double swapoff, no
  verify-after-munmap).
- Collected Acks and Reviews.

[1] https://lore.kernel.org/all/20260630164143.1595669-1-usama.arif@linux.dev/ 
 
Alexandre Ghiti (1):
  mm: zswap: add range lookup for large-folio swapin

Usama Arif (10):
  mm: add PMD swap entry detection support
  mm: add PMD swap entry splitting support
  mm: handle PMD swap entries in fork path
  mm: swap in PMD swap entries as whole THPs during swapoff
  mm: handle PMD swap entries in non-present PMD walkers
  mm: handle PMD swap entries in MADV_WILLNEED
  mm: handle PMD swap entries in UFFDIO_MOVE
  mm: handle PMD swap entry faults on swap-in
  mm: install PMD swap entries on swap-out
  selftests/mm: add PMD swap entry tests

 arch/arm64/include/asm/pgtable.h             |   4 +
 arch/loongarch/include/asm/pgtable.h         |  17 +
 arch/powerpc/include/asm/book3s/64/pgtable.h |  15 +
 arch/riscv/include/asm/pgtable.h             |  15 +
 arch/s390/include/asm/pgtable.h              |  15 +
 arch/x86/include/asm/pgtable.h               |  15 +
 fs/proc/task_mmu.c                           |  43 +-
 include/linux/huge_mm.h                      |  11 +
 include/linux/leafops.h                      |  24 +-
 include/linux/pgtable.h                      |  17 +
 include/linux/swap.h                         |   4 +-
 include/linux/vm_event_item.h                |   1 +
 include/linux/zswap.h                        |   7 +
 mm/hmm.c                                     |   3 +-
 mm/huge_memory.c                             | 565 ++++++++++++++-
 mm/internal.h                                |  36 +
 mm/khugepaged.c                              |   6 +
 mm/madvise.c                                 |  89 ++-
 mm/memory.c                                  |  42 +-
 mm/mempolicy.c                               |   2 +
 mm/mincore.c                                 |  45 +-
 mm/rmap.c                                    |  20 +
 mm/swap.h                                    |  17 +
 mm/swap_state.c                              |  44 ++
 mm/swapfile.c                                | 161 ++++-
 mm/vmscan.c                                  |   9 +-
 mm/vmstat.c                                  |   1 +
 mm/zswap.c                                   |  46 +-
 tools/testing/selftests/mm/Makefile          |   1 +
 tools/testing/selftests/mm/pmd_swap.c        | 702 +++++++++++++++++++
 30 files changed, 1878 insertions(+), 99 deletions(-)
 create mode 100644 tools/testing/selftests/mm/pmd_swap.c

-- 
2.53.0-Meta


