Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4246CD5BB9
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 956896B009E; Fri, 22 May 2026 18:06:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E28D6B009F; Fri, 22 May 2026 18:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CFE16B00A0; Fri, 22 May 2026 18:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 703046B009E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:06:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2ED8C1A07DD
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:06:41 +0000 (UTC)
X-FDA: 84796441002.08.39C7A4B
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4ECEA40010
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:06:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pkBI6bEq;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779487599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=coCEHSpY96h8xPt3azS5bgHLcKMYgGKS1j3gGbJhNfs=;
	b=AJmzmUl9O5up+Nt+xJKTV3uOuCD1sWqQDFf/jTWQsy7m/Mwd5qx1y1vhw2sl7pOMpy2v9y
	SGWmzhCgnEjbGmf9JgxY/gHp8RWuLq3DmuwoytVNGzmpLRiqMWasHB+sXyfLlOOO0/c5S5
	RnFW3ShtmRe1eNp9UHaJ091GsvBtgkw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779487599; a=rsa-sha256;
	cv=none;
	b=fWPbzEz1aZeXY2h3e2aZaGaC04WwiQF+1QSj0HmpTHF1pTApp2sgsdlbd3nnFZ9vWbl47c
	rIQkGaFExbK5HS2xzUVBKl6a2F0u7UNfTZLOpRt1Wm/41hPuxiP+g8DoRc9MQQLOnCeFVd
	2yUQf1kJD6sEc6Y/PE0nvjIoPhcGb/0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pkBI6bEq;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-69d8a6c1737so553502eaf.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 15:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779487598; x=1780092398; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=coCEHSpY96h8xPt3azS5bgHLcKMYgGKS1j3gGbJhNfs=;
        b=pkBI6bEqaz4i1cygS3OzaGmOm7mENB+BvesBUwWRfgFVcEugflObiMZpYuMLareQ3J
         Z5MUZ3tKW0vDmyT3E+rhCnJ3/32AReGq2mJARrDll8xa5BYZ6KcsiHO5g02IgtVALY+v
         vM9TA8gRhp7aLvqfLaCvWVoe6BhgwVVypaVmTjiRwV2zfpJ+Fc+8bdvVyi7B474UOcFV
         9mGyHEGnIZ5MAf5ebsU/kNr2x/hwbKKTV43LJ1FZ2hCcdf24gOawg2663XXiB1R5/EhH
         lL3qQlmkX3AobvtjyE1kxEKkxYgGngEgdsXhEB2XgAYQl52qpYh55t7edtx8Dtainx26
         PpMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779487598; x=1780092398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=coCEHSpY96h8xPt3azS5bgHLcKMYgGKS1j3gGbJhNfs=;
        b=JGZiHJucI3xJGMaQaEOkb9RNrA9poEyBhrE0RnUQYyMlzsxVL1mUG41Td4aY4sOS/U
         qG7ES85jLMsw4gs+1NbPuTSmsx2rEnXGneXuQ67hLcxexyJVfMTxNNwlQXdtWxkhuwsL
         PAkENO83DBpweW3k02hxUrnDujLF0mX/z8O8JtwyI+35/aNfu2Ec9rPevFySTkFgn/KG
         CRaUOjMV8AsRqqFvhh2aPdjZwVkueJs3yjCqA6bMmSRy9ZoDOFlnMLnT8U5Mpxn/gc/g
         aX7XaRiQfk0+llc1EuYfzJ1CkvHcMOlpF/PRR/Tc60PSU1rLSUP0X5chTRn1H2P8uUB/
         sylw==
X-Forwarded-Encrypted: i=1; AFNElJ+Nm+3HhCIn3shjuMn9G7j3QuXj5hmgSQWVRHoVePMBwTntjk/UJ1hcmhEKZ7Es5fCDhE91qVzN/A==@kvack.org
X-Gm-Message-State: AOJu0YzkwBauURvEysVoakEyUit+o4HVjoVGdW85PzlkJMagCEVI9dEQ
	+dfSgmG08U+Onn4SSF0/Pwj0j+dzpxzePj3DM7iqIBFD0FhozksKiTrf
