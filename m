Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4C4EC5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 03:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7416B0095; Fri, 31 Jul 2026 23:16:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 581256B0096; Fri, 31 Jul 2026 23:16:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4495B6B0098; Fri, 31 Jul 2026 23:16:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF5006B0095
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:16:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4884A1A0223
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 03:16:27 +0000 (UTC)
X-FDA: 85051237614.15.69C1DC7
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf19.hostedemail.com (Postfix) with ESMTP id C6F531A0002
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 03:16:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=bMMULlZD;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785554185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M1pHvAK4N9+3KUvGzv0LO80HoGs7+eXLX4dwzNp1IZM=;
	b=jR8mBMYiqgUBgYimVgXSoxHxdeIVTR1PCSwt5jbc7S/J9ypcAnMufECvqvk03iPzZKMiL/
	Csnw3yfyJUr/SwlNhqQqH387IsYZP6onIq2nlTGvUaH/SCEnsfm7YAWACy/zO2mCJ5sVam
	nMY1CJk8g5zWeKl5j2EfovXLPUPS2l8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785554185;
	b=aBmRMoIUsWZ98vLyXXfajwaiNLGMqNsv3hTT1xfvnKmlygCzsuDBVyrLqUjYtoO2fkQCzX
	+0XX6d1CZcH8IS55uyrXYzHWvEsgxwY7AfaOwZDSqbmVWI/qGLhxv8h1P1SAGekHM92EcV
	axLcHgGGWnrdOJdc7bBQyZkHlFCSBfA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=bMMULlZD;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=M1pHvAK4N9+3KUvGzv0LO80HoGs7+eXLX4dwzNp1IZM=; b=bMMULlZD2Ev3kM3uCYDeagi7uu
	SGxDMlBuA+9EC1H10raJQGthPKNwhRU/ByxUaR8mzy4Pct6RgOIcGMUv+2zX9H4D3xBhOCic0mypU
	pVI1HwOm6NVbJgW3QO36LLC8eaUzW19upwDg4XfYc5XXnsKgI59fjNScFpZGCa33d47YowjBMU3kY
	+iINXrsIg7lb4r3iUrvP4UB9zNWK51o++i77raAAmcGYPUx/t6ryctUgrrGNJ9OYPIxiKE9W7jONp
	6J6UKhulw3MrIoaqs21CpiYFmHYnOmEaVqmjvk1XK0nWBqhJfiRJpZB27pNbbKKkpRul0TOCw5z3K
	QE07Sn+w==;
Received: from [96.67.55.146] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wq0CU-000000001Q5-3m7I;
	Fri, 31 Jul 2026 23:15:50 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: [PATCH 2/5] mm/gup: split follow_page_pte_commit() out of follow_page_pte()
