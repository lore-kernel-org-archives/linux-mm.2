Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30C4C10F3DF9
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7CE46B009F; Sat, 28 Mar 2026 15:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB5596B00A3; Sat, 28 Mar 2026 15:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E546B00A1; Sat, 28 Mar 2026 15:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B45426B009F
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:52:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D3371B7100
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:37 +0000 (UTC)
X-FDA: 84596519154.08.D81320B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 886A540005
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:52:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YS40uPFA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774727555; a=rsa-sha256;
	cv=none;
	b=7Ql2StrT43nWP8XWmny7H7DoNUhCUbOozF/wkTCSjiW7RFPNJ4c8fI1XqSHzxFWV828EtG
	TfOmAFaozWQA602TBhcwgOv/Dw/yRWhNy0n2foiPt87g/uQpOUNXS/VH/oLp4kqk5XWjxg
	vS+ZtAjSHTOdwxmpe47L6BIGinW9HnA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YS40uPFA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774727555;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+DG+4ZGZPMd9gT3f9DYhNSwSiBQwhKVXgbXvRjhCA68=;
	b=5tu3cDbqTL12HPPDMI28eas6I83WIPhPQy8qrXj2htjT0YJSeC2IAffeHyqax6eBX+wjAu
	YMBSLqHblbmmipBcnMQLI4hnHaekEuHOStJDLR6Oj3Fr+uJ7c994IxWnJZdYXGjewjXImT
	zsLcmHqwUitX9Ylr087UantCBfIzXK4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E0013445BF;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD3C3C2BCB0;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774727551;
	bh=IwhdDUeDoXiHUP+X3n17xP8ze8d44nHV7UUvvAvMpxw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YS40uPFAU79qQQ9M5w9pAuFc3tpBNWYbUrmd0tg3GBQ3NImITQ6FBUd6ImKngQemS
	 7fwCvgWYzt2F/DrpDf9NyVttbDzQNQTZQ1jGv0N5PgKRb+VfqXgh7ujHddHYsopDRy
	 k4x5x5YVMqoRnEJs+MF77VCX0TZvX/RXyv+DgxKu+GIpo3kV/VEr8Ee8frev9yunbP
	 SuaTHVLavhLJ8nM6gBjRxZY7M32asDC31NQEv/LrlZgbYQdfG2p97Yu3QzSTXUZK4m
	 M5gmIPCYg58/hHUt5nWyAJu1lrMuti0recoz7OqWFfsPiPgbWFbjIs18Mt0WYEzYBu
	 yfYCUTb1/GMoQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B430710F3DFC;
	Sat, 28 Mar 2026 19:52:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 29 Mar 2026 03:52:35 +0800
Subject: [PATCH v2 09/12] mm/mglru: remove no longer used reclaim argument
 for folio protection
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260329-mglru-reclaim-v2-9-b53a3678513c@tencent.com>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
In-Reply-To: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
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
X-Mailer: b4 0.15.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774727549; l=2572;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=VpUQiKqa6L0u8xULiUTRcyn/TqUWANh3/7f3AE47AkY=;
 b=q400/17aQbvl8jZf/Gp51sktJ8SQrx2dNyisncTbri1+ECcL8rZw34QRp/+UkWaPL+IjLN9m/
 nRgqEbu1/AODiG24HJLF2jv8ZoR50YVLzSb2nYc8GGGtkgQVhCb7vMF
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 886A540005
X-Stat-Signature: ep1r9pb36jt915it3cirt667gbg8r9qf
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774727555-529651
X-HE-Meta: U2FsdGVkX18hPlF99PerxM9CvUVnqEvmE5pPWqnSIWa69qTJ6ztVrjui10rdcSBPjGTJj5qqQLqu/Dhmj+P/Vxef4dQ/3LJxRRamAoLKe15iGporPWMbxYuvqbPMRnIVd9l3CbHb9cYejNyXJukARaAm0ihlcCzwo/VMZnZvf9utX3nguUHnQw4z4r6GL4KYZLjW5bOTF2Gm84Qk/JvBp+57MYgjk7epxZc+p7bn53GiW2qSQCZ6G3YrRenSr6/zGiP9sXjV777/YFh94JREjish+2+bX5KnrJ51p3Se92+45J9KsR0A6s29zHQ8Um1cF4qMdsqafJeqT5g/DsU41ZIsOO3OLcTSofrYDwUPVi7GrSTbquR69/uSOSHGcAaVQRBy8FCNorF7CdZz5ns81MwWG4qc68/d0iySQijRHV5I4NORbfUti/MmhHY3YClIFu35iZ+31PWcYs8H10xJA1ADPhbaQ3yzsyDiPwafEN0GdyC9gPVA/9Nxp6fEiYPoTk+Pza+p3+ysZUQTlh5f3A4FXixuQ07E0ImDLLrWm47i8GqWtfQ8z/YZ++wB1mxjPE0NhsbvvsnBG7g0KRlPGqS1cCDE6Fo+PlWc8YxuwoGR173c19SaNuy46K/NfM1DB0svaVItq/Xi6QuERzfj53nnBrfnpa54SGIYdsgqF6cgSJaLoCakSx5heRXummnPSzSgVK/MP55pnpjVNj9yySZwzJ60mY2DyMg6eiq8vl7M2sMcMGBWau6jSLOddNAAihF7OMHZztclMV+F28tW0qbuBphOat1kFo+3W+CYfwBNbXhPRYgzn6qoqncNZM7mnMv6btqoeiDrQZYsK07CJHy8eP22C4fWLM6kKVhkRi8rZGSsvo7iXvA70g4USi7y3Y/E3UJ3BNtKroPa59LL4b7GZbEppNcbBVpoCsuoM5ApZxv/UT6S6/g3w8Kv1FqexFi5wd3LALIevjXyl41
 OqV0dzyp
 agZdbzyuqw67TpICzvr/YDr+O7XTx528lRp8rmu7I12r+W7CUK0EQ3wgol7DYkLm8gxiYksL/toGHxhrZKCYbEmJmz/IZIsRurn9AY0BClH2tSdVv8Fu1Qtgiyg==
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
index 17b5318fad39..07667649c5e2 100644
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
@@ -4612,7 +4609,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 
 	/* protected */
 	if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
-		gen = folio_inc_gen(lruvec, folio, false);
+		gen = folio_inc_gen(lruvec, folio);
 		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
 
 		/* don't count the workingset being lazily promoted */
@@ -4627,7 +4624,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 
 	/* ineligible */
 	if (zone > sc->reclaim_idx) {
-		gen = folio_inc_gen(lruvec, folio, false);
+		gen = folio_inc_gen(lruvec, folio);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
 	}

-- 
2.53.0



