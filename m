Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E97AF8FA66
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 12:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCB676B008C; Tue, 21 Apr 2026 08:16:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7CC96B0092; Tue, 21 Apr 2026 08:16:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91E86B0093; Tue, 21 Apr 2026 08:16:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BAC746B008C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:16:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5763C13C27E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:16:44 +0000 (UTC)
X-FDA: 84682461528.28.81AEA9C
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id 66F04C0012
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:16:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AXZqA7u5;
	spf=pass (imf10.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776773802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yjoi/ADx361WB7o/C1DRNygxoHsfgIft6bO7Dodrjv4=;
	b=SAXPjwaZJSg9hFw9z5NST00zO+HUaBHjQw26yR1ltqD3f692pEEjgOOodbTzrJ1023cAsl
	foeW6UbEl+7tk9nhmwEwNB4W2m/pZciaGXgOLFAcJp7LCITq1KVSj+NoEI5e7v16YxPvgT
	xh7ybk5N1+C4G1cpHhygztAbkJCGPHI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776773802; a=rsa-sha256;
	cv=none;
	b=JZbLGA7y+XFGkVlF3YOrYz2pzsozqiduBBla/FnkQcYHgrkalNm1rZM5lzY89i++yLxMiY
	ExwkxibuXUqiZjI4ZEK325/cTQkdNC4L/A8D0w1OWBMbAm5hDtKLZ0J7ax1b7td15cLQ35
	kY4pkRXSRqEwFuXVyJQ2M2t4hrOYE6U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AXZqA7u5;
	spf=pass (imf10.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-82f1f6103afso1881991b3a.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776773801; x=1777378601; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yjoi/ADx361WB7o/C1DRNygxoHsfgIft6bO7Dodrjv4=;
        b=AXZqA7u54h2I10/7RBbz9vT63Sc7VPIXKQPGNNdbu2IDwzw6c/4K16jr/9VpCiVeR2
         Azjgjdr0wgPSQBfz+6zoj09q18DPiMmV3i62KAjYCttPNxr7XvWYSAKjKSgYznw6rRWr
         jqeRuqEeOg0bNjMTKZwiCoChKzG7Hi4OBfm0aAbrVWqRqrV34Pq1gWkfAQG8cziuFJR4
         IiC3vpEIN+nVd/1B0bzcntP6ujgCEuJcrMhy44Rph1Dfxp8KW8beRGDPYwddCBqtzlpu
         6p7PUAHMh8/d6G512D1QRyuVZtkpFxAwtsRcAOKia6emqQq4ryisCa+VoRYtTbDFRTJ4
         9I1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776773801; x=1777378601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yjoi/ADx361WB7o/C1DRNygxoHsfgIft6bO7Dodrjv4=;
        b=s8maVzfIn/EdK1iPNeiks54RzotxJJq7wig750OCNId/S/y+07pStENFWJT+vfz04v
         QGIC6k1jL3M9wN9cqomVDrNExXCuvxpv9GVLDvlBjlO67moLs1ugLJTlnmJ9q/rx9FVt
         wcym896rDjma9qlU1dU2XRDX1vEi+UEV8qmZyIrETG5XchNl9FsTKO4xsqE8ZPc4FgvA
         8/fuRBqdraZDMkKHlHQTvvOdfTSbLvrdgQZf9Lni3rYLbtakglx08yOE8RLyKuZzT1MQ
         y4Wv1NwQwFm50Ldbb48Gv7rEdHgSrvCEXA1p952Qh/96rcow05WTnNa+FFl/Ebrg7iFi
         MvWQ==
X-Forwarded-Encrypted: i=1; AFNElJ/RpXLsZlhW6n955q3kVft4RLRR59u0eHQd19MzqRf+J1+EVT3xMWbQljr88A30UUoyOkyO3PwIhg==@kvack.org
X-Gm-Message-State: AOJu0Yw8vLlLJglm+Amkld4I5meJTskD7J9dWZzgwu/UErP5z/sY4GUG
	xiCBFkYp1+u1oA6O5heeAVdPLnRjRoclZd/fkABL49bccbk7kmdOkhxZ
X-Gm-Gg: AeBDievzbqggSiMo/4n7F7J5rXXTI9xH3QXcVQqeXcVejI8XIkhK0WPkERios/7AOay
	5qgWp8QixUoTzlwlOv/4WA2TaA8laoO+RzDMH8KJ23l5rgQ0NBFXM3w//XJTn+N4T9GpZbPbG7U
	Ahef9AnuAq+qoE4IzdPE0jdOUSIUCkDbGbT3i3D+lq9AP9J++KAv2JYhETBpz7wU8nMBRlgvYyW
	/HNFqw9dSfNFQKaDKj/Koz276ZuSSaJM30i5ZSyhKYJ2Lgfly/Qj+LpD/1QWsii9WjxAgS5Mv5e
	H+vu2uKVpxcc5nyNYe7qG31RO1CrSqza8upX25tHC/9J7t959MpGlZzThxnPtix7hwbdHwBluB4
	bUb5nwMsOBK3HbM7rv1OQy4RUCHqHXuWN3G0moLAGSaduroViprKswUEtexiId6743HrJZGZ+KF
	qaidXouuGSEsFVX9j75ZKp7yFAnqG73a/3e+Tee+W15WR1hFZVGK5XyMH7NA==
X-Received: by 2002:a05:6a00:3d16:b0:82d:24f:2511 with SMTP id d2e1a72fcca58-82f8c8522f9mr19548140b3a.12.1776773801023;
        Tue, 21 Apr 2026 05:16:41 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ec037e1sm16371071b3a.54.2026.04.21.05.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 05:16:40 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
X-Google-Original-From: Wenchao Hao <haowenchao@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Minchan Kim <minchan@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Barry Song <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [RFC PATCH v2 2/4] mm/zsmalloc: introduce zs_free_deferred() for async handle freeing
Date: Tue, 21 Apr 2026 20:16:14 +0800
Message-Id: <20260421121616.3298845-3-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260421121616.3298845-1-haowenchao@xiaomi.com>
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o354atjb6sy8h1jyfsazez8epud3ea1a
X-Rspam-User: 
X-Rspamd-Queue-Id: 66F04C0012
X-Rspamd-Server: rspam05
X-HE-Tag: 1776773802-505743
X-HE-Meta: U2FsdGVkX1/IZRY/06h9YHMfaE4rIabvR1xtnX83wi6hvGzaSBrYad8PDHlCDCTz4c+uIWGptAwTS+cDiaUxEVZp/91vHxdkVsvsqm3+RNUinEA4eU/AQ2WBt5+O3tMVm+ASrsFY587skKqBjNxTFXe4w11nPnKJBk7bpI+yMW9dta7uehKTGQHkmE7E7y8r0Je3bMdb3XJujmUDcgRIxAOD4s0yjvB+kTIy2CsHXul3WoZaztt4Fo+e5N7fKEuX8Q0AuvaVhLzbdcYxrPStUhcdcPXMflWbDBZXXABZD5zv1Ust3ycr8Ha2Myj2IrwLHope7j6psHHqVC5CpYVPrYvoOp10CCZ3u/pONwAHxP2jrmgFREJjBOVwsa+2TuEDV/OLnL8qVnaVGvYAhgecV1aRICtYY4urwrIQkDddaIoADNNWoAw3JSXsqw7hy0XVyg+uTrIPjZcg44ZhxjJLmAaioXF51uBx9/SnBbCJHEZ9p+XxiL0lIBrj3bVYymMzvqclLOQIdLy2aNljcWitsId4nkND5OebCR3R4C6TzDT05zpqWIMQmktZfQNnGQB/c4rwjt/hl8jc+H/Nm4ghXh8gaD/Cgp0aO6zI3ecfEVx2aSb+vx+3DN9j5oi+YeDRJjAjV6gdFV4EQXCkERYwjEyivpTZwqIgefVaBFzTJ32c//VUknyZaJpC7JpzNOuINrRvIM9sqFqiOrQoFjxWLRtGQ9lCzY9J46VEtSofAX4MTcIyMRIaiZ0BScb/CRtZXFMYSrewzAqfHuvozTJYPWa7UWyDwe8hMFqxGGJ9xUHtMyA52HqtNt8fxXQRgGNeLaToFkbxy5bZv4XkP5Yw1IOsYYsXW0N4PEcYW0oJL0RoLY4b2ZU/BrPjISZfHbrD0XOt4/AOLt8Lu3p0ELNPVxRS4ZkWL+JnpEVQcM5zwtOOewfGh0oH+pvh7xDQgunKTm2THYqEd33peZWVYji
 lV1BIFiX
 j2Eaij5jxe7GVxN2Pe8ZYEaKu33RoW06k8CgZHldgz4/RLEXgNV/Ayy28uEM1F5JbqGpHiYj85ntq5++KuGX1xSNMECA9xl8GrUh5Gz9oBKs+DddnqjBDhwZgoAqWv2UDIo7qhOUcm22YiQOcEU0WRp2sov5v8N/IJg83wfSdMBsxo0wTKYDDYiinoqlrRZkfdCkjTzCMf8oBwrjzmNUKsOIdmvMTNp5y/M2MmvF8rEJbwrI+aaR5WAnUvHFV90g9hxxg/+5aldpr0TauvD6GuwrOtgwkpYLPk9cFS3eHpNnqksCR8/1JynKm2PfeJWknOCixlHXA5eycSlJkgtli3FM8o68hi4oh19cfIhGVL+gJ4qAtTWAxhDrbpHlzSXgGpNBBau5rKWrWYozejjEz6YJjJVKSMbgfLi4w5CR2Aw7buWDNhWW5cVqztXnN9ZTkf5fK2YSB/MwLkIoRk5aL+zQCwSRFMOjqlHTSE6XK/vJ+kyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zs_free() is expensive due to internal locking (pool->lock, class->lock)
and potential zspage freeing. On the process exit path, the slow
zs_free() blocks memory reclamation, delaying overall memory release.
This has been reported to significantly impact Android low-memory
killing where slot_free() accounts for over 80% of the total swap
entry freeing cost.

Introduce zs_free_deferred() which queues handles into a fixed-size
per-pool array for later processing by a workqueue. This allows callers
to defer the expensive zs_free() and return quickly, so the process
exit path can release memory faster. The array capacity is derived from
a 128MB uncompressed data budget (128MB >> PAGE_SHIFT entries), which
scales naturally with PAGE_SIZE. When the array reaches half capacity,
the workqueue is scheduled to drain pending handles.

zs_free_deferred() uses spin_trylock() to access the deferred queue.
If the lock is contended (e.g. drain in progress) or the queue is full,
it falls back to synchronous zs_free() to guarantee correctness.

Also introduce zs_free_deferred_flush() for use during pool teardown to
ensure all pending handles are freed.

Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 include/linux/zsmalloc.h |   2 +
 mm/zsmalloc.c            | 111 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+)

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
index 40687c8a7469..defc892555e4 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -53,6 +53,10 @@
 
 #define ZS_HANDLE_SIZE (sizeof(unsigned long))
 
+#define ZS_DEFERRED_FREE_MAX_BYTES	(128 << 20)
+#define ZS_DEFERRED_FREE_CAPACITY	(ZS_DEFERRED_FREE_MAX_BYTES >> PAGE_SHIFT)
+#define ZS_DEFERRED_FREE_THRESHOLD	(ZS_DEFERRED_FREE_CAPACITY / 2)
+
 /*
  * Object location (<PFN>, <obj_idx>) is encoded as
  * a single (unsigned long) handle value.
@@ -217,6 +221,13 @@ struct zs_pool {
 	/* protect zspage migration/compaction */
 	rwlock_t lock;
 	atomic_t compaction_in_progress;
+
+	/* deferred free support */
+	spinlock_t deferred_lock;
+	unsigned long *deferred_handles;
+	unsigned int deferred_count;
+	unsigned int deferred_capacity;
+	struct work_struct deferred_free_work;
 };
 
 static inline void zpdesc_set_first(struct zpdesc *zpdesc)
