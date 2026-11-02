Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1140F606A33E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=COu7LGup
Received: by kanga.kvack.org (Postfix)
	id 9C7586B05BA; Mon,  2 Nov 2026 06:30:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977E46B05BC; Mon,  2 Nov 2026 06:30:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83FD96B05BD; Mon,  2 Nov 2026 06:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AAE36B05BA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:30:40 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C64F9140C18
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:30:39 +0000 (UTC)
X-FDA: 85389961398.10.432536C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id E4AFFC0002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:30:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=COu7LGup;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793619038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kfBt7VegB4tPtF3aDF2xGVmaq4e8cZHrDQu6SY70Iyc=;
	b=FIbIcVJb0SFkYhSJZBCTbyiTMbdFPNFUJ3P8BrAJWiJv9ZLVQBi8AxyjJ4lIwQg3U7dcXv
	4ChudORQ3WUm2lYVCVdc24camefdjbvYJmFh9BRQQXo7qh5vS1LGvr7mLQdDXpNFEicCdz
	ViIcnb6X8zG2zhRBulExzfEH7Ga05Vo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=COu7LGup;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793619038;
	b=j/mMKl95E2athKEMfuUfYlXrZ9Czff0dqonDG3+fnqW4xbot8jerISFwAJ8QdqYEJsYcZW
	jPPdGFh3IpsepVb7YbRo+Zmp2nwrtPqW+3E7R0CkCYTibTmORSaXOQ24s/onXe0H/Ki7kk
	VflK/qqjbiuAl++bDR/Gyc5YMuTyvq4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 134A71691;
	Mon,  2 Nov 2026 03:30:34 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4752E3F632;
	Mon,  2 Nov 2026 03:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793619037; bh=HwhV8AKXzh2IqLPyqcNAxm1ImdqPtq8zihoD7af5bxk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=COu7LGup5ViKlHhc3bxi6DjIsFvy3kMLQHaT/Jiyam9PsLDnKZRsuOpW8N0HU7TDS
	 aYi6zvYzU0a9NMzxYbUgeAxQf9SG0hS/qaHLmNjt32ZrkI6TZqbI7iJfrKXb0Atttr
	 k6Z+b+vUG7rK/28SwaGHaJ45YoVGgzCMTKY+a3VU=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:30:19 +0000
Subject: [PATCH v2 4/4] mm: gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-refactor_gup_fast-v2-4-bc1ac018c834@arm.com>
References: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
In-Reply-To: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5969; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=HwhV8AKXzh2IqLPyqcNAxm1ImdqPtq8zihoD7af5bxk=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HRSkyBgpfjrwbkgXjt7GwMRErEE2JyyT1SX3
 IWwNm/z/a+JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauh0UgAKCRBt1cPRWsUx
 M9GiC/9Q/g5vw/EFwaCW7oylk1YUQONETkxPRgb3R65xWYBUJgWSi6jzlOjGzUSOoj0zHD0K4Lt
 pJ2BVoxwO6zSrEL+fbd9OCT20BhtrX9gYf2+44sKzSL60W/EtXNH/qnxlQ+aqO68BRCcjFGU8wa
 bqYs5AdrT12pxMtiZG00yaeLHQUbR0M/2LuIzfnIIvKieBO6rbCLAjuP0w/+2DhlS3/D6FWGUho
 z1xofwt7YCQ+kllpFjhK8VHzPEAi7Aioh9Z6HH2cUlmCts4IAfvlp1jQO2FQndYl4WnPFP2GMau
 1Wk8tXNtKg1YoXpl1HP0h109dLQxTM4PFLVOndF/vPEaWj7FaJLq2tFUD6tr3q4VefWsaWmgv6E
 L7eaRSIa5xZAsvZmaQfJUjZSzOPilESlZzoDmyOOvswW3y8AdcHQOPk26z8dodPcnbxZBxdgF4b
 GRvkneFh+4Bqd4y26R5kBuN0glVsw+ftlKB50GuZOl8Tw28qWlvTkZ+9vh6fxaLzcyjY8=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Queue-Id: E4AFFC0002
