Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16C5FCCFA08
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCA498E011B; Tue,  4 Nov 2025 04:12:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53BC8E0118; Tue,  4 Nov 2025 04:12:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF4768E011B; Tue,  4 Nov 2025 04:12:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A34B68E0118
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:12:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D19D4A8F8
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:54 +0000 (UTC)
X-FDA: 84072359868.05.63BEF25
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5394F1C0007
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:12:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IoEHr2kf;
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHefQBwMy4hdQaTKpzvFhVoegjQMxAaZZyAuZBgl+nM=;
	b=pL6V+2PhM4HZVNDMj8roJUIzeZfXVw7WAP7M1UdDzO+nS6OGSj/n2eDfAsAitO094tulYB
	/8Nbl0g3NaLtPYozQTEFARJN2vMfCYbGChG7QBy2fujOJhNAiL1vjJL4IM5UkFg3cnALY0
	LAWaLlueWORibl4m26yri/vtEnr34HM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247572; a=rsa-sha256;
	cv=none;
	b=DNUqEX7tSGmQOiSvCVHMS+QBo8EZlZFxxxdnrjfNur5Mgnx4IEDfG0waFBqTcg0P2502jg
	VuNKD+8VRusLcbH2dxfgjcIg2g3rCgjeojPapsAzuF21HmAuqa8cD3MEXEO4uwvSmjkeF4
	3i1aiQpffiB9kd83Nt6HPggsX6SDmXc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IoEHr2kf;
	spf=pass (imf20.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247572; x=1793783572;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CGx/U0vtSIJXhMqgHVjiHFLqMg10OfO+a93jGXkStog=;
  b=IoEHr2kfcXY1JIStCQzZZ3jT4EJCLzw0yqbPjaGPKJ1rhI022ZQyhNUP
   sEQGuHlrnRoFylxkyBpd1XV+jrTc3IHWPwt1TWIVJh5ONGcyeiOgr98bV
   f1GNbGSTDMMGSRSSy4HH7R23W2jJdK9Gpft0WovqKANBkJt/CXaFU8Yv8
   EDwoLGFHI2kR7IC0Xo+do09aO09XoCQBgDAxwFrImJTIWN4QSJx3b84Z9
   q25o5OG3lZdrEOOH0K8iRgUaGPdBZ+oHW5ClWSuhK9/fXZwrhjd8PzMRi
   GdGSOH0h7rebSz2QA/+dAFZRcEip0Km3x0ep9Q5gE/jKwFtHdEJpypHF2
   g==;
X-CSE-ConnectionGUID: j0pYS42CQGqf7dmR/QTO4A==
X-CSE-MsgGUID: hCB9q8k0S4+y4nRBWEPBAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64265206"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64265206"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:39 -0800
X-CSE-ConnectionGUID: rgJsiR3WTDS7GG9+v26vaw==
X-CSE-MsgGUID: pbX/HAQ1Sk65r221zqyCMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795839"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:40 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	21cnbao@gmail.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	senozhatsky@chromium.org,
	sj@kernel.org,
	kasong@tencent.com,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v13 21/22] mm: zswap: zswap_store() will process a large folio in batches.
