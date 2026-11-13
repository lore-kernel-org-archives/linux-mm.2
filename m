Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4F9E606F2D2
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XYnhaxNn
Received: by kanga.kvack.org (Postfix)
	id 88C7E6B05D4; Fri, 13 Nov 2026 13:57:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D7E6B05D6; Fri, 13 Nov 2026 13:57:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7051D6B05D7; Fri, 13 Nov 2026 13:57:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD376B05D4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:57:13 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BCBE1C0188
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:12 +0000 (UTC)
X-FDA: 85431003504.14.20199E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 24467C0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XYnhaxNn;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1OlEjsYmm/cCbozumkFGrfD7ywJiG+WaDbYa8rQI19o=;
	b=PONZ+nBHEXExV25GxZzvIYWw42T9q9lMtD7v4CsEe5XBnOZR00iJ0D94XEM+iy22KvpVQM
	yHIXtqWMd6hEi4j+KR45ym9BaXsHpkKYG+rhd5+RAEEeptXzADq/DzEaug2zx6tmKbxZ/3
	7/S9jH9B+D0T6RM1smDY4ktWGYMsaxc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596231;
	b=QNyPATQ+AVy6AnNmBn6fu+4MgohQIZTIK9Z6nstFvNe4n16K6uOj5h+573YHEI+msAISe6
	5WezrC8x/L2vwveDPqwMGNEZlMSbkUksHZBuoLVFSjIW9l5YShw/8AvieJrzNmmtB3dVd5
	Hv1UpK2KnPm3UeWYU+F0Uhx8lYfE78A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XYnhaxNn;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 755D643A12;
	Fri, 13 Nov 2026 18:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD871F000C5;
	Fri, 13 Nov 2026 18:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596230;
	bh=1OlEjsYmm/cCbozumkFGrfD7ywJiG+WaDbYa8rQI19o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XYnhaxNnpgQvF9GbMZUF1rfFEXUUigOusiUfT8Ks0H92KBLiFW7prcfxLi1rzgVmu
	 7G0CcbOHJtYxRog8gCMUipGroH14GJtbQeCwiEwhZUxBVOskxQ1Sb794LD/4t/fOGh
	 AjwzTD0ASqqQnNiYFPAIMR8u/WKtVWRfDrV5lMOLKvBoxs/zRlO6lsd6YErjC0C1M9
	 ZzHV0qcMUdesqUpi8+tLY7czQUdzXhWpsal0b9AFenITdDKZdxAdnQf8zw6UYgs6ik
	 xibmDuRSaDTxcydDpSfgYyvUih5iDSzVEDOQuz50f+4oytQ4EYn+/ffe6Ocum2VWvO
	 gSO3YdVjxtXDg==
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
	Barry Song <baohua@kernel.org>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH v8 16/16] mm/mglru: Avoid scan anon while swapcache is low for GFP_NOIO allocation
Date: Sat, 14 Nov 2026 02:55:41 +0800
Message-Id: <20261113185541.70203-17-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261113185541.70203-1-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: bowze1jz9myh3oy99ypjrnpyagj1bo8z
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 24467C0003
X-Rspam-User: 
X-HE-Tag: 1794596230-374829
X-HE-Meta: U2FsdGVkX19jtd+rAj/FwJWNPPrtR6lAR5AoMZuQpfnHJCvlpQpz9kXjohI9XyLMak2Ayn6V1K9hVtSx8AUHeKqBpl+2hxbr5R+p7q39X0D2BCMj8RH7RaVpOdqcfZBkrY9w7+w0+aJtPY08WY1mS7yznYU9ylc7FBSv/7Ia1DdjkmgHuSZoZJPJsqDIt5PW2vYUm9l6gZ8yzBamGYcJBYCiEFZMPxYMRUxteNFLCau4l4T0tyaO5BySoUE3EJ2MK0yktHLrRbe+FqRMgiZrLPooJHt8X06ENjbEODH46+cV4JOkQLGdmtb7G1dOv5nlmUveI7QFshfL+1oZ61uNxsASQMsggz8wxt+bhApzG0muezp4A/5ePFJ/IfyjWkidde/5f77orQi9utj5JORPV7CKo2vJBxMrBsxQas67XrJz9MANmYohOsIVxAMzAOsmFwPSk1rwbdnnwJmeRY7gkgkb3OhicFwBZduz6dB90O9iKz0zpxlENzNP5x6SxTtVry8ya71QVJYzur2mhnAyY/fv7jw3dUoGLbHiUwrUe8hv25KnuTdXbxlPMoCcWUv9f6cIThrhdoG/Xbc6gQQL9O/WDvHoN0atorOoFgoFZfiHzIAGUSN7gaKztW7EqLSPRJ0NQSZLp5EJku7M/mdnx0sx98P7p5NSgrqrArUdtAPIeyHq5PltXvcYqOXPSssvtRhYbZ1Vm+ZEPXksP4jPUZbBxNIQHRLVzESoSBFg3knz20XdSAb24j2QvZvBS3JkN0eveFtq9Gy4GHpHFr1VrTjcFa26xsVC+DZ8oUEjewiTCyrlc+IvxU7yLtEdz5XXo5FvezF28JApGgVb7IRhqHHvX8owP86wjIRS0kyWcI0cmL1MOEwpyIra/cg51Xu3yDXbel0XwemKs6uG8TJqyQ+sbVzHO5/blvq5tmi4MxkEoFmpWVgxbbcpZh9ZrVPw/aD4Urpf7pqfzEv+hgT
 6XJcHb7e
 R8HPsqye6xtZTMwzUdGsmTYppsYSVwzlvRxuVKaoxYgo5LNKNaITKft0wbuqcfwCq/n8waKrewUcS6LEVgd46gqSd8Iui/GS7yvUAYl3pBLTNKnU4O5SXI19fVpObjZwcRTv/04B2Ud6DRH4WWSmqANpuHfqx3FzXlAxaEWrlU/YXZmo7pkB7desm8H2GlbRGSbqCHnFdx+c6MekH8goDHG+OibIKzVns1TJemTMit7VqF4E7Ljp2KqIz8f+9lp/I2gIUWK9BIwfje9MCjw8yjNIm/hczUEfwZR4c6h57cGKva5VxBe0iSa4H9AWJS9zumvuUM94TozHVNNWXMUDSRuWPda7FDmpLN2D3fPcBz18h1XBqIma1bhquCmfRfpXu93nA2KbkneMj21oRHzLxrSqJWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Bo Zhang <zhangbo56@xiaomi.com>

