Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7063C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 07:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B45956B0095; Thu, 30 Jul 2026 03:25:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D1B6B0096; Thu, 30 Jul 2026 03:25:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A33C16B0098; Thu, 30 Jul 2026 03:25:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8044C6B0095
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:25:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19BA34092E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:25:06 +0000 (UTC)
X-FDA: 85044606612.05.D2C64BC
Received: from SHSQR01.spreadtrum.com (unknown [222.66.158.135])
	by imf30.hostedemail.com (Postfix) with ESMTP id 13FAA80008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:25:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=RyBRZz6c;
	spf=pass (imf30.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785396303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QazV6RBRIReqOJNyY2v0taCUJw0vnT+qdOJHh51n7zw=;
	b=1o5oQQgcCeo+P4dMYVXpbbeCPUtQMBeBigGApRMz28SIDebFcfu2cyCCGzdxBpWUfrBln1
	YZV3m2BViMgFPTqCv7CbFwKtbuM6aZm1S/TRADTrAZumbT8x64xh18SlFPdMmGjR/MEuPQ
	+6bjn9XU82nX0yPWiQ2uw4NLLFau+JM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=RyBRZz6c;
	spf=pass (imf30.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785396303;
	b=lXo/USL6dKDpBH1K/J9ER8/t4HSfuCKIX2jaGFjGXj8YxeCZh974ihZgpbfQfQZQ3jSSnz
	NKjzvjX73BoidjoC4dE0a1AhgWZwWqJ6WwTaQ1mxi2DcXC7LMxh5LQtGKmpSZCyINFlmNK
	rqIZAhLVnmzYpDMENnK69s1qg1TrNHc=
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTPS id 66U7NxII034360
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 30 Jul 2026 15:23:59 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4h9gfx0TkGz2KKx2G;
	Thu, 30 Jul 2026 15:23:53 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Thu, 30 Jul 2026 15:23:56 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand
	<david@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Johannes Weiner
	<hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Qi Zheng
	<zhengqi.arch@bytedance.com>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Lorenzo
 Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang
	<huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [PATCH] mm/mglru: force aging the lruvec when min_seq pinned
Date: Thu, 30 Jul 2026 15:23:49 +0800
Message-ID: <20260730072349.1360449-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 66U7NxII034360
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1785396250;
	bh=QazV6RBRIReqOJNyY2v0taCUJw0vnT+qdOJHh51n7zw=;
	h=From:To:Subject:Date;
	b=RyBRZz6clo7izJg1kGxUbr92OZslOK7QhGZWyZ2xPx6rHKi7J9yy7/woeU7NfTrtJ
	 OE7oWcYRF0SxLgNiLlRAvFKRAo5zS2WsaHjTh+oE1/MtuABsPA7FWkxcr0IOkaWSdg
	 QXY1KlmqO/+ZsuY3KswPOJZi261x1TpFoJe3hryZKAAoX2Cum0VWJIUxh43w+JSrKV
	 uy/XWznAv7u+rxa9eFJAaxfqklXLZclLKaVTgKrgBhG5rjbo7W+prolnr3uItzPmf+
	 MczObJ8DgYDMWKD+hJiiX5SSKzRAgP3cnjDVCi3Yq8RF0M8jtR4dQ8EBw0YHazvtty
	 A4/j4yStGUW/A==
X-Rspamd-Queue-Id: 13FAA80008
X-Rspam-User: 
X-Stat-Signature: 7pxn3d876y819gapzuf38aqgsff1jbxb
X-Rspamd-Server: rspam04
X-HE-Tag: 1785396301-963010
X-HE-Meta: U2FsdGVkX1+J+6aLXEvtlhdbHZ9yX49RHws6T0ykv67DtTW/+JH2ElZdIRDOWFNXrtmhSeASAPQUArnvEXYRTFS2ssjWg9b41E+7dtZPnzlq+0GQYUvbZhxnlVD3fpvTbCvIgPXcm0KTa2T5EjKsu65Ddk8Ri/ujfqOjoB0zdTbEYpqxV8X7NvAATm9lcZajWeJrTlKqCuTaWWI4aSfjFD4oumpfELwzgct6dp0Li/GJUJvX8o7Abmiwj56YdlpoMlHZ/Xzh5Z1rIikLeqL6FLu961HxBCgtFC1laEn/yAjKZUAqRdn9mZRPjQWN9IjNRa02lPSgsnsfk9eDCFBX3cq58xNyPv7tBXrpVWEqfPhJPbZ2vtrU9oCwz5xsCUdHOewvwhCbtxwRmAlUtSgazJavQOyIqj7oWzxMtG/vd83S796rOvd6BA1tQcukdfaVFjBdyPl6K2RtcTO8oUGy9d3UGs/9yJ6Qy08SoH5CVsmHm8liDikkPxLwOcqODcd9eSk2Ma+2fq3WT/1Fl7kQUj2Affl5grOMXwZQQa9bfUPkYkt++l5kDUVsh6+rjHb6iovIslDe097LMIBhn7YViWyGfd7c7ZmwPH1pTGIPj9ZQZ1KBLN9749U6t8h2FxQcDdeLvelsJTF4v1ieFhZ6eXyO2mHpGFQ5kaq9JTcKoRcTB1c8DSJ1EdZZMt0okgiHfg5uow+q0u3CrbzY3H/GzPQjB9eDO2KrVglz1q8PIuvLTuldR1Pm6RGNa4gFaQv4/htHPRbIgeA3ooLPk4TcmUhLlynNkHmnRstIk4PZe6vDL6ZxpwzujFNpSB82e+MW/hndvb08767GpCer5zKfglOp4BTMxwGtiW7BOB2D9+Zl7Z6VuEq8Gz5jeHhCHo3yuOESMcjZ822MFXRbbhoEbCSPfwzbPkoovoTVNUt6zp+iOffZTrTtJP6pBILL/DV17UkibtPXlhf7hdbaJGB
 DwCSGRxE
 zsX3bKXV7CkDJwHMaQldHzh3Y9jKGxxCdKrhqlPYcn+BJ8w5F2G9ghKo/DrlEvAFQTwju6y/S62JbNLkHLnhnKNe9ystiuH0kEg5b0Y0iN185IuzG1XzAs7DYTwxMV5SnOBkFlEOFGm+Fg2poyOmO10xMNdVOska+L3HGjQSLJAHEeDmOkh3SCT0tu/Kh4z+l/gsITzJ9WttWskJdX5i6/VjchLqORzXGTzyS3Vt1M48cSzapinTo8FOL+yWLyi/vHF++otz/fWatJV/hboZc5cl9zYDpRikDkHfLDQUA8BFPH/TYeYK0yjAy1DkvrHTPjBmAfAgYJW0I1Y8E9ChfbS0ouPXnwrXmCXILIRmoT4FeREmQAvG4ofhTMNdvW8xSq/flCcGVr9NKWUfpSg+eULAWe41wwQ6PjbEj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

This submission addresses an issue where the memcg MGLRU's min_seq is
pinned by an orphan page—a page that resides in the page cache but
lacks a corresponding reference count, while the number of GENs has not
yet met the criteria of aging. I believe such pages should be detected
and handled elsewhere rather than affecting the LRU in this way(legacy
LRU could move forward by bringing this kind of folio along with).
Therefore, I propose moving these folios to the next generation when
isolation makes no progress at all.

Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
 include/linux/mmzone.h |  6 ++++++
 mm/vmscan.c            | 45 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9adb2ad21da5..b063c56ea30c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -434,6 +434,12 @@ enum lruvec_flags {
 	 */
 	LRUVEC_CGROUP_CONGESTED,
 	LRUVEC_NODE_CONGESTED,
+	/*
+	 * MGLRU: eviction failed to isolate from the oldest generation once
+	 * while the window was at MAX_NR_GENS. A second consecutive failure
+	 * forces aging so residual folios cannot pin min_seq indefinitely.
+	 */
+	LRUVEC_MGLRU_ISOLATE_FAILED,
 };
 
 #endif /* !__GENERATING_BOUNDS_H */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bd1b1aa12581..c18db08c5e10 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -175,6 +175,8 @@ struct scan_control {
 		unsigned int immediate;
 		unsigned int file_taken;
 		unsigned int taken;
+		/* folios isolated by MGLRU eviction in the current lruvec pass */
+		unsigned int isolated;
 	} nr;
 
 	/* for recording the reclaimed slab by now */
@@ -4748,6 +4750,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
+	sc->nr.isolated += isolated;
 	if (type == LRU_GEN_FILE)
 		sc->nr.file_taken += isolated;
 	/*
@@ -4998,6 +5001,11 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	long nr_to_scan;
 	unsigned long scanned = 0;
 	int swappiness = get_swappiness(lruvec, sc);
+	bool attempted = false;
+	bool rotated = false;
+
+	/* per-lruvec pass; sc is shared across lruvecs during reclaim */
+	sc->nr.isolated = 0;
 
 	while (true) {
 		int delta;
@@ -5006,6 +5014,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		if (nr_to_scan <= 0)
 			break;
 
+		attempted = true;
 		delta = evict_folios(nr_to_scan, lruvec, sc, swappiness);
 		if (!delta)
 			break;
@@ -5020,6 +5029,40 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		cond_resched();
 	}
 
+	/*
+	 * Eviction isolated nothing while the sliding window is already at
+	 * MAX_NR_GENS. In that state should_run_aging() is false, so
+	 * get_nr_to_scan() never calls try_to_inc_max_seq(). Residual folios
+	 * that fail isolate_folio() can pin min_seq and hide reclaimable
+	 * folios in younger generations.
+	 *
+	 * Require two consecutive isolate failures on this lruvec before
+	 * forcing aging, so a single no-progress batch does not rotate the
+	 * window. Successful isolation clears the sticky bit.
+	 *
+	 * Key off sc->nr.isolated, not nr_reclaimed: folios isolated but
+	 * rejected by shrink_folio_list() are put back with PG_active and do
+	 * not pin the oldest generation.
+	 */
+	if (attempted && !sc->nr.isolated) {
+		DEFINE_MAX_SEQ(lruvec);
+		DEFINE_MIN_SEQ(lruvec);
+
+		if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS < max_seq) {
+			if (test_and_set_bit(LRUVEC_MGLRU_ISOLATE_FAILED,
+					     &lruvec->flags)) {
+				rotated = try_to_inc_max_seq(lruvec, max_seq,
+							     swappiness, false);
+				clear_bit(LRUVEC_MGLRU_ISOLATE_FAILED,
+					  &lruvec->flags);
+			}
+		} else {
+			clear_bit(LRUVEC_MGLRU_ISOLATE_FAILED, &lruvec->flags);
+		}
+	} else if (sc->nr.isolated) {
+		clear_bit(LRUVEC_MGLRU_ISOLATE_FAILED, &lruvec->flags);
+	}
+
 	/*
 	 * If too many file cache in the coldest generation can't be evicted
 	 * due to being dirty, wake up the flusher.
@@ -5043,7 +5086,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	}
 
 	/* whether this lruvec should be rotated */
-	return nr_to_scan < 0;
+	return nr_to_scan < 0 || rotated;
 }
 
 static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
-- 
2.25.1