Date: Tue,  4 Nov 2025 01:12:34 -0800
Message-Id: <20251104091235.8793-22-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 5394F1C0007
X-Stat-Signature: t1crg4umhfhrdrqikg1mww9crk6aaggs
X-HE-Tag: 1762247572-405326
X-HE-Meta: U2FsdGVkX1+xuiEaRjUE5lR2tV+onV+p4FVG6lnDLBg9zJhNpH7pT3W8tstJJPO/RFR5ClpkbjhX2WwUO/XpWfLR9VQtGfeB+Ra3ZIln55bKllUs7SJRTQwQqZHGb0PkgtPoghKVsxKjWLXLCUo9fHLmEGbQR7gM9DmCL8OKxSvnNclFdq7kfe/5qMphZS0+Jg6mTh6Rntrql9x7/bRTtrzpxdiMoVCPgmxRYatt/0jgDSKyqIgcXvXMkt+l/5GzFyW238ir3H/9zENj6zgBROmA09MQc6V2IYSW4UrncBT+vTQKAafP/Ae3lDhPxfdMzs3Nu/4/jmS1qii/2XeaAs7Ufn8NgmkpaRZC++6XnD6F/T7nAlYfx0h775qp4SkxU98Bh0FXp1392x3O0PECtNKGkF/I+oQshGFdP0rVylu1Xl6cgPlEn54ueHbyPrAh5peouDeHG1zvS5hTlOAY9vN8lml/K/TladRRvwZ9S7Dy6JWuXBaXPv9rQTGUrljCg7m8RnvrEgk8AKW/o5tNrLryEb7laKnZk3Z7SQUB0wEJnM2lMO96eMDf0JVCAgyR+nEOzgERiGX5HrBwV4IFPj1vX2qODyz/McJWK/z8Lm3Vc7p2/igSIfHOqBDGM96h3g3IZsE+x/jZdINYDmTOtursQOKiA4mLVidVc2cHOGLiekpJs0kNsu7Vyy1VknAxB6/HVdHmGronv08CKLjwXiggc6EZ8lzOqZXnWaNZNd+yWkK4HH8LBDEmw5P/fQlNIixZthET4PtH17oSLnWFufK+hohw5wmyZHfZfWjyWU4Q2qSxmEBG4WFnTu/BNR0vpGbzeZeaOPKCUlnsdmN8fpnI/qFlOZjwcVf1zjzBC5WF6xsGZNshVxCSqVccL28OHJj/18cM2DC9E+epJ3qVmk6YGv7L90Tg36dUV2MhX4eG0GA08ChrksOekh5jiMmrKULrGKWop6hV00/5BPf
 wnmhSAGk
 ZAFia0gAg6Pqgg4GifEoPZVxuWW5Lky+7AqpiYasdKgePHINkZam93QkLGn8cZWRtBNDBbyx/fSz7SYSGRh6c+eClFJdgn2yxBFhRjL/+SsNMxs9Y6uKtD1GF/3GuEzU0ApIjfmrNaIQq/7OLC9IznmGYWTIXlkKk8r5dvLxHdJl8q0dAF9VjKq/Ut810H8AO1jRba25xOk5LuYwbErhShRwTd6NxrjpOgdumbM2DEfwG2Ogjy1Lfkp13iA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch makes two major changes:

First, we allocate pool batching resources if the compressor supports
batching:

  This patch sets up zswap for allocating per-CPU resources optimally
  for non-batching and batching compressors.

  A new ZSWAP_MAX_BATCH_SIZE constant is defined as 8U, to set an upper
  limit on the number of pages in large folios that will be batch
  compressed.

  It is up to the compressor to manage multiple requests, as needed, to
  accomplish batch parallelism. zswap only needs to allocate the per-CPU
  dst buffers according to the batch size supported by the compressor.

  A "u8 compr_batch_size" member is added to "struct zswap_pool", as per
  Yosry's suggestion. pool->compr_batch_size is set as the minimum of
  the compressor's max batch-size and ZSWAP_MAX_BATCH_SIZE. Accordingly,
  pool->compr_batch_size compression dst buffers are allocated in the
  per-CPU acomp_ctx.

  zswap does not use more than one dst buffer yet. Follow-up patches
  will actually utilize the multiple acomp_ctx buffers for batch
  compression/decompression of multiple pages.

  Thus, ZSWAP_MAX_BATCH_SIZE limits the amount of extra memory used for
  batching. There is a small extra memory overhead of allocating
  the acomp_ctx->buffers array for compressors that do not support
  batching: On x86_64, the overhead is 1 pointer per-CPU (i.e. 8 bytes).

