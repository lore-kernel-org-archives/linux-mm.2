Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 497B5CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 07:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34D768E000B; Thu, 25 Sep 2025 03:32:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B7B08E0001; Thu, 25 Sep 2025 03:32:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0A0E8E000B; Thu, 25 Sep 2025 03:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF0EA8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 03:32:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9BE2F16034D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:32:41 +0000 (UTC)
X-FDA: 83926955322.23.AA17BFE
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 84EEF40007
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:32:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cAiHdyP+;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758785560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/iV+2qSDfbqGJGlOtg+T5iAut/k8Wvw7Udwono6Cens=;
	b=K/pZV2LDKeDy6Z6p6I6LfbKPDdTL38Xw43JycSgBuVHC1HkeCPOuTSslLXzqa3au+zSRIG
	BUpg95JaA4B7zOfbc9jMpaTlLI4PRXDnte2hrqM4hulqh6IupqLx9YvcUunKJypvBExEsN
	CTiSU0YFIXZUstkAAZj6I0AgrJzh2Bk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758785560; a=rsa-sha256;
	cv=none;
	b=Vo81s38g4udvfowm9R/BPBnJfUD6jzxjtTuPeaQ/uHOw1pR050AO8FneWMhNCg/WaPqkVR
	sp71Knet+cAyODMaJV2SFr5VrlhysAs3FnfBA5Bc39NT/FNaAlNVSXBSYHh1WYGWaZMnYS
	CwQPQuJfgnbMR2ojzg8ew1m5k7Zlf68=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cAiHdyP+;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758785556; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=/iV+2qSDfbqGJGlOtg+T5iAut/k8Wvw7Udwono6Cens=;
	b=cAiHdyP+Qmenfe1fIBy/cA8wjnb0axpZdKrUJS+nI/iisXJUfBAp9Rjjg/7KjkAWmhwSEn6f/pewN2HrUbxQ333a4IBcc/mwMTplvjGWZaHa/0sDiXYIMM87UI1UL6KeOdjK29jjZn51Gyf/rX8y2T7kQk/dVRE/XKJKc0hG2Ms=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WomvkMn_1758785553 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 25 Sep 2025 15:32:33 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@redhat.com,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	hughd@google.com,
	willy@infradead.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm: vmscan: simplify the logic for activating dirty file folios
Date: Thu, 25 Sep 2025 15:32:12 +0800
Message-ID: <166c482b066b7da2aeaf780f0ef5ab4ae150d440.1758785194.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1758785194.git.baolin.wang@linux.alibaba.com>
References: <cover.1758785194.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 84EEF40007
X-Stat-Signature: cbfba9mtqb5ta8qyo4b6c8rjs8ip94cw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758785559-555762
X-HE-Meta: U2FsdGVkX1+TRVs1wN+D/rzLzVxjt8qu3V8wQVxodnNIJf9uS/GAbJ4Bl0GkJWJAtZokwi2VMJuTzXhUjF/ySR6I+5oLkKQLtfEudCZaLoAuQlUImNeuh4C7mprVNaq116x0UtCUxcygSVi003mXTYQdz4A+8S+cU13X7EbMqACpPFK1cUIR78BUSPwLuKzK5uHDd3OGRFvnfWfGj9ddgFPQzs2xYe3/vERsNbpliaLH9kuNTGh4Cz78Ir1ua5Jpj1Oq0EqkpLY071t7evzySJeyOBS2hHFDh6VQIIWdFeYh+sN/GqlyGsIkHpzIsT5XSEP8GZqKXQrRV6scavbgo2VPW1MZ7HIt8uDKQYH0u1Xmb282u+tbncC9nA+2abMA0IkDzlYfrAOxrhcxM8nIyacMA1bslL0Sfn0hGha/Uvo445U1gzCHU8miHD3dgEyP6G+vTd6XN2nzKNISpPOF53xu9f0jxiQuhxpOJbEVTQ7S3Io2KhA+VZhf1e4ggEcGyDpsod4+M7r8iKPT0MHoc3bOYrP/vRmiQ4zkG/FeG/5c3OGmrRMcmpedAYNvSfpuKHR46yINZqqWBSx9dHlGzNrYQkzetuIq8bQcZMJfSA5MyKppbBHtFTT3UVzozEdugLEkGaM/Xre1l4rqTflqogR47NM7dd5JKiGHlwLylUO+wNv9124sFnR6eWHJRzFozsn8idf1lfqhAdiUOhMaZeJkAz4ZG2Vb268ibhcXZW/8oiRvVLQRXWEs6ogJr27ile9mQqfpqgr8bDEerw+piEdxbiAFHl3OoajTbWvRo27D1GBPID0NA3b3/TWMDd7jpRFoSt/jvOqPsICUk/KblqLtnnTD9jdGgbyg/B9H67/0ljyzoCHiBhGbTdS5/qsc89cRJjEk/xsMnxhZJc0D9upyrKFOH+dN0EVxTQMBZGZCFDKuDL0B2SXBGvzWfdjuBQ5g15ptDR0VlZXy9qR
 VEVmt4J4
 yC8k/A8b9ErLi2yisZnYRULj0Ps3wGSD7qFLJZoJKoc8jRf+6KdvHRHilHuEn3+PhsNge/ZGr41XCEy5XOx+v59LKDYhhk4I3BE3UynSMc6fgqVsUvmQzJCCpyZ6pH0Wd3Sgrw4N1iLqXzRrFAIJBk0VOOuIkjCUiqXYBXOL3VTP1XF0InuvIfsUmhldYo8msb4GysjRQbSyropUiN7iN5cra8TecOMDTwUKZpT4rHqb6DlmFahKVrNQRrZUyMhsgM/Wt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no longer
