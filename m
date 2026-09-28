Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC053CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 19:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8276B009E; Mon, 28 Sep 2026 15:24:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 281ED6B00A0; Mon, 28 Sep 2026 15:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 122846B00A1; Mon, 28 Sep 2026 15:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC7A96B009E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:23:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6072DA01D3
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:23:59 +0000 (UTC)
X-FDA: 85264146198.22.8D93393
Received: from mail-oa2-f18.google.com (mail-oa2-f18.google.com [74.125.231.82])
	by imf19.hostedemail.com (Postfix) with ESMTP id 89C0B1A0009
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:23:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RxZdfpfp;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.82 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790623437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=90m4D/TpGSCtcBQnKW4O2iMu0JtOyx2FA0RhV3nyqiY=;
	b=iJX4DMj7r6Y7/G5nKgo/kP4rCu8LtRzfqaNmF+rXvWQOFPKJX++prHH37nGh2TdxbMy1fZ
	x2vRYMO4A50DpIikoZgRhn6+Qn0+ugkI5d8nrijyDQ5p1KcIdg4hdRb7ZdCwXNC/Dp+Wyv
	GLSj/yEnE0PfnbyKi9cdNjbkk0uzHkw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RxZdfpfp;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.82 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790623437;
	b=SAXyhBl2vTYahNfvwcXhhRoXho0pufQYhjGKJFKlzXZWrzIppsYkSQ0T+UpQ2+x6boHTd5
	AxkfTfqYzf7yRqYHitSBvNH6RtHKDRk6ylGvaXBTXU9RBuSjOPiicOsu7kt3RzhmoxMz+N
	6wfTmouiUSJicQTopvLxITUpBCRCgyU=
Received: by mail-oa2-f18.google.com with SMTP id 586e51a60fabf-466ccde2ad8so2163468fac.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790623436; x=1791228236; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=90m4D/TpGSCtcBQnKW4O2iMu0JtOyx2FA0RhV3nyqiY=;
        b=RxZdfpfpIXH6oPDN7j635ASKna1oFp+tac2xYJCSmIbNmNVmzaQ2YSzSfucpM/541H
         d7+cULqKXrv1LLN2FfVTYMosd3UOs/qLUefknLFHHooqPpAqB5oAW7KvT9WoDE3gsXM2
         L1Op2O1wt5yjQpblOZ8J47yrKK1vUdRhUc6Kwfx6jXSvy33XXYAmlLq643IBE3WgATSZ
         7sGfl94WZV2++/ceGeDMQX9on2VGfj85g7Az0x/j4dg+3yAHdyjF3w5BoLzY6AslWhye
         kYBttt+Ig0G/ZtniZRHpliRD0NjnGKPlpQuReR2Uy6XEuUOAEyVe31d+Nb8ZWTlf10LR
         4QGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790623436; x=1791228236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=90m4D/TpGSCtcBQnKW4O2iMu0JtOyx2FA0RhV3nyqiY=;
        b=UA6MtmFfWhjZNIGp3QOzlPqWAPLtXaxPFogAyFyUcVdjR/P9MJBvw0ORJF01u3WBbs
         V/E0D33WDzOB6kONe29w3r8lVOM+kWqgGwDsoQ8HTa125fH1eFF5DlozJhVm9a0VyMy+
         R7WnkeRNrShyOCRqRmRumP/RgQQrlbzwpnau0uP5JrRzrIYzkQfRXg18JS5bOWlKhi/k
         433x5n7R0cJ6UyhvxIP4VBqsItkoIKkQHD+7z6Swi0wHnLK3mPZRHp+LKSDBJhDBKoy9
         6zFVxViZOJGX0aUB0Z7qQXVFTrT+sjQ8CUEUa9uJxvN6D2VR8gfFEvF8tZG3wgNFiNf4
         z80g==
