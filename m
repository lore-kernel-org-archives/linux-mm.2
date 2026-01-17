Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7206C98304
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 02:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58BD96B0005; Fri, 16 Jan 2026 21:54:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 563116B0088; Fri, 16 Jan 2026 21:54:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4654A6B0089; Fri, 16 Jan 2026 21:54:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 330B76B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 21:54:23 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D3C0F1AE54C
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:54:22 +0000 (UTC)
X-FDA: 84339937164.30.6983F19
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1B25C40002
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:54:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FYXXiWPt;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768618461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7zbu0DneLCA70t4hlen3zQtX7oTzsmiELCeInRa1oIY=;
	b=VlaExXZph8JWswnV7zWFEZvQOWQrOcqdN55q/8jbOpnG/E/3jDdYU60uY6gWbkCuwANwwK
	aeKRgrcna2+a2jZbaSGJjrBWs4Klpm1bdruLwOTZj424bfH3f9/K4iwQvXMVqDOoixUblS
	Zz/aarNcaQAaegWoJEs/iWeLwDl7wwA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FYXXiWPt;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768618461; a=rsa-sha256;
	cv=none;
	b=HmSmWwutkw1dlb1y9txg/4CI70bNL7/zaeCBbOzDVwCUqFWuV1Lr01Z/qaXzi2lCfHfN+B
	4y+x60xwoRmc3Y0BfTB9up0xA4v3P7fge9n+mBc+zHBmQ5OHtOjahifkxVKqov6Y8JG0zC
	/GO/qHmgENmChWmzHZOOR7z/yv7PaEQ=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a0a95200e8so17610985ad.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768618460; x=1769223260; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7zbu0DneLCA70t4hlen3zQtX7oTzsmiELCeInRa1oIY=;
        b=FYXXiWPt2JGtktrcCEjFeDockFEVHNazjhtXWMXQuD44C+ORorGaQ2ik2BXwQ/9wzr
         kiNuwkW2uJO0AO9DSC2jpqID248zDqDzwD+UsvNuKAaapMzoMmQKnFybGQztEf7+edRR
         xkFRUtEXEU5RQbKWiH9kZ21a7xNoqRadLoTUM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768618460; x=1769223260;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7zbu0DneLCA70t4hlen3zQtX7oTzsmiELCeInRa1oIY=;
        b=xILZOopHudbrlG08ylAcq5T0G9FtdyXlFQ8TSsVeVFv061kP3smLdnxRSEevxNJ4QN
         iOPF4rXNqdUneCoY2fVPU45b+xJtumLlYZh+vksRG586AyrGJoYvmhSPc3b0DoSSbvm8
         eMC3gHAScZA2168Mja9Lc8sthb582yIRtmj3fUD7m+bcPGNGNKcUI412eSx5rEPL/0kR
         oCGmJgi6ya2kmfY5Ph5PCL/eFbzFL9DohLpXwjuhbX/JaM/DKOhhqHo+6HzvCi5g0g0E
         1a0yBPZ8lbt6ftnefr4v0L0/ltS2UXIiRPcexKr/z7+I74htWfT35j8J91FwN2rIHvsp
         t1qg==
X-Forwarded-Encrypted: i=1; AJvYcCWQjjMa/0x3Fcd9O2RQBi/NO7jRoi+NCEoFUL8EWe8i7gYlf2eSdkc7jk0PlGXlD76z9xPoxitIqw==@kvack.org
X-Gm-Message-State: AOJu0Yy/MHXZVFtd+PXYkcXfpxprjPYEzqQS+gvanFpVJx3Ekr5kRPBq
	ReS+fRNIt4Cni7SroPnqC9PST02YqiB14kOKphv2GfS0Q0ZH2D6OB3ugqZP2g1MoMw==
