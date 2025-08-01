Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D318DC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64B66B00AF; Fri,  1 Aug 2025 00:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A132B6B00B1; Fri,  1 Aug 2025 00:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DBA66B00B0; Fri,  1 Aug 2025 00:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 74D496B00AF
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:37:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 469BFC0F1A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:37:04 +0000 (UTC)
X-FDA: 83726928768.12.A78FBA0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id 398E4140002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:37:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G7NV5cgQ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754023022; a=rsa-sha256;
	cv=none;
	b=c8CwUFRDJpmSQDl+5LfxIJ4pLEVzAf+n7JCLSrST5l9A3wFWP+vx0iTad7UcoKtrXmR1VS
	Vfr9VYtQT/ceUuWKuIexTSYtevsTuQn/vH/EWkz56dPy9A+ZWHOwzNUqtBTGD230o0lgd+
	qkf9qkDtZszuzftxcRsSrkNCgWDcknU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G7NV5cgQ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754023022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ru7Qnw5lImv8zQ/UYPgF5a0cuzp26iuROwDncxtv44c=;
	b=GZclV5GZ0GiyQllKnFOPsVGcPR7V/tGyB1e7sFpo9vQ7NEqyWi0JDYTeSaCXJsMbVDdBTR
	Tphj/hoqcw7u+QmKjN1FngkdYVMufx2zCznVWezqQjLkygji/Md/9RZj2hhKAYwzP9lV7j
	WyCJdX0Y/fGAGXFf3ilbU17rEqR1qS4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023022; x=1785559022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jil+A0E/m2UFmjaChcPPdJdtHRi4WRZpw0YMt+8QL7E=;
  b=G7NV5cgQnMZqG+RDjY7IxgYBpxC2tYfpw73zdYLRgEVM2SpRFZisGmXj
   zCBTPd7/2BHbWcOR0hgMXf6f33kAYSQ6/cH4sDC5J+zXrPmiEu5/nadFS
   KAqF6EwZpdgpA/8jS+xJERa9HqrK4VZRch4Y+zUBzTtSZMeHfzZqJ7T5N
   fifVt3hQJqugj79ZiMa/LAAITpC12kkjt4kSyqHc11BkOgwYgFLfGmrdj
   Ls81cV059J+j0nCFD2ZryZ5hQvJ6fA3VXx5wSSzD9lmMZKxZEPX8fGPnj
   lhHA72hrDLQgshuVdA5p6FsqqgP6UB3WyXVbK/3FyvdA3C3J42nIQIW8p
   Q==;
X-CSE-ConnectionGUID: k+QyNSQNSoipHIbhcTmbcA==
X-CSE-MsgGUID: XXUELKE6SnKNAeZxqek9sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820433"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820433"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:47 -0700
X-CSE-ConnectionGUID: undxc/RuQGqPeYESUj16Kg==
X-CSE-MsgGUID: U4gn3gXHRz6IxpcWkGnwjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796312"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:46 -0700
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
Subject: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if the compressor supports batching.
Date: Thu, 31 Jul 2025 21:36:40 -0700
Message-Id: <20250801043642.8103-23-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 398E4140002
X-Stat-Signature: w33t1zmu8yu7947b41etpsy86tctqku9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754023022-656806
X-HE-Meta: U2FsdGVkX1+/rNC8sRXfhsHjckR/VQaVbUYkDwZ9HCg2GwY7h9vTab/0PFIHw2gPlGIr3Skl3N4OtFDNj/BtfzNgPnuNUrNNLzfpFLFVCpv5KgH5LqjtRggZ19ZYGCjuqIVOXEHE0cvUWktXEJtQaP2xl1h9yC/4VSoAYtt82qEdT3EJv3VyPcHYPXAfC8jDM34Q/gmWanh/j7IY8ggBBWz3mEnkYshri02JUsF+9q5V0IC1s0Cu2Ga7D7AvzDlO9yky2ettCWN6Zu7pBEZOefrGx1pbkUmyuG+wrWN1A/9XESAN2Sam0xc0Z9nB8ekD01gjwUI4mT3wVljmncn4X5tN2MSnWsfbjQMb46y6eFksGsKhmcWMU5zi2W6XW8OCox900bxA3o3DH5xPN1QMjFE/ERpsLXfMniF09i/4ihkK4ETNuP9vR124RxfKcHHsefPLDKCPJ3v6I31yvmG+RwckdETeov/if+wWDCcXaq9t04K9e1hunkenCnnelA+KSOxy2y9THsMy7JSSVcXRP1KOUbFU8hFF/zdXmu/yGQ0yRjyCrBM0lDp7euGrtDnvJ+e/Qt3T+FrmHr/Z3daCDwL+FBq2DYetkgtVF+PhpDJo6IFtXx1GamduJBUFwKtEa9rRME1oT06g8gaYZo1BIdXwfiqdfURJQoMp423A+oATccN+cP6AqiTpIStvyTcSyrOukt7FXVga2iHWD254ObrJwH9lMfRlzCjWFI+d4QMju+9GFd4HeH3HFcEZGcb0hqTL88TNNGZB/oG5hktbrbWfL6TPSgxIBsfHM7hSQs8TIAAnQlYRUKM0/XZJ5PA8q2ovvKRqO/GIZJcS6g2VeY1Z5TmUGnn/YiySf4iPTcLYXj96mt6wHDSnLHA7wAbZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch sets up zswap for allocating per-CPU resources optimally for
non-batching and batching compressors.

