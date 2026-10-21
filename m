Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 252EE606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 22:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=kkbXIFTv
Received: by kanga.kvack.org (Postfix)
	id 26C5B6B07DE; Wed, 21 Oct 2026 18:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21D486B07E0; Wed, 21 Oct 2026 18:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10B556B07E1; Wed, 21 Oct 2026 18:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA26A6B07DE
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:55:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43969140680
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:55:25 +0000 (UTC)
X-FDA: 85348141410.04.1CC9091
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7FAF98000A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:55:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kkbXIFTv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792623323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WwOVRaeIHz9zAbT7euRoVVtSbXMHrTnxV5h5/F0jgC4=;
	b=l2wOeAwo3npICtDBd2ZUhTaHYv/WZZSgjr+6fIrh4wy9tcZIRhOWHZmoFhmwEWDPxTDuKA
	UiKNH8kPXU4IYO5eC8T1fCMyRbv1HejAwwbyGbMPTdysNa36r98JWFdTwpEz0tF0U3esoU
	aKB+kiSMlkVFVqHfX/ktoHriX0qwN28=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kkbXIFTv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792623323;
	b=P2fVwKpL/GNybWxQJjsnE5qNYcOJ0Zt07o6B5CcF2qjD6SLo/MOubTToAVyx6YKSI/ioIf
	FmYpslGr2fpfHHV93L3Gn72ajGkvznnSDIMRetvmZ+mqjovPywzV3z4JqqgHZAab6J71oQ
	+d+mHB5ph/ep+ouGXMRaED3n+Qo0F3o=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-6768403e9bbso1321662d50.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792623323; x=1793228123; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WwOVRaeIHz9zAbT7euRoVVtSbXMHrTnxV5h5/F0jgC4=;
        b=kkbXIFTvWNUXKxBM301D9rgXqSoHVtI/3l6UO4JPrig8UdRzpQHeXIa/8RnbfIQ0pE
         DVZSuh5J/kaBlXXKr3TF3jD6box2JJAjoSgjOVwV7XRWbJa6N9O8JSZcp8THxn9u43/m
         vkbsGK0uhSQLfK2BP0fBKHY9ey9mLrEQR7vN2UPN2tLZBK+vRRLroKjuPoFhG6OCZBc1
         BiU0cPeeZRI1psZk7+nwxsuKHw8SFJ0x+PNqjHqlVir8YjnaLaiv8tiQy6T5NjTmVzDP
         1/CWj3K24lhOKs63brhzk5RqmKBbFlYjU0awKHlA26OZNUsD0iwoHt2CGQsvlzd4iXrS
         +SHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792623323; x=1793228123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WwOVRaeIHz9zAbT7euRoVVtSbXMHrTnxV5h5/F0jgC4=;
        b=omHnecmUNLU02m0oPtgTyV6cfvpUWvREzeV7JW4UxYVh8xtHYGxhlS4oGJDzJr84rO
         oAQnYCTzEvUrGZ9mbWTVile9STcrCFyfr83M2Lll6cBuUFGKJ/c53Zbvfg8u+7OPEcxt
         q2B7ufzviVTGahsRv9trtgPnxaYjiRf8vXMLiay5CC9+ZEv11UmZqFl7UiBRaxEM1Hku
         kahxZ/nJaedX0nke18N2RGN2/2aopL6hYEzHMcAz1s1xY+DulT23AddPCdJFG7CzuasT
         5SUGo1ZVKH2HSxSs9x9XQz242lv3DS3FliVXHct8INan1wZc/bIpF3MPw73gqT3EfRNd
         kyaA==
X-Forwarded-Encrypted: i=1; AKwUvBwBFSB+8W/62dUcweI2Qw7bSEr0XpQz3CvdUf7xFx+Hwlei9VCvOyYZ741fnU3eZg3zG8fcO3+nZQ==@kvack.org
X-Gm-Message-State: AFq9FYJcdGsnf7LoceBM+/siGhFnPuEVxY4+/h4jZx3Hu7h/l84NNije
	M55g/4aFfKIkP4y87LN9SHkAolyix26a6nS06ZSGFzJZu2hdUrO5HFor
X-Gm-Gg: AYBFou2TCY/n4BXuGwHiF8HphjXKUEkUo0wtod/YROZjy0ih1F1QFx0hW0Uhmd4nF7W
	CrFf2VNEYiivVaM8RmuyBbQJxpxYkHI6sKtGFnXXap9w8GGnQYpjoHPgmiWaCNkEvNEUnqtqkFP
	+0cjNuqx2Aw/V7JoYtsWGcGfQOGpnoh+gW/gLTP7Y6x5fG9Eue8qKWCOxfDAafARGMza8gIHmad
	0xNsQ5QoaLje6r1reHHW39ih8+/gReu+bS4bkuxVhX46uCW7Zupa5wHP5G8CKz8wYuuF4HjM4Sq
	N7jjpSqkToBwhTYwytCxCbWYoHJSaxU9b7s1lq490prNDJZyhZWlsZuAnYEKh+Hyhd+6WhdVnF/
	Fsh2YYgQKM6/wpvR3aHdH5S1+EfdZNw92c/Hnxp3rx/cElQ5TnT2AoB2h4YDKQLBmiXVMyMeU2K
	jEB9mkYd8PwG5IgeTgxw405eYgs6QpF5npYQS6oJcSVdYVWIPOugcqiYgxxaOSfvLPegvyjZzPE
	SOuxoOBybfO6UE5gF2pkvvcWuJRHHimn5VYRnfhzsUEXNBUpq+l7JbOYyS4Txf66kt1wgHn0dlH
	rQtrl+N85g==
