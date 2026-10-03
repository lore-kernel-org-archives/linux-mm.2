Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B0C8CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 12:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA28E6B0095; Sat,  3 Oct 2026 08:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51C56B0099; Sat,  3 Oct 2026 08:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACB096B0096; Sat,  3 Oct 2026 08:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CE416B0098
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:55:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D0F0D408AE
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:21 +0000 (UTC)
X-FDA: 85281310842.02.CF8883B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E9191120003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FpKBLksb;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791032119;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4DXuE7Z11TwcfY2WwFPglaSTeuWeaePgUEMKahLPms=;
	b=Z/jo7+H+j0w4gK4iS4GxDPTre2e0hZnXu8WcfVv9dQhzXWQzZu/xTosUsKqy7aMBdrOVR0
	KufnC2fOolykc3KqFcyu3227/zWFOc50NnfUVJV9Pi7KTQcW2qoH01jwx3CkppSwCP80GB
	uMxKHXjgBlJgvqSxqhmVe1nz8MNzZYo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FpKBLksb;
	spf=pass (imf29.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791032119;
	b=tFQKa7iScD5DKKf3SuW3X6Cp591yEJgWNEBGK7jw8KsmIrAOLILz7CNg69hFKnaLQ85TzL
	IrvM11vFu77OD5Bt+xtkaxUFWXNgYwJGHrfXL4zbLAPVyVBB2AIaRRoBgjHcBlWKP6Hof1
	N+iF2chL7uuDBKsBetKcWWsiSJ12JsA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 409CB60D97;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96A3EC4AF14;
	Sat,  3 Oct 2026 12:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791032117;
	bh=ZwRfJGeYorVQp6kFkHNhJlnr2SaJ/kTJzJXIHoY16SM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FpKBLksb1CMixpnMfHp4IrP2ejpQZKOpQ6MLj6RBWMUBvJhfqjToPOXr/fV6IHgp4
	 sHF1fId6qgAv6FhwrJG0JIP/KDQmijVQNl1Kl0L+JzTHlg7clZVz7zIWN2ChVPVLFm
	 lxY+sv/PL6bKbZ4HlpAcdlQLsH0NzMQLmwWAlefAsYfhclz2Z/enYsMO6iSDYenwmr
	 YudS1fFu53+NxSWeI0X9rTQJ6BIhmgJK9Rvs+1lnTE7Htmypft+XmZ75yxxt3f+x0F
	 KsqAgcN/YTf/zluTe27ObJsUQJ0DPh2OWF8vKCMkY75Qul5Q/Hr8cPzWZNsi8EUKFN
	 P2Q9dND8F35RQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79152CA5FC1;
	Sat,  3 Oct 2026 12:55:17 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 03 Oct 2026 20:55:13 +0800
Subject: [PATCH RFC v3 02/17] mm/mglru: make generation page counters
 atomic
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-mglru-fg-v3-2-cbd4546a5bd9@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791032114; l=5649;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=LsvOmT8QvQhKT9QK4YBLMm6hqK8Lr2UAJKEBLk0kMFQ=;
 b=xaL6rSpv5762wjoEvdL3LNQCyCuThddbzMxDdFYsGyrucgUEISneHQWj+0b7WvifIevzLWctJ
 W6f0u4XGjg7C2MZaGDLcduUQhYO1pLeL2lUcORkUHoxqZic70/+e5xT
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E9191120003
X-Rspam-User: 
X-Stat-Signature: systw96u8yg7kygw5xetbh8y3ksjb578
X-HE-Tag: 1791032119-838176
X-HE-Meta: U2FsdGVkX182x/TJP9/6+D2JDNtLQV3HO8fYodAl9xE0gykoTf519n3ZOzSAX3KOR2qpRF+ZGW+cwiGy/xKcNh8IEA/gRCAfs4C7oSmse5zUy/wCqUTzNwBoi77rk89sI54jEW8IWzqshkTm7UsifXi8YLe2UuuSp713L/TC5zdMI5Pi6Z+kNt3TGY9UpLKY6FvGkmvSBdztfPRWjhc1dV83Et08ceCLi0H20UqzlUt6l1uukIGbMFAdOoy4FZZ4NBsXlSqF+0ROBFNzliiX7Xh4qh+qNnoPMU96g63AHOImrL4TsS9XVojlNzbThV05oHf3EnItfTI81xTeoKHbhhuHcCzB+dNWQyvOzPK9WEUxfOQh2ArNgeNBk0Dpf4kp4UAmb0zN27j6S6fj1QCVVtk5gVFfGJo2wknFE/CPscqVEAoqe7nybORKGlBjkWTozyrsXJYcucNEuqrTxahzK4bmxkFBNFcgy3ncjd+CLF7qnWleklCNnhefni/ovj2f09Ot9GIl9BOPQlfvFgVQwn6T4NHAM/97Z9dQXzfPzv0J4jZ9eTVWtRB8cBmt8STDx+2CvENLIvvvmnW0iz5Vq9LwXDYuCA/KxzukgOQoqjalDD/UIw/eMgKrUfq8cA7ubUpIQZxxTG3uPwulGYBddgaVUkJSD7KcJ9Tdu6JYRw4/AroYNEnpWnxnJshqMpb8rvxv4c+CZb8D+GLrHggh+bnyqiONtu5DlUBLgsB7xqGMLbfhkc/N5s2tDQ5/pDSVeta9rouITtF9SSV+/Uh63fqTHkWbKo+BZnjctkXk1Cqad82iObgBXP0qRAph190P0w8v/wTfrFU2/PJpKos+3V2Yoa/4y3/Kg31IOrmimROnV75T3h4UObvLpGTX5Ud5C1mv/Bg93GOCJvVwHqkEBsk0fb4rgXvLWbe70FUSSkfBjG+PsHPudLPq43GcBFTeC9BE2kdVIgl0LCpITdX
 pjrB10Oz
 KtG5yEkwfHvkRWhR+3jaqy9mjc8+81l+W9NPf+VYFWCDr2HKDZJl96BjbiNyupNVxJDeMy4aQV6NkdLC9k2mD8dMCWol00ZpOWfsDt7aFlWx4idCezuE8v46t6Q/8L5ku+CkzwaARrWkAvLIWxqqFtvlWNxkBDNEblFu7VsqnrRQ1Mt0PcWmJo8WgYqEh2eeUK96OkwS6bA7sWBuS4i8m5GHOgCmRizwjzR6OuvA3XIhFx/4U8KwwFiJBFf5BYXy5cpD6oYUszWgkIM/JQkcrgMSLsOw4FecaXlrBjysdLphOLEg0e0Qiccp5s0zgJf+Cbj5McgomqfRUimlpcjfSwCc9zZYIW4HvhXY19dz9klMTTO1UD0oOd3X/mEkxktsDm4mtAjFWiR4CI0A0a7wbrfotak+LKX0TE5xfCaAUCh0va+rwMr2RmANXHO2RZXZ1pm2N
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
index 91295070ca33..0a29dbf9fa3f 100644
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
@@ -4117,11 +4116,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
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
@@ -4226,8 +4222,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	for (type = 0; type < ANON_AND_FILE; type++) {
 		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 			enum lru_list lru = type * LRU_INACTIVE_FILE;
-			long delta = lrugen->nr_pages[prev][type][zone] -
-				     lrugen->nr_pages[next][type][zone];
+			long delta = atomic_long_read(&lrugen->nr_pages[prev][type][zone]) -
+				     atomic_long_read(&lrugen->nr_pages[next][type][zone]);
 
 			if (!delta)
 				continue;
@@ -4345,7 +4341,8 @@ static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness
 		for (seq = min_seq[type]; seq <= max_seq; seq++) {
 			gen = lru_gen_from_seq(seq);
 			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+				total += max(atomic_long_read(&lrugen->nr_pages[gen][type][zone]),
+					     0L);
 		}
 	}
 
@@ -4765,7 +4762,7 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 
 	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
 		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
-		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
+		long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);
 		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
 		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
 
@@ -4773,9 +4770,8 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 		list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
 				      &parent_lrugen->folios[gen][type][zone]);
 
-		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
-		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
-			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
+		atomic_long_set(&child_lrugen->nr_pages[gen][type][zone], 0);
+		atomic_long_add(nr_pages, &parent_lrugen->nr_pages[gen][type][zone]);
 
 		if (lru_gen_is_active(child_lruvec, gen) != lru_gen_is_active(parent_lruvec, gen)) {
 			__update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
@@ -5855,7 +5851,8 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 			char mark = full && seq < min_seq[type] ? 'x' : ' ';
 
 			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+				size += max(atomic_long_read(&lrugen->nr_pages[gen][type][zone]),
+					    0L);
 
 			seq_printf(m, " %10lu%c", size, mark);
 		}

-- 
2.55.0



