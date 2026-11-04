Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA3C6606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 23:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XUVEOQLa
Received: by kanga.kvack.org (Postfix)
	id 967EA6B05B6; Wed,  4 Nov 2026 18:30:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91F066B05B7; Wed,  4 Nov 2026 18:30:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807056B05B8; Wed,  4 Nov 2026 18:30:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9726B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:30:41 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B79D4407E8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:30:40 +0000 (UTC)
X-FDA: 85399033440.23.64C1D99
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id F0F4F1C0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:30:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XUVEOQLa;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793835038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hn/N6JyJM+zFqKp8YocwwBTkzd8kLSS3qrHaopPl4Mo=;
	b=h+lBR60CwVSEvlYFWML9Bhqv7YhtPx5YYqMfJ93X/XZ8/UmH95I5Mt8DS16MTtPIQR+EI7
	W/VjeW7hEAwMD1hoHBXn6//PNt5IeV1UxK5xeZhni1dqWuG5S8NtTT9G1zyucmxgpwwu8g
	zTW+JFjsBX5koi0bVaBmv2fU5ZNlY8A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793835038;
	b=HMe2vW2H122hYFcRJ/Wv2wRCG5GRrB/jXqw3DqekviiPuo+uc2mR0keZz9FUyG8eKdZaAs
	fo6gyBSATphQ+JQ1ZpIPTq3vCQ539ftRbhPu7bkXgdajRF+W0Ct8XjnbQ7VQvjeUkFaePp
	2pt64BltQnsrmj5XvyCwOYyJUEfC1TQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XUVEOQLa;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8b312be5de8so14770087b3.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 15:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793835038; x=1794439838; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hn/N6JyJM+zFqKp8YocwwBTkzd8kLSS3qrHaopPl4Mo=;
        b=XUVEOQLasTi5D3+Zk2WDY3XmKNS8SMy70F1LDOC8a2lxVw0ggSiDwzg0JeDOZIBLuO
         fCl6JXrt/U6lQ8lba5ZXr/2FYzgsKOKCl0LCiBea+2K+xOnM6B/F5UGAqkBnMXLX69dy
         F+9yIn/E0kQVpTSO3IAgpO3y6r+Utfggv62XYaWFsc4dfbx4QjoLSz1hsPzmG1jZlbIt
         GPcTVYWE54u2Npt0DIaQzegc9q0hsebEbFK3HDIXY4gJyuzEmswuHOA1rOGk8CYrM6hD
         KDnEaWVstLVnPP39+gWCplCYZi9Mq6IyknwsHAKHWl/zBe7996CnhTGMj+NcvwfA76OC
         HQOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793835038; x=1794439838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hn/N6JyJM+zFqKp8YocwwBTkzd8kLSS3qrHaopPl4Mo=;
        b=wiFknblFiOHizIV7pU/ML7U2OziGYko1wanU8tsX3cbcPkVvx+vwbKla/a6XlLrYjr
         beyheUgWvcjxwJhgwt8IbuSdw334wafPcc89//YLIBGPQD+iVNPYsGNEwAi4S9Liexzc
         9hAxnl4T9/Z2tKu0K4Bb30+VDzXl7P+u2Zmn69c5mi9BRndkv9O3KqMplJMIgFdB897M
         uiRS3FK0NJSvzJs/lkDmlZg5pRBFviWF+1Lmrg8niaO6oqARBA33PaAWJuMjLID3VBeS
         dmjJCWrRSx6a84lC2aGmT3LbwCUbasjVRX8cxeSqoflU85KgKRb+TUttB5e5a35Kf3iK
         r3Bg==
X-Forwarded-Encrypted: i=1; AKwUvBwuBbwSuiargIdB85yqBXFtnSniAU474kETkAS6baGbrLwSVkjsz1aTco/uO0rPyt6NPdoNiLEljg==@kvack.org
X-Gm-Message-State: APuU4Z+khFKYU3FVZ5RzbbBjasB5MMUMONlvMJUQe0Qz/9gNr+b5fxxR
	MSqYNrRUQ67nEeOt2+8zAxasUBpV3uicvGiagmbPwcGT3F8jKiytqmY3
