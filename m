Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FF55CD3438
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 19:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8C78E0013; Wed, 12 Nov 2025 14:30:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89858E0002; Wed, 12 Nov 2025 14:30:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2A5C8E0013; Wed, 12 Nov 2025 14:30:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A2E48E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:30:06 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B5B6C05EF
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:30:06 +0000 (UTC)
X-FDA: 84102945612.01.DFE9F9E
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6145780017
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:30:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bEcJLiwb;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762975804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9HfsEAYF9yiUWWUj5tMirDvvn0FEtJ7B1MIYMFDuxY=;
	b=h4KKVB/QJAo/nfNQ0v+2vl4mJPnMrDIFZ8ku/caF607AUWoso2ueJLEvYs0Q05DUuTb0rc
	UZP8IUzG4kx3V642bWIabF9rQQ49R8vf+jHjAr+167kJm3OL40Fj32SyVi8pprQbhM3wPl
	IdtQlrSpnmKBtKbySB2Hy4ON6DkDxss=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bEcJLiwb;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762975804; a=rsa-sha256;
	cv=none;
	b=xf5sQdy2kcQP3VA1Y1BjckNAcdFwjdLhGBcRr1FLTyBm7szuXc+KvCG0vJBYvNeQpPxrPB
	nZcwvVLF+gvSxCKJ+jzhZF6GywiYe0umW10hn8dQ4UUnitXUQYEjLbPxg/4z3Vgb1K1WwQ
	wXvMcHRF0cy0b97Iu0MWjNjncHU4Mlc=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8b2656561e6so112839085a.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762975803; x=1763580603; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S9HfsEAYF9yiUWWUj5tMirDvvn0FEtJ7B1MIYMFDuxY=;
        b=bEcJLiwbZ/UWD5HwkRP0OAHrLPmFE8cXs6GaJ+T1ofct9bkstpAka3ZESjxzxlQR2N
         VUsgCMRolQ6HWjs7G0IVX2LgcBUfT0MQcrqrUrqZfh2H1Kk0Bw0q3h1zO8LXfTSQN9W0
         WuJ3fasJV5a4ojY9xHnD/HIWOXDzsnuth5Uggxbpydo3R2kOubvVXctrto0SS+kvvUya
         RkM2jHYgixR4KIxsdx4QSDfXePhuOwg8wsxsu3VYJx3L8+wlCIWoi7RU/mh9d8F9jDE3
         ntiz3ghSe7dWJbLwi/R6DVCJYw0GBQfxrDY8R6rOee5fuk4eYBfbMJ43tGHLUZfFFZDU
         WGUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975803; x=1763580603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S9HfsEAYF9yiUWWUj5tMirDvvn0FEtJ7B1MIYMFDuxY=;
        b=syNN9xXDvXIlu+jo893gCAu/nZtwiYubNtD3ossvDHlaZOg5Cj9NF8crogXOnZWpIT
         tbLNL/s9RuTXne1TeArJM1wcUhxddIEYG+k1SI0/koSTCKmkBoHlDuk5NZttzQ9LlDrp
         KHYVRuADT7SuZXmXkzScN4b00oNn2soW0LWReuT0k9g6Fmg3MzfVNRfo4wcAecnf0k9z
         AV/jQno71xu3K+oE3eAzJ65qSGdTSLXONC6eQ5lvfZMA+/eBN5zjloUFDYuT9BGGH/RD
         /7ZMwLy8Fx4vj6RdZGMruQ/DWiUhW/E5Jnfz0KNfO5pCxwGTFEM6dt6ip0bzx7T77eVO
         22UQ==
X-Gm-Message-State: AOJu0Yx0ONoXdOYZjEfiyWTkWk0CTHWLTyP1iTJMquxPd8qOsm5ZXF2s
	CtAWUOKANLN6arH3E86OoInQGtJrun4UwNwMGICj0UUA1KklJSJTLnnR+zSJq4cHLGiCBKKwEkP
	jazVH
