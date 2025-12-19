Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAEC9E66883
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 17:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD0A16B00AE; Fri, 19 Dec 2025 12:39:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC6CC6B00B2; Fri, 19 Dec 2025 12:39:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26096B00AE; Fri, 19 Dec 2025 12:39:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91BA56B00AE
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:39:03 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 41880584FC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:39:03 +0000 (UTC)
X-FDA: 84236931366.27.818E473
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 142D34000E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:39:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766165941; a=rsa-sha256;
	cv=none;
	b=Ke4lBuV7jeCwjSP5QOIw8JrjkxR3KKI/pPIEku+aA/j4TWr8g2gs4lNaOJP7CkhwY95hXV
	pIJuCRYIUBY7C4MeaKgJ09cIopnrXe60QI22Yo2BbfLZdzIYl/r6D/myU88gYiu+URw6RL
	xnClAy+iVxRCZdOCH4LGmQbr593wBU8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766165941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=20OkoImjLBtRVL7Zp8Sqzhy7baS1PQBxb71Yysa8jUE=;
	b=v/kgvBnoyxidF1RKqL+kRXqp89gOtP7EufmQA7FYFafjKVC/9JYrsT0wv5tfUqpor8yUpc
	Ud6ODhdDfbw1El9fBwJBcFthA4chzEUcBD09A0ULKeW9KUYs7K6d5v56fVpCb45jbdhre9
	9aOz3UHCVQ8xzsnLd7TljeA3Vd+GLXE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E0E545BD04;
	Fri, 19 Dec 2025 17:38:52 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C52E93EA67;
	Fri, 19 Dec 2025 17:38:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KKzYL6yNRWlTYAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 19 Dec 2025 17:38:52 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 19 Dec 2025 18:38:53 +0100
Subject: [PATCH RFC v2 3/3] mm/page_alloc: simplify
 __alloc_pages_slowpath() flow
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-thp-thisnode-tweak-v2-3-0c01f231fd1c@suse.cz>
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
X-Rspamd-Queue-Id: 142D34000E
X-Rspamd-Server: rspam04
X-Stat-Signature: w8jf6htznyu9hbp1kc1wd78ub596d8s8
X-HE-Tag: 1766165940-134822
X-HE-Meta: U2FsdGVkX1/duA/OhsOkBpcUHw5UiMBh37jhvauQPuwq+/FAs1PBajF7t7MFK6h2aoQ+AO5MjkH/lseAEW9H0osJ3VS0KU9gXjxes7fmVviL8fz1r6VjHQ+ATbwx/8hiZmJgkvvJCzJyVgOhqaDhuYg/5s7Xc1YKh5K+pNxXsNQtF4qKtWIpd90HxnRYziSucz8Sa4dUYSBgFQuHLC2BRw18DzZUbW8IeFsHbKH1HV/l48HGCF/dSVjPFvvd5CwrATKF2AMLPOj0xZqablzR/sUX7/jmQmLMNPUJgHhHpenTyvhO3H6Bs2JzIfGMiE2l49stvgh5cMmF4nYmrTKQ60S86yYhp0RSU9itAzn+JeRenLiUkxwEwvVk7bAC34R78Eu+QpLA+AdTMQw7NlaCacZ81BT577UdDJPTyDdCscZi7AlirraQifz89hPrNbZMgO2K3hB5tLwVYeHJQGSdf0cbciMXI5hXVO3JbL1AbyigtHGSTL2h07w/vqAZXRw4S6c562kj2xumJX4Lktx2PTGtQjQNKo0m1+Ijj7aNjSq2uv2mAA3Ijd02Hjw+3JQQU/OOxkwqen0gCiKCOAuUBt9khhQGtclzMHM+N0+YiwJYoIJI36Ug2mGf7TuaOuDihKcZjosYpjCanY5fHVsMu15eTIa9wNl5nvqywY9LG5bEo2lLI6WxzSUbhe2VxlFSQI268g/47+Do4FvG6k+ZOp5BE8FCt0wSgT3yor/qoCQ4QmT+cArXSjz7J5zZdAyvUg0GG+cX0C1V39qRBUqRoVjdmUpGr6DY+Ft6Kh8/Nw+9KfNFQfBWAe406zM7e5AyonpzOjtxz/xiQ/mKipHMo4ox9lhO+RWchQNMbdWmExCbECb4eZKnzx/QOxz/QYC+Wfb6rmxtPDyK1FaAWZIQ0xPMvZYYxbCS+gMWLBntPg886i5JIjZnmGiwkvrA5t5XEVHAIaYTDV+jwinbAnn
 zgZIM+x2
 C0+q283taEQ4oDh1Gwaf1RQeuUewqKe9S+vQlkNxqGIuckzWglVjn99+0WmPdJ6g2ByrpZXPm4NW+ZkiygeuziamrrQreFcsAHJZfwOVdfGYmYWjWYjrhkfy1BiwzVHPk8wmC/CEJj3dm3NdlYAMJGeb/XsLKYDrNLJOk2U1QtI2u8PQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The actions done before entering the main retry loop include waking up
