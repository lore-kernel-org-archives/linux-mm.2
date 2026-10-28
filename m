Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57F41606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ZwkICJjx
Received: by kanga.kvack.org (Postfix)
	id 7C8A36B05B1; Wed, 28 Oct 2026 05:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779436B05B3; Wed, 28 Oct 2026 05:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68F866B05B7; Wed, 28 Oct 2026 05:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4777E6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:08:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC581120C6F
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:08:14 +0000 (UTC)
X-FDA: 85371458508.14.97CDB52
Received: from mta1.migadu.com (out-26.mta1.migadu.com [95.215.58.26])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0F0222000A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:08:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZwkICJjx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.26 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793178493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FB2zn0ztxU0bAbgb4l4L6i5REO5Iim8clUozCOhgJ6s=;
	b=DxisQyvwJbL+kunPXGsn1tTy5j8YHg9IbMbK6F6g8tWzGrd6YTMs3AlVOmVE5NFAe5XWro
	AyaAFtWHJgoSh+e6coyXqQhkyduIQ48pfBIZRQNbdU2HqqwixtxDu3rkG1wQ+rjyaCDJ1r
	YFZ0HsFJowf7oSXw9oipyz8F+E6kSl0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZwkICJjx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.26 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793178493;
	b=B1KQdFQKlx3WSPO13VKiLXoBEfzaH8LWo7OZKtDouSwmBPXJn4IsxTGTvC2NcQ3c53EMJ9
	HZu/jdoHbnbrTXvrsEDLpVxpq0uucC4HzV9c60kmfLo/CqEgfJtrdk5KzMUufbWPzAETkg
	dhRe8NjBsVhy5RFJD0X/td01o0eLQD4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PYXfsEwJO7PgBKy4a6fiWmbY2+1sqdlIQEJumSVKJoQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793178488; v=1; x=1793783288;
 b=ZwkICJjxV7QwU2t4RiTh5eI6NXxuJtlwspYq+RuauGc39cAPzgXZXC7e8pt6aKiv28GuNuB7
 PWiBiQYjH3szZbjXSg6HmsTr2oXmzUashLTJxc8w17L2VRsswe5EAZSZETKCU3bQyXuhiPSX7hO
 pcWj+NQJiIoQ9o70E3+cU2Ao=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id a6d4cf88f19a13c4;
	Wed, 28 Oct 2026 09:08:08 +0000
X-Mizu-Trace-ID: a6d4cf88f19a13c4
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
Cc: teawater <zhuhui@kylinos.cn>
Subject: [PATCH] mm/compaction: annotate data race for zone->free_area[order].nr_free
Date: Wed, 28 Oct 2026 17:07:47 +0800
Message-ID: <20261028090747.68086-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0F0222000A
X-Stat-Signature: ysmq4hu4d4bbjk1doc4bgrwq8qz77nu9
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793178490-502288
X-HE-Meta: U2FsdGVkX1+S8O8tY8aJz7Yj8xhryVscFk3Kv6WPJ+AdZ9109FMFouqfBN1JGL1p9x04NwZxT/6Sb+2h4JlOo2son8NQNNTO7T7LZ8/+BlKNe+1n73KL30O5Tjb2dMuCtIQrsdP4sd2oQPvLjmIYXxpMVIrr6AVnLvJQmWAHnXM/3y08AZGUIudxRqwZr1yutj6K8qtr/XNzKN2W2mKaRezkT+HwPoHhCyl1BkcDg19FydOKtwhFMLGcoUlYsjqU9BMT9cyud07tfdpFb9ZWWD+BpbtNhfyQ/ZQqO2NzeKvYIE3WjhDe5lXnO5TmUrvAU5PfXA6nNA07N5Z6ToUvV2eV7HXUyKRoArz0kxap3M2VmClWjI+RhMmbpSnu7tOa35sG9VI19bCIrKI8qisnNlQYbbPyYCpIlhQ+20UUpDLvVGZm1V6NJIlHmpe2YJvf2iFasLMIrtAY9Glx4u3dafM50OP4E38iNp9XAeladXGsojIrhd6q4mh4SZlOgjVFhPTbXFWgEOpvCWmvOyhOOC9AncvTdhHU6pzUOpj9DmVwrvVdrNQhqCLB97ovQKt8SpS0Lagvr961zfQiNLYBmyFj5IOWDT7kM+bz/ZajfgDI438VOcBdqF5kuT0Y1BnT55AiDwtfP4mlLHCk0WbSMpviFuWII+oo7bgy0mT5xMok9KGyoEkwtoKEqfyNYYSR+T3sJRaMPh/ed6qmPffKxFZX7hdyWe5Jh1gmzMPSDko5KD2enMWTpsOJXLbZo53EX4I9e4xx4f320eQcfjnoBxyj1BGVd8XIivSmGiKP+Evn3yJJ2t+zigFMAqsA7pPsm45p9YYLb7cEFB54VztDN7T07MEgmjODEj/lfADzmo/ghnAY1gZPcRsDP1VLK/1u/AUo28v77Vck2k8xoUENJiiZBndtaExXz9T54ADo5Qk7LRo3Abi+z6hK53oQ51oocFSRu1AXNpe8+imO8NG
 96DwJj0i
 t1sMPR/IbUCaAHRbh3RDMDOZx1PpUTiWeG/Gj244qh1NOEFIJjthE0zgTibw3DOygXtju1yWYAuoY/8tYMMazUaoIsFbsVlqTQwnulYXDGw5xQMnSfxBmaSpMQChr3cmnKd69mlEfBkGAUkac/49vh0VlGLEo8cwimKi6uSRBRQ2BWuvMcqN3r1pigpL6G0kPuvGHsI7I6Ue1FO3ZmO1/y26qmFUe/MaWVq6j3yPVuIxFTP7+C78MCE1wxLu5SJZ1DjHzJeVb5WQ85RI9UriHhZC4BA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: teawater <zhuhui@kylinos.cn>

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

Signed-off-by: teawater <zhuhui@kylinos.cn>
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


