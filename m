Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 426BAC531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A28A6B00A2; Fri, 24 Jul 2026 18:30:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62AF66B00A5; Fri, 24 Jul 2026 18:30:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2A96B00A3; Fri, 24 Jul 2026 18:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11BD16B00A1
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:30:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 88159801CC
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:22 +0000 (UTC)
X-FDA: 85025115084.30.E84126C
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0855C2000C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=AEC4+FLH;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784932221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RVEpjv/H21i1kvDmlUlr5Y1tQvJuokGGfGvinQ9yGGM=;
	b=GSX4q5xFIFevTm6lavsl7nsila4lM3ckfiIgLb4WlHxV7OtNrClKshe22ZcWljI/t0phYy
	cyUfz6GiSguaI84ryWosc2kv0ohh2mVZqEYUZR7SBfIqZva2NIs2cl8V8J6CrFHoI5RY5G
	wktmh6kRuDSA2EL2vpRc20Htm0l7hSE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784932221;
	b=uugrncbVsKmzIo9kRHXUyxSfsI2MBl5DcaE9KVij/8VmV9nM/rt1m6TDM/PN54Ij848kAN
	yzOWs6eM9m/EsKwcHVQuKNS7P6E8aCy9vV+LMbNZ5b508JmcQ3W01zgDG6ltvna7JGqMHP
	D6dX/hsKf1qviInD2Focwh9gmUvuhDE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=AEC4+FLH;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RVEpjv/H21i1kvDmlUlr5Y1tQvJuokGGfGvinQ9yGGM=; b=AEC4+FLHIrLZakwloUISbyLmLz
	cv/C4wtjoemkX4OAjtCIFQbIK/5H5akAmjOh71ZrTZ6NCDF37NhNVTiYHPrioufPeKfgpqiJgfYK0
	kI3vryoxO7OzuOi1FVM2YKwR6OlS7mV6KB7YZGb9GmaWRZ9BsCPs7A2XYe1hM0sbkdxL1uaTsPJX4
	DJd/C4GdWO0BPdmV/hhDOShFemyelfUHW1dXgGUZke/r5eyNUsp/rthLFMmGpzAVpTCUufX26SXY8
	XBdBIhKldSp5PZLoG2HZySh1L8Ap2pUY/YjwulYa5dCxuD3beG1gg6uTjUcdEWbz7hZ319f79OxqD
	eU1eNjKQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wnOOs-0000000027h-0VDa;
	Fri, 24 Jul 2026 18:29:50 -0400
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH RFC v4 0/12] mm: use per-VMA lock in __access_remote_vm for improved monitoring reliability
Date: Fri, 24 Jul 2026 18:29:22 -0400
Message-ID: <20260724222934.1463812-1-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ntciustd7g4awphnz95ps7t3iw85q18f
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0855C2000C
X-HE-Tag: 1784932220-797929
X-HE-Meta: U2FsdGVkX1800IW7as/YYunOMR61Dakl3fLMYnblbKFO9T5coxvrnD7HS21cAJMKgcUqFti81FrAEPyLNo4JeZy/0AZVA7lc8u6NrX8eGLHR0HvQrshjZocxfN+d+KJJivCwStQ81poXmRpa8bb7tW2X1NgfnCr/UI78bztZI3x80Sks9YLuf+hk9mhjN6x5w1QlliOb2tPN0g8LjOENCexSev+yddy9ofjwyhwcGaDPd6w1bZybT+HIChMq5VOa1EKskJpYZ3+kTJ2PBNI1VhOl7BptUImLzKW8zO50a1kmvB82FI1xkIfjgfpzXROJAS/Iam3+UF/iAyA6pPc43E6yYfOdvEQPBNls7lEHkR1Yu7UYj2mDgjoifjlp68r0nYIjhsqyqP0HQaaTQnXGp7bUVbp0BBKcm7JoNViqdKaXNseirx6l99lHC18y8LKHeym1CNiqhY5ToV8RTlP9/NgwY+WzJkqLceZfXa2at2CkQ7DWVVJ633Lj3zd7r3iAZJqrMNQRTKbaAmKZjS7oIRdnB3BtwumIeqG4/PQZC+jvIXGNbanrL5ikeWD+yD0S/j6LxtAtUtc/ONX85UAnj9E/IJSvfr3HG3PdJjBj+p78bJLAQp6oKTnI/eDgS0RwyTK98YwEErA4HuNyot+AUBN1gtXyCN8D8bvSoi4gb1pGPTY/T6ILwQIsPDdq34h86WAaH8UY/f9WyZaudO3GCRxvsysFaaHluI9/VW5RzU9E1lpquA37CwbAALS5k3jsst2rxUSAnIKFirl919WYM/EYv++VoHy1lWkuYzWThfyPDsLlyT3rukPd7Xzr6Gp2q7SKZ6jM3a00HPoyj0pC42VVlJ1McKHZfbsGrLBB/mJI6T4tZqWnVxWwfTJxx7Dp30y7MX00VEonPo7k/vtq2reQ4+QJHPCCbQ17EBLgtubdEPsCYpjfs433uYNa7JSk/nuuiSbPYlWNsXzqXeR
 2WYOBUwu
 oHHaPqT7lpA+PJTRKwnKOjoqGzomzOBO5U6LgI0nsRmhKE/QuPn0eP18FAAfZJiZo7WK2BOs4SaOn5auJhTnXTXBcowXu64D1b5MbX/twysz6s1uMbOJzuWfCuV4vjJ0fl72CKR0lEN1rt8VHbbQLBosM+ftr/FtMOd7C1kaW0sRCRcN34H/b/nDdIEZWU3KaftdzKeHT/fLCr5TpucC2ibN+jwoTdCoy4FdYvQwvnPu/UgTBf+fXMlogfxnshL82gDg2ly2jnnJTcfIKOxDrkrJ198VeIekYg1ey3oE2NhZj3rPu7NDTnE63lUvGiS/FCW1r8fxK8zLuv/uQ4yGBsdx03Q2CIEocLYLqJhgvT4E7Vvm7/Z/lsEkf5UfOl/F9S5VnbLhGlbd0MzVOivYmaOjLolVrl+OeGQJEWpSCRBBdn8nbbXQWJqCbdY94MJMuvDYEcCv3H5OLPeTZyCAqkZAOhZmun/CEi7fyLNkjVAMGzsCJ3dKTVr2WsktXSKkJ6P4I/MO5h4QicuvkGAwyvhK8xPHyv72nhu5XKxuqYG0yURSxjoUoGXE2Sswr6yOk7zr4AArNJ/K3LbuIrvDTHuHy0xtYqetfrvbvVpfH8HM1oLLpsFxPNNoGYEIZ09F9M40Un2q+BeIgUsC2NjUnMBEAe3ZIuLK9Cn4RwclH62FzDGVFzgSyhTVWLrk1sihGdMoDNqqWIF4XIf7EJAeJ/zZ2rsNBlLuwHeIRIwaQvNrCFX+3h4QC+5D+im1XiKQkLBqC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__access_remote_vm() holds mmap_read_lock() for the whole transfer. On