X-Gm-Gg: ASbGncvEhOfofQJLkII1MYwMeQtseSYz37NckDX3TwVhufOtwYJSyuIqsUyPnf9bDg5
	v9oaXrklpMmB5LM74NV9/ZsZU+f4ACKXIqib8HvV6lNbFF8dsiPTkBJcXWBlZPi+OqWcy249XK7
	3TmH8Zed/8XB1tZdGDRihkQ4y47qWx0W74rPhNFQfRwpvkA8pUssLncsgZw5aByoYHPp7y8EA2R
	CdE9M+9MJq6Yg07rfScKxMiMl8Wxe2jsbiPLTEGtuv355uUvHr9KYoVXc3esot6fgbH5Irhl8Yb
	1obkb9sZNcJ2x36iufs2VpcPgJUffl3shXuyGM0JIzC6tPrOIObfKbJmH4DUyIOLw+sp6vl3ny2
	nWr7d1/yF9l1+EHpNgPSL8rnnNAPSiWge0TzrVlD0VeBuK0iCWs8Z6BAvJOTYRyTiN5t7L8/mcz
	TU/env3rUdxXqPsPWpcJIoQAA8vFpBzWRHKLF4Ka8J0Zqsi0XTd9Ur+N9OYftD3Ol8
X-Google-Smtp-Source: AGHT+IEVluARmCpMkOWEYo8q4r5FDTRBhMVJs5VhBJ+XJ3044t3Im4FugeCYJRKlNUbrCKiFOXWBbg==
X-Received: by 2002:a05:620a:1914:b0:8b2:73f0:bd20 with SMTP id af79cd13be357-8b2ac200a20mr88765385a.39.1762975803034;
        Wed, 12 Nov 2025 11:30:03 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa0082esm243922885a.50.2025.11.12.11.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:30:02 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	kees@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	rientjes@google.com,
	jackmanb@google.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com,
	rrichter@amd.com,
	ming.li@zohomail.com,
	usamaarif642@gmail.com,
	brauner@kernel.org,
	oleg@redhat.com,
	namcao@linutronix.de,
	escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: [RFC PATCH v2 05/11] mm: restrict slub, oom, compaction, and page_alloc to sysram by default
Date: Wed, 12 Nov 2025 14:29:21 -0500
Message-ID: <20251112192936.2574429-6-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112192936.2574429-1-gourry@gourry.net>
References: <20251112192936.2574429-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6145780017
X-Stat-Signature: pdhnjmxd7e4xowec6hije7m9uxjrgoex
X-Rspam-User: 
X-HE-Tag: 1762975804-841967
X-HE-Meta: U2FsdGVkX18ZHI3MM6GhknGjsnFjferEifz16mw0oX+hxKhgAnRISyyjsPlKLNUX4BxihGScd277rlfwtICcNfEcJLuLwk2vviwB1iZf8+ZFvdjSzqGUZIiENbC/Cu6j7X72kaPrmrjMRc6ldrWvtx4DqzzwprHuE75S0DQdl0eX5D6klJu0tJOq5mKnhqA8eanAcXZouhFEr6QEhiOmPZTcs/cuusJ96XCrNOH32XPJAeEArrmtLC/i59yJPMxwrYduSExTM4LDEKgUi+xOUEUB64kSnkA/S1BfsRRZuu0X8Jx+DEZKDEW9YA8EmjmtBzHQsrjYpyxrVRlAjrtszhP6NO8tAFq9Lc/ARgzIYRu7O46wWpiz7QUo7UwphKcOJdP7hWNKzTUGQuxEmxigivfglTgRoqxI50IA/2WSO7XxDYfgh812/siNmttIhGx34AtZHtuf5pJROqWNm54DrYk8zPxKC/rcMll1DPA3UzTlLOVZKvYq/nwxqui/bWpmgo013AV6Le949IvJH/eQIuqq3SjGM9TEj20oOQoWMniq4shH6utu3iOPlvUqSe+e1ALyYimZ3uWAtUBLe3KDKo0FTi0IH4fzYruv5MK+CRgt7B4nyT5DZ0TEiSSosPghD58CBspHjFMYv7MBhQ6h/06xje0yEUkqADfO5wohq8Z+C15u71s5UjcPw4vGj17CngqiR62oGAHyiG5gwvUJOKDkcf8LFrbMYtOakLEUqlY+yaX1cq+d2uFDKQAGjMRZetUjT7ro2QCbz20SRg4OPelmDPP21l3534kuupDGk0pcRD+JiNBwWZ2+b7QPR5QisSbqE0hn958RF2An7ebkyXsZjSJ77SYVBELgXmx7bVoqAvzJjuIiszQ6DoFm7jQHIw5fUenKeK0/YRXmsU04nUOsN+yx/8yJfgs0ON9H6k9qXTN/+aowrD0FLZBE332UVWm8mQyQyLHortWRXjT
 Wr5xPuym
 O8etN3WO3gB13oJnIbpuyjqeQYDbdxiAxZ0s8P71+jXJ6hs2zvhtUYwS5IuIxZmyMkohBQhFl4KD2OeeRrZamPS3zFLcKUT2TL5tPpEgJ1om9FUBX/cj60sWDzUNnpumJh9jfALhgeGdszPzZqqlyTxbW3hR/hzOC/RT7OfiiIxnvx+tDjoIhONQfleMen2GeAaWMtmVLxNZ3Xnuu/tNn/F7GUp4FGl8lKVuzQUAa9efZe0yRz7lMJ9DPasr2G2msBtaQtDfxXxq/ehMF/mzy0OzpnOuT0SRoZ9pizptXDcXTlTacWj/QzFzNnpe69TFieyxfqxPFzCqeZb9ErxUuBEGmNT2SzVgTyRvS991Zt7AcnUdI6Kq+WWwLmvI7zLyQuzoT0jxQ9lZlMM0mSXTgbyP2SAB0KjjTcTcPe9oqQm2dh5hUO0wlFYS2l4Cjjprio0+kMuoODuFlshE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Restrict page allocation and zone iteration behavior in mm to skip