X-Forwarded-Encrypted: i=1; AKwUvBwS5TwouxeJV3MlZ7jPGy1C+0GSvwUs0W6pdQehZ4wj68Q7lEGkV82B2CIbD25RQoimS0mznGfr2g==@kvack.org
X-Gm-Message-State: AFuF++nHKsWVuZ8vzAUiKkaWQRrb9ewgFBM9yOA8l5ZQFHGS0b3Plh4c
	M3wKZkxmKnnTJpUVBBFdlSqsg1t9zWn2sFQ/WW/EOqHStC2Tk+1zJ5Ef
X-Gm-Gg: AYBFou1J2Qe/u1aHucupMjaj/iHrGCyCeNC8HomlnVHkoFz++UbyZzT1YV2BcyyfkWM
	XMPkj1MF05cBDXckFkxbae4/jLP1lzSEY1QFzm+8SFniV78cPtIT/hLiuQiqhQA4NzweMqyAsFX
	YB6N6yF81dC7MJt9854VUcLVHO9+BFEm6h40n26jjI1sf26XldOVJdhGki+x0TiXzAMKYTpPDbm
	35rRwTkxSivHZTKyelhx3I/uEO/haS+IjfeW99J92v5AYWSIUek4f21zBuZ8ykk00EQ2/5Sfz90
	caRkpA73eTp1ijsb5h99FBFtwYnJHHPJOY1a0sgyky3PkzcxQPmvn6KP13nDxO8UVqAMD21Zo4L
	fZXeS6CsUW+f8/ZX+Y+LIfuWCIeVUpVyQxwKVvfZRG7Dx+AkXY75PicQahJz+U8VKamNBB8MmsN
	NbBrwQs4TlnaO7rjlDxnHxcaFp59IQh65sqFy/EecZoMsxkHEmSZgt3xFEPXI6UQvIWcTNKctDM
	yKanEKnU7LT6aJcAqgkklDGZfun8Q==
X-Received: by 2002:a05:6808:aaa:b0:4e6:1356:c72e with SMTP id 5614622812f47-4e61356ccc2mr4802789b6e.51.1790623436516;
        Mon, 28 Sep 2026 12:23:56 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:45::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4ebbd25cf71sm2396331b6e.16.2026.09.28.12.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 12:23:56 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v6 RESEND 5/5] mm/memcontrol: add stock to the memsw page counter
