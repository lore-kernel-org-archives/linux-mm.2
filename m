Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B9FD606A884
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dcZiCOXb
Received: by kanga.kvack.org (Postfix)
	id 655796B05EA; Wed, 11 Nov 2026 18:27:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DEF66B05EB; Wed, 11 Nov 2026 18:27:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F50D6B05EC; Wed, 11 Nov 2026 18:27:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 321396B05EA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:27:12 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED7081A0247
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:27:10 +0000 (UTC)
X-FDA: 85424426220.18.0E4E8E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 577252000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:27:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dcZiCOXb;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HVNLYWh2WNudvby9zWzUbNqB94HeT+AKpF3CXnXYX2A=;
	b=QqyB4kjb5HRb93vVa6j2ellpU+yUZldbsG4u7lJKmlOEFmRSyCXmUoHwM/8NQ3S0wV+4H+
	7LzMpxB7hNFl6quO7i6hRDC98irwhDgROnqiKtq2yD3RwNu19iavmFy2jjTDuLCu64FpdX
	LhacBZymzX2590oEed0qD4hKXzhpmWA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439629;
	b=uTKAX4b8VHa+MlK8pT75t9gUY3D2iJlJrZUBUjRBgHSWlCmnO3/FokeuJOT4x8w55Dty8Z
	YiYk/kFDsNxMYZG1cPfu1GJXX5SXJoImyVyCWDIrSLQbsLVJ8a8zX/Fjluc8AtfV3im6fu
	e+9IM4yU3riR1Q5cRVnQ5knWeQyLgwc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dcZiCOXb;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AEF53403BA;
	Wed, 11 Nov 2026 23:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFC61F00A05;
	Wed, 11 Nov 2026 23:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439628;
	bh=HVNLYWh2WNudvby9zWzUbNqB94HeT+AKpF3CXnXYX2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dcZiCOXbgswBvQ7UzVFoZlZiaycHb0NhXjZV/ocHEpQ3ngRdInmFasvgmGLeZKsjg
	 yxg2dO1365iNRwMiPGKntLA5BAIgEJGa7nnhTqM19oToXAMN9iMmfo+vYI8P71zEoa
	 /AjC1+fdK1C4v2aBpzW9WRziUNV4umRt3K8YRzgELDg+WF4L0Q10Y+dtKeFD7j4Bgd
	 PSr9nudyRMnDiIIJzeqAAkbj7wtMMbbJAX9yNm5DtLJoggNhadyS6OVH/fGOb/pDoe
	 pR8dtM+tjGtEkKfCbK9lsl1QIC5qSXIrm/KKvGChmcY3Ug/2s/KP9GCzvsy3X/301a
	 hs9Rijitx9hHA==
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
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v7 11/16] mm/mglru: Run aging when one type has no populatable folios
Date: Thu, 12 Nov 2026 07:25:58 +0800
Message-Id: <20261111232603.9934-12-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261111232603.9934-1-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 84pjbss9r8uwnu6xsjbpujqayjkz4x7w
X-Rspamd-Queue-Id: 577252000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794439629-380480
X-HE-Meta: U2FsdGVkX1+MVyGH7yuGNHDj9jc4dOTttghDs+AsafVDKdbomx5eLMoHFIBmcGb58WsWPUC2TpHhHawKv+r8HDAHvqm73hZBvZmjn2jSFmnIYONAPc0D8atsaHOOaI+uXicfUm1oXImiHZeKTeMiSGgdtEfbFrLQQfwqJdqDrCcEhQkpftphImZHSSA/+/VlF5PaC/bY4ihNeTlO+wDNB3zqierw2Xi6vBh5fswBg5sLyAiire31VLYLZJSAxoeMmLyjmjB7E2ooUSWBVGSRmCbYmhTV7iFrTrpT+A3ZdVxMZRSjAIAJ4d65A+t3LxX2feMMbkNjxoX9PNyIXq2lkYY9OCz3MnP9NWcx+9XqPIkOIZuG5ntg/jagvs0s5r0m4GomvMRhhPL7AmPwEzrdUGz2h+soHf7UygcDc6hHAu6j93g00lsUNuF1cGuUuafbLZV6JZOKySpU3w0jBGAOgOxUMrkzIqp+whQIRokYVd6qwGtFLEbvfHqYYdgfytIYWwjwoEhfCPalnnhv2q7qKhVaIICMMb8txCkZkBNcWjbntFKt1+iWUwgCbMf8k1A1Du+3rfTdwO56KQVN85d6KM3nt0sXxhK81m2IBsfOFGqujNoJkruQ+RqSu5jYCgZnhBQSOWFs1fW1rJaYiCJjkgbF0QjaA1h6B6ynWovIUYJqxlLTx7nG+LbIA31YkV+xwcCy5/9jOVP9JhEc7lqwSY41MQOFG0n1LEc69bofiuom/KaIlbBtqEFCkSb/8hOLgtWxmqrS28zX5bWv82+d3vMUSYpePvUdCXigKoY9Y23au72d7+076fvxsy1zF7O/Dq3Zq5BTUrDADH3OdnWZzcuDNvjQ8aHWonEkQuNRPC5thbpJqziZwUyMUjqYWCZBnpmFa81/rsSTfWFAuhafcvcWta2anWB5dj7AsvDuZDTEQvzK4HMJTj2GuoPFnTAD0cfUXMED62xhBU/V7EB
 Pp6OJ2Jl
 5RA4T79hKomOKqhjtkdGBe+snIYTbErm5SUrGIOq9+pSptokJ5ubBMUHrV02/NybYQaTTW+bhRZw45VQ0SSDtxplXDVoIGRwkwEsLmJIKl0KiilwVF3K4I0nCkuv7LnTvMIc0f3GLYOp/v9eTxmk1A/KBlrShBtILhBFOf3q+xPrZn6YwI5uWoIbwUFNNRVaMoLUv2+bLA3LPzfW7sG96wGFzYx1AeeFP79BZnGt5FC/j42rjyoN3jMiFJXmMl24kt0FAKVUQO1IHIB2tSMB+HXHCqKtOHrECtkQxOPqeVUWYl4fhsYbapdBdXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

