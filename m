Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F659C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 657976B00AC; Tue,  1 Sep 2026 04:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6086B6B00AE; Tue,  1 Sep 2026 04:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FB6D6B00B0; Tue,  1 Sep 2026 04:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BA5D6B00AC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:48:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D10DA039A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:48:13 +0000 (UTC)
X-FDA: 85164566466.13.EF6CFB9
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id BA5A5140004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:48:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ftsIrc8H;
	spf=pass (imf09.hostedemail.com: domain of love_goo@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=love_goo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788252491;
	b=CLN1wDQcl7kFwFY0EjieXbeK6m8t1HVNvMlbK1vpInQdYHC8x0FpnYRgOGMt19qxiDCuqF
	DzPhEp+LGeMERSFKIM3g4J/F12P5gcTwmbE1JNr+JpGCeAZTYwe3YJ1dD3vrkj3XlH/RNm
	owusk9rRlrJvosC59hFXHkBJd4hy0T8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788252491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g1fgC7TS23+f8CRqs1a7s25sfFirY0QStyUqTz1H+C0=;
	b=cQ1U/P+Xl3am+ulqwVonQfI5Fq6M8+yL1xzzeWYZG4unfCgCiLaGVY9d4Nv+6P0/HmfuxR
	aK8YEp5mV60SnU4XWGQHI70Vbje1jqE7mTLXpAMKq/nixd7g5BHMh9OkUOV4iTAERp8X4U
	qqU6SMGofLffXDwXBK3l88oydDRqPTA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ftsIrc8H;
	spf=pass (imf09.hostedemail.com: domain of love_goo@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=love_goo@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=g1
	fgC7TS23+f8CRqs1a7s25sfFirY0QStyUqTz1H+C0=; b=ftsIrc8HTu58+vVJLu
	GrYYpgFjFmIUioXWc+BiBtFrOfSCZEVQP41v2zkDjYSxk5f3XGDNpc0/aqvENfZf
	A2Go9LeKDDFhSGx0yTa3k94I12lHeC8xrS5unKE8YRUEyB9GpCN6CN6xwBeCDM53
	9m6wce2j7vp3nibw3vMW16QP4=
Received: from hpc (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgC3qo4OkZZqHFWTNA--.28200S3;
	Tue, 01 Sep 2026 16:47:12 +0800 (CST)
From: john <love_goo@163.com>
To: akpm@linux-foundation.org,
	liuye@kylinos.cn,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	mgorman@techsingularity.net,
	yang@os.amperecomputing.com
Cc: zhangqiuhao@huawei.com,
	wangkefeng.wang@huawei.com,
	mawupeng1@huwei.com,
	love_goo@163.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wupeng Ma <mawupeng1@huawei.com>
Subject: [PATCH resend 1/2] mm: vmscan: charge isolate overshoot against scan quota
Date: Tue,  1 Sep 2026 16:47:05 +0800
Message-ID: <20260901084706.3784449-2-love_goo@163.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260901084706.3784449-1-love_goo@163.com>
References: <20260901084706.3784449-1-love_goo@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgC3qo4OkZZqHFWTNA--.28200S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxCr15urW8AF1fJw1rZr1kZrb_yoW7Jw47pa
	9rG3y2vrWrJ390gryUZF4kCr4akFW3AFWUtFZFvF17ZF1fWFyfG347G39FgFWUu348ZFWS
	v39rKF97Wa1jq37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pihFx8UUUUU=
X-Originating-IP: [36.24.89.45]
X-CM-SenderInfo: 5oryvsxjrrqiywtou0bp/xtbC6xCo4GqWkRA0gQAA37
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BA5A5140004
X-Stat-Signature: 78k1ogeyjozoj8wg37dfsh3oefu188ds
X-HE-Tag: 1788252490-943846
X-HE-Meta: U2FsdGVkX1/LrXk29sDqq/Sb2f0H1X94jhHTfoxbdB1ywLVW5YfddO7zNCEXvVXTPfIJkP30q2UDvVp9ewmYeavL+4M1NIv6kg+Jy8ERws9tVyxgMqLhZFEWRRIna7AbsiiPTke1Y3niciBEL+VwRfjtnFJUCzk3oePl+FedaBqBTpySmWYhk+4Nlcy5wLOD9w64XXpLxphaBJCgQz9Bd2jNF8kMiWOMwjaPPbRzsKKtEwa7U/xmmk3ipHFEm8HjK74rfqVls2NOvr0DJqa4qBehOgkhm9EBra0IBXIuv16oIA2vMscGG9Nu+W/GNDs+P9tAaXvw51cT/UQkxQoJKmpmctfZG+pybost3Tb4LuCpupyo4T3yHSnJkyjPXZSDovo3HS9YW/TxZhqWignlkiWfg02CRlvB0ZgwB/uq+6750qfblFjfE9/t/G6sHeYjt0Q2EgiLErsA4sWYJX4W7IFfbsXAmkSkJhPaV9vwNMRBXBZRP2t5jzaupwv9lxLbLWZd2BY8OF0Me41XQcOTyzxokEeSFkgkLhCipH0qDFso0eWUSCwEQn0+/4RAkfcHqFAH5SszkW4t9KRocSywemjKwjwgnkcMRH/6XjXQQCn/p6RlY5jkCg0LMUDvSgo6zPBCHQlGJM3AdfVFKePOs9t4GOc4zYnvrFJuK6lTO865oZ4duGKRUatzEz14MYZiOVKhzgL/1abCQo5Kvd+e4Z/tfcctzpifxP2L7YpM0VzJI5eHjpIZxt2HWfyYwmEBq7FSodThrB0u/388LlNLN/NlJCgjXjl/3ksPKl1An8UP8RL/NWGA7Z9Cf5UMsC7A2wBPrVJwQQrF66gVogIzECIRQZDNK6iA4XlvfemabGjg+GsHKzum/bvRwqdMkZYJcmg4J83TVdBhr7FAC0SQJ4jLzrGxJLJ5i5VNQttlujGYaNMqO00F+ElG2sbjQqYCK+Mdn3+hzNPc4+Z6604
 JuS+DXce
 2HDKimv3MEnQYNhlGKvfDMqwpMqalY/n6kt6rgFvoeoxqBUdKYg91XSKwt/9g5dJm6f/T2USwHAT8l22QPpbjeyBwNEOWI5VPTkj8aLNSyZltKFGeRcRO+7rSCT2rRD/9cRTcAUvvZ6XTsz338B6Z689yFLOGxUu5b3yOCiWy2LeM7x6gjK+Ay9Qnu9dsCdDlSSSShgRcefk9yVkspryQXxVz3y0jkS1NSIy8XU9L+osFf1BgFTK7v/OSHkXhP/jzhqRkAtdgp7nup7UIrU9yVOk0OF8nPNBjQoOtxDtLm5f3HsyiWPV0f6VLHKiHd4871x2SwofhUQyC8CLv38hRpoC4JE3ZAFfev2VKPC0tDxXHkp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wupeng Ma <mawupeng1@huawei.com>

shrink_lruvec() charges the per-LRU budget nr[lru] in SWAP_CLUSTER_MAX
(32) chunks, but isolate_lru_folios() may scan far more per call: a
large folio can jump scan by many pages at once (a PMD-sized folio
counts 512), and a zone-ineligible LRU walks the whole list without
feeding scan back.  The overshoot is never refunded, so shrink_lruvec()
keeps charging only 32 per round and rescans the same folios.

Have isolate_lru_folios() record its scanned count in sc->nr_isolate_scanned
and let shrink_lruvec() subtract the overshoot from the remaining quota so
the next round skips already-scanned folios.  The field is reset to 0
before each shrink_list() call, as shrink_list() only reaches
isolate_lru_folios() on some paths (active + skipped_deactivate,
too_many_isolated stall bail out early); a stale value would otherwise
be charged.  The budget floor stays nr_to_scan via max() so an empty
LRU (sc->nr_isolate_scanned = 0) still advances and cannot deadlock.

Co-developed-by: Qiuhao Zhang <zhangqiuhao@huawei.com>
Signed-off-by: Qiuhao Zhang <zhangqiuhao@huawei.com>
Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
---
 mm/vmscan.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5c..823af9e86efd3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -166,6 +166,9 @@ struct scan_control {
 	/* Incremented by the number of inactive pages that were scanned */
 	unsigned long nr_scanned;
 
+	/* Number of pages that were scanned from isolate_lru_folios() */
+	unsigned long nr_isolate_scanned;
+
 	/* Number of pages freed so far during a call to shrink_zones() */
 	unsigned long nr_reclaimed;
 
@@ -1670,7 +1673,6 @@ static __always_inline void update_lru_sizes(struct lruvec *lruvec,
  * @nr_to_scan:	The number of eligible pages to look through on the list.
  * @lruvec:	The LRU vector to pull pages from.
  * @dst:	The temp list to put pages on to.
- * @nr_scanned:	The number of pages that were scanned.
  * @sc:		The scan_control struct for this reclaim session
  * @lru:	LRU list id for isolating
  *
@@ -1678,8 +1680,7 @@ static __always_inline void update_lru_sizes(struct lruvec *lruvec,
  */
 static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
 		struct lruvec *lruvec, struct list_head *dst,
-		unsigned long *nr_scanned, struct scan_control *sc,
-		enum lru_list lru)
+		struct scan_control *sc, enum lru_list lru)
 {
 	struct list_head *src = &lruvec->lists[lru];
 	unsigned long nr_taken = 0;
@@ -1763,7 +1764,7 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
 			skipped += nr_skipped[zid];
 		}
 	}
-	*nr_scanned = total_scan;
+	sc->nr_isolate_scanned = total_scan;
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				    total_scan, skipped, nr_taken, lru);
 	update_lru_sizes(lruvec, lru, nr_zone_taken);
@@ -2011,8 +2012,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	lruvec_lock_irq(lruvec);
 
-	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &folio_list,
-				     &nr_scanned, sc, lru);
+	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &folio_list, sc, lru);
+	nr_scanned = sc->nr_isolate_scanned;
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
 	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
