Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484D9606B363
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H/G/yeo8
Received: by kanga.kvack.org (Postfix)
	id 5CCC66B05C8; Fri, 13 Nov 2026 13:56:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A4996B05C9; Fri, 13 Nov 2026 13:56:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493036B05CA; Fri, 13 Nov 2026 13:56:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2376D6B05C8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:56:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D84940129
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:47 +0000 (UTC)
X-FDA: 85431002454.24.0E72EAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7660820006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H/G/yeo8";
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UwDbN1ot1ctIjPl8+wDFKVVJfwEO25eR5Kqm0MHFTag=;
	b=ZmAfYf/7f8NRUf+zf4QASq3fhfzD6n1dhmqHLFefRpJnkvEa0WMc01vDBaW8ELj365q6+q
	/6B3FJ0AX7XOR8sfcCik8OLi/mxgMZNpa3R2xwGQdox/2OSKgiJU/VtALMcM4kqCKKbolg
	rkpwvRDlord985TEF9SQYlDc/bBPAWs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596205;
	b=uRCaxaDmhty1Zayo9/AeLGOZJL5eFbLEFu964KiJ4oyvrj8Xr2v8oQSy+g/LkXilNDY14b
	Wc/uF42LklBNjMkTjD2PFFlG+1o6xOv+1W4Bw6nR6fvZnq5mn//PE0zT/O8eYOTxTKUx0X
	QRSL87snPM8cc4xjZ+k9sSgDhkmAdRA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H/G/yeo8";
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F91363295;
	Fri, 13 Nov 2026 18:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DDB1F000C8;
	Fri, 13 Nov 2026 18:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596204;
	bh=UwDbN1ot1ctIjPl8+wDFKVVJfwEO25eR5Kqm0MHFTag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/G/yeo8k4o8R6b59GQ/duO2ACA4Xo0LrB+SdVheP/1sMYcYRxEb3/BGXXGKDp5KP
	 P1Vso85yxB+MDZvwBshmZxjZZiyRdRY2UkDdZqGMpo5PWTyMN8BdJrMIbT3Thu2eGF
	 tl3YUP/F7hbbdD1R59yjl4wByMoFVwo+kKLqFcfndGYBwUXLp4Lajawub3YIGseiRN
	 YCYWdUTQ1AbdJ587s2g+ZR81kLKv5NSa5BAXDpzoRUqCGVVHZvxvfcWRS1xEOnHXL2
	 +OQpplN1HJIdo4/sffCHdO7evu+IZF3XmAODn3K9Af7hpnMRw7zc7DlRY/nZKvYII3
	 c1dFagW0IQnCQ==
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
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v8 11/16] mm/mglru: Run aging when one type has no populatable folios
Date: Sat, 14 Nov 2026 02:55:36 +0800
Message-Id: <20261113185541.70203-12-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261113185541.70203-1-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qf3r9nj8wnq35w6jkydta17eujno33hq
X-Rspamd-Queue-Id: 7660820006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794596205-852674
X-HE-Meta: U2FsdGVkX1/ubRPIAGsrwI5K7j+nhzfdkXlp0lE43XNaA1eYPZL8QMmblsBNvDpDMVUHDKh7u89Y/1B2Gfe0XsxnflWy0g2aopUpidQ34XNaeiMJ8rEzI/BCt3i0JqwrOQrVVtsz1/TJC87Uw3cu3LavL5XRCE/P+CdsScsznBvwVKCZ5XOz/JSg7e/xcMdw1cwqvkUTXTcvSCBaPEAqFbeShUyW75KuI4HDrRW25puIK10yGQcY3ICb0hSmeG1rhLXeXcj/WPY95ySDOkynjUR13UePj4WhozR/9QhiKnw7ccrPt0A4jNE05uIim+CwIOr8VV7U9ouakBpNO6bHvQ8bHMCxmS8FNZs6NTy35Vxm4cRxNjHsG5qXkh8hBkG8vMzrz+1mybSZHhfEeoyunrviJiMyMdMILmNoQkk4CbTAWeMSz6H5HgsvcyEOXD8VMBFV9pcxQjjEYZNsuvYEHETjMtNITsqjuYP8jyHKdsp+Jy063+9N+jYFFKaVxNmt7cfPEELWB8De22AMjwen++duy1qg4DdZB4GNm2F7FQbFONenttVBpLzqH+0UrdOLfnT4hAd/ah+42zNMIzoXCihZvU0Trj6YOSDopJl96WmEU1+jQRzAhZrzWsaI+o3qmQHS1bOaggZEzD0Wb442l1En3L7ZQ/hW9tUgL4sgcITxAUPsoRntKM3p+f59tY/Z8B9VYDzhP4duB5PNhZaVzr/agDsFJM+nPWzT0Ik9LSqjABFcOZgWf9LM4ixSKnlTutkzFsDxIjRhuCXFFK6m4lIevkIl2j8A0AB+ziAMwwlzhdPPl8IJAEPW3s/o0Mu+HDqI1jsBW3eoWuqDjy0krE3btJIItm2d+1SHn8h9M+yKyb6EzN4HCqvVrFgXBWL+o+5BV6ChDt+zhJ/LznYaeH1xxW6DcAY5+jKYW4KODZ3shOxxWSitBfF8YWaPRrJEvIrEnPtOyRgAsIq3q2U
 fpA29xOi
 aOB7YWTzXkVv0YqIQicE2a4dNvPlLZqE9Kup4rl25sIf1N0Tg4CfEvN4o67V2lt4hhMlHe6sWThwSgVEAznzcQGqsuoGHEipjNx2VeotXAG4cI0nJCgRAHcbwVHPmTHRMdV/Vl8xM1fjVdE3CztV5z9mK7sdlimQG+nds+n6IuXQL1LCNXYIHvykDJzzO8p2O99HZOlO5TFEFy4wU93MnM8euJqi/arDanQ8LQpmtTD/LX+bQiD/RXVGxvAjb4mjU+xkJkCvv130LVG2llGVdxiWbAHmLtUuDZQ2s1dAZ48lwi0sBq1KKTCgjxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

