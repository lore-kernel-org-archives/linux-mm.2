Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08CF860A380A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kX4p6N08
Received: by kanga.kvack.org (Postfix)
	id 751B66B07DF; Tue, 27 Oct 2026 11:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B27A6B07E1; Tue, 27 Oct 2026 11:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5540D6B07E2; Tue, 27 Oct 2026 11:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 282B76B07DF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:47:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9B0D160A8D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:05 +0000 (UTC)
X-FDA: 85368834810.02.158C591
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 035274000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kX4p6N08;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bXoksnxse8Zb0V9rR0p5aiuA2ulCNQ3zxZK0B9A35Fg=;
	b=jpMmrTp9DXg6vbhkQy4zxlZba2hDlE4a9YbxH/AqLpcXLVrh0C3lywjNqE4Z5FAIbVU8AT
	lsiHwgjgqr62ujUlrvQeFYAfyQ72DtoZvH4jGkIqeUtGJZq3dwM0a2DyIBQ/nSsMvH6Z8o
	oZ+J/V2fsIellE3M0GYpHztKQh5ZVPc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kX4p6N08;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116024;
	b=Y38brpBKIa6WTZ46M7OnZXPtWKRhThGsSUkyxB1ODFl1Ec2mSMy4RwiQd0Enk77UCMsW5y
	4RP6SnboxBX3WmbDeGfatTUKDHSFsX9OTfN5l5dEZhCOSyOYFx2b3iouEHGRoQM2B9l2eb
	saUBFrgnIc8FNsDdJpMy+SrqTwlxheQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 86EA9601FE;
	Tue, 27 Oct 2026 15:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9561F01317;
	Tue, 27 Oct 2026 15:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793116023;
	bh=bXoksnxse8Zb0V9rR0p5aiuA2ulCNQ3zxZK0B9A35Fg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kX4p6N08bpxjGgTL+dX0spyc93Z4L1rS8iHe8x5LoLMdu4zSbI2erfdE7VgOaELdD
	 5ptFnYTJArj3GWE9Vf/v04Sg1aWAn08YHiai3NNhnvwvK9zcPyQuH++7i0SH8XZXk1
	 KJMmn3CEDT5IsfeE3PtLjU2qVRqWXD+cYEVrVXgEU6BoW5X5A+n2QnHuto9BFarCtO
	 OPJRLvHCPBpLtnVGvdPVtoC32A3sNlwEMTC/4AqQy7PispMG9CrR1oijmGc5AD8enm
	 c92zR2bCaZxwB4hugQImkw6JUUJSiJoxehCoDqBsxwc2uJ3lJlp4A7yTFQ1CRAyIkK
	 ejxToFnnQihaQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 27 Oct 2026 16:46:34 +0100
Subject: [PATCH 8/9] mm/memory_hotplug: resize zones under their seqlock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-pgalloc-ai-hotfixes-v1-8-9c7d1aca801e@kernel.org>
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
X-Rspamd-Queue-Id: 035274000C
X-Stat-Signature: e9xoutw9heyizmig7km1n5o3ewthypk1
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793116023-983981
X-HE-Meta: U2FsdGVkX1/ybHcpfy6p+BM48JYhbWDt7LMWkz4YuFLActiz5eP5IvBI4WvEG54acNe5a05lKqfKpCyNocQTWyg+1hbkmHnL8DI09e/Q5ALhH7CU4D8G6NF3SW2zTeZdTLqbolPHGubU5YUJdpVNg9N1Ojlzvda++fJZEdEuCC9iP4zC4sosEpPuSTiTRG+cqHiCnfhSOezChVzxlhPA/m748J4CcVRfEzM1MesuO1bwmNVNsVGrIvhXBL+GoEo3ZggQuIzlQnhpQK2F3YMRW5Q0sFI91GY+OlBCJUCwglIPNALnREPHhYAK5zTXQy10dApTkp3KCyJNNdwML5cXMQ++ktwqpH6AFc9o+Q0oGmkkIAvJL9Pk+1eCYdULRlaPe6nC55PbGc1sX8G6gEUNoCiD6lMFASWbzljKuKRaUyznzjZNtl3vMLkwLFCg2xhkIMCEr10tZs+SA3J0TEm+2SyBM592zn1WezZkpnTCW9RQqZP/WOb/KAtogvIBRy80vspB61dEwHAP/pUOjoVA3y1CX2nwMg6/1Gw9PdWuIrAyQZboX+mn1ctJZmR4btoM5ul4+SpHXfq90uhhl/FBWbkzCZ/ieX0tkk/020nhR47ZIfckECuZT8aQ3B8QFVUq5uy4SSVQwp07esWcVGB+DAVHXsadsiTmyIjCQvlWVyxyH3J2LLwPLz+ogXApq9mTiE8ObObk0ROkbc9XzJ3DqvyvMwVzVzZnGVHZTnWKp8A43a41w6K3ezAEQ7t86FbyMm9zctDRWHdlxbUNxGFyWSxA4r0KuC/6M7QTtH954QJsqMiW//RM/JXOPPIhPY42azU3zfVj0jKpF0E8+gyBMPBunXYvwk4KI0cRiCucJkiisgwuXDs++GS6p8vAoAxjLmZgi63HLavLsXdLEuhFpon7G9mijhUNHQeXPl0GxufsZlx4kltwmv0EH5fLisg9tcGruPBkmqwdl1moqcz
 e5hI9EVo
 CNh6ZJswr/NElWHFXDXbio2fv9ZuKqPCrxDKUSj3B40KAr/EudTvf6NW8ldvg/9nz/yKGyEkwcDpDWTqdjw14VGykSYkd3HKxmSXUChQ0xk57oeLvUewZcwjzp3S4/rfaDt0Faocrj23A9EC4RoEcB9jf5GOLllqjATbGpb/IbfrMyxbbVvcF2zE/xXJWTfHyGA8hYoQRKmkBhvUO2i8aM+TuyCDdqXrrwSRKvfM4Mpg+Dyg37Sc5xUJDRPQPwoZLQoZXhCbJxv1x4gM5M8cZw1TxpMIr+/jsyhlDLJ76kcxykm0FGS2/6i7xnmpbtcad6aKCYJsV6TjM+ws0O6KHJ1/iqBxmQTSy469y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

