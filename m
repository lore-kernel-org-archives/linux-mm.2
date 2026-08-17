Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57567C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 07:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0F06B0096; Mon, 17 Aug 2026 03:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7CF6B0098; Mon, 17 Aug 2026 03:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7216B009D; Mon, 17 Aug 2026 03:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD98E6B0096
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:11:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 53EB31206EE
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:11:49 +0000 (UTC)
X-FDA: 85109891538.02.77FEE88
Received: from mta1.migadu.com (out-206.mta1.migadu.com [95.215.58.206])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5229420006
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:11:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q201gnM7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.206 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786950707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AnCS0gdxgxnp8MTq60B9x0bG+05+xrCbkKHMRTw3CKA=;
	b=4es2HE3kDmZMFveb6VYTj0CoCJ03F17QBvMtAjgQDbLv6Yifhk2wYLqRlv/iz8t8tmMjXW
	tNlqI4TtA6rnqK1nB9b+mOJ959ocRJf17HbwolfJ8mGJlfJeenB+LB08s3TUjsx0O8kPti
	+Z0OO7VOutn9OxEh3PE4kdUJ+Wx1Zew=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q201gnM7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.206 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786950707;
	b=wVQ25gLL2xD9YUaIPiGbXQu78knlCCh3swpBI822GIbi4MXeKRskdqjaqFB+oiV1tfz+6g
	Xx1cibupu7SkrklZvSaxIwhvc8m1S1/be+cJTw4yluMstueMrTVKhv2zeM+88gtGfmKtte
	/ezn4yMrPReMBpCQ/WEcDWHbpB2tqSA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3OLU2rvZSB2pUOMJNXwVJjEcb+QRFbOjrMpr5xGgUiI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786950704; v=1; x=1787555504;
 b=q201gnM7ivwXTzucqw+KPo2+XS9CmJOPZn4ASokoJKWNUj2tdsNP8PoO8v5EVDmGIkY93uA1
 S7R21KYyqTEH8ht1H/Ou8RFFt91pwzwc5zFi2mMk2E5kgQJfBgnal/3BMgRL2kKwwKrO7o0e9fU
 8Z4wx7Jp5lJESoa6E0a2Jq7M=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id e3652a2a4d77b910;
	Mon, 17 Aug 2026 07:11:44 +0000
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH mm-unstable v2 2/2] mm/vmscan: apply too_many_isolated() throttling to MGLRU eviction
Date: Mon, 17 Aug 2026 15:11:19 +0800
Message-ID: <858e2e0ae536bbe185267472d3c84a5684937131.1786950138.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1786950138.git.zhuhui@kylinos.cn>
References: <cover.1786950138.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5229420006
X-Stat-Signature: cajrfkee144op4x8h31cbz33btsurfps
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786950707-369287
X-HE-Meta: U2FsdGVkX1/mFUK9WBBZJOOgfzXniOUNmrV/fVKI0OFgSKlFU0AmODBgHATqJrIVsvZHK56fCeyvkl1BNJj2CiCCVHyTsk0gtZAd/nsdWx/1DwBAaF6BmT2VSq4FFnRkSJfvAMwDaYHr42OqWr1OyZtU0oCo6fQ8edzmfrL2YsrP/z4ykp4+2ZYYvMaFtl0STZCLvLxgygSztehvDB2VT8v7+Ps3dAtvcvFcCBaGR1jw8sfwoSIMSnFfAm5+A+A3w+3l9bT3DnlKcwSZWzFPycLt6aVb4f6Eyp1IhSVelLtW1Suo/ESRsJPojy57XI+vVi/Xy1ou8mgK8N0O0T9Fb4A0kLIyh8H+WBs58G1yEkBcSJl43K7Xii6bVTVgolJJ1vcschuSG88P65pxHJSjBcDJ/sJmse8oumLemKhEJsSVc/KIyiUfUKa/Q0AtX3oqpRsZvGyfm8l84/1VMIsyQ5IJc4Y+sDbhy6NwpKUp0zsGOZUV5KO2zWtbHDHZvTe+Z5R3AvdWz0dz/z6o10j+VzkRngJ4350Yd2g1tpaSmkqvYlzMOAEcFRkHnjpMkCZR9X0uO9LjxliYAnxQvHlGWaG5fGGpRK7coTIEmIHCyYkIqMaewWLTAzr2bTe8Zfezp+z4Xzy/nfEhx50cgzWP8RnrZ8oiJqElWHtwPua9fcOrbYdIcsI+55FbqHIofS4XosCye2WWJepA+MN3Yavl4w7nSWuiFhOK5LFnlrmYs/AATdy03lQ80KHXo5KZDOOJ7KoPWDlAjCOx6prBzkQ/+pfYQsg6vqdnErvZbGxwOUmoLPZsSlXEsox7z8F0TSljdUCSrCxpCNpgyxVbs6emIUAdhve1IgHkG+DUmfEGlZJcN96f06Qbk3vvLND5+TYZZp//h2M/ghobMzLVtDrLXrgmPu7E40vHHYln8JagzZg76gITqlcUL50AgUVkHb/2sNKThGwBhOZapeBOGeo
 upw1UGQJ
 3Qrp5nZckK2b5ZLBiKDECyka6mhHQhiQgGUj5f7nTHGa77C/BDTGcxKeORzlmQjbmx/At6ESoJg/+SNTt11te+yJBD+Ygo8aihbMDS/0KQQgQBNR2JE99EVsviNID0LKjmBC83ohqgKJF8IMMrMzQeleZbBv1+n/JMm5QChujAz6Mx5Ov4eV+URcy2Cr7LR8ro/pRv8ReFvMD0CZ/kJ6heJlcQ/jizLlRgO5onYuewQRueXM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