X-Gm-Gg: AYBFou2rJ3UvVbJGGYLXTYhopoRZTr+W1YDpYo3HKuphQ+b8hQpZccz/k6gkCvd00fi
	E4UD1UyTTDDvlsQVTvOBjj86+fDRP6LaNkuE5pzibgBZWj7BPP3c7oibb+73rSoJ288BHzcuCGJ
	j0l7AQ+rKwoZkGUvqjwykZeFXBKjuyQmTDVXeb/XDGzHuD+5WqwCMkRLVDpTaSfYcIQbFj6Hc2d
	7w+9OMFbBpGwjOXTcxdGS4UGAtyOCguPZgG0++410hm51Y63L/01buhUqCJJSDiIFM7078/LIRR
	yszVhD1uCruGTIuY+JUphZITR+peuI1/KqbmjlXl4gtrOXOdIHhcj3/blIS/5T3e7BxKFaTgIvv
	P89tab/DpaKh4YBWVkZMHh0oW6imZt71Hbt/vgdJCPRY0y5UsnNUiDQuD5MubA86mYv+QW+BwCu
	KgeQjzSb7DWWILwV86z2HdAziVbpXXkuB9jwl0p5AY9kuFscvlungnXEJXamQAfF20kQ2IWDwVG
	RNJkzVv/l2ttSEF//WTcOvpWZDD83Ea+QmZjF6fK94mKRPSEXmP4aoHCDq5SqROGNZjXv38Ftlx
	bzYG7JcHVy5+KzgN085T3Cdh5xDlhdAsrvD4kBN2LbL/xZJZF5YVPeFy10gV
