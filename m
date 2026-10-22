Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 153F0606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VsKE+RV9
Received: by kanga.kvack.org (Postfix)
	id 25D6E6B09D6; Thu, 22 Oct 2026 18:02:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233FE6B09D7; Thu, 22 Oct 2026 18:02:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14CAA6B09D8; Thu, 22 Oct 2026 18:02:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4EC86B09D6
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:02:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6ACE3140232
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:02:20 +0000 (UTC)
X-FDA: 85351636440.06.B9ADBE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id ABBA540004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:02:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VsKE+RV9;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792706538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63mK610jdToNP0YQ3Ph5BKb/f3otJucBqFL+kmib1dA=;
	b=FXJDEnbKZmM4yiisCWC7XwmhQRnejR1D5NXgeDhWI8OVnaJfZmBpr8At72XKhVpJCjX96j
	wIh60qn6VRojcpvqWnom5HLweVWThsPLvaVq+lOVnZSXOfLHWSSPJH88ODoxPTlUYZDWoV
	8ry7765IhfP1aM/6uEVFI+Ea1JHY1c8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792706538;
	b=fFHBUAe2yi1Xe5XCSVZp665JRf342rGmBApKn5/SbCLHkz5Wj5IdW6atZR7vPXXWhi6Q41
	pEUo80jCTYY3BmCBSJsqOWf+etCACwC4xYFXUl1RjHA61khkIlWYp4Ox5wBtQzURRspJE2
	xR6wlYNGafsOKzs/N9GeqmVA6cVgU3M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VsKE+RV9;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1053042B03;
	Thu, 22 Oct 2026 22:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158011F01828;
	Thu, 22 Oct 2026 22:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792706537;
	bh=63mK610jdToNP0YQ3Ph5BKb/f3otJucBqFL+kmib1dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VsKE+RV9ZiFeOrwZDoTiUuwHB9vpcwRc4MSSz8a7z5neSmnRROEqC8EjB3KAUEHbU
	 MFp/cNhWnW9ptktSNH4FF3LqxBovkVC3ekNfCkRxhj/WbiH06RUhaiUPjY5fE9ohku
	 eEG2q56loqTFA2if8MKVcDXJIqHV+CXjILILaj370EAV7fWZqcykJ0VpfX3CvOM3J3
	 SPCvz9OLlv8FTMtxHWXdyhUOwRu3Y2WBXiL+JKVegV3UqvGOv+ZgVabTiGXnPDvkEc
	 YLDhOgkx9c3YlWfoUP/CeyzP0QHv8Z8VXZ85VVUfOJdProkIUKWg45o5FflkxTEyQl
	 dtVjWMF2in8ig==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hui.zhu@linux.dev,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhuhui@kylinos.cn,
	baoquan.he@linux.dev,
	liuxiang.277@bytedance.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	kasong@tencent.com,
	liam@infradead.org,
	surenb@google.com,
	mhocko@suse.com,
	rppt@kernel.org,
	zhangbo56@xiaomi.com,
	lyugaofei@xiaomi.com,
	ridong.chen@linux.dev,
	kunwu.chan@gmail.com
