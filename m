Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E284CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 07:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E61B8E0027; Fri, 17 Oct 2025 03:53:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900F68E0016; Fri, 17 Oct 2025 03:53:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E528E0027; Fri, 17 Oct 2025 03:53:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 412D58E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 03:53:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F36F311A658
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:53:49 +0000 (UTC)
X-FDA: 84006842178.13.6D5A838
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf23.hostedemail.com (Postfix) with ESMTP id 564AD140005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:53:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AOmwRjTY;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760687628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oHdZGMzoWgx8F2L9qwK1aYNWjA2JpQlzaq9Ae2oOJGE=;
	b=MmmV2IhFOIAzxskCkADKmTHJ1CpVhtaXA+G3wC0XgYSvpfjHfEgGrRO2HFPsK4sqIu81m1
	1O72+1d2at1e4JWw92NuyVS/wI/uui1vIS+MWj6t6jmicGrWRwh4caZEFgQQYkog4ZcMto
	gLLqxdyPinpsRhCSAXKaz37InHVKK8w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AOmwRjTY;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760687628; a=rsa-sha256;
	cv=none;
	b=KXLsPktugkJY8fOb3/EdD0oamhKSmPwvHoHH38qY+e81heGULH+qbilZazZ/hAhXYNScD9
	4BgJEj59mkS5/qidDzCzI8xTSahtNP8cROI+COuLTTys8hR9fjtsOiUsujCz1ScI4ruMbC
	weyU8+axD0HPxpvnt1+LZi6njzZHje8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760687624; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=oHdZGMzoWgx8F2L9qwK1aYNWjA2JpQlzaq9Ae2oOJGE=;
	b=AOmwRjTYbTbp0Zv1zQSlBTqRWvj2JYICLhSuGZKB0jis3pH9YtK1ERYfBIxXwI4nRKWxtOmy96D/WBP4ezLNhyNwu4SbXQ2sTVbsF53QhXrMFZi7HXWtCSPH9VLIo3z58ArHqOEDzlIOJJGEof5hLfT19qalKB7qrYlfVPbKgmA=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WqPA.uq_1760687623 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Oct 2025 15:53:43 +0800
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
Subject: [PATCH v2 2/2] mm: vmscan: simplify the logic for activating dirty file folios
Date: Fri, 17 Oct 2025 15:53:07 +0800
Message-ID: <ba5c49955fd93c6850bcc19abf0e02e1573768aa.1760687075.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1760687075.git.baolin.wang@linux.alibaba.com>
References: <cover.1760687075.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 564AD140005
X-Rspamd-Server: rspam03
X-Stat-Signature: ju8gxf16wnx58qphqqtw9io7qiae9ukb
X-HE-Tag: 1760687626-669012
X-HE-Meta: U2FsdGVkX19+HlEo/I6gQcpYx7/sBcz7cNMuIEYQIyjKUkOdsjxEM+Vx6siYsoZ+351+23ub5KmMA26wmuCZ4DuMQor8J+TdVnMtlZhDQShKZa8dpPeNsQCNoC7BD1sGln9xAJRCv2wkPEsWyriS/hIDfNAuN7fJZm+0qImt2siUP+i1AXPGPvIMUNORpRk+SjjO2G4O0F7dIOQwSUsyAs99OducWnbYNScrWRWAyOi04xLP/dM3DoxnIwg0VdURea0ilRtc0YW1+JNiflNDoViZyk3N2V8zf9Gksa4NX6rKlvm9iWN8WvtWt5NPdAXxqIwHRb+e6uuaYqpamzIyz67qXKBwp+WWqVuI8DpuVZmQ5nnp5ZupWU3GGYZCFu6c76HgYLo22Z0C6qAmD3d6f0UnOY4B/DNV9ypuiMqFt8sIt0mMFvXS4DhNxYxMN7CJ1d/u8pHvbwoHw+H2XMY+V/skrf0hZIuePnMVA7hBbZTmnINfDTHhCquZGBIc013bQVqGRoTLp4gmIUF1WMsDvkcdCJwTOL+M71eZyrFCaBHsP2oQnTo358Ddm5gWQMc1qC/vQNGKAJIwxxsuv5JwdJt+juS5nrpz3IZeiIJ9zVAEFM0ZdkkUSZyr4ZPT1lVeh5BfB0Vet+YcFeQ5ZhovHukqsTXP0YJ58FpLLY6UirNFTBK+PT28mj6QYw5vleRluLP7dtpKxTBYhNH1gabryacJi92dqKygophX6gywjFLCQVv53z0IersR3ptaTll7ukgvGmLa88bOhPXX3UlRyE4MDvw+Wsuxx92u/1Tj9R+1obXW2y856QjO2Q1DoQcl47ZxAC6G6CKfPkmJh7NAOQTxIwgfSopBjCpgiVvaspjAMs7BHDFZ+w4Sz9IuaSqqwpzHJXwwEtQqHSMq09PKzdwzOVmX5WCc
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
index 65f299e4b8f0..c922bad2b8fd 100644
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
+				if (!folio_test_reclaim(folio))
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


