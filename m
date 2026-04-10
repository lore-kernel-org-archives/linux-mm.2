Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 392CEF45A0D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700436B009B; Fri, 10 Apr 2026 17:08:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B45F6B009D; Fri, 10 Apr 2026 17:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B82B6B009E; Fri, 10 Apr 2026 17:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F60D6B009B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:08:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE663160217
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:59 +0000 (UTC)
X-FDA: 84643883478.08.7DE143E
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id EFB47C000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eRPUUBC2;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775855278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=esfCictnJyPc20j2EkkTX38W+qKv+nRwhZtLvjA9q1E=;
	b=ou1ZRjqQ2v8/PzTD89tsimjgK7l5kfGyFeiM/+fDfRH/nZo1fMN7ly7nn7W6FPThlJNak7
	MLYeHhivIBk3ID2JhncaXKfLqYzorYZIuwOH//1oPOSwN25jqiTK+Nu6aFrOdCYojMok4l
	HP4KRv7HmSgMr0Itnf4HYVy4z1coxLE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775855278; a=rsa-sha256;
	cv=none;
	b=FyUZJ/VSvSRb63S27dqynTw145tduYCi2suhQ10gGaPUU9uRaRFBwIxUYD7C7C0I4RWtTH
	ZdffAPvunzqpDnuhcWxRCbs4WklJSvJB4x8WWseP3qAuarHb7D9SDPeGqUKD7YewB8yJR0
	4G7ZAtC8cpI1hvgg5Y65eRfTfJJtTWs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eRPUUBC2;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-673ee2a98b1so1510391eaf.0
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775855277; x=1776460077; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=esfCictnJyPc20j2EkkTX38W+qKv+nRwhZtLvjA9q1E=;
        b=eRPUUBC2ATUC2mQ8eLUL2cUr3T43evlVtVtHVLe1g0Gf5vQ8AoYQSn29+OEkNcL+tN
         E4AoJdKqbz0tnxVZAL++kYyD58hVpA41puV97v+Rv/Mfw3eN4aGHdiS9rbjJLJBYga0L
         5U+5Y45JjfFibHoUMwwrAfwMDd+mTaU5R2gcC+Rb4N3hD3UP/40T4K9ORi3i8Q5oxbpJ
         zqQfJMBZaB5IBckCUELjg8xgmZWOGsE022nxSigVG2nOofV97EE1KsZi+LjJJzbEsg78
         39e7V6fS5ZyE+kxu+3N+0ppmTYWzLCjtyo7wRcpdvMjRt6PmNhK3ilt5yYAsmkwJhurt
         CBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775855277; x=1776460077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=esfCictnJyPc20j2EkkTX38W+qKv+nRwhZtLvjA9q1E=;
        b=ed6tCUgITj1zWCVfvXFxz9AhNKHncPyx7a8fCtqXrpUnXw6nSFQ3CJkzQAC1tT2iZZ
         rCMZXseA5gHO+7GXkmSz2wiiDoQh/7mMukOfhY8waGFzKamYfyzCkhK63KAFuxjCnOV6
         z3VM+xnnE5idtMYIXDTJLEQKapeMHWkqZNEDlHdJyGF39w6qOzQacwj7aFoS5f91s7rM
         gCyJEZSo2oKKhBCZ03Kklj1FvUpHCqH4POPgDe2n7ZJhj0L2I1NeOk0VLJb26YS76DL4
         jGpnnMI2FkJ8cvZDDiivGTFAYHOjZgtvl7YDJgLM0tMMJ1xu8uy+/cvjrjetx23YubGF
         FUHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXt+F8asDUDxuDKRbcj4MBWEirUT35i2XpyJ6Fjvc5TzhZaZQ6+fk2HykxL/Vo4f9mZUNH3zMZm5A==@kvack.org
X-Gm-Message-State: AOJu0Yw2RYE7gGD+waRwEm6Nws+chC0AwzPkzolu9vcMIdX8qUWdSnfJ
	/li8MRa9dXoRT4F1tLdsuBUEaj9oyKe3oOTn/nllP/hd5YQQjuYeOqeC
X-Gm-Gg: AeBDiesfR3yQKJ+EHtiA4L7/dK0OEIhY1v73qkIFdUGahgkOrom5d85zqjR7HTu1i4G
	e6gpt1l2hg3J2nbvKiBbJ6slsHN9BX8OTLC+xLI1e+8mB7FBYpCcCzgZA6tQMtk/FymFVsaK9zc
	qDa6FjvfBG5Y7Cxp5DrT8gHqFiUp4bX28g4Y5jMAVAj5G6wFyZmxX5F0HIzX4c5sYdTDotUA92V
	mCBnaGTyGeypUuKFkW+4EkYzzLL3ysRcN/4Pdy+dPMCIEVvUeedUOvTTrD89FvHbID5c5nsCxdm
	c063xkv+fD6dX08d4t5vADX0ktCC20hbArsWEGlTq0CHczaOKBWorvdUs+pCHrOqDlZlQYwbtIr
	ZoieY7wOJh76i32GZGAZgj5C2FGEk8qGLThJ/2s03c+bdBbdAC1eRRkdBuONhR50hXqHAy+co3/
	tAjnogdM1efFSlhhvnxBQ2dX9xafHTfYBE
