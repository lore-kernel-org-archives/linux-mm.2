Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05AFFE63C85
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 03:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FC606B00BB; Sat, 24 Jan 2026 22:36:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1E66B00BD; Sat, 24 Jan 2026 22:36:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA5076B00BE; Sat, 24 Jan 2026 22:36:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AAF846B00BB
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:36:19 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 834831B01AC
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:36:19 +0000 (UTC)
X-FDA: 84369073278.17.23F634C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4E57B140009
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 03:36:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fBym1pSW;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769312177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V0xShF4zMBWGtIZzZPXtiFbIMIRr7YwzeqEKkvEdbrY=;
	b=Rv9uh0aYRJ1yBYR/gK5UE+N5V//la+oZEv6NFDXt2WUydhnw9sC1+0UtKA29kgguN9R4Wl
	9a0MR7IqzUUC5s11b/LrRcQ4hN2VKT+AawH6v7U8KH6JPK0KGnbOK97Xybu9sly/9sQQxs
	CI3PU08jJO3gbHFhSLStbFSgOweb+do=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fBym1pSW;
	spf=pass (imf23.hostedemail.com: domain of kanchana.p.sridhar@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=kanchana.p.sridhar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769312177; a=rsa-sha256;
	cv=none;
	b=rxylm0raRkt6wWua1BF1z+QQiMDeg/T1L3xi3Y02+4+FgOWF98FhJQjtRogbT6DcJ+cJb6
	238RW/UQPVOcdXa5lZ77utlyXhtVmw9U2SI8EQwJGAVy8jNmOlaPWsej0nvhIbCd6AAHw6
	NZLSa0I9b/ZjvvgiZO8/Ijn5ej7iXCo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312177; x=1800848177;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SBYo3eWzm2DgFOUa9jg9+Vu0sRN6wfJ9qYhqs4GDFvg=;
  b=fBym1pSWxTDVhyQ3+fhyWm3vdcf+tAdOaDorUvnqwDldws1fQZR3SuDm
   5kr8gvjP/CYEHMJgslv4AgpnxWX6ZHP75/qJOojP+f95GU2cSXPMiDBkX
   P667LsG8FvpBx3oOMvcluruazVJyqfraFRR4agFGSOMH51WTgvEmAYsN5
   J71GxrSyqnOvTrBKsMP1CYu1yip4UOPO2pe3KkRbGbfcdTwxUXpG0SpDB
   MS4pHU5zeMm4+rgav7rQAwPPQ7UeWDiHDBreDvscxjz4pEaeFV1w8bPx6
   KfkacrYyTclAETanf2pXE2uSXYV2WJdBAObLFPFW6WFPGB90jX9OeEDGi
   g==;
X-CSE-ConnectionGUID: PrWfeEgvRm2/M99/KQ+Ifg==
X-CSE-MsgGUID: 5wLjOZ/zQuydcyZ1tpIwsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887697"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887697"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:36:16 -0800
X-CSE-ConnectionGUID: uZ7SjqwJTAW6jyLUBGmkeA==
X-CSE-MsgGUID: jfpYRUoKS9OpT+uurvY7Sw==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:36:15 -0800
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
	vinicius.gomes@intel.com,
	giovanni.cabiddu@intel.com
Cc: wajdi.k.feghali@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for compress batching of large folios.
Date: Sat, 24 Jan 2026 19:35:37 -0800
Message-Id: <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4E57B140009
X-Stat-Signature: 35uipuaayepuynqzrangio4qxf9cp3qt
X-Rspam-User: 
X-HE-Tag: 1769312177-662617
X-HE-Meta: U2FsdGVkX1/OBCvYMKA3lSYn8IV0vPKoyS8ZYZaOOynzSjBIkrdq68PvS5UTjoLp9JpSeOO9V4oc9BIZs67Kr4SRs+FAmtoDroIHpFXKm8V2+dwqDcNJGypsQunDXoQ+5ZoYGJhgWtxG24oFNW7beu7p5DV0Pyca6l7ZpsAao6jC7eDnu3846CB3pkaiDOZkTBsHr7dsivX6yWx0S5whmETCPHVU6JK7PJQKUuSck+/hVdMabPmBGYYcqoZ8wukkuuVfc7BVBJkoU+LLlxKC3SWaTtUxPI7jCQyMyTmNhqs1/t+gSAs9TMyrXfQcWlK9IQPElGAII4vpUWbEwmnRQsT+KMgummkn3PRL4NtLFrSizIh+B9hIhEY5ad8tjMis4pkge8yS2yBZVQB6SpN3gBQ9iviR7kC0XIsnDlT2DyXlG2R+J8ehpYk/hIYLWd3IuSorLbQQPB4AMTUC1tAHkUG2fg38MsqQ2Jlygb9f/wfEus6eaxXR5jNMQrtjhA27N6YOznL9Esjg8iNsUwQhC4P+1zHfCtHGLzjgbrnvLQB5GWkRrCPa3kvKtuPq9GKsdceMPtGpbOZGlL10Kq2IfDQAbZYlUdVi3x8anQYv7NltaAwLKemw5xylx0G7m8bcYTbPAejBz2cEjsflu0iYPb1dtxVlJJnNTQjWR4V8TomXL/4zbhEt5EeMuKl/RwRlZnAzj7CCMaQNhZvAAhHJiMdF8ggpjMKv1qRFrJblOh8evQPePsHjlY+DZX5DZ70n4tm4vaRi43q5Q19SeShJO5xXu7kneUxuvcapcmeajInN69DfNuX3LsrKp18pVw+XmOT+jKt6brjMRwoOrnXRIkGSOa1N/mRCn8NYyuhQhRCYZl4h6QUnNCNBT8buYk40g/UPpuaOf133KLdzwNvcVJN52jPXbzxE/BBRYfkvvPBykNI47lMWqJs0giL9ZpxExGA+Vrg+qfVdqUfHyHp
 HbJFhpFp
 dlJhVfmE9zuXumat3xH4PVAOZET2fHBILYpuBNg2GjdMVwVP3WIL4lcplOQk/qzLfuZL4I/wLa2fJl24P5rtQrAvAhg9Aa5uEGwZXCGeXo40zopPs+PA2lL0HQ2kKcXktdLZLi9BAiFQrcJCcNvlF5yx2rhbs/N9sc5uVEH/VnEKsMSyIIiCqAhNX2LGNwdiPyI2DMDXe2JJoEG2Oof91IZLGLRhE3+JwjdPBt+ddQFgmr9CSObjfDHd5BSewqZBzTO0IpxTLzYwJcAI+4pMPfTXbXzDIaWmu+Opax54L68wamDPP1xRPV+5bVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We introduce a new batching implementation of zswap_compress() for
compressors that do and do not support batching. This eliminates code
duplication and facilitates code maintainability with the introduction
of compress batching.

The vectorized implementation of calling the earlier zswap_compress()
sequentially, one page at a time in zswap_store_pages(), is replaced
with this new version of zswap_compress() that accepts multiple pages to
compress as a batch.

If the compressor does not support batching, each page in the batch is
compressed and stored sequentially. If the compressor supports batching,
for e.g., 'deflate-iaa', the Intel IAA hardware accelerator, the batch
is compressed in parallel in hardware.

If the batch is compressed without errors, the compressed buffers for
the batch are stored in zsmalloc. In case of compression errors, the
current behavior based on whether the folio is enabled for zswap
writeback, is preserved.

The batched zswap_compress() incorporates Herbert's suggestion for
SG lists to represent the batch's inputs/outputs to interface with the
crypto API [1].

Performance data:
=================
As suggested by Barry, this is the performance data gathered on Intel
Sapphire Rapids with two workloads:

1) 30 usemem processes in a 150 GB memory limited cgroup, each
   allocates 10G, i.e, effectively running at 50% memory pressure.
