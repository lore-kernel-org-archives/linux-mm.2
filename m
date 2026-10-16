Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E97F7CCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 12:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9A2D6B008C; Fri, 16 Oct 2026 08:10:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D656B0092; Fri, 16 Oct 2026 08:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96936B0095; Fri, 16 Oct 2026 08:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9416B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:10:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC7D6160442
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:10:07 +0000 (UTC)
X-FDA: 85328371254.12.4A268E8
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 090E640008
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:10:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q1Apfr4b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of chenhongfeng0212@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=chenhongfeng0212@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792152606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qX4T5VNEZDCvos4GslZo2eKv8+vc1OatU8zENizVPSM=;
	b=cyp0dCJQKYi4nqQCBEw3y10VEbIAn/VBxTpfke/8YkU2NiI08Fa4zckZI6Rj2YBQdxjqDo
	QPiOsCRN3ojVo68JNqIOKNk3KActueH8mNLIvC1FYistuL3fEgURRXfFWBhzkiJb+W2P9h
	7Ueo9GU7piySJJEcLD+GattiL8sTcp0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q1Apfr4b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of chenhongfeng0212@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=chenhongfeng0212@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792152606;
	b=5u8OEhaAn4EaLTJzeqGRgOdqO5DupLlLKX7dgBuedvbiM6AG1ZTTnL5m8Jinbl3ogPMlBl
	zsnSZE5LXwQ00UMemk8437nJf8f8AxaRhErFbyHYkUmwAgmLXA6Yu2omAzDQIPT/lcaLtn
	iM3tYBZNbr+kCMDMD9HangIxQfTVHVo=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ac5b090d16so636847a91.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792152605; x=1792757405; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qX4T5VNEZDCvos4GslZo2eKv8+vc1OatU8zENizVPSM=;
        b=Q1Apfr4bWdQ8MXMB4oU5BsJ1ZrjJGYS4NR3n/2oM838k+hgxFwQHNDOnDdvDFdK64C
         h9D2YeOWTuW+dYVrGHtQdbo8D19PUCwir41t6JXueC9gdWy/TP+FXmdRyB222m1h4Ohj
         1lz0Auz/w5n2O/KhS0lE5yy100i+VxsgIcZz2v6VMAt2I05OQtWOzwvVJv4nOKVVI/LM
         iYYfQY+Q0e9x/LPQXhk6prfzVJZXGuE4ib/PrcxBkO1VifCjUADegzwUccQbbdp6498d
         6EDulaWSYAXI1gHvHdqawRrnbFBbAAR7qvsmRraC67y7MyXncYOw3M4QgNkrh9wluHfx
         EZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792152605; x=1792757405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qX4T5VNEZDCvos4GslZo2eKv8+vc1OatU8zENizVPSM=;
        b=cCPQKzWGXqFgRWlIrAH+aZF2lRDwLozSEfi1aDSPWZyWzueIAzkcLLV5s9RyaDl6vg
         jkPeXzje6LH61F6kA/9DcCSWzH+Fq9bJgx8XUsVsqB1Vq2Iqd7bAsviG5TR+qEL9uEjz
         lRe3MkXNRz4XWmRt2LhYvkd+donxda2MIr21KTL5mBRsoVMQcWO5PAcvgF1irFrPLoN5
         gCub13wz76gh1jBC5rOTcEvPe4ZEYhvfKaGlZADUTjI6sFyL0YnhXqVsHLCE9PQ3mseO
         96E93pdbUPwHTl0ZSDT59/5CwUwG4XHEyRufAK3HyS14P8eB7xO1aTNclcU7w29uOKp3
         OWvg==
X-Gm-Message-State: AFq9FYIv146DknfgwcSdvrjyzA4ecJoytQuFNDKV5TqljkOc+LUCgKVw
	4BQMzAYryDxCNoLvlFTUEuBKzMnr3kngyqISshQqi4+xrL1k5RaTTYoy