Next, we store the folio in batches:

  This patch modifies zswap_store() to store a batch of pages in large
  folios at a time, instead of storing one page at a time. It does this by
  calling a new procedure zswap_store_pages() with a range of indices in
  the folio: for batching compressors, this range contains up to
  pool->compr_batch_size pages. For non-batching compressors, we send up
  to ZSWAP_MAX_BATCH_SIZE pages to be sequentially compressed and stored
  in zswap_store_pages().

  zswap_store_pages() implements all the computes done earlier in
  zswap_store_page() for a single-page, for multiple pages in a folio,
  namely the "batch":

  1) It starts by allocating all zswap entries required to store the
     batch. New procedures, zswap_entries_cache_alloc_batch() and
     zswap_entries_cache_free_batch() call kmem_cache_[free]alloc_bulk()
     to optimize the performance of this step.

  2) The entry doesn't have to be allocated on the same node as the page
     being stored in zswap: we let the slab allocator decide this in
     kmem_cache_alloc_bulk(). However, to make sure the current zswap
     LRU list/shrinker behavior is preserved, we store the folio's nid as
     a new @nid member in the entry to enable adding it to the correct
     LRU list (and deleting it from the right LRU list). This ensures
     that when the folio's allocating NUMA node is under memory
     pressure, the entries corresponding to its pages are written back.

     The memory footprint of struct zswap_entry remains unchanged at
     56 bytes with the addition of the "int nid" member by condensing
     "length" and "referenced" into 4 bytes using bit fields and using
     the 4 bytes available after "referenced" for the "int nid". Thanks
     to Nhat and Yosry for these suggestions!

  3) Next, the entries fields are written, computes that need to be happen
     anyway, without modifying the zswap xarray/LRU publishing order. This
     avoids bringing the entries into the cache for writing in different
     code blocks within this procedure, hence improves latency.

  4) Next, it calls zswap_compress() to sequentially compress each page in
     the batch.

  5) Finally, it adds the batch's zswap entries to the xarray and LRU,
     charges zswap memory and increments zswap stats.

  6) The error handling and cleanup required for all failure scenarios
     that can occur while storing a batch in zswap are consolidated to a
     single "store_pages_failed" label in zswap_store_pages(). Here again,
     we optimize performance by calling kmem_cache_free_bulk().

This commit also makes a minor optimization in zswap_compress(), that
takes a "bool wb_enabled" argument; computed once in zswap_store()
rather than for each page in the folio.

Suggested-by: Nhat Pham <nphamcs@gmail.com>
Suggested-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 336 ++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 232 insertions(+), 104 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index cb384eb7c815..257567edc587 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -82,6 +82,9 @@ static bool zswap_pool_reached_full;
 
 #define ZSWAP_PARAM_UNSET ""
 
+/* Limit the batch size to limit per-CPU memory usage for dst buffers. */
+#define ZSWAP_MAX_BATCH_SIZE 8U
+
 static int zswap_setup(void);
 
 /* Enable/disable zswap */
@@ -139,7 +142,7 @@ struct crypto_acomp_ctx {
 	struct crypto_acomp *acomp;
 	struct acomp_req *req;
 	struct crypto_wait wait;
-	u8 *buffer;
+	u8 **buffers;
 	struct mutex mutex;
 	bool is_sleepable;
 };
@@ -149,6 +152,9 @@ struct crypto_acomp_ctx {
  * The only case where lru_lock is not acquired while holding tree.lock is
  * when a zswap_entry is taken off the lru for writeback, in that case it
  * needs to be verified that it's still valid in the tree.
+ *
+ * @compr_batch_size: The max batch size of the compression algorithm,
+ *                    bounded by ZSWAP_MAX_BATCH_SIZE.
  */
 struct zswap_pool {
 	struct zs_pool *zs_pool;
@@ -158,6 +164,7 @@ struct zswap_pool {
 	struct work_struct release_work;
 	struct hlist_node node;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
+	u8 compr_batch_size;
 };
 
 /* Global LRU lists shared by all zswap pools. */
@@ -182,6 +189,7 @@ static struct shrinker *zswap_shrinker;
  *              writeback logic. The entry is only reclaimed by the writeback
  *              logic if referenced is unset. See comments in the shrinker
  *              section for context.
+ * nid - NUMA node id of the page for which this is the zswap entry.
  * pool - the zswap_pool the entry's data is in
  * handle - zsmalloc allocation handle that stores the compressed page data
  * objcg - the obj_cgroup that the compressed memory is charged to
@@ -189,8 +197,11 @@ static struct shrinker *zswap_shrinker;
  */
 struct zswap_entry {
 	swp_entry_t swpentry;
-	unsigned int length;
-	bool referenced;
+	struct {
+		unsigned int length:31;
+		bool referenced:1;
+	};
+	int nid;
 	struct zswap_pool *pool;
 	unsigned long handle;
 	struct obj_cgroup *objcg;
@@ -242,8 +253,10 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 **********************************/
 static void __zswap_pool_empty(struct percpu_ref *ref);
 
-static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
+static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx, u8 nr_buffers)
 {
+	u8 i;
+
 	if (IS_ERR_OR_NULL(acomp_ctx))
 		return;
 
@@ -253,7 +266,11 @@ static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
 	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
 		crypto_free_acomp(acomp_ctx->acomp);
 
-	kfree(acomp_ctx->buffer);
+	if (acomp_ctx->buffers) {
+		for (i = 0; i < nr_buffers; ++i)
+			kfree(acomp_ctx->buffers[i]);
+		kfree(acomp_ctx->buffers);
+	}
 }
 
 static struct zswap_pool *zswap_pool_create(char *compressor)
@@ -265,6 +282,7 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 	if (!zswap_has_pool && !strcmp(compressor, ZSWAP_PARAM_UNSET))
 		return NULL;
 
+	/* Many things rely on the zero-initialization. */
 	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool)
 		return NULL;
@@ -315,7 +333,9 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 
 	for_each_possible_cpu(cpu)
-		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
+		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
+				  pool->compr_batch_size);
+
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -353,7 +373,8 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 
 	for_each_possible_cpu(cpu)
