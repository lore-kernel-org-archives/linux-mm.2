Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47FB606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EZxbUB/Z
Received: by kanga.kvack.org (Postfix)
	id AE7206B05D6; Wed, 11 Nov 2026 18:26:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABF566B05D7; Wed, 11 Nov 2026 18:26:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FCA16B05D8; Wed, 11 Nov 2026 18:26:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80FF26B05D6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:26:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F040B40478
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:26:19 +0000 (UTC)
X-FDA: 85424424078.14.676D4F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 56F59C0003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:26:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EZxbUB/Z";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XP8BVGG3k/SgxxucX4Qss0oWT0tMPudgWX8MpTd7f+o=;
	b=pOMtX+ybd5U2FztZmv9L7nkhiq67lB3c+jkc4Qqha3V4dQwHEk3pPeui+Bbt5jgPTYo0aK
	4kozpYQWoO9NtG18D3WuL4tweUW5wh1AbTu2HFGZEPDmiafEfDTJo2AA29+vsxXB2OStF0
	miPF9Tbsaewga1yn4ke6TLvEYiLMWjE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439578;
	b=GbrqmOCMV/x3PszSJIPqsWR6bPgvWZ15vDeMbuNCHka0YdJArTbkWzVoUXChzXa/fKG3Cq
	Vk0UlogtmOqCgwMQ3W4Uq20IZPNHNW9lw7ePQyxJDcf2TaDgwqA7dPyfJc2kNLkHD8/npP
	cukJYWJPEt3tLruwc1fQ2BSeebhLtng=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EZxbUB/Z";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D400063611;
	Wed, 11 Nov 2026 23:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65701F00A05;
	Wed, 11 Nov 2026 23:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439577;
	bh=XP8BVGG3k/SgxxucX4Qss0oWT0tMPudgWX8MpTd7f+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZxbUB/Z7guwRZZ/08dAkZz0LLA30SSS8kVtBtH9dYNhkk9vo6OFA4OpKQuBqvgu9
	 ZZ5/r5dgZSqPgmVcV2Q+lXJ/NUxMWFHlyHYLNXCBaRbyQchcCFmHR9YX9wJkMzzbsu
	 8KN7bKEzSXiWbtcIOW+x0kQp6JwGQ0yRc7npIsi68uHbU7aaR6XBXoP/+yRG4DY6bK
	 hMO9FKhAI9hzwGHgsxktbCQ2WqINtAqESUm1LNfLdJxFXBidzOn3mimI1kuIj/csJ1
	 TOynbEFY9zJNPbE/yL584+dd8QVtkaonKTZARJ1LILP+K6bzwYlE0BcvGNsARa1L4Y
	 pmbk4YTy+md9Q==
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
Subject: [PATCH v7 01/16] mm/mglru: report evictable sizes per type
Date: Thu, 12 Nov 2026 07:25:48 +0800
Message-Id: <20261111232603.9934-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261111232603.9934-1-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3hqqiprpjd8wk13gm1bzomq61a43gom7
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 56F59C0003
X-HE-Tag: 1794439578-16407
X-HE-Meta: U2FsdGVkX191xc99qFKEoElxopYeSUT0StrK4w4FvNk8qWHmk21N5W0dt71b6awxkJ1zEz1m949JWMuoQiWzbGgNPz9QOWZgc3c7r23LFypNiamzzBdeaLfcvwZFuvNeGfapBCWnVDz4lveva6bpwYbOsUfTSG0QI9x1uXvvwAv73BjuE1isW3tPMYV/VET3S8MUkPfxb+f1w4pWQDEsfMsVI6V57BxXhOw25EzCHgBmrjrmSukvYzJ0n+gPphKrppggZhCX2StvstC/T+EToEYlsHTGaVNon1UvWaOwcp/slqZ4SwBQqkguMjytYDpk6fcqoElgwGCSqf8iIPeU19kVKHsQpjWJXfMoM7j3wTr5t5cX50LaNRXTJTRbROzznqwTkmsLflW0Fyc9ar7ZK7tmPHqL+/Zp9SUgM8oOxx+wWlSZulAgx3ErMK611gTvQzjF16BvR+ruVZzgu+oWVtejKgTSp6fVUmpe7X+diP5FzWORJmYAh9hfs/2XFVcl9nEOAGUJHB7ZGoryE6XKzb9tF1/yyqdxuk7WnwyQg5FBDA4pdMaRr3tGu72ZmB1cPrvlzdeHb/xOukjH6sMjgoweZsorZmbnXdthkngssGn0zKldgHchTRQUmz/7AezIDRirDVqA0VI6QjZFjwWF/rQDcxZYAdq87de/DI+OdBXYn+Nq2SgDLucfFLZuSZNOMoc7cpjZwIIrbf1RYpV7Y1r0ZO7wyGuqy3zbzU2ShksuNwTrl1/mO1SGez7Ed95luuRzwFyMj/aR6YdclFYWd2etj6XVuiPhBCCG+v6tqrbE4Z+uOHQ6gNOSpXIbu7I2+ouEEwdD0KgJdnH0iFxG03TnUC4JAt7QDQl7FrmVkbHoEtzUdELYg3VNxBQINAHxRPQb3LPuapClEQBexMF5XN88e7TY5j+0bgdin+l2prCi/AoNvpTzl072GCpTaKCnMGSjiUt6eMbP10Hl+Xs
 7k/Fwy8c
 0Ft3q04nS0BguCihMwpaPD/9RfNNW+kyQWqUZzm7lXeTRiMfzPUDUBSKC8BVX1GrEXsSmkS1EkSUt1DtnpNhlRaZcld2gUSRAFSidhaWoPQLCiPzFSTkjWGfHKsbTRn9z76QFPCHok7LTrQ6G+ad3nkgdx8kY1T2kSqxgptmePxAa31sj/pGg784fHUsm/vgZBP857vLiLIRNMV3srx7pDe3zQ/7oANLTqR7+D+wrKkrT2lvZzWOeME0DG6egeeP0jfPrA2/weM4fttOzrtIrCxCBSK9eCus4q5nE+HWV1kceDjqCam+QZ0CtdBqX4Ts7x0gOp1gRFv8770Nz9DS5R/JOBI+IcwYU9crQ
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


