Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6273EC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 589D46B009E; Fri,  7 Aug 2026 16:21:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 513C86B009F; Fri,  7 Aug 2026 16:21:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 319EE6B00A0; Fri,  7 Aug 2026 16:21:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8CE26B009E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:21:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D4C6A14E7
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:18 +0000 (UTC)
X-FDA: 85075593036.22.6010D34
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id ACB0912000E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WuC2WdYj;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UreOU1bs1UnYmmJ7pTF9AE47T3l1T/OGD/BO7qMZ90c=;
	b=g+4jkElQY4ksPnaxrdBvjQmOZBiwQy0VThrHFxfGqRbLuAzKZ72g1i/2zOBqJDig5xjBOk
	XSkHjX/BS91aASed2Re9DZPB4n1Q0mpMPT1SYtm6JI6KGKwqKd3xnX1RqmeDBk1jQ+hMry
	CThbJVyHpPTVeG8yLuIRv2PJESyEHRM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WuC2WdYj;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134076;
	b=G2BVmxx3E+7VCLRfMlfc9Q2YNNA5PQmgR+/25aQQQjjce9wGd+iWK4r858luiFwFraqtb2
	pHL0YM1Vfel6XhPhjR1IubwnLR98rXDSA3JNxV2uMsMRKbfB5Q6ivwIowtebdV4UAKVQ4H
	Kt1DLrOKWHXILPYyLNI4xycIQ8ZTE2Q=
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7e6b5737bb2so3319080a34.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 13:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134076; x=1786738876; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UreOU1bs1UnYmmJ7pTF9AE47T3l1T/OGD/BO7qMZ90c=;
        b=WuC2WdYjLHNKXkXk3dOEOHJ824GNxq4RsRcfpBcANImkmdm3AA7i7cO8teY9avSbA5
         z0QP/fM3pOrJGKOCc3F8xMbomkA3zoAEG3i2Zy7sT/x2lgIZzpyaXLWb5D03GLZr4k5p
         wM05v7k8GNOIQa4WEy3ri4UNMMcnDPpZP913ncAkb79q3ILuAF+UuJfYodPg9ePWOn3U
         Nkh9SWum4COtkfMnIyV8fQGF71koDZSGYzT21NAFMVNrDdpyhSNViODgv6IS5acmPG5w
         0xc8jDM02jhiJQrkZdmsArIqdYa0jS4D0eHNYwSSTCLKh7MppbmC2VYDX5RAlrCs4m0b
         uBXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134076; x=1786738876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UreOU1bs1UnYmmJ7pTF9AE47T3l1T/OGD/BO7qMZ90c=;
        b=FMjx1Yl8Qc00zgkZNRVR+fVA2VJv56ODlS6dRO6/X0Bp5Vay12v6PS+9dOJ5Bnn5Os
         WwDIA1lw3Yi7kJc5jxbtSpBdzFHWPz5s3pCxrB6cFOh3zGnHMjgnZ0T+ErQzPzjtDAAs
         cZenj8MvEY+oDhED8mnWYD5lphZ6UswBLHgfhqsYxecZDlzw/EOhIJKwWZgxpVwgJ31d
         8AVQTzKfWvSILEI8MVUE0QrJqDmDkCxzp25eHybfNH6AmpSmoIP2f1kn+gdDXpOvtSWw
         7nSpF4Yt2NPxg1ica9gYFus6Se9gWLfdFJWS1fbs5dUP/Wkd947pc6n+FrvlxMMGBmGy
         gzkA==
X-Forwarded-Encrypted: i=1; AHgh+RqwTCBv2FksitA4mkD03uCaIr0yyIAvXl8sevB1igFpHTshn2506sXluYDhsjroVz73JsfX8GphnQ==@kvack.org
X-Gm-Message-State: AOJu0Yzb5HNnOvNuW5c8zXFC+cKqsj/MSmnvDFW2JNfmuQZ6xw8piaq5
	Av7T3Gc25Kaxrd3mZ0nzJotljQAbgNe+M5E/vRf25ivWLaGsbYMpqogb
