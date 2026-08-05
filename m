Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5CB6C55838
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 00:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D49616B007B; Tue,  4 Aug 2026 20:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9FC6B0088; Tue,  4 Aug 2026 20:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10886B008A; Tue,  4 Aug 2026 20:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 979A36B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:55:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2899A1202D2
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 00:55:55 +0000 (UTC)
X-FDA: 85065398670.04.0E8E571
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8D32318000C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 00:55:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hpc0r50a;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785891353;
	b=XlLx5YghVeYd38kLZRLNqedbTJQDtQEzy9kBoG3A8TK9tJku4b8IEoTwrrEG8jGcuJM1yY
	6nsXdGqcK5Rtv+YEgGdg5M+X5mfEx4/hfE9fh636QDigK/DWdlzn2xeTlh/dVcB7tdl67L
	0wy/3N52uYjv6gee7rMCqTyNAQqdG98=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hpc0r50a;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785891353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jU/YPH5ZMaDPonl6evfZrzgqXu89q45sAG6O5iVL8RQ=;
	b=SZcwUWnTpyrOoaOllAneWwUBXwsl4uxmyJHw59ThWXSzfJRxrkJiQoMlUp8X/7JkosCQcg
	uQtrfL01bgNB0vnB6DL2hNNY6NVZC63o6IPDy3vTksjh5AocOWQAXZDiRgZTC63bo6v8Hx
	gmeoH07CXQMNeiPrxdvKPVAXuQd8fsQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B132040255;
	Wed,  5 Aug 2026 00:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E53D1F000E9;
	Wed,  5 Aug 2026 00:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785891352;
	bh=jU/YPH5ZMaDPonl6evfZrzgqXu89q45sAG6O5iVL8RQ=;
	h=From:To:Cc:Subject:Date;
	b=Hpc0r50aMBHL5TJU8j0igr0yS+FvqaKEFtczekYlw7K7m0O1bycocxw5TADDCGJ9D
	 GAcrGsExTsbOuxfacAeYZgAzKXMSMbYtQqY/GMiwVZ5SigbO8q/B+wjnYkkkmq4IQD
	 X5b1rvnUjlQoFEm2JU0EFcSmvWhVN/h9PHuhVNjE4H6euBTBZaM/L1a6takguv1sIp
	 0AegsKDqDELMxFVNSoApeC/z19ntaK1pscIztmGQpMbIuNqAJFNLlBz9KGnTVWnZ2E
	 j+2pY836pn/wRGmie4Rnh/480+3n7CtjQV1UzuDtPhzDVjeVMRXBfxOsDojdw8nk7k
	 +uPl1B8bPmChA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: senozhatsky@chromium.org,
	akpm@linux-foundation.org
Cc: bigeasy@linutronix.de,
	hdanton@sina.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@kernel.org,
	ryncsn@gmail.com,
	yosry.ahmed@linux.dev,
	surenb@google.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Dongdong Zhang <zhangdongdong5@xiaomi.com>
