Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 163B2C61DE1
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 18:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACDC86B008A; Sun, 30 Aug 2026 14:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7E436B0088; Sun, 30 Aug 2026 14:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 994236B0092; Sun, 30 Aug 2026 14:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6589A6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 14:43:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3260A0358
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:43:40 +0000 (UTC)
X-FDA: 85158809400.25.29A297D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id EBC98C0006
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:43:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h8sS7y7U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788115419;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPeadiw5t+A3L90hHBlBF2ftT17ID9ZsoOS/qITDYDc=;
	b=WFEHVedsCnSIDfzwSehuo8xXGV3YZ9yGVdYU2INfR4AG7HRCJAkxWa+Bcuf4pvvlibYlw6
	EyS9EI9ZPhfcqTIBNZ49f84Hnyfk6FfrisAqmIsZcKze6VsjGVt42LNMQKaDa8uCGbu8bS
	GUH5f6u0YR3aD1PHsnNeuRVe5AOsB+8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h8sS7y7U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788115419;
	b=BqF/5qEPgyQtbQCDGBB+Rt7CDkJROGcLAeeZGWzVOUOpEnptFCEP2FAfmtvgZxQuPm5OMq
	90bxvlrGDFIx8+K72uzHKJ7rY/Wk2upO+G52zl34hx1/81cV7TFG5OowYRTeC4DpAje3CE
	7V75xqlItDsWLlB/pm3663uz1l1DDik=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E77C743F25;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA871C2BCFB;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788115417;
	bh=571fAvo+ZaIKBCUitIDqLYFldwlZ2o4hP7Qze7dNNWE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=h8sS7y7UlJyAyYxGnPxj6GIsJRbFKD31MMGxqZ2UFVeXHlweaevtHRaW7q286JnXZ
	 1gye+JAOLeGJQg3tJi6Y2vsvamIRvNcbBqrjeaiyIreG2IeXJOusYNuLKR+jknwfq9
	 kCr5Mxe2HW5JJZgyfIvyGkngNjNWmdSJ61Mnj3cfFKpvhKGQV7quMGH3fg3SX+ZNzZ
	 41Kyj5kROXc9jwA/Iygdw0CmeqrD+/pFjOSZcwWs54OUP8dX39/ffQYnpQ9+q3LPQ4
	 R38HxYRzmUL+DDIlwNBM6GOenUjY2pRNz+ZdDxkaFuBgNqshFFXBzxMg5ZqfdFlfhE
	 3vN0X5oaQXUgA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96861C61DB9;
	Sun, 30 Aug 2026 18:43:37 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 31 Aug 2026 02:43:31 +0800
Subject: [PATCH v4 1/6] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-mglru-flags-cleanup-v4-1-2d15dde0d7ee@tencent.com>
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
In-Reply-To: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com>
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
 Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788115415; l=3661;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=dZSJQRCK3EQ9sViTkUwC4Atda6qGT2eBA8Z4NTjwo2M=;
 b=QsPxwLTmieZHKBA2YEdznw6Sn+TafoOjMn4N23z5w0ahXZYooZTpq8HNxBGXj1/xdoKqAjqMk
 OED5XTVuKJFDFO4G8NRFK55XKBl3PT6Q7G3HrdniXlA73INl5QfoqTB
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EBC98C0006
X-Stat-Signature: qrm3admpqtzg6n7u6rt3ju1hsn4qeaww
X-Rspam-User: 
X-HE-Tag: 1788115418-135448
X-HE-Meta: U2FsdGVkX19nm8YuzFTfpl5b1/YPCKRZy0OWn+Z7Iq8VSzRe1fqZbEBm917VsukMn4Q6/VmXyQO2pmHRsVAQhVF2TxmEW4LvhrDY6vO8E8TBSNMB4J1ViLYamthoSEC7bnXCtlZmM27SXaufGLynbmC6qcjXSA1Q9gft+gnrunLeGV3OzBAdUw35Hi2mwc+jnS99Y6ehhd0zzlgq0okaU13etkuVxYOLP1fTHW8HEWmAMqaC0eeZdEiJ6zeXDf4mwKPRI2ssvRQ1PSoi+VnufO2199RIXHqQOCZ+ACWXARJphhdpXwGVckCU3JrKIgfPgOVrfKZyYaOwYV2RXBTPrsM7Q2+00MvriN3+xX/KbccL0dFsDmH7oyKek2D7fftpkzcmKTstlyBLfLwLlA4bw1pnyK8joH7N6XmmdEpVWHwyjCaCtugaYUv8dT0z1FQFEm8PRyl3iOdAs5YOzdOJYmvEJ/ryUY+1msxCG/yPGK1dXZpkt7U64zBGIgRpEmz+WhQs8bkT8by4FP8wANFPrYf7AHl2wnWQ0U0XURLTQb/P6uy8VOsWaFpKhgueItLeE6Esxcf26odAUZmakQ3Lpk9WzJWeUtHt6pYcRpX7kRy9JYdIcR2tJ5NkfNSBsPmBSOnuExPOrGdzgm/Ep5u4gWFNzuUp0Gme+dZgVybacgFH0f7Ohq4yO/BRdyFmNNmFCImV0GHdN4XfhBhv+a0efS8UxUp3TxOKAdi8T1ltmABFGM7FL/o5qWnoxTBmL2BJDDLNCkEJI8NmV57m+wZfe7DzAiAuRfEvn+zpGJ6oX2vZIvgYqcIXSQscVNaHVaoIOhV76/cN8IJOHzrTxqSoCRnJppuv7NIvj76C94mXFfF++ccNugEE7GYCSmq3/v+CpFJpfbS53xk/08FE2i28zTBwtMICaO/VD89kfES8+bDyFUMWNkRc4UTOUT6mLuuxVTJjWKnJF7f0QHV2dUW
 mh3sjyWS
 ZQN2nLrcqnpR2JtJMKU8/Ww9RVG3V79FewCxm0/KKQrttI9A6RXTm32xTNDK7pPnG/QkKHpeNVifC4yl2Bso9KzPlFUfvNfLaMOJ5IzDyXmRE7AmOjUh+dJigkYR3Lsai3HKDpM52hktOlDvsaAq9h7MluDMil95loC/mCmy9UloI0cLgyl9yZ1UwXUZ+ycct6cfARGCHW9+vHxCgkhCPN8Rwd44PF1ZgphND8sC3mY8k26EfIw1VqJ+IPmTNBLdQH3opFKC5/u0Jf1JYD1YRP9W108uhNDaJdjK5yAsKz+JZk5VFBOIAAGm8PRJKatMND+Ma4TG46zpOdtwm2eXLXPceiNDnpSpaP2oyaMnfDLkjQFQ5zujYihDqIWcEAfknwnf477h5aKof9y/HFmFfc0DlfMvS71cx0BXGhfdkZzou2A7Gz7U6QDfzj8Clm/6tGQoAQGYhL9S8yhZxpUuIHVTETPMc9Di0aQZZH+SCbNUiiM0eNGwp8RZfb3U0r+6q33isNE2JKcd8Q0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
