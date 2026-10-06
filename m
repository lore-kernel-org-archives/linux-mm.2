Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E182CA5FFE
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 00:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4257D6B008C; Mon,  5 Oct 2026 20:23:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C40B6B0092; Mon,  5 Oct 2026 20:23:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1656D6B0093; Mon,  5 Oct 2026 20:23:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB2CF6B008C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:23:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2516F404C6
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 00:23:19 +0000 (UTC)
X-FDA: 85290302118.01.D479E92
Received: from mta0.migadu.com (out-69.mta0.migadu.com [91.218.175.69])
	by imf25.hostedemail.com (Postfix) with ESMTP id 033CFA0005
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 00:23:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="RO/J0/l0";
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.69 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791246197;
	b=i7R9bDHvDazOk58lq8xo9iWOQGN6muwLSufvPDJZVgorG4F/9YFTfWPE49sm4XCuzRbAH/
	Jww3eLpueW+icQKkSYq6WmYLgJVzcE/lTdrxF3n8EznPjbtXF8qQ9CS42U9/CtW3UwjU5H
	ZHD+z2d+BR96eINE4s2lIVaZMEW3E1U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="RO/J0/l0";
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.69 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791246197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pPjC2gltIGWLShBycgpG5tzKye6+dleiVP/ZVexhUNA=;
	b=D2Zdr/vDpzt8eIiti2mSBkMURKJZ3GyKrFw/OTA46m6Y+KfnobdRIw2uZurOXsxB1+/eTR
	sf4rHAKUlocWnej2vRC7rUajgthGrtOT74O96fl0HHprtBRX8krCM5CFX/xU8qMyFiG0yd
	fHEs+IcaxX1Bm7nQoCXiVYZ1z6Mo0yo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=P0176Esu0HHun/DWLJ1GER3m0qS1HWmjGzYArbHIIgg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791246194; v=1; x=1791850994;
 b=RO/J0/l0raGiU0QBbB7j+CAwdjo+59BjursZYJU97TGHtRfPm3WSA5Q6ZLGR7tHrH+aWJAz7
 PfoTLOzUs6FDyzbnA6FNYPamPPKwZIFWi1q/SY1Po1cTHH4vPO+kve9jgujNtJ70m8ltxEYaA4u
 qTaCFEXEO8s2w8m1IBQVnxVI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id fd89e3a9f498a6ac;
	Tue, 06 Oct 2026 00:23:14 +0000
X-Mizu-Trace-ID: fd89e3a9f498a6ac
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
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 1/2] mm: zswap: use separate compression and decompression requests
Date: Mon,  5 Oct 2026 17:22:50 -0700
Message-ID: <20261006002307.2669023-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261006002307.2669023-1-usama.arif@linux.dev>
References: <20261006002307.2669023-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: unrn4w6x59josm4a6d1muxm7583soe4o
X-Rspamd-Queue-Id: 033CFA0005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791246196-763953
X-HE-Meta: U2FsdGVkX1+lE5bD6dS1LrUz8VTqsDzq6ftvNFJZ3d24PoJtNTCjfbWPkCwKwQseIYBwgXYBOJnooCiHit5t2jxzuZirO2WukPLdWnPWl71hihpwlM5Mwfezqf+Ped+l5cjLBlPLLwAZ+A906o0B4IoSQhdP+uGrx0pqDa+tkDBtnkbjJn3G4RVjS/XhtIr+kaY+H7lsnlrcUdJCvzmwVbTTFGCVCdUYHTSAoOnTT3/emavCQ1KIwP/PAe46cOyII/BTuNFPtwU7EqD/hyPN8qrJYOxDO8XwjMNZSC28BwtnVpTqhtr7Zs0F5kPX7nsPnvwNJqxn/qvnbfQaGIpq4SegLib3Anf00X58XJCdN5lStKnpEb7rjpXU05sUD4vS1bx151T9pzj+Shblb1csNIf5+ZLsViN6Aj++RieuiKsjv/egC08ULeZ/7oMwjbbWUBhADSj91xFxonQWdVacxDj4PaAY8MDsw5D/xjKo8ENVmlWs1xchTC5VNVO32k/vGnaBT2/ZnODhzQOgwuOYpfRAwl26wLbvX6taMldwFhRi4pdG8FGIzSkN1MUDoO6LXBXM91o4DyotihqxZT3ImNgJgVhN+Pf6lbzbXJj36jVAk7fftR97pZiyCa8c2adSu+RlK9PAhqPKAh6WzdHoXhZbWdVoMek6Fmol1nriSJ+F9ZlzSOK6vx/P6yPJIKFlFUgPfHzvPTicQaWT7X6xKdhLiZa/4OL0QnHh8mUmT/mjRnrx2VMjOh+k156ior0Y0s4IMNHJgI3mSRWOKDn+r3Rsm42cAgwslO/aksKqpPEFNaYoCTvMZziawKA6mfX/Q9qhEF5JsVbAtZrjsaQQlx7dTmJ4flVtNRscwlJHQNYRanX5P0CxhOI9xL7NMQmGpSGHGPwshGPNim3h5rnaU95Yjq+vbU9dtyBkMnEOaFHJ4XIgxJJfJZv5lDdGEkSeUpdvF7WY4A5Z3lI4cqy
 3uA4/xia
 uCNIZJPKI7KDrdrr3WrZSbtFfW+9XQj4XoibU+LjyD5H2FRBjD6omoWMJjHwoaGpFRnDSgznh5weW+7MbdJg9QdqNX1Yo/TFrsMyGiT3xfrmDpkmt/CfnP2aVhadeCdnQ3awmpyvSzowVV5ijvLidP9W2lOJJvj1g52rCGpkFfUhgX5bDCq3TJjPK0devf2TdyTHpgKGP5Dwb4PZsaEX3oCVFGqe0BG8b3BbnhjUM46meT5IyN2j/GgKF8orD7QstnSjbyUS9mP4/fDLi3h4fHD1lIQ==
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
compression. The two requests can share the per-CPU transform: no
in-tree implementation modifies transform state while (de)compressing,
and shared codec state has its own locking. Loads can still wait for
each other on the decompression mutex, and stores still serialize on
the compression mutex.

