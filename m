Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51F77C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA9946B0095; Fri, 11 Sep 2026 07:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37096B009B; Fri, 11 Sep 2026 07:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37B46B0095; Fri, 11 Sep 2026 07:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 980EF6B009B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:45:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3AFEBA0209
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:13 +0000 (UTC)
X-FDA: 85201300506.14.810300E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3890220003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GODuYNoF;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789127111;
	b=WLBGEdei6oDiKLf6XWY2prFpa0yc3Z/TU+i++prjW6xoLWxkJqvAZxql4H1JAcPOiM+5+X
	Az4j7LsFOa30efPYFw5zhlbjt4S33hflXwxeaSoibw82eDS2ikC6Iq/AeJajSp6D5o6nrq
	c2Ndoj45APcGd+/bZb0IyFe4EcRPYWM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GODuYNoF;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789127111;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8BJtJ6p0s2m98+luSDScAoj/u7I8O8f1q7BjbPH/di8=;
	b=oz9ZfSsrlnsXZs7Ey5zFpv6NHtLph2AfW56WlO27N3ZkSH9a92SQvlm3yGTDHAG4PAw888
	Q2eaECEGDxpAtKXGggTQpeR+zCUUhhNb5KlgL6CQYK7L689yFk+aMjtMtYg1WWTLM1CsEP
	NuTIzzUGXj/zcLzyghwjhr0FQffad/w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 488CE43F5E;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 052D0C2BD01;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127110;
	bh=J2BPOX7qt8s8SBAGQPf2Vyubg661OvnbqLEH8BsCnNI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=GODuYNoF11VeHOEVD+3yox6LWSLmpA7mEoHm1lHDZaRCpYI31tISMcUg4mzg89tx6
	 YmQGJDiN3ggjAo+lDytpcGa4136BRGymWjTTFAsc9vid6LbVJX40mKJ5CY5Xzhpidq
	 gJikNfnejpIoR0v1m5wGXhhuVC1fkMrKGnNu8mAEKixzLWrOIcyQ4A4Xb+0wsn85uy
	 srAalJsbutqQy3gG2eV2RAZe/F612/zR600fZgd/dQvAnxmXE78MCrEZwB506wnrho
	 LAStAa800E5cFciDSeLAprCUqgW4bJkdkHUGZhJg1xpzT/XmR4cBs0T2YMX/myggUb
	 PkW0YJhh0juqw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6238C88E50;
	Fri, 11 Sep 2026 11:45:09 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 11 Sep 2026 19:45:05 +0800
Subject: [PATCH RFC v2 02/15] mm/mglru: make generation page counters
 atomic
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-mglru-fg-v2-2-f26e5cb26da7@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127106; l=5649;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=iN/Q8dZIgZxx+9iuwvelb6tR+yDB9kWeJh/4kOz7Oag=;
 b=ggaKNAylOjplopmOOzY3r9A+0oqE75cRlvDfKuE0kjIZMgdGrzhGzQJLNb6U0QC35vVt/wVN4
 IBulwGHLgWGA2jT2vEfqONjwZ2YZbCFl4fK05iEaVGxRLz0FZbOgNiS
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3890220003
X-Stat-Signature: 7x3x48t536i8n6od79qi7qormmern7uf
X-Rspam-User: 
X-HE-Tag: 1789127111-408248
X-HE-Meta: U2FsdGVkX19zAJRz13lbTTZq+Y2SRWBy9smQGV6Mq04DwQaAlsN8NmUOh6LxHUQC/KOmwQIjANLX9bj6A0leIIe5n6OXsvscZukyBCT0t2syT0d5JiEN41p7IHTrMpQeFLl1bFum01P7e3/5hlAK8sorCCqOM+GnbqTtCZlMo3ebknkxUt874a9kdCOeWCXnLGnPxtvz4SkUztshyIKyIUIEEoXwrZVfHsV5BYgj4izZ2FAsemr04bTOCqyraHTUV2GJzhxL3nnCjB1xecQHJ1LVIfcQDMaD/cU9hVshHpGZylRZaOicg5dYdQMY9u2tRQ2za8y1t8spK23WiZl9EZrdmhJTUQg5k2rIeuLTWS/DyH5Q9K0KUdmmISRY10Gh7Yb2skeY9/MOIIOhhk0nZzgOynCsdDBWKOzayU1t1GBeeHqUKIbRAhWmsiGcD2OStosS0cp5kq4n2d1p4RuNZTWMddvXAWdhC51mCKRbZFqk/wWWXlz48ZT8b3T/dKPotSnT9ZCxfit347tsS9bs0uSuH1QOCq7WDxpuVTdNyImGT3RMfCSGGakPdc9IA7OW4Vs3t5j84jTtyl6xduMW6BwNH8bOB2mPeYwC4HiYe1ej8GNRHhxl980AQGQ3nBN3Vtr416yVFyi0sixpg3WlVok1eBxp6ZIdyXTt+cbhZMnvazK7bqMQa5N1mnuOi0pnKheV/+ioNuL9ZoSAdCRWbxbP3xnS0f4UqxFxNj1JNfjGfWPCjBy5OJpidZUNhH0ON8TvP5GB7nfB1D7nLE68TfQ3SM07jfb5Ja5byzSPz/wFf6jly8ZV3JgsQTyt7syy0wX8QKDMQS8kf7sLUKJ5L9SoYjhDXy6ERtjNV+/3rBAzXCOSUSo6baAJ46WmSsCy9DVzcrj2J2f4yjkvxPYdTsVhnx+rvO0QrIUv2Im//f38qKRdTzUkKqHT2Z4ReeLrfL5yuYdX/zgISJz1eal
 iCDd0Q0O
 VlvI7nucDmS9XlGeB9ecADCLctWLC0EaG7iV1AYL6gG4YdII7RQeNL+b8iPFhp2xqHB8YT1+3+ncQ+Cb9kQcCVt8shTYebgLCZgo/8UK8rWV3mrlbSjodgDQvqx5iDTUHyp6Eo546ku/9Wkm1OScX9X3PNYjJnAGbalvB7k41+uEJi72++FhlP4n+ecvEEtur30CfxucSx1frv3K+rlaEpbPjPLni6opD/0kuZ6jpD8kaQ4NeSqKlE9ZzRLTDx9r8c74SD0dAhIrBr3BViABiuE/TRziIaLe/kaeiE/ZLd0+rqOdfkDdElSFbA6cGdXjFAA+iDlzg3/L/kp2eZ2pUPDmN1gkyi6tCGrLF+JhQeU1Oi5ffGXHbEVGs+c9B/aUhQb/WpyMVCZro0Fr8XQaj1WpsBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No feature change, convert them to atomic so we can update them without
