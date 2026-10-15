Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2938CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 11:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68536B0098; Thu, 15 Oct 2026 07:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3FA46B0099; Thu, 15 Oct 2026 07:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58A26B009B; Thu, 15 Oct 2026 07:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3AB6B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:24:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1751C4095E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:24:51 +0000 (UTC)
X-FDA: 85324628382.30.65DB93E
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3C581160005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:24:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ndDbxgOD;
	spf=pass (imf08.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792063489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mTGaRSiOlFT8MfguHaHZjIElUHA1XvWJ2csa7S+idE8=;
	b=jYIZ4YZF3xUct5IMBySMppNf0HJ/sBgB/TPCQFJF9oqUoEXXyKyDMLbMmom1WAwz3Y27pT
	kvn0PUwXzgfJcSWTwHlzfHqDRy7EywjmpqEyU8eESP8zvw/8P6TRjL8JPc/Tq60ipGBgUB
	ELn2btJKhyn1eX9Wayhgf+kjHrO/yvs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ndDbxgOD;
	spf=pass (imf08.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792063489;
	b=kS0lGwpQwMxnECj4MAl+7CmWhaQ9+XI0bRo85CATZrshmPZY9I8YkQj3ViAAZYmjsgCSTb
	C15Cds7juWq2TzGM85W9u0PUztz00zMmOGs3n2QCSt+tSnpmu0iwxDEm7dBOLgZDh/HIhs
	7bgzraPQt2rvitU4X0fDYFPOdC9Uwp4=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-3514b90bb89so3289223eec.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792063488; x=1792668288; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mTGaRSiOlFT8MfguHaHZjIElUHA1XvWJ2csa7S+idE8=;
        b=ndDbxgODJiD0cUwNKks7JgvcpOjjnSIqVWnXXBNHChq4MpsB6XUYPrDGNghb3iBT2E
         5qeKKdlG5PA0CCB73JCI3k6eodvMANsnFtYierWZjcn5Dyv9a/WOGpQJ57lJn+UI0wWn
         XdU/QWOuTLO1pcznp5squYfs6a0e+nlJOSrRx81+dWrmRFuaZ7GQesp461a85Lz97WKA
         nUZGm3p1RzyVNgl7t89L3R4GhW3siWu3pLbbA1NQWoi5HLUHg4JeO+8HqtcPbXj3RKBh
         s8ruUABXFYYc9yK35eTvgGV1/NqHORgmbT5VVr43AsJrtIXFkAoPfNC36joKm71LvJtc
         gHgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792063488; x=1792668288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mTGaRSiOlFT8MfguHaHZjIElUHA1XvWJ2csa7S+idE8=;
        b=L744Ot98Z0BiOUif4MA+6Yf04ZizuT9U9I3hp1B5Z2lkbV25ZV85LUReLO0EWznnzv
         3kboebI2q3iBU4i1iWC9uQjLCF4TdHXOs84uHDMZ5ZgAd9wxK3RczSaXFQZrn9TrPZEP
         CYOHb8OS715tS3SNuce4OR5dR0MN6+z4bjcPJycQsLF2cOdCTuX/huf9eCNXsxYEOrQI
         U634SAS1zocHQ8xv28des7SpbIMAFOiB7uXmWQv/hlFYoeORL9r51uE17XEu364HddUP
         W4x0sp04Wrzp5RW5uOr3zv7UwxeQiLHU9LZPT8U1yRC+LvL3GmmaK8F5ak26EIX1Rocl
         1F5A==
X-Forwarded-Encrypted: i=1; AKwUvBwmJrUf+mY2QAD090bytiPAn9dmI+1v/M3g8XmJmsqr2aP81bVCoim07Lfqw49ogm4Q9jlwMOxxMw==@kvack.org
X-Gm-Message-State: AFq9FYItC8kmDmLEwnzuxCTagcDP1oHy636Kw2UJHzcszkLgrNE8qBSp
	/ZZ6l7NGJOiZ/lPNmgclvcKGVnFMbY18TOzJXiZVsqZaZAB1mO7a/aw1
X-Gm-Gg: AYBFou1f9T9Qq2FqnFi8EyfR4Cw34JdoaPzOxrlCVU0LWqYjON3yECJIcDiCZOreKy/
	7mRIDBPdajPyxVX/WuZkZa5EkTsBYdl0Bnk4P14OFPZRGtWEuXvh1X+btUf1QlzK1P02BDukCkl
	e09q7LyeKCMivN2+55ITKRb+5YHE7HwnwkX1GaAdPKNA3WdCc2R2JCKQCpU1C6Rva81473cRArs
	05690T84RlkXbwGXqk784/fLLYAxwfi/koFJwnqJxpJ6TtQ3J3ZMKPnpArUIywScxIPcABRr9pw
	wGkGnWHQQDe20kXCTpJDbwijkW1bCxicUIj4hgLRYlZrAsR3rJyfeCRkmsR0Kw6KRTERqZZjWrN
	sobFURlgoREa3Y0X46lehhdQWaALjVI0mErECh71I2YanMTSu53510AzEkjMiNE6YQ9kWXdJuKG
	WJBtcQIwS43viyrymk1RjRv1dtar016Vq1puT7pk4QuXKGbtLYrlErlDHiAnqmDINpVgE8hNRZE
	tjRYVXexY5+BNZS
X-Received: by 2002:a05:693c:88c6:20b0:359:89b9:5e09 with SMTP id 5a478bee46e88-35989b98cabmr19639355eec.36.1792063487634;
        Thu, 15 Oct 2026 04:24:47 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cb6a279sm60818382eec.30.2026.10.15.04.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 04:24:47 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	bgeffon@google.com,
	minchan@kernel.org,
	richardycc@google.com,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 10/11] zram: use rw_semaphore for decompression streams
Date: Thu, 15 Oct 2026 19:24:40 +0800
Message-Id: <20261015112440.1491168-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <atBh9xfpOji_A7A_@google.com>
References: <atBh9xfpOji_A7A_@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3C581160005
X-Rspam-User: 
X-Stat-Signature: cj9thn3jpinm9ugkoa38er8tyn1oek4u
X-HE-Tag: 1792063489-774912
X-HE-Meta: U2FsdGVkX1+7ZYA6wFwgWhAlJuYpElxtBkUo1/H+yBoUEE7NEorpDssOGWaJLiOcB22Vb2L3sqdpO+Fw6WrcT7GCiO2yRDnwA+pQ9SXqjgEuhtYc1nP5OefubsE2AZwG1G2z88ucQ+VVRCH63Y8vMWACbWDDPxYKDsUVsiiNSVmP4Ojrwb4I2t85EWcBrbmnh8EnRTHlI7jjbIIVidVDJ+8l0zE7uwjm1eOOdE8C+XC3IhPJ9vdMe32D2yRsuuaMyZBwk4Rktrut8G/9/C4+lCZ+I3N8Zp/qWxah1nIYodDqcj18d9E3N2lo+SFNLh/v2AhPnKApY00R7HZrcB788E8fyAhJ6BL/HR+t9GmQyIf6ETJFsQ3LI1GywTKoadiSc3VeiMlYGfPzmPekatqEoAOstz/7Y23ygThfwFjrZmJQsridA68fqDIbK00iAHSJbgX1xJ6bLTYE1bl2VBQoMzTx53vcNQ4YOVeL+WuLFDTeOmdkw7a0eO8AwXxA6SpJ195VtBW2kzeZEUNrgwvd4Xf+FXAVYauarfUNB4QGvBBv+QnKaDOzFRC/eXXwJJn2PKYMKo5fOv5+EWzf7kTEw9B4k0WZe/VVPbJ8wUBrbwjNA4hTcIcsR+lYj+f6mwq4andQ7lx8sSO24mvbW3LRHvHtQdVB2GeF/0ea+fV1MHWf1Zzjubdu0jxgeHqlal0w7U7H/s+NiZgNBQG+YgZdPCPQQySQtcsNyg78j+W6V9333WHpXHe5AbsWYtbXumbTJlkLvSDfa/5VVyLeqbwP0nofAo7rhemd2TEpXTRq1uE+kHsB/Qq5o2CZeHuCsvZgAWUfLE8EKMrwyqSoJglB4JFilW8pJeDRd/THyI3Bs50dxwFzojWJgveCBwBnvKnZwU4ABU7lI7qbZmmgy7+6qdQXXm18yILkL5szOxSVi9Zqb/M4j2ODh36llM6h7L1M0y5XPlxV3Ha72ZW00qs
 PVmeIKVa
 nAFRAP666VxMZITZR8OXBe3d/cCssg0f4e3Rpr++IdEF3m66oiiGrLYa+Ua5/fRrMY2KfbFCDJErQ6pkIqU5mPt26DlGEIIdxbmSUc/uYaQ6oSYkX5utia/dYJCbNlnp7oVVD8stgpIjePsa/UqNJospkKoZ0UTvd8lrY6rm/vQqlgvs0i71MYS7fmBhaGy2QuZMOjxCwf0N0XpEH5ojOjbmTQ5AKqXbFe6ucwQqSTra1isKlzznaZhr8xj27ZaJH545lfWJ3iFt0aZhJfqq5DBf+f+vdD3qraSfekPmQ9xYrT2+HCTOI/oRLWuqxZbWEOLfUku++acK2vf8V2AnFWYb5SPXEvjZJTvtfSblJ/Hee1cxsMS803f1YM3AvyCSgtowBxx+wI4IzLJjMyQV1E9paPKMgBwbwuwuu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 12:19:49 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> Or perhaps we can avoid vm_map/unmap.  A slightly different approach.
> kmalloc on fast path + memcpy (zsmalloc objects are strictly less than
> PAGE_SIZE bytes)

I applied the kmalloc+memcpy variant on-device and re-ran the same
Android A/B. It removes the exclusive path entirely in our workload.

                      9+10       9+10 + kmalloc fastpath
  read contended      ~1,959     0
  read wait_ns total  ~12 s      0
  read wait_ns max    72-96 ms   0
  shared              76.7%      100%
  exclusive           23.3%      0%
  dpin_contended      0          0

Every decompression now takes the shared (down_read) path, including the
cross-page objects that previously had to go exclusive. The ~1,959
residual contentions on the exclusive path are gone, and pin contention
stays at zero, so the full read side runs concurrently with no stream
contention.

Read-side contention end to end:

                 baseline   9+10      9+10 + kmalloc
  read contended 24,749     ~1,959    0
  shared         0%         76.7%     100%

This is a stateless-backend result (lzo-rle). zstd/deflate have
create_dctx and stay exclusive, so they don't benefit from shared reads
at all - which, as you noted, is the sad part about zstd on that list.

For those backends the serialization is unavoidable, but the actual
root cause of the long waits is still the holder being preempted or
migrated while holding the stream. So on top of 9+10+kmalloc I tried
a quick-and-dirty preempt-disable for synchronous backends. Allocation
can no longer sleep under the stream, so a two-stage zram_zs_malloc()
does a non-sleeping attempt first and, on failure, bounces into a kmalloc()
buffer, drops the stream and retries with a sleeping GFP_NOIO.

zstd backend, same A/B workload, on top of 9+10+kmalloc:

                       9+10+kmalloc   + preempt-disable
  cwrite_contended     14,880         48          (-99.7%)
  cwrite_wait_ns_total 137 s          0.32 s      (-99.8%)
  cwrite_wait_ns_max   243 ms         43 ms       (-82%)
  dexcl_contended      15,919         54          (-99.7%)
  dexcl_wait_ns_total  109.6 s        0.68 s      (-99.4%)
  dexcl_wait_ns_max    145 ms         34.6 ms     (-76%)

zstd stays 100% exclusive either way; the win comes purely from the
holder no longer being preempted/migrated, so the hold time stays short.
It's the same mechanism that took lzo-rle read contention from 24,749 to
406 earlier. So the two are complementary: shared reads remove
reader-vs-reader queuing for stateless backends, and preempt-disable
covers the exclusive/write serialization that stateful backends can't
avoid.

Quick and dirty, for discussion only - Patch below.

---
 drivers/block/zram/zcomp.c    | 17 +++++++++++---
 drivers/block/zram/zram_drv.c | 52 ++++++++++++++++++++++++++++++-------------
 2 files changed, 51 insertions(+), 18 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index bb2a8101445a..5c31bd58c616 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -165,8 +165,11 @@ struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp)
 		 * so then unlock and re-try on the current CPU.
 		 */
 		mutex_lock(&zstrm->lock);
