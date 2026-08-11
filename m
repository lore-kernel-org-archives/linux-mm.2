Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB5C4C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 07:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A53E6B0099; Tue, 11 Aug 2026 03:35:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 256216B009B; Tue, 11 Aug 2026 03:35:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 193176B009D; Tue, 11 Aug 2026 03:35:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBDEB6B0099
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:35:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7855B40379
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:35:23 +0000 (UTC)
X-FDA: 85088178126.01.8038B54
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf25.hostedemail.com (Postfix) with ESMTP id ECBCFA0008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:35:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=nHFcgoM8;
	spf=pass (imf25.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786433721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uACuRpgQeAR3tJObhea0/lBl/BNLK4v2q1i2hPsZ9IU=;
	b=UX+vGcOa249o+8lQHJXZTnKjm5GuH+DFiTqtpEu4B+tOQgCS8KjDYynNbOnjYRIqN5Vg3q
	//R2Ip5+yF67IlyW+eBdLIRllk2sJ6W+ryYo3npwKNl6kV0i5fP3AW5O8nsWcVfnWFnLyy
	brkXbyEj5V4PU9oNPIBVu2ih9kkLarw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786433721;
	b=1WSjzxUTjBxkjO7+cD8GFnKJX3Kb2jejWoXkUL88/EI/lbn4MGhz0eVxum58sj1jQT9Gl0
	xvemRNTnfq80C3FawO8Rg7CiJZdcfW42Efs0PSg0sQFubgUx7JBmx4EoGnqPPGGGQszJBj
	eFInLogD6NoiPXt64GG/EZkDKJtt9Cs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=nHFcgoM8;
	spf=pass (imf25.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uACuRpgQeAR3tJObhea0/lBl/BNLK4v2q1i2hPsZ9IU=;
	b=nHFcgoM8ACKqoIDyCz+qZzyccHxFtFz3X12kbeAOpeNpmCQxZLS8QJjEuhs7XQ2aHqAUinN3y
	4+XXXNaz12QuodHN3RiDfe4+Ugvb+OFbFLBtIfPLMbuWBZn0q7+pfIXAHBfNrYbuGtW49fEQt/4
	AaCX3cHk+aBY9eKFGaVJIs8=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hK36D5vhCzRhVQ;
	Tue, 11 Aug 2026 15:24:36 +0800 (CST)
Received: from kwepemj100016.china.huawei.com (unknown [7.202.194.10])
	by mail.maildlp.com (Postfix) with ESMTPS id 6CB4340561;
	Tue, 11 Aug 2026 15:35:11 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemj100016.china.huawei.com
 (7.202.194.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 11 Aug
 2026 15:35:10 +0800
From: Wupeng Ma <mawupeng1@huawei.com>
To: <akpm@linux-foundation.org>, <liuye@kylinos.cn>, <hannes@cmpxchg.org>,
	<mhocko@kernel.org>, <david@kernel.org>, <ljs@kernel.org>,
	<hughd@google.com>, <mgorman@techsingularity.net>,
	<yang@os.amperecomputing.com>
CC: <zhangqiuhao@huawei.com>, <wangkefeng.wang@huawei.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Wupeng Ma
	<mawupeng1@huawei.com>
Subject: [PATCH 1/2] mm: vmscan: charge isolate overshoot against scan quota
Date: Tue, 11 Aug 2026 15:08:48 +0800
Message-ID: <20260811070849.1332165-2-mawupeng1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811070849.1332165-1-mawupeng1@huawei.com>
References: <20260811070849.1332165-1-mawupeng1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100016.china.huawei.com (7.202.194.10)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ECBCFA0008
X-Stat-Signature: 9jjqkt6wn3q4j5873zpqgpnz1dz51sdz
X-Rspam-User: 
X-HE-Tag: 1786433720-895472
X-HE-Meta: U2FsdGVkX1/sGLhOyeStut44Fjh6cbbbhKL8UrCvm0NbnQWX/MBcNNmAmEjQWW3LpT7O9UVIvj4E7ga3bAxRbOQjJUAopFGHCQZ0gT/59sxeY7oQVM0bdD6WRlDAyMwtnQzihWBjtw/vQSbFnYDb7ix4sX/Re3ZiozHingiv2f0mhdjlIfK6yitfLtK82VK5acifNYssZE4gDWMD4mcFhg1DfZPItGbwW+YhYHpR8oSrFPc7SYOQMJMdcaGuGcVHwkpR70Roc4dxVVd1ld+ToWCOIO2gxrOwt5tSDViZtOvo7l3/KG6j61IJTlMElZziX3sXN/ZyrDd3ctXMRonQvyPRxTYWGn2NfGvjxlF6nUaXzBf70YnNjWuwWqpETtqVf0kD557L21i5H/cB4RrE/DlBWvb7afrx+kC0Qvi6XiKk1h4v7Q7jVaCCiTf78P+vdvvF2nyBffDXSoylGi6nuvIU6x6I7JSN/qto8+eAcID5zqjSf1lk1pRY/KygbpEd/8i/KpgJ476zaun68+oVhiYdRJ7y7+4DXxq3lhEjhdFO6yMVtkJh28NWzSdGrj/6rnvPaS8e86QM0sR41ltCDGTZfLSd6HW83s80VssKxqEFNMRpsXIab3gqOfULKaQc4SGOzo9Z77jtNkHntEC1TfpRhQ5WYm/PcQrDDIM6VJPkaEGOUNTbSi6hlbCiSKLB+fQgRKV3JTaV2dNoZfdKe8LE8JCc2CCiaJqu2klrRJfDRQjNM9zGWIeP3Z7jG6QKFiCDJa08atv60/zz2t/d6Rl7klkL9HELIeFKNbgzd2WL42aT/Kjw6vLg5aESMevOQcIzsjcEu20Yn8H0z42/B2q+gnfkqkGfqZ7efoh4FGv1VpJUsQl9+Opxg7lJBPWBNEvQXoT+EOzA00rPArrilonPQvOKU7+uQAcWCyxxukBu1xLD4wSjKYsQn0B2B0UQ5JfnpMd9wAC2wK/7/W5
 h5bDFxSH
 jZ2YRRKGN2bsgSRv8LgKcLRlMZRI0b0B5ChF7n+XoKrfwioIlBDMstMDrqcIveF9BQCMzusBZ+KK0AAr4UQOerUyVFlKl9LKLc8c0pYjZbxkY8Cd26ut7A85OC/ozUxYxQlMUpT7y1l9Pv/UQGgffSWf9Wmxau3ExgDW4/OWWa+/x1qjbbn5EaWKTGxZRd1FLrn9DXbLMdCMVrTwBD0E8Mb3kp5sT6WCAeHACDNjbq0qQIvBY07pZ6e+xds/th1bXtrv4w9sRn6s6PxhLbZ/7zJ8luCxntJ5SRvtW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 56708d1d2dfd5..147e74f9732d5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -164,6 +164,9 @@ struct scan_control {
 	/* Incremented by the number of inactive pages that were scanned */
 	unsigned long nr_scanned;
 
+	/* Number of pages that were scanned from isolate_lru_folios() */
+	unsigned long nr_isolate_scanned;
+
 	/* Number of pages freed so far during a call to shrink_zones() */
 	unsigned long nr_reclaimed;
 
@@ -1673,7 +1676,6 @@ static __always_inline void update_lru_sizes(struct lruvec *lruvec,
  * @nr_to_scan:	The number of eligible pages to look through on the list.
  * @lruvec:	The LRU vector to pull pages from.
  * @dst:	The temp list to put pages on to.
- * @nr_scanned:	The number of pages that were scanned.
  * @sc:		The scan_control struct for this reclaim session
  * @lru:	LRU list id for isolating
  *
@@ -1681,8 +1683,7 @@ static __always_inline void update_lru_sizes(struct lruvec *lruvec,
  */
 static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
 		struct lruvec *lruvec, struct list_head *dst,
-		unsigned long *nr_scanned, struct scan_control *sc,
-		enum lru_list lru)
+		struct scan_control *sc, enum lru_list lru)
 {
 	struct list_head *src = &lruvec->lists[lru];
 	unsigned long nr_taken = 0;
@@ -1766,7 +1767,7 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
 			skipped += nr_skipped[zid];
 		}
 	}
-	*nr_scanned = total_scan;
+	sc->nr_isolate_scanned = total_scan;
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				    total_scan, skipped, nr_taken, lru);
 	update_lru_sizes(lruvec, lru, nr_zone_taken);
@@ -2014,8 +2015,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	lruvec_lock_irq(lruvec);
 
-	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &folio_list,
-				     &nr_scanned, sc, lru);
+	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &folio_list, sc, lru);
+	nr_scanned = sc->nr_isolate_scanned;
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
 	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
@@ -2071,7 +2072,6 @@ static void shrink_active_list(unsigned long nr_to_scan,
 			       enum lru_list lru)
 {
 	unsigned long nr_taken;
-	unsigned long nr_scanned;
 	vm_flags_t vm_flags;
 	LIST_HEAD(l_hold);	/* The folios which were snipped off */
 	LIST_HEAD(l_active);
@@ -2085,12 +2085,11 @@ static void shrink_active_list(unsigned long nr_to_scan,
 
 	lruvec_lock_irq(lruvec);
 
-	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &l_hold,
-				     &nr_scanned, sc, lru);
+	nr_taken = isolate_lru_folios(nr_to_scan, lruvec, &l_hold, sc, lru);
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
 
-	mod_lruvec_state(lruvec, PGREFILL, nr_scanned);
+	mod_lruvec_state(lruvec, PGREFILL, sc->nr_isolate_scanned);
 
 	lruvec_unlock_irq(lruvec);
 
@@ -5920,10 +5919,21 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
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
2.43.0


