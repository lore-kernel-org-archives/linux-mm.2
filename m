Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56A79CD343F
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 08:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7455F6B0309; Sat,  9 May 2026 04:39:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5946B030B; Sat,  9 May 2026 04:39:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5156B030C; Sat,  9 May 2026 04:39:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4B6886B0309
	for <linux-mm@kvack.org>; Sat,  9 May 2026 04:39:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD541A05CF
	for <linux-mm@kvack.org>; Sat,  9 May 2026 08:39:34 +0000 (UTC)
X-FDA: 84747232668.12.BAD1E56
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id E55E540005
	for <linux-mm@kvack.org>; Sat,  9 May 2026 08:39:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=liYZ9TNy;
	spf=pass (imf04.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778315973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uWYASY6BZuBGzOxx/4aApTWOR4/wdjoaLtz5Jpeyx+k=;
	b=pVFEs1gEQ5o3tiyVSYylczuKgnZYXi4jYfRn8E6ZBSwRTGO0DPhCJEzbIpismp74kY81Z9
	sBJi4DngGLGYr1JN3hFi7AvSyp7gAe12US5U/W5BBVdze586DTBwLYKYp009iaowOdSpqm
	Z5nVhIXzTWiBY8sgu3KGbz2knVJ/9y8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=liYZ9TNy;
	spf=pass (imf04.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778315973; a=rsa-sha256;
	cv=none;
	b=lfLP2uTIf+RsHjSaoZ5csKWr3X24bWzh6Efbicx0GsdawLpBPS09s85nov356gs18InXnk
	gig+llS8hJUxW+BkaH3dBGDqA6rvlJqJ6FfrJPb+saBCgOFHIB4ayU1QR++9xjVe9wMgK3
	uZ8yH37f3uiBPX8Urk7i4aOXyqQPXX4=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-367d88b9940so156758a91.1
        for <linux-mm@kvack.org>; Sat, 09 May 2026 01:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778315972; x=1778920772; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uWYASY6BZuBGzOxx/4aApTWOR4/wdjoaLtz5Jpeyx+k=;
        b=liYZ9TNyk/jYQzCvqpWRju5y5GbdutIUsi0cwKZtcZHqTuTnK+k3SyWjvsi6K2nStp
         S/QxeHeMmajN1diVVHOP184BQyDbgmXQ76/pxgwBu7kXq6BXfEnV6HrjYGGMxqMiJphQ
         37n6Mou/79ZDTXRwypTqBfN9VtEDvUlztaJMD1oMy+UwKQxmdO9IGVBKUSaO2RtYYlpN
         3/nGWUtMUMxp8imGqh3qrwqpRd4fR8NtMwDmI6qAZ2SPJBHBxe3cyrY6LWSH0AigRNTC
         bXqXO0f61108nSniUwGeEwxGbdtY1ZId0XtG8ZcZ8eZi+3YbRv7QRdvI4bF89UchHTDB
         dP1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778315972; x=1778920772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uWYASY6BZuBGzOxx/4aApTWOR4/wdjoaLtz5Jpeyx+k=;
        b=lw6753cUZmkhJcdhAIHut2n5XP9LHSxBx3tIvfneenjbR/5InZumGRFUzObYdgrlOF
         7McGPsATgIdO4ejiSPf79EBcq1qGFkxeGE/LHrLjgtDZafO/H4MWjXTxEjCqMKytddWh
         WSDvesxI2G7DU3j5k+hEePtQ6PsfiKtLQhPvMTicPMsvRAwsBDFze8PfPBpsMlkol2ew
         UZLyYP9l0tkHax15ItbObzdaOwQveNedGiEmXhj/JWmJ9X0UpbwALXbxq8TEaEajPaKM
         0BlK3Lub5CFbBztIfdLTyTUl4ApaKnPJh5XkcvlVV5h0x+lKEfJ8+jocWCNrHZjmZDuy
         Z6Kw==
X-Forwarded-Encrypted: i=1; AFNElJ9wU5gMVadk0g/ouz4BCvcp35FtpCc0qL7Y6mmdIwYXtNNAeqNXW0bxQI0kNVkcwcnrNYfumkvWjQ==@kvack.org
X-Gm-Message-State: AOJu0Yz6EbdadA3urA6uwAU4yBL88m97nfZFFiqGWD7sRi+kx3PJ8hUr
	7Gne+C+7rtAvsMYo1JaJF8T4uZKF+YXr3JHsqLbylYmfrZC+tWo/2vfk
X-Gm-Gg: Acq92OEH21RqdiDFpiZE0FeACjTpe8e+y6tcNFbLRxAx+Cn8sSG/StyOY/BpU2O7+OT
	JKUsRZdkziLH2lyjDbMtUGOmvYHlYIRBDjpJcaq34/R4gpbhZ2cSDDelIaI5ANWoMpSREyd6Od7
	ZOAfEaHxhBHfb4QUCwVNarmQVSl1aVbirmZwN0Ap8XT66UB5JtaMYU9QWXMGEUEjoMBO2IPHKy5
	Tvk2qdCGf8XoQSmVFQXi++Z6cO2Wy5tv+LDlSoBiV4EZITZgFGe/os+/iil3wEbuDdoNyEwYrzT
	y3b+UZzkqCZPH7e9hSCdMkF/D204Q8BitxR2tPyp8XOZK5gGnlwXHosudh27GxnyKf3G41iqPgU
	8hPGHfyc8t8iLn208GOPIKjt4O0WFP0TzZyBQinA2qdJceX1UKWJbBWZBtY62vjFKelipjM10ZJ
	5867Z2BXDMXkN1fSX8NnRd9bC2dN9DsCA+vCjFCxeuWPjPSJ9B
X-Received: by 2002:a17:90b:2fcf:b0:35f:bfdd:f5a1 with SMTP id 98e67ed59e1d1-3664ccca3d8mr6141448a91.13.1778315971588;
        Sat, 09 May 2026 01:39:31 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367d629c17esm1378291a91.6.2026.05.09.01.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2026 01:39:31 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
X-Google-Original-From: Wenchao Hao <haowenchao@xiaomi.com>
To: haowenchao22@gmail.com
Cc: 21cnbao@gmail.com,
	akpm@linux-foundation.org,
	axboe@kernel.dk,
	chengming.zhou@linux.dev,
	hannes@cmpxchg.org,
	haowenchao@xiaomi.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@kernel.org,
	nphamcs@gmail.com,
	senozhatsky@chromium.org,
	yosry@kernel.org
Subject: Re: [RFC PATCH v3 0/4] mm/zsmalloc: per-cpu deferred free to accelerate swap entry release
Date: Sat,  9 May 2026 16:38:24 +0800
Message-Id: <20260509083824.2408724-1-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAOptpSPY3YL5VFJW9KKP99Yb17+_rdXKsKj93FdEn3_Zb350ow@mail.gmail.com>
References: <CAOptpSPY3YL5VFJW9KKP99Yb17+_rdXKsKj93FdEn3_Zb350ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bqsnt1w6zy9srjqgicwgq9sf3ztck9wt
X-Rspamd-Queue-Id: E55E540005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778315972-40317
X-HE-Meta: U2FsdGVkX18lHuHYz3YrDlt4tOpGlXcaQVYIKtpJR3nQw65ZSocQQ3BpYOo9ME9t6v3oWGPDCW9LUZAbRsjBWnevRsP64mw86lxR1pZPqixFFcd3YFXGm3Cwe27SfU7SEGyGJqiKy5ToQ1RxZdM3a4p1uyPApTlO0dPnE0Zj6p/JDqfseDO4L+mlbbi5Nd7uXKgzLgXDxURMIkIfKCcmUx9I3IYvJ3hnXR2sZ3uDjsaa+aj2v4hwhoEnQDCIypQ3nMHceU3Le25V0Y0YqT/YVGYmZu2dSrUNTpBmaPBD1pR994GY6Y/WZs1FBmovW4V731G4LtQ1qvjCk2aQkR2uApeEqjYu72Melyc2cQKNsun2LcZOfl1gIwQkfuAU46VgAYGDh625jSCHIyF5QLbtcu1ql/e56yCOjfYskhRoC0xVaiDw6pSQCchkofvGpB3B9WsgqlZDYJzxFp7caBSoha8PfRK+R4iYNEVDitHmw6jsnofJYKJwRr7V4Z3GSpY1WaggVVoK/qbfYz/q+iMMZcL7Uc0nxTmHYC0vT6i2DyQZC+GSMFsrIkwg+EWV2i7r7u5K3br+SFWbNsHfpPSD8MvdT6mAu+qQ+q8Z5ziuT0oxmpeJ2FWBnH7eBOU4hZVwj7mqmWEY9Rv2u8Yz95hGiayHHK2LxjoeMJy3B8VRQ3DKxvPFGNSiHcw9LiqlLpsLll6EPMjAh94QvzbYJxGjnHtu/XUCdhP149M7ycTIws3kcFYRVMwp4g4X0WQZOqjFIRKkqEahT4gS1kGO99sQzNN42ldu6ffHfF4UKuYOFLif1g3JlUAVMEIpLcyQLWDMd4yVI5DJzK0PO6GJDHEEZqxJvwoHGYVYCetbYanIRGMwvV+Fx9JAYdIsNXnnCCqDfeiFvTXYCM7LephfHgvb2f8yF7Vx4CwpF9bm6NPAW6TeMGjxAlEUZgmQzVTAaS+jNfz2svNgALb9124o/nD
 eMPuiGZ6
 /mcgFibMKe++IWr2mxePfKjn1YENsqkaNEJBhm++rrvDoYTYZYuwcWI/e40HwP/NJXBPSEeINN+VY9O0ki+xYexH4d9n5rWCTvMD40Gi+H7eoaARHLSYU2dYJq8ofpGM7tmxJkOnWDpNOOGOK8fmyyTU4blwN4Y89/FSBmvUepcJSS5wY3znc7jW+hIgEoBepWqk+kHCa4WJIaNDfXhkwCCnn84Ewm5DwJZSO4W8pRoUyQFiNtMfc4POiiUh4w/620yG29Rw1pnD6Yx55wKn5dwdzhUQ4f8syYgOKW+zOnM/yTv54BDFE1OATa7z9GYmJ7fniR+SQtlSwDi0HPabKbEEXkkJL59JYhk+UpqV3pMSWfNAcnnlscZkeNfE4DVvTltTlxZH83CbV+7A4diNcbQ7rSg6dpCg0kW0jTUy/2UYEPotoe6b3CDufDc0ASwwQRPDaUUBl5hXlDN9zdFiGJODJQJ/tvpVy1N3CEPKJHcY9FC4RaZtQ0koSrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The three patches below implement the zsmalloc-only variant --
deferring just zs_free(). They partially depend on the pool->lock
removal series, and also reduce the number of class->lock
acquire/release pairs on the drain path.

----- [1/3] mm/zsmalloc: introduce per-cpu deferred free with page pool -----

Introduce zs_free_deferred() that enqueues handles into per-cpu
buffers backed by single pages (PAGE_SIZE/8 entries each).

A pre-allocated page pool provides fresh pages for buffer swap on the
hot path without any allocation.  When a per-cpu buffer fills up, the
producer swaps in a page from the pool, moves the full page to a drain
list, and resets count — all within preempt_disable, no waiting for the
worker.

The drain worker runs on a WQ_UNBOUND workqueue to avoid preempting
the producer on its CPU.  It picks pages off the drain list one at a
time, drains them using consecutive-class batching (holding class->lock
across runs of same-class handles), and returns drained pages to the
pool.  It processes at most pool_size/2 pages per invocation to avoid
monopolizing CPU, rescheduling itself if more pages remain.

Extract __zs_free_handle() from zs_free() as the locked free primitive
shared by both synchronous and deferred paths.  Empty zspages are
collected on a list and released after dropping class->lock.

Also introduce zs_free_deferred_flush() for use before zs_compact()
and zs_deferred_free_all() for pool teardown.

Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 include/linux/zsmalloc.h |   2 +
 mm/zsmalloc.c            | 342 +++++++++++++++++++++++++++++++++++----
 2 files changed, 316 insertions(+), 28 deletions(-)

diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 478410c880b1..1e5ac1a39d41 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -30,6 +30,8 @@ void zs_destroy_pool(struct zs_pool *pool);
 unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t flags,
 			const int nid);
 void zs_free(struct zs_pool *pool, unsigned long obj);
+void zs_free_deferred(struct zs_pool *pool, unsigned long handle);
+void zs_free_deferred_flush(struct zs_pool *pool);
 
 size_t zs_huge_class_size(struct zs_pool *pool);
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 176d3ad4f6e9..f483937cf34f 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -42,6 +42,7 @@
 #include <linux/zsmalloc.h>
 #include <linux/fs.h>
 #include <linux/workqueue.h>
+#include <linux/percpu.h>
 #include "zpdesc.h"
 
 #define ZSPAGE_MAGIC	0x58
@@ -56,6 +57,9 @@
 
 #define ZS_HANDLE_SIZE (sizeof(unsigned long))
 
+#define ZS_DEFERRED_BUF_ENTRIES	(PAGE_SIZE / sizeof(unsigned long))
+#define ZS_DEFERRED_POOL_SIZE	(256 * 1024 / PAGE_SIZE)
+
 /*
  * Object location (<PFN>, <obj_idx>) is encoded as
  * a single (unsigned long) handle value.
@@ -174,6 +178,7 @@ static_assert(_PFN_BITS + OBJ_CLASS_BITS_NEEDED + OBJ_IDX_BITS_NEEDED
 #define ZS_SIZE_CLASSES	(DIV_ROUND_UP(ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE, \
 				      ZS_SIZE_CLASS_DELTA) + 1)
 
+
 /*
  * Pages are distinguished by the ratio of used memory (that is the ratio
  * of ->inuse objects to all objects that page can store). For example,
@@ -246,6 +251,11 @@ struct link_free {
 	};
 };
 
+struct zs_deferred_percpu {
+	unsigned int count;
+	unsigned long *handles;
+};
+
 static struct kmem_cache *handle_cachep;
 static struct kmem_cache *zspage_cachep;
 
@@ -270,6 +280,20 @@ struct zs_pool {
 	/* protect zspage migration/compaction */
 	rwlock_t lock;
 	atomic_t compaction_in_progress;
+
+	/* per-cpu deferred free */
+	struct zs_deferred_percpu __percpu *deferred;
+	struct work_struct deferred_drain_work;
+	struct workqueue_struct *drain_wq;
+
+	/* page pool: free pages available for buffer swap */
+	struct list_head page_pool;
+	unsigned int page_pool_count;
+	spinlock_t page_pool_lock;
+
+	/* drain list: full pages waiting to be drained */
+	struct list_head drain_list;
+	spinlock_t drain_list_lock;
 };
 
 static inline void zpdesc_set_first(struct zpdesc *zpdesc)
