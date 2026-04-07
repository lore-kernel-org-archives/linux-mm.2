Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F204FEEF31
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7F0B6B009D; Tue,  7 Apr 2026 08:04:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09CE6B0096; Tue,  7 Apr 2026 08:04:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6A16B009E; Tue,  7 Apr 2026 08:04:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A16B26B0099
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:04:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6AC6613B9A4
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:57 +0000 (UTC)
X-FDA: 84631628634.29.B1E44F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8C4AD140014
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qSYuwWEu;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775563495;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ivI+vN0ZnCwhOrnx/Id2r1IMvRpeJK0zQI9YQpLoC1A=;
	b=8PEsEs5cNhECpysN3oU0JxPXX1E8BjZI/e6eZaIJp8KtBvgKkGaSB0fLUbkWgCCHmfashQ
	mLBKM5fPTcUl1lAVLU2BXx4/rhso9OoX+CE/o6cWzJ8b8xf0YcYSETQzWOzod2jJ9LyBH+
	tzZ6N44mAucoeSPBaLP+9srrfcGOcbc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qSYuwWEu;
	spf=pass (imf26.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775563495; a=rsa-sha256;
	cv=none;
	b=r22aqz73/vRvIPZNO9ujyNNZd4muaPWF/deAny0ofLwCBPrrI/hr8PNtLuoALH1DA7nY+Y
	1CU3uRo1bTl92BkujdoEiJobVSMhgvZHdgdZIimSXrCUNAuOTyfU1d3fXCZamALNhQZXBY
	j2OKNlv+P/7aJlJD2GpaJdlRZDvj8Pg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 23EB444708;
	Tue,  7 Apr 2026 12:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1337C4AF0B;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775563492;
	bh=F6RMF6i5UclqfTQm+R0d50JEibkYyOaunBwm+v5PBO8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qSYuwWEu8T9L6KJt0kJtwoX0rYQPzZHTj93FqkdkENIR9A0IZVRhA7ktU3gwosyie
	 1SsbT/3eZhdKJZAwUHVwcrUdu8MDKpZ4ZDfAtdsD9AqOPivARB+SFevznanMwy1V/3
	 WSZOOlhtI5a3lH0NkDgnwF2LuotsqFDJOfJNteYxNwAvsxtR2Md9XXu4ePF/RUXqy8
	 B1a4e7ARZAiFOHcNpjssucV61ez14BpQ9zHJ/eKfTXsD/VUpBNuf3dNH3ZWp2CSVrz
	 Tt6W2UCNgp5feis4nuHMoWB6X3/9YmS+G3FgBOJLa9X9uk+GY2tu/2e5jVBTG9uwv7
	 cF7xoHi4n52iA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E858EFEEF31;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 07 Apr 2026 19:57:40 +0800
Subject: [PATCH v4 11/14] mm/mglru: remove no longer used reclaim argument
 for folio protection
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-mglru-reclaim-v4-11-98cf3dc69519@tencent.com>
References: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
In-Reply-To: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775563488; l=2628;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ZXuz5KArlehmdQ1TdnVKon7VrJCqzZhhKUqXRpk3w3E=;
 b=dBzNBK3Po2LqYeOED4ZvnSqKMvMGSRbTy2890M4Akposl36YW6a5ZgccUHKV0AP350izc07g1
 W1hP7NNBrqRBRM/zBoK83ziCAR4nz/PP+XPiVmOZo3++PO/iBL2F+z7
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8C4AD140014
X-Stat-Signature: 1m1ue1h4mcohg81n9kdh6wqwirpxac4h
X-Rspam-User: 
X-HE-Tag: 1775563495-968779
X-HE-Meta: U2FsdGVkX19Uf9iRucLKef740EqNr96kdeLecnJSzFp2/ARHToADLNt91xM3TI1FZAB7yOJTQrsnTXd4l6dzbND07VmgqjtJ8MdoIdbNccro2gIo1r6fkY8P9pGQvKNLEvTvfmYfTv69M36cKLLtI4SFGMhRYWYQEdXI0Rm1sF/eJ/UFsDZMP8QQkalLHtt9+5XcISfQhYKWrzYy78aZszs0fG93zKrYaIa+FAEL2JjXYb3uKLbKkHeztBQhvqLW79tTSJyJc3maVWORM8KqgOtUlhUuWLn73zR0N6cF8tox2/BxWrOCVpRKZ4YL/JqqSgVhEhU5JDnfL6URf050jklvHqAk/ZN1u8NKUOMlqLb4VlMahoXvnjD+K2HFBKEjqbKL4nO8EIttX8LUU4nr2Nhtw++lYNLn74fjuNkTzYu3RkxPj8eHFl97pCmGTarnP/ooGj4RnejQbg9BqbdYjhjQiL9VNBGX/GSyk+poL0U1OIEr6JKmMXySV7t/k0SUq6Q/Jsfxi+x4WTL/WsYepGZNDsNNC3fAnI3G7pFvBhJbYmlqHR51s3YqiAcWQ+XStLdUqVqfYJ/FPhMLvGrAzLN5vLms7JQaSYrtVesXO19DEgQ3lPtzZHM9b+EAO3AEPm315JpAcxb6MaWE/9Dnz7VxmkCDeGsTgCA/wWDpcE8ZMGvnsgWMIEceVPcxrK/I1Buvg7QPODzx4dDIr2PAAehpEdk8wExLLcEdlxzMPOd5Ne76toFPbFIZ8xlWcmcqYO965cSfM55+kB0OtpUp7RG5U57dmQ7ec9FEq3mt3+b3QF2yDTy2C5ArG8BHqjoaklkZ7Gofaf2Vk+pdWmi73MiMP2lV3HzVnrdMI8hNyd6DpLi84tCzWQB8Qomtao1mX6tFXWwQyfu4bhwYFx0MdZMsBuFWFS9oAsGL+HBJyTDXnrptVZcRgAwUcQNTkTItQfF5bIe/k2pPQPSu6vM
 2AWbJU4c
 IVuLN3dRO6yhYN4hFItsS9KPB/Pdllzo+nGln7PfY7cLs8dywf/0xMuQyb30gWyEY/k87dru86CrWrfBkhsFZA28vKplZecW0tyYKdykl1yNFUfzm6tNyF7phYg==
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

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 23ec74d3bf6a..73b1aeb6c292 100644
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



