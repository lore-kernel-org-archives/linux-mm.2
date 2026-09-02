Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A73EC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5487D6B008C; Wed,  2 Sep 2026 05:51:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51B216B0096; Wed,  2 Sep 2026 05:51:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407DE6B0099; Wed,  2 Sep 2026 05:51:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F08CF6B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:51:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 23694120154
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:51:03 +0000 (UTC)
X-FDA: 85168353606.12.154C5DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0E0C71C0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LjN8Jh71;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788342661;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kegVpYdP0lvkkn+2YQKG88UHJjeD3qnshYR8mde/Gmw=;
	b=MV2zuObSIcvJfDp2ANCOUDPfGgqe7hYn2u8kP/rozXyHtwlixfTLM7pGhfgrzW1U2B59Q9
	eSwvA2DhkQJI/YgjlhjrCtKdzYGcdM9DhJ1yxvc3pcCri1XQqyeuNBnot6kE9mqijYp0/U
	MTQRW2vu8beUk9va8V3/MFYD+WD8+5Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LjN8Jh71;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788342661;
	b=JMk64lz1aGCtwdCb6wn+ztFBzZgXWUHV0NV16QQdX1EfcMmjqxi7hRcHOAnW4KT00ADsBI
	3IrcVB/7fEbpY3jn+3XnXxnkczUrYNlgX5NHNablOX0rJOvZjqWy9F4qFLx3R2V9fChlvi
	5+388Rioe1QUE6SjgmuylQ2wWWkhQfs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F4A6447C6;
	Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B516C2BD04;
	Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788342660;
	bh=Mo3+8RFfppINKIARqVbgEULhQ/6q8Q5E73vtDdVsNaQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LjN8Jh71ESTtrz0II1QkWFMR6Ekn10yjUiU5wrtpB83llUdV/2TXESJKlYxXGJbFK
	 BjL/hqJHbUqLQ+xQ7JKPNusWEkPdY3H3tSO0Tripls89K0PunwIWQZJCzgkJ01O9VE
	 MF0jUHlUj8tq8RKt4PsFv4Ve+bB3kLb14TmcN12pef+qAjOXu9J5M6q/6aHQAvub+I
	 wtL7Ub+pGmIsjG3jKL3/mxnsnakHKDJj4Ck/bM7+uPcLyFOxE0xC076uHuPhnmg5Ob
	 +JvXfQKRavAYb/WERikZtdLsVUbzNO0i9U6pMdIidmI4xXF5ULRIzKAX1hAGCvxddi
	 o+jRgTBAC38xg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FB7C61DD6;
	Wed,  2 Sep 2026 09:51:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 02 Sep 2026 17:50:58 +0800
Subject: [PATCH v5 5/6] mm/mglru: use explicit tier range in
 read_ctrl_pos()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-mglru-flags-cleanup-v5-5-9db761d779ef@tencent.com>
References: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
In-Reply-To: <20260902-mglru-flags-cleanup-v5-0-9db761d779ef@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788342657; l=3649;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=oVmtU7RtLEHATDqO9A5jftz8sm6P6wAktfihxMqJ5Tw=;
 b=dPPzLe7vps/4tFzAt1JpcbiW7bZLRHQCFNYaCQ4sCRNhFfKoV8rZMZJk4dpFzSA1X0k61uup7
 ZtSlanhdkEYCfpC+U1UuJBSbBsreUiJ79Z2nOzSwDx7LLDmkPwdeE/2
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: oc3z53fqxy4zjaqcgc49gkin7nmnndje
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0E0C71C0003
X-Rspam-User: 
X-HE-Tag: 1788342660-590893
X-HE-Meta: U2FsdGVkX1/xBz8uVeE+y/kolEMeCIeRQDkNoQcHGH0mBbJxB0zaVdBuYwZHU8PO6SNOKHhNdTXESld2WwMhsrszT3kbhJhce+ECRPd5dLfvMByoZ52whEzS62tFL48cl8OsOvTRNDvh7nHTrYucgcrOJJ5pBZ3CzVgVgZYLtcNQsEYWxTHGP50l9nBN1iUBpiiQLLGkIzkcbwaCJvwPHgAKnm9nV/Bb4IJDGVoNyLUpJoofHNs8BBtlfbNX2S4QWC3FgH1CjkJi7bcO9w1SqDV6YKtot4+e9vyPbpvMhs4NO8Kfg9QuOQeX3B8JEuWfaHV3VMh5PCkde0qmVbBWJX4xqQTlzgPMS0d6vAnmWUs4fmwTwdjcJnYOwA/dqQGyUOIx/u8LycNgxI2xigN/i/nBXpWEtaPwPsaA/VsMkEz90x3PBy2aAlCN5nbD07B+I2XPbzHAiGNbc/kfmSFKgeidwUDCzALD/D/rkUzkoDgtihuT+wNdpIuXNXrqD5opLQDFDiwpvZihzH47yKM4EqoiSsL9ZyR/Sgd81s/KZroA4YPTgRSuGQcoIRtxVSNEQesPCu+YgR1QVkezEGVs7MSkoyx7/PdU7HwzbIyKCIPdl3kkcx3+1C3WpvhTxsZXVKwq6QUI6RCXPAJsaaXM0Q2NYI7UHwvvYqEvUW9/oBae7+/LtCfEtoQyeojsvT8LuCuNoj12Uy9mtxJHKJAbyDakgLxPwl/iX6GwLJz7smCY1gfj5iQoXxlRa4inK3STdLu207ay3ElIhtfU+zLkGxhYfCYLiojZIYNl83PvjnwdTd0pkj029OSmqUlv2R6sqBTWs+K5eGzgAdBsC16qrj6burdLMlft4rn+yhkvV8QW+6N2waGysRk9Kp1+HStv3dZup6/D8MTrdq1S7OPyFVnn/9TD7K1xilfZ4X/t802QcIif3B1/LqMN/z5HU03d4EtqdUb7w17Ed7LjRyY
 wXDc9W/m
 xfVBHbNpCaOhaKCX6nz6nLWGlRydFEBfRkwpYIzExm1Z0sK/IW2ma6LYT8O+C5RbiTnpjScI9tX06mDQ79zYI03vi7WvmaDBO4I4r2iAyRznhZ62JzM7vhN6kD0uL46kDWXwWSQvZQK3kzTZ9FMBJsOBchS5zyF9Rr/Ypyid3R0mwN9ZhD1l2CHvXj89JGq+wLRvlfrZ0DYFRQnyKUOvffvkQ+54N+UzbWGoU4QjHI9ieRMOPDEYJmqtJfHXmqRdcK9Bb39+Tu6XFwk0kkF74fBODv/328XSupJIy/7qDImrUCzmNnYryXVMFDLoq54hOeV0zF8xl2XIk9cjDuZoiwdkxa0/KHuS0crkmesF3QPPC2HQ14FoUZ8kLTHMmVuBq1aIB+JqdDqLxqkdvJpW6FYEFB9RNSVUiq7XhSm9ds/uZfJime+Z8YsEEmztz4GgNfA0GTP5hXvLqK5fTnpQ3i8eKlS6buCvmtWvDhwNMcLb7qK9aNZOoD2rSfbg/Bb6shp77jhdf7V6WK3tMHLEylLHww9TPALAKBT0U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

