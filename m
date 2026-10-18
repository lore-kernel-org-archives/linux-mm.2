Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F07BCCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 03:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54C9A6B009D; Sat, 17 Oct 2026 23:52:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AEC86B009E; Sat, 17 Oct 2026 23:52:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32A9B6B009F; Sat, 17 Oct 2026 23:52:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 414A16B009D
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:52:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1C44C037C
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:52:16 +0000 (UTC)
X-FDA: 85334374272.13.0D84F54
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0BE2940002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 03:52:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Re8hS2j4;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.49 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792295535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjViqRwAMEG7zJkwnYC4UEqQagXFhLBQpmZRnR3MJEU=;
	b=S9XSpMxMeSUPD5GijzVIzi9uXRfh+FEqspLCIZtH9XgaU+GqMdwpq1ylEq68UwTC3mYOpb
	sdM1do8zheH9CDx5BIdFNrKIX4o9+fQOAixAN7pBm+NupUWK/A/3S2IKpne1w3G6mqeskt
	4UO3a5CwHfXnDEzzVzW/zeWSalxu3v0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Re8hS2j4;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.49 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792295535;
	b=V/ou1DyWedIUjeiZq0xdWz4ZE6meatA9jTg0K5zFOF+y2iRhdAOn9dUFh1pfDRqfhXqG9O
	8UQBWFSOM/4uPpphWkUYYiZuKAx2VYz221Bzk2udS8NJeqa6IH1AdQ4c8PCgjy1AtL+oln
	mfF7DyK+JdCuktPnA2cY0oygThcq+Xo=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so607946a91.0
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 20:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792295534; x=1792900334; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GjViqRwAMEG7zJkwnYC4UEqQagXFhLBQpmZRnR3MJEU=;
        b=Re8hS2j4MpMeBzz5CvaQOl2MHCSaTRMdopn+vy0J2g83CjvWq4wQS4vTdMzG/tFv8D
         ttLzJw70ICH+0i3CUE9XqksTKcg97OQOf0JWgk/L4TF34MxcuQmzt3K94x7cYn6g+Mxs
         AatKBDYEflxY9IFtD8tDeJ+6x9i4ZjSthN/k8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792295534; x=1792900334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GjViqRwAMEG7zJkwnYC4UEqQagXFhLBQpmZRnR3MJEU=;
        b=hKkQHV8rBRex2w4CK/wuZKeVTsA44OD95HtOul5RXWISiXL1TMPLoIQ0CLDuHRt7a3
         Sd2aIu4xxnOPBjH5mtVyPw2yrODJgurkhNXGnhfnJUXdV65+SKKpMdVbxWq0EmFsCVq8
         ONRIHGTttNhFAlHnkSPcim1ByK/ZXKmqxquOLP7+a169t721TSYttHkCdtGgyfBDv2V/
         aQPdPBadjGAoUuMfL7LxuVpLBISz5j9+YE0UYU/CyfGZFm5dXt60IS2fXBQXvrrg+Eet
         lUecy7ei2ItNu8gxq/vheUMixNDQLKQtkJR1P+WbHD7TN57p1uFBVsMjMN+VgM/l6ypQ
         sOkQ==
X-Forwarded-Encrypted: i=1; AKwUvBx0uHpkWCE1WIP8N2nVPG/IbtIvQn36Ymf9FOe7SwQbk6o/dByHWn/lyrRVkAFlFDZM6RvHYZ/n9w==@kvack.org
X-Gm-Message-State: AFq9FYKdcJTs6xwVTH2ihbKpFD18CRXnApXSMehD7Z/EZhaig4JKe0My
	I4HGMDMuNLbSIxVKP9WBzQschrdlSFRucncemxTOFEoTkbr5SU4BJIGtO/Nm3lIZ1Q==