2) kernel_compilation "defconfig", 32 threads, cgroup memory limit set
   to 1.7 GiB (50% memory pressure, since baseline memory usage is 3.4
   GiB): data averaged across 10 runs.

To keep comparisons simple, all testing was done without the
zswap shrinker.

 =========================================================================
  IAA                 mm-unstable-1-23-2026             v14
 =========================================================================
    zswap compressor            deflate-iaa     deflate-iaa   IAA Batching
                                                                  vs.
                                                            IAA Sequential
 =========================================================================
 usemem30, 64K folios:

    Total throughput (KB/s)       6,226,967      10,551,714       69%
    Average throughput (KB/s)       207,565         351,723       69%
    elapsed time (sec)                99.19           67.45      -32%
    sys time (sec)                 2,356.19        1,580.47      -33%

 usemem30, PMD folios:

    Total throughput (KB/s)       6,347,201      11,315,500       78%
    Average throughput (KB/s)       211,573         377,183       78%
    elapsed time (sec)                88.14           63.37      -28%
    sys time (sec)                 2,025.53        1,455.23      -28%

 kernel_compilation, 64K folios:

    elapsed time (sec)               100.10           98.74     -1.4%
    sys time (sec)                   308.72          301.23       -2%

 kernel_compilation, PMD folios:

    elapsed time (sec)                95.29           93.44     -1.9%
    sys time (sec)                   346.21          344.48     -0.5%
 =========================================================================

 =========================================================================
  ZSTD                mm-unstable-1-23-2026             v14
 =========================================================================
    zswap compressor                   zstd            zstd     v14 ZSTD
                                                             Improvement
 =========================================================================
 usemem30, 64K folios:

    Total throughput (KB/s)       6,032,326       6,047,448      0.3%
    Average throughput (KB/s)       201,077         201,581      0.3%
    elapsed time (sec)                97.52           95.33     -2.2%
    sys time (sec)                 2,415.40        2,328.38       -4%

 usemem30, PMD folios:

    Total throughput (KB/s)       6,570,404       6,623,962      0.8%
    Average throughput (KB/s)       219,013         220,798      0.8%
    elapsed time (sec)                89.17           88.25       -1%
    sys time (sec)                 2,126.69        2,043.08       -4%

 kernel_compilation, 64K folios:

    elapsed time (sec)               100.89           99.98     -0.9%
    sys time (sec)                   417.49          414.62     -0.7%

 kernel_compilation, PMD folios:

    elapsed time (sec)                98.26           97.38     -0.9%
    sys time (sec)                   487.14          473.16     -2.9%
 =========================================================================

