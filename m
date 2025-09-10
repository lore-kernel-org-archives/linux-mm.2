Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71132CAC583
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3298E001E; Wed, 10 Sep 2025 10:31:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3678E0003; Wed, 10 Sep 2025 10:31:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B930A8E001E; Wed, 10 Sep 2025 10:31:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1C518E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:31:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B2431408F0
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:31:31 +0000 (UTC)
X-FDA: 83873578782.27.A33C5FA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id C12DB1C0013
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:31:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YgftYcb6
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757514689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xRUbv5N5R69lNPt0JmQyV0R168xYggDlrA6i1riHX9U=;
	b=MHZq/nBXvOBXNj7VQsE8HteouqaBVO8X0o5azzRIT0YLEIZVEFkrDS1r1QY9Pw+vyucdMy
	9t8GlDSv8PRUtvXTQErE2suKBwo+V6jtHBvixtnD+luQSnl0UdiInqZCNJi5MYksMeeyU0
	oGwgCNwBsvfiYYib8YCYbYLiHKS5lFY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YgftYcb6;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757514689; a=rsa-sha256;
	cv=none;
	b=wQH54v1MrCXwIsQQZXiBc09JZ+1BtKanFoPNjA6DJSBoznQI7lSvzbVKoJuM41963i+hyH
	5d0Lf+88Tz8icO+Vny/J24xtjU1hzeWbavYqaM+cYh34wARmNLTinnA3A0vOAXspaVAZAe
	03+sl5awm0Ee0RgRGlfG+eZFn2iBSUE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=xRUbv5N5R69lNPt0JmQyV0R168xYggDlrA6i1riHX9U=; b=YgftYcb6yk7o5AREkWcVDGqI9L
	0SKQxa15UNC+n9uZPCTKmLTOBtxDeKo8iXNRaRLYjqQrb3129bDFZXFrPhBDXxO38+64iNsqj2jI1
	CvMRPvY6wM+itE6DadDSwkjexdDwdC/bYiBj12w+dGwWuKdlMIA+bgdJLsGGCG/t6IMDVfevgNPiv
	Se3Cj7HS4olVTTPrNzxHfSX8BeD5wFnZR7JWK7Hg0/PnsiH5La2W+AF3zw5DugvMml1pL4KFiBsSd
	n/hF2F8HNPCasCsbRLROW/MOHCAjrastygQzsvt6rHI6C5HrmpMxOegdq3FrgwAoqkk1EJon+B3kR
	fCNsvLxw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPp-00000008MEj-0taS;
	Wed, 10 Sep 2025 11:55:09 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 05/22] mm: Constify compound_order() and page_size()
Date: Wed, 10 Sep 2025 12:54:47 +0100
Message-ID: <20250910115507.1991829-6-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C12DB1C0013
X-Rspamd-Server: rspam05
X-Stat-Signature: qur81wb59q5fbzqik6k7cwr6rfd5ogu6
X-Rspam-User: 
X-HE-Tag: 1757514689-160040
X-HE-Meta: U2FsdGVkX19OFd3UNTPESq+je/9RM3ZtArfPI7NXRO9XhvsjB8G7kxHRnYX/7zcyvN3tbmv1yRNOCjWsTRNQmGaFovk92AuDNFthrEWQ0Ol+2bVir52ydwmSRZ6xXCeQTgTzVSZkdEbnZgvt+6irtcTE8c8eVyZPMTe5S8zjhGfEfp4q2gMhCmXbq++Z71/yZ4KbFQAYrQi3m5q3vDqQfqRPl/3DCGmEBX1lqbzRrlZFLevwKvu0u0j78d/kF5h+1yNyMk4sYRO216E4pDKc9E8nt0Vo+Ypw/FB+4SQ548gyMpQzYZU8RFqqMhBkaw6RZ9XoQ9yLFmLOD8KFKr/pvysM6GDp3UdhbQTE+yD21ZCBj1eeFj6LsCrPyIla0Iv6S/GgZ8wa4IS0sRQ4QPXQIA3hVHKO9sZbD2rTL5NslmU1qHu37e3WCN/cMCcZfqdAAXcgrz8rQky8RscqhbLYbOetTgwDJI43h7IPPxkvfa/w6CNJIo0322Gfi0o7SqeZTqwIJE3nIG8Vr7lt8cZ/c1JereaM3fwZ/vRtRCY39vqmUVZZd88UckT8/CJuvWbf2BN1p32vkK44bBZo2qMJmoNbBtrC3fiA3rnARn+TdsMKpuhv089UzcKMT+J+FAHdrJOY3zA0XWq6/327ptKEcTufCqYCtqBtRR0CseS8QBni5OL7W6icHx7OfIeBjLT83v9+RVCNGg9HRyPtLrtU/5JVaBgCKfcA6BxANyIBJOkZQjUBwUPItNT4UOi71kw1zxp6LO+rgM23GU5GITt1Yf10XCVOO5gj4fO8TTNMhoDoM03gCF0g/Z2YfyILmz4X+kwDq0liyaDXSCbYnGX7lBpOv77gpKyivtdCZK8gAsZvIn8Y7QvUET0W90fUfQFDO9SwFi39J2PAl6qwkXezyK/LzBYJiiNsuLv/mC9w2ieshOX1EpjatQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These functions do not modify their arguments.  Telling the compiler
this may improve code generation, and allows us to pass const arguments
from other functions.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a6bfa46937a8..38b3d7b06d01 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1036,9 +1036,9 @@ static inline long folio_large_nr_pages(const struct folio *folio)
  * set before the order is initialised, or this may be a tail page.
  * See compaction.c for some good examples.
  */
-static inline unsigned int compound_order(struct page *page)
+static inline unsigned int compound_order(const struct page *page)
 {
-	struct folio *folio = (struct folio *)page;
+	const struct folio *folio = (struct folio *)page;
 
 	if (!test_bit(PG_head, &folio->flags.f))
 		return 0;
@@ -1256,7 +1256,7 @@ int folio_mc_copy(struct folio *dst, struct folio *src);
 unsigned long nr_free_buffer_pages(void);
 
 /* Returns the number of bytes in this potentially compound page. */
-static inline unsigned long page_size(struct page *page)
+static inline unsigned long page_size(const struct page *page)
 {
 	return PAGE_SIZE << compound_order(page);
 }
-- 
2.47.2


