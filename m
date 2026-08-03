Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16CC8C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0146B0099; Mon,  3 Aug 2026 15:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 988296B009B; Mon,  3 Aug 2026 15:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D326B009D; Mon,  3 Aug 2026 15:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56CE86B0099
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:47:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A56561C0F6D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:26 +0000 (UTC)
X-FDA: 85060992492.14.8B6395C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B021010000B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jbTvdM4k;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785786444;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VbL4xtknefYGM2fQFFbFYzwKuKQLLeBTLpTrTgiiilc=;
	b=MyVSSo1zpvaqzirae28stOneBmPB+WKif8lP9T3dHb7BO9VE1A7PQV2RHzOO21KRweYxr1
	gwiAm0GOKqXS5oOuJ4Ldlp1xtKp1iUEE9VELIHYwheh/bLxeLHmaeB6q5RnDdlufAwmTxJ
	IJWJdHtR9t7IQWLl8lHWJfstRqMckM8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jbTvdM4k;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785786444;
	b=0uEYQTMbXglM3oaJZNInL2DfZSPnqwzCid2gc2cUvh7eP/oGQDmc68CYoAcIK6txi1LkFf
	bdvvzrfgExrimfMoo0ek61wefoUeiXTWpsWyCMtoUYTVTMnQv8IHSz3dKUhwc/5B+pS2a5
	tY+ldNZDiemcnOhJ2dBZsEqSMgT+a+g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE1D644035;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4EAAC4AF50;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786442;
	bh=HQaTSb9gKEiXAW8L884mD+Mrb/OnWgT7I1M4oD8pA9I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jbTvdM4kU319OryzxazU0+wim1SrBjWHRGzrjsZ/dE/8RKZ/X/pWewA2SgMACUbRU
	 768yYi9K8pPMEYD+lgTURjA56h4lGz3rhufrxlusn1dEWblp0AJlCmyqqa0jEJLtVz
	 yCipkzFcNfSrEETg7dAvwy0VMAUtAayuIa+9OaV0rGWUQm/P+uTUuMRZSlYR/egXhM
	 oocuydPT8RyO4FtJTpZYTYFHOXpf7m1MloNKOGK9cn07MQuIgPetlA1jku8E7YOQ/Q
	 b+QXd5oV1eZxq79+1X5IAB8QGFoieiVHIvp1OYXaBw+Nz3vKJ/Db5hgSTtQxBfpu15
	 9Pl9ZwmygdQtQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F13EC55843;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:47:02 +0800
Subject: [PATCH RFC 06/15] mm/mglru: use explicit tier range in
 read_ctrl_pos()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-6-4d8dad39dad6@tencent.com>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=2788;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=sdC9n1WO6u/L2tFXmmCkir7R9Dni9ihu1pJnxCifFTc=;
 b=xv52kVfAPZlxWefP3f8wGwS9plTRIu50H/DgY4be7zffsSSa+ZutP0PLQZylfBQsByG3RFGPe
 vxKVGP4iz+OCGKU2vFXYDZzUJzjoXQqLB4c3nywiA7e41WfE2Dqkv4H
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B021010000B
X-Stat-Signature: 75a4zb8ud7ocs98a5gsyjs1knej6iha7
X-HE-Tag: 1785786444-302656
X-HE-Meta: U2FsdGVkX1//xRn0d60DLlyr1JII27iIdNmqJlY2ASOq7xFpJBn/tqsMGKULLesUG/zViLXzesjZtcJ+N2WZ+T0dODeh26T+szjAgoR/ETir25HPhD9TpurqcdYdg+hXuk60H60LLwtZccvZWX+3KvlBVo66GoDcuxz8vHddUBymFe5Q6hJreqXAK1+wO/8h/iyjLTjm5JeRpXJSO7qS8KCJWJp74iYOTCdufsSyintHqIKMBACu3a//79/yv8jxaJTOYwTHddWGnkMIGscFRvfWCE8+QtmONtMnZSEmb09YxRYzoSNnzjQa0TPA4vrnAV3I73A5+tuxGKrU6ETll8d40lp/AN0EwJuYsD3w8Ef7bia5iuFrZkA0WM6O/1I7B4MpkSL3kBXeTPbUanCnBfKUZ3RnizWa3arUxA4Te47oRI+8vsZlInrlpOXv791rKSJ8H+QbMQ59ArxQss+m455WyVefHFSOh6PPaotEwTnhAJQiFeUJ7mCVbhUDvNVGZeMMJ8ZoZaoXZf5jg1lJli6RVoU08qtT6IaZxbj4Y6L5jS49gLRASihw4ETqhg4C260OoZtAydYXK5388AU6ohGsB1gRXZjJbjaEZD/ZiItN9K/QOJ76mLUQa5R33WeQAQnVj/DAkFqMnKrC/V7aCsoBM0/nf5f87+HxikCToUUJ1ObBhysUv8zs5my7RUbTdOlHxV3SH6KppCA0eJLWCWFReofTCErMtO8Dm+0UUvYD5YJ2Db+tbLzTx65AWp6XQjVi5QQyullsGJymj7x4VmLOnwfhnmiR2AEELBgsIhBQJc9ivw9DmxDwjeYMn3+751M5ao3nWgJ4Jtd9Ndc31BplWHGoTKDLONlBDhF+cwB0GwPATLI4zBtWi4cJmzFF9ydejJD+TEBX/GnKqmDh/3iyT5bk40q+XDiwhdRHI1dBkedKsBhmuCR743mqxPrTS0Fvp9NiWVOGVmAcY9U
 Do+b4xd8
 FJ2CZ5Nzg7PGYyqi/gVNRpVccW1rnursvpbeLz3D6hTSj2EL4wmgWJK1/Xglr5k6ObeMTIY5gcvG4ji2f6cfMhahXspPM9vP2WIgFFIa+MUDpB3pcbYpwJpx3oVNsZ1yG+qLA6H26wFMShRheMkHDJBEEYzbuZ9DmIsF4YIgC75XeMysc8NuVmB1CVb/f9cuzu5kV0adA6XtQV5r+BNzEd8m3SaT4gVSAS71l3OMVCQWZLgknvk5QkpOjLIYtho6LJK+J4hKsIYKanQHz8GlhxDBE+lznCdA8lUpJ5nxfDZYRAqJQGV/lT3GdjNYFP0WkAY7PtNQzBiPzBNl9xY7pxxR19EFJV/UVxyc2XM/J9KiuxsGiaCb1R+zScrkSGFdkvJp+j/f1Qj4z9gztaVaCkS1sSalyQdBsCeHaFuWW9hFUKcz0GKXrXIS1Q2WBEozXrwxewH6ceK4WRUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

