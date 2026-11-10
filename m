Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79067606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbrug8Xl
Received: by kanga.kvack.org (Postfix)
	id 7BED46B05C6; Tue, 10 Nov 2026 15:21:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796266B05C7; Tue, 10 Nov 2026 15:21:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2B66B05C8; Tue, 10 Nov 2026 15:21:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A1C56B05C6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:21:45 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C8FF6A8652
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:44 +0000 (UTC)
X-FDA: 85420330128.13.15522FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 25461C0003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bbrug8Xl;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mj38FmKYhvqiRaBM262V/Sxj/aA72yBpxP9txaZ0CNM=;
	b=6TRKYrT7QnHQEKUJg6QPZew1MgI+nXT85en6TJ2q068aa/vzQ86bbVTV9sY7f9d03X8aDM
	lVUMrYaaeaZ6po5lz5j+EhH6DGLmwBVTKouZskPgWC1oCYUNRTCv9kTeqWsMjJP8WC/cJm
	Jm8eqk4xvCNN6tG+zOj7dHwTtKw46no=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bbrug8Xl;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342103;
	b=SiC8kXEYndRsopkqzDKNvc6HdJETYw7yR7RqN0RF7MNsZTPzZps/J4TUDCeKmm6nufV6W5
	RYXgtes09S/g+gSTH8kphFXlrLg10hcD36S1UXl+5zTZ8pCw8J54IxgpkVNVFsNultCMKT
	tCNVwjMaXO0eN3Hj+qkY46vYkaUTiZg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 761F44389A;
	Tue, 10 Nov 2026 20:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD871F0089F;
	Tue, 10 Nov 2026 20:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342102;
	bh=Mj38FmKYhvqiRaBM262V/Sxj/aA72yBpxP9txaZ0CNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbrug8Xlpt4l/RuemKutlMDaV4lVQoYOYwHxPJAfFCtKTNR+7sZDRH78wm8x2QRfF
	 fTlMidfAt9Ru6P/It5lcSjGVfZZ0rE5/Y/adp8qvAtpFcNaYS01vHyalxU34rIKlHF
	 zHRsRE/BqJKpaCFEMJAlUk36Im4YSqxnZIqWHX6jhgDyGscBnipb9ZAgB2DxigiE8b
	 Q1DIKGDVQ1+FanO0tF7JyaxWN2W9Xc753KVpp+6vpU+QC1rZ8rPDguma1zU/tBy6Da
	 96bzBjJThDxQp3rQlIUjjFPJzCQM+V0MYF8oyGjauz5zcMjGGjn3U6QTmbcDLi/z6b
	 1YooYkBpK+d7Q==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	Barry Song <baohua@kernel.org>
