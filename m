Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D87B3CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 07:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DABB6B0093; Fri, 22 May 2026 03:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2216B0095; Fri, 22 May 2026 03:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7BA6B0096; Fri, 22 May 2026 03:16:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7146B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:16:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B3A1A92422
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:16:34 +0000 (UTC)
X-FDA: 84794197908.04.A527E65
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 08EC240004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:16:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="nr+B+/VH";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779434193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ofTJ2Iw3jGWVDU8AK9RMEoAeb3tQr+vx1xTO7a1aBkY=;
	b=qobNozSoYiBkI2gy2rl8fTHCFJXyD0uL2j4GFRPXSTqHLVD6a4/ooUQ86hIRpJTQQyVhmb
	c4KmbZ/QUtOGHq/yivMlNxjRbAZQXE6guPSxCzHroocqysaL7jjd0xkHi96noIRj97TRmp
	GmsuWu4TflotbFpsRChbBn2uL/fZGNo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="nr+B+/VH";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779434193; a=rsa-sha256;
	cv=none;
	b=eZn/jwBGHycTNuuUqvb8Ipj/slhAkE0WioPCQw782xeORz1FUmMWTj05DH9wY+MR6CqbPb
	ZmVcW14ZrC7CzJvauIEYTtFsA/gBY9PfSmyRKbGFqQX6GmJheOixyHYs91MJxkG+c1zada
	AHCGSAuumlaGxIbD3Gy2aTNKfpJhKPc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779434190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ofTJ2Iw3jGWVDU8AK9RMEoAeb3tQr+vx1xTO7a1aBkY=;
	b=nr+B+/VHJIU0zdKqf0sEkBhtrCFbOMsL+3ghUpLjMAc4reaEr9gYILTsfaJgBgY+dS9inO
	ID3FV4DX8x5jioVDqwgFO0mA7jv2ifY+gx0WSfag0iaCJdMBoZoA5xbMsPLJTG+8BXv37E
	0GpSX3vtTQ6/pgb+N66nTKvqCwG4NHQ=
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Waiman Long <longman@redhat.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v2] mm/memcontrol: Avoid stuck FLUSHING_CACHED_CHARGE on isolated CPU
Date: Fri, 22 May 2026 15:16:01 +0800
Message-ID: <20260522071601.21065-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 08EC240004
X-Stat-Signature: xfrwfb1zaxy7nourt7eoiodri6td6ypj
X-Rspam-User: 
X-HE-Tag: 1779434192-783120
X-HE-Meta: U2FsdGVkX1/p4huLI+nQ2f+zhg9BWP0aaKoKfAbKuMsALegqDyI/6jhpQlJkGxvGeqNDLcjvPbOGAHGWiw6QLShm55GE6+vwPY+jkJRU0FZMGuqyRSK2cx93xtsEGtPT9pKMvFuD2/S7EA/3XLQy/XiegvtHkUACGqGHhKF/QfTH0e+pd5V7YqBK38rrmngYpHj85pQMflLPS7DpH/JZWPiKc7XVKHJtg8MF/Eq9dSkPCDhG45jpXlXDKGWpSjNNzkLmtsi9Dk+y/PZ+5x6D+v7B38skR431SOAf0bupfJiSV4Cm5XXoF7V4MP9CthEAk1HvvHYwFiP5t1ms6Ad+C2PjzX2rtdmGz+yZdzT+ZVyGzt6X+RfF0SGP/7J1Tygyvw/CEvY9NZA58nyxK3khZzCpVOIURT49uGbNL7fEMeNDuxEj88Le1AKbMGOA22ELyz7Obnu4dgef4voAJCAUl3l2C1aeiBligV/hLHvDjiGQVp6HIGK4Kx5QCsc0Eqkb9o1gcaGkIR7aUroIke2jiIUaE7JDJs9HGs3bPDttxeRbiMRZckDutN0ULSXFlHZxBUuRlpcFqhpogVIGil/aQiXLIA9Ut2b8AFglMcr/fwdwQcg/GWOH7LN4XrQY8vc7OFmHhDMWvVk6Zl3uSd4VIZK1Wt1z2azq/E4Rfct8Nlq6oVyFBnSCllXh85Fmo6c+vtLgHP8d3YsHqFzU6z+MZrIvFX7BqDuimr7k0XizrNaIPeGJXnlJn87yre3h1drB8tnxeSHenKJTNLnrhadpCn4wOfbeHDO5Yetw5+wU29B5WxHqLYo6czAne1CIbO4lwevVmmv5Q/is1P2pxWJ4Gr9cbhOMs4Xl4h4vxa4YDzavkZBrhdPh/zoktxJ7e/MPVBF0Boz7XqD4afrSMcel34Pc2F4EP9Qt6ajD5bsCJ1qAl3mqeGd4t9J7+SMflBSBIuXGuyHIkx/t6cTz21R
 AOFIcgKU
 f59hHvobs90QuYk0wpBTegu8D53pCd4rfkj8YwR83SQbcp0MBh4FE/AXrSBVMX3gXkBX+3x53U2hXuPf4SoFTxwrjicFj9Yfy9Dd56SqM5DUu4s0d57KUOZ43ndvGbxkhvhDeJHnzoIbUcLW27lCsDANWvc0BYlP9ugpSRQQHxQ1geZD5tnBJHH6DNdW/pUm6qdae221oBj+0SlCeWkBR9vErpy/nwH3Jc47mY+WthI1PJZs8RdDQw/NqqVf9CU6sc3NDH9H8JKhzffgToRs4wFJovr21GVE+K8ck
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

