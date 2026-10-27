Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03945606A336
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dPSY5mcs
Received: by kanga.kvack.org (Postfix)
	id 10E2A6B07CF; Tue, 27 Oct 2026 11:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6596B07D1; Tue, 27 Oct 2026 11:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEFDD6B07D2; Tue, 27 Oct 2026 11:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA8F86B07CF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:46:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BCD71601B5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:46:51 +0000 (UTC)
X-FDA: 85368834222.14.F47BC54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8D83F40009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:46:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dPSY5mcs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1u8lZKxgFZyPpeTOFFRYQ4fgYgjI0MvFics9ypH01DY=;
	b=XMlmFw/+H1TYwDg36SkhCNb8oxJKeLIuWEtdLLGlyR0d3qaeglqlMjUSaglig2cA8/9K6D
	Rd8IfsBzn3MHR1l8v3e6h7k55hd8VGRLV26GyowzhkMdbThZJc6PEQALARb1c+wJ/SAeMC
	TpposBifJNIw3si1xQ2XtBpfuM9TBfY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dPSY5mcs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116009;
	b=l20fVH+Ni8adIaslWfrKgqNvgOareEIRZMQP5eapf+4hqB/q4IHfHa++SEva3Vn/kM1sqh
	wB07MggINy4sb9F2VEHYLx5HxlYMxVfT1BRIHFe2Fq9BrVVBPYMD2ZQ4BiyuL+v/sHIdsY
	0iA5yQ1krn33TIRZdb/5wUbXMY0Cg48=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D80EF4408A;
	Tue, 27 Oct 2026 15:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6271F031E1;
	Tue, 27 Oct 2026 15:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793116008;
	bh=1u8lZKxgFZyPpeTOFFRYQ4fgYgjI0MvFics9ypH01DY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dPSY5mcsmJ6rtX9SPiO4XwDXHY7n/zmhtkCHeEC3C0NnN/O+8oo37LqtI35rur40l
	 aHy2epuMIF6RqQ7LULRCxz0CP8ZblI4binijgF1tR99odhURt9pZYB+LUhwDhr3PP7
	 E5sqYOdg1rmsyYrtTRx0CnJeOe/ucrxrwkFD26mimA9CjIAkhn/eWHGFgj6H46+DwZ
	 KPdBHRt4OsQMef1KfLUUQlYFvG1/HrqZg99bSh+vOpZqfhdsIrKF9lQ6sjnaj/HmCM
	 XsJH/DRSX3Y7SQs2J0tWUnvTRhDswaqDSsUkac9Qh5rYJvmMcYUU61KJyb+8QCcEqP
	 Io50uxM5SsA2g==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 27 Oct 2026 16:46:30 +0100
Subject: [PATCH 4/9] mm/page_alloc: keep the pagesets of an empty zone
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-pgalloc-ai-hotfixes-v1-4-9c7d1aca801e@kernel.org>
References: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
In-Reply-To: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 8D83F40009
X-Stat-Signature: nhnjgkpq4nnf4fzsx34e615iwq9xnq36
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793116009-521745
X-HE-Meta: U2FsdGVkX1+3qXDCW7t1M71e4J6BkixJPTyt3VGvxINoOanfUeAiuXAx95E8PEiM0mOQSilv/h+GwW8hN4aApVJR52myh72OF/JXqBTb3KlFn0uKaL1SGGMQIVNN6UyI/XbM00muMg7RpvqYd1wHojFoIjfrtMf4hqUD3tOF3nq+bFmh6a22B+Nxk36g/0Fg4OEyIgKPltgedPqSLzYYCZmiFSnaOHOKsZWHh39P4qpy2eXv04teiFmISq9ZEHZ6N0btkaPyTtyA1gCIfMeMhBmE9OpwhbLP73B/0MdqZHkyFILoffMNztYWfck+xm0aQBBff+bYbMnRmJle9mJqv69YCFqyGN9d+7fcWTlXDPllgOdj0Rctui4Ss45rFxFrJILuU/Qn8dx44e1GE6CywF/WnZz1ishEyD/wPoCRUZoQtZVZb8t7BkB5V4LCreiGv4N4bj1hueITR8L4xiUjRyikrKauoDOAQvE7kMAabhklXWBpqd2iGGi37HADtv98feX4VwMCHtiBwobLYe6FTMEsnHvxwc1+ln2Jygk+GE63HKqIeoIWZ6og2boKniM98yD9QhLaKeu08ZIHgGSTwJfMoDv2zE+fS2/e/+mDcnv4qJLKGfTniGs92E6YeSxVB+AfH23iw0zpgefsNY0QKMiEg+f06opD4Q6xHlNlbqu/eQkrFGc+WMyfp3UjLWQpURZ051wuZ30PNoFSzO1SfRXqIMHuRhwIvFnZrLJs0/1q7dNeZZRNzA0cUIqN9B92PsLlEHkZXr/9EapyHfU8/+qDeg0hespM0TpGNYoAK11h/Xpe3VWUss3tLiBpl1kSc3ugRKLpiNBpdEQV7E4F4OHI+HAOVrDBnoX7dnG4s7acEJMWgBe9B8eiitc9us14EMVDFBniq5jpjsxfF8TTA9C2nI2PE5Cf7trVF868ohXMKlwWixYfpqHmwlZRcoA9nSEJ6IYChWG/pA88pdz
 VyCpwL/Z
 Ohu1YjTyi6EK9yfDFeG2Gg4/6Sb7HTkJIKTKK0KH/4Xe/ZlEyv5bobt8N+fsVCSi7iLHjbowvfaWNCr/99ZDc4gGBnWv30oDE28w2DlBJn43sNj/3U+k3Of289hXnakfaIBTG3XZu1kfOMZ7XZJZbEodNo2sRlonKsjtejXh6PZDNPhhDamWGpHQ0A1UmOGfeGqHRb7kNHqF+sFrt0sewG7cqVf8Rb5+o+WSy38Wva9eTWA1hcZuXpJCxhP6RcCHQSSS7AaZK/qo0T4SLLx+VamXz/rTOFQSIK6ay/S1IBFqEEAnNdjWSeFHqTVLZ/WKAkpMDYjdrsnRixm3HuItDosFswCCRmMrWkCN8IMBcEquYLQ6ENJ7d1px+XZy5+3uAuLt+emMOGnM5QFBZokcfC9TFmLR6t0efxiee
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

