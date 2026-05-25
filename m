Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3298CD5BD5
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 19:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368596B0093; Mon, 25 May 2026 15:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33EF96B0095; Mon, 25 May 2026 15:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192386B0096; Mon, 25 May 2026 15:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AC3F6B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:05:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DEF81401C2
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:05:09 +0000 (UTC)
X-FDA: 84806869938.07.85DC069
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id C4EB640004
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:05:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="CLne/U1i";
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779735907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xtAatjseL4y/ybWN2OirmEntLqGpzhQX4p1MNNqGB8M=;
	b=shBg4QMr6T34D/J+v4kMT+szxzg7FRC66h6becEqZXNso/K1iNpJ4Kh21zttrDKkqD5tvf
	X4E5kiFYA5atARO6VB/W2xAjS+e+7PFX7xqaW80xcaiMegl3Iv9R2Iqf6yBt9zSiBbfBuf
	Ax5HWZwbXTDPcL96OSpzn0h0UFYkSFQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="CLne/U1i";
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779735907; a=rsa-sha256;
	cv=none;
	b=WCDHDrkU8F2P1GhmUJV2hS2RBGSTBS1LOc3hRwFIdVoEhjCH2e+BZXoedO1i/8eN9Gx2AM
	CXKjGCczVEX9SdK3+i52FBdAmPMWF61pcT+NZJzl9Ly6gecP+X9rrN/TpdgBsCddGaQi1B
	mMnzFkAwD2epiUkzBxgtRtkP/FA+VyA=
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-43bfe209e45so82875fac.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 12:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779735907; x=1780340707; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xtAatjseL4y/ybWN2OirmEntLqGpzhQX4p1MNNqGB8M=;
        b=CLne/U1iMU+q3PcR+nOFJmbcHkLw+1JiujsB7VQxsEZH26tLrtVsfpQ/ZeHCi5QLzc
         UHuv1eeAt++W0p11kWWYMrp2IrzpQDT4pwJQHgJeVXx0mZSwOsFvO8X+ChVdwgREpzvS
         Z4+aiwiv/J7wHxUxp5x5fOx3iSQ/rsmcVtlD7KDFDFrGZl48YNDqXZ3gaXDf8Yxj6zt7
         TnPldiDXBJo4Es9LtNm2gADdOIC8HqBFW/BIv7Ynzuj8bl//u5P2XIPJ1Kr0HNUlP3OX
         JP/mkVuKdhEnNLa3UEvqhaNEWgMmBh+8RHoOIy+jOjkdytK2OXZcjb0EL168BTBBcuiJ
         +uaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779735907; x=1780340707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xtAatjseL4y/ybWN2OirmEntLqGpzhQX4p1MNNqGB8M=;
        b=OigHbwZFwMu7KklZcZaRs4/GRmI0ybczCHWbqv0K9himdkqecT3uEMDVoc5IOilXWB
         kXT8ZgIYUmu9IDx6qExxbjDOROfEecH9pwYSgjbbAztyFV9YOU/8K9YKZvEMiYfzoIQZ
         UQ/AXgkWtric2a189ndAmXi3W6uXheTVbpGPeZtRQqzw4pn/9WutxPWo/uYi3CPs1kyj
         uwBsUaJjuenHuKTukltgHsuMZoCJSaxVP5X4cBphbIvtOj3yQ6zOYHVzPKBrtn4kWhbE
         zbHyCcwQN/HQVVVKNUrooppYI0fWhTSPW577BNTfKZWG2sYgKzpSZT5A2dg/kZSDmnhO
         vYCg==
X-Forwarded-Encrypted: i=1; AFNElJ83mq6uLtHSQd8ggosvP78YQ6qLqZ2ZYh4U+F1SVqR0t/3TRb65OoIKiTbDa2JY2p9TWZlzfemtyQ==@kvack.org
X-Gm-Message-State: AOJu0Yz0QAtOu3x4lKH1IrWOianesKSmMUK7rfpyOwr65yoA10SIJJyt
	+ZDSwRrsXJeD5TnevW4PHX8tjOYKzQTVBfEscsoZ07BQNOFIeL8lujNd
