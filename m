Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5412EC98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 18:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FBA66B0093; Wed, 23 Sep 2026 14:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D29F6B0095; Wed, 23 Sep 2026 14:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30F866B0096; Wed, 23 Sep 2026 14:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1227C6B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:37:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 903F8807D6
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:37:08 +0000 (UTC)
X-FDA: 85245884136.08.0DBAEE2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id AEFC6C0010
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:37:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LQvoSLxW;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790188627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qrqgVlhjOL3NQEnMg7qurGxQjDqq0a0qHRF13Q6GeBQ=;
	b=s7B4507saTKfji5yajyNHTAmaZOy7LZGQpHTbtRDdFyF9D6ZXT/jEOQXNkOIjlogSEQ4za
	JExnynYnoQ35IiqeCL4OG7msVCEpFTNpoSD7l4fs3rJ23La0qwIRrokKB4UqzxV1jKH8xj
	w/LGkZHd8qwG5a8ePDdHeUNbsUscnLE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LQvoSLxW;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790188627;
	b=gjxbi6yIRKuGKjd8mrZh/saDHz23hWjIj8wLyYCbtc1mYtTNaA9hvQLCg6mABe8SzFyJGv
	GBU8PnxZO3Toz4pJrqvU7cpvuRDXWqNZnAH5298FUr+d46R+iJlJSLGJm17mUh8KU5hBk8
	Dd38y/RIoVjgq43sITs5lA0lF1GpAsA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=qrqgVlhjOL3NQEnMg7qurGxQjDqq0a0qHRF13Q6GeBQ=; b=LQvoSLxWt+JofPwfFclir/NKAf
	dbhc80GeA1NFW2MirNhZYRgDl3J69RU1rpPhqZGZPXNqDEUQytxfG/MShYDLBWXW7Y8TGrUoT+mIa
	bGajbTG3r7V9iugAh8QSjTAQ4J6OEkgjjg7j60G6brRfmB01UmOv7UpoBHUYrD9RBFRG7u5WH3nuX
	+FSbXEa03tUa5lHQ7WhBzuREqrWGCjSbKUaGZIMOEebEb10TSIpPeOfe21uENXPzRLjEh3Ysw3Fs9
	HU1eMpr8UUqRYfmF5Z6ebhwaWiqkv8hfjFX3QGTpWHAgyBNZ9u3jv35ntCF+nQkyL6pcVtjq+BNI/
	KMbHHBxw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9Rq1-0000000E7NF-0WoP;
	Wed, 23 Sep 2026 18:37:01 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org
