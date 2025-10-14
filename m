Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34532CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94DD08E00F7; Tue, 14 Oct 2025 08:10:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925728E000D; Tue, 14 Oct 2025 08:10:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8624A8E00F7; Tue, 14 Oct 2025 08:10:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75B648E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:10:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C121BBDEA
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:50 +0000 (UTC)
X-FDA: 83996603460.26.E4C86CB
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by imf27.hostedemail.com (Postfix) with ESMTP id 58E4340018
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=B0TNqDFo;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf27.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760443847; a=rsa-sha256;
	cv=none;
	b=PJchwlSY7/j7XUREr3qu2Bs16b6fKIn9BtJ78T4EfCXIHZL+/BpPX2CLuCrxv3ieZMTHSN
	hg6M8KurwvoBV4w9IrNUbT0ntawjNmcEqI/AienMZdNiJrLpyWBTB63qCZ6uyRwo6zjFv9
	l14yAsOgCxVfISxFpnoerdzBVAMX/Pg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=B0TNqDFo;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf27.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760443847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dioO0YDP7mzhZqCWconGW6ike9OX4ckBo46ONrqcrR4=;
	b=DKI0fPaddkRIyHX1tgsfmCYduN1xejcA73V38opkzwXVotCDhK6bECSmN4i84NDwic7JTP
	VkYjClORSOEsOiJ8TsoV2efrP17V9VFYlWectzt/htG+jUUwTjhbl7Eu5nCruT4GvT5Qdc
	zFdMGAIsbfue45NwcP3jSUmkYhgCr3o=
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251014121044epoutp01fe755bdc955f22e6e4405929e3a9affe~uWll0YlZW1133811338epoutp01N
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251014121044epoutp01fe755bdc955f22e6e4405929e3a9affe~uWll0YlZW1133811338epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760443844;
	bh=dioO0YDP7mzhZqCWconGW6ike9OX4ckBo46ONrqcrR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0TNqDFoyqdsRahkcmFej3wpmKZnuHdX78pZTjij1NDXzZRcoesm5o+KDGOZcvjnw
	 1PpV/Vt3iRjOFLDSMJUARarfYJK/q/4FDpMIWV1kDbLWEfBMzrQgdIu9IfuoWgo8Io
	 YXUfAsH8n69hTOFMEGQu19qQlRYtQqe4NpgWbk1k=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20251014121044epcas5p2f380d81531fc3d4fad2cbcf760ac1c1f~uWllTAZGM1888018880epcas5p2q;
	Tue, 14 Oct 2025 12:10:44 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.87]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cmCjH05ybz2SSKY; Tue, 14 Oct
	2025 12:10:43 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121042epcas5p16a955879f8aaca4d0a4fd50bc5344f55~uWljkHFol1447514475epcas5p1o;
	Tue, 14 Oct 2025 12:10:42 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121037epsmtip1cb43407e8777ba7eb89d4bf5e248dc43~uWle9F8wv1239712397epsmtip1O;
	Tue, 14 Oct 2025 12:10:37 +0000 (GMT)
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
Subject: [PATCH v2 06/16] writeback: invoke all writeback contexts for
 flusher and dirtytime writeback
Date: Tue, 14 Oct 2025 17:38:35 +0530
Message-Id: <20251014120845.2361-7-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251014121042epcas5p16a955879f8aaca4d0a4fd50bc5344f55
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014121042epcas5p16a955879f8aaca4d0a4fd50bc5344f55
References: <20251014120845.2361-1-kundan.kumar@samsung.com>
	<CGME20251014121042epcas5p16a955879f8aaca4d0a4fd50bc5344f55@epcas5p1.samsung.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 58E4340018
