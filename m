Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6E35C61DE1
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 18:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C0736B0096; Sun, 30 Aug 2026 14:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48ABA6B009D; Sun, 30 Aug 2026 14:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 352D06B0099; Sun, 30 Aug 2026 14:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F0EF96B0098
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 14:43:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 694AD120346
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:43:43 +0000 (UTC)
X-FDA: 85158809526.09.6BF19EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6AD0A14000A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:43:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LBtTBEdv;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788115421;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wqhj6Y+A97KUOD0e/UUZ2dE9Lk9s9/sb7RgAPnRsduU=;
	b=6qAreAOdoZsA0kVXGEuewrQ8m/fjnX2CgEPoerekbOjLuAisC9b90dsGHt0nSQBfavB8ZY
	UMb7cSb8BHyh5BG7WnsMacsdU5TR0EokBq6QitaKaBVl10hGAOl2/ZveJfTWV+RACn0wTP
	Y471M5APw3UETexmv01cpYws/LHo1xI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788115421;
	b=bmn2CrBneDdZwbGNy+/rbeRDiUEPZbfoyUKsTQ85cnw5uCt9ZHc7meswbsNIkM9p0NRGrC
	sjKe2GYZg9GqXDbgoEQ7pYKQ52G1AHmrQRc06dtDmBAolT9iZi9lIc3i3Asvk5Tqmoklet
	9KpxMZBlA2bVCyd5AMugBHV6tpgLhUc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LBtTBEdv;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3AE0044514;
	Sun, 30 Aug 2026 18:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16959C32781;
	Sun, 30 Aug 2026 18:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788115418;
	bh=jyNA9Kp6+foaF24RdDxMnGyUAbbACor7vJmweV2u7Us=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LBtTBEdvGgnWLFAOpKOJnOjurRX/4FRvNtRcwJ5JFDfbiRGishnRauOTfI6CW2mcL
	 XJ13WLDnbP+HtAGxPdxcJiLGYziHXibIeYCoa0iojetBc6RpfyM07gcWY2MMZI9y9h
	 f+czEuRePFsnNuuBkzn17oPvCuy+Yr3uAgpxiI1G69GADwbv0+565bkK56M4kyATBf
	 59hpfeiFj53wXQREOn5j22VKlrHZZuEdHfWdIOExtFIMoyjJw3btLPBv06cEHV5ppX
	 sCXPRlyB4YYqrn3icGasUJeEqmefnLEGpXtSw6kdvCMovTHJtq2VrIU+NjMcBlT/jV
	 BbGS5WlvJKwVw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC8AC61DF0;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 31 Aug 2026 02:43:35 +0800
Subject: [PATCH v4 5/6] mm/mglru: use explicit tier range in
 read_ctrl_pos()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-mglru-flags-cleanup-v4-5-2d15dde0d7ee@tencent.com>
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
In-Reply-To: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788115415; l=3649;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=CWUxj/CQQzace6S+QxkJDRIrrH9jLNHsJ/crVKhgGbE=;
 b=FWk6b2RXyde5JYnHfKQSebvOwDlcdZYu+ics5x8yBjnEv1DTOr+mk6s0Kzs0JEfJnGmLmyVXE
 uFunTQEq+OtBL0CXaykFAju+MmG5A7LoemlTcpVRJVx4ydEfxRGhC4J
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6AD0A14000A
X-Stat-Signature: nhiocp586rro6htd3a9xfq9fsrj4f4ah
X-HE-Tag: 1788115421-911427
X-HE-Meta: U2FsdGVkX18JvzK1XF/nYzvUJb9+NQJQVKo4s9Xh8PolnbjE8EXmfmuMKcRzU06sAnT+Kr+GZipr/Wifw1sgtPahmQLUTlUV1foPsd9FKwlK3m9Ox5KZ7yd5OebQ9xFvaf2SsA/vR6WVRN5u2YbBOczE5ilET59c5GVxMxI27eHft1pDJs0O/Dwco5qs0/VMQpErg+YtAtcgVYH0A9b84IE7dY6xxB2y0vTyv4zr4nmyQizAK8N1o/U7dD6XyP6QOzkURyXPltFPb2ygzVJ6WFgWHfZiyPBAglXYwT5h70AVXDqxpSzMY0/Ll4NMGBULbU4Gkq0p97llBChc8me8cgu5vuuwNb9X4JvdjRoju8KWM1IrKzRqAHm+Ik7vieADJIwPgP+hzmtABElCmVNU70jyrLNiw4NCYu70W/srRFI13axN8pXWy74ubcPtbAUYhvtiBjxIqG0E4IuQ6qeenVUarLMsdaVHyFxK9xfMRv0BcxekJ+gIUhUsbcje2ocg09+o7tQXs5j7Nhv8rdAh6D9iNBO/scWHeCDpwCwlOs+yjOp3jSxjbfmZ3VsdZcsoBJtIqgBFd4Aq1kcT7pJ0ONEWrArTWhmKAplahCPcWsKB+V/u2J0WDOWy2MtDgZt3Q+nnvYvCG3m0zOfb/J1qSbMTyLNFsIqBKQ8rxatcpKgjvnimpUWrbAZWDYUnquUO+GPgztH4xpYc0CGkPm/96a/UqrFkCIRvo72O6fTE/jiH0gTc7HjIhhfGrjjHVrZoxuC0X8Baj4RuXF19ddvnG3aOnrDXGoYqqWY+q10NvZkrG6dZUP3vQHmpn6uju2YjYEz+vaQRKaDninBZXu5FYWn5bqOV7KO9hMRY91uEUfDkzPCA+zA12Lb55tf2HF2xEx4a3oMJwQrYVra1sjFNSLojpLFwpXmF4sOY6MXrihEYmP6YHnvmw8aWrF/4tl4BLmXzxYQgoq/t77VHPPg
 yH71zt4h
 bdbw6sMo2ERHVWupCM1TOB+rxkuXWdPzoryhPqiRU3P+hdPUdaNEOw5JjB9Jm0FDh5BbJlj3fYZE62SKtX42UpZwVEHbwOFKLoyI2ugyjqvWfRwdr0WH+r4cvjhDEkcrXrtXGH5Z++mmkLQAyVhtiYvPjcfEJfznVpg0vlqVcAdTW/wF2a4+VkuWT+SDGNSkE+9slLvdXZwGvmqJCm2Qq9oCE4JzdN38MFLtswBADbtDbX/DUptpheCZa9DQu6xu0kVYyTi5G8mXGOOoOpUaVYGlmB205ScghUHCnzCSibl4yggIxyuWkCAi5vIGA4rG8seOdU8gL2+07mUG8cU+EsJ+/ZuUiYSW92nRIhSnYoHLacxomK7gixlFHWGGwhoD8eegxbVAOVnczDGko62p8aoBfHBvdP6wNs+gzjl3TQ4aUfvQulcS/dqnw8/I7bZQzNwGq+QHaZyPiPW1s1ClIOvMW9/wp7+2zlioiqRs6ccbTIqNAaEA15Nu+HQ3rEt9AGDy3hFqJKIYpX6VfF28ahdSTFFQeilpVR0mz
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
index 88474d4af54b..724b6e034e69 100644
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