A new ZSWAP_MAX_BATCH_SIZE constant is defined as 8U, to set an upper
limit on the number of pages in large folios that will be batch
compressed.

As per Herbert's comments in [2] in response to the
crypto_acomp_batch_compress() and crypto_acomp_batch_decompress() API
proposed in [1], this series does not create new crypto_acomp batching
API. Instead, zswap compression batching uses the existing
crypto_acomp_compress() API in combination with the "void *kernel_data"
member added to "struct acomp_req" earlier in this series.

It is up to the compressor to manage multiple requests, as needed, to
accomplish batch parallelism. zswap only needs to allocate the per-CPU
dst buffers according to the batch size supported by the compressor.

A "u8 compr_batch_size" member is added to "struct zswap_pool", as per
Yosry's suggestion. pool->compr_batch_size is set as the minimum of the
compressor's max batch-size and ZSWAP_MAX_BATCH_SIZE. Accordingly, it
proceeds to allocate the necessary compression dst buffers in the
per-CPU acomp_ctx.

Another "u8 batch_size" member is added to "struct zswap_pool" to store
the unit for batching large folio stores: for batching compressors, this
is the pool->compr_batch_size. For non-batching compressors, this is
ZSWAP_MAX_BATCH_SIZE.

zswap does not use more than one dst buffer yet. Follow-up patches will
actually utilize the multiple acomp_ctx buffers for batch
compression/decompression of multiple pages.

Thus, ZSWAP_MAX_BATCH_SIZE limits the amount of extra memory used for
batching. There is a small extra memory overhead of allocating
the acomp_ctx->buffers array for compressors that do not support
batching: On x86_64, the overhead is 1 pointer per-CPU (i.e. 8 bytes).

[1]: https://patchwork.kernel.org/project/linux-mm/patch/20250508194134.28392-11-kanchana.p.sridhar@intel.com/
[2]: https://patchwork.kernel.org/comment/26382610

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 82 +++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 63 insertions(+), 19 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index efd501a7fe294..63a997b999537 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -80,6 +80,9 @@ static bool zswap_pool_reached_full;
 
 #define ZSWAP_PARAM_UNSET ""
 
+/* Limit the batch size to limit per-CPU memory usage for dst buffers. */
+#define ZSWAP_MAX_BATCH_SIZE 8U
+
 static int zswap_setup(void);
 
 /* Enable/disable zswap */
@@ -147,7 +150,7 @@ struct crypto_acomp_ctx {
 	struct crypto_acomp *acomp;
 	struct acomp_req *req;
 	struct crypto_wait wait;
-	u8 *buffer;
+	u8 **buffers;
 	struct mutex mutex;
 	bool is_sleepable;
 };
@@ -166,6 +169,8 @@ struct zswap_pool {
 	struct work_struct release_work;
 	struct hlist_node node;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
+	u8 compr_batch_size;
+	u8 batch_size;
 };
 
 /* Global LRU lists shared by all zswap pools. */
@@ -258,8 +263,10 @@ static void __zswap_pool_empty(struct percpu_ref *ref);
  *   zswap_cpu_comp_prepare(), not others.
  * - Cleanup acomp_ctx resources on all cores in zswap_pool_destroy().
  */