-		if (zstrm->buffer)
+		if (zstrm->buffer) {
+			if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+				preempt_disable();
 			return zstrm;
+		}
 		mutex_unlock(&zstrm->lock);
 	}
 }
@@ -174,6 +177,8 @@ struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp)
 void zcomp_cstrm_put(struct zcomp_cstrm *zstrm)
 {
 	mutex_unlock(&zstrm->lock);
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
 }
 
 bool zcomp_shared_decomp(struct zcomp *comp)
@@ -207,16 +212,22 @@ struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp,
 		 * Exclusive requests additionally own ->local_copy and
 		 * ->ctx and hence can only wait for each other.
 		 */
-		if (mode == ZCOMP_DSTRM_EXCLUSIVE)
+		if (mode == ZCOMP_DSTRM_EXCLUSIVE) {
 			mutex_lock(&zstrm->excl_lock);
+			if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+				preempt_disable();
+		}
 		return zstrm;
 	}
 }
 
 void zcomp_dstrm_put(struct zcomp_dstrm *zstrm, enum zcomp_dstrm_mode mode)
 {
-	if (mode == ZCOMP_DSTRM_EXCLUSIVE)
+	if (mode == ZCOMP_DSTRM_EXCLUSIVE) {
 		mutex_unlock(&zstrm->excl_lock);
+		if (!IS_ENABLED(CONFIG_PREEMPT_RT))
+			preempt_enable();
+	}
 	up_read(&zstrm->lock);
 }
 
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index b429c52cb37d..079796b17bde 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2297,13 +2297,37 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	return 0;
 }
 
