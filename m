Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EC4DCC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 129F66B00A5; Thu, 15 Oct 2026 14:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09336B00A6; Thu, 15 Oct 2026 14:15:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0526B00A7; Thu, 15 Oct 2026 14:15:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC9396B00A5
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:15:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39F8D1A0123
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:15:59 +0000 (UTC)
X-FDA: 85325664438.10.EE4AA1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1CACE10000F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:15:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cqJ2FaDl;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088157;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LX2824MqNIgXRgdfuLT4YdyzIykUVxsHR4e+HSG1Ouc=;
	b=19RZq9i0CGDeSZ7xIcfIAC/lfbvqM3CLe6P7tdhXA5zttDL4Xe4sYvVCkeYwJ9SRy0R5vS
	N2edH27QtZGIBrSL6SzGzKlnpX8IYCE1K/K7K2+6C8zhM3/w3DQgwDkU61PTOP3PNHCsvY
	I4Vc6D7xlay9hNPNcqlwnIcKzXzjGt0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cqJ2FaDl;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792088157;
	b=oP6uL817Wy5q0J4Bk6pZAtnNau21FoToaEokP8EcMcJLgKoGdH3dUkVzKNlWRVooFI3ixB
	ixwAyHFz2ks2HIL86dYTBMr010fHJ3SRN16L/IA0jouYQK1aa4vOqlvjSn4pZDhqEPyFlX
	vRRfDmm6SLJC1hVpXTeixVQbH5BaROM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A40B447B5;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4390BC2BCF5;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088155;
	bh=AM2uStnUk0NEZ/O+itnfOOVfuh8FaYObL72VxiLWM2g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=cqJ2FaDlOWJdmIDBul6wap+f+Iugq1YeiaMmM4fm0iXIZ5PTWKKSILnUkR3DLSeJ+
	 d6y3G4cDyxfg4q12eTzdJHyX31ysfc4HQL5UMKnI6WsTeGrhVGq6Lau8NWsJsno2bW
	 mCvGZ3glHK+7IDPoCmLWxgZX624LAtzzL3z6grbeYogBR4FirMcmwGSkZZ+dJ2zoe1
	 wx7bxALT9ppqmNzcuOE07Pd7OAaDDDDNzJW3XtanlrYUvFNOj70U6cnALQf0d1CMIA
	 bM4jHXw4WwnVfbBlle86zAmXCXEA/YYOQZeEvQ6luQkEL1e2zX1nuXiWlEYA4dOnTh
	 JUC5SUhTwbF0g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227EACCA466;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:15:51 +0800
