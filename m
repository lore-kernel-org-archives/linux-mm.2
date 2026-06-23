Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1722CDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 18:01:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A10F6B0098; Tue, 23 Jun 2026 14:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4789C6B0099; Tue, 23 Jun 2026 14:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38E526B009B; Tue, 23 Jun 2026 14:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F31DC6B0098
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:01:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 772CA1405B0
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:01:36 +0000 (UTC)
X-FDA: 84911944992.25.AE88CD8
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 98F03120005
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:01:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SX6iN2p7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782237694;
	b=Grt0HfyqkXD45CCFOnwO489SzfvRH8XcWa0k4LGWUh+yIN/NoCznO3/tJMLwuOAyyrVgmg
	FxNhTpSeXqRfhXYMsAeVLnnoJ78RwKXJAWUyC+bqk4fP/nK9S0uloR/jYVTjiiYACa9IiM
	VQXaxTWzv8IgRlEMGKD/tQhv0RjgYls=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782237694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AV1AMv1DdRElmEAq04xArjlt0DIa0cx6rlJTbGmfpe8=;
	b=J42exI4/6rKQYhcQjYIgGcZyLjSHlom0+wCn7ZCdW39Rdq5Dbc95wMf8aQAKaKBAw3S2Ja
	ARamyyEznZdBbXuujkOjcL3Nm8fwUvVxmryOFD81Qx26B6WEKPMiQqPDqc0MiWsZSRwaGC
	GcDOwzOyu+dLwUy4gkcTUMbEpy5Kz/g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SX6iN2p7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7e6128bd9b3so96228a34.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782237694; x=1782842494; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AV1AMv1DdRElmEAq04xArjlt0DIa0cx6rlJTbGmfpe8=;
        b=SX6iN2p7DiUDvbUhiGrVMoj/4Mmuce+mApeeLvtDk/N7bC7ZM6u2nV0pi1fWxJQWMf
         ayjenJGykCC9T+vH0etSisQKPMmW4TZJ1AkqKwmyhKlHBNQgyxRjF6OyRA4yqQLMm2ij
         by3d397apI2IsNPADvCKyqlQOtBEhqN/avey5OYhNZZCuaLJrrvu78HErEBbS0qt9bi1
         8UkDNyhcR1aOerrHT9a4FKnBPM1XwYiSsGps32iBe0NSUGN7ZzYqhB6aZ5u8gr6rEZYO
         ezXk9vcyMM5A3xwlIA8zLdbMT+6NHoFGHLTwCeuSmmOWgM04O/X07rcpa22mrCEN9k33
         zhKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782237694; x=1782842494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AV1AMv1DdRElmEAq04xArjlt0DIa0cx6rlJTbGmfpe8=;
        b=jkb4dsc28tMB8AlLjOhuB7ByB6Dk5Del4oSjvEQYexmTczYOara05Qq4zpAvVc1j7Z
         fha+BTvtIomK7Nmo0vwHskLG280bOO5IF09mgDnjFz93xi3LCTbnC+kYu+WRwZmjqh0q
         NKSq4wy2NkRKlzUbsbiKBnomY9KLcG9ZSLfk8pQsm6Fg9gPm3TFrKlcXCXgcXkhAO882
         84dxkpTwh0RdQqHr9s2YpE9nWPlC573EDUPY6rv+IKwUiJrDnAHRiL8AobuVAAyw8Qky
         IKaMdlDtqWBS+dxaljb1Vvg7lQnY53j7kemX6DPczYPPOianKfGqnnfFVtQs87nGDfe7
         rbVA==
X-Forwarded-Encrypted: i=1; AFNElJ8D4L6CikEhh4eCOusfjQx+LajKa8y1tnEH0L/yDvAmRQK21vdaU+oFIC/e9YGcdnZFtMCHFpzJbA==@kvack.org
X-Gm-Message-State: AOJu0YwySVmKdH0ZmPXmkopYpV01lHUvrBO2fRt9QGCc/f73uSZu4JTM
	w68ycvA52pL0eT5k/6jue6mHueVoj3EY6YHr/RFohgoN9j56oQA5crmg
X-Gm-Gg: AfdE7ck3fE94H68ma/xi8OcOaGgMEdPj6Xb+0U237/ZBBtVZ7ABG98gc3/ZO0mMT2jV
	prFgoxXTWSD5fUSGnhkG8Dq4iOa8RFMPdCRu3xTjmcUxCumgqAUgQPLFFXx74avdxJiir5bOSte
	qVm15weCWlVx4Hjk6NrGFZAeaIDIGnRQEu2oiWy0ADEjDV+U+V/uCuNjhB20dYsQqugHquvVxb3
	FSXnf9/fZjr8Pery/oavivQfXzJ5gibiO6Kfwkc8WWIk7MWXu6y6H9HzNJqiZGFWxfuhb5Crrhp
	xme5X/g98FkIuCYjB1wNXI1vo0qmrRhZTQ6rTkzKujD+LCVOOCDNxWbQ9hcPoFNcAxxkrt0Tprh
	jGs0AcqSAtWtogs0KinClOX4j0LTMLJa4TFFMWXqrEDMn81KzSQIrj0RBGazDkmI1DLFFKAgaok
	UXqMrXJwnUEBGYoudCtkzvXGxyS4OzGeCb7ZXF+SvK5w==
