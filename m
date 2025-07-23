Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 927EEC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D818B6B009F; Wed, 23 Jul 2025 06:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4C26B00A1; Wed, 23 Jul 2025 06:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0F146B00A2; Wed, 23 Jul 2025 06:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9949A6B009F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:19:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56F5F140651
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:19:45 +0000 (UTC)
X-FDA: 83695133130.05.016FDB4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id DE6EDC0006
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:19:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=cvVJ+cjO;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf28.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753265983; a=rsa-sha256;
	cv=none;
	b=DMJrtvkezQ79hgh/rMyRWFsZbmKeiSE6zEhPRoIcbNUB0Hvr7B2n5RXSZH9IHQGf4eQn74
	C9B9YQF6rkOJ5dEbohhEdiZv3ZsaexLEUHap5IKCxgGt60r2sZOYz6W9jt8KzRR4aq71nm
	5mmxxwGW7tov4KOkHmyJhH82ghjlva4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=cvVJ+cjO;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf28.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=chizhiling@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753265983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udCM1lsYiKDqT/YgXrbnqPpuwPrKh4p4pm/0FsOfkOQ=;
	b=szi6t4zx4OwiRUYwYPm02kDEGG0USRP4+0jTbswAc3TuPA3zKyVKtmS/4SlLdxgLuLyuf7
	Nboq6d7ENJoDWNhqyQQzJjPFyTgEHvU7bBHne6HaCB9WgOV/LK3T1NUOCucLqIcOTPmos9
	gRXJUy5BqLuR7MOupsnTyv3QAl2J1s4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=ud
	CM1lsYiKDqT/YgXrbnqPpuwPrKh4p4pm/0FsOfkOQ=; b=cvVJ+cjO79ogm1pZIH
	FG4mYvRNpETiEHgDuyk/LeM4xumeFz9Vz4d3oyotark5XFrNNLErXOoS4Kmzh59+
	+mfZy0k6E6j3fURxJDbXPvSUJEcWXHOP6na0O6o5ZnGeQ69GGUNUIoBLMvSWthWf
	hXcc0p4TZFImJ9s3HX/qe7roc=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDXpNEAt4BoaJF8HA--.11729S4;
	Wed, 23 Jul 2025 18:18:41 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: akpm@linux-foundation.org,
	willy@infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [RFC PATCH 2/3] mm/filemap: Avoid modifying iocb->ki_flags for AIO in filemap_get_pages()
Date: Wed, 23 Jul 2025 18:18:24 +0800
Message-ID: <20250723101825.607184-3-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250723101825.607184-1-chizhiling@163.com>
References: <20250723101825.607184-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXpNEAt4BoaJF8HA--.11729S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxZw17Cr17GFyDZw48WryxAFb_yoW5Gr1fpF
	WrGas5KayxXFy29rWfJasrua15WF18J3yayFy3Ka17Z3Z8tr95KF4SkFy8KF43AryrJF12
	qF18tayUCFWjvrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jFOJnUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiTwyTnWiArAz2oQAAsS