When the last memory of a zone goes offline, zone_pcp_reset() frees
zone->per_cpu_pageset and zone->per_cpu_zonestats. Nothing waits for those
who found the zone populated and still use the two pointers. They take
neither the memory hotplug lock nor any other lock which offline_pages()
holds, and some of them can sleep:

  CPU0 vmstat_update()                CPU1 offline_pages()
  refresh_cpu_vm_stats()
    for_each_populated_zone(zone)
      pcp = zone->per_cpu_pageset
      cond_resched()
                                      adjust_present_page_count()
                                      zone_pcp_reset(zone)
                                        free_percpu(zone->per_cpu_pageset)
      decay_pcp_high(zone, pcp)
      __this_cpu_write(pcp->expire, 0)

The same goes for drain_all_pages(NULL), which takes pcp->lock, for
zone_pcp_update(), show_free_areas() and the readers and writers of the
zonestats. If the per-cpu memory has got a new owner in the meantime, it
is corrupted.

The pagesets are only freed because setup_zone_pageset() would otherwise
leak them when the zone gets memory again. Keep them instead and let
setup_zone_pageset() and zone_pcp_init() use them again, like it is done
with pgdat->per_cpu_nodestats. Their lists are empty, and their limits
have been calculated for a zone without memory by the
init_per_zone_wmark_min() of offline_pages(), which is what
setup_zone_pageset() would come up with as well.

Fixes: 340175b7d14d ("mm/hotplug: free zone->pageset when a zone becomes empty")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_alloc.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9a4d3352c037..13211b8caada 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6312,6 +6312,10 @@ void __meminit setup_zone_pageset(struct zone *zone)
 {
 	int cpu;
 
+	/* The zone has been populated before, see zone_pcp_reset(). */
+	if (zone->per_cpu_pageset != &boot_pageset)
+		return;
+
 	/* Size may be 0 on !SMP && !NUMA */
 	if (sizeof(struct per_cpu_zonestat) > 0)
 		zone->per_cpu_zonestats = alloc_percpu(struct per_cpu_zonestat);
@@ -6404,6 +6408,10 @@ void __init setup_per_cpu_pageset(void)
 
 __meminit void zone_pcp_init(struct zone *zone)
 {
+	/* A node which is added again, see zone_pcp_reset(). */
+	if (zone->per_cpu_pageset && zone->per_cpu_pageset != &boot_pageset)
+		return;
+
 	/*
 	 * per cpu subsystem is not up at this point. The following code
 	 * relies on the ability of the linker to provide the
@@ -7684,6 +7692,12 @@ void zone_pcp_enable(struct zone *zone)
 	mutex_unlock(&pcp_batch_high_lock);
 }
 
+/*
+ * The zone has become empty. Its pagesets and zonestats are not freed: nothing
+ * keeps somebody who found the zone populated, such as refresh_cpu_vm_stats()
+ * or drain_all_pages(), from still using them. They are used again when the
+ * zone gets memory again.
+ */
 void zone_pcp_reset(struct zone *zone)
 {
 	int cpu;
@@ -7694,12 +7708,6 @@ void zone_pcp_reset(struct zone *zone)
 			pzstats = per_cpu_ptr(zone->per_cpu_zonestats, cpu);
 			drain_zonestat(zone, pzstats);
 		}
-		free_percpu(zone->per_cpu_pageset);
-		zone->per_cpu_pageset = &boot_pageset;
-		if (zone->per_cpu_zonestats != &boot_zonestats) {
-			free_percpu(zone->per_cpu_zonestats);
-			zone->per_cpu_zonestats = &boot_zonestats;
-		}
 	}
 }
 

-- 
2.56.0


