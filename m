Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F78DCA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 07:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33B66B00A4; Fri,  9 Oct 2026 03:12:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B04656B00A6; Fri,  9 Oct 2026 03:12:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A5086B00A7; Fri,  9 Oct 2026 03:12:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC136B00A4
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:12:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB47616027F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:51 +0000 (UTC)
X-FDA: 85302220542.30.0BFE477
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 32B48C0002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:12:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=G2PBZy4r;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791529970;
	b=wxEsCdedPMKbznDqLToBmPBk8MNWeeWu/jUSe9D/5yiqykIDRO3vrRSSJgILglx9y6cB+K
	K1IwKjQR8GZJgEMkEOU3AIqap2eSxmY5kCisTjQ8LnnTxb01jbi7LNsEWE5b9nsokKDrgi
	c2y2lALLg5iZF3A1STp675iHW1UkqcY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=G2PBZy4r;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791529970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v/gZL8VXxbURJSucAog4gqpCMC00QrboweJD1WkTZBw=;
	b=kMnaLOJNjR0e+jSvP0lLQ26J/W2PinOjF8w6xz98GXwxDvlCmjqH0txMP+1uoM1XfSnWNg
	AdZJ0H/lIopZBdIACrBQDCqXr1rF66MT/RegJa8e9uJRjTE+zjAcGSdh7yju8JlXKiacYY
	PqXT2E0RWp81I7Cjhd8nooXw/oGEWT4=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e49fbf92aaso24520025ad.0
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 00:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791529969; x=1792134769; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v/gZL8VXxbURJSucAog4gqpCMC00QrboweJD1WkTZBw=;
        b=G2PBZy4r7hud90Ma1lbTKeRdmSshX+9QuM4x4kJpzbiIlD7MeGsDgU7haC0hdt0boF
         b9sNt6Dr3LHLC5eaBPL/lOtPoAO3RdYhk51v+ex5mV6zZlOw6RdkiiszVric2NtNBWGx
         hM78vWV28Gneij+ywyRAYSub5fL7+wNAL/Mcw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791529969; x=1792134769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v/gZL8VXxbURJSucAog4gqpCMC00QrboweJD1WkTZBw=;
        b=M2go9OQV5n16eKKFrijxhglHWwZgEIzwMyQma7lykBjJzkXIXQ32h0zq+8/gkRTR71
         xecVgo4LiRWCixpNmzzgRdrWKwJKHtfA7lI5k/+8ER454V9TjZcgXg5O3pkcVLtryz83
         iDaDDxMYch/0dQzwNGcIAEZVk/T0Xbz0UxY5ucycvN8vkynZBr7PYF7MfgYBx5IX07As
         0HBw7/QtsPrtcQGw5VMDz8z84wd/S9Q3OKskStx5lOSqTTIIHT0s6JMZVa8U92Pq4IPG
         1Ua8vyjyVBLbFdObKoo3nXrWglrEfSNuwLcgdaLslfb6JuXZDoaPmlIpjBiSq+Xj8zGu
         aBbA==
X-Forwarded-Encrypted: i=1; AKwUvBzlABa2BB4dgZIuZg1XEMQ9vByJzMBe28DZ1KcfiGwYdOPrj5jcSFtqCGMNb4sZBsuyYBCUvbovWg==@kvack.org
X-Gm-Message-State: AFq9FYJDg93TGldUDTZ+GrhaKMuOruEVC3setIhuyymJItkPVbkW/1mM
	6r+SUIcV55La11pVf/lw5TIxJSn7WlQtD55csvVkRtHA3nDn+jUPrQGWO9Ja9PCeww==
