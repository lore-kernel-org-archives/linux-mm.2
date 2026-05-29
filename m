Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD0F1CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 16:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5DA6B00C6; Fri, 29 May 2026 12:57:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23B016B00C9; Fri, 29 May 2026 12:57:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 103F76B00CA; Fri, 29 May 2026 12:57:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F21346B00C6
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:57:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8212A161078
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:57:11 +0000 (UTC)
X-FDA: 84821062662.25.3AC7675
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com [209.85.210.65])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9059D4000E
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:57:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r6aW6bzh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.210.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780073829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9w8JzV6Ke6m6ss7khBxwWJgK/oI1uoZHRLSFhlaSQYw=;
	b=cPzuw7m5oconTa/3rO6hU7vmX6oaZ8ycuOvJ2+s/T1uwJNn0y5f4lMpu+C9RvyhO4euYEN
	wCbeLfP2OVzcILoL76HQTbP4CoNnZ9oUIJuW3sO045KRHE4nNOcDiscD9YfYA/gar4Fcpg
	85K8Jx+kn2cRnowXQ6eoURwf+ZOJCxY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r6aW6bzh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.210.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780073829; a=rsa-sha256;
	cv=none;
	b=aZ6H6iYtv8/O600ivPVCPf+qP4uDLtjAkklsIBf3vaA5UDgsjdOZZAZ7HiXrYv42hfmWFR
	nRKQgqvhN5eayIsoYf4ceAu4j/gL+AhTwNrnr+09GDfw7kVaVoF3+XKOhAv03Z6ww9KjBp
	uUuFXtzcxbtl8mEltqN4q8InDRDRXhs=
Received: by mail-ot1-f65.google.com with SMTP id 46e09a7af769-7e568ab0bc5so14538227a34.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 09:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780073828; x=1780678628; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9w8JzV6Ke6m6ss7khBxwWJgK/oI1uoZHRLSFhlaSQYw=;
        b=r6aW6bzhxzXYXtvMbOBl66npQV/+Ud3X4lb8uv3WLKT/IFXtlBEbzdD8zcliLmagfj
         bSkqFFOhfty4hfUy+emOyvfxfuW3DuctmoaWziaKG4h/OZz7XW0aY3GuMvn6H0IvVTRh
         fcAVP0ajrmzkBS2WJ2Me8+QtOxlrML3zQeQLTkz0+V7PKFSO+FKLkKMt6g3f17wCgRj2
         tLHgftC3XH193FJIrirchNnIrQDYobT5AJ92OqnjAUg18oOuv1U2txDcn2g4oOliHbFL
         wTbZxGvNG6LeBYwQK/J5fd0wJKHAHu/ZlL7YcwaRZqQoR1wPvrwiugaBxfJwJ5qgzKo9
         GeGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780073828; x=1780678628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9w8JzV6Ke6m6ss7khBxwWJgK/oI1uoZHRLSFhlaSQYw=;
        b=G7fDv9ksFAdctHw7H0SbpCTVmCgv5x6hFOyppbywGQy4KmiqasB0m5q9r9D8VkukBK
         tHmwYC9i3l/pdkE4ybtgFjcQlOt8YfT/qdnqd729YcXZMLOAFPK6KWQWM6Z8qFlyDELN
         ucsnLHit4UkYaYmKGUlS48CVDfeyKVQ6X5GIMcKmUw4unje/NbQZuuiPgnDrWD9/9uXu
         V0DYM7RoSKWc96FSgb4JKvXJl5aseRy0KNUSnKvGEk7mEHKEXDBV85nF4tkXozakzdy0
         2PKA/HWdXXTQnxOjD2r0v30BzjV0OYe66URP5C7UnLN1LY+0BVpyiHg8ZJ1rTe2BYXAv
         2P6w==
X-Forwarded-Encrypted: i=1; AFNElJ95NpIHOtuWpvYXGRwuX/Wk9cyGrbqAdU3xizWFlyng5FAt1o5pHmV1ChBF3JJBaIy2TXfd3a5Y0w==@kvack.org
X-Gm-Message-State: AOJu0Yxck7Ajxl+7xgTcH5qzKowTmWiD32oe6GsFlFNaD17WSZp0kv0m
	cNlFhceGcwnclmc/5HiOj5nXGLrLDPl05gnrWDHpvweO21cY2weqomM=