attempt to write back filesystem folios through reclaim.

However, in the shrink_folio_list() function, there still remains some
logic related to writeback control of dirty file folios. The original
logic was that, for direct reclaim, or when folio_test_reclaim() is false,
or the PGDAT_DIRTY flag is not set, the dirty file folios would be directly
activated to avoid being scanned again; otherwise, it will try to writeback
the dirty file folios. However, since we can no longer perform writeback on
dirty folios, the dirty file folios will still be activated.

Additionally, under the original logic, if we continue to try writeback dirty
file folios, we will also check the references flag, sc->may_writepage, and
may_enter_fs(), which may result in dirty file folios being left in the inactive
list. This is unreasonable. Even if these dirty folios are scanned again, we
still cannot clean them.

Therefore, the checks on these dirty file folios appear to be redundant and can
be removed. Dirty file folios should be directly moved to the active list to
avoid being scanned again. Since we set the PG_reclaim flag for the dirty folios,
once the writeback is completed, they will be moved back to the tail of the
inactive list to be retried for quick reclaim.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/mmzone.h |  4 ----
 mm/vmscan.c            | 25 +++----------------------
 2 files changed, 3 insertions(+), 26 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7fb7331c5725..4398e027f450 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1060,10 +1060,6 @@ struct zone {
 } ____cacheline_internodealigned_in_smp;
 
 enum pgdat_flags {
-	PGDAT_DIRTY,			/* reclaim scanning has recently found
-					 * many dirty file pages at the tail
-					 * of the LRU.
-					 */
 	PGDAT_WRITEBACK,		/* reclaim scanning has recently found
 					 * many pages under writeback
 					 */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f347865edc70..b1f8eea67c8e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1387,21 +1387,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 
 		mapping = folio_mapping(folio);
 		if (folio_test_dirty(folio)) {
-			/*
-			 * Only kswapd can writeback filesystem folios
-			 * to avoid risk of stack overflow. But avoid
-			 * injecting inefficient single-folio I/O into
-			 * flusher writeback as much as possible: only
-			 * write folios when we've encountered many
-			 * dirty folios, and when we've already scanned
-			 * the rest of the LRU for clean folios and see
-			 * the same dirty folios again (with the reclaim
-			 * flag set).
-			 */
-			if (folio_is_file_lru(folio) &&
-			    (!current_is_kswapd() ||
-			     !folio_test_reclaim(folio) ||
-			     !test_bit(PGDAT_DIRTY, &pgdat->flags))) {
+			if (folio_is_file_lru(folio)) {
 				/*
 				 * Immediately reclaim when written back.
 				 * Similar in principle to folio_deactivate()
@@ -1410,7 +1396,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				 */
 				node_stat_mod_folio(folio, NR_VMSCAN_IMMEDIATE,
 						nr_pages);
-				folio_set_reclaim(folio);
+				if (folio_test_reclaim(folio))
+					folio_set_reclaim(folio);
 
 				goto activate_locked;
 			}
@@ -6105,11 +6092,6 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 		if (sc->nr.writeback && sc->nr.writeback == sc->nr.taken)
 			set_bit(PGDAT_WRITEBACK, &pgdat->flags);
 
-		/* Allow kswapd to start writing pages during reclaim.*/
-		if (sc->nr.unqueued_dirty &&
-			sc->nr.unqueued_dirty == sc->nr.file_taken)
-			set_bit(PGDAT_DIRTY, &pgdat->flags);
-
 		/*
 		 * If kswapd scans pages marked for immediate
 		 * reclaim and under writeback (nr_immediate), it
@@ -6850,7 +6832,6 @@ static void clear_pgdat_congested(pg_data_t *pgdat)
 
 	clear_bit(LRUVEC_NODE_CONGESTED, &lruvec->flags);
 	clear_bit(LRUVEC_CGROUP_CONGESTED, &lruvec->flags);
-	clear_bit(PGDAT_DIRTY, &pgdat->flags);
 	clear_bit(PGDAT_WRITEBACK, &pgdat->flags);
 }
 
-- 
2.43.7


