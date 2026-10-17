Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B225CCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 16:09:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CEBD6B0096; Sat, 17 Oct 2026 12:09:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A64D6B0098; Sat, 17 Oct 2026 12:09:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3FA6B0099; Sat, 17 Oct 2026 12:09:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 260FC6B0096
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 12:09:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE333A02D0
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:09:34 +0000 (UTC)
X-FDA: 85332603468.25.AF23DFD
Received: from mta1.migadu.com (out-160.mta1.migadu.com [95.215.58.160])
	by imf09.hostedemail.com (Postfix) with ESMTP id BB6E3140006
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:09:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pSrAx+Hl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.160 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792253373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ltXt36N7KL5HQtJOZQKVE/gwiBRDHLUwQgVxEYoEGAI=;
	b=gxM+J6CuvjanXJwTS+4z61D17MKCln00cadd0IYGkE1grm68JxaT+cdtyG5LRiP4pCRXQX
	TOujh7dKXevVcG+VpsKt2wgWYuM8gjARujeWYpUkMF+jsl7dplwj91Xc6e7moTdpcfuztS
	aN8v8Ijd/nbwOQcSLNQCZ2Di3Ta4/j0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792253373;
	b=Qh4dpNysUkA0hcImaG5vUkA84x/9SFB0HU2V+N3e4CNza1yscE8zfUdBCNgSFlVUJyp593
	NpwmeI6F76YeB1l75we06vKnq9zijOLMNfrSuT/0Hg/OgBjHVUcSQhpUXaFB08Wb1YQYVq
	mN51DBiXD7/4HIOZk6v/c8iSobrqCIU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pSrAx+Hl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.160 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/8mRaaZ/j2zdk8bq9uqX0iQ1DG1/wNjoQWAEFWh6r0I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792253371; v=1; x=1792858171;
 b=pSrAx+HljFnquieZoqWi8bGQ4FhCuqEWDGDSaYnEDTuijJDpTAnOQVcjeMdfL1Z7MPwp0zcc
 BuGJYzoKeXdp/6me6Vv2HRz8D/BuZCdzxmEEwT4tZS1jstLW1S08AY7e4FVOXtHAz5tmWhUvRB+
 TCYCuegsVeiHsVosmfql/OPI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 79d4bf89d8171c02;
	Sat, 17 Oct 2026 16:09:31 +0000
X-Mizu-Trace-ID: 79d4bf89d8171c02
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
Subject: [PATCH v4 1/3] mm: zswap: use separate compression and decompression requests
Date: Sat, 17 Oct 2026 09:08:53 -0700
Message-ID: <20261017160918.2738626-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017160918.2738626-1-usama.arif@linux.dev>
References: <20261017160918.2738626-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BB6E3140006
X-Stat-Signature: diphb1yrehyjcmh35hhr9znczrn6rjcb
X-Rspam-User: 
X-HE-Tag: 1792253372-582843
X-HE-Meta: U2FsdGVkX1+uQN78AQb1WuI7V+vwtp4gxaHLOKTBLljLeeXO2eQi4Adp5cGpzgjfFpBbhOQToVTCbfqTqP56RfCwhlj03QHVVXov5+CcppikzbNtyrLAkBb+rA/iuUXzy7cPaut3r64Pm4xyw0tuyZgRgoaa8FEDYUEYnJKdCpkPh5+J+/JQoypbJEP+78j/fVN8IAhAI5/U1FvKX5mboBsdBRzqdwio8w/6rCx3yodZK4kYyzhxXUtjBHKL8SaHBuPbZ//vz2Ea16QV9T+b4oK+s1Aeme80QnltSeQDZYIf1XPt4lhfO3uCcJgepceZB2+ID5bRFJrcou0SnNw1PNXIXemtD4hDnAuiWPEvCyQwwqFeduw0qkty9b0v9tLebKNuEnsutwetdG/6CW12se8ox+SozYEMft6jhdFtyJYj20knmtNeQrIHHnuN+koBpmGDkzASrnXwxgdCP5BgE7PScMKtaJkfFHpedyIAuf7p5N/1E6Gq3K1Xmag4FcD5ciNsycFtzF1SsOzV8INw3VGKKqpZXFzHsaAFDpbvCEBXaJlJExgyK7F0w7fe4q28aP883aCD8B31w0Eb0dp6OAtowh/qvaF0AJdvkYs/TEV17ULVCDAOgL+BGtnPH2IZmIV8rTY8QlBBbN2wU5pWhpNRxn6ij0ozMATX9XP5hmyziT2jXvDbf37HpK6X9sorW7S3p2T36/PXQ8Z4+kzRn5otzO/vyYE67eHJ3AHhH9PUb43GNLoMJP/Ra6l1n7OZRAK5PVz2dg5+8jnQjWBgHbK0f7ziRfuV3j07Y0/wrMYLf000hvjSz7EqGfLMRyAdNUGKkH8IeHkQt1qyV25IaQ+yH/J6hyUhLL826INk+kNJ2FxM1pYS3xlU/aJTgnBrBEaijA+8O/nTdcTLyz3l2n9WV/2H3sJwDPq+Gz580H6lwvbu9wdy2Dnnwdo8+DExfTXqkmtLIrOAxzm44Hj
 zLdRVY5a
 7WtdI+4NqFHDlWrBf3leLTd54aThlOpIt5as0izkqsvQBqT5A1t+q+nPXsHYPV+Suv1hvVdB2OQJMAR//i2WA/8bNrPWBxVM3E7Zyikh+L5jhcJ8VbEL0l0BW7jQWxi3PDeBe5wRHQGacLHt++ez905XDOXlKYUdEjKsNgdGu8DFamtJeLKgnRrlSGYXAfUHlHWH9Jcq3V5WeS2KQKayB7ogGlV+g2XDwb390I2LdWqlBmxgcCwotCRy8pJR4WbPsIrHd+CTrysqdDOZZvXYpRI3oZ8t7kkc3t8r1fU1oYF+Gi7yEwscp13fe8OiJeeycNGFlz/wA6byptOfAWL+D4SVN8dt/Jb41xYie8mlb7Z3WWRY=
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

