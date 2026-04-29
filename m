Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9373FF885A
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 02:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB1C36B00A9; Tue, 28 Apr 2026 22:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62BB6B00AB; Tue, 28 Apr 2026 22:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B51126B00AD; Tue, 28 Apr 2026 22:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A74DC6B00A9
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 22:28:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0A57A0584
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:28:20 +0000 (UTC)
X-FDA: 84710009160.27.5C76B1F
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf10.hostedemail.com (Postfix) with ESMTP id 37954C000B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:28:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DZONtexw;
	spf=pass (imf10.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777429699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=si4pob8Nbwk0h2k/iX2PC+8vOE1XCT4dxsoLSEJ3Y8M=;
	b=Jw35X5tnIc9eTCGIdvvG2WPWG3DHVqDsNuR/cOpFx5BxiaCawi+5ccbGz5YXUHcC3UOXWs
	U7dL8Y1sjJ1VIf9tRchlM+JiyXq14b7EloiB/ks0qLSwDF0vU2xKLcXdgZ80/jN+mmhSGs
	Rf9wXwUD5ki94ekQd30hWIdd4lm0CYE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777429699; a=rsa-sha256;
	cv=none;
	b=qxNfVwtBiseXHh6b0rotUZ6dfvy7uVjqyR2IRploiOCay5CRT4oCJTAYcF8Z76m4Q97hsM
	pyWzOIY/18cDUWHtZTJEZ73MyQ8Cgy7WefFogZBADC3cmn4e7HILRsp4evIFZAzLzEWRph
	6hi591Osa9NRyASmXwQqlV7RNxaVvPU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DZONtexw;
	spf=pass (imf10.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777429697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=si4pob8Nbwk0h2k/iX2PC+8vOE1XCT4dxsoLSEJ3Y8M=;
	b=DZONtexwMlI2LaWNMKw6eoGZkZFSghxVyjxai8XC9nPgC8Zb9wKsho0YvNiZM7nISvEL/l
	hQCJ0tstYaNkPFZcCD+aiycEKmt4GlfMswZCFfPAfVDZ923b/sVZixTss6FbzgAjyzpwIG
	NDzg4Cy8jOtvKQR08EOaCF9/45jRn6A=
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
	Frederic Weisbecker <frederic@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH] mm/memcontrol: Avoid stuck FLUSHING_CACHED_CHARGE on isolated CPU
Date: Wed, 29 Apr 2026 10:27:22 +0800
Message-ID: <20260429022723.133833-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 37954C000B
X-Stat-Signature: dg9mrhc5qm6spzj3p1nruttydze88551
X-Rspam-User: 
X-HE-Tag: 1777429698-394001
X-HE-Meta: U2FsdGVkX1+iKJOGUkuhdhM75R4z3eLFvt6yc1Wog7FE4YdsLJgXxl6vCGlxJ1kJWvNjodwMF5e6XUyF53O9lvECRfyAaRD5DZffuXENJ4HUPr6Z/KQGO5aY71RjfeRbpqqM3g/S13tkVn3QuPpYQQtAmIK+W+gkPQXwEMcSRFDIRkF7udxjIJ08jcpuYfhlA3G0in7TTaGZf8XkNvgSlqpLZLbaiyPhzd4kHdsA/tEX+JaTOP5WpndezSu9AHuBPPv+Jk/SM/j+Gg3meu4a9yonIyERflGHlQFc0ZV0yx433JPscyFyZ5UPRqooO2UbpNAjW8A2Xj2b3FegLf0FvQ7Pk/8K7TYoRlZgiPVAuWyPc2IvrLPG4QSsI8JedyCvzZDdjhXHlsMJkSN0NoAkPZQabDiWfMuibYCyWuXj2L3D/Q0cUvKPTuHe/qLRz4jpysvPfjVh5C0Xh70XMqZfrS0BD1vsGBOmcqoo87VTvqiZZuQacKHWV2SxeI/I9aMS1iJUEuVvLk82n41SstGEvtgkbMLXjJm59cb6aT0kkX9oZOGOMIu+0bCGpBedIJGRa+ahoHt4Xs897WqLfW+7ywUUnamfB3gq67wm7xdJwgla28+OjJ5z7F+SxTlxClmwukXUnPZhBFeNhImwLqiUKIKAqAr/K2H4DxG6+tbP9tLGNxLjKVqLV5/6Z+tkyC/LvnMzq9/NOPsrlKHIPaCE8ExhBGF0jOFUymsmNzccIO9IgriCnjpOYH61z1VSofiFqseCgpyNtFRybWkKqXiSyjciImgWDlq+XQtJ6imoCdyn5JFFcGY5sFCqtcqaGqjic1rgo/yR9TVdptChcMurw+mC7U6RRi7SYdDONT2i8qYiof7rZZw4sGRgb786sjnda3wb5Pvd/iOlA3MKC8T8LlsPlZZv5zOTq8K/nvFfEAEqfC6YxsUf0+tp3mzTyQF+epYRNaW4BEaYxZ5lkER
 5LEIVE1e
 hTai6cBVB60B59JRzT1BBECEDYnEcJLZ3TceD97s4R2qBCq4tBC3gZHYCdPJqRDfmW5hBLHPI3Zfbe5AD5Y2scDoTHFh7oMp1jCsriMfQIoMPSTUMYLJOn3vCONI72aktGs94piTM2Yl6akj8+Y//Gdmcy3P6y7Jnhe4m3nPcHkkA4sSahjBCzST6ZkjBVwbEtwL0uCziEmujWkSuWA77Ss1v0vGTKZ6wcPDEFho73K3DjM2oITbyw/NDwg==
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

Fixes: 2d05068610a3 ("memcg: Prepare to protect against concurrent isolated cpuset change")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/memcontrol.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3d98ab41f1f..cee77b0a95f5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2219,7 +2219,8 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 	return flush;
 }
 
-static void schedule_drain_work(int cpu, struct work_struct *work)
+static void
+schedule_drain_work(int cpu, struct work_struct *work, unsigned long *flags)
 {
 	/*
 	 * Protect housekeeping cpumask read and work enqueue together
@@ -2227,9 +2228,22 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
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
@@ -2262,7 +2276,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 			if (cpu == curcpu)
 				drain_local_memcg_stock(&memcg_st->work);
 			else
-				schedule_drain_work(cpu, &memcg_st->work);
+				schedule_drain_work(cpu, &memcg_st->work,
+						    &memcg_st->flags);
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2272,7 +2287,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
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


