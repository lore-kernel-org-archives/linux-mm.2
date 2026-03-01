Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A217FD0049
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 752046B008A; Sat, 28 Feb 2026 20:33:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FFCF6B008C; Sat, 28 Feb 2026 20:33:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FE596B0092; Sat, 28 Feb 2026 20:33:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4B26B008A
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:33:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2C8A13AB6A
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:33:49 +0000 (UTC)
X-FDA: 84495772578.02.C20BFB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 21342C0007
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:33:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ot/UjyE5";
	spf=pass (imf22.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772328828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XFF2khzrWziEZW0OrcoShbJzS63VAAokHvvxgtiKM3w=;
	b=J5zJbQKwcQ55B9RKxOGhJF7KWNHUFK16lez77dYg2fAeE+zh/CXcWO5UgP2bwzNxQRsBlo
	r2dX1g7jpTv3FCaIqwBGP135fXp/FG9TTq/W5E4NrNZiuFQOpKxiWgI546KH6f84Br+Gkb
	FdpQw5cQMuVPoltOucmudy2ZEdhQFac=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ot/UjyE5";
	spf=pass (imf22.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772328828; a=rsa-sha256;
	cv=none;
	b=hM8cVI/db7d7DuYH1xH7zCB6Zmeu41hXJTLWXYOyuJ8wUZBLzyRfEsZPaC6kgEfeYnsJoR
	7P5sXQPssh6odq/DcOo/GIIiPgZjUY7b1tFey0qw6BakTK/+TF6Cx+thc2gCpMPsPWOBh5
	acRzKrXaMNmdvmFERAyU78jjpdqcUvc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F85B40804;
	Sun,  1 Mar 2026 01:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699B6C2BC86;
	Sun,  1 Mar 2026 01:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328827;
	bh=Ss2xImFuN7plPk1WKKDJhY78rLkPNuVd0tQWPNFF7Qg=;
	h=From:To:Cc:Subject:Date:From;
	b=ot/UjyE5Ao50Gqfx4Je4I7eGFBq0LXPXz2hgqVLW8paphcUPcSfSro8OcnBQY6wSb
	 zlc+fH7ND9/dsvS8G5aTrL9XYXYLAe/Gg56tMMh/pTjGLqJR+fA+qm4E/4aNP6tHvA
	 Dy0fDQscS0ylRDSN3ILlAmseZOv0dW79ya18p4te4XuKeo+G269QJlnKPFX4cisQUL
	 +7gthlmfnXohRfNao0z9bdmeHalrgh2zQNiak229+8tA4/idLg24Qiywb6Ov+RW0Zm
	 suaLGh2mb265nDnvSer+I7LG6pjylrbgpE8L03QXmlckRu/6wnywkLEqsGzprh+erd
	 K9fFyBTOdQNjA==
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
Subject: FAILED: Patch "mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE THP allocations" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:33:43 -0500
Message-ID: <20260301013344.1693034-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 21342C0007
X-Rspamd-Server: rspam08
X-Stat-Signature: gmar7tuxqeqdw1odnpbb3c4e5odp6agr
X-HE-Tag: 1772328827-21083
X-HE-Meta: U2FsdGVkX19ak2XdXeYKrDTUxhET0dgu96VrAZiT8cOtQVfFEiM8FDoeWWK8O9imYtNrEQyRG0OUYdkKBnAf6I7ACPv9DZkFe7Hg6h+dbekZasQg2v2KHd24hAiEvDdM7dpdKgaRHsSAAXPUl+pDnq8d7nbDmorU8GTar7UouLKRhskpYq1IteidKdvSCB81NwHIYBw5oG0mpcq6E3gxz9b0/US1zzaDJHRWuZP+AnN1pHEd00Bj4ECmYqu9A7rAtfR8Gna0MQ9gEz9E5h+9JTyNy+/y3VDJmdWbKc1GIoviBlwdmB5b8xunYxh1Gaq17R+G2Pv8I4x6lIuQ1neK4JUemcHiu3ORIU29WK77em68NwXShlpHWPuoyxm1JYhsHBZCgD+L09ZpifGY9cbL219NFmKe4yFFEc0XH8ZV+UQ/eCUzMsWC5+keKYgkkN2KY5qJnSWV4QtAmnsuZ8JufSH2huaNRYrx/BoaXOpXYXa9i5kithmkmfcMJ4KkdZprBD9XlsL3KKX2UkeVjpCYBB8xMYw5WEqwK+zqXbpkP6FEQnILtgzXj2NO/pFGY/VuOopSUi44ABZFtN55JqHgznn3hXvDNtOWc3f+CUxcW6W97hjC19owhzy5TAjvUzynPWzJmTIvz8/NLJSM29MytF2fcnlc+CPVTDwlaDzSMnPgagpli47ymn9xVkS3WWWqJMvU91ce6yWXQdQyw2/QhQeC97lBpC7Ztx/HEkAeMeRY7vUU0oNXjIh0T/cxkeb7e8m+v+Q12BDwULbVuPNskwohFgy9hAO5UQ18sfiFL042pQ/bO7ih3fzfUHGVUmZB9vshQv8Ap6Px46ctFTMkS5PGGHIGQEuZqwNGpLo5UU67K7ekwKrJGwU58eaAGDZO5YUbu5egvpygki/iQkNYNiOvx9gAWD/Kk8NY8iLE6dZIENgT+BubiefpPjv4S1yVzAOAlq5ELrWmiMafOVq
 Z4KWThTC
 NoDEgOCk0Jv6h+Vca9jGAKbDBYqPEpdXFa6DiALhgazNckc0heEM3CvLZt3AWU3bZASQOHeZukhXF4imJwyJLkjUDiNhX+t9kfViK/q80IN8xtre5QZL8uMpZ2/D2ZkoV7MchBZ69ajovmbs2+R6iJ1JEohbntR3xVfLk9EH1JLtiq2icAwPguoD/jXLniocV70hpd0rbZGw5NA+/fNTxMsNmG331W6GDz4zlK9OJD5yb6p5q2ANSv75R2DOP2GLFA8pScUdXKs3h+U9ZkZm1x2i5KeUn7AhzqlIO3O5bN5/ogUqiO2t+Q9SixjECNcN8mqlg7wpWowrAIeQLloP5srBUQNE2MXFVkyOUM1dlk+18Sru7ZRrcwCMjaoFof066tQr2pt33Li7rB7mXIJmZEHv4NmVo8Dup2uba5dlmrNDd/mJ9Kikj9LDiT1LQq9aq6LOMnHcxnaPQMo1R5A7V0gtFC1a+WOVJhYGoyZHtPoujlkY5QC7CZ6gXHj6alEGvEAL+9fQ1Bx9RDlWfrKMLONL24gB7oYHJLVQPEn3ZUzZSmN3gMmi91XHAEYXXBpViEZ7wihiFpbdhwgJ+mA7wJyqocPlfwK58okfZDCStE0Ntb1baMzWyjASaTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.6-stable tree.
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





