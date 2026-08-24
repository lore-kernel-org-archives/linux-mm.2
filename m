Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F52AC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36E806B00A2; Mon, 24 Aug 2026 11:26:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3471B6B00A3; Mon, 24 Aug 2026 11:26:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C2B6B00A4; Mon, 24 Aug 2026 11:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA3266B00A2
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F56080193
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:26:35 +0000 (UTC)
X-FDA: 85136539950.17.FF8837E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3AECA1C0009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:26:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ht9i7wUn;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787585193;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ha7J3JceYbiBNcl5eeuPz1TZajjn93vUhg24BOUsYI4=;
	b=vpBU9zigosXG8X9ZldJg5hSjL5Zc0D5z3V8o2K7nKXXOeG9VfVXM6sbEcBVzH+HuTdXmRM
	00kzj9YsGlFNxot1fH7BpOC9uwBu8seIU8Q9qyxNlJLF7KFUPQR9WqwRmstXnwBiR6ZE11
	Wr2FSuzI3tBDwoVNA0Bn4/mB0udOkdk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787585193;
	b=xBv9rWSVZfz4gdCojRkb67HjM4cs3KwAbbhzBU6lnsG6Gmo2q62CCzN3pCkhz8xcMsXSwX
	xW8/7VUK9/rfsSbXQ0RwN0Hzc179pykVO7NG8y3NXgBd20Sdki8NWo4CoTUsE2o7xqGbMK
	SqONbNSWNoat5gn3XkU5b3q0EHX/SlI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ht9i7wUn;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46C6944044;
	Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25F9EC4AF0C;
	Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787585192;
	bh=mQEI7l7Cq0I+IgVoWLBWri2Jyk4zZGhg0P6mQGe2AKU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ht9i7wUnH8etcN27Ts3xRBEhfGWk8yxmhu1zyHJW9LGSYqurglmDx8RwXHYg4KJFf
	 z2KHduPXoaB8FF58xtffkDV1Q0a7vqzxq36ZEfYc+QXsNtqN7lQ7ABSX6wFPZO1tAJ
	 o5eup5wnjtD8lV8KR1D6BVFAvtr1M1Bh2Jgze/iFvslNi89UlZ7BC6e7/edm6lHcug
	 2CzMV0jWn8YASfIYNXOdprkU1mO8kpnbymPbvpm6KbCVfgJ86Eir1I0kNEjCYMJY49
	 MOJc2d3uo0hA3tKN9VukXYgV2Vjy0OFzE6PP4BVk04XsGJMoUvu3lIOLzjkEubcHJr
	 c/Syri+mFVWfw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11DF4C61DB6;
	Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 24 Aug 2026 23:26:32 +0800
Subject: [PATCH v2 5/6] mm/mglru: use explicit tier range in
 read_ctrl_pos()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-mglru-flags-cleanup-v2-5-0104132114ae@tencent.com>
References: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com>
In-Reply-To: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
 Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Kairui Song <ryncsn@gmail.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787585189; l=3599;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=F4Gku0HzSaxpr5vUbexfrLyrBNocoQzHGkkgGGw70CY=;
 b=PZykz2Q/M9MgVmYuwCevSKyf2Ua8qd0n2vPVt4NypGyLX1ZWWF0KtD6b/i6LAUaArsVkCRhAz
 EatgnbIiJXODaIuKBhJOtS8ErTHwNbFu75Ut9Mb27O9WIgPfUI4WDQJ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: rdti87rkruf3jwectm9mdfgn88scrx6t
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3AECA1C0009
X-HE-Tag: 1787585193-899376
X-HE-Meta: U2FsdGVkX1//d8k8rqrJPci64nn27nRRP4BDsC8ZDWi3rSyghMkYAbp1GmfuHc3UXQiITy58IGtrDhXEur4MJZmTEAu5mbbgQKZAtHMTtpfO1qzJBay3W9X7ba512k05JXrsaGbHP9K18LBPSkS0qwYJiedLUrVbWkADE6haY8VVdBcdMf95Rw7/IGMJz6EPEeVB7+PHlUeQvMrTJgf76iYw/kHVOO3TSsHUUkQuHTFvq8erdSd14vdLveHmLJ0G77Gey2e3KveKNwfINOYNhKYb2peKpTKLKk0eq8UthDu+TfS1jD7qvdK7WwxYVOS8bqgsPu8dJlFzvRzzw0ds8SOgrfurf7yRZaJrGefDgPjyjovhB+80vbl08SB8aeSQatMHnCgfiSjKDHopdCRcuRweyMTVZlCXb9EW0JvkkvxNapZOOqpU0VYFVyIvUfR1NtRtjHNLIBVl9WOyrn/MnBsRD8ylLRFF+agWTpKi48efbnha+/LuZk3ZONrbZyuA7aqnNp4V6/Ulatcg1lvRB3iIgsIl+nCSIfpcWJYLtHaWyBNMErOjUTCB+tkd8hU9I/sWguFbyp99Gj8cn7lsuUftyHW08cu0K+9Wxi5H8KVfrOGIC6J21HhO8Ojn4Pajuzq8U5oa0ezogogxDpOKteooUFPVGBUAYOTgYSweh3eS6obsKzlJaJXmEQ7P0tkv6avfQr372JVZOvoPR5d30xAaKdGviP09aRwcqlZFNQNOxSUZg05rgM4Yjl+uH/FXg9CRCthiSj8pzGoALQqq7oMytvPdHPPD2MziCwaKh7Gg3b/IBHRpa/J4LmcDYukZNI7suRGNeI+MLENEa0MLwA4u/4QHiQEJwp0PCEMLxAs0KRB5GokpO8Kd/oBPgpf64RmBuWPHmTwmTJ5aIPrKCoZ+9hX5Qqi3HC7uahgaZWWLw996qkeFLqekqDvfpJ3q1nNdh6iC7C3kf8Hro04
 Kkd4nOjP
 XC3SBuitSfem+KqwgNIWPQd8NdTsIVkyxMstV0pKTLTPETwGDOwdPPOyzoAwbnddo4zUHUYnyCCixAQzfZ4A+FZt9wVqBOLGsPLRJZGyraq/og3NnBm+uJrv98l6B98k1Wtrvi7rRe8J947Tj/QlDU3C5oiyykKa6b6ANRg5qugZsdGNuoTKkj0Jfedgodg9Ps7lWr/jdy1f4g00ggdtAVqmKYNQhSfAq1lMtssqEOHlhILMDpuzUQdfifxcWxO9LRKyoijWoI81EI3OCee65ulbIkw/nhbzn4NAVhvimx58Tsf9HKzTREtDwYfNOVi5qp0Qm+UA3wnSY624z20cayMTgjaz+9txW3kCgBgDRwVDE3rDVEU0Xe7LVqnUQNL9IqRseOVbaIgtq/A29KjFLUt6FBtRT7s5G+Q7ffuh+gau3nGqdl4jzjqh5e1otKd8xdP8VIbKQN4sJfFv22loq36N9WAjLF5tGVD05RQ0OU+EX6TSkIXr/5i+O7F5hJeyCkQxB
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
index 557927b498fa..f8e291968342 100644
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
@@ -4804,9 +4804,9 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
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
@@ -4827,8 +4827,10 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
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



