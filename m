Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 088CF606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=shZlxht4
Received: by kanga.kvack.org (Postfix)
	id D6F566B0753; Thu, 19 Nov 2026 23:19:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1FCA6B0754; Thu, 19 Nov 2026 23:19:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0F556B0755; Thu, 19 Nov 2026 23:19:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 953DA6B0753
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:19:29 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A6D7A8C6C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:19:29 +0000 (UTC)
X-FDA: 85454193258.03.F915517
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6001016000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:19:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=shZlxht4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795148367;
	b=v73GnJTzCMkNs4mWeJNL+MtNBZxnB0PQIQm9lcycXYiZzf/cOElMY9M8Tfl5ijB+FCqwKE
	d5ugeQqm84foEzim2pWQDqOkzjTBi+3bpk/8Ad14QpGqxz0BhHeU20kYLW/6afUrgVD+xV
	fSpu6p9yUdd+uGgn8P0jxLQUsk8xFW0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795148367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EqeMfxM8xgeWT0tjUJL9cHt5zheKeVoDa21rgCviEWs=;
	b=dMLaxFClysMfQDH6DE8425mLxUBnNiDR/qvc2h2mgGlBhfeKEebz7RVVVunrpCgkY3eV/l
	SPjAYj7gbc/HqVdkloF70V4a7tTRiRnl6tOEV+dSSkfcd7+PqwOOez3/6X+o5BKmT8xsXu
	TeWkqfJOGVDFgS3WxhR43mVghqHnw+8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=shZlxht4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-18818daa3e7so712481c88.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795148366; x=1795753166; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EqeMfxM8xgeWT0tjUJL9cHt5zheKeVoDa21rgCviEWs=;
        b=shZlxht4c9J/V8qbge/XU946/xd24DHQnAoxWjytj4+gPZV8Ow1kqh2J21c2U4psaD
         6YBJ06ctyJmx6ZokGoHOhoLi6SjlHjFAYmPADRUtMEBwPGxSuteYcZHufRkLinzBquqr
         di7zTd/7e0LzKMaD3BYtowhAhUvzA2pZXPrt2H9k2PZC/0ZAYM+GL/Id79ixngFM8tvw
         qXXpPuYj23OlMR5pHtTu3jl8kCVQzhAhDfYQ4fT5AwK2vFUQG/8OutSllxYAu1l4im96
         Zh7dQZeMDtza4fX57jDWTnwv5AT33epdkBkMQvX0HIbVG0WsszLVS43VhqpscYlOGPpF
         TXKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795148366; x=1795753166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EqeMfxM8xgeWT0tjUJL9cHt5zheKeVoDa21rgCviEWs=;
        b=PnNfM714w39yleGkOySgelqcP5lSvoLBQZGyPDtPluPs6jIbU987GLB6ruWqqijTGO
         vEhGXqgUOD61Ef8mIoyjTR8jSeVHydjLoWxvdViRHm59mpnzKU06y7W3asxqL8NqHNdn
         ct434oeHm8LVMHeM8ITaqas4gK5BcMv2ELcuvzeRp6u0E+hoinYJWMBN+T9X+wqUgf49
         xs81I1ql3EDboPaRLhAOfRjr6cV8ii20h590kqW9T93WNAqaiZAQd5xFRpTLdkOozOLu
         7dKBGIHy3iF3KA4GEBd9zzp2csMxPvIUBejUvTrBbRTwubm9ai9P0dN8fj1zJQiTYZ3y
         6/rA==
X-Forwarded-Encrypted: i=1; AL+hErH3HIn/TiNoMK+Wdk63gn9NeutWN75jYOBOfVb+5cPJacere2cJhFyrgb1R9Tpkn9QksjaI3puHlg==@kvack.org
X-Gm-Message-State: APuU4Z/gDK6rWtZMr4zdBNiJQITzzH0bRrIE1foav6hsZH8wfJ8g5MUc
	S2CZj8tS8Q1ka4644hlS8bUNU4PImNhijMFSJ58BsrCADFvgI7xtdsMI