X-Gm-Gg: AY/fxX7kOQOYZ3KL+WxfyoIucsGlPqZg9DwAIVlmQ/M7QfqtwoQGfbfbv5G4tUVmN5m
	omf/nOyLStwgnVtCCMkd4ZX3RG1QDMo88b+d1sNu2QcDScOY/7obNHyZAIgJyZwWN8xPoNGw5F+
	Ad9vLN8QDBlzNt7n4cLfd2yAvSCAZtF8ge4zmZENPrMHR6hNBClGyjVxH7vrf2VIKJacd3wR77P
	upLyjmQfdX5PmmiBXkFv6Z5jncWdAz4zs/PC6Z2M24I3oRKcQUhAomSQo0u1nPaF3XcDP7WLQQV
	Rcki4f1xlZqPtMuBp1OZqXs8IDfePQuRnRYzDhKrUNJiYPqnjOOVwCcHbzfPrHWY1p/vHkcFSqW
	p3z3nuMrhjHArIG8obg87g7BLXzqbS3fLnIAEbq6SqEfRO9Tf5dunMHrBkcr6OutK74+0lXG4sq
	V2Sc9+d+BOMCYrz/Ugqhf+pdYG5uVU/C5fX5wl7iYIHec/Iu+iIkQF2nZlXohxXn681WQmNXxa4
	g==
X-Received: by 2002:a17:902:e949:b0:299:e031:173 with SMTP id d9443c01a7336-2a7175a639amr47201055ad.35.1768618459805;
        Fri, 16 Jan 2026 18:54:19 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:fb0f:ccef:d815:5581])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193fbf76sm32252665ad.71.2026.01.16.18.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 18:54:19 -0800 (PST)
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
Subject: [PATCHv2] zsmalloc: make common caches global
Date: Sat, 17 Jan 2026 11:54:05 +0900
Message-ID: <20260117025406.799428-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1j7xwqfn76u8u967w4xbc18cxoe6gn1f
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B25C40002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768618460-376290
X-HE-Meta: U2FsdGVkX19V6DnI2p0Ih/7SWZEaBQEhkPyTyOsMYYvM82tSO4mryjl+AfVuD98+UZcjBN9hsgqpSv0p1cw2VTkkx6OVKp/Kpy7CGFvkbPq6jj9lXqRbb1UKl52JJhuMxFpcULwUrvaqoftQJrlRFuNlP2eCiYv4rp+52VlsQpMDEPPirF+xT80Z/OJKmSWr9Px6HMCC5gu5kvpUzHdwJopbRoIRgvEKxKlYONaxbCThb0ipn+MtMrQCQGj8BC4aZMaZxEPd+BhgwIV2sSEgP5Oa7jMyrejcZuzbWr0kecSU+vAMmEI+vyP42Wn4CiO/MAvHjHtkgus8S/beT8Rixw1WTD4YoCojjF1lT3czYB1MkTID/v/nSKOsLXiJEq2u1UPO3xeRFnARU5nPfrpm76SqpdbKySDFub6LITv9rX5RtOyFgaV/RBbiQMhdDvrqhXfUJP/o1w6FyXVpF7Ggr8xoJavli7i67C5tvVRygDKDplj0MucjTA5CBsNNXrmb6bHdN9R68C4uPjk1wUN3ND0ZS1P0mP+2yw+l9TSuvptPvUA/Hz//60jWKQp6f8OpiOGe4i9sENITvqtqgSqBmLNsVJgEtBPpR/o8VkMCpgQvRVIlXlKmMgiKaRB6STc6eAJyaJMiqX7AbBWcgddlxu7yI9QwZxA62FgUocGIMavg0uShSLVf2Vgk+58auH2Nea41h7yZUVMR+R963evorFlOWFHlsYTeCt+dQLDazTpFizZc06ECtFGsx7fPMbBeQG/KZKVxgsOZHlDOB+gCRWWphB5jd5tYqj6+wzLrA0cs9qAn2gG6cBSLzTsHbffwWsLETI3bXDOraLgEb1MIPlJhJJySCmuG5DsmhXRs9YtjQqzwWEboYeDIevDVIVBoWOgsAqOObk9dajZ/9d2gfPTzVcDvKtfgRqOB/npBOqw1VIIOyDNy5WcJ4K4S5cGcijYJwOSNknZBjPqWc5H
 sgsxEkZ+
 0dmAQkxx28pHV7QnXRlJeEN508Xw6T41/XcGZ8Sw8qvkpONT19ztkSxKq9OgECmrIu/Y8jQXIWEBNYn/3NGZC8DfOFi95dDlxFqmt89XsM/5mJDi+V0TRa1wpJ1CjwfXz8xwr88Fh7hFKxx00wI1HCHtElpskvxym+bDBhua/6n6CbZJHK+1RS5GS7w/o+OgdX7wFuEM+3rUSwSPuusvwHq33VSmW7CU5iiZblsTDpfMEF//aDHgNPweoJlRkBiHjPTEOc78IrihOlrwD9/8yeC563ynVSsclACPMv/W0MRgNpbmk/EWGyAUggA==
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

