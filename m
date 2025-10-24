Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F07DECCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5399E8E010F; Fri, 24 Oct 2025 16:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44EF38E0112; Fri, 24 Oct 2025 16:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2771D8E010F; Fri, 24 Oct 2025 16:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E04C8E010F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:45:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C425F89571
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:59 +0000 (UTC)
X-FDA: 84034187118.01.D3A7F2F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4603E1C000C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DjGCW6HM
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338698; a=rsa-sha256;
	cv=none;
	b=HUGyblN58i2OcDfrV9NEjv2t6YssWcWaBFDfDKvNPixY6kWXYYzNMZFmdtCP5lCh3xJbUG
	9I0NMSVSUf1lBCQKnjvDYTmeWQ23KeYY5NWnCZXezuxIFh4WrbCgu8q4AQ04fKQ+oYE6en
	zE6wzsCaWc3Bfk82d4v5PPUvSFL/dTs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DjGCW6HM;
	dmarc=none;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CAglNh1kx11QZsRp8gze3hT1pdRXhjGIJ42YaDLK4Fo=;
	b=oy59JvWG+VxkLwH1q9BAId9N1ZZLDigZtcZcGIIYlNPqOHiK57mI6uk9L6dF17QABAXiAj
	JsX6wm2+3lj8TulJzLa99cNvu7oG4WpRUiy5t4K3TVWvnfsQQ90pSkYizlmTod/6Hqtjj2
	bZsN3QL5ABb6Pi7TIOF9uZVNwnWCWvg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=CAglNh1kx11QZsRp8gze3hT1pdRXhjGIJ42YaDLK4Fo=; b=DjGCW6HMjMfqx2Xqjz3mkez0VS
	qiBmaKcQX+ySCs9yN79YKbZjCzZXGGdOSdwZZ4Qxszb9Z+I7yTshKw5rdDO0m5nuDP6NxPHfaQbcG
	8EwJUMT3Az5UedhuJrhikMShkfOuaMlK/2+gbdJXDuzx0eRKcGYY+13cTBsO+4tKuhITjaZ3hHqV1
	uTyyT/HI+y7NJ/BZY+iYRkLc0RemtnHwD9KE3nZr2p6LlrwbPz+ONsB5jtFcnVWohJmz63bB4Vdt1
	0WcPBwVyDsJI1HWbUQXTCWOIXQg9jQyGdLDKS02PQ2rc4e7THZqbqjO0wJW7e98hDri/wszJn6pqE
	j5u8UVHw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeN-0000000AKSA-3xu7;
	Fri, 24 Oct 2025 20:44:39 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v3 07/17] slab: Remove folio references from kvfree_rcu_cb()
Date: Fri, 24 Oct 2025 21:44:22 +0100
Message-ID: <20251024204434.2461319-8-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024204434.2461319-1-willy@infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4603E1C000C
X-Stat-Signature: ti6531h1rxnfoepb9razcecurse395nf
X-HE-Tag: 1761338698-46576
X-HE-Meta: U2FsdGVkX189rBcNsvC+8wz8J4dmtSsL6Wk01MyfAqar2JkaII//uCn7td+ZqUxzl99Csuizmpndsqbd2P+YSRaFDhtzrsqeOn4nO9/ariyjTmyerGbzAWFg1YBWIbAqtKLUGbOOE4494mTI+E7EnRlkFwPQ9OO1RzAT6WxVZfRZLmOOPUika+9dH4XMUowgAHTN9oJ3xU+g++kccjiMP4TVpK5eZAjUai2QDKpoM4omNaa96BYRpLgENHPWePyqsXflhzF7j/wiARX2t/UGrp9XCitR9gxKQA5139jFVumpqTUzwBPwMi68veUtqo5LMFxdIkePJ+KDqBFueDL1karMHZE0jcGYTX9Sk4hrTmsH/bn/P0aGYr+uWB2FDy9B7xrK803KYdBxHWJ+1fAPB513LrraNwj/eai74EYbXOX6UoqGXUpc5DmmFoLF7HpWe19aRX79qExkEWpbkgxjR/TkeTNfCy3gujxlD8k3rBdzQM0Z6kPWDMffEBw2X/7JuESSZT1ke6o2LjbJohivSG4u1LaX6ZaCc/gIZWIO/sRA7CL6pMrHWPxSBg5RzwBxdoTYbeunAWIyOKz+UWqP3NYB2G9eXs2wPEBfMmV/wI6tAdi51hVy/RxzuagppGx7O3jtAi59DSubqUlYt9OXB2j9NkIm3/7Bo5UhRbR/FuytqTMn+3LE9E8A3psVw8Y1tP1mKUYVARAMZQDVwH+4Lby7vqVcfM8vzDMEN4eoTbN+jkglKx5KwLa64irX810Cp7vPnlCPzTGu2KnkeyL0j0z9+y+DhbwL+obaVbu0OmJ26SPfbTlgLn1ShRnIzy7ds+cOz4yF+9FPkG9yX8ANMRTv1O4OIEy748x3G22tMn4=
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
index 561944d39be9..debe7132b343 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6763,7 +6763,7 @@ static void free_large_kmalloc(struct page *page, void *object)
 void kvfree_rcu_cb(struct rcu_head *head)
 {
 	void *obj = head;
-	struct folio *folio;
+	struct page *page;
 	struct slab *slab;
 	struct kmem_cache *s;
 	void *slab_addr;
@@ -6774,20 +6774,20 @@ void kvfree_rcu_cb(struct rcu_head *head)
 		return;
 	}
 
-	folio = virt_to_folio(obj);
-	if (!folio_test_slab(folio)) {
+	page = virt_to_page(obj);
+	if (PageLargeKmalloc(page)) {
 		/*
 		 * rcu_head offset can be only less than page size so no need to
-		 * consider folio order
+		 * consider allocation order
 		 */
 		obj = (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
-		free_large_kmalloc(&folio->page, obj);
+		free_large_kmalloc(page, obj);
 		return;
 	}
 
-	slab = folio_slab(folio);
+	slab = page_slab(page);
 	s = slab->slab_cache;
-	slab_addr = folio_address(folio);
+	slab_addr = slab_address(slab);
 
 	if (is_kfence_address(obj)) {
 		obj = kfence_object_start(obj);
-- 
2.47.2


