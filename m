Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25863C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7A76B00B3; Wed, 22 Jul 2026 11:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2786C6B00B4; Wed, 22 Jul 2026 11:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18EFB6B00B5; Wed, 22 Jul 2026 11:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1D046B00B3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:20:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71F5B80211
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:20:58 +0000 (UTC)
X-FDA: 85016775396.26.19E9050
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8567614000B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:20:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ER9gVDB9;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784733657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bQygDnlW/HB0h/gQxFfG+oWJA5LnGPU/lop/0HUPq6o=;
	b=irUVv+wT8c2aREWlcyd3K/2DSDMv2M8CujS1wVMG+pDJpMlSNDELmEk0gFMYWiDfe6P+B8
	2/vxWsMcCQBiNVWqxZCrs5jxvSBoM8QJtiZTA4NpCOL9IVWxxIrJr4CExVKZzHcxsmxhZj
	fbma2I7Y1CQ22iIkPLFanKjYb5lU2Fk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ER9gVDB9;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784733657;
	b=7ZqJ7NZ+1t97ezWC90VgqF7JrxfBss7Y/O5xjBb1JdEnYqUmqOoVkosUepa++ftkdpXjWW
	JmDs9zApol7bgXyiGnUas2VWn0H7opaM+ad1BlKIsD6nmGvU3zWuFilhMyeuW12MdtUnNw
	UZaHL/fVuODaFGLTehzOuzUg2e0JJ1Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784733654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bQygDnlW/HB0h/gQxFfG+oWJA5LnGPU/lop/0HUPq6o=;
	b=ER9gVDB9XM3KFzJiSluzlIXvJWfCmbdarKy/GewgkHA8pIe/qmuugfedgtxJB4jSliq75Y
	POaanWCrMxSVytr2kLgYUoSWmkXAQyyuSFcBwRycOfwIFf5s0zy/JuYxPR1QDlElonumT+
	DWwI4KG/TSPRyg7FQcCLLpIKogNUnvY=
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
Subject: [PATCH v5 00/11] mm: PMD-level swap entries for anonymous THPs
Date: Wed, 22 Jul 2026 08:19:31 -0700
Message-ID: <20260722152043.2273289-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8567614000B
X-Stat-Signature: 1xa1rjffezj5ypqiigqwuoy7k1po1dut
X-HE-Tag: 1784733656-133611
X-HE-Meta: U2FsdGVkX18cZhZEumn9iSxswh+RdStmsPMt6680duZLYcfIYxtGCaa1NQYTtihGO68QcIAoEplocmsTtKN1J3fs9uwZ5iRvH7UQM3jfG7eig+6bVI2sbUBpDK9uJIngfIdrR+RC26O9UJzgJOlfi+5aRTVnOpfUTWASxsBERRoKgh2UyO5w2mpSiFCfiY8IWiySINEbV4lxCKtFAQIVXPuoNnV6Ln1JD/nRpdjYSaj6RElA4tgtdATcWa47qPXIcT6AnlRTy/avP8Bp8h5VrgVpTm8GSWWuXastuBfcOkTlXkoCQSE1FDeq5JSByvdDehrgXBKLFa9q3hjpJbXAfqEVgjJnFTpKBcfosAIKpRjsekNmxlfNv22Kr3xR7kB6TSMRMh1/Yd4XdywD6tVi7sn/aQAj22UCra5cLqN1FAGkGzIaPc42NYfamcbtFEU5s42NI0aFtxuwwBhiB9zGOPAHx8gz9PN8bQQN8+Kp3dxFpNxmJDyJ9lQOydN9tO6A4ZqYzNQCin9CY63jUqL3SrF3qPMPp9HtIVC+UQEAlkB15DY0rfjKqvyHRzxJIcHJz2IoxcY0FUPUg7oPCufTLg5Z3vbkK6GUH0PyWcPalDFqcmWeNF10WuBeRs+btsmMXqJR6d9vb+aN0uQwOI2KWYs7rmolkRSUWMcXJ95UT5vuSEaCFtM7261OjhSCHk/3ApmrUAX8cCVQCC4xqH1+yDkxhDeaEoWMLFimn7rYg9XZj7IJIMhB0oTdQ8GX8gOd5AmF5SHJbz/qcrqJ+lShMitsDc7ZiQBI3FjaoYgp//+4kuQG8E6qJKjQjE3TZ414FQX7QQCaICO8JSGNZEh3KlvW7250X58FAZ4hqBy0eXsPxUqzhnTdOTpQ5uRYmu6uTcM9N5BO6RpBxIk/u2ekwlCpnGboyebhnHz/LAFXK3xB1vl8gvCZRGTU9hneVS/X63aovkroIeASyYxvm1a
 OTy0LlTA
 /CdjYuO+Y0F57aQeDNMrAXdlYK7uv93x9JOFNvGqY6I3LHOA51Bu5VlRV6yI7dVYRirUxu8ueFkSKPHhdIbpY/j3qVD4FF7URjRN1vUeLNK7PMISPCBlfIDhSWK9GoOas2txPpw1phVQw9cTImTTWfJejyvUa2JnU+H0jeuren1c4FTvIVhz1rFkn40fafuCwg2xCiHPCBZ5/3E1AhKEYnIqfEsG6ZjpE5uvQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the PMD swap entry core series. The preparatory PMD softleaf [1]
