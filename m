Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 540ABC5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 14:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F30B86B0350; Sun, 16 Aug 2026 10:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09556B0357; Sun, 16 Aug 2026 10:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7916B0358; Sun, 16 Aug 2026 10:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B47CA6B0350
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 10:23:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B78FAA0582
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 14:23:00 +0000 (UTC)
X-FDA: 85107349320.22.AF267FF
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 57E6D20007
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 14:22:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f1GDSoIU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786890178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XFvz6C60IHzA1UYwdcXz9Guq3Gbi/MTHeZWN6fp2F3A=;
	b=LrDrVnDfAY115Ltpv/AK/Sy38ORVxfsy/hyXGzQatekqCz/5SQCI/Bvmm8x7/supFvxjkO
	l6DUL2LNKoSImOKmknNBydA0ebBQgwH9agcNk00NPBJL6RHxza7FMypJda2+o3bqMxOl8h
	Ay8faMCb4LrxEHirUDIOgex2K82iz08=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f1GDSoIU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786890178;
	b=QRUrflQZgwnAuPnsGPJWl6cWY18zSTkx1At9gVTUAjIiQKEDiE+Oc9i0R8upKh9UbOOS4F
	W2l5tnofGBpE3q66zGrUg2bVG/bwbCwHSGK3JGPOKVxKts+tsSgGfl/QrBrjGInH/P7rLi
	yvNi2CxlWujnQQdDZuVu7kSoCXGskYo=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2d58efc7356so850305ad.1
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 07:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786890177; x=1787494977; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XFvz6C60IHzA1UYwdcXz9Guq3Gbi/MTHeZWN6fp2F3A=;
        b=f1GDSoIUkuTsRb2wMkvGimEa1J10jlcFqHiXt6+y5YubqwqzCCIxAWd0vFGGeYFtz/
         ay8jzcsvIqpTJBCBZW0l2ISZOM70tLNW8EqeMI9fjP5KyQt1pWRogxCKUhIWOm8vR9HZ
         XaMmCzONXjIe5ZrXbdIZ0GzTAX7WzKTl3waCWybLa3QdlvgnH+CKXde1xK5HmiXXgAfe
         5ZxkDM4z+K+e0lGu9lOyXjd4mb3OgJ/jrvEYkjfB2DSvv5o4I0SuwRW5fQ2pCGeX5n4J
         YTrn9KL1YEyrK7/THnC5bxG+7Bs7OC1BfQYkgkbmDg7zjdra+0GPu1qEQLbvWEH/VBD3
         d+kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786890177; x=1787494977;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XFvz6C60IHzA1UYwdcXz9Guq3Gbi/MTHeZWN6fp2F3A=;
        b=bOHhGiHjZeV6zo61wugBkaiXkVGu6w9Pni5P3yo9fr1mkPrXui5naVLXcYJHuaDbTO
         rDoGI7rxgGFKyLlEgss6uqZQ1RLgWgEtA64XMcShZD/x9eK5SaFs5FKnj8ohlHruAQxP
         gZWdwB4++lkiuNowTQi3VXeum4grggbPa/Tc2psxNndEjKH3TSgT7Bc3S5ZI57mWLi/+
         U0SZMpYG2cd85JgBBaqmV4GNg5GG+fgFSuzD5Dg4c63SWkaqcyYTPvW/fdmI6AA42UTt
         yItcaXhzCtwWXaeo5V59ry8rvN9OXRii6pN+e1SFMD8YoXJz2SCNJKUVNUmQzOlLe72Q
         gdpg==
X-Forwarded-Encrypted: i=1; AHgh+RoKzPXYJxpf0l6mmAe8WPrIuVbY1nydTba62IWvjdvbuTGpgkgckInHL42eZEqNKdZGFDwi9g8Opg==@kvack.org
X-Gm-Message-State: AOJu0Yw5P2WRvSE2/dfsxyhq+X2x2X1p26hks9yRZAQZmntU3zIhIY1y
	8haZf0VjZg0NI2ywe8t593XAlboUEG67FX7EzC0FHjUBvEqdcC/zlGVG
X-Gm-Gg: AR+sD13A+0mpDZFoh1PMWHN1fDI/KKzEnx2kDfQJt1sLtG+qsvuAnv5cilGM/NWLCjE
	JvpTDgxC3KOcPnTNG589j7ExhLJj8n6IDp9wcB1MR43KlI9XRItMJb3OGFZ+iwEfdgPWv+i2GpZ
	T7dgeufMLWT1fzIKDPfntEjqJkXTas2mEjS7gMGNGpX3Ji2r0i1dyT2gkShuLn1YKIjK858hHrd
	pkD2N9mVH0oXa5/lx3lwbevhlJbkbIB+oxMdWpsWfMJe99fUrKqVye2DOG8tqORhUiuPhB6LLMw
	2rLqD/KaljUq06ycWoQq5hedxD7Ov8N8ZOl0RBG3VYSyzKm41JMDo0MHyeFCY/6tREncy7IwqYi
	JZjlIT+RNMtsBm/GKgTvX2lbaqaoFxipAaT3u+AGtrWMLPr2/Rm7AsJkZzrlT/YO/+YZXzzddlt
	WzTTN+/lZDKTwHcbSWlt2NqqtMsFQqA0cJqrLIcxOA42nkSnGsfWBtPCWL/l/m44etsuG2W9rJQ
	LTjvOY=
X-Received: by 2002:a17:902:fd90:b0:2c8:248a:5dbb with SMTP id d9443c01a7336-2d3b0d16339mr208743955ad.7.1786890176678;
        Sun, 16 Aug 2026 07:22:56 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3aebc8199sm26102365ad.74.2026.08.16.07.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 07:22:55 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: will@kernel.org,
	mark.rutland@arm.com,
	sj@kernel.org,
	akpm@linux-foundation.org,
	shuah@kernel.org,
	kunwu.chan@linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [RFC PATCH 2/4] mm/damon/perf: add AUX trace-buffer PMU backend for ARM SPE
