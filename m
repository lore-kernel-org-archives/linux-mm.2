Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A82EC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 952E46B0092; Fri, 11 Sep 2026 07:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903F26B0099; Fri, 11 Sep 2026 07:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AAC36B009B; Fri, 11 Sep 2026 07:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 554C76B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:45:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E05F0C0160
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:12 +0000 (UTC)
X-FDA: 85201300464.15.09EF663
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0945B120006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G0P9kzTW;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789127111;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=26fvmcICPTTIrt1TihHJ41XMPvC3vaDWxgdz+xHjwD4=;
	b=LhTmV8KqH/WwrHb4oCW9BgQO8zUVH7lg45knnZLopLWMQA+bYVRagZWCI2D6NlBB5+Ggmf
	a+L/7YEAkYN75Uj/ooyDNzrUA+WiOb2T5vT3bmypJTGetIDXgAXknAQoxUOkbBlzafjEIO
	VBXblzitiwpOiLIpuZiBcHyt3SF6isg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789127111;
	b=w8GXrE0ZM8+y45aUtCgaAoeBvTJ3wlMoX3/khZUHAWC73+A6TODmRjloOQAmIOk7fqfU4v
	bq+G9f7ef7MWGYPmwPeH0klBSxL+hkmDjGVlY9Eff7/vo7UG9lLNUuuWoNPII+j6+6jp8S
	v/fn1F6+j1BiOu/kwpx5d7wEPyFTV5A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G0P9kzTW;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D23F60A6A;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0601C2BCB8;
	Fri, 11 Sep 2026 11:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127110;
	bh=d1Y4YPT7qxMmXCP5i5LFdt1hdX4SS+8Ci1LOHflJYAI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=G0P9kzTW8AM22s5oPa6hHDE4CbC4DixXhokc34IXMFfm0YnPgpOLiZzzRUdVDRTsO
	 fGw7PHX+f84FPehfyWDh8kxLXgdfjAUNqbp8j+Z5+RhvUV47lJhwX9jvaRiFMndTcX
	 3NskMRyprW5kWSFZsmbktiVOwb/4z82iPS4P6opnujydVcMotsbp8wWl8oRMJbb5FL
	 1ZqpF4aQMTd58Wn55sn2ePGaZQI09jkiZb3J7SxGUFmsNPeuBnefPJi+tuHuodBcQm
	 voeI7v+6raUiGD3pEP6v9n8vYiiGXSl7AIUtZRXQ8y5qa+25q4UPEiWv16gv+O6gkg
	 8VhUquLkrfDVg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF05C88E4C;
	Fri, 11 Sep 2026 11:45:09 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 11 Sep 2026 19:45:04 +0800
