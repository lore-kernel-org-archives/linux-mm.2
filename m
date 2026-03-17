Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6513EFEDA11
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD4E06B009D; Tue, 17 Mar 2026 15:11:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1FD6B00A1; Tue, 17 Mar 2026 15:11:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EC7F6B00A2; Tue, 17 Mar 2026 15:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB706B009D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:11:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27247C18A3
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:11:50 +0000 (UTC)
X-FDA: 84556499580.13.D6D0094
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3E165140002
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:11:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I9sZ2tas;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773774708;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DExbb1aiY/KT+juKpFUOF3Ev5m4OFD68jmd4ozvk4JY=;
	b=X968myZWQyX5gV1d8atima5YpjZL3sW7xpatfeBj/3zA3TsCbFOFMlNwXBv0yg749OK/Ty
	e3s0u8myi25QrzSktefM1/VTxXy6mW4B0KrXSH28n1jh5k7iMWikQE1UVHYZZ6Ivplc3Ob
	ik8fZOjJ3CV9+AKZIN4WgUgqgx5wjUo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773774708; a=rsa-sha256;
	cv=none;
	b=cgGD5qDF6hnfMSfwFdwVSu3wnjmTUGACHqRdg8cR1CNSJdFzMhOMe/J7Pdc5FoDYQ7V5us
	9GMLPc5YnSeLCR1kFoQ22oipE0bdxdf+cv/rLWuQKXEaMvOxRy/z4PbH6PZoVzK2fOvyRR
	26OKG48nKydLVFLjq5cW6E1C4BmuIlI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I9sZ2tas;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 70A836133A;
	Tue, 17 Mar 2026 19:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB3D6C2BCB5;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773774706;
	bh=PR5tgNyhL+CVQhWVK3kXM+OexXjXaQ+bvPHkvSxbGGA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=I9sZ2tasDiP0g700EGkQYGCAU2P+C4HkLcesZCj12GUpEE9rl1xDAeZqqRicvUy+l
	 Vf9ryMshXE9irVWyBvZ7GJmsQKfOUHSrarnRxMbaeM2t+yh3IUKw6CW7PE8VgP+45c
	 n35fU4JwFiKiyG7QBgbdyiR5C/DlXZWP37daWMRXMemKSYe29QQTh3zhh6UcPIIKuI
	 HHw/HyiuyA4TgFLtJAdPPZVVewhy7pK+m4SwvQEqm79kn+O9TY66XUr/vFc/9oFWL5
	 SaSIj/niptGGqazBoQT6UpPxYeuZ6hpPcbiy+1C7GYsscbWjLIuLDPrkgW/+UpJ63P
	 Ek6J6M6QVYJAg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C46FEDA15;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Mar 2026 03:09:00 +0800
