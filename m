Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7926ACCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:04:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45D216B0095; Fri,  1 May 2026 17:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 434DD6B0093; Fri,  1 May 2026 17:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 324086B009B; Fri,  1 May 2026 17:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17D706B0093
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D3B311402A5
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:16 +0000 (UTC)
X-FDA: 84720078912.17.AADD6E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id A684B1C0013
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lEMAmBpw;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669454;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pKOE0uKmS9/jPdIJtHxOhrH5CvFIVG2MCRCt7wPf0/A=;
	b=k7xjma7AHwG3nx/K6lV67nfRDLUK8GGjz1u/D9UTcFfNKEuzmQ5+cnoCTZQFisVTfHOIO1
	gG+YdCl0wzqAHr/owQDwk60C54XvfhP1ehrQVFpkOK2o6SJF22T1NMYGpAGaxgjhy7vFZk
	oauaUHuFGIqznoo/FpGdI00QfWAuitk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lEMAmBpw;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669454; a=rsa-sha256;
	cv=none;
	b=zeI2pQwBXiSLiaJGDm+p3XfZKFvDrLAOnDKu8ysldMZ7LqGkP1hmnG4dDkt+wgovEA/5a3
	OG3ryKOoSs73225MFEjd1uQu6Befbid89Hj4AvDsZRd4I600DkSNBwMWTJYmjt2qPZByBn
	qN3zDNoHOxavYh0Ee5nq0cTk7bRmoCE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B87944570;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 585DBC2BD01;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669452;
	bh=jmvg4ef5qUyTqHGcbdIbJiby1sIH8SV8blDyMOM5pJs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lEMAmBpwinUPOn+VOa+VxZQccVjhzOCi2jxDLmzY8AWQSOp7kQ6Gxxowwb9gGocCS
	 qMM8PA8rtEvRauTjYZoq9i0Ju9MaujRSD/WKLrFTOKLa9E0a1oM6815wFfp4U7OjGc
	 HBZpdEFB3fA6KX39tbuKhHnxC3mGRqP1ff16oCK8xTCe4EhL5vGLtOh0psv2P3dCXV
	 BoIAfzDu6aItQaLsk6Zq30+srTO8bBkw3qJ0GxGHKFkyTasPvZczux7GnKbY3kygR8
	 MHUfdjCvknaL1bqdeYoBu2d3NKdSsZF3law98bIs8Ce0PmCEwgznn3FhlaSy0nCYfR
	 vhKC1iTda4Qwg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC53CD3427;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:03:51 +0800