X-Received: by 2002:a05:690e:4381:b0:679:c12b:ec09 with SMTP id 956f58d0204a3-67a0e4acf74mr1765499d50.51.1792623322691;
        Wed, 21 Oct 2026 15:55:22 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:b::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a0e539f46sm1754377d50.17.2026.10.21.15.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 15:55:22 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>
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
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v7 5/5] mm/memcontrol: add stock to the memsw page counter
Date: Wed, 21 Oct 2026 15:55:14 -0700
Message-ID: <20261021225516.1620680-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
References: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7FAF98000A
X-Stat-Signature: tm888txoac5eng7dcuj57kkhpuguyiog
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792623323-313767
X-HE-Meta: U2FsdGVkX1/jwdvPhBh53WNKQizbv/p9bKOU1FxNCkAmEhs89L+Qw+exOP5A8AepDHlsXORGtoGolZNJ8VhiuRP3WAyi+JNFjzsuPDa0mR9smgudFcDnjBoYCKryrrB+gEz6lrlEobZfDOhjh8QrSmxBS3r6+nc80SPU3Frq3PTVz/4xk3P4ki1unpOhBlBHHQ4a3yCyWGg13hi3DhM8kYFFu+h1rJZ5G45+qOkW00lIBcu3UTPndZswgmnlz5/fnzqgmzuAjCn/SOnA9XC9DHmW+aygI32Lugo9FJwiMkJxjErM1AyKnehlqutVXIGQwtlnoF2/ihIViaxy2OURCOzOw5bqroFdCz6M5RZSXBFRrKQpTEZ8Ca5ABHodTFUEYxHpMOZey9vvzEKdYoUNzYhL73XntpI8IrtCl1ED3WUgtKg9QUMRkyCar4TZI9QyJne3oNCJzm9oGPD2CK/BWwXKXnAkTVybDSpKyVA7D/SpLyoLKGzjrILeuq3Gol5lj+GqS7bF9gV0GDH8sDiE7lMYvidy4johvo9aWFvi1j3OwV1FXcVSo5GBBY08YUY1kvgEPvl26SgKK0CHQPynOKS80b/0/AOJd51GtlZl7PFhRLfqMSyGCm57qoZp1qRvZWHeHGsCXNsetwf2HkfXbeXFrqNqYEx77Od0gqUnS4atlVIq76DgqU+KreNRYBMNjZUe2WNkW/soCFoqaogSMEPplUlX/T4cBRS0pJgOnfjSGeSgBtnUw5dz33LJheZDnkH5Y+4ODHBt6V9PdE/Xyiv7PjqYE6Z4feG8KV6RuQ+gU3gwzUd4IPhAzHa73xZQB8465dsUBD7bEH8vnCsS38e76/HOHrK/owj3+pQUe1gWNXfpjtrwcDuWRCD8vkMSM9TO+qs15uB0VGovEQGAycrj1o9FWafucXHynVYZM3c2KybgTkSIjpJDkdRBcMJGQiRjyQUGE1IWMso6thG
 inXlz2ZI
 FqcRSwnt+TmWEKw4FEgdaMGyxCGrZ8eU8T8Eop0oN8PRG39634vcBKkTL8LrfzgBawKWrHaQNKqalpCgGZY69PZIl7voGwvItiWusB35HZJqW+ijWcsCizJUpBboL6Yge5ykyygruLKrYkeX/87cdJwEeWHzjEZlbZhQaEEqjh1ndofv/OXjFronMQ2NH68IJZzHi2bMk6x69IAl+XZ4kAQfSFaTOdCaKVwpX44QG3GjepjzYSx64ISWwAw8wWSiMkOMpE0FBnRIgjdlsxu/7HS8eTub2LbwSi3SqKn8jxmb0ieCh8nSFXEZpsL6TNIBBYsd7t0Gzo027rGZyfAdV7zNOF/7tYP9es33ZcNSY4PjkbUi+PAhSQFbLHrrsxUqXOpM/4FG+sIiI+5zAKI3bKBgtvUrRXJJw/1v+pKqDzcrR+VSLkjJM9pPzl8Q7jqckOIMnALuWTki66D8SjGe7v1ADAAiJWR7pT/lc280oL02kY/E3oLmV08ImTQ==
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
 mm/memcontrol.c | 62 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ee1e46e58e38f..aa3531a3828e5 100644
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
@@ -2557,8 +2579,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 retry:
 	if (do_memsw_account() &&
-	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter, false,
-				     NULL)) {
+	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter,
+				     may_batch, NULL)) {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		goto reclaim;
 	}
@@ -3038,7 +3060,7 @@ static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 	if (!mem_cgroup_is_root(memcg)) {
 		page_counter_refill_stock(&memcg->memory, nr_pages);
 		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, nr_pages);
+			page_counter_refill_stock(&memcg->memsw, nr_pages);
 	}
 
 	css_put(&memcg->css);
@@ -4190,6 +4212,10 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
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
@@ -5818,6 +5844,10 @@ int __init mem_cgroup_init(void)
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


