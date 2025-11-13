Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32663CD342D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:09:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4634E8E0013; Wed, 12 Nov 2025 19:09:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C59F8E0012; Wed, 12 Nov 2025 19:09:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301E28E0013; Wed, 12 Nov 2025 19:09:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3F628E0012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:09:41 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BEFCA89942
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:41 +0000 (UTC)
X-FDA: 84103650162.12.AFC9C87
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2E38940012
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YsJ8p8LO;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3mIpiB/AR+UJNL6Vq4E9ISiOEWlYtXp1+f0wjkmSXGc=;
	b=75GuPaBMrIhhaF63AKo999xamn44jvrn3gnaArZA0FP3b8dlCyaX4FcqFY7iXy2R9SZvXj
	qWHuUD9UtZGLhQVxocGz+MHLL+inj/U5G/JKaD5dZVjwx7mNSu4hbwtatfYOWbljUBEV0f
	tvvVHc9JBR+DC+A52nBKcApT2p4lOEA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992580; a=rsa-sha256;
	cv=none;
	b=Vx3sXhWBBM0niMRMPbOhdvtEjxSk9o77J9ICT/CrrLCgsSzwEZXHRh+QsgeqIkZQo16buw
	96Zo1yC76t45fmrTw9X6uX5h2VzWalfB0mgmllU1aFiL09bnCF6+rN9mUrW82M79i0WuBU
	IOcmaYynQn5QMhD1s4NI1cHoV02EmGY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YsJ8p8LO;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=3mIpiB/AR+UJNL6Vq4E9ISiOEWlYtXp1+f0wjkmSXGc=; b=YsJ8p8LO3Pag/iYUp2WoXclTRd
	VDkQGKHYcPZNS2sMNnDcDyxI0O8EwcnIIh4a0G86hp0qKBu7NZvAFPmICpHlLOt/0iBHx21sCGh2l
	r+XvV7MOaNuYfasnSFUS0qturZTjnP71CWhStHMfJSmED5eodoQWtzLIQsW0Tw6pAduWw2DXuMr90
	HjRNXUSF9oFplvVc84WD5zCkJ89wHSqnaegctULgpNVWo8CE8LWzDEoRNQF4OdAx5ljF8yKMWZ/gY
	cNX5UpATlH3TWQVhocortz514ukmuPmktpJmB1JBNXIVmV1z6ekIlFRusTAoYXS1QRqYthUYn0t7H
	H3CTNUXw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKu6-00000006fOY-3SWX;
	Thu, 13 Nov 2025 00:09:34 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v4 06/16] slab: Remove folio references from free_large_kmalloc()