cleanup series has been merged in akpm/mm-new. I got enough feedback
from sashiko to send a new revision. Hopefully sashiko will be happier
with this one.

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
     entries are valid PMD softleaf entries, prevent non-PFN entries
     from reaching softleaf_to_folio(), and add per-arch
     pmd_swp_*exclusive helpers.

  2. mm: add PMD swap entry splitting support
     Teach __split_huge_pmd_locked() to split a PMD swap entry into
     HPAGE_PMD_NR PTE swap entries.  This is the common fallback path
     whenever PMD-level handling is unsafe or unavailable.  PMD swap
     entries preserve their software flags and do not enter the
     migration-entry freeze path.

  3. mm: handle PMD swap entries in fork path
     Copy a PMD swap entry in fork via one
     swap_dup_entries_direct(HPAGE_PMD_NR) operation, with the same
     swapoff/mmlist preparation rules used by PTE entries.  Extend-table
     allocation retries cover the full PMD-sized slot range.

  4. mm: zswap: add range lookup for large-folio swapin
     Teach zswap_load() to let all-on-disk large folio reads proceed to
     the backing swap device, and add zswap_is_present() so PMD
     swap-entry consumers can split only when a specific range has
     per-page zswap state.

  5. mm: swap in PMD swap entries as whole THPs during swapoff
     Add swap_pmd_cache_lookup() and use it from swapoff.  Empty cache
     and PMD-sized cache state can be handled at PMD order; split cache
     state, zswap-backed slots, allocation/read failures, and non-uptodate
     or hardware-poisoned folios force a split and fallback to
     unuse_pte_range().  Restoring a UFFD marker in an RWP VMA also
     restores PAGE_NONE.

  6. mm: handle PMD swap entries in non-present PMD walkers
     Teach zap, mprotect, soft-dirty, uffd-wp, smaps, mincore,
     mempolicy, khugepaged, HMM, and madvise walkers about PMD swap
     entries.  mincore reports PMD-sized cache state directly and checks
     per-page slots after the cache has split; smaps calculates SwapPss
     from each slot's own swap count.

  7. mm: handle PMD swap entries in MADV_WILLNEED
     Let MADV_WILLNEED prefetch a PMD swap entry at PMD order when safe,
     treat an already cached PMD-sized folio as complete, and split/retry
     through PTEs for split cache state, zswap-backed slots, or races
     with per-slot cache population.  If per-page zswap state appears
     during the read, remove the failed PMD-sized cache folio after
     revalidating its association with the swap entry.

  8. mm: handle PMD swap entries in UFFDIO_MOVE
     Move PMD swap entries whole when the covered range is empty or
     backed by one PMD-sized folio.  Split/per-slot cache state returns
     -EAGAIN after splitting so retry can use the PTE move path and
     update per-page rmap metadata.  An RWP-registered destination gets
     the UFFD marker on the moved PMD swap entry.

  9. mm: handle PMD swap entry faults on swap-in
     Add do_huge_pmd_swap_page().  It maps a PMD-sized cached folio
     directly, or allocates/reads at PMD order when the cache is empty
     and the range has no zswap entries.  Split cache state, zswap-backed
     slots, hardware poison, and PMD-order resource failures fall back to
     the PTE path.  UFFD RWP state is restored with PAGE_NONE, and write
     faults retain their original write state through swap-slot release
     and any required COW handling.

 10. mm: install PMD swap entries on swap-out
     Stop forcing TTU_SPLIT_HUGE_PMD for PMD-mappable swapcache folios
     and install one PMD swap entry instead.  Zswap still stores the THP
     as per-page compressed entries; PMD-order swap-in consumers preserve
     a PMD-sized cached folio or read an all-on-disk range as a whole THP,
     and split before reading per-page zswap state.  Add thp_swpout_pmd
     to count each PMD mapping replaced by a PMD-level swap entry.

 11. selftests/mm: add PMD swap entry tests
     Add pmd_swap selftests covering swap-out/in, fork, fork+COW,
     repeated cycles, write fault, UFFD RWP restoration, munmap, mprotect,
     mremap, pagemap, mincore, MADV_FREE, MADV_WILLNEED, UFFDIO_MOVE, and
     swapoff.  Register the 15-test suite with run_vmtests.sh and the
     default kselftest runner.