Subject: [PATCH RFC 05/32] mm/mglru: make generation page counters atomic
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-5-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=5037;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ANTm+1uGlwjkYEz3d0r4O5bWVxUXbGeSOOlpFXDQZtE=;
 b=6f8SHaIAMJ2FbcFM8OPiHetkk+iOjEr7ZTqQSex6tvBYvhrw7VFABVnSnuDklt2MY9OcOWzLH
 u8dQtyGdgMGCiVN6bTI+xzsJUmC67F2zwSdZ40u6ye9d4hfp6B7q05g
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A684B1C0013
X-Stat-Signature: pnjq1u1p8bjzrh5w9da7jt555kt8spay
X-HE-Tag: 1777669454-552859
X-HE-Meta: U2FsdGVkX18+TCVBT43+vt20+ld6TmfvJGyrfQvRJ8t73J0ll8UafCqvmWqE4sy//MgU6Fzu+fABzKmCt7kCLmIjdG7aPMDt99VuUVMfGqzv2hgBwRZ+4kNduxI8GfrCuVTtS8RKRoRjSWYRgCKh9/FOiLuX80A6F41e0ku6kGbpsY4D3x626mb7uw0PVxAT0cVmFGJvLYipTJ+AQveJIQgQ2EZDEh6wW08Mq2h5bpx4bIoMUGB7wCM9ip5ADOg8OPcsEKWeuWhlgmdJZSLWDnxcFh315iyC9POoDiR8Zwc5eTnqkFMK5syd6edivNEvqRj21aBRSO+YMnzjzDJbFkHBPsaGdL7HyX+5kKkQh+4yhiw7WuliLbPfeGhK3z1zAQXhhAOxatmEm5gZEDLleh4Oki4LKIz6OyLrgfJoZQ1TN6tH03FRe8UUzp5Y9BLmCRJtg+2pXmT8amrqQkyCWgoukQTK5L8b0tTmk4KONkgSqr7L3ot7hfPZqNDt6FZZ0VALxpUqlUBmCAQE0yNJNvTSLu8jth6mFSo8Js4wD0bvGmux3G15Z8HDOZcKNAEa3yP+m0WvUXA6809Pwy/+VGJyABF/6oJIFsNZaBS5OWvvgLZZQlFSnkGS026N73K1FmdJQC/2oATO0gsSsMcpGxu1KEtARQpGZuSRxLzSr+KjHrVmLx88ZnLqw7Hyq5K1po1zusdww+9JmRGIRRSITBcz89mNtyKBgU0IOis/D10P1Es2Q0Jx5hYuXgm9ojHtz9x7cxwUUyab+FbVbdkyYbqrcMIDPJxNo1iEc8aJ3oXNI+9a76so2x3B58377S8qhjhBgj/psKhqlHiRV1oX6iDBZt6VpkqoDuC9tIGLbYV8DBizewCY7t7f3QTGjRnSzAWn3jxf/ywa+64S02JUMWDMWjIIM1HcAVg34MYPGEZRF/1q4NuCVUjQ3DKtTx8wg/+11ZGjI2mwRAXe72t
 wOb4YGJs
 XoxZUQ2xHBUXWtYMtuMdJ1AYMHEaVAjOJ61ZATHpifeT2/VzDR0L7GRBTgHkh/Qw9BSoTjtj3CTkLpoiLp+bcDZPvwM63fK6NVn0ZF3CDzGYIJDpwhSDroFwIeYcO1jh9p1cL7RtFK62yJ06aQ6wsB+KMFbmub0xWPKrECK0SIYqH/g2ipG7JLw1TJ/Gprr+KTR3qCr4yg78JXMMLiL/cNQ7zxYzJI1X2M/ZKh6kuAAFsn0C0Sf0iJT+Ef79m0BwGusifX6i+mehPJBF1zs4l6Jl4AAySrzcZOgxD0AIr5K0kiIgIAZWXf/5F2XUbHqiNO7OaZ6ww0EYyXSEB+IJ7hIRBkJBocI9M0+4QKNH52tITeGODIYc82dkuWYiiEbv36Q9OkNbQnW1YvEHAk7U0O6fdQQ==
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
 mm/vmscan.c               | 18 ++++++++----------
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index eade9f2d6afc..8a3fb357dc15 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -245,11 +245,9 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
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
index e4c51961ec27..721d0db8b0f9 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -569,7 +569,7 @@ struct lru_gen_folio {
 	/* the multi-gen LRU lists, lazily sorted on eviction */
 	struct list_head folios[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* the multi-gen LRU sizes, eventually consistent */
-	long nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
+	atomic_long_t nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* the exponential moving average of refaulted */
 	unsigned long avg_refaulted[ANON_AND_FILE][MAX_NR_TIERS];
 	/* the exponential moving average of evicted+protected */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2ca1d6d80259..a5b4750a5028 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3280,8 +3280,7 @@ static void reset_batch_size(struct lru_gen_mm_walk *walk)
 			continue;
 
 		walk->nr_pages[gen][type][zone] = 0;
-		WRITE_ONCE(lrugen->nr_pages[gen][type][zone],
-			   lrugen->nr_pages[gen][type][zone] + delta);
+		atomic_long_add(delta, &lrugen->nr_pages[gen][type][zone]);
 
 		if (lru_gen_is_active(lruvec, gen))
 			lru += LRU_ACTIVE;
@@ -3971,8 +3970,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	for (type = 0; type < ANON_AND_FILE; type++) {
 		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 			enum lru_list lru = type * LRU_INACTIVE_FILE;
-			long delta = lrugen->nr_pages[prev][type][zone] -
-				     lrugen->nr_pages[next][type][zone];
+			long delta = atomic_long_read(&lrugen->nr_pages[prev][type][zone]) -
+				     atomic_long_read(&lrugen->nr_pages[next][type][zone]);
 
 			if (!delta)
 				continue;
@@ -4090,7 +4089,7 @@ static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness
 		for (seq = min_seq[type]; seq <= max_seq; seq++) {
 			gen = lru_gen_from_seq(seq);
 			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+				total += max(atomic_long_read(&lrugen->nr_pages[gen][type][zone]), 0L);
 		}
 	}
 
@@ -4525,7 +4524,7 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 
 	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
 		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
-		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
+		long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);
 		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
 		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
 
@@ -4533,9 +4532,8 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 		list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
 				      &parent_lrugen->folios[gen][type][zone]);
 
-		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
-		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
-			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
+		atomic_long_set(&child_lrugen->nr_pages[gen][type][zone], 0);
+		atomic_long_add(nr_pages, &parent_lrugen->nr_pages[gen][type][zone]);
 
 		if (lru_gen_is_active(child_lruvec, gen) != lru_gen_is_active(parent_lruvec, gen)) {
 			__update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
@@ -5555,7 +5553,7 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 			char mark = full && seq < min_seq[type] ? 'x' : ' ';
 
 			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+				size += max(atomic_long_read(&lrugen->nr_pages[gen][type][zone]), 0L);
 
 			seq_printf(m, " %10lu%c", size, mark);
 		}

-- 
2.54.0