Architectural considerations for the zswap batching framework:
==============================================================
We have designed the zswap batching framework to be
hardware-agnostic. It has no dependencies on Intel-specific features and
can be leveraged by any hardware accelerator or software-based
compressor. In other words, the framework is open and inclusive by
design.

Potential future clients of the batching framework:
===================================================
This patch-series demonstrates the performance benefits of compression
batching when used in zswap_store() of large folios. Compression
batching can be used for other use cases such as batching compression in
zram, batch compression of different folios during reclaim, kcompressd,
file systems, etc. Decompression batching can be used to improve
efficiency of zswap writeback (Thanks Nhat for this idea), batching
decompressions in zram, etc.

Experiments with kernel_compilation "allmodconfig" that combine zswap
compress batching, folio reclaim batching, and writeback batching show
that 0 pages are written back with deflate-iaa and zstd. For comparison,
the baselines for these compressors see 200K-800K pages written to disk.
Reclaim batching relieves memory pressure faster than reclaiming one
folio at a time, hence alleviates the need to scan slab memory for
writeback.

[1]: https://lore.kernel.org/all/aJ7Fk6RpNc815Ivd@gondor.apana.org.au/T/#m99aea2ce3d284e6c5a3253061d97b08c4752a798

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 mm/zswap.c | 260 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 190 insertions(+), 70 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 6a22add63220..399112af2c54 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -145,6 +145,7 @@ struct crypto_acomp_ctx {
 	struct acomp_req *req;
 	struct crypto_wait wait;
 	u8 **buffers;
+	struct sg_table *sg_table;
 	struct mutex mutex;
 };
 
