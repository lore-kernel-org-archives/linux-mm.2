Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CDAECD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 17:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B438D6B008C; Thu, 28 May 2026 13:59:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3F66B0092; Thu, 28 May 2026 13:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09E66B0093; Thu, 28 May 2026 13:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8EB176B008C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:59:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26E66C2CEE
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:59:17 +0000 (UTC)
X-FDA: 84817590354.09.92065BC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 96C1F40006
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:59:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LxLOs6Ov;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779991155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=00eqepaCtdAWu+DT6W6K8Woolj1q8dfZ4GLsgZojTfU=;
	b=OGj9+UGvBOx3aqnyLD+Obnm6EKnN3yuADUxZHaVK//W0nopLuVjIw07UjsleljELISrsFo
	WcD641feWvD9zs7JC514NC3dq0/owy26uMp4uOM7KjQ/4GzSz7ANVHZ8LRwiTzX4S4RgOd
	cLU8TVTizvhAoFN8u9+LaO3ZG4Sn7MU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LxLOs6Ov;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779991155; a=rsa-sha256;
	cv=none;
	b=se4g0neHDNzH6JOc06yJ1fdPmCWo0XyqcFc4abJX5dCswuFjWy1EvCTm6Z9hZ5q+3WFWAv
	SsZmafqR/cTMlK4SWij3dGAYPZn9JASuKepfc309As6ga2tu1K7ShHlSZjS36B8XVslHXE
	454Dx/f3im+Cm84WZUHXPusLRI3f6k0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=00eqepaCtdAWu+DT6W6K8Woolj1q8dfZ4GLsgZojTfU=; b=LxLOs6Ov5lZ1U5Xru94afj9U9t
	PJL/TdKDYOWmG/W183u33w3lX2ScLoLLWmYvgRywVOH7ba+BYVC/K3wV4aME5maSdLI3puQCo0n/u
	npWsniY14pov3dOUQuhEU+7dEY8RgL+hTxmseN4qNOsjMfY4ZiHEQr4dSYi2kcbE2DbamsS88ptkZ
	HJOAw+ReE+LcCye1BMN2T5ZYVqsTsftZ6EMmMdcSRrYJHoC8PPlylMxT9wgT2qOtV1Z9S6i72ds+s
	1zm4CaNYV9URu7imarFFRFQPtyWp5DXpz71Ueb5+ERrYUkuaEX4q/QzHJnpC6nwo34LWrWlHbmfW8
	SAkN2pDg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSf0d-00000004clb-2Ub7;
	Thu, 28 May 2026 17:59:07 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-mm@kvack.org,
	Leon Romanovsky <leon@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 1/2] block: Add bvec_folio()
Date: Thu, 28 May 2026 18:59:03 +0100
Message-ID: <20260528175905.1102280-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528175905.1102280-1-willy@infradead.org>
References: <20260528175905.1102280-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 96C1F40006
X-Stat-Signature: 3a5ykczk4nfa5k7xey9f1s41amzunyrf
X-HE-Tag: 1779991155-821094
X-HE-Meta: U2FsdGVkX19ZiiS5w3tYD6VvsarR+g0mT00ltBMZv5eVbJxnYHpjeU4dx2I43RueSnfgyVxiQeWxRgD0/OcWPudAyXShpAA9K2TkPf+N1ua8TbsDzkR2bZkPyeJU/1udqzQg6wA/QbUjw01Loto7Iv6C2QR26PK9dj6rKVqZLnX2i0BfsN7l1U4QSqeGo5gwpOrYHKdcyd4ZPpUUXKGfWQFRgWCGeIJXJ6rGUjA0jMj/yP2zaQSTGZxPHcW5LTxEGYknvhgQH60lahmS5FGbQx3jr7/p/EU6LUvcyOtnwPa3Exez/ENW8ZqJcgui4muZiw9BlSFhWTVzGq3vcruDvhP569C7vyLU7xLG86aYBbWIBIk2hn1YkR3tCnaplgfzVAmeVRTf26YueZajTfH//xWiSCTWIAMnxyvxHSNOblI2nkY7Tx34b+VJN/7wqTRTw0QkhbLPcRPO4EOsQIDrbugNVCBBRBXIOVTtMah3iwDQO3lnpJ347LbFClnpcQ89EP5ncwwVIbqifB8fUPXhPgtMhlTuZE3lPpDN61ku3iKgBjtMfR82cee0UJRgabJbBjCNNR33Q4IuzD95omHmEblHA7OFSb5u07xJtELTd8q15+uMwfXKF+0orE7q7dXdDZiavMaZ/WgnOCcW5xdWhPOU+bBFpzMJ1re6s+vQesCNpclel5ID2LlmxXKyB3s4jd4ARHq9u7tW9tBuaDYjHctu/Qs80pMAY+IyHNyIWt/7KO8aj28uLmDAhIZdYOxB1AsSwiDp7TKruZZxhf7lOn+ruTWLZWVIi/Q9i7V5GWEs0cM5UwlmB74scQjAxbeMr3Z8bjv1VNSPVhtVAonGlzuNAoCPPIg/KWmsevVeuash8bEdgUQpfiarsk4o17X2EndgQ/nFuLTdWFMqUrv5q3uAMB89fZP6oV9JS2e+ZHsv4zahpaDQ2wNvipGaOeNFrpcp1wlCAKnUm7pbIp7
 XexkZyke
 JyM0MQgcZoxG5upLxgQwXTodTK47T8XtNMYvvhEaO12AOOKnGn4FxpGvrsq3U8yqghZxECPqBWrpSnr0cadm26F2TQJIgDy68pYQcw7yW/RNCrukkl2SNP2VVcf7DLXMAHmDAGGXha0ZTe8eHWtskRke6V69tuRxqsdatKlGz22NS7BDf4PfVOoVtN5ldAWF5DyY5a6H17HvLLT1xPNYBsqCQqvVlhFlhh5IgI7WOv+4/IShHKxQKJDT9sLRNzSktH0zSp3lEUeL0Ufqi07KYoJH/MWuj6mT+NCKc0uir6zhIrb8rZz2HvK4E6+H+EzOGnc4rntn4QHQNYJVBDLzUiZlURHa68PI48Rr9OVJsKBRhVk8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a simple helper which replaces page_folio(bvec->bv_page).
