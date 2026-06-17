Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D80D9CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 22:31:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9E976B0088; Wed, 17 Jun 2026 18:31:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4FBE6B008A; Wed, 17 Jun 2026 18:31:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9653D6B008C; Wed, 17 Jun 2026 18:31:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 687CC6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:31:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EAFE71A05EB
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 22:31:47 +0000 (UTC)
X-FDA: 84890853054.20.1B2B43A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E144E20002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 22:31:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ICPxMgmV;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781735506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4Qf3wr9BBl2H99nJ2CG6NJ+9FeOWB/ET8gjqBFKBbos=;
	b=Wqdxkh2kk2WMGn0zq7EzqFO9Tz+2oj1qx8xHezNM1Ii1459w+BhXmWTRXtVVh44FXE3lwg
	oOcdGKPnrT7QRTYWfOcVmZRBTIe9160mmMM9Rej8rMdeYlJ9BTGa5dNcvWCX0fGZNxp91N
	arLblpL2EuJRVSTSn3E0NKGfh6hKhbc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ICPxMgmV;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781735506;
	b=evZMU4VBNJg6QEOxM+4+ODcrBqF6WZ0OsQaiw+/vQiNd72btIimcamc851ppRM6FJLrlpU
	iPIVlPnOdlGqndcNIRTY51ehBernwyGIXEDe4N1j4ER/8ct4Yk2UU3wpbPLTLrXv8wSnVK
	toCVFxvbyE1Kwxb19Zgh2w4YBlbxzHg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 33F5B6001D;
	Wed, 17 Jun 2026 22:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA561F000E9;
	Wed, 17 Jun 2026 22:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781735504;
	bh=4Qf3wr9BBl2H99nJ2CG6NJ+9FeOWB/ET8gjqBFKBbos=;
	h=Date:From:To:Cc:Subject;
	b=ICPxMgmV7tDJS7PRYoWJMzA1/bbO+bCSpXhFyYqUX0VIyRWbGpKL1jJf/YEMjZvSi
	 StTKiBMjaIlltsQ7bJxzjiMncSgZSfr+BxaAKteYqRpUcnnl6fdEqtjTCa4nQcxE6z
	 UMd02+Ft3d31QlfR9hq6JmUxKOuxkLkZPFtF2G9Q=
Date: Wed, 17 Jun 2026 15:31:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] MM updates for 7.2-rc1
Message-Id: <20260617153144.acead3f2795da15f1e56005c@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: u6on3kchcgnusttnjqoqhtd35bx6b8yo
X-Rspamd-Queue-Id: E144E20002
X-HE-Tag: 1781735505-564262
X-HE-Meta: U2FsdGVkX19bEmDQH/Ovv/CnHaVQWiVWMMnsw7dsky/lB44ndQN+7KXzVfdKL51BLqzfpwELT3lO7tG0WxOwQhGuIJghiBXREM/rA8G4GlG8Of/xKzG4G8sQRI0Dr/JnrBUagQo51WzWLFU7LtsJK8lDcqZO/gmvLNGlb3OWZPCvjEBFqFhgzbGwPvsZr8oJYEWlBd9sKjgqTK6BVUkMmvfzrVohjO71pFcSPG+FRmXzHm4+igg7sGMULGLjJhHDoet4dwOXaEg6G7R7VB4GyuFCYb906OhLtCuhF2eJaDYHf974dB7YVAY+zDnnGoac4ewWeIEYYDA1LEkV9QPHmPlibrFR5qkndIaMdhR5n1QiUsbPZWOIRQ5zfGGPFInzZ5HJpQknhYhrB+CJQ1rYHcxb0IvtHPT/HCnokbP8vWkYSnEfNjWpYmhc0QP05s7YsZyfV94BiW+GHeyCEnZSW8BYGqIwBqNuD2hPtNcxvga0ZrxYGWPiegZ8yFkIprMhvIGlduO38y5aCU6G34dzEYCxxBL6F9mBW/WsvsPlPEveLCfDBZdgM6fDFtNrQlu81qeEVVtsy9gD2yRiWt3WlFwu22DCO0QizqqEo4SUQCZP7UYQ1oOQDv9ctbrUXgjRxkXip5x2Ua+m+HFXbGKAnNUpwPPHgTgUhtkK9bhmphxYtLrK6cKsV4JsTF96znGaJ65/CHKPgSKiq0gVpiQFbk7Ym93zk1tnbYqhpya9XBeaBHYSdFsjHrJZQJMQep2qIW43d1vCG1ZIYu+0jHEOGN68RTOy/3f4RBD0+8Gx2a0TgUbi5MHx3ZOTUPScfuQpyjdvZkMZda1Q9hS9heECOE5gxNRTpsJY/BFBoX+HcMdUSYbvJ/JVA7hX8an3VfoFHkTmqD+YDs9Goo3gHZYFuo92/o569gLTZG4vNlPmsYHLBNgxaGkssqbcrmC9Xb3HhK2fGe6jD+SwfvsK3zH
 yip1B0eV
 JS4DORmxNOG53E2T2J79axw/An2I0qQXDRAxvLL3UlJjj8HPD6Qx6mrmKX9kptVMEw1hraBWwv9A6Geq4UmJ4C31C4l0UBz8jsG1KE4MFZ38qLGtsvv2SHv/LSnSso32hj8UysE/QMcPT8seo6sbSInk1M/N4a2FOboHiRRy85ar+b7+p+uGBBa5w66X/rZULBTXotGJMOyEvwaDWhmTyw5PIYjev+XJxNyNbu7nP6ZN4pKvJ5LE+aYGnXFYlL05/VqQCmrwKejzqGHjNQNueQoOXeKajYQ3wAgOZtv2FQ78fmDsrqMRS6uJjgGP8lcxYm9sEHnNR0keVKoZ5tNWtrUH6DBhbalpXQqNRBUk+x8HfZ+U4FX5b3m5BgDD7bFhd15NtyU7uceVZzFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge these MM updates for the 7.2-rc1 development tree,