large machines, with large multi-threaded applications, the mmap_lock
is often contended, leading to things like reads of /proc/PID/cmdline
stalling.

This results in system monitoring tools getting stuck, right when
system information would be the most helpful.

That problem can be avoided by having __access_remote_vm() access
user memory under the per-VMA lock. The old code also looks up
the VMA for every page accessed, and walks the page tables for
every page inside a large folio. Cleaning that up speeds things
up nicely.

Using code that does not include its own lock dance, and does not
look up the VMA twice results in a modest speedup.

	read size   baseline    per-VMA     throughput
	8 B          201.7 ns    170.6 ns    ~15% faster
	4 KB         495 ns      442 ns      +12% (8266 -> 9265 MB/s)
	64 KB       4115 ns     3355 ns      +23% (15927 -> 19536 MB/s)
	1 MB       75902 ns    63641 ns      +19% (13815 -> 16477 MB/s)

The multi-threaded reader-versus-writer contention that motivates the lock
is not measured.

The rest of the series builds on this to batch per-VMA GUP. Patches 9-12
have follow_page_mask() report a contiguous PTE-mapped run of a large
folio, so the slow pin_user_pages() path walks it once instead of per page.
Other paths that walk a range benefit too.

That batching pays off on PTE-mapped mTHP. With mm/gup_test.c
(PIN_LONGTERM_BENCHMARK, the slow pin_user_pages() path) on a 256 MB
MADV_HUGEPAGE region in a 4 CPU VM, median get time over 16 iterations:

	gup_test -L -m 256 -n 65536 -r 16 -t
	                      before      after
	64 kB mTHP            3140 us      412 us   (7.6x)
	2 MB THP (control)      78 us       76 us
	4 kB base (control)   3010 us     3042 us