X-Gm-Gg: AR+sD12zQejzOKv6aU3iHjyYVpM7pbh8RiStf/obrV8e+twBp0RR5i463slg/4VAghA
	mrbuk8InxHOKc41Z+1gTb6GZ5KIUWUg6ioBBpgdbQpvCgwroyysemE200IM/hTJiswNsx5jznyu
	K21YR+tPALbo3BR/5jkvcFC5T99rTobCpXWsdkHq1blQBb9q5cmcHk0Nu48/ODph7tKFWObAE2h
	t+OmyILkpnGrSKCLxSiqwCVuwyefpZNcYMaklDwXixJT1yccDcD6e6ivp1udt4IfkFjJ2E5LiBz
	HVixNpWdIVdBo3e0yE3bYoyRE1YrFCiob7hxY/Yz4Na7EBa7PH+BURtWyYaOkaQ+SkL1ThA7P09
	wqdoAg03nEKBlSZ4/Dhsjddl2sfUR+P7eE8MOseH9feEIxawYWeh+/m5S993sPb5Smkkt0B0xMW
	MnrutFlDdlgClZmZYoHqJiWS+fMdzLJrVVyMuW6YF1YxbgY3LdlPDlzGbirE+QVAo950ZbBnEHF
	lML5vjKgR4wopB8Os0=
X-Received: by 2002:a05:6820:4dfc:b0:6a1:7790:258e with SMTP id 006d021491bc7-6ae96ec782bmr14629606eaf.18.1786134075612;
        Fri, 07 Aug 2026 13:21:15 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:58::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02be8ede0sm3225544eaf.12.2026.08.07.13.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:14 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 10/14] mm/memcontrol: Make memory.max tier-aware
Date: Fri,  7 Aug 2026 13:20:53 -0700
Message-ID: <20260807202059.2620949-11-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ACB0912000E
X-Stat-Signature: k1fht4kc7idfxaf5efcqidstbbphmzi1
X-HE-Tag: 1786134076-736154
X-HE-Meta: U2FsdGVkX1+pw8HRbcjqJ1uS0cv9d5Od2Z5NHFrelkCesFY0zXYctgl4gLLBO1O8wdCj0BYr2fVxAcEmAB1xWXU9vRqhXuo/8da1+DOTalNFEOPp18xFHH0Yvkqt1dhyriEJzRISPnwr1L22wZqhi3PsF0b1PRS1xSO4WfwlX0VL4gaUWdS33mx/DfGZ5hRMXzm8bbOSmpABdG+GjAjUyXXNTBn+hFgQXRgApU7RUno+LMMxXlyhY20BIYXEmJPNrJ8y01e5ghpxpjSMf1ZgNq9i2vRraRCpWXdSpb588xzljApUHKRCxOQPc9vtJe3ul7F3Bt/NowmyidumxA8iYoqLblqC4IgOhksR2EvE5gTOY0ku635qbibuvuokr9Yn9fVUQGoSoMsZt4ENu7LOVyvw5u1mGe/XN5QfD+hmmewTGbf3eAFUy+6oWWDqz13CTDK4Rq9Do+TPmjwLpDWMyvOY+cKjRyA9NjmX4k7RzBXJtU+ESw4o1kWawFsT6rGIWgK9e0gLeJR9ffHbZ8+8HQmS+2JhRbSb8G0FzRbd6dWlK8N7eJa4iQLvKNgN3OQwOYQYV2uCuEXNBCDmg8z8URaLdrHL8uU2xzZsaj1WRrxnFxPAmyiHUYrbBoIHV6pfMj9ZPBqf6k07mFmnAl1nfBCNZz8gBC6Tb+QzR3N5Uq0mF4giFuw+X1uCvPfrSAIo7ote803BIPaFesJ550PtpGAw7auObhnfaUMRQgTRQ/5bkffUvuVhhNOnanuivfxDD5jgcueFkqXhqDLy8OsAu35I2slyKornGVUs+lXWmqzRrZ8Vy8VR7dx0+IM5CX4avmFfcAJjCI4ipiCRlgwnCj/HTwoFGgOyep7RPQnyGOpjuvqKDJoYvgP5F2nHU4eOeDFwfYcKg5jLtl6KbcXJcr0FSlsETPeeE02sXqCZ4luT4rXhUNM6r7zjswyPFFYLOtmmdWHqHZRqBP5qGpb
 ek0Y6LCD
 xc/X7OqV3icLJ86WBpl/2wMbnjUth1tXX5pkxruemEfoH9daSk1uw2HqdXRIKBOuc9WquIPEIrZPcc3tQyGlXn5XcezyJzFPHWhyW+vFo+BrTr4HO/0N+7b3mmBxq9kt1edKcopiMDmHrTjZug3bKV5o8p+vi2bkTdH7Fw4pdW2NuKY6LVKZSTTuf0uDbcTI+8UXaJykve6K2G+vtcKhA3Nm6k/QBZJNG/wmxWr+F9yNBtDFQwBQJWdipkqp//lPFuRMIx0Cbxp1KpZMSDAyzRS6mssA+7OxgGUr0RWV28mBl0c28prMyBg87L6JjpPbsFaGPjjxrh48J/pZBxQy0bR+mkcucSw9+v7lQ8GVeG4eo1C70Xl2EkIYkSyyZNsZvG2PEHPOoMxNT6kG7IOFT8219RdrvIU082qDGnotOultMQ2v0hEPtAmQeV8c/vo1chhZiVMB6b26I8GwU3hkYh7x5iVfdY41i18JwQmgO8QenXeBjbqukVp9Ua0EanJSbGi9R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On machines serving multiple workloads whose memory is isolated via
