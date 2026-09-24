Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64BBBC98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 13:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A4B36B0088; Thu, 24 Sep 2026 09:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656646B008A; Thu, 24 Sep 2026 09:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544236B008C; Thu, 24 Sep 2026 09:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 328516B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:11:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B606F120315
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:11:24 +0000 (UTC)
X-FDA: 85248692088.02.55EC04E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id C11DB1A0006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:11:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CqWCpPB0;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790255483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KzS9oGSuMnm2pAsPZvjwkAIIcDYxG8w7M5m4w0EgU4U=;
	b=fHq/3lXNYnLKSljPb3SNzYx396mb6dqlV82Al16kidghjlQ7K4Jbp6vNp940TW28BZYKmE
	cJgKwQBiAsBDdg7WJgh/MqwxPBuNkgalW9MksYJvePt8ueXdWmTUm5RPRso6wE4Wb27tQd
	XLFp8klmhWGP3WdCgqtkWUKa0vgFTks=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CqWCpPB0;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790255483;
	b=GX3kfGgjFSn1F3MEvgcerCrxopSd91/pvY4BVGggBW3+DjNzD8Sz3Cya4tG66F38otnzPR
	9o3wN+F28nrGZ5b3Ut8/evtH49Gnez8H0WCd4JlIsEsjHjLt0hP8OAseL2x4FaMhrjg4dt
	qf48LpQ2ILDLE+qlHbnwi6UAtWQ6lnY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 389691476;
	Thu, 24 Sep 2026 06:11:18 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 91D493F86F;
	Thu, 24 Sep 2026 06:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790255481; bh=e/9gnFks079cSu1f+MLquMjLMqHujT2ROPffEcmRtQE=;
	h=From:To:Cc:Subject:Date:From;
	b=CqWCpPB0XZVJf7lG7wEIips7LZon7+NJAG+6kS3Q8xUm9X6gBmLzS2CfeD3fgUHpA
	 xVpOE3uyt9pMvYBmARKgZkn8wPjjvaErYbkZsv1+PHFCIauuw1iSgat/MGFhjltWgp
	 y9WZJYU7zw8BYrHas8iZqDksMOyZR265ByGPcpPQ=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	davem@davemloft.net,
	andreas@gaisler.com
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
	jgg@ziepe.ca,
	thuth@redhat.com,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 0/9] Optimize anonymous swapbacked large folio unmapping