@@ -2068,7 +2069,6 @@ static void shrink_active_list(unsigned long nr_to_scan,
 			       enum lru_list lru)
 {
 	unsigned long nr_taken;
-	unsigned long nr_scanned;
 	vma_flags_t vma_flags;
 	LIST_HEAD(l_hold);	/* The folios which were snipped off */
 	LIST_HEAD(l_active);
@@ -2082,12 +2082,11 @@ static void shrink_active_list(unsigned long nr_to_scan,
 
 	lruvec_lock_irq(lruvec);
 
-	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &l_hold,
-				     &nr_scanned, sc, lru);
+	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &l_hold, sc, lru);
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
 
-	mod_lruvec_state(lruvec, PGREFILL, nr_scanned);
+	mod_lruvec_state(lruvec, PGREFILL, sc->nr_isolate_scanned);
 
 	lruvec_unlock_irq(lruvec);
 
@@ -6013,10 +6012,21 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 		for_each_evictable_lru(lru) {
 			if (nr[lru]) {
 				nr_to_scan = min(nr[lru], SWAP_CLUSTER_MAX);
-				nr[lru] -= nr_to_scan;
 
+				sc->nr_isolate_scanned = 0;
 				nr_reclaimed += shrink_list(lru, nr_to_scan,
 							    lruvec, sc);
+				/*
+				 * isolate_lru_folios() may scan far more
+				 * than nr_to_scan when the LRU holds
+				 * ineligible folios (zone-skip) or large
+				 * folios. Charge that overshoot against the
+				 * remaining quota (clamped by min() so it
+				 * cannot go negative) so the next iteration
+				 * does not rescan the same skipped folios.
+				 */
+				nr[lru] -= min(nr[lru],
+					       max(nr_to_scan, sc->nr_isolate_scanned));
 			}
 		}
 
-- 
2.53.0


