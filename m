Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D8F6CD8C81
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14E9C6B0096; Fri,  5 Jun 2026 11:36:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1238F6B0098; Fri,  5 Jun 2026 11:36:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2FF96B0099; Fri,  5 Jun 2026 11:36:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E0B406B0096
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:36:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A265BA01D0
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:36:12 +0000 (UTC)
X-FDA: 84846260184.11.42D8146
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id C43BE40004
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:36:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UF/PZAl7";
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780673770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QT7NBEIym2G0kzWniqTa/IOK3LykjdeMwTsMHCm4gYI=;
	b=YlErGxkeqDMfv48tUePMS45t/QkbNSBTuAKBtTWap1re7WGy4Zxa+luhIQHc7va+1tvEdp
	M3f7RhPVaattJrVJAv1C37T0l0L5k561Ov6ozp8mzxejEr2K8zPnI8rvXkhdwJbzZ121mf
	0kEkER4fzedLsi8rahG33os0BkBrGsA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UF/PZAl7";
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780673770;
	b=ZOS8y39PfQJWCBbPb1gJLFj5Bmv2JWk4CifTjrgJcOKQC0t3kmd+KkyOb/FdF5LAq/iF32
	shomdbfPwKhhWN65huE9bCkUjcKC4HPJojzfVpXzmcX05LO/ErUlSoO8FbiCDgL7hzx093
	tJB7gZ8sNCB3rWeUG43NYOPBLU1U1LI=
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-440df1c768bso1578425fac.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 08:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780673770; x=1781278570; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QT7NBEIym2G0kzWniqTa/IOK3LykjdeMwTsMHCm4gYI=;
        b=UF/PZAl7HQOOyFbJsASG6/PsqDoKccums2nyvy0tHQtV/v+0RtfKlm4ZXdxMNImkPH
         A00v0wZ9RB9+dtpRIBQUW8xWdBW82NL0zqxz1xr8vRW+aIuhu01P4h8JUrudiEaZjxq0
         I92wNRvrd3v+lsfJ8KMWMDsrLA70ld6oW5fyHWiPHptyuZU9w6BqqgA8ORjeoJLDEBy3
         dqywq/87VBXO4Xlgawb40rDZ5LQODPEP48389ZFXaPJCulxp3LdiZVkFJuaLHT1Cf1Qp
         7qwjV2sfUhg24ZltM0Cwir/MqFcBhrKj8KgS+Y2z1aljdjx2UO1FSOd34W901MgECstP
         cuug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780673770; x=1781278570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QT7NBEIym2G0kzWniqTa/IOK3LykjdeMwTsMHCm4gYI=;
        b=NoElsK/i0Y5fVZJLxt/Awjc+EDTkP0N4qqczBNM3jbwrYitkwRpoHM7W3iU7nh/CE5
         0kxFZ6ur+k/+u7UINZwjj/5zgJBQbYHq8P+VVMJHfydGtaAYrLmWPZMJNhdWugyCkOwj
         EpuaSKHwJwWEyg8wFm91Qajqf1rXgHoHmL46yTqooLnPesDp6IYJ2vLbM3KHnzpo71EP
         HriVUBbXvL35Oge+e5F9LRq5r1S64wa93zwXNehigi6pNGo92F/srsI9ZmBaKK8yjS1v
         EmcxDM22nq3kcRuqwugtFnX4aA3ALwdjUTSwsGHiGaIY8XISSscJncF9k5p5awpj4DXa
         ODBg==
X-Forwarded-Encrypted: i=1; AFNElJ8XNYQiQ3egLTIJ4kOpATA0UsSiT6nKKmrXSUyTOSBklc5mLS+GpJtEBkZb1tA3Htr+PGU4txrzEw==@kvack.org
X-Gm-Message-State: AOJu0YxAsx6cp+BSzgMb8DUFhz0WFJU5NPrfQc7J845g2wKQwi3fIWv2
	QpWOzmUCO7GikVrYIoe3+pGfKL4wggFaI//a37CYVaDR0N03PEb+wNpL
