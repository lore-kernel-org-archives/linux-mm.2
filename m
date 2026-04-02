Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 005EBD6AAF9
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 646C66B00A2; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D0196B0099; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3384D6B0099; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E47CE6B0093
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:53:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A3204E1B88
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:47 +0000 (UTC)
X-FDA: 84614514894.02.512A43D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9E714140017
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hz+HC1bQ;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hz+HC1bQ;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775156025; a=rsa-sha256;
	cv=none;
	b=gxWxq817igquWiC5r4ZH2PM/qepjmX/NNl1xWhvkaPOiMF+Ht+gqBgqaP3cVSd6GICDwrz
	Uny3Atc4W7opehBqXouZk/7ZNR82Y3PTbdcuQadz1iCYZCfwsSVpn9+Gej4uEYsMf8byk9
	pjU7saqWwMye21jFtfsRyOgkJ+6EAas=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775156025;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5c/74IJhlDvSqkNnWoYfcqxBaFtkJGnfwtypLgjbIUw=;
	b=iCJ4zTpMzmxOeAQeQfq9/7g6ssk6aKSmtPpSBtO9o4H2vT10yyU2WQrLVydvSExx62RpLW
	GkGFZV3XlRhZaSHn1hkWFNY6FMCBWxJ2yh1sRzjs/+/G6dzqAbJUPyk5OAeEi0us9cnr9r
	hmmv1tRU3hnhsiOIUNpHVFZCny99TPo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 17C6E4433A;
	Thu,  2 Apr 2026 18:53:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ECBC7C2BCC4;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775156022;
	bh=5XP6DMQU/MpEX364Bg4dBKO713N/bgpO63sM9BowO0U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hz+HC1bQbjq3hI5JI2d5IWDVzdP3I8AicHwjsiW/oSn+x4t51HCiWEHFHZ/CxdooZ
	 oABD6vYcIy0y4opXyJb1kURDmdAZz+9OeNuQcaqaLt9mZS66kel9BjHV24Dvk47KwA
	 NjeKqDxrG9gJxboAKh3YJWJP99HqFPHA2GKjUFTWiHJ6M9EI104WAzsMWG8HkvZsSj
	 m3vmWh5A13h25HVV8ZXISjDbTh9S5qoY7OWtTWpSNP6rerUHIfuRBE/tY6up3eW962
	 gmznp+fjDaU/UYrJRwAeCyNtMgqZHLyKYzvzfzHTj1kJJdb3/TgBXtNQ3LtBIb7G7l
	 /eB69nw7pcZLA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB6B3D6AAFC;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 03 Apr 2026 02:53:37 +0800
