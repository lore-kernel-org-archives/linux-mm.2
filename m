Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 578A510A1E63
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7C26B008A; Thu, 26 Mar 2026 22:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBFAB6B008C; Thu, 26 Mar 2026 22:14:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFCE36B0092; Thu, 26 Mar 2026 22:14:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7D06B008A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:14:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F7AE1A0F7C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:14:17 +0000 (UTC)
X-FDA: 84590223354.16.54DAFA2
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id B74F81C000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:14:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VUFU+eLw;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gq6tDrxRofpN6+43DO4pHo2Q1I5IOP1Q0YNLsagiUNI=;
	b=G8t1cd0uO30zk49ikufC7Va3J92NhkZ2tGmJf8yy9R6N908ETQxBpbr/1Bl1wsIaoyDuWW
	7VUOuQv5+Z90IEWx8OpAUL3ro/Cyz+hcRE+Y73sa4a0z1N04RsJ2dnQ2T1rr2iTJyIVAvA
	sEPg3VGp+RHuhiIH4g32P5q28z3p3j4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VUFU+eLw;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577655; a=rsa-sha256;
	cv=none;
	b=vSdLBPDlQBAe6M6IikjxXcb35ww/qGd3ba4s98O2ZV/PgAsXTW3dQiHe1BJ39Xh5RjXdQw
	QRasA3+EbwJrDrMMXkxYpX863eFZC4sxRioO6OWz5souuPFBPqv/1YaNSdr2wzm3d6apq2
	36O8cacQwQoD7lRF6/gPAUz9cCk218c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gq6tDrxRofpN6+43DO4pHo2Q1I5IOP1Q0YNLsagiUNI=;
	b=VUFU+eLwBHZnCPCULhR3UiCG+mPLv3VmPsoMvQwjSw9IWmiWbGwuqsAtcYuN4fo3wd7f7w
	Tc/IkWLPWH4pZrCRj+4GCIAqRfFJq8dsdmTP7e5SMVyyryroVjX046opVWlz5P3JjcqDR0
	IPgagIj1g1KpLo1sApRx8TxcJV1nKXU=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
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
Subject: [v3 00/24] mm: thp: lazy PTE page table allocation at PMD split time
Date: Thu, 26 Mar 2026 19:08:42 -0700
Message-ID: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B74F81C000A
X-Stat-Signature: bhps3w6d7o38rmddbpd7udkx4tq78cdi
X-Rspam-User: 
X-HE-Tag: 1774577653-107862
X-HE-Meta: U2FsdGVkX18jfQbZ7W5/9GJDEfZytUh6DfVqd3EBqJ3JybTpP9EMU/Z5mBwVX1qP174D/+GA4vjdW/PhWw/yQRhSwC17XhsJasfPoXoS49TgXCSU8eRgIsu9MJ+xbt9BrfYW40/pZ7fKTRplEwoE94Xrn0GTrTS9+03UPmZp/NsDkQZVOjsfOYjxh6kgogCN4dUa/jWIStIOYVZKXom3EBBGnjWTGEpYpf6YaKj98/dVptM+zzLw5LDVhYV5VDmTcZZDhvR4Pn1RbxL3sDwhDuuuJp/z+LC6W97yJ+mcGiXmSj1VtYK0ainl7m+5BzK2CpJazXUKwt6i9JUDbn0cZtp7VQu2XyVtVZzRFak69nQdjtseCA+o2gEMmy4trgfqgATNHOzfekripsvDNPd69H/fDa3y/JTBQ7q+DnBnHGguWq/3SkZtBrJnQv+CCre8nelLmkqJMs57xjJYMklt0paDS/EhrjJ1q81laVDLFCnP2m05te3NTT7L/ZGu61ROkkTNrYzan5q+/tw73WifOFgBRUub4hSMPaBb/joEL3BFcsZEXoSesunizcFrEuY+8ptUJ4ZUsIPOercASqz1VOg+CWk3HdXNLy7VOFCJRrkzW82w74cMSzzIlcy5BJDNiLXgrU0eN4fbPsZBFQXtbIaSPsbXlprLpyV4OeivxlqdRQQKI6Wq0bMqWQPJofpIeuxjlBNKytL14tu62MyjWFb5i86v4vPdZSzssT4oSfPQydcsE5kDzAqgocKYKH3mor0c3P5tcmEeAB/5nSkUV37j+Tk8fzHf+P1OcHZHgnvW7GyB+mxjDY3O1tq1RZJ/uzgMqCdoOR3xrgHxIK6xB744sUBDZy38ae7OEaDe1o5qy4iT/5opEF7c6pXCFouIbU8vCxLRPsFdmUr4B+XRpc7Ngu8DAWf9XHnmOh+7Bl14W/d35pOdbebKTtiTxxfWoUy6Zz16yXCpxAxzuPg
 ZvyiXD7o
 46/C7bb8YtNTgOGNOrY6M/KtQuMr0D3npsAfX1MTCV5PaOHAmGiV+8AiFGH2bL+FW2PaC0W0BX8K1yKo0text9YLnV20LMOPfXnS1EbKozjWKJzeUlYoZ1cQbISV9MF5fJPwGcMwTGvXXQrO4f5qNHEWLpzvCdg1ZWU3g1WVwgWlMk2OOYNKGrJ1yP72l/k9KmHiZXpwzdqqYcvn9iOZPsryevfQ6+3xdPT+45rA4PrgFvGqLPxHC0yKRwqpsOKy+sMPb
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
mprotect, COW on a pinned folio, GUP with FOLL_SPLIT_PMD, and similar.
All of these operations already have well-defined error handling for
allocation failures (e.g., -ENOMEM, VM_FAULT_OOM). Allowing split to
fail and propagating the error through these existing paths is the natural
thing to do. Furthermore, if the system cannot satisfy a single order-0
allocation for a page table, it is under extreme memory pressure and
failing the operation is the correct response.

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

