Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38E08C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE286B0191; Tue, 18 Aug 2026 09:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478116B0195; Tue, 18 Aug 2026 09:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 367FB6B0197; Tue, 18 Aug 2026 09:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08DDA6B0191
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:12:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 81DFC8010A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:10 +0000 (UTC)
X-FDA: 85114428420.24.DA0A3AA
Received: from mta0.migadu.com (out-67.mta0.migadu.com [91.218.175.67])
	by imf18.hostedemail.com (Postfix) with ESMTP id E58261C0006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:12:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ku2ZoUne;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787058728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WBtwBngwOWzMFkFBBi3B8045d+kUJ8Qyb7IqyQk9qqY=;
	b=c43E6IOB6zt0aCVgfUj6tqkmWHaUj6eIYhOLWkdXGRt9F0nqunMkIKkIlXctAfIgswRkxe
	RgNQ5GAfWCiERbjiDq3Pxgja0ieeSJfDMaA1RNRW+j6vvBoQX52FdJY5awCxTySIoyHlwm
	2dfwa/TFL3ROT844UaPE98tRkUDrdLU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ku2ZoUne;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787058728;
	b=45ZLuMkk2VKOxPU5hZqxe0asvotnQdapG8qMqWMBLuxNXS/9Ko6BKpg3hz6VhDjKmai/Wo
	IJjJ9r7YP37HUubegqM3hiz35qCOCfaqkmZG7XNrMRpDDQCe9mlXttp5SRYGFfX2rSBO7m
	Q6itzdZhqCPwlBjZbprxZJmnkXrTZ+w=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=H2/+wtN9OZQjU11sS1a2j8mSL4quqo+cOA9lVD9ohS4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787058725; v=1; x=1787663525;
 b=ku2ZoUnehm336yKMuQNr5DY27yXMgOH2RDIN9l/CTMjeK7gPltOYth0fQotoCsGgoe6cBGY/
 fTDc0pNsr9NNnNUbdxc+Y5dbrp2rbfW7tbhv1X81KAepEQdlXxeHWIVgl0b+8Ng5HM5M87CfHTJ
 2Dphxv8bHcK+mmvv18S4tDag=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:19::)
	by mta12.migadu.com with ESMTPS id 9dd65e571bfab312;
	Tue, 18 Aug 2026 13:12:05 +0000
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
Subject: [PATCH v6 00/12] mm: PMD-level swap entries for anonymous THPs
Date: Tue, 18 Aug 2026 06:09:41 -0700
Message-ID: <20260818131202.494754-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j4sqko3diconbxntuaeub53ptn74ermp
X-Rspamd-Queue-Id: E58261C0006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787058726-967461
X-HE-Meta: U2FsdGVkX1+hTEQL2LXlLrGZnC8BUdsSLOESmFDvYIFZyIAY+d6KxPhcjVIuCPJQ7fe8cmWwQPJdbJxp81VczZOYkB+bNXXJiiBStea87vIsYzAADRn10M5WAxUYRvODSBtytSgIq8Vzu9H1M2O5GIyAfRTAjbuWj1f3f8rmIE7XeCOxlMVe1+it6CSuHA0qnpfoyT9/5hJvSywn6t2OiVY+U/EfaXFkLQw0CMXrD+v10kpSnF2KOhSrvnB8PyDAv2ZYgttl+h1VSX5AcLmPZPYkicQqqFCMfgOGvyqb6iATXhIu2eXynwBXs8oyaATKdWSNyoxTzYHCRq5cI7PvuPycUNrL4WhGgoXC8lSvUsmV5GKcARqjBVYSzleTuZfF6hhmJI6z1grczV/L5AfWz0m/sh8LRokTEGsfoeNP5OR9nC9yj3K8D5i68QAk2d9tLbGuHRariLVfpmvTr3bCUlVl3qt5nERDvZwp92mBWA/jPIaokge1N9aCQsC99FASY1SQKr4yEYxHDDYG9dKWSQWi6geEzgthrs8FMGSgwFORb5j8930kweaSRN4U5xDrGjJwat2Ohv96GVos/nTaUUiN/Z5n593ZDrHsUKjD4f/EEypgwhgvsqxG2YZrxT3rizHJukKk4FoILBbJZ/oT2EdcvnBtAvcyj+eTryI50OQWztnVo7Fx9YJX/rxC2D2pTWvSMPKHzUy6gnQnuYvgt5a2EQAUhYeuUrZepRUeK+jQSTxfgCwu852IZwV16Bv5FzAHMdjpbYfs2vIa+A9jKnH0OQIr0HWKnphs+0Dv5k6p61n7N/ABcrwuZktObEhsxdJGmowb2tmLw2Y/bwP4rufdcBoa67lT2ufhkZGOgZqABEs6s+XaMcEtFQ9WIxKQ+cM4uucLyiPdJ1vKj6FmtPv4vUODlLwaLkdi4xDKM9j5uayNm1Jaab7dbHEtt36mhevDOegTXuxygI6qRXB
 7c8WvOfj
 6urXol5+S3Wfa7ZPYoMg74DsLSmu5u+kCNf/sUNMUgo4h+tqAB3y/Hjy5iyJntMGB8x+eUglpd2geGSeVBXUbPEtkQv24GrruJCs4M1nZTUhio3YtYPLXHkFHGMnQCvk3trrlFtQvhHPuOolKfVXPd7/cwKPOzdlRbBJ0GCXkqVW54jlJUFw6vVJGeMK7bcVrKa1YdKaM5ICzmPAnX8w8DU4/a8aWIrWyWUJD/aVqeQkew/N/fsU1cTm8looKfVHzJ6cv9TmwtCeXN+JqbsfeK6lctwjFHh0qCfxw1EZISmwIrf0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Notes on zswap:

  Native PMD-order zswap load/store is intentionally left for a follow-up.
  Alexandre Ghiti is currently working this.
  This series can still preserve PMD swap entries while zswap is enabled:
  zswap stores the THP as order-0 entries, and PMD-order swap-in
  consumers split any range that has zswap entries before reading it.  If
  zswap has written the whole range back to disk, or the swap cache still
  contains one PMD-sized folio, PMD-level handling can proceed.

