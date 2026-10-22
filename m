Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F15D9606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QalWKvm9
Received: by kanga.kvack.org (Postfix)
	id 19A056B09D9; Thu, 22 Oct 2026 18:02:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1499C6B09DA; Thu, 22 Oct 2026 18:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 040926B09DB; Thu, 22 Oct 2026 18:02:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D25886B09D9
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:02:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D2D9E802B1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:02:25 +0000 (UTC)
X-FDA: 85351636650.13.D9A8E1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 446B340014
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:02:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QalWKvm9;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792706544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMfZkTuxTlSsyjGjWesRKoIv1NGikpPcCvSdfeM0NJ4=;
	b=Q4d6erPDcqMagRLuPHv9qFTgrck8UGrg7aJcYPv8MjS2YcwuX0zk7wzmjXkCe5eIVN4UoS
	6nvOc/LKuwHUh5v6Mf4snsdo8jH4o2ihdcZZS8QHL/D/kiLRGclEq9/EhAGp50VfzqF7yY
	qHCJQ9+UMY26AuRNsNJOPqa2UTQXJpY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792706544;
	b=yEhVLTCJdsOefUCH007183DWNsZ1lulhW581RnLENE019cx6VCiplxKyZmsnjNIUisd/2W
	m7pCoRnXbD9FR/OJk+IpUjInmKCM8CvqKXm5E69I/RRm73xaeFT07EgDEAVUzZRRrP3BAN
	Yn0swe9Etl/LyD9+Z/vKSD5E1umechw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QalWKvm9;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A0BE6022E;
	Thu, 22 Oct 2026 22:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F4E1F01829;
	Thu, 22 Oct 2026 22:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792706543;
	bh=gMfZkTuxTlSsyjGjWesRKoIv1NGikpPcCvSdfeM0NJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QalWKvm9yD1uCCEOxwkWey6CoBh/gYh5acwDeOHUfnTQ7/a0vUVmFkvY5YJqvPjXW
	 aAgY1vj5U5/2x3/Skt7zY1VWidrutMaLTlfd1Cma5Fl77gRlmFuKM6A9dkP6CLGkhK
	 bSZPuu2rrY2Y9SgASUkV+/6SBBEWZxTbNVVuw2YLntddNjrDshQ3jmuDTBQMAB9efQ
	 /s6limoyz5jeP0AWECMIvqTnWQ+OCEuMjQPFC3lVkCxqGbCMK7t4RxjJzn61VpVSJW
	 FTQ84P0+/uL8G1/OAqOLx+dmbHf8vaFMGq4S/Te5jPxcweB093N0PDvTok1EZIKPcO
	 2wuqwGj4UOCHg==
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
Subject: [RFC PATCH v5 02/14] mm/mglru: extract lruvec_populated_min_seq() helper
Date: Fri, 23 Oct 2026 06:01:51 +0800
Message-Id: <20261022220203.91911-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261022220203.91911-1-baohua@kernel.org>
References: <20261022220203.91911-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 446B340014
X-Stat-Signature: mzrtowc9yto5pgcrisitpbd9796ak868
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792706544-684788
X-HE-Meta: U2FsdGVkX18xSpa5pqrspE7KsweKrL04U3yhyggRqalPG+0jN+FEXE/aYIRb9+Kwpk5fnr86hKVYOyF17He+JqJPIHdtzKqqRk4BJlYFPU2/bPaEKI6NUdnXSo3DRWQzULXtk3UahSbfrDBOaQubs9CHTjeKh76X9TP//l8q3sAj15ASEnHRVZsbBh8YM1U3s9zxsy+f86E/IdeD7bWZEawolAHRiLUHQ0+30qO91+/GDTR/o1nZH2QecucLxVihYPAV92DgD6XXbiA9uq0iw7OzcLtkAp9KhGkSq/OiCDkYwUVU6Nnpjlu2EDKryB4neOYqOsqE1cF2hkivkWUH4wQrNAPwP+2o6ZkbkuLmec/a/rWq+hoxE+U9wY+gqRzWN4YZ7r4iROlbndP7djK+Fs4Xmr12ThEiSJuwReI22eTB3cNLqyTNAE9guo0sxigCicsZnY+W85AFDqyvIkiMShAiXbeyXRbxuRHY6Rqaxm+vYTRNGXI2Z+0qiylHJmVAVzsEwKjgBMz1roMT4Y0H8VGhLKInsndhv3upgcaozKzvOiuQWklFIUAZC5gdWFhK3fuux7BDm7UxE7C9jv9zREH5mtGGWookKcxG/yvLWwVQefh1jd300EPvqkQ0RlWSuba7Cc5lt2yxqvihgHZUW7rMj9FA/p3j/TRZHDoAeBF9yNVoB2kyY4hs6ye3Up0OKDQE5wEft7ipoiuDsqdvKQlV1n3Ta0s/tz9DTRcPskNBEzJf3DEtQw5lXl1CIPjyUdJKunP5hT4X0yTzEAkOs8Cb7tNP+JbrRtiEy4nt0tmUkAdneSbhUhaj/crM4FmkcKb5/Qwb8zCjagJvCZufZJC/j8najNwLe3Fxy5sSTXVLAC3gJ5GsTZph287W+5zsC/SLsPC0/bc0IyFvPD3asXUKHo7jkWH3jxcfJ+cxbfKJUu/9cr1JEk4sNupgJpP1FQirhFfX3bLxoSrgsQB
 UPnsgN/k
 jFhqyO0X+XsBAb26PHTGI/P6jKYLXQPOKJqiaXxh0dV50sh1hqjFqU8un/1GElKfl0qXQHRwGTLzNpTn9uIEs4f11mXQUvcqQIYcTB9kn3iFU+2OspecTypysItU/gekGpjFMEf6XyGiOwplYfFBp1HrB1fLahuZhUNgNDD0O6xyhhVaTCqF2Mr43HgcTRCkHCDyCqkXGj5csYWqduhGsRH5+3a/sIa7UO6NUmTEkPTgwf/TnmMgoP0LyXSED11uSo0kwfC0THpmCXTSGBs64BHg25xoa1k8FgWFwHqP/xnO+vh4vpiNXyk9GET96BEmTSmEQHeNlmC6iUpgqnn4K7AO15ncJtnIUniYZtIs3LnHu1aKAkZVQvbLexY8ENxywoTeE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