@@ -272,6 +273,11 @@ static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx, u8 nr_buffers)
 			kfree(acomp_ctx->buffers[i]);
 		kfree(acomp_ctx->buffers);
 	}
+
+	if (acomp_ctx->sg_table) {
+		sg_free_table(acomp_ctx->sg_table);
+		kfree(acomp_ctx->sg_table);
+	}
 }
 
 static struct zswap_pool *zswap_pool_create(char *compressor)
@@ -834,6 +840,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
 	int nid = cpu_to_node(cpu);
+	struct scatterlist *sg;
 	int ret = -ENOMEM;
 	u8 i;
 
@@ -880,6 +887,22 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 			goto fail;
 	}
 
+	acomp_ctx->sg_table = kmalloc(sizeof(*acomp_ctx->sg_table),
+					GFP_KERNEL);
+	if (!acomp_ctx->sg_table)
+		goto fail;
+
+	if (sg_alloc_table(acomp_ctx->sg_table, pool->compr_batch_size,
+			   GFP_KERNEL))
+		goto fail;
+
+	/*
+	 * Statically map the per-CPU destination buffers to the per-CPU
+	 * SG lists.
+	 */
+	for_each_sg(acomp_ctx->sg_table->sgl, sg, pool->compr_batch_size, i)
+		sg_set_buf(sg, acomp_ctx->buffers[i], PAGE_SIZE);
+
 	/*
 	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
 	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
@@ -900,84 +923,177 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	return ret;
 }
 
-static bool zswap_compress(struct page *page, struct zswap_entry *entry,
-			   struct zswap_pool *pool, bool wb_enabled)
+/*
+ * zswap_compress() batching implementation for sequential and batching
+ * compressors.
+ *
+ * Description:
+ * ============
+ *
+ * Compress multiple @nr_pages in @folio starting from the @folio_start index in
+ * batches of @nr_batch_pages.
+ *
+ * It is assumed that @nr_pages <= ZSWAP_MAX_BATCH_SIZE. zswap_store() makes
+ * sure of this by design and zswap_store_pages() warns if this is not true.
+ *
+ * @nr_pages can be in (1, ZSWAP_MAX_BATCH_SIZE] even if the compressor does not
+ * support batching.
+ *
+ * If @nr_batch_pages is 1, each page is processed sequentially.
+ *
+ * If @nr_batch_pages is > 1, compression batching is invoked within
+ * the algorithm's driver, except if @nr_pages is 1: if so, the driver can
+ * choose to call it's sequential/non-batching compress routine.
+ *
+ * In both cases, if all compressions are successful, the compressed buffers
+ * are stored in zsmalloc.
+ *
+ * Design notes for batching compressors:
+ * ======================================
+ *
+ * Traversing SG lists when @nr_batch_pages is > 1 is expensive, and
+ * impacts batching performance if repeated:
+ *   - to map destination buffers to each SG list in @acomp_ctx->sg_table.
+ *   - to initialize each output @sg->length to PAGE_SIZE.
+ *
+ * Design choices made to optimize batching with SG lists:
+ *
+ * 1) The source folio pages in the batch are directly submitted to
+ *    crypto_acomp via acomp_request_set_src_folio().
+ *
+ * 2) The per-CPU @acomp_ctx->sg_table scatterlists are statically mapped
+ *    to the per-CPU dst @buffers at pool creation time.
+ *
+ * 3) zswap_compress() sets the output SG list length to PAGE_SIZE for
+ *    non-batching compressors. The batching compressor's driver should do this
+ *    as part of iterating through the dst SG lists for batch compression setup.
+ *
+ * Considerations for non-batching and batching compressors:
+ * =========================================================
+ *
+ * For each output SG list in @acomp_ctx->req->sg_table->sgl, the @sg->length
+ * should be set to either the page's compressed length (success), or it's
+ * compression error value.
+ */
+static bool zswap_compress(struct folio *folio,
+			   long folio_start,
+			   u8 nr_pages,
+			   u8 nr_batch_pages,
+			   struct zswap_entry *entries[],
+			   struct zs_pool *zs_pool,
+			   struct crypto_acomp_ctx *acomp_ctx,
+			   int nid,
+			   bool wb_enabled)
 {
-	struct crypto_acomp_ctx *acomp_ctx;
-	struct scatterlist input, output;
-	int comp_ret = 0, alloc_ret = 0;
-	unsigned int dlen = PAGE_SIZE;
+	gfp_t gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
+	unsigned int slen = nr_batch_pages * PAGE_SIZE;
+	u8 batch_start, batch_iter, compr_batch_size_iter;
+	struct scatterlist *sg;
 	unsigned long handle;
-	gfp_t gfp;
-	u8 *dst;
-	bool mapped = false;
-
-	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-	mutex_lock(&acomp_ctx->mutex);
-
-	dst = acomp_ctx->buffers[0];
-	sg_init_table(&input, 1);
-	sg_set_page(&input, page, PAGE_SIZE, 0);
-
-	sg_init_one(&output, dst, PAGE_SIZE);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+	int err, dlen;
+	void *dst;
 
 	/*
-	 * it maybe looks a little bit silly that we send an asynchronous request,
-	 * then wait for its completion synchronously. This makes the process look
-	 * synchronous in fact.
-	 * Theoretically, acomp supports users send multiple acomp requests in one
-	 * acomp instance, then get those requests done simultaneously. but in this
-	 * case, zswap actually does store and load page by page, there is no
-	 * existing method to send the second page before the first page is done
-	 * in one thread doing zswap.
-	 * but in different threads running on different cpu, we have different
-	 * acomp instance, so multiple threads can do (de)compression in parallel.
+	 * Locking the acomp_ctx mutex once per store batch results in better
+	 * performance as compared to locking per compress batch.
 	 */
-	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
+	mutex_lock(&acomp_ctx->mutex);
 
 	/*
-	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
-	 * save the content as is without a compression, to keep the LRU order
-	 * of writebacks.  If writeback is disabled, reject the page since it
-	 * only adds metadata overhead.  swap_writeout() will put the page back
-	 * to the active LRU list in the case.
+	 * Compress the @nr_pages in @folio starting at index @folio_start
+	 * in batches of @nr_batch_pages.
 	 */
-	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
-		if (!wb_enabled) {
-			comp_ret = comp_ret ? comp_ret : -EINVAL;
-			goto unlock;
-		}
-		comp_ret = 0;
-		dlen = PAGE_SIZE;
-		dst = kmap_local_page(page);
-		mapped = true;
-	}
+	for (batch_start = 0; batch_start < nr_pages;
+	     batch_start += nr_batch_pages) {
+		/*
+		 * Send @nr_batch_pages to crypto_acomp for compression:
+		 *
+		 * These pages are in @folio's range of indices in the interval
+		 *     [@folio_start + @batch_start,
+		 *      @folio_start + @batch_start + @nr_batch_pages).
+		 *
+		 * @slen indicates the total source length bytes for @nr_batch_pages.
+		 *
+		 * The pool's compressor batch size is at least @nr_batch_pages,
+		 * hence the acomp_ctx has at least @nr_batch_pages dst @buffers.
+		 */
+		acomp_request_set_src_folio(acomp_ctx->req, folio,
+					    (folio_start + batch_start) * PAGE_SIZE,
+					    slen);
+
+		acomp_ctx->sg_table->sgl->length = slen;
+
+		acomp_request_set_dst_sg(acomp_ctx->req,
+					 acomp_ctx->sg_table->sgl,
+					 slen);
+
+		err = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req),
+				      &acomp_ctx->wait);
+
+		/*
+		 * If a page cannot be compressed into a size smaller than
+		 * PAGE_SIZE, save the content as is without a compression, to
+		 * keep the LRU order of writebacks.  If writeback is disabled,
+		 * reject the page since it only adds metadata overhead.
+		 * swap_writeout() will put the page back to the active LRU list
+		 * in the case.
+		 *
+		 * It is assumed that any compressor that sets the output length
+		 * to 0 or a value >= PAGE_SIZE will also return a negative
+		 * error status in @err; i.e, will not return a successful
+		 * compression status in @err in this case.
+		 */
+		if (unlikely(err && !wb_enabled))
+			goto compress_error;
+
+		for_each_sg(acomp_ctx->sg_table->sgl, sg, nr_batch_pages,
+			    compr_batch_size_iter) {
+			batch_iter = batch_start + compr_batch_size_iter;
+			dst = acomp_ctx->buffers[compr_batch_size_iter];
+			dlen = sg->length;
+
+			if (dlen < 0) {
+				dlen = PAGE_SIZE;
+				dst = kmap_local_page(folio_page(folio,
+						      folio_start + batch_iter));
+			}
+
+			handle = zs_malloc(zs_pool, dlen, gfp, nid);
+
+			if (unlikely(IS_ERR_VALUE(handle))) {
+				if (PTR_ERR((void *)handle) == -ENOSPC)
+					zswap_reject_compress_poor++;
+				else
+					zswap_reject_alloc_fail++;
 
-	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-	handle = zs_malloc(pool->zs_pool, dlen, gfp, page_to_nid(page));
-	if (IS_ERR_VALUE(handle)) {
-		alloc_ret = PTR_ERR((void *)handle);
-		goto unlock;
+				goto err_unlock;
+			}
+
+			zs_obj_write(zs_pool, handle, dst, dlen);
+			entries[batch_iter]->handle = handle;
+			entries[batch_iter]->length = dlen;
+			if (dst != acomp_ctx->buffers[compr_batch_size_iter])
+				kunmap_local(dst);
+		}
 	}
 
