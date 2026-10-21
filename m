Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5A7C606A338
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=OORxJcUP
Received: by kanga.kvack.org (Postfix)
	id 0D5D66B05D0; Tue, 20 Oct 2026 22:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086D86B05D1; Tue, 20 Oct 2026 22:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68E66B05D2; Tue, 20 Oct 2026 22:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE6A56B05D0
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:43:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 427B61A044E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:43:22 +0000 (UTC)
X-FDA: 85345087044.18.24C53B2
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id 75B01180003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:43:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OORxJcUP;
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xD8kSU/9QToLj3D/xT0dXUhUgFwrafcIQWn78ImkF5s=;
	b=pbt4ajUq7CUOaw1Pl/MI087i6MbbPTAC1uj22dORPkKD03BCLmNhObCqDvjHqOPkLZ4Qk4
	TQblw9G0pirVvUA4SL0Kdg9AqzRnlC6CCBTGUjOOJS2AU24GuqrbKIp0pJ6caRAXC0+WqZ
	ZcuygL42aTdEhDpF9RyH53+9lWt/ttU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550600;
	b=gVVivL5bUQOhP7B1yQQuGnLpO7DYRC8XSyj6DwDKxk7oG4l1raAn5eGX9vSV6sPNTw27sX
	ao5zw9nIQnWuqSylyoxa1cKIdAInhkPOQq0zMf/3O3GnodF6xkPPcHsKiOIOiSQpBCSjLe
	VwQ0Qx8yGI/3ptkNIOt9VYK7S+lVYZE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OORxJcUP;
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso763881eec.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792550599; x=1793155399; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xD8kSU/9QToLj3D/xT0dXUhUgFwrafcIQWn78ImkF5s=;
        b=OORxJcUPLcv/DztMlLvVtA9lXsrrla0FNfZ5RUHxxJ1qIwLxcfOzezKrGxQ4X3PxTG
         L9MF4ycVRpR6N4OVPHuHSCGRsNx4Twa+JeOtS5ruLLeEesNwzKEKq2tZm39QvudjFN7v
         ghLnvfKQvG4wfY3hIF8jv6ZX0IdAY99VR0uMQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550599; x=1793155399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xD8kSU/9QToLj3D/xT0dXUhUgFwrafcIQWn78ImkF5s=;
        b=jbnKIVzkTSgqg/en4WQpDSWviv91+YlQMPEEfyaxP3Yvuj3XrEPrricCzIbvLs7p5E
         RpyxJKNciblpqovR4kKztSn0N5LhLfqSUUyIMaJsFz1DxFtlbRvPWnQGSB+uY1NojioH
         VBC81gehacpiFHAZe6eBao/wB+PjSTOeO3SgVSt3qVEbVTyLlTF5eSv3/5uiCNA/QxsL
         cfkAbiBAFlKiqI1digDrHJ7DqwloG9Vca9Mlz8TAhKjeiWT8Ech2OGJ1pg+z2ckB//6W
         C4w4oL4eIu2PK6wpqLW4pl75vbA7FFfrTcZD+G7AQNwGrRnuYpnu9D4LBH9x627IfVSs
         Lq+g==
X-Forwarded-Encrypted: i=1; AKwUvByWr7+pdLJIYdbqpTFEoeOTL0pwnJXmnmiHOsUpXQBOUk5S4OZBSJRGS1/gWaCD/98u/YYxcpW3Qg==@kvack.org
X-Gm-Message-State: AFq9FYIUFUXXfirV3OfSZxsgKB+Vg8MQvT5sbFOs9tRbCaRuLu3jaEqY
	5vBHevIsIeY2jJIYYaqBDSeN6De5RGoqz2ZmeALw4O15fANXCu7bMjJZlZhVn74oBg==
X-Gm-Gg: AYBFou0BjgqBN0Rdq53mHJkR8u8tlw27bgVCOxo6RESOEBxRkAJ3YGGnlmx0EXgdUFm
	6LGnOE3F7knSon/KzKfyEd8117JXewgGg670cOhmU18LF0v9jTuI+ccuWdb1lWufijh3Y2RetrJ
	N8L6HlB/G1JweR9SJ2+sAyL2yPHeD+2356N6E0W7XfhpLYrY3ARTcLUwPRVt2lTgmMBtGlrdnmp
	IaPQgzBfPSuGF44H21RYT0yDaaNdayWMa1LnEdT7GzQF2TE2etr6cy3WKWnVNyCMBK5wqqKcZOX
	zsCV0cQH3biZHds88q8hK3jB5XOHFCgMVWA5c+KYDOkubGW1N1DqHHVuw+XbQjBNMkUfiJZblw5
	1wvvdBgo52c1gKtkA884aeS47HVul1o4ieUigg5ASjENq9eZd6rzo0x8VhL84W9Zd+rmuX2h89U
	bnGj0xAWUrTOJ+x0aDo0jeKOOVnA3y76OH7eh3HhVL2YybeJ7k3HRWk6artVqs9wUvOCqpZr3BO
	0COZm6z2s6EcHNu+aF+zF3jiPfEazPz1anQ4jysd0W7F99dZJZxhvO92IU84+B9GIPPMXj9dWYv
	YUPZbSOQU2fZTM4DTgPmCxKt/ZJNRV5a3IjKbVMpNEsa