X-Gm-Gg: AYBFou0NT27OdtHjz8y/XMtG1faZdG/WgKW1gwPqkc+fYUu9lIMbn2/uA8qN07wrHxL
	UO01u4L0ZkyeP7c3ekqJdga43QO3RA0FRf+I7Ou8g5vTjljW9e5PYzkvw2jjWl+wqiermykOTma
	WSSNmXjE1lM7hQSJgf9LNczgeGpCvI/TTs6LcvKn7OaUEqmU2Aol6JeuFsXaq2Yu0b63rfbwpMj
	2r3w4HKeBMuUcwWpV6xEWhhRggpHO2qmaHvKCdHCdyXg4NtdyxGDTkxBnVgrdZ4sImOOaX0++2r
	atsgCDzzBB5ygzRl/lva5mLZyUBzfw8y6GV/m6r2zzRnUZ3rrNEXURkDfnOHj5gQbVztoabW4OF
	a5Oy+t/AhJ5CgYE5wN5ddWXTrsnvo2+VTJah0XCxkCmgPt5r/v1XNFcxk4JvBzMKUk6M7mdQV87
	6HCzSSCrKP+zX96N3gHUbYctPIRhnjxFAYrVPCwIqz+JE+rtDJjNKgCTWyUjGV7e26wAXm3Grm9
	KeNTBKcOjNt9fuzbD/2n88apje/h5c7un320wCnHw8OoDkiyawm/rUNZo6g9jEVNRaIJ+AM6Q==
X-Received: by 2002:a17:903:3504:b0:2e2:c55c:90c with SMTP id d9443c01a7336-2e842bd515bmr8036365ad.64.1791529968967;
        Fri, 09 Oct 2026 00:12:48 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:383b:5817:8167:5051])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b19a2sm4483535ad.46.2026.10.09.00.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 00:12:48 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 11/11] zram: use rw_semaphore for decompression streams
Date: Fri,  9 Oct 2026 16:11:34 +0900
Message-ID: <20261009071157.3730698-12-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261009071157.3730698-1-senozhatsky@chromium.org>
References: <20261009071157.3730698-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fmg86zx4ag8xot18z4be6wddgmcpx9jg
X-Rspamd-Queue-Id: 32B48C0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791529970-773277
X-HE-Meta: U2FsdGVkX1/Hv8N0wFbNgA7rQr0xbBAjlXv3AYwzMnBlEayvb4tedz87+wBnZn/oSE5e6t/Qfioy6lTOTGJm6+D1Fsh+72xWKzR7PgkVvJH2E+0fL49av05p7E7gRFTRu40eHNt/TLdhLuUzmP5p2yJh7wYsrfPyFB1Ih1qRgW0jTbHMMa88DtsBx0bJ9O0maTGLGzmOt6SFu6Wj4kELt/o7ycm9jw2kWRlMtOCOJaCVTCHR90wukR7dI4wQkfLkydnB0oGZoH69eGrPw8BGnk2hmYROARqfTp8RDEn72mdEJQPMATd+mnEkBXozp4BRFsnLieZkiLSaewqdMXuGM8VVEToJ7rpdzXxO5tMbPmC1cdgo61q67mnHldL/q64s6YloS5L+jNKSaVJsmknxaSP+xIGL8cnDAb5BlCW8ErQkGA4zIy1eXNohOKXO8QH3MmoUM8UosyCtsungS6L4fGrJdKK8fM37ygn7YOh3lU4sM+KvkP0J8+QOArM4g8wMoPgxIq11F56sG/2h6xtoa2VU2guukQyFU+g60kjxQWGP6KypznM2Aw9PjjX1nA0V49F9Yki+stOdMqf6TCMlyDG/OSm2XdsLxAgkNZ02g0qXfMIRaXpL81209bwXYfgev4Ksiew5CwpchUnTx9tuK5EON/CDCDugG4JEQXpmp5p0M3l50er6gkpwXf9aCoGsSBKxKkE3Tqt2TaOCd0VllW6ey4vqBC1RTCMqe+eNfonf4Tc6pKyH8MrnffqerRHmv4B9sQGkTgNuGTXn+NvtzFOE8ppEIvX8tS6mB7t5URnRRk43gWIyS45XP35x+Q7bRf3Cb8URgkPr4XVUUSdHO4/fbl1yCLDxBFmLpdhwPmc91WIKR6mgAFiZcfH0cWJQsvoQOHP3X9wFWZPx+lRtw/QQf/PPdEidYtc9Ga+PxxPSb27wIIbNoaBYGz++n+Btbt1F3HONAjQJRgXV4Zk
 xc9xKSLA
 7OeTzcheOHSuFCW0p2JfLhZSk/bxFWXGgCv3tg7ws7w6EQIyzF82nJ4EuD2SA7F53JDL0EAia9hfspVDPtD5OXTkXr3cHYtgXj76xVKIgVFSoEMEuBiyKHBl0Nk2ulOtknsBdV0ZI9y7U/AfF4ZOBUcX9xEqZTRLjN0fda9DNHWBZ6WqCPg80whQ/zXxRD6LvF6XckdzIFZFeq/wzLkBXNrFzCD3b65+FGGWixOi3SUhf/cw2Ps+rfYsXyJ6pkYAaixFgOiOss4mMWFPio0kdMKT760RWvy6qb6Sjk0FKq2Tnyo+gfen3v+SAxapVnlhcppkai+wBezjJ3ZZWr3HMXx90FAhvMdhCrt/bnhKurEbOJ4ARP+0lcko0wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, per-CPU decompression streams use a mutex, so there is
