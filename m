Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13D67CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 13:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 713C88E000C; Tue, 11 Nov 2025 08:53:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C4A68E0002; Tue, 11 Nov 2025 08:53:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6020A8E000C; Tue, 11 Nov 2025 08:53:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5275C8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:53:37 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 062741405D6
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:53:37 +0000 (UTC)
X-FDA: 84098468874.18.AE49109
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7C2A440017
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:53:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KuxyIom3;
	spf=none (imf07.hostedemail.com: domain of BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762869215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p0rppA8e5n/RynaKchtzsVu3tIhHELjvyJLmV+KshVg=;
	b=AkWsAqJAcOwB6UAXDGuT0uj66o44V3laBw88rkCAH6k0+akLQUR2jYWFdcu7jRz4ExLuwp
	W3BzYiG1mBocsTha4tiOn9EQaqLjohoXmLqIHD7gQokVsclywDevHI7sD1IZ5FmuGBIpBl
	kjdGg2UMKiz8ry9mF9wUM4PoEdx9X8M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KuxyIom3;
	spf=none (imf07.hostedemail.com: domain of BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762869215; a=rsa-sha256;
	cv=none;
	b=ivbID42SEGaUUJTkMvu6hhdPSOEk3q+hMLD2yV7xU1OEBQ/WrI8DyzAgrfrI1ybWtNL7mU
	Vo0PdMwj7RsNUhPGEM4Vx5g/qCKOe36H2hqZXM9FCo78x2Eb2G4HGVyO6Xm5nu8Ou9FuBX
	Qex1n3cQU1DoWzdsAnEsASkbFDp5Neo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=p0rppA8e5n/RynaKchtzsVu3tIhHELjvyJLmV+KshVg=; b=KuxyIom3OhkUkh8uhojFIQPDxc
	v6/q2qsd0sHd11Cv8fXN5fMYyEhX10yZCnhWkqyMYyKTTBNKf6Znm4w5VyhodZSrRV4qrILiRmWHK
	q6dWiCPNANJ2TrxUkow59fPvTOhEWtWpeMzn/GuSHKT9BaEDoSW4866PcakzOPqzCj7O/9j9hymdE
	MEj/tvntfvkG3mpIztuOBFEquHIvKBgaazkcGSB5u4AscamGWRkzaSh+zVFARw64obDLQLgHixMjp
	9zkLPqV2IoMxKgc0jhy3LQzEv4tLAuVPR4UiZHHkGG5SfSLBHTEgmcVKSsUoIRKqALLIrqI6s9Cz5
	5bvsaQYw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIooO-00000007Gcj-3dPE;
	Tue, 11 Nov 2025 13:53:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] mempool: factor out a mempool_alloc_from_pool helper
Date: Tue, 11 Nov 2025 14:52:33 +0100
Message-ID: <20251111135300.752962-6-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111135300.752962-1-hch@lst.de>
References: <20251111135300.752962-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 7C2A440017
X-Stat-Signature: 634mg9bf7x5hiaanx6qd69g6ksr4ym9f
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762869215-221915
X-HE-Meta: U2FsdGVkX1+WKqOaf+C5Rkhhy8oX+Dw2aM6hcCQRl77gAobjQSpRFTysQLG1sdyj9AWjUlwXhhFkoLk+VqcB92c5GU9NK2yxinLqaD1KW8G/Gy/B+WiXomsf5XAj9C2AIXHR6mFniwrVZRry49LWRJd8BfpgTc6MLPX5Maya5jyr3jvvJxpeHR5wtzg9guN/xbiftWQ1OENZbjyjJykDVYK1/ZY1u3H7Qq/GjUAcST9XEknTJp4cg/FzyCZp/V7rMRUX5MiKi4/zYInbmuh2j+GQ0DSWPgUOH3Ew1uMYZgpp3bbh7my2ItplB6fh3me1le6ZFtycJRHzzuty4flpqzNbh2C6b9ZZKKgnvu2cFc9SVXHDtzVzICtJVQ2cwI442hah5WM/dwdP77jkuyCPAqev5LIIgJQ33+eEE7cJLXK1VCqk2sOkPoK1Ki1ArwT+wmh/Yg/pH53qVXZfovwlgfTyEfChTdbPE0avM6Al1UnGuQ+avZc9BexJ2NZvddwy8+aXvVARpSxMgm7v0GYNnwos/PieuEK/mt2Qvg4aUh3FhBVFarokpUwqUZt1pOabt0xIikddaIpP/vsHq1hD4sl/sATn3bERXf7wpAgWvVBRo29/fz6gXE4zIwW2LQo6IETYL/ZEju+kgwrAPstqE5YXFhhv5rVz3SOLokbpBsqj7C67sJ9gKKa3nmIpjUhk05/gQ0gctx03pf3qMkyhxGPyFLXyTUxdED/+yxMMeHYDFx26qWQWnQVBzHYYjCmltf1EqC0KVg9H1Zcqg+Eq0kTfkv2DfS/hB24zxYxTR+7oYIKpA2+Y56yeOqYzV2YyVdeXYBcUY+ULC/c1mYIV9dYMwxAYsFolY5AWP9TQvwcNiJIf1zZqioAAJMXYYdoz+Th2CaXM7ZnfdSAp7We6fF1gfgYh/xf/goNquCaBHr9URCEQ9XJ3Okq1TcifjsFJJ7GC7buhA4EJ18ByALc
 jEDqouBc
 CU2WcI/G5OjZiEoEpB/9aQgeW5TfGDQ8YsA5wfFtqwBxNU9THSP4Si6TNhMKlI/5rJtdkS8Ow/HdUPnVnbJQ63/5LoQ93e7JiDeNZGkOgN4xeKNQxMPOVgkzExNNqXC8x3BksMN3sz9AFOGga0PKHR22+vrsW398gJo8uvU5W5j2XOWEA22xbwQB/4/KJngZaouzqLY5zysEfMexOd/f6hQMJ/J/dz27UaO3cdDVFgv0ZkplPXTu/FeAC5Frgs2p61u8+TQLathS8AP/ryWJHqruZvKZsAMivjWqxo8E7oQcZYRVjP5ObRSyDUTsYzRgf2BzXz9TMr9XyVR0=
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
index 912364e279e9..850362f4ca7a 100644
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


