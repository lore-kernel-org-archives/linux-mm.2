Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5953CC6B2D
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CC706B00A6; Fri, 16 Oct 2026 00:45:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87CB96B00A7; Fri, 16 Oct 2026 00:45:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792E66B00A9; Fri, 16 Oct 2026 00:45:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 339606B00A6
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:45:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 93F5116032C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:45:09 +0000 (UTC)
X-FDA: 85327249938.10.8F35BA4
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id C596E80007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:45:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=mS9dcj9m;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792125907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0i3/GM+C7HIQ+51vxL/QdBH6G/WwpNAIZ4e9TPzcXVA=;
	b=Tmke+rEdMhi7Q7BaalyNJRyl0RRm+ce9kjKHlp13wlosvl1bfTgbzGdeqAHpkBw6AG6P1j
	kmvghjV1jPkwoP/MeP7kT2GJ44Mr2KpK28UEYil4xdVVSDR/w4jUrAWIVDdtFlQP14Oua9
	8/Etb09fVF47vomxvV9n7ShucGx53xM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=mS9dcj9m;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792125907;
	b=zjP/uwNOFjwsQzGhTPrTY+BJiy2U3IuVCBfR+KATsfnKVEkUDw7+/HTAfmPqHwUJNYDdkr
	RkMzQ4dQaqHti/ublkeEGkijojHlbr2i1EGfXHIEmE5dM7mc4csJArr79WY02dGvboYRba
	+anoU34OzHwu/SpMjbxtyKZVQusSMfA=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e98798cbddso1139945ad.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792125907; x=1792730707; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0i3/GM+C7HIQ+51vxL/QdBH6G/WwpNAIZ4e9TPzcXVA=;
        b=mS9dcj9mHDyboapMRVkDv5zKDlXb20pcLE7udoG6fDIns7AlukvsY6Z1eNDc3MgfI0
         Sm5is2n7Omt9OLxURlowbnyov1XBbjOyxjsh4YCoiT4upIIs3HMmRDdmU6Ma0cNaG7Ks
         XijURpRR+AqJHXnaf2xzV23joD2PpyJLNgYnU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792125907; x=1792730707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0i3/GM+C7HIQ+51vxL/QdBH6G/WwpNAIZ4e9TPzcXVA=;
        b=ry33WE9VmTxuqwls9ZqmK0CbkDJXm2W2/P5pb2NMW/Qv42VQOI+wyjStoDcPxzhJRJ
         9NyrscQLCFqGa9ImfrolrbcUxi7YDZvAB45NBz7vgRlsocNV2REOSXaYTsueALW2GRn+
         dLe/0NkRugzIxURtDnA2hFOtTtZSWMRfFpGdqirHwjwRnrX0GhxT0RkwIyP8s7Jgbo7R
         cvlHwvjV5lRGslz5mhdc6cI/5/PWJ1YBdBUhLpDjCgzVxHEb+2ViBDrT6uvgSTqe2y2c
         rVo1kOXGybxISNusMdhg7wSdzvdwsu/bXby7eGfWLhuOjqrUHKNR+Hs9/jVtqSAhtSHl
         UyKA==
X-Forwarded-Encrypted: i=1; AKwUvBzqsMdTJd/h5/juvtsEwPemsgANNXRr3hECYzzY+DBAnTSa7bsOHdxz6yw6YmM5UWfsVcEGhMLBLQ==@kvack.org
X-Gm-Message-State: AFq9FYJvkybX6R5Mk8A5YDI+OLvYjPS22LuNZSNQWSqbCtYvIJf/PRYU
	QXMqQ2l/Vw3RsPVCltB72QbyhnbgLZaL7Os+D/R6ViHwJ/IZayriMcbgntVwhqaALQ==
