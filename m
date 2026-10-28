Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D005A606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 03:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Llzwkziu
Received: by kanga.kvack.org (Postfix)
	id D7C6E6B096B; Tue, 27 Oct 2026 23:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D06506B096D; Tue, 27 Oct 2026 23:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B802B6B096E; Tue, 27 Oct 2026 23:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF076B096B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:05:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C20B40BE5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:24 +0000 (UTC)
X-FDA: 85370544168.14.A956144
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id 84E04A0003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Llzwkziu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793156722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AvcrC01525OQBRfQntsOStl5llkVzHtEkp+xwSz9Rzo=;
	b=Upqk65Ndzdb7XSmlLJHBp15EhKhirZjsMaF1t/BhN785UHQpSuDnqI0wmfh4Hf6Y+V0Sh+
	g5rTY+iCbkD+9IeWhDdv1izMyMTIgo4uPusunGwLRDWc9EDGQtGJlrL7Wt1RVjmMkHtgPf
	mGTW7JnRPX3shm5nT7htghEuktCL/Vc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Llzwkziu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793156722;
	b=G6aJAP+7x106RC0zH2Xhfa4UJXQE7gaNbPK1pajYPi9VvonPiHSNfUPpz9hvi/Yn8+urkf
	wijHUv+po+Xi1PldLpjC0Bwb8p4JUKCqrwK2GojRK+VOGBr9aJZC+0cSyZ0zPRgj6CqGr9
	e04wg9RZN4uRyW8DnBdYd6CLhh7Da+Y=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-369f33df08eso987369eec.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793156721; x=1793761521; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AvcrC01525OQBRfQntsOStl5llkVzHtEkp+xwSz9Rzo=;
        b=LlzwkziuvfAgFWYaQCi05M7zE4PY9g8xUf8Oux6NgRR4JTQze1jJkEOMdw0f4dhWo9
         4i2tRAoFKcM+w2sbMy7m6hN2Q5r93EgUnDSDWBUowpX6P2/BZ3YDySnKekc/5EIKL14X
         Spe6vNgQulx8K6xmH3lNfNPi6nvElC4QTxyrGYkhGz2hQLsdkeLNq+j9N26QUvqoRI7X
         0MHGX7TzNQxgIys3vrNkLt9hysTpcJn3mw6ZWl0yMXYttS+Hdx4oICOWY2PIRemlWjZS
         FENbulMs3534ISgMYqGMp9WJ7cq+2UveDq59wF/ov3K7WR39oj098+hMDVDA7ta6v5cW
         ymOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793156721; x=1793761521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AvcrC01525OQBRfQntsOStl5llkVzHtEkp+xwSz9Rzo=;
        b=z14TnW3SpSH3z4dCkQD4oGfogTTh9o7jAj85FHyX0Vp3HLS1ncfjC68mA6ajWNCJLt
         0nw1DK/qozI/6aF06D9ObJ27ttSoDLDAjwijR/nuIT7R/U2FlywOe6Rx0iGm24DILOI+
         8OZLiB7RnmVvIfsxLa0TK0UtfjD4Cj/LYbmiG2kOzY7rSarZTa3ZbKCGvn53RIzZHSWQ
         OObQooJBLSGs1Zh1/mnyXiVkAT5scKqGbmWgRhYmdz2oanjODc67/8MYrY0S8iQ8YKW9
         +czbw4vTt6CJccF5ago2YlOumlXH8HHjnFKjp6oPbj9KbT895hFzJh5lfavRRL8MICKp
         Tz+Q==
X-Forwarded-Encrypted: i=1; AKwUvBzgIE3yglbaEFUrnzZmRj8ubyjr3TVlLCaX5kMae54ws/S5vleoaN4SBond913X2LSXBjGON7UG8g==@kvack.org
X-Gm-Message-State: AFq9FYIgt80yfRu7BTuVhjBc4rxmBgUEksmKu4kvKWpy7zf7grl4R69/
	VAAZH3MKT7Ih91bbSkHG1athoSP4R0eO6+1CwyRpmRicKnT0YrvTKEca