X-Stat-Signature: kmucskyib9nsez81ghd4nxq8zte83bg5
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793619037-39945
X-HE-Meta: U2FsdGVkX19tTX3/6yP5K7rvm1Ui5Lja6F8dFd2w0g4jVLjFh1La6aZEoc1HGRWjNHIaul2BCcTjRbI8XBl7qzwH7pJ42g7j7E9v/kJs0k4LruPG+8EsLTBJniUUT9CVWQKlRZ2vQ+82srlq+kE1GqJfzUASDN+7dGKpClK/GedYxZe+QLfkxRVlAu0PHKcWEggPuGgwrM/nynlPJ4N5nuUEokcOSnU0f5yziwAj5adjGtZxmujGPKW4hy0Ji3oq0KI4ei9nI0yOR/kgInlx9YkNqEJ5WOiZqnEjvwzeXE0VFu5hD2CBRop6FQ/nVvngu/qyj/sc3iQW1maEat2fz1OTXafblmSox5AQ4DyJrGu9vErks0sdHYan0jUiPc08XrM6jfSNbyG8VMok0uyPeVYzODQKVdq90mw0AbatbdM/qHtaRLGDsrVvoTFPDiNQh75pdEhVAZtSy5em/QCJ2i8o7KnzRueSv3TI0afSeOm2nkfwWw1i9k77uGmYRP2eo+CmmnXv7nc8OtVs7cYy9cjYb9op/s4bXV1h1X8EhwtrBd97ZHgQzSlpjYFxR0zwiMEVESsGXIMIGg+CkGT9furxtS1F8assa7aA8EZNvQAC+SU9MJeLBs4aBhfWFHRv1MvMtZ4paDG9PeItObvY/Z2jqLK6Ov1sieKhYXR1fWfHyu7hNPbZp44Rq+ZNOs2HcR6Ls3zlPHnxQuJVwtdl0yzI8XuczVRJE1FLNAt+H5Ox81Mr9OrpzqeLt09YbYnBMJ2Uo/k11bpelOnxYn2ScqffRNkrDitkxaL729txlFISlrCnnBSBugTBXkn1PGqiWq6Rjd8NWMHWI6LdKpH3cyMcq9MwL1J8X4PtGEcp24qpZvjhnhI884mkC4nsXuvEgRH5EYt3wUV63Mol1r/dnhVRdKLxqNh8xzwThYElAg5uZEhqNkLaLJpigaGHCU5VXC8is6ZSjt80JHRCqqe
 LO0Msqsl
 bIDv7uc+3DedTGv5fWnKdwFRu0bR2hucdNX3Ftovdjm7tFncRLpZ+SiwEdPG2SHFbtHyHzJUT+RMwv6mmqOLkwKTHecci6tmeG0JRAcGDwQLGR9GSDANMSxV7B6RURLP2lSV6q7YmfRx6qRLIDfgY1OdM9F6kKsrxAWBJyY6AKQEgYZwBlib/elZzsCW5yfvKSvm/wTFxX+CMjgM8puno750I80QwCliURYEn5IQOkLUdbARBeCUy+1n7x/UN5eXaOp9qAEavyPHjsVpZB11t+ZIS5n32oLeCRCV0vx3aEA9eDKcR7njbFY2A2Fono2phi+tlVl22LhBhZMY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

GUP-fast grabs a PTE-mapped large folio one page at a time.  Every PTE
costs a try_grab_folio_fast() (a refcount cmpxchg, plus the pincount
atomic, a full barrier and a node stat update for FOLL_PIN), a
gup_fast_folio_allowed() and a folio_set_referenced(), so a 64 kB mTHP
pays sixteen of each and a PTE-mapped 2 MB THP pays 512.

The users are the hot ones: iov_iter_extract_user_pages() pins every
O_DIRECT buffer through pin_user_pages_fast(), io_uring registers its
buffers through it, and so does RDMA memory registration.
With mTHP those buffers are PTE-mapped large folios.

After the head page has been grabbed and verified as before, extend the
run to the following PTEs that map the next pages of the same folio
with the same protection bits, take the remaining references for the
run with try_grab_folio(), and fill pages[] from the run.
The PTEs of the run are read while the reference on the folio is held,
so the folio can neither be collapsed, freed nor split underneath the scan.
A read-only run of an anonymous folio stops at the first page
that gup_must_unshare() rejects, so the per-page exclusivity guarantee for
FOLL_PIN is kept.

folio_pte_batch_flags() does the scan.  It reads the entries with
ptep_get(), which is not safe without the page table lock on
CONFIG_GUP_GET_PXX_LOW_HIGH (x86 PAE, mips32, sh) or with arm64 contpte,
and GUP-fast reads every PTE with ptep_get_lockless() for that reason.
Add FPB_LOCKLESS to make the helper do the same; it is inlined per call
site, so the other callers do not change.

The order-0 path keeps its instruction sequence.  The folio flags are
tested before folio_set_referenced() on purpose: a load of the flags
right after that locked instruction cost about 25% on order-0 pages in
the gup_test benchmark below, and reading them first brings that path
back to the baseline.