Date: Thu, 13 Nov 2025 00:09:20 +0000
Message-ID: <20251113000932.1589073-7-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113000932.1589073-1-willy@infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 56tkss74x8shwtyf9c6qqj4yqafgdobj
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E38940012
X-Rspamd-Server: rspam01
X-HE-Tag: 1762992579-149944
X-HE-Meta: U2FsdGVkX1+fkMDrH0qqZIuRbvGcmCR2KcaiiysWCar5LZqDI2AiBTKMFsaloT+bERshNBM02ErqeXxE+UJY4vlNgJVzAmplksfj6TeQEgZZD6E7s81c0IMuuoadicWrWjFQC63jT+MIeMPdeZxB/Mxu9IHoi5norimHHx2bHe39DyKPE662bzep63gL8DvlK/mfV8IpQmJjjoKN1f2nKnQiVNcZEY8f9lx++sQOLgwsyEokLcrE/2DwXBnY/2hAefkb7mDSQUzuEZdnjbLWEYS/cCXc4R8qPi7KpZGQNxHbYDJoaBUAA/VtsjOHuYWKUOEAixprT3nLNXsQy/rZV9NlA9G01o3pCXCEipNVUWRJ16W//zJyRTL6+dpzjyF5Q6w8Z84a6bXIV9tLq08o65nyRl41MyFfyOgSkxib5KMee6HAzQjbba4mPVbi4tkeB8lJ0oTVHcBtsJVXDJxI7MZOZzOfL5OIMxuZplcOS8exosjewMYJuX22ZfdgQODJjqYyHQo1C1TdDs1YaxbbjNsQW1cD37iHXNfqDtbxQ52YXGndIaPM2+BCnigQTicaYnrFJXASUI04+Dm+HiR+RDtf8ipmxz7adET5ZXIbPempCZx0bUblxliMHTwiyhknt+KleAl+9e97ZJj3z96TOTlucDIrGHNiN9A18nv0+ZW06dQecdS4vy6dXju5V8v2RLhNYIZJxaNx9klXVzTDvZQqQB21H0znkzSRkX+Yu0FDyeLRfz/vafr4VggFg9Z4fjfJh/9fuVwv2QLcEa5LhedHJbNA9Kzr7BbPg5SaRx/YYXcObIrHZZ4mLMm0lB4MM5E/9n+S7tU8WjdJo0PP0pdOqlNjI2bizIBz6YlLDWH3Abj+0pGiT/w8Al2Bqzc0R5OOJxY5wXON9+1g65E7EKucyrLHRaMddx73oSVMEyJwUNv9iNxAloZ2LXM0uhI7lUVvq3BN1Z98qPq6aB6
 GpkG3zNv
 a62sUVTzeS1VXQPvcpT08VkENnPOvbx4vCCmFbRuzDassh2upo+niay9joONrMzvqjD4WTL6IxxW8GiBgKH0HH2nddAiifrCAB9FzmvnSR8YiCfwhqbBRd34VjGL1V3Uqz3YZiGyNJ9B0+MSTNo6l/JFlX1itEBRbJ25hr3+0hDq4rd9pV3UieHnmIqHrQDslrx2wzKbXyGGvRFFFlCdsNKLLWiiH6KdLfcjHwZM+PO1PSB6T8b7QzHpdn6hJRjFqS+x8gpfFdFk7LBlqLlVlJ9drLIOZ3uMYj3J/s+PfL/1MFA/H3uwn1mKMva51Iyhvc7xtmMl3ebybdWo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no need to use folio APIs here; just use a page directly.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 90c5663f2b71..05cb7ec48f09 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6791,12 +6791,12 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
-static void free_large_kmalloc(struct folio *folio, void *object)
+static void free_large_kmalloc(struct page *page, void *object)
 {
-	unsigned int order = folio_order(folio);
+	unsigned int order = compound_order(page);
 
-	if (WARN_ON_ONCE(!folio_test_large_kmalloc(folio))) {
-		dump_page(&folio->page, "Not a kmalloc allocation");
+	if (WARN_ON_ONCE(!PageLargeKmalloc(page))) {
+		dump_page(page, "Not a kmalloc allocation");
 		return;
 	}
 
@@ -6807,10 +6807,10 @@ static void free_large_kmalloc(struct folio *folio, void *object)
 	kasan_kfree_large(object);
 	kmsan_kfree_large(object);
 
-	lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B,
+	mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
 			      -(PAGE_SIZE << order));
-	__folio_clear_large_kmalloc(folio);
-	free_frozen_pages(&folio->page, order);
+	__ClearPageLargeKmalloc(page);
+	free_frozen_pages(page, order);
 }
 
 /*
@@ -6838,7 +6838,7 @@ void kvfree_rcu_cb(struct rcu_head *head)
 		 * consider folio order
 		 */
 		obj = (void *) PAGE_ALIGN_DOWN((unsigned long)obj);
-		free_large_kmalloc(folio, obj);
+		free_large_kmalloc(&folio->page, obj);
 		return;
 	}
 
@@ -6878,7 +6878,7 @@ void kfree(const void *object)
 
 	folio = virt_to_folio(object);
 	if (unlikely(!folio_test_slab(folio))) {
-		free_large_kmalloc(folio, (void *)object);
+		free_large_kmalloc(&folio->page, (void *)object);
 		return;
 	}
 
@@ -7305,7 +7305,7 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
 	if (!s) {
 		/* Handle kalloc'ed objects */
 		if (unlikely(!folio_test_slab(folio))) {
-			free_large_kmalloc(folio, object);
+			free_large_kmalloc(&folio->page, object);
 			df->slab = NULL;
 			return size;
 		}
-- 
2.47.2


