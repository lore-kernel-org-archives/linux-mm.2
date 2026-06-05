Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F449CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 804C36B0099; Fri,  5 Jun 2026 11:36:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DD146B009B; Fri,  5 Jun 2026 11:36:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2D66B009D; Fri,  5 Jun 2026 11:36:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0A76B0099
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:36:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 203561201CE
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:36:15 +0000 (UTC)
X-FDA: 84846260310.18.1879380
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 41A12140017
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:36:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lOlRGhkJ;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780673773;
	b=EF/s4rJzTh5baWQOZbt7hSzuaWkCQ7DDQqZWb6sdVWflqgQ1K2EKb1v53So5Uuh/7Bc7+S
	ZN6PV4cqkyaY5q+uYCV8437U8onPMJsZahi5hIFjBPzsAU0RCnCs21g5rBPMRkM9en9TEh
	A4ZldT3hCUVx07acWYiLI7YHU9wiXts=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lOlRGhkJ;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780673773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cDYBxVf6/SnI4wuLSeXSHzzLh62y/xO5UdAB8iPGGOc=;
	b=SCOJmZ4uzvhLyMhjRHOqf/uRXPh/QrSYH9Gkc3yksZSK28ZaO+KI1MWNc3uW4Z1lNp6l3f
	TJaCsHjVUodUl2D47Wb+EdZ9VlFduusjqOQ7cEX0vPYU1uqKk5j/SWpVg/LY3Ni/abi5Ka
	H8e1xU1ALPe15JBSkeDrS21szwIGAOs=
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-69e402b625fso1405406eaf.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 08:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780673772; x=1781278572; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cDYBxVf6/SnI4wuLSeXSHzzLh62y/xO5UdAB8iPGGOc=;
        b=lOlRGhkJI/5JU0BCdpmNlXlRR1q+vd3GIVGL3Ikcsx6JG7oVgoZTqlcXPdQK8hUJ5O
         9U73+Yt157w/5DxzE5bBsg7iSVyrjWPy8CbIpI+tNK40iGjUR+c0UzErKCIwZ9nklIWE
         cgOSZmDMlN1MdLMbiONYaHYANICKCP4HuQOhLcKSPolSD3PD5KNQrNjm28PJS3GjfXC5
         2seu+u38Txy4L5GDtK0SGVHNrKJYQKFuDwGaF2v/p4aAaiqVXkBSueTS+SGqsSI5DKxm
         1wUDAMQrjMnLgbSl62tggYe9PfrU0OIduWIA+NUBCWXNEMbvXu8Ak0YNBlm3ByIV/MR9
         7+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780673772; x=1781278572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cDYBxVf6/SnI4wuLSeXSHzzLh62y/xO5UdAB8iPGGOc=;
        b=WvtabzhYzhsqFSfdqBWEDWBD0qHsmZRsHPnBWa8IXs2DxFzBH9NOJvuskETd17mPWl
         aUBaQFUjlBu/vaYwOlgbyvGY6dJQmSD/nqOLjC+X1FbDRCCtvH1Bo31zaieFMvaOYNuC
         CfQuNsBFyUvfL2bjYnOY9IyHZI2MOlwdB0jOXwX8Vz7fVJPMIPUNC6POiciAq7d4zWb2
         GdG7npJamP66kUsIK8clg37yJFi9u7ybtQoNXpXhidD8R3Hv5Fb9Nc4DkYR/oJ7gI7mg
         PZHYKeu52+bnJbXe83DXkiAsPY/IKZ6+CtnLdykl+0ZnLSkXIjtNn2zceXFYmW52e871
         H4HQ==
X-Forwarded-Encrypted: i=1; AFNElJ8vB++2obl9n/Qt5GgzS3CxHYOCbb3yLTef3BHBapO02I8rX+uAYZqGpg6XkIaGC9spoTP0fil3FA==@kvack.org
X-Gm-Message-State: AOJu0YxACCnoJ5fjL0nYc6jwfQpT+dlFUVry6hDDdpfMkBXaZL/VGaXd
	06YXgDL09Zo+r1PL7b4shtJcV8dkvxfJDuD2FdYY820whojxBdoaNqHX
