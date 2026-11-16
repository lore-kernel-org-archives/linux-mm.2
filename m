Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9EEE606A331
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 21:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=H8T7hxEY
Received: by kanga.kvack.org (Postfix)
	id AB77F6B05B7; Mon, 16 Nov 2026 16:01:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A683B6B05B8; Mon, 16 Nov 2026 16:01:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9303F6B05B9; Mon, 16 Nov 2026 16:01:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 48E146B05B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:01:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4AE521C233C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:01:48 +0000 (UTC)
X-FDA: 85442203896.05.E2FBB9A
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf18.hostedemail.com (Postfix) with ESMTP id A6DBC1C0011
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:01:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="H8T7hx E";
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794862906;
	b=rsb7wbBD2ZzKwuOyfecco/OMSHOkCRcm1u42Y48uJSpbbGpIwLtgfd4AP4kR8RnPL+h7Rk
	rVpS8c0fo2Alfmn7lKJLYWthoT2CxwabprQSZfopcgfjg8RHmJdA0MOPLbox7jeL/r5aQ6
	mU6FaSioURXwkXI/8DkL4hTHduZ1uII=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794862906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9WS+yB2+j0+X38QKLnSIVyTlFGrRG2+fLICXzWaDJg=;
	b=tCd2CwSiw3D1ZIlpAHov99Oi35Gx8WcW05Lu/mqdMIcxqcIhJNsCWS0753ECKLA964AjGO
	7oW1QdrQJTVKHk3gC5qJtLptp2+u7pji4Qooty/ONDDyEghecSLDjK0ybDZuqfn+Qazbix
	FsAWhX7ocrxrUN8DXYyBKqml1Aj4V+4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="H8T7hx E";
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=A9WS+yB2+j0+X38QKLnSIVyTlFGrRG2+fLICXzWaDJg=; b=H8T7hx
	EYJyGILuyjgDpjr8j27/5X5np2919C1Lk9FS7L6ky9FXM9py1baXfLIrRawsGI9A9lYEfZydaMN/S
	/Lw19N+tXmSejvh9eC985ikez5yil8BtgXE/GvWOxfx8khWtnXkl00dWbpmSTFC65DiIyDtdphXTG
	dsxsSGHnAc7xbOXnzpasGhdMZOPnMWUlHhBXKFzJbqzkwm4v3kxuM8Sy4o+UT0K/8ivGb6JaGCpcD
	JpI0W8P3dtbeAeCtwTJ+zimqN34tAY3MkH3s1eLQTTlT6MLYVZQQT8iawFnbB2nAifKGC/pE7t8cN
	Q1osX/GAxenY2OQ7iRE46Geb5SdA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xT3pS-00000007LIv-2WmK;
	Mon, 16 Nov 2026 21:01:30 +0000
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
Subject: [PATCH v5 8/8] mm/gup: batch contiguous same-folio PTEs into one refcount grab
Date: Mon, 16 Nov 2026 16:01:27 -0500
Message-ID: <20261116210127.3837898-9-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261116210127.3837898-1-riel@surriel.com>
References: <20261116210127.3837898-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A6DBC1C0011
X-Rspam-User:
X-Stat-Signature: 6oq6g1tqj3yojzagixotyee7wx9gkp15
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794862906-992146
X-HE-Meta: U2FsdGVkX1+X9oFzwRUAMD0RfYlMP1MJQ7Mi6ynxlGueEVTvP2a1h2sUAmkloRWTlInxa0IoMoWZYt74pmzvYwImVMTuoA91Nd+zvt9LFlEQTQGFX8RI3SklYfC1WdtvHu7Zr+iYvCdF+Q4Nz8YDu9ATTkhdeWmr/4YgK3DRsS0CLsPo8xgsudYFqvxlQxnr53Ymta+yeBnMIrqIbYbVV6NViXL6lToDiv5KJ6Pht3m+SfZfgZTAM3PCy3AmV84XfX60KRV6KTsk8xJrDT3muxopR3xgLTXFC67v2RagUc8+rxLq80i0dqrkZiHOdGTSl9DVZSn8B2HGwvzbv9oN5loXW7eTvqpG86O9bx9RoQUe1rrehIfrQWHOUQGdiR21W1mlKmjb/mG98KYtLy/ZG1qb4VROOpOevjJtZCQ7eJ7lKS+aVEpf36NzpiGVWx6OWMqvL8keVRkjknPcpMLpzrPh4EoT3mpwfAwoom//PuRTB4G+Al+6aipRpu+D42b3pwf3Lw/QARqrjOVVLJA63h8DVGAFoU/ACDp0ns4HU4i2omKgXRH60LC0ciBmO4qW7Vxokdw8Y4rH2k25zFJQifabyz5pUicUZBAjDbl4S4kRhQIAQwVEYgkzwJsAJHNoR7Oyo8dW+jQBSVIZ9cYna/TfCoUoqkfuR5wC8AdiggyTB5esRFvwqd4byrvEvGV33d7HMr9WxsOAkNxfMUat4sXG6WOpL+RNtTnRVS2u+fZj3ZUxYMr8Hs3DclaY6SFOunDsDTDvOjLd7E2+NHYff3hMXz8Cvv0FjV/HhWL1HP5O5tUtTRI1zw5S/Lt7f8cXJjOfMqiQ4AkRK6PBKeshjuK+YdY4VJUaQtXIdVAXzAZ8UNF1mGw7iNAgS7TLG5eTqAFmwYr1Q6aQQxq4U/MkX+U5/nmAKYN7BKQFHvqKX9lPxRlzeliajVR5yYAGxBiRKtYCeTwbPe7yN/+8p+l
 IIpr9glj
 HTyr9HSVzl4CCvys3Ha2E38zVnIrUsPQ2GnYjzc+8S63X2Le9cpbBoUJps8leEw6dMMLFs+S1NqlkL9W17oWn6SwceBMWrST21k/M1QdqBpEctqWMEhHioF0UXiPxN9oksgpauj2eSeghrAtvyvazaZacVPVmTbrr0iYASDiVaMHIYBe9+CiuynDtlnc7Nuha6CIiqYE+pLce77W3ROARIBABQ7VeCknTg8p3lXGL8N6UjErIAn2gYQ4NPTHHJtybWw/LIqTf8UcZF2ZSfa/sfW8lH//m89G+G1J+qhpPmOLLXBSaIQqNW4dL971UUZ0pgA8Zifolyw278aL8/PhE3qKGFNyhqPvukWbVY4Bmt937ULFEW4giQHMCAxYBJLwcWY9Z8jxpdNvI+0Sh/XkSMq81NN9yIdoRvOeG4oC05OhiM2F8A7vTT6PzRtnHtQ67X/YPOF4rW4AtfaE=
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

