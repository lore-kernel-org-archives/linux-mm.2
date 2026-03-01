Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81816FD0049
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 02:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBFF76B0089; Sat, 28 Feb 2026 21:01:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8B4E6B008A; Sat, 28 Feb 2026 21:01:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97D46B008C; Sat, 28 Feb 2026 21:01:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA4976B0089
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 21:01:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B28C160427
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 02:01:26 +0000 (UTC)
X-FDA: 84495842172.19.8239DDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B0432100002
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 02:01:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WhX3CCv7;
	spf=pass (imf05.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772330484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pyc0Psy8IJkdXQoTaubOCOEafRQNp888B9QtqcTUa+g=;
	b=S/CJShKMbp1jdJuGYKLa292YtrYS6xbdNCXiCa5lGTGzywSNKLzrU9Rf0SEcauVXRVaBtq
	+tWchyIYWvh33+wlAQF0Fe32WE89EJEALgRHGX0ij96JrFiKNs54c06N+9OKC+GinUc6x6
	qDt/D8/omusjUNIeQ+xMfgoHVXdhx2k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WhX3CCv7;
	spf=pass (imf05.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772330484; a=rsa-sha256;
	cv=none;
	b=kjy/Ww9cSZ0lhUzvyZKQBioFJF20sKToZMXX3UIb014Cm6wpi+SF8Rvlkh9mT4X+TGL/n3
	6fpvCb79civjrtAvpW+rBzGZybTEF0dnh+gMSstgdyTcgbpIChtx32a9BcyE6DDtHAHB7d
	5EuwITafU71F4wKXYQMChhP2jd4KC30=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C93C143E06;
	Sun,  1 Mar 2026 02:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0695EC19421;
	Sun,  1 Mar 2026 02:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330483;
	bh=23WUSpufNuJyVS16pGiGEqHAg9DePnjrVjf+RZirwCg=;
	h=From:To:Cc:Subject:Date:From;
	b=WhX3CCv7t67NT1YLHDGi67VbF3SKlrwfg6Nn86hZFsEhB9hMnFRGsnAH54NmrTz46
	 VG+ASQ7Fdsm4/UYW86XgH6tB1oo7H7HlahuxHr3y1br2OACfuoknEioCHuqtTBxPz0
	 Q2a24mfDh9O29gKpveS00is463ZoX2IWwzGwdzbEsLx+FXlxY6MNY3IFEHK4hfW0Tb
	 EETKOMrWuHtWEkTXxu1Vw2dOOwIZR4zcLjVTFL8/+gvVkDzYDsIXFqspHxs6C2ECkO
	 CXHGgvxYKQXS1WBHWTcgWL6yLfRLcRdH2PMVGUeZT8s29+bnlyZrwslNlP22/VP5BL
	 QklCxShiwIt7A==
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
Subject: FAILED: Patch "mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE THP allocations" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 21:01:20 -0500
Message-ID: <20260301020120.1728638-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B0432100002
X-Stat-Signature: rdjjgzmyiapybqgqn5xcyz9hyc55curi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772330484-35069
X-HE-Meta: U2FsdGVkX19xW20lCPLDoJla+d60d71H1UpZWjoW7qpynJHbHE4FSCDORk52JF7gVqkFYDeOmSu3BzcMixeHYCb44M+H8DEr/rK2LGWRrlPTb+URsuoOLbtOpQdIu1KH9xEVaJnLpMhVRfY1ZfoaGwNvhQrkx9DYEYhSl0qr1BZmWmYyKaCvBME/Qw8+vgZb/KvnAHGpDPBlVLIUNiUwORtQmx0JFYGz3K92XL7CI26bnyru6K9hKbcpOzGM1V/fXsq+s0ozYw/VjpIzfVHQ0P49h1snYMusvl4hCkvGlHxOgXgRTVdp40ZO2AwMosEv7ZN4vo3Tm0YMbVCSGsccoYsyo0WrOvI0fDU+Eh4mhAnnZwVG1ECpoMTtdPFkxYFvjRDZXUAgPw/PSTY/l1wud8Y+U4Sxnx15cqPulHrU1c33rD/jnUCczHGK+pK3ENDA+oLISmzTNRLBOJwDyT/k1PvY7Z3ymcaEwwQ4lz0PAfz+BW2IlhwUGIY7QXcK6xoRCbA+YWhCFruVPE3j2ePoJ8iXBmOlqfSkHfi1iJ9F9c2N7xpw8hsM7EkXsMnkNS41WNa6JMwgHz45Z5fl1OEvZSgPp368E2HuKolk//kHmPZNA4w78RTIl/fFgoBwiNLcprPH0hcjAkeeUN2Jb1YtoSEhJsCiZVRs4E7oRWXKyIH4D83Vpk0+aAwXLmrhhVSVQ9yQ7iGS+Ldsod8ZxD/ZzkgIVKKseff66lJ2pOBEdwlSfkpXsCi2gv7xItOD2JAJS2eiWRDYR/zghUEqmpQRBEOlwRwsxZvld3XTrRp8YDD10kACUiCwifybu13zz78Dt0nJSISb3pSQFoxpxOg9v2lGKplWAt/Ro3R8h+E+hc5X0nZne1XgiMEVoRP4lGs4CkxNTRUZcm7apm6rPVKIu9RnKyXHsD2OxNeB7PiDRJJi6meG90VqVXHvnpoNmQFyWNwTyvKCvfwxrgVzplA
 TZ7qfXLJ
 HvMd6f/Y/y8K6jBbScEP7vdq7OmgrZHyLTkbL4pkMQUHXHverLwWucVXE8qsB1IDmIf9FKCZsbI3VhqlrgCi5RnDCwLrLEGfrB/jKkyAhAZhd4P0LO7bRgQ4ahV8ICSW8zqC5mdAVkKm4w2BfDJ7MYnBjVZ03BVTCFOtc9CXC7e2bDxltn8bkvjwkAd98pvcDHRsFPSPPbh3ixd8Non1XmU04FitB0xLrqaLzX/ZH6R0ydg31P3oCXjyMISQ4R0MAwBN4xBXj20DEqNRVklmRarqyr4jXU/+T/qT4KKsYK4RxcSbQP136wWXLHlcmvJVnPWUupiU5PNKjJ5YtvUy7pEkJOkze3x76zm3uy+ETGHnXh35ZSr2/qHTkNnkqgmzgquw1HpuFnqnan0f9S8Hiy7bj3xioHeuGTfYJy2zkwE75Qk+or1mzHN6pkvHaaz9oMGZ+N7jtZQTwNXZNPxctH3iZkktyEVBKg0prZgljuu9YiKB0gT4MOLZKs1j1rlutjKE38JfQQfwnMzPoOrVOBvAwJ+s3yw3dgZhUwelmzLbP3KayBs3HgOfeqhjCEIJB1Nj/t1CgUWMJKoEZlNjsyxYi1HQ3FdDuMY0+8Ysz3Qe4+X3DcYUZoXfPfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 5.10-stable tree.
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





