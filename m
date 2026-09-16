Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 555FDC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FCE56B0092; Wed, 16 Sep 2026 08:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B13E6B0096; Wed, 16 Sep 2026 08:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4B76B0098; Wed, 16 Sep 2026 08:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11E196B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:58:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 98753806FB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:58:00 +0000 (UTC)
X-FDA: 85219627920.02.7F71A50
Received: from mta0.migadu.com (out-27.mta0.migadu.com [91.218.175.27])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7786F100007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:57:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RBS8eGq6;
	spf=pass (imf05.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.27 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789563478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCKHX6atckv2J5YPbsDqkEfu88FFXr9lM+15ATh+s1w=;
	b=rXE2goesfeGha+5puvD9tHB+ok0RAUByR47Kag8a5D1T01MRbt7Acj5gN6pFIK/p1BcTAP
	Vp0gOE0WPII6vOIXiwSYdMaWOwUiyo7CasB+07wReM7uelPr+rYr6v+2/8MIZh5fwTco3r
	7IF6H+gimb9gC1xMXLxI8990vXO62BY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789563478;
	b=Ijt+W80XyoMXdR1akSN6e5AqIdZIi0LEoQU+l7nzhETKZRL4AjULTSr1HECKx1K44lrZMu
	Cdca24Ao/0xlhtfoFdzgdWp2Z7OX3xJwEie+YBAr4pshdniuVeb9MCkRoXZSjwfBy4o+TG
	cLlBVtIn0zAYi6Asf5LHzzCJQ/iltL0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RBS8eGq6;
	spf=pass (imf05.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.27 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IEvxqzkAIU0FGe2oQrIZRwY8Wtj6UnkhqHeEjHY4lJA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789563477; v=1; x=1790168277;
 b=RBS8eGq66dNjw/qupi3hQrAX1hPenzn0BBU2G0YAcEZmy3604q4V2quHRloawK1GWoYLrqXQ
 /iem2lOctPUNA6qiu6suOgsiF0bu7oBHaK0zuz+D6yoi7NfZsVcCtC2Z/DhkweWZugVddyHGx8V
 galXZSfyQYd3+T+EElFAPCvk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e1f141b1710aa4f6;
	Wed, 16 Sep 2026 12:57:57 +0000
X-Mizu-Trace-ID: e1f141b1710aa4f6
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: hannes@cmpxchg.org,
	mhocko@kernel.org
Cc: roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH 1/3] mm, memcg: introduce struct mem_cgroup_v1
Date: Wed, 16 Sep 2026 20:57:35 +0800
Message-ID: <20260916125737.1095414-2-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260916125737.1095414-1-cui.tao@linux.dev>
References: <20260916125737.1095414-1-cui.tao@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7786F100007
X-Stat-Signature: xrdemh1bsuxjc9yqbptixpim8a1hsp4a
X-Rspam-User: 
X-HE-Tag: 1789563478-295053
X-HE-Meta: U2FsdGVkX1+IiCTPFV9dQXvUe+96Tgt9mf+XKeg58RtA3U7Xj2DM7znAj3WmbowbG6FuNzyJPr79vpZgMUnLOwhzwACSRbm+zyqMfqLRIGAnu4o975dJC69iH6KBmzhYZI4XiETyDEqHEgiL/lsYPzDKctNf/xC+A6DsJ0R/cWiG08+PhfGY3nYuECQbG6aMV+UY5xnmewluIBwCipOrOpuK4aMdvPIOamfDw6EfOT5KPZIC70fGooJRtUzoOeTrCtEGU+impHPAdYLhwoYoIIcLMrF5jz8pH1rrvRomTf+Bt7lvnQTc7Op6U4M65VWIn+TYDxs0N7igWL/z8PAdHf2TAVRd846/rvpfgGAvcLTFWKPQGih+rI6M2cxLPcNt9EQ37+nj03Sk2u6sMJAiXTuUk+mUNetosJL53kc9TSkYQQVd3d0KDxmzddlAY2O/KAd4Cnwf2mM6nBYLWoDzEXfbLGvqtG9vHg6E0smFYzG00E6aex/AbpafwpzElHz1p4A4DhlhYcR9fJlW0IFSFL0dC7aLCLRHnK6Iu1TC0fb/wS2aJFmbLbfWyGWcX9skAYeurEB+ziU+cY0S9+urO3Xka5NBVJGLHqmbsOsq6KlHHabdLIocuW+dXuB8tnHvOEdx1/05IVrqvq64X2G7LNQrp6V3ylG7r/LeBR+4FKTE8YICux/s9ymOtdlTxcDvwZLSumT3jAg5dj5MvbbkOmkR1oA170NekMntY1wipJbOPH+kkHdr1D/lKhHmk0g97ni/J/6xd/xqPOAPsOL/Qobc1IiUdOYgRgJG3g2pzyMX8UIruxUA1nse+6NBHePU9Jtul+OFj9Nda9WBOQP8UTkAqXtT6K8PUo4QjQeQZchPNexMSvwtPV3mwGm8NNtto2Xe8DxX2iqFM+TWSja6tUASJU+jBmXwCMjE/weS4wm8RNDM9qQ6eT3mCjz+ZuKp6IocLuZ495vyLIgR7gj
 oANrURJ8
 46MYqVAwz37rEhJH0hYQJC52eO3ArpID1gQjP5aRBdSA8eVWQF08ipKKtdkmU7QGr7wm5ZMXMf0bUYTdIDqETgXYYAQC5l6/EVsvnH84cXf+FVAx9U0AinnUFcAJaq/aaExgTX/B9jhwgpIk/QHrhggDi/ZfGQYczpNdvDavb5cl79qQTqsRWpiqbJ8qBM4fDxQ8eUfede39T1znmwnzgqgX33OhVjGftXiFCPaN9k2+log82Y815is2x3kcVM6Y7xcSyVHZJkAGpUP7ddRZxdLqweQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tao Cui <cuitao@kylinos.cn>

The legacy cgroup v1 memory controller keeps its state as individual
members guarded by CONFIG_MEMCG_V1 inside struct mem_cgroup.  While the
v1 implementation already lives in mm/memcontrol-v1.c and its interface
is behind CONFIG_MEMCG_V1, its data is still intermixed with the shared
layout of struct mem_cgroup.

Group the v1-only members into a dedicated struct mem_cgroup_v1 and
embed it via a union whose anonymous side reproduces the historical
layout.  All existing memcg->X accesses keep compiling and the binary
layout is unchanged.  The anonymous side is dropped by the next patch
once the access sites are converted.

No functional change.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 include/linux/memcontrol.h | 97 ++++++++++++++++++++++++++++----------
 1 file changed, 71 insertions(+), 26 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 46bf724cae7a..beb68f39c321 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -193,6 +193,43 @@ struct obj_cgroup {
  * statistics based on the statistics developed by Rik Van Riel for clock-pro,
  * to help the administrator determine what knobs to tune.
  */
+/*
+ * Legacy cgroup v1 memory controller state, used only by the v1
+ * interface (mm/memcontrol-v1.c).
+ */
+struct mem_cgroup_v1 {
+	struct page_counter kmem;
+	struct page_counter tcpmem;
+
+	struct memcg1_events_percpu __percpu *events_percpu;
+
+	/* protected by memcg_oom_lock */
+	bool oom_lock;
+	int under_oom;
+
+	int oom_kill_disable;
+
+	struct mutex thresholds_lock;
+
+	/* RCU-protected */
+	struct mem_cgroup_thresholds thresholds;
+
+	/* RCU-protected */
+	struct mem_cgroup_thresholds memsw_thresholds;
+
+	/* For oom notifier event fd */
+	struct list_head oom_notify;
+
+	bool tcpmem_active;
+	int tcpmem_pressure;
+
+	/* List of events which userspace want to receive */
+	struct list_head event_list;
+	spinlock_t event_list_lock;
+
+	int swappiness;
+};
+
 struct mem_cgroup {
 	struct cgroup_subsys_state css;
 
@@ -271,42 +308,50 @@ struct mem_cgroup {
 	__cacheline_group_end_aligned(memcg_cold);
 
 #ifdef CONFIG_MEMCG_V1
-	/* v1 only. Not grouped: v1 is legacy, sorting it is not worth it. */
+	/*
+	 * Transitional: the anonymous struct reproduces the historical layout
+	 * so existing memcg->X accesses keep compiling; it is removed once the
+	 * access sites are converted to memcg->v1.X.
+	 */
+	union {
+		struct mem_cgroup_v1 v1;
+		struct {
+			/* Legacy consumer-oriented counters */
+			struct page_counter kmem;		/* v1 only */
+			struct page_counter tcpmem;		/* v1 only */
 
-	/* Legacy consumer-oriented counters */
-	struct page_counter kmem;		/* v1 only */
-	struct page_counter tcpmem;		/* v1 only */
+			struct memcg1_events_percpu __percpu *events_percpu;
 
-	struct memcg1_events_percpu __percpu *events_percpu;
+			/* protected by memcg_oom_lock */
+			bool oom_lock;
+			int under_oom;
 
-	/* protected by memcg_oom_lock */
-	bool oom_lock;
-	int under_oom;
+			/* OOM-Killer disable */
+			int oom_kill_disable;
 
-	/* OOM-Killer disable */
-	int oom_kill_disable;
+			/* protect arrays of thresholds */
+			struct mutex thresholds_lock;
 
-	/* protect arrays of thresholds */
-	struct mutex thresholds_lock;
+			/* thresholds for memory usage. RCU-protected */
+			struct mem_cgroup_thresholds thresholds;
 
-	/* thresholds for memory usage. RCU-protected */
-	struct mem_cgroup_thresholds thresholds;
-
-	/* thresholds for mem+swap usage. RCU-protected */
-	struct mem_cgroup_thresholds memsw_thresholds;
+			/* thresholds for mem+swap usage. RCU-protected */
+			struct mem_cgroup_thresholds memsw_thresholds;
 
-	/* For oom notifier event fd */
-	struct list_head oom_notify;
+			/* For oom notifier event fd */
+			struct list_head oom_notify;
 
-	/* Legacy tcp memory accounting */
-	bool tcpmem_active;
-	int tcpmem_pressure;
+			/* Legacy tcp memory accounting */
+			bool tcpmem_active;
+			int tcpmem_pressure;
 
-	/* List of events which userspace want to receive */
-	struct list_head event_list;
-	spinlock_t event_list_lock;
+			/* List of events which userspace want to receive */
+			struct list_head event_list;
+			spinlock_t event_list_lock;
 
-	int swappiness;
+			int swappiness;
+		};
+	};
 #endif /* CONFIG_MEMCG_V1 */
 
 	/*
-- 
2.43.0


