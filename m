Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45BD8FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:07:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C31A6B00A3; Mon, 27 Apr 2026 14:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4536B00A5; Mon, 27 Apr 2026 14:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C446B00A6; Mon, 27 Apr 2026 14:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 338276B00A4
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:07:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5B0112027F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:34 +0000 (UTC)
X-FDA: 84705118428.09.47BCCE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 25C14160009
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tPlZw8Of;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313252;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGx64xs+26f0TJPdM3ZNHYtywwHk0bWr5FpVleiXc4I=;
	b=ijd40Wsn1fXU5AS/YhVmfQa+ixLvVcfWdFhryQWEx7jfui/xuaViY1u7SXCJMiWUSOKY/X
	nv3BgxrLgkRfkzI229/SE70H86QsmBlCLF5d8Kb2966LkE519zZ79OHZmt0rosFMGCet7d
	w4sx+svYCPVu/2cCD1pxPD1sO50uGA0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313252; a=rsa-sha256;
	cv=none;
	b=Kco6qIkMzyu5tFGCDBOs5fGkPg2K6WBWcraItOPA+AsehV+NGapnq3Vv2a97jBi2BT7576
	sn4O3cL849n5C9e57CrIe0h5nYjrKprIOTkCbUA25uigxvW26gSwZBrmLZ1OdoAXUCd80o
	YPGG/m1bHUx5VKD9QWRzbCfTGIp8+HI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tPlZw8Of;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C179E4475C;
	Mon, 27 Apr 2026 18:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10672C4AF48;
	Mon, 27 Apr 2026 18:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313220;
	bh=DOK386NUsZ520wbu/04MmYJXpiyWky1LXL0L0xJEEnc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tPlZw8Ofwjb8af2XblCqKdAKB7LmCBVHmNvkiU/er7VW3ayN1Phj7jbxos7h2vU5F
	 B2O26VMCg+/P5uWd+cYILVsOVddrHZFGdOSBu5ZjC5zqkgokpumT5le8t5AUqXmplG
	 1ve8gSs0YFz7baabg+aeCIe/oIw8fguJk+VXbgX5iTr9fjtssBv1gVYF38/5Cf5muj
	 d15RwwY3DE7Y4xWx/TJFLl3J/ItwtawPm4zTRF2JfVocc0zm21jV4X6irLTu24EzXC
	 3KidLtUFtuVMtt2r91Ciarvd/I9m616a4V3WbkbonreezLFAN9Lf73r9OH8qTNNKZR
	 OujIASZR4ja5w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 057DDFF8865;
	Mon, 27 Apr 2026 18:07:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 28 Apr 2026 02:06:59 +0800
