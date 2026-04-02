Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B1D3CC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816046B0088; Thu,  2 Apr 2026 02:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79F836B0089; Thu,  2 Apr 2026 02:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E126B008A; Thu,  2 Apr 2026 02:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 570186B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:12:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B53A08BB44
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:12:10 +0000 (UTC)
X-FDA: 84612595620.08.384AF46
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id ED1D740011
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:12:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=guOJlTQ6;
	spf=pass (imf07.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775110329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UPdVRThctx1We1OWKVI8BrURZZc0r/13gnupvF6n6rY=;
	b=JfWVigb/DrpaDtbQePETMUxwTcLvalI26ZglFIpeO/mBJkAJUXhZbOosBMxK83NrplA1ZG
	Lzkp28KafMo+uIxMGl9vUIZ4Gh+POEfSWq66JNhnaWUGYi5ka2dvtJfqz8A5+bS7KtI2iX
	Z0lvV7NnU4ZW7jKxWC3C6TEWPqZIIjc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=guOJlTQ6;
	spf=pass (imf07.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775110329; a=rsa-sha256;
	cv=none;
	b=a2XaVJSxkwclK4TmrZCUoybRDvd0koziyj4SCqWjqlwq+6J2fNpcI7x/ybBxUlvKLEWc6s
	NsyiK0UDYLEHsSQfr4jDMv2OfylzTPzPAo438B9assWwWAsPqz8Y25+pdeetdO5laxGSl3
	WBGJp22zOkkRkBuheBvalkf5cdLC61Y=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48541edecf9so5448995e9.1
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 23:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775110327; x=1775715127; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UPdVRThctx1We1OWKVI8BrURZZc0r/13gnupvF6n6rY=;
        b=guOJlTQ6hLeCsDYuzV9CioeRdmv6VhkN40blQvjRnMk1tBoO4ZiQ5uy3+SiahSNlOG
         9iwCIIvE6w4Gye7/WrHhe/I5Mfab//0wm35QJBxvZ5eVRTd9TigQPfRYcir9JldHlOUn
         s1nNQBgUlOqknNhnuZ5yYIX1karNYIcLgQdggEYAw1B2SgiFEpaJWuyIaE0OS3jNDvqH
         PjPxwuriVsjlYyDy/3IGz7DErhpZG4egaqz9u/Do+iMJGiVz23IcjdjtBv3EzhVh+I+A
         aijHpw87Sm0lCFmHUMQhH6sjt4IaKftqvavLPOBI1+alHYKAAMOrJrNgLVk1V+MdTSdA
         faBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775110327; x=1775715127;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UPdVRThctx1We1OWKVI8BrURZZc0r/13gnupvF6n6rY=;
        b=qtHMYOprCCzwtHuCA+c7pan5DAwgY7L8pDGRCu6sm3G0uAMlG4HiGsaStr+cTfwMZJ
         KScqEvNngTlkjCZYr5mAVafXpK4BL7znvJIoyt0Xfdf6zozCb/qu7cx3FEc3swdjN5Rr
         JdT1Pg/bH6FRwNzTKccGdfAJ76E1OaeBXxN7gqdohplvLiCDmUZsKE5IEqQJSCWerDtp
         ZkBi42Fg9mJnkpgLG/M40d2a5GeZp4TT2cZynnqcPdJq2xrLgZFtsay7BZfAG/aak9w/
         prTECN2dmfGqq7OXKMUH4v/dwBhmrCHSStpcZI+lDwooDfpX2iOrHmBtPapEJqeL5WYJ
         3W7A==
X-Forwarded-Encrypted: i=1; AJvYcCWWs4Y7dqqexpFHqxvp/Nr7ZpCI0GseYzccqdE0hWIO0TCakReuu3oRkZf+gHXNOwa0jPIT63piUQ==@kvack.org
X-Gm-Message-State: AOJu0Yx/vffYwtWjMYKHDay3rRhCdHtL2frWkTwy5WNZiYUobFuaNPNV
	FERKDjQZwy/j8Zr0MHQNX0hRoLSIyasMRmiUkTnFa0r+C9C8YbJGWRDI
X-Gm-Gg: ATEYQzx1E9YbaYUg/w4ooWYSyyIS25KN38FkHBAr65q1w/oNNjWmSJ4Ut0HKUvpjdt1
	sJvok2n1G23+7lUD3CR5opLU9i8jMFAafMXVRDHjlzIVHf0+uvlkIpS2+0LgTf7HY9ZmgzcR1QU
	A0CPBt+zBbFw2VsUxE1ry9DQ0H3EokrXUuTu+1I6Li2u87QfkgWBytVgK2b/yBe7/GLDZrLqvZL
	NrMQIhdKEDgpzzEy5chLEIrFhgjebPTSEJRSEAS4IpurLSGhbqDV6XDbSFGqMxAtaEQj+wMUo46
	g7GQg7bC/erlcJGaRgEXNJG7QoY3z6wRwO+37u0OqxBSbQqV4fCb5xfoVCXdBa66dMUw9vgH4xW
	7hETewsctP8bzjR4NGGRzTv3AwJG5EqEIv3idGQOADKoSqyARQEFclU/h0qyrO2cuMnFiAfvxIU
	3ySJO6yBPzynv8YZXp2YckZxdETLaSPQm9QAAKJGhWKZRmCgvAm7GjQSGFZ5K1wGBDq2hJ5zXib
	amPzJdQ/pMu
X-Received: by 2002:a05:600c:858e:b0:487:1520:d107 with SMTP id 5b1f17b1804b1-488835cce64mr88940365e9.31.1775110327081;
        Wed, 01 Apr 2026 23:12:07 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4888a706062sm52452115e9.9.2026.04.01.23.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 23:12:06 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Youngjun Park <youngjun.park@lge.com>,
	NeilBrown <neil@brown.name>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	David Carlier <devnexen@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH v4] mm/page_io: rename swap_iocb->pages to swap_iocb->bvecs
Date: Thu,  2 Apr 2026 07:12:02 +0100
Message-ID: <20260402061202.35097-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9a6k8h44hcuyrocubab7hxk41ka7baw9
X-Rspamd-Queue-Id: ED1D740011
X-Rspamd-Server: rspam09
X-HE-Tag: 1775110328-598467
X-HE-Meta: U2FsdGVkX196r9LaxkXLVhUbOMqWXPN3BRI+mrtMS/maOyC4tnHH7unQhnvmXGrXrCahPDgHRyZ8CjVlzD7nyctUeUz4YtXjz5faCNoeyCDb8OgZ/OVCxf/5TReeuEbGOF2yb6A9J4/ONJGg0LuUN71Kvn7d4kKJo4uKEJ2sXG8ygNICdKIwZ1HKsIuJiIVYbaahOst1QkQv5gtTUcdfStuj94zLplht+8Eu13e/PRDurYX8DuaRw19i7A3puTT6nsGtj24hATn3kJXx7sXU1dC4AXvc3HODJGGIsetwoZS3cPKVWMUU8coBJkSW6CasX6PDBGBHQpc9qjeI6EmW0VA5rATiTvFdQ38XodPnhSu1Lqmiv/STESBs/ZAkDXyWwxoM7ru+XzI9JsaTaK1TR/E1pFDGmuQK3fPOczO3fVcOnjwaMI5t/SPe2Yl14+kyZHgrIWcW+jVYn0G2uFB7ObyNUe9Gq8LIty7ZetBbzBvilld+Cw8tUxo7X2fO/YX/dx6ANoZbbKotd4YRL6/noKXtkLQJsk3KsKQ/aam9qa5/ecpN65zN1ccZDukab5REokVNooV1A1vVJzJ7hBrh89AcnXWrB57p74tbbnWI0OT9LCK5fsLWba2+3wjGoGz9DAf6UMWP5HB1uLlmKV/mHa1R4q0mdp0dQnni45BjL8SojHqnfBLWJtekfQ7mBslvtIil6fTV5rFdV+9QBLYIOLZiaznyXxrk5Hu6GoiixEN25RmcF5x0s/LngZRi4cJmu27f6aZ1P8WBJwvT6REDjD/bBkMQ9jy8IVMln0WJ+AhQpAOPEhXoA8wC84dmsTy0zbC+lKY7BtBe2v/HD3qKcSTiUTo21N9y/d4d0KYLFucD1IVtv7FS7pzKFJHDaOFe12BmRhybG7zdpD//V7q6gbiVot2BT3L9KFIUAFoYGBLydrjxcUdawFpOPsl+qoErtvonyP0wp/KfrL3NWiT
 llJs1jCx
 WTB91pRvRnNXIjiHUw3heNKoQUIaF3SHlYjQFnEm5B76j+pL7ZIgEULsFPpw5gckmNA/HEW64Ei8hl7GYFhSRw6+G67Pym/c4/8GIel1t4BOfRqh7Rc6aLmQy4x9N5ZzqCuwn8u3JiDuC1bFkLCwxXNQSF52IuAzP75QHFi+x5oaXJNkUbjvz2FHB1D9ER1aUm84uOYW75x/TSpnpwPeRpXZ3tnTHTHmHVXPI4/+bhZz3HSQoHKjwkcKsMrwReRuj4gKSBb+4m4nwkGk2vdGTtfLA4kQHmTzyPYx7MXZ3RJTfhLBSafK5ZpY+jBKS5+NZEBvGThANG8iAJsYsP6yKTqQxxctUVD88I/EBBneJNq9jRy+IyqMBQsqt9iUeUp0xJ0OFcz4FujT4tU48PFCzdjW15h4rbadrVLKMwGWNhPAJepyNXs+qomkqhqHpiFHDRAVjNuar6RLAfpng0mH4+Ue3R2Rq+i7jN/zYnFr0xK3QG69d4FGPTPIMrIvSFFLdMDTAI11/ef67omxce1GBhBQtH5dL9g+DeRyOmztyIiWR7YX4EXb+GvqzAnGrm+TV10ZBqaYqhqBiStASgjeRhD4jb8+Pzk9j1T7D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swap_iocb->pages tracks the number of bvec entries (folios), not base
pages. Rename it to bvecs to accurately reflect its purpose.

Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: David Carlier <devnexen@gmail.com>
---
v4: renamed swap_iocb->pages to ->bvecs (Willy)                                                                                                                       
v3: use sio->len for PSWPIN accounting                                                                                                                                
v2: convert sio_write_complete() to folio APIs
 mm/page_io.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 1389cd57ca88..e524cb821d04 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -327,7 +327,7 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 struct swap_iocb {
 	struct kiocb		iocb;
 	struct bio_vec		bvec[SWAP_CLUSTER_MAX];
-	int			pages;
+	int			bvecs;
 	int			len;
 };
 static mempool_t *sio_pool;
@@ -362,14 +362,14 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
 				   ret, swap_dev_pos(page_swap_entry(page)));
