Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3609D606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JlJ0BJon
Received: by kanga.kvack.org (Postfix)
	id 43AC76B05C5; Thu,  5 Nov 2026 03:47:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EBF86B05C6; Thu,  5 Nov 2026 03:47:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3023C6B05C7; Thu,  5 Nov 2026 03:47:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BEA76B05C5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:47:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B66B12048D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:47:15 +0000 (UTC)
X-FDA: 85400436030.25.00110AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0AD8340008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:47:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JlJ0BJon;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793868434;
	b=Nb3DyCzIBv47nUX43pewq7RZJTgsmzFX0jHR8BbkCHDt4rZ7sIPHrT7rxZbRXmhWokjkKO
	nIXivxZDinD2msMYpP1gtK0bCW+ixEWNkbYN34/Fvg6mduStpacqReQIe5t15R7RLu3zW+
	66eeMQdiE7afEBTZDlu2z8Cb5dSRAR4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JlJ0BJon;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793868434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gIs9aYB6nzGonVZAd7ZA/+llOqexhh5JotKT03ZQpgc=;
	b=LUVq25lW4mZWRpgRN/Z3Vq7pMNTaad80jIQS8RBhoDNcguxvbSr6/N9iMODcKYSVL3qU7E
	BeY5C7Dwe42Cyvfo/zBZHMZejVUnglUeF7tgQGQ02rXfnuPC6nZAWMGSuGCzYzYD6D92FV
	7oVSv9L0cST/Vmj0pbpBc2xGMUT03sE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 85CB5602C3;
	Thu,  5 Nov 2026 08:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7791F000C1;
	Thu,  5 Nov 2026 08:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793868433;
	bh=gIs9aYB6nzGonVZAd7ZA/+llOqexhh5JotKT03ZQpgc=;
	h=From:To:Cc:Subject:Date;
	b=JlJ0BJonjo7QumWoY9HZw9k2a3FAbhDXriZUpC/EIBanmGi641oRI8J8wU27hPzXa
	 HC1Q3lpmOwzIPILEunTTWzYmzdrTdSUOlGb6wkEU2JG71454MJ4MefROxYjKAK7bPV
	 Lq78DmQbGdibPmW+COWPHpPgUR5aLeaFkA1gyKjaY4oa/AuMSE9h4Tr2dldsjBQdks
	 sm9dUSvZjmvKugJr7Rf7LRP0P4cmyQDSfYbJRovBBU6Qz1Q0AgJB53QL4dLQvvQK0v
	 QE0Jt6mX2FJJxAZ0PnGsjCQU/JYGgHGHIJWqvOVAD65EXhpoc8Mt2kTgBg4+YE/F0y
	 tib/wabIYGAnA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [GIT PULL] Core MM updates for 7.4-rc2
Date: Thu,  5 Nov 2026 09:47:02 +0100
Message-ID: <20261105084704.5703-1-david@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: abm4kb9ohd4epkaje5w4ur3ipa969qnb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0AD8340008
X-Spam-Status: No, score=-28.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793868433-33556
X-HE-Meta: U2FsdGVkX1/kebDo8SpA+tGe4dGnkx1nIoTSt6mz/LzLhnrvicJN3mi4mYeiX+houAArvWh4qJYYLB+tPziMNt2VKVgvErO+vomobHhJdyT+t1I6hiXT3prxVO1DjyPpMeAaN5ODRCfseorDe3/57snUaZarUH6Dyr59da3T6LQHj/26btShAvvD8rlD2Ne0em7+REo3a4q5zom9IPp/PZLr407tWJgX3xJQcpS6hWkW9TwKwSTgg0u+ewgPTxLMiKf75TW2d7hir101hjPeXYOKTeQ5HcSoe73SNBpzca9WPk82a8d6sE87UdKHtEnaY4f8KVM+4ZQSofcCq3aonSUlYqxdslfYBGCXpJx6JpxHNIqolStZcgt25yJ6FKERKIbq1/HF63GbWone/NyRmQM5elAE5Xczxbh0g6p/IaRRAwOcasfo2TOi57aSc7jjW2VDBbf7EmiYGzyD+zzOxoz3RaRdq2kN2j2SwUAZtOApi7iwNlsFMxCp5LILX7jpib4qi2zenmPwBdkELlqdthlhRK02obqZrSlqNR3gdZzexgM9ixkbAshhM9meJGn2hSUsRaZDYBCq6CfYFk4DG9kwqzN8KTZK4RGvH9Pc/bXG2llthbXOtx1Uih5Whpc3wEpTU9FG2ML9OcGEoSiEtmk11FnH3Cf/fV5EXAsXVR/zgFHUAsC4kUBssN+FeoYeiuhPthTJk/NDHLxb87pb7fCvc81FIAYKXjQgMkNUIKkmhTmBj/ej4EUCuZlVzqVoagykMmM0f9tEoZuoI3xuK+5bdSwJ6t3AM8J5Hp8S4LKqHefsqLygfchsGNoAYH8ob0A/rJ6vPVReICRk9B2wa0yDoOj8M4dmnZ2MXSqZmz2YZVm2JsnlnJlukGtgTmwGfh5BSUBpInHsLpbXJ7gRWuLWZUBAf6q11SLpkF69uksY/eeBq/2ep0v7eEHPlPEGsFDjD4nHHFnNoVsxpGn
 DqCN0hYq
 AFi4NdzaOUDw0WGtIVb5iKZwOPvReFiuKyMAboDHkAIQN9azM7u+iBetxLxSIsSWa3m1yx20LIQWyDj8Th+K1t/9gSzM/Qug2OCtuTwIGZLhewkYXY6vMxRZ9xcUR8ZmKsBEuT4dpLOU4Atj7SM+/SyPcdf19NJoB59majFqwLpv+0a0Urx8fX0mZyDeoqHQG5nNpCchFmI3souMgwJCkGMhOWwg3+3KJRpJVSTrVQlWwVI4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Linus,

