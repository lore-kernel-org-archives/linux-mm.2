Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F941CA9EC5
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 21:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69F3D6B0099; Sat, 10 Oct 2026 17:10:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650876B009B; Sat, 10 Oct 2026 17:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 516E06B009D; Sat, 10 Oct 2026 17:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 301296B009B
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 17:10:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0E3316060D
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:10:34 +0000 (UTC)
X-FDA: 85307960388.01.B38E976
Received: from mta0.migadu.com (out-203.mta0.migadu.com [91.218.175.203])
	by imf25.hostedemail.com (Postfix) with ESMTP id B1377A0005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:10:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aH1NCR1d;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.203 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791666632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0M4DQ1i+uVYURqdu8/Vp1vb9L/UdrzyPEMmBVSW5HoA=;
	b=fBDksrQKrU0O4VzaHzQ5PYPaNmFkbePBfVEJxvtY549yu8LP8Ur9phbjRCLT4rTQKSHN3n
	mUJDWY1GxPgKrxI0EzJJyuzOQJbDzDxfVxsgUslZWkDJwVAco0OIkBdYJ7tUsD+DwYhtlP
	F3CDfQ8WDiOZVcHNr4iNlEgoQJbIlwA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aH1NCR1d;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.203 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791666632;
	b=UjwY1UnWasNc3cKhj+FI5y/M1TFLWLUzZo1kyuEq3OO7jygowIk4m7x69n5awrK8gxnFnB
	8hNM7/qp7WcmcAyRFeUwdRH7GfejY+Ea4uFNrrmIr+STnCMYr13vHXMIv1dvj0uYiggd0C
	2vdAFP5+2lQJsPlkf44zWXTx/SEuCyk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3hqX3BARmjWtAQ46OvzECobezGOVuBR47j+5rD5PZIo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791666631; v=1; x=1792271431;
 b=aH1NCR1dMaFgP7EOlDMiGX6daB+ScA4bILjgQ9I8YJfm87SX3DCWjztZEU35hF3slmfXfmS4
 f+RiiIHYwWPW9D42UA0uOKSiVhV92tB518YKTVkWLcgK92uzNXeumEAeEM6ziJIh68AiHUT/bsI
 8OGtWTAaTQfQlGizT66Dvvzc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4cd0ae48d6d3e480;
	Sat, 10 Oct 2026 21:10:31 +0000
X-Mizu-Trace-ID: 4cd0ae48d6d3e480
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
Subject: [PATCH for-7.5 5/5] memcg: simplify high limit handling after a charge
Date: Sat, 10 Oct 2026 14:09:57 -0700
Message-ID: <20261010210957.1350874-6-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261010210957.1350874-1-shakeel.butt@linux.dev>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ozmb845g3aj4po6dc3qneuu85squj3jm
X-Rspam-User: 
X-Rspamd-Queue-Id: B1377A0005
X-Rspamd-Server: rspam08
X-HE-Tag: 1791666632-485593
X-HE-Meta: U2FsdGVkX1/58xxq/PYrO7/MBzrXgq8bWOvbz0lBMi3fssXh1pk2IUTT0LDDqu9z1jQX+gCViLJnjU66jPfK60ZZqa2ernesHrvCwRQgD0czjS5atbFgjKbVKUAccf2ceis9v79YsYF7HfRiawy52pjOQN27kdRjkceE5OCrk6f6WRsSfycOExwjxfW2vgBwI6CSC1wWBxVLgsjbDCkYOQp23dDH9zqeFVcHzFqyO3zgdme8T2EnHbhCAifZyrCeqjhgWN4cC7t8jDrU9yQccwULqF+OD6M1NBAPteOgeDFTPYnw8N1yyTz2pD+EWovzyxqAV7qKNTRc1xb3N0jJGLJCPjkkJLwjxNe3dQY+kgcU7/IB9iQz0H0tzdDwZvF398RXyKC1zZLrKiCoRig36SDTyvTnKM+QaTu8ZgZIPoCH67hGQVxF//QVU2muJ1AFoY3Vo9LuQQbSnpeBldmxSjwCwV9KvzT9IKuXoznMZ8SxMTW2wRWuqGHjkwozpTw3OgxTOhUQUJKw2KqijsONF+tGTRVTliXqENrrjdiCI/9/W344z7WDb3ZS7jK44xPkvjudJA3GrsEbksKVSL9bSViObSZEg9x9wbfr5B2CXGO+YzGBK941MxmfAIEcrXPc0JaCuAxzZQS/8cjc9XA3mxJWaxGQKiuz1fPQfxzfvY6XcogtOraVtwlduKhJA85ppqYhqmxBTzZwF7lPINV2siUlBrGD9Uba5+IMiLLOhPyGbqiQY6CTfthv0QzXmS85Eiya25Lkn9a8AUZwWSGjb5exqrJaWQLDV0sCT0oaPi5tb9qc4aDdlCQZiS+E8bINseFIgX9tImrVMiPqA1u/F7NooriBueW7DRyRwlZ+OCKcnbqV+YPiDv5JW2pQI/9hP/eKocN/G1+cq8SGTVqRIe5uHTCczmrvY+a49kuZJZCT+ce1jk47Ts8+6tmSHpGRAIQoGC8eTbZTNcAORvX
 zoUPMRFF
 y8tz6B0d2DrLFuVmRgj3pJSy1OAryo3S/Lk/XERE1cI+lad0IDFylYbPU4THk4twVXTj1K/gqgbTq8wkF96hBaYlJ9CgbHcqoggVrnb2Pkp2w+DPpyaBOe+JfI46Bt4b0wjagUyWddph+QM7PYpXEQMs+6v2Cx+ht4kqi0Xf4+9nwiypoVrgBAZyvYnd5L3O9qGGB34BSjBIgBhC0HCxMyz0aAd9KWj0tEvLe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Separate the hierarchy scan from high-limit enforcement. Find the first
cgroup over the applicable limit, then queue high_work or record the
task's overage after the scan. Worker contexts check only memory.high;
local charges also check memory.swap.high.

Read in_task() once and clarify the enforcement comments. Keep the
synchronous pending-overage check independent of the scan result so a
blocking charge still handles overage left by earlier charges.

No functional change intended.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 100 +++++++++++++++++++++---------------------------
 1 file changed, 43 insertions(+), 57 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d1e022e6572f..2a3742036b45 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2602,9 +2602,8 @@ static unsigned long calculate_high_delay(unsigned int nr_pages,
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
@@ -2704,78 +2703,65 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 			       gfp_t gfp_mask)
 {
+	struct mem_cgroup *iter;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
-	bool use_worker = !in_task() || (current->flags & PF_KTHREAD) ||
-		!current->mm || !mm_match_cgroup(current->mm, memcg);
+	bool task_context = in_task();
+	bool kthread = task_context && (current->flags & PF_KTHREAD);
+	bool use_high_work = !task_context || kthread || !current->mm ||
+		!mm_match_cgroup(current->mm, memcg);
 
 	/*
 	 * Reclaim can charge memory, for example when zswap stores a page.
 	 * Don't queue high_work from a reclaiming task, or the
 	 * high_work worker could keep queuing itself.
 	 */
-	if (in_task() && use_worker && (current->flags & PF_MEMALLOC))
+	if (task_context && use_high_work && (current->flags & PF_MEMALLOC))
 		return;
 
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
+	 * up current->mm and rechecks the limits.
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
 	    !(current->flags & PF_MEMALLOC) &&
-- 
2.53.0-Meta