Date: Sun, 16 Aug 2026 22:22:19 +0800
Message-ID: <20260816142222.689624-3-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260816142222.689624-1-kunwu.chan@linux.dev>
References: <20260816142222.689624-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 57E6D20007
X-Rspamd-Server: rspam07
X-Stat-Signature: 7uaf7tgt3odfxqg3366hx491yu8bgomn
X-HE-Tag: 1786890178-900923
X-HE-Meta: U2FsdGVkX1/AK6QtN4oKztwzDjn//6EnLCbOw5pvmMb44eKeO0Eb4fudZVdvN7o2Y1l9Nqu+lAHDmUnESpApufMtrp12Dje7/cJGgrHsfEg0T7UgoiZ2EVlETNfV9WR6AZt2bbn0EErrVMXxTZhepXceeh0zLuvU9TVegk/6a0yoWvKa0OQXh3MHk1cyqhrRUVppjf3R86FVpm9y7cGHsb/nsgPjRON148yaBdJkd8tnhKzDpbJLIMHlqCO+kXxJnfYiTmoZ+pV3PJrkMWxx0SQnDOJFWuzMDTnldE+FhdiN9fQnrsOcL3R6Ct4rbMOTOj2TV9aabHIHboWrQctcIq6EA+4XVRatYSyRu1EMWPgmR170zQMgotRfdwZywdzQ7y8R4F1W+hja5hUXk2fq+SWSumYRC1PO17BW28pOb84/YJjUSiFcHubdFOMU+p0vHVv2IfRs0uT7ES/ZKIKe3NKHZdRuYqEW+PbTPFsa7CfScQhkln+x1heKBHLY8HirptvMFCAM7oGpYmb3k46Q9Yuw8NtoQQ1YTmA+MfZECzGfPIimY4hysX8668eg+96sNLKwYACAjbGA4PaZSoauaLWl14nudG3EeScOMF0DAH1+G7PxWii4nJBOlbU8DysT+UVBNXgaI6V9tsd4hWvOcN2mV2K2V6yV4U9STdTgFe2Tt807+Bh9DwnTaIl5qtHWtTLa0Qy2QSHktQ1NLzpz5ffvQQF50yziWYED5Pk2sageNyE0aYtS9CENMvmN9u9o7M8KqstYbV4aT0j25nX8bu5g9nGVqVZIix+tbgOfK/EWwQcg7eLDhK7Gn7l84jSfP9FkqavRsmOJ29DnIQzwLUoYADR3RlttRBeXanG3al1o5UhI1T+m8uD2Syi25un+oCy5KARIVDdNP+msvZXWjgJJDWt1Cuy4r1HKW8dY1CDRDRjpjQsO+5mzajXuO4QA7f4kvO1mloNEQcvW92Q
 tkvbS1yN
 CyE5xtRahmYvZ2VkdHjyeIEHQxi8Tqs4XOt23LOmqy5cLSZSEVcj4WL+GYTjmOv1Vx9SP7NJwrXSUQAAEw1hIYqh5F+tqHc8Y4UYJZ+92d7lXhJNTNY/LQ5DpABB3ha44oBs8KFnbB4/T6AAN/jpzIe1f3ut+Y/OZUltN+kx53hAkd28tjRuxh9YeRUQ4t/e3RJRUmOCwx3269hUe/5osEblGut80yb7ZlyKdcdOYS5OisYIxo8QKc232VvN8mnoI7FJZJ/t0qC1hVbpw6FHiQXLcqKiNnJ25j0mxEuc3VYUSjxBgF+AzxlBG7+S7TZWIGkEJ1yaa1AywGu4c2jdtDCFPFdI793w/qIfdCrXjOCWcC5rtLepW2i+h6zcNhVHNVFQZuKWhuzUbekeZZ5aAwEvsoCxiLG5u/cf28kJ3RqbCTZoauTZRc6VEy91k4MEk60jT7bOB0EdUWVh+dj7QJgjc1TmuMOnKIzSvotcPdmOBF+Db5FyquBQ8CZ60a4DSUK/m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <kunwu.chan@gmail.com>

Add an ARM SPE backend that owns a per-CPU AUX buffer, drains its packet
stream from kdamond process context, and publishes synthesized access
reports through DAMON's existing SPSC report ring.

Drain AUX before consuming the SPSC ring on each monitoring interval.
After disabling the events, run the same AUX-then-ring sequence once more
so records finalized by perf_event_disable() are not lost.

Decode CONTEXTIDR_EL1 as a sampled tid and resolve its tgid under RCU.
Drop records whose context is missing or stale instead of assigning them
to an arbitrary DAMON target.  Retain incomplete trailing records across
drains, guarantee progress for aligned ALIGNMENT packets, and reject
unsupported extended packet classes.

Match ARM SPE events by the PMU event_init callback, avoiding a fixed-size
PMU registry and its device-lifetime problems.  Roll back partially armed
CPU events on failure and release per-CPU AUX state on all error paths.

This depends on the perf AUX kernel-consumer API series.

Co-developed-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 drivers/perf/arm_spe_pmu.c       |   8 +
 include/linux/perf/arm_spe_pmu.h |  11 +
 mm/damon/core.c                  |  22 +-
 mm/damon/ops-common.h            |   6 +-
 mm/damon/perf/Makefile           |   5 +
 mm/damon/perf/aux_backend.c      | 121 ++++++++
 mm/damon/perf/spe_backend.c      | 479 +++++++++++++++++++++++++++++++
 mm/damon/perf/spe_parser.h       | 109 +++++++
 mm/damon/vaddr.c                 |  68 ++++-
 9 files changed, 819 insertions(+), 10 deletions(-)
 create mode 100644 include/linux/perf/arm_spe_pmu.h
 create mode 100644 mm/damon/perf/aux_backend.c
 create mode 100644 mm/damon/perf/spe_backend.c
 create mode 100644 mm/damon/perf/spe_parser.h

diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
index dbd0da111639..50430342475c 100644
--- a/drivers/perf/arm_spe_pmu.c
+++ b/drivers/perf/arm_spe_pmu.c
@@ -27,6 +27,8 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/perf_event.h>
+#include <linux/perf/arm_spe_pmu.h>
+
 #include <linux/perf/arm_pmu.h>
 #include <linux/platform_device.h>
 #include <linux/printk.h>
@@ -1097,6 +1099,12 @@ static int arm_spe_pmu_perf_init(struct arm_spe_pmu *spe_pmu)
 	return perf_pmu_register(&spe_pmu->pmu, name, -1);
 }
 