X-Gm-Gg: AYBFou31aeQluv14SMXU1HkN8zpFzBaIoBl0B2C/fpW3l3k+hS762EN7yr0l1ze1Xuz
	OpCo4qmUp9apv3PWcO1kbrlNDird096pUYxeZM6PHIJdB7cuGY7hfq58FTwUFtE9h0OvZpZ3LVe
	ceLEq0zmnuWsH6g3jrR3Y0KTKugxO0oLuedi5VRcAMzxuS6dair/mUTWn3emiKYo5WqwZOOI+dn
	qqwQJD3WBL3aw3EwgV+O/ohINR44Vejs/U97YfGrt0z96bJQ9lUT98FX+xkWULk9P8bquSPkqX9
	volUt1rEbjCdd4LdIXbUB7jSgi84gpyCUMhfRPZSKneUII9MwETcMK3wEJgXXqsXUlwJ4BSzURT
	AsPvVevqjE3kOL7OObQYKtxKA72VDpgRXeuQRLj5TsAYxllxfO//AuB/AxkArsp9KSsbombmBX7
	opp0+ebiRcWTmxpKS2xpu0owH60Dm7UGRx6zghry5COfhRtbCTdWB6JdVuQBZBuwupEB2AOrLwq
	Rm+UFHzP8Gx5oCJeYnPigPkhPNXIuWEBiu8GlvmjUNp2j7E2wOWfxK18KFX1v+QyssyQBuqna6Q
	TvZIrDagRFYVlVVCCkme4c6R1nvgImqbTZp5FkplobEA
X-Received: by 2002:a17:902:dac1:b0:2e5:f62e:2eaa with SMTP id d9443c01a7336-2e842cd5165mr192173705ad.43.1792125906642;
        Thu, 15 Oct 2026 21:45:06 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:a579:8b87:8304:7ac2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e8b1b5esm4137235ad.67.2026.10.15.21.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:45:06 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo0325@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v4 11/12] zram: allocate bounce buffer for spanning objects
Date: Fri, 16 Oct 2026 13:44:16 +0900
Message-ID: <20261016044429.1304561-12-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261016044429.1304561-1-senozhatsky@chromium.org>
References: <20261016044429.1304561-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: btmwfnb7a4y6izb5g5mxhfc7ihyux84d
X-Rspam-User: 
X-Rspamd-Queue-Id: C596E80007
X-Rspamd-Server: rspam08
X-HE-Tag: 1792125907-505292
X-HE-Meta: U2FsdGVkX19H7srkakTzcYrUGhNvJEN4pgh2V+MQrVQgIgXehMoAKF6BTzPdtdIqez2QVYa+jR0UNqofedm8SsNq95D9t0wc+SJatU2RtYJusdf5N3vSEB0JXYP9vY9nJK+NOzQ7NP3FyG1hQcV29+QV4ZNnKo5Ijh/u4c/TQjgt1WKhZ14evBVeEoeifvO8nKhiIaLmKo/CNSgbVlbY39YsePA/N8BIq9tdk54/xDAImXa+WlT1H2hxFf3mWzo6s8WvmqB65nmep1QHqKC+84aurGmQQYEA60IRbT8g+ISIaNeFVaAmURleScgAkh4p5CPiot/wsYWPCdkC2yJfI0DVPcNBbPJR7IkklNtFvdATEAFx30hLXrNIjw1SmKzHs43zTZ8uLBdUT3v3lVInF8tW46tG2xi+qX9qOSI28xSpGOG6966xlPu0BgF7y1lKci8WRMa24BlTiDYjmAzmxxD39BCLwimNKQJqGXopS8pwZmrNinHui/IgxV8UVe49gXUdTw5H1Kt6H+nX05FfHgEGQKRjLdziwbk+Jkvx2W9m9gPO/JuQWM/X0yzMTSdPT9U7kQ5v7yJ5RkNnMpeUWuTCGSOGfHmPSBlu/e74nb4MABFn3CbsfM1Ur8ViIy1a1hBuKuvoPXUc1YS7rC83EE4blz2VdtPJaJNqzwK63zT8oHele+yYesbd3Oif0etSfOcEtYEyAnD2IuLKOJdbpdpvecYrdUYmAsHoP2RDKd1oJ4dxJNU1RZHNUBUy3YVZyM9Zs7iVMtXLl66pnykjrmbkVPLtNqc5NQHwXSz2fxSkhskOPSmBMrQQ1tuqefXSsRjmGYUPNc0ZZblwf5mRAaiDu7aqg1na95MeniWrWCUFHUrefkRv6U+CGMyMC2Ox3vZzRu6z8ce8xmQXxofNgSB6yrugfECdutNG4gUmXymqSOU0awnNT79PzwrzIA311G+9uWX8WH1llYEODW1
 MTk+Isxt
 frtJ/v9NIs/uEwDeQ7bV1TPWV1DKhib+Gq2WUOJ30ARALUhrNaLuiPsOXoZAFNtd1BzfkMa2/OzQHFXmHfoIxBsjcfhsEI70nSPR+oyBW+2c5JxeEsiSAmepXdfP/8fjQeC1tYoh6Zj/Fwv/9J8OjSzulYPmyJtMwFJeUih1Suhq68usSaIA0am3BzyuLU8lBlQfU6SOz4135lpV1a84R60YuZJzRdzQez/IxdhhpNO4YBAINIqsupkgMykSao8Pi/nPBj8ShIW3xe4nYsi0dmU9Kmp63zP3AObXepd2wWKQ4OKv4u3rIQqEjuO4SQv6JfTwkogc52svc4VRqz7u2UQn5SyZk2i+yZ3R6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zsmalloc objects that span two physical pages need to be linearized
