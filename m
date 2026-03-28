Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E3710BA45E
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 07:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 942446B009B; Sat, 28 Mar 2026 03:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 919A76B009D; Sat, 28 Mar 2026 03:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F2C6B009E; Sat, 28 Mar 2026 03:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 701736B009B
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 03:58:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1072EE1D98
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 07:58:41 +0000 (UTC)
X-FDA: 84594720042.20.200937B
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2B57B2000B
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 07:58:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rgzlK8RA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774684719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXhhgvgv1HNQy5Jtoy0WEWOi+G2ao/2SwUeB+IPvwPk=;
	b=EXfsXQHHw9QK8YC28ie8VnayBgTIaSPMy4y1TpR84ooXrS4slpzxbCD60Z5HS8bIgwyJsW
	Ih7bxTJ7cMb3jOTDAgqyuYulHmc0fY48qncpYDZ2WGlK7C0UX7+DMtb26dV2kDfx/KnRmQ
	Y3xoDrjQ81aIO4Z540m4EBZ/ZtAe2B4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774684719; a=rsa-sha256;
	cv=none;
	b=Ee+on8inngIcQQuFuTNsn2kOWCIyfypa9xGeHioUP9uYuD2AwMZyT/FNizpsUv6z3WVTFz
	vDTtpVrfH27YMIKPUbZEm3IzzJ5+dQ/fIEt3Iz5lUgzTO+avAF8Gg/hGuMwSROv3oPso3p
	TcNM/qiD1ueYy6j+aFDpbB0mO4dPVQU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rgzlK8RA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c73ba417c6eso1120418a12.3
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774684718; x=1775289518; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VXhhgvgv1HNQy5Jtoy0WEWOi+G2ao/2SwUeB+IPvwPk=;
        b=rgzlK8RAyNQceul+OP4j4jV+lqAz4Bcv8uwJtyM9iovgjRrUFevNczKCyHrgN99GA0
         2UK12L0Ewz1eq8nkCeTP2dIUhgN3Vw0zB60814LE3W/PBnrj7y3UsJwCo21JzIUcblLs
         79nqkbkRGT5IxcUHIHg3KOTx+MAho9jyK51aXyV/3SdZ81eVTtnlFWJz410P2dm+xVuo
         rrg4GZaryEKjUzBR5XZ7lDdarIWD+4a/CLKwdQ0lp1tzBe/682fv/wWy110c1dhiMbHF
         Toi+lAoT5ExE9qhNzrMTNKdpbLRwxmzUz1jjt0NFfqgKlZR0lBtkAdWNJ75IuNfz/maT
         izJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774684718; x=1775289518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VXhhgvgv1HNQy5Jtoy0WEWOi+G2ao/2SwUeB+IPvwPk=;
        b=Af8g9r7fXW7bG5UM1erp2k5tKCzPUz0CT4b0flrNBlVe3J5D5VVo1wWYwwB/+W3cvp
         e1dY6bStm8s8L8UH8pYJZfZU/8E0TGGVKxjbUcITPYUwlmh2ULpyKBliNtLJKCiHIjEX
         KbQXbn0p6ckz7MRB9oF3piNqs3P+1IPsdacwDEg58dQff8c6C3rGOHz9niBmT8+lzwHW
         Siw/ZUhDNYg0nau16VWgQ/mtALMusd5GzUkRtDmyTyK53Slc6QXlXMDJ/C3E8wtwsfwP
         MHtfqXBFxfI75j+wt+N7ihVUiWWHBn4m+fsLdCXk6puczJNgVSkGS/JKjuv2WMyPBRYR
         WabA==
X-Forwarded-Encrypted: i=1; AJvYcCXOuzHCBBt5DHoZiR0kupBYNlEbFANXSexCaK5eQsyG3F4UJV4Jbg5/frAPyaXExSlaTiMoUZXjRA==@kvack.org
X-Gm-Message-State: AOJu0Yx+njPYsDOORDsMkPBjbhle6ccP0375OryqqQluMJOGSYbklELQ
	Sz8VP5A91QqDDkdsoyaeS3QCR6HRk9GoAdfA5BmkUm6jLQiN8uzzkJbi
