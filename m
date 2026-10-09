Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9744CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 16:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9E2A6B008A; Fri,  9 Oct 2026 12:32:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E75956B0098; Fri,  9 Oct 2026 12:32:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8B2E6B0099; Fri,  9 Oct 2026 12:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC476B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:32:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90EE2A048F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:32:02 +0000 (UTC)
X-FDA: 85303629684.28.6E49D3C
Received: from mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8B0744000F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:32:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ViJ+tb4a;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.12 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791563520;
	b=2SpitFvQ/kkVJ3uyjzwt22U9mQ9XSgpfV1FfN5o0smce8oiNR8aFtQIUfJyhqA72N0JfoF
	cgeLoQZHwcM9HvZgijwdJzFIQEGMNxERV2PIteFrsOC9deiO7q1lwkP1elZfPqEe3S7USC
	FwXSj9WmneT40n2GEnGfNWUOD0RBpBw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ViJ+tb4a;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.12 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791563520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XHKe/oNLdUoPhNmYcnaV7Ox5MtZx10hBYZB69C7mimA=;
	b=T8Vm+MRCYah7J1NgBTEXQB2tzoriS1ITGXbDZKhER12avre32JYwesYdFOkKiVRoqQ/o2c
	Ia4oChDuBrSAjgpziR4y5xmIm8usfzotpV9Vtf4fLkWAt8Fl4EV0vr2gIHGkae5umC+8sf
	W/NyKnCri7CIKArUGeSnhi1QIMFYT9s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Tp5I2SvhZmWxOMIJktdBv2gzK+6jAyJAW9ZaQxpaWes=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791563519; v=1; x=1792168319;
 b=ViJ+tb4apXiT4p0PYRXHROj9EeN7fUMKhohpUAPVZlcpHslZkwo8HqdmtVXv5mw2kU8aPgWl
 9i1QrqgdzNi8AmcRNIThNZCmAAT5iRbhKxxFDPA/TSuHcSniikgIQ3IloxyUlLblP0hJ3Ux9cKZ
 86xM2pqXkUeE1/igkjZEc/Fk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 7de3defa0feb581d;
	Fri, 09 Oct 2026 16:31:59 +0000
X-Mizu-Trace-ID: 7de3defa0feb581d
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
Subject: [PATCH v2 2/2] mm: zswap: use stack requests for synchronous decompression
Date: Fri,  9 Oct 2026 09:30:31 -0700
Message-ID: <20261009163146.83112-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261009163146.83112-1-usama.arif@linux.dev>
References: <20261009163146.83112-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8B0744000F
X-Stat-Signature: ym7cokipritamjnyas9atyqsdkbcz75p
X-HE-Tag: 1791563520-891622
X-HE-Meta: U2FsdGVkX19MQKx7Q+ECgwKQuWJF6Fv139A+1+B2abUkea38O6pFR3dXdFIihYe0R5xkgcA4CsiqcAPrhFCRp43POPs5zJudMNH9wlfx0vfn9YrCGsG1WEuXevbqfL1ER2aT22eTem16twK+Y6qlC7uTaw944kXgWPwE01kULPrTL3ZV9C7fPqbouiyAHioVfI02H20wK6ZhE3ZyDcvEikYw1EgxwM4TvQFa9Wy+rCvpMV6VFiEWFKIsnHebdrhvJmRqpCeVM3uoqCxWwkQ7pB7v3cuM1rkKmF0CYX4nLX1kRFIZJjT+ipaNcXjIWpxk7jQb421nlHvtWwqXZoqiqu3pSCHzufc8XDab28OI3M859dN23i/MP15TC8hiX++HTn1djqT2AFFT7HcBWH/g0pwd6YsjGomu5J33Mfv8Ch96waDgniv8gGTbPAnXnYtuG9bRbIFFk+YyfirrDLluTGw4BYUrkeuRzXI2bv5ow20BOrrZVobE0EvqfBzDRufna4gq7+LQuBIpVv4E6qKgR0cDmX+KH0oCh9ncjgjsadnxGvLwtEldLU2hNLqxbUkRPjn94JKXy2gxYKGMWSGJnuj7YUToev+tJ13az6k/dm1w2UkvNd8SRP5zG1gCLbRvfAHORRCXu8AU9dCe1j8ANixtgoQrZOq9Ul0aEL0aNjArc+pkj+tXQAdCjrtRf4WFozjyOTno9FcLjMNhb62KafSat15WFMFMDCDawpbAg/RVQVrPrlWiYdLR6/Xf9zIPZlUx3ck4u0nq2Us40oUsegTBe/VYvAsq4dEGB7ahaeuqXeQ1Vn7y5FqBd5tk4Yypj8WY5mGA787E4ReyqZJml6qo3Lb1TgMHPaOMWzmOj6+ZF/liiWjvy7IIwYJ+yuuJJKKFX10Vx28BCziZB/+67/0fZmbBrim8kl3PkP7vyplSj7KgaDGMlBpEwkUmYkG8hPOH7OPZHgKKUP5XRFM
 2NYr873s
 8/DRcOkNwpOO9lmB3WCy9ZzQ/l3NqLTcSZaH4F69BSRRqm7+TOaxau6vUX98GNvgaKnDfMn0iD8dpefTF3EskQYsf3oV8pOMbgoTYKMpfSjyAFKo5gEuZP4pEqgle9p3Ur61WxJ5YFbkHDitcyNxUYrD4bkUK6/XctqOWOBRXpIwSvYfs3Rjbv7+hFYHn3xMX2JdfCCdoKbNa/0pOP/mNn/8dQFZmPc3XmAxdyZ4VQZSZCUE9JVKTWhovxbKALadg+9r9
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

