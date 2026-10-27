Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9593E606C814
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W6oFFEUT
Received: by kanga.kvack.org (Postfix)
	id 184196B07D7; Tue, 27 Oct 2026 11:47:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13B846B07D9; Tue, 27 Oct 2026 11:47:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E556B07DA; Tue, 27 Oct 2026 11:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7E8D6B07D7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:46:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97E67120AA5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:46:58 +0000 (UTC)
X-FDA: 85368834516.10.94DDFBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id CEA641A000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:46:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W6oFFEUT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CF4JG26SyUmlFQ+N2KC4es1n4tmJXfM005qUTadw3Gc=;
	b=HNKkNkLgSUSD96YRdSQOduFMCIEFt3RPqV8T+E8Zi14DOg9BSs17HJKmEO0fBpqLDhJaxW
	Xv4EyS/EMEaB3Mdh/03fBl24oPudCWqIw0mg/V6XiHfa47Qgb+nxPtyQqKtwgtrKSaiXjR
	ShLk6F60P0MOuI82yfTlL1BLue4ek1c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W6oFFEUT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116017;
	b=JsRTmiitecCsc4e2vu3N46SYJ0jtxyWiOXoGWXx883+q9oOKU5KBHJ850doGgEWM14I5hP
	dd0t0Htmk4Du17WB2wsotN0dG1NuyBt2gxSIqskuhleZxJiRIC+DzsBzOearHKbuQTCEgL
	5Sp5PyFoI52kE6K+Ie77TwKh6TgqxkE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F6B344509;
	Tue, 27 Oct 2026 15:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA381F01825;
	Tue, 27 Oct 2026 15:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793116016;
	bh=CF4JG26SyUmlFQ+N2KC4es1n4tmJXfM005qUTadw3Gc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=W6oFFEUTbkszQPQTUqjH2nM9wxzFXgif+iYI3lQBmt4ANfuR5U3fylXGePiEljIs1
	 B4mwUBBvANjpGZ2PiIfJAMQrhHVr6KjsAN0wYrILRw70Ng0eN4GgP/LdvaNTzVERgb
	 c3Fgtbs4k1uZyjXLwHFG1ek5AHdr/f6Vlof00Jl3xVO2XLFHS4YIEGBxUJ1HiqqIQc
	 797DlQNMMTBp45i9AiXjBXhhjGFHEhcpKkL83+tvLnnjpaWylwM8HUW01MgAroXrIc
	 91Hu/G2BSQafZEw0VndL2EHCjgZk/jzyU/tFfWeSMUSvT98nwszudKpJRxmuLcj4jS
	 a4mb+yAAmPnHw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 27 Oct 2026 16:46:32 +0100