Date: Mon, 28 Sep 2026 12:23:48 -0700
Message-ID: <20260928192349.3432886-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928192349.3432886-1-joshua.hahnjy@gmail.com>
References: <20260928192349.3432886-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 89C0B1A0009
X-Stat-Signature: 9hd5p7kodxayqzb7oukrjw5ybrjybao1
X-Rspam-User: 
X-HE-Tag: 1790623437-62763
X-HE-Meta: U2FsdGVkX1/BUp3y04vTH+QjsMwKeHRlxAdPDNpTE5t8iQGqKKRXg5nb/uxDKo1sMgr3tBN/07odcPpCYI+ls6yBUjEqNw4ledTjqNwzrz6tCdp2s1tywSy1W8ENe9zLgXVv7uhRxHWnBRdNAG4Y6t5lIObmqTCyVG4s2Zr3JPc5XlELCJqqMtFExF1eVwuLgM0f9rba/Hs9Y5+zgCu4lK/lbPYGFufYE7XxRmcnGP4d2VCRJKNrlc+ah2OP+J3uYvqaFdrjFGL36ea663tRZH3BAHWLXFjuhilGIHCOQ8gT3xMAESV+yUwsnXpjvVcjfT5c/Dm7yoSnywGbBi4Ie59pwqKDdw8WUhTBBZRSp+Yp52t0ZUoebFLLdlPpk9EH15Ro0m7onu+SRYC2mFo8erpfbktcueHUi+YoAaZNnlvaoH3KP1uKWxj3YZIVv+KE9mfTWb9bu7BHzeKdSMnKB12e2dSah8om5froaYQGSw8/BX/nQNO8l6KVExphpwu/RJUvfILpdRj8X/7l/fe2yTMEqFBsz2pa+qXbglSXvgJrkgIySCGh6vivZPLsAbAblcEEB3HoYh1qDBYfMvX4LzuepfzUiTA5TzaWujm86bTREQKfHtlttYbaLwJSJC43AuPIcFYeohyFldaS5nyjTIXfCHhOCfee5Olq3kYDGntuEZAE3lOC7j/pF6gRVEi0sqXMRd83DhBjBMv/Zn0SrJDA4BwsU33jS3YgP9R5oIbbN1vvyK/BMRj7g8KSpzP5gjTKKD2uo9RqDbZ9ID6TSajbi9I34fo02Jr8f+WKNTorg04onlwYSbyF39uQbwVFV4+huGESMNQFYr//794ph7/aiHwNIVKKeIxYsu2FSVQVemxDlzxsdEV7U9wPwqphqqszX2C9rfPIKTUIGOf+BoeJnWZrN9yeG6eRWqCw2tgr+/mmT+bkF8tgYsCXLEBdMBKodEqtnp+qm81Ltk1
 zzjYdze6
 3YXoPd1f3wqSyrV0dzlz8ttOgl33nOHC/Ig5kYTOl9+BK2ir1pJXQcNepOiIPXYtFkLRXrAgouxBELdYAE4HrqIzTlQ31XcyA8TNOGA/H+UHAduHMrD3rA3BfCaUnhjYccilMNZ+ZLe5OKPB+vW4Fmen6oRp7+ZqD1dGsj/vWkf0WwkH3lUK/8NUJbVo52kyHHZ6ObgwwTbDULK8VnZlhVO5gnjAhe0tYftyO5KwKxi1Xb3jvEfxuBgMXx6IpwNggHn8/TL8YQhPE2689dCzGEHruYQW8KS5z4dtlDybeLgNOSutDjP0lCuCthL14dyywCCcRehJuynypk3+cUEw/2cV4LiST4nk7p7HMN88eGGhDtUIDuCuUk0HHTo3QIl4s0YH0urEvfsickanGgjSEpVHaA/fibL7vp12oDawuuHhvj6ZMqY1b7hY5cIjiYPnjD2spn2MLu2XdncuQtYoUZRuKcOPHF8BQ9pbBECifH25S5dcQiSzWW7bDEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Attach legacy memsw page counters to their own seven-slot per-CPU
stock. Charge, refill, drain, and hotplug handling now operate on the
memory and memsw banks independently.

Factor the common drain scheduling into schedule_stock_drain() now
that both stocks use it.

Keep the existing direct memsw rollback when the memory charge fails,
ensuring that failed allocations do not replenish the newly
attached memsw stock.

The separate banks can hit, contend, evict, and drain independently,
so their raw counters can temporarily drift by their cached amounts.
The previous patch preserves the user-visible cgroup-v1 invariant by
reporting memory.memsw.usage_in_bytes as the larger raw value.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 62 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e666572a7c7cb..6cae2d84f37c0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2070,6 +2070,13 @@ static DEFINE_PER_CPU_ALIGNED(struct page_counter_stock_pcp, memory_stock) = {
 	.base = &memory_stock,
 };
 
