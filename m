Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B627CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AED16B008A; Thu, 28 May 2026 05:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55FED6B008C; Thu, 28 May 2026 05:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E166B0092; Thu, 28 May 2026 05:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 322566B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:34:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE8F612050C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:34:53 +0000 (UTC)
X-FDA: 84816319266.26.24E8635
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0FBE31C0004
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:34:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UdwJSlwG;
	spf=none (imf21.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779960892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xIEmh9cJuZ7QDznvu36mC2c+m1LHMnAwVRG0Zaa/+UI=;
	b=KR1HGGoN3OHqkVKJ0zrC5mPEFL34FqT5gNCVggWkYmZ8a9Nti8rcFO70KlWLEdt0OZlKSs
	ttUK7dt7AUq0yWs8HUxhoSfa4nFnI27JEiElLFvOkbDJT9LYUOglloqS7wUKwetuXV5t5S
	hUoEb8ePz+H+XQ2SiVy8E8I2cGJuePk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=UdwJSlwG;
	spf=none (imf21.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779960892; a=rsa-sha256;
	cv=none;
	b=FQIys9n/EosNNzNVrTgHPnXNWOixhlujQ10FMAFNd/AQL9hqMMVOTKc1TZNr4LcG7z+WAt
	DBgr2+/lxtH/XfLijh9KMSwMwmkhYgqKEIiLB6SsheMHD9DB8YHvfJTg+VtgRoJo6HnLvD
	m4gM8x8NYWgew1eiwU8EaiSupnQY+9E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xIEmh9cJuZ7QDznvu36mC2c+m1LHMnAwVRG0Zaa/+UI=; b=UdwJSlwGYXHY0aNdOlFLgU8+A3
	Vm9NuAUu1g95X50e49OXca/tWP7AJOY2H8+9U6UnhXgKz2p9bHm0oHf80trs0gK15Yvzk4GTjcOHM
	9Rc9lH5m976sbim6KrNgYwKtTMKFDTr5Z3dIhVNjBogQcVCZjSTZCCfiY0lkj0xcKsknUd/IRZM74
	N6khPYl8NimmXOG46IYzL/mvgKko/JrLdmoCVuA8ROO9Lv0JH4uISFs8JuEwqqqtOTfYgr95+pWBU
	Tp2BN8XGiuZxuUEtzNDo2oqj71V8S/muNgLwVgaAA0Lz7WHywwSs+tVUFPn5oslaC8+s5gNbEPIKk
	ADWFom2g==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSX8b-00000005WEM-0evp;
	Thu, 28 May 2026 09:34:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	io-uring@vger.kernel.org,
	kasan-dev@googlegroups.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
Date: Thu, 28 May 2026 11:34:32 +0200
Message-ID: <20260528093437.2519248-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260528093437.2519248-1-hch@lst.de>
References: <20260528093437.2519248-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0FBE31C0004
X-Stat-Signature: nun9t54fdk8asi6wa773ja3gdcxn4tx7
X-HE-Tag: 1779960891-757446
X-HE-Meta: U2FsdGVkX1/q3edawXGACuJdzN9LcWuVQj44qDQzDiTZwFUDMms4B0CchnOZ0q6qkrlDVIAgG9trbdpzFB+caygiY4FjZeVWOW8uZv0B3kMixHFTvDZucw1D9BKfp37CJ55Zkf2UjhPrWmSIlOlvceRHYdFqJ0U8Hm5T0lrBike+J7atfSHBbdHkYFBCtDK0whNDxWj5vHXxljjP/roi/bKpwjfd2DDKlr8fRrapqXJWFG9EA0w0vNIH0G/M5qfxv/993U9Bws93Lh0/JOSiMgeBkvEPHxELZTqQWsQ90nJOu6U0qOiAynIGd5YIBZbemwu9VK11N2SMkMHn44S18Nuv4A+6PfZppD5ZAhoG4HSXX0Yq4UEaahjvPmRzE3fLh+n4NY6AuRc2eNxJr7DSgdNNuvu033YHH/kznMm7VoIxeSTLCJsyzNjZod5tMk+C9vadGHa1ENd8N7COMFaWu3YfvY/lBVJCgBSR1tJeNEQrovfmblKegN1fb5uf4JwEiaDYGyoHUXTIR/xR9xss8rv5lNQ9UqZudT61cXQH5YmGYWMTvJm+T8eghBCljh85rx4Ri8ZDfzWfSBhdVu/7yRHxbMW87sqcObbbMgKo1jYvpdg9MEXcFHMBPUR7tIeiQpfJWhxhR8pD0twsJ/PhUd/ra7AQB0Z7JC5ei2NkQ5x2QQlRODzt8/z5GgAgfwojuSzMuUBXIET/nM78WZxgNU8WozRqJyvbQG//Q1h9R3xDBahtRFnS/XCSdEGVY1zm+p/cMm32+4upi6uYDPv18xCBCllPBZP5jC6Sw2+imB86xVrNEV7sIWcyOMburU2nyqT+ZOlgNUyiEbQI0ENd9dDlWsUCzyqN0mitE+0sNzVyyICq26jQq5IvE+nRo2iFeOmLfex8zoxHnqq9320k1Y0qkoH0/z6s8dLRVRWijNrid4xZCIgH1Dcy9PV9CCb0EDURV/jhzv/DgEH2Wck
 P581jxB6
 Vx2PIxPfwpmeLiYCV8xa+yPfksCsRbnpU/Nu7mfdWRxC+1ymkJ06c8uRnY1nQXHxJ/sF/sHzQa3uWxCsRfhdERkHDrVc4jzFA82radj/T5s8bc3BO/eqMJDIu+7NqjTWovdHNaCoLQPhUEN81ocj5qip6sqjhXgr3j0GqGnQ4Oy6ipc4SmSUyNEVbDabo2vUJHqsZe7z6X6aR4WcwimyAOrBg2KMfQfCibXL852+pRTjofNLhhFyxJkOt1k/8H1s92rniFWDpegFBV1tRpY2vo7wqSE/tPVlm53MKoTsKU5lcnG2uD2s6csUIV1QVrYXRqyk1NaSZela5p3n4NWJoVgePjTkBWyFJ/wRZCrsrtWSpyUPianiK7Y8oXVVzjOZvMMANDLS0cdm1u4HrEPPH9Z5DWF6hIEChbjldRyAXVvDyPa/kQ2qg40vRwgrCDClM3zGW5EwHa31Mw/S30N2Ly0tU5DJH/W4VMHqkR92zrsh4iQ+0jKqMdyCCyX7edfmJAEixYmLsMfqj0keeUbem1Q+nrc5pk0LUAA6niKKmMvkgBdR2Hi8+wJvhuuvtio70K6ZikxSqQdiV7I0dHwX1qYOYVixoHwoDlDMl1Tyy8da4k9nn2Xac9bv8JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kmem_cache_alloc_bulk return value is weird.  It returns the number
of allocated objects, but that must always be 0 or the requested number
based on the implementations and the handling in the callers, but that
assumption is not actually documented anywhere, which confuses automated
review tools.

Fix this by returning a bool if the allocation succeeded and adding a
kerneldoc comment explaining the API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com> # skbuff
---
 drivers/gpu/drm/msm/msm_iommu.c       |  6 +--
 drivers/gpu/drm/panthor/panthor_mmu.c | 13 +++---
 include/linux/slab.h                  |  6 ++-
 io_uring/io_uring.c                   | 23 ++++-------
 lib/test_meminit.c                    | 23 +++++------
 mm/kasan/kasan_test_c.c               |  5 +--
 mm/kfence/kfence_test.c               |  9 ++--
 mm/slub.c                             | 59 +++++++++++++++------------
 net/bpf/test_run.c                    |  7 ++--
 net/core/skbuff.c                     | 24 ++++++-----
 tools/include/linux/slab.h            |  2 +-
 tools/testing/shared/linux.c          | 19 ++++-----
 12 files changed, 97 insertions(+), 99 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iommu.c
index 058c71c82cf5..533104d71f6c 100644
--- a/drivers/gpu/drm/msm/msm_iommu.c
+++ b/drivers/gpu/drm/msm/msm_iommu.c
@@ -330,17 +330,15 @@ static int
 msm_iommu_pagetable_prealloc_allocate(struct msm_mmu *mmu, struct msm_mmu_prealloc *p)
 {
 	struct kmem_cache *pt_cache = get_pt_cache(mmu);
-	int ret;
 
 	p->pages = kvmalloc_objs(*p->pages, p->count);
 	if (!p->pages)
 		return -ENOMEM;
 
-	ret = kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, p->count, p->pages);
-	if (ret != p->count) {
+	if (!kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, p->count, p->pages)) {
 		kfree(p->pages);
 		p->pages = NULL;
-		p->count = ret;
+		p->count = 0;
 		return -ENOMEM;
 	}
 
diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index 75d98dad7b1d..b12c641af46c 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -1274,13 +1274,13 @@ static int panthor_vm_prepare_map_op_ctx(struct panthor_vm_op_ctx *op_ctx,
 		goto err_cleanup;
 	}
 
-	ret = kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, pt_count,
-				    op_ctx->rsvd_page_tables.pages);
-	op_ctx->rsvd_page_tables.count = ret;
-	if (ret != pt_count) {
+	if (!kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, pt_count,
+			op_ctx->rsvd_page_tables.pages)) {
+		op_ctx->rsvd_page_tables.count = 0;
 		ret = -ENOMEM;
 		goto err_cleanup;
 	}
+	op_ctx->rsvd_page_tables.count = pt_count;
 
 	/* Insert BO into the extobj list last, when we know nothing can fail. */
 	dma_resv_lock(panthor_vm_resv(vm), NULL);
@@ -1328,9 +1328,8 @@ static int panthor_vm_prepare_unmap_op_ctx(struct panthor_vm_op_ctx *op_ctx,
 			goto err_cleanup;
 		}
 
-		ret = kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, pt_count,
-					    op_ctx->rsvd_page_tables.pages);
-		if (ret != pt_count) {
+		if (!kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, pt_count,
+				op_ctx->rsvd_page_tables.pages)) {
 			ret = -ENOMEM;
 			goto err_cleanup;
 		}
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 2b5ab488e96b..6a7b452d43a0 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -815,8 +815,10 @@ kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
  */
 void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p);
 