X-Gm-Gg: Acq92OFJfg+Fp3oBbAuWpzM64Bif/SUL6m8HC/HzDKNR50NlJjmQ65u4ISvj8ntYbeY
	2MW5Prf8Ogd4B5Ab+XAIzjcuyPTAJFNzepl7shLTfaUei1W2ZkEPvODGeFxVaeGT8eDjF/WlLGD
	/pEv/Bc+BTym/PpO86L+WzIlsIf/78+BntQ/aTarwvBgaPPVHUW8nl5nD5Ut0R5TnjL1aEXkI/a
	4hStWexNkevImdQjLkamJvv9r400n0xAIwoBEuhYkB0OOTsSMK8m7+vmwNs6vkj90gOsuWY1RJ+
	wNLF2je8ivA0r6gFFN/okEKZckgNiCDwC6T92inP32XPZX/DIOevApYyqfINU5gWslmAO8S9j6a
	zGbNi2xa4S7es8woM9AxrLipTTFsRgZLcSRNAsVAdkltFcJCMEv7CrEDGN9D9xeAAVsjVNLA82v
	NF7Yku4dWI/6B+tVY9VWHIXkIFIAI7Pkjdwb8ohT2Bx3rB9aFsUz1d5gXUqO7tanQn
X-Received: by 2002:a05:6820:198b:b0:69d:c626:c404 with SMTP id 006d021491bc7-69dc626c494mr1351814eaf.24.1779735906675;
        Mon, 25 May 2026 12:05:06 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:43::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69d8370df8asm5673853eaf.6.2026.05.25.12.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 12:05:05 -0700 (PDT)
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
Subject: [PATCH 4/7 v3] mm/memcontrol: convert memcg to use page_counter_stock
Date: Mon, 25 May 2026 12:04:51 -0700
Message-ID: <20260525190455.2843786-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260525190455.2843786-1-joshua.hahnjy@gmail.com>
References: <20260525190455.2843786-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q4nsxonio31xmadn5yym9h1d4zbeyk94
X-Rspamd-Queue-Id: C4EB640004
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779735907-481550
X-HE-Meta: U2FsdGVkX1/mr/wQ6RJ9NAyKWYqa7JY2yorAZlBAZA/jVrrbaY1ULVhARHS5x6TNZzBzKqWSHfR+E/JQ4K86SGmNeOUudWpiEcyotZAkyT1lOKcZAqEThIr2TDVkj5NeM7r8nTc9s0B5rwGVV8NS3mAwOR9Ngdqjw/C5xtt1Jl6PQy6ddqcbWBQOwWqASeJwUCaSNFVZUqMDShhstdTDkCfrZpu/+P3MYIvlYnxzR4z2U+hLLQi7rm4JCwuKONVarChM3adPrT9ZMMrgNh1uVp9aS8eWMi8xt2Om02/SVW8ykenxxiKjBlogLEv5fGPd8G79pSMeci/ubB/iwPZa8yC8pra7A5IvHkuVnKK23ynwbA8DdZiE8Lhn9VXdFop6u0ZLDYGZfZdkLM4TnnO20CpMPLTfJUFWZQPLh6IWB7XJjpN9bHkCDzOvipl/L5mLddRQHsNH5usG4FwGgiY6evNXlAaZireBTCDj/aYmPE/UWoUNwW14DtFuOhZ5Jk3uxXXnVOCk4YIDyrEikSCVkW1suExmMjt6yMplruq82ESo2MJ1hsNZjI0J40ED27koh8pAEuKha85G8bN/5jZL1BfCLmK5kT+YNf1eEOO+8v8E3ZOw7GkpxaZurn6/cObQr4NL8EJByo5UxdxSXCzKieTl8g09YRzXP7uBHQ7rQXH0SzwiYvhB0kjPYQT9QWj+o8vYxc3xwRnPWRTJAwvSL4YtkvFdv9D7L8fgubXZpqqfet50875Zo7Fc28NbhpNCdj5fvfnIg4+8zb97VWnDFp4B3Q6iVL4lSDhePE+77M3+0ZjR1PC9hYMg95VT3718Fg4hSAiSFOQf6eLksP35T5FhJ9CrZJy6OfM666QroRrbOfD00V7cwlWdgLLWB1LrfiIkoynCGRF3SJ+WeUnBchIgb5aXmYO9mVeHki5QhjgLTcpHValjScgPlfgLQNDYiy6CNttF5nNn1UdmcQC
 EJe2EB4u
 U615VlQhsjShuDgcXIgxgiADNm+gip334J/ANnT64GuFV0I9/HJPMYDZZivFnomqgGDYD/Vv8jxy3gE8D0QiJDbBntufvj1ByLYeCkRRwASnmBWNuZa34/KCbmVPDFG00zl/Wv4FJpTIi9CJbMnTUVw/SwZHKwOR7jKmH54RJNPQfsgq5ES5rlBmeSm/PsPtO4Vt9Is38dXtcBE24yUnqa91nyopoOyKCbCjz5Ri6/6leRrp5Xj8Flq7FtOOpIo/lG6mhAveHhd+GOOGFFRajOauOFkDkWivFwz7bzPIpkL7X4yfqd+7csprocVQcRldGPPwieWTGjfg9w3+GE0J5S16BqFiwStoWSO5kdWXXNsovzE/H8uG17khMFTodVsE6M8sAkJA+YKz65fevWPEWnxXybQchBe0qvhEGsVYRTWHbidZILaCdcxlL0UPe7ufbPcyOEnFNMF4rUC3Qb4MX9TygbbttnsMQ/r/xsSowAFlYwssSUEwZi50jDL7gxv4E15ITIkwEupDMMn41Et+75VjTgtQuTTgCYILVThYc2nnTTSbErCoMymvEcPuD4WDruw+cgHXsMVQ+l0F58fwIuPbfmdvR+zOaozDd
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
memcg_stock slots. In the new per-counter design, refilling stock just adds
pages to the counter's own local cache without affecting other memcgs,
so the original reason for the special case no longer applies.

