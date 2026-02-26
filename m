Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56BD2FC5930
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88076B0089; Thu, 26 Feb 2026 06:33:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69746B008A; Thu, 26 Feb 2026 06:33:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F326B008C; Thu, 26 Feb 2026 06:33:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 92ED06B0089
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:33:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A9CCC38BF
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:06 +0000 (UTC)
X-FDA: 84486396372.25.162BFBD
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6000C8000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n+LWDYrt;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=k2ELw/d/0Gog00pMOWAThLbOMM5tKNxDq9T0P2nOjys=;
	b=uM8CghSO5ntbR9k4Ts6wX/7RXvE7VVJ3VaLbp0nNFZ7ijShVmH8X50cGziG0B8SVFSZzqx
	fAcKl+a3IJNNeVTuNSQvPe0C9GXjBWjMidKT95ZI1irWRfR/GPE1A26CkKYyQeicXjWNZa
	i/fxas8Ip221kai+sF73kmi1Vjut8S8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n+LWDYrt;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105584; a=rsa-sha256;
	cv=none;
	b=fLKyIr9xfmXy8obnc4KXBFQ4lzQlOOKL9K58wIRjIJNIVYTNsuYTcze98Q+w8UP8c804hi
	D8w3VahmlvxGlqCaJBsT30yyt1RkMINDk2VfibjlwDwV/C1oRjW7KCX4tfvsVfs/sVI8oz
	I5apyhYAmTaYF5rDOH020HmHrP+rcuQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=k2ELw/d/0Gog00pMOWAThLbOMM5tKNxDq9T0P2nOjys=;
	b=n+LWDYrtObsXfcKC7/nZPQ+aQqrswSfcmVak0ruMCIQrn4JHlHeaAjZLo0fHzU/CZyaKM0
	oZGFn+vdg7IzoLhh3QnaIGrmyYrAMUoaiAVI3rguksiXePFiMnXJOV3hJbZcr3SknCNQuK
	SjmK1cJeVR4nov6+c2ABb6MO5qENT9k=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [RFC v2 00/21] mm: thp: lazy PTE page table allocation at PMD split
Date: Thu, 26 Feb 2026 03:23:29 -0800
Message-ID: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: em5qurmj1is9zgeiz5wqg9npw4qczeq5
X-Rspam-User: 
X-Rspamd-Queue-Id: 6000C8000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1772105584-641722
X-HE-Meta: U2FsdGVkX1+Tfjip3r1FxHJL09Ai+hz8sZw8obKjQOJZwdauZnaGdzUxG9shudEZrLbTEBQO1/Orxa67X9sDQkTaMQnJ8qlcTF4H8M2G/tIHHfm/QiaFOQr6/ARjWs0qp4NcWJHqsncvrVegldEJ82qzNxFW05GArjvmSuwkH0Ia52CJGBuOeEjifEET2AyfKSBoZLCDGXTZ3v1FgwYj08PYHkGX6hLB+IuTHtCvOKCt6NJcZCTy0ALoPf5RGv3ukKwdNNmHDhEKV7ZoZl7jIoUTinScoeM2k1NgmGTYbYN59mSAYQd53Ui9FLs8I2EH7wH4COT5vXhrexLKH2lVf6kthhMb8jDJU8TAgAvXxYk/8MwcVLTIy3PNxhLqXLfY13Wqr9DXMaWnKvSRPkTvzGWnLdgeUFviAmWU7ZJ5VKJnwkF66l2eosZ6Xg6CPNrlRLlOP3iOmGQEnRpR5tB6TOBv6vYykukvAuZxUBqcMtQhmWJVwb824f6AQZqwyXupHBqTGRFuSRXKjyFjpctkv6TiBmrIYkpmjlqjdwDj13CvuiXqfGzkEAxMph2bbRnsd5mtQz43nf8yMnuu9IrSab2zxZfMm2ggZIeAbF5xs7D6La7kKOS9fBeFGWfBfbBDZ/X3Nsu6mP9LAMIMHRQe1+6vMkEZPdRGas6DMHwlEFrs2qAJZDxZPDYmnYj5avvhGUQJCJTlk7lNLVXz+xKyYjEXTcTVAx0lI1xEtiBD+KAUbK1Pb0UBSPSkuQFnx0XC69GuywAEbwSoQ/SRTMQSKxsNcXa8HXVi+xRZ38oihjjZDRUGlZd9nr101nVVMWFmUTyOYVPH/SADG2ZT4ryaoTNCG3UpccUbb5LNoy0NzN+xKXkcy3lc++WNrtaCXObFZE8PRzDJbfJo1en+QeZ6qGaZzbStdjj0ygCcQczihxd+P0ElY3b89wuAxFHqN0ucRC4zQQtSs+81km+QgvG
 FAX617/n
 eeIMNvoNvkwxjElwUboPX/Ia6YMp3TL1DQkHw6I/22SNehNXSKTZ1FNrfZv9QjY0Mnn+/25uTRhYIC8poCoJuQAKNCexllKSvnGilhN0dmPPnNl6khlInG8YO88SaVNnbgAJKcQX3PSwi9kyt+M+qNGCQPUYx2DJzSFeVX1GlnGL2kPwUeTg+UTC+cWX8Upf2KsI/uWq82++079NEL0/10kKt5gcawmDYDOJ8Atqina+xwrEoTA5RollsiY/4/ncA8lnc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the kernel creates a PMD-level THP mapping for anonymous pages, it
