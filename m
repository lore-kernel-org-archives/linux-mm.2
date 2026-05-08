Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A692CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 06:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37496B00F6; Fri,  8 May 2026 02:08:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0E506B00F8; Fri,  8 May 2026 02:08:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A24796B00F9; Fri,  8 May 2026 02:08:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9111C6B00F6
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:08:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 250E6160764
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:08:39 +0000 (UTC)
X-FDA: 84743223558.22.625012F
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2DC12C000C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:08:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="AnZrz/ob";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778220517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=daHGfdxKfsNdfAdW1qTjK0dkvxPd9/EICvnVIHa78Qk=;
	b=xr1YRBAxVhf2FfSq8KqQDBuZSy0gfkVePMGTnipACwV/Y5gaQ6VlktAIaqlfqwkozoF8DL
	E+xrN4f6Tnk20Q45TuhsDGIzsyZFBm8G2/Qa1wKrg0uaXIF3hyJhxvyb8/xe3Pkn4vb3vB
	KhBX/CKawAs4x7gDp4XAAHtIbbP4030=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778220517; a=rsa-sha256;
	cv=none;
	b=KdTqdmIxjNjulmCpPm1AmYq6AM1Dln+lPuQbO82D3JltQ3gyrP+xxKQOnUI38xCH9oL2+r
	8H7lOpGsCEfzyZ8eQ+LCFHht3Phb+RNUIudYrmF5NEfqkynkjcrS84Dzlq7ia9LhncPAB6
	tlXwQGYfpFIjCMtB8Cy+dGJWzd0T+So=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="AnZrz/ob";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3660ab73adbso893003a91.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 23:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778220516; x=1778825316; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=daHGfdxKfsNdfAdW1qTjK0dkvxPd9/EICvnVIHa78Qk=;
        b=AnZrz/obHXEdQR9+ylBcoNrc/9JAwnsfEeefji02ZlOAmHZxEsmvTJXcka3TUbPRUG
         /sQW7taRczl3hoNlC7X5GshpR1Mr5L6FZoPQXWEYFHQnDt9tTKmtv8xZQ+vD2SuY2ABo
         fCgJ48pIIFPUWUMzLkkq0QtN8hPU1ym2K1EVIfnkkdvPf+OIWIgMgBasBdKyxemGN4xH
         NeGTekTg9vhnqRZsQxi1GTeQGHj9b55wmIG6T0K18g93eM+K9+j3zOFO9wf1Yu7CDKwA
         Uwg4R8QmMUSC6royPfMsv4OnhibDZvwIkHvR1+pARVCf3d6Z4KMVhz6W3JU5iFDTkeG+
         Ehxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778220516; x=1778825316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=daHGfdxKfsNdfAdW1qTjK0dkvxPd9/EICvnVIHa78Qk=;
        b=MJpn4L53FPIw3WDrvpGAdv2QPoV+feKukfBiGflH3H4eFYR32As44MMUgGL0gQOmuv
         so8ytbRuHZq57nmwlIhmuw0pr7AaEXK89SYzwKeGKV+oalDA0Q2TMC8wm+xvAOco488y
         IHDcZrcaLqp2R+gCbc4DFVw+Yi3fmKVfts+dr1bPOM1FZwuuf46bIoKuSqLWWG7W30Aw
         zytAhSjuvtaJfi9dHQvTyim7CQLm/THHi8Iotq4GROc1GoNLGw0LbAWl1azRrmBDaoef
         f5rQNzXwhMoytzoHPQnV1TpKUTunS68YJXaXjp0MLDNzXguPPQg4vs1xnpzQME3dcKVA
         cvJQ==
X-Forwarded-Encrypted: i=1; AFNElJ/xLWEt/BChAzDOiMLj1fo0fjmTBSiZ2mB3BJV+CPxaPJPWQV+F9DFwUMIyUCm9Y1bRJIk2uvFguw==@kvack.org
X-Gm-Message-State: AOJu0Yw+m6rIoM2LnAY7tsOvK06CuRF6TMvoUHhQthLYJeGvOAOqPBlP
	a0lv9Hq3lhJlzLxiAMoqZAY4IEgWDXcD6LfYQUJtXhDqP6MPrQERbTdg
