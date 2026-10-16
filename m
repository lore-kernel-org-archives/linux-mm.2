Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A28D2CCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 08:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972286B008C; Fri, 16 Oct 2026 04:54:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9212C6B0092; Fri, 16 Oct 2026 04:54:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837326B0095; Fri, 16 Oct 2026 04:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3A86B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:54:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE2F0140302
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:54:33 +0000 (UTC)
X-FDA: 85327878426.29.795CA69
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1DA84100003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:54:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=k66YsBl5;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792140872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tm0sQY97x/sO1vfolLCcmx0x50wapUOdk8gJkzj/4Rc=;
	b=Qq/1pQlv3hS5fDDu7pz8o4crqU6WrJ2tmN49JK8niQ7HvFEDCTFdPaWjboRLJDJ9Jnz0LJ
	ougKu/V3yPIJPf74Ar+bHUw/4THlrTyzLZvSzcZDcWuxDYTavS2PUf7bhQD1AlVUKn+5Cl
	TfXbrcTtoKJBbUr/eXC354e+SS50KeE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792140872;
	b=A0GMfOE+VUxTubg/CEb7TIsDpQk97gHaJNchI/icr6ZbIoHSHBoVtLOfxu59/vM+xOaJAQ
	DbW7G2d7QhhuLgI0ayCsLfUb+8sMhjn+AtMGHUZmwNcou0Ig6HZIe3ZDiIVbm/BnD9xE4m
	Vj3FEknuKSybIZWrP9/tAYPIf9NksQ0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=k66YsBl5;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ace1f3897cso8938a91.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792140871; x=1792745671; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tm0sQY97x/sO1vfolLCcmx0x50wapUOdk8gJkzj/4Rc=;
        b=k66YsBl5nq4frWobmZRnSWx+FanrUGHixmf/FoO3K6f9CcPPbYaifYj74/v+TVKHtf
         3vVdl2N/bJk0azKkiDAo5o2gLxjEMqq2ZuLPtj3D77uVrg022TIYY5lZgoTSgy0dstSY
         rS4Tm3mj4OQqFv6iHzBZr02qvMLa59gSTo3Zk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792140871; x=1792745671;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tm0sQY97x/sO1vfolLCcmx0x50wapUOdk8gJkzj/4Rc=;
        b=Zzzo0k0G0hGEPQjlB1+9YT11PWitar9bBsEydGCEAQaDRfhvY+uw2En0FGf0hzSUJb
         BNIV/TDEiiDUwQiD3bvseFUdUenEXZ3GjcqtzmUWnq5TdgBGc0DPjyKCsJlU0/s6brqx
         1PiB+0HphenDoZKH4UHwl1Z/SsuzPXqzqMij/KH6f3dTAIuZ75UKk5lxIKbOI/HSwIkQ
         rzS9026M3wOjrZnWnoOmuAYB2DkAUOx8qFDMQtzzm6h9y9mmScJaGo6CNk4wCpiXVc8+
         r6c6nRXdJ095b6fy33op5bScUCsjFrb/kNc3hYAJeEdjCQK4gdUPyA0np7jaPWTGfTIH
         J4Eg==
X-Forwarded-Encrypted: i=1; AKwUvBzhAMPG3536NFjENKexmA7Ctqu//9U3eOKfZnLBwxTe3B1RFnqHvmYLd3CMEWXwAtc7kQtbpZ66AA==@kvack.org
X-Gm-Message-State: AFq9FYKaGLlywne05yTokYVqozxo/BLtzCOnlBIwEsOkr7fJK8gCjW5o
	Jzmfhaj33Ve6oE+0whvBFasYoPJOalrsKP9GDUSXnmxe0m6ptJdPJKm0j7y8z7KPMg==
X-Gm-Gg: AYBFou1xh+AGMg5HqEmN3Jg1L61DKt8hQTOGaHWwWCPho52Q8fahW1oVr5RHzI2D8Qc
	aMhe4heXIfNJUmEAFLb57lQJRQ7Ca/VLI4O9tcA84X/vYJooBxLj2XMjkLYQVGAhJtOgJ+4UsxQ
	ERt5//w6UkUjggG1XWfe6XJTerhLFln1TIXduML6WK6eCbu/JWLBmKlz5WSoA+c1p/0IxftSfYI
	7EKV+r/1GeGJ/M6KrDz/KXYuaANzRk1TJOtFZi2BNocRGCOoeR8Ei6kwANBp1ANrt1iu+L0J5Ns
	ZhYJJ6Kj7+TnrFYyDsgkAr1hK4nBgJ4gM8F/LGSHVYoaNiugsCzEsNjhCKYIOL0pMJ3SURcJP6W
	tBYCCfTGXcm8M6/X0ak9zZ0JJe/sCzcTGqGLjFWBv/PZJDJvDRZwUNJ41U/rXQA5ftKrYHzaYsc
	+FKnejxMst2BLqOAMAzl11I5TkAbvlTUG7ncaFjmwZOww+AMtzBbd/ZPa3c2E5RMCgmIP+j53qs
	/q0yOT8cT0r8dF17x7qKzE+hf82T7t6sCKPvqr+37crQA8UZNAEyu+Gpkzl3a4ZOnLT//v7Sh6j
	+ClNWVYXglLpPtr29ALTuUeD7Q7FoxWSNn4aZTVshg==