On x86-64 without PREEMPT_RT or lock debugging, each pool's per-CPU
context grows from 88 to 160 bytes. Each initialized CPU also needs an
extra acomp request: 176 bytes plus the algorithm's request context,
before alignment and allocator rounding.

acomp_request_free() ignores NULL requests, so drop the check in
acomp_ctx_free().

This follows the proposal from Sergey Senozhatsky for the same split
for zram [1].

[1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/

Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/zswap.c | 117 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 70 insertions(+), 47 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index ae19e301fced7..b23ef5f3bd529 100644
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
@@ -827,27 +856,18 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
-	/* acomp_request_alloc() returns NULL in case of an error. */
-	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!acomp_ctx->req) {
-		pr_err("could not alloc crypto acomp_request %s\n",
-		       pool->tfm_name);
-		goto fail;
-	}
-
-	crypto_init_wait(&acomp_ctx->wait);
+	ret = zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp);
+	if (ret)
+		goto req_fail;
 
-	/*
-	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
-	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
-	 * won't be called, crypto_wait_req() will return without blocking.
-	 */
-	acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   crypto_req_done, &acomp_ctx->wait);
+	ret = zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp);
+	if (ret)
+		goto req_fail;
 
-	mutex_init(&acomp_ctx->mutex);
 	return 0;
 
+req_fail:
+	pr_err("could not alloc crypto acomp_request %s\n", pool->tfm_name);
 fail:
 	acomp_ctx_free(acomp_ctx);
 	return ret;
@@ -856,7 +876,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 static bool zswap_compress(struct folio *folio, long index,
 			   struct zswap_entry *entry, struct zswap_pool *pool)
 {
-	struct crypto_acomp_ctx *acomp_ctx;
+	struct zswap_comp_ctx *comp_ctx;
 	struct scatterlist input, output;
 	int comp_ret = 0, alloc_ret = 0;
 	unsigned int dlen = PAGE_SIZE;
@@ -865,15 +885,16 @@ static bool zswap_compress(struct folio *folio, long index,
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
@@ -885,10 +906,12 @@ static bool zswap_compress(struct folio *folio, long index,
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
@@ -932,7 +955,7 @@ static bool zswap_compress(struct folio *folio, long index,
 	else if (alloc_ret)
 		zswap_reject_alloc_fail++;
 
-	mutex_unlock(&acomp_ctx->mutex);
+	mutex_unlock(&comp_ctx->areq.mutex);
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
@@ -948,7 +971,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 		return false;
 
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-	mutex_lock(&acomp_ctx->mutex);
+	mutex_lock(&acomp_ctx->decomp.mutex);
 	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
@@ -965,15 +988,15 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
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


