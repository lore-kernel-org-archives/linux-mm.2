Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3845C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 656636B00A3; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 542C76B009F; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BBF96B00A1; Mon,  3 Aug 2026 15:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE2D86B009E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:47:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6BAC31A07CA
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:28 +0000 (UTC)
X-FDA: 85060992576.11.CAC6998
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 70F80C0002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZUq52jCl;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785786446;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRxEREMbKgpUrYeruME3bMKO+IUF9VRvK8Ne80eGmP4=;
	b=nQHPPZqBdxuypv0IFiD23RdoQaucFH7LHlr/tQ9fbtvtdf4peaE8CU/QOVAieRp8ACwhfW
	oRwUTNnT1V8PD2CuiyDmCjA6b0gYtgO7Zu5saA+7APWeRKfpG+ukWBh0A/ihd2i0McDrih
	qwLjRJ0OQokE9wwgC+9uRImXdOa73Zs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZUq52jCl;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785786446;
	b=YAeYDY00wj0qT9AmnLJ/6Z9/iPf2C3ih98JGgTnliWwlrYEiYCkKgccad4JFyize57W0Z1
	8gPRxwLLnfko6Y9PDJlrVELAtgRI2OHc5EZ7I9YQqR9LacM6RFhdRLX7cXgwxp5UZBHz9Y
	teeQ7W7EiYtnywI4Tj5ePpvC5XWCUi0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0ECEB45013;
	Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0011C4AF14;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786442;
	bh=sFUdOmE7PPq4dTTxszgE5i0xfhfb5mMlbqX0i1zr9aU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ZUq52jClfqCojXBb7kZZeNU1BU0+C14rPWs5LSmrSLot7mRQPqxYH7HZN8pT4lyIv
	 XJKm+VV9jWxwZOIbxBfBm0drKR8pQX8YVsh/ZTV7tAlGDznW98wxaWmAaLpBgDjvfK
	 O0pBgmRo60yQhS2T85Sx9edHG+54OcMp+2x6Dnrcp0wiFSfNRGmqsGK94o9gVtEJIE
	 5kbKn+diWyCivlu/yL9VSo+WVPKBm8M6OfxAJ1tsuQU8dFF4C4EuB+6EM0S7LKLmcQ
	 dcnc8fB/eMTj8GYwv8Bn4uQxqZ4ctz7QjaILV1dnDsh+XL8a7DF+0n+mU1y//xtwz4
	 ZGZOaLcmkMzug==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9AA8C55822;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:47:04 +0800