X-Gm-Gg: Acq92OF+c3Eob5teY7xJVYIWteb8nK96Bkoid37/XZEkTeRTYSHx9RQOqoE8bPCcGhZ
	fNLtBapLHhAC7RK4y00bl2Bflm6mIH7Ldp2FNXdGecuV7L9k4dGS/mswC0xBhAl/7ZxRaN8IZXg
	XzNCGDEBPkF+IQOM0BrFUxnsBi+Aj/DN9xAsO6P4axOWH7zVjxchocpHrUixt2it6K8RG/aSiXg
	G+SD7ji+9aTeC95/5t8Cct17txjMv5QEpesl+NuOpMvY8EjXztLySC+/WGkPUIjFDb27Q2923Bc
	3vdA/DMgdkuExiyoPAeTd2nUe3afWozXkJFf4k/8kCf8Si+dxhMOsUrwT5y1uxa6v/sDMSaOoXa
	YVA0xrD161cSwO/zR8wMrMBgOD/oqqwmLQvQrD1GvgN0JXiA6ZUPqfypYLGtD/bGJBK2DEjFkP/
	vnsNzhDHL5XOc2KrMx7lBV7kBsxjrfiutAFlYRUg7B14c9S9ann3GVqK0PDiLywzw=
X-Received: by 2002:a05:6820:1789:b0:696:834d:cd15 with SMTP id 006d021491bc7-69d7fcaa869mr2248091eaf.7.1779487598260;
        Fri, 22 May 2026 15:06:38 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:6::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69d83a4eef1sm1506487eaf.11.2026.05.22.15.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 15:06:37 -0700 (PDT)
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
Subject: [PATCH 4/7 v2] mm/memcontrol: convert memcg to use page_counter_stock
Date: Fri, 22 May 2026 15:06:22 -0700
Message-ID: <20260522220627.1150804-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
References: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4ECEA40010
X-Stat-Signature: 4gujkhfa9xorptwa7zj77nxrpaxwpazc
X-Rspamd-Server: rspam06
X-HE-Tag: 1779487599-199765
X-HE-Meta: U2FsdGVkX1+tUzLWEWnAFmAkpobxfsC7NfaiexuO8Dr/qXIt36HnGTS6dsp2V27/Xe/8O8aHW7+FSLVIVe+4O/zQdUeNd8lj2wCASnxnw9UpjooCoNkO0zkcdbRFTeEmi2fJF+mg8H2gDbZhD6rgPXD+ZsGOj5yBVztIOgL//LebJHeVucM7kDVNYaCrsvQcvdssaZ3loqeUinVJz99ZLa1uhZrmre/wPKjVWRztnuA2y1jxU/lRKccgmNKI0/loQdTL1v5TPyp1aFfzLhLTuDULiYYpmV7lY/YiixHfjfX7H9Y2bCf3htBqeVqDEqCgI/tlH2yLt3hWTWfnxEYgA8pPZqdEINHpfEO6yVuPeTTIcp7Z80Lr0kg2Jy9YZrUhG3mQTdkZ6564Ga9CD1Tb7c9EvM1kxsfbTIK+/vdmCw3CRnYPXTpMVSKwAPfJdGykcQOf3lqX6kIi2BzKXpqZVpBBSRk9AD2/Ehxhh9J+gMW/rxLr9SGZn7sQ+lhlta6ZsK9mh4+Qpzfqs35oRAy3DcDoiXX9BM5gcpLpJMiAWyTK0SJDYTmAzRWp7Bfanh349JVI08XtePB43feofw23VdkpNgdBXjeEGqvd7ISVVyPp4rukW/Rrl8NsUutELEMZ9wJ+kFrtoJsxhbwbLipizZ2e9SXVgy6kOooEZD/7KUsAOKgRxBWbqEa2Ca5RBTvs0UOBHFZAOwEYof2MU83E00Wf0gU3mOLpnGvwMS+DvCPowqVUH4Hk+eaYGvNTr+ZV8tMIi3kFaPU0JvV/rc9TuoE6wf92w6owIKxPaO1YMTve3FngodKflKdw/mjFp1+GEc9sIiqmycIi5uaxLe0hYUOpFSDhGnUJidUFu72mgQRMnIqcMoBkp/gsJMWtxXUo7aC7eETISGUvSTqdC0VehOi1ln85UTE4qe0HzdJYbAFL1cJU5L/EkUrGJF3X69on3/gkRnmx7uBDAQjoQZw
 SUqu+kkc
 AOo2HUPdi04LojC27KoJksWOowKCArtXdbowzD7+DIB2G89L0djuwo2m06BbU/jNbx3dydA+eLjNJEfc6HuYt8ALIn+am2lisU7ZmGF6yxcpm502qOufIcQ5vnI4X46sixbRHaE/9uUHbfpRC63gTcnkJFHklA5pkwIvdeFBDPC2bR24vceUl8otm19NJW18vg6A2qFgVqZYDzbsdacDCUSkk1L0BbYK5ofc4SSloy5U9I8EMfLfMrYsIjNDake5HW6Qi0W5c37A0LokkZiDGVEnnNwPprfHScdFvHDng80YfoFELOJIie+d4+P2D2Ey/JXGMAlfsLcH6g2h6AxglA4GdefadRmOMeEePZV8WXXtLTB8lDYVAfoFxNvo2ZZBszQathYgemcs0UKAqOZ8ak0VBZwemqGkCydoODBUdvQOhCFm5A2lq7gGVaaEhxzJGO9/jajQ6DwFq3ViYFZ1zBLDMRhoF6+7zoe8x3ZQFFP3WMY9KXFpnnG3uh3ZHp7htMFrymmMibbr/xc4s+4jM2TJofLwvHmYI8Jj1KkZREmd4Lfvz946qUIWdqbqA1506JXFfmBT13HlxlpUSixDt2LVQi/NdWamr7YMs
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
index 051b82ebf371c..cb1ea17e03730 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2053,6 +2053,17 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
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
@@ -2064,28 +2075,16 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
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
@@ -2102,9 +2101,13 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 
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
@@ -2379,7 +2382,6 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			    unsigned int nr_pages)
 {
-	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
@@ -2392,31 +2394,19 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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
@@ -2513,9 +2503,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	return 0;
 
 done_restock:
-	if (batch > nr_pages)
-		refill_stock(memcg, batch - nr_pages);
-
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
 	 * reclaim on returning to userland.  We can perform reclaim here
@@ -2552,7 +2539,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			 * and distribute reclaim work and delay penalties
 			 * based on how much each task is actually allocating.
 			 */
-			current->memcg_nr_pages_over_high += batch;
+			current->memcg_nr_pages_over_high += nr_pages;
 			set_notify_resume(current);
 			break;
 		}