X-Stat-Signature: 3kowmfipzsq8s5gfz38q8shgu1pr6fen
X-HE-Tag: 1760443847-586477
X-HE-Meta: U2FsdGVkX18Bwz9Z2grmGapufOb7N0M6RiGUH9WQiXyPOinyG5d2R+Yr5TxwM9BRDzqvSW0gxGS0at9jP6/JBaC6vv1RD/EG743jwW03qBV4Bbd3eGIeTVSwP6F8bHD7M/swiFNx0akpIlQiQ6wP9lvsV/MJBox+7L08Tib1dqWY+MJpAhXO/AstR8X/B7mFtY4oGZOkVFNb/iVEa1V0b9/ya17xtGshAoAPi2JHxoVVERKfcdeKeXDP0pF9Cyk/GeSyUi4qp/VHRk8BCslInCLbvHt7rES+CWM/nTLo9NnE7Z24MoQCwuBFUbBtS5XhvJmHpiEDCN0rpUvEJ9Io6R6/urPdrVvbP4wFJGCpKSAitvLJC2NU68F2CskO0mfor+qOCaWwpsNK/GHjtu27Z7O5DxmAN6MupfNNCDuHp39r84rABkkGhKlwwxzSrxSXKFGYXxpkjBFnhLKCa87HnvIKEFn2YI/RVChfo4bEltxt4L5lw04NxfruPBNzZLwx6NXOhqthWamCG/C434BvD+9wLwDCUbPpGwW3o7fgZT/Xqg31+Itk8zMyP34VJo48wirN0VHyq4ifyS0/dEmqGLlc1cP0B0JbTRXY53fYvTa12u4y8j/RZKf9OXsTnMXDqgcNXtsrGflI7e5QG8+IMDuIfj7X4+TuP8MKM+cCQOJuyLYQRt/6it8wCRnAXnvy2Xe4DUjj33cszOjdEzUWkwlP0DJcAPPpyN7S3AWuhVYbYmfmS+eDNjiPiOLdfun/KLD03DeqkfBcGEy0mQGSbEUNQQ1nnoHRXFavfqbO7drZQtj5mg5sBeR4ejXka4PYswsCm3q+4BrfU4OmnnYNc3IrNdgqjRjEGdqu2AOEjpROh6WNW3M+8gypmkGtzSENTTxeqPis/NF4Ty3kL3JeIqR7JkZ0MV43Ir+WcayE+U1HbbFOvpe8l1OZpnxIQxrZdmATylIvFsbS8bkkEvT
 rqbuthUj
 ifUpwiDSDdSsT4Hc2mzNlxktSDWQFAEjcmEu0kPY3hLsGYVUnZfLAmH3jg1d7Aqs4zCmXzbbgAEBp2YoMWBaEm+LjNmfJ1hhuf4C9mh+pVDcWJpAfLm43jh4CPN+DqHwNaIfMs4KvrmbjRbI9/AyuWtc5QnyQK1B8Rq3scCdFTNGBnGJLT2A4//hDwLGZPD2uU7VA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modify flusher and dirtytime logic to iterate through all the writeback
contexts.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/fs-writeback.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 93f8ea340247..432f392c8256 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2389,12 +2389,14 @@ static void __wakeup_flusher_threads_bdi(struct backing_dev_info *bdi,
 					 enum wb_reason reason)
 {
 	struct bdi_writeback *wb;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 
 	if (!bdi_has_dirty_io(bdi))
 		return;
 
-	list_for_each_entry_rcu(wb, &bdi->wb_ctx[0]->wb_list, bdi_node)
-		wb_start_writeback(wb, reason);
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx)
+		list_for_each_entry_rcu(wb, &bdi_wb_ctx->wb_list, bdi_node)
+			wb_start_writeback(wb, reason);
 }
 
 void wakeup_flusher_threads_bdi(struct backing_dev_info *bdi,
@@ -2444,15 +2446,17 @@ static DECLARE_DELAYED_WORK(dirtytime_work, wakeup_dirtytime_writeback);
 static void wakeup_dirtytime_writeback(struct work_struct *w)
 {
 	struct backing_dev_info *bdi;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
 		struct bdi_writeback *wb;
 
-		list_for_each_entry_rcu(wb, &bdi->wb_ctx[0]->wb_list,
-					bdi_node)
-			if (!list_empty(&wb->b_dirty_time))
-				wb_wakeup(wb);
+		for_each_bdi_wb_ctx(bdi, bdi_wb_ctx)
+			list_for_each_entry_rcu(wb, &bdi_wb_ctx->wb_list,
+						bdi_node)
+				if (!list_empty(&wb->b_dirty_time))
+					wb_wakeup(wb);
 	}
 	rcu_read_unlock();
 	schedule_delayed_work(&dirtytime_work, dirtytime_expire_interval * HZ);
-- 
2.25.1


