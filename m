Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D22606A32D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=d4f04/pQ
Received: by kanga.kvack.org (Postfix)
	id 9C6F56B00EF; Mon,  2 Nov 2026 14:31:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99EB96B05B1; Mon,  2 Nov 2026 14:31:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88DF16B05B2; Mon,  2 Nov 2026 14:31:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4216B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:31:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D65F71C22F4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:31:12 +0000 (UTC)
X-FDA: 85391172384.23.883C682
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf20.hostedemail.com (Postfix) with ESMTP id 433521C000E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:31:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="d4f04/ p";
	spf=pass (imf20.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793647871;
	b=i5ZVxQE6Oxk7+27wWtZmjxJbm9cEMEwypemCT1GKX1bO/bDxo6uU0CKNJ9Zi9SBl3jNN5l
	FsOdTDziox7GbtaPQL3dH4nztmCsoxzo8VqdUQJX2COOmf24w0BmirEbUW8uzADjn+2mx0
	PLAP8hvBwVq3OCzecpY1taX7CZOL/vk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="d4f04/ p";
	spf=pass (imf20.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793647871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K4zW81m8lz2rVHicSvgVGAJW0sedRnDfC1U5tufjT9M=;
	b=d6HM7bTy0Z1oOUZCQ+XiWVImhrLJ4+yRLIXRQHwVoZ4ZyaOcUKVXsZQ4mDSQR+MRewySG3
	blz/sSF+wi5QNnCdTZRoapqtU8ayPMsoRUb1R6kpq+Q+xGxFrSHceaSbAqPoQ7zo9aJFLW
	Y8wMpYlFq+LgPsG0i68rwAmcz9cW8fE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=K4zW81m8lz2rVHicSvgVGAJW0sedRnDfC1U5tufjT9M=; b=d4f04/
	pQEYXAThvRzHyhhzOr/tEv8hkX5De7iclJDHyvRjKQ5JzKKqpwZ/hRGdcvVF1FTqf9TKbjENa2oTG
	GXejnNKOMk51gZTLRJ4w2YwoetLEZO7ZmKmpmQONUV2/OMpTWqJKF2B4TN+5s8oIDz1zcGONOGUKs
	TRO8j4fs9HVR6Du5dh5Emau7A4XvPEUhSJmumYB0tfWjn8iX5MJb/5YgO8AluFNq12ZQOHn4nBLif
	cxrLL59ji2iqB9eoVRtyN3T0wlgGP41++xpYA33sI/yHTYbswqISpw8V+Y/isGKb/A9cKA8D2qmaR
	Z4aZqMO70SS2ev01VT1bqgR+7YKA==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xNxjk-00000001W8x-0zAX;
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
Subject: [PATCH 7/8] mm/gup: walk multiple PTEs per follow_page_pte() call
Date: Mon,  2 Nov 2026 14:30:25 -0500
Message-ID: <20261102193026.3860700-8-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102193026.3860700-1-riel@surriel.com>
References: <20261102193026.3860700-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4hqdmtwikzhiy5fgyjf4rps63enejj3t
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 433521C000E
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793647871-768938
X-HE-Meta: U2FsdGVkX1/ISCim7EeJG+eP8bw8Fne+Slqu/ZlujFf0KHcfyVUPObuX1ota9arx4TyUIltrbginKE94TLMh5xmIm+8OkmB2aeiZjZx8QjjfV7o4FOkjca24ZOiYVS+7KoM7iNx/mlP1Kcx59k2T1PnOstFWeF1WcIhUWKa8o5DOz0wwndImPrUQVYXDo/mpQ58AUKNoFM6verb/Fa1X2+bowL5U9gh3QqL1fu59wVy4GYo8xl2GdXge0Zu7tLM9o47DGaIfL7Rtutk6pkcKO6pJYhPYZRetY43IjaksIhy+N+q/X5U/rNtE+hhH+XPD2jm3SSgNcsCU04gYljg6NLYvMY5JJKtCSPTthM7/KZu1B+QyxpE/UkWH10fsUfnvjy0iWYP1LCJJ11EbkoZi8infSw3BYP4tDz8tVdJsIJdosxInm1gbdXasGl1rUFR559/ggRj4/0+HoYEljk0XnfGOiydIYly035ez3iqPbj4v4nN2V1ffVVtPq200LnhLD9PN5gpSJfAbDrZTfpHnlPhjbRlL+vWALY4v4v3l/5OggGxk2zVDhD52IGRSwdVPaYA4Z5lT96OeyWYCdaTi9GEwkqZEb5MvTpnGnxwSOsG3Lfea7QX73W/9OutBSdGbrfMmwSiDDqpPFwGnQ5a/VU2awifbRhzAW2kDzUO1tGUdxfmTMFy6//JzZUv19fRiWlWDDy//UKiifV4TIIuoa5l6DNOpxWl92uDXxRWV7aAityVIp4jtkEtlLmMjt+FrZLjHO+yNBD3MbQTB4biCq12NMsTQDmbXS3omrKZepp82a3TvUgNno5ptWwtmb6+e4zsAXg/GNt5isp6MbdjjCtrmxmpiGspyP8Rc1rmZNB3ONumN4GDdMRVoa50H4/Ut/dNKdphC19fiVbnEnm3tB9o36Xng1U3RH5+dG1+74pjK2v4/zqUh5HESmwizDSBjFNW71X7CdpLj8qv6v/6
 Qh6uTSbc
 IKjpq/IcUH7LufwFsj5c+0rpPBWgCAhlq6+c0djCiquoSigvexF2Acq4/YmGydWbL8FqQIjM4QUspluhxflMXqRmhMmwfKnEJdOBUEE0G36qKpQG+HR3gYEnPs6vSxwnII5BlUkhm4UZZbIWWEijNmxnAJBmWz0vGktPhokuEl7CfobLQ4bjloigpLPlba89N3S9+vD189ODlry6ZB1G624JPcL5AwQhNo5IDMpGL1HFXDKVDWevDJFtC1a6QVjjl9dDYW9o06pFP4/IAXz8xDyDLUKmD3m8BAbGRtIrnnLtIuBqX+LQuuqh5XOA+ZI0QtF2tLykkCB4B/rI1G3QEIchK8k8frjo090/kMGJ+jS2vg4RJh/nL4QZlZLP5if2sdHDqtF6hekicPlc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

follow_page_pte() looks at one PTE per call, so __get_user_pages() calls
it once per page, restarting the pgd/p4d/pud/pmd descent and retaking the
PTE lock each time.

Walk every PTE from @address to the page-table/VMA/@end boundary in one
call instead. Adjacent pages from different folios, or plain base pages
with no folio relationship at all, are covered by the same call under one
lock.

A failure on the first PTE is returned as before. A failure after that
ends the walk, and __get_user_pages() retrying the read gets the error.

The pages[] slots are stored under the lock, but the cache flushes run
after it is dropped, over the pages the walk stored: holding one page
table can cover up to PTRS_PER_PTE pages, and the flush helpers need no
lock once the folio references are held.

Measured with mm/gup_test.c, median get time over 16 iterations on a
256 MB MADV_HUGEPAGE region in a 4 CPU VM. Folio size was confirmed
through the per-size anon_fault_alloc counters, 4100 folios for 64 kB
and 128 for 2 MB:

  gup_test -L -m 256 -n 65536 -r 16 -t
                        before      after
  4 kB base pages      2753 us     1178 us   (2.3x)
  64 kB mTHP           2946 us     1361 us   (2.2x)
  2 MB THP (control)     72 us       70 us

Base pages and mTHP gain about the same amount, because what is saved is
the page-table descent that no longer restarts per page, not anything
folio-specific. 2 MB THP does not reach follow_page_pte(), so it stays
flat.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 77 ++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 27 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 9e7eb8a323bbf..67e20b326be6e 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -937,44 +937,67 @@ static long gup_lookup_pte(struct vm_area_struct *vma, unsigned long address,
 	return 0;
 }
 
+/*
+ * Walk the PTEs from the start address to the end of this page table or VMA,
+ * whichever comes first, and commit every page found.
+ *
+ * A failure on the first PTE is returned to the caller. A failure after that
+ * is a short read; __get_user_pages() retrying the read will get the error.
+ *
+ * Return: the number of pages stored in @pages, 0 when no mapping exists at
+ * the start address, or a negative errno for a failure on the first PTE.
+ */
 static long follow_page_pte(struct vm_area_struct *vma,
-		unsigned long address, pmd_t *pmd, unsigned int flags,
-		struct page **pages)
+		unsigned long address, unsigned long end, pmd_t *pmd,
+		unsigned int flags, struct page **pages)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	bool need_no_page_table = false;
-	struct page *page;
+	pte_t *ptep, *orig_ptep;
+	unsigned long walk_end, base;
+	unsigned long nr = 0;
 	spinlock_t *ptl;
-	pte_t *ptep, pte;
-	long ret;
+	long ret = 0;
 
-	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+	orig_ptep = ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
 	if (!ptep)
 		return no_page_table(vma, flags, address);
-	pte = ptep_get(ptep);
 
-	ret = gup_lookup_pte(vma, address, ptep, pte, flags, &page);
-	if (!ret && page) {
+	base = address;
+	walk_end = min(pmd_addr_end(address, end), vma->vm_end);
+
+	for (; address < walk_end; address += PAGE_SIZE, ptep++) {
+		pte_t pte = ptep_get(ptep);
+		struct page *page;
+
+		ret = gup_lookup_pte(vma, address, ptep, pte, flags, &page);
+		if (ret || !page) {
+			/*
+			 * no_page_table() may look up the page cache, so it
+			 * cannot run under the PTE lock. A none PTE returns
+			 * from gup_lookup_pte() before any write check runs,
+			 * so this is the same call the old code made -- not a
+			 * new failure mode for FOLL_WRITE.
+			 */
+			if (!ret && pte_none(pte))
+				need_no_page_table = true;
+			break;
+		}
 		ret = gup_grab_folio_pages(page_folio(page), page,
-						     1, pte_dirty(pte), flags, pages);
-		if (!ret)
-			ret = 1;
-	} else if (!ret && pte_none(pte)) {
-		/*
-		 * no_page_table() may look up the page cache, so it cannot run
-		 * under the PTE lock. A none PTE returns from gup_lookup_pte()
-		 * before any write check runs, so this is the same call the old
-		 * code made -- not a new failure mode for FOLL_WRITE.
-		 */
-		need_no_page_table = true;
+						     1, pte_dirty(pte), flags,
+						     pages ? pages + nr : NULL);
+		if (ret)
+			break;
+		nr++;
 	}
+	pte_unmap_unlock(orig_ptep, ptl);
 
-	pte_unmap_unlock(ptep, ptl);
-
+	if (nr) {
+		gup_flush_pages(vma, base, pages, nr);
+		return nr;
+	}
 	if (need_no_page_table)
 		return no_page_table(vma, flags, address);
-	if (ret > 0)
-		gup_flush_pages(vma, address, pages, ret);
 	return ret;
 }
 
