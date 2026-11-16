Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B3EA606A330
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 21:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=hmoX5406
Received: by kanga.kvack.org (Postfix)
	id A6A846B05B2; Mon, 16 Nov 2026 16:01:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A766B05B3; Mon, 16 Nov 2026 16:01:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BB376B05B4; Mon, 16 Nov 2026 16:01:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 42AFF6B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:01:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE9EE1601BE
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:01:46 +0000 (UTC)
X-FDA: 85442203812.23.896B7BB
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1188EC000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:01:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="hmoX54 0";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794862905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+Ow589OsLW9rn6bN/c8iI6gGetFJ89YNOlJdWeWBDI=;
	b=HKedv7NAqsABz3tm9pzVwY+Fy44oZUbRdIT/PkftxrPNstqEraVLGO98wDyzfZCjaWn98t
	YjgWyJp6GuIog3EurvL3Mfjya9QflC/9gyP42Qg1CPNGmhqRgDP7lrQyZH0+7Ray6dGz5i
	xf+ZEUrWH12o3P5Hbmq8NE6d1utzVQ0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="hmoX54 0";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794862905;
	b=llUaU07RKMU4pE+oDC/DhN3wTd10P+ozw1inmk52mCjv/fKR8vhNZnfIqq6kQPxdrTVaDc
	1AaLlzJ3vPwR1phxzGakhxCvhfETfxF+5DsgcoIvr0qPBIw54AZnYoZXWfEATFlDx7WeMt
	fhLUV32ilHnIuoTxIUmLxiQw8q2wwZ0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=y+Ow589OsLW9rn6bN/c8iI6gGetFJ89YNOlJdWeWBDI=; b=hmoX54
	06WjYFnkJJrVKqeWkKunQbfnUnocTW13GlSshENgUZOUv9enTOhor8CvrT+84upGVTtWdMpglimiH
	uqdS0288S5unSMpXw/4xsSXJ05uJVNy8nAcYmCISLfYEh4GL2Jq4NUHybT4jq0jMDehTKHlThIwDa
	rjhhL+Gjo77b3GaiPE4xbIqEmUsO7s6b4g2kirhyGTIhf537LEKEuPihWNHYZh+7iXXKilOGWAChV
	4K4jEq2XfrznHaiXfqUOC8WCAM/h5Vpl134CPWmi0rjYNgNtBcYWVmeGixCOjnFQBtWAwzSQSesSS
	lpKS3VKLv7xWGPUN9CJ58/6GGZ5Q==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xT3pS-00000007LIv-279h;
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
Subject: [PATCH v5 4/8] mm/gup: split out folio grab-and-store helper
Date: Mon, 16 Nov 2026 16:01:23 -0500
Message-ID: <20261116210127.3837898-5-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261116210127.3837898-1-riel@surriel.com>
References: <20261116210127.3837898-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1188EC000D
X-Rspam-User: 
X-Stat-Signature: fre77chuf59m8pdcbhq4udhitspqba3p
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794862903-366068
X-HE-Meta: U2FsdGVkX1/9lX0zoZtuHImEFNtCUpzdHw3S1wQ8iaia3SfdyD0PHs5sdr2ov9clpTo4fkxF3oFZEDYntIc9lGV2g39zKTihyFwNgCFPzDeCLr6l54nHMbR5ZYc1JLW/rEAFaLLTklKFQ1pKXpU3l0WEPMY3oelqxt+jh2ui3TmCKub5Uj3o3mvrtOIOkx3jzdJ+7XhuavUnZDo05KBLyJXhUXACV3Rk5iOMlhJxg2F59mnCYYmYgfmak3pfWPeEBvhdAE2gdkn4aPZfkGmR04GkjfhSAJHd9qyh5n2EJZBtQ9Q3HLT6np2AbT+QP1AuAjDjzjy7092l1mlsPwlw7iAP3aWWmE84XLREMNikucuSNkmB3xvn9Ot+J8u6zT6l+7GGWjWaSeqqh8vdwBqwiyODCxi2APheyd68UOG801/SWSeb2Zc2jvuQ0Nk0AliuqlIeFVZxDmx1f18NnOZb+BXaxV822ooUE5zhw5ntmIpPleXmOXSK7R49YzzVHYLN+vjoNpHm7zgE9MpOezyeVc/BSVC1DkN3PFD4a/DkvKvNmBG4zW4wLGHMb5F8u7I0itIZKOrhL89x1QMq0iZGGkmjQQ5efDegmLh4Q0gwZp1+c+pl54n/ahXB3h9gEUHOQahMRnSQ7fsU3ExSqfTqD22MtOpM29e6bopulyw8OMs6yhtTKPDrVA4KAJwhKPC0Z43b5OEZIQkZyfInmOnuYY4j9QIHev91vy/pkTXh6i2/48ACg0sDgaXMH7RSkty3YLSCxHNZldL/z3cbbHs9YAKTKK8XxJJrfIMS29IyyhglkU5OM//lWnazbFSYIXY+eXtFcIq5HvoelGMUjyBYUIIpgxaHOTv3MEWja9drtoqKuHLQtU3cHNPjvuC9CNGxtMyr4FIE3EKSuDFLkx++whGWmnFVroz6HJlTaA5To10MNtorBKnqdm6RKePqMAFAO611gEoW2nCfzZzVLpa
 qgQ7glGe
 iwgRcb5WyLKVD7rb6IMZOszSCbPJBewTB0QZ4cV4FUx5k3PQam99cxaIwIdOOojN7KIWObGHqaz9uHcGCMa37YLC6fE+EgTOMO9M40PKL00a8HvsY9ZeB/z6C6prtXM2PohbkTe9I6gwMhNNZnsYzprG5UakicS/sBXRo02yIS3LcCbN5FnvYNU/Mr1SB1iACRRx6qEX0pN4TYSDcOgS6rx/x9vPHFzr+Lefp1p9os3JO+Z+8kuHKWsUq8J0WnyfMKgK5SFOsjjUmAh3cGXVGpe+Vt6RLo/6I1qoE5XfzFgTbrWC5AStw5lGHJqC390pBvs/GiQxbSnRg7jbv6JqEfL7UAE3OTMp7OC4q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