Add gup_pte_batch_len() and give gup_grab_fill_folio_pages() a run
length. Each run starts with a full per-PTE resolve, then
gup_pte_batch_len() finds how many more PTEs extend it with a pte_same()
scan rather than a re-derivation of each page, and the run is committed
with one refcount grab. Runs stop at folio boundaries, so plain base
pages are unaffected.

Read-only runs are not refused: they are trimmed to the leading pages
that need no unsharing, with the same gup_pages_not_requiring_unshare()
helper the fast path uses. Writable runs need no repeat, because a
writable anon page is already exclusive.

The helper is shared with GUP-fast through an fpb_flags parameter
that selects the scan: slow GUP merges young/dirty across the run so
folio_mark_dirty() sees any dirty PTE, while fast GUP scans locklessly
and revalidates the run after grabbing it.

Gather the dirty bits from all the PTEs in a batch, in order to mark
the folio dirty for FOLL_WRITE.

Same benchmark as the previous change, with before again taken at the
base of the series:

  gup_test -L -m 256 -n 65536 -r 16 -t, on bare metal:
                        before      after
  64 kB mTHP          17602 us      728 us  (24.2x)
  4 kB base (control) 21512 us     2800 us   (7.7x)
  2 MB THP (control)     169 us      170 us

The 4 kB column carries over the previous change: walking each page
table once instead of mapping it for every page pins base pages 7.7x
faster, and batching adds nothing there since base pages share no
folio. 64 kB mTHP goes from 17602 us to 728 us, a 24.2x from
committing a run with one refcount grab instead of one per subpage.

With FOLL_TOUCH, folio_mark_accessed() runs once per run instead of
once per page: 512 calls before and 32 after over 2 MB of 64 kB
folios, leaving them referenced but inactive after the first call.
That matches the huge-page and fast paths, which mark once
per folio. (Measured by Yuan-Hao Hsu.)

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 93 ++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 74 insertions(+), 19 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index a8e8416b299c..484226e40f0c 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1011,6 +1011,42 @@ static long gup_lookup_pte(struct vm_area_struct *vma, unsigned long address,
 	return 0;
 }
 
+/*
+ * Return how many PTEs map consecutive pages of the same folio and can be
+ * committed as one run. Read-only runs are trimmed to the leading pages
+ * that need no unsharing; a zero return means even the head page needs
+ * unsharing, and the caller must fault it in instead. Writable runs need
+ * no repeat: a writable anon page is exclusive.
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
+	 * Even a run of one page needs the unshare check: the fast path
+	 * relies on it instead of a per-page lookup.
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
@@ -1041,7 +1077,10 @@ static long follow_page_pte(struct vm_area_struct *vma,
 
 	for (; address < walk_end; address += PAGE_SIZE, ptep++) {
 		pte_t pte = ptep_get(ptep);
+		struct folio *folio;
 		struct page *page;
+		unsigned long batch;
+		pte_t batch_pte;
 
 		ret = gup_lookup_pte(vma, address, ptep, pte, flags, &page);
 		if (ret || !page) {
@@ -1056,12 +1095,35 @@ static long follow_page_pte(struct vm_area_struct *vma,
 				need_no_page_table = true;
 			break;
 		}
-		ret = gup_grab_fill_folio_pages(page_folio(page), page, 1,
-					     pte_dirty(pte), flags,
+		folio = page_folio(page);
+		batch_pte = pte;
+
+		batch = gup_pte_batch_len(vma, address, walk_end, folio,
+					 ptep, &batch_pte, flags,
+					 FPB_RESPECT_WRITE |
+					 FPB_MERGE_YOUNG_DIRTY);
+		if (!batch) {
+			/*
+			 * Unreachable: the head page passed the unshare
+			 * check in gup_lookup_pte(), so the trimmed run
+			 * holds at least that page. Break out cleanly
+			 * rather than spinning on an empty batch.
+			 */
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
 
@@ -3017,8 +3079,6 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		pte_t pte = ptep_get_lockless(ptep);
 		struct page *page;
 
-		nr_batch = 1;
-
 		/*
 		 * Always fallback to ordinary GUP on PROT_NONE-mapped pages:
 		 * pte_access_permitted() better should reject these pages
@@ -3058,20 +3118,15 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
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


