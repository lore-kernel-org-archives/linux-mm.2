Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD60ACA6011
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 18:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D4766B0099; Thu,  8 Oct 2026 14:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9878B6B009B; Thu,  8 Oct 2026 14:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89AB36B009D; Thu,  8 Oct 2026 14:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 628116B0099
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 14:28:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E052940435
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:39 +0000 (UTC)
X-FDA: 85300294758.15.92EDC07
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0335040007
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:28:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n+CGRKxd;
	spf=pass (imf12.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791484118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H8F1lWjV4954gJVzEPW44SYFrIQOOUNywVyJnvWveaQ=;
	b=37GQmMFu3070tXpwl8C+yefTFukmQuVHLnyT4IN9dVXuITSmrXmD50S+BzCLniLaXTZrxR
	ori99B6YR/0Q3tkrAOrOFg/hIiAT9aUXkXwSqbN2rpwsOHe8cVu/tM1QVpicR12fQ3ckNy
	B45tm2Cy9O4pJldWnbKICpfsm935wig=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n+CGRKxd;
	spf=pass (imf12.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791484118;
	b=uXkqKYBPuWb1cC5uTqejZfah25GdD4KOZugBfIW+ZtbyuYu3202jbPu3sZz/P4a+2BOvjK
	YjE0tO0epNW61N0wducUULDU52fRKvv02KbbXXppJu5QNjUjw2fDCFr7YM5xsog/boe1jE
	E5qavZXL/O7Ol+z45wWT8Eyy2ZgE23U=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1419d3416ceso10781481c88.0
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 11:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484117; x=1792088917; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H8F1lWjV4954gJVzEPW44SYFrIQOOUNywVyJnvWveaQ=;
        b=n+CGRKxdm2mtfisT8SnF9xItLLMMCOozTN/HzUxaeuYE2+y0iK/7P3eN44//GW0TDi
         aER6GWSdV6SbZsioIi0rEZv1RSFoWpH3nHUFHzn9SpcCm5vB4AdF93V8S7WDalBPNTBP
         s9uGPsXuGzGTSVmJ+plUauWZ8QUw9NciAa4TEZYYqHmDdZPZQVhsm9iHN2E/ePeSIrrz
         UZ+SLaF7n+nAHhZSihs1iSTJG/LqDkGJLQcWsg13sc6xz3vE62/f01iXwUNJYBrtOpG9
         1JhAes/kcA9IZjnEmOmVx7m4Rm2ioDf4Q0MCuuBsMvncFGfS/M13XVOv2km8dshKEgrZ
         fIIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484117; x=1792088917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=H8F1lWjV4954gJVzEPW44SYFrIQOOUNywVyJnvWveaQ=;
        b=VoWa6YfZpHE3XwzeIPHQeZpwG6c31ON55UI5G5OEMykqK1DPVTD1r3+c2JW8DvHWgh
         VWuCgC+0UTzoDXX3vHqG4oAlE0riAWn6S/kdSWrbaEMplvY1gO5H4q76uH7FlfNZvTBd
         wGtd0sc5wcrQawcdgPHyAvYJcDLiGMRwjMio8wgX+79KdS1LpWQfcLrPmVnw6U6usAr3
         7MHUqDpLQGimnFrxlYwK9edbwsOKgBr6nHGB6w3itExHY8HjuW0NMWPmovB3IjpyVnEm
         RJXqVDeaD8/OXIbguRjsk73f2+FLYlPUw2yH/Et3dOnzwue3Aik5QVtPeJUI5z+CryZp
         mh3A==
X-Forwarded-Encrypted: i=1; AKwUvBxoBd64DXxBRab0eIbQ+sYJJtY3dZ6Ujmr6abC2VwXRp2eCm7ksfZJrn+K0ra1lkn8zgczmAhtRUQ==@kvack.org
X-Gm-Message-State: AFuF++nRLCIM9jjfvG784DV8JBRSuo4noHFqHQSnaR6gqRbPbS0iyf0R
	sb2WVlnvfF+eWO06+dqksSy3RVHOalvmZON51ZaYTiGcOM4e2Rzs3KN/
X-Gm-Gg: AYBFou0hIsfOOypGf1HxYpv9ZBbWUOo8moyMlIUADN0/+dxsZnG4UFh4Dr1goC12Kqp
	LKjOVljP8W7WdSU4fNHbrFLB/EUslgG/kNFxB3xXNU/NHzxfVXcqZ7q+bLfVquqWIROZ1uslmbH
	33Onn/gRyssNAcmMQL2Ol3kffG9P8fSgYGdG16GN64fRlk/H6b3wQkUNuDgPn9xxO/+HTjldyeD
	+L5z8HkDdiNyGY37BQ7Rim5bOiD35l38xpBgr1BG/W9/WkeheCA6U1uB5l3v3z3PrWp49aNJw+K
	FeuzytL+h/knXloYnPnhkhLszgO3x6rJ3Z9BW9IBeUm1Yu80sgtgQIsRsFhX/U/YrWv32n4KRm2
	ONRqAHL4IppfpZXHQJDeu8qHsITWSRApUiBBSVDBiM6NvARp3qSNal2YfpzWIK2ZHWivK0J8d6h
	idNa1Tit1iZ3/s8BliseCZzGPeNyuATkFztLB41U57e3woHg8ckzEZnOHDZ0z5k+PuG8dw4tsQ0
	OfpyPyYpm4=
X-Received: by 2002:a05:701b:454f:20b0:14d:baf5:c411 with SMTP id a92af1059eb24-1620374e31emr6990690c88.14.1791484116447;
        Thu, 08 Oct 2026 11:28:36 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:35 -0700 (PDT)
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
Subject: [PATCH v1 6/8] mm: zswap: Store large folios in batches.
Date: Thu,  8 Oct 2026 11:28:12 -0700
Message-Id: <20261008182814.27450-7-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0335040007
X-Rspam-User: 
X-Stat-Signature: mgbfy9dcqxwysfswq991948ha89eprdq
X-HE-Tag: 1791484117-840742
X-HE-Meta: U2FsdGVkX1+PgNUskDuFEyk8e08LEqErC2FhDt/IRkvs8fIGjQtPivhQB4K1djb6BCxWkfUMBGP3Nn5eXTLKPpn9J2cel6ddmPijacSiCjdsJbDkCZ67GNdRideTwNjyHOIw503w6hXjn5wLmJ9Q0EWE/9q4YWn7aGOXJqdbtfEin7Bpt0vL9B/dZCavAeha1QPBqU6NzS5972gPnRQkklI4m6itAyw26/GnV5rjHqhPfZuQKLtQ4nQWivvegL4BOguMiP/F+yZnfWb+rYNFq81UkzyWM5rzHtcDWuWY15NtTyhRn2T/YcdL1vfgMLxcUKitsgmDopXEuiaRK8Al8Z5iAvN/zTNSOuasT5P/baXvFyGtIHy26bGMr/IbFKfUX0YJGx1NsX1H58asWCfzUHIpkLQBoTLH7oNmTfqL9CVyZlnbRbAkSIFck80IiwsL6r910PC8kFuM9hIyw8mmP7u7tg6Oxf88YXIQJFcw5OpA9003OlTMmKsN5Z/IA3lxqv4cngy+hdHStjPTDjbgLR0tNx5M3fI2B6vwPxxGJ8JqVtljbnTDHSyOF7GHIdRW7Gygn2+sxqJWFyDrz/5k5YkwTDvy9Jt6Jlk/RMW9TT0ikxBHsbjFceaCfh1YTEL4UQrIk9zZE3XW8io6wMPgtoxsdWreZ41USXVxYE2RddSV6nczXc37w/d62JLRzavbg7HkE5Z0hatRMngNoCBIB9KmCzkWqbVIRRolWD/G5GeJnGhbRC9/zDRHpPx1qUiXgjeDjszuBuIAtW63I+1zpRs7cSdPW4j/4ICBHbTZFjC0wpg1VHah5Ekp6xINiwJyVKfIeFgnwIfo07zZdycpVxMhtbtv6wH6EUKgz9FSpfEIRpmjfJr2DHs22URgJI5ehxno1rfW37nwNP5QdcY3VOjejbswHvq4lqNnVC6UX4GpoLIyw09tMDr0VcicA4Fwd/pJzX4HLiCj20nSg+y
 amdm23Yv
 9o+wKEtVEddy66jGx9bL/huWnXUsgPu7E3kr5sQlZvGjEPSmpj95OOSsIBmgPpZea61jpFZQsQ6HW+GIJUVK4V8GjM0Q+EUfk4YUhFu7cTld5jTf9NOw31/kF0+IO4yOKz2CWVyeN+n9YRWfzTl2/6V9W+YOg9idycpb9h9jM8JtzOBp+OJU927+AZBsdxgquwIVhn+TxWZ2a3e56SNoVnIaFBQMad2xC3nOJ8lMGIKE9lmmGmtw/ESxCw87jnGQ0PhRjHUm4WB26VJL1MO6rm1r3qNyAwAH/HPxWYIB1llxVXLd+5+fJTip7HYZRIUr1D2SteGeDl9yCfH443a46SIqb5Wh9+ZUqt1Ay+t++K9/PxW6i8QNwps2uA3YZDKHndJm4PlKb3NCOc/J+SvOZwiJPkmYKm2058oTo++DqeoSU0U400MYZkT8c4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
each batch store of a folio.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 mm/zswap.c | 304 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 212 insertions(+), 92 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index c2731d3acb2c..8ae67fd10522 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -84,6 +84,9 @@ static bool zswap_pool_reached_full;
 
 #define ZSWAP_PARAM_UNSET ""
 
+/* Limit the batch size to limit per-CPU memory usage for dst buffers. */
+#define ZSWAP_MAX_BATCH_SIZE 8U
+
 static int zswap_setup(void);
 
 /* Enable/disable zswap */
@@ -141,7 +144,7 @@ struct crypto_acomp_ctx {
 	struct crypto_acomp *acomp;
 	struct acomp_req *req;
 	struct crypto_wait wait;
-	u8 *buffer;
+	u8 **buffers;
 	struct mutex mutex;
 };
 
@@ -150,10 +153,14 @@ struct crypto_acomp_ctx {
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
+	u8 compr_batch_size;
 	struct percpu_ref ref;
 	struct rcu_work release_rwork;
 	struct hlist_node node;
@@ -269,8 +276,10 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 **********************************/
 static void __zswap_pool_empty(struct percpu_ref *ref);
 
-static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
+static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx, u8 nr_buffers)
 {
+	u8 i;
+
 	if (!acomp_ctx)
 		return;
 
@@ -293,8 +302,12 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 
 	acomp_ctx->acomp = NULL;
 
-	kfree(acomp_ctx->buffer);
-	acomp_ctx->buffer = NULL;
+	if (acomp_ctx->buffers) {
+		for (i = 0; i < nr_buffers; ++i)
+			kfree(acomp_ctx->buffers[i]);
+		kfree(acomp_ctx->buffers);
+	}
+	acomp_ctx->buffers = NULL;
 }
 
 static struct zswap_pool *zswap_pool_create(char *compressor)
@@ -378,7 +391,9 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 
 cpuhp_add_fail:
 	for_each_possible_cpu(cpu)
-		acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu));
+		acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu),
+			       pool->compr_batch_size);
+
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -416,7 +431,8 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
 	cpuhp_state_remove_instance(CPUHP_MM_ZSWP_POOL_PREPARE, &pool->node);
 
 	for_each_possible_cpu(cpu)
