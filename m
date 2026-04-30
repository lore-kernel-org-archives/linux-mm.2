Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BDFDCD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E065F6B00AD; Thu, 30 Apr 2026 16:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91116B00AF; Thu, 30 Apr 2026 16:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE2736B00B0; Thu, 30 Apr 2026 16:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A69366B00AD
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6BC5E86BDA
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:08 +0000 (UTC)
X-FDA: 84716346456.11.AB2AE6C
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf27.hostedemail.com (Postfix) with ESMTP id CFD5C40013
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LXvo21Oy;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9uzzm6jNqfcLsCYz5+I8rM6GjpDZDUZNvjjUeRJJYRk=;
	b=b/+AJtcpSjDcdruV88fHdL2NUI9m4yJyL2BwvQyC82Jv/rCAk1rVs+cAfm/gkWZMa2uKT+
	UTOCzm/TJAvFVJshyfBK5WM7Eotm3ictTjxZ09DnB3JSd3x770DtaySmrbel9cw1CDiWyJ
	XspuTt/1e5rGZ7E11UDzdWHjqApDFxw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580586; a=rsa-sha256;
	cv=none;
	b=WUJb1fmu7aqDpAshfHQK/m6rxMOurOrPuqUPeAdl5gIz6ZM4I0rekhh/uzuoR7jcYl5MbN
	CaQYJy41PMp8TLDEaCsuNtQcTuKcad9HIWmELNmbaiEvXOP4q8hjhhvAz3LlIXiWSeBU5U
	BZ3pdl2q3ZtI3RCu/Ci9sHNzxglm2eI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LXvo21Oy;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9uzzm6jNqfcLsCYz5+I8rM6GjpDZDUZNvjjUeRJJYRk=; b=LXvo21Oyrc69gpY40R7UwUItR8
	XiiuPGCCl8FZN7nMBw/yvpDmo7U2LQM8s40ZF6WPCS67Y8DiqG93nwDxQKvug1Ie9FdfkxFZJNm0W
	XPtb9vAUNG2HNHP6iUjQk88bCmN+peSyHcjHTu3B/vgHiRn/truUxw4O/sJGd3hLCkdWX9axKFEIx
	tBvV9wDdJpPi9kvuOSyuyDKqIfCO6YiLOxQqvXvO+7QbqjSa/4582YQ3G5L5cZwEzyM8SwTBDVqZF
	nUS0qqTsn/LxUR8YRr8WvW+z63rI2KhtLVdmBiIXE3ow6Z+rsGVYpV+aB0cqV8riifzZuTIc3U6yk
	/ax1ci4Q==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-0mie;
	Thu, 30 Apr 2026 16:22:41 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	Rik van Riel <riel@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 28/45] mm: page_alloc: keep PCP refill in tainted SPBs across owned pageblocks
Date: Thu, 30 Apr 2026 16:20:57 -0400
Message-ID: <20260430202233.111010-29-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CFD5C40013
X-Stat-Signature: u6ccpgy9gc87g67mdnou6cydsmmssh9f
X-Rspam-User: 
X-HE-Tag: 1777580586-295738
X-HE-Meta: U2FsdGVkX19wKDWJXXKoUeli6+/N+GflF7zDfHOPeDnMNk/urWcGHAZ4Ce19sAQ6XOcxslBsqlsbVCYcb5f0+bpgLHqIssQjuHF5hLzkfX0WBxeGnM4beaYzNPxm4XOnylswDPVwh+yack6zDYVRqo4sHZ3kq5qWLEoDd3MgrMtb8Vo18b8/iuRms5lmsT4ga3KPDMAONT3/qLwk20kAGAHJmwdC90Aa4gZMJcDCMFb7yNJElnvRo5xG+Mhh7wE4nky9PoQmzc0lKaANkLhb2hSpx05cYp9Ph9rIk1C99z2OuvHmbpGFhWWU6XHmeVsg4XamJbYhFJHkRxW/q4KIN3yURM8K914ei2paCtKb90FcKNO5WPaiGZjU+xtZK0v8hRo08xb6YkfyMczOtepaHmxraBhYT7QXuNnl8GQ934RtWmfdf/4PsDnGlvuAK3OnP8EtWIoHyJjRYPgp5vqkZhd2MX1kVmJZcO8RHS4nG6YrnRRnOqCldItzJNGYesMwUshAUk8BqWS9Sc2ZFtdc/bxezPbWJ2ehInVJIEkZxKLrelpKeMXw7vF/7CxRuwaTTvaaUo5mVrgaVh296/sO05nmh2Umdtxck5/vS2Ek2x2miPPoVuciBSV8Cbmax5Z6CQUUYg0nXnVc/fVw2d1IzAv2Ims30wMtRfquzCG8vVo5tS/b4DEsh4rw330rfL0rNhNv8O1Jh9AMLoKLIhdWoeumy6VRCqbDNpIbtk1NVd4BpbJxKRlJhL0m5Fj3b2lXYuZp0/cH5gwW6vjoeFYHZFUAcmbIYt7U2lUJf6JGsVKjm1zYZ6CR1byNgFlSgDbHTNnRmUshwYvhChvVujco5FizIK0xC5zxuyrmVhx+n4UgT57YbqamaSCcRNVP8L8rrf7mqShIsGQrujuYwKB1wxhtX6MODXuy5b/HvihT4jYRjk2N3WBoe4o2Va6iT4D1x17H2q68PgfsOrM2yaj
 wUFb3PY/
 A69ZS14cex9rPqz3bNOXH5tP82/83ie+FmELHn0YGIZ9WNWPkYD/GrLFyjx5+GZom7EALpYXvZdjZglsjOYTK8OZeirlf3vsKmHuDxIzhIqIzpkPtkX5Wp2SCFf2qc1azKBxQxxQgxsa89iwy4Oo+VwOelYdYFWXh6d8dnq8XdxV5Uwn/IbaEMsev1lDv2Q67NEhOu/SZKYxfy/Dc5Tv6bBla6dUys0VSr9aAsv6AOzDnRHU5/pcJykEXdZH69/HLqxL3gX8ouK50VDjX1PefvrSYDblqWVdYGxEskMQpZkoqk7NvL0TMHXaaQdKUwiZ6jlOR1HVmdQUcseb4egkY9x85K/g49RaRzPfKWAt7yqlQkdq/hyv8GBnkBDq09hEq2Y39WGWAsUSFHOVyrCm2ap00U+P8mGvfoejU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