Minor improvement in readability, but the real motivation is to reduce
the number of references to bvec->bv_page so that it can be changed
with less work.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Leon Romanovsky <leon@kernel.org>
---
 block/bio.c          |  6 +++---
 include/linux/bio.h  |  2 +-
 include/linux/bvec.h | 15 +++++++++++++++
 io_uring/rsrc.c      |  2 +-
 mm/page_io.c         |  4 ++--
 5 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 5f10900b3f42..85aab3140909 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1300,7 +1300,7 @@ static void bio_free_folios(struct bio *bio)
 	int i;
 
 	bio_for_each_bvec_all(bv, bio, i) {
-		struct folio *folio = page_folio(bv->bv_page);
+		struct folio *folio = bvec_folio(bv);
 
 		if (!is_zero_folio(folio))
 			folio_put(folio);
@@ -1409,7 +1409,7 @@ int bio_iov_iter_bounce(struct bio *bio, struct iov_iter *iter, size_t maxlen,
 
 static void bvec_unpin(struct bio_vec *bv, bool mark_dirty)
 {
-	struct folio *folio = page_folio(bv->bv_page);
+	struct folio *folio = bvec_folio(bv);
 	size_t nr_pages = (bv->bv_offset + bv->bv_len - 1) / PAGE_SIZE -
 			bv->bv_offset / PAGE_SIZE + 1;
 
@@ -1443,7 +1443,7 @@ static void bio_iov_iter_unbounce_read(struct bio *bio, bool is_error,
 			bvec_unpin(&bio->bi_io_vec[1 + i], mark_dirty);
 	}
 
-	folio_put(page_folio(bio->bi_io_vec[0].bv_page));
+	folio_put(bvec_folio(&bio->bi_io_vec[0]));
 }
 
 /**
diff --git a/include/linux/bio.h b/include/linux/bio.h
index dc17780d6c1e..6613ab4519bd 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -283,7 +283,7 @@ static inline void bio_first_folio(struct folio_iter *fi, struct bio *bio,
 		return;
 	}
 
-	fi->folio = page_folio(bvec->bv_page);
+	fi->folio = bvec_folio(bvec);
 	fi->offset = bvec->bv_offset +
 			PAGE_SIZE * folio_page_idx(fi->folio, bvec->bv_page);
 	fi->_seg_count = bvec->bv_len;
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index d36dd476feda..27ac3fcc6d9e 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -74,6 +74,21 @@ static inline void bvec_set_virt(struct bio_vec *bv, void *vaddr,
 	bvec_set_page(bv, virt_to_page(vaddr), len, offset_in_page(vaddr));
 }
 
+/**
+ * bvec_folio - Return the first folio referenced by this bvec
+ * @bv: bvec to access
+ *
+ * A bvec can contain non-folio memory, so this should only be called by
+ * the creator of the bvec; drivers have no business looking at the owner
+ * of the memory.  It may not even be the right interface for the caller
+ * to use as a bvec can span multiple folios.  You may be better off using
+ * something like bio_for_each_folio_all() which iterates over all folios.
+ */
+static inline struct folio *bvec_folio(const struct bio_vec *bv)
+{
+	return page_folio(bv->bv_page);
+}
+
 struct bvec_iter {
 	/*
 	 * Current device address in 512 byte sectors. Only updated by the bio
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 650303626be6..5d792f70ec1e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -102,7 +102,7 @@ static void io_release_ubuf(void *priv)
 	unsigned int i;
 
 	for (i = 0; i < imu->nr_bvecs; i++) {
-		struct folio *folio = page_folio(imu->bvec[i].bv_page);
+		struct folio *folio = bvec_folio(&imu->bvec[i]);
 
 		unpin_user_folio(folio, 1);
 	}
diff --git a/mm/page_io.c b/mm/page_io.c
index 70cea9e24d2f..a59b73f8bdd9 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -490,7 +490,7 @@ static void sio_read_complete(struct kiocb *iocb, long ret)
 
 	if (ret == sio->len) {
 		for (p = 0; p < sio->pages; p++) {
-			struct folio *folio = page_folio(sio->bvec[p].bv_page);
+			struct folio *folio = bvec_folio(&sio->bvec[p]);
 
 			count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
 			count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
@@ -500,7 +500,7 @@ static void sio_read_complete(struct kiocb *iocb, long ret)
 		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
 	} else {
 		for (p = 0; p < sio->pages; p++) {
-			struct folio *folio = page_folio(sio->bvec[p].bv_page);
+			struct folio *folio = bvec_folio(&sio->bvec[p]);
 
 			folio_unlock(folio);
 		}
-- 
2.47.3


