Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBCD2CCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 03:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59B826B00A1; Sat, 17 Oct 2026 23:52:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54B836B00A2; Sat, 17 Oct 2026 23:52:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC836B00A3; Sat, 17 Oct 2026 23:52:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED7056B00A1
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:52:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5FF1AA0412
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:52:23 +0000 (UTC)
X-FDA: 85334374566.01.7C39CE5
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 93E78140006
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:52:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Kpapf9cS;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.41 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792295541;
	b=N9yy10ovjT3GsXigleAPccrSVOHB6CH2sxmdX1N1avt+RfPYYXHzakZ3uXBF5JC6t8DpH2
	QT4XAPWzMrnKL3ZsHvxANxbXtuo/JdtKXoWkIRcNL7MAkinap3KchHItWrcFbRQ5yMyfwg
	G0BBqzujRUU3pGUPmZMjihQlC0RiKng=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Kpapf9cS;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.41 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792295541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ms0vFHNtZ2MX59YDGljIlqxn+FYjKSeTHfEf/QNa6k=;
	b=T8IwamrhYplMhgFdbVtKgzPQvMKYkk/5HPrxx+iQA4ZulVMaGWYasI4ygtvKgMYwphoRB5
	tA4Q+3mQFX8eo6aYwT4l2g0onmlMzDT2CUGGF77zWYihlE4b+fwCnv6aCB5ixMtCCDiXVY
	4NRDNjiodfMh6brg4R/begXt0jQjB4U=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-398a4dcf289so585327a91.2
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792295540; x=1792900340; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7ms0vFHNtZ2MX59YDGljIlqxn+FYjKSeTHfEf/QNa6k=;
        b=Kpapf9cSgiwmI1VFExfnMDnZzx7zjy6CIA8BhY6GvQNwjEKVXxib4sDLIsgAt7daa8
         lRuPy/s11pHB+G6CKfc8owLD1B9+3MOQX1bZ4R6eUtXMWewiZWzEiXcKqC/NZ/CeSXDJ
         57NOm689fbxTGti8vqd6YtOdoLLSTFqr5ovTA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792295540; x=1792900340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7ms0vFHNtZ2MX59YDGljIlqxn+FYjKSeTHfEf/QNa6k=;
        b=R0mRdOcpeFF8MbbTCnBfQBEqW0D8JDyJ/CKVwgHyw9XiIG9MwRVfZcDwxzE6NO7cXb
         /OekN1CCftMjwgq7kagowO00gh+cevrdt0YGAS2x01n1thOwW4rAku+t0r30ei0nexez
         jgxDa+JWYWdt2gVaan7nqDq7d3GM74w5WKcaqc5PTx0dzOVZBHHx/awTmoDoldCwconS
         +9pSXBJAYMSK+YK5KzaG62FtrCWmDVVw+/05c6761vFkUXNECv1+UHy0eC36EXQYmIXs
         eCCYThCRuFPg+2DsQBs0mYwwQ1O1fujAItxze+9tNXwFJfdi+zHOAFBXD2rGHDBC1X8I
         xmIA==
X-Forwarded-Encrypted: i=1; AKwUvBwIcZwXgeJoRXo/k7Lyo6Yxw/xwhmqMDrWv8cL94nf5LkdLrzr98RLpxG2VYlcwH6QDmllF8BCL6A==@kvack.org
X-Gm-Message-State: AFq9FYIf8189uavxIoSHvMMHISUaq8SGUZm7i/zLB/JpKf5QMt9xUHQX
	/sB2nVfQTkQShoOwL8ZoCBYKrDCVPjZMWxt8lLT1rNNWTAlvpl6+82OpkhWd4veJ9g==
X-Gm-Gg: AYBFou3W/oj4EfdFC6vjNqMFw9ACdZ4Jotj6GwKO4nGGZU9oFdEgh+4c0f49fKBWSFr
	bg0jUm1VjwxpaaytwFeKkZZ3g+Xo7icQxKvoTuR5joeZqE+lz/3yw+cHi38bQhgBHFhMXPIQSdH
	VmNeiIYZ3O6AciNY7i0U8Qw7XppqP4Uw3TciGzCbCb5ziK9i8u0iDdBLYeNIfiisLUAJoqbEPu+
	J8x911aokUmDiKma3CdAqKTDEXYBI0vtdpEcN7pwqcl5+RAbpO0wpgCHQG86LPtY0/JAm3cyP9A
	LbUJBy+xsXPmZrNv0zCIbUV9FdW2JXym1Erotwsx9VCWrYIqOeC0nRBgohFyR9sjRiXEM3SHPT5
	yYeYQ+VCGmTDABqRnZ14zEWes4gUzDX6DCdQLjZ39DoqSuyVrg/EV1K+Oxvoi5X1RBB7ou4Cvml
	HBZdh+1Vf3+Wm+mGkwCkyk/6pbeQLdy5Y32byLd2vJxDjvx8vpV5zeDSUvsxbuffvMm7tfofcO8
	OD4WGRFRS8DlHXzeTOUHSDWfc9aD8/XuK54PFAz7a40vqQB7xJu5wIyFigMSM8R3wEEqBtF9VAb
	ucV6VX6kFbaRnKCJ3tQH3ozJVk7PjhJKY/uZ/KV4xX+N
