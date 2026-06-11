Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86484CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 12:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9DC6B008C; Thu, 11 Jun 2026 08:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6A6D6B0093; Thu, 11 Jun 2026 08:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7A96B0095; Thu, 11 Jun 2026 08:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 869126B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:07:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 113B5A059F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:07:28 +0000 (UTC)
X-FDA: 84867506976.18.0622291
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 54E6318000F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:07:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTjHrppD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781179646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mpo9K/yHuwdA4WDzy+FdMrRqAosDQHP1Qamg8TrPoyA=;
	b=0EqjZmQ4TzEG5SuiKADHWOb+4WB7A9Mr3W4DqSmWebgY5Y1FFf9hLvIvc23i/1LT92oEm6
	J1UODOKcSFCs39cMpJyuPWtwihJP0YwtnjbKK1n4KxsCIOek01hKarJddAuR/5DloI6/EC
	Xkjn4AGe/v7s+Vql9rgjlM+cVt8bwwc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTjHrppD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781179646;
	b=lb+Z6xRc3abnmz+/hUgIxQduFo5fB0oSWDybLMWC/70mDfJUEAt3wMxcnj/qd4f13cXBAk
	l61RvMeZfSpvSDoSsmoc/nhVYvNtM4wQkahw94jpvtCgtp96Vj8YDKLwo4WqaBr/l2/wgO
	ko1Ik1zOqTRr7o9Yvoa52Xw/OLbGzVI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF7AA6001D;
	Thu, 11 Jun 2026 12:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF95C1F00893;
	Thu, 11 Jun 2026 12:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781179645;
	bh=Mpo9K/yHuwdA4WDzy+FdMrRqAosDQHP1Qamg8TrPoyA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fTjHrppDapgKDRL0LBUP8mp9fKT+ZEnDbaEBY43L82kCM1EUiOe3jV5sNQ4YaX9NS
	 Nd9Esn/VPY2aLHoPaedL+phCobmBO31m5kQOSny9tP49yaVjHq9jjpIgJF8fYB3OrF
	 Zol78fmD0fR2DB+qFCZ48EbWWoPwWGp44F8z25f5ufYXShZysMvBtLEfkggW7hxPSC
	 993fUkkDolkjQnyWhlTaMVydLZSWx6otk9XN0j9PyZ+jtV9Y5kk+NAKuou7C70T/oy
	 CX7I8ij2BLSROPZjZMp4ODmaS3ZKf7OGMKH3kjSz9pCirOEkE2GC04f8WPoyY6NGnw
	 d1cET7QCgf6Ag==
Date: Thu, 11 Jun 2026 13:07:21 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 0/8] Implement a new generic pagewalk API
Message-ID: <aiqkyOCy2rf99wxg@lucifer>
References: <20260525165528.184397-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525165528.184397-1-osalvador@suse.de>
X-Rspamd-Queue-Id: 54E6318000F
X-Rspam-User: 
X-Stat-Signature: dhapt5ntsec4i9hy8yzbqmtxqdoyojr6
X-Rspamd-Server: rspam09
X-HE-Tag: 1781179646-85754
X-HE-Meta: U2FsdGVkX18y31sp8xHidumnpLL8la2FhSmBOpmzBjs25L+V70ryxbIiqB9tG8gK1MKIUMQKyYAwX6LbZiY8exc4+WAZbXa2gmbH0WLuEv8zR2CCBfaxONG9VoxqYdShRJPopzKVxffZp21SbRYxcwpdtGmQzw2s9xIv8pWNajqLb+B9whxJqpX7DMlUa6ZRMei02L1dSYiZzic2rV+HFn5JOWMjqfOhOzvIOALUEtTBpsH4UTblRboyVgqlQ0mgnCLY4HHHxIBqDugq+HU5evvM3ELyA0B34hpZBRfiMUb3IJsk0/CGY9rnl68nuMUxhQvK7S6bOn2/lxR64IxMI0o/Avfz3dq6msGe2gR2DMUMw+885dF3q725MP+oMcMRccyjdFEdU1BIUe5AiQ+JeO4Pn3xhfWPjns6+HHJnyYU+FEzP18trlP2v1o2QkmQoHBZjtl38l1fxsJSYXNHsbXQqHQKjFaitcrZY7G1bZwoX76dY08b5otiiGRUay/UKt/M68MNoZo+eS4AP3tEx1/up2Nln8ZBrAXZSvDpkZlK6QblECrdf1BqHNrcZKu1/fmqODssj9vhsVwexqMNpNbb3hB3MZLK3XAaadGuhfRY0cCaHDf4PL1mu5UEtdnJJJ78oPmH23vI9lSPoS8LlFzrFeoENLrDAzwIfQy63c2kq5/T76XzftQ/yPclxnp5GeczyEUf07wqF1B1+0nT0E9G3PnSJ4WwsFpZlIZaqOfksYv6Ekulaj2CqW0X/P+Cgys0FZCd1d8LNOlgSEzadcT1n7+IwBRcaNrzBccfbWU+r6Rcgp/6K9mqULLiVfBYz8OVLR/UA2Cu7Zpv9CsASn0mghrWjS9VlomkkmOXhJuGY6oBiGOFaFsfrb8KTn54RkRDugAURj3dPaWl2mKxGLZjpyC2Ca1+heBV45ghW5Jf+0xelYS8pngVmplyMrIeZR0zN3H4uiiPA1Nda3p8
 OciGeIil
 W1/KUEyc8WjOAq9eDfgG7hhRP6J7RKqKKHKSw57uCWFZUGb+vRN3rMgs7Dsi11DXoRsBwqDEQ7VKL/Sov8h1zepU74MxfxEfvwpAzPyjpAmD9Q8GNJ+FNizimnotRKgz+uLwN0LXCsWV4IJkAadEehFIBPyBzjpKt53LfziuZjvr1TE/X3vipFgu7U41FgviIlJf0zgLY9nUSXQdbljbeHq3lyOxaTQtbHIXePaADC0VlNAxaYDuEjeyhUghn34w/QeVzxvZOgUEVAqaKB/y5RMbCvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc wrong email

