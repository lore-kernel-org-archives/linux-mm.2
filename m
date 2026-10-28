Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C67C9606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 03:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zVSSwMCd
Received: by kanga.kvack.org (Postfix)
	id 69F426B0969; Tue, 27 Oct 2026 23:05:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 677216B096B; Tue, 27 Oct 2026 23:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 564F56B096C; Tue, 27 Oct 2026 23:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 257076B0969
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:05:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98540A0B8A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:22 +0000 (UTC)
X-FDA: 85370544084.19.D0098FE
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id C75D2140005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:05:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zVSSwMCd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793156720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPFUpqrFwmcsevDtWnqAQRpw3FDHv9BgZqrP0TlIaS4=;
	b=I17grEh3AChCGmmRy0YRswONrX2OQWlKtY/ME7EW6N/TVh4YcbfdVZXfjK5E67I1mDyLCa
	phiIfbEuDKGeGM/ByxwO8H3csry0UYkHitkfzaUNDL8GeNB+udfg+7VNffWWIkmhGnJVEi
	syF/+yU90Lf4VE/W0BNpZzQO+qdrdNU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zVSSwMCd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793156720;
	b=N3hlLyS31Yre7r/ySOcXwsAJNqi5XXu9O+IujqNoaRiwXtp/0denqW0ZIWZ/rh0Hy3P3sA
	PUJ9CNCSGSuE48urF7kjeNly27iMmUPrWDEUlWbPu9mQ3forKwhDZhTRcF14KcE4tbjoHZ
	gFkwf1mUpf7EalUIjWnxqTPvXHmnU+A=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1a3c08d6928so706512c88.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793156719; x=1793761519; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jPFUpqrFwmcsevDtWnqAQRpw3FDHv9BgZqrP0TlIaS4=;
        b=zVSSwMCduy2aScEG1OvlYR2HxCBYqVX+cD3cQIeOi4qC/Tm0X0BC9CDMJJnHeNWqSQ
         7Zb3tQAXGQG6FaR3o5iPCo/Sw3KFYRPigT/z9TFuvelTs/7Xv7COI3GEkcUtuH8jJ5mY
         T/xBMKPiRfH7E8H5ZSSz43lxNYTJPcM/mRlqO6ILsirVFzC7buHOjOhZp3tdMnQaJ1I6
         1B1JjtWg0hLfQFq1hZKtcN+PyOjwtQI1txgf4zGQj491/hlyxfUk0G5kqiON7Ck8Z9Uc
         tOtkabmSoeSXQlbf67SAg7jHop4TBoVsfV6xZXSBFq4IYxx6uguuI/qm88jBDnxcQSRI
         3Qvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793156719; x=1793761519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jPFUpqrFwmcsevDtWnqAQRpw3FDHv9BgZqrP0TlIaS4=;
        b=vlU5a1C4EMDjWvDoxCOYEglooq+Is5TXK2FCbxWVqgXWF7r/o6n5XsjHgzWhBT8xdS
         nQ5IS6aNQCEEf/YCEYGNllRuvzgfZHWz0DXde4K9GQq7okdLJMiBk9YfyWXkOL8NrNSq
         YPjrZ6Wl0O9kpNMJO0t7pQbiWfZH1dlwWJhp+zvmuXDFQo53YTIBHTYE22bsgYXINhJ2
         p9m5roJiAqfHetuYacg31fRgkv2y0+MxJVp6rdroFK79V4Y1u+KSGOyN9PoFDuyZ1OZu
         aBNV/tuohZ9J2lWhM7wMyBTYBhquMB9pxWd21eYaHKcdr1EU3TejRlvJMyaNhUT727Eh
         fZ9g==
X-Forwarded-Encrypted: i=1; AKwUvByUdApNP0rcOh60hRu40XeMsfdUa52Fx4V6tdZgwZxvFXKsaGN3X3xO815qMOM+AwTCmeUYDkwEAA==@kvack.org
X-Gm-Message-State: AFq9FYIxYFaNcocFP2lu/1Lvxn3jJfJ3skvla3njrxdfRwyYBRAfAQA2
	hthGOyt1l/wzeqZaYhZy2rlBKGl1BfpvwgpahH+6cKETGWRTbvHRJpx8lAMKcg==
