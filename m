Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61F9606A32D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Z6p0cZ+Y
Received: by kanga.kvack.org (Postfix)
	id D1CD76B05C7; Fri,  6 Nov 2026 02:24:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5ABB6B05BC; Fri,  6 Nov 2026 02:24:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B469E6B05C6; Fri,  6 Nov 2026 02:24:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 801DD6B05BA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:24:30 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F412160CE4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:24:30 +0000 (UTC)
X-FDA: 85403856300.17.1BB6A0D
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3EDF51C0006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:24:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Z6p0cZ+Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793949868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WS8LeX2pXu2zl7jPs0wshNVMLyX6bgneX9kWLBMhdro=;
	b=P2snko3C0D8r00B4/4HOllRi3gN9goxKnLWdH80Awe1E3qxaiJA3NDm9oJ0Q78BsUwxRBO
	Cbgeuf8zERd4xogh5/RAgq9UZ8bqEeS1n0vYLXNK7D7vM+Lg3zvlPDim/M0bVQSB0vMGPb
	Wi5ZaWHySqqmT8qD7Cr0s+Gxw3Kbo+M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Z6p0cZ+Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793949868;
	b=TaUuUSP/lO0RjXyPX1J0ystEjlIArvTQA5sPkU2Kt633ihDtb5U8M75OccaMLyrQdvjcox
	ppo8TbV1pDbjLnPJgniTztksG42LftSuEQZztaZHWA/jdBXyBefxkmB05mhhSV9WI0I6Pw
	UNuxEYq1e1u202DDGKmYw4dEvSdEHFg=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-14fc585291cso320160c88.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 23:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793949867; x=1794554667; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WS8LeX2pXu2zl7jPs0wshNVMLyX6bgneX9kWLBMhdro=;
        b=Z6p0cZ+YMU1M/64zOHtX0a+5T6I+lBSEwpiqfE75en75WFf+BJctVXQadZ3Ng0fa+U
         +RrnASuG/dNlR5nAgqOiOWyEQ3YaLfFrCJoJ4NjeGlBR5V0fq7UCD06wlMfqHgncf2AE
         CQoZRZEWL7mwldTTYxV4vrtGH1bnAlAMLGfwThofdw+pZwT5T4M9h9qliSbzPBpjQJO7
         y8CBTxF9/rN4iGoXluJ5Xk8l1NAgTP82cAh6HzCl11Ft9xb6VwW0Qxf8ilkGWibtfgYH
         gBu7it/CurS1NiVVGjzxGYa29T6gVIoU3Dd8TsfNYbVEUzoionUK4nrUa2/mxH+RY5qi
         Y8Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793949867; x=1794554667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WS8LeX2pXu2zl7jPs0wshNVMLyX6bgneX9kWLBMhdro=;
        b=RNkgm4RWNFDy2oeY4RHmJqRjQJPTYf/oQeRBnG3y7s2Ai3zNdOe1UB4pUYcqlCeP2R
         oPZxukvJ68yFYay1ciX7dBsjkU1oZn+krxppHR0hehPLos+cV+PtU2ScMsT5gVqbG1Jv
         uWUMij6p8jWJwULSbOkZfWdiuYA2RAFwn6qB4ueyR/lE4plgB5ys2Jgy7ph2VClsUSov
         nDiAyZOhnU0GfvsCo+gwNgcuJoUZAVfLqk0epHkV7rrK5jlB1AurrTDdkFrgcnlM0aS6
         wthufVio+ndf1md96gBiM/jvylSswPGMreyOgn8LJXVvQKXRlQdC1nf7bx3ZW10aFm/F
         DHgA==
X-Forwarded-Encrypted: i=1; AKwUvBxmACk8kNQz/nEeTOhVmmIzpuAuF+zdwcikROYhUf6QcoKy61V3PKpgwzN2cKiGTgUt44Y695pzkA==@kvack.org
X-Gm-Message-State: APuU4Z83rOhqGS/ndakc4oWRW3Q3DaXcOGAMbFsGveCamA20PFQs36V6
	bveBfArm6pofAH9kK0btw4VGMA0ug2jyabHOy8uPRENE+3yApchbGLHf
