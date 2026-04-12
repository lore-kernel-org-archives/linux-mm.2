Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BC1CE937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7BC6B00A4; Sun, 12 Apr 2026 12:48:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7855E6B00A3; Sun, 12 Apr 2026 12:48:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D756B00A2; Sun, 12 Apr 2026 12:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 34E576B00A0
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:48:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D48248CD9D
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:24 +0000 (UTC)
X-FDA: 84650486928.06.8E17D7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id E32E2A0013
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bOBPZ5ei;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776012503;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LX/52LmhMpWUzCucp+PyepOJnAiORE/cUrRJb0ear08=;
	b=5MnDfzpAKlVYvEt6V5uYKGxNUQkwU5o6JSLQCPQ8b1z6zdwVqRcuc5sQ0Wqa3/5zCUXr1E
	1pjYvQycm/P964TUG3L42L4v7lgT9ghYGg6UdIJn4n34eokxidFca3WviPBXDu3h6fNfK5
	7UkkZr2nBSFOObIiebH+ZQy8SiwiPaY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bOBPZ5ei;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776012503; a=rsa-sha256;
	cv=none;
	b=plEqr5XoY+BM7FgYxK3V8HH75ikVYbtvahWiAyUd62Xj8YaocQJJedDqtz4a1Q3aYZYKC8
	zIwZWiVIAoMx2VOZvd6fAzQw2/IiAGS1S5T0C1/5r6vqFRpjiWp4blSNkMEpXmfMCbpjry
	SHQ3KJdmJtD3NwInZ0enx6APut3cQi8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B777661420;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CCA0C4AF49;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776012500;
	bh=oMG2Sjwb6KCG3/s/9b3veVJyt69C5GCtWepaQjtL4LI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bOBPZ5eiErAwt5FUnn4PIijnFS8H1jEaVxMiFOqAudqfYDHKSY7dFnfaQ2XlItlG1
	 uPL4A5s4ZY3D5y6TLe+yWZiAw6/35oQ+K72WVtIqmAII9gpt2KaRzwv9Awf2Acc3hP
	 9yr3aOFbkhsVFq3SvB/BDL6+oy2cxYX/Y72o36zgVwbTCNyOotimrHUV3aS2g8C+M1
	 GgQ/rF2JjxybE3R+Po0kdQW+0XwFWirPKuBvi/afoqSmgSbsnkw+AiUXW+0pQELG1n
	 Zk71pFqKoEeJtcBRDOxCuHPPupy7vw0n2o6vgRm89EFmkREpTt2w4c58qqoQaNLI1w
	 mD4N6sO4YcE6Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554C6E937EE;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 13 Apr 2026 00:48:25 +0800
Subject: [PATCH v5 11/14] mm/mglru: remove no longer used reclaim argument
 for folio protection
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-mglru-reclaim-v5-11-8eaeacbddc44@tencent.com>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
In-Reply-To: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776012497; l=2628;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=zvjDxFYa9NuPhqbFcpkFSi1B2Cv7XMFY1pzNGB2XdZM=;
 b=Yi/e8MDjTS+iCKm9r5qxslDObbfFgyp0AiLRDbZSZSiGXOEAloq6Gp7vEtlGApoIO4/VhTwPC
 s1fQd8goCnOCIPhi92FHECGXQ3B4FKgk2nS/xHetar+XKHRzuP9ymwr
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: E32E2A0013
X-Stat-Signature: rjojkmexgdhb6ybc1ntf8h5yog3yrspe
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776012502-188096
X-HE-Meta: U2FsdGVkX1/vEhtyHxHpd0se3ItKaefYEk9+kpeX845UZkVx918dweZEBCmUAOyolUBx1SN24fdXHkEeVIcLOlkkUkefExXmy/FVwSGdFSlN2U/6lBV3v5fWOA6M4h+cAvWiayu6c3Y4Z39cySajcwteaGU9U/ZAhFHSJyF8sH5eqxJIx7CyRi2ic0H2ibVE3HpGdYyBwNrPsW59yx6cVq54gKCj4nysTiI710KXtc18iEMoeZPoP59dr6pEHmsJOdRVP2SLH9CJvzts8kAzZdsHxdKdH3ivVxByKAouly8hTwBk9HWe/EBy+irlbDe7Nj5jz7IrRLPIU2bFP4plmbuNDOV4Jv0XLjcmacLcpb45jUHuv7pTcO7UPiweh2GnLsxGAT/b0Jqb2beDzGgKkvI7U+i1LVkcp+0l7bu4aqVhGIIRf+ZpG9wmCg2tcjdmj4XOgam7QgJJIFi9pg0YpVuOI1wZO6iLuVlLICahmPetgi24VW7y8AVxpCKe36QCwJ3DYPjrWtPy3jjFlUp7m1vVwHqSjELjwW97YSJl+BWpww+wwM9vt4O7O5pbO040D25k4fL5lmYYATDCLK4e/DMqPTaQTy/MLPccpvriWniHyBjBdtc0v98joiDAX759HW5gy1xeeRQcukonGQcVAruyfZJA+kvh2aKGEUA1eLk2hS6Z6RPV5rOWqmjCEJVIHlFW1pZ4zcfZqFOa+nPW8ID6m2unbsIIxLWrCU+pcU5H9uA068+hhrktRA/L2oTNzm3MO/XKhKqxG+PIrNwMCw5cpsvgDRze0MtEGxI4nlM6fy3kYmfaDimXAi2C4ufxM+nomVRTtB4NjnmWWHBXx8bRz+VrUK80b/K1S72FM1AQ86nL19w4iEN3N/av+ehtL2psF+AnvwE5mS1Zj+nZ4N89kO8ydq6RPTkhRxI63S0/Jiy3lDEvR+RENbLFZwYtjtN3zE22laqSsQv+ZwZ
 l0WOJsvd
 0y+Z61qi/tlUAzFf66lRYX55UTCgTckuGLuBPX2NQMFLH9vegmklPfRQXDl3JllB1sYvD9O4u0rhfFt1zyqYy/T9px13lFjhE+rBRWtMHTQzrcM326tCcoNTHR9XjtIyLZh/czpcQXwt4Ul4ApTy98QtyazmjN0zkumiBddv+gjcg1ELuTYkqN3w22lh0BXpcHhFr764sTosZattaYMjsTxnrl2x7c3/tMcgmlEWXOz98jdsMLkctC/MgrGLqtCsCRvrQfi51Ot74cJvsoV8YUAZ3XQwPIeyQiw1eVWQsaotylEkKfM30fyyS7dxZPSG11E5iwd1BisMOL9jRRT5kTCL6lBiM3vBtL3yDqyWHGKKrAxCeuFCEe2eAQtDXIXKaIZ1FAMMjgY1I6836vAqtZmnp/NQDjlEynsXARxIsRerRiYsDRSUNogKVISQPq8TLXiwDsbc58yihrp+Vz5OXhWZd8g==
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
index 8072255e3d3a..3f6ba34fcd24 100644
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



