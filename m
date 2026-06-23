Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 131C0CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 15:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5DE6B0088; Tue, 23 Jun 2026 11:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87846B008A; Tue, 23 Jun 2026 11:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9D0C6B008C; Tue, 23 Jun 2026 11:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 841EF6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:58:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E984CC0A65
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:58:51 +0000 (UTC)
X-FDA: 84911635662.01.6864AFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 979752001B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:58:42 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782230322;
	b=DJUW29bU7xMHLzvkE/7sRc7Fe8SEVFYbibyxZ81emV344CQoP2UBtGSSDs4EsYLbZmn0Ka
	D/aqCrfqEsG+GD5B51ZcqWQGAUpMx+bTubyDI7Uumae3nSeLgnqWJP+gBof2EVq2mRItjV
	d0qjyrUPnVDTfLRgoBBPYV3T4erzHT0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782230322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5sTSOIX3MEvkw7yJGOqw8Hq3CtwtoaOyjcGLRNtgrdU=;
	b=Fq2wWeIkVfknLpixIjZf7FcBtqs5RRGBzn4y6dt/t+tFQ5Xi2xMKtF1+eYY4VRs0U2C4O0
	EStJOvv4bwu7/CQ6AB4h/emhbEmC9h0fkzUDF/3pluV9c8q6MxkTQIJCuYFqCJeI2N2CR5
	B4SRXvLZwqHFF1tKvQXu8nofERIbtc0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=B0A9BylP;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 793BA408B6;
	Tue, 23 Jun 2026 15:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3932F1F000E9;
	Tue, 23 Jun 2026 15:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782230321;
	bh=5sTSOIX3MEvkw7yJGOqw8Hq3CtwtoaOyjcGLRNtgrdU=;
	h=Date:From:To:Cc:Subject;
	b=B0A9BylPuYGoWP023lu1TAwDMG1gd47Udjgeqv6/H+i0DrUlj2Q8LJR1+5+Rgfx8G
	 CdJ4wlP/09tAO0oPKgBYyfPZZJmfllU1DOsNfuS7TLzflbebCuEpUdFk6kh6f0tGAk
	 h2KixuAq8b5W/cddwqCyDYg52jo5Sb5Ju0mGaOoI=
Date: Tue, 23 Jun 2026 08:58:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] additional MM updates for 7.2-rc1
Message-Id: <20260623085840.0819c7694831ca2055e6a733@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-HE-Tag: 1782230322-607696
X-HE-Meta: U2FsdGVkX19ZWdp+S97Y13TBLT1VdnH/m2UBpui4bcIU0/rdgWabrcFGJZ0Lf08F4SuCGBtANbMZF288loBfwty5ybrnU6pn6xCTxwjH5BBJBMRYpT/xHh61M6/M3K7Ogv1LSWQHMd5ivU+7UNVSUpwspPg684uzmg/z0zRUi4DN7eJKdULz+N1Tar6tgjZJFYoz5IXjDiomKcES79rPrNmSiIojFtyU3JOsVZlfJESHbhY7Pa0iR07lNryt5OXssmaRst78KgSZy2rsud3Io1HKwsi2/dKzUMr4EqC5Zm4XQlWg7auHIivg7tX6hgE4xzTBJaCgG+5rV5PzdCzy/eg1tF9So3c6bZXfjWp2J4Z41pNENAosNprQop4WJFGUPhzyszFI4sZ9B1k0DpxOPWs4sPaFXOLpmqRKgPGSAtJNJWLAPauoN+k9tcdqPs0/ghdtLOUIlPw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this second and final batch of MM updates for the
upcoming -rc1 cycle.

I'm seeing a single conflict at this time, in fs/btrfs/defrag.c, vs the
fs tree.  Mark resolved it thusly:
	https://lore.kernel.org/ahRU4OQiGMaLf2Y-@sirena.org.uk

Thanks.