-		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
+		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
+				  pool->compr_batch_size);
 
 	free_percpu(pool->acomp_ctx);
 
@@ -644,14 +665,8 @@ static inline struct mem_cgroup *mem_cgroup_from_entry(struct zswap_entry *entry
 }
 #endif
 
-static inline int entry_to_nid(struct zswap_entry *entry)
-{
-	return page_to_nid(virt_to_page(entry));
-}
-
 static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry *entry)
 {
-	int nid = entry_to_nid(entry);
 	struct mem_cgroup *memcg;
 
 	/*
@@ -668,19 +683,18 @@ static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry *entry)
 	rcu_read_lock();
 	memcg = mem_cgroup_from_entry(entry);
 	/* will always succeed */
-	list_lru_add(list_lru, &entry->lru, nid, memcg);
+	list_lru_add(list_lru, &entry->lru, entry->nid, memcg);
 	rcu_read_unlock();
 }
 
 static void zswap_lru_del(struct list_lru *list_lru, struct zswap_entry *entry)
 {
-	int nid = entry_to_nid(entry);
 	struct mem_cgroup *memcg;
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_entry(entry);
 	/* will always succeed */
-	list_lru_del(list_lru, &entry->lru, nid, memcg);
+	list_lru_del(list_lru, &entry->lru, entry->nid, memcg);
 	rcu_read_unlock();
 }
 
@@ -740,6 +754,29 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
 	kmem_cache_free(zswap_entry_cache, entry);
 }
 
+/*
+ * Returns 0 if kmem_cache_alloc_bulk() failed and a positive number otherwise.
+ * The code for __kmem_cache_alloc_bulk() indicates that this positive number
+ * will be the @size requested, i.e., @nr_entries.
+ */
+static __always_inline int zswap_entries_cache_alloc_batch(void **entries,
+							   unsigned int nr_entries,
+							   gfp_t gfp)
+{
+	int nr_alloc = kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
+					     nr_entries, entries);
+
+	WARN_ON(!nr_alloc || (nr_alloc != nr_entries));
+
+	return nr_alloc;
+}
+
+static __always_inline void zswap_entries_cache_free_batch(void **entries,
+							   unsigned int nr_entries)
+{
+	kmem_cache_free_bulk(zswap_entry_cache, nr_entries, entries);
+}
+
 /*
  * Carries out the common pattern of freeing an entry's zsmalloc allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
@@ -766,7 +803,9 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	int nid = cpu_to_node(cpu);
 	int ret = -ENOMEM;
+	u8 i;
 
 	/*
 	 * To handle cases where the CPU goes through online-offline-online
@@ -775,11 +814,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
 		return 0;
 
-	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
-	if (!acomp_ctx->buffer)
-		return ret;
-
-	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
+	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, nid);
 	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
 				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
@@ -788,20 +823,39 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	}
 	acomp_ctx->is_sleepable = acomp_is_async(acomp_ctx->acomp);
 
+	/*
+	 * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
+	 * compressor supports batching.
+	 */
+	pool->compr_batch_size = min(ZSWAP_MAX_BATCH_SIZE,
+				     crypto_acomp_batch_size(acomp_ctx->acomp));
+
 	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