X-Gm-Gg: Acq92OEJK15wdNP1taWOl00zT1/DQ6QjGnEL+cIoCbu+pmlg2QDyGKWkkBWAAyFF0FG
	lo7bLX7szDxF9Ja0kJABRTwU5KKdBAOVtxQglr5z7Bc0g+GPlk8xaiJsUBZhUIMANdKxmVt2JP3
	6m6kMtJe2K4p/yx4wfnGZU6PxC5tBj59FywKVn4wCHM+V7/M4AxB80cvmNDGWQeEt8rUhCvGfai
	V6bbYP3GndDHeOYzykEoL1vwb1KC1BuyR8xeAS0VJQAiWSLdyiLxNiUaE7WvKRWTMgHIRGzuDKi
	Wq/6Uf/s3N5y+gCfvcSKP8JQ2ail8ib8wd6vE5d/B4xzQF22UTyRkJH9PPr6Nph33Dn7zJ4TloZ
	nCr0q1GjiOYxywWmLgPz32zq8VmpHy5xHyBEEznLLrTK7C9CG46QG5jhzp+CMadYP8+UjnOiurO
	gHJrOvXl7SbQlh+l3KFPazR/VZFd579GyNoMZVc4UAery2E86cijT1vg8yEM0h56lu
X-Received: by 2002:a05:6820:2d0b:b0:69e:71c8:193f with SMTP id 006d021491bc7-69e71c81e2dmr1257008eaf.8.1780673772254;
        Fri, 05 Jun 2026 08:36:12 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:55::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-440d8500f0esm7271409fac.18.2026.06.05.08.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 08:36:11 -0700 (PDT)
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
Subject: [PATCH 6/6 v3] mm/memcontrol: remove unused memcg_stock code
Date: Fri,  5 Jun 2026 08:36:02 -0700
Message-ID: <20260605153603.234296-7-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260605153603.234296-1-joshua.hahnjy@gmail.com>
References: <20260605153603.234296-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 41A12140017
X-Stat-Signature: npowzs6k7ym6oj71ighndcw5d6ez9if6
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780673773-386463
X-HE-Meta: U2FsdGVkX18zVYXdtQqKFZEjqW4b6M3rOXG5VPnY/GZFri5+NobWCxZJ/UnvxfrNwjmLUPEIoZhHb/VwJwr4UaCLOnPJeneF5a0uzukkmzybOpJaKXjIbZOuzjtAIRoMCLOvxnbMT5zQQNy2RcBRswoRDAW1xrSM6v5W0rLF4Ugo9ZKp/l8mWI36v9OO3O1ghMRqoRK82CGmV8wLJ+J/w0EzBxtKiwfji7OQvlG320GLH8zuoODU+ieNYhaaNRGZ1+Y9EoIVWBx2vbjB9BM9AjGGck/vaRtjv7voW1b5Qb/H0rAvMvASNwZym/HYdc1h30yYnv6qX9rwE4RtiwJsZorJSs/iZmbbfjbc4x4JwLYgJnBVUdgohCTyrdOw6mKo/62IDk6Ifb01Zze4o5otEaZQZjUn0MhjSsC0MnLktoDY+TbQUrJohcxVbxz8YZfUbuuyF+9f3h9g9+wjZKyvcLGn33Bd0aM9Y4+pO+xCr3RnIVpSdVonDjPivgiZQK4TvICoBSw1LeYXUPQGRVy3uNjhMggDU/pXchtfj5vaIjMjeu97p+OEGh4v7hC+qbe79D1FIpZi7Y3LdDFxj7w9mkccA/aC6wm1wNFcQQJsBBIEesIzueZ3vkEuriclDpflCAV1Ba/15IAcv4csvMwa58KlxjINKXJzuDtfXw1jCH2d/1RCffc9QqDhTztAbYeXElEeJb/3ILZ8HSFVM26YcId7IxIm/koLk7V2ALwbCYoe72gRNnaf9z7j70cex1Rn44nXy1X4ogvZMCUrocO9PUXY7ARYxik8lKIGksyCHGtSskqeMcPjS3rzlHNfvkHl3WRWQfGYwVts6Os/bM/+s2ZVLxihTGOZ5t90t/tTHGCygZuPsjwIc07gpgPeKABp20EmECbCE9jXf4I3jiah1HkYTnRHQPFYTX35P14z/ubS/zodToTbXj6jkEDjgHnrwFUR4c6Ku797yIqtZ85
 jhDKant5
 aSiKojqOPKCrxqGbENoRE6S4NwLZDT8KxRh4ZeKDkK2q8n/zai9qvsvvizja9IIBjgnRwShZgOi5qLsJNt219iNQJv5VSf20l5Zf+9K9YAKqpAByYhfZbPHKJdXg/dnF0RXpzw7vGneUTj1FalmM6B5lHYiotsMumzjXa4A5ybNvSW8ix/OlN1LckuIs/EHiJ258p1fApBiR/7SeRqPdnagAVwgiMCs8QZr/gCvjhFH82kx4EPBpMxglGT2jC23yT5oq6/0pH3a/zwVIZ/KFMp33nIptb8GNcNs27BT9wjfArAqLUOeNGHnbrQDVFNQ/gm0YyImybGsSAEMb7S6hjV940NjDkS7eZT4wbaD3RB6aV+XTIk0ETZb3q9QTMWApJjHe6HXVUuOY0aFouUqgn+AFrkvlQuHNjy57AhjoQPm3Qn37Vn7KeDeKFHrBEs7/Ft1HNmc6jfF4apzCkU4VpbJNwA3/6AUf/7UB9Pv9GHG/q5T8jqr8FKXZe8iTHUAjnM71W0+FelGsLm8GVfM8LzrXOIrAlGk8fK0kjKVdQAM4sMx2htKjCAL+eYYWQqezgZsT2qbV1g2LS4Cy2kVml/41PpO9tlkTpZ7WvToQKRuwg5fc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that all memcg_stock logic has been moved to page_counter_stock, we