Subject: [RFC PATCH] zram: avoid preemption with CPU-based compression backends
Date: Wed,  5 Aug 2026 08:55:45 +0800
Message-Id: <20260805005545.66112-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8D32318000C
X-Stat-Signature: ohnz53t1ncs5gz8nzomyiw3kp9kj89kh
X-Rspam-User: 
X-HE-Tag: 1785891353-504166
X-HE-Meta: U2FsdGVkX1+oGQ2afZFJPNI/OavrUs/RaWr2dnakYb7Q6CNDsGGd+AIn2ibfgvemmrRav9C81seUaBr6JDlxvzmp2IQYjQmBgdUGJs6HJUeTRbTY7fmnt7DlGM6XCALbpst+xzKG3pjv2hQEQGcsb24uxa54CO6DfagDGJA5ObdYEYo8qzpQArcaM88pGz38RopqFGvXIJrRpN1jk3E6iB1nvVwiKqErBCQ2NHB69xP2vbkoLm+LFhCLb+rYfymaLdb1p12wLf4U6iRAcWjpwMu9kZETpDmoaw1ZvHhBNhdxdlP/To0XlC5ahZSxLlB1DnO8z9IG/xS8y0AyQ5HbDaq6hhrGWFjdwSIT1hunrXTFXDzd/QEPuGxKGKErf1iqadm6BhE6MbLwVxehmry/VZuHpC2A9F3MT5BVB09ZvANir31+0QujxF2UMTNnDKcTUvgitBamcLk3bgVafmfqkR8u9fpTGxFJl+4p7fSZ1MjNYYVz6u2/CtVCtMG+K+YN2AJhPWkYf6lgAHpaSzqBt++CPBZVc2Qp8qyHwrhpQ7XhpaVclnzZ42qu7vK5BZYsFvxmuzy13kDzljPNWl0gBB2Z6VTYRZfrxSr72aFaOJnHIHADHDqMmAPMorZYJWFbgq6IeruUsSsj9bBWLvrNKaKMIAGGMi4Gb0Zf0FoE9iFwsW/smnwl1ZiAsrJkHq8FUJzATFunWtU2KHmZpylrxybfE4x8Jc7u4weP5New567yLJhqTl7CEVu+F17ptT+xqZ0yniwlPi7ZQhj8sQ4AWw5VK/ubuQk4PgetbYCxRY6AgC32InZwKSGIn9ItLO7E4OhGh/r2xawE32CopB4AjkZjZtWiAkPaXzVbw5h+H9VmDEfKqwV6d0ns5vjMRnl5k2IM6W7WZLQTlYi3H/XANKjkIFE4Ta6W5jT4e74Q+gJGzKt1qXHYFmvPOFZ7cLGHbRLPEyvXPWmQQtV1VMu
 67jj2TQ4
 aKmXUnj9Hri173pMDPIR96oMWpWNVmnYbw4T0dI/quYU+6J+R2lmlIQ6YKb4iRflVVg5l/tMBRhzbfzkvIA3HRCg9lni/PTSJs47PbBZSbLj9HIIY46J9/qWv6pZ7U7moA1+LxZoiED80dkxXBMDweQWGTVk/0Tt+gA5fh2C+8LxXj7NhY/PrBm3wOXFr+xBiMYVmshg8mMRfDJqFJysBmqBsdiPkTbZztTUF6T2ITlh/iFmpNbyf+dLKWnzgEvTZx6ik
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 2efa9e9eb4db ("zram: permit preemption with active
compression stream"), a major Android regression has been reported.

The reason is that compression/decompression is now sleepable and
preemptible. This means a stream may be migrated to another CPU or
be preempted while holding the stream mutex. As a result, high
priority UI threads may get stuck waiting for the mutex during swap-in.

The worst case is when a stream is migrated from a big core to a
little core. On the little core, the stream can be repeatedly
preempted by other threads, while a high priority task running on a
big core is blocked waiting for the mutex to perform decompression
and swap-in.

We add an async flag (currently false for almost all backends) to
indicate whether a backend is asynchronous. For synchronous
backends, we use preempt_disable() in the !PREEMPT_RT case. A
zram_zs_malloc() wrapper is provided to support a two-stage
zs_malloc() path, allowing allocation to transition from a
non-sleepable context to a sleepable context.

Fixes: 2efa9e9eb4db ("zram: permit preemption with active compression stream")
Reported-by: Dongdong Zhang <zhangdongdong5@xiaomi.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 drivers/block/zram/zcomp.c    | 14 ++++--
 drivers/block/zram/zcomp.h    |  3 +-
 drivers/block/zram/zram_drv.c | 87 +++++++++++++++++++----------------
 3 files changed, 61 insertions(+), 43 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 974c4691887e..dd4db4a8af73 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -128,14 +128,20 @@ struct zcomp_strm *zcomp_stream_get(struct zcomp *comp)
 		 * so then unlock and re-try on the current CPU.
 		 */
 		mutex_lock(&zstrm->lock);
+		if (!comp->ops->async && !IS_ENABLED(CONFIG_PREEMPT_RT))
+			preempt_disable();
 		if (likely(zstrm->buffer))
 			return zstrm;
 		mutex_unlock(&zstrm->lock);
 	}
 }
 
-void zcomp_stream_put(struct zcomp_strm *zstrm)
+void zcomp_stream_put(struct zcomp *comp)
 {
+	struct zcomp_strm *zstrm = raw_cpu_ptr(comp->stream);
+
+	if (!comp->ops->async && !IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
 	mutex_unlock(&zstrm->lock);
 }
 
@@ -150,7 +156,8 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 	};
 	int ret;
 