Also, we can now fail during page_counter_enable_stock(), if there is
not enough memory to allocate a percpu page_counter_stock. This failure
is rare and nonfatal; the system can continue to operate, with the page
counter working without stock and falling back to walking the hierarchy.

Finally, drain_all_stock is restructured to iterate CPUs in the outer
loop (rather than memcgs) to be able to schedule draining all memcgs
via a single work_on_cpu call. It reduces the number of synchronous
per-CPU work calls from O(memcgs * CPUs) to just O(CPUs).

Note that obj_stock remains untouched by these changes.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 78 +++++++++++++++++++++----------------------------
 1 file changed, 34 insertions(+), 44 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 368efc1455e35..952c6f7430395 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2260,6 +2260,17 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
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
@@ -2271,28 +2282,16 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
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
+	for_each_online_cpu(cpu)
+		work_on_cpu(cpu, drain_stock_on_cpu, root_memcg);
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
@@ -2309,9 +2308,13 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 
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
@@ -2586,7 +2589,6 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			    unsigned int nr_pages)
 {
-	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
@@ -2599,31 +2601,19 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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
@@ -2720,9 +2710,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	return 0;
 
 done_restock:
-	if (batch > nr_pages)
-		refill_stock(memcg, batch - nr_pages);
-
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
 	 * reclaim on returning to userland.  We can perform reclaim here
@@ -2759,7 +2746,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			 * and distribute reclaim work and delay penalties
 			 * based on how much each task is actually allocating.
 			 */
-			current->memcg_nr_pages_over_high += batch;
+			current->memcg_nr_pages_over_high += nr_pages;
 			set_notify_resume(current);
 			break;
 		}
@@ -3064,7 +3051,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 	account_kmem_nmi_safe(memcg, -nr_pages);
 	memcg1_account_kmem(memcg, -nr_pages);
 	if (!mem_cgroup_is_root(memcg))
-		refill_stock(memcg, nr_pages);
+		memcg_uncharge(memcg, nr_pages);
 
 	css_put(&memcg->css);
 }
@@ -4096,6 +4083,8 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 
 static void mem_cgroup_free(struct mem_cgroup *memcg)
 {
+	page_counter_free_stock(&memcg->memory);
+	page_counter_free_stock(&memcg->memsw);
 	lru_gen_exit_memcg(memcg);
 	memcg_wb_domain_exit(memcg);
 	__mem_cgroup_free(memcg);
@@ -4268,6 +4257,9 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	refcount_set(&memcg->id.ref, 1);
 	css_get(css);
 
+	/* failure is nonfatal, charges fall back to direct hierarchy */
+	page_counter_enable_stock(&memcg->memory, MEMCG_CHARGE_BATCH);
+
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
 	 *
@@ -4330,6 +4322,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	lru_gen_offline_memcg(memcg);
 
 	drain_all_stock(memcg);
+	page_counter_disable_stock(&memcg->memory);
 
 	mem_cgroup_private_id_put(memcg, 1);
 }
@@ -5524,7 +5517,7 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages)
 
 	mod_memcg_state(memcg, MEMCG_SOCK, -nr_pages);
 
-	refill_stock(memcg, nr_pages);
+	page_counter_uncharge(&memcg->memory, nr_pages);
 }
 
 void mem_cgroup_flush_workqueue(void)
@@ -5577,12 +5570,9 @@ int __init mem_cgroup_init(void)
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


