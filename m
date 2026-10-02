Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE1ECA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 14:28:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE18F6B00A6; Fri,  2 Oct 2026 10:28:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91DC6B00A7; Fri,  2 Oct 2026 10:28:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B58FE6B00A9; Fri,  2 Oct 2026 10:28:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 898E46B00A6
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:28:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C21C8120785
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:28:51 +0000 (UTC)
X-FDA: 85277917662.02.2D35686
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E0F97C0002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:28:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LRcZmqfx;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790951330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vr0vkutukniXUYWWryTnDf5STCNZT3OWCRwNBZdWN8s=;
	b=ZJ76Zz9zPRJerAkBNvXuxt+sNIqxJwisCshDbIxQN+Q2giMGd7n8/ME1ka3DTFM3YsiVRx
	QpT2u73RfWFyWV/ZO7vMUp4dq5vomLKMStNruWYVe0jlsKYYAva+EIHLAqMZ+1V6s8To+e
	K7OBcAfELcZvg+rnbEx0O5RlvuXgwKo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LRcZmqfx;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790951330;
	b=D+E8o4qMd9RwjzpPWgYBukMgBu5RH7iSIbgoCy0EFGE+hsE9DRtdI+RQZf2lwMbFOOy+kR
	VW8KY9pQpJuC19UjBwzpBp4RYkEcQHomplRzmsxP1FaZ6W896q/C1j7xMZBGu2mEEAcgyR
	l7trrlzxK1pXK6P8e/5eZzsLkS9HZaQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 35F664086D;
	Fri,  2 Oct 2026 14:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838BA1F000FF;
	Fri,  2 Oct 2026 14:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790951329;
	bh=vr0vkutukniXUYWWryTnDf5STCNZT3OWCRwNBZdWN8s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LRcZmqfx+XNdJu5UtT8niDp7bEAIJ8bjn1MBui9QDnVsQrcIByzrx5tBbrNm3tyqf
	 WwkGz/a2Ys1SMFnaNw4gXa8tgxpcPjVcgoYablGyp3vS6cA8ENnNsxblpW9kntP3cU
	 A6ErL+0fUfbvS/VYGz5L5lf9TmoVfHU/OET8NmKWg7PAUGAZG90pN9TR3lS2zFTKun
	 Ixomg0L0gbgUVK9lUa8NR+VyRZfBySj5DfKlIA6q3tE6mt0rSpNFTkdmhy3tZEFoim
	 b6/SnkFJ0f1loLm6hxArJpkHbfXcb79tVm+0fU5I7X4d2+r/qFQK2Wt8QCV2217DFH
	 SggN3OwNg3j5w==
