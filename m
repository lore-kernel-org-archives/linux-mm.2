Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51B26606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aSpoMJio
Received: by kanga.kvack.org (Postfix)
	id 498D16B05B3; Thu,  5 Nov 2026 13:39:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46F2A6B05B4; Thu,  5 Nov 2026 13:39:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35DEC6B05B5; Thu,  5 Nov 2026 13:39:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F33846B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:39:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C1B6120B77
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:39:52 +0000 (UTC)
X-FDA: 85401929424.29.A5696F1
Received: from mta0.migadu.com (out-32.mta0.migadu.com [91.218.175.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 37218C0008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:39:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aSpoMJio;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.32 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793903990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yQ0iDX7z6gCaXkJueSIGsH2a3QBgAKy6AbNj0Ju+aUg=;
	b=L4e3bcuL8ZXMB2ehNOViPboAoPWhQMoovK4G/gmcisiN7Qx/aPeOWCuv68HkfQ5Gbxyf7j
	IGn8d50NsQa/fWBN/D7OkvgqR6dFL9wLCNfI9uR+x/AGk6vO3bNFf9Juk9FEcWjmYW5fJb
	OD2CjmAvsAvEqU09nD2mbOa/qdwSdNk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793903990;
	b=Qn/MhnR56iPqvQ6rY9ALdSOlcZiYiUyiTSUfDGxE3KyF3Mj7KSTQGJrF3bu2EtO02hmKsq
	tF0TuFVZ18xAqOH2p/QaiMtDY0ohsQqdOoXwxwO0DNPgEfMP2kWmK13XMnl8zpjlniEkPe
	mTb061QE/AOP6KffjAAg6wELiSEwdJw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aSpoMJio;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.32 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=T8NewT6hpw17nzdWG2mZfGw8WkZbUzJBQs0XqaPqdq0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793903988; v=1; x=1794508788;
 b=aSpoMJioyrPg6g6yY6JSVGA2/q8OChLpKqz/+P/XEM4savVG4v6Ysc4yrzTJfyhjCvS1swx3
 uYp2PNGkxD8S1X/wLIsXFk+v8nA6poA22WgEJsD93E69LAPa4EQxpLRpmRcVJ0bJ+hnWOkkVcOa
 jFt60zr6p800jffrALL1+lOU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id cd5de5ee0304fd7a;
	Thu, 05 Nov 2026 18:39:48 +0000
X-Mizu-Trace-ID: cd5de5ee0304fd7a
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
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
Subject: [PATCH v9 00/32] mm: PMD-level swap entries for anonymous THPs
Date: Thu,  5 Nov 2026 10:38:44 -0800
Message-ID: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ij6ncfo7z55pzx7wp7et3girycnnf39x
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 37218C0008
X-Rspam-User: 
X-HE-Tag: 1793903989-417864
X-HE-Meta: U2FsdGVkX1+r95tTkGJ0BrX97JNUQlS0uG9BMFLDaYeMYIfNGUgYmM5cTNTU3wdfVO9OwALtO7X7FAbm3+Wj0aPgdUm1CRNCVDx1lb7r2Kt+WOXZzpBAnBcChqgSP81wOcOLVz6u46/YwtScBYhCU4kSBDhrIqWZSUChIvUm5EV8rKnbMDtG1D8r7DtjtU2dhulb9jQrWrZDWI1J0ylT/V843VirvnxL2p9BshoPO1GLRnj3D63LQF/v/YW2RVRZqfDKe+QqbcG7cIdkBekZcNQIO6iOiiOXbF6kQRqu5ly4t2/KW4dDcTVjbLZRujyMTIfz7aMISTkN1nvMn29OH3NC4ziEpuRuIq5t12Yu9g6dHxndMxr8bDth+NEbJ7aPJkzGU6E5rfIMvVgD81WXblpaFfgujvqMD1jrnPuJcO0TzWpVhiJYPoAvoxe22XKpcrzXOc3OG9XMY1LMo/PA98iUbMV8r58CeESmZ3gO0CC9xgowUirltHoaZCf5y8hkEwsALDqRTw4lspsAt7+ad3vSVjUbRFK7dfk4GXhSpAwZlZZoM/ZtSsKZ4yJ+wEStQ7SS7axtTg2Gs6nAOwShRNc9PWJtbcx/1mvgLKLb+RDMsQEsO98bSs7GgdNHUzK46KaC2qVgPK6HFDimDPRPJ/eJ4LVcGqQk43JsNVZWw8onR9/RNjQV/g9Hugxh/9eLwSWrsVe4fnCbtaC4Upz2yqcem2gPJvjylrR1pAxoPiM9k/Ih+SExVHTB6c53ekDNKYarfB24Oju6iFvk45UVCL5irW7/W4cTHkUfg+oVv8gf3rE6rvw8bWV/X46A5KrsdUTBN1MXNC38ZbnnJm0sMlKvgmFT5MWP+LHl42tuB1IuqzBHAU79gOuQ5FC0eThfv49+gbro4d3oYLvXTqvmhePgX9cAet7+zU0nbwpqbaEfrRBA6fzAp+oV6Jt6wqWPMd7QW5zpyu9gYuHAFXC
 WDaphKNA
 EArLETVQsDjlCnkfSPtWVuLX04CQKt/9VhIvV8zwhPU21GDbI3l7r0Hz1y5UIQutjY+4q7uaq4Z9yCP4dORCB2t6OcJ4m+LnpEWpF3GWX0GjvCe+yyEC2xTayJFiDsfzLN+wGRs4RgAwTM2sptE+TKoVJPuZeWAIZOY0eYS/Q5DDZzqHXyh/w84A4YVazA7YDxwqJq7Dq6GuBgr1cBoHLz8Sm/maSD9+996L8SRmso5GXOwi1FrNpXK9m6Zsdhsw02/1+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
split into HPAGE_PMD_NR PTE-level swap entries via TTU_SPLIT_HUGE_PMD
before unmap. This series introduces a PMD-level swap entry so the
huge mapping can survive the swap round-trip and do_huge_pmd_swap_page()
can restore the PMD mapping directly on swap-in, without waiting for
khugepaged to collapse the range later.

The PMD swap entry is a compact page-table encoding for HPAGE_PMD_NR
consecutive swap slots. swap_map accounting remains per-slot and is
unchanged. A PMD swap entry does not promise that the swap cache always
contains one PMD-sized folio. While the cache is empty or contains one
PMD-sized folio, PMD-level handling can proceed. Once the cache has
split/per-slot state, users either inspect the individual slots directly
(mincore) or split the PMD swap entry and retry through the PTE path
(fault, swapoff, MADV_WILLNEED, UFFDIO_MOVE). MADV_FREE does not consult
the cache: it frees a whole PMD swap entry in place and only splits when
the advised range covers part of the PMD. Likewise, if any slot is still
backed by zswap's per-page store, PMD-order swap-in consumers split and
let the PTE path load the range page by page; an all-on-disk range can
still be read back as one PMD-sized folio.

The series is ordered so every consumer can handle PMD swap entries
before the swap-out producer starts installing them. The swap-out patch
is the last functional change.

Performance (measurements from v8):

  Measured with vm-scalability's case-swap-w-seq benchmark [1]. Four
  pinned workers repeatedly write a 6 GiB anonymous working set on a
  4 vCPU / 4 GiB guest, forcing the set out to swap and back in. Swap
  is an 8 GiB NOCOW raw virtio device (cache=none, aio=native), zswap is
  disabled, and THP enabled/defrag are both "always". The numbers below
  are medians of five interleaved runs per kernel after one warm-up run:

  Metric                          Baseline     Patched      Change
  Aggregate throughput            584.3 MiB/s  2408.9 MiB/s +312.2% (4.12x)
  Elapsed time                    85.43 s      20.72 s      -75.7%
  Major faults                    1,814,699    228,466      -87.4%
  Swap I/O rate                   1.02 GiB/s   4.10 GiB/s   +303.9%

  This swap-intensive synthetic workload measures the reduction in
  swap-fault and page-table overhead from preserving PMD mappings.
  For long-running workloads, I expect benefits from fewer TLB misses,
  less khugepaged work and retaining larger folios. I have not yet found
  a benchmark that captures those benefits well. PMD swap entries also
  move us closer to eliminating page-table deposits for anonymous THPs,
  which would save memory.

Intermediate patches and Sashiko:

  Earlier patches prepare consumers while reclaim still requests
  TTU_SPLIT_HUGE_PMD. PMD swap entries cannot reach those consumers until
  the swap-out producer is enabled. Concerns requiring live PMD swap
  entries before that patch describe an unreachable state. See [2].
  The v8 Sashiko report failed to apply and supplied no findings.

Notes on zswap:

  Native PMD-order zswap load/store is left for a follow-up.
  Alexandre Ghiti is currently working on this.
  This series can still preserve PMD swap entries while zswap is enabled:
  zswap stores the THP as order-0 entries, and PMD-order swap-in
  consumers split any range that has zswap entries before reading it.
  If zswap has written the whole range back to disk, or the swap cache
  still contains one PMD-sized folio, PMD-level handling can proceed.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree/case-swap-w-seq
[2] https://lore.kernel.org/all/282ef982-3e48-4283-9155-73a33fc1c4e8@linux.dev/

v8 -> v9: https://lore.kernel.org/all/20261002095503.3585565-1-usama.arif@linux.dev/
Patch numbers below refer to v9.
- Rebase onto akpm/mm-new at dba8aba0a9a0.
- Grow from 30 to 32 patches by extracting the migration reference fix
  and splitting the zswap preparatory changes. (Zi Yan, Yosry Ahmed)
- Patches 3 (loongarch) and 6 (s390): order the PMD exclusive helpers as
  test/mk/clear, matching their adjacent PTE helpers. (Huacai Chen)
- Patch 7: describe the exclusive-bit assertion in terms of not aliasing
  _PAGE_PSE, without making the constraint specific to 32-bit. (Zi Yan)
- Patch 8: add pmd_swp_clear_flags() alongside the PTE helper and use it
  in softleaf_from_pmd(). Keep consumers before the swap-out producer:
  no PMD swap entry can be installed in the intermediate patches. (Zi Yan)
- Patch 9: check that setting swap soft-dirty leaves the PMD non-present.
  (Lance Yang)
- Patch 10 (new): extract the reference fix already present in v8 from
  the migration-splitting API cleanup, now patch 11. A concurrent
  MADV_DONTNEED can zap or partially split the migration PMD and cause
  the old freeze=true path to strand the extra folio reference. Remove
  that reference and use freeze=false with the old API. Drop patch 11's
  claim that the PMD must still be a migration entry. (Zi Yan)
- Patch 14: explain that -EIO requests a GFP_KERNEL allocation retry,
  while other errors fail the fork. (Zi Yan)
- Patches 15-16: keep shared swap-cache allocation error cleanup and
  high-order zswap rejection separate. The new base already exports
  zswap_is_present(), so drop the separate locking documentation patch.
  (Yosry Ahmed)
- Patch 17: rename the helper to folio_has_any_hwpoisoned_page(), add a
  high level description and update all three callers, including the
  PTE-batching and PMD-fault paths in patches 29 and 30. (Zi Yan)
- Patch 28: clear the source UFFD marker before destination RWP re-arming,
  matching move_swap_pte(). (Lance Yang)
- Patch 30: leave a cached folio that is not PMD-sized in the swap cache
  on PTE fallback; it may still be a zswap writeback folio under I/O.
  (Lance Yang)

v7 -> v8: https://lore.kernel.org/all/20260914122950.3283997-1-usama.arif@linux.dev/
- Cover letter: add the case-swap-w-seq performance results. (Andrew Morton)
- Patches 2-8: reword the opening paragraph as "Prepare for ..." instead of
  referring to a later patch. (David Hildenbrand)
- Patch 4 (powerpc): move the PMD exclusive helpers next to the soft-dirty
  PMD helpers and express them the same way, as pte_pmd()/pmd_pte()
  wrappers over the PTE helpers. (David Hildenbrand)
- Patch 6 (s390): drop the comment above the helpers, keep the explanation
  in the RSTE swap layout above __SWP_OFFSET_MASK_RSTE, and move the
  helpers into the existing CONFIG_ARCH_HAS_PMD_SOFTLEAVES block above
  pmd_swp_soft_dirty(). (David Hildenbrand)
- Patch 7 (x86): add static_assert(_PAGE_SWP_EXCLUSIVE != _PAGE_PSE) so a
  32-bit build that ever selects ARCH_HAS_PMD_SOFTLEAVES fails to compile
  rather than producing pmd_present() swap entries. (Kiryl Shutsemau)
- Patch 10: rename the flag to to_migration_entries, use two-tab
  continuation indentation, reword the split comment, turn the comment on
  split_pmd_to_migration_entries() into kerneldoc, and fold the
  try_to_migrate_one() call onto one line.  Also drop that helper's
  pmd_trans_huge() || pmd_is_valid_softleaf() test, which was both too loose
  and silently skipped the split, in favour of a VM_WARN_ON_ONCE() at the top
  of __split_huge_pmd_locked() asserting that to_migration_entries implies a
  present or device-private PMD. (David Hildenbrand)
- Patch 11: drop the VM_WARN_ON_ONCE()/force and its comment from the swap
  decode arm - 10/29 now asserts the to_migration_entries contract at the top
  of __split_huge_pmd_locked() instead - and build the replacement PTEs by
  advancing pte_next_swp_offset() rather than rebuilding each entry, which
  hoists the soft-dirty/uffd/exclusive tests out of the loop. (David
  Hildenbrand).
- Patch 12 (new): split the swap-side changes out of the fork patch, so the
  swap-entry range duplication gets its own patch for the swap maintainers.
  Keeps the single-slot names as inline wrappers so existing callers are
  untouched. (David Hildenbrand)
- Patch 13 (fork): report a failed swap dup as -EIO and let copy_pmd_range()
  own the GFP_KERNEL retry, as the PTE path does, dropping the open-coded
  retry loop; move the mm counter update into each entry-type arm. (David
  Hildenbrand)
- Patch 16 (smaps): smaps_account_swap() takes nr_pages rather than a byte
  size, and the local is called swapcount. (David Hildenbrand)
- No other functional change.  All twelve sashiko findings on v7 were
  analysed and none are defects of this series.

v6 -> v7: https://lore.kernel.org/all/20260818131202.494754-1-usama.arif@linux.dev/
- Rebase onto akpm/mm-new at baa8de2f3448 and adapt to the new
  get_swap_device() contract and linear_anon_page_index().  The series grows
  from 12 to 29 patches.
- Patch 1: code unchanged; reword the commit message and collect review tags.
- Patches 2-9: split the six architecture helpers from generic detection and
  add debug_vm_pgtable coverage.  Use the s390 RSTE exclusive bit, make the
  x86 helper return bool, clear all PMD swap overlay bits before softleaf
  decoding, and add the architecture maintainers to Cc.
- Patches 10-11: add a preparatory no-functional-change cleanup of the
  migration-splitting API and keep the PMD swap split separate.
- Patch 12: reject a multi-slot duplication range that crosses a swap-cluster
  boundary.
- Patch 13: drop the zswap_load() change, now upstream as 1a904e0d3c43, and
  check for zswap after swap-cache insertion while all slots are pinned.
- Patch 14: scan every subpage for hardware poison, discard a failed or newly
  allocated unmapped PMD-sized folio before PTE fallback, and recheck the PMD
  before splitting it.
- Patches 15-23: split the non-present PMD walkers by subsystem.  Add the
  guard-advice patch so MADV_GUARD_INSTALL/REMOVE leaves PMD swap entries
  whole; the other split patches preserve v6 behaviour.
- Patch 24: honour the current THP policy, discard a failed PMD-sized folio,
  and recheck the PMD before PTE fallback.
- Patch 25: do not split after cached-folio revalidation loses a race; retry
  so a restored present THP remains whole.
- Patches 26-27: separate the independent PTE-batching hardware-poison fix,
  scan subpages directly, and discard failed or never-mapped PMD-sized folios
  before PTE retry instead of making the whole range fail with SIGBUS.
- Patch 28: keep the normal swap-out path unchanged, but make failed producer
  preconditions warn and return -EBUSY rather than BUG or return -EINVAL.
- Patch 29: grow the selftests from 16 to 17, adding
  swapin_sync/cache-residency coverage and more robust feature, fallback,
  privilege, data-integrity, and swap-device-priority handling.

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
- Collected Acks and Reviews
 
Usama Arif (32):
  mm: rename pmd_to_softleaf_folio() to pmd_softleaf_to_folio()
  arm64: mm: add PMD swap-exclusive helpers
  loongarch: mm: add PMD swap-exclusive helpers
  powerpc: mm: add PMD swap-exclusive helpers
  riscv: mm: add PMD swap-exclusive helpers
  s390: mm: add PMD swap-exclusive helpers
  x86: mm: add PMD swap-exclusive helpers
  mm: recognize PMD swap entries in the softleaf layer
  mm/debug_vm_pgtable: test PMD swap-exclusive helpers
  mm/migrate_device: avoid leaking folio references during THP splitting
  mm: make PMD migration-entry splitting explicit
  mm: split PMD swap entries into PTE swap entries
  mm/swap: allow duplicating a range of swap entries
  mm: handle PMD swap entries in fork path
  mm: swap: share swap-cache allocation error cleanup
  mm: zswap: reject high-order swap cache allocations backed by zswap
  mm: swap in PMD swap entries as whole THPs during swapoff
  fs/proc: account PMD swap entries in smaps
  mm: handle soft-dirty and uffd-wp on PMD swap entries
  mm/hmm: fault PMD swap entries on demand
  mm: free PMD swap entries in zap_huge_pmd()
  mm/madvise: free PMD swap entries with MADV_FREE
  mm/madvise: skip PMD swap entries for MADV_COLD and MADV_PAGEOUT
  mm/madvise: keep PMD swap entries whole for MADV_GUARD_INSTALL/REMOVE
  mm/mincore: report PMD swap-cache residency
  mm/khugepaged: treat PMD swap entries as mapped THPs
  mm: handle PMD swap entries in MADV_WILLNEED
  mm: handle PMD swap entries in UFFDIO_MOVE
  mm: don't PTE-batch a swap-in over a hardware-poisoned subpage
  mm: handle PMD swap entry faults on swap-in
  mm: install PMD swap entries on swap-out
  selftests/mm: add PMD swap entry tests

 Documentation/admin-guide/mm/transhuge.rst   |   5 +
 arch/arm64/include/asm/pgtable.h             |   6 +
 arch/loongarch/include/asm/pgtable.h         |  19 +
 arch/powerpc/include/asm/book3s/64/pgtable.h |   6 +
 arch/riscv/include/asm/pgtable.h             |  15 +
 arch/s390/include/asm/pgtable.h              |  20 +-
 arch/x86/include/asm/pgtable.h               |  23 +
 fs/proc/task_mmu.c                           |  45 +-
 include/linux/huge_mm.h                      |  40 +-
 include/linux/leafops.h                      |  42 +-
 include/linux/pgtable.h                      |  17 +
 include/linux/swap.h                         |  12 +-
 include/linux/swapops.h                      |  10 +
 include/linux/vm_event_item.h                |   1 +
 mm/debug_vm_pgtable.c                        |  44 +-
 mm/hmm.c                                     |  11 +-
 mm/huge_memory.c                             | 722 ++++++++++++--
 mm/internal.h                                |  61 ++
 mm/khugepaged.c                              |   6 +
 mm/madvise.c                                 | 169 +++-
 mm/memory.c                                  |  65 +-
 mm/migrate_device.c                          |   7 +-
 mm/mincore.c                                 |  47 +-
 mm/mprotect.c                                |   2 +-
 mm/rmap.c                                    |  27 +-
 mm/swap.h                                    |  30 +-
 mm/swap_state.c                              |  83 +-
 mm/swapfile.c                                | 245 ++++-
 mm/userfaultfd.c                             |  14 +
 mm/vmscan.c                                  |   9 +-
 mm/vmstat.c                                  |   1 +
 tools/testing/selftests/mm/Makefile          |   2 +
 tools/testing/selftests/mm/ksft_pmd_swap.sh  |   4 +
 tools/testing/selftests/mm/pmd_swap.c        | 989 +++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh    |   4 +
 tools/testing/selftests/mm/vm_util.c         |  24 +
 tools/testing/selftests/mm/vm_util.h         |   2 +
 37 files changed, 2640 insertions(+), 189 deletions(-)
 create mode 100755 tools/testing/selftests/mm/ksft_pmd_swap.sh
 create mode 100644 tools/testing/selftests/mm/pmd_swap.c

-- 
2.53.0-Meta