Sorry to be a pain but I only just noticed this because it's going to the
wrong email address :)

Could you make sure to send future revisions to ljs@kernel.org?

Thanks, Lorenzo

On Mon, May 25, 2026 at 06:55:20PM +0200, Oscar Salvador wrote:
> Changelog:
>  rfcv2 -> rfcv3:
>  - Fix an out-of-bounds write
>  - Convert clear_refs to the new API
>  - Fix issue when reading cont-PMDs
>  rfc -> rfcv2:
>  - Add pte_hole functionality
>  - Fix pagemap issues
>  - Fix shmem in smap
>  - Testing with pagemap "testsuite"
>
> [WARNING]
>
> This is not yet fully complete, but before investing more time into it I would like
> to know whether 1) this is heading into the right direction and 2) this is something
> we are still interested in.
> There are still things that need work:
>
> - convert make_uffd_wp_huge_pte: Since hugetlb is being dealt like a
>   pte, we inherited PTE_MARKERs for it when those came into play, and
>   AFAIK, those are being used mostly for UFFD.
>   From here on we have two options: 1) find another way to deal with
>   UFFD without markers or 2) introduce markers for PMD and PUD level.
>   I am leaning towards option 1), because 2) seems a bit unfair.
>   I still need to put some thought into it and see how we can achieve
>   that.
>
> - Teach the new API how to use other kind of locks. E.g: pagemap scan
>   needs to take i_mmap_lock during the scanning, so we need to able to
>   take that lock. I have some ideas to do that, but something for the
>   new version.
>
> - Find corner-cases and fix them.
>
>
> Kudos go to David, who was the person suggesting the interface and
> he gave me some ideas where to begin, besides providing feedback
> on early stages (in case there is something stupid don't blame him, blame me)
>
> Also, I would like to thank Vlastimil, who helped me running this
> patchset quite a few times through Claude, to catch some fixes.
>
> [/WARNING]
>
> [TESTING]
> Part of the testing has been to duplicate
> /proc/$$/(pagemap,smaps,numa_maps,clear_refs) and have the same with
> _lab extension linked to the old API.
> In that way I could check whether the outcome from e.g: /proc/$$/smaps
> and /proc/$$/smaps_lab was the same for any given program.
> The same I did for pagemap and numa_maps.
>
> Also, regarding pagemap:
> So far, tools/mm/page-types.c reports the right outcome (compared to the old API),
> and tools/testing/selftests/mm/pagemap_ioctl.c only reports 4 failing tests.
> Although to be honest, I do not how much should I trust that one because if I
> add a few delays in the userspace code, some tests that were failing before are not
> now, so yeah.
>
>  localhost:~/workspace # ./page-types -p 1168
>               flags     page-count       MB  symbolic-flags                     long-symbolic-flags
>  0x0000000000000800              1        0  ___________M_______________________________        mmap
>  0x0000000000000828              2        0  ___U_l_____M_______________________________        uptodate,lru,mmap
>  0x000000000000082c              1        0  __RU_l_____M_______________________________        referenced,uptodate,lru,mmap
>  0x0000000000004838              1        0  ___UDl_____M__b____________________________        uptodate,dirty,lru,mmap,swapbacked
>  0x000000000000086c            423        1  __RU_lA____M_______________________________        referenced,uptodate,lru,active,mmap
>  0x0000000000205828             29        0  ___U_l_____Ma_b______x_____________________        uptodate,lru,mmap,anonymous,swapbacked,ksm
>  0x000000000020586c              1        0  __RU_lA____Ma_b______x_____________________        referenced,uptodate,lru,active,mmap,anonymous,swapbacked,ksm
>               total            458        1
>
>  localhost:~/workspace # ./page-types_lab -p 1168
>               flags     page-count       MB  symbolic-flags                     long-symbolic-flags
>  0x0000000000000804              1        0  __R________M_______________________________        referenced,mmap
>  0x0000000000000828              2        0  ___U_l_____M_______________________________        uptodate,lru,mmap
>  0x000000000000082c              1        0  __RU_l_____M_______________________________        referenced,uptodate,lru,mmap
>  0x0000000000004838              1        0  ___UDl_____M__b____________________________        uptodate,dirty,lru,mmap,swapbacked
>  0x000000000000086c            423        1  __RU_lA____M_______________________________        referenced,uptodate,lru,active,mmap
>  0x0000000000205828             29        0  ___U_l_____Ma_b______x_____________________        uptodate,lru,mmap,anonymous,swapbacked,ksm
>  0x000000000020586c              1        0  __RU_lA____Ma_b______x_____________________        referenced,uptodate,lru,active,mmap,anonymous,swapbacked,ksm
>               total            458        1
>
> page-types being using the new API and page-types_lab the old one.
>
>  # ./pagemap_ioctl
>  TAP version 13
>  1..117
>  ok 1 sanity_tests_sd Zero range size is valid
>  ok 2 sanity_tests_sd output bu
>  ok 35 Walk_end: 1 max page
>  ok 36 Page testing: all new pages must not be written (dirty)
>  ok 37 Page testing: all pages must be written (dirty)
>  ok 38 Page testing: all pages dirty other than first and the last one
>  ok 39 Page testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
>  ok 40 Page testing: only middle page dirty
>  ok 41 Page testing: only two middle pages dirty
>  ok 42 Large Page testing: all new pages must not be written (dirty)
>  ok 43 Large Page testing: all pages must be written (dirty)
>  ok 44 Large Page testing: all pages dirty other than first and the last one
>  ok 45 Large Page testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
>  ok 46 Large Page testing: only middle page dirty
>  ok 47 Large Page testing: only two middle pages dirty
>  ok 48 Huge page testing: all new pages must not be written (dirty)
>  ok 49 Huge page testing: all pages must be written (dirty)
>  ok 50 Huge page testing: all pages dirty other than first and the last one
>  ok 51 Huge page testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
>  ok 52 Huge page testing: only middle page dirty
>  ok 53 Huge page testing: only two middle pages dirty
>  ok 54 Hugetlb shmem testing: all new pages must not be written (dirty)
>  ok 55 Hugetlb shmem testing: all pages must be written (dirty)
>  ok 56 Hugetlb shmem testing: all pages dirty other than first and the last one
>  ok 57 Hugetlb shmem testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
>  ok 58 Hugetlb shmem testing: only middle page dirty
>  not ok 59 Hugetlb shmem testing: only two middle pages dirty
>  ok 60 Hugetlb mem testing: all new pages must not be written (dirty)
>  ok 61 Hugetlb mem testing: all pages must be written (dirty)
>  ok 62 Hugetlb mem testing: all pages dirty other than first and the last one
>  ok 63 Hugetlb mem testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
>  ok 64 Hugetlb mem testing: only middle page dirty
>  not ok 65 Hugetlb mem testing: only two middle pages dirty
>  ok 66 Hugetlb shmem testing: all new pages must not be written (dirty)
>  ok 67 Hugetlb shmem testing: all pages must be written (dirty)
>  ok 68 Hugetlb shmem testing: all pages dirty other than first and the last one
>  ok 69 Hugetlb shmem testing: PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC
>  ok 70 Hugetlb shmem testing: only middle page dirty
>  not ok 71 Hugetlb shmem testing: only two middle pages dirty
>  ok 72 File memory testing: all new pages must not be written (dirty)
>  ok 73 File memory testing: all p
>  # Totals: pass:113 fail:4 xfail:0 xpass:0 skip:0 error:0
>
> [/TESTING]
>
> In the LSFMM/BFP 2025, there was a general agreement that we 1) would like to have
> a generic pagewalk API 2) that replaces the existing one with callbacks if possible
> and 3) that HugeTLB can use without the need to special case it (e.g: not having to
> depend on .hugetlb_entry callbacks)., which means having a lot of duplicated
> code and also having a lot of special casing just because hugetlb lore.
>
> pt_range_walk API tries to do that and replaces the old behaviour of "in
> HugeTLB world everything reads as a PTE" and starts reading HugeTLB entries
> the way they really are, that means interpreting them as PMD/PUD entries and
> contiguous-PMD/PTE entries.
>
> In order to achieve that, we need some infrastructure we did not really need until
> know, in order to be able to read HugeTLB pages as PUD/PMD entries.
> E.g: softleaf_from_pud had to be added and some other pud_* functions.
>
> In a few words, this API goes through an address range and returns
> whatever it is in there (swap/hwpoison/migration/marker entries, folios,
> pfn and device entries, or nothing).
>
> These are the internal return types the API uses:
>
>  PT_TYPE_NONE
>  PT_TYPE_FOLIO
>  PT_TYPE_MARKER
>  PT_TYPE_PFN
>  PT_TYPE_SWAP
>  PT_TYPE_MIGRATION
>  PT_TYPE_DEVICE
>  PT_TYPE_HWPOISON
>
> The API also handles locking and batching itself, so the caller
> does not really need to bother with that.
>
> In order to handle contiguous-PMD mapped hugetlb pages, folio_pmd_batch,
> which is an analogous of folio_pte_batch, has been implemented.
>
> More information about the API can be found in patch #4.
>
> This was tested on x86_64 and arm64, but as I said, it is still
> incomplete, therefore the RFC, to gather some initial feedback before
> investing more time into this.
>
> For now, all users of the old API from fs/proc/task_mmu.c have been
> converted: /proc/pid/(smaps|numa_maps|pagemap|clear_refs).
>
> Thanks in advance
>
> Oscar Salvador (8):
>   mm: Add softleaf_from_pud
>   mm: Add {pmd,pud}_huge_lock helper
>   mm: Implement folio_pmd_batch
>   mm: Implement pt_range_walk
>   mm: Make /proc/pid/smaps use the new generic pagewalk API
>   mm: Make /proc/pid/numa_maps use the new generic pagewalk API
>   mm: Make /proc/pid/pagemap use the new generic pagewalk API
>   mm: Make /proc/pid/clear_refs use the new generic pagewalk API
>
>  arch/arm64/include/asm/pgtable.h             |   41 +
>  arch/loongarch/include/asm/pgtable.h         |    1 +
>  arch/powerpc/include/asm/book3s/64/pgtable.h |    7 +
>  arch/s390/include/asm/pgtable.h              |   38 +
>  arch/x86/include/asm/pgtable.h               |   53 +
>  arch/x86/include/asm/pgtable_64.h            |    2 +
>  arch/x86/mm/pgtable.c                        |   18 +-
>  fs/proc/task_mmu.c                           | 2295 ++++++++----------
>  include/asm-generic/pgtable_uffd.h           |   15 +
>  include/linux/leafops.h                      |   46 +
>  include/linux/mm.h                           |    2 +
>  include/linux/mm_inline.h                    |   32 +
>  include/linux/pagewalk.h                     |  106 +
>  include/linux/pgtable.h                      |   95 +
>  mm/internal.h                                |   75 +-
>  mm/memory.c                                  |   22 +
>  mm/pagewalk.c                                |  400 +++
>  mm/pgtable-generic.c                         |   21 +
>  18 files changed, 2039 insertions(+), 1230 deletions(-)
>
> --
> 2.53.0
>

