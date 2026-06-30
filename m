Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF33C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 731116B00AE; Tue, 30 Jun 2026 03:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2F76B00AF; Tue, 30 Jun 2026 03:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1546B00B0; Tue, 30 Jun 2026 03:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 333F96B00AE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:00:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F8C91203E4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:00:23 +0000 (UTC)
X-FDA: 84935680326.30.1C8C5E8
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id ABBA1A0004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:00:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cPXxk3yC;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782802822;
	b=fct6o/fUSo2BCSOsdik/WiKSJ8MsDu8//ziSXpCGyfDXQkM3VLtqtcxQm5579zA8J8NP/P
	ygWZpwWaKsABvtQrAwG0d+yXEGcAvVYZabzc8isHB9kQknQ1HPlKqKAVHJKaHyzpbdmnnE
	Za0/LPU+YtxztQn+htTJWXYUTrfGdt8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782802822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yRc15okIcuMzadoX86qxhT9vGGbP9472K9XPn91BZag=;
	b=riqwHAiIrpixujEkWmbc0FD0PoFYuIM4JtyzgQ7Zmpog88eX5UbNHEFzXq57SYnokgGpPK
	gAtWj9vHOaIKaRisduxBbd0FxhBmI2lxhZiEwgr7ABWLOrHXoC431UykvyUcsQw7GIOndY
	2X/zkN1l358lCShnlH5O0rNsDA3Vi4k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cPXxk3yC;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782802819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yRc15okIcuMzadoX86qxhT9vGGbP9472K9XPn91BZag=;
	b=cPXxk3yCuGb+JXOZx/gUvQc1NXw+z2SjcVl9btWHVr/vmR1Brk0BGzzYfKf+uh8g0aWNGB
	qb0QbZURpU0XDZhwKH1AGMgOTgR610IYPoieOSjk/0LdQm46x9RJaoWbYh9xP0n9eqgTBK
	pffv9TqiRrEqiATfwOyVISNeFFf4BHk=
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
Subject: [RESEND PATCH v2] mm/memcontrol: Avoid stuck FLUSHING_CACHED_CHARGE on isolated CPU
Date: Tue, 30 Jun 2026 15:00:04 +0800
Message-ID: <20260630070004.470181-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: kh5tkqaf5tj9uzjn3yiy696u78kw917w
X-Rspamd-Queue-Id: ABBA1A0004
X-Rspamd-Server: rspam06
X-HE-Tag: 1782802821-453212
X-HE-Meta: U2FsdGVkX183rhW5HzmE08b5fpawkpDgbMLR6xGfR3CJOR8GxCh3txfr46IkRUvH67/zEs4ihFHlvJYqSGIGxE0iQa54ofI38KgWECukRXIupUmeQREDaSqQgVTcL6szR3u93idI6PqzSZ2wTxDS+hAwSMrTZWUlE/dwK6/T3HeCLHDzJ1QPHO0B8oIAotAwyDUZeA5z8mcCN30mgcgcf6x3HN6DxBBQUHCi0wc1ozDhtizAMsr3vJ/3bQMqPpBM8iI7b00rQkXGUd08VJFBo5+eBgaa/Aigay7COX5Iuf48gpE8f42reVsz0/crECLjzukpBxKKaLEvQEXAbLgTXP0Jx6dRH9P0pe8QefrZWRHo6pUHp+YJqEPLLSo1rWB3VUwxWkOvfLOIGySI0O4SMN3Z3dZ2RO3SFsf+HH6vsFa+IXnqA50YKJONIHhk0ElKStA+u7YR2CZdZ/1NUQ/2xNRf8oiJycwTvnF+LhXQX7CsLREl7QPD6Llw3lt97Ld4yzMNzSWmaZSqoPWMxgqnbLr0e14leobeAxQ5Qf/J5zRjm5kUzDDKEV/3MvH5LOYSBblk2GxrWZDSnKgzoka/HJ279HIln7gAQCXveClisyW2joMV/tmNfj7PZGj6YW6ROwgOSYWuuP3uc3rPiD4fu4VO0inbJF6Ji1a/lshGPIlJP4oB0vvtqq22L7TroRhJVP8saW6ko3B+l4b0cnQG++AKDrrdzScebUbAdqABjdsIzyjAqqHS9dfd5lmfs7TACih82d+Ccs3eZR/OhiTcpw/Yp/T/8usyGXfLH7oXQKdWlbYy4fWDfJR0tPMr6q9+jafksebuMaokFvx0H1ZpGYZQBk1i6JdHVH7Y6p0fFjEtBi8hcLe9pFv02qogajyGBR1piGlJ60CKXlL979OH6ClWG5z7b5aCPZoEvj3edeqg99FBuCvBA5CgHIC+BaVH0DCh5pE8tcJEyZgs2IH
 R3ohIS6w
 j8eskpRey1K/Sw48AUyoU1+R1gUYW2nr2+1zXnbEpqfauoWmd8rXzN9LxH8yqeGlX+P6W/UbKDc+suZ5Txm9s0DJdr19+Q2plV0boEydMQJkEcyjYjOnDm3v2rPKgjCmXiJXzb9LNcWYUmmqYyNzxpZ6Rs6t5xWGye8W5qCypmQT9Rab6b3fD5ajNvzs27h0eKpfu1M6KYMzEck8QT3QE7mEAlFZDJL4k23zNrviM3ykL5/80cxZpC+5EIg==
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
index 6dc4888a90f3..2e66b4a2c25d 100644
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
@@ -2264,9 +2265,22 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
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


