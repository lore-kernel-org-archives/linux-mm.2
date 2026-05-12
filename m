Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54E03CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 10:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2A966B0096; Tue, 12 May 2026 06:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B027F6B0098; Tue, 12 May 2026 06:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A19656B0099; Tue, 12 May 2026 06:42:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 912886B0096
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:42:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4ED6314046F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:42:33 +0000 (UTC)
X-FDA: 84758428986.27.75D356A
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 63EF51C0017
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:42:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jg7op6ym;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778582551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4MCpeC/QI7aHjdJ7R96J+Wf7v/xQ/HqdMKtbliXTYQ=;
	b=RvhkU5Dj0VuhKG1JdtocbBOz6yGXA5WV2Ky3ZOY04y/XgIuUhP14kwnXcp+akz1rf3bGRt
	5PQyRXNL9SP3wQgK6X9Lm0p2ub6iwS6tMOoGpjn/DoWs11+xCX0SGXpEHr3XwVO8Y4hFAB
	4n7nhmAKtfury1S/sovaHe2r1fB7OrU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jg7op6ym;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778582551; a=rsa-sha256;
	cv=none;
	b=S6NZbasUoR5KRnhpyHB7PG06kisfGssJevmzbXD60V264qFMNInER50/D2OBjwp29tp6Mi
	gcIi/mBrlECqsQ8YdlGB2qWVJlIK9Fi2Qd5GELETvyIR1RPRAR5XXWaK2BwKKPLvfa9ak9
	Ozfit5ah8T7ib6DKUD7GoI5KJ8+J4hs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778582549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4MCpeC/QI7aHjdJ7R96J+Wf7v/xQ/HqdMKtbliXTYQ=;
	b=Jg7op6ymUQq7eSQlbqukgQm4a8WnNw1RxBKdasWeQORHEXNOyuW/B6ETDbrlFy24vk73V6
	2mrWF4l8/DeYIBmM8PUqo1q7je2X/p+6Qtnb6UaO42x3PSGkYJkm7VdkaIjM74qW41e82I
	0J6WqNbjp08P5vuohUNLqkG+kV7f/m0=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	baohua@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v6 3/3] mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*
Date: Tue, 12 May 2026 18:42:01 +0800
Message-ID: <20260512104201.716213-4-baoquan.he@linux.dev>
In-Reply-To: <20260512104201.716213-1-baoquan.he@linux.dev>
References: <20260512104201.716213-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9imoqmpq4zqqp9h39zgua3fsfh4bhhdn
X-Rspamd-Queue-Id: 63EF51C0017
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778582551-313095
X-HE-Meta: U2FsdGVkX184RVCXkVmpXnzbIeKoHbqSSVagZMEbnnw4/L6qc8tpL6X7eT+JnQNZe4mTJ/OwrS4CnHb+SewgGxlUmFrarnG8ACUYim22W+GT0hi//5tHvnVOwhRNbQhqE8WAW4E0KW5Huamay2UgMFjnRt7JTq+W8Qzs6oZGwf390qRqr70l9WhKoCPGfIm9mgIwe9S1fhQaJL1Kz9Tg/W0v1zcJJ+XymTGDP9JDoj8ll+jEjMbdgHY3rR5Ba0/uCoTceQzxMeCJaaeL4p3cbZ9WGEXub83OQQBHZo5fw3tQCWcea/SIh22GC98QATgXzwpzoCnuIueNiKyrP3lQkf927yqccIT9QHlx2T5H0VXNakNuIv6EmJX8o+zJfBgZFm7ZFiWwTJPAJ0Vk/jFlrIeqLScZOhzwwwzfyaqCMLMHbVjLJ8GGZh1Ho/ot4L1UYgnBfFSffZa3aV4derqdJprB0CUcvB3UlJZfIHXQEww1KumvJHmRMYsiIwkmIz/wMn76EOX1ZpjXb6fCkggbjP27AcPvawaCQfGshLqbiBLscGhoVwtiIc3U0BIxT4nQbeP3XM+uU3wrjRF/QpnRAxLNkkeI4EeIsPBC50ob20Rm9FTffkpyrwoc8Ar1RBD6+WU06FeHOCYB3BOB2n/qbtRJryYRU3XJCbKYJ3zwe93DU8nxSfabFgjM/Jb1yBZmw+/OEau+FekRK+9pFgdRM2A34mAaA7ZDoU57iwYqNush3XS7+4KhAhEivqVLrg4yLy3Z1kLc6/BWmcml8DaOf9YQY3ofV8T8BtxzbU1zDRk7HZ5tweUZSTuDalRlx6tQejlW6oLfbGLIZSlF4bfnQcOTIhEXeYYyEU2sA0aUZ/FdxZCD8uUpr8n5rmZzFLmwY7+KqYP2mzntRryLpAqpdLAB9DIUwPjIkN7NsIX6SgAnaF8ToUUhALR0iwXbxNFYpkYBMHpjzS9u/bVUthW
 5U4szyCJ
 hJmFVc6BhaPEexnMaesedkL9g/u+rVKERw4rI+QQCSZJegokiuG64hbWA2ON5Ux6oYwk/C9FDjVtOGOFudUV6YsMF/ksy/xc148XLUR2ihKcWASSiZkt3ijILpD5Ed/dBga/npwgvLdnOCnChO39cYLXisbAmjp9XtuRtGbGVxzywgfDWpTF8DJafmOw4hQUk/uMna524E6Sk2GqCoheMDzj706Ov1dhDpfv7swDB7PTx5K0mQxUFbgYqbcRcHGZ9azyal4h5xzmLZGrCP3Z3bGa1LhbIrAfJACd2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All these swap_writepage_* functions handle a passed-in folio,