read_ctrl_pos() encodes the tier range in a single "tier" parameter
via "tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)"
as the end. This is hard to follow, maintain, or extend. Tier values
0..3 select a single tier, while tier == MAX_NR_TIERS selects the
full range.

Replace it with explicit (tier_min, tier_max) parameters using a
closed [tier_min, tier_max] interval, and add LRU_TIER_MIN and
LRU_TIER_MAX for the tier bounds. The call sites now become
self-documenting:

  - get_tier_idx:   (LRU_TIER_MIN, LRU_TIER_MIN) for the first tier,
                    (tier, tier) for each subsequent tier
  - get_type_to_scan: (LRU_TIER_MIN, LRU_TIER_MAX) for the full range

No functional change.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mmzone.h |  2 ++
 mm/vmscan.c            | 18 ++++++++++--------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c9ecf370cd9f..9b27cf53bdbc 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -492,6 +492,8 @@ enum lruvec_flags {
  * folio->flags, masked by LRU_REFS_MASK.
  */
 #define MAX_NR_TIERS		4U
+#define LRU_TIER_MIN		0U
+#define LRU_TIER_MAX		(MAX_NR_TIERS - 1)
 
 #ifndef __GENERATING_BOUNDS_H
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 96fdfc14f615..714a3f273f49 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3198,8 +3198,8 @@ struct ctrl_pos {
 	int gain;
 };
 
-static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
-			  struct ctrl_pos *pos)
+static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
+			  int tier_max, int gain, struct ctrl_pos *pos)
 {
 	int i;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -3208,7 +3208,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
 	pos->gain = gain;
 	pos->refaulted = pos->total = 0;
 
-	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
+	for (i = tier_min; i <= tier_max; i++) {
 		pos->refaulted += lrugen->avg_refaulted[type][i] +
 				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
 		pos->total += lrugen->avg_total[type][i] +
@@ -4809,9 +4809,9 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
 	 * This value is chosen because any other tier would have at least twice
 	 * as many refaults as the first tier.
 	 */
-	read_ctrl_pos(lruvec, type, 0, 2, &sp);
-	for (tier = 1; tier < MAX_NR_TIERS; tier++) {
-		read_ctrl_pos(lruvec, type, tier, 3, &pv);
+	read_ctrl_pos(lruvec, type, LRU_TIER_MIN, LRU_TIER_MIN, 2, &sp);
+	for (tier = LRU_TIER_MIN + 1; tier <= LRU_TIER_MAX; tier++) {
+		read_ctrl_pos(lruvec, type, tier, tier, 3, &pv);
 		if (!positive_ctrl_err(&sp, &pv))
 			break;
 	}
@@ -4832,8 +4832,10 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 	 * Compare the sum of all tiers of anon with that of file to determine
 	 * which type to scan.
 	 */
-	read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp);
-	read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
+	read_ctrl_pos(lruvec, LRU_GEN_ANON, LRU_TIER_MIN, LRU_TIER_MAX,
+		      swappiness, &sp);
+	read_ctrl_pos(lruvec, LRU_GEN_FILE, LRU_TIER_MIN, LRU_TIER_MAX,
+		      MAX_SWAPPINESS - swappiness, &pv);
 
 	return positive_ctrl_err(&sp, &pv);
 }

-- 
2.55.0



