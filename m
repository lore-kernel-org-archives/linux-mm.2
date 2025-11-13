Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55034CD342D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2388E000E; Wed, 12 Nov 2025 19:09:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9B18E000F; Wed, 12 Nov 2025 19:09:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60EF58E000E; Wed, 12 Nov 2025 19:09:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 321CE8E0009
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:09:40 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E91AFBAEA0
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:39 +0000 (UTC)
X-FDA: 84103650078.22.9EDCAFD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 51CC7C000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=m9SMaGz+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992578; a=rsa-sha256;
	cv=none;
	b=Ijhh5wQPoLFj4E5yee2QnM3pWR2Vzgkn9oXXeiS67kHfRSpYrJlmhxwGe4xlOcW+Vx4P30
	ah/lK2cSn52q/nALbPYbLQPzTaLzU9GrMzWdoRHgDgpraJ9Ab4pbuExHmqCWtTNMl5CzEF
	Ahtj7UWL8wVh8YoQmtYdUFBlj58ogb8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=m9SMaGz+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rJjSnwQRYQONPbqnwy2HPxwxDqCwxALUKav1ica+bOg=;
	b=WVDqFgkE4TA+1gYO+57zV+qQ0OREaB1l5P+3IT3frIakbwlP3lwhGlBXya/xm1Uat8B0xZ
	DF9LIktY+jle8iR7zJ7C+2QNbxL9yzCMt4xyTfqtTrvk89B5/it3hGaQzZLxw8l5ZW643Y
	9dntt1LVvgxzhvcXnfCUzca1x9p2y7A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=rJjSnwQRYQONPbqnwy2HPxwxDqCwxALUKav1ica+bOg=; b=m9SMaGz+dwa0bMMJP+t2kKvM+o
	1rO+9LrDS6HpBVp/5698VMydfLSKAxit+EmVj47OSlaKSfUqVmxNsMvHK67WRinkCC4GAh6dfdk7G
	wogrCuBiAUVjK/+veGifQvewYHOEeEJc+amIeyf+Aa9VywvE9+znF7VPektRWd7rCL69nv2E6tEXr
	KsxXrlOGtTrH8cvBDzJ1sTuh3VQ6QQWegMVzgg9UuyyKstJk9yjTrGAyHppiEGQJzsskdJYB6fVSL
	G+1t8mQrgNYmNrDrZZgwyn5aMXufmXjlqyYxGyul6XLy8TUatBWb7oUG7NVYJ+8ul8PhNSabVOHVy
	i/2yhNVw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKu8-00000006fPV-0gfZ;
	Thu, 13 Nov 2025 00:09:36 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v4 16/16] slab: Remove references to folios from virt_to_slab()
Date: Thu, 13 Nov 2025 00:09:30 +0000
Message-ID: <20251113000932.1589073-17-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113000932.1589073-1-willy@infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 51CC7C000B
X-Stat-Signature: snfi56sh4obdyphp45zanz5epgon6afj
X-HE-Tag: 1762992578-611443
X-HE-Meta: U2FsdGVkX1/Zr84P/5Bp+PPn/jelfVjbVdcPe3Y83V8c/8hTsT0KiRt6z+xpdsqkQAEL4XHzdVoi7EhYGoFt5WKbVL2hC4ZM7cq7hOK3hthvuCfgWlh8JI3MWZmuZUx1AEAxBH+kiI3DiBgFcKycEKWhD5w9Im77pPFjDToCo74itnDMBey9WWYyi823PIwG+/Ffjl44afRutwjaCXo3nirQ4xUcaBmiTg+Hbk1SfECCa96RugpOaqthW8rckny84+v4M6MTNhqU5bRyuY+Xa6DkIeca0+lk2PlTneDck0A+bZDQoonCpeNn2apYgEBzxAfL3YdF5FxLcjPpKuvSyHHuy9IV3sxVgurddnWlAJCEtqJ7mI2xjmn4157Syuw1c2pn+LYjlW/0YnBsgb1jtJQ60Mvi2xwKpxheAOgw3U1RahMSi9UvWXEUVGPO7vMNvNoI9LOSCkbPwbimMVzAboJwaLd1GnIqpwL8Jiv1wI3xaYjNwsNFswPQHeLSNeea53H5REjY/m2abnCcBbeCZjnYYOisXVaJk5dMSX4hkRcCicVGskfcTZdsgMnPHtK29B6DNZtQa+tw2Wlho89RURpJJjBE7F7ZllouifV+8oJ4w5A4GZiPsUPI8sbiUWcqTPmDqyZsHsJRs/iixFYTk+IsYim3BAfBP3HcQ884kxtBVsa7qtfFXbni63T7Xqh5nZpl/eYQlunMIhL+btme3MoWkYFuAqoQECCD7v17L6VfuJ0os2urHR0V0EbW8bhpSkUVkPYYWsFpq2D1h1KxkJj5i4WJBY4jNBGTaOa+ulICNqRYTwPaaZA5/PSrEybAnW4Z8OTTU5oFBtfYxNlLVOhnqCrW4s4l8qe5wTYbYRdk1mhCD0JCI0UR+5gEz2KoJQkbY1vTDX7XXYI8Xw8Vo6tC2acUv9T/DUvvo30Egy6rATQePcw0H8Ww4lbvCyFYF0vbmCCf8FHNQ4rqqUR
 Te2NZi0+
 TTDmmOTr8LaNf+QAECaDcXKzAJ+K2mK5zcxwpuDPsshSoesY9AKxi/dd3KI+cMaLYf+Sesqm3dCtu429TIoErsowtmQ99QevQg9ew7pJI816VbupEwbaKwhJsAM9HwRmwPZzpWV7e1nTf0YhfoXJ+O7aHyXD6Qso+tCtFQE0ugaSnTwe5N5xR2TdceQ3bY5UuTmyXdS36mqsh2qbaAB7woXglPgBHvRAJVXVwwrC2kU4/Ce0AjNXwAPJKhCVM/sfaBlB3uAtj1G1/ukEBicftl/r4hJ31+rKJLbnbaHhMjMfdVprhY9pNUZSMJw==
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
index 0422f2acf8c6..8430e24bba3b 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -117,19 +117,6 @@ static_assert(sizeof(struct slab) <= sizeof(struct page));
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
@@ -192,12 +179,7 @@ static inline pg_data_t *slab_pgdat(const struct slab *slab)
 
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


