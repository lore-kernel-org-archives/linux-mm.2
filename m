Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BB35CD37AC
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 01:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D695D6B00A2; Thu, 14 May 2026 21:58:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40D96B00A4; Thu, 14 May 2026 21:58:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7DD96B00A5; Thu, 14 May 2026 21:58:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B971D6B00A2
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:58:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5018A406ED
	for <linux-mm@kvack.org>; Fri, 15 May 2026 01:58:06 +0000 (UTC)
X-FDA: 84767993772.04.B97155A
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9648D40009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 01:58:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XmcUqg9r;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778810284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ma9rC7Uc9wawJfY5OVvtdjq6Z8aOUOjvo79XUTZ+mxA=;
	b=8gtsHLxNjFEnl2GFO0GFVPNan209bEQGzMx4XQzFGKsnyH2aT9NqH6kzaHLS8+6E939yKG
	l+nIfcb1kf8jALTjvMYGC/VwJ4zxaQtN9VaBs39VXPhlVYzn+Xi8wzSYgk04tdGsMWV350
	cPOR5rI6V7Zt5XFpHtS0pSdcl/Orekk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XmcUqg9r;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778810284; a=rsa-sha256;
	cv=none;
	b=l+tL1rJLg51x3oUSvJfIS15s32dPJXEySr2KoExQlKkyW3pY8KXJ9Z50f7B4RlycrZa3XH
	YT6l7N8HJXIKrbEoeThfQp4/Sg31JcjcZG9h2Sp9elzTpLN/0wpvYYMQFVqvyd8AkvVcAS
	ewd/+RSm5dJfLBwblT+XFbBtpxUb/Uc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778810283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ma9rC7Uc9wawJfY5OVvtdjq6Z8aOUOjvo79XUTZ+mxA=;
	b=XmcUqg9roSeW6RY6JXgXoMBP6xs0eeXvWpov4g/feuF2HLPZdr1oWpdJeTKJxHu7JGQ237
	gL0CPCRKABbmkCMSY81i/N/j1/IMCe5iVJsN40dOGECxgqrhcoKQGk4FRCYkM6vqU2oOYl
	qoJFWt8o8eABbtVI4WIkZNFIzZKtxUg=
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
	hch@infradead.org,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v7 2/3] mm/page_io.c: rename page_io functions to consistent naming
Date: Fri, 15 May 2026 09:57:36 +0800
Message-ID: <20260515015737.890994-3-baoquan.he@linux.dev>
In-Reply-To: <20260515015737.890994-1-baoquan.he@linux.dev>
References: <20260515015737.890994-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9648D40009
X-Rspam-User: 
X-Stat-Signature: ieke1f4y7qu7jtrsh75axuyyima5br4o
X-HE-Tag: 1778810284-646346
X-HE-Meta: U2FsdGVkX19eijEw4mIPi3MXQdcqFSYq9iQksM7napdZq9nAlx0+BkNh6d0TZLqCuQs6kQe7wKgN8+G5UTIChQxYycP1njGeBp+Q0DFttLfVD2CCuuaNjeGe4GWJ1IdqdeUzKVRhcWEELoW4Y7RGbM2sbi8+i3BXOWoI45LIqSlndH9OSP3YtJ47FezQzop3WG7LXqrPJppwtzdisfvTxSld2ZPB5j/5CVNYm/0yrA1H2SHbJ++sTAkrCrNgHol5yLteDhQSdu58EcT/kqm2z1JH9qZMwlC0On48RlvNU+cLYGTlBbg8oZlMe3TyvfYFlQKmySoxPOpeKrpkcoj197P5C473kZpX1/c6dOBo9iaMAI3gUFv9GFBdB9eMtr6ytEleWmdYnuIMZz2yqDAIhTVLFI/khArMS0ofHagryak5hpxahC2UNFUuLCES9wFcpE5UjqXp6XYzFVb045RZHVLQI0TpyD3GQztW989x9f5lrn7W66TBk7ItVHT73TNROIbLSCFpl6lm9qWELWPXFOIfehZ1B0X2j+OfL01Y2ATa1ccDn7vlnsOxUOFCC2qhQEbGMyA1Yc4t/fqWDAGNNpD7j4jZGarF149DcQ3hwzHUTM3W8X5pXW5nCg6FiYftefzeegNIDhZ6KAMQ9x8xiPGN0hKDd/xkqRt642QDMeKSIkZ2Rp9zPj9lCZxXqxzxmkNc6umgBrr6DOGQnHuoGKn2ydkEVfh/dbS14OhFMepZSbQyhbT7z3R+KixNeZ3z9ctSt0IPWXSiC2xI1MP+F8niH3NkwEeHVPfvQPgMn10xj/ufMj/OV20BQ1TPsTWtASBjDlhJKzaKZ8IXMXFsx2FoAoirhSQ1Xesss+2KjGSxHYJH0NoUurEwTdhqhmfZQV2E6W5Ywvj5xynEov9Z7eYqxjmxex3yphCPSFFnvzpbrlp36naaTDgykND8q/icU5zTjJleHkBztgc8ij6
 Mq1wx01Z
 k46HvOTmLtX2QRxctRkrZq6sPGr6M0gxUwZY1ccicQbO9s2dUC9PgvO/zX/V70LgLU22FKO2Zkpfpc0g4PUsCaZzNzvHbPd6ABIEKf4HK3ZzQZQOg6vPTtUZIVHX9zVJn9bdfH9NpMV1kt9NmokDd7Ju3fStyAKXCkkxCqnRYefS/2VsDPeLAdlv1AyY1xlPPp3H7ngtvt5rMZLWDJn0wFjv/rYoZCIvaZyel8Te5PKXy9Y02jRy+Aiboaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename the swap I/O functions to use a consistent
