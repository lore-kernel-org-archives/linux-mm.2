Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1399DCDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 18:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453556B0095; Tue, 23 Jun 2026 14:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42B3E6B0098; Tue, 23 Jun 2026 14:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3956B0099; Tue, 23 Jun 2026 14:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07B8F6B0095
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:01:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B1EB1C4D72
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:01:35 +0000 (UTC)
X-FDA: 84911944950.24.82BD4C3
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7E5F140011
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:01:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rojTkKT0;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782237693;
	b=BTJhzuJt2W33HFZyY5vAX/hw+2fPgt+v6oSXY8+Z2zMR8Kb0T2KJlgN9ZaLhmksk2WbhKx
	PAhPG2MyMcV/gydbXhrR68OzhOGal0MGvKodJhA+9Dg4H2Z4bG3hD9S4uV2xWcdb7Wwtew
	MOWLOoPiAN9+Ll/wJ8uxJ6w4oBvvBJo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782237693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WC7esSJdpBo4cx7rkDb+TP6edbpeHpybFpObAVHlbJY=;
	b=ifQ/RQgUs+7Iuu/q/6GXI5gCPGPChaf4MFzYs2ETs3oCYRqfpBOF3z2V6nPvsv7IDDoiwP
	3XiqG7WTpI8jJK0vXSPsFS5snSyudsWjE+0xzhhToQeBSxthJqQ4prXhGMebLDQNnsaGa2
	8jJF9u+9gCItQ3DEVOnrLl32bB7bd7A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rojTkKT0;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-486621f0adbso145764b6e.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782237692; x=1782842492; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WC7esSJdpBo4cx7rkDb+TP6edbpeHpybFpObAVHlbJY=;
        b=rojTkKT0LDmTcb9iS1XCGmms/lrdkfr7ZLIbnOqVHRJT3b3CfCbDRSRe4UsJFyEzgz
         Lh/VeWPGujCNb8XDDrGoTf/m1b95GWkd3HTdzNczxFghJjdBTKA+sfiM43qCCmqauMMw
         umo/UIjRFY87ZkrIVeRxLh61GCA4ny1Z0gMdhWPTlHFr/B8EDS900OjMGTcC1VL5z9KR
         11BPMRLLNqUFzJ9mr9OQ/n4n0iRoHYKgfcwDngV2en2byH/kVtbg6bt4ZuHt8Ka5b0/x
         mQoM6dNoN+7/z+nIie099cDEJtgvcvLsFy4gO5a+XZSjYd06VgZJHr4HaosUYNXBuvVE
         UGQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782237692; x=1782842492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WC7esSJdpBo4cx7rkDb+TP6edbpeHpybFpObAVHlbJY=;
        b=TxXrcyrkhAZEkxwABmU8/phkSQT/wdsGZgTFtBrVXWeJpCUavkFFpP/7Ucb3vLFth9
         eBaeC41lwoJ5y2Y+2Rlfa4nF2BGnAlMfdrMkMvtuVywfJwytdPcqOse8KWcrNYid//0Q
         cTq8w8wblKIYvPPEon39hNMdgbJIQH9jt+FXAwe8ydIPJvwFEBJisThRi9l1ze0+O1kf
         w6mHXd6quK6kqhUVCvA5dRCVq/k4RNznbEf5x9LsEFx02V75GWN/3jL6ECrFlH9fayXr
         804Bpb9mDItrkHJ1x+/fK4WJHyodCuGuajLNNYW1TquoovgO/xcN59V7bXypW+fRoQYt
         oVFQ==
X-Forwarded-Encrypted: i=1; AFNElJ/i4izHObhoN7jFh+TYNM06PZKg9MBgVTPNLL+tKgWMXEyjsgEx5MzRJTp8HexZ52kutS2yufjiWA==@kvack.org
X-Gm-Message-State: AOJu0YweEj9fRijAAj8RIeiMQffOj4HbrJoU/9ZWcxJ8JZfRXxt8FoZ5
	NT65Qyt4+KjUKAf5d6c6vwmGy0qan7VTxg9DeB41qo1eAnJR4+pbavXm
X-Gm-Gg: AfdE7ckuEheyBpHL7QcYTLRMGQodjgR7zlq6SOcJEbMv+t9dV6Q4YBUKriIBwWYUDM8
	Rx//Z1kDJxvWUkF+G1YPmAoJGoO2+zOQJBAyqwLZahu0EoAEr+aM8j4sYiS1s6MB8GID5yazBGn
	PHJiFfdX6MD6BRtpHd970UL4bc/zWS+iVK2E3HrENHnCYfVZ2hLiA4SmEIcIJvwgvGEpHu8MFsE
	LtUwKSeRB6BELVrO+rZT45oNkdTs+9sB8TXD1ZOQEy1xAovV7maU86NrMRa/VKUa7Zc7EoySul2
	wsmHiuAIJqZPnEoLBLBPdCaW3WXNSiBoiXI0kGtSA+sjG+NHYR6d2CcBLUPrpNUQ0T3gCvbR3RJ
	QQAGKInnI6IDgZXONYbhcTLL++nbUiw7dTbI6h0n+pOXxdOfTtn4AQmR0B8mSbGOP4LTDMT0p7f
	fQPT6jabbgZ3xWwaPVze9M4SBrDt+cGV5nlZCxML6BboQ=
