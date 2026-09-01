Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FC3EC61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:44:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE4F56B00C5; Tue,  1 Sep 2026 01:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95856B00C6; Tue,  1 Sep 2026 01:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B879D6B00C7; Tue,  1 Sep 2026 01:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 810836B00C5
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:44:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D00B41C1C9D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:44:13 +0000 (UTC)
X-FDA: 85164102786.22.4B3FDF2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1E972C0006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:44:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dX1ar1mV;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788241452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ccxIYO2hOy0q1yGAf5wzMtkfCqP9D7PlI/JJ7p573BY=;
	b=aV9oF49xxLAHmEf/pdeAjs8HyU4uARVLVzPTEBCyt92TNbVOO2W9r/xXdQBjS7IVhPb5Mx
	bQv+hg9vpuIozTq3sZqpWr1FtELbyG8YZtmAZZ+LUKH9HKJXODoCJt2XvAU7r6OsOrUyot
	8cURovtXu40r7ajN+N+cadG/UwB0wts=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788241452;
	b=Pbm8fx3BjZm3MKvZa6TdLWIaG2t/iZoOuQBKlsfJ+NGeL0jeecoURJWErLmHIgW777gfTg
	rnWzTLQdudoFURsYDaegTLoPruD3LhOW1cG9ydNSMWtqv4Rj/0HPhuA2aAs5925dfS7w1j
	zvtSafMR0cSTzanjtbtdVScN9kdORV8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dX1ar1mV;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 176641756;
	Mon, 31 Aug 2026 22:44:07 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EF2D53F85F;
	Mon, 31 Aug 2026 22:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788241450; bh=z7SnY/TZcfUbJoxXT3hWEUw/QWVK2bD8Px83AhPKn9o=;
	h=From:To:Cc:Subject:Date:From;
	b=dX1ar1mVnXf7HIsO6+jtrW8k2z+MuNX8sdIo503mCQWJFqJC7UYVjHnU2lUwECCrt
	 HiBaEyk/3gSZN+CutLEcl5kmeRIq6/20yjyLHcF/HVnRyqW58vjFMKRCUR96OUbDnS
	 tO6kLX5luNQ26ME5RzGA4GyNvwOm1a7TUK6PA30s=
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
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v2 0/8] Optimize anonymous swapbacked large folio unmapping
Date: Tue,  1 Sep 2026 05:43:47 +0000
Message-ID: <20260901054358.4049095-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1E972C0006
X-Stat-Signature: g715t1wz1e4ywtpns1ixiicw9z9t3fn7
X-HE-Tag: 1788241451-739332
X-HE-Meta: U2FsdGVkX1/3QhLxwwC18A+HbPk/CD8hLUD3IHKx+ujWGeFNJZkL81ldu/q7Co9TF1Ip6+IA07iItWFuONWbfD4rAMv2t1W7hmVADaREEb5642TKC0utop0ozTPZkdm6TMwIwTk5J465RHCqXzq0C6Du0vzXnt0Mk+48m9ht3LY4UfZ84Vwiht9d/NjdDYESU2pAVdJXI0pqJbTb7rsQZ08dlKXxfBqabRkHOVHbmc9jt37oPgXpxFhW5LhQuXvPCdgHie5EPRGnhZ/82IozcPgsk7qI9G243K4r/FZz2nh2iWq2TvkZ0qjpfYJBhsdQmVO0vPLZ+41PKZa/vQUK8nrrCLAuMIkYFPS2rqBJXgPxZSCET+uQUe341WWwgh+RamWJDxDCMvjFh/onWujON9QFEVKM/wKFK/QRaO0wuc6KAJ8UwXNs6lfr3zNl4QBZeTAE6XHJU4/L6COCj/6DO6UeyC7ocdzIFSHzz9DmY2hhyRNYPRkJQtHpGKgc5lMlElmbHf43v+NB9DaRCmY25p6cjOFx5jn5TMBZF8RbwLMb9AsB7yLVgJ/hK5lG9UsIETVjamP3dcqyGd1Ly9wwwi9BsSThfvMthSa1Er2bxlDAWIFMBvQDsVFm00ZQbCmD3cS3fl87qq3tkNwKCuvVR35mjdG23GGBEYEnXCM6GW/XQqPKzxTlRQW09nIH27G8JCin9qRYl7ZVr1Y9QwlwFcqMhr8gsbytitT1ELqxD2sUWj4SasnuiMKU+sP1twbJNhVa2oMxP64XtIbBxppPOXZBuz0ViG5lAGJp/ZTbjPSDZ5h4AMw5k+IovCw+vc8r8A1GHG1Nhx4V5DmE+5Z5vL7vS2CInzFA/leUzfyLvPBtlyQymHXVsBu35a9Uwj4gioDJ7Xov7D7+R1eqZXg67226vtZOqjwhJ0K86gz7iiAfasCghynr4WaZfYfwQ7YsIo+qdeBkGxO93pKUU1c
 u9GQrfxq
 GDhNRTVDIEG2mzTBOUVgJSJnK+S1/l9DBGkaR3WbEAjd8CATPYmqQz5s3mbYWFGp1gsZ6EKiPk1oHOXFIYkwxNVFJTsChWH1XPCoPYUl64TfBxr5pM7sqw79CLbeFMh3SzudcEQkYSAULj5EmBc6e1lya+4yViznImU36SOINvGyLkiZyaR9i/pRsiPdNSxFm49qlOuR0ywleCCJMF/D+jZubiBB4kEJak5eBn1gCAjLcXgw6iwtElh5rP4SvzbRSHaT8Y6Z7kQENfwU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Speed up unmapping of anonymous swapbacked large folios by clearing
