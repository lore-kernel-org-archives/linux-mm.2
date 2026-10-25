Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C518260A5BDD
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 02:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=EOn5OO7E
Received: by kanga.kvack.org (Postfix)
	id D768A6B05C2; Sat, 24 Oct 2026 22:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20436B05C3; Sat, 24 Oct 2026 22:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1236B05C4; Sat, 24 Oct 2026 22:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8681A6B05C2
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:19:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0AD4E14048D
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:16 +0000 (UTC)
X-FDA: 85359541512.02.DBA774E
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 377C020005
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=EOn5OO7E;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792894754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eh0HnUlw9pDgMjno+anNWxERFVowk6iHp/gOhy/GxfU=;
	b=Z4DiY3JXBZm1/KcL4yQlPsjwpX7PW+sTzDtPIiYjQRsw2uipvxiiwT7VgEb8KozpbS21a3
	8g04nJiUTad7I4AnBEHXoSB+c7ulaBAURlsJFbEqYt7tg2X9gjq6Oawd1HvmJkpcEmoBTH
	LSks/ccxmhysBXSYt2D7fbTwxoCNW5k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=EOn5OO7E;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792894754;
	b=yJpRM9x7tyEMvO+iFtWgLiuHKRAQJIbHEGT+llr4YhgTKSPLjKCkSj/DYd06I2Fcl30kNQ
	vKQzO4VO44Vp4mNIjocBGKWrW7OjAFTZxmN2a49jQb7r27jX6EY0RLfIc3e5f1RUOQcmZZ
	sJmwTug8Bb8+7hSx5xvNEPEvJeHRKOU=
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-36661f953e4so3728434eec.1
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792894753; x=1793499553; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eh0HnUlw9pDgMjno+anNWxERFVowk6iHp/gOhy/GxfU=;
        b=EOn5OO7Es45sXzBfs/vgUgf4ATdGaacrC9i/6+JhPCvv13oOg3LgwHwGeTArTPMmdX
         9CYV8/JL8O61pUVue8GYQr+SWq2DWlh4l3CwJiuI3JSkaKQLDNrpi2BJ5F1AHlnVpt8s
         Rml0SQ6oUvMoXEOdgRrLfOe7bNWoET9VmJg3U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792894753; x=1793499553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eh0HnUlw9pDgMjno+anNWxERFVowk6iHp/gOhy/GxfU=;
        b=ORDbNydt7x1fdt4qLigYFArxBr53ylNi4ednPcYWYWqZfER+Cusk7SDJBnkiwl1wqj
         1eClNe7iNcXV54uwMWQK/pF9uc7k4Cdd0Bou3iRBQiekd7uRRd/x+raw2YA8lHnh8cZd
         eY7VsU5oXXOznJ+30kHIHVYpWM5bZ8UrcIDo/cedEvTVe1/rsmZ2xxuQx5nYxgzu8lv+
         V7i2l1VBSsE+XLQGgA/aUG6NocNxm427SdqeoOZDcAoUv1Aj5xbUEOrssSyhugz9IVYy
         OgUzESkICCNvUf0BrQk7Eb7fvaE8CuUuOldN80K21fD49kYZgR66nnP7kMdcaMX5fcY5
         m+Zw==
X-Forwarded-Encrypted: i=1; AKwUvByyRBCIVlyAvkIgmRMftuXnQij+GJcpH0KC0JOaAPOuZ76Up7y9KeARq9KTAPByIPK1tJ4poDRilQ==@kvack.org
X-Gm-Message-State: AFq9FYIFn1oXOTSOoOJ8CXGJ5pANOX8JRYjkMFR/orY/1TO1RIMDTK+A
	fn5yZSI+/tK633QgKaNkVaI8XierZ+kkFamGv6HtDF3VKEhnj+JXbQGr5XGv/ob5HA==
