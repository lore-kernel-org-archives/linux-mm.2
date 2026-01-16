Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38CC8D4A5F6
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 04:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6844F6B0088; Thu, 15 Jan 2026 23:49:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 632606B0089; Thu, 15 Jan 2026 23:49:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53E086B008A; Thu, 15 Jan 2026 23:49:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 44A196B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:49:08 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB0F113B2C0
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:49:07 +0000 (UTC)
X-FDA: 84336597534.20.A8EFEA4
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id E355C40005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:49:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="PVjW/rl4";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768538946; a=rsa-sha256;
	cv=none;
	b=EWGAVR2jN/SZ694Wko/WgLN8nWUhmGt9G47q/CoBUVzomsUFKLDWQsLpjL8s+OkXqq/CvO
	mkS1JmNOoaAM5GD8ZwAyDQlsYoGjLvcsu7pDMXo3nd772fr862J4DAr7AAu2Ab0/d/V/wY
	5OQbRvMS/J6pYzBmdmVzhJHDvR3C+tM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="PVjW/rl4";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768538946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xzwKGJFEXzcfmx1MjYg5YriTA/MrKdzyh60azwxmvPA=;
	b=jybAXdl6cm6b6bZDtMiCmIq4dxtmHOvEmLhVuKJR2JEeDyk3kj6I5cnyaBhDrPV/y2fEBh
	4Ko9EPk2hz3C5/8mjDP5tJU1gmTNWgoEf6142JRGVEd1QUWVBEw1pec0l+x8wEUnkeHz60
	LF5PbiDucGfm5R9XOv62jzh4P7+ECZU=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-81f39438187so888554b3a.2
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768538945; x=1769143745; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xzwKGJFEXzcfmx1MjYg5YriTA/MrKdzyh60azwxmvPA=;
        b=PVjW/rl46Ge0p7GEsgddHb1C6J1/PccwSKgbs4+Z3h/KDUcNdUHHQ7OLiTmuLeasEs
         GKkZnfA1jZzomGcXLUY/JLqrOo4crKDtplMg5eLLiUzYGApr2Ukfnovr9Ltv61Vt4QG6
         1zzq3z9vGRYDAD/scaWTUCdsEegGngmkmgOsk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768538945; x=1769143745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xzwKGJFEXzcfmx1MjYg5YriTA/MrKdzyh60azwxmvPA=;
        b=DCrqs6rguL/chr5d48FSsjFSpJeLRUCnCLZs2Erf7HnDp4Ggb2ePeFpiGHweR5uShq
         TaWWKhdXfaHTmbcLJabfhvwC8gbwzoZJqU5CgNj1CYTaD7La9ua2ptsD+cf/A8Z05D0O
         LOBqBpySiDqE8GYoy2+IVFWkfbvnMqCEuIIYprfcNaeOqefQv1Nbyslwnhc9L+W30Z8k
         MxYeld/Gx+0o3c3d0/UW+oC44K6PELZlCdty7w+877V5jjzuRYeRCABftinZn5Dp04gS
         vtxxyQDkUoUWxuVp1Qn2Ic5YpdagSW7Z9U5BribciIbP6dWbefq1EWb8/KTB5IMRST0N
         Ti8w==
X-Forwarded-Encrypted: i=1; AJvYcCWkVkz9WDrnbG2uD0/bLuMREI88dPwch80Tyc+R0OslGtROo5CeT0Bi/pfcH+jWj5PErbKsjf1paA==@kvack.org
X-Gm-Message-State: AOJu0YzJ+6i4UzeGZBHQgjJw/ndoTf3ICIPwj6Um7fkAyOp5Z+X3KNT0
	sCmFENBcfqAoMGXm3EaqNNgK/MX+j3CXJ6YqxARkTZdZ6tpfuvObqj8E6VDsavlXaA==