Subject: [PATCH] slab: Remove slab_folio()
Date: Wed, 23 Sep 2026 19:36:51 +0100
Message-ID: <20260923183655.3364885-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4w316369d7kx5xyx3g9krr3pzwe8hydk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AEFC6C0010
X-HE-Tag: 1790188625-691902
X-HE-Meta: U2FsdGVkX19fY12Qt1gpT2mWU4Yn2xTGAE6aN70dxAr62YRPdnd99MZ1CdIFp10gN6CmWBRYw1BwZ47RGDYqbuBjvkRLi/Qat07XowX3g5VR/dVDXjiu7vJ+FZZI7noubjPTHarU2+OWiHO12X30yVSoxkZVqov19h//581DFvNccpzaEpk7r6/ri/oXv2FdgqhDGfq8WIXMVtnQeXcFEyTyXt/StqJLPUV4d/iDiPGNWxUe0aEf78EYb45QxONQtH/6hm+zmm5TzXff6jWm2DbBrCgTbn0YNG8vl/WdRMyYmn7zb2vbPlhgAk3CceouVKzZO6hI6TEUsYNv82NcU9e/hpYjNO5s1eZ6S4LirZJ9Y1u9dYl0q73awVXl3Q+Ljp/MAHSgxDUF9la+FJ07qYRKMPh0xQO3WFE58Y1pnHeX03CId5JJN9W5vxw1TA9ikR0+FOt+IVN0k2A1bGM3Sg0mWPd5rLAJx4ElUV+x1BK0An8N9+W+RJqsRi8pLKh3fQAjOt2gOONW82+kXnrmmFy1KI1TTMulEhvsJ3R//DzCgiNEdvyHUt+R2vMtPRN8f40Qt51XJ9ttUlX/iGYz1ns7fWRrH7rUhjwjWRQlfEKtq4MDpsTfS89FguUMvFyZmjb7Gm40loJBVF0/hS3NJhaL4Nv97R3L3TIDPqrOmu20Rc3ZBkVDofvjS7dAjvLSrC+0MrAXjglYCyUsN28oaz3bCw7WM+sdIp1DRAx0CUgk91bVN1KHRGK96qL9i62jTKyr35lGy+HVdDCZBp+7XrCuOFFH80BDrf06XDFwA8Z5YE/rpx84MAjQ6usV47mmzKEyY3P32XMaNIjz0Hc3bay0/z6HTMfqqVyimDavtg9uvAESgxqEVEYQEf2ElLkOY6Z/xDltZ4Qo89bGJmqYNIdRF7nekvE6h/jpkqExslnmn1y9o7qHnripCiQEBON44473CcE8EmNOHTB7bHl
 7P002dkg
 vQiNxXZBD0pOq4Z6Fm/CmzTYt2rWskH8ngCly+1VU/EVelLotvFH9cgDJHbZFBePSZiZ1swLPrYh3BmMTeez4A7Ce6fptbc3VtfxeHaqgCRJ2HkYb+Cb7Jb1k0WCpEbxzCO0EvLgdsFTql47/8B0dzZP/8yCq6PLiOHynYDo0TKDNzYq1VxJIdQ28O1mc7mCrxw8/gwmcO/1TBSVU0iBVEVlv9panFKLu9FWO1iuVPRoDNBBj77P7CJ76YzBFUwsRutB5Y2UwFMgeg00Rqy5qCrtHKynfA+rVqBAT+j0IHbUnwcs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the final step of divorcing struct slab from struct folio.
It's still tied to struct page, but there are no more mentions of folios
in the slab code.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slab.h | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 8fd6835e4235..3ae7e70c27ff 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -149,21 +149,6 @@ static_assert(sizeof(struct slab) <= sizeof(struct page));
 static_assert(IS_ALIGNED(offsetof(struct slab, freelist), sizeof(struct freelist_counters)));
 #endif
 
-/**
- * slab_folio - The folio allocated for a slab
- * @s: The slab.
- *
- * Slabs are allocated as folios that contain the individual objects and are
- * using some fields in the first struct page of the folio - those fields are
- * now accessed by struct slab. It is occasionally necessary to convert back to
- * a folio in order to communicate with the rest of the mm.  Please use this
- * helper function instead of casting yourself, as the implementation may change
- * in the future.
- */
-#define slab_folio(s)		(_Generic((s),				\
-	const struct slab *:	(const struct folio *)s,		\
-	struct slab *:		(struct folio *)s))
-
 /**
  * page_slab - Converts from struct page to its slab.
  * @page: A page which may or may not belong to a slab.
@@ -184,15 +169,16 @@ static inline struct slab *page_slab(const struct page *page)
  * slab_page - The first struct page allocated for a slab
  * @s: The slab.
  *
- * A convenience wrapper for converting slab to the first struct page of the
- * underlying folio, to communicate with code not yet converted to folio or
- * struct slab.
+ * A convenience wrapper for returning the first page allocated to this slab.
+ * to communicate with code not yet converted to struct slab.
  */
-#define slab_page(s) folio_page(slab_folio(s), 0)
+#define slab_page(s) 		(_Generic((s),				\
+	const struct slab *:	(const struct page *)s,			\
+	struct slab *:		(struct page *)s))
 
 static inline void *slab_address(const struct slab *slab)
 {
-	return folio_address(slab_folio(slab));
+	return page_address(slab_page(slab));
 }
 
 static inline int slab_nid(const struct slab *slab)
@@ -212,7 +198,7 @@ static inline struct slab *virt_to_slab(const void *addr)
 
 static inline int slab_order(const struct slab *slab)
 {
-	return folio_order(slab_folio(slab));
+	return compound_order(slab_page(slab));
 }
 
 static inline size_t slab_size(const struct slab *slab)
-- 
2.47.3


