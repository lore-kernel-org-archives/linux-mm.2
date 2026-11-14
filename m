Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 722AA606A33F
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oXIC0n4w
Received: by kanga.kvack.org (Postfix)
	id 85DEA6B05D7; Sat, 14 Nov 2026 15:08:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E82D6B05D8; Sat, 14 Nov 2026 15:08:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9996B05D9; Sat, 14 Nov 2026 15:08:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2B06B05D7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:08:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3E594016A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:08:25 +0000 (UTC)
X-FDA: 85434811770.08.73AC6F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4FD3980002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:08:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oXIC0n4w;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a77mtASibmNRpSvCk4qjY5DapLOB/+QPvfDiCbB3EpM=;
	b=lN2pfoLSZbwVwkAiO9WkFVoTv/acJyGijU92XtqnJYe7eUbRwUlU8vuvPMANCX18HkBkut
	DkiC8PJs4skjP1VSVRHRoBO3+N534sO+WUX8QYXyWvcJBrCaNBSka4IOljdnFPO61uIDdV
	AMDgVrNhz6onpqdBpeqVsMspnKmZ/jU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686904;
	b=0g1Zo58JZcDD82k+UlzA48hnEIJOr2a5jE3NsNYJOB5cO479HL98mXBBQN0yIKv5veZD5a
	nz0X8WPzjSXwX+wJ4EU+JbBBbofz2ghfYoDKzf12KYkEd+A9AQJtzh5TYEsibyEfDxiaDp
	7G7C80IX4IMRehe1QAl5rXWVJMMHSpk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oXIC0n4w;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 821A840226;
	Sat, 14 Nov 2026 20:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C381F000C8;
	Sat, 14 Nov 2026 20:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794686903;
	bh=a77mtASibmNRpSvCk4qjY5DapLOB/+QPvfDiCbB3EpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oXIC0n4wRCmwWSji2V7+PkU/4qChsSTxJGYkEYumI2UuNruxVrDLQzKwu6DI/KVmc
	 HPb6/z3+R+LZb1Tr4vsr/F1P4uMC9BmXWbHfXycYIizCmh5F3oGCqEQVN4EeLorPCA
	 uhh1z8cJ8V/nAsgTTZxrZkCkFJAzUg80oJt2nM0IcuRX7ANX7N6c9VSGBg818tT8iK
	 /Vlr9qccXonbn9Bies8t5lXD3HhSza0gFqFklX6WE0iA1Jd8G9gbgGZkb1GfR0kR6K
	 LtEvCo27NzK2fsBBJvnCWHF+U2bulsQz8Hc43Sx3cymTHJmgG3iSilO4iC1i+NTAVt
	 l6ImXlUC5bB2Q==
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
Subject: [PATCH v9 02/16] mm/mglru: extract lruvec_populated_min_seq() helper
Date: Sun, 15 Nov 2026 04:07:49 +0800
Message-Id: <20261114200803.23129-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261114200803.23129-1-baohua@kernel.org>
References: <20261114200803.23129-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7se5arecdjxuxi4wk9pwhnzbz4qykd4t
X-Rspamd-Queue-Id: 4FD3980002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794686904-209036
X-HE-Meta: U2FsdGVkX1+IibqElRtoW2gUrg9yTBoKvr+8iB6GV2t6vT72WgXEz1ms3D/dFQDJK2nYRl5Z6SJ0TOIOJWofZ0CQGmsvdkfLd/8m+hGOtYqX1COLKXwTK2t8+Gwk/Bm87BN/KVdv0EPemUFZfxNmtgiOlHAQcE8h58AMyV7WWWcI8RwQMkCE7o2OohjCnbUv5oYTu74RjhsBIQwnVj/rAkBjH5z7g3k6zABOknYypZpdgjkW4SPhNL3MtoYg5p/sPwszIqEa6sp/aqfyZOiWJQci564yx8eBgrGRJAsrAnUJUjdOtTS0BLM0+hsXESVvypdRiI5MAGRynKYeaQ09TGTBxw7D8o6O9SPTNrMSw8zgKqfi9n+PlFfTgZmhEUrJLioXaLvCqrGYg3f1YfnhxfYzMHNJBtnwqF6Krew9MhmHcmN83AuR3Z/UvuzIHXEZb6LjRwwpriR1WawoTTMTCNsh5R9j0VvQuY0SmXMUTrMZ4dPY4toPRV6lURB9/YCjJviXG/mA7IFnw9yEIgX83+uzAnyxPk4zHJRWuPxW2XVi9j3TIj2UXmg12difaLuuSO31688V7LA87aZg+ZboZqxJO5Dp/peqnco1Wf7i8K/ulZeWtNTZplnGwVtJ7wlNk1i/CPmtwsW5G9mhusipkZHME75hq33S8Q9buVsNtJRB0y7pIgrsz4tZvDx2txN7Zp6F7sB2NmhwxaMkwBgJH5UqQqn3hcbMu0695stBinOvco9nom6hLQZLPxnTHukyt4fyZFsh4lF6KKxD4kBP2La1HrBCQomlIU/V7PWZmenDTWa86vPD2S8nRVQABM1CpeG8yjUIEGLNftOTTx6L/pIjaGfrxzGNhRAS214OGCBCwhRh7jUo0kD/fWhVXhV1DOpmUx3I3Tp2ifxohETMAV0O7DVrQBTVB1To+gMAGwy6Uxgd8C1nulP4m08UnIOx+QD+XW6mLWSvtZdOa+f
 iwEsc9zr
 /YSCVKBFWvobSVNwpHIHDURfaTtMgavhDBzTeZPRSvGDc1TiuInfGsCoZaUlhqWjnZb5Plu1qtyB81IP0tBL5+1xBZpewgzyCWjo5Xa9irbLhTAH36tNBdd7JWox1ridnNo64F4GIsuK0sw8XlrgAskLeCZNVSkBCCS6wJOAo735lYkgbYOF9z4SufoCprOSE/pRqIXZgYnRpimuxVGOkcIXc4Us4s9+eJjQeO53g2pnSnxqUWGOUFhw3akA1FvHDi5T6Qf2XbbFCRBR5OYX+KG6RFVa78ktYT7bhmlzoqr+eZXIiBKq43oleClGNtdkjwp4PmSIEOMOa0g2/Rk2BvsV0EOVfulz7GuFXZskD0T3tQGaRrbWTHQ/ln1WCVdd/pcoUmE+CA5yjpiA41fRFvWMHQA==
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
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 mm/vmscan.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 400f87fc51e1..ae3e13b1fb27 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3992,30 +3992,45 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
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
+	while (min_seq < max_seq) {
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
@@ -4027,8 +4042,6 @@ static void try_to_inc_min_seq(struct lruvec *lruvec, int swappiness)
 
 	/* see the comment on lru_gen_folio */
 	if (swappiness && swappiness <= MAX_SWAPPINESS) {
-		unsigned long seq = lrugen->max_seq - MIN_NR_GENS;
-
 		if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_FILE] < seq)
 			min_seq[LRU_GEN_ANON] = seq;
 		else if (min_seq[LRU_GEN_FILE] > seq && min_seq[LRU_GEN_ANON] < seq)
-- 
2.39.3 (Apple Git-146)