X-Gm-Gg: Acq92OEa3fdH8hK+yan2z5OToWiKOtyKosFKZ9w1C12waFEUBcMOx16eVFoiWc8dZ7N
	kyqj+8deV5/MWPrXonMsKZLnVImCiCmD58dYiVNLIgQ3dOk13cQxZ4y+tO/BJ7A5gS9YxpypqwW
	qT3hgR47KwI3Bp9CcwLo+luuOBDa2FuNGqi2QNyAnWfkIsk5ZLgF6+ksQ0a/PYrGpUhlaCsrvlP
	dkkdz1zzu4Bm1eJ3ETYAb+wjLUpN6rS5WlZ3XuE1CItAH1e3C3EUtTgSXVBFfm74sC99Urxb8h3
	fYUoiQSTiBZ6VjRbzDX6Hi67Ivk6o8s5e75B6Ssf6vjyFjKgkTeFX0FV/OIo9uhTfnrK/Cqj6C1
	dwLI24jE0h5NUKtUbgs1miUnrlHNmUKd8e8ojMiaVJPu4Vu4l2ggxMWxjsbZEQej3Zq53dvJf4V
	2ugX+zpKQXcKU+6HkO3MJ8N39pvlxUTdb+ZeP6m39vVYDSf3aPFwueFZSG0gyh7H4l+GNYfhs6j
	4h7IGb2oe31
X-Received: by 2002:a05:6830:1e21:b0:7e3:be56:e0e7 with SMTP id 46e09a7af769-7e6951dfbbbmr1403852a34.11.1780073828441;
        Fri, 29 May 2026 09:57:08 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e695bd9c9csm1806545a34.11.2026.05.29.09.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 09:57:07 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com
