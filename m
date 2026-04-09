Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31E82F31E5A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98CE26B009D; Thu,  9 Apr 2026 12:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964AE6B009E; Thu,  9 Apr 2026 12:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87AFB6B009F; Thu,  9 Apr 2026 12:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76E2E6B009D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:04:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2466C1406E0
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:04:03 +0000 (UTC)
X-FDA: 84639488766.26.01257FB
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 842D318001F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:04:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=X1ZE0ZDD;
	spf=none (imf16.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775750641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t91yQKljfNS63wofUJw8789t2weIp40I1JaX9qzqq/I=;
	b=r/wpU2v6NBjDDR9DCIc14QFJ++7l5dGL+widrH7n4nnndYuAjMIHIJbyg2zYi1/h/FUtaL
	QViU9EEk3Jo+2BgU7zQPBJqp11gjUNVuWSHKK2bL+lB+N/FBDLobEXQ+gbneyTBClNRnuk
	2IyeeV6Tc9ruY3DwXlg4bts9MrNm/Zs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=X1ZE0ZDD;
	spf=none (imf16.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775750641; a=rsa-sha256;
	cv=none;
	b=34oizyzaog/ka/N1sJ25R7Jok+ActuvGozrSZYn7KshMhKC4CcSTTya8mAKgJtUHDW/OfS
	2YCR5OaSnxS24qDC5ECjF0q+QtdYWlTbSFz2KtkBMJN9gaRMpGdT0jIYzguaBboer3reWY
	+PAnP83+LRc2UrypvcsCsynmXU/0eV4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=t91yQKljfNS63wofUJw8789t2weIp40I1JaX9qzqq/I=; b=X1ZE0ZDD0CNHcWIVi7HvmYlnnl
	ql47n/PEo3jTxAimPcUqUooqEeMGZQ+kLPZnSxv0okP10ALtx3AS8kd4H7sMvE7aoJ9br8aCC6IlR
	7gLmL/RBYLKxVHGbZRA6DMgeCKEKSr0BeeaKYaNUN1zp4JYZjr+wyRTF3inwNkTIzP6mu9dwRON2/
	xY/9H6T/ITGNQ+KWlXCD/u995zv5eIfrqhE8y8PFBFrzraYbRZvEDYnRVJSGhVY731XojBzPWiA81
	WjOJeJQY+MoI1gSMmBlgbZB9GScIr68ONzwmI4rJxFiT1IQhEfyPoTS7kdoPyeGEw+aGEmV3wrx9m
	fCM17YVg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArrJ-0000000At8B-1JIj;
	Thu, 09 Apr 2026 16:03:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Tal Zussman <tz2294@columbia.edu>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/8] iomap: use bio_complete_in_task for buffered write completions
Date: Thu,  9 Apr 2026 18:02:20 +0200
Message-ID: <20260409160243.1008358-8-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409160243.1008358-1-hch@lst.de>
References: <20260409160243.1008358-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 842D318001F
X-Stat-Signature: jooz6ekezme7wuzx5ez7dt8qg9s8bziz
X-Rspam-User: 
X-HE-Tag: 1775750641-123210
X-HE-Meta: U2FsdGVkX18jHrLExc4sdm31PnThHc54TmmAwHe+IzHdVaZtoDWD/8VMRy0pn9sWuLlqUl7eSvuBvm0kZIwpHOaG1O+mHMYNOAyPZOzwOe7fHmsXHtS9jGqF7u3DhgFTX74OtWjPBrm2/w8+ETHC5wo3mTT9rsxgKLfMhhtuplf4pJ93xrIgLsjEWyi3SFGE3kaZ+hUA9I//OePJM2XvmxJYVtJXtJg8UHILTDG7SWRAqW82z/JZwat3v2/zUo3gJRdiNkZXBvxdgRtPJegiHxKpAGj247/aeg5Y1W0gY0NB0pAo2y8sZWnHp/+WwwporMxqS0eV5J7fIU8qt4rCvjl68gfVdlow8+hrS95lDBtTIGJldon2iINOcnI/RYucfKhi8KLVoqnYPz12bcrlaj8Z5Zy0NY3shTrKV/9Yd6kZGeM4rlIPciV61qqk9BSOxTjTAh6Aa4i1tIOYwtFkVS1VTITkyxc8ksTrFt4x1vugToA9Kc5Cjw6ZfK31UX9btPZLweTQ+iGu24fxRIGI3V1sec/3J5OSIVdT3J69uQGASPn0UHD8Hw6voKyf6gQTAtWTbjEqiNSAghzO2zNnws7J7R7oY6BG0/dpRW2/BYB9k8LIjVwdA/BanKc1HsfoayndELEk9MAEXyIjBjYdJU112LAbBQiblibeDCRAGwIy1YadjBflBue4kVY4M5yLAH3wMSrOma/X+083mILm/ETmcvuOHSKVqj/rZYbkb2JdSc7mQs68IGlw4FdQDMK2C+xEOcJd7mv8Wx33MuHGGlb45OodHVhA7ujve3zi0kQOLQEtbv4Ix0NjkvDTJVZVT5EnWYSCiDlN9sWLkzsXNt79hOE7puhQICxs7f9bQVPFb1lbPgPjXFy06Tj9VEwcStV3MsEv8tqHnlKtF5t0777p4A/c/3pgV69158f14tu7nc8rvcPudzs5TIkKrNvpS9TJP2OU5t0YfDf3bIp
 wHPMpm0s
 E3019sixRa/gHjk6TnQocxbWV/4KEMSOtF14Lo+zpmYFNI8LmgI86zZft59+Ls7GisAPejglOFqc0a1ssz6BNujB1pLtGcJBbLTvpCRxByFS0V05OTFNVN6GC6BS6GhTGOlTPDVQ72ZNz1vDEuwgBJ8nLarJR7Nl0e2UkIlFxrEp90BII3kFtbgcQv2SdkMqJQFdfGUUVcwysK0EEHRKc9cBRdMtwpe8MfSOVhthtrM+hhNWxmBG1H6T4R8FVKyqnur5GtFA60sOm+aCsmSXbM+w16311XEc+WLDV5n3k6EZ6wR0HrB62r19QUMSw73Tp/5wTrk9u+CfAHNk86mSonrw44kjah8SgE+arv0xpNrtGjvCnevqdCp2AgCYBWFHHchT+MPiZglizZenj4ybZ6KqHf9ec0DYrVx64rQhPkDoodN13j7Mnre5piWqsBfHqz3WweXV3zxBnLF4UuSWgXHbHJFypHhZ0HRfOoPIjZb1QdCxQJpmluYWGFdhbPC/Jxcc9UnIPO2pg8efZu0QiQwU3bA9mI0AhFd93mi3yeB5o/iNDeZKRj098dVJtWMPfWzUbBVs7WvOyjHH/j56nihXOKJyThC62mXlo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace out own hand-crafted complete in task context scheme with the
generic block code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/ioend.c | 53 +++++-------------------------------------------
 1 file changed, 5 insertions(+), 48 deletions(-)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index a32ece8a3ee3..160224007486 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -72,63 +72,20 @@ static u32 iomap_finish_ioend_buffered_write(struct iomap_ioend *ioend)
 	return folio_count;
 }
 