@@ -788,12 +812,6 @@ static unsigned int obj_to_class_idx(unsigned long obj)
 	return (obj >> OBJ_IDX_BITS) & OBJ_CLASS_MASK;
 }
 
-/**
- * location_to_obj - encode (<zpdesc>, <obj_idx>, <class_idx>) into obj value
- * @zpdesc: zpdesc object resides in zspage
- * @obj_idx: object index
- * @class_idx: size class index
- */
 static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int obj_idx,
 				     unsigned int class_idx)
 {
@@ -1454,23 +1472,14 @@ static void obj_free(int class_size, unsigned long obj)
 	mod_zspage_inuse(zspage, -1);
 }
 
-void zs_free(struct zs_pool *pool, unsigned long handle)
+static void __zs_free_handle(struct zs_pool *pool, struct size_class *class,
+			     unsigned long handle, struct list_head *free_list)
 {
-	struct zspage *zspage;
-	struct zspage *zspage_to_free = NULL;
 	struct zpdesc *f_zpdesc;
+	struct zspage *zspage;
 	unsigned long obj;
-	struct size_class *class;
 	int fullness;
 
-	if (IS_ERR_OR_NULL((void *)handle))
-		return;
-
-	obj = handle_to_obj(handle);
-	class = pool->size_class[obj_to_class_idx(obj)];
-
-	spin_lock(&class->lock);
-
 	obj = handle_to_obj(handle);
 	obj_to_zpdesc(obj, &f_zpdesc);
 	zspage = get_zspage(f_zpdesc);
@@ -1480,31 +1489,231 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 
 	fullness = fix_fullness_group(class, zspage);
 	if (fullness == ZS_INUSE_RATIO_0) {
-		/*
-		 * Perform bookkeeping under class->lock, but defer the
-		 * actual page release (which may contend on zone->lock)
-		 * until after dropping class->lock.
-		 */
 		if (trylock_zspage(zspage)) {
 			remove_zspage(class, zspage);
 			class_stat_sub(class, ZS_OBJS_ALLOCATED,
 				       class->objs_per_zspage);
 			atomic_long_sub(class->pages_per_zspage,
 					&pool->pages_allocated);
-			zspage_to_free = zspage;
+			list_add(&zspage->list, free_list);
 		} else {
 			kick_deferred_free(pool);
 		}
 	}
+}
 