X-Received: by 2002:a17:90b:390f:b0:3a4:967c:6947 with SMTP id 98e67ed59e1d1-3aceec24c11mr3420976a91.21.1792295540531;
        Sat, 17 Oct 2026 20:52:20 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:4569:b311:f3ea:5f8d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad25d5d1b4sm253024a91.16.2026.10.17.20.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 20:52:19 -0700 (PDT)
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
Subject: [PATCH v5 12/13] zram: borrow idle decompression streams in exclusive mode
Date: Sun, 18 Oct 2026 12:51:14 +0900
Message-ID: <20261018035125.3120704-13-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261018035125.3120704-1-senozhatsky@chromium.org>
References: <20261018035125.3120704-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 93E78140006
X-Stat-Signature: jmyg3pzk548kj34fjpz8o8f9c9bgubc1
X-HE-Tag: 1792295541-628888
X-HE-Meta: U2FsdGVkX18w1I+riCevugKy4vZj+gUUZtQzC5AVJ04bakkesXZa3cuy7JHmwynKIfTzqOzjCLWoosxnmLTz5BBW7dYlMXiE2XzjNEyfGMpWPKirqoZv+fR3YLeexdrG2PJt/PTn/dl0dCTwY6KEmmqlScpsZLIC7yzBjDi5WK6ua3OvZ8t5gtWnDLrpAlRnGEy+/LxgCoUuunlA0/cw+n7LrN6K1iSZbPMvwGJN9a7sGZYyYejkwR1AUirQFU4S4t4y67MPmWZE97iZ7BHxr8P2IHRo6PJF/FyJl6wmQlZnRwPOwa+eHhBwcYjjFxsYkNPtsz+dXcTf9HA79uM9lfjlotEiG9T3rfLs8RSOqtDr3MEGO6UFI0ih7TMeL03PJ0c2edxQseW5lQ9dO+dlxyeKxk1C1+FlxRXkGilkNiec5orKTltgO+Ztr5qMQapEskepaoIoDGPPGHAVlwf5waJEuTpIHPyOG+In5O7vWbQPbx99fkf1WUSIyIlIgpgS8tcgvzFx/H39Y3RPWw6J6NYiMVG2wLQ9wlZeFf2EAZTYDBxo8UAEzXry6sEfRX1iI0FpZx9Md7zzSEnfDW4mSFnkfKc+ZOgZCZmXSKpjV+3foIMxPSM3NW/7azbsCUldErzTD5WVBL/VDvcD4c8rIMbC3lxNMS8hGaqON8bUs4Yl0a0Kan0zbyoAxIwnGH7c+dMASeSFKD+KnV9kNBSxuFC7recNz2ohlGafEPh+y13EhQb51K0NXNfMd6FTO714fM9A+owLX4LKloDpvlSEpnRr7e3cXSxbfYb5F1B2jWs0l9KD4aUNK0vDzC4M3e636H9k0JDyrIzUJgZ1kNoZDsdV5olEa4eC2yx01O7UcT+nsveMfpv4C3st9qSQHURr7nZ63QBZm4MPtmdetCoyu8TLwTL7WSgojhJlwESn8xyASCy6Pu9TEtjACYOy478nrzlyt0cUG3XyX9i1TgY
 kgbOG2A0
 bHaS9NU8zj4W591Q+u+xhBCaOaiGcLNJcDPOrmKlTzHRTPOo2bAArKqHA5K34WhhPJWWMI9fMJBoTyOi2hWeSx+O8OuMhGl6pgeLpvofz03PEt/eK8NPJXbZfTpnry6X+iwJvcBX0jcPjKsOS4tC53kkPfmlB1ldvmGiIV4RgFSeMwgPy+1ZKBp/ksMrObE4yUp8ttFgG5AUddC66HfAql36cd1aP7rMdcocU3GyPlm69y9QXevmkS9hD6v3+5Ehrt/DxhDUYPlcb9VzK2bkD0RP3yltP/N2hxpZ+ODn5dN0BuOzGHWXPJTkUIzd090N8I3y7Ro0IhiLIpsbHMnHCcfnm4j9ViDRon1EmjD8zCM7Il2rI+fo66stQAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shared decompression streams eliminate Reader vs Reader priority
