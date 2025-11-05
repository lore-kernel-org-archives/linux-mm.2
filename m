Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B33A8CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A0668E001F; Wed,  5 Nov 2025 16:06:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 150DE8E0002; Wed,  5 Nov 2025 16:06:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 040028E001F; Wed,  5 Nov 2025 16:06:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E51388E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:06:02 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2534B9B46
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:06:02 +0000 (UTC)
X-FDA: 84077785764.11.7AA96A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2355D40012
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:06:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WOhlsM3F;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdJBQ+rWiBw2V4CFVKE2kVjSD7z/z7FLcRsM10EzZt4=;
	b=GWNuForC6OSFm2FzUBVV4INnbloKyEud2br0udFsCMU66SR/nT7Ag/2IST9J5Z0TOgzVmr
	mtqLigJSRtgHY0Yz3zq3Tb3qQO68O7WOKcfLKaJtG52iKwo3PzvdsOz1riUra2RVCu2CtE
	ihSS5U2aJ4ifoI021VB3pvJ+SZnLeVs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376761; a=rsa-sha256;
	cv=none;
	b=7WtB+bpZheju9lQkw09Xphxi3lOAFeojwfbCFqRUrrbS4UncVLDt23sOfd2iDGSOW0RtoE
	Kn09GIUQdbDoPklYeBYiPKVGAlFFzlUqn2eCt9lqstJxuEqRWI8w46iosEKoOEdVKxkj9n
	mlMCu0fz3xePJuU3f/uGrDrWEq/NXZo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WOhlsM3F;
	spf=pass (imf04.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9126C60227;
	Wed,  5 Nov 2025 21:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931BAC116B1;
	Wed,  5 Nov 2025 21:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376760;
	bh=v2zJK6mDWINhu5V45BvrdNTmRnVcCM3RKrdK2Jievec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOhlsM3FFPflzzkT+kungUw4CpxH4WtHCHs2d5HiMKT5nflQAjqznTB9idFhGi9j9
	 tRztsTxI9koU2H6Z3S6lkIFF9qmFzav/2u8hz+uvQB2wL5RQInBeh3R4ri0XnCSI/L
	 GKTmU+JnRlzeT5LmvFwcbWxVA7NWv3IMe2dOrHv3bm8xf7lqifjGolmaJ9b66D4hCa
	 98qA5BREUujP5Z+vrdxNj0VnMmqeIVDjPJeHddkqna0zv9syW0oOqFapktxNlVlp4f
	 kGURmDoYUwQZDXTMnR1JDZahFJALUF4V9l+OFovx6EBHHg/uJjmGKxPRiCTeGd9v9S
	 x3UKTy6CIPBGQ==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 15/31] sched/isolation: Flush vmstat workqueues on cpuset isolated partition change