-int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size, void **p);
-#define kmem_cache_alloc_bulk(...)	alloc_hooks(kmem_cache_alloc_bulk_noprof(__VA_ARGS__))
+bool kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags,
+		size_t size, void **p);
+#define kmem_cache_alloc_bulk(...) \
+	alloc_hooks(kmem_cache_alloc_bulk_noprof(__VA_ARGS__))
 
 static __always_inline void kfree_bulk(size_t size, void **p)
 {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 103b6c88f252..bf847ca823f7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -978,29 +978,24 @@ __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 {
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO;
 	void *reqs[IO_REQ_ALLOC_BATCH];
-	int ret;
-
-	ret = kmem_cache_alloc_bulk(req_cachep, gfp, ARRAY_SIZE(reqs), reqs);
+	int nr_reqs = ARRAY_SIZE(reqs);
 
 	/*
-	 * Bulk alloc is all-or-nothing. If we fail to get a batch,
-	 * retry single alloc to be on the safe side.
+	 * Bulk alloc is all-or-nothing. If we fail to get a batch, retry a
+	 * single allocation to be on the safe side.
 	 */
-	if (unlikely(ret <= 0)) {
+	if (!kmem_cache_alloc_bulk(req_cachep, gfp, nr_reqs, reqs)) {
 		reqs[0] = kmem_cache_alloc(req_cachep, gfp);
 		if (!reqs[0])
 			return false;
-		ret = 1;
+		nr_reqs = 1;
 	}
 
-	percpu_ref_get_many(&ctx->refs, ret);
-	ctx->nr_req_allocated += ret;
-
-	while (ret--) {
-		struct io_kiocb *req = reqs[ret];
+	percpu_ref_get_many(&ctx->refs, nr_reqs);
+	ctx->nr_req_allocated += nr_reqs;
 
-		io_req_add_to_cache(req, ctx);
-	}
+	while (nr_reqs--)
+		io_req_add_to_cache(reqs[nr_reqs], ctx);
 	return true;
 }
 
diff --git a/lib/test_meminit.c b/lib/test_meminit.c
index d028a6552cd6..68c3b9da090e 100644
--- a/lib/test_meminit.c
+++ b/lib/test_meminit.c
@@ -229,16 +229,14 @@ static int __init do_kmem_cache_size(size_t size, bool want_ctor,
 	for (iter = 0; iter < 10; iter++) {
 		/* Do a test of bulk allocations */
 		if (!want_rcu && !want_ctor) {
-			int ret;
-
-			ret = kmem_cache_alloc_bulk(c, alloc_mask, BULK_SIZE, bulk_array);
-			if (!ret) {
+			if (!kmem_cache_alloc_bulk(c, alloc_mask, BULK_SIZE,
+					bulk_array)) {
 				fail = true;
 			} else {
 				int i;
-				for (i = 0; i < ret; i++)
+				for (i = 0; i < BULK_SIZE; i++)
 					fail |= check_buf(bulk_array[i], size, want_ctor, want_rcu, want_zero);
-				kmem_cache_free_bulk(c, ret, bulk_array);
+				kmem_cache_free_bulk(c, BULK_SIZE, bulk_array);
 			}
 		}
 
@@ -348,23 +346,24 @@ static int __init do_kmem_cache_size_bulk(int size, int *total_failures)
 {
 	struct kmem_cache *c;
 	int i, iter, maxiter = 1024;
-	int num, bytes;
+	int bytes;
 	bool fail = false;
 	void *objects[10];
 
 	c = kmem_cache_create("test_cache", size, size, 0, NULL);
 	for (iter = 0; (iter < maxiter) && !fail; iter++) {
-		num = kmem_cache_alloc_bulk(c, GFP_KERNEL, ARRAY_SIZE(objects),
-					    objects);
-		for (i = 0; i < num; i++) {
+		if (!kmem_cache_alloc_bulk(c, GFP_KERNEL, ARRAY_SIZE(objects),
+				objects))
+			continue;
+
+		for (i = 0; i < ARRAY_SIZE(objects); i++) {
 			bytes = count_nonzero_bytes(objects[i], size);
 			if (bytes)
 				fail = true;
 			fill_with_garbage(objects[i], size);
 		}
 
-		if (num)
-			kmem_cache_free_bulk(c, num, objects);
+		kmem_cache_free_bulk(c, ARRAY_SIZE(objects), objects);
 	}
 	kmem_cache_destroy(c);
 	*total_failures += fail;
diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index 3f4ed29178b3..b9e167ed5be3 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -1225,14 +1225,13 @@ static void kmem_cache_bulk(struct kunit *test)
 	struct kmem_cache *cache;
 	size_t size = 200;
 	char *p[10];
-	bool ret;
 	int i;
 
 	cache = kmem_cache_create("test_cache", size, 0, 0, NULL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
 
-	ret = kmem_cache_alloc_bulk(cache, GFP_KERNEL, ARRAY_SIZE(p), (void **)&p);
-	if (!ret) {
+	if (!kmem_cache_alloc_bulk(cache, GFP_KERNEL, ARRAY_SIZE(p),
+			(void **)&p)) {
 		kunit_err(test, "Allocation failed: %s\n", __func__);
 		kmem_cache_destroy(cache);
 		return;
diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index 10424cd25e5a..c472e66e7242 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -761,9 +761,10 @@ static void test_memcache_alloc_bulk(struct kunit *test)
 	timeout = jiffies + msecs_to_jiffies(100 * kfence_sample_interval);
 	do {
 		void *objects[100];
-		int i, num = kmem_cache_alloc_bulk(test_cache, GFP_ATOMIC, ARRAY_SIZE(objects),
-						   objects);
-		if (!num)
+		int i;
+
+		if (!kmem_cache_alloc_bulk(test_cache, GFP_ATOMIC,
+				ARRAY_SIZE(objects), objects))
 			continue;
 		for (i = 0; i < ARRAY_SIZE(objects); i++) {
 			if (is_kfence_address(objects[i])) {
@@ -771,7 +772,7 @@ static void test_memcache_alloc_bulk(struct kunit *test)
 				break;
 			}
 		}
-		kmem_cache_free_bulk(test_cache, num, objects);
+		kmem_cache_free_bulk(test_cache, ARRAY_SIZE(objects), objects);
 		/*
 		 * kmem_cache_alloc_bulk() disables interrupts, and calling it
 		 * in a tight loop may not give KFENCE a chance to switch the
diff --git a/mm/slub.c b/mm/slub.c
index a2bf3756ca7d..57b2af707e95 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4981,8 +4981,8 @@ static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
 	return ret;
 }
 
-static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
-				   size_t size, void **p);
+static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
+		size_t size, void **p);
 
 /*
  * returns a sheaf that has at least the requested size
@@ -5154,9 +5154,8 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
 			return __prefill_sheaf_pfmemalloc(s, sheaf, gfp);
 
 		if (!__kmem_cache_alloc_bulk(s, gfp, sheaf->capacity - sheaf->size,
-					     &sheaf->objects[sheaf->size])) {
+					     &sheaf->objects[sheaf->size]))
 			return -ENOMEM;
-		}
 		sheaf->size = sheaf->capacity;
 
 		return 0;
@@ -7289,9 +7288,8 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 	return refilled;
 }
 
-static inline
-int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
-			    void **p)
+static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
+		size_t size, void **p)
 {
 	int i;
 
@@ -7312,30 +7310,43 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 		stat_add(s, ALLOC_SLOWPATH, i);
 	}
 
-	return i;
+	return true;
 
 error:
 	__kmem_cache_free_bulk(s, i, p);
-	return 0;
-
+	return false;
 }
 
-/*
- * Note that interrupts must be enabled when calling this function and gfp
- * flags must allow spinning.
+/**
+ * kmem_cache_alloc_bulk - Allocate multiple objects
+ * @s:		The cache to allocate from
+ * @flags:	GFP_* flags. See kmalloc().
+ * @size:	Number of objects to allocate
+ * @p:		Array of allocated objects
+ *
+ * Allocate @size objects from @s and places them into @p.  @size must be larger
+ * than 0.
+ *
+ * Interrupts must be enabled when calling this function and @flags must allow
+ * spinning.
+ *
+ * Unlike alloc_pages_bulk(), this function does not check for already allocated
+ * objects in @p, and thus the caller does not need to zero it.
+ *
+ * Return: %true if the allocation succeeded, or %false if it failed.
  */
-int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
-				 void **p)
+bool kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags,
+		size_t size, void **p)
 {
 	unsigned int i = 0;
 	void *kfence_obj;
 
 	if (!size)
-		return 0;
+		return false;
 
 	s = slab_pre_alloc_hook(s, flags);
 	if (unlikely(!s))
-		return 0;
+		return false;
 
 	/*
 	 * to make things simpler, only assume at most once kfence allocated
@@ -7352,18 +7363,18 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
 	}
 
 	i = alloc_from_pcs_bulk(s, flags, size, p);
-
 	if (i < size) {
 		/*
 		 * If we ran out of memory, don't bother with freeing back to
 		 * the percpu sheaves, we have bigger problems.
 		 */
-		if (unlikely(__kmem_cache_alloc_bulk(s, flags, size - i, p + i) == 0)) {
+		if (unlikely(!__kmem_cache_alloc_bulk(s, flags, size - i,
+				p + i))) {
 			if (i > 0)
 				__kmem_cache_free_bulk(s, i, p);
 			if (kfence_obj)
 				__kfence_free(kfence_obj);
-			return 0;
+			return false;
 		}
 	}
 
@@ -7382,12 +7393,8 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
 	 * memcg and kmem_cache debug support and memory initialization.
 	 * Done outside of the IRQ disabled fastpath loop.
 	 */
-	if (unlikely(!slab_post_alloc_hook(s, NULL, flags, size, p,
-		    slab_want_init_on_alloc(flags, s), s->object_size))) {
-		return 0;
-	}
-
-	return size;
+	return likely(slab_post_alloc_hook(s, NULL, flags, size, p,
+			slab_want_init_on_alloc(flags, s), s->object_size));
 }
 EXPORT_SYMBOL(kmem_cache_alloc_bulk_noprof);
 
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2bc04feadfab..99ab9ddb05e3 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -243,12 +243,11 @@ static int xdp_recv_frames(struct xdp_frame **frames, int nframes,
 			   struct net_device *dev)
 {
 	gfp_t gfp = __GFP_ZERO | GFP_ATOMIC;
-	int i, n;
+	int i;
 	LIST_HEAD(list);
 
-	n = kmem_cache_alloc_bulk(net_hotdata.skbuff_cache, gfp, nframes,
-				  (void **)skbs);
-	if (unlikely(n == 0)) {
+	if (!kmem_cache_alloc_bulk(net_hotdata.skbuff_cache, gfp, nframes,
+				   (void **)skbs)) {
 		for (i = 0; i < nframes; i++)
 			xdp_return_frame(frames[i]);
 		return -ENOMEM;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 44ac121cfccb..73045b688385 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -288,11 +288,11 @@ static inline struct sk_buff *napi_skb_cache_get(bool alloc)
 
 	local_lock_nested_bh(&napi_alloc_cache.bh_lock);
 	if (unlikely(!nc->skb_count)) {
-		if (alloc)
-			nc->skb_count = kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
-						GFP_ATOMIC | __GFP_NOWARN,
-						NAPI_SKB_CACHE_BULK,
-						nc->skb_cache);
+		if (alloc && kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
+						   GFP_ATOMIC | __GFP_NOWARN,
+						   NAPI_SKB_CACHE_BULK,
+						   nc->skb_cache))
+			nc->skb_count = NAPI_SKB_CACHE_BULK;
 		if (unlikely(!nc->skb_count)) {
 			local_unlock_nested_bh(&napi_alloc_cache.bh_lock);
 			return NULL;
@@ -353,16 +353,18 @@ u32 napi_skb_cache_get_bulk(void **skbs, u32 n)
 
 	/* No enough cached skbs. Try refilling the cache first */
 	bulk = min(NAPI_SKB_CACHE_SIZE - nc->skb_count, NAPI_SKB_CACHE_BULK);
-	nc->skb_count += kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
-					       GFP_ATOMIC | __GFP_NOWARN, bulk,
-					       &nc->skb_cache[nc->skb_count]);
+	if (kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
+				  GFP_ATOMIC | __GFP_NOWARN, bulk,
+				  &nc->skb_cache[nc->skb_count]))
+		nc->skb_count += bulk;
 	if (likely(nc->skb_count >= n))
 		goto get;
 
 	/* Still not enough. Bulk-allocate the missing part directly, zeroed */
-	n -= kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
-				   GFP_ATOMIC | __GFP_ZERO | __GFP_NOWARN,
-				   n - nc->skb_count, &skbs[nc->skb_count]);
+	if (kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
+				  GFP_ATOMIC | __GFP_ZERO | __GFP_NOWARN,
+				  n - nc->skb_count, &skbs[nc->skb_count]))
+		n = nc->skb_count;
 	if (likely(nc->skb_count >= n))
 		goto get;
 
diff --git a/tools/include/linux/slab.h b/tools/include/linux/slab.h
index 6d8e9413d5a4..2e63c2e726aa 100644
--- a/tools/include/linux/slab.h
+++ b/tools/include/linux/slab.h
@@ -183,7 +183,7 @@ __kmem_cache_create(const char *name, unsigned int size, unsigned int align,
 		default: __kmem_cache_create)(__name, __object_size, __args, __VA_ARGS__)
 
 void kmem_cache_free_bulk(struct kmem_cache *cachep, size_t size, void **list);
-int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
+bool kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
 			  void **list);
 struct slab_sheaf *
 kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size);
diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
index 8c7257155958..e9c3bc9b3272 100644
--- a/tools/testing/shared/linux.c
+++ b/tools/testing/shared/linux.c
@@ -154,7 +154,7 @@ void kmem_cache_shrink(struct kmem_cache *cachep)
 {
 }
 
-int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
+bool kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
 			  void **p)
 {
 	size_t i;
@@ -213,7 +213,7 @@ int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
 		pthread_mutex_unlock(&cachep->lock);
 		if (cachep->callback)
 			cachep->exec_callback = true;
-		return 0;
+		return false;
 	}
 
 	for (i = 0; i < size; i++) {
@@ -224,7 +224,7 @@ int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
 			printf("Allocating %p from slab\n", p[i]);
 	}
 
-	return size;
+	return true;
 }
 
 struct kmem_cache *
@@ -271,8 +271,8 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 
 	sheaf->cache = s;
 	sheaf->capacity = capacity;
-	sheaf->size = kmem_cache_alloc_bulk(s, gfp, size, sheaf->objects);
-	if (!sheaf->size) {
+	sheaf->size = size;
+	if (!kmem_cache_alloc_bulk(s, gfp, size, sheaf->objects)) {
 		free(sheaf);
 		return NULL;
 	}
@@ -284,7 +284,6 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
 		 struct slab_sheaf **sheafp, unsigned int size)
 {
 	struct slab_sheaf *sheaf = *sheafp;
-	int refill;
 
 	if (sheaf->size >= size)
 		return 0;
@@ -299,12 +298,10 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
 		return 0;
 	}
 
-	refill = kmem_cache_alloc_bulk(s, gfp, size - sheaf->size,
-				       &sheaf->objects[sheaf->size]);
-	if (!refill)
+	if (!kmem_cache_alloc_bulk(s, gfp, size - sheaf->size,
+			&sheaf->objects[sheaf->size]))
 		return -ENOMEM;
-
-	sheaf->size += refill;
+	sheaf->size += (size - sheaf->size);
 	return 0;
 }
 
-- 
2.53.0