kswapds and an allocation attempt with the precise alloc_flags.
Then in the loop we keep waking up kswapds, and we retry the allocation
with flags potentially further adjusted by being allowed to use reserves
(due to e.g. becoming an oom victim).

We can adjust the retry loop to keep only one instance of waking up
kswapds and allocation attempt. Introduce a can_retry_reserves variable
for retrying once when we become eligible for reserves. It is still
useful not to evaluate reserve_flags immediately for the first
allocation attempt, because it's better to first try succeed in a
non-preferred zone above the min watermark before allocating immediately
from the preferred zone below min watermark.

Additionaly move the cpuset update checks introduced by e05741fb10c3
("mm/page_alloc.c: avoid infinite retries caused by cpuset race")
further in the retry loop. It's enough to check those only before
reaching any potentially infinite 'goto retry;' loop.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/page_alloc.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cb8965fd5e20..4a68adb383b2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4683,6 +4683,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
 	bool compact_first = false;
+	bool can_retry_reserves = true;
 
 	if (unlikely(nofail)) {
 		/*
@@ -4750,6 +4751,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 			goto nopage;
 	}
 
+retry:
+	/* Ensure kswapd doesn't accidentally go to sleep as long as we loop */
 	if (alloc_flags & ALLOC_KSWAPD)
 		wake_all_kswapds(order, gfp_mask, ac);
 
@@ -4761,19 +4764,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (page)
 		goto got_pg;
 
-retry:
-	/*
-	 * Deal with possible cpuset update races or zonelist updates to avoid
-	 * infinite retries.
-	 */
-	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
-	    check_retry_zonelist(zonelist_iter_cookie))
-		goto restart;
-
-	/* Ensure kswapd doesn't accidentally go to sleep as long as we loop */
-	if (alloc_flags & ALLOC_KSWAPD)
-		wake_all_kswapds(order, gfp_mask, ac);
-
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
 	if (reserve_flags)
 		alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, reserve_flags) |
@@ -4788,12 +4778,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		ac->nodemask = NULL;
 		ac->preferred_zoneref = first_zones_zonelist(ac->zonelist,
 					ac->highest_zoneidx, ac->nodemask);
-	}
 
-	/* Attempt with potentially adjusted zonelist and alloc_flags */
-	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
-	if (page)
-		goto got_pg;
+		/*
+		 * The first time we adjust anything due to being allowed to
+		 * ignore memory policies or watermarks, retry immediately. This
+		 * allows us to keep the first allocation attempt optimistic so
+		 * it can succeed in a zone that is still above watermarks.
+		 */
+		if (can_retry_reserves) {
+			can_retry_reserves = false;
+			goto retry;
+		}
+	}
 
 	/* Caller is not willing to reclaim, we can't balance anything */
 	if (!can_direct_reclaim)
@@ -4857,6 +4853,15 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 			     !(gfp_mask & __GFP_RETRY_MAYFAIL)))
 		goto nopage;
 
+	/*
+	 * Deal with possible cpuset update races or zonelist updates to avoid
+	 * infinite retries. No "goto retry;" can go above this check unless
+	 * it can execute just once.
+	 */
+	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
+	    check_retry_zonelist(zonelist_iter_cookie))
+		goto restart;
+
 	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
 				 did_some_progress > 0, &no_progress_loops))
 		goto retry;

-- 
2.52.0