Subject: [PATCH RFC v2 01/15] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-mglru-fg-v2-1-f26e5cb26da7@tencent.com>
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
In-Reply-To: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
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
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127106; l=3250;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=HPL0IDynbJIttYnOEHBWr8ihbXmo9qxsFuOTnhhs8gc=;
 b=x5yYdtClJFJY2q6tOQeScr8nDkYHljCqLLx/jRAoZo8wYLWf9ATedGlxlqAl/8g9c6uiEift9
 Glqm3tshTP6DlN9hrGw2ZhQUaA33tSd0Tilfsg+1vzqcFc9T9djfnO9
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: js591k45jjjoqxggtoofd144akjw7mwq
X-Rspamd-Queue-Id: 0945B120006
X-HE-Tag: 1789127110-292459
X-HE-Meta: U2FsdGVkX182SU888O5KNXotDgHj19YOQLgyM5RJivpaCSp1mX4MXij4yZKtJWiJ3jHjUfqcwa8f0gTTbFVNheFIbGLCho/KNnky1Lyn+pA3NHhjmtUjEVkNVMbSVNkynwXZHNhwnF7B1Hfj5vcdMLTbIKuHNO8PRO+1cs9uEkBcLUs4a0hVdUXV/j6HfmDoIWbaskEEVVf3s3GqYwIYGSDSm+NZGk8zuQ0JY3GmSFRfgn5UghxteZ4WHZbTTsmCGdIXhQzfBnpUCYoxTSyLGChW9PLPGMYjBu96WsH8LJnFciHvEKbdH0ZSq2yI5/bK6AXufH6v96SYq3qdIcrD3BCv2j0JQj3K4adL93SP3F3ZjrxATO5wXOiGqj8B8TvlJ8LdcVTxclWi9/d/wYKWJet3vlfRuX6JasXE0F8B6L3k18pQPCBbY1Ya0BXnMj98fp58Rlkd/tmXul1xhm3LNiKuWtDSMHAUBM36+q4f5Ri/ESjpJLWqrKSqcv1mmdpav++ybU6oOcgz/CqRCYSSd8BiX30Swv8S9nRDDV6plw4jHsrvUlCDgDqG/EBRSjkO/jBRJYWnMODgHTXKBEpHg5EQatN7J7g30wMwrdgQEpjANgX4a8NgVjw1xBSilRunCCP9w3r9a/0mjPMNSRGaXPK15jrawQiNGAra10LTm1IezZw3xZltTDMiZJaOCCh9P1f7JM7ajpi8w4jWM1YOPQL0dss/+0GRKhmCzUr3v87ogkeYnRZ9SqGTZdpM5ArJvYVptUco6bC+u/noxnmRljevMaslVkjjGOXk+sPh/z7v2ogevnnH1G0g8Y2N55HXqIXftgu941mLkGaKQMfWa1CBlKL1lMV/5okNY1cROg+t9QVdVCM8N5/ardjp5TyyMKwZSHHDj7VoSpvzloqhWxz579RRtjVc6Dv+D1riQsRDuXqZpdXd/qMYTsP4mJc75MkHmRVKrDHJvDXcC9J
 TYJASJsN
 tg+DWOKUttyYHfw891SB4PaHs3JQltvvErFlntlf8qOZNx4j/TkiYB+THB92XVZ6g4vkKG4dJpfpYzARMJG5FctnvJ5JMObxVv2LHzA3jOb7fIg3DQbgqRJ8VIwt99m4/lC58kVenbfYGXJe12AIL7d/cHFjpj5StO3ghjBvykaKhRqnHv/PrJacZPDyY1G03mq+h7MDJmLy3YwB1ziM9x3X/9Z8IAuJU5rMEC2g13G6oftonTqAVgmjzCTnuwabI1sF4tQvKQu3yRhCml3NKwkmNRYsCSCiaIl5tZ7y99zAuqqxH9Cb/4xgtjpkRgL1QWekQtQRyfO5VPNqiD6VacQWmiyRtoKuUt+7Ypk/sAx54sabrVhMkJ26nb9ZMmW952qyP1/Z3v1jHHOKm1BVcqrJjdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To enable moving file pages in folio_mark_accessed directly and lazily
for MGLRU, allow updating the LRU statistic atomically without holding a
lock. It may cause temporary counter underflow, which should be fine as
we still follow final consistency of the counter, and it only serves as
a factor for calculating the reclaim budget in vmscan. A little
inaccuracy has no visible effect.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h | 6 +++---
 include/linux/mm_inline.h  | 3 +--
 mm/memcontrol.c            | 6 +++---
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 46bf724cae7a..2daf2be5d1e5 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -106,7 +106,7 @@ struct mem_cgroup_per_node {
 
 	/* Written on every LRU update and on every reclaim iteration. */
 	__cacheline_group_begin_aligned(memcg_pn_write_hot);
-	long			lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
+	atomic_long_t		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 	/* slab stats for nmi context */
@@ -926,8 +926,8 @@ unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 	struct mem_cgroup_per_node *mz;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	val = READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
-	if (WARN_ON_ONCE(val < 0))
+	val = atomic_long_read(&mz->lru_zone_size[zone_idx][lru]);
+	if (val < 0)
 		return 0;
 
 	return val;
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ab69b9930893..597f013c8e04 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -47,11 +47,10 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
 {
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	lockdep_assert_held(&lruvec->lru_lock);
 	WARN_ON_ONCE(nr_pages != (int)nr_pages);
 
 	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
-	__mod_zone_page_state(&pgdat->node_zones[zid],
+	mod_zone_page_state(&pgdat->node_zones[zid],
 				NR_ZONE_LRU_BASE + lru, nr_pages);
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1460cba53588..3cc14d1932f0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1544,8 +1544,8 @@ struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
  * @zid: zone id of the accounted pages
  * @nr_pages: positive when adding or negative when removing
  *
- * This function must be called under lru_lock, just before a page is added
- * to or just after a page is removed from an lru list.
+ * This function must be called when a page is added to or removed from
+ * an lru list. Caller need to protect the lruvec from being freed.
  */
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 				int zid, long nr_pages)
@@ -1556,7 +1556,7 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 		return;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	mz->lru_zone_size[zid][lru] += nr_pages;
+	atomic_long_add(nr_pages, &mz->lru_zone_size[zid][lru]);
 }
 
 /**

-- 
2.55.0



