Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CD11606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AZU/Dwpe
Received: by kanga.kvack.org (Postfix)
	id 658566B09E4; Thu, 22 Oct 2026 18:03:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62D146B09E6; Thu, 22 Oct 2026 18:03:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 549546B09E4; Thu, 22 Oct 2026 18:03:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29EE26B09E4
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:03:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F5E51A02F7
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:03:07 +0000 (UTC)
X-FDA: 85351638414.27.E099334
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 050C94000C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:03:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AZU/Dwpe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792706586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLvjEAADfv0lMkt/oWv0SBDRFtk+jw8902krm/ExS1g=;
	b=Mo/I7Tnlho8jNvX0eISjn3JJoVkGlWm/P24z0soBhxqyUIPGS3sBZJhNhIBAuCn4o1+SuK
	VntFoct17bUwxWf+WisnfoyGnANf75uVdRdVw8t1BJZG9ip0h75egOrYtJOnrepETomtm7
	C7f5SxRc/7ABZSOGK1olKm/3scPalTA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AZU/Dwpe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792706586;
	b=yu6aBqpQfIn/sTST880lCj7MC9verkHxsMk8VxIFXlYhf+pm8jYE8DQP+UnJb7ZPyMRKlp
	Cd3zeEfKh0a7Z6wG//L8TkBw0D78hdAh4XvxpZbyR/WensjLtKazgKD5ERfWT97azh5FPc
	uGWpSM1ezHQ2/ygRMWSyYCxeKpKzr3E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 908D060233;
	Thu, 22 Oct 2026 22:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628851F031E0;
	Thu, 22 Oct 2026 22:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792706585;
	bh=gLvjEAADfv0lMkt/oWv0SBDRFtk+jw8902krm/ExS1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZU/Dwpep72q0zWTolU+Us8yktbHXnNC/l4mmgiJHwyOoJs02uHtVBOQiL5SDMcco
	 S2BL1DNNRaDtpBxvuORjS+WaSfv1DKqsF7RsMPwawI1g5h0ZPdDrC0KJit1TeuAcuY
	 f+uhjAXuyZIm8faeD2aokYfcQiyZ99N8CiPnaSWUjvf6PRltdksb6fzhe1+88/ohwp
	 b5OEiJdZ9whgLcMGQmGPy658mxqN872PAEjNy+FC5JR9tXykoFzf0KM/Khehs/SMYV
	 x/uey5AGMxt/5RVdVoYgxuTkRc83R20bNqZdFIoXP53GTHk/KhRs1JtY6YHVHVJPX9
	 H7abMqQD3IAeQ==
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
Subject: [RFC PATCH v5 10/14] mm/mglru: Run aging when pages are rare outside the youngest gen
Date: Fri, 23 Oct 2026 06:01:59 +0800
Message-Id: <20261022220203.91911-11-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261022220203.91911-1-baohua@kernel.org>
References: <20261022220203.91911-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 050C94000C
X-Rspam-User: 
X-Stat-Signature: st9yc89is7k1b3s6iaemjb4eri56uijm
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792706585-656126
X-HE-Meta: U2FsdGVkX1/lAjc999NskQYEl3tEA5yxsfH/H3izK+ZjoGDpR6kIW6KGs67GCA+tjAMvBUmv3/VKs9sY5zQKkgRhtWtQ6P6L08KuUmFyixsLYC5lk++sIsrFT/jKSZJH8unr7QDjhvw6Yc+CAHp3bMjfknNE+XxXOKIUjSodTvoaNEIolzvSMOqBwxhzxhLX2Wl/nw3yFHVYE/h8kyZyegV0WymxvsJ/IBfNhqgRgyl75nE6bd+yP4ILKSDTuW7imICYpcEgpkVgumm9Zdyo8NTJSxpxnpateuaAYChLT1QuM2GYmmnZ859adSgKM8Gh5iFNtjsrZUnD72TMjSk9ZkDzy0Y2wDlFM7SHyHrmslgiwSQtQMiNeEfirq+B8zcnxRoVLVh8Y4+7n3e1BZDwehZUtLKyF3RAYmU7NZMOGCWk6Cfeas/PhTxRSd/CcpTkhO13N7D2/0svZZFK/Cuj/M+1sQAF8zrJiM+McJk1NlTSUhMkfXP2ls/abIqUw6gE1yrSg13+5c4NYcBGWoMdgB3X+V5rawfO125tkFYqaf/V+SicXyso2iKwqqeiRnB1KmQsf4GVgh55/hKCqOO1477pXFOZlMaMtOCPzQ3+ZRQMxxoeo+FMuwnVWEoMcB3ENuIkgGx7BFe/rvhd3jkMnI8uCgBenEDhSEt/oqB190ttRX+YOKosLidlZl1X65Z3sBSDaqPJ3vwWZXM42FgKgPisXG5uY6lKN7hgK2LA6DqWGD//9Heut+X76GagHuusYyqqj/nCPjssRYvbCELg8B/r5S045ZLdZ14/c3y8VzBhvVXSRj4a9SfLoF/GK1hNcYAUfatuDOTuYA3X21uDw0Do9Y7YghHMHhNry2ZIsNoC09BgLrCBf9/roVBtRT4ABPOlXQ+Hru2Wr3Qd7S25WVYI/nbXaftd5C0Kw7MoHj0xHpLAuaVT3pIkqx2RPbG91lzQ7C1sfFxaxiMAMZV
 j25+yM7v
 XuL6AiK/lLIrMBTcMUfc5sTCZg4IN495fHqitIfRjPwzfgkuBADgTPkgpDtOl7PTuxC7ma4K9VaxxIsFXGdwpG9UMeNII43vSgEmJoynvk/Z+6kxoGSbul2+cH4fnGuxtmF/lHCDIhkX2+DSzUPARE0Fsay2FmAbB8nmde9uLWxRRXaQnOlCbM+sp6c1xTLOWubbqlQwp6Z8o6c+NoxrY074zngb3I0zINa/eu//XEcMsBizA6loHcjNCOCyjcJdKhA2hvxIMDqhDME/OkwScPWTQjFHjA6sTj9s7sy5pcxzNf1uKJjJ3nffeWQhg9XDwrbd/owNCrcqY1dO5HPY72wznhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: lyugaofei <lyugaofei@xiaomi.com>