before decompression, which zcomp does using stream's ->local_copy
buffer.  That buffer cannot be used concurrently, so such reads take
the stream in exclusive mode, even when the backend has stateless
decompression.  And spanning objects are not rare: Bo Zhang [1]
measured 23.3% of reads on lzo-rle going through the exclusive path,
causing contention on ->excl_lock of up to 72-96 ms:

                      baseline   patched w/o kmalloc bounce
  read contended      24,749     1,959
  read wait_ns total  239.8 s    ~12 s
  read wait_ns max    757 ms     72-96 ms
  read acquire        3,948,150  3,510,610

Allocate a temporary bounce buffer for spanning objects instead, so
that backends with stateless decompression can always use shared mode.
If the allocation fails we fall back to ->local_copy under ->excl_lock.

Per-request bounce buffer fixes the remaining tail latency, as was
measured by Bo Zhang [2]:

                 baseline   patched   patched w/ kmalloc bounce
  read contended 24,749     ~1,959    0
  shared         0%         76.7%     100%

A quick synthetic fio test for Reader vs Reader inversion on 24 CPUs
(lz4, 48 low priority (nice 19) readers, 24 normal priority CPU hogs
 and 24 high priority readers), average of 3 runs:

  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        1,452k             1,466k        (+1.0%)
  Read clat avg    3.46 us            3.30 us       (-4.9%)
  Read clat stdev  165.37 us          15.69 us      (-10.5x)
  Read clat max    306,679 us         7,060 us      (-43.4x)

An alternative approach is to vm_map_ram() scattered objects
(two pages), which fixes the tail latency in the same way,
but deferred TLB flushes add more cost, so it was rejected.

[1] https://lore.kernel.org/linux-kernel/20261014153603.1365617-1-zhangbo56@xiaomi.com
[2] https://lore.kernel.org/linux-kernel/20261015112440.1491168-1-zhangbo56@xiaomi.com
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zcomp.c    | 47 +++++++++++++++++++++++++----------
 drivers/block/zram/zcomp.h    |  2 +-
 drivers/block/zram/zram_drv.c |  2 +-
 3 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index da122bf4dd15..4fda13aac896 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -176,14 +176,13 @@ void zcomp_cstrm_put(struct zcomp_cstrm *zstrm)
 	mutex_unlock(&zstrm->lock);
 }
 
-bool zcomp_shared_decomp(struct zcomp *comp, struct scatterlist *sg)
+bool zcomp_shared_decomp(struct zcomp *comp)
 {
 	/*
 	 * Shared decompression is only safe when the backend has no
-	 * mutable per-stream decompression context and the object is
-	 * contained within a single page (no ->local_copy bounce needed).
+	 * mutable per-stream decompression context.
 	 */
-	return !comp->ops->create_dctx && sg_is_last(sg);
+	return !comp->ops->create_dctx;
 }
 
 struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp,
