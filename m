Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1A23C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1718F6B0124; Mon, 13 Jul 2026 13:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CFBF6B012F; Mon, 13 Jul 2026 13:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8E8E6B012F; Mon, 13 Jul 2026 13:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C21596B0128
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:27:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 572F6C1354
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:27:00 +0000 (UTC)
X-FDA: 84984433800.09.6B3B031
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5984D18000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tEkHnUhI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783963618;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4PRK+ekKkXAOtydF9vDDs9o484xRaHnYHgSRPETVsu0=;
	b=JzLaWtLSKSvJqyWkmNfLvjnBouvFpYYKsoPOp+UQgoUaAbw7EkMpP9b8dlc0rr5iMWeqLE
	qRCSzsFD6wLqfwmX2+490RJC2u+76RkpU8f9mkbnuewyIql67sx9A1j44oIvMTg5eKOtim
	GJ3n5xPK7c91m9I+V2VYrsJ+98BjbD8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tEkHnUhI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783963618;
	b=NbJDBvijqXABAm21r257T8GUrketcmJJ4CM3tyB6lt46Vib6cUyWD2sxRHWbn9qMD39HP2
	mGf6OnkH7TzeIgCgvlPFp3b1QCBY41DFQMmD2Rbqv4rOv1KrtBbfLwC0fFNMVB00TI0PMj
	8zSfSx8AlkgfaLrsgtnLUHZhxZi55/E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C5E343B10;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81C59C4AF09;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783963615;
	bh=imwRiWt5m5R7pwZ7Gp6Llq5cU3KdGzhsaV9q2p7GNmY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tEkHnUhIbvAqRe8IC3N3VKzN3NZYa2UnvhLXYC3QLJFr2oweNy2GRbtYjh7sEgmGN
	 iNIgVdfj7QqPxUe3A5Ey1/dMGG15pfyY3ILduLKLok0TeNQMGC/GA/Eux45JgJGTs/
	 rXVPjSgWX3LV5uTGob4tjnHpm3oZeZ7HfumB5yqoGXLpZ2TBAIw0QL9CmvTjhIUcvW
	 JDeL64k1R4I5xRuT+Ao48y1d4See2fzP3fGE04d4H6XU5A9LrpUofpeSIDQTr+Hwv4
	 YsfhESe1gYKr61/+OnITZ8fMyMvP7BETaIPOUsmlE6XfDgFdl5r+F8uYfwmNwM3RI6
	 FS24jW/dDTgsw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F438C44509;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 14 Jul 2026 01:25:51 +0800
Subject: [PATCH RFC 13/13] lib/plist.c: remove requeue function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-swap-pcp-priq-v1-13-de9b164ed419@tencent.com>
References: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
In-Reply-To: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783963612; l=3268;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=NQdvrWdzsSXKqo+q0HqE4Pla3VWVnV+ggTUFkX8wpiM=;
 b=Q6n5nBBbacEZZaL44/dX2mVEo+/4JgkdSEvicdYtCsgzhi3cAz+ZlaWpQtluSBlt4/xYyJppn
 kYO1kKTDiQ1DVKThhAovUCKTD+EMCA5mtDvuvk8OKV05/Bre0E5ub07
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5984D18000A
X-Stat-Signature: xhr136tkwp7tw9gydsp71j49yjunzsrf
X-Rspam-User: 
X-HE-Tag: 1783963618-178952
X-HE-Meta: U2FsdGVkX18P4GyyK3LH2BZpVBHIJKSOgyzq9WuI3pCJNlqqzpOQJhfoapuSK5O17zHjdcgFkTfBlnZwNvisMvPyyAMDM1TMNz998KypbPvl4PcL+qPUM2I9UEFXYrrs++y15yw0oyB/1P7T9KiLtFNHjkRht14fxYu+JB7EqtBfz6k9NstQL/v84ZL6mNTD9w+lU/q1Inb/UIXi1pSFaLIvysEKmeVClaPQFAbb+cg5rsvGMBqz7VlP8y2Wtg2yKqz5qQCiMhato2Vg3nCCt8LoLBapWiBo2O5bLYx2WO8NjkEWja2BffJ6yGpvFZ1OkBFJmJmrJ2luQY/U12t8USRR++UMilJ6QwvjSjZ7L73aoaea9DFMoilsY4A1W0G4r46zXFL0KHTXDmNdiOSmun/jRrFNUv6SpLUuOWTQqsBQVvk2YzDkZu+Q18z2VVz/3eSAmEcM9WX/xgAOaTJ11LGrGhFfd99q3yyip/v9XTXi9XohnP2Qr05QcXQT5C3XIu7NyGxrWBtCKJF+frbyg3jLgC+ehFDSv4ACCDSyUp3lnBvRnrihSMaGU0evL95dhB5hLpBOVIaGTodz5ijLzK8C/nwox6btDLL8x9G8amjEzfZU/RRvgK4dPrk+MAWc/5GJTQr8IZlvp4b45R8ChzEX85zE9RxckcchujahHD1N6V0YmM/QQ1xOEBryIZyyxuzky6Cl6mdJ+s6BS9xus/waFIcBD9EfHMbh2FsNFIZ3EiJj5i4qCj1h5H65AqZWnUVByIa6IM56ILoaKXswgK6FiwUkTCagCEaVaGJFzznCAnW6bPa0Qz2GareVBscz3BT5GajObkiUWVYnqenUGE+OLNb9jEeq8SWTOTyAi5/jvcjBFnopIgoHyx6XxTg33MGukt5jWrDkJm6yEq7foJmkXDdE4uQCholPucJxu0OF50ZcNzOyRw5C2b9uirFS0pg9gUzxpJAaV0ZcNzb
 YnunrPta
 hx4hRuKnntiKiWUh+qhmncTN6+RXrAdWwA2b5ysEYq95KR8NHcix8Qvzdei88kw1GfHi+eMPsoYODGPAbP6a5bH4meTiivh8flsoF1sb3uoVZEvXzKGO5z4NqvROST2xRFEU8c6f58IT8RcI4SXNN6GN4viupKn1sqPooL0KFCdEXoZ+i1nwa2DWd+ST/wN5wvFjIKFrhLOyVxAXfJg/9rDoZEkDm53gAwC/Iv2W4eHpYAMPTp6vys3bZPFA7qaaJnnVkXt2RNQJnenlKR+7xAuHkli7dHCoZDvuF8IN1R25rXDaMxNdDy8YFWKFwTMTbhAYdumKz2mmv2vsyO52pHc0PzNrwrOOOfiJGaekZ2pWkepNH5MBgzsrgNxsmk1D5NoX3hIPX3Eyoh8bDaDBn2Rg/dQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now the last user of plist requeue is gone, this function can be