Subject: [PATCH 6/9] mm/compaction: trust zone->contiguous only in the span
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-pgalloc-ai-hotfixes-v1-6-9c7d1aca801e@kernel.org>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CEA641A000A
X-Stat-Signature: sq6prrr6rf97i35xm87jxr6nbcx44rah
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793116016-37147
X-HE-Meta: U2FsdGVkX1/C8Rx1vnek58BY9Icb+yrOAZ/Yjky9GDsYcZUGOjZCXZrXsilfnu7a+cl+MNn1bPz4+osNKmHvscNb8R7duOcBhbDSHulsBz9XZtB8JNYYPwsmFgafKIgygBTAzRvnjLQAbu+s0tEiyfHSio8Z4EdDYjD4yG3CEbOrZiXud4r8Nd3Blzeg9hGamwpl1BHQqR0OvD29lkwPD9t8YJ2fUliNcuDLVWNGwWz2Du6HQSoCHgru/qIWPE/n48iz0zN3DoD3p6lLaAG2BnY9SjbJbNfxOVblka+KKJnHli2G4CNmEFcs58Hx7cBGjqp8P5p7o0Z+JLsvHuzN0nrnJEz7sVyGAPIFX81eWpRndnugepuYvWo7LnEVvHzT+2rFJIOZygW0aFyQb38Aj8g7k9oy2CMe4nqG6evT5Qu7j2KuBGcnfNjthBRZvgULlEDST7wlmi9MN6+1CabK8JMfYe/2aZYCxCBzd2R7dRB6FGAngYIOTxd4tKnJLZzOFMhi370VXR9ch5mxxrMN/3DA0Ok9Y246YDLfXmFttnz4P+wNvIZY53mleO9UGdC12udlAILrr59CYhOGZFhp4bV+KOTxgA34TZzlQGYKgFSB9BfHNZsS5R+6+tRarzJ66DIpR7rotLi+l/YcDOHwpCAB0iJ3lkfRVMGChDiCk8SK4d483njiqdMM4ud6LWD4lIsnpwHXd4ViL81gNcjSpuiVNAMw4xjCALipDKlD5X6SJkC9ghDPFXvf+Z2W7KR7klhyEA88117bsEuFJ+nOzGuhJ5E9kxdlmj2IAB5rMUdB5cO/0TIMf3d1wM0+GSPtKalxz542AWeuOs5qCMgfmWVLc1wcZeyG4+/ppdrULead0fcU8b7IJDEnWY4+AsdDiXaXzvYHZJo4Dmb6XVsOPK+1Z4Y2aUdY2hptBxForEZf6aFOO0lczfqKnxjU66gTpFguWjo49HNL4WPrTB+
 EpDajFST
 DEDSf4mCOH+eSaGNf4slGffUZc/AH7+cItKvlNqNWo5MAtm1imzSBqRLpVGfV6r8tN49EbgZ5F7pCFkyoGo9TqrCcuIiFKernkp+xlE44nyrCIXq/8tMh2KDyGXVKtdSTAtQr260fNQlDuIXUqos6rpCAJL6EOIGEiuWIx92KCPdG+1KODuJy97XBza6MHkaQ1RHDt+7eZbSM5OMAKOWxSvc+6sPqAO+nfOEmk9RS0z6/jEkIbfkXmWSoGXgUVZe2mXncmU+BxRgQsFtRuSuqH3Ip43z2MiscAPebTd6vJO/zbFi3xYmnOpiNnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

compact_zone() keeps the positions of its scanners in cc->migrate_pfn and
cc->free_pfn for the whole run. Memory offlining can shrink the zone in
the meantime. At the end of remove_pfn_range_from_zone(),
set_zone_contiguous() only looks at what is left of the zone. If that has
no hole, or if nothing is left, zone->contiguous is set again, and
pageblock_pfn_to_page() returns the memmap of any pfn unchecked, also of
one that the zone does not span any more.

The memmap of the range that left the zone is poisoned if CONFIG_DEBUG_VM
is set. Once the memory has been removed, the memmap and the pageblock
flags are freed. Ejecting DIMMs that were online in ZONE_MOVABLE while
other tasks write to /proc/sys/vm/compact_memory, no debug options set:

  BUG: unable to handle page fault for address: ffffea0004000008
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 3fee9067 P4D 3fee9067 PUD 3fee8067 PMD 0
  RIP: 0010:isolate_migratepages_block+0x32f/0x1280
  Call Trace:
   compact_zone+0x673/0x1140
   compact_node+0xb6/0x130
   sysctl_compaction_handler+0x77/0xd0

kcompactd and direct compaction walk into such ranges in the same way.

Only trust the flag for a pfn that the zone spans. Everything else goes
to __pageblock_pfn_to_page(), which finds the section offline or gone.
The span is written before the flag is set, so read them in the opposite
order.

Fixes: 7cf91a98e607 ("mm/compaction: speed up pageblock_pfn_to_page() when zone is contiguous")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/mm_init.c    | 4 ++--
 mm/page_alloc.h | 7 ++++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index df1f888e59b8..262e4e5e97be 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2270,8 +2270,8 @@ void set_zone_contiguous(struct zone *zone)
 		cond_resched();
 	}
 
-	/* We confirm that there is no hole */
-	zone->contiguous = true;
+	/* We confirm that there is no hole, see pageblock_pfn_to_page() */
+	smp_store_release(&zone->contiguous, true);
 }
 
 /*
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 2b1017a91928..e24d1203c514 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -216,7 +216,12 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
 static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
 				unsigned long end_pfn, struct zone *zone)
 {
-	if (zone->contiguous)
+	/*
+	 * A scanner may still be at a pfn that has left the zone: the zone is
+	 * shrunk before set_zone_contiguous() says that it has no holes.
+	 */
+	if (smp_load_acquire(&zone->contiguous) &&
+	    zone_spans_pfn(zone, start_pfn))
 		return pfn_to_page(start_pfn);
 
 	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);

-- 
2.56.0