@@ -579,6 +590,19 @@ static int zs_stats_size_show(struct seq_file *s, void *v)
 }
 DEFINE_SHOW_ATTRIBUTE(zs_stats_size);
 
+static int zs_stats_deferred_show(struct seq_file *s, void *v)
+{
+	struct zs_pool *pool = s->private;
+
+	spin_lock(&pool->deferred_lock);
+	seq_printf(s, "pending: %u\n", pool->deferred_count);
+	seq_printf(s, "capacity: %u\n", pool->deferred_capacity);
+	spin_unlock(&pool->deferred_lock);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(zs_stats_deferred);
+
 static void zs_pool_stat_create(struct zs_pool *pool, const char *name)
 {
 	if (!zs_stat_root) {
@@ -590,6 +614,9 @@ static void zs_pool_stat_create(struct zs_pool *pool, const char *name)
 
 	debugfs_create_file("classes", S_IFREG | 0444, pool->stat_dentry, pool,
 			    &zs_stats_size_fops);
+	debugfs_create_file("deferred_free", S_IFREG | 0444,
+			    pool->stat_dentry, pool,
+			    &zs_stats_deferred_fops);
 }
 
 static void zs_pool_stat_destroy(struct zs_pool *pool)
@@ -1432,6 +1459,76 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 }
 EXPORT_SYMBOL_GPL(zs_free);
 
+static void zs_deferred_free_work(struct work_struct *work)
+{
+	struct zs_pool *pool = container_of(work, struct zs_pool,
+					    deferred_free_work);
+	unsigned long handle;
+
+	while (1) {
+		spin_lock(&pool->deferred_lock);
+		if (pool->deferred_count == 0) {
+			spin_unlock(&pool->deferred_lock);
+			break;
+		}
+		handle = pool->deferred_handles[--pool->deferred_count];
+		spin_unlock(&pool->deferred_lock);
+
+		zs_free(pool, handle);
+		cond_resched();
+	}
+}
+
+/**
+ * zs_free_deferred - queue a handle for asynchronous freeing
+ * @pool: pool to free from
+ * @handle: handle to free
+ *
+ * Place @handle into a deferred free queue for later processing by a
+ * workqueue.  This is intended for callers that are in atomic context
+ * (e.g. under a spinlock) and cannot afford the cost of zs_free()
+ * directly.  When the queue reaches a threshold the work is scheduled.
+ * Falls back to synchronous zs_free() if the lock is contended (drain
+ * in progress) or if the queue is full.
+ */
+void zs_free_deferred(struct zs_pool *pool, unsigned long handle)
+{
+	if (IS_ERR_OR_NULL((void *)handle))
+		return;
+
+	if (!spin_trylock(&pool->deferred_lock))
+		goto sync_free;
+
+	if (pool->deferred_count >= pool->deferred_capacity) {
+		spin_unlock(&pool->deferred_lock);
+		goto sync_free;
+	}
+
+	pool->deferred_handles[pool->deferred_count++] = handle;
+	if (pool->deferred_count >= ZS_DEFERRED_FREE_THRESHOLD)
+		queue_work(system_wq, &pool->deferred_free_work);
+	spin_unlock(&pool->deferred_lock);
+	return;
+
+sync_free:
+	zs_free(pool, handle);
+}
+EXPORT_SYMBOL_GPL(zs_free_deferred);
+
+/**
+ * zs_free_deferred_flush - flush all pending deferred frees
+ * @pool: pool to flush
+ *
+ * Wait for any scheduled work to complete, then drain any remaining
+ * handles.  Must be called from process context.
+ */
+void zs_free_deferred_flush(struct zs_pool *pool)
+{
+	flush_work(&pool->deferred_free_work);
+	zs_deferred_free_work(&pool->deferred_free_work);
+}
+EXPORT_SYMBOL_GPL(zs_free_deferred_flush);
+
 static void zs_object_copy(struct size_class *class, unsigned long dst,
 				unsigned long src)
 {
@@ -2099,6 +2196,18 @@ struct zs_pool *zs_create_pool(const char *name)
 	rwlock_init(&pool->lock);
 	atomic_set(&pool->compaction_in_progress, 0);
 
+	spin_lock_init(&pool->deferred_lock);
+	pool->deferred_capacity = ZS_DEFERRED_FREE_CAPACITY;
+	pool->deferred_handles = kvmalloc_array(pool->deferred_capacity,
+						sizeof(unsigned long),
+						GFP_KERNEL);
+	if (!pool->deferred_handles) {
+		kfree(pool);
+		return NULL;
+	}
+	pool->deferred_count = 0;
+	INIT_WORK(&pool->deferred_free_work, zs_deferred_free_work);
+
 	pool->name = kstrdup(name, GFP_KERNEL);
 	if (!pool->name)
 		goto err;
@@ -2201,6 +2310,7 @@ void zs_destroy_pool(struct zs_pool *pool)
 	int i;
 
 	zs_unregister_shrinker(pool);
+	zs_free_deferred_flush(pool);
 	zs_flush_migration(pool);
 	zs_pool_stat_destroy(pool);
 
@@ -2224,6 +2334,7 @@ void zs_destroy_pool(struct zs_pool *pool)
 		kfree(class);
 	}
 
+	kvfree(pool->deferred_handles);
 	kfree(pool->name);
 	kfree(pool);
 }
-- 
2.34.1


