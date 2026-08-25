Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BB37C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 17:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FB846B0099; Tue, 25 Aug 2026 13:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236706B0096; Tue, 25 Aug 2026 13:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061836B009D; Tue, 25 Aug 2026 13:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C757C6B0096
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:53:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 589D78015D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:53:44 +0000 (UTC)
X-FDA: 85140539568.11.A0F8605
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4F5E840005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:53:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DOUWBnWA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787680422;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2NOGJTqJi2itAPe1rZdqM2sBDtNW99NJZ8FhGWLLKc=;
	b=vaxkgrliw5znzofDWyVdSydVoFEp9b8yT47Enqxj2tWxO1rIrDB6uie3vLOcH6cgZl4RMt
	cstP2eO4ksM2fPTr4HYDc3LkOAQ4Hsdi22j1As2RYoV8crwWU9tAjuhRQdA6RhSJHwP8iH
	usYxVvGDIJ+I4Ik00XxvKCNKLMAui8o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DOUWBnWA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787680422;
	b=VMLmUG5SCR5C9o3YGNBCnR6/zQP5Pqu3xs5VHotHjzHtt6Q3pPkQYpcmTvsxn7zJSaX+66
	Fppo0jDTTh8YZlcCSUyGhXxPeWWf4gB4k5rGAEza0bsxieL9H4ksYmIgpMOCkKpoMsI8N3
	pmeH3F1vF03zBPWdMCBotIsyXyrDmGU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EF5640BC7;
	Tue, 25 Aug 2026 17:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4FD9C2BCFC;
	Tue, 25 Aug 2026 17:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787680418;
	bh=ilakZpztXdNtURa4vGOWPlKTSITFZy2GPzF7HXdVqgQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DOUWBnWAELkTW70E1+P2WLj44k2tvLm8kemVPBxSLOWc65ODtc/6iwxp/aZz1etnr
	 O407mI+62/OJqqrsV7CvJ1XYtRhJbabJpGPR92QlHzciWO3J19WydKc8qkntXetLLc
	 RBeBW2kj0dNBHo6VF8rAdds/GqNZ7b3+fDNiKJDk6V65zSRPTi9fzglz17OBZ8klEK
	 6sddYklyXhqNrCsTR+X9V7+T8toGnWrfaCys54OvAbEAKgkYSsMsPPi/I9qBqmdk29
	 nSekW8BK1G9bOVvH0A4of0WvOT6RJMWZ6qQ518NdkwlzO70y+C/9h1Vdgmqd8a+ZDJ
	 aeymgFHJMNDkg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB4FC61DB9;
	Tue, 25 Aug 2026 17:53:38 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 26 Aug 2026 01:53:38 +0800
Subject: [PATCH v3 5/6] mm/mglru: use explicit tier range in
 read_ctrl_pos()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-mglru-flags-cleanup-v3-5-d9f1c75549c8@tencent.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787680416; l=3599;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=CqsOXlI9cH5NY6tCCYvGAfTjoHFp57O2DbCowcuJ3As=;
 b=SXZv5Jc5KLYAvgB60yqDBUGmHVbClc4mIxDx5wGM8BsJxIlhL65zo1dW0A2aQ32vnkrzh8HOA
 Uos3CdiZ5ZRAyiKyODkv36QdlUWMqQIRJe3NVIGYz3/VR+g+DvFzl8f
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: bajzg4j8ohsdj4dnfm7nkgwup548uyai
X-Rspamd-Queue-Id: 4F5E840005
X-HE-Tag: 1787680422-720392
X-HE-Meta: U2FsdGVkX1+he34KpPfKQba4r2lbcUq9Fb80+xbbHAK/5VKZxblZR3SVoUmcuHEHoyvJnm2buuTNH4NUcBkQNJPfT0MOIW1ZqAUat8kl1E2AVvqjryqOnBJo1Nq/ydMxB1AA0sPBccpp/tf1yCatYbQDMziVmZgGDgZzjDKESx7SAMWiP3E6cEjeitzh6AoeCNkOow3JivApKub0oJZz6xOuda2yUKeXdaDPHOG6f+aNktAuPrDeoskoSLAu/2nlmp24C4IFAkyR2c9P+3MUGkiEMi0GlGNUL0vVfLUKnXFtYEWZ3AFngATzlW2KU1Z/STWhnpO0S5A3GHFY+rKP70FRjCZLY4eT+28KQOmHFtGu4aUx8M3RiIdtu2EvUaoIbJ3yKqRaGcoxJWTmwxRcbxUQvD4OfRxg0YedzK4RN59PID5+BtcQFlNVilfpQlXRdCHDQ9g80HF9+buAF0BcjMDyondgku3GVz0rBkk+//ExOTcG5Bdz7EyS+n2JkmTpRdk9dlARAtVL/aEY3C19slOeSNH4cgYfupRTiku5h5nqxWAeRObeRB2tAZdySTXRryxPKRiCxBD1622Q/nSl/3dfdJa9Ji43rVNgs8SDZK2Tm8/de7DEVjjqdmiUwWG4ij/EFCuDSlviYHQPM0juFS0Sttz6Lg2ZVuQJ19gZndZOrLvaF2JdTWHwYdNRMIKk3IiCOVHMI8lRzXV7XNV85HdUlOryf7SsZ0d9XrpfMmmT5b6BOdoyI+uIGUKsU11U2CoeN6VKQYmdmKv2yMaaUZBI/CRzSdH+kDStia3LGNyN7hotpS4SzUHS+ogPhCpxqa1thMst1mI+VgnU72rYPjHFTM/Z+vnNVPbcW9XinNnegjE9eiQ0dfTQfVpd9g2Iu0uW2RAKVogvIEkbHNwomywj0oPBGvJCbNaa1BNBDOYtGkS85xukMZ70UmEH8q4OgFReVIY7DQnMMns1CGA
 K1Jxmpnv
 fbDOpfX0AogQKjhqvGkCxaUh4cPI6o2dyLSpxqw6j0st7WwPDHhK8Y1pCVHejtYGf2HAXRL84kBhbYLRtRTHlXoNDODvQGchWBaBcC7SdOoEKcX0cPZmkPJ48ZY0TE9HuaG/66uqW+LoMd8ttz46qO9xKdVvvuPon+HwskUa/TRcjYQjpmyU8yj62B53AWXpjvJyXZJDBelZpoWqVwotgzF/uCm9GW8UWK/+XeNV294Y0zDbqHlQjSjo6CsJK8jygsv3WgAbmZv7jdXudoAav3lXizVVoyOIihTCQ5+kNZVwLHnYXC2IqFKmV+264NZQywrlsP5cphbqE14tWc2bz/XUsO9Td3rQUw4KNqE/dmCfD2qOUv45gD70nHy7eGf2q/o3lzjj07UWy+AK2uUqS20416nYUdIwer0nNmVadM9EgsgazAt4pjYgdJu1D8c4FAt6TYCp+FqVOKPMu2WWkMiy3oeU33lyaxF6Os7k/lF+T/c7aNSHIJL0FpA==
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
index 52ef4c3705bd..cdc2e44875da 100644
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