+
 	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
 		goto fail;
 	}
 
-	crypto_init_wait(&acomp_ctx->wait);
+	acomp_ctx->buffers = kcalloc_node(pool->compr_batch_size, sizeof(u8 *),
+					  GFP_KERNEL, nid);
+	if (!acomp_ctx->buffers)
+		goto fail;
+
+	for (i = 0; i < pool->compr_batch_size; ++i) {
+		acomp_ctx->buffers[i] = kmalloc_node(PAGE_SIZE, GFP_KERNEL, nid);
+		if (!acomp_ctx->buffers[i])
+			goto fail;
+	}
 
 	/*
 	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
 	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
 	 * won't be called, crypto_wait_req() will return without blocking.
 	 */
+	crypto_init_wait(&acomp_ctx->wait);
+
 	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				   crypto_req_done, &acomp_ctx->wait);
 
@@ -811,12 +865,12 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	return 0;
 
 fail:
-	acomp_ctx_dealloc(acomp_ctx);
+	acomp_ctx_dealloc(acomp_ctx, pool->compr_batch_size);
 	return ret;
 }
 
 static bool zswap_compress(struct page *page, struct zswap_entry *entry,
-			   struct zswap_pool *pool)
+			   struct zswap_pool *pool, bool wb_enabled)
 {
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
@@ -830,7 +884,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
 	mutex_lock(&acomp_ctx->mutex);
 
-	dst = acomp_ctx->buffer;
+	dst = acomp_ctx->buffers[0];
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
 
@@ -860,8 +914,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * to the active LRU list in the case.
 	 */
 	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
-		if (!mem_cgroup_zswap_writeback_enabled(
-					folio_memcg(page_folio(page)))) {
+		if (!wb_enabled) {
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
 		}
@@ -906,7 +959,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
 	mutex_lock(&acomp_ctx->mutex);
-	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx->buffer);
+	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, acomp_ctx->buffers[0]);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
 	if (entry->length == PAGE_SIZE) {
@@ -916,15 +969,15 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 
 	/*
 	 * zs_obj_read_begin() might return a kmap address of highmem when
-	 * acomp_ctx->buffer is not used.  However, sg_init_one() does not
-	 * handle highmem addresses, so copy the object to acomp_ctx->buffer.
+	 * acomp_ctx->buffers[0] is not used.  However, sg_init_one() does not
+	 * handle highmem addresses, so copy the object to acomp_ctx->buffers[0].
 	 */
 	if (virt_addr_valid(obj)) {
 		src = obj;
 	} else {
-		WARN_ON_ONCE(obj == acomp_ctx->buffer);
-		memcpy(acomp_ctx->buffer, obj, entry->length);
-		src = acomp_ctx->buffer;
+		WARN_ON_ONCE(obj == acomp_ctx->buffers[0]);
+		memcpy(acomp_ctx->buffers[0], obj, entry->length);
+		src = acomp_ctx->buffers[0];
 	}
 
 	sg_init_one(&input, src, entry->length);
@@ -1378,95 +1431,156 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
-static bool zswap_store_page(struct page *page,
-			     struct obj_cgroup *objcg,
-			     struct zswap_pool *pool)
+/*
+ * Store multiple pages in @folio, starting from the page at index @start up to
+ * the page at index @end-1.
+ */
+static bool zswap_store_pages(struct folio *folio,
+			      long start,
+			      long end,
+			      struct obj_cgroup *objcg,
+			      struct zswap_pool *pool,
+			      int nid,
+			      bool wb_enabled)
 {
-	swp_entry_t page_swpentry = page_swap_entry(page);
-	struct zswap_entry *entry, *old;
-
-	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL, page_to_nid(page));
-	if (!entry) {
-		zswap_reject_kmemcache_fail++;
-		return false;
+	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
+	u8 i, store_fail_idx = 0, nr_pages = end - start;
+
+	VM_WARN_ON_ONCE(nr_pages > ZSWAP_MAX_BATCH_SIZE);
+
+	if (unlikely(!zswap_entries_cache_alloc_batch((void **)&entries[0],
+						      nr_pages, GFP_KERNEL))) {
+		for (i = 0; i < nr_pages; ++i) {
+			entries[i] = zswap_entry_cache_alloc(GFP_KERNEL, nid);
+
+			if (unlikely(!entries[i])) {
+				zswap_reject_kmemcache_fail++;
+				/*
+				 * While handling this error, we only need to
+				 * call zswap_entries_cache_free_batch() for
+				 * entries[0 .. @i-1].
+				 */
+				nr_pages = i;
+				goto store_pages_failed;
+			}
+		}
 	}
 
-	if (!zswap_compress(page, entry, pool))
-		goto compress_failed;
+	/*
+	 * We colocate entry initialization as much as possible here to
+	 * minimize potential cache misses.
+	 *
+	 * With kmem_cache_alloc_bulk(), the batch's entries will be created
+	 * on the NUMA node of the CPU on which zswap_store() is called, which
+	 * might not be the same as @nid, the NUMA node on which @folio was
+	 * allocated. In order for the @folio's entries to be written back when
+	 * @nid experiences memory pressure, we store @nid in @entry->nid.
+	 * This ensures that the entry is added to and deleted from the LRU
+	 * list of the correct node, namely @nid.
+	 */
+	for (i = 0; i < nr_pages; ++i) {
+		entries[i]->handle = (unsigned long)ERR_PTR(-EINVAL);
+		entries[i]->pool = pool;
+		entries[i]->swpentry = page_swap_entry(folio_page(folio, start + i));
+		entries[i]->objcg = objcg;
+		entries[i]->referenced = true;
+		entries[i]->nid = nid;
+		INIT_LIST_HEAD(&entries[i]->lru);
+	}
 
-	old = xa_store(swap_zswap_tree(page_swpentry),
-		       swp_offset(page_swpentry),
-		       entry, GFP_KERNEL);
-	if (xa_is_err(old)) {
-		int err = xa_err(old);
+	for (i = 0; i < nr_pages; ++i) {
+		struct page *page = folio_page(folio, start + i);
 
-		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
-		zswap_reject_alloc_fail++;
-		goto store_failed;
+		if (!zswap_compress(page, entries[i], pool, wb_enabled))
+			goto store_pages_failed;
 	}
 
-	/*
-	 * We may have had an existing entry that became stale when
-	 * the folio was redirtied and now the new version is being
-	 * swapped out. Get rid of the old.
-	 */
-	if (old)
-		zswap_entry_free(old);
+	for (i = 0; i < nr_pages; ++i) {
+		struct zswap_entry *old, *entry = entries[i];
 
-	/*
-	 * The entry is successfully compressed and stored in the tree, there is
-	 * no further possibility of failure. Grab refs to the pool and objcg,
-	 * charge zswap memory, and increment zswap_stored_pages.
-	 * The opposite actions will be performed by zswap_entry_free()
-	 * when the entry is removed from the tree.
-	 */
-	zswap_pool_get(pool);
-	if (objcg) {
-		obj_cgroup_get(objcg);
-		obj_cgroup_charge_zswap(objcg, entry->length);
-	}
-	atomic_long_inc(&zswap_stored_pages);
-	if (entry->length == PAGE_SIZE)
-		atomic_long_inc(&zswap_stored_incompressible_pages);
+		old = xa_store(swap_zswap_tree(entry->swpentry),
+			       swp_offset(entry->swpentry),
+			       entry, GFP_KERNEL);
+		if (unlikely(xa_is_err(old))) {
+			int err = xa_err(old);
 
-	/*
-	 * We finish initializing the entry while it's already in xarray.
-	 * This is safe because:
-	 *
-	 * 1. Concurrent stores and invalidations are excluded by folio lock.
-	 *
-	 * 2. Writeback is excluded by the entry not being on the LRU yet.
-	 *    The publishing order matters to prevent writeback from seeing
-	 *    an incoherent entry.
-	 */
-	entry->pool = pool;
-	entry->swpentry = page_swpentry;
-	entry->objcg = objcg;
-	entry->referenced = true;
-	if (entry->length) {
-		INIT_LIST_HEAD(&entry->lru);
-		zswap_lru_add(&zswap_list_lru, entry);
+			WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
+			zswap_reject_alloc_fail++;
+			/*
+			 * Entries up to this point have been stored in the
+			 * xarray. zswap_store() will erase them from the xarray
+			 * and call zswap_entry_free(). Local cleanup in
+			 * 'store_pages_failed' only needs to happen for
+			 * entries from [@i to @nr_pages).
+			 */
+			store_fail_idx = i;
+			goto store_pages_failed;
+		}
+
+		/*
+		 * We may have had an existing entry that became stale when
+		 * the folio was redirtied and now the new version is being
+		 * swapped out. Get rid of the old.
+		 */
+		if (unlikely(old))
+			zswap_entry_free(old);
+
+		/*
+		 * The entry is successfully compressed and stored in the tree,
+		 * and further failures will be cleaned up in zswap_store().
+		 * Grab refs to the pool and objcg, charge zswap memory, and
+		 * increment zswap_stored_pages. The opposite actions will be
+		 * performed by zswap_entry_free() when the entry is removed
+		 * from the tree.
+		 */
+		zswap_pool_get(pool);
+		if (objcg) {
+			obj_cgroup_get(objcg);
+			obj_cgroup_charge_zswap(objcg, entry->length);
+		}
+		atomic_long_inc(&zswap_stored_pages);
+		if (entry->length == PAGE_SIZE)
+			atomic_long_inc(&zswap_stored_incompressible_pages);
+
+		/*
+		 * We finish by adding the entry to the LRU while it's already
+		 * in xarray. This is safe because:
+		 *
+		 * 1. Concurrent stores and invalidations are excluded by folio lock.
+		 *
+		 * 2. Writeback is excluded by the entry not being on the LRU yet.
+		 *    The publishing order matters to prevent writeback from seeing
+		 *    an incoherent entry.
+		 */
+		if (likely(entry->length))
+			zswap_lru_add(&zswap_list_lru, entry);
 	}
 
 	return true;
 
-store_failed:
-	zs_free(pool->zs_pool, entry->handle);
-compress_failed:
-	zswap_entry_cache_free(entry);
+store_pages_failed:
+	for (i = store_fail_idx; i < nr_pages; ++i) {
+		if (!IS_ERR_VALUE(entries[i]->handle))
+			zs_free(pool->zs_pool, entries[i]->handle);
+	}
+	zswap_entries_cache_free_batch((void **)&entries[store_fail_idx],
+				       nr_pages - store_fail_idx);
+
 	return false;
 }
 
 bool zswap_store(struct folio *folio)
 {
+	bool wb_enabled = mem_cgroup_zswap_writeback_enabled(folio_memcg(folio));
 	long nr_pages = folio_nr_pages(folio);
 	swp_entry_t swp = folio->swap;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
+	int nid = folio_nid(folio);
 	struct zswap_pool *pool;
+	u8 store_batch_size;
 	bool ret = false;
-	long index;
+	long start, end;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1500,10 +1614,24 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
-	for (index = 0; index < nr_pages; ++index) {
-		struct page *page = folio_page(folio, index);
+	/*
+	 * For batching compressors, store the folio in batches of the
+	 * compressor's batch_size.
+	 *
+	 * For non-batching compressors, store the folio in batches
+	 * of ZSWAP_MAX_BATCH_SIZE, where each page in the batch is
+	 * compressed sequentially. This gives better performance than
+	 * invoking zswap_store_pages() per-page, due to cache locality
+	 * of working set structures.
+	 */
+	store_batch_size = (pool->compr_batch_size > 1) ?
+				pool->compr_batch_size : ZSWAP_MAX_BATCH_SIZE;
+
+	for (start = 0; start < nr_pages; start += store_batch_size) {
+		end = min(start + store_batch_size, nr_pages);
 
-		if (!zswap_store_page(page, objcg, pool))
+		if (!zswap_store_pages(folio, start, end, objcg, pool,
+				       nid, wb_enabled))
 			goto put_pool;
 	}
 
@@ -1533,9 +1661,9 @@ bool zswap_store(struct folio *folio)
 		struct zswap_entry *entry;
 		struct xarray *tree;
 
-		for (index = 0; index < nr_pages; ++index) {
-			tree = swap_zswap_tree(swp_entry(type, offset + index));
-			entry = xa_erase(tree, offset + index);
+		for (start = 0; start < nr_pages; ++start) {
+			tree = swap_zswap_tree(swp_entry(type, offset + start));
+			entry = xa_erase(tree, offset + start);
 			if (entry)
 				zswap_entry_free(entry);
 		}
-- 
2.27.0