the memory cgroup controller, it is currently impossible to enforce a
fair distribution of tiered memory among the workloads, as the only
enforceable limits have to do with total memory footprint, but not
where that memory resides.

Extend the existing memory.max limit to be tier-aware. A folio charge
is now attempted against the page_counter of the tier the folio was
allocated on, in addition to memory and memsw. When the tier counter
is over its limit, reclaim is targeted at that tier's nodes only.

Tier counters are parent-linked index-for-index with the memcg
hierarchy, so the counter reported by page_counter_try_charge() belongs
to an ancestor of the charging memcg.  memcg->tier is a separate
allocation, so container_of() cannot recover the owner;
tier_counter_mem_cgroup() walks the chain instead. This is only done
on the charge failure path.

mem_cgroup_margin() takes the tier slot so that the retry check and the
OOM re-check under oom_lock consider the tier that actually failed.
Taking the minimum across all tiers would report no headroom whenever
any tier is full, which would disable the pile-on guard in
mem_cgroup_out_of_memory() for plain memory.max breaches as well.

Note that stock is currently a per-memcg resource and does not
distinguish between tiers. There is ongoing work to change this,
however. Until then, tiered usage may transiently breach the max limit.

No-op unless the system has tiered memcg limits enabled.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 112 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 84 insertions(+), 28 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 44ea465b2005d..de6762520f475 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1570,14 +1570,32 @@ static struct page_counter *mem_cgroup_tier_counter(struct mem_cgroup *memcg,
 	return &memcg->tier[slot];
 }
 
+static struct mem_cgroup *tier_counter_mem_cgroup(struct mem_cgroup *memcg,
+						  struct page_counter *counter,
+						  int slot)
+{
+	struct mem_cgroup *iter;
+
+	for (iter = memcg; iter; iter = parent_mem_cgroup(iter)) {
+		if (&iter->tier[slot] == counter)
+			return iter;
+	}
+
+	/* the failing counter is always an ancestor of the given memcg */
+	VM_WARN_ON_ONCE(1);
+	return memcg;
+}
+
 /**
  * mem_cgroup_margin - calculate chargeable space of a memory cgroup
  * @memcg: the memory cgroup
+ * @slot: the memory tier slot
  *
- * Returns the maximum amount of memory @mem can be charged with, in
- * pages.
+ * Returns the maximum amount of memory @mem can be charged with, in pages.
+ * If the system has tiered memcg limits, then it returns the minimum of the
+ * tiered margin and the memcg margin.
  */
