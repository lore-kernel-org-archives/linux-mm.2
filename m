Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 090CFCA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 16:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9DD26B0095; Fri,  9 Oct 2026 12:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E76496B0096; Fri,  9 Oct 2026 12:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8B136B0098; Fri,  9 Oct 2026 12:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABF0F6B0095
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:31:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D8338045C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:31:55 +0000 (UTC)
X-FDA: 85303629390.10.D62F8F3
Received: from mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
	by imf02.hostedemail.com (Postfix) with ESMTP id 83CAF80007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:31:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w1ykZWfB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.7 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791563513;
	b=4wfJCYpcDESUsmQ1r+z8DY2MbBDVWrkf2sxkp0fpkAX540/3r3dgA67+XsvrmhMX++3DvF
	MrDRQbBo8I5cbFBDljMKpgoUfRnxNBiThfSxXuRDnmfXD6JZsWZaj9Fhs+yqLtJuYK1oJ0
	mor0Q+oIQ+DknUW/0T9BbRwxy8V0fN4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w1ykZWfB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.7 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791563513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sSNkWeqD1sYFhBthl0bbrWiI1wElCt+RzMlpJJaQgQE=;
	b=RvbwzXnZZuCu+h0GshunLpROw3JIWoO44N0grDwCSE2s27RvXUQ9Jp8HSnpuZqqMtif15U
	ixjNTzQwZiGGOjCzWsFanw4zzcp6onzf1NUvT4RJiyCoMAA3qPvJMXAuspc6r3u5S6UaMF
	zmx8C+o0WR/8J6p0jkZzdjFPWr7Ceds=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AbX5yr1fDxj9PcosE7xb/QpixZ7nguufAnPVK/S1B0Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791563512; v=1; x=1792168312;
 b=w1ykZWfBIxdGGLjdt76MSxjBJFNfmdmp+VN7aY/V7tQXuaZUsNHFrV4LLDjON4GfCa0G9CCg
 7mHD3RacvJ0Kkrbc07TKf6W12cx5YuUK4FRSo1h0OIa0XeEfkvO2TsTHekD3T09kGJXjlH0+kdq
 5NArHOFTkMRATVr9XT1d6qxI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 2ca375dbfad0cba9;
	Fri, 09 Oct 2026 16:31:51 +0000
X-Mizu-Trace-ID: 2ca375dbfad0cba9
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	chengming.zhou@linux.dev,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	terrelln@fb.com,
	yosry@kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	senozhatsky@chromium.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 1/2] mm: zswap: use separate compression and decompression requests
Date: Fri,  9 Oct 2026 09:30:30 -0700
Message-ID: <20261009163146.83112-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261009163146.83112-1-usama.arif@linux.dev>
References: <20261009163146.83112-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5bosszwgyeaf39zca9n1uwosbzprzmbe
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 83CAF80007
X-HE-Tag: 1791563513-323706
X-HE-Meta: U2FsdGVkX1+xPuWOgEcyGb1NuqQXoTHlBAS+CTD9xvFXR27+vpfe1j1dAvt/xcQE/BZPtLvLzxJcFPb1wKmHCc6gdtWbrhwEG7mIVaIHSF0P7InT4Iet3gpODr6Ha5fpbQYzY2O/mFemJxO8T4kDRCc2sjGhEKTiTzXJhiNGpzP2QQBghCEkD348VAGAuGuP28zbP4Fxz3mmvOPLva0GESizn7YTZvCiPt+qtvgB2/rK8BxgIwpByNn/8BeICHTjRfuJ0XK0swSRJtaaLt8v1if6g6rg5XSrcc2oTxSMM2RAGLJX4E7sMovUTwzr5nXaQ6QSm6+OB47spEFl78nncs7RZcAsaSVK5sC+yWvSFarDcqjX0G2OZVWUIWH42tBDT/n/DmV/8WwjimRUBBlYO5i6Ge9LUpkEXzbg3Sf5ppqS5D7jUY799AR6STCYvp7nfDfTcR2K6lU7gkASrcYb/vLm8JDNCel2tP0pvBSy4Mis0wRCYwA/i1FtT6DNLcwoivuPgtkxhKz/RoxvjKxA7n3QWG1abY/IG2jHFG3TIbN+EQpp3dK7ZIrExs3qZbRkaKFdhyXn5SpzKo8sXy4IlDcIEsI2NwD+bUnCMMG8PsKoSlEbR0L0Th+Ea1jQoK6KyWHT3tlu1/RbCZzYUNPt/q+rE1TGRA/1v5yFJon7q+GBqA+6QjTDxBRMNJ6KD+svnnZ6/SPghHB7q/VDz5yEt/ynYilv6e3tczurvwgSVRK5FDXkP53o40BtyWtrYuS+bHEtnZCYLRiTtuGFaX4O1HklmI96lV67GJk/cnHGAJVHThOaqozQ+EClVPydHtA1R1m8ysLjWpk3zbYJUf746c8LcPmR0aXV81k2Y+fq083WJyVj6OSprI24g+rR2B10uq4IGHWBM6u17lWwpq/LIZIV4AKdJm/oUYbmmSBght5pkq2iXUfmELSbsO7yyHO5Nggu5efhnTHp7zPexEf
 DpXDIBMB
 Py/xtYmrU4ks6Otv8Sy1+chgVl9uXFsACb4Axfz8muzrk2a/8+jCCYvP0TOrEsEsauv3v9ZBC1tz8oYcGukAEs/nQXVEbWCX2vep/xPAHTeI36ipFURU/+7q5nR5c6IOD8y+6YDIIuegIJLcWnYsEoFmwCM20I/F2RstLXUhPBLPcJYrbbyu/tk5XE7AB7wvQDj0RfD5ml4r46HqbSsL1uBSwaXGGOTzFObjGAJjJZGL7J/0sqv9LR5CmKsSYHWXjnz8msmRzJgkXqjSKrnEbuMBW9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stores and loads serialize on the same per-CPU acomp request and mutex.
