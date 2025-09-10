Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 000C9CAC583
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17DA28E001D; Wed, 10 Sep 2025 07:55:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BDB98E0016; Wed, 10 Sep 2025 07:55:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4E08E001D; Wed, 10 Sep 2025 07:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D6D908E0016
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:55:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 98C9B57A78
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:20 +0000 (UTC)
X-FDA: 83873185200.12.20FF1F8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 10BE5A0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=roWF1qV8
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757505319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MesnM9ZamXMi8T37uC8EszxIl1xk3pSu9NxpWjKejVM=;
	b=EiQTeKEZsqX0HgztjiecIaSeOc0aPZejSI1i0j88DNWLxWMDQ+hxUel6rNd6sBqYqR4UJm
	hCXxcUh5OtbK+21I4IRf1T8/uwQCnw4S+PLGNFmz872gRF1thJbE3jicX8kROsR+BPNUvG
	Z7HhgLPGU588vGSdIaBoyPNEbD8vH28=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757505319; a=rsa-sha256;
	cv=none;
	b=oXGaJipBOJqY6/t55rYOQtXvWeCk7M4telnVljpnmU3zKpGhYHh/ogYgQXu9kXYfDKhsaw
	zEfD5r8NiOXXtmmBr33Py5AfrlQ2ixGlGfDPHKgMRkM93sTqPbCBndSs4UzJgfFc4PxAAy
	OvSxk7PLh2Ee2HrrVBD8wwfWSC+zdwo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=roWF1qV8;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=MesnM9ZamXMi8T37uC8EszxIl1xk3pSu9NxpWjKejVM=; b=roWF1qV8KWOQkR17buWjYYbzlS
	cTehC5/+hCYInXERD3fExDhRo5P5kLQp/0h9JXAHM2NEDc/z/cjFoB3A4FlCIQ5CbfwPpwX9QzKZT
	8OO4w/sU9gcXbD16AOrG/Z/ovQH0dfsLFXq61e9FIYsoRALCKEo7FxwQ8snzAO7hGfnQWIBoIZjPz
	1m8bwFGU8XZXMT3ly+JF8n6CP/IU1pwqjrfVEsQExB5zDOcMXM3a+Mt8/al/FMfEIBccZ3TE98WvF
	NTKVotQXV8xPkuGU2bjWQDyfcFhwjGmmheBNV+spj7ZZ7qd1Pksy+ziaWqUOkoGajsoajEnPncpXW
	yzhTPZAg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPq-00000008MFm-3jHD;
	Wed, 10 Sep 2025 11:55:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v2 21/22] slab: Remove references to folios from virt_to_slab()
Date: Wed, 10 Sep 2025 12:55:03 +0100
Message-ID: <20250910115507.1991829-22-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 10BE5A0006
X-Stat-Signature: 6x83ixt1uo66oanwwzzbcg6n8nfmf9dp
X-Rspam-User: 
X-HE-Tag: 1757505318-859081
X-HE-Meta: U2FsdGVkX1/ZcY79G+nqiDOt/i4RwbR/aZX7IE9tK3HqzCzNX0SPlQ38mTbPJV9KJ5fL1MbvitsbkABej7LixrTCh6T6pmu9Qqgl8SmRX7L5QZ/3NdWQ7D2EL/LCz4FX0PKU9azOQtwXKKXKi+5Qf9vX3KW/PdWYDBRjoB6EsoCXjJeI3QIVCKFSQFsfWiOFFRTxik2vaEvj3ok1dI/xCjCsvFKdkgKQPV9PdfBQeFRydT3Q3KtWMb5DNLq/KUWl3/zLBoqvnrDlhThT+P3EdfL8gZBOghSTcsZjY5ejtaZWk0J+3qb8mfRRJOx34ESixc9RjN1ghFuvVdmInNGnmLnRZfLgx+HGll0T/bAqRAGa5pQc0jaHFU3q1WTvJgUOyYDo+qT0vN7TM3btjHPjLpodhLSnIp6ONUICV2Az+83tOgl5nMV40KNktU1UPBXtp1quxrZAr7kbhSXon7rF9jWub1L2VNSDrkWBSFvNkrsw0TjzBt1ZtKiR4d6cOU69xsbXIgJPRyvVUlFGg+HL18SJsiF11ycR2xsAd6wvvtCa9QNkZ06M3h/Q8a0/2OHFmmVUNhKPymT+1WclXqNGvEYBsFfewC5yGXzKZ//O7K0OiWeTc4Tgv4pCTQH/Q7GuN4SBYA7MaIK59JHUE/MD4gFEazATKeFTXfMyW1coKRksWgJc8vTvCMsu6z6NnyF+KhOrlZ9C55Mi5fvm1tNYGFVk22T67kizzdOwmIJsjKU4gBfZbNjJeBTYDjKQwdTbkFqO4p4fBpCpzN0bsq+r48ZcaEfHGAi2HFdLWm+TOAt+DbrXJG+wnETsdi+wC+UDHi4bayG/rkD6PgYP+ycJ5jYnP3NmTIZ+owG/Ne2KORaJRd03zsBPqxVkj1OTO+uHqEBC6EDdjK7aJuWvgQYJVFwA5yDv6KKgIhTHAx9JNg1aMhPNlSn/4yhdfn7wnBHSNxMIZoPkTGsvbUEcRcd
 ntyjCzax
 a5abtrvi/SWHm/9aVMz45cxTnbob4UTCmSVPNjipzDhIYpT8DDOmVfk3KedughzfAQbg10tny6sNyNTc1Mner00MnCwcS94u4Tn4G4BXAPI3ZM3axdX5UT/Xn7PggywfN+24MnZbOIouMzn2y9zJVFow5ifsUfAB2LlXZJM1DDhH8qwAsiZ9XIV4ouOIZ2+Xz+E+qF1L3h2/3Uah2SZAZFxTkYZuLVjPFlG1+q/mvtg/o3CE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use page_slab() instead of virt_to_folio() which will work
perfectly when struct slab is separated from struct folio.

This was the last user of folio_slab(), so delete it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slab.h | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index e3a85318a6e5..1b5639a148df 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -113,19 +113,6 @@ static_assert(sizeof(struct slab) <= sizeof(struct page));
 static_assert(IS_ALIGNED(offsetof(struct slab, freelist), sizeof(freelist_aba_t)));
 #endif
 
-/**
- * folio_slab - Converts from folio to slab.
- * @folio: The folio.
- *
- * Currently struct slab is a different representation of a folio where
- * folio_test_slab() is true.
- *
- * Return: The slab which contains this folio.
- */
-#define folio_slab(folio)	(_Generic((folio),			\
-	const struct folio *:	(const struct slab *)(folio),		\
-	struct folio *:		(struct slab *)(folio)))
-
 /**
  * slab_folio - The folio allocated for a slab
  * @s: The slab.
@@ -188,12 +175,7 @@ static inline pg_data_t *slab_pgdat(const struct slab *slab)
 
 static inline struct slab *virt_to_slab(const void *addr)
 {
-	struct folio *folio = virt_to_folio(addr);
-
-	if (!folio_test_slab(folio))
-		return NULL;
-
-	return folio_slab(folio);
+	return page_slab(virt_to_page(addr));
 }
 
 static inline int slab_order(const struct slab *slab)
-- 
2.47.2


