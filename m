Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 107D5CCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 03:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B76596B00A0; Sat, 17 Oct 2026 23:52:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17B16B00A3; Sat, 17 Oct 2026 23:52:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A7246B00A1; Sat, 17 Oct 2026 23:52:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF146B009E
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:52:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42211C03DF
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:52:20 +0000 (UTC)
X-FDA: 85334374440.25.88DC640
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8766AC0002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:52:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=e3nHsY36;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792295538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uBsgGrwxjk4mKkzegIUyY57FWFNYlpp8ckkkXl62oGc=;
	b=xbx/wGqIjXCfnTnpOcHeoTqI+5P5bqU9sQ0YTvvWEkD4igGkeE1KWXu0xid63XtmZLCyXQ
	Hd3tIdgzMkzz2xxMCKvCCVWe6Ab4b/c6/7JWclGG3JcVBtMgep7xINIocjniQ1htsLyHoM
	59nWQdsoRlqxZamCWVAJUNnfNRv+Eso=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=e3nHsY36;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792295538;
	b=8SjSGFpuQnl4u42Fhb6XhvuRfKkaR04CVWBFow9R/sitsthJVtTZvoLO5locRm7tSOQLAF
	NHrQ2Oa3pCq9wcqzALliqfG8aQXm9na5Csjubof1W+v9VMFnQzGyCFIrr7GMss7JLwXiJ9
	csMipmPrAtvl535rWi51TlZ1eyAA9Lg=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e8246b13cbso8273215ad.2
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792295537; x=1792900337; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uBsgGrwxjk4mKkzegIUyY57FWFNYlpp8ckkkXl62oGc=;
        b=e3nHsY36FxyUI8TUUMSxmj7Hmc4Li50UHVN23BlfZIQyx750ABJeQKc/R6HJBnC96c
         ZEiduQO4Hl1/VSAz3MW5csiokPj/weVXh9g+T1ul4NhkUeF2lWuY6Hn284fyGCOaRZFP
         l8YIkbVELmav1kWVsDr/CVh0Venr8A/6o2Xqw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792295537; x=1792900337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uBsgGrwxjk4mKkzegIUyY57FWFNYlpp8ckkkXl62oGc=;
        b=c2xIAnYTyY9InOGd/qfTUXb0NcQYAh1W+D8mrkbkSMWeuUaYY9icHJPzTNGYwFqR0s
         Ijj0IYUKxWq2Z2IG10JZ0faxtM4WyUHqvDloELHVnQABwOHVEh/DrUAgmR/+MdnJ8bf6
         pDC048XCcdm1ufkZE/Dvr5slsiE93d/+/jaSkk4wXqayROxcn6JMAxe/5zIzNiZCu3Ui
         YamT0xtM0Ei25uiXt6K8DkzLCLkNwa4bb1igDNXGdCO/jdUXSd500piL3hV+Llf1y04/
         zWwN1n9RR9OMaHW5x2r/NvAvroiUhta0gii/31f6R4f5vYcJZpWwGClYxpOIcKQFJkbL
         jgQA==
X-Forwarded-Encrypted: i=1; AKwUvBzSbpzYgRWJH4xK44tGtS4BKNV3Oy8HQSE9KSZWU8zMdEkmkRRKOW975tyz7kJ16t9r7JH2I0tHkA==@kvack.org
X-Gm-Message-State: AFq9FYJGQuEVLJ3N97U7tLdCBI6JHni9KUMaqHKf0PPa7WGQty6Uh7bW
	OteUmkKNLcyBiL7ugjTffiKHI9AZluV6qUfv7qf7oYCkPIV5qUN22N1IvwnRDdEcog==
X-Gm-Gg: AYBFou08AZawNOT/h88nVQc+0jyklRr/3qyB/bgczugxZRwsjTCioB9lfbPkRMZ3Y2+
	D+1BtqCeTEu1XIPeXSa3Iu59CVBp+DfOAl1v0cek4G4N0iVHqgZEwrLZgwmpspmzMY/DiKTCC4e
	PyVKiohpCdYRcBWiendJSJnF/fWcefdk6Gw6MoJhxMgNNvzKdINlEHTzPpBIklYlODL8+d8l6HX
	6eOsiKRCE5GkzN9sGqXoWy3twhs7FfkqUW9+KYogUm/nppoXkLFfP4RYDWHTZINSusWE+WoBC5F
	bQu5V04kS8igR6wCbaeeF1oOQPQdqveCwfa0fTzuldJD+oNJ4bbfch6TA63m2gRGMGVZrb3+KQs
	/gzY2c1KOTHiZJIvsRCAk4+elf7+72mvvFag2PKl3aCmO7lyA9q47z9be4/yL/GhCfhtVqLbF1O
	y5tQ5LBx5jgec4RS3sYMdN6v3vl9fcaNVpssB2R7plCaVqMPEYmJoN1m/PhQuorq18m7VQh/ygq
	uMjJbDKAIedRVTInu/A+VNq5M1RCliJKtdt2psn5VKAC8JMkHWamGCi16rWUNkWgpXBF7IFyeI6
	c8UM8E02nCQb4QWmxmFKYm044vmlXLxaq8tQhdDsV2yKghm7rv0roG3JUGdsBF+A8w==