Date: Wed,  5 Nov 2025 22:03:31 +0100
Message-ID: <20251105210348.35256-16-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cw6uw9c3pt6cb796ta3hscfyocthczfx
X-Rspam-User: 
X-Rspamd-Queue-Id: 2355D40012
X-Rspamd-Server: rspam01
X-HE-Tag: 1762376760-879088
X-HE-Meta: U2FsdGVkX19vjjGS85VGbHOQnj6ERzc124cvZjL5s+8Mx+L9Un34yM9cXaM+G2iQ26G5/gBRiCRloOZmW0INbZ2dCJBFjKqEQ/RtRiNdaXc11l0/ly7W//fqLWkZmLNaMal68CuGbHpk9mO2UrfFrvVRHE2EPCD2SFz3LFlK2/5KzYA0YV29bIsEiD1/H2GLPYdV67OJUhgDUHdgIU6HCwlBE/nGmfBCy4YDoRMKt4xkyvP50u26tHzMJ7cFZAsPQFq2BUAbMkv+9JmZkltEjP0WPTX1rrXTo9H2hDllJFLSpIY4vixBnn6xuXOD+ZysM3531Ywf6tHCh9313wHD87GMbEbvU/qskC6iRG2o5Ell/lPUKBn436iESf0+XJ2e7uZxrrV9Jrmj2keopg3MxuLwrd13dPsUm9WVnEMoH3139NbuwrWOAZeb4xARaIkJPvzMuPt2o7NU1yb20Idl2nfgFuEMwhzaz8D8UQT3EQHV6BwpJk3Em41I8q3rOa93hjHm+5/RkGfZYnMyUJweKXbWFx9l8GYDWkeLTAJAs73JYm//3mQrd562fYUjbO/5KlOjxKPTggJWg5/tFAJwv5310BAzNA5wzgR+q7P6/1SkuDwuZHgGp5yxe/T24H6aNjtUQ43gUH/iKUhXH0LO5D7IsNjJSH3q3EvXzi3pE9KOR2wB6tNkBqAqS7v3zY0rAyjhAcD8n7wFMuHQO3ILYtS02nju/pfcZjrJ9Xqoc/nJKKjNyUYsevcl1Ri7c6+V9u8XZ7BR6DC8UMVe6A8PGI6YYPtzHiVPnhWBwp8iAXAs1Qh1KW5MWoB3EExKWiMfkP1Sn4bDMZu4W3p3y8YUVPH2aJwAHZJW6MjI2tq5ZUWjw8qYwN7XOO/0UYJbP4mJEOfjX9NAzuh4SG7x/3ab/upm5/GJpGRkov+FVQNmjffeXYqI6C1ql4K0aLNFzfijXvoxBfCKIseJiLl419b
 T5AgDoqR
 WsxclGWWHVNQ1Ars/0QFlwWHLOa/ar0ff54hWu/Iqpq7YmdOLqu7CgAh/Tdx+u09jiLF5P8v9dCsaBAuE/kkeO1ShjJn/Yl6NB6QG0oPF+Ob8pnlU3wyLYYtsMwG3FHlq9OiapslAAUmgMZsgdmAEVnOeISKEJBKbmbAXNFsrtJEFv7UgXplYr2fgZy4sJC0a3xPCG3ahjC+Fu0HnmizGOXK980tjL5UX1j2yQb3ff5F9Hg8gkeUILN1UOTDHYSTL/n4Hamza5jXJitpNPAMYKcRZdSzAHxTQieMz5zoSBottneE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HK_TYPE_DOMAIN housekeeping cpumask is now modifiable at runtime.
In order to synchronize against vmstat workqueue to make sure
that no asynchronous vmstat work is still pending or executing on a
newly made isolated CPU, the housekeeping susbsystem must flush the
vmstat workqueues.

This involves flushing the whole mm_percpu_wq workqueue, shared with
LRU drain, introducing here a welcome side effect.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/vmstat.h   | 2 ++
 kernel/sched/isolation.c | 1 +
 kernel/sched/sched.h     | 1 +
 mm/vmstat.c              | 5 +++++
 4 files changed, 9 insertions(+)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index c287998908bf..a81aa5635b47 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -303,6 +303,7 @@ int calculate_pressure_threshold(struct zone *zone);
 int calculate_normal_threshold(struct zone *zone);
 void set_pgdat_percpu_threshold(pg_data_t *pgdat,
 				int (*calculate_pressure)(struct zone *));
+void vmstat_flush_workqueue(void);
 #else /* CONFIG_SMP */
 
 /*
@@ -403,6 +404,7 @@ static inline void __dec_node_page_state(struct page *page,
 static inline void refresh_zone_stat_thresholds(void) { }
 static inline void cpu_vm_stats_fold(int cpu) { }
 static inline void quiet_vmstat(void) { }
+static inline void vmstat_flush_workqueue(void) { }
 
 static inline void drain_zonestat(struct zone *zone,
 			struct per_cpu_zonestat *pzstats) { }
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 16c912dd91d2..8338c9259f4f 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -146,6 +146,7 @@ int housekeeping_update(struct cpumask *mask, enum hk_type type)
 	synchronize_rcu();
 
 	mem_cgroup_flush_workqueue();
+	vmstat_flush_workqueue();
 
 	kfree(old);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 77034d20b4e8..c638fc51fc07 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -68,6 +68,7 @@
 #include <linux/types.h>
 #include <linux/u64_stats_sync_api.h>
 #include <linux/uaccess.h>
+#include <linux/vmstat.h>
 #include <linux/wait_api.h>
 #include <linux/wait_bit.h>
 #include <linux/workqueue_api.h>
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 7afb2981501f..506d3ca2e47f 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2115,6 +2115,11 @@ static void vmstat_shepherd(struct work_struct *w);
 
 static DECLARE_DEFERRABLE_WORK(shepherd, vmstat_shepherd);
 
+void vmstat_flush_workqueue(void)
+{
+	flush_workqueue(mm_percpu_wq);
+}
+
 static void vmstat_shepherd(struct work_struct *w)
 {
 	int cpu;
-- 
2.51.0