Subject: [RFC PATCH 4/6] mm/damon/core: per-CPU SPSC ring drain and damon_perf_event lifecycle
Date: Fri, 29 May 2026 09:56:38 -0700
Message-ID: <20260529165640.820-5-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260529165640.820-1-ravis.opensrc@gmail.com>
References: <20260529165640.820-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gchk9e3rtrm6skjtafzm5sj3k7ztu6j5
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9059D4000E
X-Rspam-User: 
X-HE-Tag: 1780073829-415381
X-HE-Meta: U2FsdGVkX19FUivlaesNeZDNZ3IA6vhL6WmK+LXhwZoRq4wQBA1RJGzc/mgsKbwqsy8cxk12btTCCF9r8EY1u0WlUP4R6EmYr43GqZePvKR0HNc9FJWxSiNnAAfZMruM8X3dRN8t6uM2dhW19DmuiMzeNMhjv7XRVtL+KsLe13fM8+8mBVkO7474Mt4+zuOJjicdJC5kLaqRdXIHiHVPBM7OcGt805y7UwrmVkNhT0P9uq3Kn/qgZsbx2tv2f0uUQYnvbVbOizyjGW0AvLdrTDoUURM777ky+yJ2eFbxd85pGsxS3vPm8TCvlmmdiG59Nbo2D9laYN3TLFBwlbWfEnS3FL7moE11dqnhf4EKfiIucrDX9eK5V3MNjXkuwGwlt93WhOcti2z0LyRNsulo3Zp0axDodU/KC3UPxLjxuws/KgNKJ6C214O7BHhL0YUq4HC5Mo8Rm7VmQaulVWYJgQ9yyR6RhLMPBua2UXCZUuHkjsCn9SHFU5H+PtfN6Pc1izsp4SxE+OMDhHHbMon1hnZxld9AUWf4n2Rs0usBEwSTDaqc/4LLLfM63UEvbvO0ZmqMiaKC5fK5acI6hPEUBb1jMyZXxd291akZM+Vx/G+BZxY5rUZ8hJsn1e/5N8Yb48KHNyxMv2ku/hXRhQqWpVu8DPN+xYIVdbJwU8Kco3zHfhcD2fDnwAlZPbb+ZAUctvp+B+/HBZilWML5+tWv8z1p502DVhxZu7wt2WkQfwlqk9+3xCQIoJV3Qeie2PUZL4Pzon3m+jLQMXHUTG2k85RuKqx+HzXUKEjdgk5d5E8F15co5qiERycUOfFZ3aWVeO68ji2/HYoz7LmAKN+ZvyMiEvI2vzOHQFyWXa65lYTm3SsHz2/YPEVDdrfEc30rh+0jAJxFLjYLS0Ufd8zdzOPvbnBQBv/N9fnpRZteH4S8XHwXv5rw2aLKo3+zAm/lysnYAiQLvWSU1oMYSnw
 ZWGf4ee+
 vMFPi+SpxDi6Z5+F9gh6Rg2I0rFux8VR4rjSwKXEWGNDnHByybBr7y9wnD82Btnj9Q/+edBrebSCQ5V7L0Q5JP/YfT7Dvw3HbpNuNcXwqPAApvVcIXspPofPW75p8EOlQTl1b1wMaDfODwDV3fjAS+yAdEPIHAMXKPojHodxt9G5B1ixwm+lf2Dc9Sk6K1A8qTzJJeCi91zNEsexjm+s0gqtUgfQ4pBMwxUnvLrC0siB/hCU/7UK2XYdMZB7u3GWwrpzd60SxAutkw4x9lmi90NJcXnRt2DuRxUhBNSrvApeLx4/gYkihcAUkZkrY0NDu6PGYYkx9VjvgYDukqzpyCLHNje5qr2mC4xoHxGVGYXf0hV95MT3lQzcrailMJcDpvMkYtdPPykQmAxOgCrGpUJ719ywgk2IWtDl5/tj4qkXuU4f7HpEKGHh3r88g78K/3uwUiLzHeRNoQ4WSvIN6ciyr2vepmCqpA3No3h9Z4Y1HUrE6gMTdxE7ijRZ1XHdX73PA4V58kGOfvO2dJzFA1MFcxEUOJV3Ad/k9rvud516oJjOhMxYpbW78q9Q9mMm2pLamCIgdSXA725SPAsZytYeXFYX3CKyJEbue8Y0NWuZH3OPSh22LstSOfsM3oJ0bZetFTN5zwFSL8nKp4Ox6LeiSQhWFxFW7Ix+UF9ZYnxWZL0phKaaonl1kl4/3ZkKFVRXF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the mutex-protected damon_access_reports[] single-buffer with
a per-CPU SPSC ring.  The producer (damon_report_access) is called
from NMI by perf overflow handlers; the consumer
(kdamond_check_reported_accesses) runs once per sample tick.

  - 256-entry ring per CPU with cache-line-aligned head/tail
  - per-CPU damon_report_ring_busy guards against NMI nesting on top
    of a process-context producer on the same CPU
  - per-CPU damon_ring_pending bit so the consumer iterates only CPUs
    that produced samples this tick
  - smp_mb between flag clear and head read on the consumer side
    pairs with the producer's head-publish ordering

Replace the O(N) per-region scan in kdamond_apply_access_report() with
bsearch over a per-tick per-target snapshot built into a reusable
damon_ctx::drain_snapshot buffer.  The pid-based ctx early-reject is
no longer needed: kdamond_apply_access_report() already discriminates
report->vaddr vs report->paddr per ctx.

Wire the damon_perf_event lifecycle: init per attached event when
kdamond starts, teardown when the ctx is destroyed, replayed across
damon_commit_ctx.  Add the matching forward decl + drain_snapshot
field on struct damon_ctx.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/trace/events/damon.h |  17 ++
 mm/damon/core.c              | 383 ++++++++++++++++++++++++++++++-----
 2 files changed, 344 insertions(+), 56 deletions(-)

diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
index b131bee27cc4a..e97e70579a8c8 100644
--- a/include/trace/events/damon.h
+++ b/include/trace/events/damon.h
@@ -74,6 +74,23 @@ TRACE_EVENT(damos_esz,
 			__entry->esz)
 );
 
