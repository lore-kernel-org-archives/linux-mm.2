Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A8ABCC6B16
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:11:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FA166B00B6; Tue, 13 Oct 2026 11:11:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0A06B00B7; Tue, 13 Oct 2026 11:11:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671BF6B00B9; Tue, 13 Oct 2026 11:11:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48D226B00B6
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:11:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C370280C4B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:11:02 +0000 (UTC)
X-FDA: 85317940764.18.CBA377F
Received: from mta0.migadu.com (out-20.mta0.migadu.com [91.218.175.20])
	by imf09.hostedemail.com (Postfix) with ESMTP id B2E63140006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:11:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HtGXlp7H;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.20 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQSrN9slFl/gK4aY1b7+WXi/675sMIn9MnuF0iOef18=;
	b=Pp4dqZvsT4cXn/TzD7dqfihh+Kd+Vi/OisnoD3iL5cEnG2pReSn/7DniBj1LQ4mD9lJlSt
	VLYrJfScSCcrvrrawuNZxOV/uKwsh7+8Ew/CcgWMheqX6UnCbwBvGqcUgAx3sAuNslWrAx
	Nz0gVsezTaOCD+DWroi5mEo0OV5kD7w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904261;
	b=v6OfIQ+7uzxiVsYF/4M/ENEhjUOXI1NxWmAUbHDZBntYXUaDN1TM4ZX+VT8eWwQtG1QIj6
	u01To7VH7PWUdrcro6FMHIxKRFCSvb1TdP5YAj7M3bHfc+7vuZXUej52dm0RcdoQrhcK4v
	24zXFx9+y0wxCrIJ/degfvxpqT5R5fM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HtGXlp7H;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.20 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bceBj1lCDVf8rlvw9Pnq+5QiEUpw58usmClWP5+lnkY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791904259; v=1; x=1792509059;
 b=HtGXlp7HdsU1MrQuqwiw9TlpTVxg8+B367C+6XmUokvnjnAmqzJ1bEOJkqSvPrpCLl2Bf5tg
 Cu5ndTkyLR+sOmEKfLBCQabrmiY+9e/NsRG3Re7Y8rKhGYGpbNUrqTFp4wsn8MEIJpY4d10N5OU
 TtLbv+nctJHKnxQWVxsYfwZ4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 3d5937a095650203;
	Tue, 13 Oct 2026 15:10:59 +0000
X-Mizu-Trace-ID: 3d5937a095650203
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
Subject: [PATCH v3 3/3] mm: zswap: use stack requests for synchronous decompression
Date: Tue, 13 Oct 2026 08:09:37 -0700
Message-ID: <20261013151007.2093943-4-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261013151007.2093943-1-usama.arif@linux.dev>
References: <20261013151007.2093943-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B2E63140006
X-Stat-Signature: uw6mmuyarkr11c3dr9dw38gb134kgjwc
X-HE-Tag: 1791904260-884082
X-HE-Meta: U2FsdGVkX1+CvlijhEC7eJMeI2IDh4X0iAXhewxnCfmEGbzJL5xjNcMNn4EuVtKf4DiEYxTMPK0u/7uj2sVq0jWGizYbmdNm1YkW46KVgkZ/RPj6RLnHIKneYaSW1sYhjp/PVkeI7ZTNcTINsBz/gfTW+CWnh+XW+8QlBSi19RsdiHo0dKZCjyGv6hFvdSaSxAe3LLSqZtZrfmTI+sQ5A0Z7gXHzGQpjMv/qDqSXi/YJo2FkEZgNlRDMryV/Sdzv4J4p20Vmvv+4a3vPjvf6butPwtrf2D97Zu5mHzUJw3mg+znWVJqni0YfEcZ26SGet/b5mC4mlG3QxyqCNVCnd7sRDiTiX8Uus9ZoO8FgNK71GkpcRTpTmoaHhRhMx+Ecv4btC29kLa/AP32VutwHT/0pRqLA6d9E7Sae8IaJQShFnWt21lgrTN4MGLP5LTcnDTVZrxrG9rY4tLUoIhbAWirHGwadQGiYzFrdRXCDB7OXLMtSS3q/mJtI5lQSCEUcyO6MbVYO1LSQnaSaazqQ0C08I8IsFipHySyVY2hCcykWJmYpN3G/WANEh+VLRMb/J+qV95bKOCU9JijyH9yC3+7D6Dhsp1yWcxtxlXdNdg9N9FYqzET1TumAWGwVyd12hPZ8tsKeqbI5Qh32Ms1hFgE/Dv9ak4vzId3YAQhSvnw+SFS/Zk9LLGUBn2fQ9YhMQTd9f3KJmyAakij6eeWqUildf+VnStKb9ho6q6IFllQ1EZf88PpB+dRE81m7v2VJu6rhSm4nPrl/rBQ5pA5dt9x6tkKH5Jf5fHOLixdtgfLtD0h00aFBCqFyAJYNmvWoCKFoa8zj4hjtptIa8kA4j8B5DknnmBS4mgfgLVIMvZMr6v+Z/As8AFEgtf//jlCGsr0id5sih9e0tWB1MLY0l2Id87oVSvcQVz3p6bOAGGLZQ2bkphznHTzIRF8HcdyV84c3toHebI/5P5Ubp2P
 /Zi/ONcN
 F5ZTvLmnvX8+HaFg6s8Q7ZWv+LDDZHpKBSbzrSkFI2EsY7bzYK0thcplwuWDkau+PwGrWqKOydDJSD96cnWw7PkR9CHsD/gP4U8M0xHrn0iqMuqmpSVGtYRvNG08XFXNR84RUZmHXMME5NRSCGTSxf642oT3wmt1ZcVpTPxbNdmbGFfZZgFk5lEqkMihqFXzJv9e+08tw68ctKXi1MkQFUfkplBIIhZnWhUoB+n507saNy/TaNMkijHpEZ7Uk0GBRs2g3
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
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/zswap.c | 87 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 59 insertions(+), 28 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 23c4298765795..beacdf83c8b31 100644
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
@@ -856,15 +861,19 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
-	if (zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp) ||
-	    zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)) {
-		pr_err("could not alloc crypto acomp_request %s\n",
-		       pool->tfm_name);
-		goto fail;
+	if (zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp))
+		goto req_fail;
+
+	/* Skip the per-CPU request when decompression can use the stack. */
+	if (acomp_is_async(acomp_ctx->acomp)) {
+		if (zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp))
+			goto req_fail;
 	}
 
 	return 0;
 
+req_fail:
+	pr_err("could not alloc crypto acomp_request %s\n", pool->tfm_name);
 fail:
 	acomp_ctx_free(acomp_ctx);
 	return ret;
@@ -956,19 +965,14 @@ static bool zswap_compress(struct folio *folio, long index,
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
@@ -985,15 +989,13 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
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
@@ -1007,6 +1009,35 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
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


