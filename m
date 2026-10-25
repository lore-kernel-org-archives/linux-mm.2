Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F4D2606A9B4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 02:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=jTD2vOIL
Received: by kanga.kvack.org (Postfix)
	id 6E1326B05C5; Sat, 24 Oct 2026 22:19:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643356B05C6; Sat, 24 Oct 2026 22:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 559306B05C7; Sat, 24 Oct 2026 22:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 20F606B05C5
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:19:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F2691C3D54
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:20 +0000 (UTC)
X-FDA: 85359541680.18.4CA4BE6
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id C9F721C0004
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:19:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jTD2vOIL;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792894758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G53yd6495YZjDK2uTViEdAV52YMWKJCQhSrCD2FaT6k=;
	b=nIwi3Q9K6IPXQtLypDKSU3LMi8toJM6akCWEHoKSrTXLKvO0IeSLu7azIHq7o6Y4iR7M91
	wBYHG9AIOqOUsJHIajWlC+pu73shqf9MSeaGOeu8UJXlK6+hEDgpPtAp+16CGGDNbDeki2
	qEdZxbijW/9Wngk++5OPv7bFDMfoVfo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792894758;
	b=uFc4Z8aq5e2AY8d8MvoU4+xdF48EAQ7Xh5nK3O+Ls/Rox+1nCm1kALIntTv89TvrRG+HD7
	45Gp4NN2xTGEmrMrjTgtp1h08PlZVGjtqxZQDIWXz0a9JKcCTusUU5Zh7E1RHDk6NR5IGH
	gapiaLYKUPNgIjYn9PsNJbsDkYy4w8g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jTD2vOIL;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.47 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-156cbe59524so1123100c88.1
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792894758; x=1793499558; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G53yd6495YZjDK2uTViEdAV52YMWKJCQhSrCD2FaT6k=;
        b=jTD2vOILpWJR5ILCt03MxVia7ulpIMwBca1Q9ngaMaoQuocMLLzzJe7d1sncTVWv86
         HfLO/2VjsNLRjCfprYqtdEPRqWm6TLQ/WD6BURIjiHdU+TWEBHH8qmlw8AJ0GyCPsWRi
         4EmyMh0s0kT7xDOWF0AFgaaMuFpIYnt3sILAo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792894758; x=1793499558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G53yd6495YZjDK2uTViEdAV52YMWKJCQhSrCD2FaT6k=;
        b=OQ1IvC5LK5Og5RNghafeeZdLq9Maingx70pCKqv08PS6inKD8SSMzD+d64Fg/4UDYk
         xQZiJVlc9s7yN6SRtoafYvMT3AyjfF4nlQORZbkW5TSnyveVfjucEnGohDlLu0CTQPqT
         hmrWsLOBJUXIfCagXBmtcbZRguql3Vt0cVXcQp1132lLhDzzh7cbI6Vtc+fgrkCa+aEv
         0TyuI5Q89AyTKSKWfpxv5BpW1kNs1fR36a60x/8xCKPqMVBVaTTas+sgljLCNhQplq8t
         WaC1V8DHpBC5c6WlpdV8/cPAkqMhwHLxNf5cXID0y24758ZJsv8mAsQZrytOnJgi+Yxg
         CbNA==
X-Forwarded-Encrypted: i=1; AKwUvBxoh/npG8uB1FLIz0xE3R5nAOe5CnnKAbozPe40RUSsvXhlzZ7YF6BFWZzB07GzPc7a2BuCkloXkw==@kvack.org
X-Gm-Message-State: AFq9FYLFhecnG1xACz9p3mPRI91VkD+8hITVmQCrzsz16id0xYWwWakN
	EyQ2zy2ggQoO6f//iXRs/Oj3IxCB2iKAjy0R29l8EjjVTfJq+K/IFT+aQTCLxVwR+g==
X-Gm-Gg: AYBFou0TpIqssAAw9czmunlGjsdH2YKyJYP30qwV3JpnMdI1tn7gwUCrBCvK3rh0NtA
	x5HybJeHIV+3HqYgREO3cVcA5h+lOcVvAAuW6+fErkuVuFhD3stK7pQeNLxc8J337fZ2oAwxHVw
	ibE12m18MVnHTvumfNtX4TkFZDYEWchTM1MecCoatAdkQq/Gv+hJPw4DBdukMUYkR288Z85kOWA
	Bt4zsqS5UGbBrFhyJt9zBH1UCXm/KVsSzHMICGRLAfbLBYDNHdK4Lv9ZWQMS8mdKhONPw/2OcGY
	Hs471VKzTGR7v3juWkzh5/wz5v+xTN+DWo+Rl6j7JjlnKddIjmxiMA95S6lE2FDmNqsYsskwFGf
	SKN+Agp/UfLgw1lZ7TcuZT/mlA6xOLyJEv1LPiZk4FPke3r0Bv4tPg0yOWtb/aFQk+o1G6DZ48a
	MmKjjjyT5lEsdZgRzU/NwmxkDkFa/llOSYbRKYFuUgn6aLDnSu572VU75rG8fMrjrKtwQgiGxKX
	uKQrqed5fvm+PrNrKqr7SH9kjap3UtguHuvSmxpb+u2tKPRcPfVt2E3BsYUxYt1h6UIvClFSktF
	wEGYG5iXh73V9TMtofjAHGGi17/6xZCuvz/3SyUIZjgF
