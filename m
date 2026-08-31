Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2555C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FC886B009B; Mon, 31 Aug 2026 12:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 686DD6B009E; Mon, 31 Aug 2026 12:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54F556B009F; Mon, 31 Aug 2026 12:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 291FB6B009B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:38:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7DE31A01A4
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:38:04 +0000 (UTC)
X-FDA: 85162121688.17.50EDDD1
Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id DE17040015
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:38:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gYWONOfI;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788194282;
	b=cQ98weWTMpW3JUtrCMfwUW7yGQ3+ZuQHCeMvqSLX8St/oIVyMK47fkOrUzqmAqkYeWKYqB
	kcG97CXd7p26xKe77WZ+HftwmvQXCUGDG1AB5s4ei0SdHx0Ply7gsjfWKpYeBpi4VT2VuC
	90wXTV2CLRY582jY2sg5CVMqocoBV+E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gYWONOfI;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788194282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KCEcxBXECIK58MqzfUHKxW4lG6L2Egx8+PoUClZnYOs=;
	b=IsN3hh+4gSFQn2HwnKzDF69OoVAs5CktdUkAF8GfIwW5qHOPX4fnnxRsb/vOe6GvqCJ8B2
	9f1L9VY659lfUgXOM8ZDbIYz7Pzo1RKBetJnLRSF4GjvkGwTpMNrolze0G4RqIPhJpWHlA
	T38eE23WKlJbgVnk8M0zBSD0sIvsyIE=
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6b127c88220so1389926eaf.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788194282; x=1788799082; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KCEcxBXECIK58MqzfUHKxW4lG6L2Egx8+PoUClZnYOs=;
        b=gYWONOfIGFKPZlHu3Hmg/cG8B5mNA62ofEur4C1r2rp9WzHbbI2hLbd3YOLv5S2EeV
         3Ph4N1pnXRVPAZUPNrgCp68Sa6ryiRUJWSTsd/L2zmRhRqPtXd8ba1YHpBXwsunjIeT3
         S8qItCtswvdTplDc9AmKSLaCRqPlPcDQup2nzhs7Ad7r04EqpWm6pnsBB3V1SxOHrdpD
         ciqwuk+y7RaahuKRenVGoezQFrVGjaHkE2dHBk9sqUuZTTbdlCrnWBMXR0HE9EGzt3rx
         6DjFyjhAJaLpKNGXjdL7Lp40B+7qT71Q/LZqsQcGWLjqpmtuaF3C0i0l2NhUqm3IfZ0L
         PEHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788194282; x=1788799082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KCEcxBXECIK58MqzfUHKxW4lG6L2Egx8+PoUClZnYOs=;
        b=MSoGC82xWxCqeVQnob71MtDF7stPR9ygUrJdY2EqO1iKMAsffB1R1oQ5Optv1wRFHz
         iM96jDaS2xyasSzZddkAEGiG83Ial3twqXpEsDhknQedJ/NVcByKWffhHBXSb3TN5rJi
         Plv/bgzKNN1wGMoe2OJsUMwdf3P1ahsyoNzlWUoyDynRPkZyL7eKVakH1us6YLWEAKnh
         A55YpJDEKHWdab4JRhfgjimAg+ASqZffXU3wIClJSH4uMM9SqyAzxTAiPKR4MebNRpLQ
         j31Ur7bO0YxuJn/n3f6MDOWRMcl6u3NgHb8NZqKFrQ4XmY02O310sUpXm9MMxUUqUInN
         B1NQ==
X-Forwarded-Encrypted: i=1; AHgh+RoJhWtvzWir+vCr2mWVMbUqu18RtL78EcIxcnGziMSbvumRYG+envo6AhQiazFVCAJUbE8GRe7Rnw==@kvack.org
X-Gm-Message-State: AFuF++lbLsTUhvX54HInCEYWo8DY3cnY4nAtfSM/rUcut4GIqdgGP18H
	oXzJq097+9d6A12SMjRFDqEvpmsqOH1vel0Ud96qk+wPmfEo78h/kQ1C