-static DEFINE_SPINLOCK(failed_ioend_lock);
-static LIST_HEAD(failed_ioend_list);
-
-static void
-iomap_fail_ioends(
-	struct work_struct	*work)
-{
-	struct iomap_ioend	*ioend;
-	struct list_head	tmp;
-	unsigned long		flags;
-
-	spin_lock_irqsave(&failed_ioend_lock, flags);
-	list_replace_init(&failed_ioend_list, &tmp);
-	spin_unlock_irqrestore(&failed_ioend_lock, flags);
-
-	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
-			io_list))) {
-		list_del_init(&ioend->io_list);
-		iomap_finish_ioend_buffered_write(ioend);
-		cond_resched();
-	}
-}
-
-static DECLARE_WORK(failed_ioend_work, iomap_fail_ioends);
-
-static void iomap_fail_ioend_buffered(struct iomap_ioend *ioend)
-{
-	unsigned long flags;
-
-	/*
-	 * Bounce I/O errors to a workqueue to avoid nested i_lock acquisitions
-	 * in the fserror code.  The caller no longer owns the ioend reference
-	 * after the spinlock drops.
-	 */
-	spin_lock_irqsave(&failed_ioend_lock, flags);
-	if (list_empty(&failed_ioend_list))
-		WARN_ON_ONCE(!schedule_work(&failed_ioend_work));
-	list_add_tail(&ioend->io_list, &failed_ioend_list);
-	spin_unlock_irqrestore(&failed_ioend_lock, flags);
-}
-
 static void ioend_writeback_end_bio(struct bio *bio)
 {
 	struct iomap_ioend *ioend = iomap_ioend_from_bio(bio);
 
-	/* Page cache invalidation cannot be done in irq context. */
-	if (ioend->io_flags & IOMAP_IOEND_DONTCACHE) {
+	/*
+	 * Page cache invalidation and error reporting cannot be done in irq
+	 * context.
+	 */
+	if ((ioend->io_flags & IOMAP_IOEND_DONTCACHE) || bio->bi_status) {
 		if (bio_complete_in_task(bio))
 			return;
 	}
 
 	ioend->io_error = blk_status_to_errno(bio->bi_status);
-	if (ioend->io_error) {
-		iomap_fail_ioend_buffered(ioend);
-		return;
-	}
-
 	iomap_finish_ioend_buffered_write(ioend);
 }
 
-- 
2.47.3


