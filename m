Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 758B7CC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847DF6B00B2; Tue, 13 Oct 2026 11:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7826B00B3; Tue, 13 Oct 2026 11:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 734FA6B00B4; Tue, 13 Oct 2026 11:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0EF16B00B2
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:10:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C81F40D3F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:10:56 +0000 (UTC)
X-FDA: 85317940512.11.F473D15
Received: from mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
	by imf01.hostedemail.com (Postfix) with ESMTP id BBA9640007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:10:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G8cZm7L2;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYouKdiyXJp86yRL68MFzivUXa+TZV8aTHVPRt291Gc=;
	b=xbKiw4ght5rIK8G3Hip+6ND0iXiU9nWZhhcqmv3LptwoLMiQIyMNdR28ykyVfbXVybDKmr
	bsd7Wjfi32FkDcCHxmdZz+tT7dq0RGo3jRBwdNC5hZMTXMSLe2E2J1bbcM2CjKtD+/IxSI
	TmiJvfMnG/CwspWMGRlJqtsOZ5p2/tU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G8cZm7L2;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904254;
	b=SLKBsM0ge6XhbyIK9FrKY7Ge1T5LN9ruvb+2+t8t5z37aFo1zXRhI6ubvROoYClACr4u3/
	4hr8Fo2YI/a40VpVqRjNop45yOKoLA9PLz0tjj1m6pQl6/0NM9lYUfHXqhjnsr947/AgIh
	HOydEpnflswCyo/BtcR+mJmwmmAnyhQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Llw0nThjK60jUx/vxsW20gdWbzulx+k6ywgPWEsNcNQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791904251; v=1; x=1792509051;
 b=G8cZm7L2EOFnvapoCZjVUKxaK7yD+wR/ABlLbZ85P1oSn/kanfQj+IaRYb68C8hwv9RPLFeQ
 t1fFbNd7j9Tb08XnXKRaQ8KnuC4Z7A3aYwlbhhfUtRWjGJfgVBBs3JnQKuw6TVofHSuU29Wbo5F
 nTpvLejvtntVhtzCekpmbQTY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 4d6ae776659dd83d;
	Tue, 13 Oct 2026 15:10:50 +0000
X-Mizu-Trace-ID: 4d6ae776659dd83d
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
Subject: [PATCH v3 1/3] mm: zswap: use separate compression and decompression requests
Date: Tue, 13 Oct 2026 08:09:35 -0700
Message-ID: <20261013151007.2093943-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261013151007.2093943-1-usama.arif@linux.dev>
References: <20261013151007.2093943-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BBA9640007
X-Stat-Signature: 3nbji6uasz6pqoozq134uedn1gzmqm7p
X-HE-Tag: 1791904252-35063
X-HE-Meta: U2FsdGVkX1+kzcUCnjlHHseOirUYo5eTBYQTADCqN5vfaii+QnxDamNUJqcckMPPfpvONrffjv6ZgXVsk1pFzVlIA+y2IpTIcFOE2aHgmP9C5xfo1RkjzFDi/sVf77fVlqwCO7ys9z8pOLmD1p91klR7JGo14qhsNK9p4mR6ZhyuoHBFtm31eAelt1o8j37hjGb6al5HZlI5bykogol/LKSVJWYVlCACCurE0APl3FCW8/YK3ZFM39nEaEUNyTvGA87b+mtg7mC2j8a+TF62c6P4SScmyTZ60aJNECVqWqM0QYEK09wYu9PiVajvszMmKr9xrifqrSgfZVy/64nHe5wAU8h82oKffIR6+Ghti8p/eHRcA9ziPlC7ID0GXxv40yqW/aT9Ligm7nJs5FIjNPdZLdll69UZVefXf3kZAHqhxwnbHH81Q+ghZiIaGhwxCjyq8U23DQq8vO3CIIiswUx5cj4nZ0sUD+HSq20kFNQd1M6n918nIK3Dz/MZEkFQH1a0z0Y337ClCyH/o94CVFU0n7MxGRHE4cY10p7qoD1CrEj77LQhWvZPyVXfyTpBEW//4ErZuuruOqCCqMzSX25LZNXAv3ECsEt7LaTRfPak0Jw/2YY48tdIKk1WyzRkZqvbK+XOE0E6OsRojESpR+P3qj091FB2ODaMLMehD8MqwCumD2diqG/bGq+gROVMeIbNo5YPcGFgv6DzZzlhMCA48AjRaLjvkyR/wu535WpX/Sj1G6YXFTsIR7RnxumPeP5iYTjc/AvM4SwdCM4amB97rISr5OylpqfR63Tn2WK15btonN9J5p9UWQcU7T7hPsWTBynQAFiHyRaAtTQaLlc1Gw59czLV0q06gTtb3NlN9UABZBokepH2pliQnGA9EXufFVzpVUO7XNAzvus2aXb3We7IMCU2S+cKE/wvD+UufCp5arbh08XAmxjmYYFYaRsaoYxMWqQn1q21Fg7
 eYzSU9Lx
 qVQLXe8AfWUVGtECW/a8A1Q4llEF6Y41uDL86k0yTlk0SfpkZe2rkpTeFmYWu/s5vOsupFv9t+wGZXEAJTbVv6kQu9Qr9JUbQ3gRUu83o/1t+hbgSSZ38lII+xO0x4878HxYckRkcoudwXobt5ELWqhR0OorOF4mom9TBtfEMKFUTOpi+gfTh8bKO40rC2Yt/pA7vA7/v29B3gvsczqTnhJEmrSqBdf3f+oAV4PHHTCk/xV2tDW993mhmkVcCIkiZv5CnZ6tt2gxsrof3qCPNTx7vGG3cZ6mHkIYzlaiB3muu4U0=
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

Acked-by: Nhat Pham <nphamcs@gmail.com>
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


