Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2FC7C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 09:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 771C16B008C; Mon, 24 Aug 2026 05:17:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 749EA6B0092; Mon, 24 Aug 2026 05:17:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 686196B0095; Mon, 24 Aug 2026 05:17:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4788D6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:17:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B3D7E404A4
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:17:12 +0000 (UTC)
X-FDA: 85135609104.21.476208C
Received: from mta1.migadu.com (out-94.mta1.migadu.com [95.215.58.94])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1108840003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:17:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lYrHWXUs;
	spf=pass (imf11.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787563031;
	b=D9ar9UFmAU3AJ1/4Ry0NubtIoCP3/yEtYEjIfJ6CMlTmcndhjWyADcwEAQouvT9tsR4EbL
	Uu+wRB56ltN9xr77yWsFPH1WRVQE/LukzC2pbfwLneEICwWPIAfVrZnPwIH/9+nj79UfPJ
	ourmrizh1+Wm8kKidwqA0qPGsRfTypo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lYrHWXUs;
	spf=pass (imf11.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787563031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tMWq4t8RC/hjRPJ5wsJm46tq7OOKj1IaYJLgWmAvNpc=;
	b=nBr2PN1uHun3T2/hqsMcEUwtIqtjBBxxYvZ3TJu6H+SEJ+Z4zVAKa0HMBIWwp2ylVG+D/b
	S8enSLYqyCoRYGmno5nuihmdLM1bRVVxysep9fkQjEmTZ2ri/KO5vMGcwChV6ft6xnfRHJ
	ZNY1nMqLWW5J0uFNPJoXaA0NYzyjkRY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=O/9kZBkuJKeSt0mvaZpQcJ4Mx4IyhlVLvwU3R2sLsUw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787563027; v=1; x=1788167827;
 b=lYrHWXUsbJLYgQaupe9hjNej2voPhzHCBLPxt6H0Z9l4J3rzmbTbF041GrMdQRsGFk2aH+tI
 L2LoI2Ix0BqoGpU7hoKA5LM5SBTsMlIjOR+RIQwuE+uCkrs/e74iW7n4Iack98zfvTxMLROeMiI
 3113e+xcdWDJeum9B+uxEO7E=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id e1b4ba6028b59e6b;
	Mon, 24 Aug 2026 09:17:07 +0000
X-Mizu-Trace-ID: e1b4ba6028b59e6b
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH] mm: workingset: account MGLRU pages in count_shadow_nodes()
Date: Mon, 24 Aug 2026 17:16:30 +0800
Message-ID: <20260824091631.836473-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1108840003
X-Rspam-User: 
X-Stat-Signature: qfse4nnoygzuzf1fwdk96hm5sptfuqt5
X-Rspamd-Server: rspam06
X-HE-Tag: 1787563028-997062
X-HE-Meta: U2FsdGVkX18Fj0cIbZWeRXbj64Lzuyj1yX483eqyoCYNZdDiJgiZIAA8EVfGrOAfqxnQAEulgaLSLGw76E01nesIt+ttNz4EQruPLNeO1Djy1tdRWmxRaSV8T18dFGj6KsZrxC3OvCrBzniLRxs83o9s4MxGW7kf+suERMpZIsmEzt/6tYMjApBbPYyN2xThy/LiU/P6/5c21XRajxaj2JiAhPsn1anNpP974i2lasDP1/DmaUWImvKArxpne2CSTTSJzk2Ft7WkWyj852X2HGdDFWhegZz3idm211LgzDJE9kIwpXuDvcCd2mTwtKLlQOf1yH4HqgbDkIzd1Rqn5MJUaF8JWdZGY1RZi9vhYXgOPrnwsS/ihhhdpd0LRrmyjRRxsYX+DMtsWPx3cdTmLh/NZPkki01iwOYTHL1Iu8SPgbUBDsk6I1/k+PvXsmH3OyY5PqIYwzayBhwB5ns8yIxIYRECTcHiKGk2DrL4r9pueMSoaA+6QSoQ5cnLmOO+1D2eINjTUwvSTojBaG1V0yJhpAD8Bdcw9cHnsbXLelhG0t9Nx5GqdyyUIOqf6Tbf9yVmaXxyDXRJQpfq9TZcGfaYOKjj8ri/AIr0v0RCO84SxOM2bnaIfCgHBNOwhFCu13yMt6XSaDhgAx1lNoycQel5GwRQ1YABj5qj94QTQj+UI3M25iyJ8HLf1qLl/BHIIAblG9yVpL1+AJiEUXrpV6P2VSkO522EugeIoBb73swGV3V2UX7lsmfygTxDjjM1KCzvAVML3PpyyijSm6Ze7r0UPbWDWVcAD/4maKqHbpzK4VO8MS5MFfh6/bM2iv3ruALrgQ+KSMWrFI4nPa50EBMNkr6Umc6T3J0psuWyMHlEYpB56NaBFM5nbgRZl8aIetizSshFcl3iMA82pgEGjJlonVaPQRthNBuyXi1sax0PewJsL8lomQRU8PomJD86Pb2QSR6r+hrfkWEWB6J
 d2DYTv8t
 IsctZ72sJ/uAGVwVk1DCh+uEQnRpQn3gkoZB2RAOcwTqjMQZ4+1xvwNxwaMbFZ3JhXnyXkQfGk7pG+blqKhK+Nm7GrkbK8zXAFBttqfWMbDNir+9Dnwp9VtqPIIP9mL0seyk2QXpAlZPxzvxBGzcciee+QUPapD5Lc0LHb72DJsxJ1Xf8NKHCnNqoHVq1GNjpeHVqNNNfJUdbughARp6e1731hdzo+Qbo8dzA87nJi5jgAAuoBKckpcJgtW5z3tn0qVAPn6aQhMGRH+ND1c1JqS9C1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
number of lru pages") switched count_shadow_nodes() to
lruvec_lru_size().  With CONFIG_MEMCG enabled, lruvec_lru_size() reads
mz->lru_zone_size, which is only maintained through
mem_cgroup_update_lru_size().  MGLRU never goes there: all of its
accounting (lru_gen_update_size(), reset_batch_size(), inc_max_seq()
and __lru_gen_reparent_memcg()) uses __update_lru_size(), which skips
the memcg array, and the classic lruvec_add/del_folio() paths return
early once lru_gen_add/del_folio() succeeded.

The four evictable LRU lists are therefore always seen as empty when
MGLRU is on, and the shadow node budget (pages >> 3) is based on slab
and unevictable pages only.  For a memcg holding 1 GiB of page cache
and 64 MiB of slab the budget drops from ~35k nodes to ~2k, so the
workingset shadow shrinker reclaims eviction tokens almost as fast as
they are created.  Refaults then find live pages instead of shadow
entries, lru_gen_refault() cannot restore the workingset state of hot
pages, and thrashing protection is lost.  This hits every memcg reclaim
and, since the root memcg is iterated as well, global reclaim too.

Fix this by adding the per-generation counters of an enabled multi-gen
LRU to the budget.  lrugen->nr_pages[] is eventually consistent and may
go transiently negative while batched updates are pending, so clamp the
sum at zero.  Keep lruvec_lru_size() as it still accounts for the
unevictable pages.

Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/workingset.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/mm/workingset.c b/mm/workingset.c
index f351798e723a..da20034d28fc 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -653,6 +653,37 @@ void workingset_update_node(struct xa_node *node)
 	}
 }
 