A low-priority store can be preempted as soon as the compressor drops
its stream lock, while it still holds the mutex. A higher-priority load
on that CPU then waits until the store runs again, which can take a
long time when other tasks are runnable.

Give compression and decompression their own request, completion wait
and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
decompression APIs from zsmalloc"), the per-CPU buffer is only used for
compression, so group it with the compression request. Independent
requests can share the per-CPU transform; the codecs and drivers
synchronize their shared state internally. Loads can still wait for
each other on the decompression mutex, and stores still serialize on
the compression mutex.

acomp_request_free() ignores NULL requests, so drop the check in
acomp_ctx_free().

This follows the proposal from Sergey Senozhatsky for the same split
for zram [1].

[1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/zswap.c | 108 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 64 insertions(+), 44 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index ae19e301fced7..23c4298765795 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -137,14 +137,25 @@ bool zswap_never_enabled(void)
 * data structures
 **********************************/
 
-struct crypto_acomp_ctx {
-	struct crypto_acomp *acomp;
+struct zswap_acomp_req {
 	struct acomp_req *req;
 	struct crypto_wait wait;
-	u8 *buffer;
 	struct mutex mutex;
 };
 
+/* The compression mutex also protects the output buffer. */
+struct zswap_comp_ctx {
+	struct zswap_acomp_req areq;
+	u8 *buffer;
+};
+
+/* Separate requests, so that decompression does not wait for compression. */
+struct crypto_acomp_ctx {
+	struct crypto_acomp *acomp;
+	struct zswap_comp_ctx comp;
+	struct zswap_acomp_req decomp;
+};
+
 /*
  * The lock ordering is zswap_tree.lock -> zswap_pool.lru_lock.
  * The only case where lru_lock is not acquired while holding tree.lock is
@@ -270,14 +281,10 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 	if (!acomp_ctx)
 		return;
 
-	/*
-	 * If there was an error in allocating @acomp_ctx->req, it
-	 * would be set to NULL.
-	 */
-	if (acomp_ctx->req)
-		acomp_request_free(acomp_ctx->req);
-
-	acomp_ctx->req = NULL;
+	acomp_request_free(acomp_ctx->comp.areq.req);
+	acomp_ctx->comp.areq.req = NULL;
+	acomp_request_free(acomp_ctx->decomp.req);
+	acomp_ctx->decomp.req = NULL;
 
 	/*
 	 * We have to handle both cases here: an error pointer return from
@@ -289,8 +296,8 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 
 	acomp_ctx->acomp = NULL;
 
-	kfree(acomp_ctx->buffer);
-	acomp_ctx->buffer = NULL;
+	kfree(acomp_ctx->comp.buffer);
+	acomp_ctx->comp.buffer = NULL;
 }
 
 static struct zswap_pool *zswap_pool_create(char *compressor)
@@ -796,6 +803,28 @@ static void zswap_entry_free(struct zswap_entry *entry)
 /*********************************
 * compressed storage functions
 **********************************/
+static int zswap_acomp_req_init(struct zswap_acomp_req *areq,
+				struct crypto_acomp *acomp)
+{
+	/* acomp_request_alloc() returns NULL in case of an error. */
+	areq->req = acomp_request_alloc(acomp);
+	if (!areq->req)
+		return -ENOMEM;
+
+	crypto_init_wait(&areq->wait);
+
+	/*
+	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
+	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
+	 * won't be called, crypto_wait_req() will return without blocking.
+	 */
+	acomp_request_set_callback(areq->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   crypto_req_done, &areq->wait);
+
+	mutex_init(&areq->mutex);
+	return 0;
+}
+
 static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
@@ -811,8 +840,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		return 0;
 	}
 
-	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
-	if (!acomp_ctx->buffer)
+	acomp_ctx->comp.buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
+	if (!acomp_ctx->comp.buffer)
 		return ret;
 
 	/*
@@ -827,25 +856,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
-	/* acomp_request_alloc() returns NULL in case of an error. */
-	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!acomp_ctx->req) {
+	if (zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp) ||
+	    zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp_request %s\n",
 		       pool->tfm_name);
 		goto fail;
 	}
 