rmqueue_bulk Phase 2 walks SB_TAINTED superpageblocks looking for
sub-pageblock free fragments, so PCP refill can be satisfied without
tainting a clean SPB. The original Phase 2 abandons a candidate
pageblock entirely if pbd->cpu != 0 (already owned by some CPU), to
avoid two CPUs holding PCPBuddy pages from the same pageblock — which
would let the PCP merge pass corrupt the other CPU's PCP list.

On systems with many CPUs (88+) and many tainted SPBs (~50% on a 16
GiB devvm under stress), nearly every free fragment in a tainted SPB
lives in a pageblock already PCPBuddy-owned by some CPU. Phase 2 skips
through the entire SPB without finding anything usable, the atomic
alloc falls through to the slowpath, and clean SPBs get tainted.

Take the page anyway when the source pageblock is owned, but skip the
ownership claim and PCPBuddy marking. Phase 3 / __rmqueue_smallest
already pull plain non-PCPBuddy pages from owned pageblocks the same
way; the hazard is specifically about two CPUs holding PCPBuddy pages
from the same pageblock, not about a plain non-PCPBuddy page coexisting
with another CPU's PCPBuddy entries. Pass 0 (owned-block recovery) is
only meaningful when we actually claimed ownership, so register on
owned_blocks only when !pb_owned.

Fixes: 266461cd5442 ("mm: page_alloc: adopt partial pageblocks from tainted superpageblocks")

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 50 ++++++++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f0fdfe8c9a45..a09660a06ed3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4133,6 +4133,7 @@ static bool rmqueue_bulk(struct zone *zone, unsigned int order,
 				&zone->spb_lists[SB_TAINTED][full], list) {
 				struct page *page;
 				int found_order = -1;
+				bool claim_pb;
 
 				if (sb->nr_free_pages < pageblock_nr_pages / 4)
 					continue;
@@ -4156,33 +4157,39 @@ static bool rmqueue_bulk(struct zone *zone, unsigned int order,
 					continue;
 
 				/*
-				 * Check that this pageblock isn't already
-				 * owned by another CPU. If it is, two CPUs
-				 * would have PCPBuddy pages from the same
-				 * pageblock, and the PCP merge pass could
-				 * corrupt the other CPU's PCP list.
+				 * Found a free fragment in a tainted SPB. Take
+				 * it from the buddy.
+				 *
+				 * If the source pageblock is unowned, claim it:
+				 * mark our pages PagePCPBuddy and register the
+				 * block on owned_blocks so Pass 0 can recover
+				 * remaining fragments on future refills.
+				 *
+				 * If the source pageblock is already owned by
+				 * some CPU (us or another), take the page as a
+				 * plain non-PCPBuddy fragment — the same way
+				 * Phase 3 / __rmqueue_smallest would. Setting
+				 * PagePCPBuddy here would let two CPUs hold
+				 * PCPBuddy pages from the same pageblock, and
+				 * the PCP merge pass could then corrupt the
+				 * other CPU's PCP list.
+				 *
+				 * Set PB_has_<migratetype> either way (bypasses
+				 * page_del_and_expand which normally does the
+				 * PB_has tracking); idempotent if already set.
 				 */
 				pbd = pfn_to_pageblock(page,
 						       page_to_pfn(page));
-				if (pbd->cpu != 0)
-					continue;
+				claim_pb = (pbd->cpu == 0);
 
-				/*
-				 * Found a free chunk in an unowned pageblock.
-				 * Take it from buddy, claim ownership, and
-				 * set PCPBuddy. Pass 0 will grab remaining
-				 * buddy entries on future refills.
-				 *
-				 * Set PB_has_<migratetype> since we bypass
-				 * page_del_and_expand (which normally does
-				 * PB_has tracking).
-				 */
 				del_page_from_free_list(page, zone,
 							found_order,
 							migratetype);
 				__spb_set_has_type(page, migratetype);
-				set_pcpblock_owner(page, cpu);
-				__SetPagePCPBuddy(page);
+				if (claim_pb) {
+					set_pcpblock_owner(page, cpu);
+					__SetPagePCPBuddy(page);
+				}
 				pcp_enqueue_tail(pcp, page, migratetype,
 						 found_order);
 				refilled += 1 << found_order;
@@ -4190,9 +4197,10 @@ static bool rmqueue_bulk(struct zone *zone, unsigned int order,
 				/*
 				 * Register for Phase 0 recovery so future
 				 * drains from this pageblock can be swept
-				 * back efficiently.
+				 * back efficiently. Only meaningful when we
+				 * actually claimed ownership above.
 				 */
-				if (list_empty(&pbd->cpu_node))
+				if (claim_pb && list_empty(&pbd->cpu_node))
 					list_add(&pbd->cpu_node,
 						 &pcp->owned_blocks);
 
-- 
2.52.0