X-Gm-Gg: AYBFou3GncoYP4kPRRjnCJVhsz71V1FoWmTf02HppMWYbzYfVPijDb0FLlEP/ArLTvn
	g76WZT3HPsd5Mn7qX8Lv7m//GqgJtCgY9IlfRdIqsDSNzc6+0yrDUuQ1vaCh6GYh/7ttS3p9opa
	zNMNgPhx5K/XL86KDjjyCdP9Ji29wR4aiMTSogV5p3PkJPVAbQ8Ck27+iUoA/JW9suWUUgix1oe
	CbeQxMS1DWtPd1OgYFEt7L2iJ0hNaoxuOMK5+mb2c1H+PoHOxgx7+s6GKRsz+KMSAXZttHVdep7
	6gMu2C34I9BscQBWXZhUoGb3ExtJxdt66SxgId2PcbwMlYsYGAeXCIA9ggcr+q0lzhtrmcxSWfh
	MICOGhVVEyv4YuUizQcyFXVKoT35F/ATMEphoBG07JUAjaN0SgkBBBUM+QZjgx366lqP/BVb1PS
	l9CyvsE30v0ApMtOh1Yu+WGmwaQg4mgtASvHHm0TOj3IGequjBKO0AcSOruvO+iXwJYQBVXBpi3
	0C2FtM6FNe9cWQyKFx/4+jKDLPUdG5Xq92Z4JTKRc5vzIkYxE9Q7I9nmb418t0=
X-Received: by 2002:a17:90b:388c:b0:3ac:8446:c1a5 with SMTP id 98e67ed59e1d1-3acef10d017mr3561438a91.48.1792295533840;
        Sat, 17 Oct 2026 20:52:13 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:4569:b311:f3ea:5f8d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad25d5d1b4sm253024a91.16.2026.10.17.20.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 20:52:12 -0700 (PDT)
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
Subject: [PATCH v5 10/13] zram: introduce shared decompression streams
Date: Sun, 18 Oct 2026 12:51:12 +0900
Message-ID: <20261018035125.3120704-11-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261018035125.3120704-1-senozhatsky@chromium.org>
References: <20261018035125.3120704-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wsd1z8qyq8ghm4bpn63htr9hphsaxo6h
X-Rspamd-Queue-Id: 0BE2940002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792295534-848934
X-HE-Meta: U2FsdGVkX1/tGXdnDJCSzj5dnccillDi9nMEvX9YSMjqi2cNcBtdZPqScMYk5NZCXx562SxVTr1T/DWyW3WgAIMM42ox2KPaeQVNLOFyaaUDEkZThMWHEKjZsS7S7bVO9KlWYc0H/qeEHxR5iPcAe22Zhapz2qHDwCKiNe48IwnVj1VIL3F5idvEaPhtKboAfbEYtRn6ohEGGlRCdOZ1ogYDLYp7oboCcEbD3nn2ifa/aICiXBXr48316ar4QsOCLoMEVhY2qoEiTUhNSFA0HQJIFfHVucMZRRKng1bmGSuSPgVvx1ARx5vrVHjsAudAdkYeNr5/+PL6NAgqT9G+VdU3T8jCA5fnZSmFBn5iQtNlt/BfF36fcg1fr6S+TaacQ2w5ZBpf78CZJGzY2NHcA6ySqgolRsRQdNAFjkVIEgSIwAFxOy8dtY0eUwPVRV5YkqXRBSLluCaDPU7FtVl/Nrsn38qGhftxwSJWK3KVC1y4ixwSeAYOBXtWdSBgX9xdh2B3wkYPj9+SdK8A9XWCENEqqkVcT853yMTEV2Ea7woZCXoHn8rLokI+fz8FqpBN4SL8zEm/MW0Lf92Bd6H4e0JGWIsqyzBygN6P45etOofPTPfLwuHsg6SjGpdfcSj/vzghFQ+3/nt4wauSkKWieNS5AecTeD//uCu6ay7RJv6/ndssX9gWGMAqrt+F7nNGkgkfC78RhjXHqx3VPhmiOlBAMTa8F3ttkhAGRYz0RGMGLCRPd+ockwJmSpwZT9ZTyx0jdnHgpacdZFqxitWnmEcA460BL8Vuryx0Z9ePGLdn3R/PemySBaqfMvq4pImXJz4dPvywB4d4oubD1eoIFyFQkVrPVUEaoDEhvSNL8rX7nA2sIs9zxBhaGq+Hc+I3eegiXllBGbMJ271xTZujRN4TEpD68/wCvRqWHk63HdDBBRaNlHexsCL/7Lg78E54+WXDJdnenMSrRXCiSMW
 /mfRYas9
 Ba9EuyQW4GM9NFq9HefnJyDdLElmCPVkO+GE/CtHOv3bjSZHO6yNpFWMJh5IFhro5ZQjzM+RiSvEgV0ibYichc73MelTtrZHMUnKG4tKzAev41sR7huyLlJUvSsJp5TNxFKXaKjeyrTYWcqHb+8YdiIYLXesm0AOUo9kVJ1U8PVLAScGOB5X4CQgvxMSy2y7owZC+ktTY+j+0MMDH+BKaVExoYxon2/BXIbiaTiZ5L0sXsCv/4jorVJZoPa2nbrybuJlaT6Wt3qwWEYtFql6RtZxPHIgiE9mXmdRxN7JNNB9I/1Tt/1yePCiFFbnd3dOD8gDKcVzD23v6fRw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, per-CPU decompression streams use a mutex, so there is