+bool arm_spe_pmu_match(struct perf_event *perf_event)
+{
+	return perf_event->pmu->event_init == arm_spe_pmu_event_init;
+}
+EXPORT_SYMBOL_GPL(arm_spe_pmu_match);
+
 static void arm_spe_pmu_perf_destroy(struct arm_spe_pmu *spe_pmu)
 {
 	perf_pmu_unregister(&spe_pmu->pmu);
diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
new file mode 100644
index 000000000000..da5fb3d7b080
--- /dev/null
+++ b/include/linux/perf/arm_spe_pmu.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PERF_ARM_SPE_PMU_H
+#define _LINUX_PERF_ARM_SPE_PMU_H
+
+#include <linux/types.h>
+
+struct perf_event;
+
+bool arm_spe_pmu_match(struct perf_event *perf_event);
+
+#endif /* _LINUX_PERF_ARM_SPE_PMU_H */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 92b21f9484c9..aded25624e2d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -22,6 +22,7 @@
 /* for damon_get_folio() used by node eligible memory metrics */
 #include "ops-common.h"
 #include "perf/perf.h"
+#include "perf/aux_backend.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
@@ -1763,8 +1764,14 @@ static int damon_commit_perf_events(struct damon_ctx *dst,
 			 * the kdamond runs.  Arm now if we are committing into a
 			 * running ctx whose substrate is already armed.
 			 */
-			if (dst->perf_events_active)
-				damon_perf_event_arm(new_event);
+			if (dst->perf_events_active) {
+				err = damon_perf_event_arm(new_event);
+				if (err) {
+					damon_perf_cleanup(dst, new_event);
+					kfree(new_event);
+					goto out;
+				}
+			}
 		}
 		list_add_tail(&new_event->list, &dst->perf_events);
 	}
@@ -4077,6 +4084,9 @@ static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
 	unsigned int i;
 	unsigned int total_reports = 0, matched_reports = 0;
 
+	/* AUX backends publish into the same ring consumed below. */
+	damon_perf_aux_drain(ctx);
+
 	tbl = damon_build_target_lookup(ctx, &nr_targets);
 	if (!tbl) {
 		pr_warn_ratelimited(
@@ -4194,8 +4204,10 @@ static int kdamond_fn(void *data)
 		struct damon_perf_event *event;
 
 		WRITE_ONCE(ctx->perf_events_active, true);
-		list_for_each_entry(event, &ctx->perf_events, list)
-			damon_perf_event_arm(event);
+		list_for_each_entry(event, &ctx->perf_events, list) {
+			if (damon_perf_event_arm(event))
+				goto done;
+		}
 	}
 
 	if (ctx->ops.init)
@@ -4323,7 +4335,7 @@ static int kdamond_fn(void *data)
 		WRITE_ONCE(ctx->perf_events_active, false);
 		list_for_each_entry(event, &ctx->perf_events, list)
 			damon_perf_event_disarm(event);
-		/* Drain any in-flight reports queued before disarm took effect. */
+		/* Final AUX drain and ring drain after perf_event_disable(). */
 		kdamond_check_reported_accesses(ctx);
 	}
 	damon_destroy_targets(ctx);
diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
index 35da400a67ec..7142ffa8878a 100644
--- a/mm/damon/ops-common.h
+++ b/mm/damon/ops-common.h
@@ -33,11 +33,12 @@ bool damos_ops_has_filter(struct damos *s);
  */
 struct damon_perf {
 	struct perf_event * __percpu *event;
+	void			*aux_priv;
 };
 
 int damon_perf_init(struct damon_ctx *ctx, struct damon_perf_event *event);
 void damon_perf_cleanup(struct damon_ctx *ctx, struct damon_perf_event *event);
-void damon_perf_event_arm(struct damon_perf_event *event);
+int damon_perf_event_arm(struct damon_perf_event *event);
 void damon_perf_event_disarm(struct damon_perf_event *event);
 
 #else /* !CONFIG_PERF_EVENTS */