@@ -239,6 +238,15 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_cstrm *zstrm,
 	return ret;
 }
 
+static int zcomp_decompress_buf(struct zcomp *comp, struct zcomp_dstrm *zstrm,
+				struct scatterlist *sg, void *buf,
+				struct zcomp_req *req)
+{
+	sg_copy_to_buffer(sg, 2, buf, req->src_len);
+	req->src = buf;
+	return comp->ops->decompress(comp->params, &zstrm->ctx, req);
+}
+
 int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
 		     struct scatterlist *sg, unsigned int src_len, void *dst)
 {
@@ -247,27 +255,40 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
 		.src_len = src_len,
 		.dst_len = PAGE_SIZE,
 	};
-	void *src = NULL;
+	void *src;
 	int ret;
 
 	might_sleep();
 	lockdep_assert_held(&zstrm->lock);
-	if (!zcomp_shared_decomp(comp, sg))
+	if (!zcomp_shared_decomp(comp))
 		lockdep_assert_held(&zstrm->excl_lock);
 
 	if (sg_is_last(sg)) {
 		/* the object is contained within one page, read it in-place */
 		src = kmap_local_page(sg_page(sg));
 		req.src = src + sg->offset;
-	} else {
-		/* the object spans two pages, linearize it into local copy */
-		sg_copy_to_buffer(sg, 2, zstrm->local_copy, src_len);
-		req.src = zstrm->local_copy;
+		ret = comp->ops->decompress(comp->params, &zstrm->ctx, &req);
+		kunmap_local(src);
+		return ret;
 	}
 
-	ret = comp->ops->decompress(comp->params, &zstrm->ctx, &req);
-	if (src)
-		kunmap_local(src);
+	/* exclusive mode already holds ->excl_lock */
+	if (!zcomp_shared_decomp(comp))
+		return zcomp_decompress_buf(comp, zstrm, sg, zstrm->local_copy,
+					    &req);
+
+	/* shared mode: try a per-request bounce buffer first */
+	src = kmalloc(src_len, GFP_NOWAIT | __GFP_NOWARN);
+	if (src) {
+		ret = zcomp_decompress_buf(comp, zstrm, sg, src, &req);
+		kfree(src);
+		return ret;
+	}
+
+	/* fall back to ->local_copy serialized by ->excl_lock */
+	mutex_lock(&zstrm->excl_lock);
+	ret = zcomp_decompress_buf(comp, zstrm, sg, zstrm->local_copy, &req);
+	mutex_unlock(&zstrm->excl_lock);
 	return ret;
 }
 
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index bf41b27958c4..362a6da014aa 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -112,7 +112,7 @@ void zcomp_destroy(struct zcomp *comp);
 struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp);
 void zcomp_cstrm_put(struct zcomp_cstrm *zstrm);
 
-bool zcomp_shared_decomp(struct zcomp *comp, struct scatterlist *sg);
+bool zcomp_shared_decomp(struct zcomp *comp);
 struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp,
 				    enum zcomp_dstrm_mode mode);
 void zcomp_dstrm_put(struct zcomp_dstrm *zstrm, enum zcomp_dstrm_mode mode);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a34859ff0461..b429c52cb37d 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2128,7 +2128,7 @@ static int read_compressed_page(struct zram *zram, struct page *page,
 	prio = get_slot_comp_priority(zram, index);
 
 	zs_obj_read_sg_begin(zram->mem_pool, handle, sg, size);
-	if (zcomp_shared_decomp(zram->comps[prio], sg))
+	if (zcomp_shared_decomp(zram->comps[prio]))
 		mode = ZCOMP_DSTRM_SHARED;
 
 	zstrm = zcomp_dstrm_get(zram->comps[prio], mode);
-- 
2.56.0.176.g3575e65682-goog