Subject: [RFC PATCH v5 01/14] mm/mglru: report evictable sizes per type
Date: Fri, 23 Oct 2026 06:01:50 +0800
Message-Id: <20261022220203.91911-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261022220203.91911-1-baohua@kernel.org>
References: <20261022220203.91911-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ABBA540004
X-Stat-Signature: jua5defdaujcja58gdppfo4dm3zduyki
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792706538-354442
X-HE-Meta: U2FsdGVkX19te1ngWBp6ysiVV2ZUdDLAELfo1oEpFC6NO95LI2WkUsg3BtHVJ12nfduoObYovGox+TOub4Zime/lT8riAN7kJqR8MTleJWTzPC4yA4E0ejB82+fJ4KhGtTzWeaSJr3AKGzbs27IUYA3tYEF+paCR+XY/bXkT5qV8QBQICZ/NSmaYewlmzqTVle98s0HSfo3PaFYtILZx8VLjJBxdf+aIVLRBhaf2CZR0tXjv+M8WcjSgOHwx4tDd3rH6f4uUvhLWB6ISJL79kQZUTRQwfNoQ/CF8Z5rjTgnC1d8hLNJn10oFXRwaruz4hbA0fDU+FcKI9d+x0zy6HkpnqWAkWHgHHmjvKzCOMmRbw8idNmo7M4+YB5qxGTpfG4+66RHjHyKp/7WxjYGnm+Gq6VW6NyIQ0dpnHNKE4Iw1ngvrf1lrwQHsEAYeIgWKAp7tSaTFkvArpC3jE1mM7jF/UttAcrk6nwW4YDTZJzAOgWOrxHBj4U3ehB6UMEyvlxL0RPXRDu8fL+cxUUxJDSB6nyLvDKgzu7hHlUOULjI4ZdxyBCBTYDlIw8xoDpPO2IfZTcKT1H0QIPtvZkJonhhm1S2400isrs0MFFfBcJ00V1ZGoIvIFekD7IthTBB1xmvdtYsm/qsY+C0yD35ck0qyjlH/OP8gMhxiQBlYmL0xRrcGh8lM/zGmptM2wx3fFCUKUVmaNpLpfoqr82ZRk4k9++qmMvUK9dA+AmaVpgOvlAXgzsyCygmrf0hgkGkIWuxQxSfoFgqZxzesPuq7i58RGqVdYyvCOBEATuSfNDlqRnW2P40PkJkJakbxFyGftH4QyAIjDyG6aiWFvH9BHHa8Ri6zm72f5aLFbO1ab75FU6bk/HtJkanpXYUdlWpSfcmODo44pRy82yn24NtOm+1Te2OQRRWYk3ytFprlj+hdUFcDX7MhxoNKqZnWuGxsGmI+49VRP5gYee9xZey
 7KxrJIgF
 jOlCosviU0IddR8J9hyAYjiav+XresJJRrjJ4vpNCLM4vNXtm8bCjOGXRsuXqov/AVDaDUd9T92sjq1H/PpmXiul2CB4Laofwk6IqIqy5bFMDY25GRhvXsp39B5MlH8hrIRwfvm23L/LYP8o+XTalUSbwPlRfpxZjmae6KtVA1kQrx02LYIc0CB8BiAcwD1bIQBkiJP83J5EEdkEjKpAEj3VtJ+3swP/hNsSYVoZhHHeQwQN8AfpohmUiksB8gvhnrPTnYCS6S2Cren/AwhifKisZEVdurVehILqEU+hmur4tX2kvOnY0Yhwf8Zh8Z3+aHQ42BRFztlb7p8s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Change lruvec_evictable_size() to return the number of evictable
anonymous and file pages separately instead of a single total, so
that callers can weigh the two types independently.

Update lruvec_is_sizable() and get_nr_to_scan() accordingly; the
summed totals are unchanged, so there is no functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index fc823fe3bd1f..3be0d6c04a82 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4332,32 +4332,35 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
-static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
+static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
+				  unsigned long nr[])
 {
 	int gen, type, zone;
-	unsigned long seq, total = 0;
+	unsigned long seq;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
+	nr[LRU_GEN_ANON] = 0;
+	nr[LRU_GEN_FILE] = 0;
+
 	for_each_evictable_type(type, swappiness) {
 		for (seq = min_seq[type]; seq <= max_seq; seq++) {
 			gen = lru_gen_from_seq(seq);
 			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+				nr[type] += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
 		}
 	}
-
-	return total;
 }
 
 static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
 {
-	unsigned long total;
+	unsigned long total, sizes[ANON_AND_FILE];
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
-	total = lruvec_evictable_size(lruvec, swappiness);
+	lruvec_evictable_size(lruvec, swappiness, sizes);
+	total = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
 
 	/* whether the size is big enough to be helpful */
 	return mem_cgroup_online(memcg) ? (total >> sc->priority) : total;
@@ -5181,7 +5184,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 			   struct mem_cgroup *memcg, int swappiness)
 {
-	unsigned long nr_to_scan, evictable;
+	unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
 	/*
@@ -5197,7 +5200,8 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 			return 0;
 	}
 
-	evictable = lruvec_evictable_size(lruvec, swappiness);
+	lruvec_evictable_size(lruvec, swappiness, sizes);
+	evictable = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
 
 	/* try to scrape all its memory if this memcg was deleted */
 	if (!mem_cgroup_online(memcg))
-- 
2.34.1