thanks.


Conflicts I'm presently seeing, along with their linux-resolutions:

mm/page_io.c, vs block tree:
	https://lore.kernel.org/ah26UmcBXVJMy-Cc@sirena.org.uk

tools/testing/selftests/cgroup/test_memcontrol.c, vs cgroup tree:
	https://lore.kernel.org/ags6BawOir3IQHIZ@sirena.org.uk



Possible upcoming possible conflicts and build issues, along with their
linux-next resolutions:

include/net/netmem.h, vs net tree:
	https://lore.kernel.org/aaGiDINfnUexT9Px@sirena.org.uk

drivers/android/binder/page_range.rs, vs char-misc.current tree:
	https://lore.kernel.org/aarPg_AVR3TN9frW@sirena.org.uk

fs/ntfs/file.c, vs fs tree:
	https://lore.kernel.org/aa7ZT-cQMVdQOOAj@sirena.org.uk

virt/kvm/guest_memfd.c, vs kvm-x86 tree:
	https://lore.kernel.org/abGDp4jguPV2H2Mf@sirena.org.uk

init/main.c, vs tip tree:
	https://lore.kernel.org/abLMq8TWJIQH5uTj@sirena.org.uk

fs/f2fs/compress.c, vs fs tree:
	https://lore.kernel.org/acPtrrkwagtafDT8@sirena.org.uk

fs/exfat/file.c, vs fs tree:
	https://lore.kernel.org/acbY5CCmsk8C95m5@sirena.co.uk

lib/vdso/datastore.c, vs tip tree:
	https://lore.kernel.org/acbz78Mbv55Vzfh8@sirena.co.uk

arch/loongarch/mm/init.c, vs loongarch tree:
	https://lore.kernel.org/ahBDDF2noinoSIg5@sirena.org.uk

fs/btrfs/defrag.c, vs fs tree:
	https://lore.kernel.org/ahRU4OQiGMaLf2Y-@sirena.org.uk