X-Gm-Gg: Acq92OFbp0E8PymickGkyWkpmnyr04A872JWiNCIBa9bnr2PAWDMjd9r2/4TctmatXj
	doF90uaMPENMlAaVESBHvi1YXgSrz+2sTgdklL4mj0XqfN2CqRmLtIL4VruBMAreSaPpma301nc
	GLl2LIR/wkbWXaYsAjYt0Azd1BLWKTCM4SNontlW/1Txr2zINQJD8dp9rAJkzLyIccNFjdpUaRc
	vQYNzizBjv+f2/Ld+m6eJXoGpp9QuZQt4HpCXfiYADvP/C4kYyRNkHP1DuF2rIb7hy+zPWNPyp0
	MzfDkmkY3ocwYDr3Antyd3G6mSq4UcTIgfAK5cStV8oKBkLGQ6i/0UB+358Z+3WmonvoQTKJQFE
	pePprSiTzRM/oywG3UJ+EY1g3R6CV8/1E/xDn+QymMDxhgZ+ZLU43h4N3J0Y2j5GpPXcbeFLjVS
	lPyz7dgOp0CFag/RiE02otYqZ7oLJ3bAvGI53P4eYk3XmnV9m2HQ854KboKW2xl+Ew
X-Received: by 2002:a05:6870:6488:b0:430:b01:1f79 with SMTP id 586e51a60fabf-4413d248508mr2239934fac.2.1780673769704;
        Fri, 05 Jun 2026 08:36:09 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:54::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-440d8295b38sm8359180fac.10.2026.06.05.08.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 08:36:09 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 4/6 v3] mm/memcontrol: convert memcg to use page_counter_stock
Date: Fri,  5 Jun 2026 08:36:00 -0700
Message-ID: <20260605153603.234296-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260605153603.234296-1-joshua.hahnjy@gmail.com>
References: <20260605153603.234296-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C43BE40004
X-Stat-Signature: 46bcwkatpexhyxfnfo9cm744nmnerh1x
X-Rspam-User: 
X-HE-Tag: 1780673770-461105
X-HE-Meta: U2FsdGVkX1/9PvskhkugFAinHxujfZIH9kHu87P6309V6Vs8HbzbsfcJBsYU3MosQgexTRlYh8l1e766rx1kwjVLgDFLcnj1G6Tz6wA6iCOvh2XG/4R6LrXVfs78CigPaNj59kLq8MT55Ly5dBskB+dC19mbbMHoOXaU+JM2/D1HtYPYl0hfchjw1VGx3y8yypO37KqC2VRVpn5wPQADZ6nm6zu2HIdHL4ZXp2XwgtFctlvVw/dj4l7WxklZAJKQ0552waBp1nQtb2NkeQctfDhV1FBlpTYs+KgISShKDe+bvm8V7gb0Is597vLHtHqOHQOBlJuhrYQy+pkCRsazTi2Rlt6FZdxArPo5OgwiNk6q3Vp1ztJevUmomj7oe1Bk8dogVuaoD5aAP2t98/j+67DFWaa+u9rQ/VxOVd+NEQ6VirSI+WWy4cqdOle3ow8/91BFP5aivJdx2cSiDLWkynBHgGKBN1rYzI9weY/Z37RjSBJHvS3oi6BEs01FaztOFpLBDI+lGsXHnP99r8VCCBtBHbhIUwaTG4VhRzW3N7tV3pY770XAlGPo1Arw4OKVU4or9m6JgmcpnOfpA4zkUzsqOKKHdAeDnOW/gQVe80gygUwgOeWuyY9h4XPbaap2UGV1WQmddu7HdMA7O9mGsNAxa1posPHjjx0N92HH5Zn506MUamueGHn8LVR0PBRBpfufJ/jwYhYE3kgNjSTyFA+LVRBmOrxAwYLlx9kdahWGnZxv5nebs1SuWsYrV08G0VB4vta4Bzfv8KsgI2AY06nkuuVbiPJ/cgoDni1lydoMqnfNqJu7V4JcKUqiDNWP1c69Z1JE3kdRnBUhvnmLRLzSME4jzEHqBuDKLn5e2YOGQ/kEqHq5ELW0azvB0G+q320L/fXBOoA1GNBy9R3Lhvy2eA275xWTRch74r0dBOKVTBKhZcKrTLmT+6RLQeD22nwtwTE9ORqAe17JUA8
 Uekvly4r
 YAUhLQnIvqGpJwv2JuDu2OrZumsj0uO+5tokFBhM1Wo1MDWPLDoc4Fmku0cBtBFzMmomrW5dEofHfUJEG3/ViehtMAh+6PYlMGNwMmfrd+G0uFbsm2eiWyKNWU8tq3CjECcq7jnLkb2KULCvuJOaUM3J/6KhA6TNrUeaz4CQYxW+WFAk+k1ldhBApYqmGP4vVLeX5dPr/1smGyiDzGmBmu6spR+XPE9EjyZZk+pKQ3lgcBGmmoRkLjPmvgBuGDsHCXACkBro60H4VbWGhojk10UxXWV14zQgpBG+eINRFdeChCrFI4buZZbqi4hGj1X+Mg5K3Edee3Vslv9fFgdp6rxtYi9zUcLlIRnyp9fEdc2tikmCoBrV4fItEDt2qM9z2zbogEnT51dWRdfxuqev6+0hnyxDvTcFC0oXQjwJDAxTJM9US+ixV/ZCgZBH0eaO3T+RxWu0EEf9kUBwONAdwDHKpO3hE9/ktWcrHYIh6gBPVA9lovQNVlKHCEAPAyEF/ejfRVMkixwhklY+Q3tFNs6T0BcpxJI3wZtH3739RdaE52hiCvk1CqsvsWYZQt6ppGe/QyRatrvI3R5PrAJeUJQs2wnNc8hB3FOihP42rcPqcwXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now with all of the memcg_stock handling logic replicated in