-		acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu));
+		acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu),
+			       pool->compr_batch_size);
 
 	free_percpu(pool->acomp_ctx);
 
@@ -767,6 +783,41 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
 	kmem_cache_free(zswap_entry_cache, entry);
 }
 
+static __always_inline void zswap_entries_cache_free_batch(
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
+	struct zswap_entry **entries,
+	u8 nr_entries,
+	gfp_t gfp,
+	int nid)
+{
+	if (unlikely(!kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
+					    nr_entries, (void **)entries))) {
+		u8 i;
+
+		for (i = 0; i < nr_entries; ++i) {
+			entries[i] = zswap_entry_cache_alloc(GFP_KERNEL, nid);
+
+			if (unlikely(!entries[i])) {
+				zswap_reject_kmemcache_fail++;
+				zswap_entries_cache_free_batch(entries, i);
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
@@ -797,7 +848,9 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	int nid = cpu_to_node(cpu);
 	int ret = -ENOMEM;
+	u8 i;
 
 	/*
 	 * To handle cases where the CPU goes through online-offline-online
@@ -808,15 +861,11 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		return 0;
 	}
 
-	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
-	if (!acomp_ctx->buffer)
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
@@ -824,6 +873,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
+	/*
+	 * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
+	 * compressor supports batching.
+	 */
+	pool->compr_batch_size = min(ZSWAP_MAX_BATCH_SIZE,
+				     crypto_acomp_batch_size(acomp_ctx->acomp));
+
 	/* acomp_request_alloc() returns NULL in case of an error. */
 	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
 	if (!acomp_ctx->req) {
@@ -832,6 +888,17 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
+	acomp_ctx->buffers = kcalloc_node(pool->compr_batch_size, sizeof(u8 *),
+					  GFP_KERNEL, nid);
+	if (!acomp_ctx->buffers)
+		goto fail;
+
+	for (i = 0; i < pool->compr_batch_size; ++i) {
+		acomp_ctx->buffers[i] = kmalloc_node(PAGE_SIZE, GFP_KERNEL, nid);
+		if (!acomp_ctx->buffers[i])
+			goto fail;
+	}
+
 	crypto_init_wait(&acomp_ctx->wait);
 
 	/*
@@ -852,12 +919,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	return 0;
 
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
 	struct crypto_acomp_ctx *acomp_ctx;
 	struct scatterlist input, output;
@@ -871,7 +939,7 @@ static bool zswap_compress(struct folio *folio, long index,
 	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
 	mutex_lock(&acomp_ctx->mutex);
 
-	dst = acomp_ctx->buffer;
+	dst = acomp_ctx->buffers[0];
 	sg_init_table(&input, 1);
 	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
 
@@ -901,13 +969,10 @@ static bool zswap_compress(struct folio *folio, long index,
 	 * to the active LRU list in the case.
 	 */
 	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
-		rcu_read_lock();
-		if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
-			rcu_read_unlock();
+		if (!wb_enabled) {
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
 		}
-		rcu_read_unlock();
 		comp_ret = 0;
 		dlen = PAGE_SIZE;
 		dst = kmap_local_folio(folio, index * PAGE_SIZE);
@@ -1440,91 +1505,122 @@ static void shrink_worker(struct work_struct *w)
 * main API
 **********************************/
 
-static bool zswap_store_page(struct folio *folio, long index,
-			     struct obj_cgroup *objcg,
-			     struct zswap_pool *pool)
+/*
+ * Store multiple pages in @folio, starting from the page at index @start up to
+ * the page at index @end-1.
+ */
+static bool zswap_store_pages(struct folio *folio,
+			      long start,
+			      long end,
+			      struct zswap_pool *pool,
+			      int nid,
+			      bool wb_enabled,
+			      struct obj_cgroup *objcg)
 {
-	swp_entry_t page_swpentry = folio_swap_entry(folio, index);
-	struct zswap_entry *entry, *old;
-	int nid = folio_nid(folio);
+	struct zswap_entry *entries[ZSWAP_MAX_BATCH_SIZE];
+	u8 i, store_fail_idx = 0, nr_pages = end - start;
 
-	/* allocate entry */
-	entry = zswap_entry_cache_alloc(GFP_KERNEL, nid);
-	if (!entry) {
-		zswap_reject_kmemcache_fail++;
-		return false;
-	}
+	VM_WARN_ON_ONCE(nr_pages <= 0 || nr_pages > ZSWAP_MAX_BATCH_SIZE);
 
-	if (!zswap_compress(folio, index, entry, pool))
-		goto compress_failed;
+	if (unlikely(!zswap_entries_cache_alloc_batch(entries, nr_pages,
+						      GFP_KERNEL, nid)))
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
+	for (i = 0; i < nr_pages; ++i) {
+		entries[i]->handle = (unsigned long)ERR_PTR(-EINVAL);
+		/*
+		 * Set pool_idx before the xa_store() below publishes the entry, or a
+		 * concurrent reader could resolve a stale pool_idx left by slab reuse
+		 * to an unrelated live pool.
+		 */
+		entries[i]->pool_idx = pool->idx;
+		entries[i]->swpentry = folio_swap_entry(folio, start + i);
+		entries[i]->objcg = objcg;
+		entries[i]->referenced = true;
+		entries[i]->nid = nid;
+		INIT_LIST_HEAD(&entries[i]->lru);
+	}
 
-		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
-		zswap_reject_alloc_fail++;
-		goto store_failed;
+	for (i = 0; i < nr_pages; ++i) {
+		if (!zswap_compress(folio, start + i, entries[i], pool, wb_enabled))
+			goto store_pages_failed;
 	}
 
-	/*
-	 * We may have had an existing entry that became stale when
-	 * the folio was redirtied and now the new version is being
-	 * swapped out. Get rid of the old.
-	 */
-	if (old)
-		zswap_entry_free(old);
+	for (i = 0; i < nr_pages; ++i) {
+		struct zswap_entry *old, *entry = entries[i];
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
+		if (entry->length == PAGE_SIZE)
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
+	for (i = store_fail_idx; i < nr_pages; ++i) {
+		if (!IS_ERR_VALUE(entries[i]->handle))
+			zs_free(pool->zs_pool, entries[i]->handle);
+	}
+	zswap_entries_cache_free_batch(&entries[store_fail_idx],
+				       nr_pages - store_fail_idx);
+
 	return false;
 }
 
@@ -1534,9 +1630,11 @@ bool zswap_store(struct folio *folio)
 	swp_entry_t swp = folio->swap;
 	struct obj_cgroup *objcg = NULL;
 	struct mem_cgroup *memcg = NULL;
+	bool wb_enabled, ret = false;
+	int nid = folio_nid(folio);
 	struct zswap_pool *pool;
-	bool ret = false;
-	long index;
+	u8 store_batch_size;
+	long start, end;
 
 	VM_WARN_ON_ONCE(!folio_test_locked(folio));
 	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
@@ -1570,8 +1668,30 @@ bool zswap_store(struct folio *folio)
 		mem_cgroup_put(memcg);
 	}
 
-	for (index = 0; index < nr_pages; ++index) {
-		if (!zswap_store_page(folio, index, objcg, pool))
+	rcu_read_lock();
+	wb_enabled = mem_cgroup_zswap_writeback_enabled(folio_memcg(folio));
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
+		ret = zswap_store_pages(folio, start, end, pool,
+					nid, wb_enabled, objcg);
+
+		if (unlikely(!ret))
 			goto put_pool;
 	}
 
-- 
2.39.5