Notes on zswap:

  Native PMD-order zswap load/store is intentionally left for a follow-up.
  Alexandre Ghiti is currently working this.
  This series can still preserve PMD swap entries while zswap is enabled:
  zswap stores the THP as order-0 entries, and PMD-order swap-in
  consumers split any range that has zswap entries before reading it.  If
  zswap has written the whole range back to disk, or the swap cache still
  contains one PMD-sized folio, PMD-level handling can proceed.

v4 -> v5: https://lore.kernel.org/all/20260713133613.2707815-1-usama.arif@linux.dev/
- Commit message improvements for almost all patches (Yosry for zswap patch)
- Patch 1: make pmd_to_softleaf_folio() reject softleaf entries that do
  not encode a PFN, so a PMD swap offset is never interpreted as one.
  PMD swap entries remain valid softleaf entries for classification.
  (sashiko)
- Patch 2: use the existing pmd_swp_uffd() helper and force freeze=false
  for PMD swap entries, which have no struct page for the migration-entry
  freeze path. (sashiko)
- Patch 3: document that the caller's page-table or swap-cache reference
  pins every source slot while a partial PMD-sized duplication is rolled
  back.  Keep the pre-existing PTE fork retry behavior outside this
  series. (sashiko)
- Patch 5: split to the PTE path rather than mapping a PMD-sized folio
  containing a hardware-poisoned subpage, and restore PAGE_NONE when
  swapoff restores a UFFD marker in an RWP VMA. (sashiko)
- Patch 6: account SwapPss for a PMD swap entry one slot at a time because
  the slots can have different swap reference counts.
- Patch 7: if PMD-order MADV_WILLNEED encounters newly populated per-page
  zswap state, revalidate and remove the failed clean PMD-sized cache
  folio before retrying through PTEs.
- Patch 8: mark a moved PMD swap entry for UFFD when the UFFDIO_MOVE
  destination VMA is RWP-registered. (sashiko)
- Patch 9: restore PAGE_NONE for UFFD RWP swap-in, preserve the original
  write-fault state through swap-slot release and COW handling, remove
  the unnecessary LRU drain, and prevent PTE batching from mapping a
  poisoned subpage. (sashiko)
- Patch 10: add and document thp_swpout_pmd, which counts PMD mappings
  replaced by PMD-level swap entries rather than swapped folios.
- Patch 11: register pmd_swap with the default mm selftest runner, preserve
  errno across UFFDIO_MOVE cleanup, check swapoff residency before the
  first memory access, add a parent-side write and verification to the
  fork+COW test, and add RWP regression coverage for swap-in, UFFDIO_MOVE,
  and swapoff. (sashiko)
- Keep do_huge_pmd_swap_page() in patch 9.  Patches 6 and 7 only add
  consumers; patch 10 remains the first producer, so no PMD swap entry
  can reach those paths before the fault handler is present. (sashiko)
- Rebase onto latest akpm/mm-new from 22 July (5e0603ba185a)

v3 -> v4: https://lore.kernel.org/all/20260703173903.3789516-1-usama.arif@linux.dev/
- Patch 1: guard the new arch-specific pmd_swp_mkexclusive /
  pmd_swp_exclusive / pmd_swp_clear_exclusive helpers on arm64,
  loongarch, powerpc, riscv, s390, and x86 with
  CONFIG_ARCH_HAS_PMD_SOFTLEAVES, matching the pattern already
  used for pmd_swp_soft_dirty.  Also fixes the redefinition-vs-
  generic-fallback build errors kernel test robot reported on
  i386-allnoconfig-bpf and riscv-allnoconfig-bpf, and rewraps
  the patch 1 commit message paragraphs to ~75 columns.
  (sashiko, kernel test robot, Usama Arif)