X-Gm-Gg: AYBFou3Swl/OEnq4klKGxmzsfd9PDgnUAdlBhsYwVOMmet007V/oCgOGjrjOwbAuhAP
	gX0XkVqgM9zXzFH6FOQg2R+R6pyvLPg7xhiV23K8wQqjgeNf8K2jTPKrs5oVsHi2vhh55Hcg/RB
	bh93sEB57/iShLoWBnKZrEElu7AdgcKVr9qy41+pIP7S3IP2UyOmNkXXFpPQvmgN+spoCQnpbVb
	s0kYNkETlR9DXrieI6733xFMuc5CfCdePJ/jnfDaCVfJFg7hpBXC1OWYTb6ETNBEF17RTvmApkg
	/0Xh3KglUF7ViuWIwa3QG45vb0GyTjuC7BByf5sVDXEJBPssOczE3P7LWhnf2z3JyXHNZe0pC4q
	TpbvNWoM4YpLMD+PtQSBz1+Vg6+ost55slJ2XwAX0YFNEqCXLXPKwnWtBoFmcNHuwpxwlqyiYRR
	G092M/vn4hCU0hL5gC34es1QYAiWhkeNYbbkIYoj9+SUmCfd8zK+r4y6ExRxWjxwQMUzOIIqUKI
	fiS6Plm7fjPFXIMmmEVyrH8N2MCaIli3uXZAlmFdyRKSDqN+oNM0OQBXUCUdc7WSrF3lI54uChZ
	0Dzi3tH6HFAC6ei+l+1kcd10F7WdR31uUmLKIPKBrA==
X-Received: by 2002:a05:7022:fc05:b0:191:3c:aae7 with SMTP id a92af1059eb24-1a6cf167662mr1268977c88.26.1793156719318;
        Tue, 27 Oct 2026 20:05:19 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75a37093esm1150734c88.3.2026.10.27.20.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 20:05:18 -0700 (PDT)
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
Subject: [PATCH v2 6/8] mm: zswap: Store large folios in batches.
Date: Tue, 27 Oct 2026 20:05:01 -0700
Message-Id: <20261028030503.17923-7-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C75D2140005
X-Stat-Signature: 6mq9jcogubjyu3j8godxc4zw86gdfqh7
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793156720-346594
X-HE-Meta: U2FsdGVkX1/9wPfwshEHnsKWwgTA8PVaNjEoIdbA9Ovyc5IfHYjvU8CHMUq6kRLF/vauYaF+BockM7j/oI5mmxgP6FyolT8f8XdfhYFApQZDzo6VCnU0cM/qno1qI7yWCvAwIwGbAFcbGT3kppjHnPnGXUmLuvkDISR6uFLxQRPACdnHDxFQtLsz0Sa3yECxdk+FpvhQ84tYYCPMOzTjK1uK3/iQGyfPHqZZBQ8n2VCGTBw4rHPJq+D2f9QoTpL2AWCbYGDrgIaroDkKUF5gi9CT1f/HuQMOIscRK6SO0I3jwEJtZwNE7/OioxnM1GJSTTM06gqiA89Z2S64vGx3eHBgy0MKV+YFk/HPgVC5wuPNT/Li8FC+93PmbO/a3aa3kMs0g5tRFBSq8WAzWjytAtAEzgts3wgj6q5JhiVrKF71/DQvzRODsAWtpLxMOukFvwb2ZF2t1ofjiqrfAuG5xpRxvZf11ZfVQmS9evf9MD/Uh5fl3oRq5JisqP3wOaquwlfl8ujgYBZ8/d+QuuToC02dCBaQa7THdlgtIJnBqF2QMxv2cF0hRMmNXf0tW7A7pLylQHHhWVxGEfu0Isf6SdPXOCIDkUDegHE1RSAivSqNjx/UdjY9h3v0uHKKYhHcP2Z8dWIWKTxUPu/1gjUoRgSSctBECmHj6TUrpjjoVnUUSVWkAgnnD1uhSKeqnh6ioZOzhfmanJD6pVi6IhVMm31Pb8jGG7hi9I/05W82TtwjAGJ5MccK+Br9/oEbmp2Kj6YTWlXUKfzlDXEQxwWKDAoq+2XCQn1TYHHDRQHcwPQRtbPeoGrZPZMQwMwbNzVxz1pPDD9015eUwgoCZfd2zcJ3SjZVq6QT6wYA9DqEU5jrwVULv39UjqrauU/clFzGnQuaxFINzhbrcFIP6z303kci/Wk0nc6PhkN/3T+to3wN0ABh37wWWnQZpMxFtLAN7gmcBDqr8CA9KJWq26G
 wq1Vsc46
 362uT3EIcpQWd277KxqSB8w+UX2Jpq1y1143GE2J/KWVOF7+KyIs6lVTTmsOi7sxPdSzDnb4rPqC8xYsyW1Cm1hr4252qTSPCpQTAYkf0TasKSkecNWQQ+X81r6Y+WnA/bl0YYO8TgdURgXc2zuk7gvP2NKMY9zd4nd4ajo12rS3EGlYHU5ORxRl6iFGw5SLnygYTLV9nywGVrVVn72QLdVnP/AhTTQ530HrxqQ8sVZlV7HirYevgw1ad6ed830w4dReQDIidP9kVauUZdbWm/kfqYQM4rafNIOcnAd9V5d5SUkNO2IuNhKnHKW+2DEOjQpDjHp7NZLeooHAJU2hIoiNmUCHaoM9YfzyatBpfAQeUC7f1AdgsRZVOl4dslyTIk36LF+Z1KA/CddMLqWZIQqIpoYNmMz208SrMDm9oDaSKti8tbwJ5QRe61Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Use batching when storing large folios in zswap. If the underlying