-static unsigned long mem_cgroup_margin(struct mem_cgroup *memcg)
+static unsigned long mem_cgroup_margin(struct mem_cgroup *memcg, int slot)
 {
 	unsigned long margin = 0;
 	unsigned long count;
@@ -1597,6 +1615,21 @@ static unsigned long mem_cgroup_margin(struct mem_cgroup *memcg)
 			margin = 0;
 	}
 
+	if (mem_cgroup_tiered_limits()) {
+		struct page_counter *tier_counter;
+
+		tier_counter = mem_cgroup_tier_counter(memcg, slot);
+		if (!tier_counter)
+			return margin;
+
+		count = page_counter_read(tier_counter);
+		limit = READ_ONCE(tier_counter->max);
+		if (count < limit)
+			margin = min(margin, limit - count);
+		else
+			margin = 0;
+	}
+
 	return margin;
 }
 
@@ -1945,7 +1978,7 @@ void __memcg_memory_event(struct mem_cgroup *memcg,
 EXPORT_SYMBOL_GPL(__memcg_memory_event);
 
 static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
-				     int order)
+				     int order, int slot)
 {
 	struct oom_control oc = {
 		.zonelist = NULL,
@@ -1959,7 +1992,7 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (mutex_lock_killable(&oom_lock))
 		return true;
 
-	if (mem_cgroup_margin(memcg) >= (1 << order))
+	if (mem_cgroup_margin(memcg, slot) >= (1 << order))
 		goto unlock;
 
 	/*
@@ -1977,7 +2010,8 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
  * Returns true if successfully killed one or more processes. Though in some
  * corner cases it can return true even without killing any process.
  */
-static bool mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
+static bool mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order,
+			   int slot)
 {
 	bool locked, ret;
 
@@ -1989,7 +2023,7 @@ static bool mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
 	if (!memcg1_oom_prepare(memcg, &locked))
 		return false;
 
-	ret = mem_cgroup_out_of_memory(memcg, mask, order);
+	ret = mem_cgroup_out_of_memory(memcg, mask, order, slot);
 
 	memcg1_oom_finish(memcg, locked);
 
@@ -2388,13 +2422,15 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 }
 
 static bool memcg_tier_over_limit(struct mem_cgroup *memcg,
-				  unsigned long *overage, int *breached_slot)
+				  unsigned long *overage, int *breached_slot,
+				  bool high)
 {
 	int nr_tier_slots = mt_nr_tier_slots();
 
 	for (int slot = 0; slot < nr_tier_slots; slot++) {
 		unsigned long usage = page_counter_read(&memcg->tier[slot]);
-		unsigned long limit = READ_ONCE(memcg->tier[slot].high);
+		unsigned long limit = high ? READ_ONCE(memcg->tier[slot].high) :
+					     READ_ONCE(memcg->tier[slot].max);
 
 		if (usage <= limit)
 			continue;
@@ -2425,7 +2461,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 
 			if (!mem_cgroup_tiered_limits())
 				continue;
-			if (!memcg_tier_over_limit(memcg, NULL, &slot))
+			if (!memcg_tier_over_limit(memcg, NULL, &slot, true))
 				continue;
 
 			reclaim_nodes = mt_tier_nodes(slot);
@@ -2719,6 +2755,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
 	int slot = -1;
+	const nodemask_t *reclaim_nodes;
 
 	if (mem_cgroup_tiered_limits()) {
 		slot = nid_tier_slot(nid);
@@ -2737,6 +2774,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		batch = nr_pages;
 
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
+	reclaim_nodes = NULL;
 
 	if (do_memsw_account() &&
 	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
@@ -2745,15 +2783,23 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto reclaim;
 	}
 
-	if (page_counter_try_charge(&memcg->memory, batch, &counter)) {
+	if (tier_counter &&
+	    !page_counter_try_charge(tier_counter, nr_pages, &counter)) {
+		mem_over_limit = tier_counter_mem_cgroup(memcg, counter, slot);
+		reclaim_nodes = mt_tier_nodes(slot);
+		goto reclaim;
+	}
+
+	if (!page_counter_try_charge(&memcg->memory, batch, &counter)) {
+		mem_over_limit = mem_cgroup_from_counter(counter, memory);
+		if (do_memsw_account())
+			page_counter_uncharge(&memcg->memsw, batch);
 		if (tier_counter)
-			page_counter_charge(tier_counter, nr_pages);
-		goto done_restock;
+			page_counter_uncharge(tier_counter, nr_pages);
+		goto reclaim;
 	}
 
-	if (do_memsw_account())
-		page_counter_uncharge(&memcg->memsw, batch);
-	mem_over_limit = mem_cgroup_from_counter(counter, memory);
+	goto done_restock;
 
 reclaim:
 	if (batch > nr_pages) {
@@ -2782,13 +2828,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
 						    gfp_mask, reclaim_options,
-						    NULL, NULL);
+						    NULL, reclaim_nodes);
 	psi_memstall_leave(&pflags);
 
-	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
+	if (mem_cgroup_margin(mem_over_limit, slot) >= nr_pages)
 		goto retry;
 
-	if (!drained) {
+	if (!drained && !reclaim_nodes) {
 		drain_all_stock(mem_over_limit);
 		drained = true;
 		goto retry;
@@ -2824,7 +2870,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * couldn't make any progress.
 	 */
 	if (mem_cgroup_oom(mem_over_limit, gfp_mask,
-			   get_order(nr_pages * PAGE_SIZE))) {
+			   get_order(nr_pages * PAGE_SIZE), slot)) {
 		passed_oom = true;
 		nr_retries = MAX_RECLAIM_RETRIES;
 		goto retry;
@@ -2880,7 +2926,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		swap_high = page_counter_read(&memcg->swap) >
 			READ_ONCE(memcg->swap.high);
 		tier_high = mem_cgroup_tiered_limits() &&
-			memcg_tier_over_limit(memcg, NULL, NULL);
+			memcg_tier_over_limit(memcg, NULL, NULL, true);
 
 		/* Don't bother a random interrupted task */
 		if (!in_task()) {
@@ -5011,7 +5057,7 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 
 			if (!mem_cgroup_tiered_limits())
 				break;
-			if (!memcg_tier_over_limit(memcg, &charge, &slot))
+			if (!memcg_tier_over_limit(memcg, &charge, &slot, true))
 				break;
 
 			reclaim_nodes = mt_tier_nodes(slot);
@@ -5073,12 +5119,22 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
+		unsigned long charge;
+		const nodemask_t *reclaim_nodes = NULL;
+		int slot = -1;
 
 		if (max != READ_ONCE(memcg->memory.max))
 			break;
 
-		if (nr_pages <= max)
-			break;
+		if (nr_pages <= max) {
+			if (!mem_cgroup_tiered_limits())
+				break;
+			if (!memcg_tier_over_limit(memcg, &charge, &slot, false))
+				break;
+			reclaim_nodes = mt_tier_nodes(slot);
+		} else {
+			charge = nr_pages - max;
+		}
 
 		if (signal_pending(current))
 			break;
@@ -5087,22 +5143,22 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 		if (memcg_is_dying(memcg))
 			break;
 
-		if (!drained) {
+		if (!drained && !reclaim_nodes) {
 			drain_all_stock(memcg);
 			drained = true;
 			continue;
 		}
 
 		if (nr_reclaims) {
-			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
+			if (!try_to_free_mem_cgroup_pages(memcg, charge,
 					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
-					NULL, NULL))
+					NULL, reclaim_nodes))
 				nr_reclaims--;
 			continue;
 		}
 
 		memcg_memory_event(memcg, MEMCG_OOM);
-		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0))
+		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0, slot))
 			break;
 		cond_resched();
 	}
-- 
2.53.0-Meta