@@ -994,7 +1017,7 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
 	if (!pmd_present(pmdval))
 		return no_page_table(vma, flags, address);
 	if (likely(!pmd_leaf(pmdval)))
-		return follow_page_pte(vma, address, pmd, flags, pages);
+		return follow_page_pte(vma, address, end, pmd, flags, pages);
 
 	if (pmd_protnone(pmdval) && !gup_can_follow_protnone(vma, flags))
 		return no_page_table(vma, flags, address);
@@ -1007,14 +1030,14 @@ static long follow_pmd_mask(struct vm_area_struct *vma,
 	}
 	if (unlikely(!pmd_leaf(pmdval))) {
 		spin_unlock(ptl);
-		return follow_page_pte(vma, address, pmd, flags, pages);
+		return follow_page_pte(vma, address, end, pmd, flags, pages);
 	}
 	if (pmd_trans_huge(pmdval) && (flags & FOLL_SPLIT_PMD)) {
 		spin_unlock(ptl);
 		split_huge_pmd(vma, pmd, address);
 		/* If pmd was left empty, stuff a page table in there quickly */
 		return pte_alloc(mm, pmd) ? -ENOMEM :
-			follow_page_pte(vma, address, pmd, flags, pages);
+			follow_page_pte(vma, address, end, pmd, flags, pages);
 	}
 	ret = follow_huge_pmd(vma, address, end, pmd, flags, pages);
 	spin_unlock(ptl);
-- 
2.53.0-Meta