Patches 1-2:    Infrastructure — make split functions return int and
                propagate errors from vma_adjust_trans_huge() through
                __split_vma, vma_shrink, and commit_merge.

Patches 3-15:   Handle split failure at every call site — copy_huge_pmd,
                do_huge_pmd_wp_page, zap_pmd_range, wp_huge_pmd,
                change_pmd_range (mprotect), follow_pmd_mask (GUP),
                walk_pmd_range (pagewalk), move_page_tables (mremap),
                move_pages (userfaultfd), device migration,
                pagemap_scan_thp_entry (proc), powerpc subpage_prot,
                and dax_iomap_pmd_fault (DAX). The code will become
                effective in Patch 17 when split functions start
                returning -ENOMEM.

Patch 16:       Add __must_check to __split_huge_pmd(), split_huge_pmd()
                and split_huge_pmd_address() so the compiler warns on
                unchecked return values.

Patch 17:       The actual change — allocate PTE page tables lazily at
                split time instead of pre-depositing at THP creation.
                This is when split functions will actually start returning
                -ENOMEM.

Patch 18:       Remove the now-dead deposit/withdraw code on
                non-powerpc architectures.

Patch 19:       Add THP_SPLIT_PMD_FAILED vmstat counter for monitoring
                split failures.

Patches 20-24:  Selftests covering partial munmap, mprotect, mlock,
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

The patches are based off of mm-unstable as of 25 Mar
git hash: d6f51e38433489eb22cb65d1bf72ac7993c5bdec

RFC v2 -> v3: https://lore.kernel.org/all/de0dc7ec-7a8d-4b1a-a419-1d97d2e4d510@linux.dev/
- Rebased on top of mm-unstable as of 25 Mar.
- handle split_huge_pmd failure in pagemap_scan
- handle split_huge_pmd failure in subpage_prot
- handle split_huge_pmd failure in dax_iomap_pmd_fault (cannot
  actually fail for file-backed DAX, but needed for __must_check
  compliance)
- Added a folio_put(folio) on the split failure path in
  migrate_vma_split_unmapped_folio() (Nico Pache)
— Added #if defined(CONFIG_TRANSPARENT_HUGEPAGE) guards
  around THP_SPLIT_PMD_FAILED vmstat counter.

Usama Arif (24):
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
  mm: proc: handle split_huge_pmd failure in pagemap_scan
  powerpc/mm: handle split_huge_pmd failure in subpage_prot
  fs/dax: handle split_huge_pmd failure in dax_iomap_pmd_fault
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
 arch/powerpc/mm/book3s64/subpage_prot.c       |  24 +-
 arch/s390/include/asm/pgtable.h               |   6 -
 arch/s390/mm/pgtable.c                        |  41 ---
 arch/sparc/include/asm/pgtable_64.h           |   6 -
 arch/sparc/mm/tlb.c                           |  36 ---
 fs/dax.c                                      |   9 +-
 fs/proc/task_mmu.c                            |   6 +-
 include/linux/huge_mm.h                       |  51 +--
 include/linux/pgtable.h                       |  16 +-
 include/linux/vm_event_item.h                 |   1 +
 mm/debug_vm_pgtable.c                         |   4 +-
 mm/gup.c                                      |  10 +-
 mm/huge_memory.c                              | 222 +++++++++-----
 mm/khugepaged.c                               |   7 +-
 mm/memory.c                                   |  26 +-
 mm/migrate_device.c                           |  39 ++-
 mm/mprotect.c                                 |  11 +-
 mm/mremap.c                                   |   8 +-
 mm/pagewalk.c                                 |   8 +-
 mm/pgtable-generic.c                          |  32 --
 mm/rmap.c                                     |  46 ++-
 mm/userfaultfd.c                              |   8 +-
 mm/vma.c                                      |  37 ++-
 mm/vmstat.c                                   |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 .../testing/selftests/mm/thp_pmd_split_test.c | 290 ++++++++++++++++++
 tools/testing/vma/include/stubs.h             |   9 +-
 28 files changed, 685 insertions(+), 282 deletions(-)
 create mode 100644 tools/testing/selftests/mm/thp_pmd_split_test.c

-- 
2.52.0


