Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03FF6CCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:11:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CC438E00F9; Tue, 14 Oct 2025 08:11:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57C438E000D; Tue, 14 Oct 2025 08:11:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46AEB8E00F9; Tue, 14 Oct 2025 08:11:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 327438E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:11:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EEC2D86D97
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:03 +0000 (UTC)
X-FDA: 83996604006.13.2CE381F
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by imf29.hostedemail.com (Postfix) with ESMTP id 647F7120012
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=b3MP2PPQ;
	spf=pass (imf29.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760443861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gsFsMIu+qmP5Pk/U6/E+nZJ61/APVl3sjNSY2NmttmM=;
	b=1l+oXyvwLx7MObTmEs3dHbX07AAs27EFdmqBQZVaANc2SdYtaMPz8/tJxy1/m6156Etb9P
	HeBNZRFzXdB4GBAHx9w4SeNdKCtBuPE8u+LcHtn2CcniRlp1ROWvLyEhnkrJrCDqze21DT
	0H8h8ADaYm8E9Yqyg7J9pzv+uCjjMr8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=b3MP2PPQ;
	spf=pass (imf29.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760443861; a=rsa-sha256;
	cv=none;
	b=fa1b8C0cjEa1uYQvs8QgoGmc2wvsBcpMGTD+8odVlMfHr67T0O2TNQcg+JXGpsQ1Gi3R0W
	xCbi6Bm1SzJK5f8g8Dcj7rPaNGd1mijYUjWfzx9D0JZ9eUgUxiCIx1wECav2YuZdg9Ntum
	smLAYQtuCscaeVJ4gsrbSN8gNvdhso0=
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251014121059epoutp039a3aa3a57a1ade7b1497c2fed57504c1~uWlzPIVia0342003420epoutp03k
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251014121059epoutp039a3aa3a57a1ade7b1497c2fed57504c1~uWlzPIVia0342003420epoutp03k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760443859;
	bh=gsFsMIu+qmP5Pk/U6/E+nZJ61/APVl3sjNSY2NmttmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3MP2PPQADA0hrQOZsvNMk5IqyvoGROiAsnT/N0hTNdssHWHiaozpoXzdpcNl/4nY
	 aK//QNWUQ2GADLe9sOhTiSothJkAzC/Y6IHX6jQBZo5oxpejhWhMkIHsNmMlyxWPl7
	 hV5ajXmyC+3hwqX4nk9gxZZfX2spne9pdDHx46dM=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251014121058epcas5p4efc8532b88fe6f0919db6df3984eaab5~uWlyadOAm1326113261epcas5p4x;
	Tue, 14 Oct 2025 12:10:58 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.90]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cmCjY1B5gz6B9m6; Tue, 14 Oct
	2025 12:10:57 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121056epcas5p1cd2a7fde9f54633b5a331f4553f88735~uWlw9E8x81946619466epcas5p12;
	Tue, 14 Oct 2025 12:10:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121048epsmtip19b929dbb834131481e70a8aeb346f9bb~uWlpts_jW1309013090epsmtip1H;
	Tue, 14 Oct 2025 12:10:48 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: jaegeuk@kernel.org, chao@kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, miklos@szeredi.hu, agruenba@redhat.com,
	trondmy@kernel.org, anna@kernel.org, akpm@linux-foundation.org,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, wangyufei@vivo.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, linux-nfs@vger.kernel.org, linux-mm@kvack.org,
	gost.dev@samsung.com, kundan.kumar@samsung.com, anuj20.g@samsung.com,
	vishak.g@samsung.com, joshi.k@samsung.com
Subject: [PATCH v2 08/16] writeback: add support to collect stats for all
 writeback ctxs
Date: Tue, 14 Oct 2025 17:38:37 +0530
Message-Id: <20251014120845.2361-9-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251014121056epcas5p1cd2a7fde9f54633b5a331f4553f88735
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014121056epcas5p1cd2a7fde9f54633b5a331f4553f88735
References: <20251014120845.2361-1-kundan.kumar@samsung.com>
	<CGME20251014121056epcas5p1cd2a7fde9f54633b5a331f4553f88735@epcas5p1.samsung.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 647F7120012
X-Stat-Signature: uzuttdy458pbrura3dbw3yogpsipqytm
X-Rspam-User: 
X-HE-Tag: 1760443861-638679
X-HE-Meta: U2FsdGVkX1+d5mHem0E0ZYja2hp17YrIq2lJFmIpe9VpGuaOXigwVU875bKjsCy/NOb+dWzBjJ46ImzJO3evdKIpr16PmTbrI9El6m/JIOXkTbqAuTkSKSKyJycRvEznxQZGLJOADOBoNJS2lujnVc2mwvZ+sNnhrNKQ0zwjPx8D5EBOyPHANEAJUaaLKZxi1Db5h+JYybvaxeWA8qyi/UtqIa5Qo2UY6uaULz1sJPEf6dwXT9QUNcD9N77csA0gSkzjqDd1RnzDzDdxcNW6uR5rs5phk8qP1mD0TeGK1GrPDQ7tc/bgSGK44i6dXqlTwExR2CaOA/NU4swE6IKNXt8HFGO6ciLixzktC2zzov6JOmAWuCsKvYQK2RgtLtdnm0ownx/fXJF/c7A5+PTBLf0hkjRzTaUpFzKhE7CJddcT9hzWu0uJgBKIicDTBbJhnbXOdv1oTDddpeC7OUgpvf9yOPZFbeekond/KjSvzQtMaQMnVPi7jpvaRc522IqBdpbsDF499f7G3q9wOnQYrScwZfclH25VgHZjlrK5ZADP+7rUOr4caM/3Wv5PHn4/zxGqO6hWSZV5116MFlh7oHjnq+ZGwVdNm0xugFxt2jdZShyt933286/yzEbPccW6CA0xgbOC+QaeW00M2Cae2iAFY2apo4QZB1TDilnawBOq3tQ/51MGBkjoSKt8KuF6rJyL6x6lSG63Dyy16/QzNPl1xnmKgELl59liTd3n3vxC2Yk9Lzhn4MzM5CvtISjaj6ucT5KTNmmxUBoUufSsr74W9CZSLnU8suClHoD1vHBsDRh/oHWx9HaPeMXgGVdoX9ZYcFn11RQ5biLTGr7CyvCa5GuNxFrzIVwZ/fzhvIIuY2b2uDl7eTvQbxLT1XsmI7qmnquczlwcPjgkSt1MMo8DTNirBxVflBq3XBapRplpYgDH+gO/dNfmnNQ5zSFKhqT9CurBzrMEZklaelC
 N4x9hAaJ
 z4LpKJP6EHHsTZ5XcfTJloWEXNOZiy77nuF4H2nEylG7IuxvRhOkI6Fd0/ghVUybPVQ706Hwl5Erk3Ij1NoC+f2h9HEezOM7bnGLDB/ye1vn5ToD6XXBeOYxKJysmy+bQPcauHshy6uax5QVHRWKIDx18N0H35rLwa7nI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modified stats collection to collect stats for all the writeback
contexts within a bdi.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 mm/backing-dev.c | 72 ++++++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 30 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 754f2f6c6d7c..0a772d984ecf 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -50,6 +50,7 @@ struct wb_stats {
 	unsigned long nr_written;
 	unsigned long dirty_thresh;
 	unsigned long wb_thresh;
+	unsigned long state;
 };
 
 static struct dentry *bdi_debug_root;
@@ -81,6 +82,7 @@ static void collect_wb_stats(struct wb_stats *stats,
 	stats->nr_dirtied += wb_stat(wb, WB_DIRTIED);
 	stats->nr_written += wb_stat(wb, WB_WRITTEN);
 	stats->wb_thresh += wb_calc_thresh(wb, stats->dirty_thresh);
+	stats->state |= wb->state;
 }
 
 #ifdef CONFIG_CGROUP_WRITEBACK
@@ -89,22 +91,27 @@ static void bdi_collect_stats(struct backing_dev_info *bdi,
 			      struct wb_stats *stats)
 {
 	struct bdi_writeback *wb;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(wb, &bdi->wb_ctx[0]->wb_list, bdi_node) {
-		if (!wb_tryget(wb))
-			continue;
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx)
+		list_for_each_entry_rcu(wb, &bdi_wb_ctx->wb_list, bdi_node) {
+			if (!wb_tryget(wb))
+				continue;
 
-		collect_wb_stats(stats, wb);
-		wb_put(wb);
-	}
+			collect_wb_stats(stats, wb);
+			wb_put(wb);
+		}
 	rcu_read_unlock();
 }
 #else
 static void bdi_collect_stats(struct backing_dev_info *bdi,
 			      struct wb_stats *stats)
 {
-	collect_wb_stats(stats, &bdi->wb_ctx[0]->wb);
+	struct bdi_writeback_ctx *bdi_wb_ctx;
+
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx)
+		collect_wb_stats(stats, &bdi_wb_ctx->wb);
 }
 #endif
 
