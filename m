Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4B08CCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 16:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ACF56B009B; Sat, 17 Oct 2026 12:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E7716B009D; Sat, 17 Oct 2026 12:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224836B009E; Sat, 17 Oct 2026 12:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E57176B009B
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 12:09:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 741521202BB
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:09:42 +0000 (UTC)
X-FDA: 85332603804.14.45F5A37
Received: from mta0.migadu.com (out-226.mta0.migadu.com [91.218.175.226])
	by imf07.hostedemail.com (Postfix) with ESMTP id 793F540008
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:09:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SxL0rFuV;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.226 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792253380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNKI+4u98UzMp+RO55QUcLTL2hkjk2c+4uUiK+3ciAM=;
	b=H72VMyu7jymH9xR629xfQekB0uxSsXgFHK8p0lejbwP6sBftBbXoFoSY/Ccob8OvTvllGv
	T/voVxu5gv7PS7yB05TG+Jbw3vIC4vx4H+gPNTJWYmyoIoJQpNMwBZ84yqD0sgbxyL+xvE
	SiD992hPOhh3uRWONB9oD6Jm7CIMFjc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792253380;
	b=agFoE8VZm44tP2GIWKSJrshhhNEm4yui398pC/5iz93ntoA51xAOf9KLurEZVz4Qz8hUOP
	IhKkyynzc4PVWVZd9hL5thtjb9z73USHCOzAx1VVBhvxTzx/q+TZavBal1cLXvhZyFEtF5
	zfWpN6gXZ/l61lyu2x2ybbvYB+dydxY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SxL0rFuV;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.226 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ltpTa2mf6PRtR23DlzBjVmfp/75+5bWbp6ul/TgSi34=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792253379; v=1; x=1792858179;
 b=SxL0rFuVMQP0EO3GmOhcrCVGwUvWzRETtpG1bLyETPxcqtdIzxts4y7qpe8aVY2MD05p7VAa
 Za+gdHsqvmay0WKWlvgnJj77dkPD3Jl388+TfKFv67YEPJb2hr1ezkfJ39HiPQDEHwJaoSNM7/e
 Mnh1rr/5Byu4MK220H4JBvnw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 160a6d75655b9c7b;
	Sat, 17 Oct 2026 16:09:39 +0000
