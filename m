Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52297F8E4A5
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 03:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE82D6B0005; Thu, 16 Apr 2026 23:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A97696B008C; Thu, 16 Apr 2026 23:40:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ACED6B0092; Thu, 16 Apr 2026 23:40:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87E006B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:40:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 552A61B8FCF
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:40:48 +0000 (UTC)
X-FDA: 84666646176.02.BE1E66D
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 93343A000D
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:40:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CWK7pZ4f;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776397246; a=rsa-sha256;
	cv=none;
	b=LsJ5NRY4hgMUjX4p3nwq22uQrbvz5liMiyMmnUcEZ00pZmnhRtLqOVdh1HuMpdVPAEwiIE
	rP1O7DMogJ7gxmdZZvh/GZlpYd1TWWT1wrGXu3lLsbP3YHpe5iKlJNH+F3yC0MyssRIaO+
	K7Rjq4qge8/74d0NdVn4a7pn1Neg6+Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CWK7pZ4f;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776397246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7ww5x3caJvrufa945Qbb7g+cuzkYOKwE0WoRtPhhBc=;
	b=WJEUnQBkSzZ52f95iaMPEPxEl2HwYAMdrWlRlWsXxJ32RTAft0g3roqjn7ULgXk5L0uToR
	2sYrDd4lKbZP66SOae95eqB/6KtQXps7mrElnroLbbrUJh5fJaDYzBTlcpHMJqnFm/leT5
	v2KJvaOn+PUrZKhI8BJIYE4nMUeGIOs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776397245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u7ww5x3caJvrufa945Qbb7g+cuzkYOKwE0WoRtPhhBc=;
	b=CWK7pZ4f7u8FQDcEqqw2AQspzGWC6HZdUHX0baE665ZMTj4JEbfYnKAP03v9atFfkr0zyJ
	82TRw3h0dg0AS8Ac+g+O2y4hJHfSkerfvHhATBK1dL2RGGhLFnQWUdhH5rCAv6bPa9M5pc
	9rc1srAZhQc9MMnLaHOVFg4c2JCrCzg=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	usama.arif@linux.dev,
	baohua@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v4 3/3] mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*
Date: Fri, 17 Apr 2026 11:39:51 +0800
Message-ID: <20260417033951.1111038-4-baoquan.he@linux.dev>
In-Reply-To: <20260417033951.1111038-1-baoquan.he@linux.dev>
References: <20260417033951.1111038-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 93343A000D
X-Stat-Signature: 9a6ummhtgyb85bn4m3upfeho8uzw9agr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776397246-764953
X-HE-Meta: U2FsdGVkX19o55sokduhrZndaMaTtGkk9ahXv9qbU15liSp5QhwMIYakrIPqUT04NS9kXsL94jSG0+YLFvcGGieWeyf5ZrHHR5UJ/B04MkO0W+sRoBQNqGH1/grmj661rckjRXrhhHqd+9FGZwLnlhxuR+gR3sBoNpqsxpVVBATdQtFgksimp5vuMaJLjgyaQL6f4yn1ipVIAUUxWgOccogsA1b0b2/o4oPXW+Y12AqBcX1QPSVFnb5/uuV/pU0UKZWPO42kHgyy5VnsFQkWuScVuvHfsbfoI27T4PTdyQeghO3GCWcmoqtmXak8tagCU4NAdI2gjfOd9o8je8bhbD/gGHsmWKtXgJmVoiRLEzEcJFPP4WiXIo+jCklZMsVT1rLIdDOG0/PQqBDaFCfUko+Ts0ZYpHgSVDxT3GsX8K1IIfc/MoFuNZeWA9AmCETY/hDBAk+A+arGIsrqPqjBCUurAM5o5wY5Wgh091wz9JDUMqmNxImXa2C7dlei2Iq+Qy/yb42Y5rQbnQgzdn5PWZrIqz0u+pltwR6oSSM2syaMMOEMDzqMv1l+oiSqAPD6h43QjFehnDgZrGtGEACx1ia26wq3Jodf+oKTmuuVMjJnKbKJaPx1atL2rSjlbQNYiGdZ/mGfJiqpb7mvhwHJmwwuZU/vq8hegO1Z5ABUUdE6lbGPbyXtaWuroxONCgL+4mSpykrF74g0ExxmutYq9vlZBHgRqm1B2ioD6vCk3CkkZLOh9hg7dF48Vo7TGD27bqSQCBylarUe9/eeRrYgYfptcTriJlh4roDVq3+z7Zoh+kosAhCqXt2bS+sJcKeDEfeqCYwop38Lfl8qgyhvjU06CWJPqMIwQGPdrR62I0cZ/ZWqPIVkE9fNfaSU03b69Eyd3UfX/F/WaenBsDLBkK6sGKLjTBkWnEudSueQPFKI9FxUCjCDVOCBzxdbQp/lV44HjbHIrRz4sCwuU9K
 wxd/WJF1
 ebnY0n+w2iKJOf19ZOs55lq0bBvpgq5jfMnTj2fpunifTQvEUgweredG2UQEMaaR4RJvOh+O81kAUEvUbCWUno2JKxzD9/h2FAmNpoxfLJYox3AgcC7O5+spcrtFvmpSU2vNA+5gsX1L0DxHOLYPEbXuNDPGkwehK2BbzojAACiI8NL9eJ637iNb+kfV4+8RpiS6yMhSMokrJz2hJXop0CTnRsKkrVTBn0PztszkEePCiKnnUjgohDLwdGe4uvdVMWxkdYtqw6NucAdQxqAuMETFurotxeq3emREc
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
Acked-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swap_io.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/swap_io.c b/mm/swap_io.c
index 1b054a122f53..50a16148b919 100644
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