-		for (p = 0; p < sio->pages; p++) {
+		for (p = 0; p < sio->bvecs; p++) {
 			page = sio->bvec[p].bv_page;
 			set_page_dirty(page);
 			ClearPageReclaim(page);
 		}
 	}
 
-	for (p = 0; p < sio->pages; p++)
+	for (p = 0; p < sio->bvecs; p++)
 		end_page_writeback(sio->bvec[p].bv_page);
 
 	mempool_free(sio, sio_pool);
@@ -397,13 +397,13 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
 		init_sync_kiocb(&sio->iocb, swap_file);
 		sio->iocb.ki_complete = sio_write_complete;
 		sio->iocb.ki_pos = pos;
-		sio->pages = 0;
+		sio->bvecs = 0;
 		sio->len = 0;
 	}
-	bvec_set_folio(&sio->bvec[sio->pages], folio, folio_size(folio), 0);
+	bvec_set_folio(&sio->bvec[sio->bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
-	sio->pages += 1;
-	if (sio->pages == ARRAY_SIZE(sio->bvec) || !swap_plug) {
+	sio->bvecs += 1;
+	if (sio->bvecs == ARRAY_SIZE(sio->bvec) || !swap_plug) {
 		swap_write_unplug(sio);
 		sio = NULL;
 	}
@@ -477,7 +477,7 @@ void swap_write_unplug(struct swap_iocb *sio)
 	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
 	int ret;
 
-	iov_iter_bvec(&from, ITER_SOURCE, sio->bvec, sio->pages, sio->len);
+	iov_iter_bvec(&from, ITER_SOURCE, sio->bvec, sio->bvecs, sio->len);
 	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
 	if (ret != -EIOCBQUEUED)
 		sio_write_complete(&sio->iocb, ret);
@@ -489,7 +489,7 @@ static void sio_read_complete(struct kiocb *iocb, long ret)
 	int p;
 
 	if (ret == sio->len) {
-		for (p = 0; p < sio->pages; p++) {
+		for (p = 0; p < sio->bvecs; p++) {
 			struct folio *folio = page_folio(sio->bvec[p].bv_page);
 
 			count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
@@ -499,7 +499,7 @@ static void sio_read_complete(struct kiocb *iocb, long ret)
 		}
 		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
 	} else {
-		for (p = 0; p < sio->pages; p++) {
+		for (p = 0; p < sio->bvecs; p++) {
 			struct folio *folio = page_folio(sio->bvec[p].bv_page);
 
 			folio_unlock(folio);
@@ -559,13 +559,13 @@ static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
 		init_sync_kiocb(&sio->iocb, sis->swap_file);
 		sio->iocb.ki_pos = pos;
 		sio->iocb.ki_complete = sio_read_complete;
-		sio->pages = 0;
+		sio->bvecs = 0;
 		sio->len = 0;
 	}
-	bvec_set_folio(&sio->bvec[sio->pages], folio, folio_size(folio), 0);
+	bvec_set_folio(&sio->bvec[sio->bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
-	sio->pages += 1;
-	if (sio->pages == ARRAY_SIZE(sio->bvec) || !plug) {
+	sio->bvecs += 1;
+	if (sio->bvecs == ARRAY_SIZE(sio->bvec) || !plug) {
 		swap_read_unplug(sio);
 		sio = NULL;
 	}
@@ -666,7 +666,7 @@ void __swap_read_unplug(struct swap_iocb *sio)
 	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
 	int ret;
 
-	iov_iter_bvec(&from, ITER_DEST, sio->bvec, sio->pages, sio->len);
+	iov_iter_bvec(&from, ITER_DEST, sio->bvec, sio->bvecs, sio->len);
 	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
 	if (ret != -EIOCBQUEUED)
 		sio_read_complete(&sio->iocb, ret);
-- 
2.53.0


