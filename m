Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11969CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:45:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9D146B00A4; Fri, 16 Oct 2026 00:45:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4DF56B00A5; Fri, 16 Oct 2026 00:45:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62A76B00A6; Fri, 16 Oct 2026 00:45:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 894186B00A4
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:45:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 126941C2973
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:45:07 +0000 (UTC)
X-FDA: 85327249854.14.0197B1B
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 43BE9A0006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:45:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OUthYxfk;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792125905;
	b=zK+ihJEwUIoO5Nhb/qde8EpVPM8cqRGohEieUqPvwubQ+pXP9b44UM5UxK3B4oeeOp9bT9
	ZcbRJ7quHFbi85UguGnTQX9pbI23fG0qq0V1XJH5IimH5qxsH9U2GpCYr95uYCLnogWx+K
	IOOXZ/vOju1OBMNOTS2dw41XBjyIFGc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OUthYxfk;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792125905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjViqRwAMEG7zJkwnYC4UEqQagXFhLBQpmZRnR3MJEU=;
	b=qBYY5NALoKFXxFcFFB7AQUoTFYDrH4xGWU6O2+RVe5oIKg06t74gRQWizPc587YlksGXMz
	5CeMVgzFuM2dGrMBvrXsVD2Ln35l0qrUdsVwTRFw/GrDMZyHsKgpfoaflSTDiXxixctjA5
	TcwbwqPWsLTqZ+NVhZHA1C3NVI2650U=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2dd9cbb661bso43874005ad.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792125904; x=1792730704; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GjViqRwAMEG7zJkwnYC4UEqQagXFhLBQpmZRnR3MJEU=;
        b=OUthYxfkrh93bGkNkcIMtfw7a+9d2HdhUSd6IRcHEd5oQOF3CoMIf9oMdO2lBOiXrR
         AFNWdE5973eHPQmNUhB5ros48kTKpwPEVvGg3GJxgxq3laqUaLatPnWmoIf+fjhjLr2l
         e1KikR4rhjAMLF338GCyQYG5Dvc0iHRkVQNLM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792125904; x=1792730704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GjViqRwAMEG7zJkwnYC4UEqQagXFhLBQpmZRnR3MJEU=;
        b=LpxdfA0ndUbcgpuA+7/KtHV87jHe/s2mPfgzy2YBfTWuTj6IHKjF/77U1mp/i4gC1S
         sCGTxKJvrs/C3ri+bFv3O5PQq+0gMrEJBTcVCJoQO6orp9Qvd6ketEY7mN6ZXZZWrZz2
         Xjcg0Z1uXEr3mi5X9DQ+fFlUsU3wC3mhWj8ixVDsb2xP0ShvTU37Pp95YRyvTe/G7smr
         zJTB/o3KdWXdGpeYfThvVy9clVi2OJLLtvNwe1fuJ8JYdQgIvCw8PPt9w75GVYbyZPn7
         b7Z4VPGK+MS277eoYar78POwS2s0JK9tYTlwp81pvyOtztTuGr7FaeFlHcGg+rkIjPGA
         80Rw==
X-Forwarded-Encrypted: i=1; AKwUvBzuIcvkQEauu5E6JNA7yA09yiMjlIJj0wvvo/mXqVj5KmF6zVwL7K2iVmtCl+dCEHfvdBhC9pZceQ==@kvack.org
X-Gm-Message-State: AFq9FYK44KuH/6pcUBNqt6cuVNg336K0JVxa+ujtIZyD2hrXXgbHsElE
	C301CAimNLCVIoSR/3Lw6XuOkuKI+ebITnFCPV1Ao7JkdNL7UTSeKPYu8335t2MSIw==
X-Gm-Gg: AYBFou1LJaeBiby44z8OvhXCgkxWsH9PABg5K3Fqdpc85mj/seZOTcZYycpuHdvExZI
	iMpvXNMNw6UeQxQ5vreWJM8NrWavKIdmsk5Jnm8cy8VLwnDhbW0U9sz4kDW5spTy+PwVcoNDG0y
	Xw+xSyvDYz8jGHCz+begvU5aKvLUZhqb84Db3Mv/R9zDksgDAoEg+XFEYGkkhtOzBvZQCGpJ+cC
	YYhNnM/TmKFK6flk5pCom9We3/6rQlBGkZRi2Z8MLe4E2LK3f3yooeiRLEAoZlRr9ierPdFWtC0
	A6ABu72JVCH2nKR+VNLVjX+tLlwUHc0tHDdO9TADu4jJhI58CMsKg0vRSBEMgY8EJlbJ9q0IsqO
	RxjlHrZ/TyEDk0pgQi+OoHGwSEFLrzvpo79eUX6wqHtvXEJUKG5t3E2o7bjFdLsuLnLLJagj43K
	f3OJpARlmFVj5bZqZYLtQHnJFEIIW/kjWd0ub3XH0b+Fcsig5b5IVnLHNHqJcMI/VG4ZeRG+W17
	JYM4TUaEWqmRP2MjZgsr7NijSXqHU5gir44dJeilPpodJ/8nyMaFKFnCZsD6DevMwHtRd4NZ8zj
	D8qD9foE5+72E6Jw3qMikaaQBHmyd2i2Sqz6fkFzGQNU