We may have scan budget remaining for anon or file but no
folios in populatable generations to scan. In this case,
`scan_folios()` may waste time scanning that type while
the other type still has populatable folios.

Run aging in this case to make more folios populatable.
This also helps respect the scan budget distribution
determined by swappiness.

To avoid excessive aging, allow no-populatable aging only once per
`try_to_shrink_lruvec()` invocation.

With extreme swappiness values such as 1 and 200, reclaim initially
focuses exclusively on the preferred type. In this case, defer aging
the lagging type until `sc->priority` reaches `DEF_PRIORITY / 2`.
This avoids unnecessary aging and has shown better performance in
testing.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 49 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 59957fab915b..9071f8889b5c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5109,7 +5109,8 @@ static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_control *sc,
 }
 
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
-			     struct scan_control *sc, int swappiness)
+			     struct scan_control *sc, int swappiness,
+			     bool no_populatable)
 {
 	DEFINE_MIN_SEQ(lruvec);
 
@@ -5121,6 +5122,13 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
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
@@ -5208,6 +5216,13 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	bool need_rotate = false, should_age = false;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	/*
+	 * Avoid aging the lagging type under extreme swappiness,
+	 * as reclaim of the unpreferred type is disabled until
+	 * DEF_PRIORITY / 2.
+	 */
+	bool allow_no_populatable_age = (sc->priority <= DEF_PRIORITY / 2) ||
+		(swappiness > MIN_SWAPPINESS + 1 && swappiness < MAX_SWAPPINESS);
 
 	/*
 	 * Proactive reclaim initiated by userspace for anonymous memory only.
@@ -5225,22 +5240,19 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	lru_gen_prepare_scan(lruvec, sc, memcg, swappiness, nr);
 
 	while (nr[LRU_GEN_ANON] > 0 || nr[LRU_GEN_FILE] > 0) {
-		DEFINE_MAX_SEQ(lruvec);
+		unsigned long orig_file, orig_anon;
+		unsigned long max_seq;
+		bool no_populatable;
+		long scanned;
 
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
-		if (!evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH))
-			break;
+		orig_anon = nr[LRU_GEN_ANON];
+		orig_file = nr[LRU_GEN_FILE];
+		scanned = evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH);
 
 		if (should_abort_scan(lruvec, sc))
 			break;
@@ -5252,6 +5264,21 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (root_reclaim(sc) && should_age)
 			break;
 
+		/* Limit no_populatable aging to once per try_to_shrink_lruvec() */
+		no_populatable = allow_no_populatable_age &&
+			((nr[LRU_GEN_ANON] && nr[LRU_GEN_ANON] == orig_anon) ||
+			(nr[LRU_GEN_FILE] && nr[LRU_GEN_FILE] == orig_file));
+		allow_no_populatable_age &= !no_populatable;
+		max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
+		if (should_run_aging(lruvec, max_seq, sc, swappiness, no_populatable)) {
+			trace_mm_mglru_aging(lruvec, sc, swappiness);
+			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
+				need_rotate = true;
+			should_age = true;
+		}
+		if (!scanned)
+			break;
+
 		cond_resched();
 	}
 
-- 
2.39.3 (Apple Git-146)


