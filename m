Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78DD3606EEA4
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=WdLG4Wg6
Received: by kanga.kvack.org (Postfix)
	id 6C63F6B05D4; Mon,  9 Nov 2026 07:32:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D626B05D5; Mon,  9 Nov 2026 07:32:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50E106B05D6; Mon,  9 Nov 2026 07:32:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E9EA6B05D4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:32:50 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 975C2C065A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:32:49 +0000 (UTC)
X-FDA: 85415519658.07.066E8E9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id CBACE80003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:32:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WdLG4Wg6;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794227568;
	b=Umn1PH4peZhUbgso3tYEKaoLMKZPUiaE19NjDmXFIQtL3CvbZsWs5jylWALF70RCvQuF1u
	INlLYP1a5AGzg9in80Cg8fqsifNsu/D9SW+uzjTxU8siHn1pLlb802FajpqQN1lQZpmHk3
	7ruXR3Aa+SiWwl5/4W6r1nRrI0hrcWU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WdLG4Wg6;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794227568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ukow83UoTytYL8JZzZR7bTnT+vpStaGbqG5Qaqk5JyA=;
	b=vUPSKLMQjcZSp4pPty8uWuQK/wRGzt+ksFHjeeOIug/L1pviD8IceUGxSv5QX8kPBzuf+g
	h7Fgw2ab6VJ4qrwsAWTnFKgumPJ3j6Z325UYQsI91aSjSBSFvwZOEnhuOuCuPFXExrV7Fj
	8OnaCfMoyBc5hopgjEX14hctNROx24E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D3F11516;
	Mon,  9 Nov 2026 04:32:44 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 303EF3F632;
	Mon,  9 Nov 2026 04:32:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794227567; bh=7yJeZXt4u8Z7uYANqbGruKjLpg9idzB3fdrFi3g9iww=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=WdLG4Wg6SdFFXU+l09aIfdwo/rSrI8wxmfURdaGlB0EQajreL5r3Hnft2127wYtaG
	 CLJHCsGKGWe8osJbyGahrV716HPcm2QwkY4CK+eJQssi84iZ7lH6ituWbY2DX4zj4F
	 Th8pJmODxq0TUBNECCYdt2sxieZVGbsHUlANxENA=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 09 Nov 2026 12:32:30 +0000
Subject: [PATCH v3 6/6] mm: gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-refactor_gup_fast-v3-6-2aaef02df0e1@arm.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
In-Reply-To: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6911; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=7yJeZXt4u8Z7uYANqbGruKjLpg9idzB3fdrFi3g9iww=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq8b1fJK2/z263zF90nPm9HyLk8snuJ1P2HDe8f
 E/VDNkCkiaJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCavG9XwAKCRBt1cPRWsUx
 MxciDAC8U+MWYKPQE6y2OjQB+rDaHNZyuOWmPCLShwlsTEX8beUGlulWtHl9xFV1VniQdZyoYIh
 mu1YJMyzG5CpLAGpGHnoCUvlAYFc2mUk0SNRhf7Y+7/IFJFZ50i+9/FyNc+e5dpJ/nrApZlasqX
 qlOGA6AYEZiJMqjA9zhmp03O0M+CHl0YHgAcNBAzmj01+GP145ywqs+CrI3hhQJKu7G3xuje+nI
 lLzLhjCfGvHw+HmczqwOgJW+tpuZbgclhx7R02aJZw4wndOeFiw+lq2iygoDCB1DWFf8JbXl/Cx
 AkvOivaLG7+CRyb6wzqOTV+SC1HSGk6NOJRxJBMTax5R+cQXZMEAPgAZC9XQABaQf7YPpM2Adhc
 2uFgnVZfdBK4NAignaRS386s2BhVvfeAajcbmvHa3XB37GgSVPWEo//IAfUlpV1BsgUlc6ATHy7
 Ab26iIlYv5pEdIV7Vv3P9+A6Yw6G2XBOEfC0ZWINs0HKwBMaWGAHlNSJbaEBIBEKmQGkk=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: ykn3oub5omk3rhewrfqci1iutorj7h59
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CBACE80003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794227567-365326
X-HE-Meta: U2FsdGVkX18ZdvIULgX0WiibOFuQjEUjPwOw6EH23p5q/m5RV8EERlfaGBX2on0xJk96BrMxeCEsJgVefXPRQLxH9Nx0xuQZKRYURBDgKulXYDLqqjlDTF8/b/07WkzEykGy9oGtCup+oaE5LdJsOzi12sDRi6qLik0w3Cu3fUbfmmw7b9WwKCi80EOjWLDYCGPOvqeMY1vnLnxBuIU9gVKrkEfcIN8P5BmECRkYvAjdjyPJDadKc78z1z3qATBIZ5lzEg8WmLgK5/HGKu1GDGdDcl/+EQSZn02/2l5e0iJ0/J73gLlZ+WwmWq0r1x0D46lWxzyahQbHu4ODKp/PW5/nr3xgZvkFLjwAN91M5+d4KJyltPQOHx5dlQQI9P1ZIyA31buWkmDSb+0DetT0hQudd0Bp45ZFe4TxTSudcKUGNqS7WCFgYkj5hoxL42ZM1+kwUmxGU0wehVSxbN/ACsjJM01mVw3rYfEeH8CkG4RjmIUgFYH84VAUr/uFm+hRt9IiSlmI2JGCMRDt9XLfTxBeb1SZkwhbjEm9UKtZXvhTh+1ka6UNKwSgGAQmBC0paehlrc+Jq3VDFNWpDpBhSJLbfjjUDquaU+Os4Yotj+hsFHsZVpUw0dbrYtO/K3tPrqtFjrKlxZI4euZW/AnTNvfE2rMHsBJA5ifpsv2v51qoQPnHgayEswthQVLv4/qz3q+JLm+zU1NbdFlo27aDwS03kEnsu0Yt8ouz6R86h6caP5QQXbVAfFgxOZFPU7VyecpucSbLWBzxqcDgFVnGvr0pVxNpGtW1le5xXNi/hwWCcF7z63TI3Sgj3jCG2r2q7t0YyFMJkUsIKQmaZt0BF7+RlkeoLSeUwc/linbV92MMiewa8SGBSInvsj8SG8TBSwKDAkFRrHGcG1sKD832L99/Hwaos2Y/cwuxL3HMpTm/k/2EFKepQmaqH/RTBoQwzbW6MfyCfjPwp0XfTX2
 6k3LLQ8X
 N8MigFrnofXKVC2cJ3GFTwDLtlPK5c7P/cPIDbHhOKPuKP6pRla5S2ZzT2D+SrWImxTOkidUShHDcqv1lCbRR68vDpKVqBv85alQ9h6CPZzfpAYnjJTbhVrRiWfOizyTZ+ThyJW0J+eN7lF3jVkPl3L7sVe2Qx0qf4ZIaUIHecrY6GPuuYIm721+fhWODB5hlKiz9XmP7LqdelwZXmHm1pcu3Dw50VZprM/WJFiigbemYM6i5mPy2QJaG2kN3eo+Fq5DFJkgpTF6jEbIr+s5vk8QooK0AS8YStEswnVM7A2wpEHTURMQ9tWOZLQ30S9E46GgkNGA9YWmn600=
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
 mm/gup.c | 65 +++++++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 25 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index c863bae33e2f1..abb09f73f8ee0 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2932,7 +2932,8 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		unsigned long addr, unsigned long end,
 		unsigned int flags, struct page **pages)
 {
-	unsigned long nr_pages = 0;
+	unsigned long nr_pages = 0, nr_batch;
+	struct folio *folio = NULL;
 	pte_t *ptep, *ptem;
 
 	ptem = ptep = pte_offset_map(&pmd, addr);
@@ -2941,7 +2942,9 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 	do {
 		pte_t pte = ptep_get_lockless(ptep);
 		struct page *page;
-		struct folio *folio;
+		unsigned long i;
+
+		nr_batch = 1;
 
 		/*
 		 * Always fallback to ordinary GUP on PROT_NONE-mapped pages:
@@ -2951,13 +2954,13 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		 * permissions.
 		 */
 		if (pte_protnone(pte))
-			goto pte_unmap;
+			goto out;
 
 		if (!pte_access_permitted(pte, flags & FOLL_WRITE))
-			goto pte_unmap;
+			goto out;
 
 		if (pte_special(pte))
-			goto pte_unmap;
+			goto out;
 
 		/* If it's not marked as special it must have a valid memmap. */
 		VM_WARN_ON_ONCE(!pfn_valid(pte_pfn(pte)));
@@ -2965,7 +2968,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 
 		folio = try_grab_folio_fast(page, 1, flags);
 		if (!folio)
-			goto pte_unmap;
+			goto out;
 
 		/*
 		 * Recheck the PTE after grabbing the folio to detect concurrent
@@ -2976,19 +2979,25 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		 * would not dtect that we are walking a detached page table.
 		 */
 		if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get_lockless(pmdp))) ||