X-Received: by 2002:a05:6808:1387:b0:48a:199a:1fe2 with SMTP id 5614622812f47-48f60fa98b2mr2616645b6e.19.1782237691560;
        Tue, 23 Jun 2026 11:01:31 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:49::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-48aebb9cbe5sm7128201b6e.3.2026.06.23.11.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 11:01:31 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v4 4/5] mm/memcontrol: convert memcg to use page_counter_stock
Date: Tue, 23 Jun 2026 11:01:22 -0700
Message-ID: <20260623180124.868655-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623180124.868655-1-joshua.hahnjy@gmail.com>
References: <20260623180124.868655-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7E5F140011
X-Stat-Signature: p1seg69n38j3b81wwiqjcd8meab5i3su
X-HE-Tag: 1782237693-344673
X-HE-Meta: U2FsdGVkX19XvnQuLEb06GQvIOEhlSlZUepK6rDKCbd02w2fBR/RlGmdXXgyvtrx3EVBmt9BQN75E9hHXClB8IfiirqzTibNhZhDSa4ALUrnMDNTa9g9R9Jwzws634r5RpRHbyA7MZpkaSoYC8REqtNU01LM3ahiD7G+vexdSiHjCJW1GgK5wA4meT2QxtHalY02uZ4bTVrZfB4jlu6/4QIYsiHwqzfX+m1gP+u80NxtHfXRb10//Qr7SUJw0F3tyYT5s9DmRwD8zGnd/W+MbUMRM/0p5fjt2r39KqTBfWcLoUwEZNOePb3ejYGG7uWW/gTdLtezDMAU7qIvbpTlQeZZv6aa5da1NWrn7zcrWJduyqDL67vPSKbY1IRI+2sFjaR735Y3Ub84bfGqoHJ7TIMQsRO6AMiXRLrEB7Q1Q+3Kdmj491pq97qoXy5ZGhUY0x4V/5i5claomPq4GKhmuTq8spfd8Y/EAqjA/Z3jFg1yRJkw26+bRWSNWMCxbCflDYxih89vcUzbbfBdoPXhP6GMdEz1dUJqjdYPEYhglh+4km07ffd3R+XUT0cmpADH6flmDg3DTvK+cVkZb4QXjCcIO0UGkcLt0J3y+RR4BiNQykJzBdfGIohHzI8d3qEhxy8LRQMAFh+OOHTeGq84igT4xtYvbB3849zhlAK0yDGb12tDjL5rSCa8LM9vgNZE4lu9sj5KuWxn6S3KYzSP70c7psUltLeCMlLumFs/3pBfJ3MxZhZn/hYY7EfKduJuUR5PiIQgZgFkeIH6NXsGPP+hwGyFsioFSwylCZcjYiKTlw4omoKUMRKZutFNQ2zxIFIzhMDhLqNbN7QVk8gv6x8T3HIs771bPc6y5XfYa3MoG9IfEVOeLsQOZBMkbVNcTe+QAE6G9TdOuON/+nH/cXlsVeO7diJH3q3waO3S2zxm85BDk7mw1Wr2xMdmueLnarm8Ux4ym6O8QhXBJ89
 Ivd9Qg9f
 eGZE+YTYroc6U/PQpokVH0paAywMr1c100pDWn7dXfihvJp9WGxQx59vbV9t22/Egz7qJc/2Uesn/0IOE43nwX2rQ5yaJ/TgMZiwpnDF6GOyelVkFui/ElBdZWZd5Vh4X/0hDJ5zfMhSPkQO9jSvRbcRg1Ucls2gpK5l1YxY5cTuwXQ8T2bpbo3NOQJ1xp8KesKV5aHLowDWf+kAUeXCh3mtbDI5GRLu16Gw2iMb19roHHqL1bU7XxU638WnIp3qAHfPrYHudyFs5DSUiBbqZnlSn/BvEHS3NH03joJxazv8UgC/P8aTJvZpKh3K/r8LuVTeavKEh4JKwYZL6twa3oSqh+DMv5c4iruwD9H8StiRX/fplJvPu047cG/xLliTTdR14ZFatp5Hk1sDNcmZwkq996Bubg2okNFvhkKpeAtbAU+s8BemiYPfx902/5xs6OD8vERb4D7DNH9dcvr+GK7IGNOl60bxkWRiZyF/evXo7Le7EgaQKUR8mXsZRsUnNPeRWFpCF8faWABlsHLeIRhTM4bLhvMKxELbc2Eyi0IxY0BA8GTUBhmYLZJyswcC/cKiHWFG00Tx8qG47gNIt2u4vuBMQg7EGiWtF8Ek8eO9uQ6c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now with all of the memcg_stock handling logic replicated in
page_counter_stock, switch memcg to use the page_counter_stock for the
memory (and for cgroup v1 users, memsw) page_counters.

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

