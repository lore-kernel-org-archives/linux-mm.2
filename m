Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA57C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 01:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6228E0002; Mon,  4 Aug 2025 21:58:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967448E0001; Mon,  4 Aug 2025 21:58:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87CFC8E0002; Mon,  4 Aug 2025 21:58:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76D7C8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 21:58:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 167C61DDA8F
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 01:58:56 +0000 (UTC)
X-FDA: 83741045472.06.BD868A8
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7EA2580004
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 01:58:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DhNJFuoR;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754359134; a=rsa-sha256;
	cv=none;
	b=n+yN3WHHyT4VbizS8VacXWm3q9oMOQk/QYN+95vb1FJihNLRJNw69ABPY2cN1zMfq5Hoi7
	xN6X2C+X84M4XSzMA2D4O0EdINN8/3XJ0YiS0SWygENKtsab8wtz9QiQ7MiHyL822JiEiE
	E1J1LA0Q2byVskBfMgHIGOKIVe0N3kI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DhNJFuoR;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754359134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=c0fmMYUWW5aq/ZixeErEC6SbN3BrGz5bkgLU9+Wftc4=;
	b=rM9TItGHuduyv+4JKcFoeYwjlEy9N2Fx+az3w1dl1naZVAPkTf2qIva1uNXnKbmWQZqnrn
	QAzEnVZ8N62Aezn4Wfyvknw1YTXbVMRqNUCV4Kegf/m0np0jtBkrtOAXOtb0eWTI/pPz/6
	4Ew4iT1aMoF/Y7Srhgtim7U3z08LIGQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 5E8205C5412;
	Tue,  5 Aug 2025 01:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E494AC4CEE7;
	Tue,  5 Aug 2025 01:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754359133;
	bh=zxcA38zhJxLeuNnCt3MgCVsaJMa24DpyresNs6gIDdE=;
	h=Date:From:To:Cc:Subject:From;
	b=DhNJFuoRiXsCswzz9Yv+4+0rdQEGQ/xTs8Jz7RGXMC84vNwKXe7FJVJhO5swRPb1t
	 r1uueT6B5BPKX/kKiooz8YrF/LM8p8A7hfKiUPvXzadxjKW8c8h5RLU64JJ/12Tqj+
	 CMGRsf0VrL9gyQlgYi5nfaPLjfLK4EuHQLEsWr+Q=
Date: Mon, 4 Aug 2025 18:58:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] Additional MM updates for 6.17-rc1
Message-Id: <20250804185852.038ce90aa6f9a177c492b675@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7EA2580004
X-Stat-Signature: mu6tmrq3eqkeugzhtf3fa6dnbi6csj8g
X-Rspam-User: 
X-HE-Tag: 1754359134-188366
X-HE-Meta: U2FsdGVkX18QS1CZb94GblLDRF9fXmEuadXR2SZtzEXgAL/7ZPIezyNVUHfKUa9tKiu7GJFLlgY8qbZZ6TD7udJ385Mq2HBS6zpBfuoEhA3pgF5nKt9eETerFKHJ10G7tSp7MejTRbgVYcbu2Nsf0sq6iMfgjKBmxKoYqwWq7Tjm8O7EJ1Y0siqwVbWK4VTgBppyxMNAv1MTtseUemXE512wQEtEI5/yKJjdrQIXr5Q0Ldbd3hqWVbEwT5g9WxJtN8wDNThU54vXn6TQO/8+oq9wJTuIjudmLpea0Ph+17juAHn49XxhdmM7RUTp/jRL+x6LCZHp2Z4INY4X7Y7YnDaCjuxj7zL9baX4CPTUDWM54la7jyvY/hroAbqNY3+8m51YqiD225NsKzE9yTKSONZlCTJeU3dXS9yOhwd1aIP7OMXostqG2Nogli8SHgHKSq3DVsV1oqv4dOd+IeqaOcRmnXd0qE69Kf28UNo5Dwx9tnDomyT7bek0snerMg8HsqhVILwhqvT07EW0mV5dQQjFaYfJOLxvM/DNVLEBYINs5RrATge7biHYnLkc5+QTXuSCdEdlRClOaQdsbCN3yv6yoIY8aWYUi9VGK42LasL9009M2YsNbWenWgOSX/j7MrGZZQ7ffu+GySMgk4RYDkg201u1yq0r+RsXOf8T/42v5eq96e0QdxFqssN2fdvLT3rBzq9aqm7gTnTPv/eqdnhu1KS4Ug4oukuFIaigzVNT61QPY21Tio0zGUGcsv2Yf0K9mG52wgfvi1bPWUqACut3tKw2irfMIkXeF6B0o1DCIWochnAkVU8CsoIkzO8iWpPMN0/XURzKoi/0UO2GMF1EhQFWT6+pnGd4WaxnzgHRo9F/99xlhNnHL3CwY6EwIra25xNlRTxTAnZ0RK7bJJ1oB5BbwSa42ZqOkJJSbwY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please pull this second and final batch of MM updates for the
upcoming -rc1 cycle, thanks.