read_ctrl_pos() encodes the tier range in a single "tier" parameter
via "tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)"
as the end.  This is hard to follow or maintain or extend. Tier
values 0..3 select a single tier, while tier == MAX_NR_TIERS selects
the full range.

Replace it with explicit (tier_min, tier_max) parameters using a
half-open [tier_min, tier_max) interval, which is the conventional C
idiom.  The call sites become self-documenting:

  - get_tier_idx:   (0, 1) for tier 0, (tier, tier+1) for each tier
  - get_type_to_scan: (0, MAX_NR_TIERS) for the full range

No functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c2ea92c2b69e..a359d5a1ff41 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3192,8 +3192,8 @@ struct ctrl_pos {
 	int gain;
 };
 
-static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
-			  struct ctrl_pos *pos)
+static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
+			  int tier_max, int gain, struct ctrl_pos *pos)
 {
 	int i;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -3202,7 +3202,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
 	pos->gain = gain;
 	pos->refaulted = pos->total = 0;
 
-	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
+	for (i = tier_min; i < tier_max; i++) {
 		pos->refaulted += lrugen->avg_refaulted[type][i] +
 				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
 		pos->total += lrugen->avg_total[type][i] +
@@ -4805,9 +4805,9 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
 	 * This value is chosen because any other tier would have at least twice
 	 * as many refaults as the first tier.
 	 */
-	read_ctrl_pos(lruvec, type, 0, 2, &sp);
+	read_ctrl_pos(lruvec, type, 0, 1, 2, &sp);
 	for (tier = 1; tier < MAX_NR_TIERS; tier++) {
-		read_ctrl_pos(lruvec, type, tier, 3, &pv);
+		read_ctrl_pos(lruvec, type, tier, tier + 1, 3, &pv);
 		if (!positive_ctrl_err(&sp, &pv))
 			break;
 	}
@@ -4828,8 +4828,8 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 	 * Compare the sum of all tiers of anon with that of file to determine
 	 * which type to scan.
 	 */
-	read_ctrl_pos(lruvec, LRU_GEN_ANON, MAX_NR_TIERS, swappiness, &sp);
-	read_ctrl_pos(lruvec, LRU_GEN_FILE, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
+	read_ctrl_pos(lruvec, LRU_GEN_ANON, 0, MAX_NR_TIERS, swappiness, &sp);
+	read_ctrl_pos(lruvec, LRU_GEN_FILE, 0, MAX_NR_TIERS, MAX_SWAPPINESS - swappiness, &pv);
 
 	return positive_ctrl_err(&sp, &pv);
 }

-- 
2.55.0