@@ -2858,7 +2845,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 	account_kmem_nmi_safe(memcg, -nr_pages);
 	memcg1_account_kmem(memcg, -nr_pages);
 	if (!mem_cgroup_is_root(memcg))
-		refill_stock(memcg, nr_pages);
+		memcg_uncharge(memcg, nr_pages);
 
 	css_put(&memcg->css);
 }
@@ -3797,6 +3784,8 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 
 static void mem_cgroup_free(struct mem_cgroup *memcg)
 {
+	page_counter_free_stock(&memcg->memory);
+	page_counter_free_stock(&memcg->memsw);
 	lru_gen_exit_memcg(memcg);
 	memcg_wb_domain_exit(memcg);
 	__mem_cgroup_free(memcg);
@@ -3956,6 +3945,9 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	refcount_set(&memcg->id.ref, 1);
 	css_get(css);
 
+	/* failure is nonfatal, charges fall back to direct hierarchy */
+	page_counter_enable_stock(&memcg->memory, MEMCG_CHARGE_BATCH);
+
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
 	 *
@@ -3994,6 +3986,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	lru_gen_offline_memcg(memcg);
 
 	drain_all_stock(memcg);
+	page_counter_disable_stock(&memcg->memory);
 
 	mem_cgroup_private_id_put(memcg, 1);
 }
@@ -5185,7 +5178,7 @@ void mem_cgroup_sk_uncharge(const struct sock *sk, unsigned int nr_pages)
 
 	mod_memcg_state(memcg, MEMCG_SOCK, -nr_pages);
 
-	refill_stock(memcg, nr_pages);
+	page_counter_uncharge(&memcg->memory, nr_pages);
 }
 
 void mem_cgroup_flush_workqueue(void)
@@ -5238,12 +5231,9 @@ int __init mem_cgroup_init(void)
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


