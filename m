Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60649FD004A
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81046B0005; Sat, 28 Feb 2026 20:51:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2DED6B0089; Sat, 28 Feb 2026 20:51:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 957306B008A; Sat, 28 Feb 2026 20:51:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 835136B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:51:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2AFB4B0099
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:51:22 +0000 (UTC)
X-FDA: 84495816804.27.8F9B054
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 753E310000B
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:51:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QvUgzwYQ;
	spf=pass (imf14.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772329880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ftAWyPxxZX5ZM+mRE16LgE+/EMN4fllXs2BDuUKHcT0=;
	b=H7zzzSh/ACjxW3kV2d+GKu3G7JQUT3D/Q4WU9wsIwR9GnBL0yS5WxMK2HbhRELAhkZ49xn
	R6Th6wlZlTKQtWQO0x3QVigHi+puGN/riEtgaq0ZaGjRsXZHpLqTe/6wX2bui3mkY/FrKU
	FVuurZCQM6PZti7Qe18EXEpYbNcK2IE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772329880; a=rsa-sha256;
	cv=none;
	b=LFhUEK3NoH1Jp0aSPR/HkePQw7nc2XKX1OTBwwNhJO/4uDuqdB61p1E7+SJGBwvx6+lS5r
	+o8a+0zycjGeLrVSRAW7Ynp2RA7x+Ir6fWx3rBb8uy90NbnjCigtr6GxOAgd+AzzzQc+/J
	ryhYpOW7NcILhyBaM6zIhXAIyWA2UfM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QvUgzwYQ;
	spf=pass (imf14.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B9FA43941;
	Sun,  1 Mar 2026 01:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6C7C19421;
	Sun,  1 Mar 2026 01:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329879;
	bh=+9HMaBjuwAEDmbpqYj4os4AckSQwu1ygmdc/J4OWEAM=;
	h=From:To:Cc:Subject:Date:From;
	b=QvUgzwYQj1Jx/PcEk0gh/77haXgq7PJEmgTL3pnIr1Oo501rEL6s5TB+jlsHnaad+
	 c6rR/jPmdBd2Pmii0pgZb5Xq1cx0ULP8HUJFGe/XKVXoFAaw5KXj7/ICDICBKQKWg2
	 zmEN/Mgv8zeC8kXRO2Ki7FiCemQqcUsE6aGiZnsE3s9MMIY+fUtBNO5wL5riOtCfYz
	 HWVVEfbiB/wQU0nAcJUkWY6b5UJ3k8lkElIQXibhTDBHCg/CO4IyZOplbIprMoz3sj
	 kApByRKlbbrDN0d0a47xAGCVRfEgLbQeBwH1NO39GSkZgUpwq6s6SmzJBrt9Uv1RQt
	 VNxUb0/qXBHRg==
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
Subject: FAILED: Patch "mm, page_alloc, thp: prevent reclaim for __GFP_THISNODE THP allocations" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:51:16 -0500
Message-ID: <20260301015116.1717542-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 753E310000B
X-Stat-Signature: c48p1xbjiges3xk1qki8itfgpnsoe6fg
X-HE-Tag: 1772329880-458123
X-HE-Meta: U2FsdGVkX1/3vvbGEY33A7+/fF2+NNJ5O8ywdVZmXGreEm/z1+/9vNQlLHKwGAdCTwr5CLW9nq3wHtWbEVwq5rHa2CTdUXi5DU4h0NbtX3VLnsVgQhoGXabfDH/lhWU5QhF1a0twvE7Yd0su0jsMEuP/ZmDqzQNVeuR7G3VocAkxcsfzHLvetWseXvum4jBC831QaDp98GqZc1t0t74k9dePXVOKuI1KPNTjq0EI7puTZLyIfha+wUvJtq4uZz4I7h6VGR5sLCN+9CHac+sCXVrtiKW9Ef2aXarjwcWuiUhFHH84LJwwfJF5ogRwFgRyKyJs1ATdNKKdO0nFVzKjosPvJHpcvdxKDOvvV3rukYzfF5MeMPU1HgGP1hjkrjN+R6NSMq6sVmrfRLW/9AvDDO46k/Apaa9JTbS13RYmH4Q7YJR9vXv/Ewg7tGQShDI7kN7eRfmRJstxGrD8ITxbZfGzptYhdswkrqmV1Qy8lwAn8f2D7ETg+kzPF/d7nnPhe4Y07ry5CzLPPCL2CENRQvL5jKrj84Nah/oRUHhp8bs/36XUAqFensF+LC+sshnINMMxi3xD1uWhQaL4vBSzedFNGIED0t3Upo2/ITWOohCeeWgcgcbW0Aze8Op+T6BmGMTny9gnB7exnrg5JaUGs7UaTEsJnC5Z+Cpcw7p28shniTXxx66rtuxofDAYvdCiWk8lK1e1QSuoBehIXT+TS4B4fcRj59E/z7PHQMSVslR0eDsRhvB7EPQ/v82oviLsf8B6xqXTvsIjwW46k48ir9KStPJIiT2XSvGybu72/pLEqVTH6q2NoGet2l5xqR1Hmau7BL5Bprp5Zu25K8fBRbnymEa+IRrIcDhiB1h3WUeImYYY/RkOtLIVIIBxygkojGcN/cjesX5MHrxw7lQ9iWurvpkDTZKLsPIfJ+VW4d2Foz9yntpxbg43irUJpxpnp5ooIf1ypjOK9OlhKaq
 xKZO2Nqu
 vH0Qu1US2pVDrjhnnBeZvN8rzxEkRyOf4YlXCFYko5CjWDEP2NFe2AJjrBYq52GmE4JhX0uiyA7exZUufyluEgGrEiJPYsvtH2sui77X+7nmQZZqxxqq1imv29sv6lMW0LR6RMIuR5ZimPSTdTiyeUxcsScXt9a3hghtNXGYRFs4pcmWMgTKz3dsl/K1FlzXisI+fRmVy1/upfwo3kzGYxVg8uyaKgaEpaFIJ5yYW84HbPbb1bbzHnGzt9tgTPe+JiEEVqsaWAGITMmhx0bRFO7LYoTdymKT31sB/3+niqsLRFwNwPBIm4YomdXh5EmHrfT2+nhE7cZ6fN97Tha5kzl7uv/nLpZZAursdClKD8qo7TK/2Ez8uaKmOukTJXVcitYnBwBtpGcXXus6ZC4vAPr6T6MrtaypkyJX7UPS1E/kvtDu89MUrCnMCC1+m3bXvkV7FSvzkcbkPCuPJOlIizhr2aXgKm/RdscVgWcWEyqNTqqtpbNc7SsmhtUU85mYO3P5rV88Jb2rnTOMdqqhZS5VG01JbwBIJ1w+eAAQ7W85z6KBFgj4g83LSAIeg9tyFs/Cl/ArV6h90qOrFSAM95VC3CGdmipi23imNtdbYlzhYRIrAzuFS64Tlqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 5.15-stable tree.
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