X-Gm-Gg: AYBFou325xwhA7kUFoGuT0oQ8qGpwmelpwea7g7XaxVYJ42osm9h8PyZzU9tY3OTHY/
	IlwPr18ehEi1zSBopARmTOv5O6MlZcgpe0CDhvjEVbHzMEHMuwCAsMIU+h9LapnWIxay3ilfweK
	GIj8jdUIjm/WM5cUr4oTahbAacaWHi25bKCmwqhZncdCaE1jt2fwmPWWse9MYBd1qd/ZzQIsfyE
	0myvWtfFgDOFNf7EqmaqweJM8tE6DQTb00T722JtlKN1F7dp9A30kBSkYZcvD2Qg4xwXBziPjSD
	xc0rSoRb0kcD2pSnYVtOhsCfvZUNjA+z12QoLN79PgIAsQBF/CbDhr3DEzzQD86+/Szs5FqYtqf
	UbaKWPDsc7evODKE/5mReR/GT8q9yW3B9MAGVHsCr5lxvF7kELBVpaAoDuJVm6PUZE781MiTOw2
	llFxvHChYO1CaBs6vSZiFj4uxY+Kid2uSJ3GsIvSxKw819ED611O/HNTyQ2pwnp6lTwd/hOh4qt
	67dpHyEq4c2iPZwmk7mMiveSmuohdQellyiybZcV4dD2TjdTF7jzO0qvvliNn2Zj/lYItccVjnK
	6qSfmcI02bWKZuVEjRIXeovcauezTC9BLtJV1wGc9A==
X-Received: by 2002:a05:701b:2707:b0:1a0:e3e2:22a3 with SMTP id a92af1059eb24-1a6d0d531a3mr1378775c88.31.1793156720784;
        Tue, 27 Oct 2026 20:05:20 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75a37093esm1150734c88.3.2026.10.27.20.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 20:05:20 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v2 7/8] mm: zswap: Batched zswap_compress() for storing large folios in batches.
Date: Tue, 27 Oct 2026 20:05:02 -0700
Message-Id: <20261028030503.17923-8-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 84E04A0003
X-Stat-Signature: uzkuxptxbt7cr5cqu9g8m8p8d4dpb5wq
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793156722-89990
X-HE-Meta: U2FsdGVkX18W1SXsy0htoJIBrzLAVZQsKN1CWkGkA5EjfZnQ7vbrivnLGMXibqom4UIAy9mYhoNvBhKveX3FiKqy/OnOwaH0QzM0bqGyxRjcr6aFHovXUgqczJM4+3YHJ2emsIZ0l2k5gtn6J3jYFdZ5LrTlKEORcyLFnfOoOa9go1MC4JPsF20YvYZZQ/3YiQIgM33rg6U3weNyYRyGyHrjM0/WRJIYdpENocnniz+gJ6lBCECfXl6oAqHowuAFtLTwfG8OwRVbSgsBcB7LCUz5/olXPZUzXk9C4aOIsQxru6REIyOwDP5YRaAk/68KIfYSwRzIcvUC1e5VIUmoJbRNchAhpb6WUJAspBbI4c2T3JSuh06NMOfkg/k4qQe+V/sF1gV3c6paBU6KpvLkrrqol3jzgaxH2vOJax7Tr2o/TjJcaeLLbZVNAdbex8gMezsY7OefHIY/BANlDkQY2YHxsCFS8GkAOIbbSz7JorKsY2U+AuJrfhomDq6PGXsQmRePrLKkGbRemQYFu7LrR+ZV+DbZc3aRVdt/V/Anx3JJqmDuAoyznozmU0DVf5G5OXDV2dFLAtGknIjBnYGVFxWAmNFfChwPSKjeysgS8KGQeRqz/lzmwtZ38GrJD11OWmldKLBwFMDhVJk3A8IU6wcxzF/8fTRtnlZG9y6Z6WvySrPSVvk+aRNAuqEMwsjE0jYOM/PtqU6NhUcZrRHePJo/OyjXuwmLNqKWZriJ7ApzAbGYkq3vwiubb6zXkfBZYYJrzsfZ1NrYzKlGN/aEpSVX3CHh/9gmhzNkvuo7sVTqM05zz76cbZmTrMx6byH0lVLN6l9qCn+ATx+C5Zb3gnCsAVq9oC5ozmbuAOzzqv9G2F0Fb5HQRNZHBFc8heCSP/otcdU/A7z2nDj+E47xvmYdH0oAhT7HZBqLkEWMgGel0A2zpPbpf/NKluqvteg2cx8n/hEZQY5WHiAZBei
 I8rqppKX
 j2TSDw4RRfRbVDGJWkptM9Mbie6JSqYxsxE7KYncaQ1wZYvQFxhoC9f4E//III5mSeBr2xiDBahiJOSFbM7TYnzDTa+YVNJM3MEMXl9Z4lBUMlPEytgtCee0U6gG1Uacqzmtebh7G4VhH0O3Cs5mHxmi3qmXgrU+f3GvjxGHAaxbrkJJvB9vVIfXT8dLcLaAdd4Mr2rAQUWFq+2OPk8dgJkqxCd8zMIDkjMo3Mhc4zgsvYuUR3bVH4tZQjGiHgg48/kwgiQfkWo0T1AGwBPk3r7IiyhzJDSY5WD/I2ZZyRyC9Hy+N4nLzGWNY7xV2OCO8IqeB2mqsvSpByNY+u/dDi+FuWWYbAmVTSKEV935JCpx6mRrm06060lTVWYb3HyimX4UBQ1nSS5vjz4mie7La53i6GDWTh9lfCh5z1z3vY4m253rXXJDXEBIkaCPgYtR4sIJEiFv45eBAC42JMuME55S01Q6PqhC7MKJgBL2VqCnHMc/8s89UvonakEeG1TLXkgEYJ2grSbQ4fhVZsmgJxlG++A4zEHxfengZna5moijAfeXXf4MxgFvaXAxmBacLVl8G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A new batching implementation of zswap_compress() is provided for
