Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7215FF45A0F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:08:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 418296B0096; Fri, 10 Apr 2026 17:07:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307A96B0098; Fri, 10 Apr 2026 17:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D10E6B0099; Fri, 10 Apr 2026 17:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 060696B0096
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:07:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BDFF9140675
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:55 +0000 (UTC)
X-FDA: 84643883310.18.78D01CB
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id E76A7A000B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k60y8GbV;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=k60y8GbV;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775855274; a=rsa-sha256;
	cv=none;
	b=arHsGVoLimd4Xde3bhCHXj2pYPgkujBTmm74ttOAvKDU/7vEX6omsZo6V+gK77P8vgup8r
	oF1q/+c9/1VPwO29rLwTeBQg7ylL0Sl87Jwy4WA0x/I0zwXDdAAdGXl71cvlDC8T56yr8A
	eY8Py/Kau5x7efx6uwfk7ia3BwLg48k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775855274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PG5z20IDuVvS6OHbornUz1JNtNJjBAIARiXrIBCPKa0=;
	b=B4yT9WVjrJyTIz2Vly2Mcd0YmlQwOnDloL3od7ykv9CAgReZK3u+BwqXhYIbjZji1DcqNb
	jJQ4/WPtcYl0LvOwNoifpCvfaUqKHpzxc/oHOtOHLH/WwZiyq1g0/syT1KLU1NPvVcgoAx
	q/siNSXKz7tlSaqUOReW9O5HPCkEuhc=
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-4704fb0d5b8so1599883b6e.0
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775855273; x=1776460073; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PG5z20IDuVvS6OHbornUz1JNtNJjBAIARiXrIBCPKa0=;
        b=k60y8GbVTmD5ntbsZvZb3VR3sXy+B7hILyQ4I/bphtGUKsrvRKiS+iyM/F9CYjYzBV
         VaswgENAk0TR5v3fi46V5BMUqPYEXjd3XtM7p9k8Lmd8sDkGAfzlhDgjyxF4i66vg+m9
         DViBDTxa3QZVyygUZTUf8GS2+IdPeLmkEEC99J8lZFePxv8h8bNtGI6GPQ1vPKTJ8o+3
         yodhXw01EJHM5x2y41tnIBZSd7Maxeb+birQBfbPiGKWiUBFnPq8PHlsasd9fhxcDnQp
         Goo5iBja4z3geq5h/ZZIZg96MpSWZkHp2+OHIrlU6Jqegppd5xA5FBjxPxMnXI1s8tci
         2IdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775855273; x=1776460073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PG5z20IDuVvS6OHbornUz1JNtNJjBAIARiXrIBCPKa0=;
        b=GIK91rWjUl9kvJFTbmCnU67fgGqj0eg6YbjRpYpgnwT/UIdB9y/UDXx/AXeELAF026
         aehq8/hX1JvzGGMUxaTxxPkD63XwEqfVg9OI1RGyO+FIFeSCqPjmFXBJpjZuw5ALaC6y
         Nm3OchK8ORe+USfFSO5unZ2rYM6ACV9RhyZuydLCLK7RMyxky7IuG9yBIx1HkWOiUnkx
         qTKnTyrqf3GjZfQDytNAZeN3BAALHw29aQoBx5nZ8DfrSJZs3rBD8RccDJs/ZlL7mlDE
         5EKo6LP8Xmghn8l54ue2XYCUlP8/5iJ4voPAPncGE8YXTXQMWwC+9r7u2OebNqPwpAbU
         1deQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjuwOuzCb+6Ff1MXStDubjwI5QM1Qu/8YpOosABjLnwdBu3/7OenRzEUbfDFNjgDD2fD/GpOmXyw==@kvack.org
X-Gm-Message-State: AOJu0YzttA2eA0jIow1XqOB5x68YPulplPKG1sMyywR6fVPxkkY2VlcP
	4a9fmvvSDK59jO7GnyjksPgujW+GRUksc+BBpkKHOUV6I1i+xbGzGCX3
X-Gm-Gg: AeBDieuUbqCA9k09miZWfqHEY5jr6qiGdhy+fRm6iP8bOJmepDCbpDwb1qF9MB93Np/
	6KvezFZVXDSV7eV3jrrFkgNZKeM019WYsk48mGNNyOacBlGeBZT6R4hAQPbvF7H9m60SejfZthQ
	dVISvx4zY33kS02MR8BGUvlNKMTvtJ87MYpLT3+nEHr9c3+1Xj74Ckz4z2ps6TWlaByG/5G8O8H
	+aVtj2p5hyF48VUSYA5bKlc56XXJ0ifjOjDj5h1BgAGdQ0hy5Cr9PthMIftjq5Nd8Cl2Xr656NS
	+pFh+Z9WelyBM2kuu1YYhQj6oTwdfW+4FDp0+Zrl8JTc5oGqOuyv7OV1RBTGCBCzmP5eI2gqqD3
	eL8579O2bW5udZuGPiBPGM82nTwWbZ53ORDShBp5S9qP9DZZ5wUrsWgwYCy67imgh7AtzeFv732
	M+qU6Cv9E1C3Xsw1pbdv6I
