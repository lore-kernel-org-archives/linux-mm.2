Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C222C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A71586B009B; Thu, 27 Aug 2026 12:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A498C6B00A1; Thu, 27 Aug 2026 12:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986296B00A4; Thu, 27 Aug 2026 12:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 785166B009B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:42:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C596C010F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:42:47 +0000 (UTC)
X-FDA: 85147618374.03.92BE449
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf24.hostedemail.com (Postfix) with ESMTP id D96A6180010
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:42:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Dc mKzu2";
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787848965;
	b=NSkuro+f8fENFMfKe/QQUBpGw7AIl5DFvjKtLyfUvFffLjVD7YpYT/alE+vHkhkKVNCBcd
	95JMsiNA4kPgSrQrwMzt9qE5FZ96A49Lp7ft7dskOefn+kyAYF0ObgJ1Q1NVrNo/UU3DtF
	R7x9J6LB8KJqhYWNi+3W2cXjt/x5uhM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Dc mKzu2";
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787848965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3r/alrbSbcVmDatS8Yh9hNLCfL/BVX8bJGJSCiSzcPg=;
	b=mZZh8KQP1HCOby4EzVVYHC0TAS6u1tas9JWm7NlMv3Iikuf7QDKXDRJtyu5luZDfROhFua
	NNNEWJbkmJ0NAVC5BZqU8R9SNt1W5F3WLZcvPmkOsPnqDbvTE3ufC8kixdznXT2E6n7Cbr
	XTEuq43MSn6HqIbL2dHZOnhh4e/hEfM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References; bh=3r/alrbSbcVmDatS8Yh9hNLCfL/BVX8bJGJSCiSzcPg=; b=Dc
	mKzu2FNueMOxSYiKI89DPfchGUJmy9iwaoBVeiAj3DvfSeoFn2oEavdggGjDyqrE1a8f5DYno00aF
	07dLgEFc5wvJtHBtxIQZ+XMHO6Vo/fKfzt17XNmE/lNClqj6W8R2qMw4W2z6UxSKQ3S2L8WSp5RdQ
	WKjhKLchv7M1b0g4735lU/jlrBLcTIfQImVHBERJ+6823tkbAU444TBpIyMlfRbXClFyKH3z7natj
	hmclMiWBQjm9Kvn0dtye9BihnT90canw3RgRqymfN3CIYvR0wvr6VAaTSUAvlHVD7K65W0wzjEfqQ
	OuauJUryyfXq7nGucxui4mfjkEH8sicQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wzdB6-00000008X7x-2KC2;
	Thu, 27 Aug 2026 16:42:12 +0000
Date: Thu, 27 Aug 2026 12:42:11 -0400
From: Rik van Riel <riel@surriel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Muchun
 Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: [PATCH] mm/memcg: fix UAF in drain_all_stock() async work during
 offline
Message-ID: <20260827124211.3b94b103@fangorn>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D96A6180010
X-Stat-Signature: ruegtk5eg4udqsp69ry5hssaqhu1f7ms
X-Rspam-User: 
X-HE-Tag: 1787848963-574283
X-HE-Meta: U2FsdGVkX1/afyPXs75nNCs2T7KWOMH4CIxB7dDXsHIKI9Nkfel8CiKIj05KOxnSdQsXw6MroCXir9y5mywTmpeciWp6buLGhpjPJU+IdD3PsH6Y7Ox5JwRQES4Kde8O8+LNRnyNwIo8tD9cjuSOBhsK8nP85hcS/k7XhoQv8OJ1Zmkbhu68eeLze5v0s6utqtgA+VT6Ucs7x2Cux89KzR5IVt86cA4tzK/AN++qFeolFi0h5OwZEe0qkH4qKlZ9f687dsWll646Y0jaiHuCcKz/AipHISKuMEZzpfWQBGZQHCp5A15McgeN8Fdbcz7Nq1rZegH4n415vZ1T6lFEI6V46riUUlqzTFK3IzqNUReQR7NpV3s06ItiE0RnUiRcH6Vp1fF1K1cRG/VoE9ES0FUgpmL75597uCGAjQbPLOtNSfwsATR9e4BvX34dH1fY0+MTvI6BIM6uzczKnHpP1MVW8sWEKX2dMiaH8PtaTNp3pqrDh2LqAyQ1j0xIlQrFfkB15wupoiJuEod28POiGfhZfy2vp2ZiiKBif1T4Ai1dgEeSE8RRDRi0g2GjVcSVVUNQf19foDUOrtdKyimZJqtf8/03ccGcZESetQROxlQXAml1tlrRLorPcmPCIP7jHwoBjNn9mPt5FyjIExIWBLwsLXYJNvq4xxMFjH7QnH5/KM6VaA/x4wY8SxMzu2vTT/SJRW9d/QFVNMhVz8DXcsJWTqCxxmBEV5BGNxSUmjNDPKeKIr/vBWTHO33v6MqPymSAdp0Nz6CIbnAgI/NRYD7dmpe4DAKtHCHb5qZBD6npxn9JX4QQubJcnwfVNUd4HA3A4WXYCc5WrVB5DD5Z5JVpB1GLkE/gQx5NLRQeLArFSyu5S2OAX7098WKvY12q/+aJ8kotnspzGby+NFFB0tl08BfnNooTnc1WX2FyMliqITOhwpiw3yml9A1/c7CfamfT7YSnd0ziGGOIPOG
 p36l+GZ2
 VsFhKYSF2+vHX2B9KDNn92b99yDwaDF9ASJfhmCB/+4Bdg7X7si0+E9Jo0Ct1kzaFo7NWHAvw2paeSHOWI+3s3lIurwKYuzqAXdrD/P8fA9yTzC5YaaAdyNAMd53vKr5XNzN1vq2r+oZZCVYlhkfrw9G3zoZ87/BnAA4YYP2keNYpLGO1YMvoDpBP9MKULsnADfzMGiXIaXkq5V4mlJCYMCL3fh2ht/4KlepBVBHPF0dM/Osjmq0HhZ++2rOpi5qvmFd2HTKIR3JYKzEawvkTzNttgmopx4a2tpp5mqZ10Nw4b1JmjZ2JOwreu1RAzikruFGpQF14q51rtXaZSpxAGbIAyVlTgZ8C36HvA03jhmf6XwTuYAAn6B+QEcxC5s+rDfY2DtQIhc6PsHWRdhGu4bv4eA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drain_all_stock() queues drain work on remote CPUs via