We may have scan budget remaining for anon or file
but no folios in populatable generations to scan.
In this case, `scan_folios()` may waste time scanning
that type while the other type still has populatable
folios.

Run aging in this case to make more folios
populatable. This also helps respect the scan budget
distribution determined by swappiness.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bf30c5b95478..27c1547012bf 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5104,7 +5104,8 @@ static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_control *sc,
 }
 
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
-			     struct scan_control *sc, int swappiness)
+			     struct scan_control *sc, int swappiness,
+			     bool no_populatable)
 {
 	DEFINE_MIN_SEQ(lruvec);
 
@@ -5116,6 +5117,13 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 	if (sc->priority == DEF_PRIORITY)
 		return false;
 
+	/*
+	 * Run aging if scan budget remains but no folios
+	 * in populatable generations are available to scan.
+	 */
+	if (no_populatable)
+		return true;
+
 	/* better to run aging even though eviction is still possible */
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq)
 		return true;
@@ -5220,20 +5228,17 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	lru_gen_prepare_scan(lruvec, sc, memcg, swappiness, nr);
 
 	while (nr[LRU_GEN_ANON] > 0 || nr[LRU_GEN_FILE] > 0) {
+		unsigned long orig_file, orig_anon;
 		DEFINE_MAX_SEQ(lruvec);
+		bool no_populatable;
 
 		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
 			need_rotate = true;
 			break;
 		}
 
-		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
-			trace_mm_mglru_aging(lruvec, sc, swappiness);
-			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
-				need_rotate = true;
-			should_age = true;
-		}
-
+		orig_anon = nr[LRU_GEN_ANON];
+		orig_file = nr[LRU_GEN_FILE];
 		if (!evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH))
 			break;
 
@@ -5247,6 +5252,15 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (root_reclaim(sc) && should_age)
 			break;
 
+		no_populatable = (nr[LRU_GEN_ANON] && nr[LRU_GEN_ANON] == orig_anon) ||
+				 (nr[LRU_GEN_FILE] && nr[LRU_GEN_FILE] == orig_file);
+		if (should_run_aging(lruvec, max_seq, sc, swappiness, no_populatable)) {
+			trace_mm_mglru_aging(lruvec, sc, swappiness);
+			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
+				need_rotate = true;
+			should_age = true;
+		}
+
 		cond_resched();
 	}
 
-- 
2.34.1


