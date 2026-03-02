Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 869D5E9B35A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 10:40:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45B06B0092; Mon,  2 Mar 2026 05:40:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E027F6B0093; Mon,  2 Mar 2026 05:40:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D43486B0095; Mon,  2 Mar 2026 05:40:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0C226B0092
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:40:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A8D81D1B1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:40:51 +0000 (UTC)
X-FDA: 84500779902.06.7DA0DEC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 752114000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:40:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="iDECL/4g";
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772448049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DRjABJuV2Sd1Oxa6l16+nsTcOydzZjarAC+otika62g=;
	b=dtrX/Xb7ZfomePFIqGHNu9CV6KIyG25Dc1XbQTJuOESOSzNTUo12UOTfQyZHQF+moeLQ7J
	yLZjoD6CV9fVeNSEv4NpoNBHOYzBkIUuel+Kj7BQ5POMDvE3Rp9fkSNURbLdRFKo1UZ87C
	OCU5M7H2Agx9bi9g2jSNb6V7g/4lIrw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="iDECL/4g";
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772448049; a=rsa-sha256;
	cv=none;
	b=oE2lfNTNCblHq3ip2y2UPGMCn3ZvIx+soCItbA79oCI/V95P0Fr3Z9aTstPr/p7aT6Za9W
	Iuv/QisX/IojbSO1QPDWNb2YEHWYi+2R+p8tzoVRwyiBy4edAHe/1TOZA9WPABo0VXGhLT
	Gky+omMmeTpVmbJymgY5KcqGVqPy3kM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772448048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DRjABJuV2Sd1Oxa6l16+nsTcOydzZjarAC+otika62g=;
	b=iDECL/4gn5sK3e3chkA4NkhdkEqkk+/0EzJQ7eSZFbodKCGRg/+6vpnQboU6pB83bxOKF0
	zuC3OZlSrli/aAQIWj4TkUEFpGDBw+vhXH8SjKA2+fU7d/kJymKS2nJc84enCNWIsfx/mL
	vSz5dHckIOgi5t/Yi93BgbSs28fSvlI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-530-V6rEUoCTMDap6f52MtKzaA-1; Mon,
 02 Mar 2026 05:40:47 -0500
X-MC-Unique: V6rEUoCTMDap6f52MtKzaA-1
X-Mimecast-MFC-AGG-ID: V6rEUoCTMDap6f52MtKzaA_1772448046
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E27731956051;
	Mon,  2 Mar 2026 10:40:45 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.98])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6B5AB30001B9;
	Mon,  2 Mar 2026 10:40:39 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH 3/3] mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*