X-Gm-Gg: AY/fxX7921z9yPht5V5c4e8E7XfnjbEAj1/pfgSWZD0Q6G04zMAEHL+S4sKHnDpu0BF
	o7Rx/rE0RlV7QKrw+ximKuDNye0vXgRzWdKIYMHL6jbPEpqnXA1A12jWGwz35fdqN/wmFeq01s3
	EarSLAadXVWXPJGZlkPDJ/b2ki/6hIzC7gAEcltslcL/iP1T6oFtBgBuEfFr31BfSfYhChHzTCA
	9BK5lZZijfYWEYraOuVBIDfxyVDvwKaeorLfwBNIr/PyxMdOMGZ7C/zZWuMXOSEDJ67jx7Q4jCn
	Gz+JDcSdd2a4XUjXkL0gqATo2GvOmQ8sez3PnDTziL6PuwsCCknJD/2oYjmj39OUYsc+UHgmIgI
	mvqZ0KtOQj3QlRH6J3xEuSvemoHp6K3JfAa+STNG0fDvK3FUBMyW16xRgpjR11a8AoyiCc6PHUy
	pj+JZUuJD585azabEuYLa4cwo4dPaHXRGKqa2wluasPT7k13+LvW7DaxbfsQfKqjbyzpmPxkw=
X-Received: by 2002:a05:6a00:1a8e:b0:81f:4884:4fed with SMTP id d2e1a72fcca58-81f9f7e4789mr1785267b3a.7.1768538944715;
        Thu, 15 Jan 2026 20:49:04 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:ba7a:360:116f:dac])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa1291135sm820852b3a.47.2026.01.15.20.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 20:49:04 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Minchan Kim <minchan@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [RFC PATCH] zsmalloc: make common caches global
Date: Fri, 16 Jan 2026 13:48:41 +0900
Message-ID: <20260116044841.334821-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E355C40005
X-Stat-Signature: s9mdgx6thqrznpgk6mzz3xhmtenwmsdu
X-Rspam-User: 
X-HE-Tag: 1768538945-248169
X-HE-Meta: U2FsdGVkX19NpAxxOjddiTLKorjv1yXdq1GhjnlIT0z77jll7ku9b4qNTu0KKcI9GERjaNNtEqjSY1U0eP+GPVeIt1nJQNfzN/1eCudTeEmFcG85tVot9hZEC+gjDy19ac+AJql7VVYa5gfRblV5e8f/85efMq7jgUoPrhD+k1iloYIJFAzqTAnZ1wSQrXu/+IHUtcgxw/EPE5XQROGDopR/c2vCnAvQ1uq9e80xFmzsEH3sjCO9U/fU5m/jTfqOiSRgckuSmMcYY2c9yKb1duPk5+r4s+9Hlx3cfDE57iDdEHjgV8mfkHK+AreI8EfNtnc4/+8Q7xlif25xQ0g/O/D0Hzanp2LRnuo1W+jAzxhOM9EVf34aRdjT0tTtb8Yn6QOC8btxzRZhOWUemezegS3nyPY/S4CiX5LfX2uNmtDAycJmkF3r7QbGmHN/Ws+rvbe1nwzI5XHChD+Hg0EGwiQ3hkDNLQrYVJfp8S9pP04/ThV25Wr/ZKfa6NG+/gbGQYDNjfS4F9DNeUHQkaiTkjNiobKQIcGF3sDkZGwo0RvJqQwpuIlxwjVyqRBUGJIFb8pOOv/kZK6/T7rz59o8JcXleoRirzpgbWCHMct9xpaj/p0oeWU0bwU8by/TpMuzKyYpMe/hIaLOigK0oQF/BVQAjfNoN4sbVisLHEFA+UxtCuEos31LZCEuI0A5Z1RW80Xfb6KznLjRwO9MyfDWBHeZjmFIz0k0nbzjb9t3J+eyg+Fx+Ctj8OzZ1A22r8HPD+3RpEEfY0FxvouDtj06RmziMA2hupmeh3X7wg3nQYVWyHrb8M+xh1w6L/iklarMJQ8xd3jmUKtrt8ED56noBb4bzCUQJDHEdc+o82mf28faZytDqtvtrrk3G7U9eNQwfBC2gkq/2UFuLs546f08mgD9OWSBmkIo2ujYe2mVZ0eLxgny45zODDu718jO5RZgFwE0x/IP4GITzL9npgE
 LIpz7OIB
 NNlTNaBdXxbaT5h5u/cXC5WBCT732YgTwLp+1eWQnrRDUoBtlDl0IjCfvNYhfLmQdcO6QPPtLr1n9mRMOjMR8oVQ4oFawqdnGgj4IvMQ8DuZ69GRYeh3QRZKY49CFdEV+d6VwJudRFWHJUzPWFxFAsAnjvmKodzoNgHkIanINHlOOv+G2LWWYk+yqLIsWvqfYkiPCPslE2gWOJuEy1BUekixetI4TcXvmIj7/jtqdwEfjUyfRjI3v+Cw4EPnA386mTgi4q0zqgL5S+3nPKS7EslIwprnFGQBC2ccJnn9raaO+OUrMOax7Ty7Rug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, zsmalloc creates kmem_cache of handles and zspages
