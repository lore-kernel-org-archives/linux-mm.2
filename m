Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7020C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 08:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8B556B00A6; Fri, 21 Aug 2026 04:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62B16B00A7; Fri, 21 Aug 2026 04:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9FE36B00A9; Fri, 21 Aug 2026 04:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC27A6B00A6
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 04:18:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 38FC41C17A1
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:18:40 +0000 (UTC)
X-FDA: 85124575200.11.903BDA7
Received: from mta1.migadu.com (out-98.mta1.migadu.com [95.215.58.98])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3339880002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:18:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YSaPexXk;
	spf=pass (imf02.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.98 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787300318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nkoNt5Gr72o5PnQjp0wkacZFwvKjCwRCH7HaBMDrYPQ=;
	b=vvCF0ezZ2tMSnzRrP0poe3zpsej7qE7oOU41uftmh2TysnPr1uzGARF/AcBCc2G3qOwDjV
	cTmZIh5V5ldloao1kN3kF9VM+zXwbpY/ToFCYJpn3xUeCqCqlm4/dl4iid0PbvBA+PSbKW
	TO43tBAIVT71/lr3gK51aZYf0AjJw20=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YSaPexXk;
	spf=pass (imf02.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.98 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787300318;
	b=rba+KBGwcC5qbMdF6j26c1yiHNfjewhyopPWy6RaFNVN64NWWoNBSyOmsa2q7cnN5/M8mO
	NX6EIHhZi0TQQq3JNVEHhRymGA47kdlicjUUvtgVngQ7iTpf1CX14rMQeSFkc0zM5AqVph
	95Q2CLq0O77newLz27y5NkrdLPxvUc0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fJJAB3mxKN0RQHrysuI3TTh1XFgddk39iuxEmKJOrQA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787300317; v=1; x=1787905117;
 b=YSaPexXkkBbpuiGTT2njGMF5J9pDV9XbBEy0BPn+Lj7OHwpC/pCLQEgTcdUa57r64VBvqk95
 GiK74xc1YxFJdQhfhrssN96+e7bENLaCpejk6VAuwyxk12r3HUgBpK3JNlO1tmjyTk31rGrKvGv
 cgmSr23w/8U64mF+8LNalBnU=
X-Envelope-To: linux-mm@kvack.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 69efcddfc4b900a9;
	Fri, 21 Aug 2026 08:18:36 +0000
X-Mizu-Trace-ID: 69efcddfc4b900a9
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH 4/4] mm/vmscan: do not skip node reclaim when only anon is reclaimable
Date: Fri, 21 Aug 2026 16:17:41 +0800
Message-Id: <20260821081741.1340277-5-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260821081741.1340277-1-ridong.chen@linux.dev>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3339880002
X-Stat-Signature: sm68jed355tnt5rkkrtoxwu7yym3ut85
X-Rspam-User: 
X-HE-Tag: 1787300317-169837
X-HE-Meta: U2FsdGVkX1+ZnFwRxXOZMP6ynvi6t73CveilxyiYBmO6df82rpTgDHmxKafyE2Qcq+8YnKn/1NuZjj37MNLcF3NFoSleVK1fWPEaOrmRrnk4VDlOgP4AyeiRYX8x6K60ARDyhnXA8aqFMm3GybrUpmJ8kBOWrIRHEcqt7Qrp+g3uXJxxaq2kVbE4ickdtlmmVp5vF+3T0A9wYUeZZXMXckEjgqs633ZYbyYEzzqrydbDJWnHqgHP24tiudSSncmy9Zy3wP60fYXrxxI46i5xkORPdRxCBUI6Prh96G66XccGt8oVfrpQLL/kx4AJwrf8TaKc+O21bp5UhGtAzU9POQLYnpTTHyTlZJEKHGsNcqXaob+XqN2xwJWRMm6K3CW09Ua9xSgUICStPYAwfM4wtzepd2SY1Qepahw627RAbMA5ZENiK1TuraAITqps8f7fLV1831xw3FKaYT8czGs/Ap0ZlLv0nHbP9fqDaG2vcsR2t3qGamwbHjUriCjMo8au3F5KxBP5zg3hyWYy6fU10eYhcKsxsU11LeuqQzXAnFHSGPcXE7G6NP9xikrS4+S7ocBtakjxfqZLoEKYtxix/8CrfaTBfUwefp9AWkHCDLYhGMyh+hZL6nJrjH1mlanBrb0VdM7XYS8BjDndN2pAeqJ95uMqEyyYp/76f2/5yyVkzfJo53F/IK6FVGp4kJKalQ0mmrTv7RjHJ/GYqh79djgW+fJm+kr4T7VslIKhA3/kJgHlmSU5e7nOqgQXuYHWivFXJ50kEegMnHJ+MER6EFjwuJJuYX3WvR+4byifqgbEibrEc235esz/TnFhkQG7kSRxOCTJrOLe4+QnOgT7NmlEj2nVOtIxe/rCems7iCgXh6A9IcBgi+CAsDyrJDLcj/qWT09bXIxMUJgMbPxQXiOSNdqp9FuQl5u6luBJhVVz0+2YTDGntH3ndNIvu9yJJ40KYPOAZAm6w1ARNS6
 ZtswGiJj
 OPP6C8oz5oHNMcX6G7AnbXu5ruvPo4FnGk7/yHsCGgrmmEXA3juXVHle+B4Qid1AwwytJ7HcCoJZw76Ikizc+HjDngY8MWSGESGh4pl8HNuykN7FJq0MW5MPqJ415gupszO2Gxs2KrUtRT99FbJgUrNeWki3d/9jZ3+fOhomEW1MnhgTSPHAa/v7x9ZAfmwkLpS5lgLRP3wXfkhyqR5KbJdOpUvKVsTk6t044Nk1sWGEzNg1+lHJ2vpSplyge42BXQSbD4HgJWBLGrnu+akWvRLkqEWssFGSIYcMC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

node_reclaim() bailed out with "return 0" whenever both unmapped page
cache and reclaimable slab were at or below their limits:

	if (node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages &&
	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=
	    pgdat->min_slab_pages)
		return 0;

But min_unmapped_pages and min_slab_pages only describe file and slab;
they say nothing about anonymous memory, which node reclaim is otherwise
happy to reclaim (may_swap is set, swappiness applies).  So a node with
little page cache and slab but plenty of reclaimable anon was skipped
entirely, even though there was anon to free.

Require in addition that anon cannot be reclaimed before bailing out, so
the early return only triggers when none of the three types has anything
to reclaim.  When anon is reclaimable the per-type flags leave file and
slab alone, so shrink_node reclaims anon only; checking
can_reclaim_anon_pages() here also avoids entering reclaim just to scan
without freeing anything when swap and demotion are both unavailable.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/vmscan.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5a3f67b3ba32..8c706807da44 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7945,18 +7945,14 @@ unsigned long node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned i
 	};
 
 	/*
-	 * Node reclaim reclaims unmapped file backed pages and
-	 * slab pages if we are over the defined limits.
-	 *
-	 * A small portion of unmapped file backed pages is needed for
-	 * file I/O otherwise pages read by file I/O will be immediately
-	 * thrown out if the node is overallocated. So we do not reclaim
-	 * if less than a specified percentage of the node is used by
-	 * unmapped file backed pages.
+	 * min_unmapped_pages and min_slab_pages only gate file and slab.
+	 * Bail out only when both are under their limits and anon cannot
+	 * be reclaimed either, so we do not skip reclaimable anon.
 	 */
 	if (node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages &&
 	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=
-	    pgdat->min_slab_pages)
+	    pgdat->min_slab_pages &&
+	    !can_reclaim_anon_pages(NULL, pgdat->node_id, &sc))
 		return 0;
 
 	/*
-- 
2.34.1


