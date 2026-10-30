Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7614B606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 20:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AOktx0lr
Received: by kanga.kvack.org (Postfix)
	id 8376C6B05B7; Fri, 30 Oct 2026 16:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D91A6B05B8; Fri, 30 Oct 2026 16:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 616AD6B05B9; Fri, 30 Oct 2026 16:54:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 310EC6B05B7
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:54:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A3FAF120836
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:54:51 +0000 (UTC)
X-FDA: 85380496782.04.E4141CE
Received: from mta0.migadu.com (out-82.mta0.migadu.com [91.218.175.82])
	by imf08.hostedemail.com (Postfix) with ESMTP id B542116000C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:54:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AOktx0lr;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793393689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QjkNy7pHlfB3P9tWyxFaR8qT3ODyo1OuuBCXAHPu1yc=;
	b=4IGURBltsaUz16ppRCzTj5XtMmxum7bzeuFEpbqCHEh7qzOvnxH9lX5ERmqx+rmxEOU3aE
	JhDU5vkiokdQBUBLc6MTrDh9FEuUeNm/p3CTmFHB1EjboSYnhclMe2Ul5ZK3zyIwEPBlY6
	WhpNd+3cCu4Io1AfK6NFRZn6TvCU7+E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AOktx0lr;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793393689;
	b=DknopRl1Xikdoq3ypsdCcFPeiOG783h62ljPd1p4kM0IyfVEKN9jUDkhznMGpRP0Zsv5u5
	vv2hoomc4c0OUKpQw/PYHdnDENSlncX0iW7jgn+NGo4/oI7x5ZRx/eeAWfrb+rzEhAw7vW
	uN9f6HgP+RFqNDN0oEbqQkP0c6oF1Dw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3BkmFCjzJBJtvnj6/69mPrvSFoGbhkTNbA1/fZOdMOM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793393688; v=1; x=1793998488;
 b=AOktx0lrjEMar6tvlUKD0v+nU1xUxaXNnedHY8hMmXK/Hn5bgP8EgiAGXQR3XGrqbSi5iM5/
 F3K52gY6aLR5/3vlmU2H0EZqNSLT0QT7PANgh74OIViWn0liGowjTq74upTbq0GrH1AUNDHg68x
 NaopYG1E/4qc8/z1EnuYLdJI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 243d3ea72e8617f1;
	Fri, 30 Oct 2026 20:54:48 +0000
X-Mizu-Trace-ID: 243d3ea72e8617f1
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v2 5/5] memcg: simplify high limit handling after a charge
Date: Fri, 30 Oct 2026 13:54:16 -0700
Message-ID: <20261030205418.341214-6-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261030205418.341214-1-shakeel.butt@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B542116000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: b88icrruf4468z3zmyrua1hgd8zi8smg
X-HE-Tag: 1793393689-394372
X-HE-Meta: U2FsdGVkX19Ch5CoURSDu9elOecSVypUOQWB5OT3Yzn0HVOvrE2VJIkIdEpYG8iiHRmB3hY2cmie0oEs2pdAysYzrLrfeKhQ669GqJ76BeeS0lA1f1REzwqB0OlllhjhS39o533rE+7afPBP8bznUGwSf1XRDWsSDyCnIb8j4CwtpH23frqA/6fO0nHbqcpifT4ZGMkDFOSEzj7CFNSsi7N7No6vyCz1jb4Vrojft1mstr6NMbYqkyI0wqoS2GAl4l73aMwh1eP5zumQRT7EXNLX5vpzV33ezQJX9aAZt6lWj+e3HL+hzRi+FHPXrnWrymM1eGZufqsJ7ay3F/BUCF1ADkglNTWHejQoN2+iVXuS6j7KGYfAaeKclXijWlLmg185YvSdTdnJC8D1mI6RNu4rhx7WhoTnCvUiY6nxAZV/eiU/kfnzhGtAdLwkNk3wWPwUXF7Pe0F+yTER0BPbbczIFNARZ2u0+B3qaoORaj77/AS3d7ZLALPiiVQy94emk/tbY2P3mw7f1Zk9HCe2vp3qZODbTXj3A0B79Tq1uD9yyxD8M5D+gtMpLv/Tom5/SvrjhLM5REQcwdl74PQh0ERRiW2OxI5w3VXy5039gWRs4YfEaWGB1Jh5TlGIBd+fUixeX/X2Zb2+iEo8L+QLH4s2IF+KfOoiGy2A0/ahj3x6TgPxpjAuEVvw3u3uyod1eLJOcjFHDzM8nwiFeHxVinNwb66ucYcKrjdq3IfECmBRBG6TxhVanKKpJ+sKnUAtOtLrvt5P4RtNCLniSUjD3ZLBJWw/iGhIcACOfsTQotp7F7BzEfrbId7hboXjX3KawJ+JGlOZoRee8xmvKnRSLfcwvtEwbAMNts5uy8hhxUskTLsHKoLq86NOdVti4torlaxJcU/enG2K93sBwf/FQBAa2aD9nJzY8QsGeJxvxcf6WQL8Iyz9or8Wu5lbUS0XhPjdzWhQTISGcWPajg/
 Y1I7P6yd
 ah04vskhzEEKThGUXniUY994pegnfzLucQhhKc1Myab2kHGLuvQs+3dxg+K8wBq0RqXp7oriU6x9b9vru+AkCJZaKhH3QRxQ28Q8yVCAsy4r9tJG3GYErpPx1FwgX2qzYFP2iHg/cWE2j9eX2sO7Lk48i3V5PJfQl+eEAjScendIhpl2Bpjaof7O1OO8F7oDqAjp3xPP3bNcyIoSNZSs/umWJNqgvX0mGK2/XdvJWLDo3M7xoHsBgoNAN9EZdv24EQwoN+siHgyImvusDiStcNCaxO5ubkfzDdPRO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Separate the hierarchy scan from high-limit enforcement. Find the first
