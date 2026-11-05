Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9272F606A32F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fMuRMBBc
Received: by kanga.kvack.org (Postfix)
	id 87E7A6B05B2; Wed,  4 Nov 2026 23:14:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E7A6B05B9; Wed,  4 Nov 2026 23:14:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 745206B05BA; Wed,  4 Nov 2026 23:14:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB49C6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:14:11 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61CCEC0877
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:14:11 +0000 (UTC)
X-FDA: 85399747902.01.865500B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id A8C1F80004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:14:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fMuRMBBc;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793852049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=82C0pMCYwMzWMRl19g9H4sTrB8Sq3TP728Ks6dqFnPk=;
	b=Sde364zUiggito5MG5YvwUe5XKR5ekG78tHitRAgOlTfjqEM0qAA1FM9anuJkvbdQ2hVpT
	mi6JwmR6MAaohG2L0ATwJyFqVoqzUtUpURYPrl8PJp0wrApjEYPk5bHmGLyHrhLXqIent/
	IkBAMpBgbaGuQ5bq2O2ZAArMrE6S9Lk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793852049;
	b=mvqnzDtqGatqcjDSc2iUUzLgh2SZbAuijua7Tz6iKz7DYke/0m9cJDlfr44hlzrwR+sRb0
	uUxdBO4VyvV/T8doE+aC83ONnpmT9suXlwGhyhvcZcNM67pqW80Jao6zVg3C09QQ6D1Zoz
	Hre8wf3oRrwa5knAHYe+zTcZ6f042pE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fMuRMBBc;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 124BD601DE;
	Thu,  5 Nov 2026 04:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9221F1F000C1;
	Thu,  5 Nov 2026 04:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793852048;
	bh=82C0pMCYwMzWMRl19g9H4sTrB8Sq3TP728Ks6dqFnPk=;
	h=Date:From:To:Cc:Subject;
	b=fMuRMBBcxjfVKX72ikgs6rV4/6aNZ4lGc7ylD5catLudQ3gRPolVBNa1TYvP8Kh5p
	 xmgALlpu5IepSZJmD52pmSWeNujLKlM38z42YeFpDDfl9ML2kORZdw6VX+agi+tco/
	 01G5Dhderx4jxQoXw1QrJmcB653YTZDsg0NpaslQ=