The following changes since commit e3d8707358ea76b78bdec9928937bb9a797f2c8f:

  selftests/mm/hmm-tests: test pagemap reads of PMD device-private entries (2026-06-08 18:21:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-06-23-08-55

for you to fetch changes up to 13a1e1a618858407fa12c391f664ea750651f6b2:

  Revert "mm: limit filemap_fault readahead to VMA boundaries" (2026-06-21 11:37:38 -0700)

----------------------------------------------------------------
mm.git review status for linus..mm-stable

Everything:

Total patches:       118
Reviews/patch:       1.57
Reviewed rate:       62%

Excluding DAMON:

Total patches:       117
Reviews/patch:       1.58
Reviewed rate:       63%

Excluding DAMON and selftests:

Total patches:       42
Reviews/patch:       3.14
Reviewed rate:       92%

Patch series in this merge:

- The 14 patch series "khugepaged: add mTHP collapse support" from Nico
  Pache provides khugepaged with the capability to collapse anonymous
  memory regions to mTHPs.

- The 14 patch series "Remove CONFIG_READ_ONLY_THP_FOR_FS and enable
  file THP for writable files" from Zi Yan ends up removing the
  READ_ONLY_THP_FOR_FS check in file_thp_enabled(), so that khugepaged and
  MADV_COLLAPSE can run on FSes with PMD THP pagecache support even
  without READ_ONLY_THP_FOR_FS enabled.

- The 55 patch series "make MM selftests more CI friendly" from Mike
  Rapoport provides general fixes and cleanups to the MM selftests.  It
  also moves more MM selftests uder the kselftest framework, making them
  more amenable to ongoing CI testing.

- The 13 patch series "selftests/mm: fix failures and robustness
  improvements" from Sayali Patil fixes several issues in MM selftests
  which were revealed by powerpc 64k pagesize.

- The 3 patch series "selftests/mm: assorted fixes for hmm-tests" from
  Sayali Patil fixes more 64k pagesize issues in the MM selftests.

----------------------------------------------------------------
Aboorva Devarajan (1):
      selftests/mm: fix exclusive_cow test fork() handling

Baolin Wang (1):
      mm/khugepaged: run khugepaged for all orders

Bart Van Assche (1):
      lib: split codetag_lock_module_list()

Ben Dooks (1):
      mm/vmscan: pass NULL to trace vmscan node reclaim

Chen Wandun (1):
      mm/khugepaged: avoid underflow in madvise_collapse for sub-PMD MADV_COLLAPSE

Christoph Hellwig (1):
      mm: merge writeout into pageout

David Hildenbrand (Arm) (1):
      selftests: mm: fix and speedup "droppable" test

Dev Jain (1):
      mm/khugepaged: generalize alloc_charge_folio()

Hao Ge (3):
      mm/alloc_tag: replace fixed-size early PFN array with dynamic linked list
      alloc_tag: fix use-after-free in /proc/allocinfo after module unload
      MAINTAINERS: add Hao Ge as reviewer for codetag and alloc_tag

Hongfu Li (1):
      selftests/mm: fix incorrect mmap() error handling with NULL instead of MAP_FAILED

Huang Shijie (1):
      mm: use mapping_mapped to simplify the code

Jianlin Shi (1):
      mm/page_alloc: only update NUMA min ratios on sysctl write

Kaitao Cheng (1):
      mm: page_isolation: avoid unsafe folio reads while scanning compound pages

Lance Yang (1):
      mm/khugepaged: fix PMD collapse swap PTE accounting

Lorenzo Stoakes (1):
      Revert "mm: limit filemap_fault readahead to VMA boundaries"

Markus Elfring (1):
      zsmalloc: simplify data output in zs_stats_size_show()

Mike Rapoport (Microsoft) (55):
      selftests/mm: hugetlb-read-hwpoison: add SIGBUS handler
      selftests/mm: migration: don't assume huge page is TWOMEG
      selftests/mm: migration: make nthreads represent number of working threads
      selftests/mm: migration: properly cleanup fork()ed processes
      selftests/mm: run_vmtests.sh: don't gate THP and KSM tests on HAVE_HUGEPAGES
      selftests/mm: merge map_hugetlb into hugepage-mmap
      selftests/mm: rename hugepage-* tests to hugetlb-*
      selftests/mm: hugetlb-shm: use kselftest framework
      selftests/mm: hugetlb-vmemmap: use kselftest framework
      selftests/mm: hugetlb-madvise: use kselftest framework
      selftests/mm: hugetlb_madv_vs_map: use kselftest framework
      selftests/mm: hugetlb-read-hwpoison: use kselftest framework
      selftests/mm: khugepaged: group tests in an array
      selftests/mm: khugepaged: use kselftest framework
      selftests/mm: ksm_tests: use kselftest framework
      selftests/mm: protection_keys: use descriptive test names in the output
      selftests/mm: protection_keys: use kselftest framework
      selftests/mm: uffd-common: use kselftest framework
      selftests/mm: uffd-stress: use kselftest framework
      selftests/mm: uffd-unit-tests: use kselftest framework
      selftests/mm: va_high_addr_switch: use kselftest framework
      selftests/mm: add atexit() and signal handlers to thp_settings
      selftests/mm: rename thp_settings.[ch] to hugepage_settings.[ch]
      selftests/mm: move HugeTLB helpers to hugepage_settings
      selftests/mm: hugepage_settings: use unsigned long in detect_hugetlb_page_size
      selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages
      selftests/mm: hugepage_settings: rename and rework get_free_hugepages()
      selftests/mm: hugepage_settings: add APIs for HugeTLB setup and teardown
      selftests/mm: move read_file(), read_num() and write_num() to vm_util
      selftests/mm: vm_util: add helpers to set and restore shm limits
      selftests/mm: compaction_test: use HugeTLB helpers ...
      selftests/mm: cow: add setup of HugeTLB pages
      selftests/mm: gup_longterm: add setup of HugeTLB pages
      selftests/mm: gup_test: add setup of HugeTLB pages
      selftests/mm: hmm-tests: add setup of HugeTLB pages
      selftests/mm: hugepage_dio: add setup of HugeTLB pages
      selftests/mm: hugetlb_fault_after_madv: add setup of HugeTLB pages
      selftests/mm: hugetlb-madvise: add setup of HugeTLB pages
      selftests/mm: hugetlb_madv_vs_map: add setup of HugeTLB pages
      selftests/mm: hugetlb-mmap: add setup of HugeTLB pages
      selftests/mm: hugetlb-mremap: add setup of HugeTLB pages
      selftests/mm: hugetlb-shm: add setup of HugeTLB pages
      selftests/mm: hugetlb-soft-offline: add setup of HugeTLB pages
      selftests/mm: hugetlb-vmemmap: add setup of HugeTLB pages
      selftests/mm: migration: add setup of HugeTLB pages
      selftests/mm: pagemap_ioctl: add setup of HugeTLB pages
      selftests/mm: protection_keys: use library code for HugeTLB setup
      selftests/mm: thuge-gen: add setup of HugeTLB pages
      selftests/mm: uffd-stress: use hugetlb_save and alloc huge pages
      selftests/mm: uffd-unit-tests: add setup of HugeTLB pages
      selftests/mm: uffd-wp-mremap: add setup of HugeTLB pages
      selftests/mm: va_high_addr_switch: add setup of HugeTLB pages
      selftests/mm: va_high_addr_switch.sh: drop huge pages setup
      selftests/mm: run_vmtests.sh: free memory if available memory is low
      selftests/mm: run_vmtests.sh: drop detection and setup of HugeTLB

Nico Pache (12):
      mm/khugepaged: generalize hugepage_vma_revalidate for mTHP support
      mm/khugepaged: rework max_ptes_* handling with helper functions
      mm/khugepaged: generalize __collapse_huge_page_* for mTHP support
      mm/khugepaged: require collapse_huge_page to enter/exit with the lock dropped
      mm/khugepaged: generalize collapse_huge_page for mTHP collapse
      mm/khugepaged: skip collapsing mTHP to smaller orders
      mm/khugepaged: add per-order mTHP collapse failure statistics
      mm/khugepaged: improve tracepoints for mTHP orders
      mm/khugepaged: introduce collapse_possible_orders helper functions
      mm/khugepaged: introduce mTHP collapse support
      mm/khugepaged: avoid unnecessary mTHP collapse attempts
      Documentation: mm: update the admin guide for mTHP collapse

Samuel Moelius (2):
      mm/page_frag: reject invalid CPUs in page_frag_test
      mm/gup_test: reject wrapped user ranges

Sayali Patil (15):
      selftests/mm: restore default nr_hugepages value via exit trap in charge_reserved_hugetlb.sh
      selftests/mm: fix hugetlb pathname construction in charge_reserved_hugetlb.sh
      selftests/mm: restore default nr_hugepages value via exit trap in hugetlb_reparenting_test.sh
      selftests/mm: fix hugetlb pathname construction in hugetlb_reparenting_test.sh
      selftests/mm: fix cgroup task placement and drop memory.current checks in hugetlb_reparenting_test.sh
      selftests/mm: size tmpfs according to PMD page size in split_huge_page_test
      selftests/mm: free dynamically allocated PMD-sized buffers in split_huge_page_test
      selftest/mm: register existing mapping with userfaultfd in hugetlb-mremap
      selftests/mm: ensure destination is hugetlb-backed in hugetlb-mremap
      selftests/mm: skip uffd-wp-mremap if UFFD write-protect is unsupported
      selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
      selftests/mm: move hwpoison setup into run_test() and silence modprobe output for memory-failure category
      selftests/mm: clarify alternate unmapping in compaction_test
      selftests/mm: allow PUD-level entries in compound testcase of hmm tests
      selftests/mm: remove hardcoded THP sizing assumptions in hmm tests

SeongJae Park (1):
      mm/damon/core: always put unsuccessfully committed target pids

Shakeel Butt (1):
      mm/shrinker: do not hold RCU lock in shrinker_debugfs_count_show()

Zi Yan (14):
      mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
      mm/khugepaged: add folio dirty check after try_to_unmap()
      mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
      mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in hugepage_enabled()
      mm: remove READ_ONLY_THP_FOR_FS Kconfig option
      mm: fs: remove filemap_nr_thps*() functions and their users
      fs: remove nr_thps from struct address_space
      mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
      mm/truncate: use folio_split() in truncate_inode_partial_folio()
      fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
      selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
      selftests/mm: remove READ_ONLY_THP_FOR_FS code from guard-regions
      mm/khugepaged: enable clean pagecache folio collapse for writable files
      selftests/mm: add writable-file collapse tests for khugepaged

 Documentation/admin-guide/mm/hugetlbpage.rst       |  15 +-
 Documentation/admin-guide/mm/transhuge.rst         |  71 +-
 MAINTAINERS                                        |   2 +
 fs/btrfs/defrag.c                                  |   3 -
 fs/hugetlbfs/inode.c                               |   4 +-
 fs/inode.c                                         |   3 -
 fs/open.c                                          |  27 -
 include/linux/alloc_tag.h                          |   4 +-
 include/linux/codetag.h                            |   3 +-
 include/linux/fs.h                                 |   5 -
 include/linux/huge_mm.h                            |  30 +-
 include/linux/pagemap.h                            |  52 +-
 include/linux/shmem_fs.h                           |   2 +-
 include/trace/events/huge_memory.h                 |  34 +-
 lib/alloc_tag.c                                    | 157 +++--
 lib/codetag.c                                      |  12 +-
 mm/Kconfig                                         |  11 -
 mm/damon/core.c                                    |  55 +-
 mm/filemap.c                                       |   5 -
 mm/gup_test.c                                      |  12 +-
 mm/huge_memory.c                                   |  50 +-
 mm/khugepaged.c                                    | 734 +++++++++++++++------
 mm/memory.c                                        |   4 +-
 mm/page_alloc.c                                    |  18 +-
 mm/page_isolation.c                                |  19 +-
 mm/readahead.c                                     |   6 +-
 mm/shrinker_debug.c                                |   4 -
 mm/truncate.c                                      |   8 +-
 mm/vmscan.c                                        |  69 +-
 mm/zsmalloc.c                                      |   3 +-
 tools/testing/selftests/mm/.gitignore              |   4 +
 tools/testing/selftests/mm/Makefile                |  13 +-
 .../selftests/mm/charge_reserved_hugetlb.sh        |  45 +-
 tools/testing/selftests/mm/compaction_test.c       | 118 +---
 tools/testing/selftests/mm/cow.c                   |  31 +-
 tools/testing/selftests/mm/droppable.c             |  46 +-
 tools/testing/selftests/mm/folio_split_race_test.c |  25 +-
 tools/testing/selftests/mm/guard-regions.c         |  20 +-
 tools/testing/selftests/mm/gup_longterm.c          |   5 +-
 tools/testing/selftests/mm/gup_test.c              |  15 +
 tools/testing/selftests/mm/hmm-tests.c             | 149 +++--
 tools/testing/selftests/mm/hugepage-mmap.c         |  78 ---
 .../mm/{thp_settings.c => hugepage_settings.c}     | 316 +++++++--
 .../mm/{thp_settings.h => hugepage_settings.h}     |  82 ++-
 tools/testing/selftests/mm/hugetlb-madvise.c       | 215 +++---
 tools/testing/selftests/mm/hugetlb-mmap.c          | 143 ++++
 .../mm/{hugepage-mremap.c => hugetlb-mremap.c}     |  47 +-
 tools/testing/selftests/mm/hugetlb-read-hwpoison.c | 121 ++--
 .../selftests/mm/{hugepage-shm.c => hugetlb-shm.c} |  69 +-
 tools/testing/selftests/mm/hugetlb-soft-offline.c  |  45 +-
 .../mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c}   |  46 +-
 tools/testing/selftests/mm/hugetlb_dio.c           |  15 +-
 .../selftests/mm/hugetlb_fault_after_madv.c        |   9 +-
 tools/testing/selftests/mm/hugetlb_madv_vs_map.c   |  22 +-
 .../selftests/mm/hugetlb_reparenting_test.sh       |  60 +-
 tools/testing/selftests/mm/khugepaged.c            | 559 ++++++++--------
 tools/testing/selftests/mm/ksm_tests.c             | 184 +++---
 tools/testing/selftests/mm/madv_populate.c         |   2 +-
 tools/testing/selftests/mm/map_hugetlb.c           |  88 ---
 tools/testing/selftests/mm/migration.c             | 147 +++--
 .../selftests/mm/page_frag/page_frag_test.c        |   2 +
 tools/testing/selftests/mm/pagemap_ioctl.c         |  13 +-
 tools/testing/selftests/mm/pkey-helpers.h          |  15 +-
 tools/testing/selftests/mm/prctl_thp_disable.c     |   2 +-
 tools/testing/selftests/mm/protection_keys.c       | 130 ++--
 tools/testing/selftests/mm/run_vmtests.sh          | 234 ++-----
 tools/testing/selftests/mm/soft-dirty.c            |   6 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |  29 +-
 tools/testing/selftests/mm/thuge-gen.c             |  96 +--
 tools/testing/selftests/mm/transhuge-stress.c      |   2 +-
 tools/testing/selftests/mm/uffd-common.h           |  18 +-
 tools/testing/selftests/mm/uffd-stress.c           |  48 +-
 tools/testing/selftests/mm/uffd-unit-tests.c       | 138 ++--
 tools/testing/selftests/mm/uffd-wp-mremap.c        |  33 +-
 tools/testing/selftests/mm/va_high_addr_switch.c   |  42 +-
 tools/testing/selftests/mm/va_high_addr_switch.sh  |  41 +-
 tools/testing/selftests/mm/vm_util.c               | 136 ++--
 tools/testing/selftests/mm/vm_util.h               |  15 +-
 78 files changed, 2832 insertions(+), 2309 deletions(-)
 delete mode 100644 tools/testing/selftests/mm/hugepage-mmap.c
 rename tools/testing/selftests/mm/{thp_settings.c => hugepage_settings.c} (58%)
 rename tools/testing/selftests/mm/{thp_settings.h => hugepage_settings.h} (51%)
 create mode 100644 tools/testing/selftests/mm/hugetlb-mmap.c
 rename tools/testing/selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c} (80%)
 rename tools/testing/selftests/mm/{hugepage-shm.c => hugetlb-shm.c} (55%)
 rename tools/testing/selftests/mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c} (76%)
 delete mode 100644 tools/testing/selftests/mm/map_hugetlb.c