X-Gm-Gg: AYBFou0r67/1HXXsDVdNhL6mcKpTHsDyHGBLb1shaoW+w69dd2f0Hg8gSUSLeIBhWZw
	OqsXxkpjjaFzcVHdgOGqH5gGanETZPi36VRhSCRV8jxpYIX3vvseSTnk56w9r4eiCLsuc5gVNpo
	4lGvZBsEHsKTQJR0eCiZCwiJ/6MNSna3u/VNvJXylBLHxIM8WZQ3cf1KGNrAohUHcavf1Fulfxa
	SMW2etY9UmEZCbfnOrZ3/L0FtkUxcGLN+wdvNsG6Ki6aUPwKjEUuFWJQYePbarCB3jbY9R1gWbE
	u/WcMX38wf3L1VZIK0YIRTDztV+ysNOPtkDVg5STE9jkFGYFFdnMt/EtWCNRQqOhYzgt4BfFnI4
	UZpgsjV+CnGcEqZPDCJjXlGlZpfCUYCpplM2CRQc8S4xratsSsctPa/iWeSkuh8J1L8Vde6upU9
	f3VBUXQ+bebcahNS7WnYOcxlb8u6bhIP1JFFIvcVcI1dAbRXbGMfW7ZL6I64aXlcU+nbVDtRii8
	R8elnQVF3E=
X-Received: by 2002:a17:90a:2cc4:b0:3ac:36c7:c144 with SMTP id 98e67ed59e1d1-3acbb86e111mr1340061a91.28.1792152604741;
        Fri, 16 Oct 2026 05:10:04 -0700 (PDT)
Received: from hongfeng.mioffice.cn ([43.224.245.240])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc48f4cadsm3908912a91.12.2026.10.16.05.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 05:10:04 -0700 (PDT)
From: Hongfeng Chen <chenhongfeng0212@gmail.com>
X-Google-Original-From: Hongfeng Chen <hongfengchen@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Minchan Kim <minchan@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Wenchao Hao <haowenchao@xiaomi.com>,
	Wenchao Hao <haowenchao22@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	Hongfeng Chen <hongfengchen@xiaomi.com>
Subject: [RFC PATCH v4 1/2] mm/zsmalloc: defer object free to per-cpu batches and a drain worker
Date: Fri, 16 Oct 2026 20:09:26 +0800
Message-ID: <20261016120927.3191690-2-hongfengchen@xiaomi.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261016120927.3191690-1-hongfengchen@xiaomi.com>
References: <20261016120927.3191690-1-hongfengchen@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 090E640008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: y4o613rnf3f1grhfknzz4fto1itrx5qr
X-HE-Tag: 1792152605-555416
X-HE-Meta: U2FsdGVkX1/MTnlyONHGk4JQw0URGOgpLtueDcr5NNcnfl49RSTD7DTzlMa9aP1OHl7ep6GAdqrAWWAhaYaBKb4n1ZUVl/wgmi6fRxfoVeCKAycF7+SSPA7crmDnjYcMzhV/7HQzMTZfz/waBTCAA5mdpB4u29ezl6X39VsivdejiaRv9LEKfNbv8RH5ZuYZyZWEZMF9GC30buW24saFV/ojZIBT1L3RyM2aUb5AWiy3H20c3rhQRU0Gd7SW/Utml9JfFY6uA87isTszN2SgB4bhVI6BPhFEOGXtqjspkL6OLZ8WAJk5WxYGKNHsOf4hQD81B1uw9l8yJcunfxx/kcntt6nLMnnKfHVC7/kjZacLk9hAD8+utn3c7Z4dquoDcZfblzaVcDErfBTZpGO+EcV1CKSgrMZ4h0X1joNx8nJ4YyI11fKTcm6Bq75kkWcAs0iWvWyE9hxvtGJ3Mid2HvjV1WXiKF9QPUJZUjP7jZqh2sm8UfL2dhn/taGfmE+NtLZcKSBuqTb6126EniRYm1YOF04VsLU7EYzLIZNpOCMaslYV1RwiloifIAGuP6xNpHUrYiVjEq88aU+26N3ezmUXdVnulc7qTJDkzorEo2z8NgaOB5nWC67IzIYf3PP8rMiRtjpqn4xMs21jq0NTZTep5d/E8tsNZV55eh71+fyJH40UUNCYFsdv0av94i3YRjUGSJDCsK2xtduDu//+bRn3f8drFtPKmwodhkb2DlzUKs1kT5EEqVzfblbjKPEuTmCbQikWyxAboFhznNXQbFCWMAijlMjlXdSjDco/WpWVqhsxyyk5q/V3dcZfoIMGINSfh2czjOTdYDlw8imc4IwbpVWqSLcBaOq6nFgM01VIXP4K2SzUvc60BZUMhg+47zKY+V61o9KxoAZVlgFrZw1MPc9jAEP5gL1FObkOeR+6e/8Bscj/uCEFqjuf7v26HFA3LC6Fdxwariaw6ju
 OVZjYSxV
 O6+1jzFvZQ0EPfsENvW84yGN+IfAzqcaqDIdNCcqzczFmne0HmH6IOsC85N0XICQgvrix/hiWmOyJpQZMAJzJhoace7y1W5BIiA0DD0vLwbkKVVsJ1BXXKWo+mKEar+B/xaOm/HWOvo3OWpLDQJujZH4GNOxMjQaYUbOq4aKrwPXEHz5iUplJtUucf8Js1Ro0xemLFNd8XeoYzmOf0mono0L4/m+a38sUBt9On6eyTldzQyM7R10ncdJQDDtcyygufd4xwApGf6LJzKIQvot+U8iquPNXIIJ+53NoER0JqIh/GaP8YKJTUVw/h+o9suPv4NJSleGaXfAjeM+5/KQNXtRWapf74FOBPZgANNmVS5/8W/0G3ELMNOOLJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unmapping a VMA full of swap entries makes the unmapping task free every