can remove all code related to handling memcg_stock. Note that obj_stock
is untouched and is still needed. FLUSHING_CACHED_CHARGE is preserved
so that it can be used by obj_stock as well.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 186 ------------------------------------------------
 1 file changed, 186 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d0da2f842e2d4..3e3f8fbd19a48 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1998,25 +1998,7 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
 	pr_cont(" are going to be killed due to memory.oom.group set\n");
 }
 
-/*
- * The value of NR_MEMCG_STOCK is selected to keep the cached memcgs and their
- * nr_pages in a single cacheline. This may change in future.
- */
-#define NR_MEMCG_STOCK 7
 #define FLUSHING_CACHED_CHARGE	0
-struct memcg_stock_pcp {
-	local_trylock_t lock;
-	uint8_t nr_pages[NR_MEMCG_STOCK];
-	struct mem_cgroup *cached[NR_MEMCG_STOCK];
-
-	struct work_struct work;
-	unsigned long flags;
-	uint8_t drain_idx;
-};
-
-static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
-	.lock = INIT_LOCAL_TRYLOCK(lock),
-};
 
 /*
  * NR_OBJ_STOCK is sized so the entire hot path of obj_stock_pcp
@@ -2065,47 +2047,6 @@ static void drain_obj_stock(struct obj_stock_pcp *stock);
 static bool obj_stock_flush_required(struct obj_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
 
-/**
- * consume_stock: Try to consume stocked charge on this cpu.
- * @memcg: memcg to consume from.
- * @nr_pages: how many pages to charge.
- *
- * Consume the cached charge if enough nr_pages are present otherwise return
- * failure. Also return failure for charge request larger than
- * MEMCG_CHARGE_BATCH or if the local lock is already taken.
- *
- * returns true if successful, false otherwise.
- */
-static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	struct memcg_stock_pcp *stock;
-	uint8_t stock_pages;
-	bool ret = false;
-	int i;
-
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock))
-		return ret;
-
-	stock = this_cpu_ptr(&memcg_stock);
-
-	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		if (memcg != READ_ONCE(stock->cached[i]))
-			continue;
-
-		stock_pages = READ_ONCE(stock->nr_pages[i]);
-		if (stock_pages >= nr_pages) {
-			WRITE_ONCE(stock->nr_pages[i], stock_pages - nr_pages);
-			ret = true;
-		}
-		break;
-	}
-
-	local_unlock(&memcg_stock.lock);
-
-	return ret;
-}
-
 static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	page_counter_uncharge(&memcg->memory, nr_pages);