compressors that do and do not support batching. This eliminates code
duplication and facilitates code maintainability with the introduction
of compress batching.

The vectorized implementation of calling the earlier zswap_compress()
sequentially, one page at a time in zswap_store_pages(), is replaced
with this new version of zswap_compress() that accepts multiple pages to
compress as a batch.

If the compressor does not support batching, each page in the batch is
compressed and stored sequentially.

If the batch is compressed without errors, the compressed buffers for
the batch are stored in zsmalloc. In case of compression errors, the
current behavior based on whether the folio is enabled for zswap
writeback, is preserved.

The batched zswap_compress() incorporates Herbert's suggestion for
SG lists to represent the batch's inputs/outputs to interface with the
crypto API [1].

The struct zswap_store_context is extended to facilitate passing
batching related constraints and data to zswap_compress(). The code that
allocates zsmalloc memory to store compression results is refactored
into a new routine, zswap_update_entries(). Subsequent patches will be
submitted to further optimize this phase by replacing zsmalloc with
the SLUB allocator to improve zswap_store()/zswap_load() latencies.

[1]: https://lore.kernel.org/all/aJ7Fk6RpNc815Ivd@gondor.apana.org.au/T/#m99aea2ce3d284e6c5a3253061d97b08c4752a798

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 271 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 189 insertions(+), 82 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index c8890e8a9b83..4476fb4aeb5f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -150,6 +150,7 @@ struct zswap_acomp_req {
 struct zswap_comp_ctx {
 	struct zswap_acomp_req areq;
 	u8 **buffers;
+	struct sg_table *sg_table;
 };
 
 /* Separate requests, so that decompression does not wait for compression. */
@@ -235,9 +236,13 @@ struct zswap_entry {
 struct zswap_store_context {
 	struct folio *folio;
 	long folio_start;
+	unsigned int slen;
+	u8 nr_batch_pages;
 	bool wb_enabled;
 	int nid;
 	u8 nr_pages;
+	struct zs_pool *zs_pool;
+	struct zswap_comp_ctx *comp_ctx;
 	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
 };
 
@@ -325,6 +330,12 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx, u8 nr_buffers)
 		kfree(acomp_ctx->comp.buffers);
 	}
 	acomp_ctx->comp.buffers = NULL;