Subject: [PATCH v6 13/15] mm/mglru: Avoid prolonged anon reclaim with swappiness=200
Date: Wed, 11 Nov 2026 04:20:23 +0800
Message-Id: <20261110202025.25736-14-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261110202025.25736-1-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1h5f4w8fddpgwfbzd3qxu7c77kw3nzdb
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 25461C0003
X-HE-Tag: 1794342102-377882
X-HE-Meta: U2FsdGVkX18BqixQ1afhL/HsXjPBMDH4SqLR8tnm7CW+eApBQ7CwJfypVu7g0Rmyt+zlhoqYbfrRajGtUI9+LBWSyZ0V6Q10cmhrAr6p2v4rKzecgfOSA3VO+U0S+3b9eJ8CrvPeLXFkGKphRMgO/VSIiKE1besClxWtOJPJXrr7YX6OxqNt2TO/LohbiXIC7ZJe1qGZYHgaDreBI2iDHv7dk1CkcRxC/QyRpFoPY51sUDPlpuDGsaLPv4UC7FTBQYfE7s/2KVWoMbZKo/Cyk6x2j9PNUqb0VjI5gZfweXRL4MmByLuCKw/NYyw8QD5DqGVjrBnUK4Ua6kABuJvktFHuCRoSTFvC19v1nWduLTZaL10ha/aloqfD69MdjwCPKslCH3TU7WTwbv45T586K0CSbthO5G+Jt5nL+H+0DVp20csU7gV8o+78Vx34Lq2lbe11CQivd1Nf4uean0+pYew5kSog+7RbkSVAOhOMbrQS87VhYypUR2RiONHk9BscoQl5GeFxpCM535eXogGxwf3Tw7O4GN0KsQ7NV0wbkPoJCBVQarThtHCuJ9UPH550u+nbNpUG4E0prXHr2qNngeSgjDQD6O1m3lVbbZUrHTOWcsaBO7VxSs9vgtE0ACWWoOHCBKieBeDH4XwXEMNVctZz5waz6ZZDI2LxTNkMQyp5KQT9Nnr0PZH1dJJ1x1FWNH1kM8G2H6hWb3XIlu6cR0jjgrFbZ4OcCIHLmRAg7w2edLfodk66wSEaPrgoGt6d3A0fsUrh8OF7+5LyTDw9j8814GiuYyPZbknsvfBmTcnqlSIq2tR7uOJcOEON2+RXu/J4FbUoHia3XYMPvIZgL45EMqEKTJXvIfJSl34PhtO/VWQt5xjDT0yxahjT07siRc01laCM1jDR0Jj3/+nhU72BkaLxtNm93LWNz4LQIzCns7iaT8imy4vtWI9zX50v4g2O2OsXW0Bl73bt/YZ
 PYeezeTZ
 d+/lBPiR5ttwSNNTBFyYth7it9FJI7Nzqyww1uWbZcZVzzhSpNTLDCg0CfHEBlvmtZJXqD96mF4BXHGv26BF/eUbsxKUUvYHXg74scNRZObRRi7+21XJBALQBFLRAeK+UGYavvKm2swc3OyewiFHB21VkVDzEm47skUWAbqxoVjktharfHBDJzh5p22GSfvqbvAuvNKgo8bT3d4HKKOU/lwU82YsAkXz9/Dmj/hmGq18E0CxPlaZIfcZjx2VNVS8J3OUOyUDZXhs9sNFn8Qs8bARdbl48V5I+dOYf0PEuOIbgQ/lF0fPQaDXs3TMaz0THp3cG5NzJ7z4EJ+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: lyugaofei <lyugaofei@xiaomi.com>

It has been observed that swappiness=200 can significantly slow down
reclaim on some machines, with some workloads running 3x slower
under MGLRU than under CLRU.

This is because swappiness=200 currently results in file_factor=0.
Give file reclaim a small factor at lower priorities, for example,
when sc->priority < DEF_PRIORITY / 2.

Signed-off-by: lyugaofei <lyugaofei@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 34faabe617ae..5d6fc5d4d761 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4888,8 +4888,8 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
  * We don't calculate the scan cost, MGLRU uses lazy promotion, which will
  * cancel the scan budget natually.
  */
-static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
-		unsigned long total_scan, unsigned long nr[])
+static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
+		int swappiness, unsigned long total_scan, unsigned long nr[])
 {
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
@@ -4946,7 +4946,12 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
 	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
 
 	anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
-	file_factor = (u64)(MAX_SWAPPINESS - swappiness) * refault_rate[LRU_GEN_ANON] * file_weight;
+	if (swappiness == MAX_SWAPPINESS)
+		file_factor = sc->priority < DEF_PRIORITY / 2 ?
+			      refault_rate[LRU_GEN_ANON] * file_weight : 0;
+	else
+		file_factor = (u64)(MAX_SWAPPINESS - swappiness) *
+			      refault_rate[LRU_GEN_ANON] * file_weight;
 
 	/* Cross-multiply the ratio above. */
 	anon_scan = mul_u64_u64_div_u64(total_scan, anon_factor, anon_factor + file_factor);
@@ -5137,7 +5142,7 @@ static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
 
 	total = apply_proportional_protection(memcg, sc, total);
 	total >>= sc->priority;
-	lru_gen_balance_scan(lruvec, swappiness, total, nr_to_scan);
+	lru_gen_balance_scan(lruvec, sc, swappiness, total, nr_to_scan);
 }
 
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
@@ -5880,7 +5885,7 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 			return 0;
 
 		lruvec_evictable_size(lruvec, swappiness, nr_to_scan);
-		lru_gen_balance_scan(lruvec, swappiness,
+		lru_gen_balance_scan(lruvec, sc, swappiness,
 				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
 
 		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH))
-- 
2.34.1


