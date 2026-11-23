Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84CAC606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=TWxZm/dZ
Received: by kanga.kvack.org (Postfix)
	id 78EE96B05BB; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F2996B05BC; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 609316B05B8; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 209B66B05BA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:56:30 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3516A85E0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:28 +0000 (UTC)
X-FDA: 85467440856.09.1E8DEDC
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5D61840003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:56:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="TWxZm/ d";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795463787;
	b=8BhU2GWZ24RxJ6mHnsXXR+gLFl1rePjM9B5VTEnMRvK9d8j1HlVgki+KV+V8CrPfkPjO6v
	S/Fq3t9kI3uuqSBHqiawS+F6W9p+YRJG/0+o0M9SiZC8Sf821zvPng/dCY0C+KDLXL+vex
	dNGyI4kHBRFuX8wPVYzHEnmBS5Mu+hQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795463787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SNg/eN30d+0BFvF9t/QYVmNoDb1lzvAqSarbFDg/MKE=;
	b=Q2qCUKWJ0igK9jGUktexJFGeUwA1Cs6Iv9luLW5eY99pi1Z9hpjodVYo2k8cB5plAFaw2e
	UykRMDLFvwLSz6JVWas4gnkqEWO6tN88LYQHmLug7otLDWFlPpVLxFEl38jMTC9mUrW9lw
	m0CZ48nqcNN1XGFB18eXULqMyKgrHFg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="TWxZm/ d";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=SNg/eN30d+0BFvF9t/QYVmNoDb1lzvAqSarbFDg/MKE=; b=TWxZm/
	dZ0v63E06eHlklmT+WDHwGP1hIkYnKx0guN4mDEWWcSeIAqqxdy5PUKUA9Rg8yUTHZDQm2BzNDC8S
	OSA5I2Ujbl8238wuBeAokM++MnPwzvB+l67E2hBhRQ3GGAYkmmkcfh55yLghR9moWtAtPVtJ0fai3
	yQzzeED5w41VzXmZnFsHjRCtCiMDQaM/vO+GWnkqda5iAX3sSszBvCISQmwG7iBHynple/qEcKSFM
	rgH5RM2FRXEP7ungdCDhsQTCMtE5QxMljgMU6RBY85sGan9KKUTmVbZ98NO8BPdf4zaLRbEmp8UCC
	ZxkhoaHtZyWr39sOgEg7c1KpH7nA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xVa99-00000006IU7-1JJ4;
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
Subject: [PATCH 2/9] mm/gup: break out gup_flush_pages() helper
Date: Mon, 23 Nov 2026 14:56:02 -0500
Message-ID: <20261123195609.4115244-3-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261123195609.4115244-1-riel@surriel.com>
References: <20261123195609.4115244-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a85jfemxo1ifewn16cuutwjw47tjind1
X-Rspamd-Queue-Id: 5D61840003
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795463787-884725
X-HE-Meta: U2FsdGVkX19UDrYlEeVTgKVLN5ckrrs8IhymYGFO8qhqbU5lmM1PJDwCudHOpvuAiOoc6cT/AfezZVDFXA+Y8O2gDsLGZU4qSy9UZXj0zEPKMySXQXgKnchG1iBQndddTT9qsh7BDKsaY+3zbA1MeD04iPg8jQo9mAcG4Mkk8ZR2sgbsHNrlPO6PageU1Mw8FQuXY9mel+3a5eE66u6Fl6kWCattPmbGBapqeg12NEpOPgwISGDerOUQv12cBF3B5ocBzlHFRb4xm+NNUTqLFsMlwisLAc1wNzziDP8P8d8YwXdeY6SBpWB99VrMZS2BaOlNbBJ3lzNE19hpA2ZnXNYMXvrkTtE0hcKGTwwkQ4pX1+mY9QLltWbtXwlT9UMciCLfOb8liScJDx92IK7ya4u2deIbtLqYd9Zb8k5/6QuB3d7XgWUrAXpN6vZVCloZdwDNis3FQbxbj6dGfuRmkmCMqMI5JujkLkkGoi3VWnPs3qJ7PSm8cgnoltPT87IJl/Xm/nWE7Egg9F85JMtYD9A3GcBJF+BzBf8oAGjMXClx7gMtUbLdiOeA9tJtyHsclS3CuBO8QDUt5ShI64g+8C69y3Z8JUGPWe7IP8tAd4kztwxfFE1VZ1MvKR9asvZv09yHezAyIe5wF12YqumXaGfHOwgVcMtx6YviOpUCsDGbs6nhhyEKBEGfQng4WsTf33W3MBDUt/ThV7NFsqb4L8AFCIKRwTagoDOnjIBznY3G/1nC+6sFvtZQZgQs6Yg2hnfIxcHKGTQuIYIVcPZrXUl6zW661b9TC7SdYGiW7ffSv1exrWLfJioKXf1X3VK64otdOkOxygyZmghPk1cu2vEkq5/EqSSZFARQrrNL2xvNFKIFg8SbZtQBPGdz44cbfW/Wss8aE22znlTxKmfiddYQT9L1SyfPge6z+vt4sEvjVQuDkVkhJf1duo3jfZXYY/AWzJ7/VAbSwojBh91
 FSMuSrm9
 mvMfvtF5Kc93DcANkflKGVDQEzIgqoKX4lqN+gf+7tXF+jGhefjEFf0J69i0UOEf46vJ1H/Q5FwYNJy876yioJ6OWKrejWxqzvaSID5Bg0mEhJgyAbCvHvkk0QFbns9XrMHChKhSvQ7EcILRyUX4NICaeT1P6JzeAcE8FvuzGWBz67GmqNPAvPpV//KeDCsXFuyaJUxicESyNMi3tkFrJ5ntDN+otJaA39+zBAWv7M3tSAgGhqt0UxGRaZ9SD5clm1HQKXvFrREgKHEeQ1Bk1e9DoJe858Z+BVRkVZR2cbORSLFyla/yzTKm4IB10faVg/UD4fyALURQPY0GXQRkYiTVDTfBbL9w87IY/LnvrrpBXn2INqJ6aLHia+slkJYhl9IFsPsiEfwJ8VdCSER8vsvFD/n3bLwSOzKjxejvrTegvNM9CKgq6OpOykv8bsuJf2uRA5mSl1Nm9veGQ+gCmZxcaTrhu9NqyLouow28iU84fKaJf5rSJSCI450sTBZvcnt/LL86+EGX0ksp5b6BhPhE6tQ+9nZVudCS6JnP0OIN6ubE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__get_user_pages() flushes each page's caches in an open-coded loop
