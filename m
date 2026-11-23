Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FCCC606A332
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=dW5Cdkk4
Received: by kanga.kvack.org (Postfix)
	id 60D406B05BA; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56E956B05BE; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322256B05BB; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 014FF6B05B9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:56:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 822A91409E1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:29 +0000 (UTC)
X-FDA: 85467440898.01.CD69C66
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf14.hostedemail.com (Postfix) with ESMTP id E006C100005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="dW5Cdk k";
	spf=pass (imf14.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795463788;
	b=PJJAyXTUWjdUPmNwO90HGF6fypGSW8IUy87ZrisNC9ls54ytX15393/IQBpZpMEXBm1JeG
	LQNCklN1o+yTkHt28x7dlbiAcDcJIsAhgpXRE/dysI5AnInE33WFUuqkABr9a3rcMHlAV8
	cZnk/uWYQ95EyWlTrzX7it5gFyxa5TA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795463788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IiLEpxFdp/GdWWLhE2SRceq2aNaPLrmH4fAKh/8siQw=;
	b=niS+9lZ7AbJJCPdnwwsiJwZcrAoewMKoBw/KeHr6C4+dgV0N5UidHPe8q441imd2KWaGpi
	vxyILsxfFFma+6GeCHji85xfHgLekK7HiwUu6LKVNorRr/ogFkrjfR6q+XgQ2x/dNHG8Eu
	/DtP/mrKfc5tH9R8PNdth15vGhDr4TI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="dW5Cdk k";
	spf=pass (imf14.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=IiLEpxFdp/GdWWLhE2SRceq2aNaPLrmH4fAKh/8siQw=; b=dW5Cdk
	k4L9Y2JmljporTezPw+aHpEUtoacoF7UfrA6w4xnXXKKfOKtaqurjnUfV4qUaSCulnTbfxhVMT7Qc
	Yz59Ao45rw+bHu+b0IS/Q70xoZBfxsgBxNQKGamwYNt9nlYYNRv0F/Ak/Lromoa3CugZN7tQHo7MA
	bdebbrRHXNiBALSwLRI7b7ctpAeMI9ylA3ycftgdtpObfVG4dPSla7HUEvAXIPce7UL4oMTi6EGni
	q1RJODhMyPqFPmZAOeLQfuJRjGsd0rDkgy6WGWBzfuQjB6XYztkstieGzn7mtc6LkIkGYax20nnGz
	AXHMdJZ50tEcn7qVZSaX5p6UIRrA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xVa99-00000006IU7-1aVr;
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
Subject: [PATCH 4/9] mm/gup: split out folio grab-and-store helper
Date: Mon, 23 Nov 2026 14:56:04 -0500
Message-ID: <20261123195609.4115244-5-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261123195609.4115244-1-riel@surriel.com>
References: <20261123195609.4115244-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E006C100005
X-Stat-Signature: zpy1qc4h9odaqsxgp67a81d6t98819gd
X-Rspam-User:
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795463787-514024
X-HE-Meta: U2FsdGVkX1/LE7pkm3HZwc/VbPTvjlJv1+mjHPRrl6l/Oz7q6BV1bkP3kFWcUeqCItf/T0N09FPMs3uVmS5sivk7aIrozoCiI+Q6fZ/MEGbnrbQttQk+ESRVyqZ/g+jVU3QcDe2paPPLe1mmVno366ANwDJZHK3wXm+9Gc5PA7dumGQwScePWJ8bI/S6ou4tVrFu12wzQnmKGmRMxhS3O4tDpeglzaKgaM/lhrieDWKouiyiq0T3hCpA+XdBcV37AHLL3VtYiPCo5vmccZXqEIkns+zcMkVFrgUk6aIGaN1ArIzdVVAEVQh0tLBuQDnvhtLZGA1c8GVn+L3enVHEIF+zO10S0VlLqjxO7TN0zxuRbD8jHOPH8tBim7h8IC/Z7NO4t2Bj/u/vrxVVgzpmuXb61PwJB4oekRjmD/HV3Fhh3daBWLt2ogPt5xAekz6nEkeURVLy9kjtDSF5/sGVDT+i+PWg/Zlkbvp3C9ahx03GQ9AKu3hzBB86lDiI5QJaewCykFoo9qkGiwbBfxxfHFH18ls7OQne5ygkOD8XElu7rsku1WfGoLU+j26p/nh7EqhQuPxnEcSeuwDuAsWhvzKPFI2y4L9PhvCSqa5RjgxGaCtiI21IrECH6yUOpWBtjzbwWuF00TmCSbl+lMss6TU7b/UQIJm/BDts1n0CHuuD05XbJxbBvmwf4IeP7dUlQdTwsdULwmAIIsvWQuk6HsKFDjEyB87rFB6EpJR9PKU1BmT749GRS9LCDBG1gfTyokTavSDqvncTVaSsqUZhDP7bX/tj36TUQsmd8SvUsHW7VnrWVOKCUsQRTOyT/iGyl17IOKsB80yhxAEdviZ2aWIC9XsBQ0duDilEXX6DzQprF8/ZwAvn4ZAuw/vU+ZTTqBCQgPDIgnkCZ3sZ0TKqpSVX7/SZ/i2iAxp6VMKUisrPezd7vG+RZ2ZKIfG6eZBHQFA1SlvBDUrRjPbjMsE
 sR/uwW9r
 9ODT/VuEQeuSkZvjMWdUS8UEKcw998RgDvXc5p2oT62LVZKTCdMdYcJZHvWlHH36yY48gIaS0m55QJf6Gc5xrFuFYTzfbekLWJkwUuYME/3FDpvsYLYkU7oIjr1snhoGGGbN7vSYtfJiBAfllRuNDFe1Ane7+e9M0hDK28Amu66pE/HUUpOVCKXY+Twh5MvuyePdizN4HmkraX7H7XXv8xmMT+Ik9AP3eq7pbRJWlbKr/L3ne9VIFl2mGMoYRSHTStikjXTBULtX3qDZonJSBn1kfbBvT4nub6cEI8G9/3gYlmKyXOXxpDeNKAW/GiOSRvka883WBfT+/De+ho+TeSGBZidbIaif9Noot1adN2vYuvU/3snoPvBEdgn2+D46q9D/jhGmsHYXppWc3BWd9MIJuWadiDB70fImPeVbLhT6oFdIGl8F56PmnxpKtIfh+1fUAlucwCq6JnLh40Af5te4A5t0ljnPvd5tSLRo04f9YtKmgS6qWYjSntA==
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
index 963c09b955d9..d2097ecd1576 100644
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