-		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep)))) {
-			gup_put_folio(folio, 1, flags);
-			goto pte_unmap;
-		}
+		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep))))
+			goto out;
 
-		if (!gup_fast_folio_allowed(folio, flags)) {
-			gup_put_folio(folio, 1, flags);
-			goto pte_unmap;
-		}
+		if (!gup_fast_folio_allowed(folio, flags))
+			goto out;
 
-		if (!pte_write(pte) && gup_must_unshare(NULL, flags, folio, page)) {
-			gup_put_folio(folio, 1, flags);
-			goto pte_unmap;
+		if (folio_test_large(folio))
+			/*
+			 * The reference acquired above keeps the folio stable
+			 * for the following checks.
+			 */
+			nr_batch = folio_pte_batch_flags(folio, NULL, ptep, &pte,
+							 (end - addr) >> PAGE_SHIFT,
+							 FPB_LOCKLESS | FPB_RESPECT_WRITE);
+
+		if (!pte_write(pte)) {
+			nr_batch = gup_unshared_pages(NULL, flags, folio, page, nr_batch);
+			if (!nr_batch)
+				goto out;
 		}
 
 		/*
@@ -2997,16 +3006,22 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		 * see Documentation/core-api/pin_user_pages.rst for
 		 * details.
 		 */
-		if ((flags & FOLL_PIN) && arch_make_folio_accessible(folio)) {
-			gup_put_folio(folio, 1, flags);
-			goto pte_unmap;
-		}
+		if ((flags & FOLL_PIN) && arch_make_folio_accessible(folio))
+			goto out;
+
+		if (nr_batch > 1 && try_grab_folio(folio, nr_batch - 1, flags))
+			nr_batch = 1;
+
 		folio_set_referenced(folio);
-		pages[nr_pages] = page;
-		nr_pages++;
-	} while (ptep++, addr += PAGE_SIZE, addr != end);
+		for (i = 0; i < nr_batch; i++)
+			pages[nr_pages + i] = page + i;
+		nr_pages += nr_batch;
+		folio = NULL;
+	} while (ptep += nr_batch, addr += nr_batch * PAGE_SIZE, addr != end);
 
-pte_unmap:
+out:
+	if (folio)
+		gup_put_folio(folio, 1, flags);
 	pte_unmap(ptem);
 	return nr_pages;
 }

-- 
2.43.0