X-Received: by 2002:a05:6808:1985:b0:46e:c1cd:8661 with SMTP id 5614622812f47-478b64b05d0mr2208429b6e.2.1775855272803;
        Fri, 10 Apr 2026 14:07:52 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:2::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-478a2f5580asm2152863b6e.12.2026.04.10.14.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:07:52 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 5/8 RFC] mm/memcontrol: convert memcg to use page_counter_stock
Date: Fri, 10 Apr 2026 14:06:59 -0700
Message-ID: <20260410210742.550489-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
References: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E76A7A000B
X-Stat-Signature: bj8jyrpi1thym4pnhbajqbj5eysj53s5
X-Rspam-User: 
X-HE-Tag: 1775855273-918986
X-HE-Meta: U2FsdGVkX1+HmzZTOKPWbnDO+0A0UoyiiyZMhKnYlgseFnPF1nEcjcdcLJFb8ocWVcu3z67lY4KZVdT79aFaCBrgvMwJoJwUqjaXL+fQaSBqesZdShkEeEPYYR6W4uPvZbyA3oqCaOksFyVpiyEmPqJSuMvM16dBwDuQu67fH8wwKd4/zCNbqfu2J8m/V54Rip7ZzkzDj4kRU+j45Z6b7QFDFJZkBG0YyXxU0MhVMpvEgWyvh+EaEKgzt2mcEF3B95OrV6Dzov/PAFQ0l3lbnfirGuDoG8UdkZWuB++Y5sPY0cz4lIjNQz2ROB1VlEIYWvzLRjrb1IPvCpSnOQnaH3vKKM5f22rxphnwQAjind3smNGysO7eOVKuGRg3P5S/8L0ip0Oz8lx4g4bBSVAmb5XMbfI4RDMjye7K4EHrDLkgzgTxt3LFyFyuHz7v0dfz9n+AwNGunfLJ4fsO9sQgXCqdRC8K3PYzUIAMzdj3Dp03MF2y6clobM7vbaNECC82cB8wgSgTRTTNuZb066vwnqYPktq3AKGtsDZ8W5Yom5ydPxWQYOKmMp2dq0xKnDV2sqyuehnkyQI/wqwpIlOxxAU63ZszO85+tdJ7QRCeKIOVAUmBasLutno6ufvjX9tjFXNq3ljmR9xz3URwk32PTdbNc90wX747IomwKx9huzsfycPp5q0w9LFCMZ3rrXVOxNCSsSDjZgyCMBZdqfEcsGqgk6zlZVgDSZM92rUjMWmac9q0ej3CymF0grEI92bg4/5oe0/ZxaOB9hcoI7EUiww6D4hhUIaNpN3UogE5sxL5q2SxtQszqxqYd2fLKqPC2nrv2MsqaRc9662w/IgJGgYikM3lVpIWRtEOpFQWlCIs1sFicerq37EqBRvxp2oj14B9rvC2kUykTQ9P6/ifDi7borluApg4tYohdc4lgtE2aJIBRTjKSu306/x3hI3sxkEDXmt4tSsWj/wqrsN
 qptQF/9r
 YQj5RCgcxHE2ECutlgjkSksYrz3Q+fjzvIK2nygHl1SexyRgz9Yx/P7ygc9BGiXbYEPfHSJ8zWewF2WJ/43KWriLXqGb34DWz1Io3EJILPpa9h8ySnEoPnr4r58QMzvH0Z2q4ukup4uqVP+rVJqcUqesOhV5dZ4OQBSsI1bcr01ql39JGmYuVv/xjufjQ42DEhcQIEsyzBT/TmnOaI2uRwAMBlHsBALHWOOrSHzsDwsS/xowlCk3e0yFBWxZKVCxznB4NnVX5pfoNuNXBwCLWe+k5eZu/Rok9xGVjkYyu7yJwZiOzZ4abiO9N36fPzp/Vcs3CAem08yjjMXp6bX15gFHbPAKZTrZnOt8hfI3WbuRMOfvQneQms4cp3QL8Ve18oxn8QqTim4CKqO4iNree1PGd6HxYB6b68vFQfxfrQATBppgl728L/dNuEj57qjz31xPv1N+ki0SPRLVrr6vYCpEKBbIgVlDz1GggP5z8svARWwqkC4UUnGz6atEzhtZ+9MU1g1dOTp0ABLFCAu9kH3l/UtQJiDm8JPkeDvtiE9CGbvr1PmUXYcj38F0udkxHg0ZyvpD+6kywf5gWZPEdWOtbhuQbNK/540Mv
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
memcg_stock slots.

