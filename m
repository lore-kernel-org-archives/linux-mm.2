Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA7AE66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 17:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 549026B00A9; Fri, 19 Dec 2025 12:38:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4323E6B00AD; Fri, 19 Dec 2025 12:38:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3876B00AA; Fri, 19 Dec 2025 12:38:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0ECDD6B00A8
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:38:57 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AEDCF140355
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:38:56 +0000 (UTC)
X-FDA: 84236931072.23.7A15189
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5A0AA1C000F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:38:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766165934; a=rsa-sha256;
	cv=none;
	b=J8YlkmgQZ9pnl9GxE3Q4aB5dCeKW0A1r8TALHqzUXMSQ8uoafatqUR1EPJrhO/UYG1qrl2
	IoTTUP/+Fk6aQEF7Sp5/cPaKxzeLgxgWP5lSGtAnUG3qTjPQKsAlHoP9maiYu9xQMeXRWf
	CdMlVZPukJFvrIXYT1mCLTAXCGrRgFQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766165934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5fr6jEHcLUeyOFYLqwfaj51KcDsio7/lQnq9Mpq5x9Q=;
	b=zJSCu0kBDqRYXSpLBuRyW2Wd28xY4YnBubU3DxjuTLFAKmX5oTHIrI+4hoq8eIvs2ZC+fc
	OrkTDiJ4UP8ivIZy0Qf+UE30PwHT8j7GN4NCmvwsFUYIssm/27jLX6DGjqRS7mq+Xntl4L
	/JKJRwi2yamyXB9vlnR10A+mp3IBCEo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CA58D5BD00;
	Fri, 19 Dec 2025 17:38:52 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ABACA3EA66;
	Fri, 19 Dec 2025 17:38:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aHaiKayNRWlTYAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 19 Dec 2025 17:38:52 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 19 Dec 2025 18:38:52 +0100
Subject: [PATCH RFC v2 2/3] mm/page_alloc: refactor the initial compaction
 handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-thp-thisnode-tweak-v2-2-0c01f231fd1c@suse.cz>
References: <20251219-thp-thisnode-tweak-v2-0-0c01f231fd1c@suse.cz>
In-Reply-To: <20251219-thp-thisnode-tweak-v2-0-0c01f231fd1c@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, David Rientjes <rientjes@google.com>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Mike Rapoport <rppt@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5A0AA1C000F
X-Stat-Signature: otsoth4yixuo8fswn5hiebs9xu6qtgyb
X-HE-Tag: 1766165934-361990
X-HE-Meta: U2FsdGVkX18X5zIB1ASnysbMy3FwBpb0Iiv9fQC4FaZJ3EQ3wIcacVSBuVy3grA8lWyULFWQQuLjt1V6QOx4cbYTkoXBpXy9A76Ej1v+BeqtH1GvwMGu8aaLzBicT1Icj+AffE/+nUAvbFm4SqOXSdNR0OR0FIdPKyHKshomrrq2ohwemTV7iMBY2zWTRq7MRuptkse2PdmJokshAA5z24u7a1c953Y0RK9zefOsh5TqrJjmB3BtHX4HIPp7tJadbvJaxs4jCSc7LmJrKwBIVnRg+sfI4Ybk96uwWk8vpIX5D2YMUd4U9TM/7HDDFuyqICj34/ZV8Okg2g4mIB+OxltR6QUIBsoBsOI7VsIucbtKmTIM4QBjdRG+1n1n8obs/v4xILmHOs8wFE/ZwydvjnQ9MrctX76keKeyeMPM6N21K+nVE9AqiBp3nqE8H3Hw0rFz4dlkWmKJvJPPIxoqVDUNgnEmOniGnBq1Lqdvws66XzPPVJlufxAHg2HZU8nG71vCk5B10c+JaY6aBXf3mcRBtYh0gcBBVACrzAH7COIccUFQXrdPVIr5o9fJr6eiR96m1W4vgJIvRiSVy9UsDs78mmNLNqnmQfvnBH6dJi4vhEZgTeSSGNJ7H6lxhzFa6tVCLRFp0ASiGvcAJRBleFUNXLsUyPF5fIkn3eKIclPXiiVZHXuYrXeUpPFvbcxZSnbdVHjavUBJYX0AQ5K4XJp5D+SL9M3J6C9PM60JTRxdJMiMO51osF/1OywDWeItqkk5VxhhcikJIPV0yrXJu0yCwDM1YgRhlJ3DWbqYMF5YB4+4Kr6B4qhY+SB8IMvA9/EahJbatEHTtrJzGXx9lM7vrOMLnQGGZnkgQyTm+7eX5jnCxsKMfvzg1r8WmvemDM/jADjaUw1fuDZsusTYv/zlX+pIhJE3NtE1cxX3dNV751eIOH+V8ueZRWtE8Em8dy2Qu891+6h78UcU0H9
 XpgY0hHR
 40oZSUCqstsDLFWaLdrrcbTnVU+KTIXQSMmhRvRkF3xdnXAwsQJByBbUjOAUqgxD/4M8a2FjTFsKiaiX7bTsdyLdOCC9Yit7x3a7n4/5ONb2B6hQ+k5VzrWigmFNUOuh5+L1krIkOBXwffrFRrGstBy4fUHsjSiRXSLu2gGZRD/CYzwFYghqnjHGfmcx2XFCFwq3DMasN9y2n5tArGju0ELFB9q+GqMQNBCx+MqIQ8zppXi0h5s/4B9K2BjOCI3QGLS0Q6Dzegc5MrIU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The initial direct compaction done in some cases in
