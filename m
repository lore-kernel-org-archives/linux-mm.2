Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC273CDC167
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DC506B00AA; Tue,  6 Jan 2026 06:52:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BAF46B00AB; Tue,  6 Jan 2026 06:52:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CA606B00AC; Tue,  6 Jan 2026 06:52:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F01156B00AA
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:52:56 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A34B4160550
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:52:56 +0000 (UTC)
X-FDA: 84301377552.17.8B9D5B3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7D26B140006
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:52:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767700374; a=rsa-sha256;
	cv=none;
	b=JLWKMvTNOi3snrgXWS/vL2iysuqtkDGF7NWbTH5Hxga0gKPjImhyIxlQHEknq9jZHLCma4
	N15aHjC28AlEriDQXy4hDmBzEqby5Dl8m7SjiCU1DrLKYZ1N6/+zcAxNyH1fy6dbn7PBLR
	kO2GKiTb3zpNyxY8fKJt4lVEiD+Og+I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767700374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lnZ0VzaTf3+okyEdUtiuaXO7Ky6m2jcyVXyYCQc7SgQ=;
	b=U49s2p9BkjpUmW71wycNyEVWcGTmL/9EkNeeXY3cU4NBBd1lFCMuAa5QzgxrpuRIR8WENC
	ayg7GsH7j9ut00dOBCL0O5x5v/bTQfHT7z5HVBgiBLgDQq14RiNP47JAIf+E3KkGJJO5Pr
	P0NYb37LdILxeBmV/LvvEXmAqEH+w/0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 414E0339E8;
	Tue,  6 Jan 2026 11:52:41 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 221803EA67;
	Tue,  6 Jan 2026 11:52:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gHEGCIn3XGnsZwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 06 Jan 2026 11:52:41 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Tue, 06 Jan 2026 12:52:38 +0100
Subject: [PATCH mm-unstable v3 3/3] mm/page_alloc: simplify
 __alloc_pages_slowpath() flow
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260106-thp-thisnode-tweak-v3-3-f5d67c21a193@suse.cz>
References: <20260106-thp-thisnode-tweak-v3-0-f5d67c21a193@suse.cz>
In-Reply-To: <20260106-thp-thisnode-tweak-v3-0-f5d67c21a193@suse.cz>
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
X-Rspamd-Queue-Id: 7D26B140006
X-Stat-Signature: xbsrcwp11nh3ysobyyufd13mcfuxa1pa
X-HE-Tag: 1767700374-720549
X-HE-Meta: U2FsdGVkX1/qVc8zma0Lxc50hbvJAAYA5vhPFaIt7LD6rwx/lt2zVUCnyUjP4Bmi4cRGzrLjvXxNXxx3PaHvdG1wJuVZ+LQa5QSYnaJWjL+wekFAvOd49h5tgpgdzL3ftMW6qSPdBvMvmJXGNlPL7bRh0vXEhaDPuLJ3aXcWGQzuxGKTjamvvPstObIH4DP1UQqpyCOa8pp5J3o+Q3Kzu6w2BIq/+jvRY0ijA1g+SFQFtdEWXfRKnwTKVL8vg3JZ5Shp134DsL0ppoP24dCRlwOlviP6MLSAsoneCO6sn4wZJbVQuAjuCILTDKYTDDnUtiln8vNl8HHxmHGaOGjYiVeJIQLQVCJigaGIWUMJCXez7J2yjUoFTdtGECJo2tKVHiTkq8MXbMRsGomFofMKH24uawhiR+H8LfC9aGkpXEtkCbP6Z4ba58txwfiTgR69f9IHTg0XTY255lUluddqxMl3gQSDvGntpbEISyNOQZ0P3j24whBQhlektp1mmY3HOwxWQXfLpkn+rFJ3UNljIyYvP6okMhHpg3ozn+AsDM7PUXHn5kA4aGldsAfjMyXKDLiypzh2rC0Y2BGrA6M0K/H0tgo+lLFdR11/uDdEqzXBJxTMSNw5N8Q2NfasCtGvaNjPQadGnFRPfTkPCYjCQwwtDzVEVCTQpnBdHWPxx87sZB+HyU3XIrG6viXBHLQM+xO2fBqtUt+UBzGDoIxuInXOaBvI3t6zl8cbHG8+YFseFvZaSafUCfXggc5lkRk5oq4Lu/9K1p8PS0M9wLgFTFwTDkuztaa8DYNB6Ukbmp4ZgbeUNsFpiPGgpDhXmcIhG0DrL6n9uKVljTImx7TBkefPOU9/p02vvoPb7SuqAdbiyXtGNPQUMXW1k6s2RD6MdEATqo7Ie6V1VcEg6gcNY67vLsdrSBAdlhvTLWuvLLVHnPqhuUFFRM2xiaMO7wmAZyC6ImgDQt4nRQrtXTg
 5ky2fvdG
 qrL416oMdp9buyPgkE6d1HXr6LJJ4R3VeqiGwEeeleZDHtluCpq5NfxEqhr+ymdCVJITBHlpOfr33D2vh3piwIh7Q5rQ5iN/n8825nK+ljRX21GekZ2JipmpgQH5F+xgtDsQNAIjIclFv+h9RAkdhIj5UXQPBeGBEo15pzdWisVDMZwM=
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
(due to e.g. becoming an OOM killer victim).

We can adjust the retry loop to keep only one instance of waking up
kswapds and allocation attempt. Introduce the can_retry_reserves
variable for retrying once when we become eligible for reserves. It is
still useful not to evaluate reserve_flags immediately for the first
allocation attempt, because it's better to first try succeed in a
non-preferred zone above the min watermark before allocating immediately
from the preferred zone below min watermark.

Additionally move the cpuset update checks introduced by e05741fb10c3
("mm/page_alloc.c: avoid infinite retries caused by cpuset race")
further down the retry loop. It's enough to do the checks only before
reaching any potentially infinite 'goto retry;' loop.

There should be no meaningful functional changes. The change of exact
moments the retry for reserves and cpuset updates are checked should not
result in different outomes modulo races with concurrent allocator
activity.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/page_alloc.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3b2579c5716f..c02564042618 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4716,6 +4716,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
 	bool compact_first = false;
+	bool can_retry_reserves = true;
 
 	if (unlikely(nofail)) {
 		/*
@@ -4783,6 +4784,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 			goto nopage;
 	}
 
+retry:
+	/* Ensure kswapd doesn't accidentally go to sleep as long as we loop */
 	if (alloc_flags & ALLOC_KSWAPD)
 		wake_all_kswapds(order, gfp_mask, ac);
 
@@ -4794,19 +4797,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
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
@@ -4821,12 +4811,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
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
@@ -4889,6 +4885,15 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 			     !(gfp_mask & __GFP_RETRY_MAYFAIL)))
 		goto nopage;
 
+	/*
+	 * Deal with possible cpuset update races or zonelist updates to avoid
+	 * infinite retries. No "goto retry;" can be placed above this check
+	 * unless it can execute just once.
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