holding the LRU lock. There is no risk of overflow. The reader always
compares and uses zero instead if the counter values are negative. It
follows final consistency.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h |  6 ++----
 include/linux/mmzone.h    |  2 +-
 mm/vmscan.c               | 27 ++++++++++++---------------
 3 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 597f013c8e04..f52f02e8e5be 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -265,11 +265,9 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
 	VM_WARN_ON_ONCE(old_gen == -1 && new_gen == -1);
 
 	if (old_gen >= 0)
-		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
-			   lrugen->nr_pages[old_gen][type][zone] - delta);
+		atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][zone]);
 	if (new_gen >= 0)
-		WRITE_ONCE(lrugen->nr_pages[new_gen][type][zone],
-			   lrugen->nr_pages[new_gen][type][zone] + delta);
+		atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][zone]);
 
 	/* addition */
 	if (old_gen < 0) {
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index acd94cecc0d3..de7d3f8059a5 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -576,7 +576,7 @@ struct lru_gen_folio {
 	/* the multi-gen LRU lists, lazily sorted on eviction */
 	struct list_head folios[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* the multi-gen LRU sizes, eventually consistent */
-	long nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
+	atomic_long_t nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* the exponential moving average of refaulted */
 	unsigned long avg_refaulted[ANON_AND_FILE][MAX_NR_TIERS];
 	/* the exponential moving average of evicted+protected */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index aaceed4759ee..32890e628240 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3451,8 +3451,7 @@ static void reset_batch_size(struct lru_gen_mm_walk *walk)
 			continue;
 
 		walk->nr_pages[gen][type][zone] = 0;
-		WRITE_ONCE(lrugen->nr_pages[gen][type][zone],
-			   lrugen->nr_pages[gen][type][zone] + delta);
+		atomic_long_add(delta, &lrugen->nr_pages[gen][type][zone]);
 
 		if (lru_gen_is_active(lruvec, gen))
 			lru += LRU_ACTIVE;
@@ -4072,11 +4071,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 				break;
 		}
 		flush_lru_batch(head, &batch_end, target_list);
-
-		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
-			   lrugen->nr_pages[old_gen][type][zone] - delta);
-		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
-			   lrugen->nr_pages[target_gen][type][zone] + delta);
+		atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][zone]);
+		atomic_long_add(delta, &lrugen->nr_pages[target_gen][type][zone]);
 		if (!remaining)
 			return false;
 	}
@@ -4181,8 +4177,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	for (type = 0; type < ANON_AND_FILE; type++) {
 		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 			enum lru_list lru = type * LRU_INACTIVE_FILE;
-			long delta = lrugen->nr_pages[prev][type][zone] -
-				     lrugen->nr_pages[next][type][zone];
+			long delta = atomic_long_read(&lrugen->nr_pages[prev][type][zone]) -
+				     atomic_long_read(&lrugen->nr_pages[next][type][zone]);
 
 			if (!delta)
 				continue;
@@ -4300,7 +4296,8 @@ static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness
 		for (seq = min_seq[type]; seq <= max_seq; seq++) {
 			gen = lru_gen_from_seq(seq);
 			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+				total += max(atomic_long_read(&lrugen->nr_pages[gen][type][zone]),
+					     0L);
 		}
 	}
 
@@ -4720,7 +4717,7 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 
 	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
 		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
-		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
+		long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);
 		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
 		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
 
@@ -4728,9 +4725,8 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 		list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
 				      &parent_lrugen->folios[gen][type][zone]);
 
-		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
-		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
-			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
+		atomic_long_set(&child_lrugen->nr_pages[gen][type][zone], 0);
+		atomic_long_add(nr_pages, &parent_lrugen->nr_pages[gen][type][zone]);
 
 		if (lru_gen_is_active(child_lruvec, gen) != lru_gen_is_active(parent_lruvec, gen)) {
 			__update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
@@ -5807,7 +5803,8 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 			char mark = full && seq < min_seq[type] ? 'x' : ' ';
 
 			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+				size += max(atomic_long_read(&lrugen->nr_pages[gen][type][zone]),
+					    0L);
 
 			seq_printf(m, " %10lu%c", size, mark);
 		}

-- 
2.55.0



