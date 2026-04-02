Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 759D4CC6B12
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 07:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF6916B0088; Thu,  2 Apr 2026 03:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA7806B0089; Thu,  2 Apr 2026 03:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9968A6B008A; Thu,  2 Apr 2026 03:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A90F6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:27:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 231BF140523
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:27:03 +0000 (UTC)
X-FDA: 84612784326.26.98D7487
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4A1272000D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:27:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mAQBrnTe;
	spf=pass (imf13.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775114821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mTjmxxQGIpdzFW5FWCBE7RIhDHSyBFWxxqNS0QNlPrY=;
	b=Rhqe4IOPhcrRaHvxYvZVhq2eNllABIv1KYVPaq9+7jMw5g+amFkOg9VzXXdUGHOQjOZVJI
	BJ7Id1Kuln9ELSJbL4pjTZGAa7F95ILKk1USIc3YdD1t/7sY0HVuPSXuCHjDTthd8lqUmQ
	CiF0SdMLd2uapgOxcgvYYmXz8kCjshs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mAQBrnTe;
	spf=pass (imf13.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775114821; a=rsa-sha256;
	cv=none;
	b=P+PocHplfoxBTsI2mPB1VgmMcXMAB+pbSVBdvs7ZvXkIK1VBGsLXoJJhl2YRZOk/QsHfpJ
	6oa4cmWpgmoc8p7ZVKngQ1vV44nMjZ9NFE/gUl+9QNKlo255AdXXG8+Pnl+9xRJnXV0OjJ
	TstyVYDjoMHbw8e2psW+tQlV6VnwQE0=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-486fb14227cso6957785e9.3
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 00:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775114820; x=1775719620; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mTjmxxQGIpdzFW5FWCBE7RIhDHSyBFWxxqNS0QNlPrY=;
        b=mAQBrnTeKV5OQC3o+pKqM/CN1ysjxX7BuIJf2m3YwKOLxmWEBkRx5z1M5sPeDlhXQb
         /b9n/7PA/fl+0c2U1Qsa9eczv8puEbZw51MJv87AI1vvIVE9RmSqByxot7fQiOeIuzZO
         ys5AJiNk36UZ7ed8aM0HeQLJAF+qHpCEMprQvO736mZsLASxsqCAKa+8E47GqFn/r8x3
         WLqqqjyqaR5sTNfkrgppY9ee1pbX+OXCzIY5ljyihNVjN8Kxn56yGYXBQXcs4aiZ7Ctg
         zgT0N54tvKH3BhLrNoTO5Y0/92wrbZ9v6cw9AyzQYXN7evHJ3rk2ZpAUkXk69BjVFiRw
         Kypw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775114820; x=1775719620;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mTjmxxQGIpdzFW5FWCBE7RIhDHSyBFWxxqNS0QNlPrY=;
        b=csSOrQvMHliOStH118LhcKlpR0ykzLb97IT4vfQN+M7KsHizfo9FlCqupVUcsKP1yJ
         lkSBM1VJ/9sAfE+GZ4eCN3qWMRONYQj2wcKbUaAjiR5euzcmVxuDghKTp5LoLBYtoSOs
         nRr+fiTQ/icOh4eb6JJErZKdnobXrcsTFr2INflihRAXBPAuBpSrPfVySCenV/XUiE5h
         pHqrAgN4i8abj+LO5s8NW8Rczjg6xAKfyjy5evhzwArrrpMRJSZPkogFETs/eKz7xIdN
         Hl+udq7OKtCMJ/O+NUh2gefdsf5E4ESr6B27yt3dP3e/Aw3/NztacWkhIA32VRfYG4hT
         ql9w==
X-Forwarded-Encrypted: i=1; AJvYcCU5iXDO9E4Mk4+SRZwPCcV7VxbIyqeI08vg3pHJ3CGd3KwrVlx3UqLWhHDKPoi9HI2XOUPdmZv2dg==@kvack.org
X-Gm-Message-State: AOJu0YwNcfy0IO7nmo31EKKIICXQkbeVU4P1CmbcGhDkp9lv0B/G+09g
	RDEZXihrLMIuXJIjJAjxylmg4pLBvSYS3c0H/yOwVMStuMPTyTVRLVKx
X-Gm-Gg: ATEYQzycNBiHedpA1psrJF3eUVwFJGt7bK5vxBkdeLMnRnBAFfpOg5ZC+sHscmUkiQm
	66yQAG4a1KyGkUPZ072jTFWtdUZZIx17AgVaok96ZKhJdYzfItLRXuwuWJ6yBvHHqzrkAPi/Hv3
	Y3gGCBF2lSOVD9v5Q2CInd5EJmZW5djruT5dOs2/1x3Zcj1ZJLuMmpd1GPBQ4k+/sO6YdpZFRFW
	lKQPYNmLig/yj8cUU4Ni55jVkCxKzfn4+BP/topr+Fm2APMU4XcHSkr/eIHvi6RDJNx0XNTRp/H
	RcDeO4VBa3Ehn1spcgC3io2h8UwzM0mUUqIuaYFn1TtZ42D1T//7u2m+00bRSahPKiHFz9MVwx7
	QVKoVzLBcaWfJAAJrlzVvp6Gynoby4Q6qpDI+q7i1HqhlEAbyz4bX9LmQNwdpPVe5iitk2MKgE8
	yjHqn6qStn0ipvu9HimNUVxT2MKSSosmy26aL2LL1e7ySAUZMHUIGQtsqs9NST7GVEzivjhYKsP
	FkdR7v/LEdy
X-Received: by 2002:a05:600c:4704:b0:486:fcc7:d6a with SMTP id 5b1f17b1804b1-4888358931fmr107340145e9.13.1775114817821;
        Thu, 02 Apr 2026 00:26:57 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887e80a616sm280661805e9.2.2026.04.02.00.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 00:26:57 -0700 (PDT)
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
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v5] mm/page_io: rename swap_iocb fields for clarity
Date: Thu,  2 Apr 2026 08:26:50 +0100
Message-ID: <20260402072650.48811-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A1272000D
X-Stat-Signature: c46enijwbaw46arqhx9ws64r4mu9xx44
X-Rspamd-Server: rspam06
X-HE-Tag: 1775114821-583701
X-HE-Meta: U2FsdGVkX19DZf0oC0JE6wssBLYBEOr7sB0we8BvckfMzQjp8KT4pyzu8Tyqft/+eoc0wjHhPt2h3BtN+d6kudgyhcO7kCCeOqFsUAcInbIBL+7Mk/WZ1hKI6j6rCV0tvVu9tRBRDEwhY7DRuqpKYaF38xFa1MHk81y0nEHO+JZ0MUV01mBgT3zg+Lhdp1jq3RcG+JnurdmLxC5uNiz4bQ12P2X4Vv/0TkRu5sNc64pzVKNwkXSgLaaFGWuOZSFvvw8pYaH96U37ofh7S6KlTZkvZ60lcY573K3fERG/ZM9zFP58TXMmQDa370hKtwjEQEAT7WCdVSdbI8OTHFlCHpBPsJTiUw50zkfg2dk7XifnogmvB3eCCVPABRwdcMf5oRty3q44BdhNPEKbCc7UkB3zt5HYumyEVtvWS8LqXpFdsgF8QisZsza8F52rrX93KyQIUrvIcScH98OgyOeF2wsjk9gEDFGxhKSuyZmwZjR4R/Gn3Ofr0WAt/8thGwQIevOFJ0KwvHN3LUSpJoQEXL9DC9Y4citphez03w6HHB0l3ifjzZNxRZh4gLnx0xf++ZaOID3Lz2YwnNPmjOmOIbsoD+GdrBQt+VF3MAdxVQgfQBpV6qg8/L66kLdHCf2arT+jx7lbiLIPsMLYNYKp0yy5z5yIu2ZPYmirrlyb3DyJKYbUjZ+8gU5nWYmBaDcGJOILTKjRS8Zm4GSSiopCLC8GDmkNRpJaImX4Hk25R34gROOioptV/quxG9NSTPKpMIFSZtwVPzhmVtzSXyOIP8PrK1TBMCkdL0mZcqNnd1anLqYWNuMo0seGmXouzdk+M670os7i0j2G6jvlnDFGd5eczHcRnxEdI2dsdgIrioFZyUw2wFJTc06sw6YbBAssIPfoB8XczopgFpsR6fQ6Mrv88nf097K57DTv4sDmlVCzYey4hsjbGPa2661OItvfbcYY5FQw5MhII+8ZADE
 eGo/6SJ3
 lN24CxrvY2as1ZeSmW/OIbh7iCuKPM+/D4TjpW5bbkEwIXpl12xW7JRBauC2Ra2GGS0pBiwJZXwOX0VXHVQJQXhJeDpvecz2mUeFEr3wr3tUZs5+4bsETaMcSLyaBdkrkPxRJxKJsFDBLF0vcj5SwDOKNlhX5ki/4WHMTXhGVsftAVoiqbGaa4ZBDUQmf+GXlP0/NJUdn+pRFazGlXAY94A6ikyfl9PfYT/WQjFUSIc5ZlVprgeLv7+DLjtHz2Ja1j+CLz5maWMkKZMi2uoSXQPqNUghmpe9cD1uLBvH91464pSEJycUO3fPLtgHHGJXZvWElsXO86kWfCfUI3UBsCzGlMxIfrkkFEzMPzEAlPgmbcS9pLZW3xUrNvTW5yg07r39HW7BrdF/KGxkmNmX/ny1QORp5Ud/77II8QnmqX56dzGED1dfotZmBCXMblpn316eShj7DH21ZE4rz5Q6o3BHg46bwfYVK2YwISNuRaWADwn19IyRRO/AWMtcmRsltn6q6U3B2nbjWRYIjJHFpgjA2JtielENuc9QPsXlQIPOZAJDg043MqI7gG8Z7mCKXu6aYpw8fedIPYUro0Ynj+3UyMr86QInhH9Pvq/hDiCUyoh0gxst/x+N3iA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swap_iocb->pages tracks the number of bvec entries (folios), not base
pages. Rename the array from bvec to bvecs and the counter from pages
to nr_bvecs to accurately reflect their purpose.

Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/page_io.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 1389cd57ca88..18ff6f559cbd 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -326,8 +326,8 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 
 struct swap_iocb {
 	struct kiocb		iocb;
-	struct bio_vec		bvec[SWAP_CLUSTER_MAX];
-	int			pages;
+	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
+	int			nr_bvecs;
 	int			len;
 };
 static mempool_t *sio_pool;
@@ -348,7 +348,7 @@ int sio_pool_init(void)
 static void sio_write_complete(struct kiocb *iocb, long ret)
 {
 	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
-	struct page *page = sio->bvec[0].bv_page;
+	struct page *page = sio->bvecs[0].bv_page;
 	int p;
 
 	if (ret != sio->len) {
@@ -362,15 +362,15 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 		 */
 		pr_err_ratelimited("Write error %ld on dio swapfile (%llu)\n",
 				   ret, swap_dev_pos(page_swap_entry(page)));
-		for (p = 0; p < sio->pages; p++) {
-			page = sio->bvec[p].bv_page;
+		for (p = 0; p < sio->nr_bvecs; p++) {
+			page = sio->bvecs[p].bv_page;
 			set_page_dirty(page);
 			ClearPageReclaim(page);
 		}
 	}
 
-	for (p = 0; p < sio->pages; p++)
-		end_page_writeback(sio->bvec[p].bv_page);
+	for (p = 0; p < sio->nr_bvecs; p++)
+		end_page_writeback(sio->bvecs[p].bv_page);
 
 	mempool_free(sio, sio_pool);
 }
@@ -397,13 +397,13 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
 		init_sync_kiocb(&sio->iocb, swap_file);
 		sio->iocb.ki_complete = sio_write_complete;
 		sio->iocb.ki_pos = pos;
-		sio->pages = 0;
+		sio->nr_bvecs = 0;
 		sio->len = 0;
 	}
-	bvec_set_folio(&sio->bvec[sio->pages], folio, folio_size(folio), 0);
+	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
-	sio->pages += 1;
-	if (sio->pages == ARRAY_SIZE(sio->bvec) || !swap_plug) {
+	sio->nr_bvecs += 1;
+	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs) || !swap_plug) {
 		swap_write_unplug(sio);
 		sio = NULL;
 	}