Subject: [PATCH 4/8] mm/mglru: scan and count the exact number of folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260318-mglru-reclaim-v1-4-2c46f9eb0508@tencent.com>
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
In-Reply-To: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773774704; l=3146;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ky1RNKZLvXcrdMH1kH0GOekvj38YuXZMcHy4rmbDVXw=;
 b=553cnEXzCmztoDDKU1GnFdlSR+/vyXytKxAb9StLKpS6UvhbV0dykEwBCqNffnCFJo5+JaTEK
 2Ihc40Wy2N/BFNiKqlIvvQgFHbhIaFzs+7QgAGC09dLP7kT7vmNdIM1
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 1o83pup3ajzwe7d9c4my8tgzbmz6yc5o
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E165140002
X-Rspamd-Server: rspam12
X-HE-Tag: 1773774708-53918
X-HE-Meta: U2FsdGVkX192UNOPUAayJtl+O8wfbDpMId6062Ze9jxt9l/wkg1rmdMvLaDmqKx0gP0A3jzNMbsxTtuq2qvfMrn5ey+S/rw5KuOeC7jpVnMMzRC3i2MZPnVmivoq36lsvE3NnR22ul1qqzN6Ilfe8wGavqtPz1lkJecX/SOqXN10MBili7ucW3LyAeu79q2vEiF/NeNcWNIf/6bQf1/NVmyrn9mhsrWUY68glzwUSIeE/1ehE3x1+sn2es+G2tRUqRugxqcDawN1rJcptU65O2+grLVsgkKtlBX8yaXKNmqU5S/Hfz/iw3SKjx7JrePuob9eXjsVBRpBxa8RRS6CGLsoTdbFbZGu0iFwC39PyZOD41d9GNqTgPYsuux/KRFn6hAsQpDqG7/7HmHOo4Yw5z9A3GXnUF8phGz+e1emEowY60jQz0vV035YDJyZJIjrAxWLIaR+lwJwLDWLDiEDyRy77AgabVQockMmtz5ymyCJxqqQPOzsSVdCRrVfLzwZcl3CmnLqCRaleFv0hEegZ1R/dLRhPZk6FkrkGHhuSiOvvwv/Pc4Ag/7LdEB2Xp41koSpy23+YjzeFI2ozW9SclGTtZ/nnzd3MxpUkoV+uiI/GHp6GBKLdHY7odh4reIXszPx0DGBznRFqSW8LYun0xkxXqBeOcSLVm2ZERmf/gGJzyPXJpRY0SSpY65JMBsTLuvdAcHSIN9gC7uooK0nNKmEC3Kg5hKrlpjwWbvAzPupCi1KsrJOi9bNEyg0vS3/M1jyiugth0G8y1RfcJtqCeZO7TXvdVMOJpt9/OU72T4Kx58JTjo4g43kOJwUkv0YzCvvB+htsCNJRkYTxCgeR9lhs+MhtYkieSeYzwpri6J+YoLkugDxRz4QQbYVQ9u+fMfijIqME2BQ6n5nCh4CkIGLrjsYkIpryHXc3FbSC5nWpOXrOEiHfE24L5IlfuRpsS7bLzwr7Kmlt/FhkC2
 2LukV4pp
 B2s7A6TDDocN5hYOcYBc6ANL+fKB7HjWjTLz+a13UEKNOvAdufw/SK2TySH9HoTygqxT3/i8GFinneBKeNKsP2YU8ZsMhpUtu4/bkAKV+k7c/vQtYsea5F6AVFdRE4/NV+96vjHHhu1CPcGZluEccDkM99kbdOjRW1upknu3DpOBMVmy10WD/jeiu608gi28tFKlmP1bz6x1T6TOzkUg9/ORZY39qWcV2dMcrLLLzPWs+H9TxToocW87vutAMyhHpgoYiu5WN08wv1o11lSUqGz2aGEZh7DOo9WfR3iAsLnrQHW5vaF7f8tobcbis3jVFY21eWqwrcmyWzh6+9nATFYYx12onxo/+S/2Low0ZbW9Q3KyWvq7j7WuQejJaSxlozjWoPt+Y+1DloyQDygONtDRcMm8cjRYd7TBR6l5NntcYCdzXp3mqy4qeH+DwUWnDGX0B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Make the scan helpers return the exact number of folios being scanned
or isolated. This should make the scan more accurate and easier to
follow.

Now there is no more need for special handling when there is no
progress made. The old livelock prevention `(return isolated ||
!remaining ? scanned : 0)` is replaced by the natural scan budget
exhaustion in try_to_shrink_lruvec, and sort_folio moves ineligible
folios to newer generations.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ed5b5f8dd3c7..4f4548ff3a17 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4680,7 +4680,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
-		       struct list_head *list)
+		       struct list_head *list, int *isolatedp)
 {
 	int i;
 	int gen;
@@ -4750,11 +4750,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 	if (type == LRU_GEN_FILE)
 		sc->nr.file_taken += isolated;
-	/*
-	 * There might not be eligible folios due to reclaim_idx. Check the
-	 * remaining to prevent livelock if it's not making progress.
-	 */
-	return isolated || !remaining ? scanned : 0;
+
+	*isolatedp = isolated;
+	return scanned;
 }
 
 static int get_tier_idx(struct lruvec *lruvec, int type)
@@ -4819,23 +4817,24 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			  int *type_scanned, struct list_head *list)
 {
 	int i;
+	int scanned = 0;
+	int isolated = 0;
 	int type = get_type_to_scan(lruvec, swappiness);
 
 	for_each_evictable_type(i, swappiness) {
-		int scanned;
 		int tier = get_tier_idx(lruvec, type);
 
 		*type_scanned = type;
 
-		scanned = scan_folios(nr_to_scan, lruvec, sc,
-				      type, tier, list);
-		if (scanned)
+		scanned += scan_folios(nr_to_scan, lruvec, sc,
+				      type, tier, list, &isolated);
+		if (isolated)
 			return scanned;
 
 		type = !type;
 	}
 
-	return 0;
+	return scanned;
 }
 
 static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
@@ -4852,7 +4851,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
 	bool skip_retry = false;
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
@@ -4860,10 +4858,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
 
-	scanned += try_to_inc_min_seq(lruvec, swappiness);
-
-	if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS > lrugen->max_seq)
-		scanned = 0;
+	try_to_inc_min_seq(lruvec, swappiness);
 
 	lruvec_unlock_irq(lruvec);
 

-- 
2.53.0