The PMD-mapped 2 MB THP already returns in one step, so only the PTE-mapped
large folio case improves.

Reaching a page under the per-VMA lock means looking up the VMA first,
which needs to untag the remote address without the mmap lock. The untag
masks (x86 LAM, riscv pointer masking) change only while the target is
single-threaded, so a remote reader races at most one such change.

Those masks are already read locklessly elsewhere, so patches 1 and 2 add
untagged_addr_remote_unlocked() helpers with READ_ONCE()/WRITE_ONCE()
annotations. A stale read sees the old or new mask, never a torn value, and
the remote untag is best-effort.

With the VMA in hand we need one page from it under the lock the caller
already holds. get_user_pages_remote() does not fit: it hard codes the mmap
lock and re-derives the VMA internally.

Rather than reimplement GUP in yet another caller, this version follows
David Hildenbrand's v2 guidance: start from a proper GUP interface that
takes a locked VMA, not an mm, and decide which faults can resolve under
the VMA lock.

Patch 3 renames get_user_page_vma_remote() to get_user_page_lookup_vma() to
free the name. Patch 5 adds get_user_page_vma(): a simplified
__get_user_pages() that walks the tables with follow_page_mask(), faults a
missing page in with faultin_page(), and returns it with a reference and
the caller's lock still held.

Like __get_user_pages() it runs check_vma_flags(), so callers need not
pre-check the VMA.

A VM_IO or VM_PFNMAP VMA is the exception: a COWed page with a struct page
is returned normally, while a raw PFN yields -EFAULT so the caller can
reach vma->vm_ops->access(). The caller sets FOLL_VMA_LOCK when it holds
the per-VMA lock, which reaches the fault code as FAULT_FLAG_VMA_LOCK.

Anything the per-VMA lock cannot finish releases the lock and returns
-EAGAIN, so the caller retries under the mmap lock: a dropped fault, a
userfaultfd VMA (which assumes current is the faulting task), a hard error,
or ->access() memory. faultin_page() reports the retry the same way for
both lock types.

__access_remote_vm() then uses the per-VMA lock when an access fits within
one VMA, and falls back to the mmap lock for multi-VMA accesses, stack
expansion, or an -EAGAIN from get_user_page_vma().

Walking page tables under only the per-VMA lock is safe against both page
table freeing and THP collapse. munmap() frees a VMA's page tables under
the VMA write lock that our read lock excludes, so they cannot be torn down
under the walk.

THP collapse needs neither lock: it retracts a PTE page under the page
table lock and frees it by RCU.

follow_page_pte() takes that same lock through pte_offset_map_lock() and
rechecks the pmd, so it either walks an intact table or sees the collapsed
pmd and faults the page in, while RCU keeps the retracted page valid.

A COWed page in a VM_PFNMAP mapping was previously unreachable through
/proc/pid/mem because generic_access_phys() rejects ioremaps of RAM. With
get_user_page_vma() returning the struct page directly, that read now
succeeds, which the new selftests cover along with the raw PFN path.