for each pool, which may be suboptimal from the memory usage
point of view (extra internal fragmentation per pool).  Systems
that create multiple zsmalloc pools may benefit from shared
common zsmalloc caches.

Make handles and zspages kmem caches global.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/zsmalloc.c | 95 ++++++++++++++++++++++-----------------------------
 1 file changed, 40 insertions(+), 55 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 5abb8bc0956a..05ed3539aa1e 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -198,12 +198,13 @@ struct link_free {
 	};
 };
 
+static struct kmem_cache *handle_cachep;
+static struct kmem_cache *zspage_cachep;
+
 struct zs_pool {
 	const char *name;
 
 	struct size_class *size_class[ZS_SIZE_CLASSES];
-	struct kmem_cache *handle_cachep;
-	struct kmem_cache *zspage_cachep;
 
 	atomic_long_t pages_allocated;
 
@@ -376,60 +377,28 @@ static void init_deferred_free(struct zs_pool *pool) {}
 static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage) {}
 #endif
 
-static int create_cache(struct zs_pool *pool)
+static unsigned long cache_alloc_handle(gfp_t gfp)
 {
-	char *name;
-
-	name = kasprintf(GFP_KERNEL, "zs_handle-%s", pool->name);
-	if (!name)
-		return -ENOMEM;
-	pool->handle_cachep = kmem_cache_create(name, ZS_HANDLE_SIZE,
-						0, 0, NULL);
-	kfree(name);
-	if (!pool->handle_cachep)
-		return -EINVAL;
-
-	name = kasprintf(GFP_KERNEL, "zspage-%s", pool->name);
-	if (!name)
-		return -ENOMEM;
-	pool->zspage_cachep = kmem_cache_create(name, sizeof(struct zspage),
-						0, 0, NULL);
-	kfree(name);
-	if (!pool->zspage_cachep) {
-		kmem_cache_destroy(pool->handle_cachep);
-		pool->handle_cachep = NULL;
-		return -EINVAL;
-	}
-
-	return 0;
-}
+	gfp = gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 
-static void destroy_cache(struct zs_pool *pool)
-{
-	kmem_cache_destroy(pool->handle_cachep);
-	kmem_cache_destroy(pool->zspage_cachep);
+	return (unsigned long)kmem_cache_alloc(handle_cachep, gfp);
 }
 
