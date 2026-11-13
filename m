Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B906607105B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fprzCg4D
Received: by kanga.kvack.org (Postfix)
	id 97E856B05BD; Fri, 13 Nov 2026 13:56:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94DCF6B05C4; Fri, 13 Nov 2026 13:56:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8153A6B05C5; Fri, 13 Nov 2026 13:56:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5729B6B05BD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:56:22 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2FCBA025F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:21 +0000 (UTC)
X-FDA: 85431001362.29.B67183F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 23C5940007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fprzCg4D;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596180;
	b=A3EHR+OSwsq8OGqGJfh86p+HGZmpVRJpkrpnGFds+nLaaSFfjWN+eLiLHcI2Ir5nMAhYha
	MpenXh5nq/DthayKtA+aodjv2AeXzazCHckfZsKlo9Bd4W7+I50ufGg3MXDT2CEVUzjrNW
	L++X6OeTWVHRvqiAlFHF+aUDFGOr7zY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fprzCg4D;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rbf3ODCn28ZF0d7+U04laU0GN4Tl9A4x506ilfnoj8k=;
	b=FIET9A/KOux8x4t7WEMzNoLq9xgEnaVpOO6LZx6fnylXY1C8tKnXup8qKQBssqIMS0sCua
	crv4mElzIj6vv9RoND0yrg9ZJEShp8L6cYGgg0VkVpKBwEp7KxMMdv7N+B7VGOV1LmPQdw
	EDu0jbvwQV2bEfWj3Rc9Z4ENberLmGM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 72BC143E83;
	Fri, 13 Nov 2026 18:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A004B1F000C8;
	Fri, 13 Nov 2026 18:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596179;
	bh=Rbf3ODCn28ZF0d7+U04laU0GN4Tl9A4x506ilfnoj8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fprzCg4DV5a+sKOrvMCSEHUHYXDixSlpUtiMZ3iT9aOZBMDTTzIxCg09st2uD7QMo
	 /DyhKM+9bkRtkLPibys9L1bMVZ4IXNfo0/V/C+Tak0UK8qmIW2jVzTZPyGtPREtbTw
	 paSdghLTKcTTtyxp6bjJHw8o987eVwIDium9roSWRcaZasNCtHE8pEZ3DhM+fbXz2S
	 tHDPSDn7fkTbij1XUvjDLqzcjUGAa2YOTOyJeiU/Zdmdb9V9kUdLyAPJpJcX3jM3v/
	 KK2YQi7HATCfkq8iTMR7GDcBOOJVymn2eiW1dzR1BdCR2gczsTCkxBLDfQwl/XBpMw
	 QehrS2DTFB6Ng==
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
Subject: [PATCH v8 06/16] mm/mglru: return for unavailable anon reclaim earlier
Date: Sat, 14 Nov 2026 02:55:31 +0800
Message-Id: <20261113185541.70203-7-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261113185541.70203-1-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bdgne88rr4twb9kdo1my8xrar9h1odnk
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 23C5940007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794596179-414764
X-HE-Meta: U2FsdGVkX181UqrD6fBOcXIozFWcvH1ai34np8yS4zkcUjq5grU+Nu/DUntRTWVO3LK4wQqMNsvFu0twQwL+CWxi86neyLJkqLgj4Jes74HLBnYSK5x0UsglGgaRIm+eFPGzRSkUTJ1fisK2hWEbRdOW3s1BKhayac6TUelcua9+cwrNM6tJ3Ft/exFMwk2UMQXqUmHVc+3C8ihTG3WKMgrMIk2BUbbPGOeY91YFGkIx001huzS2H7tuo2XQ9ZYTKQFuIcxVA+MxHSFKvDD34rqazhAq7gRM0aDtNpazGiJvi60ungwJi3YsEjSJjyB8iy+A91B4tlPvaKsmW/tozbsweGwillfFAlpAmr2Bh7rq3PcD2e3I7OyzT9f68mE+1pF/UtB2i+vJTrKzKGzmdGazudzoKvJuB4tS1ac/z8hbI5XNKmxvoTtiyd4jGktgsOwdJMYX9W2jvTKlnqyKdkwaGNVYVwbUrGdEQygeOFdSZwDgPQKuYLFPDa+xb2ECCdSmi8zZA3XK4NR8XVviD4AwaKgfm7g7kU4kJAS7SGpC/myJuISh89bza8kc0TJuB0DMaRvdezYfH0GkpHwxiPni5hzOsz1kTllR7oc+X9U2NuozItLoNLCDtpxBhWDId6ZUSj756ks30jrl1/eX4mE5Cb6ia3Mb26v+MuSVI8H3VHjn+J4R0cU+NA49dTIHb5ilQooNb0GjegFTf0zPc6PFzEKBp6FGVSwZ0NsB0JmFFPTL6p9rLpjHF0bHRHdjlzY2fy9n1aYcMRSNMV2iWO96Fn10kwANIpkax8/okqIIAnd1FnQR1+7+Hv4gFOAlN/aonBDdVv7pWaoGP+sswY/7WweDBzZx8uuXcZ/Gla7Vc/AoeXOgzBvDmrc5F/0mySp3YY+HFHzlNAnxuPxfyBRlKmj/LDFBPxgnDLfcu0XZSfD3QEVBYNLDO9KXA61yD73UVi1EmgET9cKYv/r
 1+C9ugVx
 Q3XnxMj5UDF2jcp0Sc6mGHbJcJO8MuTsT/0eyWoyb+ERnue7qRlyzh7rGi5+0b+lcXvF36OGMFLgSDi0fhAPuM5JRLJDeeUfxkozR0Q1b8iJrgcZEKQZKzbvOwPA3l+T4tWzHFD4W3MCUWXXKK5w1w1FFFBZT/gEaMqp/7BlEYbTFVUSBTv1aW9EA4xOHOIabkVue7tz86DpyPUn4FdhGv4SkXq0HVInlAXGDXqfB/cXpFuf3PinUnUqvyR0bMYu0ZAHbdyGQK+Yt/YczpykXKNu5PP9CXcjTCZg1+brM1mj/PuGEcNe2rDps84MDiMNnfh3GTEY+QvDBm1E2Maj6Ik6+sn9j8H+y59uX
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
index a6e9e755e4b2..7a21890ebeff 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5060,20 +5060,6 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
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
@@ -5126,6 +5112,19 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
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
2.39.3 (Apple Git-146)