+
+	if (acomp_ctx->comp.sg_table) {
+		sg_free_table(acomp_ctx->comp.sg_table);
+		kfree(acomp_ctx->comp.sg_table);
+	}
+	acomp_ctx->comp.sg_table = NULL;
 }
 
 static struct zswap_pool *zswap_pool_create(char *compressor)
@@ -898,6 +909,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
 	int nid = cpu_to_node(cpu);
+	struct scatterlist *sg;
 	int ret = -ENOMEM;
 	u8 i;
 
@@ -944,6 +956,21 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 			goto req_fail;
 	}
 
+	acomp_ctx->comp.sg_table = kmalloc(sizeof(*acomp_ctx->comp.sg_table), GFP_KERNEL);
+	if (!acomp_ctx->comp.sg_table)
+		goto req_fail;
+
+	if (sg_alloc_table(acomp_ctx->comp.sg_table, pool->compr_batch_size,
+			   GFP_KERNEL))
+		goto req_fail;
+
+	/*
+	 * Statically map the per-CPU destination buffers to the per-CPU
+	 * SG lists; crucial for performance.
+	 */
+	for_each_sg(acomp_ctx->comp.sg_table->sgl, sg, pool->compr_batch_size, i)
+		sg_set_buf(sg, acomp_ctx->comp.buffers[i], PAGE_SIZE);
+
 	/* Skip the per-CPU request when decompression can use the stack. */
 	if (acomp_is_async(acomp_ctx->acomp)) {
 		ret = zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp);
@@ -960,92 +987,161 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	return ret;
 }
 
