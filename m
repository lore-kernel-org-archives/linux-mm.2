Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA7C606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=GyCi9MXd
Received: by kanga.kvack.org (Postfix)
	id D5D2A6B05B7; Mon, 23 Nov 2026 14:56:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4E66B05B8; Mon, 23 Nov 2026 14:56:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAC366B05B9; Mon, 23 Nov 2026 14:56:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 653986B05B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:56:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 01C7516093E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:28 +0000 (UTC)
X-FDA: 85467440898.08.052235F
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5A39940006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="GyCi9M X";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795463787;
	b=32SiQ8dJp2p9X7cFm2R2e7bS6JVPs7I104abphEG3D/WADBA/RWsZP1yy3jBkGsN1G43IM
	BqIAuoXfeKfwr+ZmEP5GMir3v/pp+VIixgX8YZ95/KZ0veGVCW1Oi7aGVYSmW0QWKoNSno
	BOB38XQ5ZhrRnf2hSlr8L4lpG8qIwWM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795463787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Can82GwJLZ6xNFloN0UvipHW26+kIvgtH3oyrupC710=;
	b=Ve0HRs+jhUJEu7NErGcUpv5hYuhanICORXQHm3b0Rv0UWs3rwAtw9z93cPGJFrjRwpPlZv
	/xE82wbM1j5vxmZF0XSbdDD4o75PzDqEW92Wc3L7UpbPTVwvlrsMpP7WDvDrVaowy3z1DX
	roH38927IvOQJFG+b16wXRrtBTv8HK0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="GyCi9M X";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=Can82GwJLZ6xNFloN0UvipHW26+kIvgtH3oyrupC710=; b=GyCi9M
	XdMGJPLYKb681Mul/PozoVN4IhEIQlzk2y4fhyibojn2D4rnbJztGxsCKbCamUO2H0/aBjW13Af+R
	QGtBTPfimG+/LUIug75QleEtpH5Cg9MfRHuWX1Zn3eYjBEwiIQMfAXji5jZ2b26Py2H/AlKMJ+NDS
	UUhuoSPpmM8jImd+IMld6fQUGG7MHXTgolYiF56a/qAaqz5x2iV199RbmOayWnco7zhJbUsfLsA5p
	k2lYz08oYTnxS3p5CIbBAUMNM24gCv/TdIGhPLJ0RzmSj/i6MkBS3msbIqqCv5rPsJM2XKMBNdUTT
	IeLUsWP1pOaImNhHX/YTPMXEgwKg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xVa99-00000006IU7-25zi;
	Mon, 23 Nov 2026 19:56:15 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Peter Xu <peterx@redhat.com>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH 8/9] mm/gup: batch contiguous same-folio PTEs into one refcount grab
