Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C57606A329
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 22:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xw/MrIuq
Received: by kanga.kvack.org (Postfix)
	id 85BFE6B05B7; Fri, 13 Nov 2026 17:05:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8315C6B05B8; Fri, 13 Nov 2026 17:05:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FC0D6B05B9; Fri, 13 Nov 2026 17:05:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2CA6B05B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:05:57 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8BE251A0121
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:05:56 +0000 (UTC)
X-FDA: 85431479112.02.7630A03
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id B1DC64000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:05:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="xw/MrIuq";
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794607554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oEux1Xz/zxYQ6Q/H2BR+VtuwQ39FefpqIgFmhfTyHbg=;
	b=BmsYbb6g50JXwnTtNHIpYwGDVy2q/UxD6KQ2Y3MteqTCDEVbky19Ctsv7X0FJ8NTKVqdoJ
	0M7OadQhjSnh7mC88p2nCk2o/OpIZSckvrq/jT0dPrfS+crUauX+s+X5BC92RMsa1Utihe
	NZyMsHAHx07GdPZPPC4r9kGdLs3VVYg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794607554;
	b=H6VzLJQ5wdvmCuF/EVJeRhkQtXshphPtz998mBcid/Pvxb7PYAVbf/SVTGLe/obMbU2G7Z
	j1uNDNn2MHqABcIS4kz/V8LM9dYemH4KE+xoPYzkWkyArqTckN3cZbJcLHL4sovxnptlrS
	nP/jZoxgQuMbOyJrCMnYFV46tg4OUps=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="xw/MrIuq";
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8b4bc5b8de5so1124597b3.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794607554; x=1795212354; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oEux1Xz/zxYQ6Q/H2BR+VtuwQ39FefpqIgFmhfTyHbg=;
        b=xw/MrIuqSXWB+IrRH2GgFCjO6H5K9oK4QtIqBzeqcjgsorE0iQL2KvZJyb/IXaMfgg
         GnRhPYQM6V6B/Qq3qIgG07oMraBjq8BsLr0p3tDCk0LKUIWQmRt6py/OokeZkNiXSQvo
         3grqMbqK2Jg3sMGWR0rZoCDQsRkIIZPiC+2wP6QQ9Md4kgdD0CgzrizSHFjN+qEQfTId
         6BszzxbGdE7YC/7t+egaZ9GYEgMJngCnT3PSbW0fwkPAhGHARzpdi6XN3wrMsnI55VCO
         tKITjE6MxAgChBHcKWZPQYwxPlQ1BbXYTelKhJP5YZirYZMP2+vMRYlZifC27pfJX1fh
         ADYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794607554; x=1795212354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oEux1Xz/zxYQ6Q/H2BR+VtuwQ39FefpqIgFmhfTyHbg=;
        b=rVEPMkgVQbvR+lvHQgHCYHytl08jHpoZfdXfgv0xXxlXLIGz13AW5KJ9NnulI6FXNz
         ppK5ofWrYuj24FChWlm3Nk5rnf5fjhSBuW6cre+nH9GbmB8XwvvDEVKk0D1EMg9vU+o9
         50BOsFxe4ut3KxZCQ+lwke2SLPm1XzDf187qSfHH4ujNwWPKg3edifyG1FOmXdhE2X8N
         wdunwpcwpk4qdXzRRiCesnYc9j9VfpwdpEA/QpObFUEvIb7fj8Q3y4AwJ4HUYk9GMKUR
         uwU+68UXVBBeScUFRKxC1KBtHnexfU+cW/E3U5AU/zaJ3AlmuGrdi1tyLZzFdAilSijM
         I9yw==
X-Forwarded-Encrypted: i=1; AL+hErEbX34hOXdNWyvTPxGLEFk1NGFNKKvWt5qOKFeLB8G7eCFPMUbC+xPJnCx/8PUDEDZdJyCFqYdlMw==@kvack.org
X-Gm-Message-State: APuU4Z9IIjb4LegOUJTfqKHOtaRg+8zxvigAEbPjJTJswW6LtsdYJQ3a
	jjehTC3VQgWNy7OKpu+3EtX1D3oWmv46mZnABkB0d5HQP0j8oeabXGFE