+TRACE_EVENT(damon_perf_ring_overflow,
+
+	TP_PROTO(int cpu),
+
+	TP_ARGS(cpu),
+
+	TP_STRUCT__entry(
+		__field(int, cpu)
+	),
+
+	TP_fast_assign(
+		__entry->cpu = cpu;
+	),
+
+	TP_printk("cpu=%d", __entry->cpu)
+);
+
 TRACE_EVENT_CONDITION(damos_before_apply,
 
 	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 23311189b589e..1e6966e45144f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -8,6 +8,7 @@
 #define pr_fmt(fmt) "damon: " fmt
 
 #include <linux/damon.h>
+#include <asm/local.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/memcontrol.h>
@@ -24,22 +25,43 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
 
-#define DAMON_ACCESS_REPORTS_CAP 1000
+#define DAMON_REPORT_RING_SIZE	256
+#define DAMON_REPORT_RING_MASK	(DAMON_REPORT_RING_SIZE - 1)
+
+/* Per-target region lookup snapshot for the drain loop. */
+struct damon_target_lookup {
+	struct damon_target *t;
+	struct damon_region **regions;
+	unsigned int nr_regions;
+};
+
+struct damon_report_ring {
+	unsigned int head;	/* written by producer (NMI) */
+	unsigned int tail	/* written by consumer (kdamond) */
+		____cacheline_aligned_in_smp;
+	struct damon_access_report entries[DAMON_REPORT_RING_SIZE]
+		____cacheline_aligned_in_smp;
+};
+
+static DEFINE_PER_CPU(struct damon_report_ring, damon_report_rings);
+static DEFINE_PER_CPU(local_t, damon_report_ring_busy);
+/*
+ * Producer (NMI) sets after publishing a report; consumer (kdamond) clears
+ * before draining the corresponding ring.  Per-CPU to avoid cross-CPU
+ * cacheline bouncing under sampling load on large systems.
+ */
+static DEFINE_PER_CPU(unsigned long, damon_ring_pending);
 
 static DEFINE_MUTEX(damon_lock);
 static int nr_running_ctxs;
 static bool running_exclusive_ctxs;
+static struct damon_ctx *damon_perf_owner;
 
 static DEFINE_MUTEX(damon_ops_lock);
 static struct damon_operations damon_registered_ops[NR_DAMON_OPS];
 
 static struct kmem_cache *damon_region_cache __ro_after_init;
 
-static DEFINE_MUTEX(damon_access_reports_lock);
-static struct damon_access_report damon_access_reports[
-	DAMON_ACCESS_REPORTS_CAP];
-static int damon_access_reports_len;
-
 /* Should be called under damon_ops_lock with id smaller than NR_DAMON_OPS */
 static bool __damon_is_registered_ops(enum damon_ops_id id)
 {
@@ -805,11 +827,24 @@ struct damon_ctx *damon_new_ctx(void)
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
 
+	INIT_LIST_HEAD(&ctx->perf_events);
+
 	prandom_seed_state(&ctx->rnd_state, get_random_u64());
 
 	return ctx;
 }
 
+static void damon_perf_destroy(struct damon_ctx *ctx)
+{
+	struct damon_perf_event *event, *next;
+
+	list_for_each_entry_safe(event, next, &ctx->perf_events, list) {
+		damon_perf_cleanup(ctx, event);
+		list_del(&event->list);
+		kfree(event);
+	}
+}
+
 static void damon_destroy_targets(struct damon_ctx *ctx)
 {
 	struct damon_target *t, *next_t;
@@ -835,6 +870,11 @@ void damon_destroy_ctx(struct damon_ctx *ctx)
 	damon_for_each_sample_filter_safe(f, next_f, &ctx->sample_control)
 		damon_destroy_sample_filter(f, &ctx->sample_control);
 
+	damon_perf_destroy(ctx);
+
+	kfree(ctx->drain_snapshot.lookups);
+	kfree(ctx->drain_snapshot.region_buf);
+
 	kfree(ctx);
 }
 
@@ -1694,6 +1734,45 @@ static int damon_commit_sample_control(
 	return damon_commit_sample_filters(dst, src);
 }
 
+static int damon_commit_perf_events(struct damon_ctx *dst,
+		struct damon_ctx *src)
+{
+	struct damon_perf_event *src_event, *new_event;
+	int err = 0;
+
+	damon_perf_destroy(dst);
+
+	list_for_each_entry(src_event, &src->perf_events, list) {
+		new_event = kzalloc(sizeof(*new_event), GFP_KERNEL);
+		if (!new_event) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		new_event->attr = src_event->attr;
+
+		if (damon_is_running(dst)) {
+			err = damon_perf_init(dst, new_event);
+			if (err) {
+				kfree(new_event);
+				goto out;
+			}
+			/*
+			 * Events are created with attr.disabled=1 and only fire while
+			 * the kdamond runs.  Arm now if we are committing into a
+			 * running ctx whose substrate is already armed.
+			 */
+			if (dst->perf_events_active)
+				damon_perf_event_arm(new_event);
+		}
+		list_add_tail(&new_event->list, &dst->perf_events);
+	}
+	return 0;
+out:
+	damon_perf_destroy(dst);
+	return err;
+}
+
 static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 {
 	int err;
@@ -1742,6 +1821,9 @@ static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 		return err;
 	err = damon_commit_sample_control(&dst->sample_control,
 			&src->sample_control);
+	if (err)
+		return err;
+	err = damon_commit_perf_events(dst, src);
 	if (err)
 		return err;
 	dst->addr_unit = src->addr_unit;
@@ -1929,12 +2011,40 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 		return -EBUSY;
 	}
 
+	/*
+	 * The per-CPU PMU events backing the perf-event substrate are a single
+	 * shared resource; only one ctx may own them.  Reject the start if
+	 * another already-running ctx owns the substrate, or if more than one
+	 * ctx in this batch wants it.
+	 */
+	for (i = 0; i < nr_ctxs; i++) {
+		if (!list_empty(&ctxs[i]->perf_events)) {
+			int j;
+
+			if (damon_perf_owner) {
+				mutex_unlock(&damon_lock);
+				return -EBUSY;
+			}
+			for (j = i + 1; j < nr_ctxs; j++) {
+				if (!list_empty(&ctxs[j]->perf_events)) {
+					mutex_unlock(&damon_lock);
+					return -EBUSY;
+				}
+			}
+			damon_perf_owner = ctxs[i];
+			break;
+		}
+	}
+
 	for (i = 0; i < nr_ctxs; i++) {
 		err = __damon_start(ctxs[i]);
 		if (err)
 			break;
 		nr_running_ctxs++;
 	}
+	if (err && damon_perf_owner &&
+			!damon_perf_owner->kdamond)
+		damon_perf_owner = NULL;
 	if (exclusive && nr_running_ctxs)
 		running_exclusive_ctxs = true;
 	mutex_unlock(&damon_lock);
@@ -2113,29 +2223,47 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
  * damon_report_access() - Report identified access events to DAMON.
  * @report:	The reporting access information.
  *
- * Report access events to DAMON.
+ * Report access events to DAMON via a per-CPU SPSC lockless ring.  Producer
+ * is the local CPU (typically NMI from a hardware-sampling backend);
+ * consumer is the kdamond drain in kdamond_check_reported_accesses().
  *
- * Context: May sleep.
+ * Context: any (NMI-safe).  An NMI nesting on top of a process-context
+ * producer on the same CPU would otherwise stomp the same entries[head]
+ * slot; the busy guard detects and drops in that case.
  *
- * NOTE: we may be able to implement this as a lockless queue, and allow any
- * context.  As the overhead is unknown, and region-based DAMON logics would
- * guarantee the reports would be not made that frequently, let's start with
- * this simple implementation.
+ * If the ring is full, the sample is dropped and the per-CPU overflow
+ * counter incremented.
  */
 void damon_report_access(struct damon_access_report *report)
 {
-	struct damon_access_report *dst;
+	struct damon_report_ring *ring;
+	unsigned int head, next;
 
-	/* silently fail for races */
-	if (!mutex_trylock(&damon_access_reports_lock))
-		return;
-	dst = &damon_access_reports[damon_access_reports_len++];
-	/* just drop all existing reports in favor of simplicity. */
-	if (damon_access_reports_len == DAMON_ACCESS_REPORTS_CAP)
-		damon_access_reports_len = 0;
-	*dst = *report;
-	dst->report_jiffies = jiffies;
-	mutex_unlock(&damon_access_reports_lock);
+	/* Pin to a CPU so the SPSC invariant holds for preemptible callers. */
+	preempt_disable();
+	if (local_inc_return(this_cpu_ptr(&damon_report_ring_busy)) != 1) {
+		/* NMI nested on a process-context producer; drop. */
+		trace_damon_perf_ring_overflow(smp_processor_id());
+		goto out;
+	}
+
+	ring = this_cpu_ptr(&damon_report_rings);
+	head = ring->head;
+	next = (head + 1) & DAMON_REPORT_RING_MASK;
+
+	if (next == READ_ONCE(ring->tail)) {
+		trace_damon_perf_ring_overflow(smp_processor_id());
+		goto out;
+	}
+
+	ring->entries[head] = *report;
+	ring->entries[head].report_jiffies = jiffies;
+	smp_wmb(); /* publish entry before head advance */
+	WRITE_ONCE(ring->head, next);
+	WRITE_ONCE(*this_cpu_ptr(&damon_ring_pending), 1);
+out:
+	local_dec(this_cpu_ptr(&damon_report_ring_busy));
+	preempt_enable();
 }
 
 #ifdef CONFIG_MMU
@@ -2145,7 +2273,8 @@ void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
 		.vaddr = vmf->address,
 		.size = 1,	/* todo: set appripriately */
 		.cpu = smp_processor_id(),
-		.tid = task_pid_vnr(current),
+		.tid = current->pid,
+		.tgid = task_tgid_nr(current),
 		.is_write = vmf->flags & FAULT_FLAG_WRITE,
 	};
 