Subject: [PATCH RFC 08/15] mm/memcg: add folio-based lruvec live helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-8-4d8dad39dad6@tencent.com>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=1942;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=CYaQx+ZxB9rM3tJj/qRBO+O5Fxa1QWpmGb5iZwXshX8=;
 b=++Am5L1YzqiSnxDr9o1VMbCVEwEukS5UN1/zmmuMnpfuljIk/qOzAXVOhUiwyoRYhYQDYt45R
 xgE/vtt5N5wAukyhcBnL6BpQE79+Z9dNxi2hwZQC227lqiolRkVLMAv
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 70F80C0002
X-Stat-Signature: 6wka3qn6uyntnsupku7f9r4p4nwgq7yp
X-HE-Tag: 1785786446-851518
X-HE-Meta: U2FsdGVkX18zf5m64Z+M8sp1/5iIGeArAChc3ftVv1PsnFONMlIPKh+xLxvccK9zE+NXi5GwJALpS29qNzn1nwhzYv6gFCm5HT/FycLrcnO2mM7c06BLe7wX6djWv3TtKKd1ETFyePrCJSDYbcoILtgatHtG449OoiWP6tCU59GZ7T3+BRZ45JhU7uDBIHK+mSWfBUQD/96ETc5NfmsW/FY10/j9PkQgvl1MCaKJLbi+/iDHRxtniBB4C+7OfeLuQ5evNlwF6bobOlvdsY7zpYzTTQm/D5tM0NyU9tFKcmPgk1Tlgkmxeb1q0Yk0zMUfwmhsv4FJfHJtqNjz5qGQZVDrua77PfrIMVRvzk4aOzIzUhATb4bKR5RT3KNWVPDWkT/KF8uqD84u6tdgX78uUFFLtg1emOHEdEAalV4FPeR8icscsPbqI8P3r/GCukatC7LoKzdfW2S4+1EZXZoJJ2df3+5uCibLN+mdUU5mlw+zNRasDR1FoSK6RTEqdw+Xt5J5Cj5Joj0AFE/SV3NdFjKvOQhJVccHEQqMwf2eTno5/6SVK38JDRwAIuo1Nq32CRZ0i3CVN9EU0lnyxubeB9OQoMO68EcSd/1BpmIOUEkg1siPiKxuW3MJQMRQ7akQeSkrn0OrB9p2XiJAqqYOb/qdQ83IgrtpyMk7JMnvt0NdQKL/ptCRmti42fCUMxQ5fQdJb5AspmJqDWnhX5+ICeIVAec113P7V9WiSbvTgTv3Z6g4uzSVhwB+7BlBlLtK3PvGiJckaSarSdFOhBiQmZ4LcMtiUAf72fvQmIrws54ApkP7chpi+IQ+ZkP2/Lyc9hiPJSQprjojedVSdLVO2jiOSfyRtoRlP0o+nrwFeQTxZWzYyps/2fMLxA4kaEOx5CfkhE5VqXp/QrdF3GR1eyxHYJ5MsW8k96MzspXtqUnzznNrcbJVtil8Nqs8tGGEzeV6i+jpYzTB6/YA1Hk
 LyQQ5H9X
 dPPv1LBtJoSJ0Gh4Qy4Y++3CRRtBOQdvS40W10Jq8pAK6cKtQchCwIfqoMntQS8K2MXww+CwIq0LZcFgRPpMzRsGL3UuFF4Y9hh/zHGqB+5jpEZmDkmolDdlSmFpI81Dp+erZGmxRBG65+I10akvrH1IKRue1kNJTbgxgBFdFKb5NlDsnA65jzj0lapTrfOKFOBWwKL3JAk6Q1xHiQdqpFio/4gjnNzCYe37it9h/nGnmFrIyZQ246+KUvn1BDtFK9gr39uwRlSbTNWm9VBcX5kLwsWUHoizHOFRJfDWzCrO7RjCuVxWk0JD6iZ13KgQqrIsppZSH+SDpHNQQVKfOsZqeyPJcwZk0G3ZeaaVrOQiFYihjnQreDsKuDf+ec6qvkPxzyfT56DsU+y0ZMe/Idzqz6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Add a helper that resolves a stable lruvec for a folio under RCU
without taking the lruvec lock.  It takes a folio directly so the
lruvec lookup happens inside the RCU read-side critical section,
which a lruvec-based interface cannot guarantee.

The lock-taking variant now inlines the ancestor walk instead of
calling a separate helper.

No functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 68f363000d7f..ea0111392b9b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1506,6 +1506,44 @@ static inline void lruvec_lock_irq(struct lruvec *lruvec)
 	spin_lock_irq(&lruvec->lru_lock);
 }
 
+/**
+ * folio_lruvec_live_get - get a live lruvec for a folio under RCU
+ * @folio: the folio
+ *
+ * Computes @folio's lruvec and walks up to the nearest live ancestor
+ * if the folio's memcg is dying.  Must be paired with
+ * folio_lruvec_live_put().
+ *
+ * Return: the live lruvec, with rcu_read_lock held.
+ */
+static inline struct lruvec *folio_lruvec_live_get(struct folio *folio)
+{
+#ifdef CONFIG_MEMCG
+	struct lruvec *lruvec;
+	struct pglist_data *pgdat;
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	lruvec = folio_lruvec(folio);
+	pgdat = lruvec_pgdat(lruvec);
+	memcg = lruvec_memcg(lruvec);
+	while (unlikely(memcg && css_is_dying(&memcg->css))) {
+		memcg = parent_mem_cgroup(memcg);
+		lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	}
+	return lruvec;
+#else
+	return folio_lruvec(folio);
+#endif
+}
+
+static inline void folio_lruvec_live_put(struct lruvec *lruvec)
+{
+#ifdef CONFIG_MEMCG
+	rcu_read_unlock();
+#endif
+}
+
 static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
 {
 #ifdef CONFIG_MEMCG

-- 
2.55.0



