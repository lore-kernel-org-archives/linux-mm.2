Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6789FD0048
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B8AA6B0005; Sat, 28 Feb 2026 20:22:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066846B0089; Sat, 28 Feb 2026 20:22:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89EC6B008A; Sat, 28 Feb 2026 20:22:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D783E6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:22:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67D9B8B6EE
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:22:34 +0000 (UTC)
X-FDA: 84495744228.06.A67014A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id B1775C0006
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:22:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n4aaAXBX;
	spf=pass (imf22.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772328152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CUwDb7u4QkzV+lbnOr4L0aCPStaDNXvqKqMqZw2lRcg=;
	b=ybXeVgIDBtWnUow/DMMZgpDuLM4PRKkebMBLv80jHZ3S3FrqntK9N59ns6nGNmbqpnql8e
	TQGZFXhQeC3jHkMPiRvAYoclzDrD5fDWhCsat49G8cVotcHCnwDIm8zkWYITFIWAoltUjr
	gizgbmxdL1eo1uIIuSNL+n5Bi9UqdDM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n4aaAXBX;
	spf=pass (imf22.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772328152; a=rsa-sha256;
	cv=none;
	b=TkSitG6KcNDMNDPc3IgS9NaqjwW37ePrxg2hftmo4hlEy1xrrn1ss/xB2ZEv0MEDJKD0BY
	nkwEJtDy1JfTUAL8EPKlDhEPeU+sNnQy37pElhI/t0Jw83ZdiCVdBLY+El9lIhQrsCVLT6
	JICM1/NvkousyPzz+c8LsIHYGQx2DVM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 59FDC405E6;
	Sun,  1 Mar 2026 01:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADDAC19424;
	Sun,  1 Mar 2026 01:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328151;
	bh=mjakhQFwOfu3c6K0n9rHkBJ6KvJ7nFTHNV6JA2AQPiM=;
	h=From:To:Cc:Subject:Date:From;
	b=n4aaAXBXqBchi18REblnAOMYR03FMx896G3ChFEJMhQD8eTf0rzQcPxHNdsdnIau6
	 2qKpbb7HcX9jeLQi3SUmt2c7YVD4rym59gKEhVljeYwdV+pL4rQ6B3o/qBPiqCKMJ9
	 P30zZb9gYaisRj2xlkuCAhqhXjCm1Zz8/Xxsqnopf1XWGJb3Sm0jUejN38zERQ3Ob4
	 YGz6yJtMwV2HmtQebIM9CEsOHA/I2CgImiCXTiFOhBbczjIvu/T/gV4voviMayAJiP
	 Oh5/yieCwQRJVcX35BQwm3QUphkpb/5lUzWMP0hH/F6NFKz33GztX8qsiRTg/EQLjD
	 690ydPRC8cUiA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	vbabka@kernel.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Zi Yan <ziy@nvidia.com>,
	Brendan Jackman <jackmanb@google.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE THP allocations" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:22:28 -0500
Message-ID: <20260301012228.1678891-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B1775C0006
X-Rspamd-Server: rspam07
X-Stat-Signature: p3jak8apqmxq5um9g73fiodu498poihd
X-Rspam-User: 
X-HE-Tag: 1772328152-692686
X-HE-Meta: U2FsdGVkX1+HQQIVDnwt1KkwMkcqOOVqoYdXY4ReTHCHjujLNKzjXpIydfzDGNt9qHL3DcQGRB36EQDrltJfavaREaEtNxf+srtqfuftDr3PoUamv8yE7c2CE7QSR4bgqzSAj2pVvBiod9dfwWwU/EUTHqrxSmpprIvLKH4q0uRfHOuQhV4znogbxB5PK/LbocrYb8DTtblA1BCyg4BUCeYpVbi1zE1FD2/VIc67Zkk6G3E7CbUWAZOZNG8nMNVsnoEuVAcKbcK80cLnfAgb+RHVs6OyTDeI+37gnfN6Y1xH6T1OSsjBahNMmYVwCjXXiol58gLNYNNDXW4mo87rTl0iLqkzEpcFE8+9oZ58KY3uFnva30rhK9NE7vDXEExlg5RRfD0+0BnJvErIUfiCJQTG7RYRQUzFcEe3Ves6c7XqOdET47iOlX1QuRHQ+ty3nc254sY1e/1IeZ7TgK5E1Yn3betXitJWtshXEnl5m12LVUUCW0MwrtF6+IHpd1qRBm6n61WcxxdUkbl9JBBp5+J+2csxP32RwMHGX0IJUs4KnooxKzvsPKRKaEZQgP2SMJB3iTSk3ZIRrOLGYceQfLMNu9VRYVNfRaAptErA7nGsftEoRK1Xu0GWwzgVZj76Z3Aw9/CNgVvxEIa4dMkZfHvbzUbXfX/3cqG5NoDNVC5eaf9HclWXlRHRtzhFi56G3b6zBghmc6PWuOmC/F1/O9iffvd8zDpT2OqMQfeMw2HCveY5JkABUeq51pPcoLGjg25/P7qglqar2npGyNy3pA4rMxVRxeGp7BSaX005oH8IPoSOXcnDaD8FLZdiGLzer7MjDtAU8gkhd6Lm4e1+2vowPy5rS4iU6dKf+wBA+lCP499YxW3m6s2xFEVuQjEVaX3edRXl8wmX2PovPYivTPguC90XYUnNeO06j5kuljYAPNOW3p5lT+qB7HkMZRifJn5KSbXmpNcML0Uhmbp
 kc/f7EsC
 E7P49KzpNyDp1KVFzDliNZWi45bEgYdXp9gbQ1ufmcechDgYUp9Iva8fgUhA2wIV5BYLfL6sBa7hfb5ib5qIQX36SSrPVsRmomT0VGNBpOaivhFppZyB3Gokt6d2Imleu1DXRLpI1u9/Blym1TUiKZ3P14zP4Z6iIVLvfW75DB0T/XjeqDovO6GhurRCIwLgfojX4CS3xmxgpAoHgLY5bc836TiDcu91qtQNzegzbHUs/eiwmsnAI2QONNHDqMAy+tfq+cQOyHy9bUP6k9axm37CwSQCqQ8XYP//02yuSsh57jN21GjBTKnghn6eTxkI/xKNNf0yFJNMsH1QViJgoHU1X0yWMnTR5WkfkpAANisDsLdQ3v0rz9kbAp7kgY9sf5eJ7aIgPUWfr5ej6GTkqMb3G6z50bIJSOn6DURiZ0uzpyhiGJKV/JkIo+NrLPX+qIeCegWqGMbp95cYPerFlU+SLIKDbjBlZRCYnovJ+2Ov3aUvQtA03NSo2yzHTyOJSfw8kO5PTZLnBk31mgHp4DomE0O0Mx4ZP+SqUmY2GSdiAlfkFecojS+NRh28pvIwfsL4bUunzrRTQf+2ZMPuU9ji6+1Mhk+9I9NjdxQyek62RQO4HfzcDXet+bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 9c9828d3ead69416d731b1238802af31760c823e Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 19 Dec 2025 17:31:57 +0100
Subject: [PATCH] mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE THP
 allocations

Since commit cc638f329ef6 ("mm, thp: tweak reclaim/compaction effort of
local-only and all-node allocations"), THP page fault allocations have
settled on the following scheme (from the commit log):

1. local node only THP allocation with no reclaim, just compaction.
2. for madvised VMA's or when synchronous compaction is enabled always - THP
   allocation from any node with effort determined by global defrag setting
   and VMA madvise
3. fallback to base pages on any node

Recent customer reports however revealed we have a gap in step 1 above.
What we have seen is excessive reclaim due to THP page faults on a NUMA
node that's close to its high watermark, while other nodes have plenty of
free memory.

The problem with step 1 is that it promises no reclaim after the
compaction attempt, however reclaim is only avoided for certain compaction
outcomes (deferred, or skipped due to insufficient free base pages), and
not e.g.  when compaction is actually performed but fails (we did see
compact_fail vmstat counter increasing).

THP page faults can therefore exhibit a zone_reclaim_mode-like behavior,
which is not the intention.

Thus add a check for __GFP_THISNODE that corresponds to this exact
situation and prevents continuing with reclaim/compaction once the initial
compaction attempt isn't successful in allocating the page.

Note that commit cc638f329ef6 has not introduced this over-reclaim
possibility; it appears to exist in some form since commit 2f0799a0ffc0
("mm, thp: restore node-local hugepage allocations").  Followup commits
b39d0ee2632d ("mm, page_alloc: avoid expensive reclaim when compaction may
not succeed") and cc638f329ef6 have moved in the right direction, but left
the abovementioned gap.

Link: https://lkml.kernel.org/r/20251219-costly-noretry-thisnode-fix-v1-1-e1085a4a0c34@suse.cz
Fixes: 2f0799a0ffc0 ("mm, thp: restore node-local hugepage allocations")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/page_alloc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e1cc0c9ed9479..3333524e879c4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4818,6 +4818,20 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 			    compact_result == COMPACT_DEFERRED)
 				goto nopage;
 
+			/*
+			 * THP page faults may attempt local node only first,
+			 * but are then allowed to only compact, not reclaim,
+			 * see alloc_pages_mpol().
+			 *
+			 * Compaction can fail for other reasons than those
+			 * checked above and we don't want such THP allocations
+			 * to put reclaim pressure on a single node in a
+			 * situation where other nodes might have plenty of
+			 * available memory.
+			 */
+			if (gfp_mask & __GFP_THISNODE)
+				goto nopage;
+
 			/*
 			 * Looks like reclaim/compaction is worth trying, but
 			 * sync compaction could be very expensive, so keep
-- 
2.51.0