Message-ID: <ebc72eb7-daf3-45be-8994-b51e5e301b56@kernel.org>
Date: Fri, 2 Oct 2026 16:28:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/30] mm: PMD-level swap entries for anonymous THPs
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com
References: <20261002095503.3585565-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E0F97C0002
X-Stat-Signature: qq7m6f5eetg41xzr6wcqdrpqsdd9pbam
X-HE-Tag: 1790951329-39671
X-HE-Meta: U2FsdGVkX1+wW7p8HZ/fy/JfTduGirpDNNhUM4JAWzjHOsPtnrqOPvvyC1AtDHVKi+GaTrIokXdEaDAvRYaRYax/Y870jExPpy+09oExXt0psmN799NKPXBSyvljbO2ha4gxSdNGh84R5zEhq1g66D1CZEFwQcEBCz3NSKJuxPt5dLSmQuRsek+q2w2W8NEgfL6MwhwlEknNkeNWPq58UWhf//+lLXYw7Lu+0GZ67fuYqqzNE3Y5qGd5ewG+Qgfavh3pvz2wkUg2wB0dX0Mu68iJg/UIiZIJgmfr8wfw8fcWUUjujH/XoGOsA8gW/A7RchVrHlf9xeYf4oEmQpc0UWCAxOdzmv6Ajx+hPgqp2UkVgiS0e9PFqFGpxBRMyfnzP1yiJU+0L+Xl5OuiGFry/oIwDU0VCsF5E8iiK5+cJgV0X3EcVGl/D+muPQTGJNUyY6mbvBdF24dvvVWJUKgV46ZFF6LWoCPuGX8XnHDl3eZbbCUl++XC6VZQW9P6RfO2ois9weGjHPMIbm1p10a+i+8SOFoMmMI8+xXGal7uyoHBiQd+v7ASXs1Y1BHIiEK/b7X8QQY5fEUcrgP0/K7lqAjXFuvc/olRr7bFqbtvKBGb+KKObEUMg6n6Hadb05nXBW8L0u91rRaRfZ5cC99I/xLMJjlD6t4eJ8pG/4DL6gPtvxkF74wpYf4iw2vy3Efqe898veK0K9jyvFmvXb/lSprmW85OP/X3c2navDlH65LX0lAgZKonFsccXB0de5eFrJFyT3O2QJu1jhk6t6vXNqil4IIWaWgXimjW7xZFwysCXQP9fo+l6mSKQJUzwquEXxjHaWkzYqUWoLiHLIbAI7sbeRtCA5S0CSY1f7AEvQ2YorrMzJHBxAg9K3g+gzih19exdbiTLSjE+JP0g3NMJelR/REazVcRI54xHqW4jC1NarRJ7S5rs5PudlmzfM0mQYm0OjGtUQA2s7lTG7J
 fCZ3tqmB
 S9lM/+kvKMQA7Xm3Y0kvS0NXXJWIWawp67oBwQ5kZUEMOhOtwWf5Lgglcrw7Q8PJ5zi0zQy4PbSlXrMvW1UNRkBWDX5Svye1I90wWje4XC7eQR2kTB4mdP+/vnmnUi7CIw0y/BgLMd6l/PMjubDsS/1S7TOOudQ7BCrMzj1wqka31h5bpIIEOKvqPtStwlb7jArkWDy10Srkc+REYxBFW+2wJ0UWzteluezYtCC17zFGqZJ0kvcnUnJSHqVBESFSAa/+D5AXBB6rJAYw4wT7MiXi5IGaw33R+rE8j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/26 11:52, Usama Arif wrote:
> When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
> split into HPAGE_PMD_NR PTE-level swap entries via TTU_SPLIT_HUGE_PMD
> before unmap.  This series introduces a PMD-level swap entry so the
> huge mapping can survive the swap round-trip and do_huge_pmd_swap_page()
> can restore the PMD mapping directly on swap-in, without waiting for
> khugepaged to collapse the range later.
> 
> The PMD swap entry is a compact page-table encoding for HPAGE_PMD_NR
> consecutive swap slots.  swap_map accounting remains per-slot and is
> unchanged.  Importantly, a PMD swap entry does not promise that the swap
> cache always contains one PMD-sized folio.  While the cache is empty or
> contains one PMD-sized folio, PMD-level handling can proceed.  Once the
> cache has split/per-slot state, users either inspect the individual
> slots directly (mincore) or split the PMD swap entry and retry through
> the PTE path (fault, swapoff, MADV_WILLNEED, UFFDIO_MOVE).  MADV_FREE
> does not consult the cache at all: it frees a whole PMD swap entry in
> place and only splits when the advised range covers part of the PMD.
> Likewise, if any slot is still backed by zswap's per-page
> store, PMD-order swap-in consumers split and let the PTE path load the
> range page by page; an all-on-disk range can still be read back as one
> PMD-sized folio.
> 
> The series is ordered so every consumer can handle PMD swap entries
> before the swap-out producer starts installing them.  The swap-out patch
> is the last functional change.
> 
> Performance:
> 
>   Measured with vm-scalability's case-swap-w-seq benchmark [1].  Four
>   pinned workers repeatedly write a 6 GiB anonymous working set on a
>   4 vCPU / 4 GiB guest, forcing the set out to swap and back in.  Swap
>   is an 8 GiB NOCOW raw virtio device (cache=none, aio=native), zswap is
>   disabled, and THP enabled/defrag are both "always".  The numbers below
>   are medians of five interleaved runs per kernel after one warm-up run:
> 
>   Metric                          Baseline     Patched      Change
>   Aggregate throughput            584.3 MiB/s  2408.9 MiB/s +312.2% (4.12x)
>   Elapsed time                    85.43 s      20.72 s      -75.7%
>   Major faults                    1,814,699    228,466      -87.4%
>   Swap I/O rate                   1.02 GiB/s   4.10 GiB/s   +303.9%
> 
>   This is a swap-intensive synthetic workload, so it mostly demonstrates
>   the reduction in swap-fault and page-table overhead from preserving
>   PMD mappings.  I don't want to use sythetic workloads to show benefits
>   of the series. IMHO, the main advantage comes from long-running
>   workloads I expect the bigger win to come from fewer TLB misses,
>   less khugepaged work, and less kernel churn from larger folios, although
>   I have not found a benchmark that captures that well.  PMD swap entries
>   also move us closer to eliminating page-table deposits for anonymous THPs,
>   which would provide memory savings.
> 
> Sashiko reviews on intermediate patches:
> 
>   Because the swap-out producer is the last functional patch, the
>   consumer code added by the patches before it is unreachable at the
>   point it is introduced.  Every previous sashiko review has reported
>   that code as broken on the basis of a state it cannot yet be in; the
>   series is ordered this way deliberately.  See [2].
> 
> Notes on zswap:
> 
>   Native PMD-order zswap load/store is intentionally left for a follow-up.
>   Alexandre Ghiti is currently working on this.
>   This series can still preserve PMD swap entries while zswap is enabled:
>   zswap stores the THP as order-0 entries, and PMD-order swap-in
>   consumers split any range that has zswap entries before reading it.  If
>   zswap has written the whole range back to disk, or the swap cache still
>   contains one PMD-sized folio, PMD-level handling can proceed.
> 
> Testing:
> 
>   The 17 pmd_swap selftests pass on x86_64 with zswap both disabled and
>   enabled.  PMD_SWAP_DEVICE was the sole active swap device, so the
>   swapoff test ran in both configurations.  Note that with zswap enabled
>   the range may legitimately come back through the PTE fallback, so those
>   runs skip the PMD-restoration assertions and say so in the log; the
>   zswap-disabled run is the one that proves PMD restoration.
> 
>   hmm-tests was run with CONFIG_DEBUG_VM=y and panic_on_warn=1, both on
>   this series and on the base commit: identical results either way
>   (pass:35 fail:3 skip:40).  The three failures are O_TMPFILE on the
>   test VM's 9p /tmp, not kernel behaviour, and the THP paths
>   (migrate_anon_huge_*, migrate_partial_unmap_fault,
>   benchmark_thp_migration) pass.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree/case-swap-w-seq
> [2] https://lore.kernel.org/all/282ef982-3e48-4283-9155-73a33fc1c4e8@linux.dev/
> 
> v7 -> v8: https://lore.kernel.org/all/20260914122950.3283997-1-usama.arif@linux.dev/
> - Cover letter: add the case-swap-w-seq performance results. (Andrew Morton)
> - Patches 2-8: reword the opening paragraph as "Prepare for ..." instead of
>   referring to a later patch. (David Hildenbrand)
> - Patch 4 (powerpc): move the PMD exclusive helpers next to the soft-dirty
>   PMD helpers and express them the same way, as pte_pmd()/pmd_pte()
>   wrappers over the PTE helpers. (David Hildenbrand)
> - Patch 6 (s390): drop the comment above the helpers, keep the explanation
>   in the RSTE swap layout above __SWP_OFFSET_MASK_RSTE, and move the
>   helpers into the existing CONFIG_ARCH_HAS_PMD_SOFTLEAVES block above
>   pmd_swp_soft_dirty(). (David Hildenbrand)
> - Patch 7 (x86): add static_assert(_PAGE_SWP_EXCLUSIVE != _PAGE_PSE) so a
>   32-bit build that ever selects ARCH_HAS_PMD_SOFTLEAVES fails to compile
>   rather than producing pmd_present() swap entries. (Kiryl Shutsemau)
> - Patch 10: rename the flag to to_migration_entries, use two-tab
>   continuation indentation, reword the split comment, turn the comment on
>   split_pmd_to_migration_entries() into kerneldoc, and fold the
>   try_to_migrate_one() call onto one line.  Also drop that helper's
>   pmd_trans_huge() || pmd_is_valid_softleaf() test, which was both too loose
>   and silently skipped the split, in favour of a VM_WARN_ON_ONCE() at the top
>   of __split_huge_pmd_locked() asserting that to_migration_entries implies a
>   present or device-private PMD. (David Hildenbrand)
> - Patch 11: drop the VM_WARN_ON_ONCE()/force and its comment from the swap
>   decode arm - 10/29 now asserts the to_migration_entries contract at the top
>   of __split_huge_pmd_locked() instead - and build the replacement PTEs by
>   advancing pte_next_swp_offset() rather than rebuilding each entry, which
>   hoists the soft-dirty/uffd/exclusive tests out of the loop. (David
>   Hildenbrand).
> - Patch 12 (new): split the swap-side changes out of the fork patch, so the
>   swap-entry range duplication gets its own patch for the swap maintainers.
>   Keeps the single-slot names as inline wrappers so existing callers are
>   untouched. (David Hildenbrand)
> - Patch 13 (fork): report a failed swap dup as -EIO and let copy_pmd_range()
>   own the GFP_KERNEL retry, as the PTE path does, dropping the open-coded
>   retry loop; move the mm counter update into each entry-type arm. (David
>   Hildenbrand)
> - Patch 16 (smaps): smaps_account_swap() takes nr_pages rather than a byte
>   size, and the local is called swapcount. (David Hildenbrand)
> - No other functional change.  All twelve sashiko findings on v7 were
>   analysed and none are defects of this series.
> 
> v6 -> v7: https://lore.kernel.org/all/20260818131202.494754-1-usama.arif@linux.dev/
> - Rebase onto akpm/mm-new at baa8de2f3448 and adapt to the new
>   get_swap_device() contract and linear_anon_page_index().  The series grows
>   from 12 to 29 patches.
> - Patch 1: code unchanged; reword the commit message and collect review tags.
> - Patches 2-9: split the six architecture helpers from generic detection and
>   add debug_vm_pgtable coverage.  Use the s390 RSTE exclusive bit, make the
>   x86 helper return bool, clear all PMD swap overlay bits before softleaf
>   decoding, and add the architecture maintainers to Cc.
> - Patches 10-11: add a preparatory no-functional-change cleanup of the
>   migration-splitting API and keep the PMD swap split separate.
> - Patch 12: reject a multi-slot duplication range that crosses a swap-cluster
>   boundary.
> - Patch 13: drop the zswap_load() change, now upstream as 1a904e0d3c43, and
>   check for zswap after swap-cache insertion while all slots are pinned.
> - Patch 14: scan every subpage for hardware poison, discard a failed or newly
>   allocated unmapped PMD-sized folio before PTE fallback, and recheck the PMD
>   before splitting it.
> - Patches 15-23: split the non-present PMD walkers by subsystem.  Add the
>   guard-advice patch so MADV_GUARD_INSTALL/REMOVE leaves PMD swap entries
>   whole; the other split patches preserve v6 behaviour.
> - Patch 24: honour the current THP policy, discard a failed PMD-sized folio,
>   and recheck the PMD before PTE fallback.
> - Patch 25: do not split after cached-folio revalidation loses a race; retry
>   so a restored present THP remains whole.
> - Patches 26-27: separate the independent PTE-batching hardware-poison fix,
>   scan subpages directly, and discard failed or never-mapped PMD-sized folios
>   before PTE retry instead of making the whole range fail with SIGBUS.
> - Patch 28: keep the normal swap-out path unchanged, but make failed producer
>   preconditions warn and return -EBUSY rather than BUG or return -EINVAL.
> - Patch 29: grow the selftests from 16 to 17, adding
>   swapin_sync/cache-residency coverage and more robust feature, fallback,
>   privilege, data-integrity, and swap-device-priority handling.
> 
> v5 -> v6: https://lore.kernel.org/all/20260722152043.2273289-1-usama.arif@linux.dev/
> - Add patch 1 to rename pmd_to_softleaf_folio() to
>   pmd_softleaf_to_folio().  No functional change. (Dev Jain)
> - Patch 2: warn when pmd_softleaf_to_folio() is given a non-PFN
>   softleaf rather than silently returning NULL. (Dev Jain)
> - Patch 4: bound the fork extend-table fallback to one retry, re-read
>   the PMD under its lock, normalize unrecoverable copy_huge_pmd() errors
>   to -ENOMEM so copy_pmd_range() cannot clear and leak the source swap
>   PMD, and drop a redundant thp_migration_supported() gate.
> - Patch 5: check multi-page swap-cache insertions for zswap-backed slots
>   in __swap_cache_add_check() under the cluster lock, both before
>   allocation and before insertion, and reject mixed zswap/disk state
>   with -EBUSY. (Yosry Ahmed, Nhat Pham)
> - Patch 6: on a failed non-uptodate PMD-order read, remove the large
>   folio from swap cache before splitting so order-0
>   fallback retries individual slots rather than poisoning the whole
>   2 MiB range; retain hardware-poisoned folios for per-subpage handling.
> - Patch 7: make HMM snapshot mode report a PMD swap entry as non-resident,
>   matching PTE swap entries, rather than HMM_PFN_ERROR.  Drop redundant
>   thp_migration_supported() gates and simplify non-present PMD handling.
> - Patch 8: factor PMD MADV_WILLNEED prefetch into
>   swapin_pmd_swap_entry(), split and retry through PTEs after any
>   PMD-order swapin failure, and replace the racy folio_test_locked()
>   plus folio_lock() sequence with folio_trylock().
> - Patch 9: guard PMD-swap UFFDIO_MOVE code with CONFIG_THP_SWAP, clarify
>   RWP marker propagation, and reject a PMD swap entry at the destination
>   with -EEXIST so UFFDIO_MOVE cannot loop forever on -EAGAIN.
> - Patch 10: honor current THP/VMA policy before PMD-order swap-in, recheck
>   that the PMD is still the original swap entry before splitting for PTE
>   fallback, and provide the CONFIG_TRANSPARENT_HUGEPAGE wp_huge_pmd()
>   declaration/stub needed by THP=n builds.
> - Patch 11: make an invalid set_pmd_swap_entry() walk context warn and
>   return -EINVAL instead of falsely reporting success and corrupting the
>   MM_ANONPAGES/MM_SWAPENTS accounting, and add an exact PMD-size folio
>   precondition check. (Luiz Capitulino)
> - Patch 12: use /proc/swaps for prerequisite detection, check
>   MADV_HUGEPAGE, and distinguish an environment that cannot allocate a
>   PMD THP (SKIP) from a swap-out validation failure (FAIL).  Add
>   partial-mprotect and partial-munmap split coverage.  Strengthen
>   munmap/MADV_FREE VmSwap accounting, pagemap slot-offset checks, and
>   mprotect/mremap swapped-state checks; force mremap to move, check
>   munmap()'s return, and mark the UFFDIO_MOVE destination MADV_HUGEPAGE
>   before asserting PMD restoration.  Move common setup and cleanup into
>   one fixture, merge the swapoff fixture, remove the redundant cycles
>   test, and make the data pattern differ between base pages so the split
>   tests can detect incorrect slot ordering.  Order fork-COW so the parent
>   writes while the child still holds the untouched shared swap entry.
>   (Luiz Capitulino)
> - Clarify commit messages throughout.  Retain TTU_SPLIT_HUGE_PMD after
>   prototyping its removal: removing it here requires an extra rmap walk
>   and broadens the series beyond PMD swap entries. (Matthew Wilcox)
> - Rebase onto akpm/mm-new from 15 August (4b65683fd25f).
> 
> v4 -> v5: https://lore.kernel.org/all/20260713133613.2707815-1-usama.arif@linux.dev/
> - Commit message improvements for almost all patches (Yosry for zswap patch)
> - Patch 1: make pmd_to_softleaf_folio() reject softleaf entries that do
>   not encode a PFN, so a PMD swap offset is never interpreted as one.
>   PMD swap entries remain valid softleaf entries for classification.
>   (sashiko)
> - Patch 2: use the existing pmd_swp_uffd() helper and force freeze=false
>   for PMD swap entries, which have no struct page for the migration-entry
>   freeze path. (sashiko)
> - Patch 3: document that the caller's page-table or swap-cache reference
>   pins every source slot while a partial PMD-sized duplication is rolled
>   back.  Keep the pre-existing PTE fork retry behavior outside this
>   series. (sashiko)
> - Patch 5: split to the PTE path rather than mapping a PMD-sized folio
>   containing a hardware-poisoned subpage, and restore PAGE_NONE when
>   swapoff restores a UFFD marker in an RWP VMA. (sashiko)
> - Patch 6: account SwapPss for a PMD swap entry one slot at a time because
>   the slots can have different swap reference counts.
> - Patch 7: if PMD-order MADV_WILLNEED encounters newly populated per-page
>   zswap state, revalidate and remove the failed clean PMD-sized cache
>   folio before retrying through PTEs.
> - Patch 8: mark a moved PMD swap entry for UFFD when the UFFDIO_MOVE
>   destination VMA is RWP-registered. (sashiko)
> - Patch 9: restore PAGE_NONE for UFFD RWP swap-in, preserve the original
>   write-fault state through swap-slot release and COW handling, remove
>   the unnecessary LRU drain, and prevent PTE batching from mapping a
>   poisoned subpage. (sashiko)
> - Patch 10: add and document thp_swpout_pmd, which counts PMD mappings
>   replaced by PMD-level swap entries rather than swapped folios.
> - Patch 11: register pmd_swap with the default mm selftest runner, preserve
>   errno across UFFDIO_MOVE cleanup, check swapoff residency before the
>   first memory access, add a parent-side write and verification to the
>   fork+COW test, and add RWP regression coverage for swap-in, UFFDIO_MOVE,
>   and swapoff. (sashiko)
> - Keep do_huge_pmd_swap_page() in patch 9.  Patches 6 and 7 only add
>   consumers; patch 10 remains the first producer, so no PMD swap entry
>   can reach those paths before the fault handler is present. (sashiko)
> - Rebase onto latest akpm/mm-new from 22 July (5e0603ba185a)
> 
> v3 -> v4: https://lore.kernel.org/all/20260703173903.3789516-1-usama.arif@linux.dev/
> - Patch 1: guard the new arch-specific pmd_swp_mkexclusive /
>   pmd_swp_exclusive / pmd_swp_clear_exclusive helpers on arm64,
>   loongarch, powerpc, riscv, s390, and x86 with
>   CONFIG_ARCH_HAS_PMD_SOFTLEAVES, matching the pattern already
>   used for pmd_swp_soft_dirty.  Also fixes the redefinition-vs-
>   generic-fallback build errors kernel test robot reported on
>   i386-allnoconfig-bpf and riscv-allnoconfig-bpf, and rewraps
>   the patch 1 commit message paragraphs to ~75 columns.
>   (sashiko, kernel test robot, Usama Arif)
> - Patch 2: switch the trailing folio_remove_rmap_pmd() gate in
>   __split_huge_pmd_locked() from *pmd to old_pmd, old_pmd retains
>   the original present-or-non-present classification for every
>   branch above. (sashiko)
> - Patch 3: teach swap_retry_table_alloc() (and the underlying
>   swap_extend_table_alloc()) to accept an nr parameter and scan
>   every slot in [ci_off, ci_off + nr) before committing an
>   extend-table allocation.  (sashiko)
> - Patch 4: rename zswap_range_has_entry() to zswap_is_present() so
>   the same helper serves both single-slot (nr=1) and range queries,
>   and switch the implementation from XA_STATE + xas_find() to
>   xa_find(), which handles RCU locking and internal-retry markers
>   itself.  Rename the callers in patches 5, 7, 9. (Yosry)
> - Patch 9: refuse to map a swap-cache folio in do_huge_pmd_swap_page()
>   when folio_contain_hwpoisoned_page() reports a poisoned subpage;
>   split the PMD swap entry so do_swap_page() can return
>   VM_FAULT_HWPOISON per subpage instead of the PMD handler mapping
>   the corrupted memory as one THP.  Mirrors the PageHWPoison check
>   the PTE swap-in path already performs. (sashiko)
> - Patch 9: note explicitly in the commit message that PMD-order
>   swap-in deliberately skips the order-0 readahead paths, order-0
>   readahead would populate per-page swap-cache state and force the
>   PMD swap entry to split before the fault could finish. (Kairui)
> - Patch 10: move mm_prepare_for_swap_entries() into
>   set_pmd_swap_entry() between folio_dup_swap() and set_pmd_at()
>   so this mm is on init_mm.mmlist before any swap PMD referencing
>   slots with a non-zero swap_map becomes visible.  Matches the PTE
>   swap-out ordering. (sashiko)
> - rebase onto latest akpm/mm-new (61cccb8363fcc282d4ae0555b8739dd227f5ad0b)
> 
> 
> v2 -> v3: https://lore.kernel.org/all/20260602142537.198755-1-usama.arif@linux.dev/
> - Clarified the PMD swap entry rule: it is a compact encoding for
>   HPAGE_PMD_NR swap slots, not a guarantee that swap cache always has
>   one PMD-sized folio. (Lance Yang)
> - Swapoff, fault, MADV_WILLNEED, and UFFDIO_MOVE now classify the
>   whole PMD swap-cache range and split/retry through the PTE path for
>   split/per-slot cache state. (Lance Yang)
> - mincore handles PMD swap entries without assuming one lookup covers
>   a split swap-cache range. (Lance Yang)
> - UFFDIO_MOVE rechecks all HPAGE_PMD_NR slots before moving an empty
>   PMD swap-cache range, avoiding stale rmap metadata for per-slot
>   cached folios.
> - Added a standalone zswap prerequisite patch from Alexandre that
>   distinguishes all-on-disk large-folio ranges from ranges with
>   per-page zswap entries.
> - Replaced the global zswap-ever-enabled policy with per-range zswap
>   checks: PMD swap entries can still be installed while zswap is
>   enabled, and PMD-order swap-in consumers split when the range has
>   per-page zswap state.
> - Added a mincore selftest and updated MADV_WILLNEED coverage so the
>   test checks that the PMD swap entry remains in place until first
>   touch.  Total pmd_swap coverage is now 14 tests.
> 
> 
> v1 -> v2: https://lore.kernel.org/all/20260427100553.2754667-1-usama.arif@linux.dev/
> - Patch 1: convert two additional softleaf_to_pmd() callers that
>   landed in mm-unstable since v1 (mm/debug_vm_pgtable.c,
>   mm/migrate_device.c) (Dev)
> - Patch 2: rename helper ensure_on_mmlist() to
>   mm_prepare_for_swap_entries() to better describe its purpose
>   (David)
> - Patch 3: drop VM_WARN_ON_ONCE(!pmd_is_migration_entry) as
>   Dev posted it as a separate patch.
> - Patch 5 (new): move softleaf_to_folio() inside the device-private
>   branch in migrate_vma_collect_pmd(); same class of fix as patch 4
>   but for the migrate-device PMD walker.
> - Patch 6 (new): rename CONFIG_ARCH_ENABLE_THP_MIGRATION to
>   CONFIG_ARCH_HAS_PMD_SOFTLEAVES so the gate that now drives
>   swap-entry support too is named for what it actually controls
>   (PMD softleaf entries), not just migration. (Dev)
> - Patch 7: add the missing pmd_swp_exclusive / mkexclusive /
>   clear_exclusive helpers for powerpc.
> - Patches 10 and 14: use upstream swapin_sync() (bundles
>   swap_cache_alloc_folio + swap_read_folio + the -EEXIST race
>   retry) instead of the bespoke swapin_alloc_pmd_folio() helper
>   from v1; do_swap_page and shmem_swapin_folio use the same
>   helper (Kairui)
> - Patch 10: construct a stack vm_fault for the swapoff swap-in so
>   the allocator can resolve a mempolicy, mirroring how the PTE
>   swapoff path (unuse_pte_range) already does it.
> - Patch 11: extend coverage to check_pmd_state() in khugepaged so a
>   swapped-out PMD-mapped THP is treated as SCAN_PMD_MAPPED (matches
>   the existing migration-entry handling). Route PMD swap entries in the
>   pmd_trans_huge_lock() branch of mincore_pte_range() through
>   mincore_pmd_swap() so a swapped-out PMD-mapped THP isn't reported as
>   resident.
> - Patch 12 (new): handle PMD swap entries in MADV_WILLNEED via
>   swapin_sync(BIT(HPAGE_PMD_ORDER)); a naive order-0 read-ahead
>   would force the subsequent fault to split.
> - Patch 13: refuse UFFDIO_MOVE with -EBUSY if the swap-cache folio
>   was split between swap-out and the move, matching
>   move_pages_pte()'s rejection of large folios; otherwise only one
>   of the 512 anon-rmaps would be re-anchored to dst_vma.
> - Patch 16: alloc_fill_swap_thp() now uses the existing
>   mmap_pmd_aligned() helper so tests don't flake/skip based on VA
>   placement; new MADV_WILLNEED test that watches the PMD-order
>   mTHP swpin counter; swapoff test restructured to use the
>   kselftest_harness ASSERT cleanup blocks (no double swapoff, no
>   verify-after-munmap).
> - Collected Acks and Reviews
> 
> Usama Arif (30):
>   mm: rename pmd_to_softleaf_folio() to pmd_softleaf_to_folio()
>   arm64: mm: add PMD swap-exclusive helpers
>   loongarch: mm: add PMD swap-exclusive helpers
>   powerpc: mm: add PMD swap-exclusive helpers
>   riscv: mm: add PMD swap-exclusive helpers
>   s390: mm: add PMD swap-exclusive helpers
>   x86: mm: add PMD swap-exclusive helpers
>   mm: recognize PMD swap entries in the softleaf layer
>   mm/debug_vm_pgtable: test PMD swap-exclusive helpers
>   mm: make PMD migration-entry splitting explicit
>   mm: split PMD swap entries into PTE swap entries
>   mm/swap: allow duplicating a range of swap entries
>   mm: handle PMD swap entries in fork path
>   mm: zswap: reject high-order swap cache allocations backed by zswap
>   mm: swap in PMD swap entries as whole THPs during swapoff
>   fs/proc: account PMD swap entries in smaps
>   mm: handle soft-dirty and uffd-wp on PMD swap entries
>   mm/hmm: fault PMD swap entries on demand
>   mm: free PMD swap entries in zap_huge_pmd()
>   mm/madvise: free PMD swap entries with MADV_FREE
>   mm/madvise: skip PMD swap entries for MADV_COLD and MADV_PAGEOUT
>   mm/madvise: keep PMD swap entries whole for MADV_GUARD_INSTALL/REMOVE
>   mm/mincore: report PMD swap-cache residency
>   mm/khugepaged: treat PMD swap entries as mapped THPs
>   mm: handle PMD swap entries in MADV_WILLNEED
>   mm: handle PMD swap entries in UFFDIO_MOVE
>   mm: don't PTE-batch a swap-in over a hardware-poisoned subpage
>   mm: handle PMD swap entry faults on swap-in
>   mm: install PMD swap entries on swap-out
>   selftests/mm: add PMD swap entry tests
> 
>  Documentation/admin-guide/mm/transhuge.rst   |   5 +
>  arch/arm64/include/asm/pgtable.h             |   6 +
>  arch/loongarch/include/asm/pgtable.h         |  19 +
>  arch/powerpc/include/asm/book3s/64/pgtable.h |   6 +
>  arch/riscv/include/asm/pgtable.h             |  15 +
>  arch/s390/include/asm/pgtable.h              |  20 +-
>  arch/x86/include/asm/pgtable.h               |  20 +
>  fs/proc/task_mmu.c                           |  45 +-
>  include/linux/huge_mm.h                      |  40 +-
>  include/linux/leafops.h                      |  44 +-
>  include/linux/pgtable.h                      |  17 +
>  include/linux/swap.h                         |  12 +-
>  include/linux/vm_event_item.h                |   1 +
>  include/linux/zswap.h                        |   6 +
>  mm/debug_vm_pgtable.c                        |  40 +
>  mm/hmm.c                                     |  11 +-
>  mm/huge_memory.c                             | 714 +++++++++++--
>  mm/internal.h                                |  58 ++
>  mm/khugepaged.c                              |   6 +
>  mm/madvise.c                                 | 169 +++-
>  mm/memory.c                                  |  65 +-
>  mm/migrate_device.c                          |   7 +-
>  mm/mincore.c                                 |  47 +-
>  mm/mprotect.c                                |   2 +-
>  mm/rmap.c                                    |  27 +-
>  mm/swap.h                                    |  30 +-
>  mm/swap_state.c                              |  83 +-
>  mm/swapfile.c                                | 245 ++++-
>  mm/userfaultfd.c                             |  14 +
>  mm/vmscan.c                                  |   9 +-
>  mm/vmstat.c                                  |   1 +
>  mm/zswap.c                                   |  12 +-
>  tools/testing/selftests/mm/Makefile          |   2 +
>  tools/testing/selftests/mm/ksft_pmd_swap.sh  |   4 +
>  tools/testing/selftests/mm/pmd_swap.c        | 989 +++++++++++++++++++
>  tools/testing/selftests/mm/run_vmtests.sh    |   4 +
>  tools/testing/selftests/mm/vm_util.c         |  24 +
>  tools/testing/selftests/mm/vm_util.h         |   2 +
>  38 files changed, 2630 insertions(+), 191 deletions(-)
>  create mode 100755 tools/testing/selftests/mm/ksft_pmd_swap.sh
>  create mode 100644 tools/testing/selftests/mm/pmd_swap.c
> 

I was hoping that we could get this into the next merge window, but as we are
approach rc6 and I didn't even manage to review all patches (shame on me), I
assume this would be a quite fit.

So I assume this series is one of the things that we'll try to get in shape over
the next merge window to queue it early after rc1.

-- 
Cheers,

David

