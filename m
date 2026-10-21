Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB4B606A325
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=bAhRog2s
Received: by kanga.kvack.org (Postfix)
	id E43276B05CD; Tue, 20 Oct 2026 22:43:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3F66B05CE; Tue, 20 Oct 2026 22:43:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C942A6B05CF; Tue, 20 Oct 2026 22:43:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C54F6B05CD
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:43:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 243C9160428
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:43:15 +0000 (UTC)
X-FDA: 85345086750.03.840C4CB
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 538C8160002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:43:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bAhRog2s;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMUHUG9mI8djbWDXUeIrwPM5WKtb93fhgTyjDqvX1u0=;
	b=r5CoHlz8N1ckgQPaNBoBwon9G2Uyu7MVZ12xmaWz8a+KtvTRubzkRxPwsOWKLlIvVMoTZp
	VDr5T68neygR4UiLjbpmEkskt74rupiO3BpuadqF9GJB/l5sOrFaSFNXRWMpct2pKuH9Pk
	RS9rA0RjK2M8T6VRXzzedQPzuSN9tlA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=bAhRog2s;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550593;
	b=BPBTcnkskzNfp8DdZMTTLGo10WNuF3iQsyeCGg+DXgbIcDT8qzO8U3b3iBiEYeGxR85dej
	EnwyrB1KJShC15+ObHc+rbtqScJ2CGSjFO2/5cS5K8DFrQyaKUuk6BjpWXiamWqe9Yy6u0
	5s/PEGw78qY0zS7joWmacXtIspuTaeQ=
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-3535bf8b3e0so429658eec.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792550592; x=1793155392; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GMUHUG9mI8djbWDXUeIrwPM5WKtb93fhgTyjDqvX1u0=;
        b=bAhRog2sqLhpVEw0X37poA2xx0TlTFKU/Ot/WhtBr9bJUmRycGEJIt3YZYc89R0aJp
         tAT439u7YFLwosKoE0ubS3771nqwQZSxWr7pZFhzUEh2zfPlPD7vl/JLr9s54lmKMgI7
         Yw71CLpcCbisSy+/xONuibMd8/RTjVRYygIyw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550592; x=1793155392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GMUHUG9mI8djbWDXUeIrwPM5WKtb93fhgTyjDqvX1u0=;
        b=mk1Mi2rH/sQgm/ZiqzQIoDe4DEC7ZCNGBt/smo8yvcoynpZR1uBSMOJ4oTjQ04pejw
         FHfzxsxIZ6jxhhaCQym+AAGV/+jf80IMEmYEHcC3PReWsRdbmwQIJWrJQTtgfef8UT7H
         WQuY8vK7HeMJ2YyJoZ1hP75b7YNymz+lWQFYOAbTA1x/ecdLk2aS32AB7bPsq5+vFR1g
         kFas5yiUUW3UykEXS6mDroqTEOzzodtJYtNBj6CVJYXLGHfT5/EvVlrbWlNCFRxrxPE3
         qJUBL4tJ1nVpaodxSqF87gnGWBRHtG5wKMKVX7FVqAHtd/lJZSQFziaz3j7vyhW1HvKC
         ih+Q==
X-Forwarded-Encrypted: i=1; AKwUvBzIbDmIsagN4cqVjacSovoR0A+uN+4e9VVDiCd/rAOj797iJ427UTO34tj36ADPSArHpwHMg6PJoA==@kvack.org
X-Gm-Message-State: AFq9FYLXV1t7gYOl1/kGfF4KT/JrRJGlNZVwyHCsKn/K8FbxmDMW4/M1
	VjRjNTX34qeDZVLujQPDmJ10zeXOP1Q2ye8fdG114HXMcnlflnfRPjYK4Wkh7H9WyA==
X-Gm-Gg: AYBFou3O3k+aiN3UtKJIlfuHsEdqRFWOPz5jcK941xt4D2S21Kjfh0HXK+oCMMrS+X+
	e+QPqQijNhaMxXYSRFvUrIYBxR/Jlhr8NLv/gJIWdEY1YRlueA19LeaUb3vEEXUxJYuAbhJSOLc
	CaRA02JtzynPksf/Qr5maxbfzVuN0yO+yK3yOfoVngArUHng98kN3WePgApQ0RCkXhd9jpfKtYu
	BEwsYLOqHuESu5ijPBcfYljtpyehkiMG5hT38tk0gGKVYIUqLPgat216KONrwhbTvnsW5ENAeFx
	C44/Ex4pn/WnPZsTnvxglFQn4rAajfMK7TUaMJCuecrvz2AMNo/cnaTqDo7mN6RR5K/6MZU9SIB
	Q7quvNGVQjqQvFP3zXCSVBa3uRpqly+eMbIB5Wdnk3MupWn3E/HbY2EpQ8nhqzTw04hD+nCXB/N
	XspbJEy9nM0/0HNKaVaKYw0OOxrUdfoAHkGng7QFFp9xAOoz93olrOJb0V0UPoDZt5wrF6ZXzoh
	v6oP9tBB7GC/Hzw6H4GacKjR3zXEckeIeN9vMpHcoQhFTUm+IMsD4f/r3+dsSTCZejUnwNDqa0/
	ws1TYL5EbDH7zdLPMOc6giZ28M9uv7h5Jo/r47hOdmOUQw==