Synchronous algorithms whose requests need no extra context can use an
on-stack request, so decompress with one and take no zswap lock. All
in-tree software compressors qualify. Add acomp_can_use_stack_req() to
keep the synchronous and request-size checks in the Crypto API.
Asynchronous algorithms, and synchronous ones with request context,
keep the per-CPU request and mutex, which is still taken before the
zsmalloc read lock.

Reading the per-CPU context without the mutex is safe. Since
commit ef3c0f6cb798e ("mm: zswap: tie per-CPU acomp_ctx lifetime to the
pool"), it is set up before its CPU comes online and is not torn down
until the pool is destroyed. The codecs keep their own stream locks, and
crypto_acomp_decompress() rejects on-stack requests only for
asynchronous transforms, which never take this path.

For software compressors this drops the heap request added by the
previous patch. The on-stack request and wait take 216 bytes, which
makes the load path about 270 bytes deeper on x86-64. Asynchronous
algorithms pay this too.

Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/crypto/acompress.h | 13 ++++++
 mm/zswap.c                 | 87 ++++++++++++++++++++++++++------------
 2 files changed, 72 insertions(+), 28 deletions(-)

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 5d5358dfab734..12c1ce1f6243b 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -203,6 +203,19 @@ static inline bool acomp_is_async(struct crypto_acomp *tfm)
 	       CRYPTO_ALG_ASYNC;
 }
 
+/**
+ * acomp_can_use_stack_req() - check whether a transform can use stack requests
+ * @tfm: ACOMPRESS transform
+ *
+ * Return: true if @tfm completes synchronously and its request context fits
+ * in the storage reserved by ACOMP_REQUEST_ON_STACK(), false otherwise.
+ */
+static inline bool acomp_can_use_stack_req(struct crypto_acomp *tfm)
+{
+	return !acomp_is_async(tfm) &&
+	       crypto_acomp_reqsize(tfm) <= MAX_SYNC_COMP_REQSIZE;
+}
+
 static inline struct crypto_acomp *crypto_acomp_reqtfm(struct acomp_req *req)
 {
 	return __crypto_acomp_tfm(req->base.tfm);
diff --git a/mm/zswap.c b/mm/zswap.c
index 23c4298765795..572075bb1c1c1 100644
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
+	if (!acomp_can_use_stack_req(acomp_ctx->acomp)) {
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