X-Received: by 2002:a05:701b:42cf:20b0:150:6c0e:2ce2 with SMTP id a92af1059eb24-190a87a48bemr939881c88.31.1792550597905;
        Tue, 20 Oct 2026 19:43:17 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:97d1:a8be:236d:bf79])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19035c0c9a6sm2392047c88.3.2026.10.20.19.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:43:17 -0700 (PDT)
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
Subject: [PATCH v6 12/13] zram: borrow idle decompression streams in exclusive mode
Date: Wed, 21 Oct 2026 11:42:22 +0900
Message-ID: <20261021024236.1787884-13-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
In-Reply-To: <20261021024236.1787884-1-senozhatsky@chromium.org>
References: <20261021024236.1787884-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 75B01180003
X-Stat-Signature: f6ybef6zrwb4ca7hg8ym9x174ioekhoi
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792550600-759240
X-HE-Meta: U2FsdGVkX1+OLcjO1envQ0hz4kDvaO4cDTFJum/79rkgjxQhCVLYlGZDpAGmPxH1q/RhFwA6r5nQerD+tfEdH4WdQgln32jstYncuLtYPz6kIAw4P5fpbGiMC4WaxjWAZH20n+zDERaPuJjdNTahROXWPSJg0tRnQdR9Dp/emmD4gDSfqUAtvymz8/iZTXDHkUZfpMqzWPP/ucHGWR5FRLF+pdA//pWf0ar1QjbAZvNCoSZrplghOXVTOlBCoGYRc42mZl+EMKDW1W1RjNTcqKwndRA5OLPcv0+xiM1TVVfawWEgqGxy6tdbVeKmq8ACGJD5hYFyLvUIZ0MoGblAJh/7Ho1kmpYIYa+bvQagmcpc7/Hax/4C8U99jaNHaMmem1jEBo46iHiNJF3+/xHA3Nki0IBN5WhFSHPCbSADZtlOGMDCTny8qHSt/rVKKlvBWE1rovHjP0p2yo3QP5yaV+9xwkG01MEhNzebPII1gfmELi/j3EPuwyJYvWK8/Kxzoz3+OTn3Yy98NyebZhMoRMJvPP569nGh0ROk/EOpXVB2tjaZN9BSB+d8LycjtzfSIfg/kuPO3EMPME+wb/3gjKqfVaQCe+wKGbqX/mFrADdfAMjk1l9eKIvfDAxJ2GVUao57aAD5t37mQzjb9boVNuQvfLV9nAJuHchcsgclRlXESoh8A5fFwY4R9VFdBXv2ipLd6Sx5u2bVrBeHpqHCHSazYpiJzBFSEh5WNmFL1mwbb3VaDQtqrcaFdqyNVLJJZwALuU9+VcG87yY26X2JXzQ4fjhxWD92Fj/FscaFvLzkJtnIId6r+8KGBzeB/1zxnHqxilnMO3jIXBQToZKe+35Z9fqQz5QIEIfho7b7m9UTHJkw/HwY9/2IAjH4+KCVeB6QU8dkEHF/jQm9OSZNFST7KgHdNhPHWP4nY+b4LAi7JhiCmwaH/gw0N4TBnbGLUACeEeCY6Pum1woO1qn
 xPxDSxKV
 rcqbo5a1VPXosdySvnfYFk84xozpWD0wEVVfdFy13uyVQ6C5303Zfi/uFVbYcDoz9cqR8vXF/7fo4+MkB6Rfros4vIzO+VEZopMt3o7xs89N7Bohm+H/jZow3Zg6TbUiq5f/0cPa+KNaBdU/bXkomqnYXj4GmLK2wxymzXTCjWQEfDA6NbomDz5rnOEIaiHJo10h4AgeLVHtDQMV0r3TnMHUzBiMWBWIW8Zg0m8XXOqKX6XwJ2f0DQmIkndMXwJXh66S7FIfBCgXJJ4QVbkHfNMrqLES1gAi5XqRmsIzaAjKOj0+IdU+J3AYnH3CN33MaX/+YxRQiAMRS+61ScFBO4dC91R6CHHLBXdpz8F4a9geSYDiURZZgK0NjdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 4fda13aac896..72683f91313f 100644
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
+	unsigned int cpu, start = raw_smp_processor_id();
+	struct zcomp_dstrm *zstrm;
+
+	/* Best-effort start CPU hint; migration during the scan is fine */
+	for_each_online_cpu_wrap(cpu, start) {
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
2.56.0.212.g129ede20d9-goog