-	might_sleep();
+	if (comp->ops->async)
+		might_sleep();
 	ret = comp->ops->compress(comp->params, &zstrm->ctx, &req);
 	if (!ret)
 		*dst_len = req.dst_len;
@@ -167,7 +174,8 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
 		.dst_len = PAGE_SIZE,
 	};
 
-	might_sleep();
+	if (comp->ops->async)
+		might_sleep();
 	return comp->ops->decompress(comp->params, &zstrm->ctx, &req);
 }
 
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 81a0f3f6ff48..5293d638da8f 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -67,6 +67,7 @@ struct zcomp_ops {
 	void (*release_params)(struct zcomp_params *params);
 
 	const char *name;
+	bool async;
 };
 
 /* dynamic per-device compression frontend */
@@ -86,7 +87,7 @@ struct zcomp *zcomp_create(const char *alg, struct zcomp_params *params);
 void zcomp_destroy(struct zcomp *comp);
 
 struct zcomp_strm *zcomp_stream_get(struct zcomp *comp);
-void zcomp_stream_put(struct zcomp_strm *zstrm);
+void zcomp_stream_put(struct zcomp *comp);
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 		   const void *src, unsigned int *dst_len);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index cfa98846ac48..52b9fbe3e0d1 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1364,7 +1364,7 @@ static int decompress_bdev_page(struct zram *zram, struct page *page, u32 index)
 	if (!ret)
 		copy_page(src, zstrm->local_copy);
 	kunmap_local(src);
-	zcomp_stream_put(zstrm);
+	zcomp_stream_put(zram->comps[prio]);
 	slot_unlock(zram, index);
 
 	return ret;
@@ -2098,7 +2098,7 @@ static int read_compressed_page(struct zram *zram, struct page *page, u32 index)
 	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size, dst);
 	kunmap_local(dst);
 	zs_obj_read_end(zram->mem_pool, handle, size, src);
-	zcomp_stream_put(zstrm);
+	zcomp_stream_put(zram->comps[prio]);
 
 	return ret;
 }
@@ -2124,7 +2124,7 @@ static int read_from_zspool_raw(struct zram *zram, struct page *page, u32 index)
 				zstrm->local_copy);
 	memcpy_to_page(page, 0, src, size);
 	zs_obj_read_end(zram->mem_pool, handle, size, src);
-	zcomp_stream_put(zstrm);
+	zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
 
 	memzero_page(page, size, PAGE_SIZE - size);
 
@@ -2218,20 +2218,40 @@ static int write_same_filled_page(struct zram *zram, unsigned long fill,
 	return 0;
 }
 
