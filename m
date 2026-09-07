Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 319ACC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27D3A6B00A3; Mon,  7 Sep 2026 06:58:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255346B00A9; Mon,  7 Sep 2026 06:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A456B00AA; Mon,  7 Sep 2026 06:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEEA16B00A3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:58:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F0AD160119
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:58:07 +0000 (UTC)
X-FDA: 85186666614.24.4D19DE5
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id A1F1616000B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:58:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ThuwTyaT;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788778685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QaUctYgsKexv76T3vPQS88gPu5aYrdy0F+NCE/op3Bo=;
	b=QN0BC/KtzdFC1hx/B7QgDuiG/ahYgoTfNwiVGVuRFgRbMtD3BZzRLJbQnuwLdxlxW6QJzv
	xDSKvjgWP1YpbQOyWychUUf0nhAluVQExPxeKA4cmsRqdiJCLskos1GfrXNl/TFIo+1CZJ
	QjgGQWw9wYJ2gTaSahKgfxzxgyC82js=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788778685;
	b=4qZB3xhUVrZbKGVXTrHRDF1fmLfd2mbO23A+PdU4FjN6h0Cs91weimJxyOzOxqpUW1Hiod
	f1ArM932CKcFArTLP1Pp3C8gvSYjcFefIWE1AYo6JcaulWGwtFdeWWguj9Ymu+Ojn3P+Ut
	PRMxwS29cDwj3PyC0TB8sXM4IbAu7/Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ThuwTyaT;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso2442829a91.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 03:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1788778684; x=1789383484; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QaUctYgsKexv76T3vPQS88gPu5aYrdy0F+NCE/op3Bo=;
        b=ThuwTyaTs11f0TIIAwWAZZqNNOmjgf31K6ZtoMQ+TN/40Xo+7desl4YfgGi/BvQny0
         SQUFh/GuWcDSdVC6jTSUrWhTkT4oCqMz3mZJqVedorBM/fospAXO8+c+85DzCqFH9hMF
         Vf8kEdklgbUjnn5AbCChC0edjcq4dDsK6bJn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788778684; x=1789383484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QaUctYgsKexv76T3vPQS88gPu5aYrdy0F+NCE/op3Bo=;
        b=shxSgw3zMkupm8e+h1MCCrb5VK+691FAnmmpSBXkmbo6MxS7Zsgxpx8cz1qCnmCUcL
         wNDxae5UB3ZXOSAZZEQlWzwvcfjtVhp34gjbl/CkSoWTdMTo80GngPtFhpYB9+H/glX8
         931gtzFjCYvmzuOd5WzuXq36AgCm7lb1NjUVHgsS57xp+gukLJsZwOm3xf1lbk5tXdWD
         qEF8F8OBxE8d40Z0hXHw998xOwmdtATTKy4dbrieJpCykzG/LvzrZwjhA3FbLLBlRtJd
         fR228dRG+HDKSSzi9cDYMGV9F5ODScqkxm5rCDqPumU31JcDm1cC5NHwM/8a77kdKzxU
         ducQ==
X-Forwarded-Encrypted: i=1; AKwUvByB8PUm1MjA+qpFS/nYeVrEdejnSGeC+bPive75520DGxAuNuv/RAQZ3oQx/sy7wKmNQSsXWUL6fw==@kvack.org
X-Gm-Message-State: AFuF++kKaMsyocAWNOVHp+magt4WpvAYMQmI46tGH5emy7XUMQoQYdUp
	uiDDF02b0jOXHxF9pGm/gC6K4kYzAyaivwRJcRSGN6J3rZGupfZU1Yvwuix1cgTucQ==