Thanks to Suren for pointing out the need, to David for pushing me
to just rework the whole area, to Usama for reviewing the arch patches,
and Lorenzo for the changelog and cover letter cleanups.

There is a lot more work that could be done in this area, but the
patch series is big enough. More changes can come in follow up work.
---
 arch/arm64/kernel/mte.c                        |   2 +-
 arch/riscv/include/asm/mmu_context.h           |   4 +-
 arch/riscv/include/asm/uaccess.h               |  10 +-
 arch/riscv/kernel/process.c                    |  12 +-
 arch/x86/include/asm/mmu_context.h             |   6 +-
 arch/x86/include/asm/uaccess_64.h              |  15 +-
 arch/x86/kernel/process_64.c                   |   4 +-
 arch/x86/kernel/uprobes.c                      |   2 +-
 include/linux/mm.h                             |  32 +--
 include/linux/uaccess.h                        |   7 +
 mm/gup.c                                       | 360 ++++++++++++++++++-----
 mm/internal.h                                  |   8 +-
 mm/memory.c                                    | 379 +++++++++++++++++--------
 mm/rmap.c                                      |   2 +-
 tools/testing/selftests/mm/Makefile            |   1 +
 tools/testing/selftests/mm/mthp_gup_cow_test.c | 213 ++++++++++++++
 tools/testing/selftests/mm/pfnmap.c            |  66 +++++
 tools/testing/selftests/mm/run_vmtests.sh      |   1 +
 18 files changed, 887 insertions(+), 237 deletions(-)

base-commit: 248951ddc14de84de3910f9b13f51491a8cd91df
---
To: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Rik van Riel <riel@surriel.com>

REVIEWERS NOTES:
Series based on the current Linus tree (v7.2-rc5, commit 248951ddc14d).
Patches 1-8 add per-VMA lock remote access; patches 9-12 batch per-VMA GUP
over PTE-mapped large folios.

Changes since v3 (RFC v3, 2026-07-17):
https://lore.kernel.org/all/20260717170036.743149-1-riel@surriel.com/

- Address Usama Arif's v3 review:
  - p1: correct the Acked-by address to usama.arif@linux.dev.
  - p2: rewrite the riscv changelog to describe only this patch's change,
    and replace the false "pmlen is stable" claim with the accurate story
    (pmlen may change until MM_CONTEXT_LOCK_PMLEN; READ_ONCE avoids a torn
    value, and the remote untag is best-effort).
  - p3: fix the "name space" typo and note "No functional change intended."
  - Split the check_vma_flags() ignore-flags change into its own prep patch
    (patch 4) so the PROT_NONE PFNMAP read hole fix is bisectable, keeping
    the VM_READ / FOLL_FORCE / arch-key checks for a PFNMAP VMA.
  - get_user_page_vma(): add the flush_anon_page()/flush_dcache_page() cache
    flushes __get_user_pages() does, and reword the faultin_page() kerneldoc
    to cover the per-VMA lock, not just the mmap lock.
- New patch 7: read remote strings (bpf_copy_from_user_task_str()) under the
  per-VMA lock, extending the approach to __copy_remote_vm_str().
- Factor __access_remote_vm() and the string reader onto a shared
  remote_vm_walk() helper, and fix a NUL-termination regression it exposed:
  the partial buffer is now terminated on a mid-walk error.
- Fold the mTHP GUP batching (patches 9-12), previously a separate follow-up,
  into this series; the cover letter now carries its gup_test numbers.
- Correct two changelog claims. The page table lock plus the pmd recheck, not
  the VMA write lock, guards the walk against concurrent THP collapse; RCU
  only keeps the retracted PTE page valid, and the VMA write lock excludes
  munmap(). The x86 untag mask changes while the target is single-threaded,
  so the lockless read is best-effort, not "set once and never changes."
- Rebase onto the current Linus tree (v7.2-rc5).

