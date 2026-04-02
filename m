Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D10D6AAF9
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 531466B0095; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459396B0096; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7A46B0095; Thu,  2 Apr 2026 14:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 019566B008C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:53:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CCB6114085C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:44 +0000 (UTC)
X-FDA: 84614514768.19.2B326F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C39651C0003
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:53:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m7571P2y;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775156022;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80l7G9HqcO9QO1QwVtrY38+Qx4dX+Um/VFNib5/fNWQ=;
	b=QCjmfGqFKUokFlvKBKlJA6LK1j5Ji2E21U6kBWPoNYJbw/W9xWlbwlC1dZK1KrGZhk/AmY
	6okGZugOKKgNlnt5jSMNZgky1tn1VwuzRuoQCGncsgUL+G7hsQ9SYGFIudOJpFPFSS3dVU
	fjpyTdOQUPaBCC70iJUuTFqLV3HXAn4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m7571P2y;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775156023; a=rsa-sha256;
	cv=none;
	b=08MROK/c4DhxktASBB/5UKju+ttIFvxJRHthTfqzynzEdCiC19i5FVOL30jOMPFD7BBOPN
	8wnosXErIhEK0TKaoMdDS6kBnGfNVF2h5N0UFX7odNHLc+ie1TOksddeCz4T4bqNwDxzls
	VXd745yOGtpOw8LGsQbzuvi/G/twts0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 66EB144237;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25D37C2BCAF;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775156021;
	bh=pu/4aSrd7KSa0bxFp6wbeBj72fjrUtTNvGBmWMpcIZ0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=m7571P2y00QevWVbuV7/Y4W9iWXwf0BBNsgFp6Xip5qVAkHcvVioaALVPtuh6PfrJ
	 SdeVtjCm9sbx+/f9LwQruGe51pbpsbrM4bde8dUQ+PqKIoATtJJgSYIl3bgzF+pRTJ
	 OCH0JGE6gpIodKzLS7n9h0pg0//uFpURAf4E7KPbG66f3wEDyM6SeJqkNSUsWPWNh3
	 ySmchgTLPpXu5TcbpsBM0UxjXmOan3sv1QGunSMDX1KZV0isnu1XOai9YR7nU6u+vo
	 WhkrRRnKNP3fLRC3PrggCoea5Q5G8sDo7fyT+VJocEQAlbnuPAfqd4vigkKJTcK+b5
	 hHl/r/zfp3nmg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ADFFD6AAF8;
	Thu,  2 Apr 2026 18:53:41 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 03 Apr 2026 02:53:27 +0800