X-Gm-Gg: AYBFou3X01jZirg3jwy3wUl4HAA3AMONIBxQ5ds6UKWnwgwBXPfQ0mhuMUriETkbaDj
	j4TZ94w842HEekb7xVmW3taMQPTPmpXDSvGZ/hBt+/UeDh5OkcZd+YFlzU0G2/2dhs4QpqfDtY4
	5o0Uzg/tYG1XZE8yCli4Oub7E0eSdNlkjrFojtyCFpzyNSUEZuD7t7vdrIpfDcI/D944CY+5Nrl
	KwByS+VeX+IAUKHGXg4Smfi2LegQCoV1U1H+knJY1/woERIVWDnBbF/2MK6uT6guXfnR8lSa9Gn
	4OiV8ET+A/9dqrlqjAdwPtSInN6FG0MQZrPyseyVJaplQI52c/1yUX6+FDNdRIyezRbem9f8ZZT
	+IpIrJPVeI1KuuaZc2L7r5iMDe0C1Jec0bV4xtIW3i5lM9YHE0kc0jF98CWYPSVZUmxPbl8le3x
	i4a01AMq/KJuWoGJCOfsybvpNjrIhPk8aHa3S7Vs5guC8dey0wvIw9y+7gJUUf+LHzcNq4lNCPo
	ea6d2yCQFrJIMWO/0nw4SGC/7YQm2UX1WfB1/RmkHY7QEDmmI8j
X-Received: by 2002:a17:90b:2884:b0:398:e86b:ce14 with SMTP id 98e67ed59e1d1-39b262ab44emr32170153a91.20.1788778684370;
        Mon, 07 Sep 2026 03:58:04 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:7fc7:d8d5:4877:bc3f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b51eb40e6sm10343714a91.16.2026.09.07.03.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 03:58:03 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 1/2] zram: convert to SG-list zsmalloc object read API
Date: Mon,  7 Sep 2026 19:57:28 +0900
Message-ID: <20260907105739.1793316-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
In-Reply-To: <20260907105739.1793316-1-senozhatsky@chromium.org>
References: <20260907105739.1793316-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A1F1616000B
X-Stat-Signature: tghehyiw5cyzw6yqs4o4s9rtfdtapdc4
X-HE-Tag: 1788778685-440095
X-HE-Meta: U2FsdGVkX1+mMsn7FlOVxyE7mHqmpmQtKxCRZ31+3kWazdbpYP7RjQb6KE9DUia+62jXmiO8Hh2BAixHRiF9ibd15DjiAjzGbxAFblY1lrLckRrlohwUNZZqrSw+7CVcffL4lgX7ULmXhrWiQmpvjMRqT0cTy0B4nGLASAmd4lEKjQkHxzv4caD0u8SdeDi6ln03GapkdbsdXKYGmh1/NqoWtTBDM5KUNcnrzvblpkWv7G5DfIQDlyrDphyqaXtW0BBRLL9Dl3HPfTnerAXN0c6OFMIpb0BlBPmlofd2+CoIQ/5z5tPptDgzw3r7+opjwN54rclHuaePgeqrWyuLNTMq9P44y2ycywqWjH4e9YIDfe6RN+c9jG1BrhSPwR4/zX3Uj/hdaLs0WNU6MSNZ31Ym9542qMALmBMSEiUMS25pOlew7CxfXihLAAjb5PJ4b/Bx7EfrtS6ojEIXabXaTPOD+djnsz5vTTFFPZ97kc3Egl4EoinpmhKHXyC+ZZdBRda2KONugZhxZTMfRpOsMi59Gdd8R437DdRmKbqDql0+hNOLS18zVHeU6iy2BBz2U7+dsbpCPun28HLwgko96QV/It15tEXVfhKdogzzOL0CghGUtyRkIo7h/uGX0XNyNlTF2CWJCwZGACsEQ4P+VCP1M5CNMumeDHffd8vkK5W9Fn+fjIct//21wNCYu11hHQMf/F/ltIH5HI2HPyBdqmh/w41XPhuagmH9/MUaHOQMWj/Jpf2SqiZ3uqkgTaGsZ+BjeeNToyCeL/Jib2+mhpo4By44u3DMTX0GKDJ5YfB8xeEHCqW6yBbbW/bofj5LrF+ISPDT7jxrsdWW6eH4ePxB85DoSd0H50YkJNtmpcoyiwAqXICuwSJNZcstYQ5/83VOlw9/Bu1/sh2pTQoHqUi5I8jH/2RKhhj8/IyoKyVYiJ01XM2tbyaMbIMYXg1oMtxCMAIOukUqSN97ooe
 d9uj8sVs
 E34kqXvBLZQMo7zF2dyIZm1VWimZujRC8yewgJXDrh2Q+kCN58INTrWqQjPYQf7xK+dZhBZfvLx+czB2YMYTr6tN4gFvQEZzAFwScwIBk83EZrYWBA7KAIBB66j8pSAX0NOg3v5opoc0CHkAvPe+MIqHM9OJVTTcC+/EwRh7IEtQoX+eLAv6TUDSW5KGDZzNS1DYL8PFyInGdXBbfr4IZNyQom25I7ouLU4Nvubds+rjyEMkH5abc+7NshzY6EQo6ZiWo7PQnMgrC+KPuXgaOeeOllBkfbPId0VXNFsGMtxhdNYrdaBEbnFV0ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zram remains the last user of old zsmalloc object read