cgroup over the applicable limit, then queue high_work or record the
task's overage after the scan. Worker contexts check only memory.high;
local charges also check memory.swap.high.

Clarify the enforcement comments. Keep the synchronous pending-overage
check independent of the scan result so a blocking charge still handles
overage left by earlier charges.

No functional change intended.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/memcontrol.c | 102 +++++++++++++++++++++---------------------------
 1 file changed, 45 insertions(+), 57 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e8d9c001b6ce..f3b69d4fa248 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2605,9 +2605,8 @@ static unsigned long calculate_high_delay(unsigned int nr_pages,
 }
 
 /*
- * Reclaims memory over the high limit. Called directly from
- * try_charge() (context permitting), as well as from the userland
- * return path where reclaim is always able to block.
+ * Handle pending high overage during a blocking charge or on return
+ * to userspace.
  */
 void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
@@ -2701,76 +2700,65 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 
 /*
  * Called after @nr_pages were charged to @memcg. If @memcg or one of its
- * ancestors is over memory.high or memory.swap.high, start reclaim or slow
- * down the task.
+ * ancestors is over its high limit, either queue high_work to reclaim from
+ * that cgroup, or record the overage so the charging task reclaims later
+ * and sleeps if reclaim can't keep up. high_work only handles memory.high;
+ * memory.swap.high is only enforced on the charging task.
  */
 static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 			       gfp_t gfp_mask)
 {
+	struct mem_cgroup *iter;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
-	bool use_worker = !in_task() || (current->flags & PF_KTHREAD) ||
+	bool use_high_work = !in_task() || (current->flags & PF_KTHREAD) ||
 		!current->mm || !mm_match_cgroup(current->mm, memcg);
 
 	/*
-	 * If the hierarchy is above the normal consumption range, schedule
-	 * reclaim on returning to userland.  We can perform reclaim here
-	 * if __GFP_RECLAIM but let's always punt for simplicity and so that
-	 * GFP_KERNEL can consistently be used during reclaim.  @memcg is
-	 * not recorded as it most likely matches current's and won't
-	 * change in the meantime.  As high limit is checked again before
-	 * reclaim, the cost of mismatch is negligible.
+	 * Check the charged cgroup and its parents. Local charges normally defer
+	 * reclaim until return to userspace so it can use GFP_KERNEL. Large
+	 * pending overages may be handled synchronously below. The handler looks
+	 * up current->mm and rechecks the limits. If the task moved to another
+	 * cgroup in the meantime, the handler works on the new cgroup instead.
+	 * That is rare and costs little.
 	 */
-	do {
+	for (iter = memcg; iter; iter = parent_mem_cgroup(iter)) {
 		bool mem_high, swap_high;
 
-		mem_high = page_counter_read(&memcg->memory) >
-			READ_ONCE(memcg->memory.high);
-		swap_high = page_counter_read(&memcg->swap) >
-			READ_ONCE(memcg->swap.high);
-
-		/*
-		 * Don't make an unrelated interrupted task handle this charge.
-		 * Kernel threads may be working for other tasks, so let a worker
-		 * reclaim instead.
-		 * Remote charges need reclaim from their charged hierarchy.
-		 */
-		if (use_worker) {
-			if (mem_high) {
-				if (allow_spinning)
-					schedule_work(&memcg->high_work);
-				else
-					irq_work_queue(&memcg->high_irq_work);
-				break;
-			}
-			continue;
-		}
-
-		if (mem_high || swap_high) {
-			/*
-			 * The allocating tasks in this cgroup will need to do
-			 * reclaim or be throttled to prevent further growth
-			 * of the memory or swap footprints.
-			 *
-			 * Target some best-effort fairness between the tasks,
-			 * and distribute reclaim work and delay penalties
-			 * based on how much each task is actually allocating.
-			 */
-			current->memcg_nr_pages_over_high += nr_pages;
-			set_notify_resume(current);
+		mem_high = page_counter_read(&iter->memory) >
+			READ_ONCE(iter->memory.high);
+		swap_high = !use_high_work &&
+			(page_counter_read(&iter->swap) > READ_ONCE(iter->swap.high));
+		if (mem_high || swap_high)
 			break;
-		}
-	} while ((memcg = parent_mem_cgroup(memcg)));
+	}
 
-	/* Interrupts, kernel threads, and remote chargers stop here. */
-	if (use_worker)
+	/*
+	 * Use a worker for interrupts, kernel threads, and tasks whose mm
+	 * does not match the charged hierarchy.
+	 */
+	if (use_high_work) {
+		if (!iter)
+			return;
+		if (allow_spinning)
+			schedule_work(&iter->high_work);
+		else
+			irq_work_queue(&iter->high_irq_work);
 		return;
+	}
+
+	if (iter) {
+		/*
+		 * Count the full batch so reclaim work and delay penalties scale
+		 * with the pages charged by this task.
+		 */
+		current->memcg_nr_pages_over_high += nr_pages;
+		set_notify_resume(current);
+	}
 
 	/*
-	 * Reclaim is set up above to be called from the userland
-	 * return path. But also attempt synchronous reclaim to avoid
-	 * excessive overrun while the task is still inside the
-	 * kernel. If this is successful, the return path will see it
-	 * when it rechecks the overage and simply bail out.
+	 * Earlier charges may have left high overage pending even if this charge
+	 * found no new overage. Handle it now if this charge can block, to limit
+	 * overrun while the task remains in the kernel.
 	 */
 	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
 	    gfpflags_allow_blocking(gfp_mask))
-- 
2.53.0-Meta