compressor supports batching (e.g. hardware parallel compression),
allocate multiple compression buffers, otherwise allocate one. The
number of buffers is bounded by a new constant, ZSWAP_MAX_BATCH_SIZE, to
limit the memory overhead. For existing software compressors, the only
extra overhead is the extra 'buffers' pointer, so 8 bytes per-CPU on
x86_64. Only the first buffer is currently used.

Regardless of compression batching, always process large folios in
batches. For hardware compressors, the batch size is the compressor
batch size, otherwise ZSWAP_MAX_BATCH_SIZE is used.

zswap_store_page() is replaced with zswap_store_pages(), which processes
a batch of pages and allows for batching optimizations. For now, only
optimize allocating entries by using batch allocations from the slab
cache.

Avoid repeatedly calling mem_cgroup_zswap_writeback_enabled() for every
page and only call it once for the folio, since the entire folio is
charged to a single memcg. Similarly, obtain the nid once to use during
each batch store of a folio. To facilitate this, a
struct zswap_store_context is introduced to keep function parameter
lists concise.

Also, place and align the members of struct zswap_pool such that members
used together in compress/decompress hot paths are able to share the same
cacheline. Specifically, these members are now on the same cacheline:

 struct zswap_pool {
        struct zs_pool *zs_pool;
        struct crypto_acomp_ctx __percpu *acomp_ctx;
        struct percpu_ref ref;
        u8 idx;
        u8 compr_batch_size;
        // ...
 };

The size of struct zswap_pool is unchanged.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 323 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 227 insertions(+), 96 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 19b7d60bc7d2..c8890e8a9b83 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -84,6 +84,9 @@ static bool zswap_pool_reached_full;
 
 #define ZSWAP_PARAM_UNSET ""
 
+/* Limit the batch size to limit per-CPU memory usage for dst buffers. */
+#define ZSWAP_MAX_BATCH_SIZE 8U
+
 static int zswap_setup(void);
 
 /* Enable/disable zswap */
@@ -143,10 +146,10 @@ struct zswap_acomp_req {
 	struct mutex mutex;
 };
 