@@ -477,7 +477,7 @@ void swap_write_unplug(struct swap_iocb *sio)
 	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
 	int ret;
 
-	iov_iter_bvec(&from, ITER_SOURCE, sio->bvec, sio->pages, sio->len);
+	iov_iter_bvec(&from, ITER_SOURCE, sio->bvecs, sio->nr_bvecs, sio->len);
 	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
 	if (ret != -EIOCBQUEUED)
 		sio_write_complete(&sio->iocb, ret);
@@ -489,8 +489,8 @@ static void sio_read_complete(struct kiocb *iocb, long ret)
 	int p;
 
 	if (ret == sio->len) {
-		for (p = 0; p < sio->pages; p++) {
-			struct folio *folio = page_folio(sio->bvec[p].bv_page);
+		for (p = 0; p < sio->nr_bvecs; p++) {
+			struct folio *folio = page_folio(sio->bvecs[p].bv_page);
 
 			count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);
 			count_memcg_folio_events(folio, PSWPIN, folio_nr_pages(folio));
@@ -499,8 +499,8 @@ static void sio_read_complete(struct kiocb *iocb, long ret)
 		}
 		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
 	} else {
-		for (p = 0; p < sio->pages; p++) {
-			struct folio *folio = page_folio(sio->bvec[p].bv_page);
+		for (p = 0; p < sio->nr_bvecs; p++) {
+			struct folio *folio = page_folio(sio->bvecs[p].bv_page);
 
 			folio_unlock(folio);
 		}
@@ -559,13 +559,13 @@ static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
 		init_sync_kiocb(&sio->iocb, sis->swap_file);
 		sio->iocb.ki_pos = pos;
 		sio->iocb.ki_complete = sio_read_complete;
-		sio->pages = 0;
+		sio->nr_bvecs = 0;
 		sio->len = 0;
 	}
-	bvec_set_folio(&sio->bvec[sio->pages], folio, folio_size(folio), 0);
+	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
-	sio->pages += 1;
-	if (sio->pages == ARRAY_SIZE(sio->bvec) || !plug) {
+	sio->nr_bvecs += 1;
+	if (sio->nr_bvecs == ARRAY_SIZE(sio->bvecs) || !plug) {
 		swap_read_unplug(sio);
 		sio = NULL;
 	}
@@ -666,7 +666,7 @@ void __swap_read_unplug(struct swap_iocb *sio)
 	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
 	int ret;
 
-	iov_iter_bvec(&from, ITER_DEST, sio->bvec, sio->pages, sio->len);
+	iov_iter_bvec(&from, ITER_DEST, sio->bvecs, sio->nr_bvecs, sio->len);
 	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
 	if (ret != -EIOCBQUEUED)
 		sio_read_complete(&sio->iocb, ret);
-- 
2.53.0


