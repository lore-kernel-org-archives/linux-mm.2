Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACD3DC5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 03:30:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D2F96B008C; Mon, 10 Aug 2026 23:30:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583056B0095; Mon, 10 Aug 2026 23:30:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 499156B0096; Mon, 10 Aug 2026 23:30:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 21C1A6B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:30:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2881A0356
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:30:00 +0000 (UTC)
X-FDA: 85087559760.02.77264FE
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2B789100010
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:29:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=B1KNBknq;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786418999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YYSV7ewB+nMetdXPY8LjvmotcaHNCvlEgZ2HICuq4Os=;
	b=rT1Yw8kimTvTIa0sMXO7pdNAB7tRDaWiyyFguF3wndIIZks9ab2vkPgU4+KSCLWw07bevL
	ZPN5ky5cLuvctZeN/s50WLUKgWJmitdyguzjYoXilLCWyNNf152JerNIj1lfURba7gLHL0
	Af5vUhglT32g0TY01ALslPZ7mV9veiE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=B1KNBknq;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786418999;
	b=kxEH5oXC9EMYpXvEI+QfowUMKno1B/JBdIV31qNE3EmIazgpo/OM7sEfGcdxHbs189IZTT
	/YDy2kH59evuY2aZlBFopem6MPuwhSQzilMXsYJYwi2zNLDJJpdU7CZdglqIe7n4bHGZMB
	DPguo0IszogtWJQQ77rbfSsCl7H9zvs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YYSV7ewB+nMetdXPY8LjvmotcaHNCvlEgZ2HICuq4Os=; b=B1KNBknqtNr4D8k8c+8D19ORi4
	bZCvNF99HN347La92JvlZe+SdQjR6lNY2OGg0oqAVXL1UsaI4ybJkbrOOHcQlIRIKQ/mvHT9XDwI6
	ZvjMAPZRwfe7U94/SSU9H1Tcz1qS3eybTAxbuShMZW6PenRkiJtUvxo7+pDK3JcX3pcpjJ8obQe1X
	/SnGj6U68Prz7w7o22f8+Cin5/EyrbdX6YIBHgWUFb6gj1yqRJAbymxF488EsBN8I+eCjPFhd7cqh
	C6kWlRHCZTccIGh2GgxBdoeUqLDd7iNYzp0/zEh0bTZytzrqLMT9T+6wAGd/XKwIZqSekFMBO2ifG
	AVq8hzkA==;
Received: from [96.67.55.146] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wtcb6-000000007kZ-321P;
	Mon, 10 Aug 2026 22:52:12 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 8/8] mm/gup: batch contiguous same-folio PTEs into one refcount grab
Date: Mon, 10 Aug 2026 22:51:57 -0400
Message-ID: <20260811025157.1632867-9-riel@surriel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811025157.1632867-1-riel@surriel.com>
References: <20260811025157.1632867-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dex4zdns8x1yiidp7pw47byf17161dpk
X-Rspamd-Queue-Id: 2B789100010
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786418999-334362
X-HE-Meta: U2FsdGVkX1/S4QE8KCUnZW4dQylVNi3+eCRb6gKvP5wdImt9/aQa0CxCv1VxHVVTwADaAESwQkbkaKGCaVwb/C6r7aYeiQoQU0DmHmGZDP1VCkjG+CsXPJT32BOFQstoFxR+JiCluJZdaCvX3hIG+tn1RlWJ7Ban5CGidIU3qBkCwPGlSb/ufWfin8fYi74XVQOjySk626rmmX9MOaD91T+keg4yhW9Wdh17iuzEu5BRQ3UZeRknU6bWzOCSYYl0sa7c28dflcPZ25QYgKS3bEZngWcorHjko18g8rwqlq9v51OcBhAjxFlrI3l7NumMkgSN21dBU/Ll9c9YusnIBGdgM3InlHJPhCTIRz6aYjiPSoX0zACiCvz5c92WzaAGrIMKylehCx+Y/T99ewWmt+7KBK1E/RHXOU7pWzClX+uGp3m26IaGV49VtKwl8B4pHBYoBEcvmZdW4qB3InbM1seWmYxz1g1QgwKzQqE30kGL0d77Xf8tsejpQFlf87l96NL8lovnljDpFYXniUsysJa+4ap6RW3bwPjr2V2wDCtL88QTYt18TYHTUA/MpfjkcHqaNEBYzkFjYGq1oPT1HqpYpPbEGPjIwsljLvbnTlWXmrlT83ezkMGdYFDR2dO+2pZl1YuTWM8nJzvlVSQDHmsCf2nl4IvJPyY24jSJNEgNr/XnDfu8kEAbjXvUVvLlCP/HWJplkcXOXnvcBT7yA93wdrNOT6/6P2iurEnpVIjpWJsfaXFaG/7whowbc4opzLGuSsCtOnA96SL6Y3uMwUaa40Ace3hLDFGWYG8xgp3ctVv7Jd5VqKeZbBMDqVUB1jv43nNg7ugmupuVLjSDixSBx8BVMb7n9QiYUENjD8j5164W3ckgZaD7hwSJ+wQqzeP98q17cH63ugDFvoAPgjuqxXO1mX7wfTmsPXm8UxMIRtQSutfKkoAUWikY9zorJxjjQ7MNWmcmXqSLISu
 C/WEK1h7
 umWk4P5Yoslg5lC6QV43ymQNpV7fAU1a5wkOsPmy18cDOpt6k8Ta/r2zljKdDrxk8XCiiY+bd9aLPuJuPk6fvKcwcEU8jg3XejNFbiRlB2DzKTRJh8jrSlc3wIKFwZYMunzoFE0VHql6lkj4hqBLA0gjE+Jx/h7lR5Bk2KdAqf7FOmUmjIsAdC3KHk0Xf0WZcpOw9TbRy9mHim/gNN0cqe4mBIGO+JXGa5Y72buvU3DefHMfwYKyx78gJzmoboQAQFroS3H1DBgrCZGvqoQefN/dOuD+zSsqtf7dezM8WJ0EJy6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_page_pte() now walks a whole page table in one call, but still