X-Received: by 2002:a05:690c:ee:b0:8b0:a957:80d4 with SMTP id 00721157ae682-8b2b66eccf9mr87622347b3.20.1793835038019;
        Wed, 04 Nov 2026 15:30:38 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:72::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b309bd35c7sm29090667b3.44.2026.11.04.15.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:30:37 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
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
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v8 6/7] mm/memcontrol: add stock to the memsw page counter
Date: Wed,  4 Nov 2026 15:30:27 -0800
Message-ID: <20261104233029.3282438-7-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
References: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 7rm3kf3th8z1i51sj5myjtaq4xyhjxda
X-Rspamd-Queue-Id: F0F4F1C0006
X-Rspam-User: 
X-HE-Tag: 1793835038-146388
X-HE-Meta: U2FsdGVkX1+4yAOMUsp4Tfr4ehbaI3AGwXtggD0egRuL0hZfGrCM/aMlVBXRo1cIMWH18SyijVgSx8xzMRHOq543RtvR/ldOS7GAPgOd8oNPbQQ6YBoeXN4KfoAmXA3aySJdMRTJWZlQfJNueM86GyFBR7vOPjxSczaa1q67m30bu0tljn7UFoIoOlSAdyeZL0L/PNCF+uCrUkpbcTp4/b4No7Lk/3fuhDXSBj16SLOuE3X91o83HNhBKGjFT6XSKDQJMewtNngH1XWLt5BUm7cRdkYuNVeuLZmzHZs2Jl9isITENhtUilRs61JC5veIikVTKZorkGuV7Rpe20o5yIqx/a0Y8DyexkCLR9GOtmkgm1Gg6k012OSjABeVKDK25w0rJvke1p/1rj9LTAKJdhsc9dCEYX0NSqLGDB2ITyEPwfltITdpzddGUME7pmpOPBs93S1hip6vC+p50Bx88kGRuBHNRWHPfG/C7CNejILrznq86ANCG53mhgLtBBRQVfLrl7LibobqijGMdzHCAKpL2Aq6HBaIDx0Z+11U+UvHxxABcm8vjGD0oygj9jLMTXT74I1Tn6LHd7Kvtd1ewrpTqV8wG+T/0u9kVRcvfQlnOfz+sWkFWqQH8d98Kp5UJIkkz4XJxyfuvyA1RmB4fmsyMP5e8Inx63wqqW+PChCJccBKnIGMVqWSDL0Guc7o/TRVWLZJaaRXVo6F960qY5fA5eDUP+JURpFqgeVi/mfZsMwiA3vKmMG+wEAqlYdsVHcT/8NhD5Vccwsy5Rx3MY/DXyIM8tWUZDsDja/f19Xughex6apoFoTbYmRTTrB+yOikKUZWydUBsi+4F/yZKCBEn3HGtItXsjvLyC5iNmbu8OioN9U3SFylLoW+ILLgpwDcWuxLvNHGuYrvWc7swVBYCl5j8Sc0CPGtO4HWpPGubadeCDNPUZFv5h666yIG8PpdgReoAgnaNTKjRgk
 TJfS0/wF
 6sH2yayHiWau4ELyRrNWwHMsaFFms7h8rhCiiFCuB7yXjLl/rm8wWiP4Z2c8yCsehxj042AI+f4Vu0BFWZAlGID5NyM7Q+ypERSX0C46rmrhWSFxlA50AHiCn2SEH+rgpRZrs2kmzbF4HLlxk97Pb2T+SVwZ3g+389KpXRcOsIrpw1PtkTSIXa3zGBCiiT7o6twfCy8VxGcOV37Qox6BxczkVhNgdecKH30OWg26FeurcnD95/7QcGvLCpg47dAyEjgbmIvziiYOZLGg2mmxEE86D1cRHNHiCT0C/bVW0caNQ0YUs0nrr9FjXS3YpUfB2PQDdMUjDqpt0RtaIyhpZMjKVQbIjKQCJ3K4LAQkDNCeI6nG37v/3KfAGgrC0Av1UYLnufMyhRxu9L6Qm4mXKE+DWHMZzdnV0zQZL4yVNG/UXaWbudQVFoTcMhavNX+hstYd85O97qwW8K8JXfR3QDPbQzx17d+c91LF0Zh1sezuRkgN8qyxnzBGGOU9sxytvSs63
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
index d03d64969548d..aac987ebaab6f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2057,6 +2057,13 @@ static DEFINE_PER_CPU_ALIGNED(struct page_counter_stock_pcp, memory_stock) = {
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
@@ -2161,12 +2168,30 @@ static bool schedule_drain_work(int cpu, struct work_struct *work)
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
@@ -2181,21 +2206,13 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
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
@@ -2221,6 +2238,9 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	/* no need for the local lock */
 	drain_obj_stock(obj_st);
 	page_counter_drain_stock_fully(memory_st);
+#ifdef CONFIG_MEMCG_V1
+	page_counter_drain_stock_fully(per_cpu_ptr(&memsw_stock, cpu));
+#endif
 
 	/*
 	 * A drain work queued before the CPU went away is executed by an
@@ -2229,6 +2249,10 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	 * the CPU comes back online.
 	 */
 	clear_bit(FLUSHING_CACHED_CHARGE, &memory_st->flags);
+#ifdef CONFIG_MEMCG_V1
+	clear_bit(FLUSHING_CACHED_CHARGE,
+		  &per_cpu_ptr(&memsw_stock, cpu)->flags);
+#endif
 	clear_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags);
 
 	return 0;
@@ -2614,8 +2638,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 retry:
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter, false,
-				     NULL)) {
+	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter,
+				     may_batch, NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		goto reclaim;
 	}
@@ -3046,7 +3070,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 	if (!mem_cgroup_is_root(memcg)) {
 		page_counter_refill_stock(&memcg->memory, nr_pages);
 		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, nr_pages);
+			page_counter_refill_stock(&memcg->memsw, nr_pages);
 	}
 
 	css_put(&memcg->css);
@@ -4198,6 +4222,10 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
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
@@ -5823,6 +5851,10 @@ int __init mem_cgroup_init(void)
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


