Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38DF9E9907D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6EF6B0005; Fri, 10 Apr 2026 06:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 897A16B0089; Fri, 10 Apr 2026 06:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786506B008A; Fri, 10 Apr 2026 06:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62A536B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:32:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDC3A1404E7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:32:23 +0000 (UTC)
X-FDA: 84642281766.04.8F1A367
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 01B792000B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:32:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pkFuTB7d;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775817142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=S7HM5EObQNGCD1ffT9BLbR30RNdPTSFZqM5v5/Zt7lQ=;
	b=EiZedk+sPRKuxlhPzn3BIv7YhfgWx97AlZ08vfxCH86iidkkVx2LjIbnhK9qMzNAI6dXML
	hhY1LPtSOdEH6QaDAk6F6+eS8ZHFDVauknPWbdClGJEZRU8z5+o7RyzQFzDse2LEkj/6x0
	oQ1DQnVf6M1DPkO1OOCW2idn86V6XLA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pkFuTB7d;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775817142; a=rsa-sha256;
	cv=none;
	b=eb5gKSIerCctxkxrRhr3JkQSqB+QCpDBU7Q5LVYWebltcBvHp45J6sNXZbLQoopG7DFZ09
	6N5GjdVGIky309aM/UNcC2Fzj9UmP3I/59xozLpk0LOfNS+aef42KBULIxdQOCfcZuoccR
	ygvKufr2Bk4S1FMXR/f/JKGfWwttCBk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19A551D13;
	Fri, 10 Apr 2026 03:32:15 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 992D53FAF5;
	Fri, 10 Apr 2026 03:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775817140; bh=jmHyMDlai0x0f05zSdQn8Nu2D9ewo36NxGUAqiysfbM=;
	h=From:To:Cc:Subject:Date:From;
	b=pkFuTB7dmikw7C91cqH3pZT3et/jndvNGFkXwF82k3d2lpxoReaf8RrkaOXz06RXH
	 +csyYlIM6hzOU275rNwE1F+Hk/tEBkV70U4LvEaabPrhqc8I2YmmfKv/nSQEKLBhhB
	 iHbQS2T6PPBLBTYD/9GIgWVoABqCTw068zjTTznE=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v2 0/9] Optimize anonymous large folio unmapping
Date: Fri, 10 Apr 2026 16:01:55 +0530
Message-Id: <20260410103204.120409-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 01B792000B
X-Stat-Signature: wfa3i3bdrehhfqtcb9qzac1n7eek9dtj
X-Rspam-User: 
X-HE-Tag: 1775817141-244345
X-HE-Meta: U2FsdGVkX1/I06KrCg/4fLF4zqi9/Y22dqlqb+gcw8UdiGVgf9/m6cI2BRLDyb5lqV4/H8zxipxnfsgHZw/CrDOXyYWdsa/h+vn6lDIc5ARycFN+danYtUQJZ/ZeffHA7nsamgHzxUzLXbdoVlf5SiUxpla5twQUve9ZsT1nuO3pXNpYlXTg1AQecctNbA+NA8h4lsli0UxxLwV47rVLHt8dc+W8YPwOC8kCAHHefsgT42Wtanxq3TfHikw0JHV3bDirGgjLV5UXmoYbL3Ic5/S190gUpBC4X2CDSJljvEmRUYuGw5Iwf9kp3NQdxnzH6AsVk72F0NisK4B/FbZFIYRTlqFkKrO91UTRC+iCO+HbF5AEERfl4BDynaMJg4f8J5b2xzcA2Bd7+Y4lamYYBl9exshpO5odYT+1wqK+rArYCASDW4XLHf+Aw9asOci/4xYihqRHi5DofQoCaHLjQUEPfb+MhtIFHolxc5G7E0Kd2Fu+gOK4s3ALTxy47u1vdRbDBV0GxvYoZAmC9ySE6/YRv4k+J4A2KP2+4t/Azw70BLbS0ZdRRDe3aAsRa7Uz9CyjtrTgK42BU62MjGIl+HfL3PkcolVdGhLB0oxf3NkD87pDyGqEGYTlx3iid4Z3/h2PlfDpOvsA3ofZ2Id7FL3YOtOuu3DmPzSHUMnTrPzdvlg3VMlvZmVh0xT9insuJO3zM9Rd0Bj1PDFG88u3gk62uG64fJYIodhLqK3m7JS+g1hYMNQjfgQqWkAUplMNvJQW3wSx/xtVqXPdbPbMjCZ9RamVSXb0b7kAS5Zi73IsRGIi29iLN4oErFjJ2fVLFsnToOB9rlDhKqHdzosdXbLySTOifLLnXjHWfdHfAWxjAozseLVIUOlu1oXVklXCtbCmYC47RQm86HBcxUe9VVlbNxF35XfMifCguzvIIwN44PgLskY4OjobQ9pnzAJo84mDbeyjj1e0FSThUHI
 dX6vT4e1
 9VHjPTWpD2v1jvEmAn2+9iulI3c9UnJ3t1FjeDsWEQkQkhLVMwm3Smm2F3q1uOaRo5MztSb+lEcY/t7voFtN+m9Y/IyDZZYlX49YW4DosBgQknFoVgMupBN8vl7c33np6OQK4YVRjYOPm3k9qXKlfI2bCjFkhWnG/yDe/XW9AoKfjlht3t0jRRtwQtQ==
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
Based on mm-unstable 3fa44141e0bb ("ksm: optimize rmap_walk_ksm by passing
a suitable address range"). mm-selftests pass.

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

Dev Jain (9):
  mm/rmap: initialize nr_pages to 1 at loop start in try_to_unmap_one
  mm/rmap: refactor hugetlb pte clearing in try_to_unmap_one
  mm/rmap: refactor some code around lazyfree folio unmapping
  mm/memory: Batch set uffd-wp markers during zapping
  mm/rmap: batch unmap folios belonging to uffd-wp VMAs
  mm/swapfile: Add batched version of folio_dup_swap
  mm/swapfile: Add batched version of folio_put_swap
  mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
  mm/rmap: enable batch unmapping of anonymous folios

 include/linux/mm.h        |  11 ++
 include/linux/mm_inline.h |  32 +--
 include/linux/rmap.h      |  27 ++-
 mm/internal.h             |  26 +++
 mm/memory.c               |  26 +--
 mm/mprotect.c             |  17 --
 mm/rmap.c                 | 404 +++++++++++++++++++++++---------------
 mm/shmem.c                |   8 +-
 mm/swap.h                 |  23 ++-
 mm/swapfile.c             |  42 ++--
 10 files changed, 380 insertions(+), 236 deletions(-)

-- 
2.34.1


