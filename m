Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 987C5FA0C5D
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 08:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 118386B0092; Wed, 15 Apr 2026 04:57:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9456B0096; Wed, 15 Apr 2026 04:57:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8DC6B0098; Wed, 15 Apr 2026 04:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DEAF06B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:57:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9311B140537
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:57:35 +0000 (UTC)
X-FDA: 84660186870.02.BE8692C
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf27.hostedemail.com (Postfix) with ESMTP id CE89340003
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:57:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Go0uIRa0;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776243454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h8Q0yOP/JuEDCBeOqlI6zUOjJoYjm2ZTHveOpWLQl2Y=;
	b=Sp3df2u06kz3Qfh61CgCb0CDWKzpnrY/Od495BLdCXgLQGov6rPPOFyAhwGA/ZrbV8Owlp
	34t8HRGF/92JOu7fYKWBKdE/3bQZkwd1l2JLm5baK/5jm74iRk7An1kzGA9z2/MdFrARrU
	5xk6sOjzC4kEa0MaZYIAt71wk5ZxUcs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776243454; a=rsa-sha256;
	cv=none;
	b=Hp9e3nQx6H9RyfPKuib4Pm1d9Ndd41Q99I7N+zYz/R7albmn/QmAKAHZSEWVel04pSJj8p
	Iy6ZLTSS8uDK6dqKMP3zRZD3GRc9p/zjOi5OvAEs0i5S14BZW7iLUUg3NImJX88xYnsR19
	MJSUgEnb9ld9Wr2QtUCRGHZZ44wSi+0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Go0uIRa0;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776243451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h8Q0yOP/JuEDCBeOqlI6zUOjJoYjm2ZTHveOpWLQl2Y=;
	b=Go0uIRa0WQa6Da4Qp3/MoP9lCX3U5mklASq9YslPWrDFn/d9iDJo4NhxNlFjRB+30WBBDv
	gqaqbBszsDtuln0CRDTs+C0NHE+ki4TKXWoaQf+lOXcMR+bFDgjN1JuRYL++ZAJWm8wM8k
	pW39m+Q0K+QqAPxTov2GkfHBZAjvJcE=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v3 3/3] mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*
Date: Wed, 15 Apr 2026 16:56:58 +0800
Message-ID: <20260415085658.993859-4-baoquan.he@linux.dev>
In-Reply-To: <20260415085658.993859-1-baoquan.he@linux.dev>
References: <20260415085658.993859-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: gpxor7hqzezfjjmzhhckt8tg4mhufy5y
X-Rspamd-Queue-Id: CE89340003
X-Rspam-User: 
X-HE-Tag: 1776243453-631418
X-HE-Meta: U2FsdGVkX1/T5rYu7sE81UxElqIXBBxi/pO5ptUNXta03iaUDO7/yQevzSQZTHAeg1QAxZ3QWYjd9yRHwwkVXlbnbbWhiqCkm8xbACYh522RpPRuEKHeUYoEOa1rHhNAfmnI9p1lM0dBxYM90uNxB10gABaQbbXEA7NvG/f2XddgnMPt14KgapbJf8xJs4s6dE+URZjR1qdaiR+XFp+T6kzuuy0JDwdqTNMn7yPbOCZuwx+UPKHs7V5EoHl+89XNjznKibxRpDgnqFukyolfNTX6BKIavOiUYjfEBI17mXOn4djaalw9/QmVdwEVQvoz/uw1iJV3cYAkXXpaYcPpYyOQMp7NPaQwCfvAmGr1ptFg/Odbr5i8w4cZ8BfHmqYk32VQGIPkSBdHDlZFenPtwD5tFfTzEjUk5xpPQEhz3PA2LhMuIlGEiZkuIr/66iYZnA9cDoJIAvvIuSGHo1chZkosdl9YgDq2rCVF492NtyFHdrWMwMFBCS1GTQW4iHLI75YIPEKKDfw5MjERkbjvuzamb9bC+oHklRGY61VA5D6PiI9YZfL9hZHHrHcwyxIEWuIHD9H0it7AedY63dHgQn+3JBCBzKv/BSPBds9UclQxrH8BUOyuVTUKJt50VizQ3NNUQJy+aQzGP+fAddqaH1WJ4Qm473vTPYWPdCfP7/9h7FdyxRLNeUurjOds7YBn1arY0Yo28XoyPngTPC59r2p2w3jXnoWETYXpPi1wjpKiHQ6u1Y4H9AubQlow0M2FIGRW3XtwcYr7ogIgHLDV3EC5LEOxPbikL8Q6v5kR5So3SGJq4zVzfKlhvFqq92zcReRKnzhHCLikJaSudaRKaBmTZGcfWE/ox+ZuwXB4iuRpImBpgH8+DIQFsADO0bDH3Sxqn261DkRglm92p0MgJyeaSM2Inf+ULTJjJfb0zhg4KqxKxtW/puKK2atJ2zTdBNFK1t0NGgW+wsWVv2n
 DL6oQ0o8
 nbaQDOikt6iPAtL/MQu7aAT21edtIWZT/NqsCG5ESGIIHNtKTuPG9sCigWjPjxSXMUGv+Hy3zq2izvD3xx8vM3YzpRYIqXo8cde0DqwuFOa+BAQruL1WYQyl83+ziU53Gy3z11jMG2BFnSnKFPcFCuatJowwgqQLsBp11kEIviXAugWAq2WOiTOyz+FNsf+2A9mnaBhpmar1ihZKF8RHEexb0cz+81Ukc1qdMCgo5JCzdQq90oOnAzwL0fVUxHhp6tyREaA6/S+EPz0QvD2TbagacROoYYvZCst4i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All these swap_writepage_* functions are hanlding passed in folio, but
not page. And this renaming make them consistent with the their
counterpart swap_read_folio_* functions.

Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swap_io.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/swap_io.c b/mm/swap_io.c
index 602e9b871b30..26f2daabb91f 100644
--- a/mm/swap_io.c
+++ b/mm/swap_io.c
@@ -370,7 +370,7 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 	mempool_free(sio, sio_pool);
 }
 
-static void swap_writepage_fs(struct swap_info_struct *sis,
+static void swap_write_folio_fs(struct swap_info_struct *sis,
 			      struct folio *folio,
 			      struct swap_iocb **swap_plug)
 {
@@ -407,7 +407,7 @@ static void swap_writepage_fs(struct swap_info_struct *sis,
 		*swap_plug = sio;
 }
 
-static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
+static void swap_write_folio_bdev_sync(struct swap_info_struct *sis,
 				     struct folio *folio,
 				     struct swap_iocb **plug)
 {
@@ -428,7 +428,7 @@ static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
 	__end_swap_bio_write(&bio);
 }
 
-static void swap_writepage_bdev_async(struct swap_info_struct *sis,
+static void swap_write_folio_bdev_async(struct swap_info_struct *sis,
 				      struct folio *folio,
 				      struct swap_iocb **plug)
 {
@@ -590,17 +590,17 @@ static void swap_read_folio_bdev_async(struct swap_info_struct *sis,
 
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