X-Gm-Gg: AYBFou1pZj7c4toOC+R4Uv5lwFWzToR5LrOOAbmJA+mu/eo5n+4eCUYR085r9fxtFdm
	ey9ieddzT9bXQrPVi3rL42eCVeeCNx67c+WoDdakNxFg7s8NtqmPo2qJKTRmv3YYnixvfvPcXUW
	gfgxamWwM/sSjxxeFE2QM/4FPZRIK8NzrcGRvrnhrT5kpyAY7O4+tD6ZZLEuTCj38yndx0ZeKd/
	lHfNo8sBJdvBzo7aGLFoqqwW1ZXXKbWY63/SEN2x3VVYnJRRyixAgfqVBkB/IUk67fxnL806VAX
	UoIsIYh0oYl3GoMvmUCdnTM+hqnB7AKlbXMn4kvLkeCwL8IchPqT3KMHLdaRDouUSXbfAIPydyV
	jFeqlm/NV4y+OdA1lLi810iDXIoCxj/KTeU/3bTeTg4v8Vwja6k7dymWX3GYD1bruR77x74Mxgf
	WHjYfCGG3G5BP/QnEIcPXt/Z6K9wIH+oxfJIm9fi/nihi4PTjMP6lKu+JDNe5qVnxMV0ZPO3kAV
	aKmsfsAHOAIBp0f/WfS3H/ARLYtJ/TOFyeO3fNKTA7M+QpNxr6kOuDKjTLkTjdtdtZCgZQftijk
	lz4uIy5MPTLhF5Hi11qYymeo0AMoelhUatRD1+eVB30TFT+AmVqTUiRwn/cQ8rk=
X-Received: by 2002:a05:7022:ea8c:b0:1af:d691:1b4f with SMTP id a92af1059eb24-1b25d34662dmr1700342c88.42.1793949866856;
        Thu, 05 Nov 2026 23:24:26 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4840f3sm6262220c88.5.2026.11.05.23.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 23:24:26 -0800 (PST)
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
Subject: [PATCH v3 6/8] mm: zswap: Store large folios in batches.
Date: Thu,  5 Nov 2026 23:24:10 -0800
Message-Id: <20261106072412.7909-7-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3EDF51C0006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: shjxk446kzyzroe74hk9nuy6d31yxgmq
X-HE-Tag: 1793949868-509968
X-HE-Meta: U2FsdGVkX19yAtqKSMouGs5NCjT9Q9nKWifAVZDcihzA1mx6IHM1TZ8vcu32TnLMyicyz1Xyf2xifEgWvxoWzz6GD5wyfoA7rygDALzORk25U4hgDynKqiyzj/ik8wkdsPpU5bdi7+6S5PGeQbcLkk2QVWdpLpnJ73/hRphfjLQcuCF/DEpuxmGpuNHuosvGXnvbKcbV/Y3y+Aa5xLpIMNi87wUQ2aNX5/PEwrMemZkxHjWyqdeLuqRftJiVbKA+gBgkNjtAWq6chWm+jXmekR+gIVkOn7EgF/ODe4DeId4JBQSyhTzANA8SomJJhQ3ni99fMV/QHXGupsn+yexvQjm60OJMq3JgRTyK1oE2QnEo9D0m2brEjUHXpzHtARZLjPBKZMEA5P/w1vrmQWDMarWuz79y6CGbUAN3iGHzJMObBPkQzE+WLMvh904G1ZjKgoBgCfqMMjYNfuuLKhj1GvKQwHfMzDAmb/L6i5qltKObsGGmb6nW1XYjMO8x8YUZsUdu0H3QU+pmqkJdCz+n64v59nQw7sTapoL/hiEMqchN63PB1PpNS3P/WsY9TKV9CeCG+AoSrGkOBKQJTpIbOPsNrHITNQwvgKO/CwzjbBCVSUskxGuQHHRJxDdfvvU/gOm4W1SJQrWsYHdTe11wr5qXmhqjC5yoE/eOtD1+zaszOJpieSakmdWTgbhFOYFptPyXh/qRE316N6M9187SBFkoJnAo+MmSycabpTmap8hHzf7J8YzYk8Nwy95igbH2S6DyM9v/Q0NUEXgCGixkiZORwXLaUnY4VWblPLNIzhvhJATqyvRZ2k1hjgs/aT0Z9EgS5Xm3YIqMuVNRVf6M3BJCbTP8L6DrhpVMCI1UvudwBLqofpzg3UCTueXz7t8+ZK0fxrvQYmd247IBeXnEZb22AqTZSytDGfrBBIHemwlA4Nr6SO+D+NM9k/n3fBTT6wM2644kf0I3H7/5Lov
 M2n3oDjU
 6GK+tIi0sTk3iMqpBTPnccUBr20fzg9Sp77pXwYBkqtbN6HAikUyWuh+FslpfLTCkPIAHZrOvkdZB62K7UzDfg7e6TEnfKOoRfvkiEoz3poaLEiBAYa4WzX+8vi0fxaO1MvPpJV4twR/NkLKtStxA1lRl5qQgi8BHcz12dP9D5WEySUwpWsEGh7GGaWe0dnxbvsE6hZUlohfVMn4AN/p0erNJ4BUj7FqaFtjnSk9Ed52KtJjVUPNp1Zd8vNhOpulKQ3yDQ1S/dQH7QePZ3IYDLIX/zRB0VP7x0GEbUM76j+pB254tIZdzcGP6RMmwsOlXEec6Fp10DlygW/ENQ7tfyYPYdF7nhkel8Kmj+xwE5WAe9its1/+BFd99ep2illmPfMMZqnytc6HAFJ/sHrfKFIFMHrRlogRXFuJFa0KioNusVZxAZDlhHUN6Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Use batching when storing large folios in zswap. A new constant,