X-Gm-Gg: Acq92OFTRUJjRMoCixNaJcyvB4YZ/bIqQQTf+A4S2XSgmoRD4GnCPr3Ci4SV6BX0rLC
	OsnbdW5Bpnn2vrTaavRgbYhhR46eXYAOtA9u9ZiYNqKTba44F1LSB8Xc3/FwdtilL3IsfnZMXY0
	JCbzQzseto2B5vojHJpNwgn0m32VtPzpBt9qNKjfDFIhkdxsHmQSh5683S75skq2bcazY1Nr370
	dYYsTIMHClcJtZr9LwBw6sPAhT1SAPByVUqdI10HEYc6GLZ/YkF5hq5GAORWXuLqBImwd8PI5Ea
	ZLHyo8IonHaTUrZhJZaadn3ww0GbymHVHWS9YaJZtrnErVR82PK6q8ufbXVsNjOn16+3iz912Qz
	xbwk5GsqsH9eanBGN24wPjvRhmFsWgW0jp+CYH3KW37ZDC1tWgSPuAMVlYXCK3imRQ9dDjs5yY1
	FbQlLknn4hVRm7sVBqQ9t2bVzbLYDbpnu4YOqPsKG0u9uvl+z0
X-Received: by 2002:a17:90b:5486:b0:35f:b230:5889 with SMTP id 98e67ed59e1d1-366053e90a9mr5119623a91.6.1778220515779;
        Thu, 07 May 2026 23:08:35 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36645bb9c02sm673651a91.1.2026.05.07.23.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 23:08:35 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
X-Google-Original-From: Wenchao Hao <haowenchao@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <21cnbao@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>
Cc: Wenchao Hao <haowenchao22@gmail.com>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [RFC PATCH v3 1/4] mm/zsmalloc: introduce deferred free framework with callback ops
Date: Fri,  8 May 2026 14:07:21 +0800
Message-Id: <20260508060724.3810904-2-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260508060724.3810904-1-haowenchao@xiaomi.com>
References: <20260508060724.3810904-1-haowenchao@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2DC12C000C
X-Stat-Signature: qogbr8cs4x1dznrpaooicauy7936g38c
X-Rspam-User: 
X-HE-Tag: 1778220516-967221
X-HE-Meta: U2FsdGVkX1+OxYmHfe9l1aOJ/siZ9hD9VkJro1/f/68+57BHk5eHjcCB5D2/vd7d3ihulsdtG6NJmWJjp/pUad2ejBG/AYY/JB/kS917eWVux3qbcvHxQiVjs7iXVypTEhYYcMh161V7qK7niD7H94+DbSYJGRBZjSCZn3qIyp6BFXUt+UotoC6Krf0MmzyIa9ncOLNXXih3GkXaf5tP4ak43XzM6IFaXbfs14MSz7BNUMK2Ntr8spHMr8l1k4sHwsO2KoB+PZAND7cwaHvNEq/41wbRs9D1elmGgEo3j+7EnSCQNAeJjsI7aUrWvSuRyE/qNzGGP6PcIbfP2cJl+b2+HwQuGdnM2taEg4XIEZqpzyA+bBEL96fdMFD6bIZ30iJDgHWUsoCfHT2nlBeXvWy4qNDVUQdwu9MWClQZttlEh6xoJ+wD3G0BZszlKE40ScNUbIHpR9aY8Z+GCfB9xiMI33elPqguM0UiOroAbnb2V+0/ST6Xn9+u0lX6tMdB5uYxdyVAgHDhoEG9mQLXOKiWAL7gzijj2QoEaWF3PBFrEXshwEefFogll7jwvDpqUFif2LBkInbKF5wbR92o4KNT/lQAVcRy4TLyCuhOdT1c8pV8HQbJyYoZ5q8GEVfs3gOpn1Nr3rop2CMlMkkUwmzq1ZjtRf/70VJzUi6Pe8cRbP4N+W2riKeKCkl2eAy+CiHhH8bSb3ZQeHnA9BCnYF7uV3A42bvjLv2yusj+yvtaSpr0rgGV4H532Epse8ROVPjb+5DIAmCZRpk2enwwep+WfLA+7vbXjozwjV4WC3P1cGf+5ITnpUI5pCzgYpM3nTcQgax5BzFERqoGgEs47VMDod958gITMSREdIl7fpUKgush4oVw8Og7i9tfdyvKMsx0wodWiON0jNpu7MmoIcsFW9QqP9cR+TTKbdEeVvLYMtoG1j2+aswhdoMvQhw3u+FM/N5mciICzGfp5hK
 jrD/O/f9
 sxuBKeRh5q7uiinuOrdK9QRUwG3gR+0DjrfHq7tYYSf7FOWIcik2WXCmS7YQeZT2/wezHt5iKibhT5/PFV4jluroZ/IUUGgiWHeoWcCoNKtX6a1hPCnUnSh8pxCO7UDcBvd0MDQ2BeFAYk8K+b2UHPVQHNIbVeFs/nFyRluOyDxSzchmUh7D7U0r4+GzbuLf9p+olx2zs2WiINLh36JUz+1SyeVV4/rrgvo7541QiPbnL1G89geNijr7mnr/KwW+i64OGLNAXO6SRu1i0fhc3YAZ2u109ktwqQ4/olxbv+4UGFrUPOiXdOp1caUBMM/n7o7lgDpGjdNzKByKeyfXsVJMTIcAiLOehvj2wzwT8g6f7xCaRv5iX9vHacYPV1eImyrLEGftnnLEY2xAlq3esgpuFqfn/t0jgzYM+DthM5VFTY0aBIKohnuYd4TQcZx+Swc+UcSWLh36RVNaEByYvBT04ZZo5rDKw/rrJf3VpSYz9SSy97AGXVPZ8+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a per-cpu deferred free mechanism to zsmalloc with a callback