X-Received: by 2002:a17:90b:5112:b0:3ac:450a:f9d4 with SMTP id 98e67ed59e1d1-3acef1544fdmr3929944a91.64.1792295536643;
        Sat, 17 Oct 2026 20:52:16 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:4569:b311:f3ea:5f8d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad25d5d1b4sm253024a91.16.2026.10.17.20.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 20:52:16 -0700 (PDT)
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
Subject: [PATCH v5 11/13] zram: allocate bounce buffer for spanning objects
Date: Sun, 18 Oct 2026 12:51:13 +0900
Message-ID: <20261018035125.3120704-12-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261018035125.3120704-1-senozhatsky@chromium.org>
References: <20261018035125.3120704-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gxmyzdn8qidjzzkdhm8jtu9ei9abgp98
X-Rspamd-Queue-Id: 8766AC0002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792295538-990838
X-HE-Meta: U2FsdGVkX19TMl5rpdttjKq30QJRqHOyqpjvgk50jBLXEzqjAy/L60wZzuyRcHiz+5+781emCaD4VErcc+1Me3cz1gY0hG6qHgM+7C5o4P0yV3G2Pxab7bsRey+Yw9lViQF5t/Er4/GGJoxM4vB7/mfOvr7XSMBy7k2BLJpYPScj1zMIII5AkXaA0Ir5AryGN/B1FQdiEW2MoZOTfSzd0Rt8Q4cK/jFQQ1EVxFhiXHLZb1iA3QwnxrENnf5rhdxcnNq2szoql1kFlVw/R7KrgYguYYg/Yez7dD3I7ohs3jhy1rKG6u7TUoX3WwQRXb/6E0Qr+x0g+FZT/T1xOw19AYv4QcMxt8PHHGixBtHBsneSRXbheaKux6grM3zqS1tvWgpuxTaNnO1vTiUbZnZn7CKqGJBvWh5lPUquKpD33Gv8yzYi4+bO2LAYhupcu6tja5caMbOL2G+wH11WNUvR/LiBQrN+9Guh1M28TpTcIRxiBA0T72piuE5+PudXnhfeT4yDRyPOQE3Flh9duwXZdAHa5C4+jVuL8U03E0vjpyIaRuQ4OtX8RTsbgYoNE9zRC2d2WlG5UCf69E+VylWCI+HBir9TCqYSUSRcLRALs/c0lpTmQMYS0HXOgxdO3UoCwV1T98h7xCpMn9abIVx2lLJ1NMxdwPicsRLrgQbbcbfdL/nrjs3ioohGWyJIXF8N0JSosSjHqsFis2NtXnPh/6vsLGuh1CuZSY1eqzmRqMaDayT7jV6sWjkYIgsf1KqTy/91m10D5mc7MA036C5xHBXSpr+00KqV8Cv8gVA6yv2M2P2uxzf72Dif2rGN2toe76nvoqz1zhK9pu6NNJEDalTzJ0TdDVg0zBSn7sG0pdxY4CjUfseauucZ7znQQMxrGM0cgkzt2IIEm6WLh9uMfRtMokBiWbY1mYs6C2yBzL37+MNDxDt7s2kF2UxZGW7dgj2yBjPw5jHSjgoFPvY
 9uQ1CMBh
 V0wx9HrRXv3prUTKtXpxDP2U9CG3SBecc0YBLrJOvKKRMd8odeBZcf0UFKqeuGfBAetP3EyZObB26+6oDEDx6M4wV360/aOGAdtH+62pA359U0+g0sO2qytxTF8/rU2oetGF9ccnRnd27mM9EK16c9cZJalw2dqvyZ0xQLTVmYy28RhiWuWi6q+svCRz4mugQxWfTaIgWnbvnj6gq+y4Q/X5ttG78lnrlPKIiZumZSGvM+aan1EmytQOGyVj3vZWk0MLCn2NdYWWpo4E0VDEZcStw1tbF1U3xhiOlWKY6+v1V6K8EtsRq86LfyXEgSChpEb0iSMMiDlpC2oTCy+HajC1tfUHb1+7skjuW
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
decompression.  And spanning objects are not rare: Bo Zhang measured
23.3% of reads on lzo-rle going through the exclusive path, causing
contention on ->excl_lock of up to 72-96 ms [1].

Allocate a temporary bounce buffer for spanning objects instead, so
that backends with stateless decompression can always use shared mode.
If the allocation fails we fall back to ->local_copy under ->excl_lock.

Per-request bounce buffer fixes the remaining tail latency, as was
measured by Bo Zhang [2]:

  Metric          Base      kmalloc bounce
  ----------------------------------------
  read contended  ~1,959    0
  shared          76.7%     100%

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


