Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 781A8CD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C326B0088; Tue, 26 May 2026 02:36:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71CFD6B008A; Tue, 26 May 2026 02:36:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60BC86B008C; Tue, 26 May 2026 02:36:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3106B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:36:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED6A91A029F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:36:55 +0000 (UTC)
X-FDA: 84808613190.11.A29A2BA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 19F801C0006
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:36:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aaxxDZZ0;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779777414; a=rsa-sha256;
	cv=none;
	b=KEcHXBcadmDAPMD3EVvK1EDUEAIQUx4FqM3jwKI0Qg3gYcMta7B2/IX58p/bS3sOTKJpl+
	S/eAzu8frx3Yan0+rCTSk2t4FvbS7xHh62qX+RXIexxE//zu8pnWi+gOUnjiAFtqct2iyg
	vRaKKTBnOOTuV9uIBvhNrh6hP7VPj0w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aaxxDZZ0;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779777414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bRkfZQb+I+HeNXhyQMTc4woDklt726y/01ztYmchOMA=;
	b=aWD6XmZnegLD3iWZfgVBjvbp5i3rhJ6pttW0RETN2xxRZoSWOFolmXNFqN2+LTvGY+O3z9
	NPSW1eXL/NZ4c9JQJ0KdgAKg6HcGrmA288VUd/lXTcqj2Bet4b4A+XYSc86hVOhQkhUxGM
	BoWzahnXzImXCX3bQ++04SlQghE8lDk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1B8B16F2;
	Mon, 25 May 2026 23:36:47 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 582733F7D8;
	Mon, 25 May 2026 23:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779777413; bh=3ZneyL1b9DzWVg14gAhSJwF0kmIWkhbz/xMA8lPoVc8=;
	h=From:To:Cc:Subject:Date:From;
	b=aaxxDZZ00/6kTt9UJwFHNozi2DNKt5zjoYtENmmW0NNH65+WDLuWQ7zIAnjclLOlc
	 G+La6zgUxuPjsq8Zl8sIB0j5rwanOYrSIU3aCHkXcuHgUfa3bq0x1tJL5oLiRmSPPG
	 SLW406MAZdQI4a9MkA+0X+OOLa2UL3lgVgd58Yb0=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v4 00/12] Optimize anonymous large folio unmapping
Date: Tue, 26 May 2026 12:06:23 +0530
Message-Id: <20260526063635.61721-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 19F801C0006
X-Rspamd-Server: rspam03
X-Stat-Signature: 5oe114s4yzoez9q8m4rcxjwi5twc8neu
X-HE-Tag: 1779777413-422553
X-HE-Meta: U2FsdGVkX1+7tbe/BBFgrUSHdIVex+PbIZQhgTS6f5XFYWppA2C28oUTkA3xEjzDCWXiyx6nceZEXEILbr8ehrNnI3LSaZva8tYHyTekPFGv+U558bM8vcAqKust3jV6vt+u8bebum4F6nkONX/oNk0FE3oPoOg39UOr3UrgaFpoQ5BcpfEYlk1Eq+U8dOzqGqE07aquNJw5LNNVnMR6hZvxbyeCBVA0mtNj5mC2em2ZXxWgBDC9OMkmQhaKbXa+dO+GK58BCsC9Im3Ky62hmCPKyCEwBhFhlvnc7cGN52rDCdlY3RUjSu2TheydZQZNloCw/pw1BHGPQroRRbZDrn+mdCWOvE2LvFA+shqOBEomIiwig7Vt3BHa4vPSNOHqlPlx+B1K4xAdqG7g6bcz63mSFkOZ7J99N/s2oCPM7wwOqJnPX3kMWcfjc9cjtTKY1judrsPcHc1+7QEJ6uPJnfURAz/lPSx6fL1gv1yRAaSUBH9FOO146HsSOm8S9lcVq3ZCItNePOlC6y3BEMJuRXyjQUp0dG5MM64BFRbBkx8FGOtuYG87AZibOslI77JzUA/42LM0vKxAYGWSmAz3WhiOxIPpcFDmlWINoyd3sRsb5Mfg3tt5Tu8f2wrgnn4ep0RgI5i4PFsDQzPXOlGP4EMMwnCeVyNJgrrjcB6ryebaUgm5W9LtTe0ncbNMyQhNIS/p84QE+jNhK+s+qo1C+L755eKdVcpjdIZbJFk4O42e8kvmUzmuwt8j8l8UvjmaSotKPxHI7Q5IeCI7oGfbtL2Zo2VwMwwowsFGQg3SJzvuFxMfCBhDxGqbbWgFodmUcbZdJ64YftTQC2QdNovwaGA2CPyY2mbGNx7Wf8+Kvbob9Dvj9+epdBA/fQOEY+V0vIiLGoX5ddfWMeg+m6jRQJgYar6HCDFEor824qDbhDtKS1xe3C7Wjc4yUYs0Vw10RcdzR3NIxt9EvER3HeZ
 5S3x1vdT
 M5byMZJRdU86G6jWkSsogeE0CYRJXXpKeTOaH1nWK0vu93ceLjqmjo5OWzo+mbC/zu9x6t+30bpVs1ih7zDy+wdEfWL1428S44BH6MKQglbGWbTM5ZQQoJ8SPQM+UHKjxKPOtOO2D48xtYFUCVQszh1FjZUafa5GdKMB3GIP0r4QLoaMS7q7QUjxYVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Speed up unmapping of anonymous large folios by clearing the ptes, and