I'm presently seeing no merge issues with this small batch of changes.

Thanks.


The following changes since commit af915c3c13b64d196d1c305016092f5da20942c4:

  MAINTAINERS: add missing headers to mempory policy & migration section (2025-07-26 15:08:24 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-08-03-12-35

for you to fetch changes up to a2152fef29020e740ba0276930f3a24440012505:

  mm: mempool: fix crash in mempool_free() for zero-minimum pools (2025-08-02 12:06:13 -0700)

----------------------------------------------------------------
Significant patch series in this pull request:

- The 4 patch series "mseal cleanups" from Lorenzo Stoakes erforms some
  mseal cleaning with no intended functional change.

- The 3 patch series "Optimizations for khugepaged" from David
  Hildenbrand improves khugepaged throughput by batching PTE operations
  for large folios.  This gain is mainly for arm64.

- The 8 patch series "x86: enable EXECMEM_ROX_CACHE for ftrace and
  kprobes" from Mike Rapoport provides a bugfix, additional debug code and
  cleanups to the execmem code.

- The 7 patch series "mm/shmem, swap: bugfix and improvement of mTHP
  swap in" from Kairui Song provides bugfixes, cleanups and performance
  improvememnts to the mTHP swapin code.

----------------------------------------------------------------
Baolin Wang (1):
      mm: shmem: fix the shmem large folio allocation for the i915 driver

Bijan Tabatabai (1):
      mm/damon/vaddr: skip isolating folios already in destination nid

David Hildenbrand (1):
      mm: add get_and_clear_ptes() and clear_ptes()

Dev Jain (2):
      khugepaged: optimize __collapse_huge_page_copy_succeeded() by PTE batching
      khugepaged: optimize collapse_pte_mapped_thp() by PTE batching

Jann Horn (2):
      kasan: skip quarantine if object is still accessible under RCU
      mm/rmap: add anon_vma lifetime debug check

Jinjiang Tu (2):
      mm/memory-failure: hold PTL in hwpoison_hugetlb_range
      mm/mincore: hold PTL in mincore_hugetlb

Joanne Koong (1):
      mm/page-flags: remove folio_start_writeback_keepwrite()

Kairui Song (8):
      mm/shmem, swap: improve cached mTHP handling and fix potential hang
      mm/shmem, swap: avoid redundant Xarray lookup during swapin
      mm/shmem, swap: tidy up THP swapin checks
      mm/shmem, swap: tidy up swap entry splitting
      mm/shmem, swap: never use swap cache and readahead for SWP_SYNCHRONOUS_IO
      mm/shmem, swap: simplify swapin path and result handling
      mm/shmem, swap: rework swap entry and index calculation for large swapin
      mm/shmem, swap: fix major fault counting

Lorenzo Stoakes (7):
      mm/mseal: always define VM_SEALED
      mm/mseal: update madvise() logic
      mm/mseal: small cleanups
      mm/mseal: simplify and rename VMA gap check
      mm/mseal: rework mseal apply logic
      mm: remove mm/io-mapping.c
      mm: correct type for vmalloc vm_flags fields

Mike Rapoport (Microsoft) (8):
      execmem: drop unused execmem_update_copy()
      execmem: introduce execmem_alloc_rw()
      execmem: rework execmem_cache_free()
      execmem: move execmem_force_rw() and execmem_restore_rox() before use
      execmem: add fallback for failures in vmalloc(VM_ALLOW_HUGE_VMAP)
      execmem: drop writable parameter from execmem_fill_trapping_insns()
      x86/kprobes: enable EXECMEM_ROX_CACHE for kprobes allocations
      x86/ftrace: enable EXECMEM_ROX_CACHE for ftrace allocations

Suren Baghdasaryan (1):
      mm: fix a UAF when vma->mm is freed after vma->vm_refcnt got dropped

Suresh K C (1):
      selftests: cachestat: add tests for mmap, refactor and enhance mmap test for cachestat validation

Xuanye Liu (1):
      mm: add process info to bad rss-counter warning

Yadan Fan (1):
      mm: mempool: fix crash in mempool_free() for zero-minimum pools

wang lian (1):
      selftests/mm: add process_madvise() tests

 Documentation/core-api/mm-api.rst                  |   1 -
 arch/arm64/mm/mmu.c                                |   4 +-
 arch/x86/kernel/alternative.c                      |   3 +-
 arch/x86/kernel/ftrace.c                           |   2 +-
 arch/x86/kernel/kprobes/core.c                     |  18 --
 arch/x86/mm/init.c                                 |  24 +-
 include/linux/execmem.h                            |  54 ++--
 include/linux/io-mapping.h                         |   3 -
 include/linux/mm.h                                 |   6 +-
 include/linux/mmap_lock.h                          |  30 ++
 include/linux/page-flags.h                         |   2 -
 include/linux/pgtable.h                            |  45 +++
 include/linux/rmap.h                               |  22 ++
 kernel/fork.c                                      |   9 +-
 kernel/module/main.c                               |  13 +-
 mm/Kconfig                                         |   4 -
 mm/Makefile                                        |   1 -
 mm/damon/vaddr.c                                   |   4 +
 mm/execmem.c                                       | 206 ++++++++----
 mm/internal.h                                      |   2 +-
 mm/io-mapping.c                                    |  30 --
 mm/kasan/common.c                                  |  25 +-
 mm/khugepaged.c                                    |  58 ++--
 mm/madvise.c                                       |  71 ++++-
 mm/memory-failure.c                                |  12 +-
 mm/mempool.c                                       |  24 +-
 mm/mincore.c                                       |   3 +
 mm/mmap_lock.c                                     |  10 +-
 mm/mprotect.c                                      |   2 +-
 mm/mremap.c                                        |   4 +-
 mm/mseal.c                                         | 166 +++-------
 mm/nommu.c                                         |   2 +-
 mm/rmap.c                                          |   2 +-
 mm/shmem.c                                         | 279 +++++++++--------
 mm/vma.c                                           |   4 +-
 mm/vma.h                                           |  27 +-
 tools/testing/selftests/cachestat/test_cachestat.c |  62 +++-
 tools/testing/selftests/mm/.gitignore              |   1 +
 tools/testing/selftests/mm/Makefile                |   1 +
 tools/testing/selftests/mm/process_madv.c          | 344 +++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh          |   5 +
 tools/testing/vma/vma_internal.h                   |   6 +-
 42 files changed, 1080 insertions(+), 511 deletions(-)
 delete mode 100644 mm/io-mapping.c
 create mode 100644 tools/testing/selftests/mm/process_madv.c