Date: Mon,  2 Mar 2026 18:40:16 +0800
Message-ID: <20260302104016.163542-4-bhe@redhat.com>
In-Reply-To: <20260302104016.163542-1-bhe@redhat.com>
References: <20260302104016.163542-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GI-JSbgBhv3f8cnUPmUVCmL2K7hlr_hjsgE94mFunAk_1772448046
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 752114000E
X-Stat-Signature: iauts8irreohhxxoh8nosnbpdadut9oj
X-Rspam-User: 
X-HE-Tag: 1772448049-880703
X-HE-Meta: U2FsdGVkX1/dus31A6f82mjLoDFFBZd8nN12Acf+RaTnUUCYyZ0Q/GrXCQQ9NgDuMjIDbcJcorz3kLsocJhiGHlN+IVEUQlDwYYSuHQWNbcqbd5ONk9ZgSpQXEWKUKRB684Pgyp7/OLpytz9hSz3rpaUQxeBuNRv88jSwcUYapJ5+bO8NiU5HaR/tRiL+kG51jqLXYTyBUftdA3ddPZcbF/w+IE9RN8EIrWtTgaQ9jotECWHMOPAO0X2vpY5GSbhpdulN/o0kku5YcBokoqqWVADg3Sa8nK8VO5opZ40ikpjnalOqEi1XMKkfD1XysBtkRFhSyZP8SvkHYILA98/wLSzs8A352iRHDT79YUUoyVe1z/16zDayODQxRFF8mZ/PeugLbldJpy6/MWbpjYZwwnm+X5xq4TkitqSLG5+hDaqprDtfiSMfQWEcAIPYparDFKAk9GODVLZFaIptXVy0HTx6usi0UhnLH9jfkScO0s/30P6mpPYJTrVq4xgVRT7Ie7X2C1CvB3PCUE0SPqgVyT1aspoJwjNoNexlsiUzEuY7xPktjiZ9QZDZ3wNIxoZTesG+VITsdJ3jiN69nSE1vbQ99uiwKG5hBrV8UUA94gt9SazNDdMcyhL11wdIJv5DAMZmskEcsKsrRu/uybSMmLgBylMDJoefArm1uVQnEXEJCapdZzEUZV+9WJ0DSglKQm5iMqfJVp2LpnBPOzGUItgcpvSEWUmSyqbRnKWQtjYX1OXnZThCmGEEZF62RpetbA68UmL6coOmgYwX76S9biqgToglhselqBGqz+6XnbJL7pns+dZV1tTheXguYT8qMz8y0B9ubVMYt1LGYYWNNP3W5L9+SedETI1iDeVnvZSJBnhIxIrNG3WbQaVN6n4EMoC8JXhDRmzDUy6Gp68NyeMVxE+ygK1eTaC+AL/nqgWMcJ9I6dHfXtsTxOPyLwGQJd1ZAhz97wzFDysoJR
 6u4UpWPQ
 ToXtWPoKXAgLTNvJlJTC3UhO4Zp0W/1INkeNmCjd52Qpf7jwA7RvOoGEfZN144Rqb28Af2lOEMu2hWoSM6Lu6h5AsZYZd8+u00UvKY89scnA0rouMYC24+ngHyz7oXUI/eOxJJ7mKjsqPy9WJjxOsh7spklC8H63gER0OBak+fknnrjSLtr4Z9UTlEVtUIRQwobj1NdSptcAgSgWYZwCeykSQOPkiXCNli2mYPtWxw7MEVpqZejSxBNDFNOEIVyu8VriItvZ+NLrnrz3gp4F8YjkT4f2szWt2LzeMOLgo80LXdGZz6fEDdXWc6+FbkLFhimovpz2268yInVrartyY8cNkhWtgQLLIRQ8g5y0rChIKz7fAmMSN99jH6Hx0vPqoWUgR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All these swap_writepage_* functions are hanlding passed in folio, but
not page. And this renaming make them consistent with the their
counterpart swap_read_folio_* functions.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 mm/swap_io.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/swap_io.c b/mm/swap_io.c
index 47077b345ae3..ad315b128e36 100644
--- a/mm/swap_io.c
+++ b/mm/swap_io.c
@@ -373,7 +373,7 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 	mempool_free(sio, sio_pool);
 }
 
-static void swap_writepage_fs(struct swap_info_struct *sis,
+static void swap_write_folio_fs(struct swap_info_struct *sis,
 			      struct folio *folio,
 			      struct swap_iocb **swap_plug)
 {
@@ -410,7 +410,7 @@ static void swap_writepage_fs(struct swap_info_struct *sis,
 		*swap_plug = sio;
 }
 
-static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
+static void swap_write_folio_bdev_sync(struct swap_info_struct *sis,
 				     struct folio *folio,
 				     struct swap_iocb **plug)
 {
@@ -431,7 +431,7 @@ static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
 	__end_swap_bio_write(&bio);
 }
 
-static void swap_writepage_bdev_async(struct swap_info_struct *sis,
+static void swap_write_folio_bdev_async(struct swap_info_struct *sis,
 				      struct folio *folio,
 				      struct swap_iocb **plug)
 {
@@ -593,17 +593,17 @@ static void swap_read_folio_bdev_async(struct swap_info_struct *sis,
 
 static struct swap_ops bdev_fs_swap_ops = {
 	.read_folio = swap_read_folio_fs,
-	.write_folio = swap_writepage_fs,
+	.write_folio = swap_write_folio_fs,
 };
 
 static struct swap_ops bdev_sync_swap_ops = {
 	.read_folio = swap_read_folio_bdev_sync,
-	.write_folio = swap_writepage_bdev_sync,
+	.write_folio = swap_write_folio_bdev_sync,
 };
 
 static struct swap_ops bdev_async_swap_ops = {
 	.read_folio = swap_read_folio_bdev_async,
-	.write_folio = swap_writepage_bdev_async,
+	.write_folio = swap_write_folio_bdev_async,
 };
 
 int probe_swap_fs(struct swap_info_struct *sis)
-- 
2.52.0


