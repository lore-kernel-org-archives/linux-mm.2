Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D13D606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=eo8Z3Vlo
Received: by kanga.kvack.org (Postfix)
	id 3E6C06B05B3; Mon, 23 Nov 2026 00:36:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 396A56B05B5; Mon, 23 Nov 2026 00:36:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 285446B05B6; Mon, 23 Nov 2026 00:36:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0345C6B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:36:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C22B1407C5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:00 +0000 (UTC)
X-FDA: 85465272480.20.0D1404C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6C4CC180006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:35:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eo8Z3Vlo;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412159;
	b=ju/ljqH+S9FikqgOrSG/vmGeMSqpHmPsZj8ZpCWtqhHFQTGE1xc6vsL5recuNiIcbSuDpR
	orfZdU+vIikt2d2VrvJSZl6zbSCNbEQVUKzOQpIl0gFIuLdGkAE2oBARK0vG54cHJypO7j
	/MsMaXX5nm5TLusA4/5NFc9KJplFiQI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=x0xS8mfVx4sgioYASlvGLOE1qEDPr6sx+CujBt6qdxA=;
	b=FWL3TohESl+0wyjoSWPW38YDw4VVIWKtr6q8/JdXcMAJAcmZfwON6kR+FUEN0airZFbFvY
	zLnG0mLdg0a6NIbGkWzlGLudFe1z+ZhmSocpSltLmsa8qx6Z8IDMnEFqrEd28BUvX8GLB0
	veHZp1aYLrdgqKOLS1x2ZrTS6NiwhDQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eo8Z3Vlo;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3744A143D;
	Sun, 22 Nov 2026 21:35:54 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 67A8B3F632;
	Sun, 22 Nov 2026 21:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795412157; bh=0Itlx5I79xCD1WeWTqYMZrMqsEx/2ywYmF2pj7cYvUA=;
	h=From:To:Cc:Subject:Date:From;
	b=eo8Z3Vloq5FbqmhKu4Fd6c5UZMZiuIupYX/Fl5lo/zo1+EJ7TWY6+SsBg7/IHEXz6
	 KqOMF30lMOE4gCoKoiNzn4sbektwUEvHkya9lwxqkiFgm0NKyACkNQzuZKKY/qpCZV
	 02jh8US75WztqwmwjPVaJGAOajgalNbERPKvdn64=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
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
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v5 0/8] Optimize anonymous swapbacked large folio unmapping
Date: Mon, 23 Nov 2026 05:35:34 +0000
Message-ID: <20261123053543.295467-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6C4CC180006
X-Stat-Signature: bpwr51ttz47ko5u8wfy3o7xutro9y11p
X-HE-Tag: 1795412158-661978
X-HE-Meta: U2FsdGVkX182TIi8dFx5s+Z8Tfxy78b84eMrzl9ej1hzVF3wtjH4UBVhyk1YIk+vmLt6PqabWAg6CeCJQAzKq0a4l8AYORTTp+/ezimagL6HMHJZWE+oWbqbWZxtuLf3YhYUcWk9SOCIy1BteX6saTmq43nEhxhaDaMKgln18zsXxqWtmshRFqk7fFrb9YMBWAKJGWzY6NhJN/IYC8p6fR8ocG+e+nJktBF205iVE1s9QjlVIf4UbMJ1Cm/FHJYQvV6EZvlOOzYa9dn8ju+N6t/5qGWodnu1tQ5SGPnq8YTUQW7Fyu8+DRiEioy14r+PXp14DBgHkiRW9hfKky9etGJ5O6gu6s+nONYhuUAF+fRPjHpoWz8IB0zVyEqWDad53ltEiMQBNVjN0jX5rM1AQZTQG1RekrqMujIBEVKS7xaAQ8MiXSIrfzv7nDeFnzvqCss2XeIQwaqTy+V3a0BH5BkczeuNrz6x8TzFNUIU/HG7YinvoOI17angE6Xg4hcNUadCAWULFuEvdcdNAUawBVMXhvr8re2QoDpVeeL89a99T2D4xWT6dQJG2F5wuxxWBAZdN9UZuFR4u5xEpdRv1shxvcsxB5M3EH0b4HY6DjFWoBQLgaqvNTNk2jP7ChxEGLs50JKtIyiBO6aiSNLZ6J5QkiQBOG84jP4mwRn+YmtPYM6qBG1lsRhFyBxq1aKZ6CuWjG8EfVEFkY/yQKFERJh68ka8aceHcmpf8Pqu73V4Dgcga0W8xqCOIX6+buKfUo8/IJ6er939P5LKPAQ0UDyO/yE8pcd6Wl51tki9zY64FokfEwKpR5DYAgnNKaYpGJDSSHjS0M47x3TgfxBdBd5ieEJCMlgJZTijFVwIGjyIcJs3fh/9BgKAytWUB9r7HLuvmZNIKIvQbp3LmbTJmjL9av0xzcN5Me573pDAyph3ixBvZ31I9PQVxXA3pi9kRkblIaCcVj4PnHNnRky
 gqd2c/ih
 GoeWp9ABAFEtuJpx5UZN9dfn2le5GE5nMk6U9S25YxLs6k8nPJK0gt9W+TITMiQr62Da3Cl3K5oM9crUYFyPZYrukpn2m3ZFHUnj2yFGDENgcoGqwZbHWKb+EajMU2YGyfGd2YiqRU9JdMc5fYTMIRxAaIZg3pMZ9OiEhDGC0bSeaENcfxGf25k2NFSYGKfstF9geitVs7X0ctK+riUa97pRqNFWoHBktTBqxqK418CT2pY+hZBHeQmS/CK61TS1YepN1Pw08Rokhtv/V9rLsfEZCaYpLJs0vSHXDMRJsUkKlBzRoAyY7aeWUfhlA/ODOXkQZ1tEgRaznQfykPJHhLYKcEv1bnySxLJY8v4TxjAkviVhbR7QlOa38W8DddWtzUxtaxoqWllNdcXyJgZZ0BYnWw2ZriFgI+SM1
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

Applies on mm-core/for-next (fe0dcc1affd4).

This breakout patchset is the final completion of
https://lore.kernel.org/all/20260526063635.61721-1-dev.jain@arm.com/

The extra addition is the generic set_softleaf_ptes() helper.

v4->v5:
 - Rebase on mm-core/for-next
 - Drop the sparch arch_unmap_one() batch changes; I currently do not have
   time to batch that, given I have no knowledge of the arch and that we
   are in firefighting mode so I'd rather not introduce new changes to
   this series. I can send that as a follow-up

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

Dev Jain (8):
  mm/swapfile: add batched version of folio_dup_swap
  mm/swapfile: add batched version of folio_put_swap
  mm: move anon-exclusive batch helper to rmap.h
  mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
  mm/internal: rename swap offset helpers to softleaf offset
  mm/internal: add set_softleaf_ptes
  mm/memory: use set_softleaf_ptes for uffd-wp markers
  mm/rmap: batch unmap anonymous swap-backed large folios

 include/linux/rmap.h |  76 +++++++++++++++++++++-------
 mm/internal.h        |  64 +++++++++++++++++------
 mm/memory.c          |  23 ++++-----
 mm/mprotect.c        |  25 ++-------
 mm/rmap.c            | 118 +++++++++++++++++++++++++++++++------------
 mm/shmem.c           |   8 +--
 mm/swap.h            |  35 +++++++++++--
 mm/swapfile.c        |  39 +++++++-------
 8 files changed, 260 insertions(+), 128 deletions(-)

-- 
2.43.0