removed.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/plist.h |  2 --
 lib/plist.c           | 64 ---------------------------------------------------
 2 files changed, 66 deletions(-)

diff --git a/include/linux/plist.h b/include/linux/plist.h
index 16cf4355b5c1..73d359c1a053 100644
--- a/include/linux/plist.h
+++ b/include/linux/plist.h
@@ -132,8 +132,6 @@ static inline void plist_node_init(struct plist_node *node, int prio)
 extern void plist_add(struct plist_node *node, struct plist_head *head);
 extern void plist_del(struct plist_node *node, struct plist_head *head);
 
-extern void plist_requeue(struct plist_node *node, struct plist_head *head);
-
 /**
  * plist_for_each - iterate over the plist
  * @pos:	the type * to use as a loop counter
diff --git a/lib/plist.c b/lib/plist.c
index a5bef38add43..b05ae7ffea87 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -142,58 +142,6 @@ void plist_del(struct plist_node *node, struct plist_head *head)
 	plist_check_head(head);
 }
 
-/**
- * plist_requeue - Requeue @node at end of same-prio entries.
- *
- * This is essentially an optimized plist_del() followed by
- * plist_add().  It moves an entry already in the plist to
- * after any other same-priority entries.
- *
- * @node:	&struct plist_node pointer - entry to be moved
- * @head:	&struct plist_head pointer - list head
- */
-void plist_requeue(struct plist_node *node, struct plist_head *head)
-{
-	struct plist_node *iter;
-	struct list_head *node_next = &head->node_list;
-
-	plist_check_head(head);
-	BUG_ON(plist_head_empty(head));
-	BUG_ON(plist_node_empty(node));
-
-	if (node == plist_last(head))
-		return;
-
-	iter = plist_next(node);
-
-	if (node->prio != iter->prio)
-		return;
-
-	plist_del(node, head);
-
-	/*
-	 * After plist_del(), iter is the replacement of the node.  If the node
-	 * was on prio_list, take shortcut to find node_next instead of looping.
-	 */
-	if (!list_empty(&iter->prio_list)) {
-		iter = list_entry(iter->prio_list.next, struct plist_node,
-				  prio_list);
-		node_next = &iter->node_list;
-		goto queue;
-	}
-
-	plist_for_each_continue(iter, head) {
-		if (node->prio != iter->prio) {
-			node_next = &iter->node_list;
-			break;
-		}
-	}
-queue:
-	list_add_tail(&node->node_list, node_next);
-
-	plist_check_head(head);
-}
-
 #ifdef CONFIG_DEBUG_PLIST
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
@@ -231,14 +179,6 @@ static void __init plist_test_check(int nr_expect)
 	BUG_ON(prio_pos->prio_list.next != &first->prio_list);
 }
 
-static void __init plist_test_requeue(struct plist_node *node)
-{
-	plist_requeue(node, &test_head);
-
-	if (node != plist_last(&test_head))
-		BUG_ON(node->prio == plist_next(node)->prio);
-}
-
 static int  __init plist_test(void)
 {
 	int nr_expect = 0, i, loop;
@@ -262,10 +202,6 @@ static int  __init plist_test(void)
 			nr_expect--;
 		}
 		plist_test_check(nr_expect);
-		if (!plist_node_empty(test_node + i)) {
-			plist_test_requeue(test_node + i);
-			plist_test_check(nr_expect);
-		}
 	}
 
 	for (i = 0; i < ARRAY_SIZE(test_node); i++) {

-- 
2.55.0