as discussed via mail, here is a bigger set of MM fixes that we didn't
manage to have ready for -rc1. All fixes are stable-worthy; the majority
fixes nasty long-standing bugs instead of being purely hotfixes.

We have some more of these kinds of stable-worthy fixes in the pipeline,
but we'll focus on the really urgent fixes as we get closer to the release.

(leaving urgent MM fixes lurking for various weeks is not good,
but having too many changes close to the release is also not good, it's
tricky ...)

Most issues were reported by Anthropic. Others were found while reworking
proposed fixes, and of course some of the fixes were just reported and
fixed on the mailing list.

All fixes were in linux-next for several days without changes. Some commit
IDs changed recently when I had to drop some non-stable fixes, rebased to
-rc1 and picked up more trailers.

Please let me know if anything looks odd or if you would prefer things
differently going forward. I'm still learning while dealing with all the
bugs we're finding.

Cheers,

David

----------------------------------------------------------------

The following changes since commit 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4:

  Linux 7.4-rc1 (2026-11-01 13:26:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git tags/mm-core-7.4-rc2

for you to fetch changes up to 71555ae8c7572fd99158013ca2e29187c5d2508d:

  mm/gup: check folio->mapping under folio lock in memfd_pin_folios() (2026-11-03 20:20:53 +0100)

----------------------------------------------------------------
Core memory management fixes for 7.4-rc2

This includes fixes to:

 - THP (Transparent Huge Pages)
 - GUP (Get User Pages)
 - KSM (Kernel Samepage Merging)
 - USERFAULTFD
 - SHARED MEMORY (shmem/tmpfs/memfd)
 - HUGETLB
 - Core MM, PAGE CACHE and MEMORY RECLAIM

The main changes are:

 - Prevent information leaks through memfd pinning, and out-of
   bounds writes in GUP.

 - Fix data loss in shmem, THP collapse, KSM and memfd pinning.

 - Fix corruption and reference-counting errors with huge PMD/PUD
   mappings, and incorrect TLB flushing and unmapping.

 - Fix various use-after-free bugs, deadlocks and unkillable loops,
   witha a focus on shmem swap handling.

 - Fix execution-seal enforcement for memfd (incl. hugetlb).

Other changes fix accounting, quota and userfaultfd (un)registration
handling.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

----------------------------------------------------------------
Chris Mason (15):
      mm/mempolicy: charge shared policy nodes
      mm/shmem: honour F_SEAL_EXEC when an ACL is set
      mm/shmem: stop retrying folios that cannot be split
      mm/shmem: preserve data in clean folios when splitting fails
      mm/huge_memory: fix truncate racing with PMD zapping
      mm/huge_memory: fix zapping migration entries for device-private THPs
      mm/khugepaged: preserve dirty bits when collapsing PTE-mapped THPs
      mm/gup: fix clearing folios in memfd_pin_folios()
      mm/gup: fix out-of-bounds write for nr_pages == 0 in GUP-fast
      mm/mmu_notifier: set ->mm only after mmgrab()
      mm/memory: reject remote COW faults on PFN mappings
      mm: fix unkillable fault loop on MAP_DROPPABLE memory
      mm: fix deadlock of mremap() against UFFDIO_MOVE
      mm/ksm: check large swap-cache folios before mapping them
      mm/vma: call ->may_split() before a partial merge

David Hildenbrand (Arm) (26):
      mm/shmem: discard whole new large folios on fallocate rollback
      mm/shmem: rescan after nonuniform folio splitting
      mm/shmem: fix truncate hang in large swap entry
      mm/shmem: preserve allocation errors when swapping in large entries
      mm/shmem: fix truncate loop after boundary swapin failure
      mm/shmem: fix accounting of swapin-error markers
      mm/shmem: fix truncation of files containing only swapin-error markers
      fork: take mmap_lock before copying mm_struct
      mm/shmem: make shmem_file() check the file's inode
      mm/truncate: look again if a folio left the mapping
      mm/filemap: finish fault cleanup before dropping the fault lock
      mm/rmap: handle device-exclusive entries in folio_referenced_one()
      mm/huge_memory: fix list corruption when deferred_split_scan() races with deferred_split_folio()
      mm/huge_memory: properly handle refcounted PUD mappings on fork
      mm/gup: recheck the PUD under PTL in follow_pud_mask()
      mm/gup: check for overflow when converting nr_pages to bytes in GUP-fast
      mm/userfaultfd: write-lock the VMA before waking waiters when unregistering
      mm/userfaultfd: wake waiters when registration modes are removed
      mm/mremap: use pudp_huge_get_and_clear() when moving huge PUDs
      mm/mremap: recheck PUDs under the page table lock
      mm/madvise: fix data loss from MADV_FREE on a KSM page
      mm/ksm: reset the unstable trees of all nodes
      mm/ksm: fix use of a freed anon_vma at swap-in
      mm/huge_memory: split huge PUDs when adjusting VMA boundaries
      mm/vma: don't leak the charge for stack growth
      mm/memory-tiers: unregister empty tiers outside memory_tier_lock

Eva Kurchatova (1):
      hugetlbfs: enforce F_SEAL_EXEC in setattr

Gregory Price (1):
      mm/userfaultfd: compare exact registration modes before skipping

Josef Bacik (14):
      tmpfs: keep the quota soft limits of an unused id
      tmpfs: preserve explicitly disabled quota limits
      mm/shmem: hold off eviction in shmem_writeout()
      mm/mglru: don't use stack pointers when walking PUD and PMD tables
      mm/memfd: make f_pos accesses atomic
      mm/filemap: read mapping->a_ops->free_folio under i_lock
      mm/filemap: don't lose a folio lock wakeup to a signal
      mm/khugepaged: always recheck the pmd in try_collapse_pte_mapped_thp()
      mm/khugepaged: fix PMD table lock leak in try_collapse_pte_mapped_thp()
      mm/userfaultfd: wake all waiters on unregister
      mm/mmu_gather: fix flushing ranges with 4 GiB or larger
      mm/mmu_notifier: finish non-blocking interval invalidation on error
      mm/mremap: fix moving PUD leaves
      mm: fix unmap_mapping_range() beyond 4 GiB on 32-bit

Lance Yang (1):
      khugepaged: fix readahead lock inversion in collapse_file()

Rik van Riel (1):
      mm/cma: don't release CMA pages still in use

Ritesh Harjani (IBM) (1):
      mm/huge_memory: set the mmu_gather page size in zap_huge_pud()

Samiullah Khawaja (1):
      mm/gup: check folio->mapping under folio lock in memfd_pin_folios()

 fs/hugetlbfs/inode.c          |   8 ++
 include/asm-generic/tlb.h     |   3 +-
 include/linux/huge_mm.h       |   5 +-
 include/linux/ksm.h           |   6 +-
 include/linux/memfd.h         |   9 +++
 include/linux/mmu_notifier.h  |   3 +-
 include/linux/shmem_fs.h      |  15 ++--
 include/linux/userfaultfd_k.h |   2 -
 kernel/fork.c                 |  20 +++--
 mm/cma.c                      |  10 ++-
 mm/filemap.c                  |  84 ++++++++++----------
 mm/gup.c                      |  68 ++++++++++++-----
 mm/huge_memory.c              | 146 ++++++++++++++++++++++++++---------
 mm/hugetlb.c                  |  14 +---
 mm/internal.h                 |  28 +++++++
 mm/khugepaged.c               |  65 +++++++++++-----
 mm/ksm.c                      |  56 ++++++++++----
 mm/madvise.c                  |   9 +++
 mm/memfd.c                    |   2 +
 mm/memory-tiers.c             |  29 ++++---
 mm/memory.c                   |  30 +++++---
 mm/mempolicy.c                |   4 +-
 mm/mmap.c                     |   8 +-
 mm/mmu_notifier.c             |  24 ++++--
 mm/mremap.c                   | 103 +++++++++++--------------
 mm/nommu.c                    |   2 +-
 mm/rmap.c                     |  23 +++++-
 mm/shmem.c                    | 173 +++++++++++++++++++++++++++++-------------
 mm/shmem_quota.c              |  28 +++----
 mm/swapfile.c                 |   3 +-
 mm/truncate.c                 |  13 +++-
 mm/userfaultfd.c              |  75 +++++++++---------
 mm/util.c                     |  13 ++++
 mm/vma.c                      |  24 ++++--
 mm/vmscan.c                   |   4 +-
 35 files changed, 717 insertions(+), 392 deletions(-)