Date: Fri, 31 Jul 2026 23:15:37 -0400
Message-ID: <20260801031540.2742891-3-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260801031540.2742891-1-riel@surriel.com>
References: <20260801031540.2742891-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C6F531A0002
X-Stat-Signature: 44f17388ejwk9grz9w4mw8yikt4sso95
X-HE-Tag: 1785554185-321468
X-HE-Meta: U2FsdGVkX1+USgYv79+tz7+g7F66avZ8rF+ut+Br8ZPc5VwosfP2pjlqRBuQQPVNgNPiv85yxCCR/s/+cT+rbGOuXgd7s3G0tjqFD5rTC0f8xeMn0AIhX8g6Ai4LV5kQCAEJii+rO3p7jUug/rVT68BPaQpa9gwmU1F5fLGBvMMxiuTKFndKw7KMLaMRufV2zV8CmArA6EEkA+mUie/qQI8z6V/Nb+oNbfvl5DwCIALk7yYK8+s4QP356iC5aCWOkv/NHfphOU6pj72Khv78CllVq9cr7IL4Cx/PQunhqOrhHG4SzwfXCOPDrkJlik7mxnWwLnekCIUbN96/cOSjXbmkMN4qcblFMG7f3+xxBRIxuh8Lq9u/qRMtSE42HlWCL4vDcrGI/pKnzHp2v/5odmoEK1D4jDkLdADnsVFE4xpliwQ91Pqtfwse+UmTKeBFMatMfRql1KBMSocVUtcL19whaplk3g53j0c4Cp3fyt7bzBv83BVnA8Jztb++xdM1DVbPOZAJeep6vPkDD81M0ycfz9BXNNFHcyiBuXNn7mdyPot3bdAPD/tzSd2AaWIhwJRyqftg641f7s3N0iHhQLVMSJqtw9yVl3tm+7iDNgioshJXrcwJx2H8ejqrSnVB2Culbiv7cNIQQoruEiHhkCG1nPTFDlbNzaQHzg0Vs+suRrj3w/fO/yaqd/ezXmnJgmSM5K2DXysSv2cOcTgQl0UnO6Wgbh6sFwBYxsYPKLa4megdKqDNZtY05f6PodifDW55EFownX5MzHvr70PNxw5NA8cWaPH0QtZ3uug0sSat6clTXrtaxPfAtZoSTmwej9oY8RVspIPFDuQ29GywXtgt8RU2QGGrdLBi6z3PlaCTqOGwVFvIb7S9f7XhZtwwf+98waPkbKshFdRMKaslLCNPcyt1rDHfREaFl/tgpp7+ZMTeAEXkqhVv5NUIhHIQtH3YYXvrYfyWqj6SGz4
 q4Kou25B
 Ea9x823W9PjnmsB53GZLnucHJ3dmIdqNp/ZWdZokKsRjIla84IW6+3/jq8RNTxp6s/JBfL9gSTHeQosty4UU4xIzADTJEO6gF+Y7IUFU5oAeKv5nKIPo/e+kq5fhhTDbAK5XAegWID+hHUoOM84d4ZBl5f3W1q+fSDuyO7vTpmM3zemNlM7P71oCM50pT0pIbA4a8fHGTqkNQOlbdhXIKWU/GWAj6+Q0sbO6DdlWxPZAd/CboFtJdycPIAnrqz2Q5PP4w/tGlWt8Pke+640+AwDAFjpBTmzHaIEGQRozv96mRq7Hpw236Kri6VD6+NNKBDbMd1xaUSk2es0Mq5KL3PWbTww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_page_pte() does two things once it has resolved a present PTE
to a page: run the per-PTE safety checks (write-fault, unshare), then
commit to that page: grab a ref, fault it in if pinning, mark it
dirty/accessed, and hand it back to the caller.

Split the second part into its own follow_page_pte_commit(), unchanged
except for taking its inputs as parameters instead of local variables.
A later change teaches it to commit more than one page at a time.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 86 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 53 insertions(+), 33 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 09c64ef2f57c..053da43760a2 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -813,6 +813,56 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
 	return !userfaultfd_pte_wp(vma, pte);
 }
 
+/*
+ * The caller has already run every per-PTE safety check (present,
+ * write-fault, gup_must_unshare()) on the PTE, so this only does the
+ * per-folio work: the refcount grab, the FOLL_PIN accessibility fault-in,
+ * dirty/accessed marking, and the array fill with the cache flush.
+ */
+static long follow_page_pte_commit(struct vm_area_struct *vma,
+		unsigned long address, struct folio *folio, struct page *page,
+		pte_t pte, unsigned int flags, struct page **pages)
+{
+	long ret;
+
+	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
+	ret = try_grab_folio(folio, 1, flags);
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
+			gup_put_folio(folio, 1, flags);
+			return ret;
+		}
+	}
+	if (flags & FOLL_TOUCH) {
+		if ((flags & FOLL_WRITE) &&
+		    !pte_dirty(pte) && !folio_test_dirty(folio))
+			folio_mark_dirty(folio);
+		/*
+		 * pte_mkyoung() would be more correct here, but atomic care
+		 * is needed to avoid losing the dirty bit: it is easier to use
+		 * folio_mark_accessed().
+		 */
+		folio_mark_accessed(folio);
+	}
+
+	if (pages) {
+		pages[0] = page;
+		flush_anon_page(vma, page, address);
+		flush_dcache_page(page);
+	}
+
+	return 0;
+}
+
 static long follow_page_pte(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmd, unsigned int flags,
 		struct page **pages)
@@ -868,40 +918,10 @@ static long follow_page_pte(struct vm_area_struct *vma,
 	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
 			     !PageAnonExclusive(page), page);
 
-	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
-	ret = try_grab_folio(folio, 1, flags);
-	if (unlikely(ret))
+	ret = follow_page_pte_commit(vma, address, folio, page, pte, flags,
+				     pages);
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
-	if (pages) {
-		pages[0] = page;
-		flush_anon_page(vma, page, address);
-		flush_dcache_page(page);
-	}
 	ret = 1;
 out:
 	pte_unmap_unlock(ptep, ptl);
-- 
2.53.0-Meta