X-Gm-Gg: AYBFou3oSxIGPAWYXGRZJ30njhNgwSen3dX8URau4l7R1ettrf+cFSMLJLR9qoc4HIR
	DHuSd/DcR2H7jYOY8Gb9bNpNaapXrY8e2rRsy4Vv7Ix88FNjSV9+j3VFkTYM3iMBgXYH8Deitrs
	HBIVOO5/GsS0B/MIXqvSo/W4K/Slu+6ANIQzMl4x9bT9ppItu3TAXsefHGRlSLEQV0ov9M+kb6B
	lEve+vWB6SRkR3hGssUKqULekQUbuHCfXtmUrtO8Ef0ZObOWxNM9wildV/A+K4aBPbQTb8pczKG
	bCo6eKxBM/VFgoUNc5qOGTw1qlkpu2APAcyPMlNGEjBowb4hVDUG3SRH0Wpy4W8Vk0CBu/VuF53
	xtNXZZ9uxaS6s5OuODgTlXiQGdEKcYg527dGqrdXuDxBj8fvTaJNt5FcCC2F052nFuHw17DQH9s
	fG2fjP3t1EqE08dEUab8qRbPgaxgsy7DUh7sOaDozWrcXDKjZsLNzq+DZyvrHDC3nieHSiuP/g+
	63DcXSfgTvevbqUqk0a+aCXj2rzplxGKgPTbOBwZPxjDBnTMX1Wwz8kEsOS9S7PCVum1pqy2Ngi
	SWWMsUii+qpRxkvKOJCyBagzHEPS4II+YJd9thMQ58iNYJQ19J5XMN3t22qe
X-Received: by 2002:a05:690c:498f:b0:895:8474:3c6f with SMTP id 00721157ae682-8b4a9f74dcdmr27872247b3.0.1794607553668;
        Fri, 13 Nov 2026 14:05:53 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:45::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa7ee70csm31029047b3.6.2026.11.13.14.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 14:05:52 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Koutny <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Balbir Singh <balbirs@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v9 6/7] mm/memcontrol: add stock to the memsw page counter
Date: Fri, 13 Nov 2026 14:05:33 -0800
Message-ID: <20261113220539.2275715-7-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
References: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 3iwab87dzxpgk33yswfxdb5tsrm4ewsk
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B1DC64000A
X-Rspam-User: 
X-HE-Tag: 1794607554-586711
X-HE-Meta: U2FsdGVkX1/IuMJ8JVvwNqIffVbDhzcusxdyOcQVi0EyKJdIHYttpEK5VrwMdP2uU934iXiq20IUv0q8Y/uQbAzuAAc47eWUWz0KEK362W7s/pbKmEcRZrOezZKSiGeC5gEUeVY4B9pgX6u1RJhgJ+4R0K+f2S+CSLTMHM58tpe1qRBmP49toUeslGIUEOPBCbhOOR4F9O1M68GwpNNbgQuLO2VewOpZmt2avDMsnzGeYAe8Pu3tVnEn2JKophecj0Jr9ncSqHCbhwTLCP6uOTeq+Rd0oYYsLzcp2+m/qDY3LQ4oi96gOIiLVKLC2L2c0JGq6GigejU828dT/J8d7VhTA4ifCXOMu2tt/Fr8j/57raauKsTa8DCyGGiirc68wo8H7PMRFrfuqp9NfTS2uxR2ksSWFV/k0njxapS6SQuIxLu9gKD4jt/m1SCPKbMrSX8NwqnSrusPn/6NQjPqzcxERrTMa06m2GF2uVdwfmBG7zBkORzoPj0woKxGTytZJYMslFT9vOaH95wzGneUb0whzGdSxmNUhiBWs6aDB5O3csJPZ6XjKmGOPUt/wLGbHUTj2U9mscOyp9U0QEGzkFuLNG0ziwojfXGWD7Sr2qKO+MVCMqAlEALHI9GjHk6C1Eq66APv3GJ2DgERosfkpPtSJFdySDSk++oMKN+wRWSWqgt6+jfIqXIs92BJJtA7sHsUsmgJQnMN2XWjrxoAovVCO680+OAC9Utgzc0FtncOxdxECZUmRbPKrX8OX4t8zmxJbVeBNFEWbdnw/eNs4NXwo6wDUY4KZcunrd70d/HNKK5sw3p2wzjKwViDKufS5VqtRHyub9ZfBuwBu4kBGBHIOZEOLY7MuxURRX0Or2hBTMrUS5v4Cyi6/J3oDqNm/x8K3RZnw+3Kczkwcgqbo3bwy9OTGkxlTW2ateQzBG5TLpVbiDv+92F7EbLU66z8u0HIJTNVxiYpLn6z4Ga
 x6PhywOt
 CbezGCok6tbMK/WboouiU8z41fmcgEPyz02plnyukP27e7BtGw3dS1sFnKGUXaf0/WXkJ6zNw9LgfqdAeD43GEVEBUgCKTOTOh/REW6R+o9U0oLLrSSMj8q5sqJ37zbV27FJVy1XWKdBO//sOQ70Ub5LTJtgd7TBly1FZBPgrf4mfFMuA0MrRO0QhKE8yvA0Dxgv9gt5Ps0oQKAd/SLVHAHdO1pw5qJDzEoT2p13DmKVU+SJAKtikAmPoLK+hW2xSsd0r1HPqggfZf/gltN0mwkNeIl07vkz5KTMDINA3OUTKFvYZjzfGIF8Oyb0a2wSj8VDLW76j5++sKBZdzkgGx6fFNM90HZ332XNtMKlfAR4VEE0050WuaynhTtcxT+mO40x1qjraTSK+1Dcr8EHfUqKWoOzKqDEFHKceFvkIOAoX3F1uwfAAi5OANRWSCnPBhv+I7xncSbsQ6WmhX1OR9TI4wti8F7v97zF2hFy1JMQN5DewL4sIjMpp8nOfCgb7zATC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Attach legacy memsw page counters to their own seven-slot per-CPU
