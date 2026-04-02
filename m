Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D47F0CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C73A6B0089; Thu,  2 Apr 2026 02:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09DB56B008A; Thu,  2 Apr 2026 02:14:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA75F6B008C; Thu,  2 Apr 2026 02:14:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB1326B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:14:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A25159019
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:14:17 +0000 (UTC)
X-FDA: 84612600954.10.F48464C
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9259580004
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:14:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="N6/Gg5tu";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775110455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GVqIzm8m//ymXBpB0pyluskL8sS6UcY+x4y2VchiXAs=;
	b=eKsSpXmBbt+cFE1Z2cMkf5EfULPhsLJ40ahzHCDw0eCLaTQ6lfqk3pXA2WrXkEs3cJpy6Z
	A4tPP/7aPFdOhXIPi/er9D+E2YA8qrWSei+vuZ5ojdYN9PoWk7cVyqa2F9D6+nm7uWzu+8
	7l526Ieoi+vXsiVrQ7Edj7OK8E+diS4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775110455; a=rsa-sha256;
	cv=none;
	b=5IxKNN+UV9wX4Kfrd1Zmrl6/hn6S82VuZ3RHmHT/pGwk7d3fS1UWHJPyuobuBTddLY2CBw
	c0K+PwuSLv/WyN40YHlVMYj4HozzpAcNUhAGg7zAXELsdRELNJ6e6PFhDEZOAAIGYZvo5S
	cf+kixNJFAocQvXwoRTYoH3ikRDxP1M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="N6/Gg5tu";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=devnexen@gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-486fd3a577eso3795585e9.1
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 23:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775110454; x=1775715254; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GVqIzm8m//ymXBpB0pyluskL8sS6UcY+x4y2VchiXAs=;
        b=N6/Gg5tuInXtlhm91ROnKyjM1o86/f2e2T2qpv4TAbXa6sYK4nSOuZDAcPwHV2yaC2
         eePpkMRX2Mp7vFjFew2FJigHKRHcYUNHkJbSmZ/2tZIrZdMpFvW3NhezNPeIT//pSJZO
         9PdRY4iVvZ8K14i8mdw8uhZhnkZDNF5qEUGXGoWdOXw9nMhMl2CSZsuwAMWQnCnX0qPt
         K4Tkw/prh4RoWUfUO5UhWQnkT7KPmxMInkfBtkNaK4ZhhGl82Lu02/NVExV5uwB2+3SU
         6rnj5mGdBZMk5I+4h0MPToFfDFk/+vSHcivPlnriPg+luOFKB1QfLy5y/6JnR+J0/CBg
         klhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775110454; x=1775715254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GVqIzm8m//ymXBpB0pyluskL8sS6UcY+x4y2VchiXAs=;
        b=XiKao6g4ctez/wSkaqYcDKp5VMktltB+RpDcwdER/iiToWYBspBhVTGaCsUmcDM9xO
         HfskQryPjK0f1ZrXDUZfnJS3OTgyiEoGkMD9bNEb3QeOECybk6BLORRncFM2YbSx434a
         YTYbAFCaS4lNzYAVT1K3UFUUYXjwKj8KYT+CCVoMz+2zS9xv34kB5L2Rli+H0qEMzjna
         83yLbnoN3f4GGNeinzTKWNveGG0Qm6Xy1gqAXWmxTRvahcT7JbUDTFBxXbuhRuQRyNkM
         SYTWA9OmSkXtLl1cZfBmT49TGtMCH2qXm1EUBV6M6TrJYfA7TbNQjXzcGGfUGpyHzCov
         MrYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbrTFDLrjFVSbAaOvTCJPAePLg92+LakRSmI91xMbogMartcY4rwePnbg6Z8q2895ZSe3+20cMKw==@kvack.org
X-Gm-Message-State: AOJu0YxzRBAi3hwmNjfryM27H9q79LoxvHgWDLeAbQXVie2e5dsCbsM7
	jWD3T+efji7P89yO+gdhMEx9/XU5a/U5pL/APdCXTYtiOBdKkuNHldyf
X-Gm-Gg: ATEYQzy21g5pY5P54t+Yao9x2MwYojC3KBqrtaFckzFyO6P18XuGNQ5U1A2mUVKZvNG
	mqSDrWHcf7fyz1P5ha56fNouHLI0xEdgy3QuXmYFGGBgix3QQ4Ql/w+uFL+VrxppzzSUiOPau0m
	N9mEo/ulyLDyjAv1pOyRq71YXnkEHvlnpvwIgOJ0hX5RY40PaUikaoWAUSRdExFvoMPZKxNINtq
	jnLM5d5Bq8NXHfiQLlBdtDzC+jjVHtPbDHmj5IlXATTV5iaI+5MoaGLi6tr2XuoSPofFa+b6Bh7
	Wd2lN9BkZooooVo/QvZoRszoElHWBRuh3gXusmuz93P/+CKJJtXofBIKv2Wim19zIWYiuoVEr+A
	Y9NtqfT4kBf/J3CicjsfztXJTayyPP2CDkNZyv2slbfxc67GArrJzc2kLYJBuRPrtu6Flr3r0Xa
	CNfpr7s0V+2JOyno2zURqRWgRSz/J0SNpz/BSaL40wcAN452zN2lY6StYfmZ8r0J5iGnYF02b9Q
	0mlMta7naui
