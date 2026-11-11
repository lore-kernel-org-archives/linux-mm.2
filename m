Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B3DA606A8A5
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hebxcBgm
Received: by kanga.kvack.org (Postfix)
	id 4F51B6B05E0; Wed, 11 Nov 2026 18:26:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431006B05E1; Wed, 11 Nov 2026 18:26:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F826B05E2; Wed, 11 Nov 2026 18:26:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B73E6B05E0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:26:46 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C4A7C0480
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:26:45 +0000 (UTC)
X-FDA: 85424425170.04.D4DC2D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E5C091C0009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:26:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hebxcBgm;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439604;
	b=8jltGfGtevGkAzzdDJQE/cp9rxkQc3GPvA2AdohA65Cu2L8hXDN0cQtY5z5/Wq1JMV52oM
	ysfhep0xeoexr+FYWp73xzaKbtn6RdOVfiujd3yaZknvPaj61tWVe43ix8S8TIuiCvgZrT
	7BNL6SLkcOtI4+ZL9Z3F+TKLhx3doDA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hebxcBgm;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svLW62vkvxW0xvIszMrXeZ8SojWKg92Vr+WIfieUekQ=;
	b=M6nKhRoHMCIs7v9SGg6nSZiPrWduwiK3lKgtMpATI7vSKDddrChM+dkEzRExaiV7d8qV9t
	4MXn0nRbAxX0HGrFthSqNapTeKb8ZkmLzVS52VoyN5JTaIeC4vj3fMoPgfwcXofmxNAXVH
	94pF49kFeMXph6Dt1ZzULi70ZjTh/s0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C5D1414BE;
	Wed, 11 Nov 2026 23:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576811F00A08;
	Wed, 11 Nov 2026 23:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439603;
	bh=svLW62vkvxW0xvIszMrXeZ8SojWKg92Vr+WIfieUekQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hebxcBgmWepyx7VjbguRAqqK17gGACZTgFgv4nuQqAUoBo2S80BMonpgiyWcFu3Kw
	 qr+0XdOMyL/g58305NxMlAkn2m0MMuSNzoJ6mOOxVo5dZH//ks4GTGqvTO6Q7s9fws
	 1RtjJBcerT5lWeuMyl8P7Rb4wZgUBSyi4Sh9QBOfwbAIIk7hZ6TjnAtcYipuTU8SbA
	 EwWSB8+reOYIcGhJhqwG9u8I20Xp6ovAe90r7DzH+u4ilbQV+5z3nfKN/QisjsjTMk
	 iZej9gAtV5yMKNwQumbjWGcM6NatLRZmWktNDZTYz/Trs3HdKWUwpNTqNmJUpulvDR
	 Ccien+d1qIVTA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org
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
	linux-mm@kvack.org,
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
Subject: [PATCH v7 06/16] mm/mglru: return for unavailable anon reclaim earlier
Date: Thu, 12 Nov 2026 07:25:53 +0800
Message-Id: <20261111232603.9934-7-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261111232603.9934-1-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tr8k44p7jqxzjjthh9nwaowtgto5t79y
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E5C091C0009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794439603-831866
X-HE-Meta: U2FsdGVkX1+bb2Ktivt65zzpN936+mZmo9lMA0ZBQ0IYeCxo1HAS7rxGqB95W5pbUv7fVSN5ORXcI5MmcPbBzivTMyVzT0tuXfgW7DoIM9UfFEwQJ5NElKyS97Lf2mZCAK3PK1ntUa9Q7yDXgSqIA10Wy+HGX3K8pxOjai1tbfM1GidsXiv6hDSdiuKM/HoW3VakRw9WaYyU+YCk0HM5SnsKibb+mGFIFVD5o0wp2ytoayydcLhUUoWJxiwH3NSowbswkKsRLJJBtSnh2xUe/KCFTMYOAHprqyVxkp7IzNnUy3oq/zOjlLuioLukwQtz162aoI35TZIw80SzRT8kQQd9ITL4ERsp3yFTAYghtCXy80BzDp+4AAHSgZ/+0sdlVdZOR0F408OWzq62bP++eUnG6aG/bui4Uebmj0TedPdUju6IOTKYfMk2HJ3EW6xTaJoL3P2TLShOOXq0eGvcLhk/fu2aKn0R5g1DquevqPtCuCS8EEuMXycVWsgPS52bDFj5oRWAV6ih22IqclKm86JMpFKYrXUWvQUKEwIg7lhEuYm588uMtnatMOOY52F+1aq3LgRGMv9uSICFN8+yWYeHYnJaxvjedk1dSPQGjQgasVZpOvgdnu/t/ZwKnQZlG+0bREonvrTeHIm693LH7UnCIgM9JuTx5ylhY95qtwZCt+ND8FcDsnZ7IhAmK/ALP8+qdwncbxKq9/dinmms0E1pWof+2N8o7trrcFMFqihCz6qtfStLmCMsTziDNeXg2MPS4t58odzn+JThMD6dqtMPyj5nbPsGLJPSnJ4/B3TNt0r1lyfzL7buSC+nnH4vKHkDSf2W0/seEOQ30lCctyXBXr6b1Fn4/+uOC3o+m4W/bHp0BlfCGhUiENWQwuVr3K4EvGZX2Q5vjT8Cm55guMl57Pgst/L5Ytzw1f6J3K8tRmyfC/3aSyuCJi7sLWytjQItbtwMwcsCMPvGDTn
 1pecME76
 4ialRUnn6WYNExkN+b90H/cqOXPFoSuFW23H25KhXlvIXd4+KklYhyUNjYNliqGce9caBsDw6BssCXCbRPlfhaBX6pMHIxqPBa6dcwFj9sd5rf1NSKsookAdmDTIMW+9WU08K5S+ETuR1oC1800YdcHN03aaZxiqfq1E1KkjGSt0TGc7KM/W2KeWqD3mi9YR4FGa3lUjXkupxsS3/+LxIq1moR6zfuc37iwJ2hO+9DHtKQJaSx6rd3Q+tb33H54u0faD8g7EqGpsu1v53UIsZDedT1XMeTZtW6lQxXMB+D1QmDI9jincalI3Ow2hEhaCoGhzIKANOxHvwykTtUcghPGub8GzCE8V0GS6d
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