schedule_drain_work() -> queue_work_on(memcg_wq) and returns
immediately without waiting. The worker, drain_local_memcg_stock()
/ drain_local_obj_stock(), dereferences per-CPU stock caches with
READ_ONCE(stock->cached[i]) and does css_put() / obj_cgroup_put().

mem_cgroup_css_offline() calls drain_all_stock(memcg) to
optimize reclamation latency, but never flushes memcg_wq. If
that races with cgroup removal, free can happen while workers
are still pending, causing UAF. The drain work could also have
been queued by somebody else before offline started (e.g. high
throttling), not just by the offline path itself.

Timeline illustrating the race:

  CPU0 (rmdir + offline)                CPU1 (charge cache holder)
  -------------------------             ----------------------------
  cgroup_rmdir()
    cgroup_destroy_locked()
      kill_css_sync()
      ...

                                      refill_stock(victim)
                                        css_get(victim)
                                        WRITE_ONCE(cached[i]=victim)

  percpu_ref kill confirmed, css_killed_ref_fn() called

  css_killed_work_fn() [offline_wq]
    mem_cgroup_css_offline(victim)
      drain_all_stock(victim)
        is_memcg_drain_needed()
          READ_ONCE(cached) -> victim
        queue_work_on(CPU1, memcg_wq, work)
        // no flush!
      mem_cgroup_private_id_put()
    css_put() -> refcnt may hit 0

  [RCU GP]
  css_free_rwork_fn()
    mem_cgroup_free(victim)
    // victim struct freed

                                        // worker delayed by scheduler/
                                        // WQ concurrency
                                        drain_local_memcg_stock()
                                          old = READ_ONCE(cached[i])
                                          // UAF: old == freed victim
                                          memcg_uncharge(old)
                                          css_put(&old->css)

Fix by having the offline path wait for the workqueue to be
done with the memcg, before freeing the memcg.

Found through a code audit with kres.

Fixes: 591edfb10a94 ("mm: drain memcg stocks on css offlining")
Cc: stable@vger.kernel.org
Assisted-by: Hermes:muse-spark-1.2 kres
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/memcontrol.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..c95a1f6ec799 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2273,12 +2273,18 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
  */
-void drain_all_stock(struct mem_cgroup *root_memcg)
+static void __drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
 {
 	int cpu, curcpu;
 
-	/* If someone's already draining, avoid adding running more workers. */
-	if (!mutex_trylock(&percpu_charge_mutex))
+	/*
+	 *  If someone's already draining, avoid starting more workers.
+	 *  Synchronous callers need to guarantee all the last things
+	 *  are flushed, e.g. before a memcg is removed.
+	 */
+	if (sync)
+		mutex_lock(&percpu_charge_mutex);
+	else if (!mutex_trylock(&percpu_charge_mutex))
 		return;
 	/*
 	 * Notify other cpus that system-wide "drain" is running
@@ -2316,6 +2322,21 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 	mutex_unlock(&percpu_charge_mutex);
 }
 
+void drain_all_stock(struct mem_cgroup *root_memcg)
+{
+	__drain_all_stock(root_memcg, false);
+}
+
+void drain_all_stock_sync(struct mem_cgroup *root_memcg)
+{
+	/*
+	 * Make sure the workqueue is done with this memcg
+	 * before freeing it.
+	 */
+	__drain_all_stock(root_memcg, true);
+	flush_workqueue(memcg_wq);
+}
+
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
 	/* no need for the local lock */
@@ -4305,7 +4326,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	wb_memcg_offline(memcg);
 	lru_gen_offline_memcg(memcg);
 
-	drain_all_stock(memcg);
+	drain_all_stock_sync(memcg);
 
 	mem_cgroup_private_id_put(memcg, 1);
 }
-- 
2.55.0



