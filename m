Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75CEA606A322
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 02:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZLPuw5EX
Received: by kanga.kvack.org (Postfix)
	id 8666F6B05B1; Thu, 29 Oct 2026 22:55:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83DCD6B05B2; Thu, 29 Oct 2026 22:55:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77C006B05B3; Thu, 29 Oct 2026 22:55:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A32B6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:55:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3851180352
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:55:43 +0000 (UTC)
X-FDA: 85377777366.03.3502061
Received: from mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2BA48A0004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:55:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZLPuw5EX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793328941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pUCbReckSqEr12tJBWbX35Dm/JKcttu5DEw0fkc69DI=;
	b=waOvId/Q2YySwBm9ShTXHko0Gsw+mcjz+5CM6JXvYCUhOGBquI3ObI2z1hoRZJQamD1ozt
	JULGfgV+B0OgEo8JcMtii4gvWSMX0xt8tjyh4XDOqJHONj68kqGeQyNlleMSBlYg8pjCk7
	enh5ZUsIxN1canPdG4IvAbsWY6qebWc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZLPuw5EX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793328941;
	b=TSc+Ra6E5ydIQKSuo6sdfEbwFeDxudp5Qi/o3knVvUTMew5M6dG3y0D91+/wJi5UoMoHUo
	bkp1OQPNOj7sbptCJOmiLXR9d8mrP32EXQMC2VHgt2SWjmQX7fLkKHSmLlMkP30SxotgXz
	rw+MKPoKoXeoQgFHhnwa4JwaGRervKQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sAQYKG0X+cRq7vrg7+ttEQx6a2fpFc91J/Dodm9J4/w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793328939; v=1; x=1793933739;
 b=ZLPuw5EXMctc9GYJweSlQAVVeQcklAr1ydzoP1OgL9PNQ1GMrdrfZh319f8dRhKqxrXYbFmu
 oG5oSwUsozWbD77rPDJ1+F3Q+Cq16azVhE4HxwZKtGOsrXdIs9A463tt6WRzHC7N1WLSsre3BLj
 O3TzgJQEXeStP+MhnI3apFGE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 392c1607db233a43;
	Fri, 30 Oct 2026 02:55:39 +0000
X-Mizu-Trace-ID: 392c1607db233a43
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
Subject: [PATCH v2] mm/compaction: annotate data race for zone->free_area[order].nr_free
Date: Fri, 30 Oct 2026 10:55:07 +0800
Message-ID: <20261030025507.115248-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2BA48A0004
X-Stat-Signature: s99gpgxokry4k6513ty4r8hbf7z1jatc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793328940-144516
X-HE-Meta: U2FsdGVkX1/vmlg+MZYppTudeEOfdDdFkV6a0OC8TL3YHrISBeAd1Wyj0ziCPhmHiM1fqzSEW8FKs/yECeXAG0FDYbPlJJrYpHgfj/w5XH/q6jrW9APfrq2j7EbLTd0S+Ayo7nU40p8TmJXG2LTpOkEqFjW3efPiXmPvbUUyn49ekK063JnQyWFYnR0cmlcniHRNlltEYiCTt+SRh1W09V1/yjN5yExW0RV3UEEjZRyKqIKFWoT8VLy+kbu5ngpY0nwABP40JZzt5BfZDp1UXwUhoLeUFOFYG46KITZV0GsvCAZvztTCCmzM+HpCUy5RBzfUfrfytppPkuBu6l2V4pqNZJ/yMomIhkBIIl/zknNTf+xJoVsW56rdPm9aH3ucbPMkVyejN06WR4rvL/ZLk+00mRb6aUGuXSHoP/PfxYXPkBk5t+YjSJAnXRyMWVJkEPf0sN3e+n4RjFhkcKLmv3sMYCqI2XXSa4mERhd30hmjLf7CtDgUWrs/vZ6oJPglUe9DMCb1XWlfgdebpWB9S7Xxt1SpFr5qICVWuKk3bH6UXv59cx3moMJWjZ+cAyBCCNiTth0r0cQqyGtzehwk5H+9pmvSXhxEiKjIcFCCnPyluBeiCH2F9/3BnNeWCbOWVpLQkisYul7KSFzwQchg6UXW3MWKexlGL9VRVKvnSPMbyP5ut89b3cSXFnysjDRCU8v4ZTlIrixDIQk4ostOqEmzhyLxnSnth/RaGrufW6wVl9dGmhqmidSnLifo6DF9ZGt+QTvbl5tT55q+pxTlg4wyBzApKZLau6TYpgWKXoxO2AFB2I0+bSMEGWcHAy1AWyXHIcxN50T1EVlLtyPn2fd3MPvbK5+M3afutx1JtV86qlWL7SxVR1uiHZbnZ5+HtEo8/V+0fr1o1RRvEDUxA3WUsKHQhk1m/aoHi5SofMtemWLjBC/VeJcEAn9oCKiNu+SfRyU8lt4OePtki5G
 +fEtJP2T
 TKFWz1S6VYT/SpV/vfw7c9JXrMwGXXqrXX9ydecXYyGHYDWIcidCK5iInyWW+DUwpt+it+q1Xm6YKrbCMhpp/GTu8QZVxFJ3bANFhxWP4VGcOYBk6yrRabI+04kjj4XwOGl3FLdIH7jU8UR911JINs1w1zFaeJu5TCkAT1MTgUvQi4RniWmVJ8ibGj8+7Psb3igMUVDy76U8eFqUQjMM9I422hxWP6UPDLNrf/SUqeKoTE1+eovX2mH3Cjy2aWiMkgCd4+XUiyZQBB4zeDcWQnLf5omwsat2OL/3WfFNgKyJAeJabxdeQtbEdNbd+O0Eq6274moi+d2M9sz15q2e0ulv4buNz5B/5bP4IUovfyo3ffJncBxYFXUXHIAkLCum0U4RM2LrYa7t9F35UUB3yu12ILMScIY+YGsUDBCoF3/yH/Q/BdpI8mSgRgu9xEvZApEUVecr/+nok2mjk3wppgwkEYyAq3PX2DcDL3m5wGsaZtwDM+7/EtoVzAw==
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
af1c31acc853 ("mm/vmstat: annotate data race for zone->free_area[order].nr_free").

No functional change intended.

Fixes: 70b44595eafe ("mm, compaction: use free lists to quickly locate a migration source")
Fixes: 5a811889de10 ("mm, compaction: use free lists to quickly locate a migration target")
Cc: stable+noautosel@kernel.org # KCSAN annotation only, no functional change
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
---
 mm/compaction.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index f1b2060eb2016..499ec7ceaa3ed 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1601,7 +1601,11 @@ static void fast_isolate_freepages(struct compact_control *cc)
 		unsigned int order_scanned = 0;
 		unsigned long high_pfn = 0;
 
-		if (!area->nr_free)
+		/*
+		 * Access to nr_free is lockless as it is only a hint; a stale
+		 * value is harmless. Use data_race to avoid KCSAN warning.
+		 */
+		if (!data_race(area->nr_free))
 			continue;
 
 		spin_lock_irqsave(&cc->zone->lock, flags);
@@ -2031,7 +2035,11 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
 		unsigned long flags;
 		struct page *freepage;
 
-		if (!area->nr_free)
+		/*
+		 * Access to nr_free is lockless as it is only a hint; a stale
+		 * value is harmless. Use data_race to avoid KCSAN warning.
+		 */
+		if (!data_race(area->nr_free))
 			continue;
 
 		spin_lock_irqsave(&cc->zone->lock, flags);
-- 
2.43.0