-static unsigned long cache_alloc_handle(struct zs_pool *pool, gfp_t gfp)
+static void cache_free_handle(unsigned long handle)
 {
-	return (unsigned long)kmem_cache_alloc(pool->handle_cachep,
-			gfp & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
+	kmem_cache_free(handle_cachep, (void *)handle);
 }
 
-static void cache_free_handle(struct zs_pool *pool, unsigned long handle)
+static struct zspage *cache_alloc_zspage(gfp_t gfp)
 {
-	kmem_cache_free(pool->handle_cachep, (void *)handle);
-}
+	gfp = gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 
-static struct zspage *cache_alloc_zspage(struct zs_pool *pool, gfp_t flags)
-{
-	return kmem_cache_zalloc(pool->zspage_cachep,
-			flags & ~(__GFP_HIGHMEM|__GFP_MOVABLE));
+	return kmem_cache_zalloc(zspage_cachep, gfp);
 }
 
-static void cache_free_zspage(struct zs_pool *pool, struct zspage *zspage)
+static void cache_free_zspage(struct zspage *zspage)
 {
-	kmem_cache_free(pool->zspage_cachep, zspage);
+	kmem_cache_free(zspage_cachep, zspage);
 }
 
 /* class->lock(which owns the handle) synchronizes races */
@@ -858,7 +827,7 @@ static void __free_zspage(struct zs_pool *pool, struct size_class *class,
 		zpdesc = next;
 	} while (zpdesc != NULL);
 
-	cache_free_zspage(pool, zspage);
+	cache_free_zspage(zspage);
 
 	class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
 	atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
@@ -971,7 +940,7 @@ static struct zspage *alloc_zspage(struct zs_pool *pool,
 {
 	int i;
 	struct zpdesc *zpdescs[ZS_MAX_PAGES_PER_ZSPAGE];
-	struct zspage *zspage = cache_alloc_zspage(pool, gfp);
+	struct zspage *zspage = cache_alloc_zspage(gfp);
 
 	if (!zspage)
 		return NULL;
@@ -993,7 +962,7 @@ static struct zspage *alloc_zspage(struct zs_pool *pool,
 				zpdesc_dec_zone_page_state(zpdescs[i]);
 				free_zpdesc(zpdescs[i]);
 			}
-			cache_free_zspage(pool, zspage);
+			cache_free_zspage(zspage);
 			return NULL;
 		}
 		__zpdesc_set_zsmalloc(zpdesc);
@@ -1346,7 +1315,7 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
 	if (unlikely(size > ZS_MAX_ALLOC_SIZE))
 		return (unsigned long)ERR_PTR(-ENOSPC);
 
-	handle = cache_alloc_handle(pool, gfp);
+	handle = cache_alloc_handle(gfp);
 	if (!handle)
 		return (unsigned long)ERR_PTR(-ENOMEM);
 
@@ -1370,7 +1339,7 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
 
 	zspage = alloc_zspage(pool, class, gfp, nid);
 	if (!zspage) {
-		cache_free_handle(pool, handle);
+		cache_free_handle(handle);
 		return (unsigned long)ERR_PTR(-ENOMEM);
 	}
 
@@ -1450,7 +1419,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 		free_zspage(pool, class, zspage);
 
 	spin_unlock(&class->lock);
-	cache_free_handle(pool, handle);
+	cache_free_handle(handle);
 }
 EXPORT_SYMBOL_GPL(zs_free);
 
@@ -2112,9 +2081,6 @@ struct zs_pool *zs_create_pool(const char *name)
 	if (!pool->name)
 		goto err;
 
-	if (create_cache(pool))
-		goto err;
-
 	/*
 	 * Iterate reversely, because, size of size_class that we want to use
 	 * for merging should be larger or equal to current size.
@@ -2236,7 +2202,6 @@ void zs_destroy_pool(struct zs_pool *pool)
 		kfree(class);
 	}
 
-	destroy_cache(pool);
 	kfree(pool->name);
 	kfree(pool);
 }
@@ -2246,10 +2211,28 @@ static int __init zs_init(void)
 {
 	int rc __maybe_unused;
 
+	handle_cachep = kmem_cache_create("zs_handle", ZS_HANDLE_SIZE, 0, 0,
+					  NULL);
+	if (!handle_cachep)
+		return -ENOMEM;
+
+	zspage_cachep = kmem_cache_create("zspage", sizeof(struct zspage), 0,
+					  0, NULL);
+	if (!zspage_cachep) {
+		kmem_cache_destroy(handle_cachep);
+		handle_cachep = NULL;
+		return -ENOMEM;
+	}
+
 #ifdef CONFIG_COMPACTION
 	rc = set_movable_ops(&zsmalloc_mops, PGTY_zsmalloc);
-	if (rc)
+	if (rc) {
+		kmem_cache_destroy(zspage_cachep);
+		kmem_cache_destroy(handle_cachep);
+		zspage_cachep = NULL;
+		handle_cachep = NULL;
 		return rc;
+	}
 #endif
 	zs_stat_init();
 	return 0;
@@ -2261,6 +2244,8 @@ static void __exit zs_exit(void)
 	set_movable_ops(NULL, PGTY_zsmalloc);
 #endif
 	zs_stat_exit();
+	kmem_cache_destroy(zspage_cachep);
+	kmem_cache_destroy(handle_cachep);
 }
 
 module_init(zs_init);
-- 
2.52.0.457.g6b5491de43-goog