-	zs_obj_write(pool->zs_pool, handle, dst, dlen);
-	entry->handle = handle;
-	entry->length = dlen;
+	mutex_unlock(&acomp_ctx->mutex);
+	return true;
 
-unlock:
-	if (mapped)
-		kunmap_local(dst);
-	if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
-		zswap_reject_compress_poor++;
-	else if (comp_ret)
-		zswap_reject_compress_fail++;
-	else if (alloc_ret)
-		zswap_reject_alloc_fail++;
+compress_error:
+	for_each_sg(acomp_ctx->sg_table->sgl, sg, nr_batch_pages,
+		    compr_batch_size_iter) {
+		if ((int)sg->length < 0) {
+			if ((int)sg->length == -ENOSPC)
+				zswap_reject_compress_poor++;
+			else
+				zswap_reject_compress_fail++;
+		}
+	}
 
+err_unlock:
 	mutex_unlock(&acomp_ctx->mutex);
-	return comp_ret == 0 && alloc_ret == 0;
+	return false;
 }
 
 static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
@@ -1499,12 +1615,16 @@ static bool zswap_store_pages(struct folio *folio,
 		INIT_LIST_HEAD(&entries[i]->lru);
 	}
 
-	for (i = 0; i < nr_pages; ++i) {
-		struct page *page = folio_page(folio, start + i);
-
-		if (!zswap_compress(page, entries[i], pool, wb_enabled))
-			goto store_pages_failed;
-	}
+	if (unlikely(!zswap_compress(folio,
+				     start,
+				     nr_pages,
+				     min(nr_pages, pool->compr_batch_size),
+				     entries,
+				     pool->zs_pool,
+				     acomp_ctx,
+				     nid,
+				     wb_enabled)))
+		goto store_pages_failed;
 
 	for (i = 0; i < nr_pages; ++i) {
 		struct zswap_entry *old, *entry = entries[i];
-- 
2.27.0