page_counter_stock, switch memcg to use the page_counter_stock.

There are a few details that have changed:

First, the old special-casing for the !allow_spinning check to avoid
refilling and flushing of the old stock is removed. This special casing
was important previously, because refilling the stock could do a lot of
extra work by evicting one of 7 random victim memcgs in the percpu
memcg_stock slots. In the new per-counter design, refilling stock just
adds pages to the counter's own local cache without affecting other memcgs,
so the original reason for the special case no longer applies.

Also, we can now fail during page_counter_alloc_stock(), if there is
not enough memory to allocate a percpu page_counter_stock. This failure
is rare and nonfatal; the system can continue to operate, with the page
counter working without stock and falling back to walking the hierarchy.

Finally, drain_all_stock is restructured to iterate CPUs in the outer
loop (rather than memcgs) to be able to schedule draining all memcgs
via a single work_on_cpu call. It reduces the number of synchronous
per-CPU work calls from O(memcgs * CPUs) to just O(CPUs).

We also skip isolated CPUs, as schedule_drain_work() did before. We
don't need its guard(rcu) here though; that rcu section existed to
order async work scheduling against cpumask updates and workqueue
flushes, which would lead to drain work pending.
Since all work here is synchronous, we don't leave any work behind.

Note that obj_stock remains untouched by these changes, and that memsw
stock will be handled in the next patch.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 80 ++++++++++++++++++++++---------------------------
 1 file changed, 36 insertions(+), 44 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 56cd4af082326..562ed9301f5a4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2269,6 +2269,17 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
 		queue_work_on(cpu, memcg_wq, work);
 }
 
+static long drain_stock_on_cpu(void *arg)
+{
+	struct mem_cgroup *root_memcg = arg;
+	struct mem_cgroup *memcg;
+
+	for_each_mem_cgroup_tree(memcg, root_memcg)
+		page_counter_drain_stock_local(&memcg->memory);
+
+	return 0;
+}
+
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
@@ -2280,28 +2291,18 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 	/* If someone's already draining, avoid adding running more workers. */
 	if (!mutex_trylock(&percpu_charge_mutex))
 		return;
-	/*
-	 * Notify other cpus that system-wide "drain" is running
-	 * We do not care about races with the cpu hotplug because cpu down
-	 * as well as workers from this path always operate on the local
-	 * per-cpu data. CPU up doesn't touch memcg_stock at all.
-	 */
+
+	for_each_online_cpu(cpu) {
+		if (!cpu_is_isolated(cpu))
+			work_on_cpu(cpu, drain_stock_on_cpu, root_memcg);
+	}
+
+	/* Drain obj_stock on all online CPUs */
 	migrate_disable();
 	curcpu = smp_processor_id();
 	for_each_online_cpu(cpu) {
-		struct memcg_stock_pcp *memcg_st = &per_cpu(memcg_stock, cpu);
 		struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
 
-		if (!test_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags) &&
-		    is_memcg_drain_needed(memcg_st, root_memcg) &&
-		    !test_and_set_bit(FLUSHING_CACHED_CHARGE,
-				      &memcg_st->flags)) {
-			if (cpu == curcpu)
-				drain_local_memcg_stock(&memcg_st->work);
-			else
-				schedule_drain_work(cpu, &memcg_st->work);
-		}
-
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
 		    obj_stock_flush_required(obj_st, root_memcg) &&
 		    !test_and_set_bit(FLUSHING_CACHED_CHARGE,
@@ -2318,9 +2319,13 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
+	struct mem_cgroup *memcg;
+
 	/* no need for the local lock */
 	drain_obj_stock(&per_cpu(obj_stock, cpu));
-	drain_stock_fully(&per_cpu(memcg_stock, cpu));
+
+	for_each_mem_cgroup(memcg)
+		page_counter_drain_stock_cpu(&memcg->memory, cpu);
 
 	return 0;
 }
