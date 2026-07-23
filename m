Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 957E5C4453E
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 05:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7073E6B00CA; Thu, 23 Jul 2026 01:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B7A16B00CC; Thu, 23 Jul 2026 01:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CDE66B00CD; Thu, 23 Jul 2026 01:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3493B6B00CA
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:47:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A15181603C6
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:47:02 +0000 (UTC)
X-FDA: 85018957884.08.8A023DD
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id B4186180005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:47:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DI6wpV8r;
	spf=none (imf24.hostedemail.com: domain of BATV+ab842403ba89e86779d5+8369+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+ab842403ba89e86779d5+8369+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784785620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcRYB9o1CpB5jJsRwr6821KrXtl1M65m2wTd3bP1/Cw=;
	b=NnTPQbw0uo1zzLlSbs6/Tp6gGaB/MuVhkNdzjEuvkF0TpnhXGriFy9p3Pw2viMWMg20GdB
	he8b9rhkSGc0YD/yMK+2CFIQgT1Cg2Hrqx6YfjHYBdaBNu1XRfK4xBx2qY8EAYq2oqTnqk
	f00bgqOdi27l/HvgxxTHfzs5pjkmxZk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DI6wpV8r;
	spf=none (imf24.hostedemail.com: domain of BATV+ab842403ba89e86779d5+8369+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+ab842403ba89e86779d5+8369+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784785620;
	b=8EgBu0N5zYGPPPdpHt6Tgv0Hnv19NKfSD3wo6iim/A6mllUlx1BxHxivEDQjDLr5ItoAtu
	nhqs1tBEb8dgGvEep4zyc6p6SgPAIGQM/Dr+bAAvtyZGo1luX+ZSiucIkc3EvcmFl6U5mC
	7LSzZSWz1ynRmibRoQHFd7GQU3QWwjc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pcRYB9o1CpB5jJsRwr6821KrXtl1M65m2wTd3bP1/Cw=; b=DI6wpV8rEtQVdeWHAke9bjq8wu
	wC0FuZ5lRLAB197Fqglgn5hrmJr7cs35jEo/78WySTb6bEB/SyGU4G6u1rvTxTzrwWX+AukskRf+U
	TuLlBHHb8QyRQBvtQfMqI1mNatec4DzqztCPfvjLAb8JTSDAdGV79JFAnVQAWGtxkPsEr10e6KArw
	nisHmsIa4OX29uUi8ylg2e5r97u312LxvkTAFV3QZoafJXof5R3o68YHVqWVsE21gHdEU0JJy8At3
	o65DkZOCBBJvHgTugEBft4iloJ6qxvVQT+syZ5ASbyxmwbO2fsClDsArCFt3/nX+g8TwsiAzn0xG7
	byqOLwJQ==;
Received: from 217-76-162-32.static.highway.a1.net ([217.76.162.32] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmmGg-0000000DV1N-3y5c;
	Thu, 23 Jul 2026 05:46:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	ryncsn@gmail.com,
	trondmy@kernel.org,
	anna@kernel.org,
	sfrench@samba.org,
	linux-mm@kvack.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: [PATCH 1/3] mm/swap: revert to single-folio writes for synchronous swap devices
Date: Thu, 23 Jul 2026 07:46:04 +0200
Message-ID: <20260723054622.3460249-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723054622.3460249-1-hch@lst.de>
References: <20260723054622.3460249-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: B4186180005
X-Rspam-User: 
X-Stat-Signature: spiut73ubgxkzb6gmipjhjtdmm1x1qpb
X-Rspamd-Server: rspam04
X-HE-Tag: 1784785620-790169
X-HE-Meta: U2FsdGVkX18/0WO5Wlf7yd42UR+jYQWrvJb5Qm8O8cRU0/E0QDUrrdcesRp8Zm/4KWjBIjh9zb1ypStCXEoUSwY8Qh4riTTJBhpUxNVyD84Y3p8s69hlCqCmaJxApIcyr7Ar0L5G1BS/plXCB9Lj6RngJ4seG8vtjaqhZOAAxW82eDNjj2zTChVXzLqTpQJQ0vdWgp13T/u/q/P5CAgXPL4obt7j6jCFqfGLqrZUvhQhM7Uhy3oxJpjyOtQnnydMXgsq8y5vZqzHuTCInmbM8BqAkK9YojJ8wAJrp2uumA4OuT9c1J6QjCL2gFGQXERBUp7HAEEc6aq0ShyZNgzK38SxsNQGZBGRkarmWxeFugKsGSAm9mfW0fiuVugbzBKkpEa9943BOl2csHqP1ca6STEro9vaIpqkgx9EbtXU9tJeX98wxTiehl1DQ3c0SRMSHKwPndhN4Ej3svS/+J0XmZAhTPbMFAXO8LRIdysnHiPERnyV4bMxg2IzzWn4dOt3eCoWXMut4ujEyxBSr5guwcAZ88CGQtH0shbZ8lhbfFoicvaTbDwatDlqEpjREEWXImaZkDoUaoN6jGvnaVJ9h0Ke1bNhmPXM69ckqmVAjFcFC9/Jkvmv0VWWqAtqbuuQNKk+p9G9TVyto5gk5CURysYLl0wOz/FrojeDBez4CvA6PqqAhgUJWHlqSv2Un8pH59InArkr6PBx7yahBlm0BxRUPkNVwT4AkXf9H84v7o8SI3nf35NaDHkAMhdBjeLGlxQrkj+/O7dakad+HJ1h+B3ik5QEK+HbJYjyrehEloLZFaTQgk16/qbGxALalzXwY3lIuUDIBY4yaoKppa6vkaaH9BoRqhLgQtXW6/3ym8VdvUVY0Osqm3CEsIcUwNhtCB2SupufdyY6LWf0ZeObGVNtO0JmD80SUxL9yTMPqITMMOvUidv9v0zNVtgDyURFabLZDuXVQEVI7T/I4vP
 YnAwjkMF
 WlUVge1gHF/Cxg/lzYgryvIshmUy4uuBRO4xTH3SFLITQZ//yjOHWet5IfUNcbfs9/nKu/4cIV3jgI9Wn1fX2myqNE2hsyY4yN6WbgGaqVUfGnz2vlbzQ/yBA8w759rmoZNEfXhr2MVMZhGEtmq7a973P8nec7xazDGdIpw25mS3fmeBRCIiFWnTy0V9ltNO1fguQIe7hSll4PRbYF+UtIsJWEJHbLYVtTCVSSqIbi6lwc+mPH+65sOsFGw09K9sVFgXbrqaTP5WNc0Qs2ZM0w6WgX+1frFWsJtFGv2uyEG6BASWWgrrFUUpUSkfxwKnUMcmsRa82NwjiE3Z0UK5RH5+XY08urLYUl2S48PNpk09IEkQqrzZwEMS0+3VNlW0PNxV9ohhTf94VRN/552h7J1ySYZcdoZhruY+Pfte/D6NAcKZqrgEnZTWj+A38ISBVuDtQ0VEWraA/jabn2F/FC2sGuAT3NG89csNFm3CRw2Lj7cW1q3+3Q/Ipsw8yiE7u1mUfaKhVRHE3XdI35JDEPnRyYg5LMgaRmQRRjAtLqLT/Qd3IYaisuB9CIWK8/t35+Dgya3OK72tu+kUBF9f7RxXvWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kairui Song reported that zram benefits from submitting each folio
directly instead of batching up I/O because the classic LRU scanning
benefits from clearing the folio writeback bit in the scan loop.

Accommodate that by kicking off writes for synchronous devices for
each iteration.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Chris Li <chrisl@kernel.org>
---
 mm/page_io.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index e4fa7ffffe8b..c984a4023a65 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -358,7 +358,16 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 	}
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
-	if (++sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
+
+	/*
+	 * Write out the iocb if we filled it, or if the device is synchronous.
+	 *
+	 * The latter is to work around expectations in the classic LRU code
+	 * which make synchronous clearing of the folio writeback flag in the
+	 * reclaim path beneficial.
+	 */
+	if (++sio->nr_bvecs == ARRAY_SIZE(sio->bvecs) ||
+	    (rw == WRITE && (sis->flags & SWP_SYNCHRONOUS_IO))) {
 		if (rw == WRITE)
 			swap_write_submit(ctx);
 		else
-- 
2.53.0


