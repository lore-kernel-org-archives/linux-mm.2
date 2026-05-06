Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1575BCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29C0F6B0005; Wed,  6 May 2026 05:45:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D676B0088; Wed,  6 May 2026 05:45:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B826B008A; Wed,  6 May 2026 05:45:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 00E546B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:45:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88FE91C135E
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:45:22 +0000 (UTC)
X-FDA: 84736512084.18.4B3B715
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id E036214000F
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:45:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gT8rV42M;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778060721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qPdvvguBCaLa636mpG/gBfVV6uX0J2RQ0K8xrOfCd94=;
	b=UdsFH19SiC4nBG1R4axqH6npZQPgU95b4PduClzdWTzqdzd3sRgZdkTuLmd5Y4HDWWFSIJ
	Xl36K0AXbCiiQkbrQSc3aSqQ2CQO5KR5smqZv+G41oRQymQDTaw8UKxP5kUTWsBFHTaCDI
	MCMAXaykTVWVRKzv4+EK2Bv4dLYC4Cw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778060721; a=rsa-sha256;
	cv=none;
	b=nhRAdEm/W5fRHtEoFyLJ5mhErTWjugEweMvTkReBo3W9/qb04GlcdytpUX+HE0L+wvD1aI
	FUUVjh2LbzAwmKcqykXgMfJc8sytmN3FSIqi2/tHgW8m/E8I/oeTfPBYaFAh+rre8aAjU7
	a3H+1S4d5Rl2ZdVJ9azZtCpkKSz0jAA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gT8rV42M;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E3261A9A;
	Wed,  6 May 2026 02:45:14 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CCE223F7B4;
	Wed,  6 May 2026 02:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778060719; bh=2t9L31CurR28eOltO1eS/4M9dmxEnpUnjiQfALWhCkg=;
	h=From:To:Cc:Subject:Date:From;
	b=gT8rV42Mxd4wvgf5OaeZErHCRVkQ1VYUGuARq+ONMgYtfMHQ1IiZdToGo+9gexoLI
	 Fi3Ewq0j5MAodsRqKhN4Xd68ynhMfMZKfmRjmvURCvjjE1/KFGtViKArO9PZA9W3NJ
	 RnRAhNrtDGa9jGjWHDu5s3xQnVEi/V9YBQ8Q2OFE=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 0/9] Optimize anonymous large folio unmapping
Date: Wed,  6 May 2026 15:14:55 +0530
Message-Id: <20260506094504.2588857-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E036214000F
X-Rspam-User: 
X-Stat-Signature: 9feah71ph5499eibnfnnm9borhw7kaic
X-HE-Tag: 1778060720-213059
X-HE-Meta: U2FsdGVkX1+THhV0aJ3jTdRn8JM2b9yCd5gu2RgwI+Ap7iNlVqO6RnXV8CPpEdr5f1Nd2LjL3RMnCJ8nMf6VxRjDk8XyY50e9cAAw5ZVy/wT4UmQCgCnayilwVXwZniAXo9FspXxfKBhfo6w0B0j8erYqzkbZUxqq0uSBWMr+GeSjziEwoJtKopivb6jT9IL33Lwgd7clARObIJb6HC3Cbrfs6qG/gq4tK2+aD1tns8N5lrbKHfBf/W78I+g6KvW9R2x7fhptaiUfoyjCWCy/HZPZmJlp5BOScp9Mww4RUn27SafAzB+B74Mbtz//qyZ4qKcouNsA75S4tXfGkK5Ia511HEvOmx3fUZ3CTQCf9YCCjRm11qoO2PJqJcy6M463v1YDaA1AIAyazNJNUNUJFkwmFFxcW7N9DSPlMOiI5af6fefT2rye3TLB1ChRwnKxHYtDl1ibXrwxPWe7g0k1oeGwR3aJFTYp+pwQvZc31/4DF7nfgudGGDBOsxnrJn8EuTWfNb66lazgcJm6sLLt8hRZtoYQodDpO74UvaZo2Ct67UUxqeStzjie4S7HQwqrh727LQw6GT2NRNlFSfW/pSY4K0GsAyU/MUXV4lRdVsfd9pzIqwiNnRDE+s3h4jTMM9+/9BnSjZ9YAZg4CzFxXxRSz6u0P6P08er3rA5eWw+xLRWaaiLyem+tiwy3En+QZeZ3rxEqOYdoxpuiULXeLPcHK4hkYXXNlmcwX4IdBpqhntVCEpG2PA40Ve87LkUxTGEMbrDVbHiCZ+1Ji+EzIwuIpN6JeN+aTOhgfnWBf6pklBEXXv1X37Y40va6vc4jyQqjVt+ERlvXvtyIguFLenmoetVT4oIHg0KqqLZfGi52lGCb/TkkNldaCWROE4AA+Iap8bkZGBhOt2ASJFFbdkAA39LXk5OoL0Nuzz2q+wpr3ENZe9b9xLaegZxaoRu5CczhfAEog5PaobMvfn
 1fNRH3CV
 fPULhEehfZC5fRCgYEF0Bu3ssTBFyBCDPTw0pCZu20Th+67GmBHheXZZhVs6lzYs55YkEgcbBhxUNuFdCHLkZvAONrhaIKNG1e+An57PT5fyeVpVTTh5sBQxJ4HG1Gdte5UubwZeF3WFoaOEE7tzTtiBPFTz179J/e3q/wR1AEVz/vgi+HfgBVX2X3A==
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
Applies on mm-unstable (2d565cbaafd4).

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
 include/linux/mm_inline.h |  34 ++--
 include/linux/rmap.h      |  27 ++-
 mm/internal.h             |  26 +++
 mm/memory.c               |  26 +--
 mm/mprotect.c             |  17 --
 mm/rmap.c                 | 405 ++++++++++++++++++++++++--------------
 mm/shmem.c                |   8 +-
 mm/swap.h                 |  23 ++-
 mm/swapfile.c             |  42 ++--
 10 files changed, 383 insertions(+), 236 deletions(-)

-- 
2.34.1


