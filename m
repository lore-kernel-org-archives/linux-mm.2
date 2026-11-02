Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC1D606A32C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AZDzOl1W
Received: by kanga.kvack.org (Postfix)
	id BBFE56B00EF; Mon,  2 Nov 2026 03:19:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B704C6B05B1; Mon,  2 Nov 2026 03:19:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5FE26B05B2; Mon,  2 Nov 2026 03:19:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72E1E6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:19:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64E03C0BD8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:19:41 +0000 (UTC)
X-FDA: 85389480162.14.C141EAB
Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	by imf20.hostedemail.com (Postfix) with ESMTP id F382B1C0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:19:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AZDzOl1W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793607579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6LIgKMD8dHTd4WojjokCcwg495C76eo9u3xZtsqzS+k=;
	b=z0ZF7qIGqSH40WMZQH520RWnYfadj+Ptcx4ikVIYInGQZIZUZr1IRoSQQ6E/653tAD5sHq
	aBgGGNsKfT0U/VmFLmc6YnUaQb4LN9cTE/dC3iSxd9Q/bmiWbPdeBzhYFxXh3y0cdbukyR
	tU3K+xBwmHFpzRnMyHVNj6sO04KpSN8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AZDzOl1W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793607579;
	b=GunffWdT/mFWgYCkZ68OINLrm4Lhjk0RyY7XkO2CrIRzVZHd//a0ZEvod5c8L9QPUnYc5z
	R78Bivwg2kXZxpRbQ7JScdu51nH4vuL3md3raIrcLf3alCaBIV5hnReBKC+2EaXBqSdFY2
	RZgdZY0I5+Z9ryW2zv0cSDfHpZ27Jd8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EBKM40GcqovOdTmepBxoC9IiuiPwdTEdquc/inXuQmU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793607576; v=1; x=1794212376;
 b=AZDzOl1WlM0ZM+HlRBWP8R2eySrKpGJIpSlS84qhwFCPdwO3z0lg0x+ioEPVsR71T3wegNd2
 FCRPfwrNebKHsirn2PZKLgRXt8rmNSW5PyoK2LjoDTv+I5vIqg5MzMEhk1VHm5VDo0BHzEb0piK
 Yt4ws4hq3JjvhVFChcDlxgy8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 684001e98352b0ca;
	Mon, 02 Nov 2026 08:19:36 +0000
X-Mizu-Trace-ID: 684001e98352b0ca
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	stable+noautosel@kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v3] mm/compaction: annotate data race for zone->free_area[order].nr_free
Date: Mon,  2 Nov 2026 16:19:18 +0800
Message-ID: <20261102081919.80625-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F382B1C0005
X-Stat-Signature: htni81aw74qnk8baqkafftyszisb8a1t
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793607577-792868
X-HE-Meta: U2FsdGVkX1/HSBqnyz4MsulZJcMxQkJgXuKPezxCxWd3gZbzP7MeC8va8sNzN1QXa52/C1p8it8nZrhaZIcGoWGFVYOxOtFkHTbKncRCexgm/QhDB38qbcxmVqCejOgZ/oWvjB0TPc6OIeQNMW5mIMY7LIdLWwpP1pZRxpDx9/4JNhiCscfTLLs877fjbLnByhiagL/BXZsfPxz6TDg9z79tzd3wFi0t4dxT04CEHxfmwfrxJLrM5fZGL5+S1FW2UCOJWdCMPaefPJIeUyXZWJ3EmHwfpWR66NmNGHz3Z+IsOWGKeCwmh7LW4yO+IqFLOe7uoKcCqeVIRFIuSCJNSYIv2tX6LDHdVwzsP22mAlM4X+saJkddafDr8AyNW2uHhwZj8I+qfJxZN5HdvbWWDmC1bPUUdOiOFDtc7nnswYaPIbJKtdlEr8BdRFedJK+EAS2OKiD/S1IS/lEVkq5skVc6l/qGIMPa09ncWI6cCrTPXZoKdtqXPWnNC/wLvDpHlGyE1xxPe86UJPtVkRImlA/28T5/GqoJVlHm0sfibr1s/Rl4IcyE3LVwor1578uQv+aRuU7NtFDL0ke6Xqup5Ag0x1EI/Uun4yYEJAQS6EPrUg2NRMkJHj91UyH5/+Us5qHxawI8wUZINyUdGvCaaDacUZKjbRFOzrfzf9nZGiXXrauSVDjFbGMg/YAuIDrhzZgykCtl7vfsnLF7H8qDcVh28R7aV8OfG5U0r5O+nCCQFuQbIHhyJsQoyqbGbiAd69oMgYB/Y7KZ+KX5VjYpLxdaFfb6LNX9QRO0GxDRkbHxEP2SjgqRpUek04/Md/4Qg0vbdapjSRdxk/algCr7GcPvo4NL+/9lt6uEmqFNK5B50hA7XIFn5n5IpbSvrRcdqLowm2aM3kcd0EiqYnpIR9Z22Q14RZFrcFw1QElBLzhbgoWlYArpW2GIrXCpxvPMV8aH/017NOxZkNHHhU9
 Jj0LTBEY
 nMVw2m5Uo1vVkJnqbUaoDmHkketiYnqXvphMmx5tLIhQs17Pwpd9JI0HOPE9CrqjBm8ZbdRDUwcsBhpv1Tg+FTc2E2fd1FRo1F3aVqHa78Csydw4buhIiYGc7REX0VACGpQ5RgCWPeHn3xq6ZuE50fAedUUsjPdfMFgGqaRXeEUbn8hTA6LQfru+i1BCKzQdlxvKFEZfbPDCZYu8jeVptGeKoMcKSHSXbm38QRA6OWEwQkU0FNG2hQZLrZE5eemA4YECjMwVALJbyju1RV4Rivb0q9Rn2X0gLgwKfG+A5+QI+Kn++i4OnVSny46XEHFg+SQC+XUrnqujPZWNv1UBXmDyrVdxepoCNWpveSJWnzmZWbCzCCEq+ZEhWVB1Az/YgPrIGP6bb2l4IN59OCOzPt3DGSih6UVLkSGttt4tt8CSayVClpub1OuwX+1BBjDTfnHmZCZ2JHJwBgs8PTSrNPtxK1qCYDt5qC4RJ6pAz5+bjWsnnzsY9WF6FAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hui Zhu <zhuhui@kylinos.cn>

