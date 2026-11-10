Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B05960A5BC3
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GQfpZpJD
Received: by kanga.kvack.org (Postfix)
	id 155436B05C2; Tue, 10 Nov 2026 15:21:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12D246B05C3; Tue, 10 Nov 2026 15:21:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A336B05C4; Tue, 10 Nov 2026 15:21:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC39C6B05C2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:21:29 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48B47A86F4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:29 +0000 (UTC)
X-FDA: 85420329498.03.A8D598C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A6451140005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQfpZpJD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AiZ7N6GU02U+o9iesZbyf8ratkWg+EWsdL11fnyuYU8=;
	b=HT02sO5N4lAOE6NgC3cWMH+Zky2D6UxemjhCbUuQeiQHhFVP4vWzY63BUAn4LVJHW4cE9e
	dqBXle2UdC4KF8rOgyg2+iPx2yvwscrG7D40MdFYdKNROXI89nOxyMCYkPXMMxw6bBDaj5
	gRAT20iKPtbdF8lL6qDvmHZjRzzePUg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQfpZpJD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342087;
	b=vcy2A8bhnMW6l19kuukZ4DvNa+41u1cFmtvYs27OW3u0KTtgWjrwITTE5hkzPYUihVIFZr
	4f1iZAHsb0F+qqy5UGoBTmsT666hhuzBncLiM6yKJZqoklDZ7khOZX9psjQt55wIBqCByV
	dIKXKMBf6ePCvO3IgUvHLpPQObCkzbM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 41A5561469;
	Tue, 10 Nov 2026 20:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F56A1F008A1;
	Tue, 10 Nov 2026 20:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342087;
	bh=AiZ7N6GU02U+o9iesZbyf8ratkWg+EWsdL11fnyuYU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQfpZpJDF5NPDaWm5L0da6tQj33/hECXNWhj2Z8APnZoHS2nsmjGCgeYvP3O+FqnD
	 PpbL6c/NCc9ulYh6r8/eTyb7O9JytaP9NkxmD5unJUPv1SZVRakV5iITHyDbCtfRxn
	 MHwlyplZPfzDZxJzcHfBL4G5sarT6b1swJVj/HOtLDTtRieozKqrjLQ9mp6Fl/AXZ4
	 d6VOTv57FKYCINNCi6vGIuwWmFjK+ZHsxf6t6LdRxl2kMtX62bOHBEJGKzD4EU0b6j
	 dIcH6cH6LujqTdjhACz1XpeX7PoyTknXYnXBdoNwFnXMu5v/sNO8N7ljsS9gQ7OXzy
	 VXIhweELWI+CA==
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
Subject: [PATCH v6 10/15] mm/mglru: Run aging when pages are rare outside the youngest gen
Date: Wed, 11 Nov 2026 04:20:20 +0800
Message-Id: <20261110202025.25736-11-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261110202025.25736-1-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A6451140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fxg18e93rw6sqnm4o4eirh88dtzwog11
X-HE-Tag: 1794342087-2539
X-HE-Meta: U2FsdGVkX1/D1WVa9FLZtQILSPbOD96mRYvYxwHB988g3LAb8NG6FSXUjIEn7rapb5zd1OX1v7X7ZYykGBiOLT1sokI1902+DepaTIoU7K5HR+sXoOWiuuD8LdZ6NNKJ2P5NrEZYUdVJJhERqFlE+ys+8hDW/phADyuaczsyFwAFlE11udP0i27H+j6U2SFxSf5QsrWdfxQEZDhwG8LTqvyo9GUL6MDqZUb0UOvfkPprjAzrim29cyOKhPoBQ/F8qjlIzHEseO9oinLqOEp+E8dmQxe7sPAcG7185h/sna5w37vSTZ+YJW7fY7Ngq89UwE+51Xsvk2dWfHw/5MLBYGZ8cL5iY+oSOT0MCq2mgF5SX2uUF/j1ahsl9nJU/a2iGhxVNPdeW02wyTh06Cgg+a5A9CDJ5S+VtIa/LJVvor1YO6Pf6kl9++AJvtr24w+yk3Cd4eUbhajuFTjVYGqMQR1cumokjeoCgLGY+ubvAZOjJzGdLA2/5dRg0Y3Kg+iIzk41VrT0NJabW0o7No/YJHZd+YVFJKWQyx6C5UcOT7Yj+kJ2ZmDaWPpaCgrT8OzkIuYCfsHJLpaiZrVPUcfFRRF975q8cF5Qx2zT8zrNpQHm95YdzUWCrXLFVG2deFPWmiXo2cc21Z2fBbIlEIblPBLSHb8OoE8Iy+guPIPQpAqbCT7ORKxyY1IFPSBpScoVEj71UQyjEd/BqnUnNLuqJHKxdzAqtWpXl3b8j2PTyOk9GNyE02MzmcLiWk2oghtARxEjpWL3weKD/Nj6uoCMPBPfPQ4KfKsZCjmZGzIPshQaT4jq3OHwS9/sOWNzesQkb5pgclzZRNYBc6SXnBjOGOT456if78Jht9ImF4207lZltNkXKgcJ5H31BaueWLasfJ/mL29/2m7i5PdhHvCjCBWFYS8rg1oj1jZmDNq6m6zqt1rTvmBRu14Ox+r7VxcQrmZkD6GKNV3pJ/qM3Tj
 Kj4zV1tm
 10uYusp75or0xHsBwvGrClSDozlerfdhFLHveH1iOWrgwmkdvbJrhDLj9d3Ol9miblte5HfFAiXbjbwp7KUVD7ZtiFlUqY1JTFejZEAtuCv5tX04d+9D93knUY9/GXZx2+I1Rcrlo1c1cgrtXDixqDBTPY8k+eThsZuhkPAyJ2v2gerHisnoHFb6/KiS7o1rdmC3Dy6mMr6Gv9K5Zz3nVvMkVQ4SYI8l+3GkFFgvpds9R3m0xUNngQt5oKgdDRhAGPCuKwYs9pEVd+/kAQhtraQgr8VFlSFg8amSNLow8K8cxogJMcZIi2VqCiBjvW+vK2b4uPcEw2fIGA4U=
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
 mm/vmscan.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bde67da7db57..8014a90e4bc2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5068,8 +5068,41 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
 
@@ -5082,7 +5115,11 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
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
@@ -5168,6 +5205,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	bool need_rotate = false, should_age = false;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	bool do_balance = (sc->priority <= DEF_PRIORITY / 2);
 
 	/*
 	 * Proactive reclaim initiated by userspace for anonymous memory only.
@@ -5192,12 +5230,13 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			break;
 		}
 
-		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
+		if (should_run_aging(lruvec, max_seq, sc, swappiness, do_balance)) {
 			trace_mm_mglru_aging(lruvec, sc, swappiness);
 			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
 				need_rotate = true;
 			should_age = true;
 		}
+		do_balance = false;
 
 		if (!evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH))
 			break;
-- 
2.34.1