+static unsigned long zram_zs_malloc(struct zram *zram, struct zcomp_cstrm *zstrm,
+				    size_t comp_len, const int nid, void **bounce)
+{
+	unsigned long handle;
+
+	handle = zs_malloc(zram->mem_pool, comp_len,
+			__GFP_KSWAPD_RECLAIM | __GFP_NOWARN |
+			__GFP_HIGHMEM | __GFP_MOVABLE, nid);
+	if (!IS_ERR_VALUE(handle))
+		return handle;
+
+	*bounce = kmalloc(comp_len, GFP_ATOMIC);
+	if (!*bounce)
+		return (unsigned long)ERR_PTR(-ENOMEM);
+	memcpy(*bounce, zstrm->buffer, comp_len);
+
+	/* Drop the stream (re-enables preemption) before a sleeping alloc. */
+	zcomp_cstrm_put(zstrm);
+	handle = zs_malloc(zram->mem_pool, comp_len,
+			GFP_NOIO | __GFP_NOWARN |
+			__GFP_HIGHMEM | __GFP_MOVABLE, nid);
+	return handle;
+}
+
 static int zram_write_page(struct zram *zram, struct page *page,
 			   unsigned long index)
 {
 	int ret = 0;
 	unsigned long handle;
 	unsigned int comp_len;
-	void *mem;
+	void *mem, *bounce = NULL;
 	struct zcomp_cstrm *zstrm;
 	unsigned long element;
 	bool same_filled;
@@ -2331,22 +2355,20 @@ static int zram_write_page(struct zram *zram, struct page *page,
 		return write_incompressible_page(zram, page, index);
 	}
 
-	handle = zs_malloc(zram->mem_pool, comp_len,
-			   GFP_NOIO | __GFP_NOWARN |
-			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+	handle = zram_zs_malloc(zram, zstrm, comp_len, page_to_nid(page), &bounce);
 	if (IS_ERR_VALUE(handle)) {
-		zcomp_cstrm_put(zstrm);
+		bounce ? kfree(bounce) : zcomp_cstrm_put(zstrm);
 		return PTR_ERR((void *)handle);
 	}
 
 	if (!zram_can_store_page(zram)) {
-		zcomp_cstrm_put(zstrm);
+		bounce ? kfree(bounce) : zcomp_cstrm_put(zstrm);
 		zs_free(zram->mem_pool, handle);
 		return -ENOMEM;
 	}
 
-	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
-	zcomp_cstrm_put(zstrm);
+	zs_obj_write(zram->mem_pool, handle, bounce ? bounce : zstrm->buffer, comp_len);
+	bounce ? kfree(bounce) : zcomp_cstrm_put(zstrm);
 
 	slot_lock(zram, index);
 	slot_free(zram, index);
@@ -2463,6 +2485,7 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 	unsigned int class_index_old;
 	unsigned int class_index_new;
 	void *src;
+	void *bounce = NULL;
 	int ret = 0;
 
 	handle_old = get_slot_handle(zram, index);
@@ -2535,17 +2558,16 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 	 * modify zsmalloc API to return this information. For now, we will
 	 * make do with the node of the page allocated for recompression.
 	 */
-	handle_new = zs_malloc(zram->mem_pool, comp_len_new,
-			       GFP_NOIO | __GFP_NOWARN |
-			       __GFP_HIGHMEM | __GFP_MOVABLE,
-			       page_to_nid(page));
+	handle_new = zram_zs_malloc(zram, zstrm, comp_len_new,
+				    page_to_nid(page), &bounce);
 	if (IS_ERR_VALUE(handle_new)) {
-		zcomp_cstrm_put(zstrm);
+		bounce ? kfree(bounce) : zcomp_cstrm_put(zstrm);
 		return PTR_ERR((void *)handle_new);
 	}
 
-	zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer, comp_len_new);
-	zcomp_cstrm_put(zstrm);
+	zs_obj_write(zram->mem_pool, handle_new,
+		     bounce ? bounce : zstrm->buffer, comp_len_new);
+	bounce ? kfree(bounce) : zcomp_cstrm_put(zstrm);
 
 	slot_free(zram, index);
 	set_slot_handle(zram, index, handle_new);

Thanks,
Bo