Date: Mon, 23 Nov 2026 14:56:08 -0500
Message-ID: <20261123195609.4115244-9-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261123195609.4115244-1-riel@surriel.com>
References: <20261123195609.4115244-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 5A39940006
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7hokqphsi46tmxpiughro3i1hk3s5f53
X-HE-Tag: 1795463787-122724
X-HE-Meta: U2FsdGVkX18wRRZhkjLnBrW/6ObBnSSU1bSD6mcgAcuf6SN/hn/G2uhory71McC9SSm0BIDnkvrKBJi8yHw0JoEAhDnCOXm413b3735vdt6Jt9ZU/MguaLZlCJb47H31Z1iH0UA4pth4bejvYaQZBzumHS2l7AHUUEAbYiKzEf2fcdwd04SVtJ/03f/Bks5wCqqI6ZolJiFVSRjdlePOkxZIGEu5gL9XLd4lKazzt+nC0a1YHqq9/0ft4DnFlC42ev3XYVhD5aDDoJWMk6jvevhX+J3yhNIi8rCDmecLOv1elwZbnpJ9w8alRGOBgOPzd0DKX7yiuUBluBEpefLJCziSgn6EGIs3NVw/1ikv/MW2DuXkoc1L1U+CiRdthNkImk8cKfqE/T9mxqKjCgx2VlGMsAEAhBohBz6NNVkiXhD1StWK9LQUE/Pg007uMOOFCuItfqQEkbKoRG+fGCTbcNxS8FO4OqADJoFTbtl9X7vNmf0zF9r2xtGB1e2pmg/3NeT/LcNVv1o9RULwLJ+vXPlDeMFCAq7U3VIbMgoNShETApvnnVj0fEPkH8/ytl7mc3BYRq2ApJlzngo3jdPH/mXFVWN2SVaMSZftmdNoHFt7dvHcdrEc6xGxnsk98SA9wxLUQ5I9sZqpgHdh0pgJaaYjwil0EYAHWu01wqhmrCpeVo1HoI0whEpoAp0gBT8+xT7cWDkRnIewxjQridVivyUkrBFSyuqzaMpHM9N8gajC4blRzGjl29WwVfL0sbsXHidES43XFFeuP4s9C+6FRr3jKI++Nygdd/bCBBdqE1jEXrqfg27JIH817CE9fJGxtExoZ6EQxgDOT3mr4P+mkpmmBJN0hwR99guhyyAicYXqL9XFejYDMUlhvLJYnMochR6WCMyGk+aolymAxQD1p/fKtXBzi24vinD6eu5zp4RSJQ8q9U2R6PQqcPF0jMd2tK/j9oO5LYBXo1aY7DY
 uzuORpkX
 bkaz8Uh1SXeujMnHZXRn+JfUoACnK3usV20eM4PNgcI3YXXKlZQA5nwifssuJIN7DOBQU1EK65Z6d72XzjAsRmOrMBsAvHiZz3hPiRsI5GZdday+Ex7Zkqp0QiBsdh6+uOX1QOYdA+Xk4ecFYEQUF3CA+Ke1aKQ3ddXIs7gUzCPHpIetppou7if+/Ic2TYECjIlH5xj4pibFUA6vlto3XI4wt+aS/BzDBsj9wiOlnVFuvAQHmfTRF5PAhJIcmQA7X0++EDLNSSplDIVdnxTSrQa26dDNDpbxXl2USdLvM7q+1bAO8j5Ac9UWd/et+dA8zMMFudw81zRui2k640h3LyaarMb6Tg1weXv7I6yYVJucNhk5DL1acI0r1jXx/jD67mBQjGL9Tz1O3oaRQ/CgE3KxC/U1G04nVH5TijCAa9h6/5z5MxB/2EkAkyw5e5nWn3JjitQ8s4qDbgcq+ZwZPuPvbFVseWw808HjRt53d2toxPPX/jJzTlBY40A==
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
 mm/gup.c | 95 ++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 76 insertions(+), 19 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index b5747f2c2ca3..886a413b8233 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1011,6 +1011,46 @@ static long gup_lookup_pte(struct vm_area_struct *vma, unsigned long address,
 	return 0;
 }
 
