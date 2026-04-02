Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 086E2D6AAFA
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81C896B009E; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645546B009F; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422046B00A1; Thu,  2 Apr 2026 14:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E5B266B009E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:53:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A156F8C701
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:47 +0000 (UTC)
X-FDA: 84614514894.30.710EA0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8D3FFA0013
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZBSrQmqC;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775156025;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/EP5W31F4mrOpVkOViwWEDqyf93DCva2WNsQoo4+14o=;
	b=NPHCPSMzyLTCJuUJvTMQF3XucHuOZYeyNauRwOC2IYa/pcps1303WG2XsBD7whJeQtyHMv
	xPcTBJ3wB33r2RQDZ10lZvc/lLYQec1+7OA4ZbR7aYmjk5yKn79h+024UkAf3FsIxIK0dV
	1KVo8O5O93gTFxjFwyQbXPf6V1Ld/T0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZBSrQmqC;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775156025; a=rsa-sha256;
	cv=none;
	b=U/UyitExyuPpIOcXYI/XVePauFForgN5diN3hgte4m6m2BbVny0IkttGDDKo4ce5ixD9u3
	p0pEiLHmGo1Ctrjlbh1kszxkIuMXyMU2FROxP6uulEJk/JtTmBrmS+RezBZBqfu/CXRqvH
	oUzak/r2z/QHV8Kf0G6c852XeBI9dec=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EA5F8444B9;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2063C2BC9E;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775156021;
	bh=2VrNcvAFxwhtYfLD7SRMhvh+xHXxnXAiLxIFBOgX9kM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ZBSrQmqCj9MVilaJpGU5xhFHpz2NUX05pb/bCGx9CPAmui3vbKnwQWccuun9W4/Ck
	 t9uYKsabmUBHpmsy1CXKZiOXeotR/V88JdhcrrM3i3UGEcJ7RSdd8mmZzpWRjUTCPS
	 lbjHbuH1+3dm25YC/6ogvq+WLPcEv/OGaBrMQqhzHxa3oJykvE9jryelyER70XN5N2
	 6HWm7kenBoVY3TW36hZWxtRSC4uXr7sioS6ZsMDtlDtXf+HTvL/Ih6tyWcC05Sq24D
	 FafDFPZ0CDAG2bK9KRfmF8evUk/15/KJksYhbZ4CMB7wxb2NAt+UbZ3Q3+AlRLiMtS
	 LYoWnSCxci68A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B15D6AAFA;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 03 Apr 2026 02:53:35 +0800