X-Received: by 2002:a17:90b:3a48:b0:3a7:f4d:b23d with SMTP id 98e67ed59e1d1-3ab3ac790dfmr19469341a91.52.1792140870404;
        Fri, 16 Oct 2026 01:54:30 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:a579:8b87:8304:7ac2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac945e74bcsm8425589a91.3.2026.10.16.01.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 01:54:29 -0700 (PDT)
Date: Fri, 16 Oct 2026 17:54:25 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	akpm@linux-foundation.org, baohua@kernel.org, bgeffon@google.com, minchan@kernel.org, 
	richardycc@google.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v3 10/11] zram: use rw_semaphore for decompression streams
Message-ID: <atHftz13hWzGludk@google.com>
References: <atBh9xfpOji_A7A_@google.com>
 <20261015112440.1491168-1-zhangbo56@xiaomi.com>
 <atGPwJL6XzlRaMva@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atGPwJL6XzlRaMva@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1DA84100003
X-Stat-Signature: 8ezfjh5p8rx1sermyb64xn4c6qwi63nk
X-HE-Tag: 1792140871-177424
X-HE-Meta: U2FsdGVkX19PxFUtAiAQWYAKyzF/QOVNFtfnCRur4ggJA45r44TOIi+nSRoTipIV8XB1k7seDWJwzccxMVYjsdJFxMxOoAZtIcOHWkNfSZCNY7TgpdFNvMThVdsUq5tGE6HH0p1yuhXf8ElZsn5JOlBghMFdigaGxoopRUKf0uXiufyB3axrIj5v+pqvINOyYTWFUX3GVWQRtX75Il7Hpz94LilyYglC3dbvHaaOsQF4qysR6xYLbK5r5975PEqkywz5zv8lsQva5R35TdGoRy8I0xIA95Ns3ZoGuK040RWit+PBFqhP4PXaRch9X6UvG8mI0yxYw4z9CeeR+KxgW8GtMDUee9JeApNAhrVqaeml9wTBzGQf3W0S+Q+GEgg9Gwjn+72EyZsrq3xmcuCAsAyjlFosyAHvMNvdolkkQ6/hTRDEpdBlye0FZ6+7RPiEWG8hCYXNi1bhG2KsgnSPPS1h3iu+/QqRmyqSZnVyasRbbgsqCYixCyIWUJaS5PDha8vhYfKh0eCJmzUoAOYKRxtJEwwVy83ZqM8LFUiWTAXYStuUW5dUCOzYDnoGBmCW/dqvRuzkVJbfYRrieHhR04esCOYB8oBR2DjJc7V2GHYzVFH940N8KpSmjr6/pIFfnTYXIrmV4OESqUvgxjsYEohVSeSBgRUTitmAOb6ZCyEaOzNQ5+NQ/rfwHyc+e6ccz6p3NpFqODiiGLxSE/uNWSxj4iODnaB5vwjoo6/qIlJdlr3q6HW113A4JyCw3tMf8OCI2p6ufKv/mL+eSp8C2E7XBA+SoKcYLakndpVTpUEnH9sIVL3dqQMA8I5Avswzm8Nwq8KUI5zTfpo0jv/z/gDzLZRpBOtLt6V2TU0GtlBaqxA8gMjqjgbqG8rpJcfubIJ8yIKNzkBpHjkbCgfAjM7PDOb4c0wUN918b2lKjaiwBdaOhbLw85EV/fW13WJdFDtblESAiWGfQEfbC9U
 GcF3p72X
 040a7pkhdwUUAd62YTt0V8ZKNyAlqMIuSax626k8r3FVJ0NiMa2ZiV3PqGlYY1cJDMem96gz+e6wfGvZgI7+Hdd9Cwe3u2raopQzbY/HvA5tF8U59tOcHPvdCcs0oATQyxZYqy1GgUUvjurP60bcXPKnyg/I3oMRbvsY/LgwXXQLBF+l8v/7pKa3L3sm9LxMQ+L81SIo44BdBXdIhV68IedPXO6dF4haR7CNQ2vN7O/DDD2ja5xP2sv6xRepXUFfbPzfCfabxKOOWHqGRU0mXfdSEKLa1Pjn0kfbqhyA3oi6aCwAscnqdptWQU8IdQD54KVBhl9hyDTGMy7c0csidawbZtOAanjy9Ya8QZgxh8n8Qo7lF8loZzSpyzD0eWAID8JYBA2k2yy3FVuTDL+JSSLlNPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/10/16 11:50), Sergey Senozhatsky wrote:
> > zstd backend, same A/B workload, on top of 9+10+kmalloc:
> > 
> >                        9+10+kmalloc   + preempt-disable
> >   cwrite_contended     14,880         48          (-99.7%)
> >   cwrite_wait_ns_total 137 s          0.32 s      (-99.8%)
> >   cwrite_wait_ns_max   243 ms         43 ms       (-82%)
> >   dexcl_contended      15,919         54          (-99.7%)
> >   dexcl_wait_ns_total  109.6 s        0.68 s      (-99.4%)
> >   dexcl_wait_ns_max    145 ms         34.6 ms     (-76%)
> > 
> > zstd stays 100% exclusive either way; the win comes purely from the
> > holder no longer being preempted/migrated, so the hold time stays short.
> > It's the same mechanism that took lzo-rle read contention from 24,749 to
> > 406 earlier. So the two are complementary: shared reads remove
> > reader-vs-reader queuing for stateless backends, and preempt-disable
> > covers the exclusive/write serialization that stateful backends can't
> > avoid.
> > 
> > Quick and dirty, for discussion only - Patch below.
> 
> Yeah... I need to think about it, before I can join discussions
> in a meaningful way.

A quick and dirty patch, as usual, just to play around with.  This
attempts to improve the reader side, because the reader is side
much more sensitive.  Tested only with zstd.  We probably can do
something for the writer side as well, but I'd prefer to postpone
that, until we actually have to do something.

A quick thinking-process dump:
Our shared dstrm-s are almost non-pCPU at this point (we have a
fall back bounce buffer in pCPU), so we can have any in-flight
number of those.   Doing something similar for exclusive dstrm-s
is more complicated, because those dctxes are beefy - zstd dctx
sits at ~100KB.  And this rules out the "pool of idle dctxes"
approach.  I decided to keep them pCPU, and implement exclusive
dstrm borrowing (from remote CPUs) instead.

A quick (and a bit extreme) synthetic fio test for Reader vs Reader
inversion on 24 CPUs (preempt=full, zstd, 48 low priority (nice 19)
bg readers, 24 normal priority (nice 0) CPU hogs and 24 high priority
(nice -19) fg readers).

fg reader results (average of 3 runs):

    Metric           Base               Patched
    ----------------------------------------------------------
    Read IOPS        396k               1,064k        (+2.7x)
    Read clat avg    48.32 us           9.66 us       (-5.0x)
    Read clat stdev  7,571.00 us        31.92 us      (-237x)
    Read clat p99.99 5,707.10 us        2,233.68 us   (-2.6x)
    Read clat max    3,555,300 us       6,287.57 us   (-565x)

A quick note (the last one) - happy Friday!  Time to logoff for me.

---
 drivers/block/zram/zcomp.c    | 75 +++++++++++++++++++++++++----------
 drivers/block/zram/zcomp.h    |  5 ++-
 drivers/block/zram/zram_drv.c |  4 +-
 3 files changed, 59 insertions(+), 25 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 81f21bad787e..af1aaa1f9e9b 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -190,38 +190,66 @@ bool zcomp_shared_decomp(struct zcomp *comp)
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
+	/* wait_event() checks the condition first before touching the waitq */
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
 
@@ -294,6 +322,8 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_dstrm *zstrm,
 	mutex_lock(&zstrm->excl_lock);
 	ret = zcomp_decompress_buf(comp, zstrm, sg, zstrm->local_copy, &req);
 	mutex_unlock(&zstrm->excl_lock);
+	if (wq_has_sleeper(&comp->dstrm_waitq))
+		wake_up(&comp->dstrm_waitq);
 	return ret;
 }
 
@@ -385,6 +415,7 @@ static int zcomp_init(struct zcomp *comp, struct zcomp_params *params,
 		ret = -ENOMEM;
 		goto cleanup;
 	}
+	init_waitqueue_head(&comp->dstrm_waitq);
 
 	for_each_possible_cpu(cpu) {
 		struct zcomp_dstrm *zstrm = per_cpu_ptr(comp->dstream, cpu);
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 6764818d2a9f..39efefc43a13 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -5,6 +5,7 @@
 
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
+#include <linux/wait.h>
 
 struct scatterlist;
 
@@ -96,6 +97,7 @@ struct zcomp_ops {
 /* dynamic per-device compression frontend */
 struct zcomp {
 	struct zcomp_dstrm __percpu *dstream;
+	wait_queue_head_t dstrm_waitq;
 	struct zcomp_cstrm __percpu *cstream;
 	struct zcomp_cstrm *recomp_cstream;
 	const struct zcomp_ops *ops;
@@ -118,7 +120,8 @@ void zcomp_cstrm_put(struct zcomp_cstrm *zstrm);
 bool zcomp_shared_decomp(struct zcomp *comp);
 struct zcomp_dstrm *zcomp_dstrm_get(struct zcomp *comp,
 				    enum zcomp_dstrm_mode mode);
-void zcomp_dstrm_put(struct zcomp_dstrm *zstrm, enum zcomp_dstrm_mode mode);
+void zcomp_dstrm_put(struct zcomp *comp, struct zcomp_dstrm *zstrm,
+		     enum zcomp_dstrm_mode mode);
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_cstrm *zstrm,
 		   const void *src, unsigned int *dst_len);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index e608769bfad5..079f3723db31 100644
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


