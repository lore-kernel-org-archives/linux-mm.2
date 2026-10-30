Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6438606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 20:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p6NdYS5x
Received: by kanga.kvack.org (Postfix)
	id 48F3A6B05B5; Fri, 30 Oct 2026 16:54:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467BB6B05B6; Fri, 30 Oct 2026 16:54:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A5186B05B7; Fri, 30 Oct 2026 16:54:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00AF76B05B5
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:54:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 66D594011E
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:54:45 +0000 (UTC)
X-FDA: 85380496530.13.956FC68
Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8CE7220006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:54:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p6NdYS5x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793393683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WvB6ePpKWWKwFI9dveLQEwy+mNq3q4b5hvoyCK6cGIg=;
	b=L6yoD/mgsTti1Yag1NN4YZuaDCnrdc/KSiBKGVs8v2axlSbrtXuYAt9F05ipx3LLPiWjmI
	5LFx1anplOV+6kBAsXepj/kKYJHe+map5wAbdIGv8lsHFhMHYDNgrxnSI/a2dLGRTErwP0
	m7e8zYRMY8cgEp0bYwV6U1AgDzy+gQg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p6NdYS5x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793393683;
	b=HtjV4eNOC59JwhzTmWQSKHXiawK3Ilm2wMheVgOlKUGNj+A+W27lRMZ45XwzowmlrTIPMJ
	/8jlMXpCiQnvDeB+lAGz8VZPtJ9Xj27Wbtm4zv9cNNniA/UnBOLft/x+E5+uWknFvpNcTu
	p59W/qdl+B0VlXxpJepfYcCOqnSm52o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PEe7LP+ea1c/6uQpUdYkMtQm9r7KkVekkLLCHeCHzrQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793393682; v=1; x=1793998482;
 b=p6NdYS5xu4Ofo3c7yLwGkEcBjz1wod2WxK6ICnQ+wq225o/TkjQYwGwM4h2TjCD6+B/KSu0f
 yWOLwKsoxbx81L8sko6x36MgAhTQ6w1AYPZrZRamW56w9KZfUiGrpM0H7Or/y0iGYj0eQji7C5u
 aoaw6OL7ZJWIs/pgs8LN/ZHk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9e68337c290a835a;
	Fri, 30 Oct 2026 20:54:42 +0000
X-Mizu-Trace-ID: 9e68337c290a835a
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
Subject: [PATCH v2 3/5] memcg: use high_work for kernel threads
Date: Fri, 30 Oct 2026 13:54:14 -0700
Message-ID: <20261030205418.341214-4-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261030205418.341214-1-shakeel.butt@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8CE7220006
X-Stat-Signature: eby3dzrnsnxw4c6raxa7mq5eyxmykozb
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793393683-517370
X-HE-Meta: U2FsdGVkX18gwYziSERR/R6K45SKfCSBhXFiACJ3tHOVT9fXVvJiG9Ns3yjMDu3CtdwzEad/eIPvCM86ijdfojx4kxqNcgD3icU6ifj8auqZJdQ+K0orfBLW6oxAbeqY8Or3WJZm4DM+e7HqR4W0sXi98RD+4S+e4MXLZ5rHfvYhiqdGs1HTrKumDvR9yDCWO9qVGJd7benTFl8GtQ/WtuzpsXur2ja0xmQADpqwhMjLtQNWs8vBVCipP+yXj7gA1CChqaZm2oN39vMgnT0buOzDxMqrr6KXIeLorGC5A/oTsK3rL1enm/zsQExkEQCi9/nZOjTXEGEAwwxIQmmxxAn9coPkia7HK+OUJRQoxrhQU/Gzd+205pu/4Ldl6LKqL/SLoDkGYOscxmmoRBw8WKNk2SIJ/9WoWW4LOUpTAIaZ7GpyRF6UrkrGkFl5/CiDlJjGW1wHU0XU2MQh4CG4hXQJq7hSP/nXLO6GXyioSr65L4yXTD/57GDxqqEvpAFscW1Jh8KL6BZu57E0s2d/osm/t4XAuMRxRtEE99ghMCT2Inhhz8rZKMKAxX6gpFdx5es5EY3HsPmLgytYwEfdhz7Am3oOBNm2XZJ/qj7Z90NI+s8bEzT7xl84UiLWAZLDn3Q60dG+rMaOGCdSHNjwpG9SKG1o9J1clE22GuQeEIvwbG5PGX7azS+MzQ2gwGZzjQhJ/d5VTGLwlwHlHFmPiVMhju/Uk3QOpNItumOBRafk5hHtfZClEl0GMgt7UX+Tvxp6ibhTwaEnaCpIiQMaAhOnjNJsWPP331Te2ndE21kngkI7NQI+xQVLbzmvbFFSCXmAj2olscbT+cusZEJ5SX+C9dh3LD50ZwhFr+u+ZrXvctXaSXKwtvPTfvD6MZMtQAvsjpwsTa+Z6bTRUk1LyT1yKGgVES2Z6SrxPyU1PURBQSY49PhtoIc+g26HwcCplMWjbf0iMvltxzbqYvO
 VZEoJ2RN
 BGoxRpwBQR3siYay/j+xf3++/MRAm0z/FCubzLslSX8FbMybm0BaSUo+cjjsbLZLk5k/pmp26LOkYRDHDNBs8jpBU72gkpXUxMcLjW6013mtQjPCVr1ZjIkwHPh7CUKijx3IXW9FsBZSyMQa2dZRY55+55D1+G4Tj23JJI857EP94Ini2G0PmcMmIVxhx2rnLSd0JXIyAVTvMjQMrFT/DPU7w6t986i0U/gA/WGmt4iSJveHu+PkHFTV8rppSLm6A9drBWbrRefn+6I4tJAnND0T4tc4MZ7lWAdPghy9r4TXL5pb7xqbFVA3y4bOxDIbtE1MDJhKQIvl7Z+Knj/2uT51rm2d4JIkKbiNjhupMrokrtN4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/memcontrol.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index af95a4574a0f..42bdaaacafb7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2708,6 +2708,7 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
 			       gfp_t gfp_mask)
 {
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	bool use_worker = !in_task() || (current->flags & PF_KTHREAD);
 
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
@@ -2726,8 +2727,12 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
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
@@ -2754,6 +2759,10 @@ static void memcg_enforce_high(struct mem_cgroup *memcg, unsigned int nr_pages,
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


