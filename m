Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D5D606AE3D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TjnvK/YA
Received: by kanga.kvack.org (Postfix)
	id 80CB56B05BA; Tue, 10 Nov 2026 15:21:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3A86B05BB; Tue, 10 Nov 2026 15:21:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71FDF6B05BC; Tue, 10 Nov 2026 15:21:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 533616B05BA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:21:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E76B5140AA3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:08 +0000 (UTC)
X-FDA: 85420328616.26.F9D65DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6194BC000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TjnvK/YA";
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342067;
	b=racwTygfucC+ytqZpQX+IGysTMrvUf6wRFasBZESiLLXm5d7vf523U/Y+Bva9lGPtoT4eY
	Kz8kQ77sNFHtsNlhsR3hPBXyAUXRaKDcWcyqdF3YIVRV7ak6coR5EOjmYiUuPHL3FrbFEH
	st1erBrdHGgzVVqw1lvcp/s/9iKINeI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TjnvK/YA";
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svLW62vkvxW0xvIszMrXeZ8SojWKg92Vr+WIfieUekQ=;
	b=ZXakE113BwhMsty8b7RT/+iegF5J69WgRMaRhnodmNgT25sPUEmGUyx+sPu0XZe494qGkl
	CZgudagTNQ7vvpz5xizVtsbgHBacD8NigJKrDkGqCYasZvpvHWHSbq4UMJLUMs5R7Jdv8m
	Cv0C7t3TS9YXM6GsmUJVlBs1TThUNUE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1D60601DF;
	Tue, 10 Nov 2026 20:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA15B1F008A2;
	Tue, 10 Nov 2026 20:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342066;
	bh=svLW62vkvxW0xvIszMrXeZ8SojWKg92Vr+WIfieUekQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TjnvK/YAvvUg9oKn3idKeHXGSn/xtyNOamiw70cQDIAFP5WSiK2eLBsHazNOvcg9O
	 4JHACPddPsMkjq9uMu1edkXnSz2+0GQow2ewXV7NsjqcQ0+D6Zik7pnPHmbZXoMLmr
	 XwtPv4vDw7lmTX3EYyFc0IvbmOQE/Bv+KwbWt+/j3ePbd60RjfG9ZbFl6erx3HkWIO
	 f+CVKm2qdTCrob5En9s50yZGXulzGCmZ3/5XlrEqrms4yIVd4zFe4j3yuD2jl/Vgr/
	 99O0Y0/tNKoisx0UD4VMoFtx1JqOqpngayT9B3E3rqqFpFeKTvS1ISlW76Rb5lacRn
	 JL1IWyIV4+1Uw==
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
Subject: [PATCH v6 06/15] mm/mglru: return for unavailable anon reclaim earlier
Date: Wed, 11 Nov 2026 04:20:16 +0800
Message-Id: <20261110202025.25736-7-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261110202025.25736-1-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6194BC000B
X-Stat-Signature: rswbr3zc8o1n98fi4jkqg9xr8tuseg5o
X-Rspam-User: 
X-HE-Tag: 1794342067-624616
X-HE-Meta: U2FsdGVkX18qdiqnhkQZYkiSgqzf32DrlilDlnkd2DdXN6eyClkrAVjvV35W1//9PoYHeCibqusyW3S2GfZ22f8SLaqB4Vr+NTrKGEFbRRBnPwYtQ9Ve466QrakkOduvVyW+KSSskoXlvZTZiGNBmb2yDJFk+2T6U/X2Yot/vrxBmeCiBzwArK0yOqqDAAXnYqUJROFe7D8zBM9giKtQXwUjmQhn41xK5vp/Pd6vHvc316daBuHRACQSB+Zmb58q/14j6dss+4YTB3JRiKsXp81EECsBs9fAMNBhOVA46Nq7yffB2VX02FEnG+EPp9lTtbzODF5lBw7jd7uT75umSS3RhY/CacF+L2fTeSGiOR444/JqL78RuvRwD73ZbXkNRZ5WX+xzyqELV5UJEVt3OPK7LAo2PJDVusi43GQyM6Jr4WdrV2ZsrNaRvGgIvdMhV8wAg1fTStPElHwR+m3gL/x9WwYuuVtJyEnti6rtIKRMwG/l855QnN1ib74nPS+AAqDBJjFR/sxvN0sfOViJtWjcad+lMR2DIiX9svX/lKbuP0tJwoLdxuiL28Uu24cifVOr+geoY2c8jdXdZaebRc2abCGHvouCXcxrWs497LKIfPD9wo2FoKMW3URpWey/+Dc6IV+AgCNMJH9sxoDq54pxyIQyoSWL8wTjgELXJfBRu2RC3/VvL+81hGBMdDOtN1oeqi+d7RX0/tIFRmld4lYye4DTYKNCe8lre39dtHusnkwud9YFoGe8nGZ+NrB41roTxXbQiGBVy2eBNOTUN92onvtABYOf9emZ/8tLgNKWHFYcYktBcCQ3+5eLlC/E5oFMgZZQEpJ4Xo5Z1/qLpSPM+7zRIyoeJPzw+dRGITuEuvTAg8XmTZUWtZJBPILXUpQZIRpiDZH6Jb6CEsG03Dh9xHQjhf6hLzPuP+cfgeCSR2nCuWggtnd28rwcT+fWywR0nEMkV3Jz+0T++0r
 mGxJ5Su1
 JIv2Bfi1ABOaxkyrJ5t9BPDjDAXyWRHt2vzpHsLcNInKLENtJlYBQDGTBWUzb/CN7sN47q0DRY0tvJfsrncMAR2a4eHAwbmnw3lKCE4N1fFcN79eepSbMmUv6SCdH+2CeZKLU1dKKpFAbFHgPsfsnDlopGiTo+KVYLsa4pgd3rXdBXtXsHXkMsokoSzOjovtpLxekQ9OeH33o/e4E/W4Fm+GbJGaNTJ2hJZo6dyU4JNVI68m1YNoy3F01Pxt+/AdJeOWO2wkP90/K9jrPkTLM+0qZkjyihcbHtxmRYpKvsOXMqmE/gsd3uw2/3hTidRd0uHj+DyszSGGFj8+14q5QPvml8Dq+oNLiyb8g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

No feature change, just shuffle some code, prepare for later commits.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 mm/vmscan.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6b1670677974..e2807faf26de 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5055,20 +5055,6 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 			   struct mem_cgroup *memcg, int swappiness)
 {
 	unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-
-	/*
-	 * Proactive reclaim initiated by userspace for anonymous memory only.
-	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
-	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
-	 * no swap), return 0 to skip the scan entirely, avoiding useless scan
-	 * work when there is nothing eligible to reclaim.
-	 */
-	if (swappiness == SWAPPINESS_ANON_ONLY) {
-		WARN_ON_ONCE(!sc->proactive);
-		if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc))
-			return 0;
-	}
 
 	lruvec_evictable_size(lruvec, swappiness, sizes);
 	evictable = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
@@ -5121,6 +5107,19 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
+	/*
+	 * Proactive reclaim initiated by userspace for anonymous memory only.
+	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
+	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
+	 * no swap), return 0 to skip the scan entirely, avoiding useless scan
+	 * work when there is nothing eligible to reclaim.
+	 */
+	if (swappiness == SWAPPINESS_ANON_ONLY) {
+		WARN_ON_ONCE(!sc->proactive);
+		if (!can_reclaim_anon_pages(memcg, lruvec_pgdat(lruvec)->node_id, sc))
+			return false;
+	}
+
 	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
 	while (nr_to_scan > 0) {
 		int delta;
-- 
2.34.1