drain_all_stock and memcg_hotplug_cpu_dead also now use the page_counter
stock drain variant, which uses remote atomic_xchg to retrieve stock
across CPUs, instead of scheduling asynchronous work.

Finally, as a side-effect of separating the per-memcg stock to per-
page_counter, the memsw and memory page_counters have independent stock.
This means that the reported memsw may transiently be lower than memory
usage if the stock for memory and memsw page_counters go out of sync.

Note that obj_stock is untouched by this change.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 87 +++++++++++++++++++++++--------------------------
 1 file changed, 41 insertions(+), 46 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 306658fd55512..846800917af49 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2269,39 +2269,36 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
 		queue_work_on(cpu, memcg_wq, work);
 }
 
+static void memcg_drain_stock(struct mem_cgroup *memcg, int cpu)
+{
+	page_counter_drain_stock(&memcg->memory, cpu);
+	if (do_memsw_account())
+		page_counter_drain_stock(&memcg->memsw, cpu);
+}
+
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
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
+	for_each_mem_cgroup_tree(memcg, root_memcg) {
+		for_each_online_cpu(cpu)
+			memcg_drain_stock(memcg, cpu);
+	}
+
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
@@ -2318,9 +2315,13 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
+	struct mem_cgroup *memcg;
+
 	/* no need for the local lock */
 	drain_obj_stock(&per_cpu(obj_stock, cpu));
-	drain_stock_fully(&per_cpu(memcg_stock, cpu));
+
+	for_each_mem_cgroup(memcg)
+		memcg_drain_stock(memcg, cpu);
 
 	return 0;
 }
@@ -2595,7 +2596,6 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			    unsigned int nr_pages)
 {
-	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
@@ -2606,36 +2606,30 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	unsigned long nr_charged = 0;
 
 retry:
-	if (consume_stock(memcg, nr_pages))
-		return 0;
-
-	if (!allow_spinning)
-		/* Avoid the refill and flush of the older stock */
-		batch = nr_pages;
-
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
+	    !page_counter_try_charge_stock(&memcg->memsw, nr_pages,
+					   &counter, NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
 		goto reclaim;
 	}
 
-	if (page_counter_try_charge(&memcg->memory, batch, &counter))
-		goto done_restock;
+	if (page_counter_try_charge_stock(&memcg->memory, nr_pages,
+					  &counter, &nr_charged)) {
+		if (!nr_charged)
+			return 0;
+		goto handle_high;
+	}
 
 	if (do_memsw_account())
-		page_counter_uncharge(&memcg->memsw, batch);
+		page_counter_uncharge(&memcg->memsw, nr_pages);
 	mem_over_limit = mem_cgroup_from_counter(counter, memory);
 
 reclaim:
-	if (batch > nr_pages) {
-		batch = nr_pages;
-		goto retry;
-	}
-
 	/*
 	 * Prevent unbounded recursion when reclaim operations need to
 	 * allocate memory. This might exceed the limits temporarily,
@@ -2731,10 +2725,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	return 0;
 
-done_restock:
-	if (batch > nr_pages)
-		refill_stock(memcg, batch - nr_pages);
-
+handle_high:
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
 	 * reclaim on returning to userland.  We can perform reclaim here
@@ -2771,7 +2762,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			 * and distribute reclaim work and delay penalties
 			 * based on how much each task is actually allocating.
 			 */
-			current->memcg_nr_pages_over_high += batch;
+			current->memcg_nr_pages_over_high += nr_charged;
 			set_notify_resume(current);
 			break;
 		}
@@ -3076,7 +3067,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 	account_kmem_nmi_safe(memcg, -nr_pages);
 	memcg1_account_kmem(memcg, -nr_pages);
 	if (!mem_cgroup_is_root(memcg))
-		refill_stock(memcg, nr_pages);
+		memcg_uncharge(memcg, nr_pages);
 
 	css_put(&memcg->css);
 }
@@ -4080,6 +4071,8 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 
 static void mem_cgroup_free(struct mem_cgroup *memcg)
 {
+	page_counter_free_stock(&memcg->memory);
+	page_counter_free_stock(&memcg->memsw);
 	lru_gen_exit_memcg(memcg);
 	memcg_wb_domain_exit(memcg);
 	__mem_cgroup_free(memcg);
@@ -4247,6 +4240,11 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	refcount_set(&memcg->id.ref, 1);
 	css_get(css);
 
+	/* failure is nonfatal, charges fall back to direct hierarchy */
+	page_counter_alloc_stock(&memcg->memory, MEMCG_CHARGE_BATCH);
+	if (do_memsw_account())
+		page_counter_alloc_stock(&memcg->memsw, MEMCG_CHARGE_BATCH);
+
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
 	 *
@@ -5502,7 +5500,7 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages)
 
 	mod_memcg_state(memcg, MEMCG_SOCK, -nr_pages);
 
-	refill_stock(memcg, nr_pages);
+	page_counter_uncharge(&memcg->memory, nr_pages);
 }
 
 void mem_cgroup_flush_workqueue(void)
@@ -5555,12 +5553,9 @@ int __init mem_cgroup_init(void)
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