API, that performed linearisation on the zsmalloc side.
There is a new SG-list API, that has a bunch of benefits.
Switch zram to SG-list zsmalloc object read API.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zcomp.c    | 23 ++++++++++++--
 drivers/block/zram/zcomp.h    |  4 ++-
 drivers/block/zram/zram_drv.c | 56 ++++++++++++++++++++---------------
 3 files changed, 55 insertions(+), 28 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 974c4691887e..028e2f0f587e 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -7,6 +7,8 @@
 #include <linux/wait.h>
 #include <linux/sched.h>
 #include <linux/cpuhotplug.h>
+#include <linux/highmem.h>
+#include <linux/scatterlist.h>
 #include <linux/vmalloc.h>
 #include <linux/sysfs.h>
 
@@ -158,17 +160,32 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 }
 
 int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
-		     const void *src, unsigned int src_len, void *dst)
+		     struct scatterlist *sg, unsigned int src_len, void *dst)
 {
 	struct zcomp_req req = {
-		.src = src,
 		.dst = dst,
 		.src_len = src_len,
 		.dst_len = PAGE_SIZE,
 	};
+	void *src = NULL;
+	int ret;
 
 	might_sleep();
-	return comp->ops->decompress(comp->params, &zstrm->ctx, &req);
+
+	if (sg_is_last(sg)) {
+		/* the object is contained within one page, read it in-place */
+		src = kmap_local_page(sg_page(sg));
+		req.src = src + sg->offset;
+	} else {
+		/* the object spans two pages, linearize it into local copy */
+		sg_copy_to_buffer(sg, 2, zstrm->local_copy, src_len);
+		req.src = zstrm->local_copy;
+	}
+
+	ret = comp->ops->decompress(comp->params, &zstrm->ctx, &req);
+	if (src)
+		kunmap_local(src);
+	return ret;
 }
 
 int zcomp_cpu_up_prepare(unsigned int cpu, struct hlist_node *node)
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 81a0f3f6ff48..f38fd31f9e4e 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -5,6 +5,8 @@
 
 #include <linux/mutex.h>
 
+struct scatterlist;
+
 #define ZCOMP_PARAM_NOT_SET	INT_MIN
 
 struct deflate_params {
@@ -91,6 +93,6 @@ void zcomp_stream_put(struct zcomp_strm *zstrm);
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 		   const void *src, unsigned int *dst_len);
 int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
-		     const void *src, unsigned int src_len, void *dst);
+		     struct scatterlist *sg, unsigned int src_len, void *dst);
 
 #endif /* _ZCOMP_H_ */
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a9b3bb1d3bef..5431b16f2f45 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -32,6 +32,7 @@
 #include <linux/debugfs.h>
 #include <linux/cpuhotplug.h>
 #include <linux/part_stat.h>
+#include <linux/scatterlist.h>
 #include <linux/kernel_read_file.h>
 #include <linux/rcupdate.h>
 