The legacy path throttles direct reclaim in shrink_inactive_list()
when too many isolated folios pile up, but MGLRU's evict_folios()
isolates folios without this check, which can lead to unnecessary
swapping, thrashing and OOM.

With the NR_ISOLATED counters now updated in evict_folios(), extract
the throttling loop from shrink_inactive_list() into
throttle_isolated() and reuse it in evict_folios(). The type to
isolate is predicted with get_type_to_scan() since it is unknown
until isolation.

If a fatal signal is pending, fake reclaim progress the same way the
legacy path does, so the dying task exits reclaim quickly instead of
being held in the throttle.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/vmscan.c | 67 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 56 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index fdc45d7d8fba..886a53f563ab 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1819,7 +1819,7 @@ bool folio_isolate_lru(struct folio *folio)
  * the LRU list will go small and be scanned faster than necessary, leading to
  * unnecessary swapping, thrashing and OOM.
  */
-static bool too_many_isolated(struct pglist_data *pgdat, int file,
+static bool too_many_isolated(struct pglist_data *pgdat, bool file,
 		struct scan_control *sc)
 {
 	unsigned long inactive, isolated;
@@ -1856,6 +1856,37 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
 	return too_many;
 }
 
+/*
+ * Throttle reclaim if too many isolated folios are piling up. If this makes
+ * no progress, the caller is probably looping on unevictable folios, so give
+ * up. Returns false to tell the caller to stop reclaiming, and sets @fatal
+ * if the task received a fatal signal while waiting, so that the caller can
+ * bail out faster.
+ */
+static bool throttle_isolated(struct pglist_data *pgdat, bool file,
+			      struct scan_control *sc, bool *fatal)
+{
+	bool stalled = false;
+
+	*fatal = false;
+	while (unlikely(too_many_isolated(pgdat, file, sc))) {
+		if (stalled)
+			return false;
+
+		/* wait a bit for the reclaimer. */
+		stalled = true;
+		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);
+
+		/* We are about to die and free our memory. Return now. */
+		if (fatal_signal_pending(current)) {
+			*fatal = true;
+			return false;
+		}
+	}
+
+	return true;
+}
+
 /*
  * move_folios_to_lru() moves folios from private @list to appropriate LRU list.
  *
@@ -1992,19 +2023,14 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	bool file = is_file_lru(lru);
 	enum node_stat_item item;
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-	bool stalled = false;
-
-	while (unlikely(too_many_isolated(pgdat, file, sc))) {
-		if (stalled)
-			return 0;
-
-		/* wait a bit for the reclaimer. */
-		stalled = true;
-		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);
+	bool fatal;
 
+	if (!throttle_isolated(pgdat, file, sc, &fatal)) {
 		/* We are about to die and free our memory. Return now. */
-		if (fatal_signal_pending(current))
+		if (fatal)
 			return SWAP_CLUSTER_MAX;
+
+		return 0;
 	}
 
 	lru_add_drain();
@@ -4883,6 +4909,25 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	bool fatal;
+
+	/*
+	 * The type to isolate is unknown until isolation, so predict it for
+	 * the throttling check. isolate_folios() may still fall back to the
+	 * other type, which is fine for this heuristic.
+	 */
+	type = get_type_to_scan(lruvec, swappiness);
+	if (!throttle_isolated(pgdat, type, sc, &fatal)) {
+		/*
+		 * We are about to die and free our memory. Like the legacy
+		 * path, pretend some pages were reclaimed so reclaim unwinds
+		 * quickly instead of looping back into the throttle.
+		 */
+		if (fatal)
+			sc->nr_reclaimed += SWAP_CLUSTER_MAX;
+
+		return 0;
+	}
 
 	lruvec_lock_irq(lruvec);
 
-- 
2.53.0