right after filling the array.

Move it into a gup_flush_pages() helper.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index e0698d2075b4..d35fedbce7e1 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -729,6 +729,24 @@ static void gup_fill_pages(struct page **pages, struct page *page,
 		pages[i] = page + i;
 }
 
+/*
+ * Flush the caches for @nr_pages pages stored in @pages. The caller
+ * already holds folio references on the pages.
+ */
+static void gup_flush_pages(struct vm_area_struct *vma, unsigned long address,
+		struct page **pages, unsigned long nr_pages)
+{
+	unsigned long i;
+
+	if (!pages)
+		return;
+
+	for (i = 0; i < nr_pages; i++) {
+		flush_anon_page(vma, pages[i], address + i * PAGE_SIZE);
+		flush_dcache_page(pages[i]);
+	}
+}
+
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
 /* FOLL_FORCE can write to even unwritable PUDs in COW mappings. */
 static inline bool can_follow_write_pud(pud_t pud, struct page *page,
@@ -1566,9 +1584,6 @@ static long __get_user_pages(struct mm_struct *mm,
 			page_increm = nr_pages;
 
 		if (pages) {
-			struct page *subpage;
-			unsigned int j;
-
 			/*
 			 * This must be a large folio (and doesn't need to
 			 * be the whole folio; it can be part of it), do
@@ -1599,11 +1614,7 @@ static long __get_user_pages(struct mm_struct *mm,
 			}
 
 			gup_fill_pages(pages + i, page, page_increm);
-			for (j = 0; j < page_increm; j++) {
-				subpage = page + j;
-				flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
-				flush_dcache_page(subpage);
-			}
+			gup_flush_pages(vma, start, pages + i, page_increm);
 		}
 
 		i += page_increm;
-- 
2.56.0


