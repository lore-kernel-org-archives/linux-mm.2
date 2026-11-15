Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3890606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Y7Vd6qgN
Received: by kanga.kvack.org (Postfix)
	id CAB766B05B2; Sun, 15 Nov 2026 09:39:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C82E36B05B3; Sun, 15 Nov 2026 09:39:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBFF96B05B4; Sun, 15 Nov 2026 09:39:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A22F6B05B2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:39:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7B658160775
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:39:22 +0000 (UTC)
X-FDA: 85437611364.30.AD78F8E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9FDB080005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:39:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Y7Vd6qgN;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794753561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZaejXHaBUpAvEwKuL1oBVBhqrVdgMX2jfRxMaYZY1C0=;
	b=B99GBqwKoOJA4At6Si39+iwx16nAXIFxXeBGgQZZ3KMhxNiYAuPRqk++/R3nSVxPlFS5qK
	o0PMRdHsCGPKTpnMgOHjy6y589JMVBNcTQt7+XRR8QO1hNkqd0eXqVwNp9wHl8tRkZbhFJ
	S1Alp5AhyQ47ICce+jrM+8k0xtrY91w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Y7Vd6qgN;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794753561;
	b=e4hpB8XqJGbjj8Ys4l428FMY1aUehlweGhnUVhorRyfAQXe6fadRtA8U+T/0ousUdPhEAs
	B61wgsOLqEYPs7mBmn0Aaf2tP1mm6Un/Rm0kW15hBbnnXy0iLdkx98S2aK34AMERWGDvJ3
	mSUd8fPY1rARCa/xOli6UlYs+esI++8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84E751476;
	Sun, 15 Nov 2026 06:39:16 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id ACC043F85F;
	Sun, 15 Nov 2026 06:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794753559; bh=jI0WbTDOJd6J5+na5JHcdV0AETzFP4/ftE8ndjLZuMw=;
	h=From:To:Cc:Subject:Date:From;
	b=Y7Vd6qgN125q8hK35gQR0raUdxPiX5gSqSFy44kpN+z29FlGNNe97oyKtLMGxDtlE
	 Z/Y0dYXpMbLieTfKz8aDW2YRqEltVKVwNb+kxYClYQWm/5ZbkGfdaEkJ5vK6fiVuNF
	 RTmXNEProFAb29tj75RfnqnFRB6o6JsA/6UCCFok=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
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
	anshuman.khandual@arm.com,
	geert@linux-m68k.org,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v4 0/9] Optimize anonymous swapbacked large folio unmapping
Date: Sun, 15 Nov 2026 14:38:55 +0000
Message-ID: <20261115143905.3045084-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9FDB080005
X-Stat-Signature: zei8f4rb9xesf8awh8nn1e1kaai5sdzs
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794753560-99430
X-HE-Meta: U2FsdGVkX1+846Z9XwLJ/X7xXeCDAf2wQglSCvDg4Mf/IyzkzxJ6Rc8H+9vqaH7G5ZNuVbML1z6ULLMKaXKIK2dY5LDQ/ri4y3B73R7IkhU5YbeGeVrPoybB4FQ6H83TYI9ZWAWam417fi/fDdFjlqnvTWjthyxYQzhD7YD/gyHzEltZdOvZjPC2t0iVVttpzOnD/8Y/BoGbZJIEP2HCgxQoSabM4WaUTkFF7z5HOBXsC2S+O6v+FJpX+vieHfLK3FxHwZZDR+Q15f8IgxwcQsILhKM5qSMN7Pd9OY6XZvFOA84vCM3qYY7O6DT/WagpI5TCZBEMD/NsRbrqjbH+KBfv4LWHjpzoorhM/8t0rMFEaDIY6SfuxiL07OKfT8Ks1VVSeatNIrSk8gO2o5wLMzI4GPUHihU+YPGX4Use6IRCMaN0fkO3HXg0PIMgv5b+AVcRDzpEGQLRViGrElCk7IZLSxhuxgtQLLVInnMrgOZgfovbsuzyzkwDZ1cLS3p7ggFHnAf4iKZzrQqM6JOa7BvdYe3JgKTzpN6S/jHIa5b+DoETkNRUB3E0b/auq6HinGREi91Ux7DzX3p6Z8eSRLFX7XoXixp8C+JPWCY22dDTZFdpHuj2bTCr8x1VpT8+ifJbvJXYLY/MAaeLGc0uqiMjwZFBL33gimAS9l/cFR+9GZDKHyTls9yihVQGUWwWfj+pM+AZsjp068A5HEV3tNxbfM+LPGvqLWHDn5DQ6Sr7qWLWt23o0VS720/FcPUXjFP62EafVApMs+1WSzELGDSzZTbI7aZjlTU0IDR8URvGo7pCyrXaN7U4YCWSf1+6zs/f3+D+TKYdJUzyszTT4zbwHrz+La/2IN0a3hTxocJsDad4Nwg9YMQXxFlUaIHvHkariKpZ+6hk6/z1/kXhBtKkR6doRva/t0X8vYaTeWXsSA5o/AFnKBYbBb6jLhVPJJho/+16Rr1v7OH9K+G
 vzazroYC
 8nCttigk+ZXcRDBb3wW33zdC73752QzXvD9c2ag5xYjUSz2su5+K6YBvt9MpCx1gbHrwzk2VKXwDPE3H8LYOl5IuYgKc7kIOKDCYUnWJWgwqK4Dmaka/fS333Dom2ES3quowsrsmMymnj0aeQm2gTm64jPqymiRP45v6KYgZ7Djs1myjjPm/ziJapiiUnYp5vo0tytZ76IL0bBGXL+EYbNDWWVVTHDBJDoHYCSns7+/VWYF4H3xgJe3FIGd04+0QKr47AYirmwBXP6D4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
Applies on mm-unstable (24231596edf2).

mm-selftests pass.

This breakout patchset is the final completion of
https://lore.kernel.org/all/20260526063635.61721-1-dev.jain@arm.com/

The extra addition is the generic set_softleaf_ptes() helper.

v3->v4:
 - Make page_anon_exclusive_batch return the exclusivity instead of
   computing that in the caller
 - Make ttu_anon_folio() return the number of unmapped pages, to simplify
   the code

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
 arch/sparc/kernel/adi_64.c          |  21 +++++
 include/linux/pgtable.h             |   6 +-
 include/linux/rmap.h                |  76 ++++++++++++++----
 mm/internal.h                       |  64 +++++++++++----
 mm/memory.c                         |  23 +++---
 mm/mprotect.c                       |  25 +-----
 mm/rmap.c                           | 119 ++++++++++++++++++++--------
 mm/shmem.c                          |   8 +-
 mm/swap.h                           |  35 +++++++-
 mm/swapfile.c                       |  39 +++++----
 11 files changed, 289 insertions(+), 137 deletions(-)

-- 
2.43.0


