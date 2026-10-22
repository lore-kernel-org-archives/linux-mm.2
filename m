Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A39E606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XnRr+6Xf
Received: by kanga.kvack.org (Postfix)
	id 543986B09DE; Thu, 22 Oct 2026 18:02:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CCB76B09DF; Thu, 22 Oct 2026 18:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40A5D6B09E0; Thu, 22 Oct 2026 18:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AF486B09DE
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:02:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 96E56A7BA5
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:02:46 +0000 (UTC)
X-FDA: 85351637532.29.457D935
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 099281C000B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:02:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XnRr+6Xf;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792706565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vQbgXpddcTuVN34Htk2SOZBEs+BmtG8kWRSjzolqx1o=;
	b=ynijhzhJIHN6l0TVjfFlD7TU/oabVc8OJVqSi3dl4P3dF5A/P+mfxYL51I1aZDdhWGarVM
	C/7XgH++FwuI/BWHa49CK+cXO++CPHuM6sGCH9Xc/Psv2lTdbDcH7ANEEZo5ZZrVkPDqDb
	EDh3vSw6FovT9SayzjLD+pIswqcnPDE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792706565;
	b=g+anSQA5foTDIw7OGlkHENItrM1YrGNJF6N7Fme5Cv8h3rj1X5aZ4UBUgGFCuBaA55kxYS
	wdt56lP4IHoVQ6Uh3KcLxOtPIaME6kJsYQLIxI5mePT9CT8X+Aoy9gzIgmtMKYpHq+B0bL
	yKlKEdZexwd8CefwdSsp2KeCBAd0TfU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XnRr+6Xf;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9668260A81;
	Thu, 22 Oct 2026 22:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6351F031E3;
	Thu, 22 Oct 2026 22:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792706564;
	bh=vQbgXpddcTuVN34Htk2SOZBEs+BmtG8kWRSjzolqx1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XnRr+6XfOUCbH/xPlS5RKjnpP9QvE97884/4k0z9EfH2JOZ4uTuMGSFj61If9PFwT
	 9REgjLHsA4c6oDgeSJjBtoNljs25bmh6QtJzsDtYNpvI8Bub4IkPWVSuuQe4WS0EpK
	 b95CAKwrFrU17eG+C3jSZzk6qKGICpYbAt2Iq6rD4iKMbv8JUvVyZbVq7NvbUeum+B
	 r0mUgJUpO9LxRk0HQ3qJqX9TjrBnRKs05ruzHYBh2PuYXv+4RfNz0SpWpBkqGKY7bq
	 Am5ff9IDRSNUWNrtFJQob71+vnE+1xG648get02FKRjecPl8BUDT5RNa3765t2vCAn
	 CC6fWslSbJpiQ==
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
Subject: [RFC PATCH v5 06/14] mm/mglru: return for unavailable anon reclaim earlier
Date: Fri, 23 Oct 2026 06:01:55 +0800
Message-Id: <20261022220203.91911-7-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261022220203.91911-1-baohua@kernel.org>
References: <20261022220203.91911-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 099281C000B
X-Stat-Signature: t4w8ip3foitj4r76hjfzxcyn4trzktqq
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792706564-674580
X-HE-Meta: U2FsdGVkX1/tA/GFnAQmq7OlhC0IaCU/lcG4OXpASHSvd2IOcOAH+TppLBaYNKJFVED3dEIMk2vc5jCARodFgTQMv5zbiqNJuEZi8hzgsp+8/1f7zl6PCsd6tPTnFPaPlZtfNptVpkdeioMLgr8AQc25TY0Pi5ySnIRaAh7w0YS3N4UqQ4YNd+/2d0WQkooIP4iyRioi0rf+islb54FqFGm577si7wccJ05r9f5JfO0ZsQeSg98Gs0sYSpFQTEr109XejsPTy5kl1CgCT7bCYo3EIG3mbaDeEFrP7kkUulo2uCtzeZYe/xIuisq3r8UG+138A4QBJrZbpSQnPUqkljMu5tq9dk/eCyWEIzRRTvt2cc41T2TW7EmuIgf3CgCNJJne69Kiug0Xj+FJMKzNYs7tOhWzAyjiv/5g1VXWxUkZ9uAS6SAp1oxgT5B1utS+SYhLhkT/xVTmo/llVgz3JEH5y0NFvk8O/mWlEKu6x8ddCqq/inHFFhBaSrKFGoaa0Sm2GMjfRChd2oOuRMppA8juxHCXEnOrxABu8VGnoCo+lOg/bofnwYonGFTk+gyOvzXc3NpJGZGTG2cseWIimYxPWT06mCYesph2rWwQzI2Wu8JUQ8v130SB9/WBeRU1rb2A3W1XtuhBfVlX+6iC7QK7ETNo94RnY251fJESkuyL0Mjk0GxZPIDp/JeFX3gSUjCxD/GbOJzHUBarFL+970cfFcJ0O53SOEhpXFDn/3v/XRs25mtAIqFg6QVnzxDW5zkMYVkMM3qPgVitHAX1K5RRiJFAZfBOfSA5guk72PDzNgbDImbLNHD8GfdryA03EPYYVVPhcrhObCyxAiAETb+6tB++daJCfKdQZdzlTFUH1swAVgkKdbIxPoMHty42xMOyZ/f8rs24ogJHYWGwGv0gxMu8wE8gP/hXacgYe4FM/WgFvUlLD/dbiKI+IKVmRL7S43EkVOR8srG6H/J
 oVcik+PF
 4nePisD/jbZ914gtxgnX1GBaFiZClOFEEyWbl25furQpQm1rraDqEJ04t8vn1KzuIZyq5rEcvfFGu/37aHDjTwWuCr3xs9zMMEK5C8NywYvO1YGdJlPYXHTLUinFyM/Qrkx4NjR4G80UiYzQ+3St9B+GyYXlebMmQNVrWKqayQBMRj8h24N7S8bEYXjLaV1DtWXR/s8xNhjqvkrRQ2GQ9oTLRgjDHjcguAMzBaOUu7R7tHIyr4Xxmfpcb5d5/nBddIIU4H3AC4i4mjPTfau/b50OVAEatNvwIo7CLk2UecGeKprpPUzsXfUuyisBshZh7XV4lffhqyDBRHMA=
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
---
 mm/vmscan.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d3caed8aa789..0930bee5906e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5215,20 +5215,6 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
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
@@ -5285,6 +5271,19 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
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


