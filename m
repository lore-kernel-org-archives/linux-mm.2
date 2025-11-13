Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 034EDCD4F5F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7DF8E0011; Thu, 13 Nov 2025 03:41:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2789C8E0016; Thu, 13 Nov 2025 03:41:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16DAE8E0011; Thu, 13 Nov 2025 03:41:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 023D98E0011
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:41:16 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA6BB13BE6D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:41:16 +0000 (UTC)
X-FDA: 84104939352.11.3A14FAE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 41D451C0006
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:41:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=F8vH+9EI;
	spf=none (imf18.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763023275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aDSpBqpuPDvNgRiKLctHSSMS3KA13s/a0UYvKEJUm9Y=;
	b=d2mTh+e6x2j207jEiT5IxE9UWcDvBR+AqrHhtrqQachwt4sIq0EvKipYSjUym6gRa8nlFI
	v3imWMv3VlkKuh1DgQE8bOvmtJpNIEq24FRSDuXQ24uIcOfRtHDj8Pbx8hR+Vo/03F9raT
	luZyjW+4xye9F+kPKYRVCbdq02sccx8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=F8vH+9EI;
	spf=none (imf18.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763023275; a=rsa-sha256;
	cv=none;
	b=Gb9dOc5MOwLlLqyQxfdVblWRJuTFnVMnTVHsdPLTjvUZpfnzBYi/EAZZ53nDKrrQrn33KG
	fZ1cSrMSTDrcjWMQuzqudTe09TKDLf1Mpzo78qLkqFw+QYWH8+ZrABriuDdADz9/kw0+Aq
	TVGsPxGdTWGtkJKV736m/Hgh44EgWyM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aDSpBqpuPDvNgRiKLctHSSMS3KA13s/a0UYvKEJUm9Y=; b=F8vH+9EIobv+MIMPOxmAy+XOQN
	wGvS3vqQgDf7qirAMIahwxY8ZH5xWqd0FPz1x0Ucts2QO3m9pQLHBzwGnTL8HTTjczSs27XPIW2LV
	ABB7un6YVzZpogRbsbgObFbPEPjTD2KcLLPNenCRMbWRnDqf34XVFnDzvlOQfVqBzExqWLfv9Nsus
	KvD/L8HAXfvckRFLXZ1o0ZeOnx4EgvUB0JTQw2YokmyWee5YMFYeKaYHmbf4DE37M/dQXqlXiRONy
	3T68E9NsI6yruVXpJnTo2/DGKcpYlnnezyRVs0oex0VeyW4p0QaEcC4Xp5yt1JIJMf4ktpT8pc2qc
	hTazqwIg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJStD-0000000A7Sb-3YlU;
	Thu, 13 Nov 2025 08:41:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] mempool: factor out a mempool_alloc_from_pool helper
Date: Thu, 13 Nov 2025 09:39:47 +0100
Message-ID: <20251113084022.1255121-7-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113084022.1255121-1-hch@lst.de>
References: <20251113084022.1255121-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 41D451C0006
X-Stat-Signature: 3yycy4u6dngm3mx1xgsm5xxy7ngk6kos
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763023275-359591
X-HE-Meta: U2FsdGVkX1/76OlfB32F72gUbVrrk/0UC1OFCQM/BXbIo8KLRJbZKzrPlolwPzAxofKglkGINU2cMkCiB6k/9y3NHYc7eTMvcHz5/+DRkFW6Jpq/67yw5PD8t/f6yYltbTpTidB+RVAz8vwxTEOPIU6wM+gj+2fbqau9Ffcq6aby50iIvYu2+/MaWmxvSEgODn72ZMYj3pOhM90PgJdD7Qm0EchAPchQfIQTYW47otvDQGusZEU1uQMH1GMHh/2TsqiWMfWA720Jl8Ef+yiNowbIfbz/s989jVX/8P19hAmX+3oRbyMjm2Ybv1138dnwyX8Lo7L/BMuJipsbh8DotaOjbh5Fq6X4BT5M/Fyt9o1fD0zRc1HYkCh1wqPzHXQEg8R0VToogGpeAU1oC+CoC3jrxVJnMeDWQoTNQYuyV0ml+qJHuzSmYKb6woj7s/+eAsw/2Ekmb4ryucZEA6unFdVDql9aPVJcEfmhQ22/o7b8W20jj60Xjei82kRDNvH7YDv17pEcIsSmZ/1pzU7+bjUid9UsiVQb+HpOL6Wh0NmlzYL7TT3vX4wv+eMhlhTQEpE8SQ6GWLkgqGLU/5kHfFXNhwyCTxqKbPv31J6Qq/0erHLcySyDR6gQOZAjwUvQFTLKl1lZ2UPYGJntwwBa50zWs25oJO+5HlzKtfY2qVTE3GyTm7CA7y2kPdN2PHu0RIDTUgwz9uP+2UUVh53B3Tsy/KQPbGkh2r08bfqaW5W4XgU1KriOfRNqDT8jADVs/mNYOeAgmrxibBg04diY8nl4OyTOVeoEu7zfH6WFUdsW4ow879cIfPlfrKlz7CnjYC//FVFKz8QZeJYpzCcpQB+BQmWAdBYMudbHiPKRXKWj2Tjgt90wmBaOeMkFY1yd0Ug7EAYkMbkFVUNu9+W+TER+yPoZCzovw/d1RtHohW2Uw30hsMnbkiynW2YfgLx9OzGUvCuTpAs4TL11Rnk
 iQ61CO6X
 HcWrUAbzGJEXljNPNXMeGsdfYHCFBGLfDTIX8p8t2EopzVCpaBcQeAU3ZzaUdM/GtfvDDDXbEEYpm0RezXJDVsOrH8ivFuQ+BoO7r8Pe4xMHPuACcTpePva8ZzGvQMdGZNF+tCJ9rcK42FgFya0PGyg+aJ1BKX7C1p95MeXGL25JhOh6gC9zHyiMYFbrtW8kCYJZQhLZlmpUq3tLVK57vXCN7IZjDjrIGmhEkD5XcXZZANFjIReXBqnrQu0SCuPD4Hw28LwtNcAToLllSWwYRD8D5Xrfv0RCRVxHhtiN2H3cn5424rs6miVOGsqpYd4lnBmWUfyDvwFP8WGE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a helper for the mempool_alloc slowpath to better separate it from the
fast path, and also use it to implement mempool_alloc_preallocated which
shares the same logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/mempool.c | 121 ++++++++++++++++++++++++---------------------------
 1 file changed, 57 insertions(+), 64 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index a0718a35c34f..c28087a3b8a9 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -380,6 +380,50 @@ int mempool_resize(mempool_t *pool, int new_min_nr)
 }
 EXPORT_SYMBOL(mempool_resize);
 
