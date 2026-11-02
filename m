Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A09B4606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=H4O+qNzY
Received: by kanga.kvack.org (Postfix)
	id 4E17D6B05B2; Mon,  2 Nov 2026 14:31:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472F16B05BD; Mon,  2 Nov 2026 14:31:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6696B05B2; Mon,  2 Nov 2026 14:31:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C25906B05BA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:31:14 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 44AAB1A0268
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:31:14 +0000 (UTC)
X-FDA: 85391172468.23.36B2401
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf15.hostedemail.com (Postfix) with ESMTP id A3EDBA000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:31:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="H4O+qN z";
	spf=pass (imf15.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793647872;
	b=po59ZDAIeu8QmC11K0uxSXz06yS3waecsFgGwN5X/yyFHI7dzWQDEcZEws1Q3JCavWDs3T
	8yCbFL2smaFHa8RhiOLyvP+H0epqFBUQPmqgOGfUt/L/cuyxNbbASC8oywRjVr1yr5l1/t
	jOI/r1rgCP339mW+lCMOjMf+j0vN6Oo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="H4O+qN z";
	spf=pass (imf15.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793647872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EssaCi2baNEeAPpk67tmLaBdKKwRtpyn3LygDdFuUKc=;
	b=ez3pflMYxyl11iZVGfeirc4NI0xCY5pHvR/6gL5oDKFByokdK4qze7VaBEwNk2IXGWC6LB
	DgLareAEfqtjfASaEmm/aXclwAIVwAyjyNF7zf2c3jJ3xFi1trprDDX+gJaAfESWIUzm8b
	G6pgk/xK6yVBpzYIbXYt6+aa89AC8rc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=EssaCi2baNEeAPpk67tmLaBdKKwRtpyn3LygDdFuUKc=; b=H4O+qN
	zYJlUgRH/Gqu/0hHvWmJjaOrfLTu9L+QeCQc5vP/s4bgx6yoSPHQNSKfvdlWH+w9zorwBa8y84snI
	vNjlttT82c9YYWyPBnan5rK0BpfTE7iEJCcih2mOTTvjLYJHt6SLQT1SbDPOzqMrwLDwdV3KWGkqe
	X/PbvY+g/SMe5/3byxw1M79+XERo+jxvkR4OamnW/0NYLH71gkd9EkpQFOgyBZ0dvZvjX1IuulPTU
	m2N9Nl5VPWpFLvDJMqI1hFDwIuBsr1h/wuGifXjtwPduCQpG7xuDe6KRYyB73ycdqcukB+ZaSqt5d
	dmm33ylXBybJ8lovrEwDCsWmCeAw==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xNxjk-00000001W8x-16er;
	Mon, 02 Nov 2026 19:30:32 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-mm@kvack.org,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH 8/8] mm/gup: batch contiguous same-folio PTEs into one refcount grab
Date: Mon,  2 Nov 2026 14:30:26 -0500
Message-ID: <20261102193026.3860700-9-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102193026.3860700-1-riel@surriel.com>
References: <20261102193026.3860700-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A3EDBA000C
X-Stat-Signature: ii98y7mdk657u96din8og6hp9r5yt5xz
X-Rspam-User: 
X-HE-Tag: 1793647872-858129
X-HE-Meta: U2FsdGVkX1/HGvemOVdqOfFiLOrlSqaQzGQ4Ko9zuJpO28ejQP9ovTDxbUVDUekrreYbId1Kc8sFnzZ7HjAiANVDXOHQ31hV7FJYVvQkamYVzAF1YPVVqoV9aqfUBwUiXRoyIqw2iK7b+5qXW7zW/XMQULJsKCWerH7aqcS2K5mXIa3cX5cA5ZbnXGCuqwapmzYPWffj5bdhMkQj5JABhfIqNlcu4oPfIRkNzq6E4sOVhBq2Nvlyxndfy3NoqYnXQUKIdeM9xZmTWLTECl5XhU/LqxNUb9XZ+ek2xyi4QqPkxkJ/IjDwjWsi0LaKz/r0CD3rLdHavTBXLIbltILcUvHltVlIEISSuio5BH+aCxV+H/hHhh2LAyoYN+2S1ZgvMafLwAI3em52JAx8qyEw82XTtK72tNQ0k1p1PCpwd8ht4Wq9eO0mXdG4wNffj9r9EkRD4ci7Uq/cc/DlLO7BYnAV1gcjvKwSHGcd6AwK/3qRzcQaGDTo0vw9yiJoG3Q7ojfe5UBY5kx+yIT8NAofehhbL8j81Gg6VvZOnn8e/c54pjjrPyYxRP7FeiJRr4zGOp9APnxhdcvoBN8eMNxG2TuR0DMrD/4FGZE/a5wmBS5D30jEXwMKHL1Xg5G5Q92OLWhXFgR//vXhbQUt1SfA4wekI9CQkT4QGCvEjfLQCYlLKFkeFpzmXqSNDPLQSZYVbcZXj/CUdvonCJ9trEoKTVVt+ItbzHhWcBHqNvo9LBzlB+Pz/7TNH6Kl4jYsZ8AwyzxGemRhZM39DTYrrrMrh/kO+osJPIqiVetwIOMiiROb14cfhcA2pGRGzPdWwZ3ROmDJ6mRBLPhePT0/vuvy8k39QYC+PAAt3gFhjYCUBAHr22TAuxs/4QOgMbJ5FSrPr0ipTcabOPNxJhRsC2cg7GmTnw69QzXkcJwcItpekE7wHqtZtO84ISkK/p/WVT4ngGsY49uXwt8FwlkG9sJ
 BZ/ahA60
 2w2ttZtThkN+omtmT1CXeias48nSoFHXrw3FWBNVuxmGveaMyNL1Vbvw01nWjbDKoh04h5kjDWUTgipSeSR73loORpbWs9KnO8mgevy1pcUFPw26qAAEECJIiFjdvsuhCFDDmq4llSxEG/KMfTgcBVANGsqhvCV8NjJZuw55GAGcZF2usNlDMphRmXWk+6eg4XG9Puvl9094R/Egrwrqswq/pdDb19rNZG41HXrv1J7QSFOqN6Lcz2JHBpvLhCIPm10N3SnvVHlFjuR+eqTMTWccN+AbVaKRfqwFW+YlC86LAZwB78u6qYFGdhnDALMPZDUwbdMiPrIjeCdgcIA7iS7KydY5pyTWXo+ZN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

follow_page_pte() now walks a whole page table in one call, but still
resolves and commits each PTE on its own, so a PTE-mapped large folio
(mTHP) pays one try_grab_folio() per subpage.

Add gup_pte_batch_len() and give gup_grab_folio_pages() a run
length. Each run starts with a full per-PTE resolve, then
gup_pte_batch_len() finds how many more PTEs extend it with a pte_same()
scan rather than a re-derivation of each page, and the run is committed
with one refcount grab. Runs stop at folio boundaries, so plain base
pages are unaffected.

Gather the dirty bits from all the PTEs in a batch, in order to mark
the folio dirty for FOLL_WRITE.

Same benchmark as the previous change, with before again taken at the
base of the series:

  gup_test -L -m 256 -n 65536 -r 16 -t
                        before      after
  64 kB mTHP           2946 us      231 us  (12.8x)
  4 kB base (control)  2753 us     1198 us   (2.3x)
  2 MB THP (control)     72 us       71 us

The 4 kB column is the previous change's 2.3x, unchanged: base pages
share no folio, so there is nothing to batch. 64 kB mTHP goes from that
change's 2.2x to 12.8x, a further 5.9x from committing a run with one
refcount grab instead of one per subpage.

With FOLL_TOUCH, folio_mark_accessed() runs once per run instead of
once per page: 512 calls before and 32 after over 2 MB of 64 kB
folios, leaving them referenced but inactive after the first call.
That matches the huge-page and fast paths, which mark once
per folio. (Measured by Yuan-Hao Hsu.)

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 67e20b326be6e..47f204e21a3a7 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -937,6 +937,35 @@ static long gup_lookup_pte(struct vm_area_struct *vma, unsigned long address,
 	return 0;
 }
 
+/*
+ * Return how many PTEs map consecutive pages of the same folio and can be
+ * committed as one run. Always at least 1.
+ *
+ * The write-fault and unshare checks in gup_lookup_pte() are per PTE, but a
+ * writable run needs no repeat: a writable anon page is exclusive. A read-only
+ * run under FOLL_WRITE or FOLL_PIN does need the per-page check, so it stays
+ * one page at a time.
+ */
+static unsigned long gup_pte_batch_len(struct vm_area_struct *vma,
+		unsigned long address, unsigned long walk_end,
+		struct folio *folio, pte_t *ptep, pte_t *batch_pte, unsigned int flags)
+{
+	unsigned long max;
+
+	if (!folio_test_large(folio))
+		return 1;
+	if (!pte_write(*batch_pte) && (flags & (FOLL_WRITE | FOLL_PIN)))
+		return 1;
+
+	max = (walk_end - address) >> PAGE_SHIFT;
+	if (max <= 1)
+		return 1;
+
+	/* Merge young/dirty across batch so folio_mark_dirty sees any dirty. */
+	return folio_pte_batch_flags(folio, vma, ptep, batch_pte, max,
+				     FPB_RESPECT_WRITE | FPB_MERGE_YOUNG_DIRTY);
+}
+
 /*
  * Walk the PTEs from the start address to the end of this page table or VMA,
  * whichever comes first, and commit every page found.
@@ -968,7 +997,10 @@ static long follow_page_pte(struct vm_area_struct *vma,
 
 	for (; address < walk_end; address += PAGE_SIZE, ptep++) {
 		pte_t pte = ptep_get(ptep);
+		struct folio *folio;
 		struct page *page;
+		unsigned long batch;
+		pte_t batch_pte;
 
 		ret = gup_lookup_pte(vma, address, ptep, pte, flags, &page);
 		if (ret || !page) {
@@ -983,12 +1015,23 @@ static long follow_page_pte(struct vm_area_struct *vma,
 				need_no_page_table = true;
 			break;
 		}
-		ret = gup_grab_folio_pages(page_folio(page), page,
-						     1, pte_dirty(pte), flags,
+		folio = page_folio(page);
+		batch_pte = pte;
+
+		batch = gup_pte_batch_len(vma, address, walk_end, folio,
+					 ptep, &batch_pte, flags);
+		ret = gup_grab_folio_pages(folio, page, batch,
+						     pte_dirty(batch_pte), flags,
 						     pages ? pages + nr : NULL);
 		if (ret)
 			break;
-		nr++;
+		nr += batch;
+		/*
+		 * The loop's own increment covers one PTE; skip
+		 * the rest of the batch.
+		 */
+		ptep += batch - 1;
+		address += (batch - 1) * PAGE_SIZE;
 	}
 	pte_unmap_unlock(orig_ptep, ptl);
 
-- 
2.53.0-Meta


