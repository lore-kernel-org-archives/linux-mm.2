Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD6F6C624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 16:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750ED6B0098; Sat,  5 Sep 2026 12:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700976B009B; Sat,  5 Sep 2026 12:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6160C6B0099; Sat,  5 Sep 2026 12:51:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 443A76B0096
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:51:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD8B880380
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:51:19 +0000 (UTC)
X-FDA: 85180299078.17.75A00CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id DE0B240005
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:51:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vOFmXfhe;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788627078;
	b=KJ70BuVRFYrXa/VvFiI9GUnFehB2F8SBZUQILIMXyJorR0QTqxgOxgfvbw5p3SO0sdrLjH
	JdLy3wAW4Zp+yzrcI+z+g+qLYoooX4dK3VGQREAEUcC+zg5+b00Bl3kJmyEVkHurdlxhLi
	2+AJiGFvlQuOZHN0e5GaCGHXRueFR/Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vOFmXfhe;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788627078;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hRF6Hh5UrzH8l5m2SQRfBnPzl9zOjUYjFZ2LjflAJB0=;
	b=zgOTn70hMb0SwftdQ+AiH//DP6c04k1sX4dla3siDbvYl9yG2dYvi4apr2cj/bhKlJdnwg
	cVaR993typC6K8CWG4E8mmKUs0R2I3XhIc1NYiz5d0cdWBojFD7moSi7i3LFx3dBSBY1Xu
	+ZTg/VQ0CiBjFhiRhF7MEQrSfupXElM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4A9F447CB;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4F1CC2BCF4;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788627074;
	bh=AVJXq+BQq7Pf0gKBWFcyLJSKYOWrbhfVNLrhrg8kmEM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=vOFmXfhe7uBdue+WGOPFfNgxp3UO9nDSBzOybDDlnjqdE5FXSUJYseWKxif2trUnb
	 pnExadqU/W2ElxjAPuq+xTnX73WVuCRTz3uhKbUExnPYXmVzr2IeJs1EGst81PiMcf
	 uxc+qBJKZ5cpCOHLXBt7n2m9Q8xOo/ZKxuelTULM7PsVdoYk+Ifb32ry9PDSS7VqJ6
	 fRVxL9Pb1DFhJu1Sjih5ejefBedbbopvlIf50YhfXDRPC1YShmIiiTtwOtO41F+ubo
	 nDs2HvZ5g38mXS3Cq3D905aC42SHZzc8Zc4V4PVTYNN601Z6M4rhHDnO/LgaCjZ1JB
	 3C/aj4GGr099Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9154DC624D3;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 06 Sep 2026 00:51:10 +0800
Subject: [PATCH v6 5/6] mm/mglru: use explicit tier range in
 read_ctrl_pos()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-mglru-flags-cleanup-v6-5-9aacbd77d4ca@tencent.com>
