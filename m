Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A837EFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638FE6B009E; Mon, 27 Apr 2026 14:07:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9366B009F; Mon, 27 Apr 2026 14:07:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48ABC6B00A0; Mon, 27 Apr 2026 14:07:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 301996B009E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:07:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECAF640290
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:16 +0000 (UTC)
X-FDA: 84705117672.14.061E91A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id C8A1AA000A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uVUTfkgG;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313235;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pg+NMGxnOwqFzqyg3+NiMwzxiW5pF5OgjL6klE8TRLA=;
	b=hiL+Vi55um96sPn3MvOXR68bJKEclGE+MMFkSsi0/0Z9dFCATn0ak+mv8F9IFhY298ZO7r
	akYlXF+X8K2/IURq2nW1frsFFe1JU95ZoI/qBDiKSKaZVnT77DwDpUO3yctZ/fGsAbSMAH
	6/7yJzQqQaxm4irIRvtklpn1dBpkrqw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uVUTfkgG;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313235; a=rsa-sha256;
	cv=none;
	b=XJ2sC4BKVPZ1QzbfAGcT7hIKqF+zpl6iqWXu2guFASmVCJdSV1slleWgeBPzUMIyeWcLpA
	fRabfHbFXj+ITXh7whGLtTR6vdsXJMjztu1Kr+gwdnOqeeal7ZyFHStEdaWk2w87dcZjym
	3+2zpntQFg/m6zWMyTuAuQkJDxUiwRI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 858664472A;
	Mon, 27 Apr 2026 18:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A35ECC2BCF4;
	Mon, 27 Apr 2026 18:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313219;
	bh=L926ZYKmv08z/xxUtsdt7bPrPbk3jRIyRF1yuMzjHzs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=uVUTfkgG55sUFJETSBEd7/pzr4vc1A/Juhfodsn86V+mohBD6YWVAAbc+nkR9/r72
	 RFxbjwjYcOIO4XzOQpenbMvPxbVm+MN/Ho2l4BMrQXuprCZuOO6LvZHfMxZ3eX4UrT
	 eHhreSpF5Svch5aQx/eeMqJlzCnezRu7MtYdABMae7IQYAt4Pgvra4/ciiH5wZFd5c
	 HK/ZtN22FdboVkpxGR6KF0ZgDWou1du2r+8ldogi9bY9236pK5NpWjipja4fGtjctR
	 a9VY3ixTY7VTpmuFQLf9tmowQ8tFNYmUQEIl6pcdy0puVauHsEwP2D9isK8v6y3IT2
	 5NENOHdYoMGZg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B037FF8860;
	Mon, 27 Apr 2026 18:06:59 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 28 Apr 2026 02:06:54 +0800
Subject: [PATCH v7 03/15] mm/mglru: relocate the LRU scan batch limit to
 callers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-mglru-reclaim-v7-3-02fabb92dc43@tencent.com>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