-/* The compression mutex also protects the output buffer. */
+/* The compression mutex also protects the output buffer(s). */
 struct zswap_comp_ctx {
 	struct zswap_acomp_req areq;
-	u8 *buffer;
+	u8 **buffers;
 };
 
 /* Separate requests, so that decompression does not wait for compression. */
@@ -161,14 +164,18 @@ struct crypto_acomp_ctx {
  * The only case where lru_lock is not acquired while holding tree.lock is
  * when a zswap_entry is taken off the lru for writeback, in that case it
  * needs to be verified that it's still valid in the tree.
+ *
+ * @compr_batch_size: The max batch size of the compression algorithm,
+ *                    bounded by ZSWAP_MAX_BATCH_SIZE.
  */
 struct zswap_pool {
 	struct zs_pool *zs_pool;
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct percpu_ref ref;
-	struct rcu_work release_rwork;
-	struct hlist_node node;
 	u8 idx;
+	u8 compr_batch_size;
+	struct hlist_node node;
+	struct rcu_work release_rwork;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
 
@@ -225,6 +232,15 @@ struct zswap_entry {
 	struct list_head lru;
 };
 
+struct zswap_store_context {
+	struct folio *folio;
+	long folio_start;
+	bool wb_enabled;
+	int nid;
+	u8 nr_pages;
+	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
+};
+
 /*
  * No RCU section is needed around the returned pointer: a stored entry pins
  * its pool via percpu_ref (taken in zswap_store_page()), so the id cannot be
@@ -281,8 +297,10 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 **********************************/
 static void __zswap_pool_empty(struct percpu_ref *ref);
 
-static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
+static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx, u8 nr_buffers)
 {
+	u8 i;
+
 	if (!acomp_ctx)
 		return;
 
@@ -301,8 +319,12 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 
 	acomp_ctx->acomp = NULL;
 
-	kfree(acomp_ctx->comp.buffer);
-	acomp_ctx->comp.buffer = NULL;
+	if (acomp_ctx->comp.buffers) {
+		for (i = 0; i < nr_buffers; ++i)
+			kfree(acomp_ctx->comp.buffers[i]);
+		kfree(acomp_ctx->comp.buffers);
+	}
+	acomp_ctx->comp.buffers = NULL;
 }
 
 static struct zswap_pool *zswap_pool_create(char *compressor)
@@ -386,7 +408,9 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 
 cpuhp_add_fail:
 	for_each_possible_cpu(cpu)
-		acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu));
+		acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu),
+			       pool->compr_batch_size);
+
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -424,7 +448,8 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 
 	for_each_possible_cpu(cpu)
-		acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu));
+		acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu),
+			       pool->compr_batch_size);
 
 	free_percpu(pool->acomp_ctx);
 
@@ -776,6 +801,39 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
 	kmem_cache_free(zswap_entry_cache, entry);
 }
 
+static inline void zswap_entries_cache_free_batch(
+	struct zswap_entry **entries,
+	u8 nr_entries)
+{
+	/*
+	 * It is okay to use this to free entries allocated separately
+	 * by zswap_entry_cache_alloc().
+	 */
+	kmem_cache_free_bulk(zswap_entry_cache, nr_entries, (void **)entries);
+}
+
+static bool zswap_entries_cache_alloc_batch(
+	struct zswap_store_context *zc,
+	gfp_t gfp)
+{
+	if (unlikely(!kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
+					    zc->nr_pages, (void **)zc->entries))) {
+		u8 i;
+
+		for (i = 0; i < zc->nr_pages; ++i) {
+			zc->entries[i] = zswap_entry_cache_alloc(GFP_KERNEL);
+
+			if (unlikely(!zc->entries[i])) {
+				zswap_reject_kmemcache_fail++;
+				zswap_entries_cache_free_batch(zc->entries, i);
+				return false;
+			}
+		}
+	}
+
+	return true;
+}
+
 /*
  * Carries out the common pattern of freeing an entry's zsmalloc allocation,
  * freeing the entry itself, and decrementing the number of stored pages.
@@ -839,7 +897,9 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	int nid = cpu_to_node(cpu);
 	int ret = -ENOMEM;
+	u8 i;
 
 	/*
 	 * To handle cases where the CPU goes through online-offline-online
@@ -850,15 +910,11 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		return 0;
 	}
 
-	acomp_ctx->comp.buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
-	if (!acomp_ctx->comp.buffer)
-		return ret;
-
 	/*
 	 * In case of an error, crypto_alloc_acomp_node() returns an
 	 * error pointer, never NULL.
 	 */