KCSAN reports a data-race on nr_free which also exists on mainline:

  BUG: KCSAN: data-race in fast_isolate_freepages+0x284/0x1550 mm/compaction.c:1589

  race at unknown origin, with read to 0xffff9894ff3dcb60 of 8 bytes by task 179078 on cpu 12:
   fast_isolate_freepages+0x284/0x1550 mm/compaction.c:1589
   isolate_freepages+0x52/0x650 mm/compaction.c:1722
   compaction_alloc_noprof+0x36e/0x3e0 mm/compaction.c:1850
   compaction_alloc+0x21/0x30 mm/compaction.c:1880
   migrate_folio_unmap+0x7f/0x820 mm/migrate.c:1177
   migrate_pages_batch+0x37e/0x1200 mm/migrate.c:1762
   migrate_pages_sync+0xce/0x560 mm/migrate.c:1928
   migrate_pages+0x8c6/0xc20 mm/migrate.c:2037
   compact_zone+0x539/0x10b0 mm/compaction.c:2660
   compact_zone_order+0x1b8/0x230 mm/compaction.c:2795
   try_to_compact_pages+0x20b/0x630 mm/compaction.c:2851
   __alloc_pages_direct_compact+0x98/0x2b0 mm/page_alloc.c:3722
   __alloc_pages_slowpath.constprop.0+0x452/0xdf0 mm/page_alloc.c:4401
   __alloc_pages_noprof+0x28a/0x2d0 mm/page_alloc.c:4794
   alloc_pages_mpol_noprof+0x1b1/0x470 mm/mempolicy.c:2270
   alloc_pages_noprof+0x7a/0xe0 mm/mempolicy.c:2347
   io_mem_alloc_compound io_uring/io_uring.c:2848 [inline]
   io_pages_map+0xb9/0x330 io_uring/io_uring.c:2892
   io_allocate_scq_urings+0x231/0x300 io_uring/io_uring.c:3933
   io_uring_create+0x29c/0x9c0 io_uring/io_uring.c:4091
   io_uring_setup+0xb6/0x100 io_uring/io_uring.c:4203
   __do_sys_io_uring_setup io_uring/io_uring.c:4230 [inline]
   __se_sys_io_uring_setup io_uring/io_uring.c:4224 [inline]
   __x64_sys_io_uring_setup+0x66/0xe0 io_uring/io_uring.c:4224
   x64_sys_call+0x1816/0x1d90 arch/x86/include/generated/asm/syscalls_64.h:426
   do_syscall_x64 arch/x86/entry/common.c:51 [inline]
   do_syscall_64+0x70/0x2a0 arch/x86/entry/common.c:81
   entry_SYSCALL_64_after_hwframe+0x76/0xe0

  value changed: 0x00000000000002f4 -> 0x00000000000002f5

nr_free is only updated with zone->lock held, but fast_isolate_freepages()
and fast_find_migrateblock() read it locklessly to skip an order that has
no free pages.  page_alloc.o is excluded from KCSAN, so the writer is not
instrumented and the report is of unknown origin.

The race is benign: a stale zero only skips the order for this round, and
a stale non-zero just finds an empty MIGRATE_MOVABLE freelist under the
lock.  Annotate both reads with data_race(), following commit
af1c31acc853 ("mm/vmstat: annotate data race for zone->free_area[order].nr_free"),
and say at each site why both stale directions are harmless.

No functional change intended.

Fixes: 70b44595eafe ("mm, compaction: use free lists to quickly locate a migration source")
Fixes: 5a811889de10 ("mm, compaction: use free lists to quickly locate a migration target")
Cc: stable+noautosel@kernel.org # KCSAN annotation only, no functional change
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
---
Changelog:
v3:
Reword both comments to explain why a stale read is harmless (Vlastimil).
v2:
Real name in Signed-off-by, add Fixes: and Cc: stable+noautosel tags.

 mm/compaction.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index f1b2060eb2016..426563acf7acf 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1601,7 +1601,12 @@ static void fast_isolate_freepages(struct compact_control *cc)
 		unsigned int order_scanned = 0;
 		unsigned long high_pfn = 0;
 
-		if (!area->nr_free)
+		/*
+		 * Opportunistic lockless check.  A false non-zero is fine, we
+		 * inspect the freelist under the lock.  A false zero is fine,
+		 * we just miss this order.
+		 */
+		if (!data_race(area->nr_free))
 			continue;
 
 		spin_lock_irqsave(&cc->zone->lock, flags);
@@ -2031,7 +2036,12 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 		unsigned long flags;
 		struct page *freepage;
 
-		if (!area->nr_free)
+		/*
+		 * Opportunistic lockless check.  A false non-zero is fine, we
+		 * inspect the freelist under the lock.  A false zero is fine,
+		 * we just miss this order.
+		 */
+		if (!data_race(area->nr_free))
 			continue;
 
 		spin_lock_irqsave(&cc->zone->lock, flags);
-- 
2.43.0