X-Mizu-Trace-ID: 160a6d75655b9c7b
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
Subject: [PATCH v4 3/3] mm: zswap: use stack requests for synchronous decompression
Date: Sat, 17 Oct 2026 09:08:55 -0700
Message-ID: <20261017160918.2738626-4-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017160918.2738626-1-usama.arif@linux.dev>
References: <20261017160918.2738626-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r93ccfem5ew7egofkkcwfbqywb9696px
X-Rspam-User: 
X-Rspamd-Queue-Id: 793F540008
X-Rspamd-Server: rspam10
X-HE-Tag: 1792253380-896324
X-HE-Meta: U2FsdGVkX184QlA/4UYb6hKYGmbFfmP8M/CeWWykCQKZaZ9XFqhQa/PX60S8fKkN4ZyebyC9IXjaKIg/qdszRs5yytrsBSSBhgguuzB0UHJlXxumewkad3+3E44zCzl5LMMai74+fDKF/WUmiC0PunFWhp+GyjRS1t96UcrWeUOWND83P+a4PEMO66t+xRx4UFS6+q36z0gDjs60aH5hx7xwHMbyem93/8toolP8Iqxs/WryGp60NbVt5ohe8CheooS4CZGI15gCUbbSu9l7zoWhEjF980AnfB1jhUR9AbSRRlGgI6+BXdqnVaksbOIfjJuLKj/pypf8U6XbGyUdf/6bYDAnc4twyTbHfpjQriW4ncS93bR/QeS5BLOX191oXbzYauFjbn0beQZypW7J3sAEc7AYY5GMSohuzv3RMrHfXn206nxbBTTPice6hJYvga1VDSbFHF+sifSKgGqWFvZRQGqM7vMTTcJOfkHS3kTbwzcT1f99HI+oauVQDaH/0BC7VjE7N0DfCSy3vwFopCjAUUkAvt7nli/j+QF4PCmm7KmPDiY4/IsssvZRj65RZunP0mdfXe2rBScHkr+8uAHprD1SaO+mCbN3kIKQp8/ewavmN1VKwDXWCfHZkYqU/8c1/ekzF4Qq3/OnY08qiPjQA2/Y/zC6zrNILcq8RX/zH3uqB7MzxWDasAvtlTwsH5JKzh2rzCNkLcVySS7gpZk9fpxg3oVcVr4CUDbrIDV7rNFTncnnoToTQLa18QttM3RZnjUCxZS72S+cecxS7bmgHeUQHVhqTyCtoZUHUUavEgEFWS+tBGgXI3YndUdCwdjmv6nrjFVin6C/wxb7JI6f7u98jRSR1eKWTCu14/1UNFtzv4e4rx/WaZnfU5f/1mkBvjhhhU0b5qmXP3WswjC2eMKS7O2VutS7YBDTXRZFeurNcEPnROybJA62bbCTzQLlkQ513s2i6W2K5fh
 PdZWnhTU
 ZwGrKnn11LrkNEOTXJw/nZezPOGotoyBCHKrgWKUFh4X2g5m/PgdYauTJuv4GlHCskjTc2b0rdNjyvgoaXcWZ/xXhTNoSsYEdzgzU5yC4knShf73Ej2a8aJRkz7X8mvZrAPpDmmwVbhqbDKN3l36QS/x52Co+lwzFj3D1Vh6/jayqroyDq5bjfZ2qw2q0dAvS5i5IDCiyi1TaszlCewETuIQHNjB2sW5/gq5Zb1A8suXDQLeFi9Vxa1RmIbGjIGhcUiROB3MT5kmHtybu7WqgQQr9Bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With separate requests for compression and decompression, loads still
serialize on the per-CPU decompression mutex. A low-priority load that
is preempted after the codec drops its stream lock keeps holding the mutex
and stalls every other load on that CPU, including higher-priority ones.

Synchronous algorithms can use an on-stack request, so decompress with
one and take no zswap lock. All in-tree software compressors qualify.
The Crypto API enforces MAX_SYNC_COMP_REQSIZE during initialization,
so checking acomp_is_async() is sufficient. Asynchronous algorithms
keep the per-CPU request and mutex, which is still taken before the
zsmalloc read lock.