interface that lets callers (zram, zswap) customize push and drain
behavior.

Each CPU owns a single-page buffer. The hot path (zs_free_deferred)
writes a value into the current CPU's buffer via the push callback
with preemption disabled — no locks, no atomics. When the buffer
fills, it is swapped with a fresh page from a pre-allocated page
pool and the full page is queued to a WQ_UNBOUND worker for drain.

The drain worker invokes the drain callback which performs the actual
expensive work (zs_free, slot_free, etc.) in batch, away from the
original hot path.

Page pool management:
  - Pool is pre-allocated at enable time (ZS_DEFERRED_POOL_SIZE pages)
  - Full buffers are drained and returned to the pool
  - If no free page is available when buffer is full, the push falls
    back to synchronous processing by the caller

Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 include/linux/zsmalloc.h |  16 +++
 mm/zsmalloc.c            | 208 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 223 insertions(+), 1 deletion(-)

diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 478410c880b1..8d6c675b10dc 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -24,12 +24,28 @@ struct zs_pool_stats {
 struct zs_pool;
 struct scatterlist;
 
+enum zs_push_ret {
+	ZS_PUSH_OK = 0,
+	ZS_PUSH_FULL,
+	ZS_PUSH_FULL_QUEUED,
+};
+
+struct zs_deferred_ops {
+	enum zs_push_ret (*push)(void *buf, unsigned int count,
+					  unsigned long value);
+	void (*drain)(void *private, void *buf, unsigned int count);
+};
+
 struct zs_pool *zs_create_pool(const char *name);
 void zs_destroy_pool(struct zs_pool *pool);
 
 unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t flags,
 			const int nid);
 void zs_free(struct zs_pool *pool, unsigned long obj);