ZSWAP_MAX_BATCH_SIZE is defined as 4U to support processing batches of
up to 4 pages at a time while storing large folios. This commit
modifies the "store single page" approach to "store a batch of pages".

As part of CPU onlining per-CPU acomp_ctx setup, ZSWAP_MAX_BATCH_SIZE
compression buffers are allocated to eventually be able to compress and
store ZSWAP_MAX_BATCH_SIZE pages. This happens in subsequent commits.

For existing software compressors, the extra overhead is the
the extra 'buffers' pointer, 3 additional elements in 'buffers' and 3
additional 4K space per 'buffers[i]': in all ~12 KB per-CPU on
x86_64. Only the first buffer is currently used.

zswap_store_page() is replaced with zswap_store_pages(), which processes
a batch of pages and allows for batching optimizations. For now, only
optimize allocating entries by using batch allocations from the slab
cache.

Avoid repeatedly calling mem_cgroup_zswap_writeback_enabled() for every
page and only call it once for the folio, since the entire folio is
charged to a single memcg. Similarly, obtain the nid once to use during
each batch store of a folio. To facilitate this, a "struct
zswap_store_context" is introduced to keep function parameter lists
concise.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 307 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 216 insertions(+), 91 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 8cc9e0fde456..00cc4586b284 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -84,6 +84,9 @@ static bool zswap_pool_reached_full;
 
 #define ZSWAP_PARAM_UNSET ""
 
+/* Limit the batch size to limit per-CPU memory usage for dst buffers. */
+#define ZSWAP_MAX_BATCH_SIZE 4U
+
 static int zswap_setup(void);
 
 /* Enable/disable zswap */
@@ -143,10 +146,12 @@ struct zswap_acomp_req {
 	struct mutex mutex;
 };
 
-/* The compression mutex also protects the output buffer. */
+/*
+ * The compression mutex also protects the output buffer(s).
+ */
 struct zswap_comp_ctx {
 	struct zswap_acomp_req areq;
-	u8 *buffer;
+	u8 **buffers;
 };
 
 /* Separate requests, so that decompression does not wait for compression. */