Make handles and zspages kmem caches global.  The memory
savings depend on particular setup and data patterns and
can be found via slabinfo.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---

v1->v2:
- factored out zs_destroy_caches/zs_init_caches (Yosry)

 mm/zsmalloc.c | 106 ++++++++++++++++++++++++--------------------------
 1 file changed, 50 insertions(+), 56 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 5a68349403d5..8df45aa1b5c8 100644
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
+	gfp = gfp & ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 
-	return 0;
-}
-
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
@@ -1344,7 +1313,7 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
 	if (unlikely(size > ZS_MAX_ALLOC_SIZE))
 		return (unsigned long)ERR_PTR(-ENOSPC);
 
-	handle = cache_alloc_handle(pool, gfp);
+	handle = cache_alloc_handle(gfp);
 	if (!handle)
 		return (unsigned long)ERR_PTR(-ENOMEM);
 
@@ -1368,7 +1337,7 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
 
 	zspage = alloc_zspage(pool, class, gfp, nid);
 	if (!zspage) {
-		cache_free_handle(pool, handle);
+		cache_free_handle(handle);
 		return (unsigned long)ERR_PTR(-ENOMEM);
 	}
 
@@ -1448,7 +1417,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 		free_zspage(pool, class, zspage);
 
 	spin_unlock(&class->lock);
-	cache_free_handle(pool, handle);
+	cache_free_handle(handle);
 }
 EXPORT_SYMBOL_GPL(zs_free);
 
@@ -2110,9 +2079,6 @@ struct zs_pool *zs_create_pool(const char *name)
 	if (!pool->name)
 		goto err;
 
-	if (create_cache(pool))
-		goto err;
-
 	/*
 	 * Iterate reversely, because, size of size_class that we want to use
 	 * for merging should be larger or equal to current size.
@@ -2234,20 +2200,47 @@ void zs_destroy_pool(struct zs_pool *pool)
 		kfree(class);
 	}
 
-	destroy_cache(pool);
 	kfree(pool->name);
 	kfree(pool);
 }
 EXPORT_SYMBOL_GPL(zs_destroy_pool);
 
+static void zs_destroy_caches(void)
+{
+	kmem_cache_destroy(handle_cachep);
+	handle_cachep = NULL;
+	kmem_cache_destroy(zspage_cachep);
+	zspage_cachep = NULL;
+}
+
+static int __init zs_init_caches(void)
+{
+	handle_cachep = kmem_cache_create("zs_handle", ZS_HANDLE_SIZE,
+					  0, 0, NULL);
+	zspage_cachep = kmem_cache_create("zspage", sizeof(struct zspage),
+					  0, 0, NULL);
+
+	if (!handle_cachep || !zspage_cachep) {
+		zs_destroy_caches();
+		return -ENOMEM;
+	}
+	return 0;
+}
+
 static int __init zs_init(void)
 {
-	int rc __maybe_unused;
+	int rc;
+
+	rc = zs_init_caches();
+	if (rc)
+		return rc;
 
 #ifdef CONFIG_COMPACTION
 	rc = set_movable_ops(&zsmalloc_mops, PGTY_zsmalloc);
-	if (rc)
+	if (rc) {
+		zs_destroy_caches();
 		return rc;
+	}
 #endif
 	zs_stat_init();
 	return 0;
@@ -2259,6 +2252,7 @@ static void __exit zs_exit(void)
 	set_movable_ops(NULL, PGTY_zsmalloc);
 #endif
 	zs_stat_exit();
+	zs_destroy_caches();
 }
 
 module_init(zs_init);
-- 
2.52.0.457.g6b5491de43-goog