@@ -53,8 +54,9 @@ static inline void damon_perf_cleanup(struct damon_ctx *ctx,
 {
 }
 
-static inline void damon_perf_event_arm(struct damon_perf_event *event)
+static inline int damon_perf_event_arm(struct damon_perf_event *event)
 {
+	return 0;
 }
 
 static inline void damon_perf_event_disarm(struct damon_perf_event *event)
diff --git a/mm/damon/perf/Makefile b/mm/damon/perf/Makefile
index 150cbaa875fa..76857e443234 100644
--- a/mm/damon/perf/Makefile
+++ b/mm/damon/perf/Makefile
@@ -3,3 +3,8 @@
 # Observability: per-CPU counters, tracepoints, debugfs perf_stats
 obj-$(CONFIG_DAMON_PERF_OBSERVE)	+= damon-perf.o
 damon-perf-objs			:= stats.o debugfs.o
+
+obj-$(CONFIG_DAMON_PERF_AUX)		+= damon-perf-aux.o
+damon-perf-aux-objs			:= aux_backend.o spe_backend.o
+damon-perf-aux-$(CONFIG_DAMON_PERF_SPE_KUNIT_TEST) += \
+					spe_parser_test.o
diff --git a/mm/damon/perf/aux_backend.c b/mm/damon/perf/aux_backend.c
new file mode 100644
index 000000000000..c6c55c7845a5
--- /dev/null
+++ b/mm/damon/perf/aux_backend.c
@@ -0,0 +1,121 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * DAMON Perf AUX Backend — Generic Drain Scheduler
+ *
+ * Provides damon_perf_aux_drain() which is called by kdamond_fn() each
+ * tick before the SPSC ring drain.  It iterates all perf events on the
+ * context and for any event whose backend ops carry DAMON_PERF_BACKEND_AUX,
+ * invokes the per-CPU drain callback to parse PMU records and feed them
+ * into damon_report_access().
+ *
+ * Also provides the auto-selection helper that assigns a backend to an
+ * event based on the PMU object of the created perf_event.
+ */
+
+#include <linux/cpu.h>
+#include <linux/cpumask.h>
+#include <linux/damon.h>
+#include <linux/list.h>
+
+#include "aux_backend.h"
+
+/* Registered backends (populated at initcall time). */
+#define AUX_BACKEND_MAX 4
+
+static const struct damon_perf_backend_ops *aux_backends[AUX_BACKEND_MAX];
+static int nr_aux_backends;
+
+/**
+ * damon_perf_aux_register_backend - Register an AUX backend ops table
+ * @ops: Backend callbacks to register.
+ *
+ * Called at initcall time by each backend.  Returns 0 on success,
+ * -ENOSPC if the static table is full.
+ */
+int damon_perf_aux_register_backend(const struct damon_perf_backend_ops *ops)
+{
+	if (nr_aux_backends >= AUX_BACKEND_MAX)
+		return -ENOSPC;
+
+	aux_backends[nr_aux_backends++] = ops;
+	return 0;
+}
+
+/**
+ * damon_perf_aux_find_backend - Find the backend that claims the PMU
+ * @perf_event: Created perf event whose PMU should be matched.
+ *
+ * Returns the ops table whose match_pmu() claims @perf_event->pmu
+ * (exact PMU object comparison), or NULL if no backend matches.
+ */
+const struct damon_perf_backend_ops *
+damon_perf_aux_find_backend(struct perf_event *perf_event)
+{
+	int i;
+
+	for (i = 0; i < nr_aux_backends; i++) {
+		if (aux_backends[i]->match_pmu &&
+		    aux_backends[i]->match_pmu(perf_event))
+			return aux_backends[i];
+	}
+	return NULL;
+}
+
+/**
+ * damon_perf_aux_select - Auto-select a backend for @event
+ * @event: DAMON perf event that will own the selected backend.
+ * @perf_event: Created perf event used for capability and PMU matching.
+ *
+ * Called from damon_perf_cpu_online() after the first perf_event is
+ * created.  Checks the PMU capabilities of the created event; if it has
+ * PERF_PMU_CAP_ITRACE, looks up a registered AUX backend that claims
+ * the PMU object of the created event.
+ * Overflow-handler PMUs (IBS, PEBS, generic counters) keep ops == NULL.
+ */
+void damon_perf_aux_select(struct damon_perf_event *event,
+			   struct perf_event *perf_event)
+{
+	if (event->ops)
+		return;		/* already assigned */
+
+	if (!(perf_event->pmu->capabilities & PERF_PMU_CAP_ITRACE))
+		return;		/* not an ITRACE / AUX PMU */
+
+	event->ops = damon_perf_aux_find_backend(perf_event);
+}
+
+/**
+ * damon_perf_aux_drain - Drain all AUX backends into the SPSC ring
+ * @ctx: DAMON context whose AUX events should be drained.
+ *
+ * Must be called BEFORE kdamond_check_reported_accesses() each tick
+ * so that freshly-parsed records are available for the ring drain.
+ * Also called at kdamond stop for a final flush.
+ */
+void damon_perf_aux_drain(struct damon_ctx *ctx)
+{
+	struct damon_perf_event *event;
+	int cpu;
+
+	/*
+	 * Hold the CPU hotplug read lock so that a concurrent CPU offline
+	 * callback cannot free the per-CPU backend resources (st->win,
+	 * AUX buffer) while drain is accessing them.  The offline path
+	 * runs under the write-side hotplug lock and clears aux_cpumask
+	 * before freeing, so once cpus_read_lock() is held any CPU still
+	 * in the mask has live resources.
+	 */
+	cpus_read_lock();
+	list_for_each_entry(event, &ctx->perf_events, list) {
+		if (!event->ops ||
+		    !(event->ops->flags & DAMON_PERF_BACKEND_AUX))
+			continue;
+		if (!event->ops->drain)
+			continue;
+
+		/* Only CPUs with initialized AUX resources. */
+		for_each_cpu(cpu, &event->aux_cpumask)
+			event->ops->drain(event, cpu);
+	}
+	cpus_read_unlock();
+}
diff --git a/mm/damon/perf/spe_backend.c b/mm/damon/perf/spe_backend.c
new file mode 100644
index 000000000000..42dd62cd0fcf
--- /dev/null
+++ b/mm/damon/perf/spe_backend.c
@@ -0,0 +1,479 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * DAMON Perf - ARM SPE Backend
+ *
+ * Implements the damon_perf_backend_ops for ARM SPE (Statistical
+ * Profiling Extension).  SPE delivers samples into an AUX trace buffer
+ * owned by the perf core: perf_event_setup_aux() allocates it at init,
+ * the arm_spe_pmu driver writes it through perf_aux_output_begin()/
+ * perf_aux_output_end() (updating rb->aux_head), and each kdamond tick
+ * this backend copies the newly written window [aux_tail, aux_head)
+ * into a linear scratch buffer, parses the SPE record stream (same
+ * packet encoding as tools/perf/util/arm-spe-decoder), and feeds
+ * synthesized damon_access_report entries into the per-CPU SPSC ring
+ * via damon_report_access().
+ *
+ * The AUX ring runs in non-overwrite streaming mode: when the buffer
+ * is full the PMU pauses itself, and this backend's drain both frees
+ * the space (advancing aux_tail) and re-enables the paused event.
+ *
+ * Parser and record layout live in spe_parser.h; the parsing function
+ * itself is kept in this module so the KUnit test (spe_parser_test.c)
+ * can exercise it without a perf PMU.
+ */
+
+#include <linux/bits.h>
+#include <linux/damon.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/perf_event.h>
+#include <linux/perf/arm_spe_pmu.h>
+#include <linux/rcupdate.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+#include "../ops-common.h"
+#include "aux_backend.h"
+#include "perf.h"
+#include "spe_parser.h"
+
+/*
+ * Parse one SPE record from the linear drain window.
+ *
+ * st->win holds a window of st->win_size bytes starting at the stream
+ * position st->aux_tail.  On success the cursor is advanced past the
+ * record.  An incomplete trailing record is retained in the AUX ring so
+ * the producer can finish it after the consumer releases any complete
+ * prefix records.
+ * SPE records are padded with PAD packets by the driver
+ * (arm_spe_pmu_pad_buf), so a complete record followed by padding
+ * reaches the window end only after the last record was committed.
+ */
+int spe_parse_one_record(struct spe_parser_state *st, struct spe_record *rec)
+{
+	unsigned int pos = 0;
+	unsigned int record_start = 0;
+	u32 local_tid = 0;
+	bool have_tid = false;
+	bool record_started = false;
+
+	memset(rec, 0, sizeof(*rec));
+
+	while (pos < st->win_size) {
+		u8 hdr = st->win[pos];
+		u8 hdr1;
+		u64 payload;
+		int width, index;
+
+		/* PAD - 1 byte, skip. */
+		if (hdr == SPE_HDR_PAD) {
+			pos++;
+			if (!record_started)
+				record_start = pos;
+			continue;
+		}
+		/* END - record terminator, no payload. */
+		if (hdr == SPE_HDR_END) {
+			record_started = true;
+			pos++;
+			goto record_done;
+		}
+		/* TIMESTAMP - record terminator, always 8-byte payload. */
+		if (hdr == SPE_HDR_TIMESTAMP) {
+			record_started = true;
+			if (pos + 1 + 8 > st->win_size)
+				goto truncated;
+			pos += 1 + 8;
+			goto record_done;
+		}
+		/* EVENTS / DATA-SOURCE - payload is not needed by DAMON. */
+		if ((hdr & SPE_HDR_MASK1) == SPE_HDR_EVENTS ||
+		    (hdr & SPE_HDR_MASK1) == SPE_HDR_SOURCE) {
+			record_started = true;
+			width = 1 << ((hdr >> 4) & 0x3);
+			if (pos + 1 + width > st->win_size)
+				goto truncated;
+			pos += 1 + width;
+			continue;
+		}
+		/* CONTEXT / OP-TYPE / EXTENDED share MASK2. */
+		if ((hdr & SPE_HDR_MASK2) == SPE_HDR_CONTEXT ||
+		    (hdr & SPE_HDR_MASK2) == SPE_HDR_OP_TYPE) {
+			record_started = true;
+			index = hdr & 0x3;
+			width = 1 << ((hdr >> 4) & 0x3);
+			pos += 1;
+		} else if ((hdr & SPE_HDR_MASK2) == SPE_HDR_EXTENDED) {
+			/*
+			 * Extended header: a second byte carries the
+			 * width and (for data packets) the upper index
+			 * bits.  hdr1 == 0 is the ALIGNMENT pseudo-packet:
+			 * consume bytes up to the next 2^(hdr[3:0]+1)
+			 * aligned position, exactly like
+			 * arm_spe_get_alignment().  hdr is the extended
+			 * marker (0x20), so this alignment is 2 bytes.
+			 */
+			if (pos + 2 > st->win_size)
+				goto truncated;
+			hdr1 = st->win[pos + 1];
+			if (hdr1 == SPE_HDR1_ALIGNMENT) {
+				/*
+				 * Alignment is relative to the original
+				 * AUX stream position, not the scratch
+				 * window.  st->aux_tail is the absolute
+				 * offset of the window start.
+				 */
+				unsigned long stream = st->aux_tail + pos;
+				unsigned int align = 1U << ((hdr & 0xf) + 1);
+				unsigned int skip = align -
+					(stream & (align - 1));
+
+				if (pos + skip > st->win_size)
+					goto truncated;
+				pos += skip;
+				if (!record_started)
+					record_start = pos;
+				continue;
+			}
+			if ((hdr1 & SPE_HDR_MASK3) != SPE_HDR_ADDRESS &&
+			    (hdr1 & SPE_HDR_MASK3) != SPE_HDR_COUNTER)
+				goto bad_packet;
+			record_started = true;
+			index = ((hdr & 0x3) << 3) | (hdr1 & 0x7);
+			width = 1 << ((hdr1 >> 4) & 0x3);
+			hdr = hdr1;
+			pos += 2;
+		} else if ((hdr & SPE_HDR_MASK3) == SPE_HDR_ADDRESS ||
+			   (hdr & SPE_HDR_MASK3) == SPE_HDR_COUNTER) {
+			record_started = true;
+			index = hdr & 0x7;
+			width = 1 << ((hdr >> 4) & 0x3);
+			pos += 1;
+		} else {
+			goto bad_packet;
+		}
+
+		if (pos + width > st->win_size)
+			goto truncated;
+
+		/* Little-endian payload. */
+		{
+			const u8 *src = st->win + pos;
+			int j;
+
+			payload = 0;
+			for (j = width - 1; j >= 0; j--)
+				payload = (payload << 8) | src[j];
+		}
+		pos += width;
+
+		if ((hdr & SPE_HDR_MASK2) == SPE_HDR_CONTEXT) {
+			/*
+			 * Bits 3-2 encode the context format:
+			 * 0 = 32-bit CONTEXTIDR_EL1,
+			 * 1 = 64-bit CONTEXTIDR_EL1 (FEAT_CONTEXTIDR_EL1_64).
+			 * Both carry the task pid in the lower 32 bits.
+			 */
+			if (((hdr >> 2) & 0x3) <= 1) {
+				local_tid = (u32)payload;
+				have_tid = true;
+			}
+		} else if ((hdr & SPE_HDR_MASK2) == SPE_HDR_OP_TYPE) {
+			/* LD/ST/ATOMIC class: payload bit 0 = store. */
+			if ((index & SPE_OP_CLASS_MASK) == SPE_OP_CLASS_LDST)
+				rec->is_write = !!(payload & SPE_OP_PKT_ST);
+		} else if ((hdr & SPE_HDR_MASK3) == SPE_HDR_ADDRESS) {
+			if (index == SPE_ADDR_DATA_VIRT) {
+				rec->va = payload & GENMASK_ULL(55, 0);
+				rec->have_addr = true;
+			}
+		}
+		/* EVENTS/COUNTER/TIMESTAMP payloads are ignored. */
+	}
+
+truncated:
+	/*
+	 * PAD and ALIGNMENT packets before the record are independently
+	 * consumable.  Keep the record itself in the AUX ring; the next
+	 * drain copies it again together with newly produced bytes.
+	 */
+	st->aux_tail += record_start;
+	st->bytes += record_start;
+	return SPE_PARSE_NEED_MORE;
+
+record_done:
+	st->aux_tail += pos;
+	st->bytes += pos;
+	if (!rec->have_addr)
+		return SPE_PARSE_SKIP;
+	rec->tid = have_tid ? local_tid : 0;
+	st->records++;
+	return SPE_PARSE_REPORT;
+
+bad_packet:
+	/* Resync one byte forward: drop the offending byte. */
+	pos++;
+	st->aux_tail += pos;
+	st->bytes += pos;
+	return SPE_PARSE_ERROR;
+}
+
+/* ---- Report synthesis ---------------------------------------------- */
+
+static void spe_submit(struct spe_record *rec, int cpu,
+		       struct perf_event *perf_event)
+{
+	struct damon_access_report report = {
+		.vaddr = rec->va & PAGE_MASK,
+		.size = PAGE_SIZE,
+		.cpu = cpu,
+		.is_write = rec->is_write,
+#ifdef CONFIG_DAMON_PERF_OBSERVE
+		.source = DAMON_REPORT_SRC_PERF_AUX,
+#endif
+	};
+
+	/*
+	 * CONTEXTIDR_EL1 carries the sampled task's pid, not its tgid.
+	 * Resolve pid -> tgid here under RCU (no lifetime pin) so
+	 * kdamond_check_reported_accesses() can match the report against
+	 * DAMON's pid targets.  A task that exits between sampling and
+	 * this lookup yields no match (tgid == 0), which mirrors perf's
+	 * own CONTEXTIDR semantics; pid-reuse can misattribute a sample
+	 * the same way it would in any hardware-context-based tool.
+	 */
+	if (rec->tid) {
+		struct task_struct *task;
+
+		rcu_read_lock();
+		task = find_task_by_vpid(rec->tid);
+		if (task) {
+			report.tid = rec->tid;
+			report.tgid = task_tgid_nr(task);
+		}
+		rcu_read_unlock();
+	}
+
+	/*
+	 * A missing or stale CONTEXTID cannot be attributed safely.  Do not
+	 * turn it into an access by assigning an arbitrary DAMON target.
+	 */
+	if (!report.tgid) {
+		damon_perf_observe_miss(rec->va, cpu,
+					DAMON_REPORT_MISS_TGID);
+		return;
+	}
+
+	/* reason 0 denotes a valid sample that is queued to the ring. */
+	damon_perf_observe_sample(rec->va, 0,
+				  0, cpu, 0, 0, perf_event->attr.sample_type);
+	damon_report_access(&report);
+}
+
+/* ---- Backend ops ---------------------------------------------------- */
+
+static bool spe_match_pmu(struct perf_event *perf_event)
+{
+	return arm_spe_pmu_match(perf_event);
+}
+
+static struct spe_parser_state *spe_state(struct damon_perf_event *event,
+					  int cpu)
+{
+	struct damon_perf *perf = event->priv;
+	unsigned long addr = (unsigned long)perf->aux_priv +
+			     per_cpu_offset(cpu);
+
+	return (struct spe_parser_state *)addr;
+}
+
+static int spe_backend_init(struct damon_perf_event *event, int cpu,
+			    struct perf_event *perf_event)
+{
+	struct damon_perf *perf = event->priv;
+	struct spe_parser_state *st;
+
+	int ret;
+
+	/*
+	 * Allocate the AUX buffer the PMU writes into.  Must happen
+	 * before the event is enabled (arm() ordering, see
+	 * damon_perf_event_arm()).  The buffer is non-overwrite
+	 * streaming: the PMU pauses itself when it fills up and this
+	 * backend re-enables it once the drain has freed space.
+	 */
+	ret = perf_event_setup_aux(perf_event, SPE_BUFFER_PAGES, 0);
+	if (ret) {
+		pr_warn_ratelimited("damon-perf: cpu %u aux setup failed: %d\n",
+				    cpu, ret);
+		return ret;
+	}
+
+	if (!perf->aux_priv) {
+		perf->aux_priv = alloc_percpu(struct spe_parser_state);
+		if (!perf->aux_priv)
+			return -ENOMEM;
+	}
+
+	st = spe_state(event, cpu);
+	memset(st, 0, sizeof(*st));
+	st->win = kzalloc(SPE_BUFFER_PAGES * PAGE_SIZE, GFP_KERNEL);
+	if (!st->win)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void spe_backend_cleanup(struct damon_perf_event *event, int cpu)
+{
+	struct spe_parser_state *st = spe_state(event, cpu);
+
+	kfree(st->win);
+	st->win = NULL;
+}
+
+static int spe_backend_arm(struct damon_perf_event *event, int cpu)
+{
+	struct damon_perf *perf = event->priv;
+	struct spe_parser_state *st = spe_state(event, cpu);
+	struct perf_event *perf_event;
+	unsigned long head;
+
+	perf_event = *per_cpu_ptr(perf->event, cpu);
+	if (!perf_event)
+		return -ENODEV;
+
+	/*
+	 * Start consuming from the current head so data written before
+	 * this session (e.g. a previous arm/disarm cycle) is discarded.
+	 * The consumer cursor must be moved too: perf_aux_output_begin()
+	 * computes free space from user_page->aux_tail.
+	 */
+	head = perf_event_aux_head(perf_event);
+	st->aux_tail = head;
+	if (perf_event_aux_tail_set(perf_event, head) < 0)
+		return -EIO;
+	st->records = 0;
+	st->bytes = 0;
+	st->armed = true;
+	return 0;
+}
+
+static void spe_backend_disarm(struct damon_perf_event *event, int cpu)
+{
+	struct spe_parser_state *st = spe_state(event, cpu);
+
+	/*
+	 * Prevent spe_backend_drain() from calling perf_event_enable()
+	 * during the final drain that follows perf_event_disable().
+	 * The resume-after-full logic is correct only while armed.
+	 */
+	st->armed = false;
+}
+
+static unsigned int spe_backend_drain(struct damon_perf_event *event, int cpu)
+{
+	struct damon_perf *perf = event->priv;
+	struct spe_parser_state *st = spe_state(event, cpu);
+	struct perf_event *perf_event;
+	unsigned long head, size, consumed;
+	long copied;
+	unsigned int drained = 0;
+
+	perf_event = *per_cpu_ptr(perf->event, cpu);
+	if (!perf_event)
+		return 0;
+
+	head = perf_event_aux_head(perf_event);
+	size = head - st->aux_tail;
+	/*
+	 * The AUX head/tail are absolute cursors that can span many
+	 * buffer sizes while the hardware runs.  If the window exceeds
+	 * the buffer size, skip the overwritten prefix (discarded data)
+	 * and clamp to one buffer worth of data.
+	 */
+	if (size > SPE_BUFFER_PAGES * PAGE_SIZE) {
+		st->aux_tail = head - SPE_BUFFER_PAGES * PAGE_SIZE;
+		size = SPE_BUFFER_PAGES * PAGE_SIZE;
+	}
+	if (!size)
+		return 0;
+
+	/*
+	 * Linearize the (possibly wrapped) window into the scratch buffer.
+	 * Do not parse unless the accessor copied the complete snapshot.
+	 */
+	copied = perf_event_aux_copy(perf_event, st->aux_tail,
+				     st->aux_tail + size, st->win);
+	if (copied < 0 || (unsigned long)copied != size)
+		return 0;
+	st->win_size = size;
+
+	while (drained < SPE_BUFFER_MAX_RECORDS) {
+		struct spe_record rec;
+		unsigned long tail0 = st->aux_tail;
+		int ret;
+
+		ret = spe_parse_one_record(st, &rec);
+		if (ret == SPE_PARSE_NEED_MORE)
+			break;
+
+		/* Drop the consumed prefix from the window. */
+		consumed = st->aux_tail - tail0;
+		st->win_size -= consumed;
+		memmove(st->win, st->win + consumed, st->win_size);
+
+		drained++;
+		if (ret == SPE_PARSE_REPORT)
+			spe_submit(&rec, cpu, perf_event);
+	}
+
+	/*
+	 * Release the consumed space back to the AUX ring.  If the tail
+	 * advance fails, do not resume a paused producer.
+	 */
+	if (perf_event_aux_tail_set(perf_event, st->aux_tail) < 0)
+		return drained;
+
+	/*
+	 * ARM SPE stops its hardware when a non-overwrite ring is full,
+	 * but leaves event->state ACTIVE.  perf_event_enable() therefore
+	 * cannot restart it by itself.  Move the event through OFF after
+	 * releasing space, then enable it again.  Do this only for a ring
+	 * snapshot that was exactly full and while the backend is armed;
+	 * the final drain after disarm must not restart the producer.
+	 */
+	if (st->armed && size == SPE_BUFFER_PAGES * PAGE_SIZE) {
+		perf_event_pause(perf_event, false);
+		perf_event_enable(perf_event);
+	}
+
+	return drained;
+}
+
+/* ---- Backend registration ------------------------------------------ */
+
+static const struct damon_perf_backend_ops spe_backend_ops = {
+	.name		= "arm_spe",
+	.flags		= DAMON_PERF_BACKEND_AUX,
+	.match_pmu	= spe_match_pmu,
+	.init		= spe_backend_init,
+	.cleanup	= spe_backend_cleanup,
+	.arm		= spe_backend_arm,
+	.disarm		= spe_backend_disarm,
+	.drain		= spe_backend_drain,
+};
+
+static int __init spe_backend_initcall(void)
+{
+	int ret;
+
+	ret = damon_perf_aux_register_backend(&spe_backend_ops);
+	if (ret)
+		pr_warn("damon-perf: SPE backend registration failed: %d\n",
+			ret);
+	return ret;
+}
+late_initcall(spe_backend_initcall);
diff --git a/mm/damon/perf/spe_parser.h b/mm/damon/perf/spe_parser.h
new file mode 100644
index 000000000000..ef9035ee7784
--- /dev/null
+++ b/mm/damon/perf/spe_parser.h
@@ -0,0 +1,109 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ARM SPE Record Format Definitions
+ *
+ * Constants and parser interface for the byte stream produced by the
+ * Statistical Profiling Extension (ARM ARM DDI 0487, Chapter D8).
+ * Packet encodings and decode order match
+ * tools/perf/util/arm-spe-decoder/arm-spe-pkt-decoder.c.
+ */
+
+#ifndef _DAMON_PERF_SPE_PARSER_H
+#define _DAMON_PERF_SPE_PARSER_H
+
+#include <linux/types.h>
+
+/* AUX buffer geometry. */
+#define SPE_BUFFER_MIN_PAGES	2	/* arm_spe_pmu_setup_aux() minimum */
+#define SPE_BUFFER_PAGES	16	/* 64 KiB per-CPU trace buffer */
+#define SPE_BUFFER_MAX_RECORDS	8192	/* per-drain record budget */
+
+/* Packet header masks/values (arm-spe-pkt-decoder.h). */
+#define SPE_HDR_MASK1		0xcf
+#define SPE_HDR_MASK2		0xfc
+#define SPE_HDR_MASK3		0xf8
+#define SPE_HDR_PAD		0x00
+#define SPE_HDR_END		0x01
+#define SPE_HDR_TIMESTAMP	0x71
+#define SPE_HDR_EVENTS		0x42
+#define SPE_HDR_SOURCE		0x43
+#define SPE_HDR_CONTEXT		0x64
+#define SPE_HDR_OP_TYPE		0x48
+#define SPE_HDR_EXTENDED	0x20
+#define SPE_HDR_ADDRESS		0xb0
+#define SPE_HDR_COUNTER		0x98
+#define SPE_HDR1_ALIGNMENT	0x00
+
+/* Address packet index for the virtual data address. */
+#define SPE_ADDR_DATA_VIRT	2
+
+/* OP-TYPE index bits[1:0] == 1 selects the LD/ST/ATOMIC class. */
+#define SPE_OP_CLASS_MASK	0x3
+#define SPE_OP_CLASS_LDST	0x1
+#define SPE_OP_PKT_ST		0x1
+
+/*
+ * Parser return values.  The distinction between NEED_MORE and SKIP is
+ * essential: NEED_MORE means the window ran out mid-record and the record
+ * remains unconsumed, while SKIP means a complete record was consumed that
+ * has no virtual address.
+ */
+enum spe_parse_ret {
+	SPE_PARSE_NEED_MORE = 0,	/* incomplete record retained */
+	SPE_PARSE_REPORT = 1,		/* complete record with a VA */
+	SPE_PARSE_SKIP = 2,		/* complete record without a VA */
+	SPE_PARSE_ERROR = -EINVAL,	/* bad packet; parser resynced */
+};
+
+/**
+ * struct spe_record - One parsed SPE record.
+ * @va:		DATA_VIRT address (bits[55:0]).
+ * @is_write:	Store/load class from OP-TYPE payload bit 0.
+ * @tid:	CONTEXTIDR_EL1 payload (the sampled task's pid).
+ * @have_addr:	An ADDRESS/DATA_VIRT packet was seen.
+ */
+struct spe_record {
+	unsigned long	va;
+	bool		is_write;
+	u32		tid;
+	bool		have_addr;
+};
+
+/**
+ * struct spe_parser_state - Per-(event,cpu) parser state.
+ * @win:	Linear copy of the drained AUX window (read-only for
+ *		the parser; the caller owns the buffer).
+ * @win_size:	Current window length (bytes).
+ * @aux_tail:	Absolute consumption cursor (rb->aux_head domain).
+ * @records:	Records parsed with a VA (session total).
+ * @bytes:	Bytes consumed (session total).
+ *
+ * spe_parse_one_record() never modifies @win.  It advances @aux_tail
+ * and @bytes by the bytes it consumes; the caller is responsible for
+ * dropping the consumed prefix from @win (memmove + win_size shrink)
+ * before calling again.
+ */
+struct spe_parser_state {
+	u8			*win;
+	unsigned int		win_size;
+	unsigned long		aux_tail;
+	unsigned int		records;
+	unsigned long		bytes;
+	bool			armed;
+};
+
+/**
+ * spe_parse_one_record() - Parse one record from the linear window.
+ *
+ * Reads the next record from @st->win (a window of @st->win_size bytes
+ * starting at the stream position @st->aux_tail) and advances
+ * @st->aux_tail past it.  Returns one of enum spe_parse_ret.
+ *
+ * An incomplete trailing record is retained.  The next drain reparses it
+ * from its first packet after the producer appends more bytes.  Leading PAD
+ * and ALIGNMENT packets can be consumed independently.
+ */
+int spe_parse_one_record(struct spe_parser_state *st,
+			 struct spe_record *rec);
+
+#endif /* _DAMON_PERF_SPE_PARSER_H */
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index a68c7262d533..814571c4db78 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -18,6 +18,7 @@
 #include <linux/sched/mm.h>
 
 #include "perf/perf.h"
+#include "perf/aux_backend.h"
 
 #include "../internal.h"
 #include "ops-common.h"
@@ -1159,6 +1160,21 @@ static int damon_perf_cpu_online(unsigned int cpu, struct hlist_node *node)
 	*per_cpu_ptr(perf->event, cpu) = perf_event;
 
 	damon_perf_observe_event_bound(event, cpu, perf_event);
+	if (!event->ops)
+		cpumask_clear(&event->aux_cpumask);
+	damon_perf_aux_select(event, perf_event);
+	if (event->ops && event->ops->init) {
+		int ret = event->ops->init(event, cpu, perf_event);
+
+		if (ret) {
+			pr_warn_ratelimited("damon-perf: cpu %u AUX init failed: %d\n", cpu, ret);
+			perf_event_release_kernel(perf_event);
+			*per_cpu_ptr(perf->event, cpu) = NULL;
+			event->any_cpu_failed = true;
+			return 0;
+		}
+		cpumask_set_cpu(cpu, &event->aux_cpumask);
+	}
 
 	/*
 	 * Late-online CPU after the substrate is armed: events are created
@@ -1167,6 +1183,16 @@ static int damon_perf_cpu_online(unsigned int cpu, struct hlist_node *node)
 	 * already-online CPUs.
 	 */
 	if (event->ctx && READ_ONCE(event->ctx->perf_events_active)) {
+		if (event->ops && event->ops->arm &&
+		    event->ops->arm(event, cpu)) {
+			if (cpumask_test_and_clear_cpu(cpu, &event->aux_cpumask) &&
+			    event->ops->cleanup)
+				event->ops->cleanup(event, cpu);
+			perf_event_release_kernel(perf_event);
+			*per_cpu_ptr(perf->event, cpu) = NULL;
+			event->any_cpu_failed = true;
+			return 0;
+		}
 		perf_event_enable(perf_event);
 		damon_perf_observe_event_enabled(event, cpu,
 				perf_event->state, perf_event->oncpu);
@@ -1188,30 +1214,58 @@ static int damon_perf_cpu_offline(unsigned int cpu, struct hlist_node *node)
 	if (perf_event) {
 		damon_perf_observe_event_destroyed(event, cpu);
 		perf_event_disable(perf_event);
+		if (event->ops && event->ops->disarm)
+			event->ops->disarm(event, cpu);
+		if (cpumask_test_and_clear_cpu(cpu, &event->aux_cpumask) &&
+		    event->ops && event->ops->cleanup)
+			event->ops->cleanup(event, cpu);
 		perf_event_release_kernel(perf_event);
 		*per_cpu_ptr(perf->event, cpu) = NULL;
 	}
 	return 0;
 }
 
-void damon_perf_event_arm(struct damon_perf_event *event)
+int damon_perf_event_arm(struct damon_perf_event *event)
 {
 	struct damon_perf *perf = event->priv;
 	struct perf_event *perf_event;
-	int cpu;
+	int cpu, failed_cpu = nr_cpu_ids;
 
 	if (!perf)
-		return;
+		return -EINVAL;
 
 	for_each_online_cpu(cpu) {
 		perf_event = *per_cpu_ptr(perf->event, cpu);
 		if (perf_event) {
+			if (event->ops && event->ops->arm &&
+			    event->ops->arm(event, cpu)) {
+				event->any_cpu_failed = true;
+				failed_cpu = cpu;
+				break;
+			}
 			perf_event_enable(perf_event);
 			damon_perf_observe_event_enabled(event, cpu,
 					perf_event->state,
 					perf_event->oncpu);
 		}
 	}
+	if (failed_cpu == nr_cpu_ids)
+		return 0;
+
+	/* Roll back CPUs enabled by this arm attempt. */
+	for_each_online_cpu(cpu) {
+		if (cpu >= failed_cpu)
+			break;
+		perf_event = *per_cpu_ptr(perf->event, cpu);
+		if (!perf_event)
+			continue;
+		perf_event_disable(perf_event);
+		if (event->ops && event->ops->disarm)
+			event->ops->disarm(event, cpu);
+		damon_perf_observe_event_disabled(event, cpu,
+						  perf_event->state);
+	}
+	return -EIO;
 }
 
 void damon_perf_event_disarm(struct damon_perf_event *event)
@@ -1227,6 +1281,8 @@ void damon_perf_event_disarm(struct damon_perf_event *event)
 		perf_event = *per_cpu_ptr(perf->event, cpu);
 		if (perf_event) {
 			perf_event_disable(perf_event);
+			if (event->ops && event->ops->disarm)
+				event->ops->disarm(event, cpu);
 			damon_perf_observe_event_disabled(event, cpu,
 					perf_event->state);
 		}
@@ -1272,6 +1328,8 @@ int damon_perf_init(struct damon_ctx *ctx, struct damon_perf_event *event)
 
 free_event:
 	damon_perf_observe_event_free(event);
+	if (perf->aux_priv)
+		free_percpu((void __percpu *)perf->aux_priv);
 	free_percpu(perf->event);
 free_perf:
 	kfree(perf);
@@ -1291,6 +1349,10 @@ void damon_perf_cleanup(struct damon_ctx *ctx, struct damon_perf_event *event)
 	cpuhp_state_remove_instance(damon_perf_cpuhp_state,
 			&event->hlist_node);
 
+	if (perf->aux_priv) {
+		free_percpu((void __percpu *)perf->aux_priv);
+		perf->aux_priv = NULL;
+	}
 	free_percpu(perf->event);
 	kfree(perf);
 	event->priv = NULL;
-- 
2.43.0