X-Received: by 2002:a05:600c:1f11:b0:485:39d1:b4dd with SMTP id 5b1f17b1804b1-48883575eb7mr100478095e9.10.1775110453857;
        Wed, 01 Apr 2026 23:14:13 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887c8ee2d3sm61916095e9.32.2026.04.01.23.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 23:14:13 -0700 (PDT)
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
Subject: [PATCH v4 2/2] mm/page_io: rename swap_iocb->pages to swap_iocb->bvecs
Date: Thu,  2 Apr 2026 07:14:08 +0100
Message-ID: <20260402061408.36119-2-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402061408.36119-1-devnexen@gmail.com>
References: <20260402061408.36119-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9259580004
X-Stat-Signature: isoobs1fzcyk8941w6h6jtainyyeqisb
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775110455-904525
X-HE-Meta: U2FsdGVkX1/fwG3lTY/SOSTJ+slv+6M2W1ihXWTYUZhzzQXbyfcU5iKrfwKGOZ0YHnY2xuGbdEqnPZ4u1KWrH7Z6bm+7TQEDWE5sdppNueICpdLWIQymmV7HLNUr8AepQ+uK7Qy69QkoFOHRlbAYuqlvZ2DQIAZbOGbNHQJHEWQqozfY1u8tSA4JEhsWVgSWG5IYhVlh6hep6mGtwgmdS6+cb+Gam4WEGcBYFICbNfp2UVnrtzGeKBTZ8Y7bGv9JUqawD7TI3wK0nHYfjY6qt5A8ZmmC7w6QTPSKq5avxtsLfPmurAu4zXXDHbikzGqjOKQQpQL4QR+AelabvX8eQIhNwXqu+QOPxBF+Xkw2hW09W0HePB4xKzbRRHzfeXNGusq5+qYqZSp5IrPB4sUsipH9XYSeE09vIeC/czjCA8X9/8uutXiZqKrK2caucLLY+1bR7vBegHIqlO0U7vn412gmek2AVjeLFREpb+UDg986FFJhr7oS4pW3v5m7B53J5S2KOfXSiuDNXgEB+f2sv2fl0boX+BOFnKgFyHCbws53Mx3cdo7iwRmIRu+UlV/TtBAQSywj87Q1d0IsRvsl8je3yUpsBBh8KgVA/oyZUOw+nSLJ1qVPe9/mMBRBT4FGDCYdO4SsRu2R6KFldps1PVNdSlnRQ62mpedl5UBkjijL9qiJGMJ+7T51RLCnkhJasZEaaJBNOtSNbhuKEBKtD3DrdKun25Kx2ce/QdTLuI/c/Bta9/POQnzmuQeda43mbDsdldhZo0gAhYy8uxC9OF8P/R3NX82ZC7tznaefW+7C9yx8q7mYSe/zdJVyUFmp/tpfR7z+LxTYlFYUBDNZoxBo9reJP96bqHlSCukeHQ5CFHb21zbTk9yeJbz/t24HL5MuKpsmRXOi7lDOxOt0unJgVnmn1Vkx6cIunVpVhIiQtrFVYprV0DpzvkdPTsGXCQOq8NDpMAkFq2zknDL
 X+E/S/zI
 OJyKP9dveIQhRHpG53WXfMPKbbfEUYihM/+C7PLfR2TCbYUmmDJmE87qIddBoCbPPZ3gNpvVltCBu1+YEgFazk3ohxLuS+roJURadBnerSSzhsZgzbf8fQPNBnnmIlrlmcpv7jnwwnbNsSSf8fyM95HGIkFNPtq3vWuLJiWUfZDHPuFWUvbrvF7RFe5AlZZFbCqYpBe2sSipXl8l7HjtK9BCzeSZ39fgxEQVmIFgXcmkuKiFQdCSD/cIFgQQvuKb9xFBDtRYo/7tQHuNP3XS9AuhGH++kFe4TGNvFKQ2ARRCIpZZWmgJZKUN2FVIpI7405Di/WiEcB0QWd2lBbuCaV3JRL41GW2edJb/80/N4ts0xbMNzhu43vSAbAvg2a4a2o2wf19i5yNXIpaUEkaWeL6LBMNbKJ2XUrXfj+66xLer+if8aFG5Ut0T7yK612hdDTrvyaZT8UPU3W4gKst5uISsBKz732LDf/xPGKv/WMBHQuuCJwzavnKMFvI5fyEG/7eBGN6QjVUA5nXM=
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