X-Received: by 2002:a17:903:230c:b0:2df:4876:50d9 with SMTP id d9443c01a7336-2e8429a58b9mr205540725ad.18.1792125904178;
        Thu, 15 Oct 2026 21:45:04 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:a579:8b87:8304:7ac2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e8b1b5esm4137235ad.67.2026.10.15.21.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:45:03 -0700 (PDT)
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
Subject: [PATCH v4 10/12] zram: introduce shared decompression streams
Date: Fri, 16 Oct 2026 13:44:15 +0900
Message-ID: <20261016044429.1304561-11-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261016044429.1304561-1-senozhatsky@chromium.org>
References: <20261016044429.1304561-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 43BE9A0006
X-Stat-Signature: 9s1cgbehdqrrq3qssgc63ng51aye5xyx
X-HE-Tag: 1792125905-968963
X-HE-Meta: U2FsdGVkX1/99L3E7p2EaIezJyR4VFx1LlTVJ3SlGBtdHaP5aeBDH2bkHbenbdmwnYV1AfqnC+WhOs/viHpOT5XiSPLC29AJWY1zrc/15QS4vewgqIlxhL9KofjQ35gIdvUXPup1p0yb0cRjqF9bg1CykKWCXLnKImbMhLjlpyZTLeM0JqLWJBXaHqfEIIK/tSupasrMKuSySnv1ZLa+AWMLJABg1sRx8BW7Sl8T7XNjABGTY5oFDKqHZwYvcaTlFVDsPWRc6OcNhJutzObvFGN+bbFW4D46m5vAmUKqobnZSyzoEaVwP9VPeul9gxyJAWazGrXw6DKrbDwD0MPmlt3YfQgLUFiTodQ8F2epJy2HTSV5zLi0Per3vqX292F6+RLRgHHZ6AiXUtr9aIpdSM7ASziBELGs4LVmRQtmgjZqZdvOOC9wIbLU5kD86dUDNOhQMO6ZksqIEKID/pF63cuIb6feAr5oTa4Dzfodtr5DpYjt9AWgFK3O3hDI1ftYcGYuod/IYeijIdjh9M9emmqvwfF4HUSpyfQgqx4ZhzwqN1MpIJT9zeGTPHc9AwDQi0rIHS8wNpYqlRZlaR0VvsrsusJYVNDmstgUEAcANKtGycYmLg4iyhGSQnHCKZh2vouDT8GMp2QgWSe0neM9CO2BrjWsk8bP/DpXa9uerK5WGN76/JRvfAe6iyFE0M8e3vLgyF01H7gJkUrRx2AtdFW88z1fQu00h/aU910R1EKgsffGzokVcbiqpTW87iDsiMlAZ1TdI2VPZoUpOq8S14s2zMCYGyPXxz2zOJKuzv53BIuxA27mWrCxzpAK44TdmJ10VmwGraICKDDG4alv/rZ6ZIJ/ikyOLKesIfLkK5R+lSjOBk1jgDfIR6HdIGfDgZNS+/heSocmgohEb9Mv+pc4a3TP607XaHGMLv2UqxjQsqiFUI6VtOCUQvWv+O3bagKNGUp8YU0KnIzVlXq
 j/Mbkqlt
 tBJZaVSkVllJKxxSJNq7rSmEBSD1keNj/i4jTV6OWhMkDogtPtDRNqJSY8LklwowK2Poq27DAnex5R0NJQ+eyDCs1l+SgFe4fmjjCPX5ZXC1d/naMwiZGssFQjTH3TtJ7sZtQRMJ+En6xwE1cZTjXDuvMr/lMw71s3NQLVK8iUb7VLbcwIP3XD0DlE7jdzwszV0wPf7gZtbk5Ika4N+XhMbOBI8PwqgxDhMLSucD8T9mPNRhze9uviMrF9gAc2JSfCwz8TX3r1AccvJS+BFdeCVTdfwLIx2qKLkF3hkYhgTT+EkneAVafvr3B/P0owRTtz/L+2Mv8v4oEYKo=
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