compressed object itself, one zs_free() call per page. On Android this
slows down the exit of a task killed to reclaim memory.

Instead of freeing the object right away, zs_free() appends its handle to
a per-cpu batch of 64 handles. A full batch goes to an unbound drain worker
through a lockless list, and the worker frees the objects. This batches the
release and moves it off the unmapping path, and the change stays within
zsmalloc.

Freeing empty zspages is left to the worker too: it does that directly when
it can take the page locks, and reuses kick_deferred_free() to free them
asynchronously when it cannot.

Failing to allocate the per-cpu state is not fatal: pool->defer stays NULL
and zs_free() keeps its old path.

Signed-off-by: Hongfeng Chen <hongfengchen@xiaomi.com>
---
 mm/zsmalloc.c | 182 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 154 insertions(+), 28 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 7ef80e0da626..eacd771bd542 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -43,6 +43,7 @@
 #include <linux/zsmalloc.h>
 #include <linux/fs.h>
 #include <linux/workqueue.h>
+#include <linux/llist.h>
 #include "zpdesc.h"
 
 #define ZSPAGE_MAGIC	0x58
@@ -267,6 +268,21 @@ struct link_free {
 static struct kmem_cache *handle_cachep;
 static struct kmem_cache *zspage_cachep;
 
+#define ZS_DEFER_BATCH	64
+
+struct zs_defer_batch {
+	struct llist_node node;
+	unsigned int count;
+	unsigned long handles[ZS_DEFER_BATCH];
+};
+
+struct zs_defer_percpu {
+	struct zs_defer_batch *active;
+	struct llist_head pending;
+	struct work_struct drain_work;
+	struct zs_pool *pool;
+};
+
 struct zs_pool {
 	const char *name;
 
@@ -282,12 +298,12 @@ struct zs_pool {
 #ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
 #endif
-#ifdef CONFIG_COMPACTION
 	struct work_struct free_work;
-#endif
 	/* protect zspage migration/compaction */
 	rwlock_t lock;
 	atomic_t compaction_in_progress;
+
+	struct zs_defer_percpu __percpu *defer;
 };
 
 static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
@@ -428,13 +444,11 @@ static bool ZsHugePage(struct zspage *zspage)
 	return zspage->huge;
 }
 
-#ifdef CONFIG_COMPACTION
 static void kick_deferred_free(struct zs_pool *pool);
 static void init_deferred_free(struct zs_pool *pool);
+#ifdef CONFIG_COMPACTION
 static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage);
 #else
-static void kick_deferred_free(struct zs_pool *pool) {}
-static void init_deferred_free(struct zs_pool *pool) {}
 static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage) {}
 #endif
 
@@ -684,7 +698,6 @@ static inline void zs_pool_stat_destroy(struct zs_pool *pool)
 }
 #endif
 