X-Gm-Gg: AYBFou2oqS4R6cpXgvmgfsW1CNlauO4O+Eo+mKqz2vgkXCHatbXj9CDJIzuzeRhUqnx
	cTi/LiXkFS/pzKG4raAo6QnT8QYsH/7VfTLSzBXE3r3ybW6Sd0kUHUN67fyjQg5NA/d+kO4qnFc
	/Cp2eRGZpXj9Nrv7BN8ZDHrimcyfrUJMPl7olCFLyEtb8bQLxvcTJ5toTvXNMhquW/EKlUlnP+Y
	jPGc5CGP9OZCsRvPgBS4ejzQQTkG3z0D+PlisCDQwTDrLmIJ2Lk6QHfuhoSTogJL7UBybhEypQU
	imtvOHuXi/2pH+WPhFrinB/uom1LvlvF2GaPA8yY6Tbe87NJX6RVjix9AUouHKZp8tYn3HUXtrv
	n1HS0hHGYWgbUSP5xZp86L8O4uCJ1AQkPMbK95wFYP8Ic5BJzJ+DpvTIcQ0R6NMyth4DLWX4Uw5
	QLnBQoWzTozlCOcTzBqgFnUsQj6TJHUrsr+Z94M95NGks4J6VWjC6+GnpmG7Jr3sBqcFk7orFnF
	R1FzV4+ZQy9zU2MaYzJmJa/9Ko8YX05S8DVtIJILLn1/wkS+OjAjePclWUIp3UZY8MQI2HB0dFu
	5DSvxA3RCS6Qx9A6bHn2giJqsIrHdqLgoGsqTw/EZg==
X-Received: by 2002:a05:7022:7f14:b0:19d:233:989d with SMTP id a92af1059eb24-1b5568ff754mr1580091c88.14.1795148365990;
        Thu, 19 Nov 2026 20:19:25 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ffa8csm3124341c88.7.2026.11.19.20.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 20:19:25 -0800 (PST)
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
Subject: [PATCH v4 6/8] mm: zswap: Store large folios in batches.
Date: Thu, 19 Nov 2026 20:19:04 -0800
Message-Id: <20261120041906.5785-7-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6001016000A
X-Stat-Signature: mj5gbisjhjghhio4kj4yo5i3ch9ngnas
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795148367-523046
X-HE-Meta: U2FsdGVkX18c1PLCsoH5z59pOIt/b7WJ8R7h05yCXZ5/rhswshlTQpJF9jqeonOVZZPg5xvUwJW5CGjJ1MNzr9s2XN1GVxqntsRdRdXogA7Jf7N1YoZ9tN7CaOgQlA9VpG/SPM98nK63dghlScDAUCsJK79UNq1tY/lHA/wuvKBFxLyDK6l+EVWk1VU5hLAkVT333iWEdOb91x8AiTQVMefllt+QcwHiolwSIkyOhrBf3XXV4qnvQl+Qj2zV8WB91FptGyjX+YTvSfZYDxO5+jccnE/3kkxTkEq6wHxjzVAvOcisvIdZP5cGhtouKZnrX9nuWVGWjNLfUta5IiplaqVbKG1eUK0vPQAneye+j3qrS5QFd6vsIbLARBLtofVAbQMD7NQvSm+XzaL+FspF6LvkYTsKyHjnVJ6bqwA/6OUlUG4/rvGkiqRTZ+pdNl6mQDtd+xeaEZA7VfbdDp88HNOZMPiVLb39osFUW8Fs2lfIlTrKZDdBL2+TfGK4EKx022fYJxTxnbHguPrqoOAW1wC9fDUQTfTMlmqdNsI5schv4wXOwlv3vaaAKsukGdx2/Uh+vYdrbJNSaQKA4e4lRtePWMdb0RAHrfAHvCgpqD3Z2dvAOB4zx96/QLab27s1Z7kbCkMcfpRzNbIAFhz44rCNhMPCHfQBIFLHemM8ymFqvWMGx3fqJiJY4m2btziQcs9VwIsS3EsU2NpZn5Rkz9BTEdHtfnzffvsshNADnZrzzJSRJozRgFfBmKu720mV4CyBZe6pwAAa0cFlgq+4freA5xpCTWnr4jV+iDxFBRk1X2+65+uUw9jh8LIXT1SM7XVjeBYj73rJtC4FFJChmAqxfYlJm2ViTrSkGdz9Eoo7DZxn/jZwPGao3fj9w37TDNVHMzcBiePVsiSyZFWcQlSCOJ7YgS/te6tVQriqUU3XuRYFFGn+ED1HL167qDC8+DVVEx7Gdii6BHnmo7G
 /sEi5dIr
 TQXfUBPBrBdVQg6XGN4L6oXwyySjJnz6CpdUijfxAG+NPR+6E1+hQtc7IPLm8AzCTeZ0hnKV0ljCL3WH68cuxQLFt5E7mtF2BSWkhTi99YWCyN+k9Y+MM/dPlUtay65bjGok36HjrNgfzuSQqrVfzy+SIi8Hzp+7lbOcY8bLUt3VJCtZaYqdfKTLCLyuzNzsp4sBRy8MZZPAiQR1s/Or1bhN0PpLjHXYJd14BLq0AeWyBpyD59Ds6dRWu0rX8/ZOBe/PmSNK0mfDoxgSEF7QKHFhI2CDJ0XetCoA6/vPpsXb++shhJLREGnSCtQGQBS06uTh9s0icpjQYyhSzNBjNICEqXIbYadB0a+tp3hlbOBOADCFHXzSHWv9+pG3Ar08RdZ2UkMNxJtasbV7O5tWFJ7fQHSHHtE6V9fNdKE/JEJCfupHCoJQRixqYGMXUqWe3C0EhX5lWZZKXgaspmO/cRe+kU2Ny7tA1HiWEgKhSuTd7YWnrxYW2cm5plNueo6EjFvmCSsda+RTFjU1G3ppQrhKHVroaDOLvSN8xePJYtVNrluDc2LJbECHE62/PekWcH6i2Or56918pXdsgSztlnb21QYsxEneeVLOsTF3W6wApB2uCb0CkwVD5YxiUmeFlTrh14zfCRIs+Y4gLeVZFARRfRMqRFu4KxdoicjgCog89DRLWsWNeNqFQfbRzuhegMnLXk32tPlu8dnc=
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
 1 file changed, 217 insertions(+), 90 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 78d9694f75b5..df59ab0c1029 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -85,6 +85,9 @@ static bool zswap_pool_reached_full;
 
 #define ZSWAP_PARAM_UNSET ""
 
