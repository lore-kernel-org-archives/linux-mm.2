Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C9CA606A338
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eUzhXTUF
Received: by kanga.kvack.org (Postfix)
	id 50EDF6B05B3; Fri, 13 Nov 2026 13:55:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8866B05B5; Fri, 13 Nov 2026 13:55:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CF116B05B6; Fri, 13 Nov 2026 13:55:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CE4F6B05B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:55:57 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 424D6A793B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:55:56 +0000 (UTC)
X-FDA: 85431000312.12.9973C79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id A111B20006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:55:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eUzhXTUF;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/dKIjKxFlwknpbWJVXX/cmtGsbGxhiJgbgpOqLZNO10=;
	b=vfnQGXpkCXi61aweTaB1qRDIC1zPW7wYUfJxpbNiDbZ1XXzf++nKwrgwBuxa5RrNvDYZwT
	H5WX+We4S8brH7JuDIRQUQOx1AfOdFQ77HIrNiavxA8rscwLdNA6NBl9MEAWMbUQQSs/EA
	/3NLbl7nowi5Uotqjx/4z7rKZOOh6iw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eUzhXTUF;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596154;
	b=uzXOtJn/eSmrYUX4UUwQnZA1Wpkhd1RCp3oF7zEUpcgG6YGVc2PC2EkbnwD8ttR662UDZs
	PH5Ew3T0e9UNDY81Fj/IMbDXsbRgoNgggP8iowL/V+ushIwlUHBhJuzEP9yAVP8wU68Gfk
	FE8ARi+5xpS2dfMkhmWbhGdCwaMH9AA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E8B363342;
	Fri, 13 Nov 2026 18:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230F51F000C5;
	Fri, 13 Nov 2026 18:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596153;
	bh=/dKIjKxFlwknpbWJVXX/cmtGsbGxhiJgbgpOqLZNO10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eUzhXTUFbXoKr2sBu5psoSFRm1KZwtj4mV4RSQtAChYoF7VdQMKGUNcu4BnPo5X96
	 5GAfliIjUAmjKGNJU4TOuZEvLY/XPmoY0hvy6LDVeKwuXTlczoZByg9gQZdGQDy3XA
	 emo6ethhQEeBB3ZHZGH/sny8QEPKDQbz3DQiXAdUqOM2GrBSSyOaqLOKgFLiIHlYm3
	 mdSQgbZ3caheWyLIQ6W1OjNYkwpoqSEjLBWIvlwXYyRTgn9GHo4npaCHsAAIbm9lbG
	 X+8qRQg+D9PF/MNWvikOyRrS3Ltcel3a6AsPs0SEsgbnsSZ6Hr1Cek+TqxrCBhzhUE
	 wcVqHmKTIAj0A==
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
Subject: [PATCH v8 01/16] mm/mglru: report evictable sizes per type
Date: Sat, 14 Nov 2026 02:55:26 +0800
Message-Id: <20261113185541.70203-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261113185541.70203-1-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jfhwrqmpeaihydwb3w86od6n3o1w1tms
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A111B20006
X-HE-Tag: 1794596154-307838
X-HE-Meta: U2FsdGVkX19DvIn3JMQc5paM7rL0jVoECAinUmah8v9wkwaujJKJrsNK+3PPrDTNkHDAqToIUWOmbHY0c1mC1paJ+fV4bNc+YOnPxi+ULNx1tAWOn83O8h6PFhTVnOmeR90JMNrfkdFse6KlXSyXAOQcPWiIpz8kBWz7Jq7FNkRejnCVKA9dnaDHlxZcZ4+a8HEvz0/DN3wZ6yDc2ZF5XYENsPQEj2yrQU2bYA7uAc/aKhY1sN7scUHz/5BPmxugBPPk5WZ/njadtBwt8fpB/2ziH1C8kGYAFweTrU60ugbb/RLDroHlgd1xOqhN5TcA7PdNWFyNUM5aNzhI9c/i+zoglrN6/x8NclB8BykMl9Y1KGZrhJPAMiDkSo9WhYjCo8v2BQa+quUNyXoOrx93P9lRsn5uVFMnx4eoM3d+y16GCS3OobZTMCfVuBXTaX08mYZKtVnnNQyclJTSwM3XkjwBUlUGnehAny2/5+yvseEmrUJSXF5XatEXrT2pb/nbXi1s71fturXv3bPMlWgOhtouZod7p7DrUTzlC+LjwXMVfFCSgi8+mgt/FBD0GYzYsbWDzMWn2HBKfMA7/gCAkODYSYsM3jHNXZ4OiXwTFMCXpyWeofB6d9IaSPPj5qEDWzI9I7nYs1CDse8id8mtRtHGGb8X+JahsJfMxvvfOtx+EovhiEHRF87WjVWYADKUsyEi5+8bxHqOp5NVbeOPofVe5/B7UVgxxFu4ZEu0gkc+HMqqi6tJitgPoCS0uaPhUl1JtPZQIDls0lLXk5OEl9RKo02a4Aja+C/X7lqsDUskJFi+PugTbLn/J0NLbegB/lE1jglFVhXw4LAfSlh7YlQGUac4jkKycKvRjC/JMJLNEmr1laL6phVzYYMO2UL4O8KzMq5MPkPFN0TF4qO6gQM6RcCZc4jSuf0yl/n19PhSr1rwOeLIshxoMsELy6KlqVBaVbVoG+n87y+U2cA
 B2lBq1Vc
 xbNzhvfpLQWf0pXw17+dkDOWFHbafOZEY1yFNoCg/cBtZR0UugJtf1TXAb1AqWPqzvcAZAqbrI1zMxvjCy1s2Xzebio2QR4+KJvRpf9KHdD6h5t547ZEGx7OrzvUYY9O3YVFwx+0bsQ1bYCU4isrBYKzanPxVoxZ2emj95mj69o+j2MN8gEwGeLTeojlDf8xI0UdyDgWPPOAiUFMfyW6lPd+Fvk6lGDvlUdm2il+H0nFbRaoWISjUnQPB78WEJy/C9IxiqUG3kVT8DMIJo43LkOh25vV7upG62OcTuCk65JaxHZpuayyB7QX/HiXQILn9J33f0guaPfpkUUTn8+QowG0rWzJS6U3/VyoqFr25HzfyUYVp9Vezy4eNYg==
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
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/vmscan.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 46be9c7e967c..400f87fc51e1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4193,28 +4193,31 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
-static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
+static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
+				  unsigned long nr[])
 {
 	int type;
-	unsigned long seq, total = 0;
+	unsigned long seq;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
+	nr[LRU_GEN_ANON] = 0;
+	nr[LRU_GEN_FILE] = 0;
+
 	for_each_evictable_type(type, swappiness) {
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
-			total += lruvec_gen_size(lrugen, type, seq);
+			nr[type] += lruvec_gen_size(lrugen, type, seq);
 	}
-
-	return total;
 }
 
 static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
 {
-	unsigned long total;
+	unsigned long total, sizes[ANON_AND_FILE];
 	int swappiness = get_swappiness(lruvec, sc);
 
-	total = lruvec_evictable_size(lruvec, swappiness);
+	lruvec_evictable_size(lruvec, swappiness, sizes);
+	total = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
 
 	/* whether the size is big enough to be helpful */
 	return total >> sc->priority;
@@ -5028,7 +5031,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 			   struct mem_cgroup *memcg, int swappiness)
 {
-	unsigned long nr_to_scan, evictable;
+	unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
 	/*
@@ -5044,7 +5047,8 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 			return 0;
 	}
 
-	evictable = lruvec_evictable_size(lruvec, swappiness);
+	lruvec_evictable_size(lruvec, swappiness, sizes);
+	evictable = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
 
 	nr_to_scan = apply_proportional_protection(memcg, sc, evictable);
 	nr_to_scan >>= sc->priority;
-- 
2.39.3 (Apple Git-146)


