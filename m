Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72516C79F87
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 13:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BC666B0092; Fri,  4 Sep 2026 09:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7D36B0095; Fri,  4 Sep 2026 09:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E6D26B0096; Fri,  4 Sep 2026 09:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC95B6B0092
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:25:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 695B41612C3
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:25:18 +0000 (UTC)
X-FDA: 85176151116.07.002D73B
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9DF9C1C0007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:25:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="oc/WX4wR";
	spf=pass (imf21.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788528316;
	b=iSaOJoteIzUDwPFyigIwacRDdEA6Fq/1oWTCOFJAcg1VDEoS6JhFrpd/6wU9kfc6tehGTl
	5HRGNvLba3IeqtN35EfEa3+AKZSuLrhaZDI1hpRhdqRl/uSePc1qfre67JE+jAdI2bD0if
	zmIolsh1Embw805FL24RnfOhoYnhxXM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="oc/WX4wR";
	spf=pass (imf21.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788528316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8g/AFfc0xixTGDqDEvYMQWCEZQ1RAhdG9wVvkvsQsWo=;
	b=pYLCcxz/e4dkMDvXmC34ElK8aN2KFodEXAGIQbSjXDx5I9CPTbmx4L/HD+Yzqt4aZOwxLv
	tYRNMfCyaZ2B6N1tS8xIAomoj/aY7uRzoIGkn69fKdypHX8M77ZBjLepcSwk+6+IoqtSXY
	/97NHNg2VELAPj4YiGBBSlYYYXkC//8=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-853f8c34ba4so1226749b3a.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 06:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788528315; x=1789133115; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8g/AFfc0xixTGDqDEvYMQWCEZQ1RAhdG9wVvkvsQsWo=;
        b=oc/WX4wRi4APOxhnyPc4TJwncqysGyz1YOzHvsSewt6BFV8FyEkfqbVzwM6QSloWhx
         gnIQhIYyuXV7NY0MwClQbrHqx028QWF0L/Jbw8qPVY6GZS9VrD3id4elMM4kXi8AhxR1
         zx4oIHr6lvk79RzP305DgS8pYvU82u1A3BkL5ZPfAn997CDebcftRV6abMAv1aDVs6Jh
         X6vgC2l1tc8OEjOTxguG5dtboM6eiRGfAFDovy4FWdZoL2iUHrq5ID07Z7+znFyw3bQB
         0ZdQkRjxHGCq898uD5gIRyZqlj4O5mQS4Y5KVZjUvDST8fxTXN0kFOlufsMavmxpmt2l
         lzFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788528315; x=1789133115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8g/AFfc0xixTGDqDEvYMQWCEZQ1RAhdG9wVvkvsQsWo=;
        b=MH04/fdzHHxiJ/dEce9qHtL6JDZowe4vhK3+h1PpRNSmPCnkNWONyh34HJGhQ1LMYP
         ztoY3rQyRCSOgcWnlFN2IA/7ejAbIqqSwI9qTUnqEuZExbmvDzUrfhr4A8rNRSfaAisC
         6lUYHUBYB6Bx9vf86d0oyutiITKiFg5rk7vHFhjk4+QUPir6OeXLFxiESFx0PMkHP7ms
         ZzMPWQd+aalsNOaYOdOUk/ncDFvj8ZS1EQ9yJLBmH5qYxTbBTtheTbtVEGaaETeU4TRF
         ++52zC24cHhnuAqVq3zEWRXmW4QSONDdd8HtB4rCVtUjspAtMTY2msUy8rAM/MBGH0QU
         JYig==
X-Forwarded-Encrypted: i=1; AKwUvBx9uBXXisaUo3gpLgCigTYqERnEul0KwmgBKhMQOEKPIMqDuK98m8cFIzbz0BNJNfpny5TF2Bc9eA==@kvack.org
X-Gm-Message-State: AFuF++koAb+iOJVdIGYxNH0xSbSE7YwjEN2TE+Avi5amkYiUXa6UnEx+
	S6y/TegvsCMJS4YSwn7kUerS0csV8jKAWJI+fzuI2PfXVPNVU4vVXdaP
X-Gm-Gg: AYBFou2L5eS2amh9wgTb/StrX+pFAj+/YBPZp/2UcgUdMzIsEFBye5jxb07aPgSfXlL
	lAnymolbRfoocFfG6Oyv3VvWrfFs/jnDEwJWHRAYmqffj0wSxUCLTTs9Yf6FWNk9G6+cY1jd0rZ
	4kHZ8avO66lhQWoadWvt4w8nrpmrnlVJm8Us7cxBGNzAfnIiGdTb5zDnYAZSe49rV8Y4TFx4o7J
	TAeAgrA2HUVReyBFMxrAhVXXb4LWAkddbfhS8YIwaa6e7AhttM/bDLwGkGL9jMwlPHEmLCQKFnL
	tWC/fhV9NPscgh/+3KHTPwh9MUt8bw+jFUfnh1qhbLciTmfBvP9fgudTVs9+g74UH9nHLIQIxnZ
	62lsPywA9Upo1fb3FSjBHgHrSmJLegxRHs42UTpFmC6wqjsZVrqwCcFRQFx94AXW/q2Zb9sgMWt
	ARfBnMlBPStXxCWdm/7Q+8hxGCtrdvu8wDuIn2E8a2e2WZxq8FiXUm+7yVaFFjE/8Ze0lbE1KjB
	OJkFFEC0V+sU/3IZqj8NDNQ1TTarVS9jVCQ2eIL1I0/Kfzl
X-Received: by 2002:aa7:88c3:0:b0:848:4424:2b8e with SMTP id d2e1a72fcca58-861696788b3mr7866901b3a.3.1788528315173;
        Fri, 04 Sep 2026 06:25:15 -0700 (PDT)
Received: from NV-J4GCB44.nvidia.com ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152c2a52asm1147302b3a.30.2026.09.04.06.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 06:25:14 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/3] mm/zswap: replace the zswap_pools list with an allocating xarray
Date: Fri,  4 Sep 2026 21:24:55 +0800
Message-ID: <22625ed4915936814f766092e9d7ac6637c5b2f4.1788528216.git.wujianyue000@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788528216.git.wujianyue000@gmail.com>
References: <20260830114731.8322-1-wujianyue000@gmail.com> <cover.1788528216.git.wujianyue000@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9DF9C1C0007
X-Stat-Signature: md46hj5xgz1swbp96b9apanh7xnhuqia
X-HE-Tag: 1788528316-45937
X-HE-Meta: U2FsdGVkX1823Aqm0J8wFeaUBYkCRbXFGFFNU2HpCoTQNQ2ul3JScP/0iPcIGXQTSuhER6kjjjZNqnRcljASvR0jTbIvanNYH/+c2aujr0rjZnO2ShUGi+SvyNsXZZqKSErnvuNUjspy8tL0N8b09dyaV9XcAlpkOEN8MnD48hdFenE2vEjh5qzA2/cHRMSi8RPe12+hBQ3cUFrGS0ZfDRJBTQ5/E/8adzD04e8zCvhLDWqC6h6ZeTiJDquPEAmKMkR9DYRf5auu/4bjDE6Tdch3a3mNvb9OPJf3VXsBuff87aAEp9m1KgUm91RK+1A8cKj+vVMY87PUzonQE+XZbuUBXpB7aTmiNS1CVvm40xjNs7J/1VZCYF+S4dscSubZrRyt3AfKBObNXuUcFr6AwhpdS4wZtJFR9vWDEqD04nDa+U9OXRnUcm461wQvjKy9AiQcrUeByIRIYphwiXJRWa32H2adoU/V4772jEiJPAz7XqOreA5zmXaWE2hHdnW1+SkBCZ8HoabykrgJJl4j1SmkWjl5gJIiVXBz7mVldmUlI3l6t5PPZoazaRTBRO0RBOjgw/mLvc2lkMVFUren4TtX2d6ofYtRWhgvt2HJ+ANDHpC/dm39GOxyqmtfAa6AbFsLeJ/9t0dRl65Kad4wPOZP5WB85NdEEprZC73rotgpqEc8+qqUyZuPSh6m+xelJ1miofJRz44EvatsvSNHnYx/1umlBEogfkLOCLbxMXvzxT3Q+eUkHJmmt4yuRFKH+Q2lHxCl1Fv4srChDgstAqeSNMSfcUsdgoQOrkKoXJxNAGMijJ2oev8MVf5VFatTMSQXLer4FJDflo5+VhmuA44TmLyLZtrl9DVB4RMJE6T5pJ0y8Ti/knxCbYbIsbIyWnBhejj7Yn9mxULszOD7Jic/NWCj0O2vLFifI1yvZQ7ns2B7smWwPD5QC5Mbh9uFzbkHrOEKQEIsPLZV9nl
 UpSFjg4e
 la7vaLLtnsDUT4mIpT7CycGUs76O76STUoRpOtJ8WuKBg+cucnAsktZLZOLmogSRZNN6sBF0oLXw6mH+9H/j0bvJTbSQByOs7yzxCDRAF1y5XAFEnoHd0WRD4fK3r8ctEA+qMFeu7BoIxNacbyMUgqnODyWEiZAB3i+w5WnXbh5wCKdraD1zYJeKXpBBDu4RHXwZMklXiz51dwjkmpPHKRbdzUf3wHTwPrWy+Hd9rFESiYb/6x1Df5y7S1p5PNouoY0nZulalj+4W0NDMm5fsXfJG7Lr9KUVxooWLS/jsIovlJAUizu2aQHm+UVSYcaNIJkXF6NLimuAwoVte/VGlAQayEG9O0/OU8nxzkcBag8P8q53XZ+ZsPJ5tMiiiP2r6H770U4vFDKNWPdH536nA2uLrg0VQ2k6VnPn4DbYMsVk+LEAy4xcXbCh7fqF3f42rhcNGpBzQ8t9CU4jZisiotY+bXj0IDzxPizivgY8sZ7eamfS940fwA1uU1MyUpl6EQ35bhigm6Q4JzN+6gpmSK2rNdhqTgHZRrRUyeBL6qCetQcin3Vgjm5g7azKI/tcVTKB3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Originally zswap keeps its pools on an RCU list whose head also serves
as the current pool. Convert the pool table to an allocating xarray
keyed by a small integer id, and track the current pool with a separate
RCU-protected pointer.

The xarray gives each pool a stable id for a later zswap_entry shrink.
XA_FLAGS_ALLOC1 starts ids at 1, so id 0 remains reserved. The id range
is bounded by ZSWAP_MAX_POOL_ID because the later entry field is a u8.

Keep compressor switching close to the previous flow: look up an
existing pool under xa_lock, resurrect it outside the lock if reused, or
create a new one. zswap_pool_create() allocates the pool's id and
publishes it into the xarray as its final step, so the create call is
itself atomic: it either fully builds the pool and publishes it, or
unwinds completely on failure. Publishing makes the pool live, so a
caller that later fails (e.g. param_set_charp()) must still kill the
pool to erase it from the xarray. Runtime compressor parameter updates
are serialized by the module parameter lock, so no speculative loser
path is needed.

A retiring pool is erased from the xarray in __zswap_pool_empty() and
freed via queue_rcu_work(), preserving the old RCU teardown ordering.

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 mm/zswap.c | 87 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 33 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index e456e5080531..74876acfa9dc 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -34,6 +34,7 @@
 #include <linux/writeback.h>
 #include <linux/pagemap.h>
 #include <linux/workqueue.h>
+#include <linux/xarray.h>
 #include <linux/list_lru.h>
 #include <linux/zsmalloc.h>
 
@@ -154,12 +155,24 @@ struct zswap_pool {
 	struct zs_pool *zs_pool;
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct percpu_ref ref;
-	struct list_head list;
 	struct rcu_work release_rwork;
 	struct hlist_node node;
+	u8 idx;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
 
+/*
+ * Live pools keyed by id (1..ZSWAP_MAX_POOL_ID).  XA_FLAGS_ALLOC1 keeps
+ * the reserved id 0 unallocated, so looking it up never aliases a live
+ * pool.  XA_FLAGS_LOCK_BH makes the xa_lock softirq-safe: it is taken
+ * from __zswap_pool_empty(), which runs from a percpu_ref release
+ * callback in softirq context.
+ */
+#define ZSWAP_FIRST_POOL_ID 1
+#define ZSWAP_MAX_POOL_ID U8_MAX
+static DEFINE_XARRAY_FLAGS(zswap_pools, XA_FLAGS_ALLOC1 | XA_FLAGS_LOCK_BH);
+static struct zswap_pool __rcu *zswap_current_pool;
+
 /* Global LRU lists shared by all zswap pools. */
 static struct list_lru zswap_list_lru;
 
@@ -200,10 +213,6 @@ struct zswap_entry {
 static struct xarray *zswap_trees[MAX_SWAPFILES];
 static unsigned int nr_zswap_trees[MAX_SWAPFILES];
 
-/* RCU-protected iteration */
-static LIST_HEAD(zswap_pools);
-/* protects zswap_pools list modification */
-static DEFINE_SPINLOCK(zswap_pools_lock);
 /* pool counter to provide unique names to zsmalloc */
 static atomic_t zswap_pools_count = ATOMIC_INIT(0);
 
@@ -275,6 +284,7 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 	struct zswap_pool *pool;
 	char name[38]; /* 'zswap' + 32 char (max) num + \0 */
 	int ret, cpu;
+	u32 id;
 
 	if (!zswap_has_pool && !strcmp(compressor, ZSWAP_PARAM_UNSET))
 		return NULL;
@@ -320,12 +330,24 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 			      PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
 	if (ret)
 		goto ref_fail;
-	INIT_LIST_HEAD(&pool->list);
+
+	ret = xa_alloc_bh(&zswap_pools, &id, pool,
+			  XA_LIMIT(ZSWAP_FIRST_POOL_ID, ZSWAP_MAX_POOL_ID),
+			  GFP_KERNEL);
+	if (ret) {
+		if (ret == -EBUSY)
+			pr_err("cannot allocate pool id (max %d live pools)\n",
+			       ZSWAP_MAX_POOL_ID - ZSWAP_FIRST_POOL_ID + 1);
+		goto xa_fail;
+	}
+	pool->idx = id;
 
 	zswap_pool_debug("created", pool);
 
 	return pool;
 
+xa_fail:
+	percpu_ref_exit(&pool->ref);
 ref_fail:
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 
@@ -386,7 +408,7 @@ static void __zswap_pool_release(struct work_struct *work)
 	WARN_ON(!percpu_ref_is_zero(&pool->ref));
 	percpu_ref_exit(&pool->ref);
 
-	/* pool is now off zswap_pools list and has no references. */
+	/* The pool is no longer in zswap_pools and has no references. */
 	zswap_pool_destroy(pool);
 }
 
@@ -398,16 +420,16 @@ static void __zswap_pool_empty(struct percpu_ref *ref)
 
 	pool = container_of(ref, typeof(*pool), ref);
 
-	spin_lock_bh(&zswap_pools_lock);
+	xa_lock_bh(&zswap_pools);
 
 	WARN_ON(pool == zswap_pool_current());
 
-	list_del_rcu(&pool->list);
+	__xa_erase(&zswap_pools, pool->idx);
 
 	INIT_RCU_WORK(&pool->release_rwork, __zswap_pool_release);
 	queue_rcu_work(system_percpu_wq, &pool->release_rwork);
 
-	spin_unlock_bh(&zswap_pools_lock);
+	xa_unlock_bh(&zswap_pools);
 }
 
 static int __must_check zswap_pool_tryget(struct zswap_pool *pool)
@@ -433,7 +455,8 @@ static struct zswap_pool *__zswap_pool_current(void)
 {
 	struct zswap_pool *pool;
 
-	pool = list_first_or_null_rcu(&zswap_pools, typeof(*pool), list);
+	pool = rcu_dereference_check(zswap_current_pool,
+				     lockdep_is_held(&zswap_pools.xa_lock));
 	WARN_ONCE(!pool && zswap_has_pool,
 		  "%s: no page storage pool!\n", __func__);
 
@@ -442,7 +465,7 @@ static struct zswap_pool *__zswap_pool_current(void)
 
 static struct zswap_pool *zswap_pool_current(void)
 {
-	assert_spin_locked(&zswap_pools_lock);
+	lockdep_assert_held(&zswap_pools.xa_lock);
 
 	return __zswap_pool_current();
 }
@@ -462,14 +485,15 @@ static struct zswap_pool *zswap_pool_current_get(void)
 	return pool;
 }
 
-/* type and compressor must be null-terminated */
+/* compressor must be null-terminated */
 static struct zswap_pool *zswap_pool_find_get(char *compressor)
 {
 	struct zswap_pool *pool;
+	unsigned long id;
 
-	assert_spin_locked(&zswap_pools_lock);
+	lockdep_assert_held(&zswap_pools.xa_lock);
 
-	list_for_each_entry_rcu(pool, &zswap_pools, list) {
+	xa_for_each(&zswap_pools, id, pool) {
 		if (strcmp(pool->tfm_name, compressor))
 			continue;
 		/* if we can't get it, it's about to be destroyed */
@@ -495,9 +519,15 @@ unsigned long zswap_total_pages(void)
 {
 	struct zswap_pool *pool;
 	unsigned long total = 0;
+	unsigned long id;
 
+	/*
+	 * rcu_read_lock() is required here, not just for xa_for_each(): it also
+	 * keeps each pool alive while it is dereferenced, since a concurrently
+	 * retired pool is freed via queue_rcu_work() after a grace period.
+	 */
 	rcu_read_lock();
-	list_for_each_entry_rcu(pool, &zswap_pools, list)
+	xa_for_each(&zswap_pools, id, pool)
 		total += zs_get_total_pages(pool->zs_pool);
 	rcu_read_unlock();
 
@@ -554,20 +584,17 @@ static int zswap_compressor_param_set(const char *val, const struct kernel_param
 		return -ENOENT;
 	}
 
-	spin_lock_bh(&zswap_pools_lock);
-
+	xa_lock_bh(&zswap_pools);
 	pool = zswap_pool_find_get(s);
 	if (pool) {
 		zswap_pool_debug("using existing", pool);
 		WARN_ON(pool == zswap_pool_current());
-		list_del_rcu(&pool->list);
 	}
+	xa_unlock_bh(&zswap_pools);
 
-	spin_unlock_bh(&zswap_pools_lock);
-
-	if (!pool)
+	if (!pool) {
 		pool = zswap_pool_create(s);
-	else {
+	} else {
 		/*
 		 * Restore the initial ref dropped by percpu_ref_kill()
 		 * when the pool was decommissioned and switch it again
@@ -584,23 +611,17 @@ static int zswap_compressor_param_set(const char *val, const struct kernel_param
 	else
 		ret = -EINVAL;
 
-	spin_lock_bh(&zswap_pools_lock);
+	xa_lock_bh(&zswap_pools);
 
 	if (!ret) {
 		put_pool = zswap_pool_current();
-		list_add_rcu(&pool->list, &zswap_pools);
+		rcu_assign_pointer(zswap_current_pool, pool);
 		zswap_has_pool = true;
 	} else if (pool) {
-		/*
-		 * Add the possibly pre-existing pool to the end of the pools
-		 * list; if it's new (and empty) then it'll be removed and
-		 * destroyed by the put after we drop the lock
-		 */
-		list_add_tail_rcu(&pool->list, &zswap_pools);
 		put_pool = pool;
 	}
 
-	spin_unlock_bh(&zswap_pools_lock);
+	xa_unlock_bh(&zswap_pools);
 
 	/*
 	 * Drop the ref from either the old current pool,
@@ -1788,7 +1809,7 @@ static int zswap_setup(void)
 	pool = __zswap_pool_create_fallback();
 	if (pool) {
 		pr_info("loaded using pool %s\n", pool->tfm_name);
-		list_add(&pool->list, &zswap_pools);
+		rcu_assign_pointer(zswap_current_pool, pool);
 		zswap_has_pool = true;
 		static_branch_enable(&zswap_ever_enabled);
 	} else {
-- 
2.43.0