X-Gm-Gg: ATEYQzx2E/pnoQWrMdH4xFwRyoWZ+x+Eu3+FRsX0/Bu2xxYgF40y+ZXoQJMlrOmZu6W
	ijiBArEwsBGYbKNiU/APRqxH0PrO3iD/rPDavv+PwMHmy7IR/O59NVbuHC8ql6blRqkxUR9niu3
	zKWT31qAOCLYwNgbgnsP8J3+wYw3g+koyOEavzTE+7mOEH7o4efSGB+xgWFVzUALOq2zIUXVk4H
	SiX6jtckvaBG47JbzHpUj5kPqxfsJ68gxip9FSBQAXNJ+LFz7CJPGvBeRAv1OiGYFWEZoSTZs9v
	xHStFPnihwXc31ztlXltVvKlZrOq4FE+O/Vs8rOTL+WlMh15P4ydZskmODBW8oozWLCQbx44ZzZ
	/ZkrolKkz0LDxyLWU8IqEk7X95PHurSvL5l5JpRD3+fxnSVYuybJS1633vYv+/achRROUnzcpSe
	1L7Yibj6KuzQh5bY8OdyoWwPNXPWjnLI/oMNDaNxeQ4N96rF7Mj2XBWAymLxd50jPRxcvYV02TM
	HKAZmGiyJxRtKLC
X-Received: by 2002:a05:6a20:3943:b0:39c:50b4:cd50 with SMTP id adf61e73a8af0-39c87c4adcamr5626144637.61.1774684717861;
        Sat, 28 Mar 2026 00:58:37 -0700 (PDT)
Received: from Barrys-MBP.bbrouter ([2409:8a1e:2e90:6fa0:903d:bf86:180e:c711])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca84644d9sm1448312b3a.13.2026.03.28.00.58.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 28 Mar 2026 00:58:37 -0700 (PDT)
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: bhe@redhat.com,
	baohua@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*