@@ -3700,6 +3829,7 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 	unsigned long sample_interval = ctx->attrs.sample_interval ?
 		ctx->attrs.sample_interval : 1;
 	struct damos *scheme;
+	struct damon_perf_event *event, *next;
 
 	ctx->passed_sample_intervals = 0;
 	ctx->next_aggregation_sis = ctx->attrs.aggr_interval / sample_interval;
@@ -3713,6 +3843,15 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 		damos_set_next_apply_sis(scheme, ctx);
 		damos_set_filters_default_reject(scheme);
 	}
+
+	list_for_each_entry_safe(event, next, &ctx->perf_events, list) {
+		int err = damon_perf_init(ctx, event);
+
+		if (err) {
+			list_del(&event->list);
+			kfree(event);
+		}
+	}
 }
 
 static bool damon_sample_filter_matching(struct damon_access_report *report,
@@ -3759,26 +3898,46 @@ static bool damon_sample_filter_out(struct damon_access_report *report,
 }
 
 static void kdamond_apply_access_report(struct damon_access_report *report,
-		struct damon_target *t, struct damon_ctx *ctx)
+		struct damon_target *t,
+		struct damon_region **regions, unsigned int nr_regions,
+		struct damon_ctx *ctx)
 {
 	struct damon_region *r;
 	unsigned long addr;
+	int left, right, mid;
 
-	if (damon_sample_filter_out(report, &ctx->sample_control))
-		return;
-	if (damon_target_has_pid(ctx))
+	if (damon_target_has_pid(ctx)) {
+		if (pid_nr(t->pid) != report->tgid)
+			return;
 		addr = report->vaddr;
-	else
+	} else {
 		addr = report->paddr;
+	}
 
-	/* todo: make search faster, e.g., binary search? */
-	damon_for_each_region(r, t) {
-		if (addr < r->ar.start)
-			continue;
-		if (r->ar.end < addr + report->size)
-			continue;
-		if (!r->access_reported)
-			damon_update_region_access_rate(r, true, &ctx->attrs);
+	/* Binary search the snapshot for the region containing addr. */
+	left = 0;
+	right = nr_regions - 1;
+	r = NULL;
+	while (left <= right) {
+		/* Avoid (left + right) overflow at large nr_regions. */
+		mid = left + (right - left) / 2;
+		if (addr < regions[mid]->ar.start)
+			right = mid - 1;
+		else if (addr >= regions[mid]->ar.end)
+			left = mid + 1;
+		else {
+			r = regions[mid];
+			break;
+		}
+	}
+
+	if (!r)
+		return;
+	/* Reject reports straddling a region boundary. */
+	if (addr + report->size > r->ar.end)
+		return;
+	if (!r->access_reported) {
+		damon_update_region_access_rate(r, true, &ctx->attrs);
 		r->access_reported = true;
 	}
 }
@@ -3802,28 +3961,120 @@ static unsigned int kdamond_apply_zero_access_report(struct damon_ctx *ctx)
 	return max_nr_accesses;
 }
 