Subject: [PATCH v7 08/15] mm/mglru: don't abort scan immediately right
 after aging
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-mglru-reclaim-v7-8-02fabb92dc43@tencent.com>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
In-Reply-To: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777313217; l=3743;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=tJwMbabzOAzU1rtsLiIyfOmdKQT6hOnnnbW6fs5AP+4=;
 b=dCW6tVzk20OP2vvexHeQXlVKV4wetE3MP2wgKaZEtwI5Ts+//V2gyFAgFaL8XShlYlbC0jmm8
 omaErK+i6lTDe2wBWtWYaX9o1gMRvQYyAss21vpoE/YZLzCCT7522jo
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 25C14160009
X-Rspam-User: 
X-Stat-Signature: b7ugujzbqiwx89cacx9qkqhtzswc4dit
X-HE-Tag: 1777313251-817124
X-HE-Meta: U2FsdGVkX1/+ZHcgQKL5cD4ZkRYRncEaouvUliW03iixGKEsUhVUpsevV3+5utuV72PxAvySvkEEvqB2JfhOV3G60l5xLYqfLjqqiDsFL/J8zokr1p02iCrpKhi7G8sSzWiC8Y9ktRRkBB0NY8RSdNRVH8cuKOPAWVoxlxPnRxONFI4hYSL/580obFjFwGzbu9oQX3qKckik+wAYHZ/lOxPzGhskEyuPTg9fj/0RgNb+guATcKaAVpar5TAoZ6MK59TUjGcsSob3vQg/Q2CltqIiKNSZS1y6lPy4P33vOkbh2g7eeKrb4M0q1wbcL7nFscRU/3roPxqyLmTNITrMHN3vLMsr6fP6DlN1SHVev0kM6ZnuzLOD61lpywIrI/ZCu4IW7ezPaO3yDo2UiTwCRamUNyfXZ7kPJVpQjyjT8P//CD3lx7vF0m0mH1FnAJrAQBa6tSHTdeNSXSvKxJCGL3BisRMgOUNtK98BC9F3nRNZmqDZe7OrVL2j+yDcjtvVBUexQH/GAclHqzY6Fn5C1ofJFhbuWZ7Dr2wjTPyYLuH6jEgX19AmpqfXwlPgb66ixfX+I1lk1SBSOG3qdlt/r3UASu1esxDNLPZVLEY8En/kpI3nsWht9eADw3JKwRZn58kH9a4Nhj4lwoaaNgZRzJ40eIsfnL5cqsGgRMAjduN3/4OjdwwPAEIwdEqXQt2WvkPrlClnlhz+ol7SBBo0BFU2Tt2Afnu/arEBuNDQDgZpcWvS5Q2Qan7LX/BfOtHvsmo6XJB70zg7zzNp7Qy66WazkJnp+buCgo/deTxLYyfd+TYtPYshqKNFR52FSUk6/9Q6QrVWMU3Y9eR11tQfv9DYV3S5BqTQMbRtHPO/jVy/V6AHaYIrxqPoToF2RWA+/qzsRMbhLoVyYSb5Y8CPytIVt5Q8p3auSLphlXW4SJgFS2vXkTPnLL8gFFG9SNonbS64g/zvnv6IsDFjaJh
 y7kJgZoi
 om63ishS9JPE4K8lyl+yTita6KeylKp4c76Ht58hrEELZcDEgmijlBRLMoKeS8NMbKh4yPdxmC0VE8mSHi0LrBq75LvydfVcGa9xSwVBz+ieNlnMAFULqaP6UqWV/1wyg8iRu5lLt/LtfdBifp5j0Ci0T6qpHk70NAFocx2iGQ9o2Za7ZOSFoDFXTd3N4FMHw8w6uPA1NTG/luAvvDTIzD7RZpVhYTZl1DAV/uP2RZj22fxqKmqqdfnQFm3tuZMLS3DIDE7uAs3pLckDlseARt25n8EUK3pqpn21Sg+dp+rYZPGswwJ7Gg4N1lQRc/wd2UjSyhdPoinyHIWykYDBGi5bCibwNBR0jcEEpOMyAhGXpt+99HSYxMAWMyaCRKZTLjZAZC6qSLpqUWce52p17QsOfkJ77vS4M1A9gZfXSCCI9jWjA6H5upDypjmgekACImWSbiXFzSmZe1HJSHt+nvaDfKTFAgMS+g1/NBkUxx1DZ2TnZjnkUoBudoKqAcUAiF07H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Right now, if eviction triggers aging, the reclaimer will abort.  This is
not the optimal strategy for several reasons.

Aborting the reclaim early wastes a reclaim cycle when under pressure, and
for concurrent reclaim, if the LRU is under aging, all concurrent
reclaimers might fail.  And if the age has just finished, new cold folios
exposed by the aging are not reclaimed until the next reclaim iteration.

What's more, the current aging trigger is quite lenient, having 3 gens
with a reclaim priority lower than default will trigger aging, and blocks
reclaiming from one memcg.  This wastes reclaim retry cycles easily.  And
in the worst case, if the reclaim is making slower progress and all
following attempts fail due to being blocked by aging, it triggers
unexpected early OOM.

And if a lruvec requires aging, it doesn't mean it's hot.  Instead, the
lruvec could be idle for quite a while, and hence it might contain lots of
cold folios to be reclaimed.

While it's helpful to rotate memcg LRU after aging for global reclaim, as
global reclaim fairness is coupled with the rotation in shrink_many, memcg
fairness is instead handled by cgroup iteration in shrink_node_memcgs.
So, for memcg level pressure, this abort is not the key part for keeping
the fairness.  And in most cases, there is no need to age, and fairness
must be achieved by upper-level reclaim control.

So instead, just keep the scanning going unless one whole batch of folios
failed to be isolated or enough folios have been scanned, which is
triggered by evict_folios returning 0.  And only abort for global reclaim
after one batch, so when there are fewer memcgs, progress is still made,
and the fairness mechanism described above still works fine.

And in most cases, the one more batch attempt for global reclaim might
just be enough to satisfy what the reclaimer needs, hence improving global
reclaim performance by reducing reclaim retry cycles.

Rotation is still there after the reclaim is done, which still follows the
comment in mmzone.h.  And fairness still looking good.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2a607546277c..42ccc6eb0748 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4985,7 +4985,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
  */
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
-	bool need_rotate = false;
+	bool need_rotate = false, should_age = false;
 	long nr_batch, nr_to_scan;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -5003,8 +5003,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
 			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
 				need_rotate = true;
-			/* stop scanning as it's low on cold folios */
-			break;
+			should_age = true;
 		}
 
 		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
@@ -5015,6 +5014,13 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (should_abort_scan(lruvec, sc))
 			break;
 
+		/*
+		 * Root reclaim needs rotation when low on cold folio for better
+		 * fairness. Cgroup reclaim gets fairness from the iterator.
+		 */
+		if (root_reclaim(sc) && should_age)
+			break;
+
 		nr_to_scan -= delta;
 		cond_resched();
 	}

-- 
2.54.0