The search for the oldest populated generation of a type, previously
embedded in try_to_inc_min_seq(), is extracted into the new
lruvec_populated_min_seq() helper. It returns the oldest populated seq
of a given type, bounded by the given max_seq so the search never goes
beyond it.

No functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3be0d6c04a82..500ef23949fd 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4131,30 +4131,45 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	return true;
 }
 
+/* Similar to lruvec_evictable_size, return the oldest populated seq of the type */
+static unsigned long lruvec_populated_min_seq(struct lruvec *lruvec, int type,
+					      unsigned long max_seq)
+{
+	int gen, zone;
+	unsigned long min_seq;
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+
+	lockdep_assert_held(&lruvec->lru_lock);
+
+	min_seq = READ_ONCE(lrugen->min_seq[type]);
+	while (min_seq <= max_seq) {
+		gen = lru_gen_from_seq(min_seq);
+		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+			if (!list_empty(&lrugen->folios[gen][type][zone]))
+				return min_seq;
+		}
+		min_seq++;
+	}
+
+	return max_seq;
+}
+
 static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 {
-	int gen, type, zone;
+	int type;
 	bool seq_inc_flag = false;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MIN_SEQ(lruvec);
+	unsigned long seq;
 
 	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
 
-	/* find the oldest populated generation */
+	/* Requires at least MIN_NR_GENS gens for basic functionality */
+	seq = lrugen->max_seq - MIN_NR_GENS;
 	for_each_evictable_type(type, swappiness) {
-		while (min_seq[type] + MIN_NR_GENS <= lrugen->max_seq) {
-			gen = lru_gen_from_seq(min_seq[type]);
-
-			for (zone = 0; zone < MAX_NR_ZONES; zone++) {
-				if (!list_empty(&lrugen->folios[gen][type][zone]))
-					goto next;
-			}
-
-			min_seq[type]++;
+		min_seq[type] = lruvec_populated_min_seq(lruvec, type, seq + 1);
+		if (min_seq[type] > lrugen->min_seq[type])
 			seq_inc_flag = true;
-		}
-next:
-		;
 	}
 
 	/*
-- 
2.34.1