+/*
+ * Return how many PTEs map consecutive pages of the same folio and can be
+ * committed as one run. Always at least 1.
+ *
+ * The write-fault and unshare checks in gup_lookup_pte() are per PTE, but a
+ * writable run needs no repeat: a writable anon page is exclusive. A
+ * read-only run under FOLL_WRITE or FOLL_PIN does need the per-page check,
+ * so it stays one page at a time.
+ *
+ * @fpb_flags selects the scan: slow GUP merges young/dirty so
+ * folio_mark_dirty() sees any dirty PTE in the run; fast GUP scans
+ * locklessly and revalidates the run after grabbing it. @vma is only
+ * needed for FPB_MERGE_WRITE and may be NULL otherwise.
+ */
+static unsigned long gup_pte_batch_len(struct vm_area_struct *vma,
+		unsigned long address, unsigned long walk_end,
+		struct folio *folio, pte_t *ptep, pte_t *batch_pte,
+		unsigned int flags, fpb_t fpb_flags)
+{
+	unsigned long max, nr = 1;
+
+	if (folio_test_large(folio)) {
+		max = (walk_end - address) >> PAGE_SHIFT;
+		if (max > 1)
+			nr = folio_pte_batch_flags(folio, vma, ptep,
+						   batch_pte, max, fpb_flags);
+	}
+
+	/*
+	 * Read-only runs are trimmed to the leading pages that need no
+	 * unsharing; a zero return means even the head page needs
+	 * unsharing, and the caller must fault it in instead. Writable
+	 * runs need no repeat: a writable anon page is exclusive.
+	 */
+	if (!pte_write(*batch_pte))
+		nr = gup_pages_not_requiring_unshare(vma, flags, folio,
+						     pte_page(*batch_pte), nr);
+	return nr;
+}
+
 /*
  * Walk the PTEs from the start address to the end of this page table or VMA,
  * whichever comes first, and commit every page found.
@@ -1046,7 +1086,10 @@ static long follow_page_pte(struct vm_area_struct *vma,
 
 	for (; address < walk_end; address += PAGE_SIZE, ptep++) {
 		pte_t pte = ptep_get(ptep);
+		struct folio *folio;
 		struct page *page;
+		unsigned long batch;
+		pte_t batch_pte;
 
 		/*
 		 * no_page_table() may access the page cache for a
@@ -1061,12 +1104,33 @@ static long follow_page_pte(struct vm_area_struct *vma,
 		ret = gup_lookup_pte(vma, address, ptep, pte, flags, &page);
 		if (ret || !page)
 			break;
-		ret = gup_grab_fill_folio_pages(page_folio(page), page, 1,
-					     pte_dirty(pte), flags,
+		folio = page_folio(page);
+		batch_pte = pte;
+
+		batch = gup_pte_batch_len(vma, address, walk_end, folio,
+					 ptep, &batch_pte, flags,
+					 FPB_RESPECT_WRITE |
+					 FPB_MERGE_YOUNG_DIRTY);
+		/*
+		 * Break out if the helper says the pages are not
+		 * usable as-is.
+		 */
+		if (!batch) {
+			ret = 0;
+			break;
+		}
+		ret = gup_grab_fill_folio_pages(folio, page, batch,
+					     pte_dirty(batch_pte), flags,
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
 
@@ -3021,8 +3085,6 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		pte_t pte = ptep_get_lockless(ptep);
 		struct page *page;
 
-		nr_batch = 1;
-
 		/*
 		 * Always fallback to ordinary GUP on PROT_NONE-mapped pages:
 		 * pte_access_permitted() better should reject these pages
@@ -3062,20 +3124,15 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		if (!gup_fast_folio_allowed(folio, flags))
 			goto out;
 
-		if (folio_test_large(folio))
-			/*
-			 * The reference acquired above keeps the folio stable
-			 * for the following checks.
-			 */
-			nr_batch = folio_pte_batch_flags(folio, NULL, ptep, &pte,
-							 (end - addr) >> PAGE_SHIFT,
-							 FPB_LOCKLESS | FPB_RESPECT_WRITE);
-
-		if (!pte_write(pte)) {
-			nr_batch = gup_pages_not_requiring_unshare(NULL, flags, folio, page, nr_batch);
-			if (!nr_batch)
-				goto out;
-		}
+		/*
+		 * The reference acquired above keeps the folio stable
+		 * for the following checks.
+		 */
+		nr_batch = gup_pte_batch_len(NULL, addr, end, folio,
+					     ptep, &pte, flags,
+					     FPB_LOCKLESS | FPB_RESPECT_WRITE);
+		if (!nr_batch)
+			goto out;
 
 		/*
 		 * We need to make the page accessible if and only if we are
-- 
2.56.0