setting swap ptes, in one go.

The following benchmark (stolen from Barry at [1]) is used to measure the
time taken to swapout 256M worth of memory backed by 64K large folios:

 #define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/mman.h>
 #include <string.h>
 #include <time.h>
 #include <unistd.h>
 #include <errno.h>

 #define SIZE_MB 256
 #define SIZE_BYTES (SIZE_MB * 1024 * 1024)

 int main() {
     void *addr = mmap(NULL, SIZE_BYTES, PROT_READ | PROT_WRITE,
                       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
     if (addr == MAP_FAILED) {
         perror("mmap failed");
         return 1;
     }

     memset(addr, 0, SIZE_BYTES);

     struct timespec start, end;
     clock_gettime(CLOCK_MONOTONIC, &start);

     if (madvise(addr, SIZE_BYTES, MADV_PAGEOUT) != 0) {
         perror("madvise(MADV_PAGEOUT) failed");
         munmap(addr, SIZE_BYTES);
         return 1;
     }

     clock_gettime(CLOCK_MONOTONIC, &end);

     long duration_ns = (end.tv_sec - start.tv_sec) * 1e9 +
                        (end.tv_nsec - start.tv_nsec);
     printf("madvise(MADV_PAGEOUT) took %ld ns (%.3f ms)\n",
            duration_ns, duration_ns / 1e6);

     munmap(addr, SIZE_BYTES);
     return 0;
 }

Performance as measured on a Linux VM on Apple M3 (arm64):

Vanilla - Mean: 37401913 ns, std dev: 12%
Patched - Mean: 17420282 ns, std dev: 11%

No regression observed on 4K folios.

Performance as measured on bare metal x86:

Vanilla - mean: 54986286 ns, std dev: 1.5%
Patched - mean: 51930795 ns, std dev: 3%

Interestingly, no obvious improvement is observed on x86, hinting that the
benefit lies mainly in the reduction of ptep_get() calls and the reduction
of TLB flushes during contpte-unfolding, on arm64.

No regression is observed on 4K folios on x86 too.

---
Applies on mm-unstable (444fc9435e57).

v3->v4:
 - Add patch 1 (page->folio conversion), patch 2 (add try_to_unmap_hugetlb_one),
   patch 6 and 11 (subpage -> page renaming), and patch 10 (refactoring anon
   unmap first)
 - Drop patch 1 of v3, which is now in mm-hotfixes
 - Patch 3: do set_ptes() restoration at call site
 - Patch 4: rename the function, move to memory.c, rename pte->ptep, pteval->pte
 - Patch 7,8: Remove redundant stub, add kerneldoc
 - Patch 9: remove helper, do a loop in-line

v2->v3:
Mostly a resend after merge window. Some minor changes:

 - Match kerneldoc parameter with function parameter (pte -> ptep)
 - Mention change BUG->WARN in patch description
 - Rename walk_done -> exit_walk in patch 2
 - 
v1->v2:
 - Keep nr_pages as unsigned long
 - Add patch 2
 - Rename some functions, make return type bool for functions returning 0/1
 - Drop page_vma_mapped_walk_jump - this is implicitly handled
 - Drop likely()
 - Add folio_dup/put_swap_pages, do subpage -> page
 - Shorten the kerneldoc to remove unnecessary information - keep it
   aligned with analogous functions
 - Put clear_pages_anon_exclusive to mm.h
 - Some more refactoring in last patch with finish_folio_unmap

Dev Jain (12):
  mm/rmap: convert page -> folio for hwpoison checks
  mm/rmap: Add try_to_unmap_hugetlb_one
  mm/rmap: refactor some code around lazyfree folio unmapping
  mm/memory: Batch set uffd-wp markers during zapping
  mm/rmap: batch unmap folios belonging to uffd-wp VMAs
  mm/swap: rename subpage->page in folio_dup_swap/folio_put_swap
  mm/swapfile: Add batched version of folio_dup_swap
  mm/swapfile: Add batched version of folio_put_swap
  mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
  mm/rmap: refactor anon folio unmap in try_to_unmap_one
  mm/mprotect: drop 'sub' from page_anon_exclusive_sub_batch
  mm/rmap: enable batch unmapping of anonymous folios

 include/linux/mm.h        |   4 +
 include/linux/mm_inline.h |  53 -----
 include/linux/rmap.h      |  52 +++--
 mm/internal.h             |  17 ++
 mm/memory.c               |  87 +++++--
 mm/mprotect.c             |  19 +-
 mm/rmap.c                 | 475 ++++++++++++++++++++++++--------------
 mm/shmem.c                |   8 +-
 mm/swap.h                 |  36 ++-
 mm/swapfile.c             |  31 ++-
 10 files changed, 470 insertions(+), 312 deletions(-)

-- 
2.34.1


