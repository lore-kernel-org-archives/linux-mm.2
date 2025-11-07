Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7467CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 23:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C64C8E0029; Fri,  7 Nov 2025 18:40:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276638E0006; Fri,  7 Nov 2025 18:40:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 165B78E0029; Fri,  7 Nov 2025 18:40:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00C128E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 18:40:54 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1DC8160330
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 23:40:54 +0000 (UTC)
X-FDA: 84085433628.22.A221623
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 01D5D4000F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 23:40:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CJdquOFk;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762558853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/IBXXmQT6HU9XyqJOJH4DC8oXV/wM5t8TSqxI0nVn0E=;
	b=j0tAOhWCKTkqbN1rCRFfUC6XrGfONStWWUFFS/IcitiWJgqsH7fzm3IzHSAncGWHi5OBVV
	kmpixZqLjjBeTYGpLl9bGg0MNzvGDuq+wSoFyosN/JYceJ14vzicjl56bjxTFS9hEUP8NS
	BmbDAg6INDCBSakOokwj/nBWZqvvgHQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762558853; a=rsa-sha256;
	cv=none;
	b=2srGdPHQGFgZ92bDuR1OOgNmkvaskeszw8FHY5kpdBNUdJjZxxpqsK1PVh59jWiXNIFgXu
	1rindl719eG73aTR6x67fmpnjLqX7n5SBs2wvCGOIzQUb4pbQnW/oVdS76+VBtkEY5Ngte
	YCGiDwZ91LXW5l7GDNZalWu4VLWH184=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CJdquOFk;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762558850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/IBXXmQT6HU9XyqJOJH4DC8oXV/wM5t8TSqxI0nVn0E=;
	b=CJdquOFkgso7i4s8SSmNNC0ZzfMELSZNYUpwf6zqIIQ/zYA33bEJWPtRQaUh/8XtjGDUs2
	EbwO8BPL4v0NIoBKt6oLehSqCnJw0oTtg/tSr38hP5jijKmVa1O/VCTUrSh5Dm/NaYqI1m
	Fsqsa5stw7fanplmYSNHUSqMhB5vnPs=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: [PATCH] mm: memcg: dump memcg protection info on oom or alloc failures
Date: Fri,  7 Nov 2025 15:40:41 -0800
Message-ID: <20251107234041.3632644-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 01D5D4000F
X-Stat-Signature: njwsyr4dhxh7o49smp157m6ied316f4z
X-Rspam-User: 
X-HE-Tag: 1762558852-258703
X-HE-Meta: U2FsdGVkX18srA+m3ppwh4p5iSyKb6rePRbC35mOIqB2rQx0z7XxIbEYb1c0m5HO8IY7wx+KEmSkfjdW4a2I4sE9N0xJoM+SOy/fMdswgd69YOnquUHsvcwGe9R1mH+rSY5BLQmuYFD8BXQ92C+df3EaOmshwOO6/stXChDuiVCi1BTZAQTByWwc5mRcIZZRoudMxbhexVdty29ItCw1kBhwOLgLT3lPmEGT7RdrZ8t/ZoiYYbHypu+5FG0uNDd8tJr1/IXq0VMJ5s62+kARVWWkRz0QiyvgoJTpD1gdO83YnXOl2F3ZUN6MncUTL9KUmuPfjIcdqH8olL01zEfuDir23VpSV9kYfQ0X8Bhz+aGCDUgY8Aa0CAbjnyn/Ddln6x6fBNGv5p+MTYc1TG7qLl/Q5xt/vEq4pbZiN5hPc68u4mCQ/GT7dUSu0hfY6Zo7zEiCeoO3j3D3a4StRSjYtHLFFy07SaqgMp0hnH5nMSw/EZkHsGJmHC6QHj7BK8K1zVIjrLBUbi49ID3qTsM1jEPqCYJho39rdsdAdk4nur5gapLOo3jdn2v2qmBw5JzT/ubzotrPp6t2MH0wZ5djVuTPV0yZv1DaGDYLuwBGf5ek7aEkNbJ0J/n7nn1Ji4BhrG/IpnhU6oV8hxhK9SGi3sZ02ba6gYSl+/IGDZkfNO166NiOB0/7M6zdk+SyUY/dq/XMuf5MFhDCSIcwwuAxDudiLMwHbuLmVg7Se0unM9V8yfXBwI17C+RtanNk4nZ4aJM60WxE/POJ//30QTVdwSCswcz09vKjwtMfzqrKFEcbDbiS+8g59RHowHRoPg7oJv2W+EFd8dfbZdKo2Np1amAzMPpK8gJ6ph8z/HxJ+yDZgQZ0qnadyWILcXlDbBLlvbhsPK/h1Yxyeg79nKdEjst/vjVrgSoyNsLnW1BUYYQ8Ea6LsbqMMmL0evrZEBlj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently kernel dumps memory state on oom and allocation failures. One
of the question usually raised on those dumps is why the kernel has not
reclaimed the reclaimable memory instead of triggering oom. One
potential reason is the usage of memory protection provided by memcg.
So, let's also dump the memory protected by the memcg in such reports to
ease the debugging.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h |  5 +++++
 mm/memcontrol.c            | 13 +++++++++++++
 mm/oom_kill.c              |  1 +
 mm/page_alloc.c            |  1 +
 4 files changed, 20 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8d2e250535a8..6861f0ff02b5 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1779,6 +1779,7 @@ static inline bool memcg_is_dying(struct mem_cgroup *memcg)
 	return memcg ? css_is_dying(&memcg->css) : false;
 }
 
+void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
 #else
 static inline bool mem_cgroup_kmem_disabled(void)
 {
@@ -1850,6 +1851,10 @@ static inline bool memcg_is_dying(struct mem_cgroup *memcg)
 {
 	return false;
 }
+
+static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
+{
+}
 #endif /* CONFIG_MEMCG */
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c34029e92bab..623446821b00 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5636,3 +5636,16 @@ bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
 {
 	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
 }
+
+void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
+{
+	if (mem_cgroup_disabled() || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
+	if (!memcg)
+		memcg = root_mem_cgroup;
+
+	pr_warn("Memory cgroup min protection %lukB -- low protection %lukB",
+		K(atomic_long_read(&memcg->memory.children_min_usage)*PAGE_SIZE),
+		K(atomic_long_read(&memcg->memory.children_low_usage)*PAGE_SIZE));
+}
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index c145b0feecc1..5eb11fbba704 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -472,6 +472,7 @@ static void dump_header(struct oom_control *oc)
 		if (should_dump_unreclaim_slab())
 			dump_unreclaimable_slab();
 	}
+	mem_cgroup_show_protected_memory(oc->memcg);
 	if (sysctl_oom_dump_tasks)
 		dump_tasks(oc);
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e4efda1158b2..26be5734253f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3977,6 +3977,7 @@ static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
 		filter &= ~SHOW_MEM_FILTER_NODES;
 
 	__show_mem(filter, nodemask, gfp_zone(gfp_mask));
+	mem_cgroup_show_protected_memory(NULL);
 }
 
 void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
-- 
2.47.3