In-Reply-To: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777313217; l=3314;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=2ZDrAewbf1TxtvY6gQRB6CyLSpuIbi1jF9zQ5rQYaJQ=;
 b=qtDGt5Rx+hfSvSnpA4X68Gvowz5paVgNR8eqDxVAI+zX3U1b0iPwl9P+ZT3/x0wgPHCAJkalF
 6hntboypL6CCk1n4rvrr6bXC31pfeHNbW+SN/1wJmIY0sYYaZnDirX+
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: C8A1AA000A
X-Rspamd-Server: rspam06
X-Stat-Signature: nj33nnej4hta5r9dqqgqht8gb47nmop1
X-HE-Tag: 1777313234-796986
X-HE-Meta: U2FsdGVkX193fSSDiq/lF4Is2cViW0F4nLodADg+/ERKDV8RPf3o+kkMLXWgS9d9+qEHqF/PxQTpXwUXCYo/N7J8CyiAtBtYAseNOu9A2FBv2d9pHrSdNjLmwIrdLGI2DFcmiFe7gF42kT8erovK8nJqw6OsqB3IZBlidCmC0FKg+zYqx3T7RR6TOBOsGXVn77M0XO7PJ6tSd8njl+TLvluqcec1fJPheKtjjC940X2ZElG4rc8E5nV91Rgrnx9EuXB/kUB8LosuRkAtcNe2XpLXdGg0XMjRwwEWF22oXoFkEURp13YfdBggqk3ioJJsUTFLNffV4XchcPf7OSApr0hjWTvmqZEhr6P3dfPykYOptb0TZ6vzNJoRoBSoPdppP99rQASUg1dGesjD892AY89NYpnmGxuYyeGt8pu1WsKOsf9A6SZ7eldN84Zm3RUsYfBnTsAoAl0JwS+/6XiD0xmKPfksDnJbpDD3Uhx1PZoLSJa153RmEyssgQWYdAU/BI8y6Qhtkn/odvnBp8enyE1P5QdEU/z2WMFgQvDKlnMkJIL4OPjgieymIO11L/OJbYvcLSid16uzNE1TSRH5N7HpHxNNPw/IYzVWhy6aoYOU9yw+B6SzqKGsIhEp3IGJonKVBPMG6OkX/KNOn6Jp6qWfsc2HXog2I/bAuykw8nC+Ft38vR+ybVPcatmbKkhGaAkOS2ZDTzGAD2/AuWj3z9lHS70yzQdJj3phpwPY25Sz193Yws+9i5u6MZoKouINnKIidWMKk1TA7uSN/q9YTi0uiRG/IxClHSdloc4+qhAUp98CRoO4qa87RIw7HsLo6SUZ+EtApC6xJZymCeh7NnJ32zNB2PtA3U50KVJGWF/ox2SaW3+6k8S/rkdAh+nw2JrlDHd5qnt6Xs7nnCT+c3Bq5CWqyl0rFGG7OI2elX2WqswbzEKPK5Itwt24OxOLKsFruvFqsndS8PPxRW4
 rQp5DAFZ
 dVEV/+TaB9xgVO3i3sfzfuZOokoDUIE8t7xQXE8vKBTHi5BkV+FBhCwdSuhEkNKL5sa2OJbDE/e3u1a/8hZa/iyYQiE4O1USVWrxHTQkClMvPbVVq+BdDI9DSqM3r4zoLxXrSIHs2NdUpzcfFVLRCJQqysoRjQPRRhMBpqeHJfwruFnVM7ysW+hSS4iBCsmW1hVVL9yrdIlwJay940qMSPw/r2rLt0TZVoraNxEXayZN21C2s4aIIFvptPgKlFqRftIn3AJm8e/hd2apkX4kZQ18Y/RX06wZXudHQW4Hn64KjFIJMsBB5gxq41x9zKiuVExUHHZMSR1g/5jSFM6mqKAtx7/F2razNmlhFUoT4xKimXPWCITv8fWwZ6CyjuuTgWpHPLFPf5vgTwkwxIwsGB1oTMOzsf395XYtusSQEFMz9RoBiC0bGKr19F+7fpIT9MeLcxZUSRG0acx34ZYUMcM6Sa6b/EEP0K9C1ylsGAEufi8KDcCOYXZnDCsYY1eKpxev1qmgFP6YBwq/BD/Z8Btb3vhEdDqM1RwXv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Same as active / inactive LRU, MGLRU isolates and scans folios in batches.
The batch split is done hidden deep in the helper, which makes the code
harder to follow.  The helper's arguments are also confusing since callers
usually request more folios than the batch size, so the helper almost
never processes the full requested amount.

Move the batch splitting into the top loop to make it cleaner, there
should be no behavior change.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7f011ff4c478..a011733a6392 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4695,10 +4695,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int scanned = 0;
 	int isolated = 0;
 	int skipped = 0;
-	int scan_batch = min(nr_to_scan, MAX_LRU_BATCH);
-	int remaining = scan_batch;
+	unsigned long remaining = nr_to_scan;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
+	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
 	VM_WARN_ON_ONCE(!list_empty(list));
 
 	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
@@ -4751,7 +4751,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	mod_lruvec_state(lruvec, item, isolated);
 	mod_lruvec_state(lruvec, PGREFILL, sorted);
 	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
+	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 	if (type == LRU_GEN_FILE)
@@ -4987,7 +4987,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
-	long nr_to_scan;
+	long nr_batch, nr_to_scan;
 	unsigned long scanned = 0;
 	int swappiness = get_swappiness(lruvec, sc);
 
@@ -4998,7 +4998,8 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (nr_to_scan <= 0)
 			break;
 
-		delta = evict_folios(nr_to_scan, lruvec, sc, swappiness);
+		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
+		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;
 
@@ -5623,6 +5624,7 @@ static int run_aging(struct lruvec *lruvec, unsigned long seq,
 static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_control *sc,
 			int swappiness, unsigned long nr_to_reclaim)
 {
+	int nr_batch;
 	DEFINE_MAX_SEQ(lruvec);
 
 	if (seq + MIN_NR_GENS > max_seq)
@@ -5639,8 +5641,8 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;
 
-		if (!evict_folios(nr_to_reclaim - sc->nr_reclaimed, lruvec, sc,
-				  swappiness))
+		nr_batch = min(nr_to_reclaim - sc->nr_reclaimed, MAX_LRU_BATCH);
+		if (!evict_folios(nr_batch, lruvec, sc, swappiness))
 			return 0;
 
 		cond_resched();

-- 
2.54.0