-	crypto_init_wait(&acomp_ctx->wait);
-
-	/*
-	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
-	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
-	 * won't be called, crypto_wait_req() will return without blocking.
-	 */
-	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   crypto_req_done, &acomp_ctx->wait);
-
-	mutex_init(&acomp_ctx->mutex);
 	return 0;
 
 fail:
@@ -856,7 +873,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 static bool zswap_compress(struct folio *folio, long index,
 			   struct zswap_entry *entry, struct zswap_pool *pool)
 {
-	struct crypto_acomp_ctx *acomp_ctx;
+	struct zswap_comp_ctx *comp_ctx;
 	struct scatterlist input, output;
 	int comp_ret = 0, alloc_ret = 0;
 	unsigned int dlen = PAGE_SIZE;
@@ -865,15 +882,16 @@ static bool zswap_compress(struct folio *folio, long index,
 	u8 *dst;
 	bool mapped = false;
 
-	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-	mutex_lock(&acomp_ctx->mutex);
+	comp_ctx = &raw_cpu_ptr(pool->acomp_ctx)->comp;
+	mutex_lock(&comp_ctx->areq.mutex);
 
-	dst = acomp_ctx->buffer;
+	dst = comp_ctx->buffer;
 	sg_init_table(&input, 1);
 	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
 
 	sg_init_one(&output, dst, PAGE_SIZE);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+	acomp_request_set_params(comp_ctx->areq.req, &input, &output,
+				 PAGE_SIZE, dlen);
 
 	/*
 	 * it maybe looks a little bit silly that we send an asynchronous request,
@@ -885,10 +903,12 @@ static bool zswap_compress(struct folio *folio, long index,
 	 * existing method to send the second page before the first page is done
 	 * in one thread doing zswap.
 	 * but in different threads running on different cpu, we have different
-	 * acomp instance, so multiple threads can do (de)compression in parallel.
+	 * acomp instance, and compression and decompression use separate
+	 * requests, so multiple threads can do (de)compression in parallel.
 	 */
-	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
+	comp_ret = crypto_wait_req(crypto_acomp_compress(comp_ctx->areq.req),
+				   &comp_ctx->areq.wait);
+	dlen = comp_ctx->areq.req->dlen;
 
 	/*
 	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
@@ -932,7 +952,7 @@ static bool zswap_compress(struct folio *folio, long index,
 	else if (alloc_ret)
 		zswap_reject_alloc_fail++;
 
-	mutex_unlock(&acomp_ctx->mutex);
+	mutex_unlock(&comp_ctx->areq.mutex);
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
@@ -948,7 +968,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 		return false;
 
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-	mutex_lock(&acomp_ctx->mutex);
+	mutex_lock(&acomp_ctx->decomp.mutex);
 	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
@@ -965,15 +985,15 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	} else {
 		sg_init_table(&output, 1);
 		sg_set_folio(&output, folio, PAGE_SIZE, 0);
-		acomp_request_set_params(acomp_ctx->req, input, &output,
+		acomp_request_set_params(acomp_ctx->decomp.req, input, &output,
 					 entry->length, PAGE_SIZE);
-		ret = crypto_acomp_decompress(acomp_ctx->req);
-		ret = crypto_wait_req(ret, &acomp_ctx->wait);
-		dlen = acomp_ctx->req->dlen;
+		ret = crypto_acomp_decompress(acomp_ctx->decomp.req);
+		ret = crypto_wait_req(ret, &acomp_ctx->decomp.wait);
+		dlen = acomp_ctx->decomp.req->dlen;
 	}
 
 	zs_obj_read_sg_end(pool->zs_pool, entry->handle);
-	mutex_unlock(&acomp_ctx->mutex);
+	mutex_unlock(&acomp_ctx->decomp.mutex);
 
 	if (!ret && dlen == PAGE_SIZE)
 		return true;
-- 
2.53.0-Meta


