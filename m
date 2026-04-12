Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1E0BE937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D79CF6B0099; Sun, 12 Apr 2026 12:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03086B009F; Sun, 12 Apr 2026 12:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF3016B00A0; Sun, 12 Apr 2026 12:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9522B6B009F
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:48:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64AA1160B9F
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:24 +0000 (UTC)
X-FDA: 84650486928.09.AD23C05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5B28F40002
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WuR1xmq6;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WuR1xmq6;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776012502; a=rsa-sha256;
	cv=none;
	b=RLR04PeLZr7z7etIvcqT4wwNdeD7FOIBJSSQSCeTBGJvq+W259ErscdehsBiOU+8wBSrw6
	Yba6Nto9OeYV0CoNRXt8Um7cT6vSuLzcx9gTd0pGLa5HB+rGzzSSrZA23fXlVpNbtIP6Dj
	XyixQHpO5YHfpnNlW8o9BRluAmPriOs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776012502;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=odKZ+5pg/Rroupu3xpAeBiHKuJo6sz4ziDly9UlZHtM=;
	b=gpIp5CokbWnDo4UaHVqxzgWD8FGwXsMtVRj8Jw/G2iVIwPNUg8PdD3/Rhdyg7OK48iZyP5
	mXcCWueWuYEkGJCUcR4IXWdYb8aHv5RQlwCnMgZHSqHH0MqFI5hyV/KHRzV6hHuH1kaV6W
	kqeCkqRKIop4R6HRUJ3SPpKosaHf/Vs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DBB7446A8;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B81EC4AF18;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776012500;
	bh=3RE8cIiuwEqnweS2KmT3lOO/ndLGSLdeBknMMEpJdGU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WuR1xmq69ig1SziU0qHbhRF88CtGLsmJdyPEC7m4dEPXIS0/Lkwfmx7fL+aMqhehV
	 o4kRNCFs1CtNx4Vo1HjbMXignQt+p7WAjGTkcDEiT4JEh3uqEvjjVHoYuRco1sZA6l
	 PE2yK4IgsOz5GJSrNuXwHUBHzfUQFi67dzGzf5Hcj/mAv0M+CiP7XKaP6sOY+cK81s
	 kdrw3lBTFkSMIywfMfNjDNQtTKXNfJCC+i+Z4Vz45f9VE611A83rjeduiAZgQ1mZ7q
	 Fh7rJJG5htuOGHHF9Xyek+p6jGjHmZsIR1h8Dpn64+hYjWioPTlkbZR4T7+6EvMN5q
	 vTG0KEZzcwI4w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332A5E937F6;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 13 Apr 2026 00:48:23 +0800
Subject: [PATCH v5 09/14] mm/mglru: use the common routine for
 dirty/writeback reactivation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-mglru-reclaim-v5-9-8eaeacbddc44@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776012497; l=3145;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=/X4tLveOy+BYFW/Zy6+R0vMXPcNqV+3IgOLhWgyGVaY=;
 b=O73Zv+vYMZOn0sSZ+5JRY/iW+5z8qjEomyZSYRa7iYd8d7HTuSFm3QlJFJHOQUPFzgVCGADc0
 z3J0NZSLEgLA93OaJZwauHtgqcKd97qysgKlk/iHPlY2ttyQqx8TKZE
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5B28F40002
X-Stat-Signature: mopgxi8u1rg9nadt9bgca7w86kadr9yb
X-Rspam-User: 
X-HE-Tag: 1776012502-594817
X-HE-Meta: U2FsdGVkX1+50xEaCmci9EuFgfuHcsx1XAX1mTylhMlgBSSeN91ArNWn2KL+qVcdWEUhx7v365pjDcQsaGy1spo1zQnmGUVaDdpwdMZBPFSWaZaYwLJe6wf7zEuotUM8JfM8+51JfUZjbj2ZEnXHRpBUNVkytp9M9SpdvWukAITDFZq+OsDA5HKPGba+9nyGARTnvRl5ieY46nRdABbYg3QI7Z1r7554SBAd9wsaUzVqZpl5dslsFZ4cGJS8LNQEP/1Uz5Ha7mRbg4IrRgNCrgeby+knFrh91DZQQYwSavskglj1TJjCFKG608Ffw96uKvIs8tuvpKqYSr7gQ9/EVX91MDvkuXLCaRctg78YCaljey10h8mZpVIwBMNuFEoHdauBLgzd9h/IBO+hVmIFn+YSdxCKq/LvxTD9ulXh+ItwHFnca4haVsiVbb+9Jncm9ZgmotoO0OavdIF9JYvN7Gi0vJh1+TWRZRVFc25pv1YRhsmyovZ4OPYWv17wnmjACCpIgPtdiT3QMlSOfg1sHrqO/CDryvu2coMcw58AesWd/jbwevsplA7g5iMV97BnfO3pyesbjf+AqnD1BeTi7ZTtXC/RrtmVxtGz+HxxAYxGOe4gGBAH067rA/JEC2fkGgZ3Pv1k3wxIaugJeL9XixlaZJNCaO6WkqDFnWpXgHNl7Iv6EvizL8v/E40dJHSvN//ONCdHt+aojSOphNPyNEGCF0hJjLT4MxNLZQ6SuqIW+Z/Uu5ZBBq1oQWVSnxcHzd7j1CNr7qQ4Mm2PIvXN3uqz2JLOcZsaX2WnrboO84eg+K6ABciZmomSn38hpBHaUBvsz2kmtGz1JUznANrMHN1gw3WLLEkQR2TgOeQAe3mN7ExAeIqj2DYypma9ByEWWDzCAteclks1YZ9YPTrc2wVveHmxAmE8t1ywYNhIqaNaBJSn4I6QjrRixRC7zX+/lRZMa4SzosDwJKrKUmI
 iPNM0ZNL
 EwWcafKOJfLeA8ZccIf730yAOdIc2AYS2MXLq8EcgeC3PXubELPM774UgLqzEwmxxPboD7eR1ZUfAWu88kAEAxx1+nGhIcMEYdTQx6leclW1Z05geFU3u9HCF+KXCEere8pLI1BUgWfXnXNgNFQfL9MuwpBUKriRGEwY3WJbq6bmvJWLmkdkb+7dqdVIMN6G3Brydboen5SfkYafnr3SouQFMO/8Lyt5oi49rACUCNDrrYwOzNK93ixKBFPpKxNAdGJSNBcF1AGQVhAo4HkweaxT6ylTnrDkj5Gm8ivbBNk4NM3LH9sKlFtdAMYscoghaTf9LVPGzUhYBytwLb6CfeUxF/P3PMeX8TOD0coupYzdxFN4LWPV794TBZz5me6PpNWu6VRD9VOg7AWQcQWaRmO1PQmPqdPP8jRsu07rXZrVJahIKzXxTIJdzRFOksZ5IxfrW8206HlAxFlYqVSY0Ry5NOw==
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

And using the common routine also keeps the folio's referenced bits
(tier bits), which could improve metrics in the long term. Also no
more need to clean reclaim bit as the common routine will make use
of it.

Note the common routine updates a few throttling and writeback counters,
which are not used, and never have been for the MGLRU case. We will
start making use of these in later commits.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 965d8905a4fe..d63ac03a7266 100644
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