With GFP_NOIO, we cannot reclaim anon folios unless they are in
the swap cache. CLRU skips anon reclaim when the swap cache is
very low by commit 74d9aa0d8e98 ("mm: vmscan: avoid anon scanning
for GFP_NOIO with low swapcache"). Apply the same logic to MGLRU.

The new scan-budget-based mechanism makes this straightforward to
implement. Thanks also to Xiang Liu, who previously attempted to fix
this before we had the scan-budget-based model [1].

[1] https://lore.kernel.org/linux-mm/179248830836.1744016.8424217811286616919.noio-mglru-rfc-v2@bytedance.com/

Cc: Xiang Liu <liuxiang.277@bytedance.com>
Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kunwu Chan <chentao@kylinos.cn>
---
 mm/vmscan.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9ebfa3e4eeb0..18a3332c71e9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -272,13 +272,6 @@ static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
 	if (!sc || (sc->gfp_mask & __GFP_IO))
 		return false;
 
-	/*
-	 * FIXME: MGLRU doesn't fully respect can_reclaim_anon_pages() for the
-	 * scanning type, so only apply this to the traditional LRU for now.
-	 */
-	if (lru_gen_enabled())
-		return false;
-
 	if (memcg) {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
@@ -4211,6 +4204,8 @@ static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc
 	int type;
 	unsigned long seq;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	int nid = lruvec_pgdat(lruvec)->node_id;
 	DEFINE_MAX_SEQ(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
@@ -4218,6 +4213,8 @@ static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_control *sc
 	nr[LRU_GEN_FILE] = 0;
 
 	for_each_evictable_type(type, swappiness) {
+		if (type == LRU_GEN_ANON && !can_reclaim_anon_pages(memcg, nid, sc))
+			continue;
 		for (seq = min_seq[type]; seq <= max_seq; seq++)
 			nr[type] += lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
 	}
@@ -4904,23 +4901,19 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
 {
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
-	u64 anon_scan, file_scan, total;
+	u64 anon_scan, file_scan;
 	u64 anon_weight, file_weight;
 	int size_bias;
 
-	total = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE];
-	if (!total)
-		return;
-
-	if (swappiness <= MIN_SWAPPINESS) {
+	if (swappiness <= MIN_SWAPPINESS)
 		nr[LRU_GEN_ANON] = 0;
-		nr[LRU_GEN_FILE] = min_t(u64, total_scan, nr[LRU_GEN_FILE]);
-		return;
-	}
 
-	if (swappiness == SWAPPINESS_ANON_ONLY) {
+	if (swappiness == SWAPPINESS_ANON_ONLY)
 		nr[LRU_GEN_FILE] = 0;
+
+	if (!nr[LRU_GEN_ANON] || !nr[LRU_GEN_FILE]) {
 		nr[LRU_GEN_ANON] = min_t(u64, total_scan, nr[LRU_GEN_ANON]);
+		nr[LRU_GEN_FILE] = min_t(u64, total_scan, nr[LRU_GEN_FILE]);
 		return;
 	}
 
-- 
2.39.3 (Apple Git-146)