a chance for Reader vs Reader priority inversion - a low priority
Reader can get preempted by a higher priority Reader, which simply
will get blocked on the stream mutex.

Switch zcomp_dstrm to permit parallel usage.  However, things are not
completely straightforward.  Many backends have stateless decompression
and don't modify decompression context, so those can be used
concurrently.  But then there are backends that do modify decompression
context.  We also can have compressed object span across physical pages,
which zcomp linearises using stream's ->local_copy buffer before
decompression.  That buffer, clearly, cannot be used concurrently.

Give zcomp_dstrm two locks:
- ->lock (rw_semaphore) pins the stream against CPU hotplug teardown.
  Every decompression request takes it in read mode, and only
  zcomp_cpu_dead() takes it in write mode.
- ->excl_lock (mutex) serializes access to mutable stream state
  (->local_copy and ->ctx).

When the backend has no per-stream decompression context (stateless)
and zsmalloc object fits in a single page (zcomp_shared_decomp()),
the request touches neither ->local_copy nor ->ctx, so it only takes
->lock in read mode (ZCOMP_DSTRM_SHARED).  Otherwise, when ->local_copy
is needed or the backend has a decompression context (zstd, deflate),
additionally take ->excl_lock (ZCOMP_DSTRM_EXCLUSIVE) so exclusive
requests serialize only against each other without blocking shared
readers.

A quick synthetic fio test for Reader vs Reader inversion on 24 CPUs
(preempt=full, lz4, 48 low priority (nice 19) readers, 24 normal
priority (nice 0) CPU hogs and 24 high priority (nice -19) readers):

  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        857k               1,382k        (+61.3%)
  Read clat avg    14.40 us           4.07 us       (-3.5x)
  Read clat stdev  3,270.31 us        671.46 us     (-4.9x)
  Read clat p99.99 1,500 us           24.64 us      (-60.9x)
  Read clat max    2,430,200 us       1,022,758 us  (-2.4x)

Suggested-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zcomp.c    | 56 ++++++++++++++++++++++++++++-------
 drivers/block/zram/zcomp.h    | 21 +++++++++++--
 drivers/block/zram/zram_drv.c | 12 +++++---
 3 files changed, 71 insertions(+), 18 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 1c9f6d5c8cd1..da122bf4dd15 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -165,7 +165,7 @@ struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp)
 		 * so then unlock and re-try on the current CPU.
 		 */
 		mutex_lock(&zstrm->lock);