@@ -161,6 +166,7 @@ struct crypto_acomp_ctx {
  * The only case where lru_lock is not acquired while holding tree.lock is
  * when a zswap_entry is taken off the lru for writeback, in that case it
  * needs to be verified that it's still valid in the tree.
+ *
  */
 struct zswap_pool {
 	struct zs_pool *zs_pool;
@@ -225,6 +231,15 @@ struct zswap_entry {
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
@@ -283,6 +298,8 @@ static void __zswap_pool_empty(struct percpu_ref *ref);
 
 static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 {
+	u8 i;
+
 	if (!acomp_ctx)
 		return;
 
@@ -301,8 +318,12 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 
 	acomp_ctx->acomp = NULL;
 
-	kfree(acomp_ctx->comp.buffer);
-	acomp_ctx->comp.buffer = NULL;
+	if (acomp_ctx->comp.buffers) {
+		for (i = 0; i < ZSWAP_MAX_BATCH_SIZE; ++i)
+			kfree(acomp_ctx->comp.buffers[i]);
+		kfree(acomp_ctx->comp.buffers);
+	}
+	acomp_ctx->comp.buffers = NULL;
 }
 
 static struct zswap_pool *zswap_pool_create(char *compressor)
@@ -387,6 +408,7 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 cpuhp_add_fail:
 	for_each_possible_cpu(cpu)
 		acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu));
+
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -776,6 +798,41 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
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
+	bool ret = kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
+					 zc->nr_pages, (void **)zc->entries);
+
+	if (unlikely(!ret)) {
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
@@ -785,7 +842,7 @@ static void zswap_entry_free(struct zswap_entry *entry)
 	struct zswap_pool *pool = zswap_entry_pool(entry);
 
 	zswap_lru_del(entry);
-	if (!WARN_ON_ONCE(!pool)) {
+	if (likely(!WARN_ON_ONCE(!pool))) {
 		zs_free(pool->zs_pool, entry->handle);
 		zswap_pool_put(pool);
 	}
@@ -839,7 +896,9 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	int nid = cpu_to_node(cpu);
 	int ret = -ENOMEM;
+	u8 i;
 
 	/*
 	 * To handle cases where the CPU goes through online-offline-online
@@ -850,15 +909,11 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
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
@@ -870,6 +925,24 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	if (ret)
 		goto req_fail;
 
+	/*
+	 * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers for all compressors.
+	 */
+	acomp_ctx->comp.buffers = kcalloc_node(ZSWAP_MAX_BATCH_SIZE,
+					       sizeof(u8 *), GFP_KERNEL, nid);
+	if (!acomp_ctx->comp.buffers) {
+		ret = -ENOMEM;
+		goto req_fail;
+	}
+
+	for (i = 0; i < ZSWAP_MAX_BATCH_SIZE; ++i) {
+		acomp_ctx->comp.buffers[i] = kmalloc_node(PAGE_SIZE, GFP_KERNEL, nid);
+		if (!acomp_ctx->comp.buffers[i]) {
+			ret = -ENOMEM;
+			goto req_fail;
+		}
+	}
+
 	/* Skip the per-CPU request when decompression can use the stack. */
 	if (acomp_is_async(acomp_ctx->acomp)) {
 		ret = zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp);
@@ -887,7 +960,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 }
 
 static bool zswap_compress(struct folio *folio, long index,
-			   struct zswap_entry *entry, struct zswap_pool *pool)
+			   struct zswap_entry *entry, struct zswap_pool *pool,
+			   bool wb_enabled)
 {
 	struct zswap_comp_ctx *comp_ctx;
 	struct scatterlist input, output;
@@ -901,7 +975,7 @@ static bool zswap_compress(struct folio *folio, long index,
 	comp_ctx = &raw_cpu_ptr(pool->acomp_ctx)->comp;
 	mutex_lock(&comp_ctx->areq.mutex);
 
-	dst = comp_ctx->buffer;
+	dst = comp_ctx->buffers[0];
 	sg_init_table(&input, 1);
 	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
 
@@ -940,12 +1014,8 @@ static bool zswap_compress(struct folio *folio, long index,
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
@@ -1500,91 +1570,126 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
-static bool zswap_store_page(struct folio *folio, long index,
-			     struct obj_cgroup *objcg,
-			     struct zswap_pool *pool)
+/*
+ * Store multiple pages in @zc->folio, starting from the page at index @start up
+ * to the page at index @end-1.
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
+	bool ret;
 
-	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL);
-	if (!entry) {
-		zswap_reject_kmemcache_fail++;
-		return false;
-	}
+	zc->nr_pages = end - start;
+	zc->folio_start = start;
+
+	VM_WARN_ON_ONCE(zc->nr_pages <= 0 || zc->nr_pages > ZSWAP_MAX_BATCH_SIZE);
 
-	if (!zswap_compress(folio, index, entry, pool))
-		goto compress_failed;
+	ret = zswap_entries_cache_alloc_batch(zc, GFP_KERNEL);
+	if (unlikely(!ret))
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
 
@@ -1594,9 +1699,14 @@ bool zswap_store(struct folio *folio)
 	swp_entry_t swp = folio->swap;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
-	struct zswap_pool *pool;
+	int nid = folio_nid(folio);
 	bool ret = false;
-	long index;
+	struct zswap_pool *pool;
+	long start, end;
+	struct zswap_store_context zc = {
+		.folio = folio,
+		.nid = nid,
+	};
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1630,8 +1740,23 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
-	for (index = 0; index < nr_pages; ++index) {
-		if (!zswap_store_page(folio, index, objcg, pool))
+	rcu_read_lock();
+	zc.wb_enabled = mem_cgroup_zswap_writeback_enabled(folio_memcg(folio));
+	rcu_read_unlock();
+
+	/*
+	 * For batching and non-batching compressors, store the folio in
+	 * batches of ZSWAP_MAX_BATCH_SIZE, where the pages in the batch
+	 * are compressed in batches of the compressor's batch_size. This gives
+	 * better performance than invoking zswap_store_pages() per-page,
+	 * due to cache locality of working set structures.
+	 */
+	for (start = 0; start < nr_pages; start += ZSWAP_MAX_BATCH_SIZE) {
+		end = min(start + ZSWAP_MAX_BATCH_SIZE, nr_pages);
+
+		ret = zswap_store_pages(&zc, start, end, pool, objcg);
+
+		if (unlikely(!ret))
 			goto put_pool;
 	}
 
-- 
2.39.5