inversion for backends with stateless decompression.  However,
backends with stateful decompression contexts (zstd, deflate)
still require exclusive access to the stream [1].

When a low priority exclusive stream Reader is preempted by a high
priority exclusive Reader, instead of unconditionally blocking on
the local CPU's ->excl_lock, we can scan online CPUs starting from
the current and try to borrow first free stream.  Only when all
online streams are busy, sleep on a per-zcomp waitqueue until any
CPU releases an exclusive stream, which significantly drops
contention and wait time, per Bo Zhang's measurements [2]:

  Metric              Base      cross-CPU borrow
  ----------------------------------------------
  dexcl_contended     15,919    1,447
  dexcl_wait_ns_total 109.6 s   3.66 s
  dexcl_wait_ns_max   145 ms    26.6 ms
  dexcl_avg_wait      6.88 ms   2.53 ms
  dexcl_acquire       2.21M     2.94M

A quick synthetic fio test for Reader vs Reader inversion on 24 CPUs
(preempt=full, zstd, 48 low priority (nice 19) bg readers, 24 normal
priority (nice 0) CPU hogs and 24 high priority (nice -19) fg readers),
fg reader results (average of 3 runs):

  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        396k               1,064k        (+2.7x)
  Read clat avg    48.32 us           9.66 us       (-5.0x)
  Read clat stdev  7,571.00 us        31.92 us      (-237x)
  Read clat p99.99 5,707.10 us        2,233.68 us   (-2.6x)
  Read clat max    3,555,300 us       6,287.57 us   (-565x)

[1] https://lore.kernel.org/linux-kernel/20261015112440.1491168-1-zhangbo56@xiaomi.com
[2] https://lore.kernel.org/linux-kernel/20261016134847.1620103-1-zhangbo0325@gmail.com
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zcomp.c    | 77 +++++++++++++++++++++++++----------
 drivers/block/zram/zcomp.h    |  5 ++-
 drivers/block/zram/zram_drv.c |  4 +-
 3 files changed, 61 insertions(+), 25 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 4fda13aac896..c6d2fd23c6f6 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -185,38 +185,67 @@ bool zcomp_shared_decomp(struct zcomp *comp)
 	return !comp->ops->create_dctx;
 }
 
