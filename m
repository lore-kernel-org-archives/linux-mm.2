Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2961FD0045
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3826B6B0089; Sat, 28 Feb 2026 20:42:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32C746B008A; Sat, 28 Feb 2026 20:42:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DA666B008C; Sat, 28 Feb 2026 20:42:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0FBE86B0089
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:42:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AEA0B1B7DBD
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:42:57 +0000 (UTC)
X-FDA: 84495795594.12.7C320E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2769480008
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:42:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l43vNT7Y;
	spf=pass (imf30.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772329376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nE690RGbRj1W+FjEFXQeEEtsm2MDfi9PmIMHFvnNorc=;
	b=U06vI2DohLndg2tAokvem5D1rtCPR0wHgVYeXGmjBnCr0ilDhvTBLyTfydVorh++lQ4fAO
	b+38KJqbDbmIwsw9OGATvbBFfTZAWHgpmbwBhY3S7Hh1T1HXeaXA9WTnBPtV5e8QTqoF4k
	JhDiyqgAw+GgL59fg7vuhnVXStrbroQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l43vNT7Y;
	spf=pass (imf30.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772329376; a=rsa-sha256;
	cv=none;
	b=uVQgjy+PlhWnVcLdsGsDiTyP4tjcIY0dEb+B43ceLp+54fXcBedpiETqXCcl6WorCevIsv
	QyAMbev0jrsoKnz3f/00qNdRX2d2BMYqiFEjGp/3GlOm+0j54c5IoS8hKgd3joRXnbiD15
	tbNp/dYr4gsHkZEw9bSjyzdWX1tDVt8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 903316013C;
	Sun,  1 Mar 2026 01:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDE3C19421;
	Sun,  1 Mar 2026 01:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329375;
	bh=tksX+9S5JDwFTjWOdD/EGgtN37eSD/ynyq68jTSBxow=;
	h=From:To:Cc:Subject:Date:From;
	b=l43vNT7Y+abQ37rbpEDa36NZQAXo7ksvm8jI7h7Fa5PAoUv/c/KFE877oYdSWsHK3
	 hCrwgB2UCPZfa4Hsn/8wtefHFgcAIBasqjoZyWp7y/nj2EZEKheDW7EeROS3OD0n4W
	 CzLPvgl/AsEqYUpkri71p1k3Hc/b84t9e1SuhbpS8uiOnNsDxRrrMHyC6ct2/j/y9w
	 rydHnFCVbhsPUsKDUMr/6SIQCvp5M/iUaSRzkFZiE7XGz9dxmAweVrrLiZwLuZFpuW
	 o5s3Lv8xd3UHWrvp0v84EIBgjaDhKNM9NXHH3knagBwEohFCoRo6SSN1l+dh7NqRLv
	 CYzkAfz7itAHA==
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
Subject: FAILED: Patch "mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE THP allocations" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:42:52 -0500
Message-ID: <20260301014252.1704825-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2769480008
X-Stat-Signature: asbrjneua3gm5s5hxtzbuqbo4iuxzgo6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772329376-222434
X-HE-Meta: U2FsdGVkX1//f1XSD/mx2J8O3G9/sF17XrauSLB/mS3rmuxIqYmHGMnwzgzmVDQ4ReF7AlWptKXJLYfpEr0FjfDCwN9P0KCRaZkjatZNFNsZueWLhOo4fOv47SNg8wc4onG5sQZiEEQHD0wTUG2hSVCwJ8mU4/agKHXdHf5w0Yj2VnNlwTt1Smc0StUAbWD21FDv2BV3Sl7vkvMFbKWjazOhMqcF9vIuGPoGggqrUCC8cYfUXkC2GqWYZ8rfyPnt5dLuy96145UVWDXywQ+62+4vJ0NFJmWfgVxXcryjlj3sFusAMFyQghbs0GKbdTdNdp4llBgKZBNt1XPOspn7OQaILR9YnvOPq4M3Z03ECkWo84+Vs7/01bfy8oESwEmwamXiJR3eMzgjtEo1ypJ14IHtBQlEtkVeLaIPTEEZV35HufsokuP2rwh0YwpGMoVU2HXoUp0EAtqxdcWcqpCMgYm+MEA4FxuEfvptlZ1mOt6xASHK5pAsgKVXySb9tvymOe24+tgPShdGhr6nG7T7iKIu7Tx7pwSEv2E7Jiy1B+PiDfIjJ6RRZOrLcBUc4y/9aAlSm27h4MaNaI7OxC3bNqEzsSRHx+LPcXNT65DyrxF5hOV6HDKdcTvyWyi3Zpb79J5vY8Cgk6+ncJnjMxSAhPv2XhuEHGj2+gQBzHuX8xTmL19aU6kTjeGy3jXa5FLk7bPrVWDSw7Ll1yb0cEdjTtWMXA8A/0GM/uVPhRByaZocgNKfRICDfN0I59QsOR+uTgWM1zCQJJEwaX/VpTZWiCVV40dFtGeuhRYT2JWmyacHnoAGRg/Om92ynS0WAo5bpqtjUNkakj17X5y+at3clQOGskjrsSO3xDO80YFt+u2GHEtUPmOMlaxP+pgSEVVhQQ98t/hyoaI0EQoF3yQ1TUc0YaTek+aTqZGIgLQS6+uk/gRwh2J8BwY4wY+8PNAl/FbWN61iO3kpxKgXCLg
 K8/Ocfxz
 dFNhJlAh7RLyAcdF8HQAgGA6que2O+MlpN8gicPHSNuwOZBM+fvdUnEG4S8+taANYMUM8B2VbWUmhM7NkHLD/gD3hj2zAJ9CHtz1h3LynS6TfG1ttpnW3Y7b/sxzYR3nXKsECdAJTYGSHL/hJW2//O7S1PBwpCo0551ZV3OG82boQX4w88AonU21K8LqckfKoI+7QdEoA3kpFnK5sNkyzy05rKKU7PiUOD8R7jZdVq6UFEWcxhLO9Csl9oFZGL7mORQ1ZxKmjjw57APPRhbh3k8GIw1/NSk61ZfMwuUHADXhB5yYdH5NxifGw7te5n3358QeNuOVKPfSwW+ZU7s8xD3NmD8fJkqLwC0LXqDqXLS3IcTMVGHofCQbBJresgk+aCvcyJ1pVGgQUsOLpR4b6Lfa6iRff2c1Qe1AvxS2q+xAiEs7lGy+Ez8ONgOIawriBMuAM9aKh2jwmdnMtQ50lwE7ahS6uo+mAKk5d/IV4GWJ0cbtRKIZ9LBLvSWDDD0hzLWxAloaIwJlXzDQirIRhIMoVST85jJl8oHi9KgymfwmsIdIasJVUVzPce7yGvSDAnz4QfaNI0G8q2k28joaa+5iBRwm3NTmBN2Bl3gXrz+XDx6hMmeiw3FJO7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.1-stable tree.
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