SPM Nodes via cpusets, or mt_sysram_nodelist when cpusets is disabled.

This constrains core users of nodemasks to the mt_sysram_nodelist, which
is guaranteed to at least contain the set of nodes with sysram memory
blocks present at boot (or NULL if NUMA is compiled out).

If the sysram nodelist is empty (something in memory-tiers broken),
return NULL, which still allows all zones to be iterated.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/compaction.c |  3 +++
 mm/oom_kill.c   |  5 ++++-
 mm/page_alloc.c | 18 ++++++++++++++----
 mm/slub.c       | 15 ++++++++++++---
 4 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index d2176935d3dd..7b73179d1fbf 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -13,6 +13,7 @@
 #include <linux/migrate.h>
 #include <linux/compaction.h>
 #include <linux/mm_inline.h>
+#include <linux/memory-tiers.h>
 #include <linux/sched/signal.h>
 #include <linux/backing-dev.h>
 #include <linux/sysctl.h>
@@ -2832,6 +2833,8 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 		if ((alloc_flags & ALLOC_CPUSET) &&
 		    !cpuset_zone_allowed(zone, gfp_mask))
 			continue;
+		else if (!mt_node_allowed(zone_to_nid(zone), gfp_mask))
+			continue;
 
 		if (prio > MIN_COMPACT_PRIORITY
 					&& compaction_deferred(zone, order)) {
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index c145b0feecc1..386b4ceeaeb8 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -34,6 +34,7 @@
 #include <linux/export.h>
 #include <linux/notifier.h>
 #include <linux/memcontrol.h>
+#include <linux/memory-tiers.h>
 #include <linux/mempolicy.h>
 #include <linux/security.h>
 #include <linux/ptrace.h>
@@ -1118,6 +1119,8 @@ EXPORT_SYMBOL_GPL(unregister_oom_notifier);
 bool out_of_memory(struct oom_control *oc)
 {
 	unsigned long freed = 0;
+	if (!oc->nodemask)
+		oc->nodemask = mt_sysram_nodemask();
 
 	if (oom_killer_disabled)
 		return false;
@@ -1154,7 +1157,7 @@ bool out_of_memory(struct oom_control *oc)
 	 */
 	oc->constraint = constrained_alloc(oc);
 	if (oc->constraint != CONSTRAINT_MEMORY_POLICY)
-		oc->nodemask = NULL;
+		oc->nodemask = mt_sysram_nodemask();
 	check_panic_on_oom(oc);
 
 	if (!is_memcg_oom(oc) && sysctl_oom_kill_allocating_task &&
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bcaf1125d109..2ea6a50f6079 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -34,6 +34,7 @@
 #include <linux/cpuset.h>
 #include <linux/pagevec.h>
 #include <linux/memory_hotplug.h>
+#include <linux/memory-tiers.h>
 #include <linux/nodemask.h>
 #include <linux/vmstat.h>
 #include <linux/fault-inject.h>
@@ -3753,6 +3754,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		if ((alloc_flags & ALLOC_CPUSET) &&
 		    !cpuset_zone_allowed(zone, gfp_mask))
 			continue;
+		else if (!mt_node_allowed(zone_to_nid(zone), gfp_mask))
+			continue;
 		/*
 		 * When allocating a page cache page for writing, we
 		 * want to get it from a node that is within its dirty
@@ -4555,6 +4558,8 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 		if ((alloc_flags & ALLOC_CPUSET) &&
 		    !cpuset_zone_allowed(zone, gfp_mask))
 			continue;
+		else if (!mt_node_allowed(zone_to_nid(zone), gfp_mask))
+			continue;
 
 		available = reclaimable = zone_reclaimable_pages(zone);
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
@@ -4608,7 +4613,7 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
 	 */
 	if (cpusets_enabled() && ac->nodemask &&
 			!cpuset_nodemask_valid_mems_allowed(ac->nodemask)) {
-		ac->nodemask = NULL;
+		ac->nodemask = mt_sysram_nodemask();
 		return true;
 	}
 
@@ -4792,7 +4797,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * user oriented.
 	 */
 	if (!(alloc_flags & ALLOC_CPUSET) || reserve_flags) {
-		ac->nodemask = NULL;
+		ac->nodemask = mt_sysram_nodemask();
 		ac->preferred_zoneref = first_zones_zonelist(ac->zonelist,
 					ac->highest_zoneidx, ac->nodemask);
 	}
@@ -4944,7 +4949,8 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 			ac->nodemask = &cpuset_current_mems_allowed;
 		else
 			*alloc_flags |= ALLOC_CPUSET;
-	}
+	} else if (!ac->nodemask) /* sysram_nodes may be NULL during __init */
+		ac->nodemask = mt_sysram_nodemask();
 
 	might_alloc(gfp_mask);
 
@@ -5053,6 +5059,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		if ((alloc_flags & ALLOC_CPUSET) &&
 		    !cpuset_zone_allowed(zone, gfp))
 			continue;
+		else if (!mt_node_allowed(zone_to_nid(zone), gfp))
+			continue;
 
 		if (nr_online_nodes > 1 && zone != zonelist_zone(ac.preferred_zoneref) &&
 		    zone_to_nid(zone) != zonelist_node_idx(ac.preferred_zoneref)) {
@@ -5187,8 +5195,10 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	/*
 	 * Restore the original nodemask if it was potentially replaced with
 	 * &cpuset_current_mems_allowed to optimize the fast-path attempt.
+	 *
+	 * If not set, default to sysram nodes.
 	 */
-	ac.nodemask = nodemask;
+	ac.nodemask = nodemask ? nodemask : mt_sysram_nodemask();
 
 	page = __alloc_pages_slowpath(alloc_gfp, order, &ac);
 
diff --git a/mm/slub.c b/mm/slub.c
index 1bf65c421325..c857db97c6a0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -28,6 +28,7 @@
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/mempolicy.h>
+#include <linux/memory-tiers.h>
 #include <linux/ctype.h>
 #include <linux/stackdepot.h>
 #include <linux/debugobjects.h>
@@ -3576,11 +3577,19 @@ static struct slab *get_any_partial(struct kmem_cache *s,
 		zonelist = node_zonelist(mempolicy_slab_node(), pc->flags);
 		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
 			struct kmem_cache_node *n;
+			int nid = zone_to_nid(zone);
+			bool allowed;
 
-			n = get_node(s, zone_to_nid(zone));
+			n = get_node(s, nid);
+			if (!n)
+				continue;
+
+			if (cpusets_enabled())
+				allowed = __cpuset_zone_allowed(zone, pc->flags);
+			else
+				allowed = mt_node_allowed(nid, pc->flags);
 
-			if (n && cpuset_zone_allowed(zone, pc->flags) &&
-					n->nr_partial > s->min_partial) {
+			if (allowed && (n->nr_partial > s->min_partial)) {
 				slab = get_partial_node(s, n, pc);
 				if (slab) {
 					/*
-- 
2.51.1