+/* Limit the batch size to limit per-CPU memory usage for dst buffers. */
+#define ZSWAP_MAX_BATCH_SIZE 4U
+
 static int zswap_setup(void);
 
 /* Enable/disable zswap */
@@ -144,10 +147,12 @@ struct zswap_acomp_req {
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
@@ -162,6 +167,7 @@ struct crypto_acomp_ctx {
  * The only case where lru_lock is not acquired while holding tree.lock is
  * when a zswap_entry is taken off the lru for writeback, in that case it
  * needs to be verified that it's still valid in the tree.
+ *
  */
 struct zswap_pool {
 	struct zs_pool *zs_pool;
@@ -226,6 +232,15 @@ struct zswap_entry {
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
@@ -284,6 +299,8 @@ static void __zswap_pool_empty(struct percpu_ref *ref);
 
 static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 {
+	u8 i;
+
 	if (!acomp_ctx)
 		return;
 
@@ -302,8 +319,12 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
 
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
@@ -388,6 +409,7 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 cpuhp_add_fail:
 	for_each_possible_cpu(cpu)
 		acomp_ctx_free(per_cpu_ptr(pool->acomp_ctx, cpu));
+
 error:
 	if (pool->acomp_ctx)
 		free_percpu(pool->acomp_ctx);
@@ -778,6 +800,44 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
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
+	u8 i;
+
+	bool ret = kmem_cache_alloc_bulk(zswap_entry_cache, gfp,
+					 zc->nr_pages, (void **)zc->entries);
+
+	if (likely(ret)) {
+		for (i = 0; i < zc->nr_pages; ++i)
+			zs_handle_init(&zc->entries[i]->handle);
+	} else {
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
@@ -842,7 +902,9 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
 	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
+	int nid = cpu_to_node(cpu);
 	int ret = -ENOMEM;
+	u8 i;
 
 	/*
 	 * To handle cases where the CPU goes through online-offline-online
@@ -853,15 +915,11 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
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
@@ -873,6 +931,24 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
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
@@ -890,7 +966,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 }
 
 static bool zswap_compress(struct folio *folio, long index,
-			   struct zswap_entry *entry, struct zswap_pool *pool)
+			   struct zswap_entry *entry, struct zswap_pool *pool,
+			   bool wb_enabled)
 {
 	struct zswap_comp_ctx *comp_ctx;
 	struct scatterlist input, output;
@@ -903,7 +980,7 @@ static bool zswap_compress(struct folio *folio, long index,
 	comp_ctx = &raw_cpu_ptr(pool->acomp_ctx)->comp;
 	mutex_lock(&comp_ctx->areq.mutex);
 
-	dst = comp_ctx->buffer;
+	dst = comp_ctx->buffers[0];
 	sg_init_table(&input, 1);
 	sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
 
@@ -942,12 +1019,8 @@ static bool zswap_compress(struct folio *folio, long index,
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
@@ -1530,91 +1603,125 @@ static void shrink_worker(struct work_struct *w)
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
-	zs_free(pool->zs_pool, &entry->handle);
-compress_failed:
-	zswap_entry_cache_free(entry);
+store_pages_failed:
+	for (i = store_fail_idx; i < zc->nr_pages; ++i) {
+		if (zs_handle_is_allocated(&zc->entries[i]->handle))
+			zs_free(pool->zs_pool, &zc->entries[i]->handle);
+	}
+
+	zswap_entries_cache_free_batch(&zc->entries[store_fail_idx],
+				       zc->nr_pages - store_fail_idx);
+
 	return false;
 }
 
@@ -1624,9 +1731,14 @@ bool zswap_store(struct folio *folio)
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
@@ -1660,8 +1772,23 @@ bool zswap_store(struct folio *folio)
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