stock. Charge, refill, drain, and hotplug handling now operate on the
memory and memsw banks independently.

Factor the common drain scheduling into schedule_stock_drain() now
that both stocks use it.

If the memory charge fails, roll back only nr_pages from memsw. Any
batch surplus the memsw charge already placed in the memsw stock
stays cached, like any other stock slot.

The separate banks can hit, contend, evict, and drain independently,
so their raw counters can temporarily drift by their cached amounts.
The previous patch preserves the user-visible cgroup-v1
memory <= memory + swap invariant by reporting memory.usage_in_bytes
as the smaller raw value.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 64 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 48 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0f5481b276fa1..cb1f46b457ae8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2061,6 +2061,13 @@ static DEFINE_PER_CPU_ALIGNED(struct page_counter_stock_pcp, memory_stock) = {
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
@@ -2165,12 +2172,30 @@ static bool schedule_drain_work(int cpu, struct work_struct *work)
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
@@ -2185,21 +2210,13 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
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
@@ -2225,6 +2242,9 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	/* no need for the local lock */
 	drain_obj_stock(obj_st);
 	page_counter_drain_stock_fully(memory_st);
+#ifdef CONFIG_MEMCG_V1
+	page_counter_drain_stock_fully(per_cpu_ptr(&memsw_stock, cpu));
+#endif
 
 	/*
 	 * A drain work queued before the CPU went away is executed by an
@@ -2233,6 +2253,10 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	 * the CPU comes back online.
 	 */
 	clear_bit(FLUSHING_CACHED_CHARGE, &memory_st->flags);
+#ifdef CONFIG_MEMCG_V1
+	clear_bit(FLUSHING_CACHED_CHARGE,
+		  &per_cpu_ptr(&memsw_stock, cpu)->flags);
+#endif
 	clear_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags);
 
 	return 0;
@@ -2618,8 +2642,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 retry:
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter, false,
-				     NULL)) {
+	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter,
+				     may_batch, NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		goto reclaim;
 	}
@@ -3050,7 +3074,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 	if (!mem_cgroup_is_root(memcg)) {
 		page_counter_refill_stock(&memcg->memory, nr_pages);
 		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, nr_pages);
+			page_counter_refill_stock(&memcg->memsw, nr_pages);
 	}
 
 	css_put(&memcg->css);
@@ -4204,6 +4228,10 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
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
@@ -5829,6 +5857,10 @@ int __init mem_cgroup_init(void)
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
2.53.1-Meta