follow_page_pte() does two things once it has resolved a present PTE
to a page: run the per-PTE safety checks (write-fault, unshare), then
grab a folio reference and hand the page back: fault it in if pinning,
mark it dirty/accessed, and store the caller's array slot.

Split the second part into gup_grab_fill_folio_pages(), which stores the
pages with gup_fill_pages(). The cache flushes stay with the caller in
__get_user_pages(), which runs gup_flush_pages() without any page
table lock held. Storing one slot under the lock is cheap; flushing is
not, and needs no lock once the folio reference is held.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 76 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 47 insertions(+), 29 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index c59d436be7ad..efb2ad64be80 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -921,6 +921,50 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
 	return !userfaultfd_pte_wp(vma, pte);
 }
 
+/*
+ * Grab a folio reference for @nr pages starting at @page, mark the folio
+ * accessed (and dirty for FOLL_WRITE), and store the pages for the caller.
+ * The caller (__get_user_pages()) flushes the caches with gup_flush_pages().
+ */
+static long gup_grab_fill_folio_pages(struct folio *folio,
+		struct page *page, unsigned long nr, bool dirty,
+		unsigned int flags, struct page **pages)
+{
+	long ret;
+
+	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
+	ret = try_grab_folio(folio, nr, flags);
+	if (unlikely(ret))
+		return ret;
+
+	/*
+	 * We need to make the page accessible if and only if we are going
+	 * to access its content (the FOLL_PIN case).  Please see
+	 * Documentation/core-api/pin_user_pages.rst for details.
+	 */
+	if (flags & FOLL_PIN) {
+		ret = arch_make_folio_accessible(folio);
+		if (ret) {
+			gup_put_folio(folio, nr, flags);
+			return ret;
+		}
+	}
+	if (flags & FOLL_TOUCH) {
+		if ((flags & FOLL_WRITE) && !dirty && !folio_test_dirty(folio))
+			folio_mark_dirty(folio);
+		/*
+		 * pte_mkyoung() would be more correct here, but atomic care
+		 * is needed to avoid losing the dirty bit: it is easier to use
+		 * folio_mark_accessed().
+		 */
+		folio_mark_accessed(folio);
+	}
+
+	gup_fill_pages(pages, page, nr);
+
+	return 0;
+}
+
 static long follow_page_pte(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmd, unsigned int flags,
 		struct page **pages)
@@ -976,36 +1020,10 @@ static long follow_page_pte(struct vm_area_struct *vma,
 	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
 			     !PageAnonExclusive(page), page);
 
-	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
-	ret = try_grab_folio(folio, 1, flags);
-	if (unlikely(ret))
+	ret = gup_grab_fill_folio_pages(folio, page, 1,
+			pte_dirty(pte), flags, pages);
+	if (ret)
 		goto out;
-
-	/*
-	 * We need to make the page accessible if and only if we are going
-	 * to access its content (the FOLL_PIN case).  Please see
-	 * Documentation/core-api/pin_user_pages.rst for details.
-	 */
-	if (flags & FOLL_PIN) {
-		ret = arch_make_folio_accessible(folio);
-		if (ret) {
-			gup_put_folio(folio, 1, flags);
-			goto out;
-		}
-	}
-	if (flags & FOLL_TOUCH) {
-		if ((flags & FOLL_WRITE) &&
-		    !pte_dirty(pte) && !folio_test_dirty(folio))
-			folio_mark_dirty(folio);
-		/*
-		 * pte_mkyoung() would be more correct here, but atomic care
-		 * is needed to avoid losing the dirty bit: it is easier to use
-		 * folio_mark_accessed().
-		 */
-		folio_mark_accessed(folio);
-	}
-
-	gup_fill_pages(pages, page, 1);
 	ret = 1;
 out:
 	pte_unmap_unlock(ptep, ptl);
-- 
2.56.0