The following changes since commit e771677c937da5808f7b6c1f0e4a97ec1a84f8a8:

  Merge tag 'for-linus-iommufd' of git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd (2026-06-17 12:33:23 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-06-17-15-16

for you to fetch changes up to e771677c937da5808f7b6c1f0e4a97ec1a84f8a8:

  Merge tag 'for-linus-iommufd' of git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd (2026-06-17 12:33:23 -0700)

----------------------------------------------------------------
mm.git review status for mm-hotfixes-stable..mm-stable

Everything:

Total patches:       321
Reviews/patch:       1.52
Reviewed rate:       68%

Excluding DAMON:

Total patches:       227
Reviews/patch:       2.07
Reviewed rate:       90%

Excluding DAMON and selftests:

Total patches:       203
Reviews/patch:       2.14
Reviewed rate:       91%

Patchsets in this merge:

- The 2 patch series "selftests/mm: clean up build output and verbosity"
  from Li Wang removes some noise from the MM selftests build out.

- The 3 patch series "mm: Free contiguous order-0 pages efficiently"
  from Ryan Roberts speeds up the freeing of a batch of 0-order pages by
  first scanning them for coalescing opportunities.  This is applicable to
  vfree() and to the releasing of frozen pages.

- The 11 patch series "mm/damon: introduce DAMOS failed region quota
  charge ratio" from SeongJae Park addresses a DAMOS usability issue: The
  DAMOS quota often exhausts prematurely because it charges for all memory
  attempted, causing slow and inconsistent performance when actions fail
  on unreclaimable memory.

  To fix this, a new feature lets users set a smaller, flexible quota
  charge ratio (via a numerator and denominator) for failed regions.
  Since failed actions cause less overhead, reducing their quota cost
  ensures more predictable and efficient DAMOS processing

- The 8 patch series "selftests/cgroup: improve zswap tests robustness
  and support large page sizes" from Li Wang fixes various spurious
  failures and improves the overall robustness of the cgroup zswap
  selftests.

- The 3 patch series "fix MAP_DROPPABLE not supported errno" from
  Anthony Yznaga fixes an issue in the mlock selftests on arm32.

- The 2 patch series "mm: huge_memory: clean up defrag sysfs with
  shared" from Breno Leitao does some maintenance work in the huge_memory
  code.

- The 3 patch series "treewide: fixup gfp_t printks" from Brendan
  Jackman uses the special vprintf() gfp_t conversion in various places.

- The 6 patch series "mm: Fix vmemmap optimization accounting and
  initialization" from Muchun Song fixes several bugs in the vmemmap
  optimization, mainly around incorrect page accounting and memmap
  initialization in the DAX and memory hotplug paths.  It also fixes
  pageblock migratetype initialization and struct page initialization for
  ZONE_DEVICE compound pages.

- The 4 patch series "mm/damon: repost non-hotfix reviewed patches in
  damon/next tree" from is a sprinkle of unrelated minor bugfixes for
  DAMON.

- The 3 patch series "mm: remove page_mapped()" from David Hildenbrand
  remove this function from the tree, replacing it with folio_mapped().

- The 10 patch series "mm/damon: let DAMON be paused and resumed" from
  SeongJae Park permits DAMON to be paused and resumed without losing its
  current state.

- The 3 patch series "kasan: hw_tags: Disable tagging for stack and
  page-tables" from Muhammad Usama Anjum simplifies and speeds up kasan by
  removing its ineffective tagging of stacks and page tables.

- The 7 patch series "mm/damon/reclaim,lru_sort: monitor all system rams
  by default" from SeongJae Park simplifies deployment on diverse hardware
  like NUMA systems by updating DAMON_RECLAIM and DAMON_LRU_SORT to
  automatically monitor the physical address range covering all System RAM
  areas by default, replacing the overly restrictive behavior that only
  targeted the single largest memory block to save on negligible overhead.

- The 2 patch series "mm/damon/sysfs: document filters/ directory as
  deprecated" from SeongJae Park updates some DAMON docs.

- The 8 patch series "mm: use spinlock guards for zone lock" from Dmitry
  Ilvokhin switches zone->lock handling over to using the guard()
  mechanisms.

- The 2 patch series "mm/filemap: tighten mmap_miss hit accounting" from
  fujunjie fixes a flaw where the mmap_miss counter over-credited page
  cache hits during fault-arounds and page-fault retries.  This results in
  significant reduction of redundant synchronous mmap readahead I/O,
  drastically cutting down execution time and gigabytes read for sparse
  random or strided memory access workloads.

- The 2 patch series "selftests/cgroup: Fix false positive failures in
  test_percpu_basic" from Li Wang fixes a couple of false-positives in the
  cgroup kmem selftests.

- The 2 patch series "mm/damon/reclaim: support monitoring intervals
  auto-tuning" from SeongJae Park adds a new parameter to DAMON permitting
  DAMON_RECLAIM to automatically tune DAMON's sampling and aggregation
  intervals.

- The 2 patch series "mm/damon/stat: add kdamond_pid parameter" from
  SeongJae Park chnges DAMON_STAT to provide the pid of its kdamond.

- The 2 patch series "mm/kmemleak: dedupe verbose scan output" from
  Breno Leitao removes large amounts of duplicated backtraces from the
  verbose-mode kmemleak output.

- The 8 patch series "mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE (Part 1)"
  from David Hildenbrand reduces our use of CONFIG_HAVE_BOOTMEM_INFO_NODE,
  with a view to removing it entirely in a later series.

- The 2 patch series "mm/damon: validate min_region_size to be power of
  2" from Liew Rui Yan prevents users from passing a non-power-of-2 value
  of `addr_unit', as this later results in undesirable behavior.

- The 2 patch series "mm: document read_pages and simplify usage" from
  Frederick Mayle does as claimed.

- The 3 patch series "tools/mm/page-types: Fix misc bugs" from Ye Liu
  fixes three issues in tools/mm/page-types.c.

- The 4 patch series "mm: misc cleanups from __GFP_UNMAPPED series" from
  Brendan Jackman implements several cleanups in the page allocator and
  related code.

- The 12 patch series "mm, swap: swap table phase IV: unify allocation"
  from Kairui Song unifies the allocation and charging of anon and shmem
  swap in folios, provides better synchronization, consolidates the
  metadata management, hence dropping the static array and map, and
  improves performance.

- The 28 patch series "mm/damon: introduce data attributes monitoring"
  from SeongJae Park extends DAMON for monitoring general data attributes
  other than accesses.

- The 5 patch series "mm/vmalloc: free unused pages on vrealloc()
  shrink" from Shivam Kalra implements the TODO in vrealloc() to unmap and
  free unused pages when shrinking across a page boundary.

- The 3 patch series "mm/damon: documentation and comment fixes" from
  niecheng does as advertised.

- The 3 patch series "remove mmap_action success, error hooks" from
  Lorenzo Stoakes eliminates custom hooks from mmap_action by removing the
  problematic success_hook which allowed drivers to improperly access
  uninitialized VMAs.  It replaces the error_hook with a simple error-code
  field and updates the memory char driver accordingly.

- The 14 patch series "mm/damon: minor improvements for code readability
  and tests" from SeongJae Park implements minor improvements in code
  readability and tests for DAMON.

- The 2 patch series "mm/damon: fix macro arguments and clarify quota
  goals doc" from Maksym Shcherba does those things.

- The 2 patch series "userfaultfd: merge fs/userfaultfd.c into
  mm/userfaultfd.c" from Mike Rapoport performs that code movement.

- The 15 patch series "mm/mglru: improve reclaim loop and dirty folio"
  from Kairui Song and others cleans up and slightly improves MGLRU's
  reclaim loop and dirty writeback handling.  Large performance
  improvements are measured.

- The 3 patch series "use vma locks for proc/pid/{smaps|numa_maps}
  reads" from Suren Baghdasaryan uses per-vma locks when reading
  /proc/pid/smaps and /proc/pid/numa_maps similar to reduce contention on
  central mmap_lock.

- The 2 patch series "refactors thpsize_shmem_enabled_store() and
  thpsize_shmem_enabled_show()" from Ran Xiaokai provides some cleanup
  work in the THP code.

- The 2 patch series "selftests/memfd: fix compilation warnings" from
  Konstantin Khorenko fixes a few build glitches in the memfd selftest
  code.

- The 4 patch series "memcg: shrink obj_stock_pcp and cache multiple
  objcgs" from Shakeel Butt resolves a 68% performance regression caused
  by NUMA-node cache thrashing around struct obj_stock_pcp by shrinking
  its existing fields and expanding it into a multi-slot array that caches
  up to five obj_cgroup pointers per CPU, allowing per-node variants of
  the same memcg to coexist within a single 64-byte cache line.

- The 2 patch series "zram: writeback fixes" from Sergey Senozhatsky
  addresses a couple of unrelated zram writeback issues.

- The 9 patch series "mm: switch THP shrinker to list_lru" from Johannes
  Weiner resolves NUMA-awareness issues and streamlines callsite
  interaction by refactoring and extending the list_lru API to completely
  replace the complex, open-coded deferred split queue for Transparent
  Huge Pages (THPs).

- The 2 patch series "mm: improve large folio readahead for exec memory"
  from Usama Arif improves large-folio readahead on systems like 64K-page
  arm64 by preventing the mmap_miss check from permanently disabling
  target-oriented VM_EXEC readahead, and by generalizing the
  force_thp_readahead gate to support mappings with any usefully large
  maximum folio order under the cache cap.

- The 6 patch series "userfaultfd/pagemap: pre-existing fixes" from
  Kiryl Shutsemau fixes a bunch of minor issues in the
  userfaultfd/pagemap, all of which were flagged by Sashiko review of
  proposed new material.

- The 5 patch series "mm/sparse-vmemmap: Provide generic
  vmemmap_set_pmd() and vmemmap_check_pmd()" from Muchun Song provides
  generic versions of these two functions so the four arch-specific
  implementations can be removed.

- The 2 patch series "mm/swap, PM: hibernate: fix swapoff race in
  uswsusp by pinning swap device" from Youngjun Park addresses a
  uswsusp-vs-swapoff race and reduces the swap device reference
  taking/releasing frequency.

- The 2 patch series "mm/hmm: A fix and a selftest" from Dev Jain does
  as claimed.

----------------------------------------------------------------


