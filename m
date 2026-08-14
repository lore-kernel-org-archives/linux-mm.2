Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 579F4C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 14:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204D96B0315; Fri, 14 Aug 2026 10:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DCDD6B06C5; Fri, 14 Aug 2026 10:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3786B06C6; Fri, 14 Aug 2026 10:54:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA3A16B0315
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:54:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E668E8016C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 14:54:49 +0000 (UTC)
X-FDA: 85100171898.08.62ECAD0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf19.hostedemail.com (Postfix) with ESMTP id 809691A0014
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 14:54:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786719288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=z7316QClM0NVqmRv0Ke7nmqf/etL3PXqAP5T63BGy8A=;
	b=nWCemDtzVOaNRI0gDS/p1vCFa9TyC4uXxuCMhQC1eAZK/BiSb/ag4RQkVooUTZjXdvVKKP
	m+ESbQX/lktDD0WL7FfbGVxpZt43t9zGZ7ezvSXtFM16RZoUeL/AbpREtzHs6Ub+irvX8U
	eQFdqLZSZ56YwMyrUxgGmZW3SIYLCpk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786719288;
	b=Og8JWDu1YOoWSrskDPEubu3INzlLvoOI2R51ccBmvQt9eKCMOkMJtMp3XalCFQ9ean6Z4o
	dxAyG+WIzWMBKT2iQe/N2spYVQPqnrk+/FyWjTKSZ7WToWwszg4JlGSvLf6jDbvDRgY+14
	mkff/HwumOlSjHc1iK7HX4EbVMWLkbY=
X-UUID: 0ede099897f011f19a56ed5b684f684d-20260814
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR, DN_TRUSTED
	SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD_SPF, CIE_UNKNOWN
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:d1a1be2e-dc37-4716-8c96-0f12715df988,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:d1a1be2e-dc37-4716-8c96-0f12715df988,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:85d6637386c9f1a391c82b250b9c79f5,BulkI
	D:260814225207IKVV92P0,BulkQuantity:1,SF:17|19|38|66|78|102|127|865|898,TC
	:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:
	nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0ede099897f011f19a56ed5b684f684d-20260814
X-User: lienze@kylinos.cn
Received: from ubuntu.. [(61.48.210.10)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2099589790; Fri, 14 Aug 2026 22:54:32 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] mm/damon/stat: avoid iterating targets in damon_stat_sort_regions()
Date: Fri, 14 Aug 2026 22:54:09 +0800
Message-ID: <20260814145409.553724-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 809691A0014
X-Stat-Signature: zodznbt334ffz83f9mtbyx7mj695k3ma
X-Rspam-User: 
X-HE-Tag: 1786719285-105860
X-HE-Meta: U2FsdGVkX1/3ePZdcUAtFB9IHm/lCF6hmQRpC8jLc548m5kXJcdK/ugxf9E1m9/G7pPtH3fB0AzqVEvgMLuIOZE5hRH4HwL6MFC0y+iY/IPueVMQtlmUdTVFMH9aXxwSIRFzW3sk/Texxc+L8iTSk+9q5FS6WeSRGL+plclBV7BNAyxTTzrI0cZscfWIVakvmGzTokMow56UO8y+zU2opawOJfP+0tSl9LOet864XNMq+/AY8mdnvC//Lj3Z4JEcAANZyErV2y9klz1v++YcktDKH8x5Umc/2Z2Te4zFHq0dFMi4qbES0m2QT6bWN5irG2MLcazkGryXUIEXWIuKK6Q8Xe9dYHeLEy5uGCxF9PW43JS4hwOe0IJ8zDZjSWBjKrwVurzCtMQuBpEtqTXesyBvZ+Ar7VD19Bar2TttKbqE+2v+BFspxTCQ9wXyZgvt+0fMVNutsrOrjdzs7eCemJoDf3UQRRdU9hm5AeW/qe8S77+EAkz6678B8N0OZo1V0Mup0n5Cr1pkIA9iUjGfl9ZeFI7lfKhvV76uudRHkCddhm5xvLAn9sdeoZA2McP6cD+ZkYB/GknPWkdMiNXGIg+5WnpkVqvSAdk570XuvvB9ElaqokbiCGWJjnqI8M14sDkucrfM8/XhNMDdLzLTOAqmxvOHAlwDo/z8s92BXRTKiss+0U8Kcb8QaNSFfzATXFEqM5UST6Z01P/X+pUES6Vda0DV5dCfxUp6T8jEhTs/UQWoz4g0B8WVX2AnJuC+m8yXdxrTUjpIeDqin/JMHIaMJZEozr7dNaBAB9s1i0h6tRJNgNRf4RzeJAUo1Ei4LBGJIJ2+SdD6B4sBKvMsAOm4adpsLGF1V2TvSZddze08XyH81ohKoJHPeQWfkKsgDZlHUzI9C4n2XGWfI0Zi5aFd0/Ug2sUBX7oiQk1qCu/zO6XdnE4vgo2M2AwJwT07qTOB43azVR/7a/msxQ3
 MPwISaTb
 HYDcnrlPLF+i48E66Rzmm+RWkh8z/JzXyJHi5pGCZSNCysFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon/stat module creates only one target in damon_stat_build_ctx(), and
the comment in damon_stat_sort_regions() already says so.  But the code
still iterates adaptive_targets with damon_for_each_target(), which is
needlessly verbose and adds an extra indentation level.

Just use list_first_entry() to grab the single target, with a
list_empty() check to be safe.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 mm/damon/stat.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index b05b68f73e10..c8b1e909bbac 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -91,16 +91,15 @@ static int damon_stat_sort_regions(struct damon_ctx *c,
 	unsigned int nr_regions = 0;
 	unsigned long total_sz = 0;
 
-	damon_for_each_target(t, c) {
-		/* there is only one target */
-		region_pointers = kmalloc_objs(*region_pointers,
-					       damon_nr_regions(t));
-		if (!region_pointers)
-			return -ENOMEM;
-		damon_for_each_region(r, t) {
-			region_pointers[nr_regions++] = r;
-			total_sz += r->ar.end - r->ar.start;
-		}
+	if (list_empty(&c->adaptive_targets))
+		return -EINVAL;
+	t = list_first_entry(&c->adaptive_targets, struct damon_target, list);
+	region_pointers = kmalloc_objs(*region_pointers, damon_nr_regions(t));
+	if (!region_pointers)
+		return -ENOMEM;
+	damon_for_each_region(r, t) {
+		region_pointers[nr_regions++] = r;
+		total_sz += r->ar.end - r->ar.start;
 	}
 	sort(region_pointers, nr_regions, sizeof(*region_pointers),
 			damon_stat_cmp_regions, NULL);

base-commit: 6c2cdf00fe5205942b5f29e16905603a1717b931
-- 
2.43.0


