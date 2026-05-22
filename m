Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6238CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 18:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C27C26B00A5; Fri, 22 May 2026 14:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1F56B00A6; Fri, 22 May 2026 14:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79E96B00A7; Fri, 22 May 2026 14:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9435D6B00A5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:21:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34A251C05F2
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:21:29 +0000 (UTC)
X-FDA: 84795873498.15.BAD469F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id DF548120008
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:21:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=edYPf9Rr;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779474087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zKLvy/XVT2bpLk4en4fS6J9Rd5aUoTUJe2g27vvq3tQ=;
	b=xdnVhCAJeVT9keKvrzoRBbjUeD+I9of2MakxB4mpNSZYjqdXR3OEkkgBINpbkqtBthsnbg
	c+cpJzOnACxNzMk4JwTDQFsucsynr1yxXmUusuBxyHOpI8oBw0pRguDAXiD/HBAlenCnpP
	SLiPlpvCQGgcwsFYT0NNQa0wziUBVP4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779474087; a=rsa-sha256;
	cv=none;
	b=7HDH2baGWmgZ2hBdyrpNOxqIb7B/Tk4qqOL4TlbTFP0uMPkLDeaq3KcWGKKQai2HEYiXYV
	G7sHMQXaWW4OnjGplBh5701km9zsRnb29plCwj8FYlLrSyGUbT5pUFQoFKTULogK9a3mrx
	YwRl7oKGNi7v5oAPNjce95lglwrp8qE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=edYPf9Rr;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=zKLvy/XVT2bpLk4en4fS6J9Rd5aUoTUJe2g27vvq3tQ=; b=edYPf9RrqDquidBWf3LrLjCWr8
	ohWh080hKEcac6vExpyKG6U5XH6P+E+dZdSgULWxD6I72OJhYutOSlbKYpTTFdLOR5mcLYHcY0IDU
	GNhkRn/4TYmnPQ1tKqvbP2Y4zrJrKYYyPxiA1RQ3umXuH/GiWVePTUZ9gqi79KgnEEdK4KyjN4pi7
	IifQXHjtqCfaWBQlFD+w2KDacSCmWUkpptnUzdCtQTIKxdT4aAeYbBwRl/6b+YTCKdjbuSUj26nAG
	fvkUYyPbSvmOppII2AVGbp6zwYaJ5jteoiqs7qpS9un1v4oBxS9mmFOtOYSb3V769RRasMtXbdScu
	1m/BTF6w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQUUu-0000000ARbe-2m3r;
	Fri, 22 May 2026 18:21:24 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-mm@kvack.org,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH] block: Add bvec_folio()
Date: Fri, 22 May 2026 19:21:20 +0100
Message-ID: <20260522182122.2489391-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: ey1qafoff6tm664ohbbgbj49co1tyx5k
X-Rspamd-Queue-Id: DF548120008
X-Rspam-User: 
X-HE-Tag: 1779474086-872045
X-HE-Meta: U2FsdGVkX1/n8A5/38NkzSxgTVM4X3TIlGfdk44E2EU0kAgkTT39d21unF/y9iU3Ma2gFKOl2LXXHWQ+PAaB23NtgeFeI1c75Ytw6SIlLjRdwcLFc9kyYaJwIqkDj1yNAmceR8zCWTnrMod22WVeq9rVZpqJWdQVC8qTs09+QNDor+RlTThSYvhFh+kptQwsMDubTbNspalUVp+ijjxm0LxC15vKsBTqnucfdUfqQxL3Q7M90CLePcca+cq93L8lpsQF7vvpu1IgKHq33v3ILdy3YFkDYO66AdkLkgQ2Xo+xBIl7sAREYcKqw8rJMF8fF/5vhK0ZDfxrxEBzoRbTiKt0PtcjtphN204k5xzznObg9GX6duDsqUox7Rbu/RczEdQvDC6z9dMx8C7F5m6jyGUfefWqSdud0c3Syd7VDnFIT4SLwnIYKC9HqpZkCPgyypbDl4aT4xE2KmHBt149EB2MeTRPO1Y3nIlQM9aRkQ9wuImlg0G3fe0wfaZgpU+LGLllajmIuoaJihwXEpNQHB8yR3ah9q0XYjlMWQi0vHF22nbrBar7CzyxbwHO5Op3m2CaNy/vg/N5GTFAl24JwzwUTwf7Tg8VRDGL1aEMS70tv8IW/GPY0cvz/5vhWM/exF1puR2r7/0tEdPw+L5nADeQ8ua81pi8ORZtbhpvm+LIGnQXVbThwlkqHOfqmeyvcTipWr64mz7FN0tcO341br1/RfDLxQASEcdfDf7YBv9Mdc5KI32L1q1QUHk22x7E69TVauo5mwZSWS+fXP1cjd5PTbfsGwcxdOzsy3tkAs0+Syj3UZ/LlSQnTyC+jyNgco40Hh4IvzTrMxekX1QqDsgGvwZVqjWAARnyFIYC4D1qnGH92tYU99pI1zkaCPW6YeD9VcXv+utm9lz3qMgUgOizATZ6cc7yEY0wNjUPGValXLWb5cO9sWN46lCDdiLpWQc2W1ia8iEHdvVvnGP
 b45LWMB1
 RJ9RhVZpPpp4DLa3iAaKs9LTAe04v0EeCOWcsEKvGZREt7RP+aixUz308ABaX80eLNTPEOiy9z4yiqL03PEWQMUhPDf21wCJFVALOX8zJvcntP3O2PNJYb1Nh6aGltARgt7o0T3DokIwDpGDmRG5dGTel22Q0fojKNvL3i6DnRbDJ9V2lbkBXH7Y43ZsZvfhak2phCe1p8DK0gpj0vKRhOiTBuArvRxofgDSbaDaAveVV4yCKXSmvJP+bFhT1W+BZ691J6W5ZIfJo6j3UsEmgvpH7glowOAooAKY6o5kjjur/5epj70EqJgF35ofWkCjCAcZUKZ/OiYSV0eXkTUJgcdJFZjWR1uLNEItN+AA8SWejQxw=
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

Hi Jens,

I have a pile of other patches which depend on this one, but they're
spread all over the kernel and don't really have anything in common
with each other.  Getting this in the next merge window will let me send
those patches next cycle.

 block/bio.c          |  6 +++---
 include/linux/bio.h  |  2 +-
 include/linux/bvec.h | 13 +++++++++++++
 io_uring/rsrc.c      |  2 +-
 mm/page_io.c         |  4 ++--
 5 files changed, 20 insertions(+), 7 deletions(-)

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
index d36dd476feda..32846079b853 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -74,6 +74,19 @@ static inline void bvec_set_virt(struct bio_vec *bv, void *vaddr,
 	bvec_set_page(bv, virt_to_page(vaddr), len, offset_in_page(vaddr));
 }
 
+/**
+ * bvec_folio - Return the first folio referenced by this bvec
+ * @bv: bvec to access
+ *
+ * bvecs can span multiple folios.  Unless you know that this
+ * bvec does not, you may be better off using something like
+ * bio_for_each_folio_all() which iterates over all folios.
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