not a page. This renaming makes them consistent with their
counterpart swap_read_folio_* functions.

Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swap_io.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/swap_io.c b/mm/swap_io.c
index 3f9aee5b6a4d..ff38adfde0fa 100644
--- a/mm/swap_io.c
+++ b/mm/swap_io.c
@@ -374,7 +374,7 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 	mempool_free(sio, sio_pool);
 }
 
-static void swap_writepage_fs(struct swap_info_struct *sis,
+static void swap_write_folio_fs(struct swap_info_struct *sis,
 			      struct folio *folio,
 			      struct swap_iocb **swap_plug)
 {
@@ -411,7 +411,7 @@ static void swap_writepage_fs(struct swap_info_struct *sis,
 		*swap_plug = sio;
 }
 
-static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
+static void swap_write_folio_bdev_sync(struct swap_info_struct *sis,
 				     struct folio *folio,
 				     struct swap_iocb **plug)
 {
@@ -432,7 +432,7 @@ static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
 	__end_swap_bio_write(&bio);
 }
 
-static void swap_writepage_bdev_async(struct swap_info_struct *sis,
+static void swap_write_folio_bdev_async(struct swap_info_struct *sis,
 				      struct folio *folio,
 				      struct swap_iocb **plug)
 {
@@ -594,17 +594,17 @@ static void swap_read_folio_bdev_async(struct swap_info_struct *sis,
 
 static const struct swap_ops bdev_fs_swap_ops = {
 	.read_folio = swap_read_folio_fs,
-	.write_folio = swap_writepage_fs,
+	.write_folio = swap_write_folio_fs,
 };
 
 static const struct swap_ops bdev_sync_swap_ops = {
 	.read_folio = swap_read_folio_bdev_sync,
-	.write_folio = swap_writepage_bdev_sync,
+	.write_folio = swap_write_folio_bdev_sync,
 };
 
 static const struct swap_ops bdev_async_swap_ops = {
 	.read_folio = swap_read_folio_bdev_async,
-	.write_folio = swap_writepage_bdev_async,
+	.write_folio = swap_write_folio_bdev_async,
 };
 
 int init_swap_ops(struct swap_info_struct *sis)
-- 
2.52.0