a chance for priority inversion - a low priority Reader can get
preempted by a higher priority Reader, which simply will get
blocked on the stream mutex.

Switch zcomp_dstrm lock from mutex to rw_semaphore to permit parallel
usage.  However, things are not completely straightforward.  Many
backends have stateless decompression and don't modify decompression
context, so those can be used concurrently.  But then there are backends
that do modify decompression context.  We also can have compressed
object span across physical pages, which zcomp linearises using stream's
->local_copy buffer before decompression.  That buffer, clearly, cannot
be used concurrently.

When the backend has no per-stream decompression context (stateless)
and zsmalloc object fits in a single page (ZCOMP_DECOMP_INPLACE), take
the stream lock in shared mode (read).  Otherwise, when ->local_copy
is needed (ZCOMP_DECOMP_BOUNCE) or the backend has a decompression
context (zstd, deflate), take the lock in exclusive mode (write).

A quick synthetic fio test on 24 CPUs (preempt=full, lz4, 48 low
priority (nice 19) readers, 24 normal priority (nice 0) CPU hogs
and 24 high priority (nice -19) readers):

  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        473k               680k          (+43.8%)
  Read clat avg    35.98 us           21.28 us      (-40.9%)
  Read clat p99.95 55.55 us           20.86 us      (-2.7x)
  Read clat p99.99 6,717 us           2,834 us      (-2.4x)
  Read clat max    2,005,100 us       1,614,300 us  (-19.5%)

Suggested-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zcomp.c    | 41 +++++++++++++++++++++++++++--------
 drivers/block/zram/zcomp.h    | 12 ++++++++--
 drivers/block/zram/zram_drv.c | 10 ++++++---
 3 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 20c487bafff2..79ed957fede4 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -181,21 +181,43 @@ void zcomp_cstrm_put(struct zcomp_cstrm *zstrm)
 	mutex_unlock(&zstrm->lock);
 }
 
-struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp)
+struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp,
+				    enum zcomp_decomp_mode mode)
 {
+	/*
+	 * Backends with a per-stream decompression context modify ->ctx
+	 * during decompression and cannot share the stream concurrently.
+	 */
+	if (comp->ops->create_dctx)
+		mode = ZCOMP_DECOMP_BOUNCE;
+
 	for (;;) {
 		struct zcomp_dstrm *zstrm = raw_cpu_ptr(comp->dstream);
 
-		mutex_lock(&zstrm->lock);
-		if (likely(zstrm->local_copy))
-			return zstrm;
-		mutex_unlock(&zstrm->lock);
+		if (mode == ZCOMP_DECOMP_INPLACE) {
+			down_read(&zstrm->lock);
+			if (likely(zstrm->local_copy))
+				return zstrm;
+			up_read(&zstrm->lock);
+		} else {
+			down_write(&zstrm->lock);
+			if (likely(zstrm->local_copy)) {
+				zstrm->excl_locked = true;
+				return zstrm;
+			}
+			up_write(&zstrm->lock);
+		}
 	}
 }
 
 void zcomp_dstrm_put(struct zcomp_dstrm *zstrm)
 {
-	mutex_unlock(&zstrm->lock);
+	if (zstrm->excl_locked) {
+		zstrm->excl_locked = false;
+		up_write(&zstrm->lock);
+	} else {
+		up_read(&zstrm->lock);
+	}
 }
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_cstrm *zstrm,
@@ -235,6 +257,7 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
 		req.src = src + sg->offset;
 	} else {
 		/* the object spans two pages, linearize it into local copy */
+		lockdep_assert_held_write(&zstrm->lock);
 		sg_copy_to_buffer(sg, 2, zstrm->local_copy, src_len);
 		req.src = zstrm->local_copy;
 	}