X-Gm-Gg: AYBFou3pdf4QIfZTc8osnMQLp/4euoCf2yIKPg5wixUcFn9LABQAWx99eonw8jrjNnb
	rdg44SYlaBwpwCrh65s2iGtDosDNupSqWXX0wPv7XbjFskg31zSXCon8QHL9x/FsWqPCzoNda0l
	6GJETI7MEH8YDAzFOYRNipvw+si1NxoTRX5Gu3n+/czvRVm0NjLebYS2MCRGdrv7qya3KSsULLQ
	JNw72C5CuCzALG+dXSIBpUL3slyoARzhLkOjAXGvmqFtSHFaKJGD70AnBp7DlObquNhsy2d93nR
	1lVscK8b5xbLiWcfjgtnM6vonA4ZCChFO0HIWEgrx0tZhLXs2Hx7m7WSWFb08s9b3Ph1+sCtA3E
	CFq/293gAuhm6z9x9BiaHjXQvzamWiNfSW/7R5JPdIclAiAUI/nPqA9uq3bB2MtGiNl4HxVbM7W
	9Vbn64ktpgqflTBy4JZ72KIqRW8hvQZYO5N8BchuhToiRf9aPPLSLQliirWYV030ffTZF327SQO
	VHsf/MVvlWqOseLh6glgu/XQcCx/MF1Bvylhj0qCFc2YuR8eevPoOdMaOqZCkLMDIKwySPE3TJP
	a8QiaGpnby0XqrgiIiqEPZXptUnPsn5UaDAHH5shGqcgARqiam8wrVylHlbOT7s+qw==
X-Received: by 2002:a05:701b:2501:b0:15a:4155:3d9d with SMTP id a92af1059eb24-19936e34e29mr4661614c88.31.1792894752899;
        Sat, 24 Oct 2026 19:19:12 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9f87:66fc:8c85:11bb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee5asm10387242c88.8.2026.10.24.19.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 19:19:12 -0700 (PDT)
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
Subject: [PATCH v7 12/15] zram: introduce shared decompression streams
Date: Sun, 25 Oct 2026 11:18:28 +0900
Message-ID: <20261025021839.1542805-13-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
In-Reply-To: <20261025021839.1542805-1-senozhatsky@chromium.org>
References: <20261025021839.1542805-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 377C020005
X-Stat-Signature: g3xey9tijtqrpbosn37o666i7mdfc7di
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792894754-165980
X-HE-Meta: U2FsdGVkX1+2bQLMwNG2Zrs1ffyL8fBOUKKT+8oBiIi7W8egl+2h7wUlMgHlc9Nc8oLOIUyIX2q5c8WdLyCXoCRlCpUrC89+EB+v2UYZjXOjCFSVJbnazq7Rj+cMWGufnDAkBVVno05rId2vVpH48ScwXzLagfbfqe6TO35FJ3fptjodgPXi8Ndzpqr1tFkHSUwIJw5JxlDYM/MRQymelERzGwroRG9NEWzwwGb72RjRbCEnBBXmcpR7oC0sO2cQ5jy2rzlc5YHVs0C9VSO4/9PbyfQel3d7YrcfnpbxVos5J700rs5BtP2T+PFdWQWnY0s88C1UkHTITYm0/Pc4FD9F8DrDA9omg1/CxZDGWyjGL8nUqAYhI41aj86rktadXyCVw0jKR+JJMLXfVmTlQxtySidL+QfpBLX8lpQENfy5H/u2Z8Kl6a4y0XXPsLnS44qP+7alXw1pWTLObQD+cvvgcsSvXnN0Mr+QV2GMa2SgYqra4fp1/T4Z40u6G5ozXiZZW19mLvJCV5b5I5XzKacu024TY7yoU8j8T7eqO1o6nhwSd/IlbGZJoXz7l5OMDivCXInL0zp4+CHhnTkclOZ7pJ4NvrSwX/I9aRMcITMEOLbtZWjCEWMOTDj1qUeFxDfwcgDWEaF+Rxkwz5VDYHVs5rs7N7efcMbh5d1HV0TUAstCV5bL5Wh5AJfmumy5bFsrjxzWf5rZY8RmOsu8DELIZQJdFo8YfmAJXWReiw8goa7yGyNUsNpYfg1APXzD0Qf+6VqdkMMo5ulczk88APVGiCEUCGNjE2vGHhSdjBDvp5Oq3gmvRg57KxU8Ps3R0rriH0f4spQO6HQTWi2flS6W6uu6DEGwVrTrErFTbO8rwxopQ/eoyaT9LTrrbVCzU/nnBKUbNYoqfXvBvOUx1g/mqyFCmRekHJqyBmgmvEELI66AuWd85Jzc465qaUA4ZiJEN2GG4feH0+jQ+Gk
 /IZbpKAS
 TfYDhZqVuSK49rSMN72AWuLh/kq2wqzB614vQkTbqU0JzyIkWskN2rGcxGTwjTaB4IP8ZFBH6nR47c9tq5DE9jw1xYHs8f+Pt+xroOxDxvNiqNGJ/T84VVY7JuK2RBh2UFQhxvHovgSJ1q6PQnUwbv8X5hwFffr4QKe2IrHkqOxqFBoGeYMcikVRek6TncR5Q4VjMl2Pk3Y4wblZ/UDA4IYgQ+cXzu7Sbr+WFhUIfgnCYUSLX0QCpDEzM9IRBQ4aiyhkJ3k1ptoFoyLzpNWLHMAjkHmgiB++o/lsOiSOkSzgU81vG6cVnK5cKfXYG+8IcQ1TqQ8mwSGPwQx4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, per-CPU decompression streams use a mutex, but most of the