+/*
+ * try non-sleepable allocation for !async backend, then try
+ * sleepable allocation; for async backend, we always begin
+ * from sleepable allocation
+ */
+static unsigned long zram_zs_malloc(struct zram *zram, size_t comp_len,
+		bool async, const int nid)
+{
+	unsigned long handle;
+
+	if (!async && !IS_ENABLED(CONFIG_PREEMPT_RT)) {
+		handle = zs_malloc(zram->mem_pool, comp_len,
+				__GFP_KSWAPD_RECLAIM | __GFP_NOWARN |
+				__GFP_HIGHMEM | __GFP_MOVABLE, nid);
+		if (!IS_ERR_VALUE(handle))
+			return handle;
+		preempt_enable();
+	}
+
+	handle = zs_malloc(zram->mem_pool, comp_len,
+			   GFP_NOIO | __GFP_NOWARN |
+			   __GFP_HIGHMEM | __GFP_MOVABLE, nid);
+	if (!async && !IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
+	return handle;
+}
+
 static int write_incompressible_page(struct zram *zram, struct page *page,
-				     u32 index)
+				     u32 index, bool async)
 {
 	unsigned long handle;
 	void *src;
 
-	/*
-	 * This function is called from preemptible context so we don't need
-	 * to do optimistic and fallback to pessimistic handle allocation,
-	 * like we do for compressible pages.
-	 */
-	handle = zs_malloc(zram->mem_pool, PAGE_SIZE,
-			   GFP_NOIO | __GFP_NOWARN |
-			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+	handle = zram_zs_malloc(zram, PAGE_SIZE, async, page_to_nid(page));
 	if (IS_ERR_VALUE(handle))
 		return PTR_ERR((void *)handle);
 
@@ -2268,6 +2288,7 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 	struct zcomp_strm *zstrm;
 	unsigned long element;
 	bool same_filled;
+	bool async;
 
 	mem = kmap_local_page(page);
 	same_filled = page_same_filled(mem, &element);
@@ -2275,6 +2296,7 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 	if (same_filled)
 		return write_same_filled_page(zram, element, index);
 
+	async = zram->comps[ZRAM_PRIMARY_COMP]->ops->async;
 	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
 	mem = kmap_local_page(page);
 	ret = zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
@@ -2282,32 +2304,30 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 	kunmap_local(mem);
 
 	if (unlikely(ret)) {
-		zcomp_stream_put(zstrm);
+		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
 		pr_err("Compression failed! err=%d\n", ret);
 		return ret;
 	}
 
 	if (comp_len >= huge_class_size) {
-		zcomp_stream_put(zstrm);
-		return write_incompressible_page(zram, page, index);
+		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
+		return write_incompressible_page(zram, page, index, async);
 	}
 
-	handle = zs_malloc(zram->mem_pool, comp_len,
-			   GFP_NOIO | __GFP_NOWARN |
-			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+	handle = zram_zs_malloc(zram, comp_len, async, page_to_nid(page));
 	if (IS_ERR_VALUE(handle)) {
-		zcomp_stream_put(zstrm);
+		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
 		return PTR_ERR((void *)handle);
 	}
 
 	if (!zram_can_store_page(zram)) {
-		zcomp_stream_put(zstrm);
+		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
 		zs_free(zram->mem_pool, handle);
 		return -ENOMEM;
 	}
 
 	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
-	zcomp_stream_put(zstrm);
+	zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
 
 	slot_lock(zram, index);
 	slot_free(zram, index);
@@ -2423,6 +2443,7 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 	unsigned int class_index_old;
 	unsigned int class_index_new;
 	void *src;
+	bool async;
 	int ret = 0;
 
 	handle_old = get_slot_handle(zram, index);
@@ -2447,6 +2468,7 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 	 */
 	clear_slot_flag(zram, index, ZRAM_IDLE);
 
+	async = zram->comps[prio]->ops->async;
 	zstrm = zcomp_stream_get(zram->comps[prio]);
 	src = kmap_local_page(page);
 	ret = zcomp_compress(zram->comps[prio], zstrm, src, &comp_len_new);
@@ -2462,7 +2484,7 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 		*num_recomp_pages -= 1;
 
 	if (ret) {
-		zcomp_stream_put(zstrm);
+		zcomp_stream_put(zram->comps[prio]);
 		return ret;
 	}
 
@@ -2471,7 +2493,7 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 
 	if (class_index_new >= class_index_old ||
 	    (threshold && comp_len_new >= threshold)) {
-		zcomp_stream_put(zstrm);
+		zcomp_stream_put(zram->comps[prio]);
 
 		/*
 		 * Secondary algorithms failed to re-compress the page
@@ -2485,27 +2507,14 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 		return 0;
 	}
 
-	/*
-	 * We are holding per-CPU stream mutex and entry lock so better
-	 * avoid direct reclaim.  Allocation error is not fatal since
-	 * we still have the old object in the mem_pool.
-	 *
-	 * XXX: technically, the node we really want here is the node that
-	 * holds the original compressed data. But that would require us to
-	 * modify zsmalloc API to return this information. For now, we will
-	 * make do with the node of the page allocated for recompression.
-	 */
-	handle_new = zs_malloc(zram->mem_pool, comp_len_new,
-			       GFP_NOIO | __GFP_NOWARN |
-			       __GFP_HIGHMEM | __GFP_MOVABLE,
-			       page_to_nid(page));
+	handle_new = zram_zs_malloc(zram, comp_len_new, async, page_to_nid(page));
 	if (IS_ERR_VALUE(handle_new)) {
-		zcomp_stream_put(zstrm);
+		zcomp_stream_put(zram->comps[prio]);
 		return PTR_ERR((void *)handle_new);
 	}
 
 	zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer, comp_len_new);
-	zcomp_stream_put(zstrm);
+	zcomp_stream_put(zram->comps[prio]);
 
 	slot_free(zram, index);
 	set_slot_handle(zram, index, handle_new);
-- 
2.39.3 (Apple Git-146)