+static void *mempool_alloc_from_pool(struct mempool *pool, gfp_t gfp_mask)
+{
+	unsigned long flags;
+	void *element;
+
+	spin_lock_irqsave(&pool->lock, flags);
+	if (unlikely(!pool->curr_nr))
+		goto fail;
+	element = remove_element(pool);
+	spin_unlock_irqrestore(&pool->lock, flags);
+
+	/* Paired with rmb in mempool_free(), read comment there. */
+	smp_wmb();
+
+	/*
+	 * Update the allocation stack trace as this is more useful for
+	 * debugging.
+	 */
+	kmemleak_update_trace(element);
+	return element;
+
+fail:
+	if (gfp_mask & __GFP_DIRECT_RECLAIM) {
+		DEFINE_WAIT(wait);
+
+		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
+		spin_unlock_irqrestore(&pool->lock, flags);
+
+		/*
+		 * Wait for someone else to return an element to @pool.
+		 *
+		 * FIXME: this should be io_schedule().  The timeout is there as
+		 * a workaround for some DM problems in 2.6.18.
+		 */
+		io_schedule_timeout(5 * HZ);
+		finish_wait(&pool->wait, &wait);
+	} else {
+		/* We must not sleep if __GFP_DIRECT_RECLAIM is not set. */
+		spin_unlock_irqrestore(&pool->lock, flags);
+	}
+
+	return NULL;
+}
+
 /*
  * Adjust the gfp flags for mempool allocations, as we never want to dip into
  * the global emergency reserves or retry in the page allocator.
@@ -413,8 +457,6 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
 {
 	gfp_t gfp_temp = mempool_adjust_gfp(&gfp_mask);
 	void *element;
-	unsigned long flags;
-	wait_queue_entry_t wait;
 
 	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
 	might_alloc(gfp_mask);
@@ -428,53 +470,22 @@ void *mempool_alloc_noprof(mempool_t *pool, gfp_t gfp_mask)
 		element = pool->alloc(gfp_temp, pool->pool_data);
 	}
 
-	if (likely(element))
-		return element;
-
-	spin_lock_irqsave(&pool->lock, flags);
-	if (likely(pool->curr_nr)) {
-		element = remove_element(pool);
-		spin_unlock_irqrestore(&pool->lock, flags);
-		/* paired with rmb in mempool_free(), read comment there */
-		smp_wmb();
+	if (unlikely(!element)) {
 		/*
-		 * Update the allocation stack trace as this is more useful
-		 * for debugging.
+		 * Try to allocate an element from the pool.
+		 *
+		 * The first pass won't have __GFP_DIRECT_RECLAIM and won't
+		 * sleep in mempool_alloc_from_pool.  Retry the allocation
+		 * with all flags set in that case.
 		 */
-		kmemleak_update_trace(element);
-		return element;
-	}
-
-	/*
-	 * We use gfp mask w/o direct reclaim or IO for the first round.  If
-	 * alloc failed with that and @pool was empty, retry immediately.
-	 */
-	if (gfp_temp != gfp_mask) {
-		spin_unlock_irqrestore(&pool->lock, flags);
-		gfp_temp = gfp_mask;
-		goto repeat_alloc;
-	}
-
-	/* We must not sleep if !__GFP_DIRECT_RECLAIM */
-	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
-		spin_unlock_irqrestore(&pool->lock, flags);
-		return NULL;
+		element = mempool_alloc_from_pool(pool, gfp_mask);
+		if (!element && gfp_temp != gfp_mask) {
+			gfp_temp = gfp_mask;
+			goto repeat_alloc;
+		}
 	}
 