X-Gm-Gg: AR+sD11F2etChZ1zMDUUnk/CZ1N/sm4iBF/OJdKDDw/JiGsngYPqMo8B0a61jSr6ScZ
	FUK9NsL/4F9q3qQp69x5lWbG1ZjQz3ZWwUxw5I/PWg5zo00eXM6rFgbdxFwrIchYVcoND5sp8u6
	Oq+MSMKGtk3rkwm0Ev2Tv54SmLAAQhY1Qh1do/4HSJec0JmVH8du7LarmtipUzTFMJjtC5lasEm
	R8cYJPRx+vYusLo4T94ARFi+LhiyVthvJCoy3WshtUqoq6sYNoPMZ3IzxplZu8obnGxjsNfhv/W
	X8YI/UkBBOtz1fC8CXH8z/EhkDC3hGUXPxK1rerOFKxByRGuxvScCW8iM2vv6ucW7t0BQXIwoHe
	Nvd/hioY6R5oXLAyBYpNKyRdq2lgmRud0+owsLDwegurdVliFBRDNtn/tw4rFzmheeO5DBvj/zn
	Z4nIQ4Aycru6xr4PDyMbiTXHhFffHGfEf/qu2/G4N98JNymsaktARywtvB7ka2zO44i82Z2HWFE
	bNn+3ltPFj2AKJaaw==
X-Received: by 2002:a05:6820:1791:b0:6b1:d18b:4048 with SMTP id 006d021491bc7-6b372d21358mr2106016eaf.10.1788194281822;
        Mon, 31 Aug 2026 09:38:01 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:e::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f4fa7e97d5sm8453832a34.10.2026.08.31.09.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:38:01 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org
Cc: roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: [PATCH v5 7/7] mm/memcontrol: add stock to the memsw page_counter
Date: Mon, 31 Aug 2026 09:37:51 -0700
Message-ID: <20260831163752.2193337-8-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DE17040015
X-Stat-Signature: 6urqn4j3t6pk7fpsrbqpwmuaabebpxxq
X-HE-Tag: 1788194282-161061
X-HE-Meta: U2FsdGVkX1/z8GfHhsqky46vJYDgmQVdw0HEDNOYP5DAPqZe4cvuLYfS3SvNMRiysfUyxUxShbAnAOxgbSLk38xa5pcgzmjGkGbkIgsWi4jwbu/vy5AVwGYXx7caasA77K04vRoQjNqUCPVuH2499Tyq8YrkjOXEnPFGemfYCpZJNteywZnVywjaWjfD2+PZMys0prfyuhhGrkJ6lLUGxlZ7XU0w/1Nx9C6ggMa7Y6DNUjw/ijXWxMEX/rgK3Y5bHFb7LUfP13FzY+K1Nl+jtoCEEP8NBS+SvxNssXfo+nq78PKPh6Ke9luPhB+EGBTcUQBBHjnSt4wbCH2p+iACCPfI8rvfGJjs8Ky7kcKkW0O/tw0g6k5NatQP2iGsNaj9gma1l8/FIdOW4DOU1kO1FcZBBFoO7vneDbhCg3jpyCTx3khQwLeIqhlaNaDRHG7RPN/lAkbPDZ0Ei48jmhJDovPBjESx2e8CBtDvgssotOKdhef3M6ECzqUeVSr2omJws9tMRNpOW8Me9vkU3I9cd5dS8P0sojw53mVzKXPFiecI+Bd9VdAlJ1g0Ey3Fy9RpmV53m8XZhQNEw2+kd0jnVX1bk7TRhpBDD8clWGGx2sxIT7umiCiFoxA34sxK0ONp1a/prf37KKWIGD9PAR6jnB441UxM1cV9+VtHrpOK38sxJw0sd/2gF/DmNFUA6LnKviBu0/i35GchwLJnoqIWP+Udr8OayRSok83RLaBc4bNDlW36RE53mIW8gRWwTddo1kR+/PXbOuiCEauSH8PRbMy5TZwRQ8FMkIDiK/CkzO7RAGzJacl5vOEsROvhXqLm2rWW3G2Krv7g9o0/9F1m3AW/JTrE3yajMNmSv+y5Z36IQN/q1sxjTvgEg1POQwbbZQmraPP1088YvoMdvQacW709NHgaHoPVoA1SRrMTnF8uBVmdP+3LPNPHOyJRP97tFyIlXvm7NblBpRizgaX
 d/T45NDy
 cFQVD5MUcPJfnTmLPK7CEgix6NxButJoibGVdHBYcxr906RmP3rSEcU9gEi5e0dPmSmncAbFWBebdUfUwp2M6bdSSudITXYb0Bb6kVWArVmNbBo1sckMhGL8r+Ga04cZyzMf3RznUqPt+yKKd/PN3pRbbmaM/j/ebV0n6kN5DoLb+mscha9M9mhG3iMe9XpDIUv+8ol2MtHbZOmzZUZ01B5LMlMbU4CnPMqAowP8tndFSi1S8MGcH6UhYqBxuHhNrekB8u900749l2rGnW3wxreSDkYntd9Y8b09P8xc4lvAdkRGf7rqSwCWiSneQ3xHjuQxcVXGS8yLpgIFRBbqxiASNM6nYUfMXjpCkzt80JU0c+jumDQ0osd5iew2pzkGRPVE8JRuEGSwHvWc3TtBYxvqs4TuO21YkHUHh5hyfMWmJXIEO5u6jprl3DFLvzajb5AeRPodEuPf1yGoyMyinGRr9AoknTmPdVUFoeMhXEtwsSrzFYi+hRHKhTZXqtf7AlU3sD0g8l0UdTtiX7TG5RYB2lC/UWDTj7K9qXEAF9tYcHwg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before this series, each memcg had one stock shared by all its
