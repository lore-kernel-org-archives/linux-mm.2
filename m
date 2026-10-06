Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74EEECA5FF5
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 00:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647C46B0093; Mon,  5 Oct 2026 20:23:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AB1E6B0095; Mon,  5 Oct 2026 20:23:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4728A6B0096; Mon,  5 Oct 2026 20:23:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9FFB6B0093
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:23:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 629B380505
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 00:23:21 +0000 (UTC)
X-FDA: 85290302202.10.36CF187
Received: from mta0.migadu.com (out-71.mta0.migadu.com [91.218.175.71])
	by imf26.hostedemail.com (Postfix) with ESMTP id 73B80140003
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 00:23:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YonuEzSv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791246199;
	b=iNMsEQFM+vxf7As0wrA1/zkDRz5Aoqg7+odI7pjFDmW69wlwnzzJL4O8hbtZFEV5JK5a0B
	c6WBI8Y1oEmMX6v0NgIcrwqlnqJoaRaVeXk1xJ/KTJiMPc8XqloQgoJZ/c81HAzTsHrYfn
	Ry3q53zM//2k8Z1huAO+OUAaNlSn2I0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YonuEzSv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791246199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4EU20wDq8IDODZu9ohVxmjwkXNAS65twLINssHMbT3I=;
	b=Hx37zhLhu00wi0FLWKPd/uesu4rGdwR7wKS+GySOBzpJiMeUZng2L8zibG6G4uu5ukl2hr
	5SeaEWL2kFuzX1WJ9HVz8XKGybW+pP5naA99wiYNqE5wYA/yIVxnEoWyLGyEQ0ANlfdkhO
	SLD41ODn3rA/wiTCe2sYwThGMc5f8gk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nbJqiGn5pFkuXQBzYRivhDJLdV+pjGcePbifZ588ksg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791246196; v=1; x=1791850996;
 b=YonuEzSv6V1v6uLsWV1icfYMJZIDBdS3eiCoHZ/IFoawKjlt19ojM8GpCMaQelsqxqAtg2RB
 k0Y8d9PXDVp1aH0Q75280aKj5aWAEgHvAq6jGW5Iai8i4DNIrYi5zRUqht2ZkAcJh0lh9bV5bP/
 ihkDOOTO3+SrrUfzkxbSFOvQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 99567cebb8f6a1d1;
	Tue, 06 Oct 2026 00:23:16 +0000
