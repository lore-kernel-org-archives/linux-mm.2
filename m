Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E38BC5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 06:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A173A6B08F1; Tue, 18 Aug 2026 02:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C80C6B08F3; Tue, 18 Aug 2026 02:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7266B08F4; Tue, 18 Aug 2026 02:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CC4F6B08F1
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:11:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED028120ADD
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:11:33 +0000 (UTC)
X-FDA: 85113368466.29.FCF225C
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1F11B40003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:11:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PpgfE9Fu;
	spf=pass (imf04.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787033492;
	b=kS12fQHP+T5mQ7k7M0xyUMxOr7fWCpCymokEbbEu/+KiEcUvTSI06RZK2fMROncVFtP/8Z
	ayo32rhjGTA46SiEdckRctFz+PmjrTbbrYxtpiTbNP8t322tWTQg8qXYN5z1OOg0+FoMuk
	W+5oVY6L9ODaHGhCMKCuon7FkXE/NPk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PpgfE9Fu;
	spf=pass (imf04.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787033492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qyQvFdJaou+co7R0CJUYpuqHbBnGV73Fl2ebn6kSllM=;
	b=ttuEjJ3s/RzCl46eMTidvUCQ/CX7ZT5g7lZjw6Vno/n9XxiCofea3eGDkP5cjOgs74xCdS
	rB8AfW/OK976T2JCVU4K+zSiekRNnvH5tJpjXtGV25zZ1SpVP7/g2Q6ORr5tkS7mHE/Uwt
	msMKDqunGbZJTsWpurGkm1E+xTCBOz8=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so4314715a91.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787033491; x=1787638291; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qyQvFdJaou+co7R0CJUYpuqHbBnGV73Fl2ebn6kSllM=;
        b=PpgfE9FuS50FUx0GgI/oqv0TE3iZeL0645bGgta7gEepaLEVFCAEZbwZQmMcKrd+MF
         kQQ9/ELBhwdWWAdqpghUZQjEiKnTK9Q9YBicwWQBxoHyK8FUVR2UkCjmE1ngtKg7mKdN
         e1ldfbZEZOEWUFUjJUb5OQCxN7g2/h8mCc6Ocmxnv38yn7B0DuCyl9zylih0ip12MjoI
         0rGJ3ywf5b5cgDHHUofi70ArRKaHMdCAgboNlNC2kxwLOf27FJ7RCfIBNylJvqDRqgnf
         WhnuqIUf0QzZ+yIEqQ32VrAAh0K3LwWXo7wYG3Wp4Zn9hRUPecKQ4I8CJUPUh5B9MsWN
         LFbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787033491; x=1787638291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qyQvFdJaou+co7R0CJUYpuqHbBnGV73Fl2ebn6kSllM=;
        b=hTO5xduAggc+Qs2DesOmzwNjoWVGQ5ebxcJwrtiJTA9oBNyoOf7ZVwyeEq08ANWvV4
         XeTuMZR8UtqIee4RxfQgPUnrOTawchVA/tAhnaatYEC1fm9YOyK5jGYZfobf5/c3AHxd
         MI3UL0uBY6rs5cdxzNgaI8rNbsB6MFW3dbXAZMSlDE56Mm5YuZNubyjuGAW2yZdqg+Er
         B4R66ISCPUadeJsds2C9X0W5dwMS7FSXzXl4GCeA99ZoDu/ccyv/cbhQdwp8apJHoemX
         3vT02ew31MixR5whpWLsd3eCc9q0KAZt3caMvJYPcLis3N33OoxTXaa9YoQJABw3KZtP
         fk8w==
X-Forwarded-Encrypted: i=1; AHgh+RpxO9v64fBlpRDlqtQ/ScIWtDOBQIMMIxpej4eUhhBfbDDcXGwO0Eut50jpI++I2RHEmMrYsBaJrQ==@kvack.org
X-Gm-Message-State: AOJu0Yxu0qz21f3N4t4vc9MDWj/bO0vjaspS0olqadhwl6KJMqqlNuRn
	XQDhQJ+8UN3lllrsqTRDelsTiXcqwnaYTI8C/DOydYShE5Df8iGSJEX8
X-Gm-Gg: AR+sD13AUIyE1VF24iidbvUKnqU/swO0Sm17z8kS00XON/jZ1SSX17RCRD9x2fjtn9q
	WADhiRzhrn7qFIl162sQy9e0kclfIL0ZWPhqvFQTZxLBgJlecqvCa83cXhgvOSwRkb9U/na/Jwq
	KTVpkD+PhVdsN3CK7o2KMXfwK+sMK1oMaPlwlwvFynOLgUpjVaTEsrJccbBtVdvv5jqelqEfB9S
	u36BjHUrtK7hfDSnUs+x5rUX9VuGFzqRS7Y6mY8d3cra3U+S+GytO/8F4D5ze+onqqXiMyTspaO
	TU8P7Mld1k974gs7W/2MoasavR1K4kMOMdj4HUfALVaKzeoqzFnjLGnPQyuELCoCD22zgm/YWhe
	F2SEuym4kfTO9d0QgIkEdfZRG3ZWQ5Ihd0vgI4ECf0HLBmCtG58ozxUQB4Jb9n92UwqVYz+AMpM
	7CHA62tYIU5qNm8mIB4Qz1mCPUIX1ZIJ18LIpGjWg1/HNjQoV6ddR8XN25cvhjRvPFITezzPQoG
	7Qz3ME=
X-Received: by 2002:a17:90b:39a6:b0:37c:6130:7a5b with SMTP id 98e67ed59e1d1-3955a7467f8mr6401620a91.8.1787033490697;
        Mon, 17 Aug 2026 23:11:30 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3954d38bf94sm4633942a91.9.2026.08.17.23.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 23:11:30 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	shuah@kernel.org,
	lianux.mm@gmail.com,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [RFC PATCH 7/7] mm/damon/perf: add CONFIG_DAMON_PERF_DEBUG and pipeline health check
Date: Tue, 18 Aug 2026 14:10:31 +0800
Message-ID: <20260818061031.827057-8-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260818061031.827057-1-kunwu.chan@linux.dev>
References: <20260818061031.827057-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1F11B40003
X-Stat-Signature: ipeifgxcd6s88j8g7fqaec68mcon6k36
X-HE-Tag: 1787033491-344754
X-HE-Meta: U2FsdGVkX19AqdkV2FIy9ViyaMbZj/DDa8cZze/Fpaaj4EyDslru6v7Kjqq2JwSixValvTwjsk2qxhJJvffI4xMoKI3pgsXKgS/WzkMTtWdc9G8swj4FWa9xY03cI2V+gx2vtC9BzTuOVbHuj4c2rHW0crCq+GrKHzU5SVaXzRipYMjs3e9fEtYNIWCk87zTCxfTZJwYIgU5TEHAMGNLQASr+KKLNG9TKUbOFJKl5samz/2qb3nZrnj3ahmPqv0F5cjWaDShbwfFbVYSktk7MoO8vco7unoxwXXVnRgyelcSFUXL/pyF1pfhz+voTE3nuXj0q1Pmfnqs0dlWlndUnDK4kdOyWuK/uBQ4fqFM6tIkTXICYA0pW4gckj0bDtgfZGU7+3ZTD4HJdvqYnrIOWGfGG9Nt6fBE2AazBKDqpqUDY0beMiHe14BHVHMBxnq+7anmZTsXade4gpufxGWhCoaFjfR1gmRA9Oy3w76Yvd/GDfYC4eJW4L963UZyFz66tZqtQlu2zSaTNbXvDXsGu4gekoQ/C+gQhc2/ttBZ9LZ1vZ4tB0fGNeOZZ+3TSnJoAVgMcSXDFQzMAabaykvwrNE8VOwOjRXNUPSYuVtBobVdouDNCbOSdtarfCRMjK99CjgldWehC1fm4qC+JnmPJ7PzQNwNSqK08u8tiXOM8GGFQHgiJU1tLQ01JgpvhTNhUa5lRMkcEJiGhzax8bHVsMrKOKi6vBaAqTGWAlGxKDt0YW/RzEoYcEeBFQzQmsNg0lcB3eoyXog9BgYnfx2N2E5/fcr/HYplBjl8RudCxMpOXgcRwCgTxRMYj9ZX76ks+c5tl1opX/38EaHKfr1iK5l4jK4r0TPNoTxjU2JJE+VnycGro0D/Ra/wLLsHr67m597m43lQvr2Juhs2qrpBNHFx8HTNO3wbre3+vkYL25oVJ8Hjd7yhg2m8LCMsxhvLzX27bdOST+OnKgoX0ZN
 DpXj2PMj
 ClHWl1Vs3IS2ojq5zsfGpMkjME/+4b0yTlMFKcyK6kIse6PmDR7SRwqMl00qRTcYbBXo+5X8+gCkXJcFk56intkU+PcfQAE41sdFwnCBrO5EM4BgEXyZ8TfEMz19CnqAQf+6aad4c/3vD6V5WCUtgobD71MOtjbH94R7sCCpw3BcHDvcDI/RlNOXr+yZft6x/A+PUNuWsWvIQDBNpevylJfoQKk9iUlY0pPLBW6saT3x3G9292E6lHV9W+6YidddxzavwC9b/3oX1Q60d+MgYMyHmOH2TdpvHewgW9+OiVqPdFSWMe6SY6Ei8baY2wYOOtvZWj5p43GL3DKF7H+R+d/oRCrw079BJ+92i7b+DsGxl14+3fjewSs/ijA+kMmEqbHyxXqM+Xrm4K91rq8X5tOQg0z49r/arXAqg0mQbPEaGoTYvQ06UiVtISTtfzeO9dHMAAj+f0G36Kwmvf9+pHWRzixb/Ye6HwZJ/6MJ6Yx9p2nncS7QFx+oz4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lian Wang <lianux.mm@gmail.com>

Add CONFIG_DAMON_PERF_DEBUG as an optional Kconfig option that
enables pr_debug() output for the observability pipeline via the
damon_perf_dbg() macro.  Default off, zero overhead when disabled.

Add a pipeline health check to the observability selftest that
diagnoses which stage is broken when callbacks are zero, using the
existing per-CPU state and counter deltas.

Co-developed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/damon/Kconfig                               | 16 ++++++++++++++++
 mm/damon/perf/debugfs.c                        |  5 ++++-
 mm/damon/perf/perf.h                           |  7 +++++++
 mm/damon/perf/stats.c                          | 15 ++++++++++++++-
 .../selftests/damon/damon_perf_obs_test.sh     | 18 +++++++++++++++++-
 5 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index 9f811510760f..35ec4d12c5b8 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -148,4 +148,20 @@ config DAMON_PERF_OBSERVE
 	  static-inline no-ops with zero runtime overhead.
 
 	  If unsure, say N.
+
+config DAMON_PERF_DEBUG
+	bool "DAMON Perf verbose debugging output"
+	depends on DAMON_PERF_OBSERVE
+	help
+	  Enable verbose per-event and per-drain pr_debug() output
+	  for the DAMON perf observability pipeline.  When enabled,
+	  key lifecycle transitions and sampling events are logged
+	  at KERN_DEBUG level, visible via dynamic_debug or when
+	  DEBUG is defined at compile time.
+
+	  This adds dmesg noise and should only be enabled for
+	  development or troubleshooting.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/mm/damon/perf/debugfs.c b/mm/damon/perf/debugfs.c
index c54dd7644ac3..48f3d23c2dbc 100644
--- a/mm/damon/perf/debugfs.c
+++ b/mm/damon/perf/debugfs.c
@@ -132,11 +132,14 @@ int damon_perf_debugfs_init(void)
 	damon_debugfs_dir = debugfs_create_dir("damon", NULL);
 	if (damon_debugfs_dir == ERR_PTR(-EEXIST))
 		damon_debugfs_dir = debugfs_lookup("damon", NULL);
-	if (IS_ERR(damon_debugfs_dir))
+	if (IS_ERR(damon_debugfs_dir)) {
+		damon_perf_dbg("debugfs init failed: %ld\n", PTR_ERR(damon_debugfs_dir));
 		return PTR_ERR(damon_debugfs_dir);
+	}
 
 	debugfs_create_file("perf_stats", 0400, damon_debugfs_dir,
 			NULL, &perf_stats_fops);
 
+	damon_perf_dbg("debugfs init ok\n");
 	return 0;
 }
diff --git a/mm/damon/perf/perf.h b/mm/damon/perf/perf.h
index 78e23d436336..908c06f2e3db 100644
--- a/mm/damon/perf/perf.h
+++ b/mm/damon/perf/perf.h
@@ -18,6 +18,13 @@
 struct perf_event;
 #include <linux/types.h>
 
+#ifdef CONFIG_DAMON_PERF_DEBUG
+#define damon_perf_dbg(fmt, ...) \
+	pr_debug("damon-perf: " fmt, ##__VA_ARGS__)
+#else
+#define damon_perf_dbg(fmt, ...) no_printk(fmt, ##__VA_ARGS__)
+#endif
+
 struct damon_perf_event;
 
 /*
diff --git a/mm/damon/perf/stats.c b/mm/damon/perf/stats.c
index ae5b0037a31d..e2c1e5764d41 100644
--- a/mm/damon/perf/stats.c
+++ b/mm/damon/perf/stats.c
@@ -67,6 +67,7 @@ void damon_perf_observe_event_created(struct damon_perf_event *event, int cpu)
 			return;
 	}
 	*per_cpu_ptr(event->cpu_state, cpu) = DAMON_PERF_STATE_CREATED;
+	damon_perf_dbg("cpu %d: event created\n", cpu);
 	damon_perf_cpu_state_advance(cpu, DAMON_PERF_STATE_CREATED);
 }
 
@@ -76,6 +77,7 @@ void damon_perf_observe_event_bound(struct damon_perf_event *event,
 	if (event->cpu_state)
 		*per_cpu_ptr(event->cpu_state, cpu) = DAMON_PERF_STATE_BOUND;
 	damon_perf_cpu_state_advance(cpu, DAMON_PERF_STATE_BOUND);
+	damon_perf_dbg("cpu %d: event bound\n", cpu);
 }
 
 void damon_perf_observe_event_enabled(struct damon_perf_event *event,
@@ -84,12 +86,14 @@ void damon_perf_observe_event_enabled(struct damon_perf_event *event,
 	if (event->cpu_state)
 		*per_cpu_ptr(event->cpu_state, cpu) = DAMON_PERF_STATE_ENABLED;
 	damon_perf_cpu_state_advance(cpu, DAMON_PERF_STATE_ENABLED);
+	damon_perf_dbg("cpu %d: event enabled\n", cpu);
 }
 
 void damon_perf_observe_event_disabled(struct damon_perf_event *event,
 		int cpu, int state)
 {
 	/* State unchanged: the event may be re-enabled later. */
+	damon_perf_dbg("cpu %d: event disabled\n", cpu);
 }
 
 void damon_perf_observe_event_destroyed(struct damon_perf_event *event, int cpu)
@@ -104,6 +108,7 @@ void damon_perf_observe_event_destroyed(struct damon_perf_event *event, int cpu)
 	 */
 	if (event->cpu_state)
 		*per_cpu_ptr(event->cpu_state, cpu) = DAMON_PERF_STATE_UNINIT;
+	damon_perf_dbg("cpu %d: event destroyed\n", cpu);
 }
 
 void damon_perf_observe_event_free(struct damon_perf_event *event)