introduced a sanity check to catch memcg counter underflow, which was
more of a workaround for another bug: lru_zone_size is unsigned, so
underflow wraps it around and returns an enormously large number, then
the memcg shrinker loops almost forever as the calculated number of
folios to shrink is huge. That commit also checked if a zero value
matches the empty LRU list, so we have to hold the LRU lock, and
handle the positive and negative deltas separately.

But later commit b4536f0c829c ("mm, memcg: fix the active list aging
for lowmem requests when memcg is enabled") already removed the LRU
emptiness check, so handling the deltas separately is no longer
needed. And if we just turn it into an atomic long, underflow isn't a
big issue either, and can be checked at the reader side, which is
called much less frequently than the updater.

So let's turn the counter into an atomic long and check at the reader
side instead, which has a smaller overhead. The underflow correction
is removed: a massive leak of the LRU size counter would indicate
that something else has gone very wrong, and one should fix that
leaking site instead. Besides, the updater-side sanity check is
unlikely to catch the leaking site anyway: if a folio was removed
without updating the counter while other folios remain on the LRU,
the WARN only triggers much later, from a likely innocent callsite.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h |  9 +++++++--
 mm/memcontrol.c            | 18 +-----------------
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..1b49d8b591da 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -113,7 +113,7 @@ struct mem_cgroup_per_node {
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
 	CACHELINE_PADDING(_pad2_);
-	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
+	atomic_long_t		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
 
 	/*
@@ -902,10 +902,15 @@ static inline
 unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
 {
+	long val;
 	struct mem_cgroup_per_node *mz;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
+	val = atomic_long_read(&mz->lru_zone_size[zone_idx][lru]);
+	if (WARN_ON_ONCE(val < 0))
+		return 0;
+
+	return val;
 }
 
 void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..f91540feaf73 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1529,28 +1529,12 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 				int zid, long nr_pages)
 {
 	struct mem_cgroup_per_node *mz;
-	unsigned long *lru_size;
-	long size;
 
 	if (mem_cgroup_disabled())
 		return;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	lru_size = &mz->lru_zone_size[zid][lru];
-
-	if (nr_pages < 0)
-		*lru_size += nr_pages;
-
-	size = *lru_size;
-	if (WARN_ONCE(size < 0,
-		"%s(%p, %d, %ld): lru_size %ld\n",
-		__func__, lruvec, lru, nr_pages, size)) {
-		VM_BUG_ON(1);
-		*lru_size = 0;
-	}
-
-	if (nr_pages > 0)
-		*lru_size += nr_pages;
+	atomic_long_add(nr_pages, &mz->lru_zone_size[zid][lru]);
 }
 
 /**

-- 
2.55.0



