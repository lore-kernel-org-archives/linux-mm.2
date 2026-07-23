Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0D9CC44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:09:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DB456B00DB; Thu, 23 Jul 2026 03:09:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68C8D6B00DC; Thu, 23 Jul 2026 03:09:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A2B16B00DD; Thu, 23 Jul 2026 03:09:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33D476B00DB
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:09:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7C5A1A03BD
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:09:22 +0000 (UTC)
X-FDA: 85019165364.17.F3FB0F6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id AA44EA0007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:09:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ou8rjE6e;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784790561;
	b=VMNXsdTVfje2AnkONIWX+7L2yRlQ+7wMN7RiRvQ2tw1JXiiIErl/4XBLwAwj/EF4/Si0wj
	RpD5yuqAEt2Xkui5aSUWZg7oQtAgQ9wBD5HTmpLF6pWDLIVb6q3kZzgaHSp2506xlAmaY+
	1r+vHd3sr3Et22ESJwd+gN4OVDQDrws=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ou8rjE6e;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784790561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9X7U+iB+v5RgdxBdfzXX7MDvVIMh+9MRFGuWjNQ2RcU=;
	b=3CmETleSYuVJqwFKCEj9d4CzCP/gFvi9qUSnhXSG+vj800O0gqH9sJMFh09cMp9w4VOSLc
	gYZjzkUUQf23/L3qb28zi3DdonUzm5CQC0WFrfDO0hlnObix3mKhv0I1mmdJwWEdRIiCEV
	3ZDfMCFzhYOyBpoOORHVKv/BJqhD6/Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6030A1477;
	Thu, 23 Jul 2026 00:09:15 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A2C123F66F;
	Thu, 23 Jul 2026 00:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784790559; bh=r9EfMEmAfxVooZvdxkOc/5sBU7O5MNGAs6jqD165yJM=;
	h=From:To:Cc:Subject:Date:From;
	b=ou8rjE6eBVg9yglueWD2KRr0100k416BiZ9gZo3ZXKNeqUtt4hov0ULKqVZqKepcG
	 OnpuRIl/wgswEOFImGUU8U3ygWlG/Y2WL+OEvwP4qycfCrQSeT/LyklTGQE5yVABNC
	 7WAwtFWqAIo1tTscUAiy7qK3Ma8dfOKwV3lH3/qs=
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
Subject: [PATCH 0/8] Optimize anonymous swapbacked large folio unmapping
Date: Thu, 23 Jul 2026 07:08:56 +0000
Message-ID: <20260723070905.3422276-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AA44EA0007
X-Stat-Signature: ko1y7t5yxx8aoizkgqhogjpwjn6mic7w
X-Rspam-User: 
X-HE-Tag: 1784790560-363634
X-HE-Meta: U2FsdGVkX18R6lrkplUEdpCVN89M4cG5YaU28m/TThnx9OVp/zHXCtqTE0CRkD3JZrRflSVl9IHbK3K+vlI/eAWz+xBV1u9ODQck9KSUlSRtJGncVctKCL91wZJ3qddoiF39kbL4q4KAna8TDIh70cPXVaaKgMeUNEzqEFaetXa15YnypYxKU9jZFGyaGTOLPDeOKCs4rFFBB5fCeNoFj4aQAPH3QGYA8Ki1DVsgDlVCupYpPxqb3nN1bcTZTz4qPMJIcPP9PXauaRns2IvOYjeBOcafYduS34vDK2G0UwwwF09aTeeGqnQWU/73VQcFXy5uxkjOKxkbEb8tKbgyrypHmTRKXmD9Y9AonE+S3bG+tWRyLvw+qSSOKT73YYub/2gqnHJl/osg+rYvhz1qjaOWnJofJ4FdeU954Nu4jTOFLRh/T0DmFGdCi1psWSm6knu3Gd152F++sjtXs8+ePzk2p170mDgFrehjFGQwgwfyq9Uh11UH6VBezPzZoLw/cKHw0JKezMn01yQ/GKQnCm0jIG6OLCp/hAi/qB8Ajx/Rqbft5l6CMqmn8IuucYOXLfrV+eGctsUoTOju9lgIqxZwdJmMd8lMI1uSdDjHbpDeOe6bmP8plRVM8FVJ8ApaObTdjEQgUrQCWb6zgr2lFZjVJIN0CqIBs+eAhgX3WR81nWothOHd2hCW3/rO/0ODSR/0e0feXc6xoVx/BNp/CCdrp5UhuOa9R/H/G8cRD0A3LMDTLHkeivG9b0bk6+xNrquhEhH7N/4Ri79mfJ0nN82Vbn5ZRzGZON0Q87uVavJkJF2h77Z48SEbUqxWmEOIdr5qAfNaQZDbZo2H+Bf8YBmoA/fo01qjB5KqY0vbSs/VCZ4cWvgHpYv5vgxkS6lgR7Lk2/VdVIoqvjArYy6QaLIL1GgVT7X5FbRGWPViQMI1/ZCXovsXBHxh22u0Q+3zsjQ/IUvnQUSqPiVD8XM
 Mw7KJZpr
 8zrXzQ8Qrddh2fLOYYrC5p2X9x8w21omuHMp1IPCbXwjlZdzSEOt6J4QFUxkvPcu0hjZOp9uSncGZeweLjq0TbPQmN9Dr2Z5IckOO/Isan/j1YyxwsZVKnVbdzdcgvSsL5QvC/TkZr6qC1H6r0p8BbtMKe65UgYqRt9jYtgfhOV258PrbERbhoRUXJcRG3+UUWqvW3mgx/Tm9iAkHweRP5S784quRqb51LopbtynwBqyDmOwlaem4yQ1jTsVEFx5kIC0eJwVPLkU1A5U=
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
Applies on mm-new (3d18f3499c48). mm-selftests pass.

This breakout patchset is the final completion of
https://lore.kernel.org/all/20260526063635.61721-1-dev.jain@arm.com/

The extra addition is the generic set_softleaf_ptes() helper.

Dev Jain (8):
  mm/swapfile: add batched version of folio_dup_swap
  mm/swapfile: add batched version of folio_put_swap
  mm/rmap: mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
  mm/internal: rename swap offset helpers to softleaf offset
  mm/internal: add set_softleaf_ptes
  mm/memory: use set_softleaf_ptes for uffd-wp markers
  mm: move anon-exclusive batch helper to internal.h
  mm/rmap: batch unmap anonymous swap-backed large folios

 include/linux/rmap.h |  51 +++++++++++++-------
 mm/internal.h        |  79 +++++++++++++++++++++++++------
 mm/memory.c          |  20 +++-----
 mm/mprotect.c        |  17 -------
 mm/rmap.c            | 109 +++++++++++++++++++++++++++++++------------
 mm/shmem.c           |   8 ++--
 mm/swap.h            |  35 ++++++++++++--
 mm/swapfile.c        |  31 ++++++------
 8 files changed, 235 insertions(+), 115 deletions(-)

-- 
2.43.0


