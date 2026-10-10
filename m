Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AABCDCA9EC5
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 21:10:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA80E6B0092; Sat, 10 Oct 2026 17:10:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B320A6B0095; Sat, 10 Oct 2026 17:10:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47AA6B0096; Sat, 10 Oct 2026 17:10:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 826446B0092
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 17:10:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 270481C3DD2
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:10:28 +0000 (UTC)
X-FDA: 85307960136.10.7047254
Received: from mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
	by imf08.hostedemail.com (Postfix) with ESMTP id 386FC160002
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:10:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SAllbrch;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.7 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791666626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oyYtJcSI0Mqgi/b8qful4h+Sn3xp1Op1Y3XHQCXic/E=;
	b=Y/wATADvn3ZDNWeEwo3cGtXLLFBvT8o+CIH5T63Pj+bh/g7DgzfKJHE5D0/0RqsJtvQsOR
	6/th2BGVbHvCxpMpmRWgdEBg+3gYjEjnqNrrDCU9/hFpecnJ2S/C5LmlA3ddmL/y/ZpcJ1
	SnudrDupIzfQ9Xl5nrEZ0UmAFjvW9nM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791666626;
	b=5qWH5esLkCYzsbnTCZul1iSFVhWvMLacyjnqVsHcG6pPZt1Rvriq1bqIXQ1Nxqrd8XHMby
	yZZA4FRzPqix0pv4eX5+9qcO2IGwE8iUypjqoPxUllRwGBt03o6Cuk96d1O3Ut7EkoxErK
	9w1AmSUvzM6pVA72oPl3J1H36FNGvWk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SAllbrch;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.7 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Ly0XDKz5aJx09UruibyzcA0mahI1HK/w5v/NpW9zEKk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791666624; v=1; x=1792271424;
 b=SAllbrch+JRv3seZFDZCGjm7gng8nzNsfCMbJPFNCv2ZMFB8XzH2R/d02QPdza1LJrklkA/5
 UHx/ZFLR37N63Fd9unAM9DC62RrEqAQm0DPVwH4PrwQtUpmyHpAQDdXjst3InSW2cgQ9qNA4ZJn
 I/r6wlTRopm2F6qufCiSgjJE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id db4aa6a7d8b211f2;
	Sat, 10 Oct 2026 21:10:23 +0000
X-Mizu-Trace-ID: db4aa6a7d8b211f2
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH for-7.5 2/5] memcg: use high_work for kernel threads
Date: Sat, 10 Oct 2026 14:09:54 -0700
Message-ID: <20261010210957.1350874-3-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261010210957.1350874-1-shakeel.butt@linux.dev>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 386FC160002
X-Rspam-User: 
X-Stat-Signature: 4rhnmxg7dhuz83apnqgjptnxh6nj541n
X-HE-Tag: 1791666625-805784
X-HE-Meta: U2FsdGVkX1/+DWXIMq1mh+nR7ORzmvLdqucttNwVKwcfitKdfSP6xU3VzDy5e/+T0Gz0nCcd7Qeyd85TZBiiHt1dgtnNr+EhoB5hUpFTp6UWBzlSFwCkLl/CzeF1THceKrCzteMrUsswJJDR3kximLTeBJNbt3Tys+bj62AcuRRhwlr8QMKA/JS62l28CPPiJaTojb9clD/z/uyf4EnASPEj+YLOClR+OzPcSAupOOKsaAhhIhABX7t3Vo4CRfYJkojKjx0YTEJJdbND8RPaDxLdcWAEyx+ugjbnulLMDGuWgNXx48LbHsHatA+I8mRBli93ROMkXPLPSw4nO3mZ16h2I+eMsZ0pvtR0T+t4aKnVN5IyhGES5J7vxfPc8OOP5wPtI8txAf17HDHZbrLtb4EkNpkuXuybnnuB/9S2nBzkiggdsnwfCofyEdr3KuMzz9JHvJl7FJYxcRunRx+ktwHP6QJzhrBVLugWzHCp6Z6S4bw4f0stSgWgWOY1YUNndTt8lqC6bYSyf1WDZTjq/vSK/lMKqXGSMh6qQIg3iCXTgZKG5gA/nYagB4jHdKaJ7cBwF3jgRkhqLlL6G1yebujglwz4qbb97axzw522LmoomNNqK5NO6BXt3yShMuaejFSSuyeHkgm+IR/TEn6K1hQmlIlzxZA8FDw3ABwnaN3ggiAoyingHcJnPp00j9qUNvecT61ApxBhggTXZLQgKproz9Xn/wFIU1QJBdNauFmZL9T62y+bzUMFOt7peqwte0fEW4rvEcRAFKuOYbKjS8tl0i7emQcOA5/LU49qp7Lt9UqC+XcY1M/ZPkgzryFhFbJ95WEM+M1ChLmji3MdH8ujHGkFF8vUd9kGAsWcaPcmX0wAV+z2PQuL9PV4v2MhU2xFO1iYcY2RgeRA++rRd+kg8AT94eBc7SjMasPsHS8ZDclzxlH0YVG6eIwTtxr4RrJ5mQXM0P/iMBqYU0f
 VMXcxZ1o
 u03/H7oWDsOP5lMOW9yL0otc4988SG/5X1yoc7QvaZXP2aqOUDYGdKz95CegpoAWkKNn4IXj2lpqteAKXnVrr/KlSkWsvDu6Ip4bOW0hw6v9uCD9Y+Dd4VyyJcMjmoAFeduXQH6Wlwr5r5BRUlGn2jhSlxb+ukgrJ+sUdOt196kKCX/K4RgQXkotjYejNcGdKEWTs+lo9RPmxL75iXoFxQSgzXNxQ0QkA0Gjot0jSRfAkBNqxy6emWedUDElSEE2zH2jX7IuP21i5ZLFPSpyyCqpF7gSwE4iYoLmVgOWAEp8U/Bk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kernel threads never return to userspace, so deferred memory.high
reclaim does not run. Reclaim and throttling during a charge can also
delay work they do for other tasks.

Treat kernel threads like interrupts. Queue high_work for the first
cgroup over memory.high and skip reclaim and throttling in the charging
thread.

User workers created by create_io_thread() and vhost_task_create() keep
their current behavior. Vhost kernel threads use the new path, even when
they borrow the owner's mm.

The worker requests a fixed batch of pages each time. A fast allocator
can keep usage well above memory.high. Kernel threads also skip
memory.swap.high throttling and its high-event reporting. The memory.max
and memory.swap.max checks stay the same.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 20c5dfe1a894..8116fce6ab96 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2705,6 +2705,7 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 			       gfp_t gfp_mask)
 {
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	bool use_worker = !in_task() || (current->flags & PF_KTHREAD);
 
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
@@ -2723,8 +2724,12 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		swap_high = page_counter_read(&memcg->swap) >
 			READ_ONCE(memcg->swap.high);
 
-		/* Don't bother a random interrupted task */
-		if (!in_task()) {
+		/*
+		 * Don't make an unrelated interrupted task handle this charge.
+		 * Kernel threads may be working for other tasks, so let a worker
+		 * reclaim instead.
+		 */
+		if (use_worker) {
 			if (mem_high) {
 				if (allow_spinning)
 					schedule_work(&memcg->high_work);
@@ -2751,6 +2756,10 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 		}
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
+	/* Interrupts and kernel threads stop here. */
+	if (use_worker)
+		return;
+
 	/*
 	 * Reclaim is set up above to be called from the userland
 	 * return path. But also attempt synchronous reclaim to avoid
-- 
2.53.0-Meta