X-Received: by 2002:a05:6820:1389:b0:67d:f88f:d853 with SMTP id 006d021491bc7-68be5c5dd0amr2359578eaf.6.1775855276856;
        Fri, 10 Apr 2026 14:07:56 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:59::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-423dcf9726fsm3229555fac.0.2026.04.10.14.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:07:56 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 8/8 RFC] mm/memcontrol: remove unused memcg_stock code
Date: Fri, 10 Apr 2026 14:07:02 -0700
Message-ID: <20260410210742.550489-9-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
References: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: c7cu8zg468sf1ed5fhteekwho9g78aqf
X-Rspamd-Queue-Id: EFB47C000A
X-Rspam-User: 
X-HE-Tag: 1775855277-53258
X-HE-Meta: U2FsdGVkX1+g0guL7amC3XDuU8o7cSDbdaidUqf5ptCA9LVhvV5PeB0BvcQ0ftYJZuZjmByCqSyFvHhLyevRAHagWvkrG40BCpLYP/CiiQd7GE3meaqBCnhYHwE3lpxzgmcsarS1yCZb8ECjvuD7Ft7EuD1AXgzZ/i89zMtWNfcvrGVuP4t1Kq+y0VFh6IaywNd4jKjsNaXjnFA0e1NYZ32zx8uybQpgHbXraRNjKocJnOgbVZhh1Iiw6bE5yFjPRezImfosKYOt7/L0O12dHyanEoCPa7SxC64cYQ+SKl3OSmqXIPlqU11xV3hDb0S1HCnRE9yMHX9sb4XJWgV/WPQIu6Q0fC7+UjHFEIhf5LJlB7Kt4uHYIdm4qRbVGN66INTlAWs6bOhgY/4m+UjBim3uzPgru2a1C5fI+VLl+PxkQNHxoBFXvXzLaJtIkEIOHhNC8C3DUmRE7v7KX/ptZC/pD90Ra0mVEqqXXGXhA6cQgrvosBnLllFr62m229cqdHzUKifgt693+Q/tT9pl3hvR3ZnEyoWlQmex/PP5j7KBKji0X1uSs68KxmsWgV1fuQ3f+KZum4mLx0XR2dyLKQzLdXPQYMCHZ3et80a43WSZTNllhnPhQJYHr47bNsGBGfeuk4B9x29CadnadTHpvS8v6SDzp8KDsQTSmg/n8oVd1rLnfrOJdHIwVYx15PcVSREAgWaE1N2BKcg4w6F/MAymvklwDZ56b2VUYachiWp0Z314zzmcb6sgTVNZd6xpIDA3XOsv4aBnqWwJR2Qy2mY47LX7cuUIcefT7jAeryqE493Sz3aGNsZisMO8CxGHeZqhY6I2aOoR1U2CgD4rYwPe3z3I1TycUIbaA3xwYV4Rms1lQuLA3Q6QwpTD/GUPMGkbTmm+KVAKfBXYgMbgIDqiLVd3c6+qn/AUIQzLF75xuxv4GwRPm5DTCQfFd4zba96VqFVJ74YD6eg+41l
 fExoUhET
 92KDaqb4VRQUYenaeLmXLyCMAojpjYbe70f1PeXg85tjnc6qcrYbfIb7kFpXHwaNRQwWt2zUnyFrHJR0eP79jwI/jprSMhI4dgpaZCD3hK9K/GYKT5o7aVKxoGubh0kjs/d0DNJcTGkPs95pFnqhCqYec3yfHcmkeqKX6H5JlVAGj3TrFvOQxCBQhFrzinNDprH8p0ji/UL1rLO9v9xqewNogL3bgtzoga+Q+md1pXaELYpIaCeVCjI5L3nzbXZ/G1/sPoa5sTteaPqHUFhM2AjWUMpATcVjrd5U2FvFjbN3lfBJsy+MRj6tBU8jMYcILwHBEPdkAf/3CyWAi8jecuVO2vwrdthtf1vSyRxaTs/HIOVfy9jKhEVVHZwtXeYGpit37N4iadx9NNok0UYUlDpLNKI4MDPdDPp0DK7itsKpwYGROBNmOq53PRJpYfYHDSazZ1jxmKghp6zM2EzL0hQlg7gAjlT5inMgMJnhXrapj4sJFjDTo2VRCpVHlep5/Pqd+liByqiZK6qvGLQhO+tCJTFNmn8CewxntPxiuLUjQrdHEIYZ3U+L/xY3cW8uA97k0yzgoa1Ue08BNEp9KecmMrQo/drrvT36o
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
 mm/memcontrol.c | 183 ------------------------------------------------
 1 file changed, 183 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4be1638dde180..7de23ecd7cef6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1989,24 +1989,7 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
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
-};
-
-static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
-	.lock = INIT_LOCAL_TRYLOCK(lock),
-};
 
 struct obj_stock_pcp {
 	local_trylock_t lock;
@@ -2030,47 +2013,6 @@ static void drain_obj_stock(struct obj_stock_pcp *stock);
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
@@ -2078,51 +2020,6 @@ static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
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
@@ -2139,86 +2036,6 @@ static void drain_local_obj_stock(struct work_struct *dummy)
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
-			i = get_random_u32_below(NR_MEMCG_STOCK);
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
2.52.0