-		if (likely(zstrm->buffer))
+		if (zstrm->buffer)
 			return zstrm;
 		mutex_unlock(&zstrm->lock);
 	}
@@ -176,21 +176,49 @@ void zcomp_cstrm_put(struct zcomp_cstrm *zstrm)
 	mutex_unlock(&zstrm->lock);
 }
 
-struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp)
+bool zcomp_shared_decomp(struct zcomp *comp, struct scatterlist *sg)
+{
+	/*
+	 * Shared decompression is only safe when the backend has no
+	 * mutable per-stream decompression context and the object is
+	 * contained within a single page (no ->local_copy bounce needed).
+	 */
+	return !comp->ops->create_dctx && sg_is_last(sg);
+}
+
+struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp,
+				    enum zcomp_dstrm_mode mode)
 {
 	for (;;) {
 		struct zcomp_dstrm *zstrm = raw_cpu_ptr(comp->dstream);
 
-		mutex_lock(&zstrm->lock);
-		if (likely(zstrm->local_copy))
-			return zstrm;
-		mutex_unlock(&zstrm->lock);
+		/*
+		 * Pin the stream.  The write side of ->lock is only taken
+		 * by zcomp_cpu_dead(), so this never contends with other
+		 * decompression requests, regardless of their mode.
+		 */
+		down_read(&zstrm->lock);
+		if (!zstrm->local_copy) {
+			/* The stream has been destroyed, re-try */
+			up_read(&zstrm->lock);
+			continue;
+		}
+
+		/*
+		 * Exclusive requests additionally own ->local_copy and
+		 * ->ctx and hence can only wait for each other.
+		 */
+		if (mode == ZCOMP_DSTRM_EXCLUSIVE)
+			mutex_lock(&zstrm->excl_lock);
+		return zstrm;
 	}
 }
 
-void zcomp_dstrm_put(struct zcomp_dstrm *zstrm)
+void zcomp_dstrm_put(struct zcomp_dstrm *zstrm, enum zcomp_dstrm_mode mode)
 {
-	mutex_unlock(&zstrm->lock);
+	if (mode == ZCOMP_DSTRM_EXCLUSIVE)
+		mutex_unlock(&zstrm->excl_lock);
+	up_read(&zstrm->lock);
 }
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_cstrm *zstrm,
@@ -223,6 +251,9 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
 	int ret;
 
 	might_sleep();
+	lockdep_assert_held(&zstrm->lock);
+	if (!zcomp_shared_decomp(comp, sg))
+		lockdep_assert_held(&zstrm->excl_lock);
 
 	if (sg_is_last(sg)) {
 		/* the object is contained within one page, read it in-place */
@@ -277,9 +308,9 @@ int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node)
 	mutex_unlock(&cstrm->lock);
 
 	dstrm = per_cpu_ptr(comp->dstream, cpu);
-	mutex_lock(&dstrm->lock);
+	down_write(&dstrm->lock);
 	zcomp_dstrm_free(comp, dstrm);
-	mutex_unlock(&dstrm->lock);
+	up_write(&dstrm->lock);
 
 	return 0;
 }
@@ -306,8 +337,11 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params)
 	}
 
 	for_each_possible_cpu(cpu) {
+		struct zcomp_dstrm *zstrm = per_cpu_ptr(comp->dstream, cpu);
+
 		mutex_init(&per_cpu_ptr(comp->cstream, cpu)->lock);
-		mutex_init(&per_cpu_ptr(comp->dstream, cpu)->lock);
+		init_rwsem(&zstrm->lock);
+		mutex_init(&zstrm->excl_lock);
 	}
 
 	ret = cpuhp_state_add_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 22be50dc51ba..bf41b27958c4 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -4,11 +4,17 @@
 #define _ZCOMP_H_
 
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 
 struct scatterlist;
 
 #define ZCOMP_PARAM_NOT_SET	INT_MIN
 
