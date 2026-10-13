Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F5F2CA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C03EE6B00A1; Mon, 12 Oct 2026 23:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB48C6B00A2; Mon, 12 Oct 2026 23:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7DEB6B00A3; Mon, 12 Oct 2026 23:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7359A6B00A1
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:52:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DFBB1140A4C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:38 +0000 (UTC)
X-FDA: 85316231196.07.A0A0242
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 12A4A140003
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:52:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=oMDst+Hg;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791863557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShalK9Y5U/Jls8Ez8QYxGoc3BlxRo/GgKG72kj7Los0=;
	b=DeoZwOJa1Af9jW54cXQR8YIrOfSQPPRlswnouC6jHNB5jRGLwZYjU9Ix5UnLu4L550Nzhp
	K42vr6iJLiVrKsfoczmCGf4xaE2Qy7Uv0aI9b3bNxq5TyghpMZrVjZGMB2Dm60J4wSEfER
	apTfNAdsHrpfhy71Eg7fgrL1Gc4rJCo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=oMDst+Hg;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791863557;
	b=x8xU3jgO2e7Ekg3JOpO9XUyIw1pGX4pgK3J5gs1KB6YhRNirNDxqHVqrdz9I0VktGjO33I
	GPg0Z+urQ/yBbOf0RZFqp1L2xHNlgmcfGN0JZ3YHrSCrSrKaVPVKAqyEjVn/cmJONbH7Qt
	3n3wpOJcSnOvLsmQJSB7h3JO5UA4o/Q=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8875d220446so1111580b3a.3
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791863556; x=1792468356; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ShalK9Y5U/Jls8Ez8QYxGoc3BlxRo/GgKG72kj7Los0=;
        b=oMDst+Hg4d5UoVmQp4Gwo1JLU4mk49H7s+wEBGHRkjghIdq+hujmy4CzYhYAsry25/
         3T6GTWarNZLLQf7Xl7N4g8GdoFXHsPOu4u4C9o/2Sj1zSkHHe1ijJEqhyU0d19jA3sh3
         /fVPYBMlPFhi7FQ0XdSuXqFawkfR0NjAwmjpw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791863556; x=1792468356;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ShalK9Y5U/Jls8Ez8QYxGoc3BlxRo/GgKG72kj7Los0=;
        b=r0mgHa8nOgfw9qLUykEaqRJJpy3eRyOEJ5PcGjvUCauNfuR9guWJp5m0cXBeqvkpfs
         gEgJRLQ5tw/pB3U0Zmz9YMgB6F87+YppCbfNy0Y9o8H2X73q5tollu6+qn9wIoIgxRPw
         CV0sdCwmZK7+S5TRzGUtBbGN+zuO9SQyK84aUalPibeHFmdXHYTNpbjPqEEGDvAK0ZlP
         iolGPO34i71FBjvEmcoYRmWbLOZqcUQu6RiDyKWKVxS73K8aBWW2axnHxUa/mffIoxaO
         BVg0Z7R0aB5kMeMtF5dSuqp7kv9nSGpfRiY9WKmxtryC7UVrUQE/K46/k0iFJ9jrPxZ4
         froQ==
X-Forwarded-Encrypted: i=1; AKwUvBybmwv0dlHPZSluw4/UwkAdrZe/Z70TuXYBOE2p6rxKjjOSyZ+PemERXDKfAZIS/koNF7xWzWNw/g==@kvack.org
X-Gm-Message-State: AFq9FYKIQIqFCOL7B8qO5fdCg0PgXut78D7oWYd41q0etTuVX+lmMdqx
	Fix7P5zR98ye72MPt1Pp50bHRk/MoUazmI/+dHH/MVRthVPuzQviLGy8ATBI882WJCF7rEVb7qO
	p31s=
X-Gm-Gg: AYBFou0jEpBYOFx8XonCEhFfGMZ22nIP/X//C2lpNJgqpEfMDGXzVk895cC4y5GCJsn
	CBrI7vN610qGCutZ4TSaCIupQcM4kM1M0kcuFhpJ6cRy9YhRAk++MZQ24dc8A66kN7p4jO88egM
	zJlvyt5FJ2Gs7yrQX21EyAq69bUc3FJuBQCG9QmUSM2mCEIbBCcctEgnKrRP36j+9yNJw811Nxg
	xplgzJEWeaUOcACQnJams/5sk1FFz/2ApuwQbhkQ9B5nl/rc23N58Rg5L0nGTt4AeOgdx3vI7oB
	75O2P+sQsHW9KFRPopIwjBA2XERzuuCtmczzQMF1Bw5Fa3JEoCHvZTa2ViwH6+rockQJd4s+3iw
	rEZ2XrLWzdPhB2H/Jtc9IZmg77AnG2QPQibg6XdheF+fAphpCtMyJkJz/VtRLmvbR78hd3Rh7kj
	zCmgLhgOxOfew8Im75fat8iJT+JVpc82BwT92yAG9xFe9GK/RgxLR5N/lyvbjUHWR78eyeXunSJ
	B/LZCLIF4a390Y84mQuRRxz5/VJgFuvHCqhaVaDIqkoxHI2f71J19WSZD7OEQ==