drain_all_stock() sets FLUSHING_CACHED_CHARGE before calling
schedule_drain_work() to queue per-CPU drain work.  When the target
CPU is isolated (cpu_is_isolated() == true), the work is silently
not queued, but FLUSHING_CACHED_CHARGE stays set.  Every subsequent
drain_all_stock() then sees the bit and skips this stock entirely,
so the entry is effectively pinned until something else on that CPU
runs drain_local_*_stock() and clears the bit -- which on a long-
isolated CPU may never happen.

The original idea was to actually perform the drain from the calling
CPU on behalf of the isolated one, by adding a lock around the
per-CPU stock so that a remote drainer could safely touch it.  In
practice this turned out to be intrusive: the stock data structures
and their fast paths (consume_stock(), refill_stock(), the obj_stock
helpers) are deliberately designed around current-CPU-only access,
and retrofitting cross-CPU serialisation onto them adds non-trivial
locking and PREEMPT_RT concerns for very little gain.

Looking at the actual amount of charge that can accumulate in a
single per-CPU stock, it is bounded and small, so leaving an
isolated CPU's stock undrained for a while is not a real problem.
The only real bug is that the stuck FLUSHING_CACHED_CHARGE bit
prevents future drain_all_stock() callers from re-attempting once
the CPU is no longer isolated.

Fix this minimally by clearing FLUSHING_CACHED_CHARGE when the work
could not be queued because the target CPU is isolated.  The cached
charge itself is left in place; it will be released the next time
the CPU runs drain_local_*_stock() (e.g. after leaving isolation,
or if the isolated CPU itself calls drain_all_stock() -- in that
case cpu == curcpu causes drain_local_memcg_stock() to be invoked
directly), and the next drain_all_stock() call is free to retry
instead of skipping the stock forever.

Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
Changelog:
v2:
According to the comments of Waiman Long, updated fixes.

 mm/memcontrol.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c03d4787d466..8985334565a8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2228,7 +2228,8 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 	return flush;
 }
 
-static void schedule_drain_work(int cpu, struct work_struct *work)
+static void
+schedule_drain_work(int cpu, struct work_struct *work, unsigned long *flags)
 {
 	/*
 	 * Protect housekeeping cpumask read and work enqueue together
@@ -2236,9 +2237,22 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
 	 * partition update only need to wait for an RCU GP and flush the
 	 * pending work on newly isolated CPUs.
 	 */
-	guard(rcu)();
-	if (!cpu_is_isolated(cpu))
-		queue_work_on(cpu, memcg_wq, work);
+	scoped_guard(rcu) {
+		if (!cpu_is_isolated(cpu)) {
+			queue_work_on(cpu, memcg_wq, work);
+			return;
+		}
+	}
+
+	/*
+	 * The target CPU is isolated: the drain work was not queued.
+	 * Clear FLUSHING_CACHED_CHARGE so that future drain_all_stock()
+	 * callers can re-attempt instead of skipping this stock forever.
+	 * The cached charge is left in place; it will be released the
+	 * next time the CPU itself runs drain_local_*_stock() (e.g.
+	 * after leaving isolation), or by a follow-up mechanism.
+	 */
+	clear_bit(FLUSHING_CACHED_CHARGE, flags);
 }
 
 /*
@@ -2271,7 +2285,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 			if (cpu == curcpu)
 				drain_local_memcg_stock(&memcg_st->work);
 			else
-				schedule_drain_work(cpu, &memcg_st->work);
+				schedule_drain_work(cpu, &memcg_st->work,
+						    &memcg_st->flags);
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2281,7 +2296,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 			if (cpu == curcpu)
 				drain_local_obj_stock(&obj_st->work);
 			else
-				schedule_drain_work(cpu, &obj_st->work);
+				schedule_drain_work(cpu, &obj_st->work,
+						    &obj_st->flags);
 		}
 	}
 	migrate_enable();
-- 
2.43.0


