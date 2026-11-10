Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFC9960A2615
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P13YjycL
Received: by kanga.kvack.org (Postfix)
	id C77EB6B05B1; Tue, 10 Nov 2026 15:20:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E886B05B2; Tue, 10 Nov 2026 15:20:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8BDC6B05B3; Tue, 10 Nov 2026 15:20:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95B2B6B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:20:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36664140A92
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:20:43 +0000 (UTC)
X-FDA: 85420327566.25.428594E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7B6F51C000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:20:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P13YjycL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XP8BVGG3k/SgxxucX4Qss0oWT0tMPudgWX8MpTd7f+o=;
	b=d5gjCExI44ah8deykyrR/6jAnjdOkdu0XAJIcCJcux2aluPp03iIN4hFG4H32DOsQpSmnV
	cd3FfUrJo/Y3pdaPAd/QlH2zBi1nEFJa4+QdSPJDVgWhK1AtMLtf51TfiIlxbzpshXJomZ
	qqiTBiEYtPf5ATVcqHSJxMqh1s0bPJs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P13YjycL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342041;
	b=PPKPCYloCuCm5LSY3ouWsQh6ksPoJBtAsGsz8nRuDyHcBb1jCiuIpSu20SmKF6gA0MZ3X7
	4oxVfPtPKu+MvWxNJMi89RL3bPxftLFnCv4EpxhPeHYQOMG7voI1q/348qo8VdCEu/PZBH
	fUYef8PIFrusQheqq5bVoP8hAAOWH88=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C589D4729B;
	Tue, 10 Nov 2026 20:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01B91F008A5;
	Tue, 10 Nov 2026 20:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342040;
	bh=XP8BVGG3k/SgxxucX4Qss0oWT0tMPudgWX8MpTd7f+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P13YjycLN4F4N+zD38vWSxkt6HKL82woeFH/3wQ0qxOXtm7u3KffXFHkfHkmDPJZS
	 tfYSVHjrhhJqJ8C9aG5U1no+kDK09JEao8rZzOGUHE0ytYlmMIHTORE14d7+GISbrA
	 cVnCLkQ4XmoDZ93o6axAh7bDumtY3VptUIyaPbzqhl42raKoOQpkm0xP6HplEWn3Uz
	 hwRN7qCqOMNLtoel7IGi0JUsHfS0eL8ifsfnzV1R1o6U5VGJg5mxLM/kbP2eNabEcR
	 sIRLxehDzZQ/x962ZTEwOQKCosmyJC5gKH22risR7sCIXHDYgY0vr4IFGiBzSrH8dQ
	 KK7FOND2vOxrA==
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
Subject: [PATCH v6 01/15] mm/mglru: report evictable sizes per type
Date: Wed, 11 Nov 2026 04:20:11 +0800
Message-Id: <20261110202025.25736-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261110202025.25736-1-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7B6F51C000B
X-Stat-Signature: ibugutuf9pdcuc4gqsd7eqjto4t7ttob
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794342041-612282
X-HE-Meta: U2FsdGVkX191HNuKPfPfTN3V0YjQuFw3yuK2InhIib2j2kSSdsjyFdXYb4X2gwb+3mdijqsi83M7MzZYTfaJ111z5OWaVLnhWNL1cB/T2Kv8djBlNrfL+Gl1WBJIuJlxxZ2lUgzxQe21Rh/WgEnuSHyiXNhk4rSIZmf8SNiOcbF+Qp98SrzsqI3x3P5lTBSiN+Y4dcRMtREKtdfdzvRPxl2+KSRr42xdbdzgr0e8m/ZL9PEZoaNCDzYkEJMY8NMdFdgGza+/A4RJJdnVx/GDzFlvlZQqjdwly1w0xiahji44hsUxsUucVbKLnEslVJ/phoDM5IN8agyUK7C1EsG+y4xtB04J1D2nIKhwzS5ew/B81LKOQl73dF7pxjHunikHlhXdBKhE5fMk78cAXWZeZGmxA7a/906qGt7wrLY8uGGP0inXXtrlNYc0JUaOaRSPRwefFwjIKiiI+akFOVQE45bjhYCsfu6NLaTS294ERWCONPIWo3N9CulYlwrvg0ys/dC00ZZ/v317/wUi56lX9Tb7axz55sD9KAvKg+MPFgRU+FFg1O4n6V2o6DihcP5ATz+pgIdzrE3LjESibDeppPBC0OuAfHUD3sUOM0dbiRgXEVWB2cM2w9XpuEAg9PaTdUIwQQ2KgMMbgXJ1C6MdQqwc2N0FgJ1qHk9ZOUw2Tu9UZ30pT0/stgmjkU8sHSBWqGtRGZsBkrAIBT2cncJwtCDAKzjdrbd+vX0QSzrmwZJ/xRjZ/OutPj+MOzV72v9Q2J0Oq7mTMppq/5GSqZFz6+C3xCcDs+sLm1lGGSJ4rgysLXDcGILDhHoyTN4Q0flA50rl4pjfpcUap0ZuQDqH+Fplc5GnOlo1qW4CPAfsAs2rQ2I+7Ew2YyxUEjMGIJcgyaDyr6AVfgeIvkMARzdM453JePJozeWENILj7h4vpVn1KcEWtSyE6AY8Y/NUzppERyTfJgx4J6fb7s7ZbX5
 SeCDYie5
 MHP097w13eZtFe7mnBeMb6Ofk49V2CALPXi1dtfkde96rt3iffYKuhfRZlFbMq/lrryymEQyqphlIlBQNUhz89X4Kt2/FrFwsYOkMNejy6Z6Z7rMpmdS9ENYvhIPdrVEzDwEpKRmLsMWFF6H84NIkjDNGvEqM671dM3Kgf2Dh9JkX5jHT1MPih5tb4La6bEoeHyZeYdgzrHJbL/WDQXomzALh9Agk6cf9XFBms9nowF8244EMWM38P7MLyFgLh1VoH7De8fc8thmqkU3PMmVZ9YAM723dQjEh5ONdxzKWtSLfUiilg+hjeGdvkU9W1mJnpLUhHxQK61Lo5utW1e6EFqf5QpDLfCaTozAV
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
---
 mm/vmscan.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 061fbd168d98..acc4efccda2f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4192,28 +4192,31 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
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
@@ -5021,7 +5024,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 			   struct mem_cgroup *memcg, int swappiness)
 {
-	unsigned long nr_to_scan, evictable;
+	unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
 	/*
@@ -5037,7 +5040,8 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 			return 0;
 	}
 
-	evictable = lruvec_evictable_size(lruvec, swappiness);
+	lruvec_evictable_size(lruvec, swappiness, sizes);
+	evictable = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
 
 	nr_to_scan = apply_proportional_protection(memcg, sc, evictable);
 	nr_to_scan >>= sc->priority;
-- 
2.34.1