X-Rspamd-Queue-Id: DE6EDC0006
X-Stat-Signature: bro3xwkqdkk3f7wuood95dqd7kgakk4u
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753265982-289864
X-HE-Meta: U2FsdGVkX1+T2UkDOLNr5i3mwbbwG8UYjQ/HmRIZbRyyr3aKoXQur+hsZMqsII5yUT5tWKhlUHlsnHWvZgWsjp0E57LvgdFHl6acMFnZyZfUkdMLLCiZeWgnU+scBOHrCkLw+IDea6oqEK+0Cv+ALpXRtG1YSKnOXOes9v/AdXN7wbuXlDWXukxkD8lwO3vM/PzA/4xxI7p6clngfUcJDkUX0uAcpGGUd+amlrEli+Ca26gvY0J33/nwGS7CPKE+awqKqSV0rV7CliCt+fsV7a4Nlz+Hp9fQni62eHwUGODvEXGRGlRNRjcD9M7NxxO/qnl3dWHJFp/w2NGJm9/DinXdN++DHQURGWw+TPnnGrdXsb38ciZLBXZ6eWfW007cu1n44EkhkysRTwPtQ7yAqmaHy9hSAR7gXbUsxXIkBhw5WC4E84HujCevnLXdU4l39B9gleExyjskOGEuBkn+OU71YG8VVJkTuEcld6tUovtG0e79vj6moFOoOIvyOQuDlV5HdiTaMX7r5XdIxf6SD5zvJsHRKxHoh6hhrIZ8rRBnyXXImeF7oLZ/vRKQ5vgm2BM9brO+3GjEs6QtPq+RpOI48o8JtZyMvoPjMY/EC5Ju/KM7eJd11zt5acl28flg2BOP1csw2z6N95BFv+Umt8VEWczFWSFI0Ybg/16st2IRwY+4mr6H+TJPKEZ3tpcyqxS7qsGQYZiFgyl77lwdH/zejbKA3vbffT+Xt8EIzq1EzclBJ9qXcFCCJz9AeSmknI/INtgHCgJFLEthSzi9OoRh6LxJp1A7gBasJSovTcJlzAjMDzeFHWX0ho21I6Nygzvj9uipaAqQJidy+pZznabu16BNzt7qKGNmKSOENIQjXPjnY0cxGS2YxLqrCT1VaDie8NU1MKv9I983PkVmUj6f3K2MBYDo79u4q51p3JzB6rt0DIexPFgVGqpNuCVyP6iujhcw/BOTas9dFDA
 4FnkVo5O
 7xKLqflTYuLPYmAVr2sY03uq4hL8TlC3JtfRSlyf9sJIJEJIoYQ/tv2MUVioaQaeMPEPxKRcDBGB9KUzOZ87jblSVpCplaRjaJAPWYT6vr/94ZJsLNyIJ26VwD0+0WABeX04o/9qsV0OJyoJ4F6kxf2llKvOC4YYHXtDyPuCFb5qbuHIFj8vh8bdB/CZtX9a5RXPEoCrpnBV99/aKxfzUMsC1p3bGhB9DhY8qLcGieSLkYtZf2dhnF4jYIpK39M8jTbKQVyfDdMbIObfQxeAa7d/Zv5k+BNVvGBJMkBG+sfqCN+DtxhEazjBQLHwTooGC2pVa/Fp0WUXquPJVSPMIAUDji5MmZ7JC8o9rZ1vGuKDwPXNYfrGlZ9iOsrvbw9NpTqMUGblBCOgC9tEulJ88WZsQtLyKioGBCwQxjqXRWP+09dKcU37gsERE3tjxHWFhXiP0e9jH0GQed0lkcfqk0hKQBtj+GUNoYJ7T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

Setting IOCB_NOWAIT in filemap_get_pages() for AIO is only used to
indicate not to block in the filemap_update_page(), with no other purpose.
Moreover, in filemap_read(), IOCB_NOWAIT will be set again for AIO.

Therefore, adding a parameter to the filemap_update_page function to
explicitly indicate not to block serves the same purpose as indicating
through iocb->ki_flags, thus avoiding modifications to iocb->ki_flags.

This patch does not change the original logic and is preparation for the
next patch.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 mm/filemap.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index af12d1cecc7d..350080f579ef 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2454,11 +2454,15 @@ static bool filemap_range_uptodate(struct address_space *mapping,
 
 static int filemap_update_page(struct kiocb *iocb,
 		struct address_space *mapping, size_t count,
-		struct folio *folio, bool need_uptodate)
+		struct folio *folio, bool need_uptodate,
+		bool no_wait)
 {
 	int error;
+	int flags = iocb->ki_flags;
+	if (no_wait)
+		flags |= IOCB_NOWAIT;
 
-	if (iocb->ki_flags & IOCB_NOWAIT) {
+	if (flags & IOCB_NOWAIT) {
 		if (!filemap_invalidate_trylock_shared(mapping))
 			return -EAGAIN;
 	} else {
@@ -2467,9 +2471,9 @@ static int filemap_update_page(struct kiocb *iocb,
 
 	if (!folio_trylock(folio)) {
 		error = -EAGAIN;
-		if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_NOIO))
+		if (flags & (IOCB_NOWAIT | IOCB_NOIO))
 			goto unlock_mapping;
-		if (!(iocb->ki_flags & IOCB_WAITQ)) {
+		if (!(flags & IOCB_WAITQ)) {
 			filemap_invalidate_unlock_shared(mapping);
 			/*
 			 * This is where we usually end up waiting for a
@@ -2493,7 +2497,7 @@ static int filemap_update_page(struct kiocb *iocb,
 		goto unlock;
 
 	error = -EAGAIN;
-	if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT | IOCB_WAITQ))
+	if (flags & (IOCB_NOIO | IOCB_NOWAIT | IOCB_WAITQ))
 		goto unlock;
 
 	error = filemap_read_folio(iocb->ki_filp, mapping->a_ops->read_folio,
@@ -2621,11 +2625,13 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
 			goto err;
 	}
 	if (!folio_test_uptodate(folio)) {
+		bool no_wait = false;
+
 		if ((iocb->ki_flags & IOCB_WAITQ) &&
 		    folio_batch_count(fbatch) > 1)
-			iocb->ki_flags |= IOCB_NOWAIT;
+			no_wait = true;
 		err = filemap_update_page(iocb, mapping, count, folio,
-					  need_uptodate);
+					  need_uptodate, no_wait);
 		if (err)
 			goto err;
 	}
-- 
2.43.0