With CONFIG_DEBUG_VM the page allocator checks that a page which is
freed, split or allocated lies within its zone. The check reads
zone->zone_start_pfn and zone->spanned_pages under zone->span_seqlock, as
memory hotplug can change the two at any time.

Commit 27cacaad16c5 ("mm,memory_hotplug: drop unneeded locking") removed
the write side, since all resizing is serialized by the hotplug lock. That
leaves the reader without protection. When memory below the start of a
zone goes online, the start is lowered first and the size is raised
afterwards. When the lowest memory of a zone goes offline, the size is
reduced first. In between, the zone seems to end before its last pages. If
one of them goes through the allocator at that moment, it is reported as
being outside of the zone and VM_BUG_ON_PAGE() kills the kernel.

Write the two fields in a write section of the seqlock. Interrupts are
disabled as pages are freed from interrupts, too, and the reader would
wait for the writer which it has interrupted.

Fixes: 27cacaad16c5 ("mm,memory_hotplug: drop unneeded locking")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/memory_hotplug.c | 44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index e773a7d54165..66f181d98ebd 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -467,6 +467,22 @@ static unsigned long find_biggest_section_pfn(int nid, struct zone *zone,
 	return 0;
 }
 
+/*
+ * The page allocator checks pages against the span of their zone while the
+ * zone is resized, see page_outside_zone_boundaries(). It must not see the
+ * new value of one field together with the old value of the other one.
+ */
+static void zone_set_span(struct zone *zone, unsigned long start_pfn,
+			  unsigned long spanned_pages)
+{
+	unsigned long flags;
+
+	write_seqlock_irqsave(&zone->span_seqlock, flags);
+	zone->zone_start_pfn = start_pfn;
+	zone->spanned_pages = spanned_pages;
+	write_sequnlock_irqrestore(&zone->span_seqlock, flags);
+}
+
 static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 			     unsigned long end_pfn)
 {
@@ -482,13 +498,10 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 		 */
 		pfn = find_smallest_section_pfn(nid, zone, end_pfn,
 						zone_end_pfn(zone));
-		if (pfn) {
-			zone->spanned_pages = zone_end_pfn(zone) - pfn;
-			zone->zone_start_pfn = pfn;
-		} else {
-			zone->zone_start_pfn = 0;
-			zone->spanned_pages = 0;
-		}
+		if (pfn)
+			zone_set_span(zone, pfn, zone_end_pfn(zone) - pfn);
+		else
+			zone_set_span(zone, 0, 0);
 	} else if (zone_end_pfn(zone) == end_pfn) {
 		/*
 		 * If the section is biggest section in the zone, it need
@@ -499,11 +512,10 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 		pfn = find_biggest_section_pfn(nid, zone, zone->zone_start_pfn,
 					       start_pfn);
 		if (pfn)
-			zone->spanned_pages = pfn - zone->zone_start_pfn + 1;
-		else {
-			zone->zone_start_pfn = 0;
-			zone->spanned_pages = 0;
-		}
+			zone_set_span(zone, zone->zone_start_pfn,
+				      pfn - zone->zone_start_pfn + 1);
+		else
+			zone_set_span(zone, 0, 0);
 	}
 }
 
@@ -696,12 +708,12 @@ static void online_pages_range(unsigned long start_pfn, unsigned long nr_pages)
 static void __meminit resize_zone_range(struct zone *zone, unsigned long start_pfn,
 		unsigned long nr_pages)
 {
-	unsigned long old_end_pfn = zone_end_pfn(zone);
+	unsigned long end_pfn = max(start_pfn + nr_pages, zone_end_pfn(zone));
 
-	if (zone_is_empty(zone) || start_pfn < zone->zone_start_pfn)
-		zone->zone_start_pfn = start_pfn;
+	if (!zone_is_empty(zone) && start_pfn > zone->zone_start_pfn)
+		start_pfn = zone->zone_start_pfn;
 
-	zone->spanned_pages = max(start_pfn + nr_pages, old_end_pfn) - zone->zone_start_pfn;
+	zone_set_span(zone, start_pfn, end_pfn - start_pfn);
 }
 
 static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned long start_pfn,

-- 
2.56.0


