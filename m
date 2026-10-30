Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27ACE606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 20:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=posSsXvV
Received: by kanga.kvack.org (Postfix)
	id 2BBBD6B05B2; Fri, 30 Oct 2026 16:54:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292796B05B3; Fri, 30 Oct 2026 16:54:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1816A6B05B4; Fri, 30 Oct 2026 16:54:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E66086B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:54:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74AA31404D6
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:54:39 +0000 (UTC)
X-FDA: 85380496278.15.651BA06
Received: from mta1.migadu.com (out-131.mta1.migadu.com [95.215.58.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4B18F160002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:54:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=posSsXvV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.131 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793393677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KR9I261kTrsqtzc7fnfrlPtlTPG2hb9NkIOztRWBktc=;
	b=2LwgZhJCssKh81yHhgw5BqJg4aq9iIgU6TPwhl1V+njafU5N+8EWzu/i7J0kWlh/XMtqPv
	yra11Lj9sPVAg3xqtAmsJ4JM7uV3bYGsvth5udDkKS8RmBYkX83WaLNZY0qOxejNEdqeWM
	szNeUgRdonWVbw4V7qXy44aHhD+XmyY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=posSsXvV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.131 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793393677;
	b=HgwdRd4PvMFjbKCP2dkhlGEqa7ItTntIsR0667CAgJYw6JGqcSmay7mIWso48bURNbw4eo
	zfXYbqhfRevpXNS7R7uKypOIR/UAJPBtMTQ4nLakoEKPy0SqN3JwKGaUpAuC1bUrXUB24Z
	Q4nbSdn0ACXQ3OCBWOkV3RTKF7ZsAPY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rrc83QUVCEKjAuO1Psc8BzjH8gymP25jq76cd3gkcmA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793393675; v=1; x=1793998475;
 b=posSsXvVXjEAaZaa0oR9bQKlIo/bHUN4IQyorG+PQGNbEuIPcIyTSLRPtkrGTYIn41NZMrQt
 t/hnK4dFo6wHtUtVHWJI/sbzPPfXQBamtdjZVwkTK0S6YDiGYLNpVQzngdGNc1gfOAlkjd1/Qez
 2HOHlGkH3opotEnH+p2lDDHY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f4708c483aea1fb8;
	Fri, 30 Oct 2026 20:54:35 +0000
X-Mizu-Trace-ID: f4708c483aea1fb8
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
Subject: [PATCH v2 1/5] memcg: move memory.high enforcement out of try_charge_memcg()
Date: Fri, 30 Oct 2026 13:54:12 -0700
Message-ID: <20261030205418.341214-2-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261030205418.341214-1-shakeel.butt@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4B18F160002
X-Stat-Signature: ebujzd46ph4bwftuz15y8oj1sszfag61
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793393676-977059
X-HE-Meta: U2FsdGVkX18ZnvugaTBYiqqGMOSQTzu0vCS97zKHXFQRUBSqyumJMoM+Rm85uL6ew7pSfcEFGXhi2pwkOj3wi+uDRcWNII4IB8JUemQ0cu+u4Jltramn+Eaetf3CkW2v9cz0D5CLCCBiOeS3yNKcdjfkxI2rMP6YBFpIIzeZld45zK1p9PtYyWtTNEPhAa4MWFaqBCWyczRA10mpT7hh7srG1iE4RN4z+ft+DON2dgU1cHn79GkUZT/lPV3Wy13Z7OaAwgxnVCQwpskLdqHSeJkQ7RvgyYLDsvYGez4B9IjKFmuD0Z9lzunirfsUn6KH6Hz2RkbbpdPx+CV067QC3D3qbe9XbkmIH5G7Egafrz6wuao7a8QtzAEsf7Gb1JZdjDeIFoAgQOLhveZiKRZzdiY1TR+EJ2Y/aRURr8aBMXpOe0wdW8IShh9Jf8PsJQ7+iXJ2JNwE46gn6e5NU651DX+nO5h2/lf2tJ4F1Neek590Kqw6WRjPxxllLT7inBpPerdlRaGo9SSP71Dxktv9EbcMy+G7WgL5/eevJapu2i27pBxPCPU2kZRZDeMDcuZcmGJSJ14AExVPVTtWxWsUOs71ofjmwQLRF6CoITJn6NAoaZ9Pcft2x4URVi4ON8KfTJGg66e2eg2xDidoBbUrbPM6+nD0AICjtDclfdBbgh0oJKwvgB1hntjCV7tfZnXETup88X3WrkjeMJY5gPZYSS2mDsuQOaZhoaJLNQVguSD/P6x8qpeChtdGJvHWFvfuFgvrp7h5ls9ZwzXfM+2br0Hr01wiaIIrc/gxbj+wjnZAd+8u4Ett06dCMXqe1zsv/Mmn5o2wGitQ7zS6RDqA+JbHe+4FXXh11K8+yotJ5VxRfIeBkHrr2Wj6bqJrEQCVFsRQSo2JiLOR1J3XuqySw2JwLKAKjgJ3bhwUlucZVG0Fu5VPgUfBEQyLNsyG999ik8z+PGfEQSTB91DE6Sf
 e9YtY0Na
 OcLXHxleixWcfiTNaN8D7VWhaGls7sJDAZVEIkGlZ/KxktLQz0MgZBmDgf847eYHDYdjDOn+SUDoIg27+7ykJX/nZ0lL+fS4AtU5/KOpnBJ4CLSoV+bsvB5el+JdcL98cet0uZkGHB7etKVjDYjD+k1FYgj4b7mL7Nhrk5NQtbvqstllrDTchotgtDqpGTWq7/I1aLqfRS2XVNRF5iqoNlrBpWb1+W4f8ITXIik80Ulkt1xy/IMM9sBMPORhw8N1d+i+UuwbTePUdf9If592THIm2/LHYIilUocX+LxsubtUcju7QxpEi98Nt/6xyX0Xx5jzi+N96Z8EpNnvEh6ZRNhJ6ORFEaLCqAv+9j1dikofFVTU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

try_charge_memcg() does a lot. It charges the page counters, reclaims
when a limit is hit, may call the OOM killer, and at the end it checks
and enforces memory.high. Move the memory.high part into a new function,
memcg_enforce_high(), so that try_charge_memcg() is shorter and the
memory.high code is easier to read and change.

The code and its comments move as they are. The only difference is that
the new function gets allow_spinning from gfp_mask itself.

No functional change.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/memcontrol.c | 125 ++++++++++++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 56 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..0e484f7f823a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2699,6 +2699,74 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 	css_put(&memcg->css);
 }
 
+/*
+ * Called after @nr_pages were charged to @memcg. If @memcg or one of its
+ * ancestors is over memory.high or memory.swap.high, start reclaim or slow
+ * down the task.
+ */
+static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
+			       gfp_t gfp_mask)
+{
+	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+
+	/*
+	 * If the hierarchy is above the normal consumption range, schedule
+	 * reclaim on returning to userland.  We can perform reclaim here
+	 * if __GFP_RECLAIM but let's always punt for simplicity and so that
+	 * GFP_KERNEL can consistently be used during reclaim.  @memcg is
+	 * not recorded as it most likely matches current's and won't
+	 * change in the meantime.  As high limit is checked again before
+	 * reclaim, the cost of mismatch is negligible.
+	 */
+	do {
+		bool mem_high, swap_high;
+
+		mem_high = page_counter_read(&memcg->memory) >
+			READ_ONCE(memcg->memory.high);
+		swap_high = page_counter_read(&memcg->swap) >
+			READ_ONCE(memcg->swap.high);
+
+		/* Don't bother a random interrupted task */
+		if (!in_task()) {
+			if (mem_high) {
+				if (allow_spinning)
+					schedule_work(&memcg->high_work);
+				else
+					irq_work_queue(&memcg->high_irq_work);
+				break;
+			}
+			continue;
+		}
+
+		if (mem_high || swap_high) {
+			/*
+			 * The allocating tasks in this cgroup will need to do
+			 * reclaim or be throttled to prevent further growth
+			 * of the memory or swap footprints.
+			 *
+			 * Target some best-effort fairness between the tasks,
+			 * and distribute reclaim work and delay penalties
+			 * based on how much each task is actually allocating.
+			 */
+			current->memcg_nr_pages_over_high += nr_pages;
+			set_notify_resume(current);
+			break;
+		}
+	} while ((memcg = parent_mem_cgroup(memcg)));
+
+	/*
+	 * Reclaim is set up above to be called from the userland
+	 * return path. But also attempt synchronous reclaim to avoid
+	 * excessive overrun while the task is still inside the
+	 * kernel. If this is successful, the return path will see it
+	 * when it rechecks the overage and simply bail out.
+	 */
+	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
+	    !(current->flags & PF_MEMALLOC) &&
+	    gfpflags_allow_blocking(gfp_mask))
+		__mem_cgroup_handle_over_high(gfp_mask);
+}
+
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			    unsigned int nr_pages)
 {
@@ -2856,62 +2924,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
 
-	/*
-	 * If the hierarchy is above the normal consumption range, schedule
-	 * reclaim on returning to userland.  We can perform reclaim here
-	 * if __GFP_RECLAIM but let's always punt for simplicity and so that
-	 * GFP_KERNEL can consistently be used during reclaim.  @memcg is
-	 * not recorded as it most likely matches current's and won't
-	 * change in the meantime.  As high limit is checked again before
-	 * reclaim, the cost of mismatch is negligible.
-	 */
-	do {
-		bool mem_high, swap_high;
-
-		mem_high = page_counter_read(&memcg->memory) >
-			READ_ONCE(memcg->memory.high);
-		swap_high = page_counter_read(&memcg->swap) >
-			READ_ONCE(memcg->swap.high);
-
-		/* Don't bother a random interrupted task */
-		if (!in_task()) {
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
-			current->memcg_nr_pages_over_high += batch;
-			set_notify_resume(current);
-			break;
-		}
-	} while ((memcg = parent_mem_cgroup(memcg)));
-
-	/*
-	 * Reclaim is set up above to be called from the userland
-	 * return path. But also attempt synchronous reclaim to avoid
-	 * excessive overrun while the task is still inside the
-	 * kernel. If this is successful, the return path will see it
-	 * when it rechecks the overage and simply bail out.
-	 */
-	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
-	    !(current->flags & PF_MEMALLOC) &&
-	    gfpflags_allow_blocking(gfp_mask))
-		__mem_cgroup_handle_over_high(gfp_mask);
+	memcg_enforce_high(memcg, batch, gfp_mask);
 	return ret;
 }
 
-- 
2.53.0-Meta