@@ -2595,7 +2600,6 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			    unsigned int nr_pages)
 {
-	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
@@ -2608,31 +2612,19 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
 
 retry:
-	if (consume_stock(memcg, nr_pages))
-		return 0;
-
-	if (!allow_spinning)
-		/* Avoid the refill and flush of the older stock */
-		batch = nr_pages;
-
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (!do_memsw_account() ||
-	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
-		if (page_counter_try_charge(&memcg->memory, batch, &counter))
+	    page_counter_try_charge(&memcg->memsw, nr_pages, &counter)) {
+		if (page_counter_try_charge(&memcg->memory, nr_pages, &counter))
 			goto done_restock;
 		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, batch);
+			page_counter_uncharge(&memcg->memsw, nr_pages);
 		mem_over_limit = mem_cgroup_from_counter(counter, memory);
 	} else {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
 	}
 
-	if (batch > nr_pages) {
-		batch = nr_pages;
-		goto retry;
-	}
-
 	/*
 	 * Prevent unbounded recursion when reclaim operations need to
 	 * allocate memory. This might exceed the limits temporarily,
@@ -2729,9 +2721,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	return 0;
 
 done_restock:
-	if (batch > nr_pages)
-		refill_stock(memcg, batch - nr_pages);
-
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
 	 * reclaim on returning to userland.  We can perform reclaim here
@@ -2768,7 +2757,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			 * and distribute reclaim work and delay penalties
 			 * based on how much each task is actually allocating.
 			 */
-			current->memcg_nr_pages_over_high += batch;
+			current->memcg_nr_pages_over_high += nr_pages;
 			set_notify_resume(current);
 			break;
 		}
@@ -3073,7 +3062,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 	account_kmem_nmi_safe(memcg, -nr_pages);
 	memcg1_account_kmem(memcg, -nr_pages);
 	if (!mem_cgroup_is_root(memcg))
-		refill_stock(memcg, nr_pages);
+		memcg_uncharge(memcg, nr_pages);
 
 	css_put(&memcg->css);
 }
@@ -4077,6 +4066,8 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 
 static void mem_cgroup_free(struct mem_cgroup *memcg)
 {
+	page_counter_free_stock(&memcg->memory);
+	page_counter_free_stock(&memcg->memsw);
 	lru_gen_exit_memcg(memcg);
 	memcg_wb_domain_exit(memcg);
 	__mem_cgroup_free(memcg);
@@ -4244,6 +4235,9 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	refcount_set(&memcg->id.ref, 1);
 	css_get(css);
 
+	/* failure is nonfatal, charges fall back to direct hierarchy */
+	page_counter_alloc_stock(&memcg->memory, MEMCG_CHARGE_BATCH);
+
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
 	 *
@@ -4304,6 +4298,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	wb_memcg_offline(memcg);
 	lru_gen_offline_memcg(memcg);
 
+	page_counter_disable_stock(&memcg->memory);
 	drain_all_stock(memcg);
 
 	mem_cgroup_private_id_put(memcg, 1);
@@ -5499,7 +5494,7 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages)
 
 	mod_memcg_state(memcg, MEMCG_SOCK, -nr_pages);
 
-	refill_stock(memcg, nr_pages);
+	page_counter_uncharge(&memcg->memory, nr_pages);
 }
 
 void mem_cgroup_flush_workqueue(void)
@@ -5552,12 +5547,9 @@ int __init mem_cgroup_init(void)
 	memcg_wq = alloc_workqueue("memcg", WQ_PERCPU, 0);
 	WARN_ON(!memcg_wq);
 
-	for_each_possible_cpu(cpu) {
-		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
-			  drain_local_memcg_stock);
+	for_each_possible_cpu(cpu)
 		INIT_WORK(&per_cpu_ptr(&obj_stock, cpu)->work,
 			  drain_local_obj_stock);
-	}
 
 	memcg_size = struct_size_t(struct mem_cgroup, nodeinfo, nr_node_ids);
 	memcg_cachep = kmem_cache_create("mem_cgroup", memcg_size, 0,
-- 
2.53.0-Meta