-static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
+/*
+ * Build a snapshot of the ctx's targets and their region arrays for use
+ * by the ring drain loop.  The snapshot buffer is reused across ticks,
+ * grown via krealloc only when a new high water mark is reached.
+ *
+ * The two-pass walk over adaptive_targets is safe even though
+ * krealloc_array() may sleep: target list mutation is funneled through
+ * damon_call onto the kdamond itself, so no other thread can mutate the
+ * list while kdamond is running this function.
+ */
+static struct damon_target_lookup *damon_build_target_lookup(
+		struct damon_ctx *ctx, unsigned int *nr_targets_out)
 {
-	int i;
-	struct damon_access_report *report;
 	struct damon_target *t;
+	struct damon_target_lookup *tbl;
+	unsigned int nr_targets = 0, total_regions = 0, ti = 0, ri = 0;
 
-	/* currently damon_access_report supports only physical address */
-	if (damon_target_has_pid(ctx))
-		return 0;
+	damon_for_each_target(t, ctx) {
+		nr_targets++;
+		total_regions += damon_nr_regions(t);
+	}
 
-	mutex_lock(&damon_access_reports_lock);
-	for (i = 0; i < damon_access_reports_len; i++) {
-		report = &damon_access_reports[i];
-		if (time_before(report->report_jiffies,
-					jiffies -
-					usecs_to_jiffies(
-						ctx->attrs.sample_interval)))
+	if (nr_targets > ctx->drain_snapshot.nr_lookups) {
+		tbl = krealloc_array(ctx->drain_snapshot.lookups,
+				nr_targets, sizeof(*tbl), GFP_KERNEL);
+		if (!tbl)
+			return NULL;
+		ctx->drain_snapshot.lookups = tbl;
+		ctx->drain_snapshot.nr_lookups = nr_targets;
+	}
+	tbl = ctx->drain_snapshot.lookups;
+
+	if (total_regions > ctx->drain_snapshot.region_buf_cap) {
+		struct damon_region **buf;
+
+		buf = krealloc_array(ctx->drain_snapshot.region_buf,
+				total_regions, sizeof(*buf), GFP_KERNEL);
+		if (!buf)
+			return NULL;
+		ctx->drain_snapshot.region_buf = buf;
+		ctx->drain_snapshot.region_buf_cap = total_regions;
+	}
+
+	damon_for_each_target(t, ctx) {
+		struct damon_region *r;
+
+		tbl[ti].t = t;
+		tbl[ti].regions = &ctx->drain_snapshot.region_buf[ri];
+		tbl[ti].nr_regions = damon_nr_regions(t);
+		damon_for_each_region(r, t)
+			ctx->drain_snapshot.region_buf[ri++] = r;
+		ti++;
+	}
+
+	*nr_targets_out = nr_targets;
+	return tbl;
+}
+
+static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
+{
+	int cpu;
+	struct damon_target_lookup *tbl;
+	unsigned int nr_targets = 0;
+	unsigned int i;
+
+	tbl = damon_build_target_lookup(ctx, &nr_targets);
+	if (!tbl) {
+		pr_warn_ratelimited(
+			"damon: target-lookup alloc failed; ring drain skipped this tick\n");
+		return kdamond_apply_zero_access_report(ctx);
+	}
+
+	for_each_online_cpu(cpu) {
+		struct damon_report_ring *ring;
+		unsigned int head, tail;
+
+		if (!READ_ONCE(*per_cpu_ptr(&damon_ring_pending, cpu)))
 			continue;
-		damon_for_each_target(t, ctx)
-			kdamond_apply_access_report(report, t, ctx);
+		ring = per_cpu_ptr(&damon_report_rings, cpu);
+
+		WRITE_ONCE(*per_cpu_ptr(&damon_ring_pending, cpu), 0);
+		/*
+		 * Pair with the producer's smp_wmb between entry and head
+		 * publish: order our flag clear before the head read so that
+		 * a producer publishing between our clear and READ_ONCE(head)
+		 * is observed via the flag it re-sets, not lost as a
+		 * stale-head drain.
+		 */
+		smp_mb();
+		head = READ_ONCE(ring->head);
+		smp_rmb(); /* pair with smp_wmb in producer */
+		tail = ring->tail;
+
+		while (tail != head) {
+			struct damon_access_report *report =
+				&ring->entries[tail];
+
+			if (time_before(report->report_jiffies,
+					jiffies - usecs_to_jiffies(
+						ctx->attrs.sample_interval)))
+				goto next;
+			if (damon_sample_filter_out(report,
+					&ctx->sample_control))
+				goto next;
+			for (i = 0; i < nr_targets; i++)
+				kdamond_apply_access_report(report,
+						tbl[i].t,
+						tbl[i].regions,
+						tbl[i].nr_regions, ctx);
+next:
+			tail = (tail + 1) & DAMON_REPORT_RING_MASK;
+		}
+		WRITE_ONCE(ring->tail, tail);
 	}
-	mutex_unlock(&damon_access_reports_lock);
 	/* For nr_accesses_bp, absence of access should also be reported. */
 	return kdamond_apply_zero_access_report(ctx);
 }
@@ -3848,6 +4099,14 @@ static int kdamond_fn(void *data)
 	complete(&ctx->kdamond_started);
 	kdamond_init_ctx(ctx);
 
+	if (!list_empty(&ctx->perf_events)) {
+		struct damon_perf_event *event;
+
+		WRITE_ONCE(ctx->perf_events_active, true);
+		list_for_each_entry(event, &ctx->perf_events, list)
+			damon_perf_event_arm(event);
+	}
+
 	if (ctx->ops.init)
 		ctx->ops.init(ctx);
 	ctx->regions_score_histogram = kmalloc_array(DAMOS_MAX_SCORE + 1,
@@ -3871,14 +4130,15 @@ static int kdamond_fn(void *data)
 		if (kdamond_wait_activation(ctx))
 			break;
 
-		if (ctx->ops.prepare_access_checks)
+		if (list_empty(&ctx->perf_events) &&
+				ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
 
 		kdamond_usleep(sample_interval);
 		ctx->passed_sample_intervals++;
 
-		/* todo: make these non-exclusive */
-		if (ctx->sample_control.primitives_enabled.page_fault)
+		if (!list_empty(&ctx->perf_events) ||
+		    ctx->sample_control.primitives_enabled.page_fault)
 			max_nr_accesses = kdamond_check_reported_accesses(ctx);
 		else if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
@@ -3965,6 +4225,15 @@ static int kdamond_fn(void *data)
 		}
 	}
 done:
+	if (ctx->perf_events_active) {
+		struct damon_perf_event *event;
+
+		WRITE_ONCE(ctx->perf_events_active, false);
+		list_for_each_entry(event, &ctx->perf_events, list)
+			damon_perf_event_disarm(event);
+		/* Drain any in-flight reports queued before disarm took effect. */
+		kdamond_check_reported_accesses(ctx);
+	}
 	damon_destroy_targets(ctx);
 
 	kfree(ctx->regions_score_histogram);
@@ -3986,6 +4255,8 @@ static int kdamond_fn(void *data)
 	nr_running_ctxs--;
 	if (!nr_running_ctxs && running_exclusive_ctxs)
 		running_exclusive_ctxs = false;
+	if (damon_perf_owner == ctx)
+		damon_perf_owner = NULL;
 	mutex_unlock(&damon_lock);
 
 	return 0;
-- 
2.43.0