X-Received: by 2002:a05:7022:6283:b0:14c:96a4:b631 with SMTP id a92af1059eb24-1993702493bmr6104831c88.30.1792894757489;
        Sat, 24 Oct 2026 19:19:17 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9f87:66fc:8c85:11bb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee5asm10387242c88.8.2026.10.24.19.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 19:19:17 -0700 (PDT)
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
Subject: [PATCH v7 14/15] zram: borrow idle decompression streams in exclusive mode
Date: Sun, 25 Oct 2026 11:18:30 +0900
Message-ID: <20261025021839.1542805-15-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
In-Reply-To: <20261025021839.1542805-1-senozhatsky@chromium.org>
References: <20261025021839.1542805-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C9F721C0004
X-Stat-Signature: rcrcu95trnzgozizbpht573gxbu6f7ha
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792894758-833557
X-HE-Meta: U2FsdGVkX1+usA6+N+eWM1TzIvJR6yEZ2M/cCsf1Kjo7Mp+3hsjVnKD3LxNrl6NbiqxnjUM8dByxURWdeoRWcApplbKz05Tc3RN6+gBB/ow36fvmSNJKOC6qUkvDrxDuDKZPrByEC1jSLoVUPs3A2aohyYhCZKBpAX8AAO5BS8mKfbQLb3/+3tsPZlBP0jVedVdnXjq5h8CktMsvnsbeYZbiSyZVAEm+uL8oOAd4liG+uxFRujRL+bLCeHYau4XnJkccp0WnzoRtNE4v0ni2bfgw5LNFyJ+BMvwakOBTlMH5PTRsbbuCFOryxzJGz1tTyST7BI4k3OS95tqZqkVs4nRjuX4BUXXLwoyUSdqheptgcRiIt57NamuYwwQOhasnxBpZnLoc9sDhPvswGagGZIN+VD6tNNGsGV2nZ9Kby0J0sakjSF+YDKB3cw+8+66DIHKWf8stS3yY/1X2BU6GjPxkql51+fEaK0X/qvT0dGp4dx6H09Dc7/xPBeN4fjKdMtB10S1IsuYrPlxKyrdBLLr4/I42tWpJnsjKko51sl57g39GOt1eo8elEXmgFPqbZ1p8uWa7cAshSCx8wrmx6IufZ6SCPZUczkwxr7hISg+G+Eih94BZBNQZra/ZZsQCyz9qM07UIGy9H+dyU6aOoC7cGUItNMU0EHq/Ug4SRZlLg16lt+XsfH33tIN0B4+Bh6+ObkKyMN28KLLWl+jFNODzQARpLytRhhHIDNZVtpO1lTwq/nTLWaVTZg1y8c/o0e5F/6R4cy52xyCrXHvMPDpj6xFi3ecY9qon9EMgTRR83Siz9TzAOnJU4iIxFW3kwdqk2h+WG5YdQZifzQMKrwIX7dv443t/+q56M0/cOzZAYi1gb99pl99vxAv284/nCCC2Sj0sj/D6tilyQ/5YjEdqvEeGcvtPGu7VV6tKfjBAxi6Zp0U1dqYQE83jxNuUccioaQgJYqEl+w8KBlY
 OIOaLkP3
 hn0HIYkVDjGYmYnm1iMdo+R3VdTxm60DEz56lzFL2sf02wvAMb0d+IAoYDyAp99gOQQVl9YCfgb/tKIp4/5PGrPUFcnZMj6Ge8AnR/C0RLaYEQ2aJLrEu1fg4Q0YtMxO5IhndHJzVyoeRVI72ZYowUzGtHxnaqIYJDBFZg8r+E2baUEAWpGIWLG2E1sCn67aR0fmmiqG2DWj8K14M9U+JzdaYR3irWgeb04Q1m9cxe9rLKeHkbQKTWnS6gzxo2jfB2J1NrnPvykSmb+vUjg7JGvYTahGGbeoZCxVIRLPZkEy7c3aoJvgMGxpZcbQvql82CAo/pvaB5/9zmTEaA8i/y6ut/aGNo5PVTRm3QktATAJoc9PlNPHVBNy2VA==
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

Instead of unconditionally blocking on the local CPU's ->excl_lock,
we can scan online CPUs starting from the current one and try to
borrow the first free stream.  Only when all online streams are
busy, sleep on a per-zcomp waitqueue until any CPU releases an
exclusive stream, which significantly drops contention and wait
time, per Bo Zhang's measurements [2]:

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
  Read clat p50    7.58 us            8.85 us       (+17%)
  Read clat p99    14.27 us           31.02 us      (+2.2x)
  Read clat stdev  7,571 us           31.92 us      (-237x)
  Read clat max    3,555,300 us       6,288 us      (-565x)

Reader vs Reader with CONFIG_SCHED_PROXY_EXEC=y in both kernels,
21 runs each:

                          Base                    Patched
  ------------------------------------------------------------------
  zstd-3   Read IOPS      1,055k (+-160k)         1,045k (+-50k)
           Read clat max  113 ms - 2.35 s         2.8 - 6.3 ms
  zstd-12  Read IOPS      973k (+-175k)           1,045k (+-17k)
           Read clat max  135 ms - 2.34 s         2.9 - 7.5 ms

  Welch's t-test on IOPS, 21 runs each (patched vs base):
                          diff        95% CI              p
  ------------------------------------------------------------------
  zstd-3                  -1.0%       [-76k, +63k]        0.78
  zstd-12                 +7.4%       [+2k, +149k]        0.073

  Runs with max read latency over 100 ms / over 1 s:
                          Base                    Patched
  ------------------------------------------------------------------
  zstd-3                  21 of 21 / 9 of 21      0 / 0
  zstd-12                 21 of 21 / 14 of 21     0 / 0

With proxy execution base is about as fast as patched at both levels
(no significant difference, p = 0.78 and p = 0.073).  Base is noisy
though, and its worst case is still 0.1-2.3 s in every run.

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
index 8c0fe34b7a28..8d55b1104b76 100644
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
2.56.0.257.gf7497c7d27-goog