-static bool zswap_compress(struct folio *folio, long index,
-			   struct zswap_entry *entry, struct zswap_pool *pool,
-			   bool wb_enabled)
+static bool zswap_update_entries(struct zswap_store_context *zc,
+				 u8 batch_start)
 {
-	struct zswap_comp_ctx *comp_ctx;
-	struct scatterlist input, output;
-	int comp_ret = 0, alloc_ret = 0;
-	unsigned int dlen = PAGE_SIZE;
+	gfp_t gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
+	u8 i, batch_iter, comp_batch_iter;
 	unsigned long handle;
-	gfp_t gfp;
+	unsigned int dlen;
 	u8 *dst;
-	bool mapped = false;
-
-	comp_ctx = &raw_cpu_ptr(pool->acomp_ctx)->comp;
-	mutex_lock(&comp_ctx->areq.mutex);
-
-	dst = comp_ctx->buffers[0];
-	sg_init_table(&input, 1);
-	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
-
-	sg_init_one(&output, dst, PAGE_SIZE);
-	acomp_request_set_params(comp_ctx->areq.req, &input, &output,
-				 PAGE_SIZE, dlen);
 
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
-	 * acomp instance, and compression and decompression use separate
-	 * requests, so multiple threads can do (de)compression in parallel.
+	 * For each output SG list in @acomp_ctx->req->sg_table->sgl,
+	 * the @sg->length should be set to either the page's compressed
+	 * length (success), or it's negative value compression error.
 	 */
-	comp_ret = crypto_wait_req(crypto_acomp_compress(comp_ctx->areq.req),
-				   &comp_ctx->areq.wait);
-	dlen = comp_ctx->areq.req->dlen;
-	if (!comp_ret) {
-		if (dlen == PAGE_SIZE)
-			comp_ret = -ENOSPC;
-		else if (WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE))
-			comp_ret = -EINVAL;
+	for (comp_batch_iter = 0; comp_batch_iter < zc->nr_batch_pages;
+	     ++comp_batch_iter) {
+		batch_iter = batch_start + comp_batch_iter;
+		dlen = zc->entries[batch_iter]->length;
+		handle = zs_malloc(zc->zs_pool, dlen, gfp, zc->nid);
+
+		if (unlikely(IS_ERR_VALUE(handle))) {
+			if (PTR_ERR((void *)handle) == -ENOSPC)
+				zswap_reject_compress_poor++;
+			else
+				zswap_reject_alloc_fail++;
+
+			for (i = 0; i < comp_batch_iter; ++i)
+				zs_free(zc->zs_pool, zc->entries[batch_start + i]->handle);
+
+			return false;
+		}
+
+		zc->entries[batch_iter]->handle = handle;
+
+		if (likely(dlen < PAGE_SIZE)) {
+			dst = zc->comp_ctx->buffers[comp_batch_iter];
+			zs_obj_write(zc->zs_pool, handle, dst, dlen);
+		} else {
+			dst = kmap_local_folio(zc->folio,
+					(zc->folio_start + batch_iter) * PAGE_SIZE);
+			zs_obj_write(zc->zs_pool, handle, dst, dlen);
+			kunmap_local(dst);
+		}
 	}
 
+	return true;
+}
+
+/*
+ * zswap_compress() batching implementation for sequential and batching
+ * compressors.
+ *
+ * Description:
+ * ============
+ * Compress multiple @nr_pages in @folio starting from the @folio_start index
+ * in batches of @nr_batch_pages; the latter representing the lesser of the
+ * @nr_pages to be batch compressed and the compressor's batch size.
+ *
+ * @nr_pages can be in (1, ZSWAP_MAX_BATCH_SIZE] even if the compressor does not
+ * support batching.
+ *
+ * If @nr_batch_pages is 1, each page is processed sequentially.
+ *
+ * If @nr_batch_pages is > 1, the compressor may use batching to optimize
+ * compression.
+ */
+static bool zswap_compress(struct zswap_store_context *zc)
+{
+	u8 batch_start, comp_batch_iter, batch_iter;
+	struct scatterlist *sg;
+	bool ret;
+	int err;
+
 	/*
-	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
-	 * save the content as is without a compression, to keep the LRU order
-	 * of writebacks.  If writeback is disabled, reject the page since it
-	 * only adds metadata overhead.  swap_writeout() will put the page back
-	 * to the active LRU list in the case.
+	 * Compress the @nr_pages in @folio starting at index @folio_start
+	 * in batches of @nr_batch_pages.
 	 */
-	if (comp_ret) {
-		if (!wb_enabled)
-			goto unlock;
-		comp_ret = 0;
-		dlen = PAGE_SIZE;
-		dst = kmap_local_folio(folio, index * PAGE_SIZE);
-		mapped = true;
-	}
+	for (batch_start = 0; batch_start < zc->nr_pages;
+	     batch_start += zc->nr_batch_pages) {
+		/*
+		 * Send @nr_batch_pages to crypto_acomp for compression:
+		 *
+		 * These pages are in @folio's range of indices in the interval
+		 *     [@folio_start + @batch_start,
+		 *      @folio_start + @batch_start + @nr_batch_pages).
+		 *
+		 * @slen indicates the total source length bytes for
+		 * @nr_batch_pages.
+		 *
+		 * The source folio pages in the batch are directly submitted to
+		 * crypto_acomp via acomp_request_set_src_folio().
+		 *
+		 * The pool's compressor batch size is at least @nr_batch_pages,
+		 * hence the acomp_ctx has at least @nr_batch_pages dst @buffers.
+		 */
+		acomp_request_set_src_folio(zc->comp_ctx->areq.req, zc->folio,
+				(zc->folio_start + batch_start) * PAGE_SIZE,
+				zc->slen);
+
+		zc->comp_ctx->sg_table->sgl->length = zc->slen;
+
+		/*
+		 * The per-CPU @zc->comp_ctx->sg_table scatterlists are statically
+		 * mapped to the per-CPU dst @buffers at pool creation time.
+		 */
+		acomp_request_set_dst_sg(zc->comp_ctx->areq.req,
+					 zc->comp_ctx->sg_table->sgl, zc->slen);
+
+		err = crypto_wait_req(crypto_acomp_compress(zc->comp_ctx->areq.req),
+				      &zc->comp_ctx->areq.wait);
 
-	gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
-	handle = zs_malloc(pool->zs_pool, dlen, gfp, folio_nid(folio));
-	if (IS_ERR_VALUE(handle)) {
-		alloc_ret = PTR_ERR((void *)handle);
-		goto unlock;
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
+		if (unlikely(err && !zc->wb_enabled))
+			goto compress_error;
+
+		for_each_sg(zc->comp_ctx->sg_table->sgl, sg,
+			    zc->nr_batch_pages, comp_batch_iter) {
+			batch_iter = batch_start + comp_batch_iter;
+			if (unlikely(sg->length <= 0 || sg->length >= PAGE_SIZE))
+				sg->length = PAGE_SIZE;
+
+			zc->entries[batch_iter]->length = sg->length;
+		}
+
+		ret = zswap_update_entries(zc, batch_start);
+		if (unlikely(!ret))
+			return false;
 	}
 
-	zs_obj_write(pool->zs_pool, handle, dst, dlen);
-	entry->handle = handle;
-	entry->length = dlen;
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
-
-	mutex_unlock(&comp_ctx->areq.mutex);
-	return comp_ret == 0 && alloc_ret == 0;
+compress_error:
+	for_each_sg(zc->comp_ctx->sg_table->sgl, sg,
+		    zc->nr_batch_pages, comp_batch_iter) {
+		if ((int)sg->length < 0) {
+			if ((int)sg->length == -ENOSPC)
+				zswap_reject_compress_poor++;
+			else
+				zswap_reject_compress_fail++;
+		}
+	}
+
+	return false;
 }
 
 static bool __zswap_decompress(struct zswap_entry *entry,
@@ -1582,6 +1678,7 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 			      struct obj_cgroup *objcg)
 {
 	u8 i, store_fail_idx = 0;
+	bool ret;
 
 	zc->nr_pages = end - start;
 	zc->folio_start = start;
@@ -1596,7 +1693,6 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 	 * minimize potential cache misses.
 	 */
 	for (i = 0; i < zc->nr_pages; ++i) {
-		zc->entries[i]->handle = (unsigned long)ERR_PTR(-EINVAL);
 		/*
 		 * Set pool_idx before the xa_store() below publishes the entry, or a
 		 * concurrent reader could resolve a stale pool_idx left by slab reuse
@@ -1611,11 +1707,19 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 		INIT_LIST_HEAD(&zc->entries[i]->lru);
 	}
 
-	for (i = 0; i < zc->nr_pages; ++i) {
-		if (!zswap_compress(zc->folio, zc->folio_start + i,
-				    zc->entries[i], pool, zc->wb_enabled))
-			goto store_pages_failed;
-	}
+	/*
+	 * Locking the comp_ctx mutex once per store batch results in better
+	 * performance as compared to locking per compress batch.
+	 */
+	zc->comp_ctx = &raw_cpu_ptr(pool->acomp_ctx)->comp;
+	mutex_lock(&zc->comp_ctx->areq.mutex);
+
+	ret = zswap_compress(zc);
+
+	mutex_unlock(&zc->comp_ctx->areq.mutex);
+
+	if (unlikely(!ret))
+		goto compress_failed;
 
 	for (i = 0; i < zc->nr_pages; ++i) {
 		struct zswap_entry *old, *entry = zc->entries[i];
@@ -1681,11 +1785,10 @@ static bool zswap_store_pages(struct zswap_store_context *zc,
 	return true;
 
 store_pages_failed:
-	for (i = store_fail_idx; i < zc->nr_pages; ++i) {
-		if (!IS_ERR_VALUE(zc->entries[i]->handle))
-			zs_free(pool->zs_pool, zc->entries[i]->handle);
-	}
+	for (i = store_fail_idx; i < zc->nr_pages; ++i)
+		zs_free(pool->zs_pool, zc->entries[i]->handle);
 
+compress_failed:
 	zswap_entries_cache_free_batch(&zc->entries[store_fail_idx],
 				       zc->nr_pages - store_fail_idx);
 
@@ -1757,6 +1860,10 @@ bool zswap_store(struct folio *folio)
 	store_batch_size = (pool->compr_batch_size > 1) ?
 			    pool->compr_batch_size : ZSWAP_MAX_BATCH_SIZE;
 
+	zc.nr_batch_pages = pool->compr_batch_size;
+	zc.slen = zc.nr_batch_pages * PAGE_SIZE;
+	zc.zs_pool = pool->zs_pool;
+
 	for (start = 0; start < nr_pages; start += store_batch_size) {
 		end = min(start + store_batch_size, nr_pages);
 
-- 
2.39.5