References: <20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com>
In-Reply-To: <20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788627072; l=3649;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=5MPHjX11d6p+ZO2XLfReDjM4IrSH/0cvhw67NcVOu40=;
 b=6tKmvBMZdSyt2tfNvDuqlrCr4GQeQ3b6PiKqdka154yqj+BC9/ROdqAi6uvnMnPWtDZ+bVzcN
 Se2TkDQZKINBiO+cN0BJB38+Am5Jy6eDI4Kz5i/zHS4q8X2Ylf5IbNP
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DE0B240005
X-Stat-Signature: faxenkghgsifas6ocq6xkpwwmo4eetww
X-Rspam-User: 
X-HE-Tag: 1788627077-645006
X-HE-Meta: U2FsdGVkX1/URfTn8WkduHOvnZDbjx4zTYv2t3Yt4wCyV1GAh+YGwtpyYofwV2+6pcAmgesN6yfRuFvIzPA553/6Z2I2RHOXUnz2wWwuyM0u9AuBMC687agHN3OTPVpberoI+oCV1vkGU+kAbbe2ubcaBd5jc8H1tq5KgE+HdyEF8D1gAVcax8RoIkrko9luThv7bcd9whwIj0oiPiFtdLEpnk5f6U0u67S2XzsBQwdWzqWfedp2yz/T545L0/iphHZP7sky5SZt1V5k0E0JJq4i2prdJMFd1RG3R5nrO1op383l5K010T8kpzBMGpEEBW8UKbCne8h/p0ekwp5rRtxUFr41hQgUUmVVQHS0CoblkNtiLJD6O8mXGaME3ptYchKDUAG2tr6GVGZV72/2aj2xrKxlcDmFYFF12IgMDKEklDI/n5Xw4ZK5PQPlb0We5x+b38QzJDHK66VbvVUhKA0m1Eo9BbH8kGQ40jqmXVVAMazN1YwMGYpF5Y9deMpbFG+p26wbq/Dsy1M63h1jnj+gvhWTSva9GGsnnFDHjwJ9tqyJT85v7eSSDJNKd9kMdyY8FnCda0RHhQtIFkfjP2T3xUBedgg2Ny1YGujpmlY9YyglaUM2iQoAcgViSEc7IbGoqdkmtjvOlzaPbD3j14X1izcVmEjsQLLBMxFlRLtQtYJjWV7T7zh3u7lzU4TIlndaAVMk62fAOKRp78vluuUcklNURXRTME0LiQuC4yRTfeeBZBQ3ec8YXCbqFycHnMFbz6tNFGS6y2Bi2qP2dp9rH8uyRxOcdH66OduQuApzhsE+Tjh66tgfHiA59fagWrmgIK4hXSB9R8Ykw23vIXbH1MIRyeSLlrE7PZ4kRtZjCGuf+BrJV7lVjG0VoBgkgwRyx8hyL9GbjrBDmDd0uskplbBNjHZrWr+pC23Ak+14oTmwgiL+Pe40wEjx5ufx+z75cGmay1CTHtLg+3k
 q7GvyoTY
 YiOobt0KikzMAZ/NEfydpieK6qmh8RV3kUnx0wAUwY9fAXLD5+iNWm2chw4FtsjTjVEIjK3l+e/ZbKL7PsRFHwdNdj88MDmZ/zXEFiVvx5Z4h0x48PsFxY96IWYitpr7Ynj0nDbd+q8kVYy4hplNyCqZbD0DRTyQ2iFP3/tBGsySXs62xq8QVknCTQ1JAQQqtJOl9pUzNZV05TIv+V1/tiej1bEAPWTpcT/la+kpuQI02xyP2NSOuiYXCpG17qbLbbcgqmwcgUZZmEu3YbodD3NHMr1uS2bhL2+fdIuBkkeno7HF6m5y8eO28Y1I7MVQtqpW0Tmsm6cJY+/dSitsWXtjTTFKvEtzQ88HjgqGbWOVgDXdFzBu9XD+GHmpBIOkX9sbb/5V3z4WGzCpb9jnMnM19Dy6dKUdkfCEvxTk8nmX2M47vXjWxbb2xq04vFxg/KI84vRIeyJJmxQvkrZ2nhNcda52xKpjyf8QOhulloCZm6ehOaKy9CLb8Qo69r/bvjwKs95lrNTix1fs176LAx/34ZAuso5Y3JyHD
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
index 775d6279dfea..c9ae7991a8b2 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -495,6 +495,8 @@ enum lruvec_flags {
  * folio->flags, masked by LRU_REFS_MASK.
  */
 #define MAX_NR_TIERS		4U
+#define LRU_TIER_MIN		0U
+#define LRU_TIER_MAX		(MAX_NR_TIERS - 1)
 
 #ifndef __GENERATING_BOUNDS_H
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4732b987aa67..ec5832b0d867 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3223,8 +3223,8 @@ struct ctrl_pos {
 	int gain;
 };
 
-static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
-			  struct ctrl_pos *pos)
+static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
+			  int tier_max, int gain, struct ctrl_pos *pos)
 {
 	int i;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -3233,7 +3233,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
 	pos->gain = gain;
 	pos->refaulted = pos->total = 0;
 
-	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
+	for (i = tier_min; i <= tier_max; i++) {
 		pos->refaulted += lrugen->avg_refaulted[type][i] +
 				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
 		pos->total += lrugen->avg_total[type][i] +
@@ -4879,9 +4879,9 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
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
@@ -4902,8 +4902,10 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
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