Subject: [PATCH v4 02/17] mm/mglru: make generation page counters atomic
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-2-2106750c0bfa@tencent.com>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
To: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
 SJ Park <sj@kernel.org>
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
 David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
 Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=5705;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=0WiOWnqNr4HX6xukU5Z7iG/633RjVbvVUBflEj8zKv0=;
 b=GzIQnMCGGFBJ8rRg+psg68PBeye+76F28QDmanvToZ/WFpaDmG5dUrzTfJvb8a4MA/FisZGJH
 oLRudWip/H5CxKK6A0GNSogsnT6xzOKiGpswm4d6g0s+I1LjILlAP9T
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1CACE10000F
X-Stat-Signature: otbd1os9wqjqc8s6hguut33634q3jd6s
X-HE-Tag: 1792088156-924081
X-HE-Meta: U2FsdGVkX18E43bUxHhb4+4FAVosjI/O7rEUyudcgQh+sUShMF9XkiP4/BTKHgMHkpRESvvaRAOqBBTZLiKQQBcRhb5rNLXhmLrZCYd/IsLX6KXsq/OXHb/bzVBEzwSrMxke4lbDrB29kTMhYjb6qmstelLcfMvcVlCoYz2mDp65dJKW5INEYOCqUfCdsEgOtRgxHnXw0THn1Hur+vX6/Y+xTBPhKP8z5XTSKQLn7/5UuZ7NRgEDvhcG6K6lbsiE1tDrvTOAwrGbxv9RYDiVsMkAW9xQdgypnNCLJK30+fT4ReyEM3eIqyct6oRiOtel3bxzgjHtOJHOnffeTk0pTbaCKF5sHQPxvFaFvZiXR5XkGAgKDSYe+Fvw7Vq3+jfpxlA5IZPxhCynop9+mT8pY7CuNSyXxxJP9CMP8hXIjBq6weOyg5Lsi5mYmWogX3mFhgE4Ly1JzJCaILYdNd1j/2NFDhlmCrWwwEKbT083AqZhX8CL07K0kMXbpS1xmTRZOzWVnxK7QU7PvHNxAiWgZ+SVuDwMDF7UHKU35yxgcR+uUotIIek8Y45Iok6NRZHwyN+4Qj5UDYLbbwtNiepOIx/GUAbAnZNmPaWx7nCYXPLb+b9VhisO82pZalryYZvrg85RrNOGvnZDYI2SOzfjC7HFH++l/lOOT7KkTaJndGF3uUAO3iddYKCDgxhCfeNAWJZYyFnh2e2KyJhIULGQvWjG8q7C+lhDB9/U+pj1ql+ZUE6QD7orHKpsdFCFSiPjkd4COMfoPYv3d5bjPGC39Kcil5ccXd2FR3zao7QI/dWdXQWt4UTow8IF7m8TR39V/DeIJpXPYuW/bIvkFsUaWISIvnkasETKd4V794s39E/yM9icfpfnuNQuXhdLnsB2Pv9PFBmuN1oCYh2Z3ud8K4gJxCvWlUEoLHisQxDoREbkpH0152tk+1+6OGEMVBf7vukxHTxMj0GeXDVXFAw
 EKPGfGpW
 iuGQfAvjFV9nQz1RXvSONEKAxKwF6yBo2uTqBkUgx6mY1OKBGmM7xLnYLT4rVjHaHRP2wARlM+lOdiBcFGcaSBnIyZfXFBuNYsXnhI9eTprgE3q3GVogvZQDlmHeIPDIJTDtGmXsHI+XSIiAlNmArIo6If1xu1xTU53XejtaHZ3CJKlUnBa0sGxEOw45UlPzU5woQCK/w6Q4B2X0Xqefa6CRN1XbIzaS1g0EloLMMAXP4MtpbXxqjkbR/DyWAFG2pddauJo/Zz7jTkWCNADh5AKQNNGyiXddNjRvdaguVG1pRqoyqlZ4Cem3b4+ZjSZ8uOCUVyajRUAKp17g1iF32RTzw2lC4GWS/jYut1yDCJfX7aYmViHZ70h/74M6QbmgIvZl7V0nB1tITmKkK+WD9Y2e0NugThQv1vd5HFJBDgkeaPFhCajpXY2HqEJLolewlv2dDxMyulqUBWk7VpT/Pl7OtAAnNjVnU86FJe6JIvIsoSbMHtfqSEG2PSmjndlnS8it7
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

Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
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
index 3b96d6c7123b..09ce82fa841a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -554,7 +554,7 @@ struct lru_gen_folio {
 	/* the multi-gen LRU lists, lazily sorted on eviction */
 	struct list_head folios[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* the multi-gen LRU sizes, eventually consistent */
-	long nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
+	atomic_long_t nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* the exponential moving average of refaulted */
 	unsigned long avg_refaulted[ANON_AND_FILE][MAX_NR_TIERS];
 	/* the exponential moving average of evicted+protected */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index daa7e37c2236..cab3ba14d20c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3495,8 +3495,7 @@ static void reset_batch_size(struct lru_gen_mm_walk *walk)
 			continue;
 
 		walk->nr_pages[gen][type][zone] = 0;
-		WRITE_ONCE(lrugen->nr_pages[gen][type][zone],
-			   lrugen->nr_pages[gen][type][zone] + delta);
+		atomic_long_add(delta, &lrugen->nr_pages[gen][type][zone]);
 
 		if (lru_gen_is_active(lruvec, gen))
 			lru += LRU_ACTIVE;
@@ -4116,11 +4115,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
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
@@ -4225,8 +4221,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	for (type = 0; type < ANON_AND_FILE; type++) {
 		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 			enum lru_list lru = type * LRU_INACTIVE_FILE;
-			long delta = lrugen->nr_pages[prev][type][zone] -
-				     lrugen->nr_pages[next][type][zone];
+			long delta = atomic_long_read(&lrugen->nr_pages[prev][type][zone]) -
+				     atomic_long_read(&lrugen->nr_pages[next][type][zone]);
 
 			if (!delta)
 				continue;
@@ -4344,7 +4340,8 @@ static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness
 		for (seq = min_seq[type]; seq <= max_seq; seq++) {
 			gen = lru_gen_from_seq(seq);
 			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+				total += max(atomic_long_read(&lrugen->nr_pages[gen][type][zone]),
+					     0L);
 		}
 	}
 
@@ -4764,7 +4761,7 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 
 	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
 		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
-		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
+		long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);
 		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
 		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
 
@@ -4772,9 +4769,8 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 		list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
 				      &parent_lrugen->folios[gen][type][zone]);
 
-		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
-		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
-			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
+		atomic_long_set(&child_lrugen->nr_pages[gen][type][zone], 0);
+		atomic_long_add(nr_pages, &parent_lrugen->nr_pages[gen][type][zone]);
 
 		if (lru_gen_is_active(child_lruvec, gen) != lru_gen_is_active(parent_lruvec, gen)) {
 			__update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
@@ -5859,7 +5855,8 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 			char mark = full && seq < min_seq[type] ? 'x' : ' ';
 
 			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+				size += max(atomic_long_read(&lrugen->nr_pages[gen][type][zone]),
+					    0L);
 
 			seq_printf(m, " %10lu%c", size, mark);
 		}

-- 
2.56.0