+static void free_zspage_list(struct zs_pool *pool, struct list_head *list)
+{
+	struct zspage *zspage, *tmp;
+
+	list_for_each_entry_safe(zspage, tmp, list, list) {
+		list_del(&zspage->list);
+		free_zspage_pages(pool, zspage);
+	}
+}
+
+void zs_free(struct zs_pool *pool, unsigned long handle)
+{
+	struct size_class *class;
+	unsigned long obj;
+	LIST_HEAD(free_list);
+
+	if (IS_ERR_OR_NULL((void *)handle))
+		return;
+
+	obj = handle_to_obj(handle);
+	class = pool->size_class[obj_to_class_idx(obj)];
+	spin_lock(&class->lock);
+
+	__zs_free_handle(pool, class, handle, &free_list);
 	spin_unlock(&class->lock);
 
-	if (zspage_to_free)
-		free_zspage_pages(pool, zspage_to_free);
+	free_zspage_list(pool, &free_list);
 	cache_free_handle(handle);
 }
 EXPORT_SYMBOL_GPL(zs_free);
 
+static void zs_deferred_drain_batch(struct zs_pool *pool,
+				    unsigned long *handles, unsigned int count)
+{
+	struct size_class *class = NULL;
+	unsigned int cur_cls = UINT_MAX;
+	LIST_HEAD(free_list);
+	unsigned int i;
+
+	for (i = 0; i < count; i++) {
+		unsigned long obj = handle_to_obj(handles[i]);
+		unsigned int cls = obj_to_class_idx(obj);
+
+		if (cls != cur_cls) {
+			if (class) {
+				spin_unlock(&class->lock);
+				free_zspage_list(pool, &free_list);
+				cond_resched();
+			}
+			cur_cls = cls;
+			class = pool->size_class[cls];
+			spin_lock(&class->lock);
+		}
+		__zs_free_handle(pool, class, handles[i], &free_list);
+	}
+
+	if (class) {
+		spin_unlock(&class->lock);
+		free_zspage_list(pool, &free_list);
+	}
+
+	for (i = 0; i < count; i++)
+		cache_free_handle(handles[i]);
+}
+
+static struct page *deferred_pool_get(struct zs_pool *pool)
+{
+	struct page *page = NULL;
+
+	spin_lock(&pool->page_pool_lock);
+	if (!list_empty(&pool->page_pool)) {
+		page = list_first_entry(&pool->page_pool, struct page, lru);
+		list_del(&page->lru);
+		pool->page_pool_count--;
+	}
+	spin_unlock(&pool->page_pool_lock);
+	return page;
+}
+
+static void deferred_pool_put(struct zs_pool *pool, struct page *page)
+{
+	spin_lock(&pool->page_pool_lock);
+	list_add_tail(&page->lru, &pool->page_pool);
+	pool->page_pool_count++;
+	spin_unlock(&pool->page_pool_lock);
+}
+
+static void deferred_drain_enqueue(struct zs_pool *pool, struct page *page)
+{
+	spin_lock(&pool->drain_list_lock);
+	list_add_tail(&page->lru, &pool->drain_list);
+	spin_unlock(&pool->drain_list_lock);
+}
+
+static struct page *deferred_drain_dequeue(struct zs_pool *pool)
+{
+	struct page *page = NULL;
+
+	spin_lock(&pool->drain_list_lock);
+	if (!list_empty(&pool->drain_list)) {
+		page = list_first_entry(&pool->drain_list, struct page, lru);
+		list_del(&page->lru);
+	}
+	spin_unlock(&pool->drain_list_lock);
+	return page;
+}
+
+static void zs_deferred_drain_work(struct work_struct *work)
+{
+	struct zs_pool *pool = container_of(work, struct zs_pool,
+					    deferred_drain_work);
+	struct page *page;
+	unsigned int drained = 0;
+	unsigned int max_drain = ZS_DEFERRED_POOL_SIZE / 2;
+
+	while (drained < max_drain) {
+		page = deferred_drain_dequeue(pool);
+		if (!page)
+			break;
+
+		zs_deferred_drain_batch(pool, page_address(page),
+					ZS_DEFERRED_BUF_ENTRIES);
+		deferred_pool_put(pool, page);
+		drained++;
+		cond_resched();
+	}
+
+	/* If drain list still has pages, reschedule */
+	spin_lock(&pool->drain_list_lock);
+	if (!list_empty(&pool->drain_list))
+		queue_work(pool->drain_wq, &pool->deferred_drain_work);
+	spin_unlock(&pool->drain_list_lock);
+}
+
+void zs_free_deferred(struct zs_pool *pool, unsigned long handle)
+{
+	struct zs_deferred_percpu *def;
+	struct page *new_page, *full_page;
+	bool queued = false;
+
+	if (IS_ERR_OR_NULL((void *)handle))
+		return;
+
+	def = get_cpu_ptr(pool->deferred);
+
+	if (likely(def->count < ZS_DEFERRED_BUF_ENTRIES)) {
+		def->handles[def->count++] = handle;
+		queued = true;
+		if (def->count < ZS_DEFERRED_BUF_ENTRIES) {
+			put_cpu_ptr(pool->deferred);
+			return;
+		}
+	}
+
+	/* Buffer is full, try to swap in a fresh page */
+	new_page = deferred_pool_get(pool);
+	if (new_page) {
+		full_page = virt_to_page(def->handles);
+		def->handles = page_address(new_page);
+		def->count = 0;
+		if (!queued)
+			def->handles[def->count++] = handle;
+		put_cpu_ptr(pool->deferred);
+		deferred_drain_enqueue(pool, full_page);
+		queue_work(pool->drain_wq, &pool->deferred_drain_work);
+		return;
+	}
+	put_cpu_ptr(pool->deferred);
+
+	if (!queued)
+		zs_free(pool, handle);
+}
+EXPORT_SYMBOL_GPL(zs_free_deferred);
+
+/*
+ * Called only from zs_destroy_pool() when no producers are running.
+ * Drains all per-cpu buffers regardless of whether they are full.
+ */
+static void zs_deferred_free_all(struct zs_pool *pool)
+{
+	struct page *page;
+	int cpu;
+
+	flush_work(&pool->deferred_drain_work);
+
+	/* Drain remaining pages on drain list */
+	while ((page = deferred_drain_dequeue(pool)) != NULL) {
+		zs_deferred_drain_batch(pool, page_address(page),
+					ZS_DEFERRED_BUF_ENTRIES);
+		deferred_pool_put(pool, page);
+	}
+
+	/* Drain partially-filled per-cpu buffers */
+	for_each_possible_cpu(cpu) {
+		struct zs_deferred_percpu *def;
+		unsigned int count;
+
+		def = per_cpu_ptr(pool->deferred, cpu);
+		count = def->count;
+		if (!count)
+			continue;
+		zs_deferred_drain_batch(pool, def->handles, count);
+		def->count = 0;
+	}
+}
+
+void zs_free_deferred_flush(struct zs_pool *pool)
+{
+	flush_work(&pool->deferred_drain_work);
+}
+EXPORT_SYMBOL_GPL(zs_free_deferred_flush);
+
 static void zs_object_copy(struct size_class *class, unsigned long dst,
 				unsigned long src)
 {
@@ -2053,6 +2262,8 @@ unsigned long zs_compact(struct zs_pool *pool)
 	if (atomic_xchg(&pool->compaction_in_progress, 1))
 		return 0;
 
+	zs_free_deferred_flush(pool);
+
 	for (i = ZS_SIZE_CLASSES - 1; i >= 0; i--) {
 		class = pool->size_class[i];
 		if (class->index != i)
@@ -2161,9 +2372,11 @@ static int calculate_zspage_chain_size(int class_size)
  */
 struct zs_pool *zs_create_pool(const char *name)
 {
-	int i;
+	int i, cpu;
+	unsigned int pg_idx;
 	struct zs_pool *pool;
 	struct size_class *prev_class = NULL;
+	struct page *page, *tmp;
 
 	pool = kzalloc_obj(*pool);
 	if (!pool)
@@ -2172,11 +2385,67 @@ struct zs_pool *zs_create_pool(const char *name)
 	init_deferred_free(pool);
 	rwlock_init(&pool->lock);
 	atomic_set(&pool->compaction_in_progress, 0);
+	INIT_WORK(&pool->deferred_drain_work, zs_deferred_drain_work);
+
+	pool->drain_wq = alloc_workqueue("zs_drain", WQ_UNBOUND, 0);
+	if (!pool->drain_wq) {
+		kfree(pool);
+		return NULL;
+	}
+
+	/* Initialize page pool and drain list */
+	INIT_LIST_HEAD(&pool->page_pool);
+	spin_lock_init(&pool->page_pool_lock);
+	pool->page_pool_count = 0;
+	INIT_LIST_HEAD(&pool->drain_list);
+	spin_lock_init(&pool->drain_list_lock);
+
+	for (pg_idx = 0; pg_idx < ZS_DEFERRED_POOL_SIZE; pg_idx++) {
+		page = alloc_page(GFP_KERNEL);
+		if (!page)
+			goto err_pool_pages;
+		list_add_tail(&page->lru, &pool->page_pool);
+		pool->page_pool_count++;
+	}
+
+	pool->deferred = alloc_percpu(struct zs_deferred_percpu);
+	if (!pool->deferred)
+		goto err_pool_pages;
+	for_each_possible_cpu(cpu) {
+		struct zs_deferred_percpu *def = per_cpu_ptr(pool->deferred, cpu);
+
+		page = deferred_pool_get(pool);
+		if (!page) {
+			for_each_possible_cpu(cpu) {
+				def = per_cpu_ptr(pool->deferred, cpu);
+				if (def->handles)
+					deferred_pool_put(pool,
+						virt_to_page(def->handles));
+			}
+			free_percpu(pool->deferred);
+			goto err_pool_pages;
+		}
+		def->handles = page_address(page);
+		def->count = 0;
+	}
 
 	pool->name = kstrdup(name, GFP_KERNEL);
 	if (!pool->name)
 		goto err;
 
+	goto pool_init_done;
+
+err_pool_pages:
+	list_for_each_entry_safe(page, tmp, &pool->page_pool, lru) {
+		list_del(&page->lru);
+		__free_page(page);
+	}
+	destroy_workqueue(pool->drain_wq);
+	kfree(pool);
+	return NULL;
+
+pool_init_done:
+
 	/*
 	 * Iterate reversely, because, size of size_class that we want to use
 	 * for merging should be larger or equal to current size.
@@ -2272,9 +2541,11 @@ EXPORT_SYMBOL_GPL(zs_create_pool);
 
 void zs_destroy_pool(struct zs_pool *pool)
 {
-	int i;
+	int i, cpu;
+	struct page *page, *tmp;
 
 	zs_unregister_shrinker(pool);
+	zs_deferred_free_all(pool);
 	zs_flush_migration(pool);
 	zs_pool_stat_destroy(pool);
 
@@ -2298,6 +2569,21 @@ void zs_destroy_pool(struct zs_pool *pool)
 		kfree(class);
 	}
 
+	/* Return per-cpu buffers to page pool */
+	for_each_possible_cpu(cpu) {
+		struct zs_deferred_percpu *def = per_cpu_ptr(pool->deferred, cpu);
+
+		if (def->handles)
+			deferred_pool_put(pool, virt_to_page(def->handles));
+	}
+
+	/* Free all pages in page pool */
+	list_for_each_entry_safe(page, tmp, &pool->page_pool, lru) {
+		list_del(&page->lru);
+		__free_page(page);
+	}
+	free_percpu(pool->deferred);
+	destroy_workqueue(pool->drain_wq);
 	kfree(pool->name);
 	kfree(pool);
 }


----- [2/3] mm/zswap: use zs_free_deferred() in entry free path -----

Replace zs_free() with zs_free_deferred() in zswap_entry_free() to
avoid the overhead of zsmalloc class->lock and potential zone->lock
contention in the zswap invalidation/reclaim hot path.

The store failure path still uses zs_free() directly since it is not
performance critical.

Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 4b5149173b0e..f2a38c07579f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -765,7 +765,7 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
 static void zswap_entry_free(struct zswap_entry *entry)
 {
 	zswap_lru_del(&zswap_list_lru, entry);
-	zs_free(entry->pool->zs_pool, entry->handle);
+	zs_free_deferred(entry->pool->zs_pool, entry->handle);
 	zswap_pool_put(entry->pool);
 	if (entry->objcg) {
 		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);


----- [3/3] zram: defer zs_free() in swap slot free notification path -----

zram_slot_free_notify() is called on the process exit path when
unmapping swap entries.  The zs_free() it invokes accounts for ~87%
of slot_free() cost due to zsmalloc locking, blocking memory release
during Android low-memory killing.

Split slot_free() into slot_free_extract() and the actual zs_free():

  slot_free_extract() handles slot metadata cleanup (flags, stats,
  handle/size zeroing) and returns the zsmalloc handle.

  The returned handle is passed to zs_free_deferred() in the
  notification path, deferring the expensive zs_free() to a
  workqueue so the exit path can release anon folios faster.

All other slot_free() callers (write, discard, meta_free) continue
to use synchronous zs_free() through the unchanged slot_free().

Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 drivers/block/zram/zram_drv.c | 41 ++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index aebc710f0d6a..c67a7442d283 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2000,24 +2000,26 @@ static bool zram_meta_alloc(struct zram *zram, u64 disksize)
 	return true;
 }
 
-static void slot_free(struct zram *zram, u32 index)
+/*
+ * Clear slot metadata and extract the zsmalloc handle that needs freeing.
+ * Returns the handle, or 0 if no zsmalloc free is required (e.g. same-filled
+ * or writeback slots).
+ */
+#define ZRAM_SLOT_CLEAR_MASK \
+	(BIT(ZRAM_IDLE) | BIT(ZRAM_INCOMPRESSIBLE) | BIT(ZRAM_PP_SLOT) | \
+	 (ZRAM_COMP_PRIORITY_MASK << ZRAM_COMP_PRIORITY_BIT1))
+
+static unsigned long slot_free_extract(struct zram *zram, u32 index)
 {
-	unsigned long handle;
+	unsigned long handle = 0;
 
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
 	zram->table[index].attr.ac_time = 0;
 #endif
 
-	clear_slot_flag(zram, index, ZRAM_IDLE);
-	clear_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE);
-	clear_slot_flag(zram, index, ZRAM_PP_SLOT);
-	set_slot_comp_priority(zram, index, 0);
+	zram->table[index].attr.flags &= ~ZRAM_SLOT_CLEAR_MASK;
 
 	if (test_slot_flag(zram, index, ZRAM_HUGE)) {
-		/*
-		 * Writeback completion decrements ->huge_pages but keeps
-		 * ZRAM_HUGE flag for deferred decompression path.
-		 */
 		if (!test_slot_flag(zram, index, ZRAM_WB))
 			atomic64_dec(&zram->stats.huge_pages);
 		clear_slot_flag(zram, index, ZRAM_HUGE);
@@ -2029,10 +2031,6 @@ static void slot_free(struct zram *zram, u32 index)
 		goto out;
 	}
 
-	/*
-	 * No memory is allocated for same element filled pages.
-	 * Simply clear same page flag.
-	 */
 	if (test_slot_flag(zram, index, ZRAM_SAME)) {
 		clear_slot_flag(zram, index, ZRAM_SAME);
 		atomic64_dec(&zram->stats.same_pages);
@@ -2041,9 +2039,7 @@ static void slot_free(struct zram *zram, u32 index)
 
 	handle = get_slot_handle(zram, index);
 	if (!handle)
-		return;
-
-	zs_free(zram->mem_pool, handle);
+		return 0;
 
 	atomic64_sub(get_slot_size(zram, index),
 		     &zram->stats.compr_data_size);
@@ -2051,6 +2047,15 @@ static void slot_free(struct zram *zram, u32 index)
 	atomic64_dec(&zram->stats.pages_stored);
 	set_slot_handle(zram, index, 0);
 	set_slot_size(zram, index, 0);
+
+	return handle;
+}
+
+static void slot_free(struct zram *zram, u32 index)
+{
+	unsigned long handle = slot_free_extract(zram, index);
+
+	zs_free(zram->mem_pool, handle);
 }
 
 static int read_same_filled_page(struct zram *zram, struct page *page,
@@ -2797,7 +2802,7 @@ static void zram_slot_free_notify(struct block_device *bdev,
 		return;
 	}
 
-	slot_free(zram, index);
+	zs_free_deferred(zram->mem_pool, slot_free_extract(zram, index));
 	slot_unlock(zram, index);
 }