+enum zcomp_dstrm_mode {
+	ZCOMP_DSTRM_SHARED,
+	ZCOMP_DSTRM_EXCLUSIVE,
+};
+
 struct deflate_params {
 	s32 winbits;
 };
@@ -47,7 +53,14 @@ struct zcomp_cstrm {
 };
 
 struct zcomp_dstrm {
-	struct mutex lock;
+	/*
+	 * Pins the stream: held in read mode by every user, regardless
+	 * of the decompression mode, and in write mode only by
+	 * zcomp_cpu_dead().
+	 */
+	struct rw_semaphore lock;
+	/* Serializes users of the mutable stream state: ->local_copy, ->ctx */
+	struct mutex excl_lock;
 	/* local copy of handle memory */
 	void *local_copy;
 	struct zcomp_ctx ctx;
@@ -99,8 +112,10 @@ void zcomp_destroy(struct zcomp *comp);
 struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp);
 void zcomp_cstrm_put(struct zcomp_cstrm *zstrm);
 
-struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp);
-void zcomp_dstrm_put(struct zcomp_dstrm *zstrm);
+bool zcomp_shared_decomp(struct zcomp *comp, struct scatterlist *sg);
+struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp,
+				    enum zcomp_dstrm_mode mode);
+void zcomp_dstrm_put(struct zcomp_dstrm *zstrm, enum zcomp_dstrm_mode mode);
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_cstrm *zstrm,
 		   const void *src, unsigned int *dst_len);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index def5266679b0..a34859ff0461 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1373,7 +1373,7 @@ static int decompress_bdev_page(struct zram *zram, struct page *page,
 	sg_init_table(sg, 1);
 	sg_set_page(sg, page, size, 0);
 
-	zstrm = zcomp_dstrm_get(zram->comps[prio]);
+	zstrm = zcomp_dstrm_get(zram->comps[prio], ZCOMP_DSTRM_EXCLUSIVE);
 	ret = zcomp_decompress(zram->comps[prio], zstrm, sg, size,
 			       zstrm->local_copy);
 	if (!ret) {
@@ -1382,7 +1382,7 @@ static int decompress_bdev_page(struct zram *zram, struct page *page,
 		copy_page(dst, zstrm->local_copy);
 		kunmap_local(dst);
 	}
-	zcomp_dstrm_put(zstrm);
+	zcomp_dstrm_put(zstrm, ZCOMP_DSTRM_EXCLUSIVE);
 	slot_unlock(zram, index);
 
 	return ret;
@@ -2115,6 +2115,7 @@ static int read_incompressible_page(struct zram *zram, struct page *page,
 static int read_compressed_page(struct zram *zram, struct page *page,
 				unsigned long index)
 {
+	enum zcomp_dstrm_mode mode = ZCOMP_DSTRM_EXCLUSIVE;
 	struct zcomp_dstrm *zstrm;
 	struct scatterlist sg[2];
 	unsigned long handle;
@@ -2126,13 +2127,16 @@ static int read_compressed_page(struct zram *zram, struct page *page,
 	size = get_slot_size(zram, index);
 	prio = get_slot_comp_priority(zram, index);
 
-	zstrm = zcomp_dstrm_get(zram->comps[prio]);
 	zs_obj_read_sg_begin(zram->mem_pool, handle, sg, size);
+	if (zcomp_shared_decomp(zram->comps[prio], sg))
+		mode = ZCOMP_DSTRM_SHARED;
+
+	zstrm = zcomp_dstrm_get(zram->comps[prio], mode);
 	dst = kmap_local_page(page);
 	ret = zcomp_decompress(zram->comps[prio], zstrm, sg, size, dst);
 	kunmap_local(dst);
+	zcomp_dstrm_put(zstrm, mode);
 	zs_obj_read_sg_end(zram->mem_pool, handle);
-	zcomp_dstrm_put(zstrm);
 
 	return ret;
 }
-- 
2.56.0.176.g3575e65682-goog