+#ifdef CONFIG_MEMCG_V1
+static DEFINE_PER_CPU_ALIGNED(struct page_counter_stock_pcp, memsw_stock) = {
+	.lock = INIT_LOCAL_TRYLOCK(lock),
+	.base = &memsw_stock,
+};
+#endif
+
 /*
  * NR_OBJ_STOCK is sized so the entire hot path of obj_stock_pcp
  * (lock, accounting metadata, nr_bytes[] and cached[]) fits within a
@@ -2174,12 +2181,30 @@ static bool schedule_drain_work(int cpu, struct work_struct *work)
 	return true;
 }
 
+static void schedule_stock_drain(struct page_counter_stock_pcp __percpu *stock,
+				 struct cgroup_subsys_state *root_css,
+				 int cpu, int curcpu)
+{
+	struct page_counter_stock_pcp *pcp_stock = per_cpu_ptr(stock, cpu);
+
+	if (test_bit(FLUSHING_CACHED_CHARGE, &pcp_stock->flags) ||
+	    !page_counter_stock_flush_required(pcp_stock, root_css) ||
+	    test_and_set_bit(FLUSHING_CACHED_CHARGE, &pcp_stock->flags))
+		return;
+
+	if (cpu == curcpu)
+		drain_local_stock(&pcp_stock->work);
+	else if (!schedule_drain_work(cpu, &pcp_stock->work))
+		clear_bit(FLUSHING_CACHED_CHARGE, &pcp_stock->flags);
+}
+
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
  */
 void drain_all_stock(struct mem_cgroup *root_memcg)
 {
+	struct cgroup_subsys_state *root_css = &root_memcg->css;
 	int cpu, curcpu;
 
 	/* If someone's already draining, avoid adding running more workers. */
@@ -2194,21 +2219,13 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 	migrate_disable();
 	curcpu = smp_processor_id();
 	for_each_online_cpu(cpu) {
-		struct page_counter_stock_pcp *memory_st =
-			per_cpu_ptr(&memory_stock, cpu);
 		struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
 
-		if (!test_bit(FLUSHING_CACHED_CHARGE, &memory_st->flags) &&
-		    page_counter_stock_flush_required(memory_st,
-						      &root_memcg->css) &&
-		    !test_and_set_bit(FLUSHING_CACHED_CHARGE,
-				      &memory_st->flags)) {
-			if (cpu == curcpu)
-				drain_local_stock(&memory_st->work);
-			else if (!schedule_drain_work(cpu, &memory_st->work))
-				clear_bit(FLUSHING_CACHED_CHARGE,
-					  &memory_st->flags);
-		}
+		schedule_stock_drain(&memory_stock, root_css, cpu, curcpu);
+#ifdef CONFIG_MEMCG_V1
+		if (do_memsw_account())
+			schedule_stock_drain(&memsw_stock, root_css, cpu, curcpu);
+#endif
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
 		    obj_stock_flush_required(obj_st, root_memcg) &&
@@ -2235,6 +2252,11 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	stock = per_cpu_ptr(&memory_stock, cpu);
 	page_counter_drain_stock_fully(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
+#ifdef CONFIG_MEMCG_V1
+	stock = per_cpu_ptr(&memsw_stock, cpu);
+	page_counter_drain_stock_fully(stock);
+	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
+#endif
 
 	/*
 	 * A drain work queued before the CPU went away is executed by an
@@ -2538,8 +2560,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 retry:
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter, false,
-				     NULL)) {
+	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter,
+				     may_batch, NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
 		goto reclaim;
@@ -3018,7 +3040,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 	if (!mem_cgroup_is_root(memcg)) {
 		page_counter_refill_stock(&memcg->memory, nr_pages);
 		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, nr_pages);
+			page_counter_refill_stock(&memcg->memsw, nr_pages);
 	}
 
 	css_put(&memcg->css);
@@ -4170,6 +4192,10 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		memcg->memory.stock_css = &memcg->css;
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
+		if (!memcg_on_dfl) {
+			memcg->memsw.stock = &memsw_stock;
+			memcg->memsw.stock_css = &memcg->css;
+		}
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 		memcg->memory.track_failcnt = !memcg_on_dfl;
 		memcg->memsw.track_failcnt = !memcg_on_dfl;
@@ -5798,6 +5824,10 @@ int __init mem_cgroup_init(void)
 	for_each_possible_cpu(cpu) {
 		INIT_WORK(&per_cpu_ptr(&memory_stock, cpu)->work,
 			  drain_local_stock);
+#ifdef CONFIG_MEMCG_V1
+		INIT_WORK(&per_cpu_ptr(&memsw_stock, cpu)->work,
+			  drain_local_stock);
+#endif
 		INIT_WORK(&per_cpu_ptr(&obj_stock, cpu)->work,
 			  drain_local_obj_stock);
 	}
-- 
2.53.0-Meta