-	/* Let's wait for someone else to return an element to @pool */
-	init_wait(&wait);
-	prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
-
-	spin_unlock_irqrestore(&pool->lock, flags);
-
-	/*
-	 * FIXME: this should be io_schedule().  The timeout is there as a
-	 * workaround for some DM problems in 2.6.18.
-	 */
-	io_schedule_timeout(5*HZ);
-
-	finish_wait(&pool->wait, &wait);
-	goto repeat_alloc;
+	return element;
 }
 EXPORT_SYMBOL(mempool_alloc_noprof);
 
@@ -492,25 +503,7 @@ EXPORT_SYMBOL(mempool_alloc_noprof);
  */
 void *mempool_alloc_preallocated(mempool_t *pool)
 {
-	void *element;
-	unsigned long flags;
-
-	spin_lock_irqsave(&pool->lock, flags);
-	if (likely(pool->curr_nr)) {
-		element = remove_element(pool);
-		spin_unlock_irqrestore(&pool->lock, flags);
-		/* paired with rmb in mempool_free(), read comment there */
-		smp_wmb();
-		/*
-		 * Update the allocation stack trace as this is more useful
-		 * for debugging.
-		 */
-		kmemleak_update_trace(element);
-		return element;
-	}
-	spin_unlock_irqrestore(&pool->lock, flags);
-
-	return NULL;
+	return mempool_alloc_from_pool(pool, GFP_NOWAIT);
 }
 EXPORT_SYMBOL(mempool_alloc_preallocated);
 
-- 
2.47.3