X-Received: by 2002:a05:701b:2051:20b0:16a:f5cd:365 with SMTP id a92af1059eb24-1909fd72082mr1003892c88.5.1792550592171;
        Tue, 20 Oct 2026 19:43:12 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:97d1:a8be:236d:bf79])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19035c0c9a6sm2392047c88.3.2026.10.20.19.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:43:11 -0700 (PDT)
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
Subject: [PATCH v6 10/13] zram: introduce shared decompression streams
Date: Wed, 21 Oct 2026 11:42:20 +0900
Message-ID: <20261021024236.1787884-11-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
In-Reply-To: <20261021024236.1787884-1-senozhatsky@chromium.org>
References: <20261021024236.1787884-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 538C8160002
X-Stat-Signature: f43u3xcrpqx4s6gkjrqybb9ug4mbhqf6
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792550593-848840
X-HE-Meta: U2FsdGVkX1+q6eiEX/EvuYCZ32uJ8ABBDbHqmyrBdPNkL0/r3ri7eRjIs7vsO3YSK8w6cWxgfZUqBAR8TzJ/6y9IUB1yaM9pUCx66dAyxrolfKIOWNROyYs4L982HC1cDkvc4WTk55IPYyeFlfUD6zOIKWQd0Csne4sRDIKJKqnoT4z3hVQDFDBk8Q5JkuFDFCkmTaPmREY15JKtaz2M4EmUeK+VWf3+s4NUFhndgjdFOxeUxldL8sccV44se+tHg+lydCBRP5wMhyBIi5HOsSti074eMCxKU/7Hz/f8QwPgIotTX//guqNdk+To9M4iUewF6AilB19DY4p1OzK9Kk7M4J9wSG9i2NS82Dagvwx5LhERx6RssjH8nNM9JPEWP1r1TeR68QLMorPSTtqv6glG4Wkgu1oBgB5Zt20bP1XAst560FlHpezXZRU06tkpyU7HYtro+2kd6awbZvrbjeIN7HB4p66y9GqMKFiOL0LHxwtYQhFKuDOsbzyQAwGA6r8BWUWCz+njbIk26UAgNJpj16CEJO6B0/2OnaBKdfXpJONLEyDzCNeHYkQBwYSI4/22GysLW7DOrFGf0oa3wEOz+XzTrXmTHqQKhSpHIDcgJe0B39hOA9x1vNuVLfEseb1KlCJdGfOymTuulZuRLEZlT2wEnkEM/sol1RUA8M9R6RY6088vx0MWH3f6Kx/SsOE2KGM7XGe+8cD/lDmqhCl0vkyvMeRbocRzC01CjgOmXCq5MRoO/etiFZGfkcSZ/Qxj+Cdr0m8KOztdGS4uN7Hd6bNPQNy7K9MgXUumrNZJSn9OU7LqcG3Tv/yGZleo6lH4d0XbHdjXCiw+2NVLm+jTrL2VipnVPEaLO3MyD/ytXY1zNX1lo5xVMUK5ZFZZqQGsF1mWchUV3kU53O+orQGbEUFjLeIwyhKoB0TnDa4eFTVP94jWxgOvpxeKu0LKqdbLbPwcSSEt9RH5+j7
 tksXS6bb
 y0o5EzgcY7PhwRhq1N59nOmbLEJy1g24Zl2iI3B/QQ+ZOzHdw3lfmYZuCbFGG97LyV7cBDnwtz+svClgC3xpZyQFbBxlkYhLBnHj8oxBh9IUCswzCLkG45hFkDE5aB/3sSelWwtZ9xx2Gg2jQ17n7nFv7/b2+cvKAB4wnfY3pT1YGYfbl5PuldN+N6j0qLHNKoHsrmXoF7gwelGJ7SirXjTa9/rxPdDxTFpXVOy0y2BcJSujZwAV6zY2uqf0ose9WX/FNGxPbCajdv0JCy/PITVS+QmSgkw14ZxSiPMoGzZzT6fNwRzCpXfwepf7m6AWQc4h3nqIbo6ZuScg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
2.56.0.212.g129ede20d9-goog