__alloc_pages_slowpath() stands out from the main retry loop of
reclaim + compaction.

We can simplify this by instead skipping the initial reclaim attempt via
a new local variable compact_first, and handle the compact_prority to
match the original behavior.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/page_alloc.c | 106 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 54 insertions(+), 52 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9e7b0967f1b5..cb8965fd5e20 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4512,6 +4512,11 @@ static bool oom_reserves_allowed(struct task_struct *tsk)
 	return true;
 }
 
+static inline bool gfp_thisnode_noretry(gfp_t gfp_mask)
+{
+	return (gfp_mask & __GFP_NORETRY) && (gfp_mask & __GFP_THISNODE);
+}
+
 /*
  * Distinguish requests which really need access to full memory
  * reserves from oom victims which can live with a portion of it
@@ -4664,7 +4669,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
 	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
-	bool can_compact = gfp_compaction_allowed(gfp_mask);
+	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
 	bool nofail = gfp_mask & __GFP_NOFAIL;
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
 	struct page *page = NULL;
@@ -4677,6 +4682,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	unsigned int cpuset_mems_cookie;
 	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
+	bool compact_first = false;
 
 	if (unlikely(nofail)) {
 		/*
@@ -4700,6 +4706,19 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	cpuset_mems_cookie = read_mems_allowed_begin();
 	zonelist_iter_cookie = zonelist_iter_begin();
 
+	/*
+	 * For costly allocations, try direct compaction first, as it's likely
+	 * that we have enough base pages and don't need to reclaim. For non-
+	 * movable high-order allocations, do that as well, as compaction will
+	 * try prevent permanent fragmentation by migrating from blocks of the
+	 * same migratetype.
+	 */
+	if (can_compact && (costly_order || (order > 0 &&
+					ac->migratetype != MIGRATE_MOVABLE))) {
+		compact_first = true;
+		compact_priority = INIT_COMPACT_PRIORITY;
+	}
+
 	/*
 	 * The fast path uses conservative alloc_flags to succeed only until
 	 * kswapd needs to be woken up, and to avoid the cost of setting up
@@ -4742,53 +4761,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (page)
 		goto got_pg;
 
-	/*
-	 * For costly allocations, try direct compaction first, as it's likely
-	 * that we have enough base pages and don't need to reclaim. For non-
-	 * movable high-order allocations, do that as well, as compaction will
-	 * try prevent permanent fragmentation by migrating from blocks of the
-	 * same migratetype.
-	 * Don't try this for allocations that are allowed to ignore
-	 * watermarks, as the ALLOC_NO_WATERMARKS attempt didn't yet happen.
-	 */
-	if (can_direct_reclaim && can_compact &&
-			(costly_order ||
-			   (order > 0 && ac->migratetype != MIGRATE_MOVABLE))
-			&& !gfp_pfmemalloc_allowed(gfp_mask)) {
-		page = __alloc_pages_direct_compact(gfp_mask, order,
-						alloc_flags, ac,
-						INIT_COMPACT_PRIORITY,
-						&compact_result);
-		if (page)
-			goto got_pg;
-
-		/*
-		 * Checks for costly allocations with __GFP_NORETRY, which
-		 * includes some THP page fault allocations
-		 */
-		if (costly_order && (gfp_mask & __GFP_NORETRY)) {
-			/*
-			 * THP page faults may attempt local node only first,
-			 * but are then allowed to only compact, not reclaim,
-			 * see alloc_pages_mpol().
-			 *
-			 * Compaction has failed above and we don't want such
-			 * THP allocations to put reclaim pressure on a single
-			 * node in a situation where other nodes might have
-			 * plenty of available memory.
-			 */
-			if (gfp_mask & __GFP_THISNODE)
-				goto nopage;
-
-			/*
-			 * Proceed with single round of reclaim/compaction, but
-			 * since sync compaction could be very expensive, keep
-			 * using async compaction.
-			 */
-			compact_priority = INIT_COMPACT_PRIORITY;
-		}
-	}
-
 retry:
 	/*
 	 * Deal with possible cpuset update races or zonelist updates to avoid
@@ -4832,10 +4804,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto nopage;
 
 	/* Try direct reclaim and then allocating */
-	page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags, ac,
-							&did_some_progress);
-	if (page)
-		goto got_pg;
+	if (!compact_first) {
+		page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags,
+							ac, &did_some_progress);
+		if (page)
+			goto got_pg;
+	}
 
 	/* Try direct compaction and then allocating */
 	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags, ac,
@@ -4843,6 +4817,34 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (page)
 		goto got_pg;
 
+	if (compact_first) {
+		/*
+		 * THP page faults may attempt local node only first, but are
+		 * then allowed to only compact, not reclaim, see
+		 * alloc_pages_mpol().
+		 *
+		 * Compaction has failed above and we don't want such THP
+		 * allocations to put reclaim pressure on a single node in a
+		 * situation where other nodes might have plenty of available
+		 * memory.
+		 */
+		if (gfp_thisnode_noretry(gfp_mask))
+			goto nopage;
+
+		/*
+		 * For the initial compaction attempt we have lowered its
+		 * priority. Restore it for further retries. With __GFP_NORETRY
+		 * there will be a single round of reclaim+compaction with the
+		 * lowered priority.
+		 */
+		if (!(gfp_mask & __GFP_NORETRY)) {
+			compact_priority = DEF_COMPACT_PRIORITY;
+		}
+
+		compact_first = false;
+		goto retry;
+	}
+
 	/* Do not loop if specifically requested */
 	if (gfp_mask & __GFP_NORETRY)
 		goto nopage;

-- 
2.52.0