gup_test ioctl over a 256 MB anonymous region, FOLL_WRITE, 65536 pages
per call, median of 15 runs, two baseline boots / one patched boot, on
an x86-64 VM:

                       get_user_pages_fast()   pin_user_pages_fast()
                       before       after      before       after
  4 kB pages           849/789 us   783 us     1174/1138 us 1094 us
  64 kB mTHP           812/811 us   126 us     1215/1113 us  188 us
  1 MB mTHP            799/774 us    59 us     1185/1077 us   64 us
  2 MB THP, PTE-mapped 803/786 us    57 us     1159/1120 us   58 us
  2 MB THP, PMD-mapped  42/40 us     40 us       46/41 us     42 us

fio O_DIRECT randread of a null_blk device (CPU bound) with the I/O
buffer in 64 kB mTHP, median of 15 five-second runs:

  bs=1M psync                 126.2/125.6 GB/s  ->  220.6 GB/s
  bs=1M io_uring, iodepth 16   71.2/71.6 GB/s   ->  112.1 GB/s
  bs=64k io_uring, iodepth 16  50.2/50.7 GB/s   ->   60.1 GB/s

IORING_REGISTER_BUFFERS of 1 GB, median of 15:

  64 kB mTHP           6179/5998 us  ->  1599 us
  1 MB mTHP            5790/5801 us  ->   893 us
  4 kB pages           7173/6741 us  ->  6763 us

Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/gup.c | 46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 49681f63950ec..94a9dc45e5953 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2901,7 +2901,8 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		unsigned long addr, unsigned long end,
 		unsigned int flags, struct page **pages)
 {
-	unsigned long nr_pages = 0;
+	unsigned long nr_pages = 0, nr_batch;
+	struct folio *folio = NULL;
 	pte_t *ptep, *ptem;
 
 	ptem = ptep = pte_offset_map(&pmd, addr);
@@ -2910,7 +2911,9 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 	do {
 		pte_t pte = ptep_get_lockless(ptep);
 		struct page *page;
-		struct folio *folio;
+		unsigned long i;
+
+		nr_batch = 1;
 
 		/*
 		 * Always fallback to ordinary GUP on PROT_NONE-mapped pages:
@@ -2937,19 +2940,21 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 			goto pte_unmap;
 
 		if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get_lockless(pmdp))) ||
-		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep)))) {
-			gup_put_folio(folio, 1, flags);
+		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep))))
 			goto pte_unmap;
-		}
 
-		if (!gup_fast_folio_allowed(folio, flags)) {
-			gup_put_folio(folio, 1, flags);
+		if (!gup_fast_folio_allowed(folio, flags))
 			goto pte_unmap;
-		}
 
-		if (!pte_write(pte) && gup_must_unshare(NULL, flags, folio, page)) {
-			gup_put_folio(folio, 1, flags);
-			goto pte_unmap;
+		if (folio_test_large(folio))
+			nr_batch = folio_pte_batch_flags(folio, NULL, ptep, &pte,
+							 (end - addr) >> PAGE_SHIFT,
+							 FPB_LOCKLESS | FPB_RESPECT_WRITE);
+
+		if (!pte_write(pte)) {
+			nr_batch = gup_unshared_pages(NULL, flags, folio, page, nr_batch);
+			if (nr_batch == 0)
+				goto pte_unmap;
 		}
 
 		/*
@@ -2958,16 +2963,23 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		 * see Documentation/core-api/pin_user_pages.rst for
 		 * details.
 		 */
-		if ((flags & FOLL_PIN) && arch_make_folio_accessible(folio)) {
-			gup_put_folio(folio, 1, flags);
+		if ((flags & FOLL_PIN) && arch_make_folio_accessible(folio))
 			goto pte_unmap;
-		}
+
+		if (nr_batch > 1 && try_grab_folio(folio, nr_batch - 1, flags))
+			nr_batch = 1;
+
 		folio_set_referenced(folio);
-		pages[nr_pages] = page;
-		nr_pages++;
-	} while (ptep++, addr += PAGE_SIZE, addr != end);
+		for (i = 0; i < nr_batch; i++) {
+			pages[nr_pages + i] = page + i;
+		}
+		nr_pages += nr_batch;
+		folio = NULL;
+	} while (ptep += nr_batch, addr += nr_batch * PAGE_SIZE, addr != end);
 
 pte_unmap:
+	if (folio)
+		gup_put_folio(folio, 1, flags);
 	pte_unmap(ptem);
 	return nr_pages;
 }

-- 
2.43.0