Subject: [PATCH v3 11/14] mm/mglru: remove no longer used reclaim argument
 for folio protection
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260403-mglru-reclaim-v3-11-a285efd6ff91@tencent.com>
References: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
In-Reply-To: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
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
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775156018; l=2572;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=KgV7etFzeAnK6AqSihOWX2NgT4FyFpQCpbEP9PRCiOs=;
 b=DukibqSLKidGFP97yV+KQCxS/VA0dvzM+NjLCJRdKi/iBntY+1hZKF6J+THVGASBUqV8cFwac
 vDWTFxah41uDkvnA+B87GXmGhkfRcaBulSvWxk7btOTPJmzyLNM3iHj
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9E714140017
X-Stat-Signature: fgqwo5pd51867waq4cwrgigjjh1ticjr
X-Rspam-User: 
X-HE-Tag: 1775156025-147984
X-HE-Meta: U2FsdGVkX18Mf51o87Wbl5MMeIzQpSD7onBZJ4GU4K2KabZg8NVW1WCPq/T5ELyRk59EDcrtTCr47lM3GoiyPokILwNqwSwpoZ/5a7zCm5YmkCQ94469d0HIMkHpFFpcbCJj7Y9nGMDfLsuMpyJIFEzSC8kj8S99uIdKFP8CM8Z4ePh8BzlaT2FkCJa/BsN9DqEs1ENEhSLH8dXr7ArtyYhq33HDmvN3J2hOQXteImzOtrJehtx7GiO6j/62zi3eRIsSJxszfx8N5XU430+/hbr2nJU99FkxPdIagy5Zw7gUnvz9gYB86GDu4/MZ0DjElZMS9B5dcgCMLXwhn757ig4RgpfZR88AUsHK2g6jajN6x1s3vrynkC/mB58lLxOtQeH8Hvcq//hmoNPLjXXbZXwEnmX4rhlBH8H5sChU47Otvb3cTDvHUCDUc5Hk0i5m5LAr1Dla3tWNOpbwLXeIO9i/WAneM6VkRBFXwddX9YQJ13X38ug9T6kHoVCoTlCkVPjOc4V9A5J87LrwT2uBNaRksCQaiHv/orxKiUvnR3Od+28PfTDkup04pwYUazSLMfxREawc6YVvK4KGV2efqxo3dhKWkRTu80FA2MOUxs8wTIrbnPal+qdss9VrKZKXOlRPRaApSXfPQ19rnn/00pS3P9qxGss1qA1vBY67gyzBHsWIpKaRYOLECuGSf80kUHQusIrsyz6JF/EsEQCqv60mdV/m5/Uk7jn9DmWEGHcvQt/zkaN9BtTBYCokJ7EpU0U14pZIdQRygNjqmsLwC8Mg6LlMsJhMsLeNA5ErF7WtFDhACu/hBDKM9+sxBwhner+3i3JAE4Ci/OfnfeMhOOtcUTu2GyrnUdpRboAvxPwGhehV/qocBI+CpT0pIIXl3PTuXWVWBywNaJk9aeGATCaa16Or43XQqg6i8/fh+V88q7jvaJmvlwDvtFRgMehvI5yuIivAA1Qq9y25j7C
 2qQVD6Cw
 39JGKpsvgQf2K60QelegNZuAbDJUfpCG0NC2XScOHpRd7AsXwDTyqwOJts7uq565lgD4U1HfEzTEAFLbhCFAnKZorQc6Y8Z/0RQ4C6oBkZu5QOUDUfShRkwzC/qvuZkt9sRl0XnaunZa1o+vqTmJY9esSOGKCNTYlhE7GEHvFLCFpnBJ+GaoplVldbfXurok6EhDOTUwfhQcMkShdyPpnAymOhRg9/h0cvONTovOuuXEly8YJiHchgedU2BCfmjd1gZUH6qTG2EPlxfdUkA1ynfyh5z8k5zO5IlzaRNc8zQVc064zLE15r0X9/ML/nCoDZPNBQWFhY8Ga1PGkSLCssw5xVpHev9zghVDqlMRzF7V9YUzeAuKiwIxWGcMDweib76r6Vw9r00LZqRzK92bLQllg+iW8GGX+ylji9sJDrszcXfsuoVQkP4mc+WnoFVrzTfZt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now dirty reclaim folios are handled after isolation, not before,
since dirty reactivation must take the folio off LRU first, and that
helps to unify the dirty handling logic.

So this argument is no longer needed. Just remove it.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bd2bf45826de..9bd0a3b94855 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3220,7 +3220,7 @@ static int folio_update_gen(struct folio *folio, int gen)
 }
 
 /* protect pages accessed multiple times through file descriptors */
-static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 {
 	int type = folio_is_file_lru(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -3239,9 +3239,6 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, bool reclai
 
 		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
 		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
-		/* for folio_end_writeback() */
-		if (reclaiming)
-			new_flags |= BIT(PG_reclaim);
 	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
 
 	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
@@ -3855,7 +3852,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
-			new_gen = folio_inc_gen(lruvec, folio, false);
+			new_gen = folio_inc_gen(lruvec, folio);
 			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
 
 			/* don't count the workingset being lazily promoted */
@@ -4607,7 +4604,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 
 	/* protected */
 	if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
-		gen = folio_inc_gen(lruvec, folio, false);
+		gen = folio_inc_gen(lruvec, folio);
 		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
 
 		/* don't count the workingset being lazily promoted */
@@ -4622,7 +4619,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 
 	/* ineligible */
 	if (zone > sc->reclaim_idx) {
-		gen = folio_inc_gen(lruvec, folio, false);
+		gen = folio_inc_gen(lruvec, folio);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
 	}

-- 
2.53.0