X-Mizu-Trace-ID: 99567cebb8f6a1d1
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
Subject: [PATCH 2/2] mm: zswap: use stack requests for synchronous decompression
Date: Mon,  5 Oct 2026 17:22:51 -0700
Message-ID: <20261006002307.2669023-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261006002307.2669023-1-usama.arif@linux.dev>
References: <20261006002307.2669023-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ruws9h3aztpkxrz7z1y3t6zcsy4n9ph8
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 73B80140003
X-HE-Tag: 1791246199-70194
X-HE-Meta: U2FsdGVkX19iF6DaHERMVjOfoXTE6whXIAhzMMOlX73LnPmRIO5yPco4Js/jflVb9IvowfUWBnLMD0ChH2Nb3zU0dYMOYlq8pIBQT3s0hji1Y5xz+UTnihPuyiUMyi4j207mJfKHPEv3XVCIscra02f4ZNt25S+/QYtrIxiw/1vjXrJtSHNXIMlppNASOnxwbITUNDmf4+I2LhALBZ6PcOy+AzVSFysj9dvxQT4Y6TePt64nXyv/xn0ZXYy+gil6stzzjplvOvehZSbjibOr+e/zMCny1t3QhWc/zAksR+JPxbJ2Hd++G9YWJ8JXi+VnTZ+LvyQMCC+PNtoVHpZhYDkY3c4quhvCjnu3pJ+x2PH8iAke3BeGACRmmd0eQibx2lkHIpWxGMGFr2h+0yPxvu6BAaa9tH//PhFknaAoILuptlzCl2NjL+yYFDBzb66GChcFy5T1uVfiNgm2EFZRxp1luGXm1oc6qaKnq87tw6hNlLy+Oe6lpukciz4RDTyqbark9H/FlG1KWZswwjVdJjnkXOTd/aYKKsDx1KamKXmgWa42km8RsACUOY9VHjLX0RGnsf/Br5YHyNlUpWYgkg5norlYeCsQhgC1fJlQaYSz90f5BuJ0VNJAdVgeiavwYx7JixpaG2N+gP2lbvUAfGtjOAg4dWlxxZq2C5H2tg9P5XGXk9QJLuDXj6KK7I6TPPTznFU0k944W1lOO6iEcMpdZJqBm5VWnjq/8rkcWTqUSDpcd7y3XqW8vpF3UjOtRdcvE5LjR50kMxd3hSTLSJO4bo3p3llsgeVWMPSv1yqSylC5GjFd8QkV3bU8C+4tlKIvdd9F61lks3yKu5X7eaKQVa5+QlmNPRqAkt+xsZTFs9BxeYNEgqMoYwMKFykL5Qh0vdkBMttmauAXAu/5fNuhyF1hVscGTxy+7EHc+XwAmmXM0ZatisIKOgYJqNi044rUUJGL2lpC/Rv7dqu
 3Xei+y/0
 doRvW+f2OLJm76AYZtEZnhiIs1362gZB3fS6g+cNaUjP+GKnNKR0V1BAEiZ5gOaWEEIBi74Vf/zn+P63oLtGGeBJhYW3AIii78gveFxClwzT73zcginbvIXYINMkVrtKAoWU1bEjuwWOIhBPXJx5W/f8f0+sl7f/yf0uSTfFQm2PPb9F4e9xatFVhCsnH2RP3xszY8OzikQ1Bviaq/2/IfbPwPzXyg3+otuhsQe1ZJbN9aRc=
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
in-tree software compressors qualify. Asynchronous algorithms, and
synchronous ones with request context, keep the per-CPU request and
mutex, which is still taken before the zsmalloc read lock.

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

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/zswap.c | 65 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 20 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 54187b1ef751d..7e7fb6e7ec24c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -147,7 +147,7 @@ struct zswap_acomp_req {
 struct crypto_acomp_ctx {
 	struct crypto_acomp *acomp;
 	struct zswap_acomp_req comp;
-	struct zswap_acomp_req decomp;
+	struct zswap_acomp_req decomp;	/* unused by synchronous algorithms */
 	u8 *buffer;
 };
 
@@ -851,15 +851,20 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
-	if (zswap_acomp_req_init(&acomp_ctx->comp, acomp_ctx->acomp) ||
-	    zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)) {
-		pr_err("could not alloc crypto acomp_request %s\n",
-		       pool->tfm_name);
-		goto fail;
+	if (zswap_acomp_req_init(&acomp_ctx->comp, acomp_ctx->acomp))
+		goto req_fail;
+
+	/* Synchronous algorithms decompress with an on-stack request. */
+	if (acomp_is_async(acomp_ctx->acomp) ||
+	    crypto_acomp_reqsize(acomp_ctx->acomp) > MAX_SYNC_COMP_REQSIZE) {
+		if (zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp))
+			goto req_fail;
 	}
 
 	return 0;
 
+req_fail:
+	pr_err("could not alloc crypto acomp_request %s\n", pool->tfm_name);
 fail:
 	acomp_ctx_free(acomp_ctx);
 	return ret;
@@ -951,19 +956,14 @@ static bool zswap_compress(struct folio *folio, long index,
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
@@ -980,15 +980,14 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 	} else {
 		sg_init_table(&output, 1);
 		sg_set_folio(&output, folio, PAGE_SIZE, 0);
-		acomp_request_set_params(acomp_ctx->decomp.req, input, &output,
-					 entry->length, PAGE_SIZE);
-		ret = crypto_acomp_decompress(acomp_ctx->decomp.req);
-		ret = crypto_wait_req(ret, &acomp_ctx->decomp.wait);
-		dlen = acomp_ctx->decomp.req->dlen;
+		acomp_request_set_params(req, input, &output, entry->length,
+					 PAGE_SIZE);
+		ret = crypto_acomp_decompress(req);
+		ret = crypto_wait_req(ret, wait);
+		dlen = req->dlen;
 	}
 
 	zs_obj_read_sg_end(pool->zs_pool, entry->handle);
-	mutex_unlock(&acomp_ctx->decomp.mutex);
 
 	if (!ret && dlen == PAGE_SIZE)
 		return true;
@@ -1002,6 +1001,32 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
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
+	if (!acomp_ctx->decomp.req) {
+		ACOMP_REQUEST_ON_STACK(req, acomp_ctx->acomp);
+		DECLARE_CRYPTO_WAIT(wait);
+
+		acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					   crypto_req_done, &wait);
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