-
 /*
  * For each size class, zspages are divided into different groups
  * depending on their usage ratio. This function returns fullness
@@ -1293,7 +1306,6 @@ static unsigned long obj_malloc(struct zs_pool *pool,
 	return obj;
 }
 
-
 /**
  * zs_malloc - Allocate block of given size from pool.
  * @pool: pool to allocate from
@@ -1371,7 +1383,6 @@ static void obj_free(int class_size, unsigned long obj)
 	unsigned int f_objidx;
 	void *vaddr;
 
-
 	obj_to_location(obj, &f_zpdesc, &f_objidx);
 	f_offset = offset_in_page(class_size * f_objidx);
 	zspage = get_zspage(f_zpdesc);
@@ -1447,7 +1458,7 @@ static inline void obj_class_get_and_lock(struct zs_pool *pool, unsigned long ha
 }
 #endif
 
-void zs_free(struct zs_pool *pool, unsigned long handle)
+static void __zs_free_one(struct zs_pool *pool, unsigned long handle)
 {
 	struct zspage *zspage;
 	unsigned long obj;
@@ -1455,9 +1466,6 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	int fullness;
 	struct zspage *zspage_to_free = NULL;
 
-	if (IS_ERR_OR_NULL((void *)handle))
-		return;
-
 	obj_class_get_and_lock(pool, handle, &obj, &zspage, &class);
 
 	class_stat_sub(class, ZS_OBJS_INUSE, 1);
@@ -1483,6 +1491,78 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	}
 	cache_free_handle(handle);
 }
+
+static void zs_defer_drain(struct zs_defer_percpu *defer)
+{
+	struct zs_pool *pool = defer->pool;
+	struct zs_defer_batch *batch, *n;
+	struct llist_node *first;
+
+	first = llist_del_all(&defer->pending);
+	llist_for_each_entry_safe(batch, n, first, node) {
+		unsigned int i;
+
+		for (i = 0; i < batch->count; i++)
+			__zs_free_one(pool, batch->handles[i]);
+		kfree(batch);
+		cond_resched();
+	}
+}
+
+static void zs_defer_drain_work(struct work_struct *work)
+{
+	zs_defer_drain(container_of(work, struct zs_defer_percpu, drain_work));
+}
+
+static bool zs_defer_push(struct zs_pool *pool, unsigned long handle)
+{
+	struct zs_defer_batch *new_batch = NULL, *batch;
+	struct zs_defer_percpu *defer;
+	bool queue = false;
+
+	if (!pool->defer)
+		return false;
+
+	defer = get_cpu_ptr(pool->defer);
+	if (!defer->active) {
+		put_cpu_ptr(pool->defer);
+		new_batch = kmalloc_obj(*new_batch, GFP_NOWAIT | __GFP_NOWARN);
+		if (!new_batch)
+			return false;
+		new_batch->count = 0;
+
+		defer = get_cpu_ptr(pool->defer);
+		if (!defer->active) {
+			defer->active = new_batch;
+			new_batch = NULL;
+		}
+	}
+
+	batch = defer->active;
+	batch->handles[batch->count++] = handle;
+	if (batch->count == ZS_DEFER_BATCH) {
+		llist_add(&batch->node, &defer->pending);
+		defer->active = NULL;
+		queue = true;
+	}
+	put_cpu_ptr(pool->defer);
+
+	if (unlikely(new_batch))
+		kfree(new_batch);
+
+	if (queue)
+		queue_work(system_dfl_wq, &defer->drain_work);
+	return true;
+}
+
+void zs_free(struct zs_pool *pool, unsigned long handle)
+{
+	if (IS_ERR_OR_NULL((void *)handle))
+		return;
+
+	if (!zs_defer_push(pool, handle))
+		__zs_free_one(pool, handle);
+}
 EXPORT_SYMBOL_GPL(zs_free);
 
 static void zs_object_copy(struct size_class *class, unsigned long dst,
@@ -1671,7 +1751,6 @@ static int putback_zspage(struct size_class *class, struct zspage *zspage)
 	return fullness;
 }
 
-#ifdef CONFIG_COMPACTION
 /*
  * To prevent zspage destroy during migration, zspage freeing should
  * hold locks of all pages in the zspage.
@@ -1714,6 +1793,8 @@ static void lock_zspage(struct zspage *zspage)
 	zspage_read_unlock(zspage);
 }
 
+#ifdef CONFIG_COMPACTION
+
 static void replace_sub_page(struct size_class *class, struct zspage *zspage,
 				struct zpdesc *newzpdesc, struct zpdesc *oldzpdesc)
 {
@@ -1866,6 +1947,18 @@ const struct movable_operations zsmalloc_mops = {
 	.putback_page = zs_page_putback,
 };
 
+static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage)
+{
+	struct zpdesc *zpdesc = get_first_zpdesc(zspage);
+
+	do {
+		WARN_ON(!zpdesc_trylock(zpdesc));
+		__zpdesc_set_movable(zpdesc);
+		zpdesc_unlock(zpdesc);
+	} while ((zpdesc = get_next_zpdesc(zpdesc)) != NULL);
+}
+#endif /* CONFIG_COMPACTION */
+
 /*
  * Caller should hold page_lock of all pages in the zspage
  * In here, we cannot use zspage meta data.
@@ -1904,7 +1997,7 @@ static void async_free_zspage(struct work_struct *work)
 
 static void kick_deferred_free(struct zs_pool *pool)
 {
-	schedule_work(&pool->free_work);
+	queue_work(system_dfl_wq, &pool->free_work);
 }
 
 static void zs_flush_migration(struct zs_pool *pool)
@@ -1917,20 +2010,6 @@ static void init_deferred_free(struct zs_pool *pool)
 	INIT_WORK(&pool->free_work, async_free_zspage);
 }
 
-static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage)
-{
-	struct zpdesc *zpdesc = get_first_zpdesc(zspage);
-
-	do {
-		WARN_ON(!zpdesc_trylock(zpdesc));
-		__zpdesc_set_movable(zpdesc);
-		zpdesc_unlock(zpdesc);
-	} while ((zpdesc = get_next_zpdesc(zpdesc)) != NULL);
-}
-#else
-static inline void zs_flush_migration(struct zs_pool *pool) { }
-#endif
-
 /*
  *
  * Based on the number of unused allocated objects calculate
@@ -2127,6 +2206,48 @@ static int calculate_zspage_chain_size(int class_size)
 	return chain_size;
 }
 
+static void zs_defer_destroy(struct zs_pool *pool)
+{
+	struct zs_defer_percpu __percpu *defer_pcp = pool->defer;
+	int cpu;
+
+	if (!defer_pcp)
+		return;
+
+	pool->defer = NULL;
+	for_each_possible_cpu(cpu) {
+		struct zs_defer_percpu *defer = per_cpu_ptr(defer_pcp, cpu);
+
+		cancel_work_sync(&defer->drain_work);
+		if (defer->active) {
+			llist_add(&defer->active->node, &defer->pending);
+			defer->active = NULL;
+		}
+		zs_defer_drain(defer);
+	}
+	free_percpu(defer_pcp);
+}
+
+static int zs_defer_init(struct zs_pool *pool)
+{
+	int cpu;
+
+	pool->defer = alloc_percpu(struct zs_defer_percpu);
+	if (!pool->defer)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu) {
+		struct zs_defer_percpu *defer = per_cpu_ptr(pool->defer, cpu);
+
+		defer->active = NULL;
+		init_llist_head(&defer->pending);
+		defer->pool = pool;
+		INIT_WORK(&defer->drain_work, zs_defer_drain_work);
+	}
+
+	return 0;
+}
+
 /**
  * zs_create_pool - Creates an allocation pool to work from.
  * @name: pool name to be created
@@ -2151,6 +2272,10 @@ struct zs_pool *zs_create_pool(const char *name)
 	rwlock_init(&pool->lock);
 	atomic_set(&pool->compaction_in_progress, 0);
 
+	if (zs_defer_init(pool))
+		pr_info("deferred free unavailable for <%s>, freeing synchronously\n",
+			name);
+
 	pool->name = kstrdup(name, GFP_KERNEL);
 	if (!pool->name)
 		goto err;
@@ -2253,6 +2378,7 @@ void zs_destroy_pool(struct zs_pool *pool)
 	int i;
 
 	zs_unregister_shrinker(pool);
+	zs_defer_destroy(pool);
 	zs_flush_migration(pool);
 	zs_pool_stat_destroy(pool);
 
-- 
2.54.0