-static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
+static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx, u8 nr_buffers)
 {
+	u8 i;
+
 	if (IS_ERR_OR_NULL(acomp_ctx))
 		return;
 
@@ -269,7 +276,11 @@ static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
 	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
 		crypto_free_acomp(acomp_ctx->acomp);
 
-	kfree(acomp_ctx->buffer);
+	if (acomp_ctx->buffers) {
+		for (i = 0; i < nr_buffers; ++i)
+			kfree(acomp_ctx->buffers[i]);
+		kfree(acomp_ctx->buffers);
+	}
 }
 
 static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
@@ -290,6 +301,7 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 			return NULL;
 	}
 
+	/* Many things rely on the zero-initialization. */
 	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool)
 		return NULL;
@@ -352,13 +364,28 @@ static struct zswap_pool *zswap_pool_create(char *type, char *compressor)
 		goto ref_fail;
 	INIT_LIST_HEAD(&pool->list);
 
+	/*
+	 * Set the unit of compress batching for large folios, for quick
+	 * retrieval in the zswap_compress() fast path:
+	 * If the compressor is sequential (@pool->compr_batch_size is 1),
+	 * large folios will be compressed in batches of ZSWAP_MAX_BATCH_SIZE
+	 * pages, where each page in the batch is compressed sequentially.
+	 * We see better performance by processing the folio in batches of
+	 * ZSWAP_MAX_BATCH_SIZE, due to cache locality of working set
+	 * structures.
+	 */
+	pool->batch_size = (pool->compr_batch_size > 1) ?
+				pool->compr_batch_size : ZSWAP_MAX_BATCH_SIZE;
+
 	zswap_pool_debug("created", pool);
 
 	return pool;
 
 ref_fail:
 	for_each_possible_cpu(cpu)
-		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
+		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
+				  pool->compr_batch_size);
+
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -417,7 +444,8 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
 	zswap_pool_debug("destroying", pool);
 
 	for_each_possible_cpu(cpu)
-		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
+		acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
+				  pool->compr_batch_size);
 
 	free_percpu(pool->acomp_ctx);
 
@@ -876,6 +904,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
 	int ret = -ENOMEM;
+	u8 i;
 
 	/*
 	 * The per-CPU pool->acomp_ctx is zero-initialized on allocation.
@@ -888,10 +917,6 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
 		return 0;
 
-	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
-	if (!acomp_ctx->buffer)
-		return ret;
-
 	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %ld\n",
@@ -904,17 +929,36 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
 	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
-		       pool->tfm_name);
+			pool->tfm_name);
 		goto fail;
 	}
 
-	crypto_init_wait(&acomp_ctx->wait);
+	/*
+	 * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
+	 * compressor supports batching.
+	 */
+	pool->compr_batch_size = min(ZSWAP_MAX_BATCH_SIZE,
+				     crypto_acomp_batch_size(acomp_ctx->acomp));
+
+	acomp_ctx->buffers = kcalloc_node(pool->compr_batch_size, sizeof(u8 *),
+					  GFP_KERNEL, cpu_to_node(cpu));
+	if (!acomp_ctx->buffers)
+		goto fail;
+
+	for (i = 0; i < pool->compr_batch_size; ++i) {
+		acomp_ctx->buffers[i] = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL,
+						     cpu_to_node(cpu));
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
 
@@ -922,7 +966,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	return 0;
 
 fail:
-	acomp_ctx_dealloc(acomp_ctx);
+	acomp_ctx_dealloc(acomp_ctx, pool->compr_batch_size);
 	return ret;
 }
 
@@ -942,7 +986,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 
 	mutex_lock(&acomp_ctx->mutex);
 
-	dst = acomp_ctx->buffer;
+	dst = acomp_ctx->buffers[0];
 	sg_init_table(&input, 1);
 	sg_set_page(&input, page, PAGE_SIZE, 0);
 
@@ -1003,19 +1047,19 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 
 	acomp_ctx = raw_cpu_ptr(entry->pool->acomp_ctx);
 	mutex_lock(&acomp_ctx->mutex);
-	obj = zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buffer);
+	obj = zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buffers[0]);
 
 	/*
 	 * zpool_obj_read_begin() might return a kmap address of highmem when
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
-- 
2.27.0


