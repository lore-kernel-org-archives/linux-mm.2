Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52DE3CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 07:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7846B0093; Mon, 11 May 2026 03:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9EA46B0095; Mon, 11 May 2026 03:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DC666B0096; Mon, 11 May 2026 03:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0FC6B0093
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:34:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 36A661A0622
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:34:15 +0000 (UTC)
X-FDA: 84754325670.26.B0354FB
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7593F160008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:34:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qZhPjRfR;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778484853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EgE7Huk+NLVuTxSVwDwhS2p2qIJr1u27I3Kmv9Snavo=;
	b=YvzjzryGzrxJWeK0L3c36zSGScDyZ0RdOzrqYPsds7k5/2ev71DiK1An6MGhyIz6FtuvUq
	HKSekLTuiQY8CcUX4vmvEDR7Ldlj8QmRDO1h+bc7+ZRiHR7HABfE0VntNxyI1csAoMPYST
	UqfgtKVmciBvojYTnrdOMd9xPfpBa4Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qZhPjRfR;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778484853; a=rsa-sha256;
	cv=none;
	b=KX/rqFHACN0euf9Y7tyGYdI18dJp0lIImCwHRDhOiIGVdbPClSFZgR1SXBFPqS+tSYrzkb
	oY9TqbTqj0Fi+tb8yS9EbSgD3tsOQIekTwy1CnlvS2m/cCvZ+GBNOPH6k3NEVgxYDE81px
	cpfGECatc4rgARNz/lKsIdJ3TKqet1Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778484851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EgE7Huk+NLVuTxSVwDwhS2p2qIJr1u27I3Kmv9Snavo=;
	b=qZhPjRfRh8ZPZ7+m2vaP7uRJmCUuqnlQg5HBxVUeyckkM+howS2pTPP3ZIuWEzAdWTvx8A
	EULixie4m6JFfV0Pt3ImqpGurCjCwl6a08/1GOSxaKcORBG1Cx96RrDjg1+6c7htGEHg4k
	fYS/Hlb6Yr1b3RNhnTI2l8lFWd5c0g0=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	usama.arif@linux.dev,
	chrisl@kernel.org,
	baohua@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v5 3/3] mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*
Date: Mon, 11 May 2026 15:33:34 +0800
Message-ID: <20260511073334.635682-4-baoquan.he@linux.dev>
In-Reply-To: <20260511073334.635682-1-baoquan.he@linux.dev>
References: <20260511073334.635682-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7593F160008
X-Stat-Signature: ye9hret8ythg1fhgq31jjw8ro6p9seqh
X-HE-Tag: 1778484853-805853
X-HE-Meta: U2FsdGVkX1/zMidcvim0lSaNN8ZkyovF1IMzWgFEjxRV0WYT3RP0p/5RVcQwBOQ0BzoBDt/rVPYlTA8fa2sEGBKAtBFNkOCvTr5fiDSZXJXa4mKPG2H1NsJRTC34SD8ZaLucTtw0V0Bn1CVeJl3mf5vv39bJX38ENdXTBA4F82RzP+7tIAbdqWhzr7Wq8w6eztCLikrn86fDcQDPDgeTCcpPtCsw4h9/rWf2wHuS0WUYIGQakLSXj9th+ghAmPDULW626MtPlUJ0VNH1kja3zQBIiSM0TIh/gJPgNSidAEcN9e2GYTpjVmD0doOUN2qnAVL7CNa4ddsCOvgGDuSycsZuHhkzitiAn573jHzLYsqfJt8QSeVam4OhT+6B2sd9Z2nHPp4BVCOMtrLZyxs4TDnH+xqc5CFe56Ne6sAGtoXVNjN/tKIwkWW0OWrpLgB966XpLcVpfDYhAMqqCPfpn1Oujn/eqvLbHT5xM+YiWRYgCGCeuoEYs/GXxSAJVnzg40rgUhqqfCpPwuzXEirGNH4ntXuEWFH1uNqI6MM4B1ZR5ojOPn6Bs5gPxeKzJtRHbvSe9Ql/iefE5ubiAYJ4QYL8JSpgw504tX7A8WtyGPg2epjHecARddqWrmdxUev0CUaOkadPdObApEf/H6MkAgM36lb4cRVT6fWdSTt7Z4I77jjXih4a3oN59WXNFD/kPQll6V5vEU1P2foG+PMCZDoimQDC3Fq3Gc6wHcXVaj5D6C0yQBUIDSwISEoB45tassDjLZ19D6k+ks/MxT//VYBELNaXnz9I31g76UpXqEWlGEqMW63zL8nVjgGJUk7R4eDEgQJ1I/cpKyvrQwf8CHA8bdtTgWB2Z3jEWiZPQGinaiDh9R6ISHkfhP+WYAnqUAV8JKxmw8nfQ3z29yzBTC5G8ME2tFihiMqZwogDnK+MrMdB2ATiMNKxN1gbXn0VzBLrIePp2mP9v2x/EGx
 BkN1A8qE
 5xCBukGiStKOevTu9+M0dFUlCSAQBfD3crNxtrDLDVOhu86ovLHCIg8G4+dTGsknGnwpja+bHqjncYFZuf8USM9HOgh8Y5/wGrhPwog1VSBymm4CzUAZzaP7LdKov03HCtPKGBm2BEzf/WDVYudMna+alU3IlvuHXj7zWvZ/TDY/Sy/FgF4LihU8H/j45APWLYuz1ESBK/dc/6yxobq4xQfz2qLzRQpY0ufLNSinzgESK1nBSPRJh+J+/sww5TjsKZovQmGaELr6nprHXEgGWmXzayHIxlYZLPbWQ
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
index cef884339717..e2710d5fb44e 100644
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