Run aging when the total number of pages outside the youngest
generation across both types falls below 1/MAX_NR_GENS of the number
of pages in the youngest generation. For extreme swappiness values
such as 1 and 200, also consider the balance of the corresponding
type.

This improves reclaim efficiency, especially at extreme swappiness
values, while reducing system time.

To avoid the overhead of aging, we only allow imbalance-based aging
when the reclaim priority is low enough that we might reclaim the
youngest generation. We also limit it to once per priority.

Signed-off-by: lyugaofei <lyugaofei@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 65 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 56 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 39f77a68be37..e8eeeeb76282 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4346,10 +4346,21 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
 	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
 }
 
+static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
+		int type, unsigned long seq)
+{
+	int gen = lru_gen_from_seq(seq);
+	unsigned long size = 0;
+
+	for (int zone = 0; zone < MAX_NR_ZONES; zone++)
+		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
+	return size;
+}
+
 static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
 				  unsigned long nr[])
 {
-	int gen, type, zone;
+	int type;
 	unsigned long seq;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	DEFINE_MAX_SEQ(lruvec);
@@ -4359,11 +4370,8 @@ static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
 	nr[LRU_GEN_FILE] = 0;
 
 	for_each_evictable_type(type, swappiness) {
-		for (seq = min_seq[type]; seq <= max_seq; seq++) {
-			gen = lru_gen_from_seq(seq);
-			for (zone = 0; zone < MAX_NR_ZONES; zone++)
-				nr[type] += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
-		}
+		for (seq = min_seq[type]; seq <= max_seq; seq++)
+			nr[type] += lruvec_gen_size(lrugen, type, seq);
 	}
 }
 
@@ -5228,8 +5236,41 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	return scanned;
 }
 
+static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_control *sc,
+		int swappiness)
+{
+	unsigned long youngest[ANON_AND_FILE] = {0}, old[ANON_AND_FILE] = {0};
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	DEFINE_MAX_SEQ(lruvec);
+	DEFINE_MIN_SEQ(lruvec);
+	int type;
+
+	for_each_evictable_type(type, swappiness) {
+		unsigned long seq;
+
+		youngest[type] = lruvec_gen_size(lrugen, type, max_seq);
+		for (seq = min_seq[type]; seq < max_seq; seq++)
+			old[type] += lruvec_gen_size(lrugen, type, seq);
+	}
+
+	/* the vast majority of pages sit in the youngest gen */
+	if (youngest[LRU_GEN_ANON] + youngest[LRU_GEN_FILE] >
+	    (old[LRU_GEN_ANON] + old[LRU_GEN_FILE]) * MAX_NR_GENS)
+		return true;
+
+	/* Swappiness extremes: the corresponding type matters */
+	if (swappiness == MIN_SWAPPINESS + 1)
+		return youngest[LRU_GEN_FILE] > old[LRU_GEN_FILE] * MAX_NR_GENS;
+
+	if (swappiness == MAX_SWAPPINESS)
+		return youngest[LRU_GEN_ANON] > old[LRU_GEN_ANON] * MAX_NR_GENS;
+
+	return false;
+}
+
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
-			     struct scan_control *sc, int swappiness)
+			     struct scan_control *sc, int swappiness,
+			     bool do_balance)
 {
 	DEFINE_MIN_SEQ(lruvec);
 
@@ -5242,7 +5283,11 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 		return false;
 
 	/* better to run aging even though eviction is still possible */
-	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
+	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq)
+		return true;
+
+	/* run aging when folios outside the youngest gen are rare */
+	return do_balance && lru_gen_imbalanced(lruvec, sc, swappiness);
 }
 
 static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
@@ -5328,6 +5373,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	bool need_rotate = false, should_age = false;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	bool do_balance = (sc->priority <= DEF_PRIORITY / 2);
 
 	/*
 	 * Proactive reclaim initiated by userspace for anonymous memory only.
@@ -5352,11 +5398,12 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			break;
 		}
 
-		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
+		if (should_run_aging(lruvec, max_seq, sc, swappiness, do_balance)) {
 			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
 				need_rotate = true;
 			should_age = true;
 		}
+		do_balance = false;
 
 		if (!evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH))
 			break;
-- 
2.34.1