@@ -111,6 +116,7 @@ void damon_perf_observe_event_free(struct damon_perf_event *event)
 	if (event->cpu_state) {
 		free_percpu(event->cpu_state);
 		event->cpu_state = NULL;
+		damon_perf_dbg("event freed\n");
 	}
 }
 
@@ -231,6 +237,7 @@ void damon_perf_observe_drain(unsigned int total, unsigned int matched)
 {
 	if (trace_damon_perf_drain_enabled())
 		trace_damon_perf_drain(total, matched);
+	damon_perf_dbg("drain: total=%u matched=%u\n", total, matched);
 }
 
 /*
@@ -291,5 +298,11 @@ void damon_perf_stats_aggregate(struct damon_perf_stats *dst)
 
 int damon_perf_framework_init(void)
 {
-	return damon_perf_debugfs_init();
+	int ret = damon_perf_debugfs_init();
+
+	if (ret)
+		damon_perf_dbg("framework init failed: %d\n", ret);
+	else
+		damon_perf_dbg("framework init ok\n");
+	return ret;
 }
diff --git a/tools/testing/selftests/damon/damon_perf_obs_test.sh b/tools/testing/selftests/damon/damon_perf_obs_test.sh
index 4c4074cdd191..cd567c151ae6 100755
--- a/tools/testing/selftests/damon/damon_perf_obs_test.sh
+++ b/tools/testing/selftests/damon/damon_perf_obs_test.sh
@@ -344,7 +344,7 @@ max_cpu_state() {
 	} END { print max+0 }' "$1" 2>/dev/null
 }
 
-CPU_ST_BASE=$(max_cpu_state "$STATS_BASE")
+CPU_ST_BASE=$(max_cpu_state /sys/kernel/debug/damon/perf_stats)
 
 if [[ "$CPU_ST_BASE" -ge 1 ]]; then
 	pass "Event Created (max per-CPU state >= CREATED)"
@@ -431,6 +431,22 @@ VALID=$(delta valid)
 ADDR_ZERO=$(delta addr_zero)
 KERNEL=$(delta kernel)
 ENQUEUE=$(delta enqueue)
+# Pipeline health check: diagnose which stage is broken when
+# callbacks are zero, using the existing per-CPU state and
+# counter deltas.  This is a best-effort diagnostic, not a
+# substitute for detailed per-backend debugging.
+if [[ "$CALLBACK" -eq 0 ]]; then
+	CPU_ST_BASE_VAL=$(max_cpu_state /sys/kernel/debug/damon/perf_stats)
+	if [[ "$CPU_ST_BASE_VAL" -le 1 ]]; then
+		echo "  Pipeline diagnosis: event not created or bound (state=$CPU_ST_BASE_VAL)"
+	elif [[ "$CPU_ST_BASE_VAL" -eq 2 ]]; then
+		echo "  Pipeline diagnosis: event bound but not enabled (state=BOUND)"
+	elif [[ "$ENQUEUE" -eq 0 ]]; then
+		echo "  Pipeline diagnosis: PMU not producing data or AUX pipeline broken"
+	else
+		echo "  Pipeline diagnosis: samples enqueued but none valid"
+	fi
+fi
 DEQUEUE=$(delta dequeue)
 OVERFLOW=$(delta overflow)
 MATCH=$(delta match)
-- 
2.43.0


