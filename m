Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA686CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DDFE8E0011; Wed, 10 Sep 2025 07:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FACE8E0016; Wed, 10 Sep 2025 07:55:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 242078E0011; Wed, 10 Sep 2025 07:55:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0408C8E000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:55:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A55C711AA3D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:18 +0000 (UTC)
X-FDA: 83873185116.12.770FD4B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 11735180008
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=B2AU6ZBz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757505317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KqH7OAYV/Rwll99Ldk6+9zF/WjuI5qHlk209yq1cS3U=;
	b=3vonzIK3jlJpAF/1EVHomxojHVmmNNKme00QsRgHr9SLqsv+TQ2B/wOeyBC0z7VHE5FONv
	Zng6WqeGVUslxtdkaSuUxevrotNovpaz/WE1Kc33xbzFnQa9eDqLGWZJkxh9XFz9VkvkS+
	AkdD7zsbhCZTdP/Ri5aqUD/f38eMzCg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757505317; a=rsa-sha256;
	cv=none;
	b=FCqdicpGBkDzTDYJrBxgHqkKOuxn3V2fWap9c6rsrXJ1NXYFzhC9+e5Ie553v2kOa1eEnd
	66mYWVQZKW8aEy8l6KHzAGVajjPPy52zoTdovGy1qon5WecghEC99ODWVx2FSd5oL/MQFL
	ZMFB12PFns9spGRe5W+SRex+U1y4dMM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=B2AU6ZBz;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=KqH7OAYV/Rwll99Ldk6+9zF/WjuI5qHlk209yq1cS3U=; b=B2AU6ZBzgjzWQ8dPqjw474FnGX
	8vdti3e64c4AivHCjc/vVSFvWGHPhX+6SJdlgLm0ec6TxkxsSHngqR5ZD0yEpAVPDduNSKoJZ6tik
	hTxNGIefSyUvbSWjheEDXyjFaDJEFklHnJ1qbyyhyqzasCEfIVSX9Wd3Qfc1TJOrWOUYtKQpxRvS1
	R1mvweFRIDiYj7FS4h1kk6+7ifwVRYyefjUd48I9beR7Z6knURLi6jo2ijJvA216QHurc95EC8Sjg
	Xe7wX9wnSL++X9Qdt9g4th6RJX9vuzwcNTmp+5i7a9Qbbdg1f937iVc41SfTMx1RRdPOlVoe61w1H
	WbAmfwyA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPp-00000008MF6-3Jsx;
	Wed, 10 Sep 2025 11:55:09 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v2 10/22] slab: Remove folio references from ___kmalloc_large_node()
Date: Wed, 10 Sep 2025 12:54:52 +0100
Message-ID: <20250910115507.1991829-11-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ipnpfmypm75e3nm4wwzry8jgreqqap8t
X-Rspam-User: 
X-Rspamd-Queue-Id: 11735180008
X-Rspamd-Server: rspam10
X-HE-Tag: 1757505316-476914
X-HE-Meta: U2FsdGVkX184IJCMEfHq/t3tjbYkP0+fU949i+e3Eo73uMpXynp8f6qksteEKsYDWFt6moog2AaosDzi1+j8KJ+5z/ktDjeI3XjmZz1soa+T4mlN05vbpE2zj3JaWGWTxCg03oxUqoKujwIFqTXKQvQqMhBCkKPR1yiqU2JjH7YRRK88nfxlND6DUC+D2aaisy+rOqfH2Al+Ako1EaSZURXXrVafNN37PGM4zgDf30PVGSKCABwnDKs29awRU2JXBx/M6ASEJb1t+EM4gDDtKLYOI++km8TVOhAP7Slsq1A51XFJR3IERGPK+mX4d2eQoLD7rJV4CGSvKO63MIvSCfHjgOXT4XryMEUGv4oP23TVRd29IpAttTGFsqHUwfPQKn4Xi6u3xhkhM/jzjgfpi5D35+VE+/u78fUkdmNFfF2PSCdOcaqQFQA4qRqO5HtJ0wFRvXC+BSIuU+GJXMUdouWkXGQBZFS3l4aX65n9hIvN2fd7L/JSwZJkz2COC6Vc56GAsb+LV67naz4J0C7HZn6l7VI+qV4yksGJqiqdIfGN4sgrfJJIP22M0NpG3RPq5nSr9o3r8xyUAkDGrv7HU3/s5OpWikMwC1KyPLc4F/+/18KYcrBv1T/x+R4pQVDwgqqR0d0Rkwk9xiZdFEgqrPqJBiJ4M2hCgKD3gtCt/UXpH2YmE37YH+hHBD1QUDPW8UIUbUhp6OLbh6jPQx5LvPglW4oox6ZzLL5f1R5Aeck5tJy6Hf6D1CM/mgD4xjNFgCR+/3+18XwjVLYVe2jiYFLWykkQK9xuaF20LGaOrk8xeYAe2R7jmfv4q0MSkMNFayAldORqUMmUz3OuUr8UD+jRcO26CbwPuc9LLiiGPvoZkO1lzOYJW8C5HGnBa+UhsDkV50IIK7LSErDKB2ydcKHNcBiamLKdQl9IfJtlbQ0D1Q0d8BmRRqAoTcuGE7HwIlzkkibHI2/b40hs8vH
 YVP6J0X7
 xDraPVzshe/3DjiDmJl5VvlVQ83aXjcgFBvG0MtZjDRnve7UawmGVC0CTB26IbrjdPGwzrAbePFySsgJoHxe3n9nDhDH9NwVXY0ly9DZPkzDHrDCHcgymkK8xOaa0GXAnVLgsezyaylipb0efkgZN8TLNe1eagFaPB2l5XxUnS2OW5m/57RO+VoaQwCE0tFNP6nAqK8XY8GikSAssOw41rRobuYmQUQ3vqXv+RDEE+COYTyQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no need to use folio APIs here; just use a page directly.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7973b064639e..28f68887ac3c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5284,7 +5284,7 @@ unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
  */
 static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
 {
-	struct folio *folio;
+	struct page *page;
 	void *ptr = NULL;
 	unsigned int order = get_order(size);
 
@@ -5294,15 +5294,15 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
 	flags |= __GFP_COMP;
 
 	if (node == NUMA_NO_NODE)
-		folio = (struct folio *)alloc_frozen_pages_noprof(flags, order);
+		page = alloc_frozen_pages_noprof(flags, order);
 	else
-		folio = (struct folio *)__alloc_frozen_pages_noprof(flags, order, node, NULL);
+		page = __alloc_frozen_pages_noprof(flags, order, node, NULL);
 
-	if (folio) {
-		ptr = folio_address(folio);
-		lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B,
+	if (page) {
+		ptr = page_address(page);
+		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
 				      PAGE_SIZE << order);
-		__folio_set_large_kmalloc(folio);
+		__SetPageLargeKmalloc(page);
 	}
 
 	ptr = kasan_kmalloc_large(ptr, size, flags);
-- 
2.47.2