Testing:

  The 16 pmd_swap selftests pass on x86_64 with zswap both disabled and
  enabled.  PMD_SWAP_DEVICE was set, so the swapoff test ran in both
  configurations.

v5 -> v6: https://lore.kernel.org/all/20260722152043.2273289-1-usama.arif@linux.dev/
- Add patch 1 to rename pmd_to_softleaf_folio() to
  pmd_softleaf_to_folio().  No functional change. (Dev Jain)
- Patch 2: warn when pmd_softleaf_to_folio() is given a non-PFN
  softleaf rather than silently returning NULL. (Dev Jain)
- Patch 4: bound the fork extend-table fallback to one retry, re-read
  the PMD under its lock, normalize unrecoverable copy_huge_pmd() errors
  to -ENOMEM so copy_pmd_range() cannot clear and leak the source swap
  PMD, and drop a redundant thp_migration_supported() gate.
- Patch 5: check multi-page swap-cache insertions for zswap-backed slots
  in __swap_cache_add_check() under the cluster lock, both before
  allocation and before insertion, and reject mixed zswap/disk state
  with -EBUSY. (Yosry Ahmed, Nhat Pham)
- Patch 6: on a failed non-uptodate PMD-order read, remove the large
  folio from swap cache before splitting so order-0
  fallback retries individual slots rather than poisoning the whole
  2 MiB range; retain hardware-poisoned folios for per-subpage handling.
- Patch 7: make HMM snapshot mode report a PMD swap entry as non-resident,
  matching PTE swap entries, rather than HMM_PFN_ERROR.  Drop redundant
  thp_migration_supported() gates and simplify non-present PMD handling.
- Patch 8: factor PMD MADV_WILLNEED prefetch into
  swapin_pmd_swap_entry(), split and retry through PTEs after any
  PMD-order swapin failure, and replace the racy folio_test_locked()
  plus folio_lock() sequence with folio_trylock().