pre-allocates a PTE page table via pgtable_trans_huge_deposit(). This
page table sits unused in a deposit list for the lifetime of the THP
mapping, only to be withdrawn when the PMD is split or zapped. Every
anonymous THP therefore wastes 4KB of memory unconditionally. On large
servers where hundreds of gigabytes of memory are mapped as THPs, this
adds up: roughly 200MB wasted per 100GB of THP memory. This memory
could otherwise satisfy other allocations, including the very PTE page
table allocations needed when splits eventually occur.

This series removes the pre-deposit and allocates the PTE page table
lazily — only when a PMD split actually happens. Since a large number
of THPs are never split (they are zapped wholesale when processes exit or
munmap the full range), the allocation is avoided entirely in the common
case.

The pre-deposit pattern exists because split_huge_pmd was designed as an
operation that must never fail: if the kernel decides to split, it needs
a PTE page table, so one is deposited in advance. But "must never fail"
is an unnecessarily strong requirement. A PMD split is typically triggered
by a partial operation on a sub-PMD range — partial munmap, partial
mprotect, partial mremap and so on.
Most of these operations already have well-defined error handling for
allocation failures (e.g., -ENOMEM, VM_FAULT_OOM). Allowing split to
fail and propagating the error through these existing paths is the natural
thing to do. Furthermore, split failing requires an order-0 allocation for
a page table to fail, which is extremely unlikely.

Designing functions like split_huge_pmd as operations that cannot fail
has a subtle but real cost to code quality. It forces a pre-allocation
pattern - every THP creation path must deposit a page table, and every
split or zap path must withdraw one, creating a hidden coupling between
widely separated code paths.

This also serves as a code cleanup. On every architecture except powerpc
with hash MMU, the deposit/withdraw machinery becomes dead code. The
series removes the generic implementations in pgtable-generic.c and the
s390/sparc overrides, replacing them with no-op stubs guarded by
arch_needs_pgtable_deposit(), which evaluates to false at compile time
on all non-powerpc architectures.

The series is structured as follows:

Patches 1-2:    Error infrastructure — make split functions return int
                and propagate errors from vma_adjust_trans_huge()
                through __split_vma, vma_shrink, and commit_merge.

Patches 3-12:   Handle split failure at every call site — copy_huge_pmd,
                do_huge_pmd_wp_page, zap_pmd_range, wp_huge_pmd,
                change_pmd_range (mprotect), follow_pmd_mask (GUP),
                walk_pmd_range (pagewalk), move_page_tables (mremap),
                move_pages (userfaultfd), and device migration.
                The code will become affective in Patch 14 when split
                functions start returning -ENOMEM.

Patch 13:       Add __must_check to __split_huge_pmd(), split_huge_pmd()
                and split_huge_pmd_address() so the compiler warns on
                unchecked return values.

Patch 14:       The actual change — allocate PTE page tables lazily at
                split time instead of pre-depositing at THP creation.
                This is when split functions will actually start returning
                -ENOMEM.

Patch 15:       Remove the now-dead deposit/withdraw code on
                non-powerpc architectures.

Patch 16:       Add THP_SPLIT_PMD_FAILED vmstat counter for monitoring
                split failures.

Patches 17-21:  Selftests covering partial munmap, mprotect, mlock,
                mremap, and MADV_DONTNEED on THPs to exercise the
                split paths.

The error handling patches are placed before the lazy allocation patch so
that every call site is already prepared to handle split failures before
the failure mode is introduced. This makes each patch independently safe
to apply and bisect through.

The patches were tested with CONFIG_DEBUG_ATOMIC_SLEEP and CONFIG_DEBUG_VM
enabled. The test results are below:

TAP version 13
1..5
# Starting 5 tests from 1 test cases.
#  RUN           thp_pmd_split.partial_munmap ...
# thp_pmd_split_test.c:60:partial_munmap:thp_split_pmd: 0 -> 1
# thp_pmd_split_test.c:62:partial_munmap:thp_split_pmd_failed: 0 -> 0
#            OK  thp_pmd_split.partial_munmap
ok 1 thp_pmd_split.partial_munmap
#  RUN           thp_pmd_split.partial_mprotect ...
# thp_pmd_split_test.c:60:partial_mprotect:thp_split_pmd: 1 -> 2
# thp_pmd_split_test.c:62:partial_mprotect:thp_split_pmd_failed: 0 -> 0
#            OK  thp_pmd_split.partial_mprotect
ok 2 thp_pmd_split.partial_mprotect
#  RUN           thp_pmd_split.partial_mlock ...
# thp_pmd_split_test.c:60:partial_mlock:thp_split_pmd: 2 -> 3
# thp_pmd_split_test.c:62:partial_mlock:thp_split_pmd_failed: 0 -> 0
#            OK  thp_pmd_split.partial_mlock
ok 3 thp_pmd_split.partial_mlock
#  RUN           thp_pmd_split.partial_mremap ...
# thp_pmd_split_test.c:60:partial_mremap:thp_split_pmd: 3 -> 4
# thp_pmd_split_test.c:62:partial_mremap:thp_split_pmd_failed: 0 -> 0
#            OK  thp_pmd_split.partial_mremap
ok 4 thp_pmd_split.partial_mremap
#  RUN           thp_pmd_split.partial_madv_dontneed ...
# thp_pmd_split_test.c:60:partial_madv_dontneed:thp_split_pmd: 4 -> 5
# thp_pmd_split_test.c:62:partial_madv_dontneed:thp_split_pmd_failed: 0 -> 0
#            OK  thp_pmd_split.partial_madv_dontneed
ok 5 thp_pmd_split.partial_madv_dontneed
# PASSED: 5 / 5 tests passed.
# Totals: pass:5 fail:0 xfail:0 xpass:0 skip:0 error:0

The patches are based off of 957a3fab8811b455420128ea5f41c51fd23eb6c7 from
mm-unstable as of 25 Feb (7.0.0-rc1).


RFC v1 -> v2: https://lore.kernel.org/all/20260211125507.4175026-1-usama.arif@linux.dev/
- Change counter name to THP_SPLIT_PMD_FAILED (David)
- remove pgtable_trans_huge_{deposit/withdraw} when not needed and
  make them arch specific (David)
- make split functions return error code and have callers handle them
  (David and Kiryl)
- Add test cases for splitting

Usama Arif (21):
  mm: thp: make split_huge_pmd functions return int for error
    propagation
  mm: thp: propagate split failure from vma_adjust_trans_huge()
  mm: thp: handle split failure in copy_huge_pmd()
  mm: thp: handle split failure in do_huge_pmd_wp_page()
  mm: thp: handle split failure in zap_pmd_range()
  mm: thp: handle split failure in wp_huge_pmd()
  mm: thp: retry on split failure in change_pmd_range()
  mm: thp: handle split failure in follow_pmd_mask()
  mm: handle walk_page_range() failure from THP split
  mm: thp: handle split failure in mremap move_page_tables()
  mm: thp: handle split failure in userfaultfd move_pages()
  mm: thp: handle split failure in device migration
  mm: huge_mm: Make sure all split_huge_pmd calls are checked
  mm: thp: allocate PTE page tables lazily at split time
  mm: thp: remove pgtable_trans_huge_{deposit/withdraw} when not needed
  mm: thp: add THP_SPLIT_PMD_FAILED counter
  selftests/mm: add THP PMD split test infrastructure
  selftests/mm: add partial_mprotect test for change_pmd_range
  selftests/mm: add partial_mlock test
  selftests/mm: add partial_mremap test for move_page_tables
  selftests/mm: add madv_dontneed_partial test

 arch/powerpc/include/asm/book3s/64/pgtable.h  |  12 +-
 arch/s390/include/asm/pgtable.h               |   6 -
 arch/s390/mm/pgtable.c                        |  41 ---
 arch/sparc/include/asm/pgtable_64.h           |   6 -
 arch/sparc/mm/tlb.c                           |  36 ---
 include/linux/huge_mm.h                       |  51 +--
 include/linux/pgtable.h                       |  16 +-
 include/linux/vm_event_item.h                 |   1 +
 mm/debug_vm_pgtable.c                         |   4 +-
 mm/gup.c                                      |  10 +-
 mm/huge_memory.c                              | 208 +++++++++----
 mm/khugepaged.c                               |   7 +-
 mm/memory.c                                   |  26 +-
 mm/migrate_device.c                           |  33 +-
 mm/mprotect.c                                 |  11 +-
 mm/mremap.c                                   |   8 +-
 mm/pagewalk.c                                 |   8 +-
 mm/pgtable-generic.c                          |  32 --
 mm/rmap.c                                     |  42 ++-
 mm/userfaultfd.c                              |   8 +-
 mm/vma.c                                      |  37 ++-
 mm/vmstat.c                                   |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 .../testing/selftests/mm/thp_pmd_split_test.c | 290 ++++++++++++++++++
 tools/testing/vma/include/stubs.h             |   9 +-
 25 files changed, 645 insertions(+), 259 deletions(-)
 create mode 100644 tools/testing/selftests/mm/thp_pmd_split_test.c

-- 
2.47.3


