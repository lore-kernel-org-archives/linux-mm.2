Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DE89D262AD
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 01:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F66F6B0005; Tue, 20 Jan 2026 20:36:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CDE36B0088; Tue, 20 Jan 2026 20:36:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1BBE6B0089; Tue, 20 Jan 2026 20:36:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2CF56B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 20:36:35 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E8C4C1C97
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:36:35 +0000 (UTC)
X-FDA: 84354256350.03.8EE6666
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 86E3140004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:36:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HBi66FL3;
	spf=pass (imf17.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768959393; a=rsa-sha256;
	cv=none;
	b=RyepEoYcM1vtRQqYuL9wkw1XRnF9TlyZhXy9SsVszgOyKurVraJIzDXdcCi1ZDc8CdiTt6
	vWQhcGAGiSFrtdI1OzA0NIGTss35swbhg6VC1yZjAohZPEYFrgCkQHTu1bBYJ0S7DLLSTB
	vUxeL5UHLcXehQntlMC17Eh2PowXU4I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HBi66FL3;
	spf=pass (imf17.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768959393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+IolQVkF+7UTpDVewB/Y2bOjTacpO437CdsV4Ah2nrY=;
	b=IF4y/FmrcwWC/zPlbB3+Nqx5x5tihwEiiQ/P+EgE2cfmSbOxBdvO+8E9WvzSNEET8NVqS1
	cU4vAWCZXrD3v1/zWM8Fo5rSeoPBjD+NyrRTASkxqSAIdPvlocIVglTxxIhdAQdqcwBImD
	crHwrI5fW8UxISBA6HvGY1D1dMpLkz4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768959391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+IolQVkF+7UTpDVewB/Y2bOjTacpO437CdsV4Ah2nrY=;
	b=HBi66FL3kiW2dq0oZq81qI1Ia79wPYUpGTNiVC+kShReCTOQzSdZ0oBnyko1enQLLLcyQR
	fy+6jMDQzE+9rFjFw9drVv9MEHs+LGw/3Xn+YC3mnDUUgUSjN/D6+WXwmaZGRyCsjsxD/Q
	Aio7KMDAwxXYsYSzWccGmVxwlbv8lMQ=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH] mm: zswap: Use SG list decompression APIs from zsmalloc
Date: Wed, 21 Jan 2026 01:36:15 +0000
Message-ID: <20260121013615.2906368-1-yosry.ahmed@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 86E3140004
X-Stat-Signature: jmwpwudi85n9iipubdznoguhrrwqbheh
X-Rspam-User: 
X-HE-Tag: 1768959393-137277
X-HE-Meta: U2FsdGVkX1/qBA1zXTKpimYu2+G43iWSFxIEwwPJfyaZBqlAJazcT9wC80Cj/U8rzXV2xPt81OfE6lSaDKZWYT25fL/ds5u8/kYHxALXRJCV2Mm3GMaZf/PzWpcR4O4Y9O7QqVpab02HyGe1RU/Pnu/tFxOFT71HPzF1iaWEJ4lHgp/IvEHdbTOyIubZsdY+4iVwjvkPiYTW5nVaUMtxhnQ2Y4AZPxiEVd4jzFw4deOQQBfuy//ax2YtkRo9LSixvqYVshVCMVR20K2B2kveqrUFetN8sdhahItAkfefql9EJ+jHPUKUHxGuI8dxbGk22ibO3H+8IVhzNp2xiZiIzrKoAG7dyE2LTvtFBPwBHgVNnV5xt8VJ9Un8ZJT2jgYXxHzqmvnMtrml6/DKUzlDvtc97vGW1HZA6oEkctLn+mnTgASIYr24BbAxpAskYoh3/8Jfc9dn3/8UnDz6W715JJqhSzl7s6FoI7n5yhxd3jeNNxM2a/sEGwd5rOjkYRnA+WL+RvzmzzOwTydsTFbk/7aGI5ZpPG/4AoJKbCB2s4XnNLhKBXVpxTOluMQ8RWLIKLY8yDrcfVrYXU7yuNI4CuCGecz2GCv0JF6gM+fyyNewP3uQo+Br2O0BKMUUec9P8IwWySWdFAgQyBYMk57EoroM8ORF3XPv+jOQlV62VOLUW+qmw/SMckgQstYbNsvqAOS/NZtwXtNJ6dByB7+ZpazGyt/9Oa9pnY3Q9+m11sOJFXXUCksBuemtIGayJJ0Ku8uflgzXp3JB/vO33nZRwLwRD2Ukt+JWy6uSoG46JzzrrQPJN8iMyKpfwG74eUGQAHkxK3rZGXOd8zvtN+cJd+vdHkpaEV+eG4odES4LN3RgdyTPVFjFt9tgNqmzvinGHsJVRFiRAbsHUZdx4RbYJNeHdA4fuxNHskSbu1n62+UY1dBOe3MWHRIKcWiz7RMKLujqUeNQTZBC41JZnvf
 zzjk7A9o
 vTcjGq7SdS52S8loviBpD3TpcMJ/nKqHJnnz4HU6/IoXjAHa2jqdx9S4psBfSIpVNV5F8p2ZePEuK6O0x/zTKTneBf7aZbuRG6vrqQ5dSKYaljFZ1uLFcTNHh0JuCPaP9gj40XWEHAiB5ixPoxDKbE1sCToXMI8xOEuVMtF+YzPQD+hiSLHoce8uppDH29WAjwtvPKolr8Pv5bVlYDJEzetuxRjdl+mP70dTGVNyDuN8ORnz2X3OEtZuhTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the new zs_obj_read_sg_*() APIs in zswap_decompress(), instead of
zs_obj_read_*() APIs returning a linear address. The SG list is passed
directly to the crypto API, simplifying the logic and dropping the
workaround that copies highmem addresses to a buffer. The crypto API
should internally linearize the SG list if needed.

This avoids the memcpy() in zsmalloc for objects spanning multiple
pages, although an equivalent operation will be done internally by
acomp/scomp. However, in the future compression algorithms could support
handling discontiguous SG lists, completely eliminating the copying for
spanning objects.

Zsmalloc fills an SG list up to 2 entries in size, so change the input
SG list to fit 2 entries.

Update the incompressible entries path to use memcpy_from_sglist() to
copy the data to the folio. Opportunistically set dlen to PAGE_SIZE in
the same code path (rather that at the top of the function) to make it
clearer.

Drop the goto in zswap_compress() as the code now is not simple enough
for an if-else statement instead. Rename 'decomp_ret' to 'ret' and reuse
it to keep the intermediate return value of crypto_acomp_decompress() to
keep line lengths manageable.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---

This patch depends on "zsmalloc: introduce SG-list based object read
API":

https://lore.kernel.org/linux-mm/20260113034645.2729998-1-senozhatsky@chromium.org/

---
 mm/zswap.c | 49 +++++++++++++++++++------------------------------
 1 file changed, 19 insertions(+), 30 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 2f410507cbc8..aea3267c5a96 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -26,6 +26,7 @@
 #include <linux/mempolicy.h>
 #include <linux/mempool.h>
 #include <crypto/acompress.h>
+#include <crypto/scatterwalk.h>
 #include <linux/zswap.h>
 #include <linux/mm_types.h>
 #include <linux/page-flags.h>
@@ -936,53 +937,41 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 {
 	struct zswap_pool *pool = entry->pool;
-	struct scatterlist input, output;
+	struct scatterlist input[2]; /* zsmalloc returns an SG list 1-2 entries */
+	struct scatterlist output;
 	struct crypto_acomp_ctx *acomp_ctx;
-	int decomp_ret = 0, dlen = PAGE_SIZE;
-	u8 *src, *obj;
+	int ret = 0, dlen;
 
 	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
-	obj = zs_obj_read_begin(pool->zs_pool, entry->handle, entry->length,
-				acomp_ctx->buffer);
+	zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
 
 	/* zswap entries of length PAGE_SIZE are not compressed. */
 	if (entry->length == PAGE_SIZE) {
-		memcpy_to_folio(folio, 0, obj, entry->length);
-		goto read_done;
-	}
-
-	/*
-	 * zs_obj_read_begin() might return a kmap address of highmem when
-	 * acomp_ctx->buffer is not used.  However, sg_init_one() does not
-	 * handle highmem addresses, so copy the object to acomp_ctx->buffer.
-	 */
-	if (virt_addr_valid(obj)) {
-		src = obj;
+		WARN_ON_ONCE(input->length != PAGE_SIZE);
+		memcpy_from_sglist(kmap_local_folio(folio, 0), input, 0, PAGE_SIZE);
+		dlen = PAGE_SIZE;
 	} else {
-		WARN_ON_ONCE(obj == acomp_ctx->buffer);
-		memcpy(acomp_ctx->buffer, obj, entry->length);
-		src = acomp_ctx->buffer;
+		sg_init_table(&output, 1);
+		sg_set_folio(&output, folio, PAGE_SIZE, 0);
+		acomp_request_set_params(acomp_ctx->req, input, &output,
+					 entry->length, PAGE_SIZE);
+		ret = crypto_acomp_decompress(acomp_ctx->req);
+		ret = crypto_wait_req(ret, &acomp_ctx->wait);
+		dlen = acomp_ctx->req->dlen;
 	}
 
-	sg_init_one(&input, src, entry->length);
-	sg_init_table(&output, 1);
-	sg_set_folio(&output, folio, PAGE_SIZE, 0);
-	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
-	decomp_ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
-
-read_done:
-	zs_obj_read_end(pool->zs_pool, entry->handle, entry->length, obj);
+	zs_obj_read_sg_end(pool->zs_pool, entry->handle);
 	acomp_ctx_put_unlock(acomp_ctx);
 
-	if (!decomp_ret && dlen == PAGE_SIZE)
+	if (!ret && dlen == PAGE_SIZE)
 		return true;
 
 	zswap_decompress_fail++;
 	pr_alert_ratelimited("Decompression error from zswap (%d:%lu %s %u->%d)\n",
 						swp_type(entry->swpentry),
 						swp_offset(entry->swpentry),
-						entry->pool->tfm_name, entry->length, dlen);
+						entry->pool->tfm_name,
+						entry->length, dlen);
 	return false;
 }
 
-- 
2.52.0.457.g6b5491de43-goog