- Patch 2: switch the trailing folio_remove_rmap_pmd() gate in
  __split_huge_pmd_locked() from *pmd to old_pmd, old_pmd retains
  the original present-or-non-present classification for every
  branch above. (sashiko)
- Patch 3: teach swap_retry_table_alloc() (and the underlying
  swap_extend_table_alloc()) to accept an nr parameter and scan
  every slot in [ci_off, ci_off + nr) before committing an
  extend-table allocation.  (sashiko)
- Patch 4: rename zswap_range_has_entry() to zswap_is_present() so
  the same helper serves both single-slot (nr=1) and range queries,
  and switch the implementation from XA_STATE + xas_find() to
  xa_find(), which handles RCU locking and internal-retry markers
  itself.  Rename the callers in patches 5, 7, 9. (Yosry)
- Patch 9: refuse to map a swap-cache folio in do_huge_pmd_swap_page()
  when folio_contain_hwpoisoned_page() reports a poisoned subpage;
  split the PMD swap entry so do_swap_page() can return
  VM_FAULT_HWPOISON per subpage instead of the PMD handler mapping
  the corrupted memory as one THP.  Mirrors the PageHWPoison check
  the PTE swap-in path already performs. (sashiko)
- Patch 9: note explicitly in the commit message that PMD-order
  swap-in deliberately skips the order-0 readahead paths, order-0
  readahead would populate per-page swap-cache state and force the
  PMD swap entry to split before the fault could finish. (Kairui)
- Patch 10: move mm_prepare_for_swap_entries() into
  set_pmd_swap_entry() between folio_dup_swap() and set_pmd_at()
  so this mm is on init_mm.mmlist before any swap PMD referencing
  slots with a non-zero swap_map becomes visible.  Matches the PTE
  swap-out ordering. (sashiko)
- rebase onto latest akpm/mm-new (61cccb8363fcc282d4ae0555b8739dd227f5ad0b)


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
  CONFIG_ARCH_HAS_PMD_SOFTLEAVES so the gate that now drives
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

 Documentation/admin-guide/mm/transhuge.rst   |   5 +
 arch/arm64/include/asm/pgtable.h             |   6 +
 arch/loongarch/include/asm/pgtable.h         |  19 +
 arch/powerpc/include/asm/book3s/64/pgtable.h |  17 +
 arch/riscv/include/asm/pgtable.h             |  15 +
 arch/s390/include/asm/pgtable.h              |  17 +
 arch/x86/include/asm/pgtable.h               |  17 +
 fs/proc/task_mmu.c                           |  46 +-
 include/linux/huge_mm.h                      |  16 +
 include/linux/leafops.h                      |  26 +-
 include/linux/pgtable.h                      |  17 +
 include/linux/swap.h                         |   4 +-
 include/linux/vm_event_item.h                |   1 +
 include/linux/zswap.h                        |   6 +
 mm/hmm.c                                     |   3 +-
 mm/huge_memory.c                             | 581 +++++++++++-
 mm/internal.h                                |  34 +
 mm/khugepaged.c                              |   6 +
 mm/madvise.c                                 | 101 ++-
 mm/memory.c                                  |  45 +-
 mm/mincore.c                                 |  45 +-
 mm/rmap.c                                    |  19 +
 mm/swap.h                                    |  22 +-
 mm/swap_state.c                              |  44 +
 mm/swapfile.c                                | 202 ++++-
 mm/vmscan.c                                  |   9 +-
 mm/vmstat.c                                  |   1 +
 mm/zswap.c                                   |  42 +-
 tools/testing/selftests/mm/Makefile          |   2 +
 tools/testing/selftests/mm/ksft_pmd_swap.sh  |   4 +
 tools/testing/selftests/mm/pmd_swap.c        | 874 +++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh    |   4 +
 32 files changed, 2139 insertions(+), 111 deletions(-)
 create mode 100755 tools/testing/selftests/mm/ksft_pmd_swap.sh
 create mode 100644 tools/testing/selftests/mm/pmd_swap.c

-- 
2.53.0-Meta