+static bool zcomp_dstrm_excl_trylock(struct zcomp_dstrm *zstrm)
+{
+	/* Cheap pre-check: don't touch a busy stream's cachelines */
+	if (mutex_is_locked(&zstrm->excl_lock))
+		return false;
+	/*
+	 * Pin the stream.  The write side of ->lock is only taken by
+	 * zcomp_cpu_dead(), which also sets ->local_copy to NULL.
+	 */
+	if (!down_read_trylock(&zstrm->lock))
+		return false;
+	if (zstrm->local_copy && mutex_trylock(&zstrm->excl_lock))
+		return true;
+	up_read(&zstrm->lock);
+	return false;
+}
+
+static struct zcomp_dstrm *zcomp_dstrm_excl_tryget(struct zcomp *comp)
+{
+	struct zcomp_dstrm *zstrm;
+	unsigned int cpu;
+
+	/* Best-effort start CPU hint; migration during the scan is fine */
+	for_each_online_cpu_wrap(cpu, raw_smp_processor_id()) {
+		zstrm = per_cpu_ptr(comp->dstream, cpu);
+		if (zcomp_dstrm_excl_trylock(zstrm))
+			return zstrm;
+	}
+	return NULL;
+}
+
 struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp,
 				    enum zcomp_dstrm_mode mode)
 {
-	for (;;) {
-		struct zcomp_dstrm *zstrm = raw_cpu_ptr(comp->dstream);
-
-		/*
-		 * Pin the stream.  The write side of ->lock is only taken
-		 * by zcomp_cpu_dead(), so this never contends with other
-		 * decompression requests, regardless of their mode.
-		 */
-		down_read(&zstrm->lock);
-		if (!zstrm->local_copy) {
-			/* The stream has been destroyed, re-try */
+	struct zcomp_dstrm *zstrm;
+
+	if (mode == ZCOMP_DSTRM_SHARED) {
+		for (;;) {
+			zstrm = raw_cpu_ptr(comp->dstream);
+			down_read(&zstrm->lock);
+			if (zstrm->local_copy)
+				return zstrm;
 			up_read(&zstrm->lock);
-			continue;
 		}
-
-		/*
-		 * Exclusive requests additionally own ->local_copy and
-		 * ->ctx and hence can only wait for each other.
-		 */
-		if (mode == ZCOMP_DSTRM_EXCLUSIVE)
-			mutex_lock(&zstrm->excl_lock);
-		return zstrm;
 	}
+
+	/* Checks zcomp_dstrm_excl_tryget() before touching the waitq */
+	wait_event(comp->dstrm_waitq, (zstrm = zcomp_dstrm_excl_tryget(comp)));
+	return zstrm;
 }
 
-void zcomp_dstrm_put(struct zcomp_dstrm *zstrm, enum zcomp_dstrm_mode mode)
+void zcomp_dstrm_put(struct zcomp *comp, struct zcomp_dstrm *zstrm,
+		     enum zcomp_dstrm_mode mode)
 {
-	if (mode == ZCOMP_DSTRM_EXCLUSIVE)
+	if (mode == ZCOMP_DSTRM_EXCLUSIVE) {
 		mutex_unlock(&zstrm->excl_lock);
+		up_read(&zstrm->lock);
+		if (wq_has_sleeper(&comp->dstrm_waitq))
+			wake_up(&comp->dstrm_waitq);
+		return;
+	}
 	up_read(&zstrm->lock);
 }
 
@@ -289,6 +318,8 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
 	mutex_lock(&zstrm->excl_lock);
 	ret = zcomp_decompress_buf(comp, zstrm, sg, zstrm->local_copy, &req);
 	mutex_unlock(&zstrm->excl_lock);
+	if (wq_has_sleeper(&comp->dstrm_waitq))
+		wake_up(&comp->dstrm_waitq);
 	return ret;
 }
 
@@ -357,6 +388,8 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 		goto cleanup;
 	}
 
+	init_waitqueue_head(&comp->dstrm_waitq);
+
 	for_each_possible_cpu(cpu) {
 		struct zcomp_dstrm *zstrm = per_cpu_ptr(comp->dstream, cpu);
 
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 362a6da014aa..ca1ebc70ad0a 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -5,6 +5,7 @@
 
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
+#include <linux/wait.h>
 
 struct scatterlist;
 
@@ -96,6 +97,7 @@ struct zcomp_ops {
 struct zcomp {
 	struct zcomp_cstrm __percpu *cstream;
 	struct zcomp_dstrm __percpu *dstream;
+	wait_queue_head_t dstrm_waitq;
 	const struct zcomp_ops *ops;
 	struct zcomp_params *params;
 	struct hlist_node node;
@@ -115,7 +117,8 @@ void zcomp_cstrm_put(struct zcomp_cstrm *zstrm);
 bool zcomp_shared_decomp(struct zcomp *comp);
 struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp,
 				    enum zcomp_dstrm_mode mode);
-void zcomp_dstrm_put(struct zcomp_dstrm *zstrm, enum zcomp_dstrm_mode mode);
+void zcomp_dstrm_put(struct zcomp *comp, struct zcomp_dstrm *zstrm,
+		     enum zcomp_dstrm_mode mode);
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_cstrm *zstrm,
 		   const void *src, unsigned int *dst_len);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index b429c52cb37d..52341f05da83 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1382,7 +1382,7 @@ static int decompress_bdev_page(struct zram *zram, struct page *page,
 		copy_page(dst, zstrm->local_copy);
 		kunmap_local(dst);
 	}
-	zcomp_dstrm_put(zstrm, ZCOMP_DSTRM_EXCLUSIVE);
+	zcomp_dstrm_put(zram->comps[prio], zstrm, ZCOMP_DSTRM_EXCLUSIVE);
 	slot_unlock(zram, index);
 
 	return ret;
@@ -2135,7 +2135,7 @@ static int read_compressed_page(struct zram *zram, struct page *page,
 	dst = kmap_local_page(page);
 	ret = zcomp_decompress(zram->comps[prio], zstrm, sg, size, dst);
 	kunmap_local(dst);
-	zcomp_dstrm_put(zstrm, mode);
+	zcomp_dstrm_put(zram->comps[prio], zstrm, mode);
 	zs_obj_read_sg_end(zram->mem_pool, handle);
 
 	return ret;
-- 
2.56.0.176.g3575e65682-goog