+int zs_pool_enable_deferred_free(struct zs_pool *pool,
+				 const struct zs_deferred_ops *ops,
+				 void *private);
+bool zs_free_deferred(struct zs_pool *pool, unsigned long value);
 
 size_t zs_huge_class_size(struct zs_pool *pool);
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 63128ddb7959..d8220a8753a7 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -196,6 +196,13 @@ struct link_free {
 static struct kmem_cache *handle_cachep;
 static struct kmem_cache *zspage_cachep;
 
+#define ZS_DEFERRED_POOL_SIZE	(256 * 1024 / PAGE_SIZE)
+
+struct zs_deferred_percpu {
+	unsigned int count;
+	void *buf;
+};
+
 struct zs_pool {
 	const char *name;
 
@@ -217,6 +224,18 @@ struct zs_pool {
 	/* protect zspage migration/compaction */
 	rwlock_t lock;
 	atomic_t compaction_in_progress;
+
+	/* per-cpu deferred free */
+	const struct zs_deferred_ops *deferred_ops;
+	void *deferred_private;
+	struct zs_deferred_percpu __percpu *deferred;
+	struct work_struct deferred_work;
+	struct workqueue_struct *deferred_wq;
+	struct list_head deferred_pool;
+	unsigned int deferred_pool_count;
+	spinlock_t deferred_pool_lock;
+	struct list_head deferred_drain_list;
+	spinlock_t deferred_drain_lock;
 };
 
 static inline void zpdesc_set_first(struct zpdesc *zpdesc)
@@ -1416,6 +1435,171 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 }
 EXPORT_SYMBOL_GPL(zs_free);
 
+static struct page *deferred_pool_get(struct zs_pool *pool)
+{
+	struct page *page = NULL;
+
+	spin_lock(&pool->deferred_pool_lock);
+	if (!list_empty(&pool->deferred_pool)) {
+		page = list_first_entry(&pool->deferred_pool, struct page, lru);
+		list_del(&page->lru);
+		pool->deferred_pool_count--;
+	}
+	spin_unlock(&pool->deferred_pool_lock);
+	return page;
+}
+
+static void deferred_pool_put(struct zs_pool *pool, struct page *page)
+{
+	spin_lock(&pool->deferred_pool_lock);
+	list_add_tail(&page->lru, &pool->deferred_pool);
+	pool->deferred_pool_count++;
+	spin_unlock(&pool->deferred_pool_lock);
+}
+
+static void zs_deferred_work_fn(struct work_struct *work)
+{
+	struct zs_pool *pool = container_of(work, struct zs_pool, deferred_work);
+	struct page *page;
+
+	while (true) {
+		unsigned int count;
+
+		spin_lock(&pool->deferred_drain_lock);
+		if (list_empty(&pool->deferred_drain_list)) {
+			spin_unlock(&pool->deferred_drain_lock);
+			break;
+		}
+		page = list_first_entry(&pool->deferred_drain_list,
+					struct page, lru);
+		list_del(&page->lru);
+		count = page_private(page);
+		spin_unlock(&pool->deferred_drain_lock);
+
+		pool->deferred_ops->drain(pool->deferred_private,
+					  page_address(page), count);
+		deferred_pool_put(pool, page);
+		cond_resched();
+	}
+}
+
+bool zs_free_deferred(struct zs_pool *pool, unsigned long value)
+{
+	struct zs_deferred_percpu *def;
+	struct page *new_page, *full_page;
+	enum zs_push_ret ret;
+
+	if (!pool->deferred)
+		return false;
+
+	def = get_cpu_ptr(pool->deferred);
+
+	ret = pool->deferred_ops->push(def->buf, def->count, value);
+	if (ret == ZS_PUSH_OK) {
+		def->count++;
+		put_cpu_ptr(pool->deferred);
+		return true;
+	}
+
+	if (ret == ZS_PUSH_FULL_QUEUED)
+		def->count++;
+
+	new_page = deferred_pool_get(pool);
+	if (new_page) {
+		full_page = virt_to_page(def->buf);
+		set_page_private(full_page, def->count);
+		def->buf = page_address(new_page);
+		def->count = 0;
+
+		if (ret == ZS_PUSH_FULL) {
+			pool->deferred_ops->push(def->buf, 0, value);
+			def->count = 1;
+		}
+		put_cpu_ptr(pool->deferred);
+
+		spin_lock(&pool->deferred_drain_lock);
+		list_add_tail(&full_page->lru, &pool->deferred_drain_list);
+		spin_unlock(&pool->deferred_drain_lock);
+		queue_work(pool->deferred_wq, &pool->deferred_work);
+		return true;
+	}
+	put_cpu_ptr(pool->deferred);
+
+	/* ret==2: value already queued, will be drained eventually */
+	if (ret == 2)
+		return true;
+
+	/* ret==1: value not queued, caller must fallback */
+	return false;
+}
+EXPORT_SYMBOL_GPL(zs_free_deferred);
+
+int zs_pool_enable_deferred_free(struct zs_pool *pool,
+				 const struct zs_deferred_ops *ops,
+				 void *private)
+{
+	int cpu;
+	unsigned int pg_idx;
+	struct page *page, *tmp;
+
+	pool->deferred_ops = ops;
+	pool->deferred_private = private;
+
+	INIT_WORK(&pool->deferred_work, zs_deferred_work_fn);
+	pool->deferred_wq = alloc_workqueue("zs_drain", WQ_UNBOUND, 0);
+	if (!pool->deferred_wq)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&pool->deferred_pool);
+	spin_lock_init(&pool->deferred_pool_lock);
+	pool->deferred_pool_count = 0;
+	INIT_LIST_HEAD(&pool->deferred_drain_list);
+	spin_lock_init(&pool->deferred_drain_lock);
+
+	for (pg_idx = 0; pg_idx < ZS_DEFERRED_POOL_SIZE; pg_idx++) {
+		page = alloc_page(GFP_KERNEL);
+		if (!page)
+			goto err_pages;
+		list_add_tail(&page->lru, &pool->deferred_pool);
+		pool->deferred_pool_count++;
+	}
+
+	pool->deferred = alloc_percpu(struct zs_deferred_percpu);
+	if (!pool->deferred)
+		goto err_pages;
+
+	for_each_possible_cpu(cpu) {
+		struct zs_deferred_percpu *def = per_cpu_ptr(pool->deferred, cpu);
+
+		page = deferred_pool_get(pool);
+		if (!page)
+			goto err_percpu;
+		def->buf = page_address(page);
+		def->count = 0;
+	}
+
+	return 0;
+
+err_percpu:
+	for_each_possible_cpu(cpu) {
+		struct zs_deferred_percpu *def = per_cpu_ptr(pool->deferred, cpu);
+
+		if (def->buf)
+			deferred_pool_put(pool, virt_to_page(def->buf));
+	}
+	free_percpu(pool->deferred);
+	pool->deferred = NULL;
+err_pages:
+	list_for_each_entry_safe(page, tmp, &pool->deferred_pool, lru) {
+		list_del(&page->lru);
+		__free_page(page);
+	}
+	destroy_workqueue(pool->deferred_wq);
+	pool->deferred_wq = NULL;
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(zs_pool_enable_deferred_free);
+
 static void zs_object_copy(struct size_class *class, unsigned long dst,
 				unsigned long src)
 {
@@ -2182,9 +2366,31 @@ EXPORT_SYMBOL_GPL(zs_create_pool);
 
 void zs_destroy_pool(struct zs_pool *pool)
 {
-	int i;
+	int i, cpu;
+	struct page *page, *tmp;
 
 	zs_unregister_shrinker(pool);
+
+	if (pool->deferred) {
+		flush_work(&pool->deferred_work);
+		for_each_possible_cpu(cpu) {
+			struct zs_deferred_percpu *def =
+				per_cpu_ptr(pool->deferred, cpu);
+
+			if (def->buf && def->count)
+				pool->deferred_ops->drain(pool->deferred_private,
+							  def->buf, def->count);
+			if (def->buf)
+				deferred_pool_put(pool, virt_to_page(def->buf));
+		}
+		free_percpu(pool->deferred);
+		list_for_each_entry_safe(page, tmp, &pool->deferred_pool, lru) {
+			list_del(&page->lru);
+			__free_page(page);
+		}
+		destroy_workqueue(pool->deferred_wq);
+	}
+
 	zs_flush_migration(pool);
 	zs_pool_stat_destroy(pool);
 
-- 
2.34.1


