Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 515E9C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 05:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E1E56B0149; Tue, 18 Aug 2026 01:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0634E6B0146; Tue, 18 Aug 2026 01:38:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD14E6B014A; Tue, 18 Aug 2026 01:38:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCBCB6B0146
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:38:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 508EA140B01
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:38:27 +0000 (UTC)
X-FDA: 85113285054.04.99AE74C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7284A40005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:38:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kKAKg1hL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787031505;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rd/iQv4TZrWHm69tDUrgR6ziK59tmcdSkmhKFtQKJUs=;
	b=eeUrMgGQyy8st09qPzbBv0ce57+TCa27+VIcRbjb5NdwZMZfUlL3+E3LcVHiOd6200NDb+
	IrAvr6Vl4RCNDWa+9rkvEyfjrIHAZ7seXno2CmtXUZtUSA6rWECHn08PJxVR16H961SZs4
	UitfWy6WMJUXQqEN+Tch2DWbcUiTTUM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kKAKg1hL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787031505;
	b=712KnZrwSXJIwce0YUnyD6zw3zosyOBdHnAde/C4IYyRvEZUyscA49wnmv2gv07LJvX92m
	45UkCVOleNPipSPouu3rFfCXfnucTfaC0PURg+MOMHjKSaZGjj4NDIZ/ve6udFrDbbxT1K
	HKf63EOW4CrktRPtvpb6HbSVmZXxej0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DEB7A6020E;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72091C4AF1A;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787031504;
	bh=Sx8EIzWCQwmQ5nLlhTfCRcDmg7PW3HdfIWlqtAUVtug=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kKAKg1hL8/QJ6S0wakilKwr0s1rR7LJsgNCNefhuFRVEv8PUwaWU9/SSo2PhnEhZn
	 HVKQ9xn+0mBjwgJV4cWk66CGmEVELNGV4V7QqIzj4K95A/LY1fJixWtIBpIr04SrFf
	 DBlbgwCurQ10l/B4NqBwnexoc8HLfHMwzuZ+B49662MrfentTkxYsUwdlYU7l2BzZa
	 SnXLgolF2haIKbQz4jZvJttKu8WCYkfMSufzF+wQQhKdZjM82gQbnAc/t2D4jgB49A
	 lT0pEkpbCsOUH5Wcwz0fwpdWc0Cqd2mUBsOITguRHS3xBi0rbG8F6iowhhHfiQ5WGJ
	 EJeOrv0s/cWPg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A915C5DF67;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 18 Aug 2026 13:38:07 +0800
Subject: [PATCH 5/7] mm/mglru: use explicit tier range in read_ctrl_pos()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-mglru-flags-cleanup-v1-5-8dbbdac0d28c@tencent.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
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
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787031500; l=3448;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=GYBGb1xTYAtwF8ULj9QKeuy7M/IFOhc3aBT9Nkjj2Us=;
 b=hZsipqcQnctqC9gaBUbfHO2y8v0AyYm5uSBYOqOLuZZpuIPS1tItIjOSQv7M5GcDMTYwSIrAD
 Vygm8AIFzatCFz7bA7FXXGfPRfwCpMJd9W58MsRsA4lbht1gCaM74wm
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 7284A40005
X-Stat-Signature: 481fkymwobi3jg1489yefh6gx4x4i15o
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787031505-928400
X-HE-Meta: U2FsdGVkX1+a4i2UoGV6/POBxPWsx8OrDNgZYCrqoMxV86ZbKkAMnwQ2LJ/ZeHY0VE1/5svWEJ936oJnbqDQKs08h1zb7jNLH0h+Jpk6ET0nC2/qLKZnjFiSBkI8a69G/DoSOV8YUMN6tYOUaT9txVupb5I8AMmac1eHZCMPwW8/5P9PvYt54KsrfaKep6OFqfaFmgEY92qQkqU6S7sNFS+rUrdKQWOLUMqi0PHE/fv/T3Ez0sykBN8DAVjs3mc2tjylIW6KsDEAJlm1iI7KudgUzNSEBxFUHWMEwm8zqLWWvcVDliP9YksjnDO0PTje5iRWUAwcCnJMQ9P17hMH2v8ilCJthgm2aJdnnXVBVZuwXBtJbaO7wdjoRb+Is0hs+mq7NiWMqrZ8qq7B3giztZdpPX4k0b1vdD53sZVTY4ug+B/LQLjc06jMCbMKWg2nUnRqQVFLLOgOot8sIyXpwLTThd220qCoUBbWGEjidV5dB+hpiC76dgomwJq5LoVIMZ+zvHyenqUTta7UhlTmYsBzu5bPMHDByN1XVHzm+EcgrA/o8qRy2fcjpyfIlxgq5kPv78Vej3UQ9y1fZGyAdJ1ysrDQxK8qzcOl2y81jRcs3hAZ6uy0EMmppqcevGk9U2uvmJaghNJBOb4wKPShajr45xpBoFdXR8IZYnIkod2vHSck3yHs7lidaWEge1LtTQZgJQSi0ZYkcvSdpL3XyLirUX5RMUa4LjLLgaX6oyIjuXx+z4yCZBmkDHKZ2hxKZMW1ZQndWBq4JkLNDFZ/r8r3y8JoIObT8GU4E3TUnttA7QHrx6qrxLJf7gdhVCBBIqaovRIXT56247YEPNRtRIQC9lMLDHrmA42G+jf9n84CbcWpFuyaVhDcKyWmo3p8tqxii2Y9Hc3ujTRbNbzBcYBa4p6QLp9wihiNf3+CMxjFW28dBDFGVtlksfuUw0c3aYil6CFhvy4b1RcaOBb
 FHTrhY/Z
 oHK4lCUtWaEK4aOI09OMutp9LCAmTlqtqAA0uSC3joT+lN6z1hWQY4tPhkEOS2uNaPpu+C85pkiRnXyBkQzIh5VcejR9nnalqmhzMUl3gPPUbu4jyHM4WDVi07z8WTg/C+RnyT9Gy0TSBbqt6ujKwHnBesC0cqSyZ9LLUkcvD/FqT6Yie3LngFz22tt+w7LXo33N06+AEgXpk3lTQi5kfcPOZNf37ECjm3u+cYZxKponajy8OITnvaxiQTUTQykecr8/A0aQ1uSvNfk4hZwBEbWP0EqD4LJiVLxfIxGwdUUA1WowBjgCABi/sLtqYqv4/IfX3CTtn0iIYhRTi4WuGwQGeJT8gL+qhXPubhYPRCr04DkqNHyw35c7OnuS8iG30Td4ofgD8uczWilXYuCja54gsG3d7/LrANaZOEhHlyx2DK0RpBel0bmymNEITAilDIro0C/91QlCtgHg=
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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mmzone.h |  2 ++
 mm/vmscan.c            | 18 ++++++++++--------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 32d9354a754f..d0b5c6217d25 100644
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
index a819be6b7ae9..a613bb8d7271 100644
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