the ptes, and setting swap ptes, in one go.

The following benchmark (stolen from Barry) is used to measure the
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

resulting in more than 2x speedup.

No regression observed on 4K folios.

Performance as measured on bare metal x86:

Vanilla - mean: 54986286 ns, std dev: 1.5%
Patched - mean: 51930795 ns, std dev: 3%

I tried magnifying the difference on x86 by using 1M large folios, but
can't spot an obvious improvement (looks like my system is too fast to
benefit from batched atomic operations!), hinting that the benefit lies
mainly in the reduction of ptep_get() calls and the reduction of TLB
flushes during contpte-unfolding, on arm64.

No regression is observed on 4K folios on x86 too.

---
Applies on Linux 7.3-rc1 plus below:
https://lore.kernel.org/all/20260831082849.3573957-1-dev.jain@arm.com/

mm-selftests pass.

This breakout patchset is the final completion of
https://lore.kernel.org/all/20260526063635.61721-1-dev.jain@arm.com/

The extra addition is the generic set_softleaf_ptes() helper.

v1->v2:
 - Add WARNs for folio span in folio_*_swap_pages
 - Trivial changes to page_anon_exclusive_batch
 - Add two sanity checks in patch 4

Dev Jain (8):
  mm/swapfile: add batched version of folio_dup_swap
  mm/swapfile: add batched version of folio_put_swap
  mm: move anon-exclusive batch helper to mm.h
  mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
  mm/internal: rename swap offset helpers to softleaf offset
  mm/internal: add set_softleaf_ptes
  mm/memory: use set_softleaf_ptes for uffd-wp markers
  mm/rmap: batch unmap anonymous swap-backed large folios

 include/linux/mm.h   |  19 ++++++++
 include/linux/rmap.h |  56 +++++++++++++++-------
 mm/internal.h        |  62 ++++++++++++++++++------
 mm/memory.c          |  20 +++-----
 mm/mprotect.c        |  17 -------
 mm/rmap.c            | 110 +++++++++++++++++++++++++++++++------------
 mm/shmem.c           |   8 ++--
 mm/swap.h            |  35 ++++++++++++--
 mm/swapfile.c        |  35 +++++++-------
 9 files changed, 247 insertions(+), 115 deletions(-)

-- 
2.43.0