@@ -2113,51 +2054,6 @@ static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
 		page_counter_uncharge(&memcg->memsw, nr_pages);
 }
 
-/*
- * Returns stocks cached in percpu and reset cached information.
- */
-static void drain_stock(struct memcg_stock_pcp *stock, int i)
-{
-	struct mem_cgroup *old = READ_ONCE(stock->cached[i]);
-	uint8_t stock_pages;
-
-	if (!old)
-		return;
-
-	stock_pages = READ_ONCE(stock->nr_pages[i]);
-	if (stock_pages) {
-		memcg_uncharge(old, stock_pages);
-		WRITE_ONCE(stock->nr_pages[i], 0);
-	}
-
-	css_put(&old->css);
-	WRITE_ONCE(stock->cached[i], NULL);
-}
-
-static void drain_stock_fully(struct memcg_stock_pcp *stock)
-{
-	int i;
-
-	for (i = 0; i < NR_MEMCG_STOCK; ++i)
-		drain_stock(stock, i);
-}
-
-static void drain_local_memcg_stock(struct work_struct *dummy)
-{
-	struct memcg_stock_pcp *stock;
-
-	if (WARN_ONCE(!in_task(), "drain in non-task context"))
-		return;
-
-	local_lock(&memcg_stock.lock);
-
-	stock = this_cpu_ptr(&memcg_stock);
-	drain_stock_fully(stock);
-	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
-
-	local_unlock(&memcg_stock.lock);
-}
-
 static void drain_local_obj_stock(struct work_struct *dummy)
 {
 	struct obj_stock_pcp *stock;
@@ -2174,88 +2070,6 @@ static void drain_local_obj_stock(struct work_struct *dummy)
 	local_unlock(&obj_stock.lock);
 }
 
-static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	struct memcg_stock_pcp *stock;
-	struct mem_cgroup *cached;
-	uint8_t stock_pages;
-	bool success = false;
-	int empty_slot = -1;
-	int i;
-
-	/*
-	 * For now limit MEMCG_CHARGE_BATCH to 127 and less. In future if we
-	 * decide to increase it more than 127 then we will need more careful
-	 * handling of nr_pages[] in struct memcg_stock_pcp.
-	 */
-	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S8_MAX);
-
-	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
-
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock)) {
-		/*
-		 * In case of larger than batch refill or unlikely failure to
-		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
-		 */
-		memcg_uncharge(memcg, nr_pages);
-		return;
-	}
-
-	stock = this_cpu_ptr(&memcg_stock);
-	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		cached = READ_ONCE(stock->cached[i]);
-		if (!cached && empty_slot == -1)
-			empty_slot = i;
-		if (memcg == READ_ONCE(stock->cached[i])) {
-			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			if (stock_pages > MEMCG_CHARGE_BATCH)
-				drain_stock(stock, i);
-			success = true;
-			break;
-		}
-	}
-
-	if (!success) {
-		i = empty_slot;
-		if (i == -1) {
-			i = stock->drain_idx++;
-			if (stock->drain_idx == NR_MEMCG_STOCK)
-				stock->drain_idx = 0;
-			drain_stock(stock, i);
-		}
-		css_get(&memcg->css);
-		WRITE_ONCE(stock->cached[i], memcg);
-		WRITE_ONCE(stock->nr_pages[i], nr_pages);
-	}
-
-	local_unlock(&memcg_stock.lock);
-}
-
-static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
-				  struct mem_cgroup *root_memcg)
-{
-	struct mem_cgroup *memcg;
-	bool flush = false;
-	int i;
-
-	rcu_read_lock();
-	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		memcg = READ_ONCE(stock->cached[i]);
-		if (!memcg)
-			continue;
-
-		if (READ_ONCE(stock->nr_pages[i]) &&
-		    mem_cgroup_is_descendant(memcg, root_memcg)) {
-			flush = true;
-			break;
-		}
-	}
-	rcu_read_unlock();
-	return flush;
-}
-
 static void schedule_drain_work(int cpu, struct work_struct *work)
 {
 	/*
-- 
2.53.0-Meta


