Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9974CA9EC5
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 21:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2EE26B008A; Sat, 10 Oct 2026 17:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDF466B008C; Sat, 10 Oct 2026 17:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCEC26B0092; Sat, 10 Oct 2026 17:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA766B008A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 17:10:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0EA4E16023E
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:10:22 +0000 (UTC)
X-FDA: 85307959884.26.73FB562
Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf26.hostedemail.com (Postfix) with ESMTP id F0528140006
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 21:10:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LcN7HbZo;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791666620;
	b=QzpwultwUbOyGb6b5JAxuesEkbm8z1/4IAjlMxzS2fqSQTQU5QMVlqQt0L10lcbMGjaMhh
	HdYo9IFzpYaZZdlJJV9ZYRFvY409ZUQv9coTNLuo2HC7eBljxjHrZrpBWHnPoqbxmO1ja0
	5RV8Elx90moR7jXoZqp6wB1vMFRrZjw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LcN7HbZo;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791666620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljxUuOyKFOOp1j1knAZhovOOGJ1Bra6mwFERNx8uJp8=;
	b=RgKyqzIrJ0V+hw63F8QEl563EBNblfTketDvcXpunCrj4cBJ27DMhkJ1TweuGmGpYMrE6Q
	ePwsEQmH9DUpBb2swMPmIcHp0VRZoQi1vddnA/ptAB+pNkiYX6GXz4g5PEj8jmjPpMFWCr
	f50dZ7/GBVidh7OLZN9sEe62ZLc01Rk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=r8kUhAXeGuwNlZMbjSzZrDN+BN6E2U2Ur6MAZTc0RbA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791666618; v=1; x=1792271418;
 b=LcN7HbZote/F9ryzygmmmtViTn4SBQYReaBYFT22YCE7qw6Na7TlEwPlyM6rqM9VvZVj6elY
 P9E0MLRrGOFcDnj1JlAWl7BJIKNSK9DrOPGvtaW65OxDRXnKImE1Oj2gye5OI7pWuA61b6zbRwn
 SUG7hHVKpVll4WbveyRoqDLI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5ce34010455c6035;
	Sat, 10 Oct 2026 21:10:15 +0000
X-Mizu-Trace-ID: 5ce34010455c6035
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
Subject: [PATCH for-7.5 1/5] memcg: move memory.high enforcement out of try_charge_memcg()
Date: Sat, 10 Oct 2026 14:09:53 -0700
Message-ID: <20261010210957.1350874-2-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261010210957.1350874-1-shakeel.butt@linux.dev>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F0528140006
X-Rspam-User: 
X-Stat-Signature: baesbatk1zr6co7j78sbyxrzco8jf4bo
X-HE-Tag: 1791666619-325265
X-HE-Meta: U2FsdGVkX1/ybloPA7rADvfd1ObQCt1XV0fGARgZq710Is1Ixpp0yaFrBdoweNT8w/G82VuQZOyy7JUNU3K7sD5pOE0ycfZK7c5Z/q2VtnSn1UnwVsQEK03c2NPWrVcYvP+BZN0izP2niM9/mgQnQvo1ZUTgoLjAKv/p1kDPwAVqzQuTRODru/b84xJxuORvVqDhye8ynxQiVL1lE1Koc5WcmwfCqh7mZJGNkTtF2CNxj1KCbS2g23Em/Wp2vRge754qJ2grkTqealrpE31DPC2BVj46z+VYXtgBfCVJSDrX0mjsb65Ya6OdE+16/g2WsrsprTkddcWhGKxcm1q9Y7ctcQRC7tg7TnglGs57GTaIPjeVl+RiQkdsDLZM+k6z4DSXPeQKAlB4md3OZZyB7eoTU6ZO2wUedbv/0I99c/VOjQVS2uLwKeBLARh5xbB7CjCS6BnX2qENKdUVWjbTniWcFN0dC5arpH0a6HxLHd2ToLrDM2+DXMoArOuQFbGIfud3AsW2hjIGofgtlZO4AOtqRNhRx+Ps2bsc97BruLFhKCUuDSjk62zkAGE4PmLADDPLyNdeMVZQ9y4kVEdxIvK1DLhn4fvWoTJ4cKKKzi+ZYYlLJC5WHRT7Q026cwtBXHfCKiANMHeQWk7tgD4v0Kib8TmZ1IdZjHFR369WV+CgmNLxivSukEyd2Ssqyt5Pst4y7dNHlHv1F45+bgFTYLwmNGcS3nmFwQMPPVHwi1P9beXa0kD7AafcKFiOg2lGd30aHdN0UFEblNoTlbsFjfz4F12K3VYwA4HAEd7KGn3aDJqdqeIRNmZ8AmEWAeKgIxmmh8qWtR8/j3lisQ5ksi04Wgci6txdm0zC6RDpgPuDBMEMxHhI9MMGbaHPbHDu3S6w1iUYXvq4bEIyV2C1w5BM4A4aJeC+YlfUYwKNABYcP3rPhwnatcX6RVGKWxVgjm2b/IHSlPJVfBcpWy/
 SylsyZVy
 0A/V3jf6x8PT9BHze1efaAIGgCg7zz+w+yiruWQ3LG3MIxqshoq5K3f1moHlg86jnjdfAjyHZ+35iP4f6jzcgW/i9s/W1ft8A6U86iu/uxeBGu48TOzXu+QrcsDVWhQzXXO7X+alI7zexK0+ndnFnJ8fCrG4RA3I+kAXVgbQx1gADpFi5YkzlK4PeyLQ5mk5e8mtuJlXZZIH9Of9mXcX2TzVMc3r8aeomfOQOQieMbNIGheohvqf4KaBWUEkiROVtvkOQFvUvl/LKowLBmaQAOKpbcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

try_charge_memcg() does a lot. It charges the page counters, reclaims
when a limit is hit, may call the OOM killer, and at the end it checks
and enforces memory.high. Move the memory.high part into a new function,
memcg_enforce_high(), so that try_charge_memcg() is shorter and the
memory.high code is easier to read and change.

The code and its comments move as they are. The only difference is that
the new function gets allow_spinning from gfp_mask itself.

No functional change.
---
 mm/memcontrol.c | 125 ++++++++++++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 56 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aad0498a7bd6..20c5dfe1a894 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2696,6 +2696,74 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
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
@@ -2853,62 +2921,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
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