This follows the proposal from Sergey Senozhatsky for the same split
for zram [1].

[1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/zswap.c | 89 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 37 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index ae19e301fced7..54187b1ef751d 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -137,14 +137,20 @@ bool zswap_never_enabled(void)
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
 
+/* Separate requests, so that decompression does not wait for compression. */
+struct crypto_acomp_ctx {
+	struct crypto_acomp *acomp;
+	struct zswap_acomp_req comp;
+	struct zswap_acomp_req decomp;
+	u8 *buffer;
+};
+
 /*
  * The lock ordering is zswap_tree.lock -> zswap_pool.lru_lock.
  * The only case where lru_lock is not acquired while holding tree.lock is
@@ -270,14 +276,10 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
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
+	acomp_request_free(acomp_ctx->comp.req);
+	acomp_ctx->comp.req = NULL;
+	acomp_request_free(acomp_ctx->decomp.req);
+	acomp_ctx->decomp.req = NULL;
 
 	/*
 	 * We have to handle both cases here: an error pointer return from
@@ -796,6 +798,28 @@ static void zswap_entry_free(struct zswap_entry *entry)
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
@@ -827,25 +851,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
-	/* acomp_request_alloc() returns NULL in case of an error. */
-	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
-	if (!acomp_ctx->req) {
+	if (zswap_acomp_req_init(&acomp_ctx->comp, acomp_ctx->acomp) ||
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
@@ -866,14 +878,15 @@ static bool zswap_compress(struct folio *folio, long index,
 	bool mapped = false;
 
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-	mutex_lock(&acomp_ctx->mutex);
+	mutex_lock(&acomp_ctx->comp.mutex);
 
 	dst = acomp_ctx->buffer;
 	sg_init_table(&input, 1);
 	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
 
 	sg_init_one(&output, dst, PAGE_SIZE);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
+	acomp_request_set_params(acomp_ctx->comp.req, &input, &output,
+				 PAGE_SIZE, dlen);
 
 	/*
 	 * it maybe looks a little bit silly that we send an asynchronous request,
@@ -885,10 +898,12 @@ static bool zswap_compress(struct folio *folio, long index,
 	 * existing method to send the second page before the first page is done
 	 * in one thread doing zswap.
 	 * but in different threads running on different cpu, we have different
-	 * acomp instance, so multiple threads can do (de)compression in parallel.
+	 * acomp instance, and compression and decompression use separate
+	 * requests, so multiple threads can do (de)compression in parallel.
 	 */
-	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
+	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->comp.req),
+				   &acomp_ctx->comp.wait);
+	dlen = acomp_ctx->comp.req->dlen;
 
 	/*
 	 * If a page cannot be compressed into a size smaller than PAGE_SIZE,
@@ -932,7 +947,7 @@ static bool zswap_compress(struct folio *folio, long index,
 	else if (alloc_ret)
 		zswap_reject_alloc_fail++;
 
-	mutex_unlock(&acomp_ctx->mutex);
+	mutex_unlock(&acomp_ctx->comp.mutex);
 	return comp_ret == 0 && alloc_ret == 0;
 }
 
@@ -948,7 +963,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 		return false;
 
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
-	mutex_lock(&acomp_ctx->mutex);
+	mutex_lock(&acomp_ctx->decomp.mutex);
 	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
@@ -965,15 +980,15 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
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


