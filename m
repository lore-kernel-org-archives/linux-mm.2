Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4A04CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 16:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9628E0009; Fri, 29 Aug 2025 12:50:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7E38E0001; Fri, 29 Aug 2025 12:50:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBDB48E0009; Fri, 29 Aug 2025 12:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BA09B8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:50:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3FA90119BC6
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:50:30 +0000 (UTC)
X-FDA: 83830383420.28.A5AC11E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7989CA000E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:50:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NY16TteP
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756486228; a=rsa-sha256;
	cv=none;
	b=tEZ/y3ZhP+FpUcHTgia9QIbxjDSZO06+2J3dgx5a0Vvsdd5jJcQ/dUjPLLnnMr3CgEMWQw
	/WS2uHcmhIZcZjqsTud79KHXGRpUilJPU+eb0nb3l8rjrD/NWTwzMSnl1EeLIsNvSf1XgG
	azUEKhlAicvawuLqAYE7CVlAtJNKB8w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NY16TteP;
	dmarc=none;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756486228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfIM8CbJsYx6t9KsWKvZMivPHMASFRuQgKN8GLYltCw=;
	b=f7WuQMkxAJRSM+t6uO6MSh9QKr1y7Fx5twg9MadOhzKDJz4l7SjrXaKybu+XKk/FXQgmhl
	J7XnZQJTUTcVaJSC2fqqUbteXmGv4X6xMuv7A7Wuhb9VXNKEj5HbgD58sb/gU9SGHWIGYY
	Z5hmGGg9uCfMOTjHJm4E4z+ynNb/c/s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=HfIM8CbJsYx6t9KsWKvZMivPHMASFRuQgKN8GLYltCw=; b=NY16TtePFOOm4QEROg1QWzrS7s
	3HNpac2V11iCd4E6kzsL/2Lpg/GhhDe3ytnCEHbTkfHyNCbuhGLiP+LA1kGDYOAoIQNSQ/n0S/1wa
	ot9OzYBvDVDA51l2rsb9BHz3qWo8o6Cajr2D5RPeMvL5yoEudmyj8b2e522uaCCP1guO29iTpFzUX
	9Dbp5ui0rfFO4BeQDg/PrqqjcTN8GMrihqrFIZAuT7SJebcDhyGdz+J6NvR4xQGYdDp9Y+QaELt3d
	HSnieL7dh5QXvQGHxPvuvZw2MkPP6LK1WwoWezd0/MXLOmcqfWuLBBSQJnk5W1QPTPdrbUqZrg+EI
	LkPgrXfw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K8-0000000EFxN-0dPU;
	Fri, 29 Aug 2025 15:47:32 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH 14/22] slab: Remove folio references from __do_krealloc()
Date: Fri, 29 Aug 2025 16:47:18 +0100
Message-ID: <20250829154728.3397606-15-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7989CA000E
X-Stat-Signature: xtau35oszjtp4d8551jj6y7y4c97j9rx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756486228-268417
X-HE-Meta: U2FsdGVkX1+lBixwOI2PO98awVIE6wzokA+aq+V5jrGKTi4MjHZUY2tQrMWRWdZ7H0rAfbRNwT+wPIzuWNGMxTZskd5pAfvKpwyRO/gSIWHjjC37gB24In4CtIxnNTlNY/0FY+1iXZ+UXAKiG0d1qr96DicZY1zzSChotyQHLJnbBTDx3waEeUxi4Wy213CkImT4rIy4vp0g8dzNYyIgGdkZHxZDLb72bpe2XY3mkXs6s5mfoynVDeuBWjw91NX+KIwiDX+L8M6EgBoZD2XEQ26519e+Qmmv+L8An/TVeXbKtAZ4oHC7pNPOJy/M4x+IWPWZqh3ik7tJv952jDNyA1U4Qm5xGyljA6/bGAAIBwFIu3/Fo4q7jOWagdOhA/+k40J4WgC+7luqT+h0qU5tj/sOiWzzNJmg9rHJ4sADVI5slm0oa5k/2RwTM3ZBu54x0bUZw2v3FqePf/FqJVlFzgWvPlzmheGC1JNAE1xXAccL6jUgPkJ7VA5ItUTn+TXl/b/UGLUTnkG4kpi/Av7U/OZM8fuWvNicOdfB+6ptOTm5PqjYtKcMKbZWG1YIDvnqrOEt747zKWCqevwXO45xLLEeZRglnSlwPullEr5GOqTnVE4p6hp6kxbW81eemZDLGwOLwZM+dDP/rATm/8CR+uzC5zTN1UV52MzJpJ4CIGsbN63bx6kXHagO+zzBa4RBhTZWZSgnix3sDH3qxr/Vu2ydGmAiEcO+VaSNTNmIhftfJaQb66nN0/hDf8z8PfRgI8SSrNu1F4b42TbbT6dZDQ2ISjzFXCzHZqtapAYpzTEWth1ItogZCiZB0jQLfM3XSI8Vq6JmlKXPTO8DvFfuoe7sN1ZaewFHIMZMxsrDZ8FvTlpKGCa2ZKxHqfY7uNcwqSuTa7Tx60V6E9iX3DkdvCaZTMOQBg9XgtB8TNm7vFTiZzStpq/a1+blZqwi54GNnGj9MK7r9HBPJmnm6pV
 BINpTkSN
 55ljFIRRJdDxWzFbyvxl/MM04PGnkMdpE5aQ/5H4+SZdFQ5w6iFMwWYeM+ylonuk605O9dLaQUMnE9WikokKSC4rsI5TC/VoeXJ94gv8Iro3iHr6jmxTyy9i0AtNA0GxFGUmsgJ9yI2rHQgXxvAVBiVDU2Waz5sCjW3N0SjCBA6/BbUm3vqNT+gkHJo2h+cmErObt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As with memcg_slab_post_charge(), we save a call to compound_head()
for large kmallocs.  This has a slight change of behaviour in that
non-vmalloc, non-slab, non-kmalloc pointers will now cause a NULL
pointer dereference rather than a warning.  We could add that back if
really needed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index e471716cbde3..f31206e5c89a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6320,16 +6320,16 @@ __do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags,
 	if (is_kfence_address(p)) {
 		ks = orig_size = kfence_ksize(p);
 	} else {
-		struct folio *folio;
+		struct page *page;
 
-		folio = virt_to_folio(p);
-		if (unlikely(!folio_test_slab(folio))) {
+		page = virt_to_page(p);
+		if (unlikely(PageLargeKmalloc(page))) {
 			/* Big kmalloc object */
-			WARN_ON(folio_size(folio) <= KMALLOC_MAX_CACHE_SIZE);
-			WARN_ON(p != folio_address(folio));
-			ks = folio_size(folio);
+			ks = page_size(page);
+			WARN_ON(ks <= KMALLOC_MAX_CACHE_SIZE);
+			WARN_ON(p != page_address(page));
 		} else {
-			s = folio_slab(folio)->slab_cache;
+			s = page_slab(page)->slab_cache;
 			orig_size = get_orig_size(s, (void *)p);
 			ks = s->object_size;
 		}
-- 
2.47.2