Date: Wed, 4 Nov 2026 20:14:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org, David Hildenbrand <david@kernel.org>
Subject: [GIT PULL] MM hotfixes for 7.4-rc2
Message-Id: <20261104201408.90579e9988fe725faf3ad859@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: z8pxzfrgd4kpnwwwgb151k8emefpog9c
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A8C1F80004
X-Rspam-User: 
X-HE-Tag: 1793852049-816174
X-HE-Meta: U2FsdGVkX18OofDS79EMau0UNU4awpIQxxJDeqMq/NwglpJkH3MZ3ogijat3J4K+r/3g/KZ6GI2znlGuI+9VcCBydkS+2/aDXYvtF55YrqrHpUHTsFQXf8KlLL+9G82Mz1I0RW9JHSYX+PEwIApGFRbauUM3Wzjhn+q8dJfJvYSc+T6+0ci/DGDi0mvpiVZ/mCVcg2HpaUHYlE4nOM3pB4Io+T3JaxlqqbpHJDQmeMs4GRfE4PqXeVYtwIrI8M2XIILLmYInvnv7WZAXYR9CjkY2qs8B6wtW9ZJfDteqbA1/dslUUqnls+G5EBBSL85zi0DZYJe7Mt7nk/M2Fw/Ic8EM2XyogCm/pg5bSCbt6X0+hjvkQM8FlWk6oDsQWL1LtaUA/6AFk82qSZtlZzjajtsBJBuybQQKIUj4YJgtr3uspXt3ZQFIAePDftpim1hZ9LhHB3a0Rpfkp+VJ4vOMWAPGoM3OuJfXc7jyp0Okhe5dm/YGlQDdZjpyvmSoCd1gxGvQE1D0MU4P7SHiMteeV4LRN4+wduCxfcILG1mvGItF/TJwprl/A8XdpTapraRJCmuoqECGV58zIuSGexn4Rl/tBePRObz6mc2RntyjggpOX83tGsO29W7vPo2GiND508bfeJEE+56UCZ8KQeCiZvQKF87zpydQpOxnn0lNY+y+ifxxyserjDvNZhFmwTLEq5ADcG06FputSqwvn66QoC18Oz8wH5CkMZOhfORJIP5gi26v36db5pDt2Ms0M/pSeCePldUNPke8/T1sCi7HYhwZOwLH2aaGAX5ovsIoc1d1psElwlsSyA0jlF2CHPQ1oLVug0w176paBX4TwEW4j41lopPttgxZ/w4DjR2sATu8LclbM4Rzkt8jNvBrGPuEuMnZU1P2huPyEv8F2oWngtA6m84xcWbFeTQH9w3lCsp+yOpW4/w7VR8Mw138iddSjmv5MbgmQZUWzHyo59t
 a4h2QT0W
 YK3CbyLnT1APk2MjL36n9ntAS4oUlFr9gy2588qjM+agSnQzRc9Y5XbBD2kE7/vvjGJA/wTmyXOwJmTVsKsLKQLGFC+LXQKbxxcjTgzZOSetry6lrHgKcmouhHQCSx6TzJxV8mdq/S6stU/RSkjCeU3GAyjGTyWF3++3WtN2fUcg2zCOgyK1x/PXHRizdAroyHxlO1mo5SsM3epVjZNzQlrNj1hdJCJ6zuvq2zLKrcWSRoWelYhHqiymra/rSRZ0jhm8Jy3jN8w9ZfXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4:

  Linux 7.4-rc1 (2026-11-01 13:26:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-11-04-20-02

for you to fetch changes up to 19eab4cf787c917bfb7615460933e4ae894af65b:

  MAINTAINERS: move SLAB ALLOCATOR under MEMORY MANAGEMENT (2026-11-02 18:14:50 -0800)

----------------------------------------------------------------
mm.git review status for linus..mm-hotfixes-stable

Everything:

Total patches:       43
Fixes: tags:         42
cc:stable patches:   30
Reviews/patch:       3.67
Reviewed rate:       88%

Excluding DAMON:

Total patches:       40
Fixes: tags:         39
cc:stable patches:   27
Reviews/patch:       3.95
Reviewed rate:       95%

Summary of patch series in this merge:

- "mm: avoid losing atomic VMA flags" (Lorenzo Stoakes):

  Preserve guard-page and soft-dirty state across VMA changes. Prevent
  fork and THP collapse from losing guard markers, and keep changes
  visible to applications which track modified memory.

- "MAINTAINERS: MM updates" (David Hildenbrand):

  Start routing more MM components through mm/core.git and add Zi Yan
  as a THP co-maintainer. Update component coverage and integration
  branches as part of the transition to separate MM component trees.

- "mm/hugetlb: fix mremap bugs" (Li Zhe):

  Fix hugetlb mremap deadlocks and truncated move lengths. Prevent
  userfaultfd poison markers from affecting other processes through
  shared hugetlb page tables.

- "MAINTAINERS updates for page and slab allocators" (Vlastimil Babka):

  Add Johannes Weiner as a page allocator co-maintainer and update
  page and slab allocator entries for their component trees and
  integration through mm/linux.

- "mm/damon: fix three race bugs in sysfs and core" (SJ Park):

  Serialize DAMOS tuning updates and stop monitoring contexts from
  sharing mutable state. Avoid interference between concurrent DAMON
  instances and incorrect auto-tuning.

- "mm: page_alloc: fix reserve access for non-blocking requests"
  (Johannes Weiner):

  Stop ordinary non-blocking allocations from consuming reserves or
  bypassing watermarks. Avoid severe allocation stalls under memory
  pressure and preserve reserves for requests entitled to use them.

- "mm/cma: accept memory of CMA areas reserved with memblock_reserve()"
  (Mike Rapoport):

  Accept memory in fixed-address and multi-range CMA reservations.
  Prevent fatal accesses to these pages in TDX and SEV-SNP guests.

Summary of the 20 singletons in this merge:

Several fixes address crashes and unsafe memory access. Failed THP
collapse now flushes stale translations before releasing pages which
another collapse can free. A truncation race with MADV_DONTNEED could
remove still-mapped shmem pages and hit a kernel BUG. Large-folio
page-table scans no longer wrap addresses and crash near address-space
boundaries. Hugetlb vmemmap optimization no longer causes write faults
from racing reference-count operations. Memory-cgroup teardown is
also protected against reclaim work accessing released state.

KSM now preserves userfaultfd protection during merging and unmerging,
and retains soft-dirty information needed by incremental memory
dumpers. Reads of /proc/PID/maps and related files no longer omit
continuously mapped ranges during concurrent VMA changes. There are
also fixes for expanding mixed mappings with mremap() and querying
NUMA placement with tagged addresses. Swapoff checks for signals while
processing large address spaces and shmem files, so it can be
interrupted without holding up suspend until the whole object is read.

Costly allocations with cheap smaller-order fallbacks avoid direct
reclaim and compaction. Reported arm64 PostgreSQL tests improved from
58,602 to 157,246 transactions per second with defrag_mode disabled;
this addresses a buffered-write regression under fragmentation.
Background reclaim can recover on the highest-numbered memory node
after it has given up, and 32-bit writeback threshold calculations
no longer overflow and assign incorrect dirty-memory limits.

----------------------------------------------------------------
Baolin Wang (1):
      mm: memory: fix truncation removing mapped folios

Chris Down (1):
      mm: make swapoff interruptible when unusing mms/shmem

Danish Khateeb (1):
      selftests/mm: merge: keep the far mremap() targets in the carveout

David Hildenbrand (Arm) (11):
      mm: fix address wraparound when scanning large folio PTEs
      mm/hugetlb: disable PMD sharing for UFFD missing mode
      mm/vma: write lock source VMA before duplicating it in __split_vma()
      mm/madvise: preserve VMA_SOFTDIRTY_BIT when changing anonymous names
      MAINTAINERS: mention for-next branch in MEMORY MANAGEMENT - MEMORY MAP
      MAINTAINERS: TMPFS (SHMEM FILESYSTEM) updates
      MAINTAINERS: add Zi Yan as co-maintainer for MEMORY MANAGEMENT - THP
      MAINTAINERS: sort entries in MM sections
      MAINTAINERS: add missing files to MM component sections
      MAINTAINERS: rename and move MEMORY HOT(UN)PLUG
      MAINTAINERS: route more MM changes through mm/core.git

Gregory Price (Meta) (1):
      mm/page_alloc: let the highest memory node recover from hopeless state

Hengyu Liang (1):
      fs/proc/task_mmu: return -ENOTTY for unknown pagemap ioctls

Hungyu Lin (2):
      mm/page-writeback: avoid 32-bit overflow in dirty threshold shares
      mm/migrate: untag addresses when querying page nodes

Johannes Weiner (2):
      mm: page_alloc: do not give all non-blocking requests reserve access
      mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES

Kiryl Shutsemau (Meta) (1):
      mm/hugetlb_vmemmap: map the shared tail page writable

Kyle Zeng (1):
      mm/khugepaged: flush deferred unmaps before dropping a failed folio

Lance Yang (1):
      mm/ksm: fix userfaultfd protection during merge and unmerge

Li Zhe (2):
      mm/hugetlb: fix mremap move length truncation
      mm/hugetlb: fix mremap deadlock when PMD sharing is possible

Lorenzo Stoakes (ARM) (5):
      mm/vma: fix expansion of VMA_MIXEDMAP_BIT VMAs
      mm: do not unintentionally overwrite atomic VMA flags
      mm/vma: avoid losing atomic VMA flags when setting sticky VMA flags
      mm/vma: update VMA iterator state on error in new VMA merge
      fs/proc/task_mmu: fix missed VMAs when reading /proc/PID/maps and friends

Mike Rapoport (Microsoft) (2):
      mm/cma: accept memory of multi-range CMA areas
      mm/cma: accept memory of CMA areas reserved at a fixed address

SJ Park (3):
      mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_metric_store()
      mm/damon/core: move static variable last_nr_regions to damon_ctx
      mm/damon/core: move static variable rotation to damon_ctx

Salvatore Dipietro (1):
      mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations

Samarth Narang (1):
      mm/ksm: keep soft-dirty when merging a page

T.J. Mercier (1):
      mm: memcontrol: fix NULL pointer deref and UAF from high_work_func() on dying memcg

Vlastimil Babka (SUSE) (2):
      MAINTAINERS: add Johannes as the page allocator co-maintainer
      MAINTAINERS: move SLAB ALLOCATOR under MEMORY MANAGEMENT

Yafang Shao (1):
      mm/migrate: snapshot the source nid before the misplaced migration

Zenghui Yu (Huawei) (2):
      mm/page_alloc: mark pages freed by __free_pages_core() as not tagged
      selftests/mm: fix khugepaged_race build with older glibc

 Documentation/mm/vmemmap_dedup.rst           |  15 +-
 MAINTAINERS                                  | 224 ++++++++++++++++-----------
 fs/proc/internal.h                           |   1 +
 fs/proc/task_mmu.c                           |  15 +-
 include/linux/damon.h                        |  10 ++
 include/linux/hugetlb.h                      |  15 +-
 include/linux/mm.h                           | 166 ++++++++++----------
 include/linux/mmap_lock.h                    |  22 ++-
 include/linux/userfaultfd_k.h                |  16 +-
 mm/cma.c                                     |   4 +
 mm/damon/core.c                              |  10 +-
 mm/damon/sysfs-schemes.c                     |   3 +
 mm/hugetlb.c                                 |  55 +++++--
 mm/hugetlb_vmemmap.c                         |   8 +-
 mm/internal.h                                |  10 +-
 mm/khugepaged.c                              |  10 +-
 mm/ksm.c                                     |  10 ++
 mm/madvise.c                                 |  10 +-
 mm/memcontrol.c                              |   5 +
 mm/memory.c                                  |  99 ++++++++----
 mm/migrate.c                                 |   5 +-
 mm/mlock.c                                   |   6 +-
 mm/mm_init.c                                 |   2 -
 mm/mmap_lock.c                               |  61 ++++++--
 mm/mprotect.c                                |   2 +-
 mm/page-writeback.c                          |   8 +-
 mm/page_alloc.c                              |  30 +++-
 mm/page_alloc.h                              |  14 +-
 mm/shmem.c                                   |   4 +
 mm/swapfile.c                                |   4 +-
 mm/vma.c                                     | 104 ++++++++-----
 mm/vma_init.c                                |   3 +
 tools/testing/selftests/mm/khugepaged_race.c |   1 +
 tools/testing/selftests/mm/merge.c           |  33 ++--
 tools/testing/vma/include/dup.h              |  83 ++++++----
 tools/testing/vma/include/stubs.h            |   2 +-
 tools/testing/vma/shared.h                   |  16 +-
 37 files changed, 682 insertions(+), 404 deletions(-)