time there is nothing to protect.  Many backends have stateless
decompression and don't modify decompression context, so those can be
used concurrently.  The mutex is only needed for backends that do
modify decompression context (zstd, deflate) and for compressed
objects that span across physical pages, which zcomp linearises using
stream's ->local_copy buffer before decompression.  That buffer,
clearly, cannot be used concurrently.

Serializing all Readers because of that also creates Reader vs Reader
priority inversion - a low priority Reader that holds the stream mutex
can get preempted, and a higher priority Reader that then needs the
same per-CPU stream sleeps on that mutex until the scheduler runs the
low priority Reader again.

Switch zcomp_dstrm to permit parallel usage.  Give zcomp_dstrm two
locks:
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
priority (nice 0) CPU hogs and 24 high priority (nice -19) readers),
fg reader results, average of 3 runs:

  Metric           Base               Patched
  ----------------------------------------------------------
  Read IOPS        972k               1,466k        (+1.5x)
  Read clat avg    11.56 us           3.29 us       (-3.5x)
  Read clat stdev  2,739 us           16.6 us       (-165x)
  Read clat max    2,204,467 us       6,442 us      (-342x)

Reader vs Reader with CONFIG_SCHED_PROXY_EXEC=y in both kernels,
21 runs each:

                          Base                    Patched
  ------------------------------------------------------------------
  lz4      Read IOPS      1,456k (+-22k)          1,472k (+-4k)
           Read clat p50  3.3 us                  3.3 us
           Read clat p99  6.0 us                  5.9 us
           Read clat max  2.8 ms - 951 ms         2.8 - 7.4 ms

  Welch's t-test on IOPS, 21 runs each (patched vs base):
                          diff        95% CI              p
  ------------------------------------------------------------------
  lz4                     +1.1%       [+7k, +26k]         0.004

  Runs with max read latency over 100 ms / over 1 s:
                          Base                    Patched
  ------------------------------------------------------------------
  lz4                     15 of 21 / 0 of 21      0 / 0

Proxy execution closes the throughput gap, but shared streams don't
block in the first place, so the worst case is still much better.

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
index 0f8764c7a942..768c9a6d81e5 100644
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
2.56.0.257.gf7497c7d27-goog