-	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
+	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, nid);
 	if (IS_ERR(acomp_ctx->acomp)) {
 		pr_err("could not alloc crypto acomp %s : %pe\n",
 				pool->tfm_name, acomp_ctx->acomp);
@@ -866,10 +922,28 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
+	/*
+	 * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
+	 * compressor supports batching.
+	 */
+	pool->compr_batch_size = min(ZSWAP_MAX_BATCH_SIZE,
+				     crypto_acomp_batch_size(acomp_ctx->acomp));
+
 	ret = zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp);
 	if (ret)
 		goto req_fail;
 
+	acomp_ctx->comp.buffers = kcalloc_node(pool->compr_batch_size, sizeof(u8 *),
+					       GFP_KERNEL, nid);
+	if (!acomp_ctx->comp.buffers)
+		goto req_fail;
+
+	for (i = 0; i < pool->compr_batch_size; ++i) {
+		acomp_ctx->comp.buffers[i] = kmalloc_node(PAGE_SIZE, GFP_KERNEL, nid);
+		if (!acomp_ctx->comp.buffers[i])
+			goto req_fail;
+	}
+
 	/* Skip the per-CPU request when decompression can use the stack. */
 	if (acomp_is_async(acomp_ctx->acomp)) {
 		ret = zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp);
@@ -882,12 +956,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 req_fail:
 	pr_err("could not alloc crypto acomp_request %s\n", pool->tfm_name);
 fail:
-	acomp_ctx_free(acomp_ctx);
+	acomp_ctx_free(acomp_ctx, pool->compr_batch_size);
 	return ret;
 }
 
 static bool zswap_compress(struct folio *folio, long index,
-			   struct zswap_entry *entry, struct zswap_pool *pool)
+			   struct zswap_entry *entry, struct zswap_pool *pool,
+			   bool wb_enabled)
 {
 	struct zswap_comp_ctx *comp_ctx;
 	struct scatterlist input, output;
@@ -901,7 +976,7 @@ static bool zswap_compress(struct folio *folio, long index,
 	comp_ctx = &raw_cpu_ptr(pool->acomp_ctx)->comp;
 	mutex_lock(&comp_ctx->areq.mutex);
 
-	dst = comp_ctx->buffer;
+	dst = comp_ctx->buffers[0];
 	sg_init_table(&input, 1);
 	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
 
@@ -940,12 +1015,8 @@ static bool zswap_compress(struct folio *folio, long index,
 	 * to the active LRU list in the case.
 	 */
 	if (comp_ret) {
-		rcu_read_lock();
-		if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
-			rcu_read_unlock();
+		if (!wb_enabled)
 			goto unlock;
-		}
-		rcu_read_unlock();
 		comp_ret = 0;
 		dlen = PAGE_SIZE;
 		dst = kmap_local_folio(folio, index * PAGE_SIZE);
@@ -1500,91 +1571,124 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
-static bool zswap_store_page(struct folio *folio, long index,
-			     struct obj_cgroup *objcg,
-			     struct zswap_pool *pool)
+/*
+ * Store multiple pages in @folio, starting from the page at index @start up to
+ * the page at index @end-1.
+ */
+static bool zswap_store_pages(struct zswap_store_context *zc,
+			      long start,
+			      long end,
+			      struct zswap_pool *pool,
+			      struct obj_cgroup *objcg)
 {
-	swp_entry_t page_swpentry = folio_swap_entry(folio, index);
-	struct zswap_entry *entry, *old;
-	int nid = folio_nid(folio);
+	u8 i, store_fail_idx = 0;
 
-	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL);
-	if (!entry) {
-		zswap_reject_kmemcache_fail++;
-		return false;
-	}
+	zc->nr_pages = end - start;
+	zc->folio_start = start;
 
-	if (!zswap_compress(folio, index, entry, pool))
-		goto compress_failed;
+	VM_WARN_ON_ONCE(zc->nr_pages <= 0 || zc->nr_pages > ZSWAP_MAX_BATCH_SIZE);
+
+	if (unlikely(!zswap_entries_cache_alloc_batch(zc, GFP_KERNEL)))
+		return false;
 
 	/*
-	 * Set pool_idx before the xa_store() below publishes the entry, or a
-	 * concurrent reader could resolve a stale pool_idx left by slab reuse
-	 * to an unrelated live pool.
+	 * We co-locate entry initialization as much as possible here to
+	 * minimize potential cache misses.
 	 */
-	entry->pool_idx = pool->idx;
-	entry->nid = nid;
-
-	old = xa_store(swap_zswap_tree(page_swpentry),
-		       swp_offset(page_swpentry),
-		       entry, GFP_KERNEL);
-	if (xa_is_err(old)) {
-		int err = xa_err(old);
+	for (i = 0; i < zc->nr_pages; ++i) {
+		zc->entries[i]->handle = (unsigned long)ERR_PTR(-EINVAL);
+		/*
+		 * Set pool_idx before the xa_store() below publishes the entry, or a
+		 * concurrent reader could resolve a stale pool_idx left by slab reuse
+		 * to an unrelated live pool.
+		 */
+		zc->entries[i]->pool_idx = pool->idx;
+		zc->entries[i]->swpentry = folio_swap_entry(zc->folio,
+							zc->folio_start + i);
+		zc->entries[i]->objcg = objcg;
+		zc->entries[i]->referenced = true;
+		zc->entries[i]->nid = zc->nid;
+		INIT_LIST_HEAD(&zc->entries[i]->lru);
+	}
 
-		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
-		zswap_reject_alloc_fail++;
-		goto store_failed;
+	for (i = 0; i < zc->nr_pages; ++i) {
+		if (!zswap_compress(zc->folio, zc->folio_start + i,
+				    zc->entries[i], pool, zc->wb_enabled))
+			goto store_pages_failed;
 	}
 
-	/*
-	 * We may have had an existing entry that became stale when
-	 * the folio was redirtied and now the new version is being
-	 * swapped out. Get rid of the old.
-	 */
-	if (old)
-		zswap_entry_free(old);
+	for (i = 0; i < zc->nr_pages; ++i) {
+		struct zswap_entry *old, *entry = zc->entries[i];
+
+		old = xa_store(swap_zswap_tree(entry->swpentry),
+			       swp_offset(entry->swpentry),
+			       entry, GFP_KERNEL);
+		if (unlikely(xa_is_err(old))) {
+			int err = xa_err(old);
+
+			WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
+			zswap_reject_alloc_fail++;
+			/*
+			 * Entries up to this point have been stored in the
+			 * xarray. zswap_store() will erase them from the xarray
+			 * and call zswap_entry_free(). Local cleanup in
+			 * 'store_pages_failed' only needs to happen for
+			 * entries from [@i to @nr_pages).
+			 */
+			store_fail_idx = i;
+			goto store_pages_failed;
+		}
 
-	/*
-	 * The entry is successfully compressed and stored in the tree, there is
-	 * no further possibility of failure. Grab refs to the pool and objcg,
-	 * charge zswap memory, and increment zswap_stored_pages.
-	 * The opposite actions will be performed by zswap_entry_free()
-	 * when the entry is removed from the tree.
-	 */
-	zswap_pool_get(pool);
-	if (objcg) {
-		obj_cgroup_get(objcg);
-		obj_cgroup_charge_zswap(objcg, entry->length);
-	}
-	atomic_long_inc(&zswap_stored_pages);
-	if (entry->length == PAGE_SIZE)
-		atomic_long_inc(&zswap_stored_incompressible_pages);
+		/*
+		 * We may have had an existing entry that became stale when
+		 * the folio was redirtied and now the new version is being
+		 * swapped out. Get rid of the old.
+		 */
+		if (unlikely(old))
+			zswap_entry_free(old);
 
-	/*
-	 * We finish initializing the entry while it's already in xarray.
-	 * This is safe because:
-	 *
-	 * 1. Concurrent stores and invalidations are excluded by folio lock.
-	 *
-	 * 2. Writeback is excluded by the entry not being on the LRU yet.
-	 *    The publishing order matters to prevent writeback from seeing
-	 *    an incoherent entry.
-	 */
-	entry->swpentry = page_swpentry;
-	entry->objcg = objcg;
-	entry->referenced = true;
-	if (entry->length) {
-		INIT_LIST_HEAD(&entry->lru);
-		zswap_lru_add(entry);
+		/*
+		 * The entry is successfully compressed and stored in the tree,
+		 * and further failures will be cleaned up in zswap_store().
+		 * Grab refs to the pool and objcg, charge zswap memory, and
+		 * increment zswap_stored_pages. The opposite actions will be
+		 * performed by zswap_entry_free() when the entry is removed
+		 * from the tree.
+		 */
+		zswap_pool_get(pool);
+		if (objcg) {
+			obj_cgroup_get(objcg);
+			obj_cgroup_charge_zswap(objcg, entry->length);
+		}
+		atomic_long_inc(&zswap_stored_pages);
+		if (unlikely(entry->length == PAGE_SIZE))
+			atomic_long_inc(&zswap_stored_incompressible_pages);
+
+		/*
+		 * We finish by adding the entry to the LRU while it's already
+		 * in xarray. This is safe because:
+		 *
+		 * 1. Concurrent stores and invalidations are excluded by folio lock.
+		 *
+		 * 2. Writeback is excluded by the entry not being on the LRU yet.
+		 *    The publishing order matters to prevent writeback from seeing
+		 *    an incoherent entry.
+		 */
+		if (likely(entry->length))
+			zswap_lru_add(entry);
 	}
 
 	return true;
 
-store_failed:
-	zs_free(pool->zs_pool, entry->handle);
-compress_failed:
-	zswap_entry_cache_free(entry);
+store_pages_failed:
+	for (i = store_fail_idx; i < zc->nr_pages; ++i) {
+		if (!IS_ERR_VALUE(zc->entries[i]->handle))
+			zs_free(pool->zs_pool, zc->entries[i]->handle);
+	}
+
+	zswap_entries_cache_free_batch(&zc->entries[store_fail_idx],
+				       zc->nr_pages - store_fail_idx);
+
 	return false;
 }
 
@@ -1594,9 +1698,15 @@ bool zswap_store(struct folio *folio)
 	swp_entry_t swp = folio->swap;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
-	struct zswap_pool *pool;
+	int nid = folio_nid(folio);
 	bool ret = false;
-	long index;
+	struct zswap_pool *pool;
+	u8 store_batch_size;
+	long start, end;
+	struct zswap_store_context zc = {
+		.folio = folio,
+		.nid = nid,
+	};
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1630,8 +1740,29 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
-	for (index = 0; index < nr_pages; ++index) {
-		if (!zswap_store_page(folio, index, objcg, pool))
+	rcu_read_lock();
+	zc.wb_enabled = mem_cgroup_zswap_writeback_enabled(folio_memcg(folio));
+	rcu_read_unlock();
+
+	/*
+	 * For batching compressors, store the folio in batches of the
+	 * compressor's batch_size.
+	 *
+	 * For non-batching compressors, store the folio in batches
+	 * of ZSWAP_MAX_BATCH_SIZE, where each page in the batch is
+	 * compressed sequentially. This gives better performance than
+	 * invoking zswap_store_pages() per-page, due to cache locality
+	 * of working set structures.
+	 */
+	store_batch_size = (pool->compr_batch_size > 1) ?
+			    pool->compr_batch_size : ZSWAP_MAX_BATCH_SIZE;
+
+	for (start = 0; start < nr_pages; start += store_batch_size) {
+		end = min(start + store_batch_size, nr_pages);
+
+		ret = zswap_store_pages(&zc, start, end, pool, objcg);
+
+		if (unlikely(!ret))
 			goto put_pool;
 	}
 
-- 
2.39.5


