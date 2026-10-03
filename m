Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6764DCA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3C26B0096; Sat,  3 Oct 2026 17:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77EF46B0098; Sat,  3 Oct 2026 17:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692C96B0099; Sat,  3 Oct 2026 17:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 011386B0096
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:22:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6334BA0A14
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:22:56 +0000 (UTC)
X-FDA: 85282589952.08.FBEA6D7
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf16.hostedemail.com (Postfix) with ESMTP id AB7C7180002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:22:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ThdRzXB+;
	spf=pass (imf16.hostedemail.com: domain of 3LHLBagYKCHMciZqqfXffXcV.TfdcZelo-ddbmRTb.fiX@flex--lrizzo.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3LHLBagYKCHMciZqqfXffXcV.TfdcZelo-ddbmRTb.fiX@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILXebACN7PwS4fPLD7OqPMsk7FAR2TMHjyWjGbbeypE=;
	b=Z9nqbP38DLHLD8mvLySDum7CGOAMkn0z3GPzGqPgoL+2c/cL+enrUiT3KFvYNuegRd/DMa
	qNYN5lhL4l0GH7HAjx8IsE6kQMD5cj5Lnq23GqbTPDv0R54+FFHMN6MBmuii0MJVx4mXok
	OCqg08EPY4ghzmz4omhdVtyA5nsg9Mo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ThdRzXB+;
	spf=pass (imf16.hostedemail.com: domain of 3LHLBagYKCHMciZqqfXffXcV.TfdcZelo-ddbmRTb.fiX@flex--lrizzo.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3LHLBagYKCHMciZqqfXffXcV.TfdcZelo-ddbmRTb.fiX@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062574;
	b=OmdRScFOF9vqcAIPpSdFJEFZtvYHEunzSYdx8K3yDEz8fBZkhLq+R/HMl7rLs2Vb32EjJ6
	nCXhnOK7ofrqll0UKq1iL0fwtg0bj7O8meHu6mUrLnT9D+3v51N81lWOkCETJQWnZ/eGP9
	pJe2w2Lu4dohzAzu886hqWVXb4ICUr0=
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c210c66672eso117456866b.2
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062573; x=1791667373; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ILXebACN7PwS4fPLD7OqPMsk7FAR2TMHjyWjGbbeypE=;
        b=ThdRzXB+31e2nZOsY8DCXP+LCiqPnnLq0GGZFIVmkErTHfaBeMVkyfi3wYbJqtSPCL
         O5BpHHxvheUFxjDi/PWuOKWMkG6W0mmEEhvgpeu6k+QTpF8zSC+Cldq/FcB3u/98OjLf
         /NcJIcp7BcktIcfsuDd6mJpgt4/eJlycx12AX4ktwWzBrtkbPvyA6i5zaAHTXnvvryT2
         c8NT3o/Nvo7Rd/euClW90Rc5nPltKYLMxdqm3sqJwERjTqUx4jETW4mEeAm50z10D+Pv
         cmoZY+lkBVMDfCfWplAx0ZM9Qk+CBZdjxOIJsQi82PHPHAzZnH8iM6L70aZ7P0NM2s3/
         vVgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062573; x=1791667373;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ILXebACN7PwS4fPLD7OqPMsk7FAR2TMHjyWjGbbeypE=;
        b=eZtV4z0QKzcu24Y/inXV49e/TT46A0nQL5ou9kBKLHj80+IW+TV/dHgAurxPZQ2aDn
         8qG4CSqvbouiXz2aVB93R+9OXvxaTFEPzUbdh1kFvusvgAH0F1frrOIuoJeGpTzRuKzl
         6YaUHhRYt51uokpd763OmGbHZWISLemz23bmz+gEpG6dUCwMQHgmBDNSMZYBzbvS3Jkb
         MUw4TDVRi5zraniBegW0FqE0qIUZ+qddBINnjJohmZ2KNHV7nfD/+GIncSlumg8DBwGe
         8sLLRm9oc8eUFAIXInkGeGUTuijmkdaVDspJLzjFauW1wVhABni37F1lwD7ZedIcFWob
         ZLeQ==
X-Forwarded-Encrypted: i=1; AKwUvBy6TKaMpMZCeRWgxfHCMcnwD5I2ey2+mVSYZAoQolGGSWl8TPY/+iPw2y2uZjpBHY15gfixQdy84w==@kvack.org
X-Gm-Message-State: AFuF++mNgHUwkJo9MgX4L+oY2UtA3ue0IO6LxcpaeVISfQd2BG8HuNqD
	RlDP1z2GNzae+ec/WeMN3HUAYIDerTazd+gdRvt00U8UicPPcLFnGMpIo2aADw/gpKVos+kTxT6
	NWhXYfg==
X-Received: from ejbhb21.prod.google.com ([2002:a17:906:b895:b0:c2e:845f:6dab])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:e003:20b0:c2e:4b90:3c53
 with SMTP id a640c23a62f3a-c2e4b9042a4mr380528166b.1.1791062572894; Sat, 03
 Oct 2026 14:22:52 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:24 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-6-lrizzo@google.com>
Subject: [RFC: DMA_PMD 05/22] iommu/dma: Global cap and shrinker for DMA_PMD
 pool memory
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xqo1hmegzqr7ntckczdxouf5kujz47ui
X-Rspamd-Queue-Id: AB7C7180002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1791062574-41585
X-HE-Meta: U2FsdGVkX18Oo4NNJk9q5ba6DyRCDedZXQBB1RmKTGCTwKx9bHBVeGmEd9CgxaIHVBBep+/3WRhsc1+Ld7ypHewcDoUxwFjPG2xQAw/ZHZMYxv49myGYV40SQTGrthBDgDLW9+e5ZdhUaRwudNhUkSrZFQdruBUjVUuboi8hoS/ieJu5L8sU8faqOsJMSYaGHq+QYrv8Ck/W/xmsK7XbobPwuzfayij9nAfU7hLSP4ZL73MLe8mrMVrDrZ0NvDqOox+xZTYBUqzCnb2f59lO3V1G0l75Om8x+oBHw7knoXKwqANfNxKxfg4pNx0cKCaN6uX8Pd5QxbSKXVboXmuoGOlwaQ1AeIOgPSlqpHwAfxPSMa7NZxudHP/RcO7AAel3NhoIA0Ifc0iNRH2bYnAyz3W3Hx2oHFAtvjYc4BVlKvLYLIyT+PIfVNdA9N7cLIyebyExU/V5gQZ/7+zYZah+IIFQnflVaDZx1MOSows76jHkTi+VduvJe88mhwyCzUJejjN6/lJxSvBusq+ErfwYRN8WWLRSU+5DXAU1VbK9H6OzubClTBZjBXWfVZQB7f6X96ALIEEOPMOQATbMlgc2Oz4Pgyc0f/Q8PFKL1SCkZwtivK1/u3ak1Xh/FQxSHLunPJFxSoqjl+23xn3CTFRX2uVVQb5YNaPRN1FVFG7J1UxS7czgAjsHsbWWArNTS7fVLhtH3Tg7WqXcu5NLACJCFdE/HeKbvxN/B4v5mw6OWM4aC9bc19RTQ9bX01wyR1A4bkpgUsb4dC6c4NcPeSK/E85kcX/lGHnjimWGVcamQBCi5DRqmPKTJYRI6seak8fh64HHt/SwskaAmWY61kUjeMYPZ4d8Fbpn57sC1iH+cWxifmHmDUIkwM+CP4VGE8J10uYdqAwmYo9VhpCfYukqIUwKuXnGmF52f+BcfBwd+hzJSnlb3JhjNNAQlkVZ12mCQxdOnAGZn4XmUkLvkAd
 Z1Wcicoi
 Qf6RF4FF5ghrvW5Ax8FG+dtsqjBT2tbTGTlsxlBCKF8OSGNh03Tr8jkwrCMWFNsNJDG8NGVtwP406mT/1itxvEhKTXiA/38wIuJ821pcqe5t8myTMnkIy4bJxGBKcj3pdoZ7lB3T2onsh2rMX57wnt5i0bicDtW1EE6ubWKigOsQHHEx+rNSvl3dzj65qunWU4FtPl0UWt6TeNr/43uXnvb4pEMxaU8hO1szfE4F33LL4olBiz0VMkFmQ5/ZIovJlKvcD9h0oq5JcPXbajh9XlhmpQp9IO1ZrJSLbZ/HyLdHg/tx2ZG6JVfx6Zi9zykEuhOfPFx5xuFcVV62VFqLDMONXfD2sMXGyt3m70dDxHw9fD8tYPHRdkBXy/UeGU+OMyj/zvVM8Kset8UhhcR54Al48C9CcZe2F2S53UupA9r+aWRhtPro78Eg4380QCazOwRE6SUVr2ISrt37XRRHCPDW6HdLsqhIyZ8jz8M38C7vk8U3wYLrkoxW1pBNH0Ey1Aya5quywKTgkMZuXepeG//sLKILHM3KJKyY7ewb0kSoRbR2ETFdFW5Sv6SBlGIfTDgC8rIe3GxLBABwzyzJXWC9AveJAO1YtgOsWZKCRV2k6TjWZ00aVH+r/ivKd5mjsJ3ymitbKseuaKN6Sj1YzbgawMc5bWZRKXtBL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Each pool holds some idle pages, for faster future allocations, but on
large systems there is one pool per CPU and the number may become large.

Add two mechanism to bound the number of unused DMA_PMD pages:

 - a global ceiling on the number of DMA_PMD pages pinned across all
   pools, defaulting to one eighth of RAM with a floor for small machines
   if not configured via /sys/module/kernel/parameters/dma_pmd_max_pages
   It is checked before each DMA_PMD page allocation and is meant to bound
   a pathological configuration, not to be reached in normal operation.

 - a shrinker that, under reclaim, offers every completely idle page in
   every pool and retires as many as the reclaim path asks for, stopping
   there. Idle pages are detached under the pool lock and retired outside
   it, since retiring one unmaps it from the IOMMU.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/dma-pmd-kunit.c |  21 ++++-
 drivers/iommu/dma-pmd-pool.c  | 146 +++++++++++++++++++++++++++++++++-
 drivers/iommu/dma-pmd-priv.h  |   2 +
 3 files changed, 165 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/dma-pmd-kunit.c b/drivers/iommu/dma-pmd-kunit.c
index 24978a5123f54..4e38cc5970433 100644
--- a/drivers/iommu/dma-pmd-kunit.c
+++ b/drivers/iommu/dma-pmd-kunit.c
@@ -88,8 +88,8 @@ static void test_meta_pooled_toggle(struct kunit *test)
 
 static void test_pool_alloc_and_recycle(struct kunit *test)
 {
-	struct dma_pmd_pool *pool;
-	struct page *p1, *p2;
+	struct dma_pmd_pool *pool, *pool_wm;
+	struct page *p1, *p2, *b1, *b2, *b3;
 	unsigned int order;
 
 	KUNIT_EXPECT_NULL(test, dma_pmd_pool_destroy(NULL));
@@ -121,6 +121,23 @@ static void test_pool_alloc_and_recycle(struct kunit *test)
 		if (p2)
 			__free_pages(p2, order);
 	}
+
+	/*
+	 * Exercise max_idle_2m = 1 watermark release: an order-(PMD_ORDER - 1)
+	 * pool has 2 blocks per 2M page, so 3 allocations span two 2M pages.
+	 */
+	pool_wm = dma_pmd_pool_create(PMD_ORDER - 1, 1);
+	KUNIT_ASSERT_NOT_NULL(test, pool_wm);
+	b1 = dma_pmd_pool_alloc(pool_wm, GFP_KERNEL);
+	b2 = dma_pmd_pool_alloc(pool_wm, GFP_KERNEL);
+	b3 = dma_pmd_pool_alloc(pool_wm, GFP_KERNEL);
+	if (b1)
+		__free_pages(b1, PMD_ORDER - 1);
+	if (b2)
+		__free_pages(b2, PMD_ORDER - 1);
+	if (b3)
+		__free_pages(b3, PMD_ORDER - 1);
+	dma_pmd_pool_destroy(pool_wm);
 }
 
 static struct kunit_case dma_pmd_meta_test_cases[] = {
diff --git a/drivers/iommu/dma-pmd-pool.c b/drivers/iommu/dma-pmd-pool.c
index e6e5ba7c65f27..78f2537772d1d 100644
--- a/drivers/iommu/dma-pmd-pool.c
+++ b/drivers/iommu/dma-pmd-pool.c
@@ -39,6 +39,17 @@ static LLIST_HEAD(dma_pmd_free_list);
 /* Dedicated WQ_MEM_RECLAIM workqueue, can run without allocations. */
 static struct workqueue_struct *dma_pmd_wq __ro_after_init;
 
+/*
+ * Running total and global ceiling on DMA_PMD pages pinned across all pools.
+ * If zero, it is set at boot at 1/8 of total RAM.
+ * Without this the bound is per-pool, so the footprint scales with the number
+ * of pools (one per RX queue, two per CPU for sockets) with nothing watching
+ * the aggregate.
+ */
+static atomic_long_t dma_pmd_nr_pages __cacheline_aligned_in_smp;
+static unsigned long dma_pmd_max_pages __read_mostly;
+core_param(dma_pmd_max_pages, dma_pmd_max_pages, ulong, 0644);
+
 /* All live pools. */
 static LIST_HEAD(dma_pmd_pools);
 static DEFINE_MUTEX(dma_pmd_pools_lock);
@@ -101,6 +112,8 @@ static void dma_pmd_release_page_rcu(struct rcu_head *head)
 		__free_pages(block, order);
 	}
 
+	atomic_long_dec(&dma_pmd_nr_pages);
+
 	spin_lock_irqsave(&pool->lock, flags);
 	pool->pmd_free_cnt++;
 	spin_unlock_irqrestore(&pool->lock, flags);
@@ -115,7 +128,7 @@ static void dma_pmd_release_page_rcu(struct rcu_head *head)
  * Cost: Slow path; clears the membership bit. The blocks themselves are
  *       returned after an RCU grace period.
  * Locking: Must not hold @pool->lock.
- * Frequency: Rare (background reclaim workqueue, pool destruction).
+ * Frequency: Rare (background reclaim workqueue, shrinker, pool destruction).
  */
 static void dma_pmd_release_page(struct dma_pmd_meta *meta)
 {
@@ -168,7 +181,9 @@ static void dma_pmd_schedule_reclaim(void)
  * @order: Block order to dispense, must be <= PMD_ORDER.
  * @max_idle_pages: Maximum number of completely idle PMD pages to keep cached in
  *               the pool before asynchronously releasing excess PMD pages to buddy
- *               (0 uses default of 16 = 32 MB).
+ *               (0 uses default of 16 = 32 MB). This is a per-pool bound; the
+ *               aggregate across all pools is additionally capped by
+ *               dma_pmd_max_pages and trimmed by the shrinker.
  *
  * New PMD physical pages are allocated on demand on the NUMA node of the
  * calling CPU (the NAPI CPU for RX queue refill, or the application CPU for TX).
@@ -294,6 +309,15 @@ static struct dma_pmd_meta *dma_pmd_add_page(struct dma_pmd_pool *pool,
 	if (!can_block && time_before(jiffies, READ_ONCE(pool->next_alloc_attempt)))
 		return NULL;
 
+	/* Aggregate ceiling across every pool, independent of max_idle_pages. */
+	if (atomic_long_inc_return(&dma_pmd_nr_pages) > READ_ONCE(dma_pmd_max_pages)) {
+		atomic_long_dec(&dma_pmd_nr_pages);
+		if (!can_block)
+			WRITE_ONCE(pool->next_alloc_attempt,
+				   jiffies + DIV_ROUND_UP(HZ, 100));
+		return NULL;
+	}
+
 	/*
 	 * The following flags are discarded:
 	 *
@@ -324,6 +348,7 @@ static struct dma_pmd_meta *dma_pmd_add_page(struct dma_pmd_pool *pool,
 
 	page = alloc_pages_node(nid, alloc_gfp, PMD_ORDER);
 	if (!page) {
+		atomic_long_dec(&dma_pmd_nr_pages);
 		/* Retry backoff; could be made shorter or tunable in future. */
 		if (!can_block)
 			WRITE_ONCE(pool->next_alloc_attempt,
@@ -338,12 +363,14 @@ static struct dma_pmd_meta *dma_pmd_add_page(struct dma_pmd_pool *pool,
 	 */
 	if (unlikely(!dma_pmd_meta_ensure_pfn(page_to_pfn(page), can_block))) {
 		__free_pages(page, PMD_ORDER);
+		atomic_long_dec(&dma_pmd_nr_pages);
 		return NULL;
 	}
 
 	/* Fails with -EBUSY if a concurrent PFN walker holds a speculative ref. */
 	if (split_page_compound(page, PMD_ORDER, pool->order)) {
 		__free_pages(page, PMD_ORDER);
+		atomic_long_dec(&dma_pmd_nr_pages);
 		return NULL;
 	}
 
@@ -642,8 +669,112 @@ bool __dma_pmd_free_page(struct page *page)
 }
 EXPORT_SYMBOL(__dma_pmd_free_page);
 
+/*
+ * Idle PMD pages are retained per pool up to max_idle_pages, which is a throughput
+ * knob and deliberately does not react to memory pressure. The shrinker is
+ * what makes that safe: under reclaim every completely idle PMD page in every
+ * pool becomes available, so the pools give the memory back instead of
+ * pinning their high-water mark for the lifetime of the machine.
+ *
+ * Both callbacks use mutex_trylock() rather than mutex_lock(): a thread that
+ * already holds dma_pmd_pools_lock can enter direct reclaim from an
+ * allocation it makes under that lock, and reclaim calls straight back in
+ * here. Giving up is always correct, since there is nothing this shrinker
+ * could free that the holder is not already about to account for.
+ */
+static unsigned long dma_pmd_shrink_count(struct shrinker *shrink,
+					  struct shrink_control *sc)
+{
+	struct dma_pmd_pool *pool;
+	unsigned long nr = 0;
+
+	if (!mutex_trylock(&dma_pmd_pools_lock))
+		return 0;
+
+	list_for_each_entry(pool, &dma_pmd_pools, node)
+		nr += READ_ONCE(pool->num_idle_pages);
+
+	mutex_unlock(&dma_pmd_pools_lock);
+
+	return nr << PMD_ORDER;
+}
+
+static unsigned long dma_pmd_shrink_scan(struct shrinker *shrink,
+					 struct shrink_control *sc)
+{
+	struct dma_pmd_meta *meta, *tmp;
+	struct dma_pmd_pool *pool;
+	unsigned long freed = 0;
+	LIST_HEAD(release_list);
+	unsigned long flags;
+
+	if (!mutex_trylock(&dma_pmd_pools_lock))
+		return SHRINK_STOP;
+
+	list_for_each_entry(pool, &dma_pmd_pools, node) {
+		/*
+		 * Every PMD page on @idle is a candidate, so this detaches one
+		 * per iteration and stops as soon as the reclaim path has
+		 * what it asked for: the IRQs-off section is bounded by the
+		 * work done, not by how many PMD pages the pool holds.
+		 */
+		spin_lock_irqsave(&pool->lock, flags);
+		list_for_each_entry_safe(meta, tmp, &pool->idle, list) {
+			if (freed >= sc->nr_to_scan)
+				break;
+			list_move(&meta->list, &release_list);
+			pool->num_idle_pages--;
+			freed += 1UL << PMD_ORDER;
+		}
+		spin_unlock_irqrestore(&pool->lock, flags);
+
+		if (freed >= sc->nr_to_scan)
+			break;
+	}
+
+	mutex_unlock(&dma_pmd_pools_lock);
+
+	/* Retiring must not run under @pool->lock. */
+	list_for_each_entry_safe(meta, tmp, &release_list, list) {
+		list_del(&meta->list);
+		dma_pmd_release_page(meta);
+	}
+
+	/*
+	 * Both counts are in pages, matching dma_pmd_shrink_count(). A
+	 * 2M page is 512 of them and cannot be freed in parts, so a
+	 * SHRINK_BATCH sized request always overshoots. Report what was
+	 * really reclaimed so that do_shrink_slab() charges its budget for
+	 * the whole PMD page instead of the 128 pages it asked for, and does
+	 * not come back four times over for the same pressure.
+	 *
+	 * Zero scanned pages would leave that budget untouched and spin,
+	 * so a scan that reclaimed nothing has to say SHRINK_STOP.
+	 */
+	sc->nr_scanned = freed;
+
+	return freed ?: SHRINK_STOP;
+}
+
 static int __init dma_pmd_init(void)
 {
+	struct shrinker *shrink;
+
+	/*
+	 * Hard ceiling on memory diverted from the buddy allocator into 2MB
+	 * pools, in PMD pages. One eighth of RAM is far above what the per-pool
+	 * watermarks should ever reach; it exists to bound a pathological
+	 * configuration (many queues, many CPUs, all pools at their high
+	 * water mark) rather than to be hit in normal operation. The floor
+	 * keeps small machines usable. Zero here means the dma_pmd_max_pages=
+	 * boot parameter did not override it.
+	 *
+	 * Lowering the cap later only stops pools from growing; the PMD pages
+	 * already held are returned by the shrinker as they fall idle.
+	 */
+	if (!dma_pmd_max_pages)
+		dma_pmd_max_pages = max(totalram_pages() >> (PMD_ORDER + 3), 16UL);
+
 	/*
 	 * Reclaim frees memory, so it must not queue behind arbitrary work on
 	 * system_wq when the machine is already short of it. Failure is not
@@ -653,6 +784,17 @@ static int __init dma_pmd_init(void)
 	if (!dma_pmd_wq)
 		pr_warn("dma_pmd: no reclaim workqueue, falling back to system_wq\n");
 
+	shrink = shrinker_alloc(0, "dma_pmd");
+	if (!shrink) {
+		pr_warn("dma_pmd: shrinker registration failed\n");
+		return 0;
+	}
+
+	shrink->count_objects = dma_pmd_shrink_count;
+	shrink->scan_objects = dma_pmd_shrink_scan;
+	shrink->seeks = DEFAULT_SEEKS;
+	shrinker_register(shrink);
+
 	return 0;
 }
 subsys_initcall(dma_pmd_init);
diff --git a/drivers/iommu/dma-pmd-priv.h b/drivers/iommu/dma-pmd-priv.h
index 99bd7d77fd4ef..39295d0add51d 100644
--- a/drivers/iommu/dma-pmd-priv.h
+++ b/drivers/iommu/dma-pmd-priv.h
@@ -21,6 +21,8 @@
  *			when can_block is true. It is not nested with pool->lock
  *			or meta->map_lock, and sits inside dma_pmd_pools_lock
  *			when dma_pmd_pool_create() calls dma_pmd_meta_init().
+ *			The only reverse edge on dma_pmd_pools_lock is the
+ *			shrinker's mutex_trylock(), which cannot block.
  *
  * dma_pmd_pools_lock	Mutex over the list of live pools. Outermost of the
  *			three, and it must not be taken from a context that
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


