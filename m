Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68DEDCCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:44:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75E318E010B; Fri, 24 Oct 2025 16:44:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5428E010A; Fri, 24 Oct 2025 16:44:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB3D8E0108; Fri, 24 Oct 2025 16:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 202EC8E0106
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:44:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D57BC8950C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:48 +0000 (UTC)
X-FDA: 84034186656.21.548FAE5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 40D6C180002
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UU1+rKqC
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVyUOaGf5lSCcT/L3Isn7d/hi7lBe9uwpycZkgtRscs=;
	b=zv3X1q/PgB4wNVA4HvBNtpJOD4vxCPFAKjSjiN6HVX2A9qLKp9osc/e+foBewb5x6lAhZe
	ZPBkaC6I1N4Rwy73AsdLUVo7gEH4y8mNWVrX4qaOTsO+BcO+wwdmvNIcLgWa9SNgeyGti4
	8pL/1bo1CejKIzH6v7jxkaqs7eWWj9M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UU1+rKqC;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338687; a=rsa-sha256;
	cv=none;
	b=WLd4BvQvBedHOj21thS9sTLg0skKTl9qvUM9NHv7UHHXn3pW8V6/rLTsoihch2P11t9uhD
	BljUMsFuhiWVOz7O6GOtaD7gWZ0q3hseBEbKRB721oWiv5GAETM0rnRj8iLiU+4CjW8PNy
	SO9TQ1NO/fSvBeqwLEL43AxH9g3BnTA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=LVyUOaGf5lSCcT/L3Isn7d/hi7lBe9uwpycZkgtRscs=; b=UU1+rKqCRW5J4eOyHm7vl06fRH
	5YaD9BXWD/L8I7tyyQho9pJjQbWvFjiZRAeE0JHo2nt2dVMTabr94HDUrCIa7ZBX4KHmiqjHkpuuR
	l7y2RTpw3//tDXOMWK9fNba4W1xXDupCkRHRquago7eIT7+2aBptpeA9TPdYld2qMQ53FrNnHAGkY
	qShDzU/Grz2lK/ub5RrMXZ4oCtOIxYxAtv26ScDxNt4CpK3BS24zMI+cB9gyCNPHuMAfTSahbs7oA
	86+DxhO4r0WGa01XFummczvzfXNateE83xfwOY1d5QRbZVRQHqgqX6/F+KV8NKl8/jLfG0xZYEq7d
	kCiWBIKw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeO-0000000AKT0-0sOX;
	Fri, 24 Oct 2025 20:44:40 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v3 10/17] slab: Remove folio references from build_detached_freelist()
Date: Fri, 24 Oct 2025 21:44:25 +0100
Message-ID: <20251024204434.2461319-11-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024204434.2461319-1-willy@infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bm3uoizh6hfoy6czzzcaee5p5oxmxjx1
X-Rspamd-Queue-Id: 40D6C180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761338687-675817
X-HE-Meta: U2FsdGVkX1/dR2Mf9w/ABXNU8Wc2fk7Mqy9AkdOFG1wL8W9NyZvY/4JUEVNK6K2GsvsS2MBdsXi4bclXwgJIfAQGV8XTOPW8Hlkc+OkfOQAmuJIyCkoxxU/DFkdIohe2+l1n+taP2IXfudrSB/bYvuzHauJb1JusOL8Ht/R1wX12wuG/0EHBKkYGZgVDvu4H50xEULYscC+6dYr44AnwKGVICBcwGi9AVeiG4vmt032o2JdOKrnIvqYyw9jpw19hxI+SVT0DB3Sp+ke14thIXMH02YBgEfTrdUVlKbba1hps5lrEjxmXAIEEyU9nGSLv3FZdrAqnYyXT2zfdyUriIc3/+pFKESJQLhCEiTAs6G3UoP9IL/kK2rPW9pBruVQ+U63QXdCKL0VZeKZDuLykjqj12l6Ru8wli8hLL5hUYtJstDG9S5cqsH9TlJAKJ2+ScvT0XnS1UNNU7SnJG6tTu7aR7zhke2Fkb062qM5Tu/pF5nxg+ucg8SGw1dpHpJ3v9vq4qbLYkN3OG0BZMClxvQvFatnI94QUZjH82M9Ngzv64vFwYKWzUfsOLWinBUpTie7w6o9ZNExZOqbqeimq0/1V8zr64/FrBtnZTrx64Wrs+hLgrIBM8nj5ZPAZuJR0QUlw27r2IYkhSayzZijb6U3khuGeNjbuGk9txCpBHaJFSdnzjyh3azZto4QcxMp6YuzLy5o8MpuvDAVvVOMqpt/u0P1A2HnbSotNbh6zii0CGZg5uAz6vigE7PTHWDV/GspplFCFjZMCX+5FcsyKhJBLaNeVJy9O2S5zdgS431ZymM71vYnSJ9Zb4AeZ3LYBIiNelfWO/gi1Af7ALJRdp/FCe5qiPll+myPPcqQ7OxMMpIWaOJ8yIgPqIdWmWWNlJE8lHY0YZNtBpVUku6odNLRxTYieRtNJ+Pne1jhVbyTOMnKc1gdcyOjKMUQxxUXQiHixyn7j7iPg6xtU+SF
 z/LLKoF4
 5emmHP1vbxjHB0WaMhiQ4kdSPl+FtdRzFqg+I5Fk7Lb2JvZ7jhFmIbBncJsCbb7tqhVfbANSjTZQCptOB88BWGfsj6RD9tfytIXI0rjJ4kXWNNpAfEcv3masy+0a6YwHDWdMlmgxuyksCtAlLLmBd5IFtadhVLASvN5ps8mGKWy89VTMc10GN9CFS4vzRWvgRpRWr0E2qocs36D8wxYET55Qw36108XSek9ElyVX1UsWLe6c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As with memcg_slab_post_charge(), we save a call to compound_head() for
large kmallocs.  This has a slight change of behaviour in that non-slab,
non-kmalloc pointers will now cause a NULL pointer dereference rather
than a warning.  We could add that back if really needed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 4e282e7782bb..e72016ff0236 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7244,23 +7244,23 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
 {
 	int lookahead = 3;
 	void *object;
-	struct folio *folio;
+	struct page *page;
 	size_t same;
 
 	object = p[--size];
-	folio = virt_to_folio(object);
+	page = virt_to_page(object);
 	if (!s) {
 		/* Handle kalloc'ed objects */
-		if (unlikely(!folio_test_slab(folio))) {
-			free_large_kmalloc(&folio->page, object);
+		if (unlikely(PageLargeKmalloc(page))) {
+			free_large_kmalloc(page, object);
 			df->slab = NULL;
 			return size;
 		}
 		/* Derive kmem_cache from object */
-		df->slab = folio_slab(folio);
+		df->slab = page_slab(page);
 		df->s = df->slab->slab_cache;
 	} else {
-		df->slab = folio_slab(folio);
+		df->slab = page_slab(page);
 		df->s = cache_from_obj(s, object); /* Support for memcg */
 	}
 
-- 
2.47.2