resolves and commits each PTE on its own, so a PTE-mapped large folio
(mTHP) pays one try_grab_folio() per subpage.

Add follow_pte_batch() and give follow_page_pte_commit() a run length.
Each run starts with a full per-PTE resolve, then follow_pte_batch()
finds how many more PTEs extend it with a pte_same() scan rather than a
re-derivation of each page, and the run is committed with one refcount
grab. Runs stop at folio boundaries, so plain base pages are unaffected.

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

Suggested-by: David Hildenbrand <david@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index c4233a7b8a48..106806634b3c 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -833,12 +833,13 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
  */
 static long follow_page_pte_commit(struct vm_area_struct *vma,
 		unsigned long address, struct folio *folio, struct page *page,
-		pte_t pte, unsigned int flags, struct page **pages)
+		pte_t pte, unsigned long nr, unsigned int flags,
+		struct page **pages)
 {
 	long ret;
 
 	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
-	ret = try_grab_folio(folio, 1, flags);
+	ret = try_grab_folio(folio, nr, flags);
 	if (unlikely(ret))
 		return ret;
 
@@ -850,7 +851,7 @@ static long follow_page_pte_commit(struct vm_area_struct *vma,
 	if (flags & FOLL_PIN) {
 		ret = arch_make_folio_accessible(folio);
 		if (ret) {
-			gup_put_folio(folio, 1, flags);
+			gup_put_folio(folio, nr, flags);
 			return ret;
 		}
 	}
@@ -866,7 +867,7 @@ static long follow_page_pte_commit(struct vm_area_struct *vma,
 		folio_mark_accessed(folio);
 	}
 
-	gup_fill_pages(vma, address, page, 1, pages);
+	gup_fill_pages(vma, address, page, nr, pages);
 
 	return 0;
 }
@@ -916,6 +917,35 @@ static long follow_one_pte(struct vm_area_struct *vma, unsigned long address,
 	return 0;
 }
 
+/*
+ * Return how many PTEs map consecutive pages of the same folio and can be
+ * committed as one run. Always at least 1.
+ *
+ * The write-fault and unshare checks in follow_one_pte() are per PTE, but a
+ * writable run needs no repeat: a writable anon page is exclusive. A read-only
+ * run under FOLL_WRITE or FOLL_PIN does need the per-page check, so it stays
+ * one page at a time.
+ */
+static unsigned long follow_pte_batch(struct vm_area_struct *vma,
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
@@ -947,12 +977,24 @@ static long follow_page_pte(struct vm_area_struct *vma,
 
 		ret = follow_one_pte(vma, address, ptep, pte, flags, &page);
 		if (!ret && page) {
-			ret = follow_page_pte_commit(vma, address,
-						     page_folio(page), page,
-						     pte, flags,
+			struct folio *folio = page_folio(page);
+			unsigned long batch;
+
+			pte_t batch_pte = pte;
+
+			batch = follow_pte_batch(vma, address, walk_end, folio,
+						 ptep, &batch_pte, flags);
+			ret = follow_page_pte_commit(vma, address, folio, page,
+						     batch_pte, batch, flags,
 						     pages ? pages + nr : NULL);
 			if (!ret) {
-				nr++;
+				nr += batch;
+				/*
+				 * The loop's own increment covers one PTE; skip
+				 * the rest of the batch.
+				 */
+				ptep += batch - 1;
+				address += (batch - 1) * PAGE_SIZE;
 				continue;
 			}
 		}
-- 
2.55.0