Reading the per-CPU context without the mutex is safe. Since
commit ef3c0f6cb798e ("mm: zswap: tie per-CPU acomp_ctx lifetime to the
pool"), it is set up before its CPU comes online and is not torn down
until the pool is destroyed. The codecs keep their own stream locks, and
crypto_acomp_decompress() rejects on-stack requests only for
asynchronous transforms, which never take this path.

For software compressors this drops the heap request added for
decompression. The on-stack request and wait take 216 bytes, which
makes the load path about 270 bytes deeper on x86-64. Asynchronous
algorithms pay this too.

Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/zswap.c | 82 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 56 insertions(+), 26 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index b23ef5f3bd529..9cb75215b2703 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -153,7 +153,7 @@ struct zswap_comp_ctx {
 struct crypto_acomp_ctx {
 	struct crypto_acomp *acomp;
 	struct zswap_comp_ctx comp;
-	struct zswap_acomp_req decomp;
+	struct zswap_acomp_req decomp;	/* unused with on-stack requests */
 };
 
 /*
@@ -803,6 +803,18 @@ static void zswap_entry_free(struct zswap_entry *entry)
 /*********************************
 * compressed storage functions
 **********************************/
+static void zswap_set_acomp_req_callback(struct acomp_req *req,
+					 struct crypto_wait *wait)
+{
+	/*
+	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
+	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
+	 * won't be called, crypto_wait_req() will return without blocking.
+	 */
+	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   crypto_req_done, wait);
+}
+
 static int zswap_acomp_req_init(struct zswap_acomp_req *areq,
 				struct crypto_acomp *acomp)
 {
@@ -812,14 +824,7 @@ static int zswap_acomp_req_init(struct zswap_acomp_req *areq,
 		return -ENOMEM;
 
 	crypto_init_wait(&areq->wait);
-
-	/*
-	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
-	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
-	 * won't be called, crypto_wait_req() will return without blocking.
-	 */
-	acomp_request_set_callback(areq->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				   crypto_req_done, &areq->wait);
+	zswap_set_acomp_req_callback(areq->req, &areq->wait);
 
 	mutex_init(&areq->mutex);
 	return 0;
@@ -860,9 +865,12 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	if (ret)
 		goto req_fail;
 
-	ret = zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp);
-	if (ret)
-		goto req_fail;
+	/* Skip the per-CPU request when decompression can use the stack. */
+	if (acomp_is_async(acomp_ctx->acomp)) {
+		ret = zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp);
+		if (ret)
+			goto req_fail;
+	}
 
 	return 0;
 
@@ -959,19 +967,14 @@ static bool zswap_compress(struct folio *folio, long index,
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
-static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
+static bool __zswap_decompress(struct zswap_entry *entry,
+			       struct zswap_pool *pool, struct acomp_req *req,
+			       struct crypto_wait *wait, struct folio *folio)
 {
-	struct zswap_pool *pool = zswap_entry_pool(entry);
 	struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 entries */
 	struct scatterlist output;
-	struct crypto_acomp_ctx *acomp_ctx;
 	int ret = 0, dlen;
 
-	if (WARN_ON_ONCE(!pool))
-		return false;
-
-	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-	mutex_lock(&acomp_ctx->decomp.mutex);
 	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
@@ -988,15 +991,13 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	} else {
 		sg_init_table(&output, 1);
 		sg_set_folio(&output, folio, PAGE_SIZE, 0);
-		acomp_request_set_params(acomp_ctx->decomp.req, input, &output,
-					 entry->length, PAGE_SIZE);
-		ret = crypto_acomp_decompress(acomp_ctx->decomp.req);
-		ret = crypto_wait_req(ret, &acomp_ctx->decomp.wait);
-		dlen = acomp_ctx->decomp.req->dlen;
+		acomp_request_set_params(req, input, &output, entry->length, PAGE_SIZE);
+		ret = crypto_acomp_decompress(req);
+		ret = crypto_wait_req(ret, wait);
+		dlen = req->dlen;
 	}
 
 	zs_obj_read_sg_end(pool->zs_pool, entry->handle);
-	mutex_unlock(&acomp_ctx->decomp.mutex);
 
 	if (!ret && dlen == PAGE_SIZE)
 		return true;
@@ -1010,6 +1011,35 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	return false;
 }
 
+static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
+{
+	struct zswap_pool *pool = zswap_entry_pool(entry);
+	struct crypto_acomp_ctx *acomp_ctx;
+	bool ret;
+
+	if (WARN_ON_ONCE(!pool))
+		return false;
+
+	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
+	/*
+	 * Use a private on-stack request when the transform supports it.
+	 * Otherwise serialize decompression on the shared per-CPU request.
+	 */
+	if (!acomp_ctx->decomp.req) {
+		ACOMP_REQUEST_ON_STACK(req, acomp_ctx->acomp);
+		DECLARE_CRYPTO_WAIT(wait);
+
+		zswap_set_acomp_req_callback(req, &wait);
+		return __zswap_decompress(entry, pool, req, &wait, folio);
+	}
+
+	mutex_lock(&acomp_ctx->decomp.mutex);
+	ret = __zswap_decompress(entry, pool, acomp_ctx->decomp.req,
+				 &acomp_ctx->decomp.wait, folio);
+	mutex_unlock(&acomp_ctx->decomp.mutex);
+	return ret;
+}
+
 /*********************************
 * writeback code
 **********************************/
-- 
2.53.0-Meta


