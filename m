Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43C91C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 02:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F36376B00A6; Tue, 30 Jun 2026 22:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0DC96B00A8; Tue, 30 Jun 2026 22:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22EC6B00A9; Tue, 30 Jun 2026 22:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B98E96B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:40:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE5C61C0E4C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:40:30 +0000 (UTC)
X-FDA: 84938654220.25.99D3A34
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id A82B31C0005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:40:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jU53toVP;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782873629;
	b=At+Z+WTTwNar6R1F+nWQIJjOH4yxM/cOW/fw+o+nlPNKgO2kVQD5DedX/0IZaqXHuaQ8S1
	wTTQQK3lyaaZBXRVEI4AVUO8vsQwygHNbXQAXgpBNO/OD5Yjk0+sim++32BiHhqKhmPxGm
	q/Lar/NoJ0/TsYQUkgaqYltqZyMh9cU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782873629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zOd8DSH7cMYtJD/+/URsy/IxwgqSz9ZSG2fyMnhSXak=;
	b=cPN3B8+T4cx6penDPZpIAWpsthSPy++SwuqoqaOmjgZrlCRprbgk/JKZgbkRP9DH5FJUrS
	wRcxe069B1OsuoC/TZCPyDzKcqtfKVWmCWNxx9+re/labv8jzNucTTTdiNyHTb1Jn8PIrX
	AfATPyDVbGRBheJY7mGLN6TwMvJP004=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jU53toVP;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782873624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zOd8DSH7cMYtJD/+/URsy/IxwgqSz9ZSG2fyMnhSXak=;
	b=jU53toVPumrS9P5nkr8lgqCFP3On/pZhU6agZrcXkfqKCJkvxOKtlYu/72jObB/OC9jhqZ
	BjXP02wTgs93xHsY/ptW+JuOjrGzS92mQSLkYBuLjiSIiHoqCZZ4dDkxjAAWaKx2pd52T/
	3ULYc9iXvhPdt7Auvx4hQY9Ul009zSM=
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
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v3] mm/memcontrol: Avoid stuck FLUSHING_CACHED_CHARGE on isolated CPU
Date: Wed,  1 Jul 2026 10:40:10 +0800
Message-ID: <20260701024010.564830-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A82B31C0005
X-Rspam-User: 
X-Stat-Signature: zcgb5398nuittyjgpm4xue3uifz9gxpg
X-HE-Tag: 1782873626-883741
X-HE-Meta: U2FsdGVkX1/H4OjuvdjSWnZhvWbbWlNneNxwFHGaaXmvVCepiHrjc1rGp4FZgLJkmIaPvVkefTivBMLTsGbkfcZQMA7kaQn//GQ04SMc210wnUn4QZ22tqutLMAp+rb6JHF5dyxu0H/cqczPlI2gra44ceu8TBYJin28x7uQHQZpku2q9sX/FEgMoLCRNHnp1AT2LfO878+kkLB2JB5iu6ukixEIfoNVozTdhRG8bmPLoiAGD3io1vTzVG3hIDmt8ljNEaqaJecsKs8dmFzIVBwhKc2Xyh5xcACGeoWzllzFgSt+fFW1od5+18dxWDpuS0gmlQNUBZCQyjnwj5jbB7F6c9VSgLoWAMO14iBTKmWEtYjzJKolFFe1+3uU71I06/1ldDbM4dk+4VjMSqQRtX3Kuk/lr+rAe8G0IqzFEOi1brsjSWp0040BFN8bvfOwAEOX/YZi58FiQwUbfC+yyl35jOOZmhsmVPQE/lwwTSQDfAkYG2zVM9PEAfczrEiCJtvhIUV2prIC/tMllRxxQdNjaEtmkTVnnXxnfont/QywD+KCVdxS/zuwhwwf76vfk2q0DaZj1uXQZPI9jjuBfCoLJwHYb6AHWz4fD5Uhx7EyjgicIfuzQf6JBtFXvo5AvBFiOA2/Aj9gNvUdCuSjnrFaNuDrzZJO6qz1yx9oX6rmkF54CpRUUL8RAVw7+fBXi/SYxGDZMhTPrIWyBIKhqfF/axpg14yprRbqfUEfA8ibZCVlGWNsqSzGY1Dq0gIc/egCLaHSGpYn/mL/34Lj0yKKcsCsl5A83EysXrEviAvNqXUBu33iyE95hfW13qAv6BHFqqWMvOWF40CgEUbNH0HeluRyP2CtpQWkIIiDcy8X/8uiBEbWhEahUCoKKG7zpHI6DYLN6D9ndvRYyJswrzBmFjfhF6dH1PZuff/GqWr9YBn88Kr+Fka91z1f6Y+yy0qb5a15q0qGwKtp4tz
 C7+shWL0
 KJZVpvzwDKZqwZUkv8cC8CgLoncQLWwrb3E/1oYyM4opwad7cAtjUw/8p/hPAw05ybT9R+gQpPF2rSWSCRwq0WPsYtc69Eo1ove0z1w7MyR2UL8l+RTyyplfx6kJcZJnP06jtS9B50/ux9w7PXmpnaKad1NlbQyh7m/8hQ+oEtIieaprsWFj22ocsETHtm9zhauRbHx3toNMgE0vsu60VqKjSBJyfmKktjIAkGw42P+jxRdvarJFqfZ8tpA==
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
v3:
According to the comments of Shakeel Butt, keep the whole
schedule_drain_work() body under a single guard(rcu)() instead of
splitting it with scoped_guard(rcu){}.
v2:
According to the comments of Waiman Long, updated fixes.

 mm/memcontrol.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..42a0d0d6284a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2256,7 +2256,8 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 	return flush;
 }
 
-static void schedule_drain_work(int cpu, struct work_struct *work)
+static void
+schedule_drain_work(int cpu, struct work_struct *work, unsigned long *flags)
 {
 	/*
 	 * Protect housekeeping cpumask read and work enqueue together
@@ -2265,8 +2266,21 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
 	 * pending work on newly isolated CPUs.
 	 */
 	guard(rcu)();
-	if (!cpu_is_isolated(cpu))
-		queue_work_on(cpu, memcg_wq, work);
+	if (cpu_is_isolated(cpu)) {
+		/*
+		 * The target CPU is isolated: the drain work was not
+		 * queued. Clear FLUSHING_CACHED_CHARGE so a future
+		 * drain_all_stock() call can retry instead of skipping
+		 * this stock forever.
+		 *
+		 * The cached charge itself is left untouched here; it
+		 * will be drained the next time drain_local_stock() runs
+		 * on this CPU (e.g. after it leaves isolation).
+		 */
+		clear_bit(FLUSHING_CACHED_CHARGE, flags);
+		return;
+	}
+	queue_work_on(cpu, memcg_wq, work);
 }
 
 /*
@@ -2299,7 +2313,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 			if (cpu == curcpu)
 				drain_local_memcg_stock(&memcg_st->work);
 			else
-				schedule_drain_work(cpu, &memcg_st->work);
+				schedule_drain_work(cpu, &memcg_st->work,
+						    &memcg_st->flags);
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2309,7 +2324,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
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