@@ -1342,9 +1343,9 @@ static int decompress_bdev_page(struct zram *zram, struct page *page,
 				unsigned long index)
 {
 	struct zcomp_strm *zstrm;
+	struct scatterlist sg[1];
 	unsigned int size;
 	int ret, prio;
-	void *src;
 
 	slot_lock(zram, index);
 	/* Since slot was unlocked we need to make sure it's still ZRAM_WB */
@@ -1363,13 +1364,18 @@ static int decompress_bdev_page(struct zram *zram, struct page *page,
 	size = get_slot_size(zram, index);
 	prio = get_slot_comp_priority(zram, index);
 
+	sg_init_table(sg, 1);
+	sg_set_page(sg, page, size, 0);
+
 	zstrm = zcomp_stream_get(zram->comps[prio]);
-	src = kmap_local_page(page);
-	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size,
+	ret = zcomp_decompress(zram->comps[prio], zstrm, sg, size,
 			       zstrm->local_copy);
-	if (!ret)
-		copy_page(src, zstrm->local_copy);
-	kunmap_local(src);
+	if (!ret) {
+		void *dst = kmap_local_page(page);
+
+		copy_page(dst, zstrm->local_copy);
+		kunmap_local(dst);
+	}
 	zcomp_stream_put(zstrm);
 	slot_unlock(zram, index);
 
@@ -2086,15 +2092,19 @@ static int read_same_filled_page(struct zram *zram, struct page *page,
 static int read_incompressible_page(struct zram *zram, struct page *page,
 				    unsigned long index)
 {
+	struct scatterlist sg[2];
 	unsigned long handle;
 	void *src, *dst;
 
 	handle = get_slot_handle(zram, index);
-	src = zs_obj_read_begin(zram->mem_pool, handle, PAGE_SIZE, NULL);
+	zs_obj_read_sg_begin(zram->mem_pool, handle, sg, PAGE_SIZE);
+	/* an incompressible object never spans two pages */
+	src = kmap_local_page(sg_page(sg));
 	dst = kmap_local_page(page);
 	copy_page(dst, src);
 	kunmap_local(dst);
-	zs_obj_read_end(zram->mem_pool, handle, PAGE_SIZE, src);
+	kunmap_local(src);
+	zs_obj_read_sg_end(zram->mem_pool, handle);
 
 	return 0;
 }
@@ -2103,9 +2113,10 @@ static int read_compressed_page(struct zram *zram, struct page *page,
 				unsigned long index)
 {
 	struct zcomp_strm *zstrm;
+	struct scatterlist sg[2];
 	unsigned long handle;
 	unsigned int size;
-	void *src, *dst;
+	void *dst;
 	int ret, prio;
 
 	handle = get_slot_handle(zram, index);
@@ -2113,12 +2124,11 @@ static int read_compressed_page(struct zram *zram, struct page *page,
 	prio = get_slot_comp_priority(zram, index);
 
 	zstrm = zcomp_stream_get(zram->comps[prio]);
-	src = zs_obj_read_begin(zram->mem_pool, handle, size,
-				zstrm->local_copy);
+	zs_obj_read_sg_begin(zram->mem_pool, handle, sg, size);
 	dst = kmap_local_page(page);
-	ret = zcomp_decompress(zram->comps[prio], zstrm, src, size, dst);
+	ret = zcomp_decompress(zram->comps[prio], zstrm, sg, size, dst);
 	kunmap_local(dst);
-	zs_obj_read_end(zram->mem_pool, handle, size, src);
+	zs_obj_read_sg_end(zram->mem_pool, handle);
 	zcomp_stream_put(zstrm);
 
 	return ret;
@@ -2128,25 +2138,23 @@ static int read_compressed_page(struct zram *zram, struct page *page,
 static int read_from_zspool_raw(struct zram *zram, struct page *page,
 				unsigned long index)
 {
-	struct zcomp_strm *zstrm;
+	struct scatterlist sg[2];
 	unsigned long handle;
 	unsigned int size;
-	void *src;
+	void *dst;
 
 	handle = get_slot_handle(zram, index);
 	size = get_slot_size(zram, index);
 
 	/*
-	 * We need to get stream just for ->local_copy buffer, in
-	 * case if object spans two physical pages. No decompression
-	 * takes place here, as we read raw compressed data.
+	 * No decompression takes place here, we copy out raw compressed
+	 * data directly into the destination page.
 	 */
-	zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
-	src = zs_obj_read_begin(zram->mem_pool, handle, size,
-				zstrm->local_copy);
-	memcpy_to_page(page, 0, src, size);
-	zs_obj_read_end(zram->mem_pool, handle, size, src);
-	zcomp_stream_put(zstrm);
+	zs_obj_read_sg_begin(zram->mem_pool, handle, sg, size);
+	dst = kmap_local_page(page);
+	sg_copy_to_buffer(sg, sg_nents(sg), dst, size);
+	kunmap_local(dst);
+	zs_obj_read_sg_end(zram->mem_pool, handle);
 
 	memzero_page(page, size, PAGE_SIZE - size);
 
-- 
2.55.0.979.g7e5102b832-goog


