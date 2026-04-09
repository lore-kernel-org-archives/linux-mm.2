Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFED3F31E59
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5D7B6B009B; Thu,  9 Apr 2026 12:03:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D350F6B009D; Thu,  9 Apr 2026 12:03:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFCE66B009F; Thu,  9 Apr 2026 12:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACE5B6B009B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:03:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3F91113B163
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:03:54 +0000 (UTC)
X-FDA: 84639488388.17.5D77963
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 770901C0016
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:03:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=kQoYS4HS;
	spf=none (imf20.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775750632; a=rsa-sha256;
	cv=none;
	b=FgNonrIpPX3TDLeRFceQbhyOg0FovrFX5ztoAx0NNdW2FIX8p6G7hYoiputjKOQe9Qr2Mc
	kv4y1UO7xdjuvy+3slRSgt0H1NAszu8LVFoquAFTuJDd8OrPuZ/RXa3trmVQrhU/CUMwHg
	thH0R6ptRbBGeRl9KI1FDQuCvh1pZ3Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775750632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eEKUbIuo9fZAdJk1FYFd6tgmjZsDZNLvgGz2ue3oLuo=;
	b=o7aD/pYCCaG27N5COWjNuD/mKWM0+PWAOvuLmdS8c2RGBUQ++MRYlfmHQL0ixuYdMuV3HR
	xVq5EUygmZs+eDFdy9hFMTxIyuCNU5gU54H/NOo8APTU94pfdcyY4ghifA50LiXV5BmC9U
	PJ6ph1X33FVDg+r9tFguHB2epH+JxfY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=kQoYS4HS;
	spf=none (imf20.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eEKUbIuo9fZAdJk1FYFd6tgmjZsDZNLvgGz2ue3oLuo=; b=kQoYS4HSsLVIn50YskCEgjJ6Fq
	UptT2cEv16lB+JK6GOZtYAj5Ufg3eahSl0DZxC7yT1ImyJFBkgv9elt253UOegNBFx53xCBY2voCi
	HpGnEi5gn1QH/nOrPNt+4IzZzm4cYoUiCYhii8DsMGhSUt1mPxtBgUFmPSA2tsHaW6EtCNlFVndHO
	f6/mVlSPj7ztFSix2X/R/tNZbk786xJ6p1uztsQan47GDdqHouhWQ3JzSUWnvjRxSReax/sTl7mHn
	/kbfQ96fS+IeT6SL9cdrcbVEbwg89Jm/DmxSkqj1MhTB/XNCskKz6J+1VmGql6bth3QTiMgt+Hix3
	EXwSiS7Q==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArr9-0000000At7E-4A3r;
	Thu, 09 Apr 2026 16:03:48 +0000
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
Subject: [PATCH 6/8] iomap: use bio_complete_in_task for buffered read errors
Date: Thu,  9 Apr 2026 18:02:19 +0200
Message-ID: <20260409160243.1008358-7-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409160243.1008358-1-hch@lst.de>
References: <20260409160243.1008358-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 770901C0016
X-Stat-Signature: fhnduib9ayd4e8h9bse6kw1su38oaey5
X-HE-Tag: 1775750632-541003
X-HE-Meta: U2FsdGVkX19VH6dIzm38bawfwSfdDt8T2DvhQHwM8i86gs0xxOo/v0atD6QY4DAX5ppDdQRMIc62xFAugDs+Y2PbeJqd79AsNXb3dGdFUEob87eALJWuOtEkTB2KRvY1qBgdpKFdttxJAhpp5zs2VzpHsE+PD7RM30rQbHv+T3msqfGSDTouCwVXV3yMSTU6zbrhL410xYcIwK7syv8OpyW0FkVbbEQvjXyyj32uqk5G0YRC3aIe+sIu8Eyny+Vy1Q5GjSBfEyEyqavp88CtBWar/oX41WCjzxhP+vM3euMW+I4/JZoY3+BHQPZtpvlW9ACfmmgqj69YNKI7bMO9Ed9Xygy65+h0CmTCxfNluAzs5v1q1T+EoNfWk0AjLZQyZ5zH2bYyhfBupvImP4lp0YJkewUVLqyMfUDaI6ZN2cmGUtCLCMjfNmWQdxg5cJJ9lO+MVIwk5EWpHm2dHSEzEsuWW/QnIVRgFueqsiaz50p3kiekl7eVph+/64pWuHPVEDsXCuaE1arr3GVix4p240rnGJDkxD7E5za0APWbqjvgR8ok/a8Gpqn02FrcN82kKUmN0JieuYG0vdUJDxmVrjocp0oYsOk9uTMDcu33mhwMxrwDDtKJVwxFUW4TH8C+4MGr3ApNP4tmAqFoiqQSTkGGV+OnEqI1XL93WO6qXAGgR0UDqPMf9phjOIud4vrYOvF+ja82n8h2FTC+3P2YE51XTALs+10GbNLTlDYVBLn1Jc838Bi7WYwIOrrkr+jREihj5JBTTnf1m/yAJkApHtjUtmh6wgPf4zm203yMC3VIT4O9kwVOkjpyggImOK/Cq+J/2DkyJwI7VtSjgyVcI9Urdck+gEiZ6S4VGD6E8ZlQuLTo7TKeAhpBt29wfz8VH+ZojyEJz8Er6omdTV+jOjgqFzvwU5inub0nKWsuNxLaL0AoC4M4Y8R2NJ1GrQDCFHmbH2kwmG7B5Um/tpB
 Va6Pl8cZ
 TLt2hbNYLQ6jiStfl6Bk8L8odMiyM4GcSsiwl/Aaqi78KrfmSKOPm1c/B3bRtn5wFedLlIMg8S2FL4xB55GDp+cKw+EvQ+HTBUOneYvL3AaAbkQjoGqiggQsLtI/JP0MlscaHtLppzHlFCEM1dBgXRnSnfMapQWGKW9TzdS+t+SUYdzTzTy7JrhLHe/LvnRjL8699vIU7RO9yjn2TpZbTg7LGO2cCeCzP7TzxUINm0zPug+wWqgdBL/4Mc0WG/Peg82uoQ1HKJmm2he+wupUQZnC4o2YeGnzJhJzpGSvR9PXMCinTCHwwYYiKykYfnl1SyXnMVqB0q0HSwZQm/rGIYQiauuAyaEdNVb1DtJx6PsaP3OgDAiXPGczI1NWX6h84ryF8Qf80vJ6iit8I1kqiw+LDfK/yYQdCHeLg2yEqWQTgz374y1ZdRjWjq2Q8tNYmDI3mu2sbgVz78+UbSEI9y6cWBVPgYvgsBgnIGZ91nxyHynlNLPm7ZlICKAELtl+pO9vwOK7QDtaT9acVZWFjNzaC4joQ9aB1jr6jGAT93GoAvDsbET4uW+/jUiGLre5rHETVtQV8cyuZDW6Ko6SIqy0usZd5nUfTlgGiA6/tpcH/F3qSw58T1DUYevgNvHb7Cm0TBeE+UdEiMRg=
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
 fs/iomap/bio.c | 44 +-------------------------------------------
 1 file changed, 1 insertion(+), 43 deletions(-)

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 4504f4633f17..5b9b91198ec8 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -9,9 +9,6 @@
 #include "internal.h"
 #include "trace.h"
 
-static DEFINE_SPINLOCK(failed_read_lock);
-static struct bio_list failed_read_list = BIO_EMPTY_LIST;
-
 static u32 __iomap_read_end_io(struct bio *bio, int error)
 {
 	struct folio_iter fi;
@@ -27,49 +24,10 @@ static u32 __iomap_read_end_io(struct bio *bio, int error)
 	return folio_count;
 }
 
-static void
-iomap_fail_reads(
-	struct work_struct	*work)
-{
-	struct bio		*bio;
-	struct bio_list		tmp = BIO_EMPTY_LIST;
-	unsigned long		flags;
-
-	spin_lock_irqsave(&failed_read_lock, flags);
-	bio_list_merge_init(&tmp, &failed_read_list);
-	spin_unlock_irqrestore(&failed_read_lock, flags);
-
-	while ((bio = bio_list_pop(&tmp)) != NULL) {
-		__iomap_read_end_io(bio, blk_status_to_errno(bio->bi_status));
-		cond_resched();
-	}
-}
-
-static DECLARE_WORK(failed_read_work, iomap_fail_reads);
-
-static void iomap_fail_buffered_read(struct bio *bio)
-{
-	unsigned long flags;
-
-	/*
-	 * Bounce I/O errors to a workqueue to avoid nested i_lock acquisitions
-	 * in the fserror code.  The caller no longer owns the bio reference
-	 * after the spinlock drops.
-	 */
-	spin_lock_irqsave(&failed_read_lock, flags);
-	if (bio_list_empty(&failed_read_list))
-		WARN_ON_ONCE(!schedule_work(&failed_read_work));
-	bio_list_add(&failed_read_list, bio);
-	spin_unlock_irqrestore(&failed_read_lock, flags);
-}
-
 static void iomap_read_end_io(struct bio *bio)
 {
-	if (bio->bi_status) {
-		iomap_fail_buffered_read(bio);
+	if (bio->bi_status && bio_complete_in_task(bio))
 		return;
-	}
-
 	__iomap_read_end_io(bio, 0);
 }
 
-- 
2.47.3


