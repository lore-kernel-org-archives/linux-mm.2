Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A219BCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 12:55:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649946B008C; Sat,  3 Oct 2026 08:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C23F6B0096; Sat,  3 Oct 2026 08:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43BF76B0093; Sat,  3 Oct 2026 08:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5416B008C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:55:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65BCF160922
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:21 +0000 (UTC)
X-FDA: 85281310842.03.669E971
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6BE6CA000A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DhoT0l/o";
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791032119;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0um07wgfOW18l0j9/RUHTNbGmOJ5XMW+el60gmV52o=;
	b=4LVHxeaRA/tVK/go4+zUJa64PW7MEgpCZy5eoERTAKbVL/boVzje7M8ZHyeIbMYd341jOS
	W7k05fuKthRGV93c0dDzxpVTutzDosiwQzTmtev79bZ+WW0bLjwckbIQVHQXnRWqiuBEB3
	qbiKBj31UslhLplWNyDq/UuKHNfbvFE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DhoT0l/o";
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791032119;
	b=mnn0fC1xAZLozu96PjQ/cRja2Ds8GtP4Z//vLGSnJs1Vf3kMRXsX6dOTV21/6zdthnSBBz
	haK9nUerHk2ar8XOyLon/a5T20A5cnMTkrCZkqxA6/AzssaQBcJ8wANxpo9YME8EX1XlWY
	QK9GLbmW6X7qB1w9g5UZOvcioLYlFT4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 13A9344818;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A745AC4AF15;
	Sat,  3 Oct 2026 12:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791032117;
	bh=wf2qnnNZyt63f6bgPwSW7gAoSrPCsJ0FRmCZEeRXJac=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=DhoT0l/oF7p4P+fPi7y6cIq/099YTs0IZ5ri/gSoMa4vgMBZT83mIqzhJQ9TkiET7
	 UtHwwhya5Hnf3fOXZnbkDRl0LO+MSoV0wN1EYXy4WoRf4HNHUEM2ClWzqFOg+llI03
	 38Tw4Tv4KwQr0R352B59Glrx3tkz/x9YwGOLTiRwNrHd/M7gnEXiMH++wBzVuVifyJ
	 OlQclRSYi4bCJFkEpEftkS4JVUHwnpnub8YR3AUb0oLOiVdPvJt4ASDJfQWTbLSq9F
	 pEuwA74nlyWXuQ+PyIrqVKCHlaaDyUyhCdW6M/kj0ksQ5LlYPXhoMMoHfiqrVMJuQA
	 HZ9UWLbLIC64w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AEB6CA5FE9;
	Sat,  3 Oct 2026 12:55:17 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 03 Oct 2026 20:55:14 +0800
Subject: [PATCH RFC v3 03/17] mm/memcg: add folio-based lruvec live helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-mglru-fg-v3-3-cbd4546a5bd9@tencent.com>
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
In-Reply-To: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
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
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791032114; l=1978;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=INmIp582Dn7nky+glPCA6hAuYR4TWw3FCmBj9GXz/2U=;
 b=oORF7caj8BINg9CX51BXlXyhC2/uK2Go8JqcZ2ZYKXWd/N359aK8Lru/BdtBdL6lwEvMpxDKH
 LCvoXtg1oVBCYBQEoSnSybH31YH1asP6qLVdIy5LT97H97HZA87X1Qp
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6BE6CA000A
X-Rspam-User: 
X-Stat-Signature: w1fgdu4fhqi5ofsk4ynhdgf5yuo5drp4
X-HE-Tag: 1791032119-524812
X-HE-Meta: U2FsdGVkX19K6x+ZS/Wi7aXDsvB3wDOdDkVh/XNmWrbArAOLY68EYeicR0m+d7TX/ppioE0qrz570fL2ItqcvmpIuDqBOPno3D/VE5M7GavFd3lNSFo1AtH6s/8hdKHBZdovsTg/iqyZUnYcaKoEPS0gt8c4dNJN2VjrV39m1i6Qi53eb8Spe+2SmEZbdtb4nA/hQ51ds81UdmBubMcdv5TyqHvkjmdgd/SWZaaYGzoxctWEm/zF2kVBpwh2LJVmJfMJ831PYsszFiQppiJ0e285Aho8JnL2baxrtzstWp2ukcqPg29rzsujFbLikjUFLSbavF1ZfuKIVFgpzK8pz++IDiQyus2/ubBHrtPZgmG2PPMjhJ6fY8eS5gzwqX2BB+oRSLunFIQYsIKpV2N1HmPQs8gQp7pe1DAR1JCXotq9Zi+unsftoIYyuk4jVPzyzYDCFqYB8ib4h8rxzEpj1T0BhPm00XffOFZE80fMY1rwUVSYUYvkQvnuP5e1VeOIasGD3N0Q52H59/cmNwUqpPw9eTp+Fn5wkV11NjboOVyLfO7WLThEELmXH8XcRIb3NhMulHPGRu1ONU5A/yQnB1sT0VLo+4DCU9+GOFKg2DEvtRznkSK1SbXqUcxdHG92d197usXJ3lB2pAY74Zxysk9ojxPBup565zpP1dlIGAys2FvUpZQ0H+ZGnUslX3Kh6RKPTIwbalaGExx4joQjec06FVxYg0JhKSpz5GKIKrJXG0Qr5iL+K8xuJLCyUMYgmp6hMtt609xSpUnM2bi5IYtiMynchHy9Wp8d8+K338XPSy0WwwvN2GIPmTjvbvHc+BaZ7lbBCoGeBwYA46kGwK9ZD+alsXC8glXjj0wsgnWLP40tWK8BmuUs6CIh93nNuGd/cjxnnSrRoH8xZxb0JU7U/GBK6tQ1+yaoAgk8jhDDOv/UG9acfC3LPmEFwEmhEW4h9I9TunPZmFfUDii
 9Rn3m+Ia
 O87XJZbWWK4STyYenEUTeCUCaqifz3lpj+YssDQH7YHSkYuE1MEGaqS9m0vnhzm71YBCwy4rhShBsKBvE/i7u9Vji2ECADIjGkPti3WD9ggSo05R6FniKLBW6Z9RlrE9u4R6Exb8brTiivEcJdQvalPfv2ItJRCkZk3u5eV4UsQzXmg7apakySM/tkhHzAEJM2fZnsq4eMe66cUZy+TH0OMP0SPzUuuDN1vICaeDGaQjelIxBBz3W+NYUiJVFqAavHHRzaaOR1EQTYhel7+UNDkaJTX/yqiehRRP6nhm9FdYK5EgXjD/UYpXM5WCZ+87uZe+Ue1GHs1z2K00q368cwesSU+LA2CCXc81v9VyJL95FKSKDC+eNbanM3d7zKafxECKicJhAJxHN+ULq24WrVP2JRF/4cU14E/9B6aTh3ht9Q9g+JnMdcxeG+0mpM4Q9naEA
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

No functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bdc5dc925c1d..d0a9229e8cd7 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1535,6 +1535,45 @@ static inline void lruvec_lock_irq(struct lruvec *lruvec)
 	spin_lock_irq(&lruvec->lru_lock);
 }
 
+/**
+ * folio_lruvec_live_get - get a live lruvec for a folio under RCU
+ * @folio: the folio
+ *
+ * Computes @folio's lruvec and walks up to the nearest live ancestor
+ * if the folio's memcg is dying.  Paired with folio_lruvec_live_put().
+ * The result may be stale: RCU keeps it alive but does not pin @folio
+ * to it.  That is fine as the counters are fixed up on reparenting.
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