Subject: [PATCH v3 09/14] mm/mglru: use the common routine for
 dirty/writeback reactivation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260403-mglru-reclaim-v3-9-a285efd6ff91@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775156018; l=2740;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=1fGU9ybQ5gFaLofblHVGMFlVdGupfTZeucnLqWkcozw=;
 b=qbDO5xQDJ/A3sbmqRNwdWrxQdbrMGyslVtbnU0pYRi2mPjxtxWVTHjvGTF6EiGkv24u4OlDCw
 uu28LZ4FGAoBj58CCG7sr1Q6XlUF6m9vA6Hfib0XVBDjXh20yZD0uh6
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: 9o55i4ktrj39uobmy9gcx3ym1gur87dg
X-Rspamd-Queue-Id: 8D3FFA0013
X-Rspamd-Server: rspam09
X-HE-Tag: 1775156025-466926
X-HE-Meta: U2FsdGVkX18jaHKW5BmsjZACW1AV0HVYWRVkTw8uEYPd/nEbJ5Jgx0RrYeJ+0m5MXey4Fvx1ctBcEiAlduk/SN4Fn73Om2/ZiWZKhSb8t3210oe9d9FglQfXNHDKQvtYAtV+/dJ1RbpYYzDac4tTqdxGTBoyY9diuk9stDIwxyokiA9gOIRoeEsdXY4LpbPEEQ3uY/Vh59MNfv/dUpuWgzORFba1r56MbfmP5CbhOHQbBdXZx1GboZSUaLRxzIGzQjjolsuh4NFfw/9pHrXNKsCppijTChjGHe++hOwvpRNf0oZcw1vhpnUQBZFYPT9I/4tHd4LXGHAcrORKKaxXQrOdN9mWUX/1iG++d65emPkbTUbUuMabArqVemULQI7+DoBdtrjsOPVIdRgr7Ozi9AfXLgRNqWIuwwg+HIgXdIJILopSCiy90r8wqud5tJxE3xEHOjJu23SlYy3sGKeKMDSX2TrHc7d7+vHwxZJrru6puoR2vQTPfwPzhff3Rs+kLaKY1kBZuFOCRAJa017LFdpSE0KVRPVufGeC6W3UOiSgUk6Z0Wm9w0Pe7O+MpBUJV9fpWZpA3LnJyHbuJz5i1ru98zOpIP72oJIK9zlo8eoEKxkcUMze3M3AHXhHsFa8D5G6R2t042y9HTJOOkGIjh/5/OjlVIjjE2HGVwojpNgSnkQNmWS/lkZbLlGUOpcVRYHelKUabuMu2hIEbxcP4HrqVsRq2td/r9A1gQaw8c2iL3fBoIWHEcCRnGRDpUhpRxQynctDjCQujAMh8dz8p09M5K/2TPwAimqSx4I+x+vkci8G9nI6/KjVcC2gknwbh6Dhparka11dh5NBgFWA/IeQiWtnKqOK+RKa3x9kd7H1AAiQZb1CW8FSIEjnkOx1r2xLE7FBQg2CjpUlI5CLJ/YDm/oP6CgahdriFCmPze3oKwW3MrlbjsYte5FEvcApmnsjMfv8bUo1QcXlXbM
 cyPWjN38
 8MrgnKw3cKmrrpzz5OikkLYhqBNPgml8VYVb0+yQfaPCm8izeazGuNHCGwN/Xuxy8SUuahoF+vxOXHWHt6DNaLZ/GMC4XZtbO/DVqeIj2F3Ns6JRzGUEHdRAtfxZOGS0Oa/qDPN3iNd1TlVSset4RnJoXPemd9SLh2lXr1lAk8NpNGOCeXVrF0k/4hXaTG8flXRkuw73Gtv/c5teP+ysXfZ8ZD4mkT2Y44flp21kAMkz8T80FgKBdfu7TKA3moFMpuKKDrWCu56yGntIgljkxf8ilWJjVofCgzgC2H3BHjZuPvM5ML5SOVipYfH6mX1Y1agyEoC3ec3hodNq2CcyVFHYkdmNW0ecsvUhEf5cqI0UDaLOD4qPwrFfkEgEVZdjsSOvxACpYWKWWDlB4CsZpILppVxaNXo3OUh4ldUTxRtmvlid//CnH2848HqjiZzkGPq+niJDehDkXhdbJidrTinbx+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Currently MGLRU will move the dirty writeback folios to the second
oldest gen instead of reactivate them like the classical LRU. This
might help to reduce the LRU contention as it skipped the isolation.
But as a result we will see these folios at the LRU tail more frequently
leading to inefficient reclaim.

Besides, the dirty / writeback check after isolation in
shrink_folio_list is more accurate and covers more cases. So instead,
just drop the special handling for dirty writeback, use the common
routine and re-activate it like the classical LRU.

This should in theory improve the scan efficiency. These folios will be
rotated back to LRU tail once writeback is done so there is no risk of
hotness inversion. And now each reclaim loop will have a higher
success rate. This also prepares for unifying the writeback and
throttling mechanism with classical LRU, we keep these folios far from
tail so detecting the tail batch will have a similar pattern with
classical LRU.

The micro optimization that avoids LRU contention by skipping the
isolation is gone, which should be fine. Compared to IO and writeback
cost, the isolation overhead is trivial.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9f4512a4d35f..2a36cf937061 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4578,7 +4578,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		       int tier_idx)
 {
 	bool success;
-	bool dirty, writeback;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -4628,21 +4627,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		return true;
 	}
 
-	dirty = folio_test_dirty(folio);
-	writeback = folio_test_writeback(folio);
-	if (type == LRU_GEN_FILE && dirty) {
-		sc->nr.file_taken += delta;
-		if (!writeback)
-			sc->nr.unqueued_dirty += delta;
-	}
-
-	/* waiting for writeback */
-	if (writeback || (type == LRU_GEN_FILE && dirty)) {
-		gen = folio_inc_gen(lruvec, folio, true);
-		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
-		return true;
-	}
-
 	return false;
 }
 
@@ -4664,9 +4648,6 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 	if (!folio_test_referenced(folio))
 		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
 
-	/* for shrink_folio_list() */
-	folio_clear_reclaim(folio);
-
 	success = lru_gen_del_folio(lruvec, folio, true);
 	VM_WARN_ON_ONCE_FOLIO(!success, folio);
 

-- 
2.53.0