Now that we no longer randomly evict other memcg stocks, refilling just
adds extra pages to the local cache. While there may be extra work
attempted when trying to refill (rather than just servicing the exact
number of pages requested), this is much less work than the flushing of
other memcgs' stock.

Secondly, stock checking is folded into the memory page_counter. This
means that for cgroupv1 users who use the memsw page_counter, they will
always incur the cost of hierarchically charging for memsw. One possible
workaround for this is to introduce a separate stock for memsw, which
would allow for separate stock checks for both memsw and memory,
restoring the fastpath behavior.

Finally, we can now fail during page_counter_enable_stock(), if there is
not enough memory to allocate a percpu page_counter_stock. This failure
is rare and nonfatal; the system can continue to operate, with the page
counter working without stock and falling back to walking the hierarchy.

Note that obj_stock remains untouched by these changes.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c   | 68 +++++++++++++++++------------------------------
 mm/page_counter.c |  5 +---
 2 files changed, 25 insertions(+), 48 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3d98ab41f1f1..27d2edd5a7832 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2238,33 +2238,22 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
  */
 void drain_all_stock(struct mem_cgroup *root_memcg)
 {
+	struct mem_cgroup *memcg;
 	int cpu, curcpu;
 
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
+	for_each_mem_cgroup_tree(memcg, root_memcg)
+		page_counter_drain_stock(&memcg->memory);
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
@@ -2281,9 +2270,13 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
+	struct mem_cgroup *memcg;
+
 	/* no need for the local lock */
 	drain_obj_stock(&per_cpu(obj_stock, cpu));
-	drain_stock_fully(&per_cpu(memcg_stock, cpu));
+
+	for_each_mem_cgroup(memcg)
+		page_counter_drain_cpu(&memcg->memory, cpu);
 
 	return 0;
 }
@@ -2558,7 +2551,6 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			    unsigned int nr_pages)
 {
-	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
@@ -2571,31 +2563,19 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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
@@ -2692,9 +2672,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	return 0;
 
 done_restock:
-	if (batch > nr_pages)
-		refill_stock(memcg, batch - nr_pages);
-
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
 	 * reclaim on returning to userland.  We can perform reclaim here
@@ -2731,7 +2708,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			 * and distribute reclaim work and delay penalties
 			 * based on how much each task is actually allocating.
 			 */
-			current->memcg_nr_pages_over_high += batch;
+			current->memcg_nr_pages_over_high += nr_pages;
 			set_notify_resume(current);
 			break;
 		}
@@ -3036,7 +3013,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 	account_kmem_nmi_safe(memcg, -nr_pages);
 	memcg1_account_kmem(memcg, -nr_pages);
 	if (!mem_cgroup_is_root(memcg))
-		refill_stock(memcg, nr_pages);
+		memcg_uncharge(memcg, nr_pages);
 
 	css_put(&memcg->css);
 }
@@ -3957,6 +3934,8 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 
 static void mem_cgroup_free(struct mem_cgroup *memcg)
 {
+	page_counter_free_stock(&memcg->memory);
+	page_counter_free_stock(&memcg->memsw);
 	lru_gen_exit_memcg(memcg);
 	memcg_wb_domain_exit(memcg);
 	__mem_cgroup_free(memcg);
@@ -4130,6 +4109,9 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	refcount_set(&memcg->id.ref, 1);
 	css_get(css);
 
+	/* failure is nonfatal, charges fall back to direct hierarchy */
+	page_counter_enable_stock(&memcg->memory, MEMCG_CHARGE_BATCH);
+
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
 	 *
@@ -4192,6 +4174,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	lru_gen_offline_memcg(memcg);
 
 	drain_all_stock(memcg);
+	page_counter_disable_stock(&memcg->memory);
 
 	mem_cgroup_private_id_put(memcg, 1);
 }
@@ -5382,7 +5365,7 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages)
 
 	mod_memcg_state(memcg, MEMCG_SOCK, -nr_pages);
 
-	refill_stock(memcg, nr_pages);
+	page_counter_uncharge(&memcg->memory, nr_pages);
 }
 
 void mem_cgroup_flush_workqueue(void)
@@ -5435,12 +5418,9 @@ int __init mem_cgroup_init(void)
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
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 28c2e6442f7d3..51148ca3a5b63 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -421,10 +421,7 @@ static long page_counter_drain_stock_cpu(void *arg)
 
 	return 0;
 }
-/*
- * Drain per-cpu stock across all online CPUs. Caller (drain_all_stock) is
- * already protected by a mutex, all future callers must serialize as well.
- */
+
 void page_counter_drain_stock(struct page_counter *counter)
 {
 	int cpu;
-- 
2.52.0