@@ -287,9 +310,9 @@ int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node)
 	}
 
 	dstrm = per_cpu_ptr(comp->dstream, cpu);
-	mutex_lock(&dstrm->lock);
+	down_write(&dstrm->lock);
 	zcomp_dstrm_free(comp, dstrm);
-	mutex_unlock(&dstrm->lock);
+	up_write(&dstrm->lock);
 
 	return 0;
 }
@@ -335,7 +358,7 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params,
 	}
 
 	for_each_possible_cpu(cpu)
-		mutex_init(&per_cpu_ptr(comp->dstream, cpu)->lock);
+		init_rwsem(&per_cpu_ptr(comp->dstream, cpu)->lock);
 
 	ret = cpuhp_state_add_instance(CPUHP_ZCOMP_PREPARE, &comp->node);
 	if (ret < 0)
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index e48e3f075352..db9fc7aa5ae4 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -4,11 +4,17 @@
 #define _ZCOMP_H_
 
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 
 struct scatterlist;
 
 #define ZCOMP_PARAM_NOT_SET	INT_MIN
 
+enum zcomp_decomp_mode {
+	ZCOMP_DECOMP_INPLACE,
+	ZCOMP_DECOMP_BOUNCE,
+};
+
 struct deflate_params {
 	s32 winbits;
 };
@@ -48,7 +54,8 @@ struct zcomp_cstrm {
 };
 
 struct zcomp_dstrm {
-	struct mutex lock;
+	struct rw_semaphore lock;
+	bool excl_locked;
 	/* local copy of handle memory */
 	void *local_copy;
 	struct zcomp_ctx ctx;
@@ -102,7 +109,8 @@ void zcomp_destroy(struct zcomp *comp);
 struct zcomp_cstrm *zcomp_cstrm_get(struct zcomp *comp);
 void zcomp_cstrm_put(struct zcomp_cstrm *zstrm);
 
-struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp);
+struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp,
+				    enum zcomp_decomp_mode mode);
 void zcomp_dstrm_put(struct zcomp_dstrm *zstrm);
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_cstrm *zstrm,
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 70d3f0ed9a3c..d47d1e4129bd 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1373,7 +1373,7 @@ static int decompress_bdev_page(struct zram *zram, struct page *page,
 	sg_init_table(sg, 1);
 	sg_set_page(sg, page, size, 0);
 
-	zstrm = zcomp_dstrm_get(zram->comps[prio]);
+	zstrm = zcomp_dstrm_get(zram->comps[prio], ZCOMP_DECOMP_BOUNCE);
 	ret = zcomp_decompress(zram->comps[prio], zstrm, sg, size,
 			       zstrm->local_copy);
 	if (!ret) {
@@ -2115,6 +2115,7 @@ static int read_incompressible_page(struct zram *zram, struct page *page,
 static int read_compressed_page(struct zram *zram, struct page *page,
 				unsigned long index)
 {
+	enum zcomp_decomp_mode mode = ZCOMP_DECOMP_BOUNCE;
 	struct zcomp_dstrm *zstrm;
 	struct scatterlist sg[2];
 	unsigned long handle;
@@ -2126,13 +2127,16 @@ static int read_compressed_page(struct zram *zram, struct page *page,
 	size = get_slot_size(zram, index);
 	prio = get_slot_comp_priority(zram, index);
 
-	zstrm = zcomp_dstrm_get(zram->comps[prio]);
 	zs_obj_read_sg_begin(zram->mem_pool, handle, sg, size);
+	if (sg_is_last(sg))
+		mode = ZCOMP_DECOMP_INPLACE;
+
+	zstrm = zcomp_dstrm_get(zram->comps[prio], mode);
 	dst = kmap_local_page(page);
 	ret = zcomp_decompress(zram->comps[prio], zstrm, sg, size, dst);
 	kunmap_local(dst);
-	zs_obj_read_sg_end(zram->mem_pool, handle);
 	zcomp_dstrm_put(zstrm);
+	zs_obj_read_sg_end(zram->mem_pool, handle);
 
 	return ret;
 }
-- 
2.56.0.385.gd3acb90ef8-goog