X-Received: by 2002:a05:6a00:3021:b0:874:705d:f64e with SMTP id d2e1a72fcca58-897c634e30bmr8648075b3a.28.1791863555911;
        Mon, 12 Oct 2026 20:52:35 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:476:d384:7c2e:1579])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c41bbb27sm4326818b3a.40.2026.10.12.20.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 20:52:35 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v3 10/11] zram: use rw_semaphore for decompression streams
Date: Tue, 13 Oct 2026 12:50:57 +0900
Message-ID: <20261013035201.2809924-11-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261013035201.2809924-1-senozhatsky@chromium.org>
References: <20261013035201.2809924-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 12A4A140003
X-Stat-Signature: k4oefp8ex74p3w8scm8znbb7ysrbucia
X-HE-Tag: 1791863556-149472
X-HE-Meta: U2FsdGVkX1/+Fzd13qhnjhrEtWX20V3MTbwo6RQwlv46GhajrjvKb5oJXlTkCH7/7aJKzBQGN4G0UmLHWYmeqTrqRoii05AASzy5DeOG0gXHQU/uvzy2jiP36hr847zLHooESdXuGHxI4hwCkm6ysyEc6WN/lqvJ+1CkK3frLVg0GkQsh0lgeQ+i5SnuAaN03M4/Ev2gCLdHv9R65pGImQpq9QLRuP5afbOIG+dhTe7MfTWXC6RdFc+GmQXtwlKwXX+iTnxAiXj2MO3woR8Y2/vAtz6PncAfEWBm93HNJFNW5e4F3EbwwrYZ+yAsRPAloEj+CiOd/bCXIgUPuwo/MZwvKJFoyyrHvMqve1MpyDjSTR26JUsuiHrwr69FykKdBrRjOsy/Vlu3HV2AZSYVEqSgnEdcUrTMbjCPD1betBh2LHkzYAKihAeZG8hH+Mg2xkmYFegJr9pMDtLSM+Qz6kNTJgm6PfKYdn8SRkPaOxK2ELOmt9D9yfAr2qEcteL6oMh9I43kvtNuixa5QG9D45p8xS+6q1KWkuY3/5dAqVa4Lnqkg/bd5gL5olooodQqanW4TeqV1FUxgztLSeAvklC5iWZv6C30hdoUb1jTEYPxKpmJVgmCklktiNICCEG33uxkrk38bDpp+ZOC7/feQttPUBfPYWGJT38CFGWJT2zRxhWIN4mJDH23eSFGy05Y2ROT858/WiifFYo89IWfTkByN4j0k6lxAHdRsdV9ruuPhb7O1+L7k1ElW4AFe2G4dfsGi2Vh3x4/YJK9QVm2UV0qWKlgzOUlZhVufUB9f3wu2hnXG3xRyvvv9KfIO5Rdw5N8fazDVdeo6iT8cswe4hGPiHoBqPZ1T5zebqbAmR2zc1ek7OVKABcsll9cnsb0FAQlMCa4DIi3M7XV8QM1SNV9YcYEd5voIlHm/Pb/rVU7hPXmWMSH/MD3mUgNybU5yenSfcgPT7bruii/KBW
 c4lfXKmp
 tKWCNH86jj8f8JBdaphTeoHeS7UvlWl0FU0150OIw+QOOy4OC8Q+7FzgTwHbz3fLSCqwwghGsGCLpEevRZDaymUiudjPGSOs8ArqtnzIDqi+gL8mklop07pLfr18ezbfi1/9O6W1D4AO+GnqP+jujewlQ9t7Bw8ORPgVjrXCi4xvjJmuDPydk2wSNjSKawyEewfBrZVch4/2t9NT50px2L1OsnbqCqwGpXmQ6TEoFV7tukfBlLKFUJL/3X6NbV05FaH2gpJusDZD+Dd9zCJm7gopoFSfKPaHJ7TWE0xDv1r8hSzeYJc3FEYFap84lY+eAJBLXLNFUqH/g6dpBHk4FEZ510WHQSc3xi5A5pNofGMEU3Xbak+09s5tE2g==
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
2.56.0.385.gd3acb90ef8-goog