Date: Thu, 24 Sep 2026 13:09:28 +0000
Message-ID: <20260924131106.1730494-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C11DB1A0006
X-Stat-Signature: ybwy4dfnb8uy5aorrx74qozawk65z7ky
X-HE-Tag: 1790255482-671452
X-HE-Meta: U2FsdGVkX19BXaS4TxLqRKOpblwy3VtO4kt/zHlN8iFXHOd3fanF888p+LrTg87RVyU4gccBQEbpZjxFZ1W+6mndcXWsNrvCnqaCBQdY9WG0Xxx0x1fE0++rABHPohLjv5YXZWi0M7U4EL+XZVIfLEF93WwyrLylBm3TxQzuOAHtmhP63rGCRFj2Y0N5CyO9eEolwDiu8dvjvBvonwtHm3f9M8KJf3b3c1eyIyLkTKOLpvmkbkMGOL8hH8VYhdF9EOMY/FzpTUnYYPhSwbdR8h1IGk9xj5SAQsDhFtxsyAR70+RYvddtYkPG6PNtD/ubXwLVO5TbZCxXBt1o++XRwar6ef+aVD7Og1ZORFUryvzRnQAudc6GCWKBcFjCe+Fjlt90OYGZjWXEaWJSRK9WXcbDkEtuqjrSBdwNfnYjUXH8yyhV3OOp6MfT6B5gDxnKEF3nY5dT/A9TMzy5VRdlnoYDdZFuTHZ2RAU3PaJbbRDDsoViozXCxNmD2hD3/ZTy/QFcZ/HGQXm7uf3AZUtUDfoVtVQPb62keP+QHr1PGppdS4TA16VU2+Ueh+Cb87qpB6gGjLYpu8bqy66nm/HpLvgIX7chA4sQLXoVk5zk6/dVZnSjOy79Co2ng+RSroxADhENmZ7c3sN628/Z+UDDZADgjtVdAvhm85XcJ1nLcDp/Yp9uB0K62TAX0b9ckGQTtiDl58pScgv+WcbUCNup/SzFeAHamy3rS6KowTfMfWz4G9jAqWzcRnQH6FBd4kO6MX3WWG19gmWNiG6BnINbEE9zR07q6vpOVLMgiMwqvKXy76/ldnGiUN5guGY2oaqLwUwl/H+clTEBvxl5W/NGAg7CEVYQ/CYiiIykjbQ5gUs9GVFK38Mmb7NeUxu1GAYtzY+wfkm9kNH1GyDo5rpeK0ArwCXhv86Y8eJesvu4xE0FPr2z/7xZ6n2kku7e1lqWq0ndwhYHcLqUrXUyBBJ
 LMK+hJmO
 xldWxzj/gX+H0k2aN8hzLs1ZXkZGJ+auO+9XnMGWaryfZNxCDYHR9G2Oj45IyFb07wpPdCOQT4vqr44SVMZMjrI70DmhNHHE/UGFYrdVeiFI/QLVigk8IbS6CnprfpeF0+k3hvSvckSUOYHwh82Fk0jJNyCchdPP6R1snDZNfOVq2ukRqlh5ROft8R3/b8Rq2rguO8RcVv+N80KPZLIpDLvA3f3eoqOb4AlgaDaisHJCX1xRyLbX5jELGTxbF5GZbmxkH5o/gp+PDExo=
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
Applies on mm-unstable.

mm-selftests pass.

This breakout patchset is the final completion of
https://lore.kernel.org/all/20260526063635.61721-1-dev.jain@arm.com/

The extra addition is the generic set_softleaf_ptes() helper.

v2->v3:
 - page_anon_exclusive_batch returns unsigned long, shift to rmap.h
 - Drop a para in description of patch 5, use softleaf_is_swap to gate
   pte_swp_exclusive
 - finish_folio_unmap -> finish_folio_unmap_batch
 - Add patch 9 to do batching for sparc
   
v1->v2:
 - Add WARNs for folio span in folio_*_swap_pages
 - Trivial changes to page_anon_exclusive_batch
 - Add two sanity checks in patch 4

Dev Jain (9):
  mm/swapfile: add batched version of folio_dup_swap
  mm/swapfile: add batched version of folio_put_swap
  mm: move anon-exclusive batch helper to rmap.h
  mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
  mm/internal: rename swap offset helpers to softleaf offset
  mm/internal: add set_softleaf_ptes
  mm/memory: use set_softleaf_ptes for uffd-wp markers
  mm/rmap: batch unmap anonymous swap-backed large folios
  mm, sparc: batch arch_unmap_one()

 arch/sparc/include/asm/pgtable_64.h |  10 ++-
 arch/sparc/kernel/adi_64.c          |  21 ++++++
 include/linux/pgtable.h             |   6 +-
 include/linux/rmap.h                |  73 +++++++++++++-----
 mm/internal.h                       |  64 ++++++++++++----
 mm/memory.c                         |  20 ++---
 mm/mprotect.c                       |  18 +----
 mm/rmap.c                           | 110 ++++++++++++++++++++--------
 mm/shmem.c                          |   8 +-
 mm/swap.h                           |  35 ++++++++-
 mm/swapfile.c                       |  39 +++++-----
 11 files changed, 275 insertions(+), 129 deletions(-)


base-commit: 8d61431ed2607386b427752505379536eb634ce8
-- 
2.43.0