Subject: [PATCH v3 01/14] mm/mglru: consolidate common code for retrieving
 evictable size
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260403-mglru-reclaim-v3-1-a285efd6ff91@tencent.com>
References: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
In-Reply-To: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775156018; l=3179;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=lovGNHm1LZYPq5LXk6kp/WVa26J2TdTx/242vg8RH/A=;
 b=URh7Mqe3jKmhJPz6rFFWysHrVdbxBs4LBSBylx8UBXj0H6es/WNz+eCO20qz09X3nbrdpG4lj
 QWuNUtc4ovjCIzjmhWKTa/Bj1ph3lntXNkCtGALz4CsfcWpSVmmtZsO
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: C39651C0003
X-Stat-Signature: at3dytc9fpgdh8x9ddgehh7pjakjyyzu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775156022-775627
X-HE-Meta: U2FsdGVkX18FmRmH9SR9j6die+SNNy9mgItpJdtUPCw7rcFo5SCxyoVEL4nD5mXBqNwHzYPonYWYIg7Z9/d8+u8BxCLm7Z2Cdl09aY0WrVVNYpgRPUuF5skjqeCKfQRuOoICnigbR0IprAHkZszH8buM0fLsoPJS1hIOYfUHS8kifWT3/eW8OOgyyZoLUnL1ctQX+Q6LTLM9WAAPIgov2BeHK7UK+FXV76MK6/YfdLJ1B1gkAhrr9hh9Vdbx/HstMGwj9+TSWWnvBh82pJh61s2PDzVNK6v7NB4ey0UiJyDa//NGjWsMdNu9/lluSES3e6rLv7VlT2tT3zIX88eNekGXW8SHkKLQNq1KOgvHXXy2ybKfYTMBbZVMn3xbqXiLaHn951VLBkKO1WC2f2pYzYpR2kYAguA1i/SSMtlgwqZfxGeZvXKhCmR2UH5djlEeqh0sc5QW0FeGTeJVtTKgiS1UaaSkYY7/5kUQfdzXkCQQBWexID5oaAViCtWdlSuYn0Dv1/feqms+aEFPJG7ofFlUbLUIbuqSxIoYMUK6rt+TvfDKfKAawgNKlU51H5vdgdYROyo5XDel+oNz9upL1j3MBY6NXZ59jB/NrHyr2OhypS/i2CBE9SwV5tMDgpirsVm8VcFW8orLF8fKstlUbN140li/a98SaiH84MTM3doRu6JYpJtDuSbVidSKaKQsm+xkku+Zl3FxV1OfzIOIubLyuyEiyY4O8i8h2Wcvn3/JxA78R2dSHPcD0YhmVxxPD7tE4y5H9jR8DPjV+yOrd6NQThTkE7p3UudR0E6u8fvpXHGuxVmZ96dmuJAGziCbEKoKdc4Jscz/OnEIDo6bw0xnjH/i0/2JyXBMBoIka2Zx18/jCmlIS3/Z1a8XxQalix7XM9XsdENDFbGcBm0qMmizcXA3RAu/+xHXY44UnEV857z65mSw2k6IBNWfSXpwemyManxufZnZF27Zde4
 Qjt2ChWq
 fMPC67jJJkgXPyOlHuVmbV5D+Z5f8SpY6Pdt8lwirtbAxwD1fbPeQwyoLUwAXhaHlaFE5XXLKk2pK3bSSMFb8TFlcyLj3wbdxmbEAZGUHHuuIgsMTiXhPLa5IeR/yo3zDW4E0DzZX83IlSfqHSFyX9+z4JKOBlq8tTxWC7h8/Llv1gsgb+hgx+0tF2Mwree7IOJWD6VtCp1euUDK7ArpE6u+H+i60ryztV3glEoZlb5u7mbmOApXfrik5GCEk7Q9zswnRQQeogJTxq8PkJF6IJDFuPtoB0R465Jx8LB4pYABRqHoNwENNXJjpckf/FgCeJ+ER1ntRsSE0KmwCqmroJKDlXrXzq53CG7mzNZgzm13qaPu6FcltkRCLHkgiSv/2Tdqtb4fuHPOdRSP/bEhqUlaUMYI0dptVGJHC+KkFU8MZ6hKn0pp3wCZ2mIJLhmy+LyvC3SmSoGs66pUvqMwTEhYGPfJad554La9OBomRuPcxpBqYGq8VwkBAz8larfD6cjqfUnZiRdpDx2vfcxMmmUbbbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Merge commonly used code for counting evictable folios in a lruvec.

No behavior change.

Return unsigned long instead of long as suggested [ Axel Rasmussen ]

Acked-by: Yuanchu Xie <yuanchu@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5a8c8fcccbfc..adc07501a137 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4084,27 +4084,33 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
-static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
+static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
 {
 	int gen, type, zone;
-	unsigned long total = 0;
-	int swappiness = get_swappiness(lruvec, sc);
+	unsigned long seq, total = 0;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
 	for_each_evictable_type(type, swappiness) {
-		unsigned long seq;
-
 		for (seq = min_seq[type]; seq <= max_seq; seq++) {
 			gen = lru_gen_from_seq(seq);
-
 			for (zone = 0; zone < MAX_NR_ZONES; zone++)
 				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
 		}
 	}
 
+	return total;
+}
+
+static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
+{
+	unsigned long total;
+	int swappiness = get_swappiness(lruvec, sc);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+
+	total = lruvec_evictable_size(lruvec, swappiness);
+
 	/* whether the size is big enough to be helpful */
 	return mem_cgroup_online(memcg) ? (total >> sc->priority) : total;
 }
@@ -4909,9 +4915,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     int swappiness, unsigned long *nr_to_scan)
 {
-	int gen, type, zone;
-	unsigned long size = 0;
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MIN_SEQ(lruvec);
 
 	*nr_to_scan = 0;
@@ -4919,18 +4922,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;
 
-	for_each_evictable_type(type, swappiness) {
-		unsigned long seq;
-
-		for (seq = min_seq[type]; seq <= max_seq; seq++) {
-			gen = lru_gen_from_seq(seq);
-
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-		}
-	}
-
-	*nr_to_scan = size;
+	*nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
 	/* better to run aging even though eviction is still possible */
 	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
 }

-- 
2.53.0