swap_<backend>_<op>_<folio> naming scheme, so the backend type
immediately follows the swap_ prefix. The new names align with
swap_ops callbacks: .write_folio and .read_folio.

  swap_writepage_fs          ->  swap_fs_write_folio
  swap_writepage_bdev_sync   ->  swap_bdev_sync_write_folio
  swap_writepage_bdev_async  ->  swap_bdev_async_write_folio
  swap_read_folio_fs         ->  swap_fs_read_folio
  swap_read_folio_bdev_sync  ->  swap_bdev_sync_read_folio
  swap_read_folio_bdev_async ->  swap_bdev_async_read_folio

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/page_io.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 2b520af88376..38b94c560c37 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -378,7 +378,7 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 	mempool_free(sio, sio_pool);
 }
 
-static void swap_writepage_fs(struct swap_info_struct *sis,
+static void swap_fs_write_folio(struct swap_info_struct *sis,
 			      struct folio *folio,
 			      struct swap_iocb **swap_plug)
 {
@@ -415,7 +415,7 @@ static void swap_writepage_fs(struct swap_info_struct *sis,
 		*swap_plug = sio;
 }
 
-static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
+static void swap_bdev_sync_write_folio(struct swap_info_struct *sis,
 				     struct folio *folio,
 				     struct swap_iocb **plug)
 {
@@ -436,7 +436,7 @@ static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
 	__end_swap_bio_write(&bio);
 }
 
-static void swap_writepage_bdev_async(struct swap_info_struct *sis,
+static void swap_bdev_async_write_folio(struct swap_info_struct *sis,
 				      struct folio *folio,
 				      struct swap_iocb **plug)
 {
@@ -522,7 +522,7 @@ static bool swap_read_folio_zeromap(struct folio *folio)
 	return true;
 }
 
-static void swap_read_folio_fs(struct swap_info_struct *sis,
+static void swap_fs_read_folio(struct swap_info_struct *sis,
 			       struct folio *folio,
 			       struct swap_iocb **plug)
 {
@@ -557,7 +557,7 @@ static void swap_read_folio_fs(struct swap_info_struct *sis,
 		*plug = sio;
 }
 
-static void swap_read_folio_bdev_sync(struct swap_info_struct *sis,
+static void swap_bdev_sync_read_folio(struct swap_info_struct *sis,
 				      struct folio *folio,
 				      struct swap_iocb **plug)
 {
@@ -580,7 +580,7 @@ static void swap_read_folio_bdev_sync(struct swap_info_struct *sis,
 	put_task_struct(current);
 }
 
-static void swap_read_folio_bdev_async(struct swap_info_struct *sis,
+static void swap_bdev_async_read_folio(struct swap_info_struct *sis,
 				       struct folio *folio,
 				       struct swap_iocb **plug)
 {
@@ -597,18 +597,18 @@ static void swap_read_folio_bdev_async(struct swap_info_struct *sis,
 }
 
 static const struct swap_ops bdev_fs_swap_ops = {
-	.read_folio = swap_read_folio_fs,
-	.write_folio = swap_writepage_fs,
+	.read_folio = swap_fs_read_folio,
+	.write_folio = swap_fs_write_folio,
 };
 
 static const struct swap_ops bdev_sync_swap_ops = {
-	.read_folio = swap_read_folio_bdev_sync,
-	.write_folio = swap_writepage_bdev_sync,
+	.read_folio = swap_bdev_sync_read_folio,
+	.write_folio = swap_bdev_sync_write_folio,
 };
 
 static const struct swap_ops bdev_async_swap_ops = {
-	.read_folio = swap_read_folio_bdev_async,
-	.write_folio = swap_writepage_bdev_async,
+	.read_folio = swap_bdev_async_read_folio,
+	.write_folio = swap_bdev_async_write_folio,
 };
 
 int init_swap_ops(struct swap_info_struct *sis)
-- 
2.52.0