page_counters (memory + memsw). Now that the memcg stock was folded
into the page_counter level, give memsw its own page_counter_stock
so that it can benefit from caching charges as well.

Note that while the allocation is conditional on do_memsw_account(),
the freeing is not; the freer will only free non-NULL stocks. This
matters because do_memsw_account() could have changed in between the
allocation and the free.

This narrows the memsw skew introduced by the previous patch. memsw is
now charged in the same batches as memory, so the two no longer diverge
systematically, but can still see transient drifts since each keeps
its own per-cpu stock. The drift is bound by
MEMCG_CHARGE_BATCH * nr_possible_cpus.

In the unlikely scenario that one of the stocks does not get allocated,
there will be different granularities of charging for the cgroup's
lifetime (one charging in batch granularity, the other just in
nr_pages).

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5678486cc55b0..33e4ffbd48a8b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2127,8 +2127,10 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 	if (!mutex_trylock(&percpu_charge_mutex))
 		return;
 
-	for_each_mem_cgroup_tree(memcg, root_memcg)
+	for_each_mem_cgroup_tree(memcg, root_memcg) {
 		page_counter_drain_stock_async(&memcg->memory);
+		page_counter_drain_stock_async(&memcg->memsw);
+	}
 
 	/* Hotplug races are OK; workers only touch their own cpu's obj_stock */
 	migrate_disable();
@@ -2159,8 +2161,10 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	/* no need for the local lock */
 	drain_obj_stock(obj_st);
 
-	for_each_mem_cgroup_tree(memcg, NULL)
+	for_each_mem_cgroup_tree(memcg, NULL) {
 		page_counter_drain_cpu_stock(&memcg->memory, cpu);
+		page_counter_drain_cpu_stock(&memcg->memsw, cpu);
+	}
 
 	/*
 	 * A drain work queued before the CPU went away is executed by an
@@ -2467,7 +2471,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto check_high;
 
 	if (do_memsw_account())
-		page_counter_uncharge(&memcg->memsw, nr_pages);
+		page_counter_refill_stock(&memcg->memsw, nr_pages);
 	mem_over_limit = mem_cgroup_from_counter(counter, memory);
 
 reclaim:
@@ -2926,7 +2930,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 	if (!mem_cgroup_is_root(memcg)) {
 		page_counter_refill_stock(&memcg->memory, nr_pages);
 		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, nr_pages);
+			page_counter_refill_stock(&memcg->memsw, nr_pages);
 	}
 
 	css_put(&memcg->css);
@@ -3930,6 +3934,8 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 static void mem_cgroup_free(struct mem_cgroup *memcg)
 {
 	page_counter_free_stock(&memcg->memory);
+	/* memsw and swap are the same counter; only memsw is ever stocked */
+	page_counter_free_stock(&memcg->memsw);
 	lru_gen_exit_memcg(memcg);
 	memcg_wb_domain_exit(memcg);
 	__mem_cgroup_free(memcg);
@@ -4098,8 +4104,12 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	css_get(css);
 
 	/* stock allocation failure is nonfatal; fall back to direct charges */
-	if (!mem_cgroup_is_root(memcg))
+	if (!mem_cgroup_is_root(memcg)) {
 		page_counter_alloc_stock(&memcg->memory, MEMCG_CHARGE_BATCH);
+		if (do_memsw_account())
+			page_counter_alloc_stock(&memcg->memsw,
+						 MEMCG_CHARGE_BATCH);
+	}
 
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
-- 
2.53.0-Meta