Date: Sat, 28 Mar 2026 15:58:12 +0800
Message-Id: <20260328075812.11060-4-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260328075812.11060-1-21cnbao@gmail.com>
References: <20260328075812.11060-1-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2B57B2000B
X-Stat-Signature: u5w1cwwy9ns7jrct5xw1j5qg1t7epiy5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774684718-74043
X-HE-Meta: U2FsdGVkX1/oWLu+sX7gPY3+FnP16FaddIdu3gYVdFnBmCl9f6wlxfzmMZepWPBFEeaYlCDXctGWmwu29LMgo43MM/uktlvvRclL2EV2Sd6N6yhd9zl4/YcfzoDWaB9araNHexx0lZ46IJ+j+HfBAkEmnU5KfCeLhYg7o9fIVZU87d/exqhUFpYttUwNofDeErVARAwpKbIylUIMQtVVQ2hpixSZw2RY5X/XMP1RIqu1Kg20zYAYBo2Uv2eHE6e+QjgM8rfEwsXGDBf3Lk6+LyxjFrFZr7nx823jDdZFLFPAZ1/cNJ34OpNUbpuyaeSds61X4w7vkUmybrNYb7D3SLEjohGozHKHKs6iNwQLUXCxlalfOqdbOp1gfJW+0hBRKgK3kFhfSnQ6KjyO/8hZS2UFnUc2ZbdUejN8Xs98l5wLIfAIhyh9qUbNqVK89O3jWqupKF+or10gku65euiOUE7VR5E6kgHj2yVf+/b22AUEcVvZnooMOosEhoJciSxbTLyUHGBqcPrgdtB9NLVuFioNIzm3sLAe2vcma32H0JwdNv7gCuO2LBVt5z0ZFmcr+q7lbklsXUN3C7RUsPbDwfIeT2JCvgVwGuLhVDn3Pspz4Za2yw+/i/ilDonz3G8GmY/IrzT6wPMRzJotQbhk7C3XBbsLvp4t1Yp3FhgAvniPa4G+X20EvJFqk5M2PpabvbgS+fOqVJf5lV4RH6SFwSeczzh9h5ND6ufIlnBLDyYngIw6hz/mgucbe0cJcu/MSYOp/j1b0gr50CMuUgDWV0EJMsJ46QViBKzM6d+BepVuORWwyOGgjN5IJiXli+1GzPgY8/Yj3jKwVWx9oZmMWFyUa/+Q516T0CzWkjL5S3kaA05aPAmkDkqG+PgiW5EJboYnh3EtItVvnoTRiHHoT7vqMw+BsWRtv8kNWNrbncoOsUZCv8jfn1HPTXv0+sQJOBbMbX9K4Ygr3/T3Ltb
 gIKrBeA+
 ZnBKUv4oVmVYKgWE3UjvdWjzn3IXSk18/Cy+zNIwTIKLZmwhDp3Vaw2VcgA+RbJ4HIf0EPYT6cd5E7sBSkLb0I1Q2PgVkiTYtOTlNaKaHuDpUhB3F0deKYwqTaJ8Bm/VQJhuZeG384m5RjOXrBV+p2z2vRv9giPGDDDJGFqFAJ5HjISdgEuHgvhdysttD/qKqhRzLNs6Q7g0gQFZicmhN4G6uSID5GNDyYSOEirqiTt9FyvizV33CEBz7szPxopuofeqOS3g+njIQHPuygBxh70ZosdeEhXaup/6CxGgsZrBUTn2ahjHBFOr38koXF+jn6UFyN9H7KwMsgklmRNbCn3wFcn9DXUCinfK+O1nuAgd+weG8zeBLtn5YbukCQUDJXUDADyMVC8N4GNgBectmU5AHxoy74pzkSfL2h22tW8+x8PVuIvlMX8B5S/eObgh2Ak5okyPY09ao/etoB8H1EPPSoU+ZPEK6OG9gRS9FzRPMi54Dl+sHL0wq8q41bZqm2qbm8Y+rPWG2Xmc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baoquan He <bhe@redhat.com>

All these swap_writepage_* functions are hanlding passed in folio, but
not page. And this renaming make them consistent with the their
counterpart swap_read_folio_* functions.

Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Barry Song <baohua@kernel.org>
---
 mm/swap_io.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/swap_io.c b/mm/swap_io.c
index ad0895af6ed8..063cd005ca0d 100644
--- a/mm/swap_io.c
+++ b/mm/swap_io.c
@@ -375,7 +375,7 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 	mempool_free(sio, sio_pool);
 }
 
-static void swap_writepage_fs(struct swap_info_struct *sis,
+static void swap_write_folio_fs(struct swap_info_struct *sis,
 			      struct folio *folio,
 			      struct swap_iocb **swap_plug)
 {
@@ -412,7 +412,7 @@ static void swap_writepage_fs(struct swap_info_struct *sis,
 		*swap_plug = sio;
 }
 
-static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
+static void swap_write_folio_bdev_sync(struct swap_info_struct *sis,
 				     struct folio *folio,
 				     struct swap_iocb **plug)
 {
@@ -433,7 +433,7 @@ static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
 	__end_swap_bio_write(&bio);
 }
 
-static void swap_writepage_bdev_async(struct swap_info_struct *sis,
+static void swap_write_folio_bdev_async(struct swap_info_struct *sis,
 				      struct folio *folio,
 				      struct swap_iocb **plug)
 {
@@ -595,17 +595,17 @@ static void swap_read_folio_bdev_async(struct swap_info_struct *sis,
 
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
 
 void setup_swap_ops(struct swap_info_struct *sis)
-- 
2.39.3 (Apple Git-146)