X-Received: by 2002:a05:6830:7109:b0:7dc:c7aa:22d4 with SMTP id 46e09a7af769-7e9867c537fmr179348a34.1.1782237692753;
        Tue, 23 Jun 2026 11:01:32 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:c::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e944296d7asm9374720a34.19.2026.06.23.11.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 11:01:32 -0700 (PDT)
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
Subject: [PATCH v4 5/5] mm/memcontrol: remove unused memcg_stock code
Date: Tue, 23 Jun 2026 11:01:23 -0700
Message-ID: <20260623180124.868655-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623180124.868655-1-joshua.hahnjy@gmail.com>
References: <20260623180124.868655-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 98F03120005
X-Stat-Signature: t7k3zw3m4muk7knc3wprbzb6mdhje93q
X-HE-Tag: 1782237694-778658
X-HE-Meta: U2FsdGVkX1+BxJ+8pSv4BPC1yWbPxYg+YjpHy6RvBeBTAbJ1+jOvvC8gv6d4n2fPaBDlAZEt2QbIer/G5yBf+XNCLfkNtDuYhdKtGV9MKxQ6BLzfoRAdh4JA77Vkh/z8dO+4canyvgZC4Hj+tRNVGyxb+NL2SA8AYRK2Yu27/U9uNVwB2wZRj6S6nxXFK+l4lAOzZToBpiREsf5dP+BgEabCjA/0nz3gLIzW1DvKfhoGVDvZ5wtIP22scaCBUTXzm7MTetWuft4PA1tmEgr58T3TP5oswo1sxCGlL/nXkVs2MbP7DRK8g1X8AW5ECqdmc3rjox8q13LtcWtpckgOCw7th3lTV0HBhXPjG9K9DL+s3+3xMfvGekgDsVndzSbaGoZjOdo9CMsznAxsYgwWg+6bHASTYGhUjl7PcKId4DQuzUwrOGhdNylMiHMk+mX7+RDw1ACEoMXAohM0gAztnKj20ITm/MY27tJl6NGdkHebTYM0snNG3r4Pr6JyLuB3xmK9ThlOLoDHa07cBWhlb+WTicnEGqnFR3aJy6j8ZN4xgtovIXjowVofE4YmZHpXCm3BTNuRKT9M6qJZpczbSh5dsGgq67onYavtCv4El8BCe3OWO9RSaseqXItm1bGEuaO4vxTtOJoifco0rVOH+uPunzDwFRqsIyTKH4pYzAGCwjky4qZhBPuIq54bMjoDqslHM40tUXjGP5lX8JXdLG7B+bAOLdwbDYFB3A6DnsqoWTxqdM0w5Y2Uru+HpWScwscgRPUjcnnJFfuFgQYKwtHUxQBJAZcwiv8S+A4oLvIICQCaAvQUizMvQFSaQP5Cl1yS3FeT1ZWGLVJVLYjCNNaesdS1/rH/yPP5ss44WDqTOcNdiK9QwsIrIaC7V9vRh6lEvxDVlAX7AqTnn0b/3lRsQo9CEgFnTC0bpU8GpgKMx/hAMXHz0wvlNHnmrHb2cqrorhMBmXasc1ZiQdJ
 lrf2I9vg
 j2QMtjRXUq2qgXitnf6E1PxzlCxFHhbTqR3n6WeWVzMJL22oK+U/CH2laQLFuKdF0Mzq9T2ubBFwMMXNn5MZ3djzDXNgG05cl9Zu79jJ+r2TOj3j/OZFoSSeH6WiXoTtcC68glSfx/i878cSZOkNjNtrffKlm99HQAAcc9tC0s8WSnV+u9jOhnYt59cebTcNVb2Uo814Qe5sYO/t/2qRoLEmIpNmJ2mT74OBWca19d1+qMNHswzBLgACYTXbTVHyJ1pNZSbb0QY5jt2CJQ3UuI22jeVjV8tzd+hlrYCOxLGGoTU1jUWpfeot9lX7Ne6/89jIwpMSqaijI2kz4fHim5uHyP/w3codwe4Lb8CfXztXzkbsyg1YlnXABKYG0Hlx3Z21ecn6QogKW3ZZ+HYEGHgD65QSdDWWp/XfKEz0WTHcY0nLAjrTic64jdaDYxBhp8gOnWsAQlutq5q/DdPNU2HOheQ1SWqqc4zZ3m5c237a+Jwy26TnPdWy5EHCxZj/c40MTQnjWK59Q8FxaDDYh+SbQtJ748h1j+b2e3fc2ttr0ERIW8Af2sipsnGcyNJ63amgFdLEWVE25VdJpIwSHzC+u5o3zyS870+C754Fb9T+9Ays=
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
index 846800917af49..762fb8914c308 100644
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