- Patch 9: guard PMD-swap UFFDIO_MOVE code with CONFIG_THP_SWAP, clarify
  RWP marker propagation, and reject a PMD swap entry at the destination
  with -EEXIST so UFFDIO_MOVE cannot loop forever on -EAGAIN.
- Patch 10: honor current THP/VMA policy before PMD-order swap-in, recheck
  that the PMD is still the original swap entry before splitting for PTE
  fallback, and provide the CONFIG_TRANSPARENT_HUGEPAGE wp_huge_pmd()
  declaration/stub needed by THP=n builds.
- Patch 11: make an invalid set_pmd_swap_entry() walk context warn and
  return -EINVAL instead of falsely reporting success and corrupting the
  MM_ANONPAGES/MM_SWAPENTS accounting, and add an exact PMD-size folio
  precondition check. (Luiz Capitulino)
- Patch 12: use /proc/swaps for prerequisite detection, check
  MADV_HUGEPAGE, and distinguish an environment that cannot allocate a
  PMD THP (SKIP) from a swap-out validation failure (FAIL).  Add
  partial-mprotect and partial-munmap split coverage.  Strengthen
  munmap/MADV_FREE VmSwap accounting, pagemap slot-offset checks, and
  mprotect/mremap swapped-state checks; force mremap to move, check
  munmap()'s return, and mark the UFFDIO_MOVE destination MADV_HUGEPAGE
  before asserting PMD restoration.  Move common setup and cleanup into
  one fixture, merge the swapoff fixture, remove the redundant cycles
  test, and make the data pattern differ between base pages so the split
  tests can detect incorrect slot ordering.  Order fork-COW so the parent
  writes while the child still holds the untouched shared swap entry.
  (Luiz Capitulino)
- Clarify commit messages throughout.  Retain TTU_SPLIT_HUGE_PMD after
  prototyping its removal: removing it here requires an extra rmap walk
  and broadens the series beyond PMD swap entries. (Matthew Wilcox)
- Rebase onto akpm/mm-new from 15 August (4b65683fd25f).

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
  the existing migration-entry handling). Route PMD swap entries in the
  pmd_trans_huge_lock() branch of mincore_pte_range() through
  mincore_pmd_swap() so a swapped-out PMD-mapped THP isn't reported as
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

Usama Arif (11):
  mm: rename pmd_to_softleaf_folio() to pmd_softleaf_to_folio()
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
 include/linux/leafops.h                      |  30 +-
 include/linux/pgtable.h                      |  17 +
 include/linux/swap.h                         |   4 +-
 include/linux/vm_event_item.h                |   1 +
 include/linux/zswap.h                        |   6 +
 mm/hmm.c                                     |  11 +-
 mm/huge_memory.c                             | 607 ++++++++++++++-
 mm/internal.h                                |  42 ++
 mm/khugepaged.c                              |   6 +
 mm/madvise.c                                 | 120 ++-
 mm/memory.c                                  |  47 +-
 mm/mincore.c                                 |  45 +-
 mm/rmap.c                                    |  19 +
 mm/swap.h                                    |  22 +-
 mm/swap_state.c                              |  54 ++
 mm/swapfile.c                                | 209 +++++-
 mm/userfaultfd.c                             |  14 +
 mm/vmscan.c                                  |   9 +-
 mm/vmstat.c                                  |   1 +
 mm/zswap.c                                   |  46 +-
 tools/testing/selftests/mm/Makefile          |   2 +
 tools/testing/selftests/mm/ksft_pmd_swap.sh  |   4 +
 tools/testing/selftests/mm/pmd_swap.c        | 742 +++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh    |   4 +
 33 files changed, 2104 insertions(+), 116 deletions(-)
 create mode 100755 tools/testing/selftests/mm/ksft_pmd_swap.sh
 create mode 100644 tools/testing/selftests/mm/pmd_swap.c

-- 
2.53.0-Meta