@@ -150,7 +157,7 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 		   stats.nr_io,
 		   stats.nr_more_io,
 		   stats.nr_dirty_time,
-		   !list_empty(&bdi->bdi_list), bdi->wb_ctx[0]->wb.state);
+		   !list_empty(&bdi->bdi_list), stats.state);
 
 	return 0;
 }
@@ -195,35 +202,40 @@ static int cgwb_debug_stats_show(struct seq_file *m, void *v)
 {
 	struct backing_dev_info *bdi = m->private;
 	struct bdi_writeback *wb;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
+	struct wb_stats stats;
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
+	stats.dirty_thresh = dirty_thresh;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(wb, &bdi->wb_ctx[0]->wb_list, bdi_node) {
-		struct wb_stats stats = { .dirty_thresh = dirty_thresh };
-
-		if (!wb_tryget(wb))
-			continue;
-
-		collect_wb_stats(&stats, wb);
-
-		/*
-		 * Calculate thresh of wb in writeback cgroup which is min of
-		 * thresh in global domain and thresh in cgroup domain. Drop
-		 * rcu lock because cgwb_calc_thresh may sleep in
-		 * cgroup_rstat_flush. We can do so here because we have a ref.
-		 */
-		if (mem_cgroup_wb_domain(wb)) {
-			rcu_read_unlock();
-			stats.wb_thresh = min(stats.wb_thresh, cgwb_calc_thresh(wb));
-			rcu_read_lock();
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		list_for_each_entry_rcu(wb, &bdi_wb_ctx->wb_list, bdi_node) {
+			if (!wb_tryget(wb))
+				continue;
+
+			collect_wb_stats(&stats, wb);
+
+			/*
+			 * Calculate thresh of wb in writeback cgroup which is
+			 * min of thresh in global domain and thresh in cgroup
+			 * domain. Drop rcu lock because cgwb_calc_thresh may
+			 * sleep in cgroup_rstat_flush. We can do so here
+			 * because we have a ref.
+			 */
+			if (mem_cgroup_wb_domain(wb)) {
+				rcu_read_unlock();
+				stats.wb_thresh = min(stats.wb_thresh,
+						      cgwb_calc_thresh(wb));
+				rcu_read_lock();
+			}
+
+			wb_stats_show(m, wb, &stats);
+
+			wb_put(wb);
 		}
-
-		wb_stats_show(m, wb, &stats);
-
-		wb_put(wb);
 	}
 	rcu_read_unlock();
 
-- 
2.25.1