+#ifdef CONFIG_LRU_GEN
+/*
+ * The per-generation counters are eventually consistent and may go
+ * transiently negative while batched updates are pending, so clamp
+ * the sum at zero.
+ */
+static unsigned long count_lru_gen_pages(struct lruvec *lruvec)
+{
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	long nr_pages = 0;
+	int gen, type, zone;
+
+	if (!lrugen->enabled)
+		return 0;
+
+	for (gen = 0; gen < MAX_NR_GENS; gen++) {
+		for (type = 0; type < ANON_AND_FILE; type++) {
+			long *cnt = lrugen->nr_pages[gen][type];
+
+			for (zone = 0; zone < MAX_NR_ZONES; zone++)
+				nr_pages += READ_ONCE(cnt[zone]);
+		}
+	}
+
+	if (nr_pages <= 0)
+		return 0;
+
+	return nr_pages;
+}
+#endif
+
 static unsigned long count_shadow_nodes(struct shrinker *shrinker,
 					struct shrink_control *sc)
 {
@@ -697,6 +728,15 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
 		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
 			pages += lruvec_lru_size(lruvec, i, MAX_NR_ZONES - 1);
 
+#ifdef CONFIG_LRU_GEN
+		/*
+		 * MGLRU accounts for the evictable pages in
+		 * lrugen->nr_pages[] instead of mz->lru_zone_size, which
+		 * lruvec_lru_size() reads, so the loop above misses them.
+		 */
+		pages += count_lru_gen_pages(lruvec);
+#endif
+
 		pages += lruvec_page_state_local(
 			lruvec, NR_SLAB_RECLAIMABLE_B) >> PAGE_SHIFT;
 		pages += lruvec_page_state_local(
-- 
2.53.0


