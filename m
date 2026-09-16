Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B29C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:03:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077186B00B0; Wed, 16 Sep 2026 08:03:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1DC16B00B1; Wed, 16 Sep 2026 08:03:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6F46B00B2; Wed, 16 Sep 2026 08:03:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFABC6B00B0
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:03:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A034FC06F3
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:32 +0000 (UTC)
X-FDA: 85219490664.02.4E5F6B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B4C5C4000D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bpV1JWpL;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wH/HnScIECqzPez57vPSs9kJwAMAsBLZmPepnLoPjpM=;
	b=fpvKQL07CfGT3u8Q+1HxtMJ5jwCKE74VXoOcrwl0azEaPz7n4360hHLcKdEG2b2exY8yQ0
	gVyrFtkG4avh2m1DApw4nYAiZIYvKgV5j9b12RmUoikHFD4wCNfSv4xeQEhVO84P/JV1iZ
	3O6MQQ7znklePEcqrwIIUrcOP3mCdd8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789560210;
	b=hhAbq9F6sSWGvQtvP69PAyFBKHsSBAYaLi3S+slIesfzLqKlUM/TXWwZjY/nGh4mk/sq0t
	T240wvrsI77WEwVDHhy9Eb1mvCpReT4LMtqdxrwTV7d79kaDjwzntZDklxA28w8ZGtZ0zb
	Wc2Bn/YqsnBchRIrnePHj4L+PUS+WYM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bpV1JWpL;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B72D6053A;
	Wed, 16 Sep 2026 12:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04531F00893;
	Wed, 16 Sep 2026 12:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560209;
	bh=wH/HnScIECqzPez57vPSs9kJwAMAsBLZmPepnLoPjpM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bpV1JWpLM04RGbK5U4If2hI6Y4LcRDqVywq8G9ReCiaUs5k6T1WXMkizcMA2sGwrT
	 fyxRR86ZRwACtE+NEeay1nJlFxlRQZz/xKLMPc5+G0lR9kOn9EzCTbrit+M5SY0Qbm
	 WKNORYyiKnPyUikQfWoXOBJanlpL/617bbD+4jsT+AQf8PYpqjZLShaxlRgZ2yMKRD
	 vXrxwbnSVTVAbA+ibbwAVCOA930bkYfjO706qwTCT5h62Xkp1lC8Sk+2Gmx1NKMBWo
	 CLBLJIVOr0iQXie4vOUcd5eySMNYj5dxsGOWyYSLhnhy362ahS6tVZmaEcbX8YJ9S6
	 Huq6SnArIMgZA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 16 Sep 2026 15:03:11 +0300
Subject: [PATCH v3 04/13] s390/chsc_sch: Use __free(kfree) for synchronous
 CHSC requests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-s390-cio-ready-v3-4-39e4894637d6@kernel.org>
References: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
In-Reply-To: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, 
 Peter Oberparleiter <oberpar@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Vineeth Vijayan <vneethv@linux.ibm.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B4C5C4000D
X-Stat-Signature: ye86eb3oi5rutycta81nqpq7iwpj9hnb
X-Rspam-User: 
X-HE-Tag: 1789560210-799312
X-HE-Meta: U2FsdGVkX1/T7mHNqZQydibO7o4zzd8qdH5N09+bbpmTqm/jQOrUQAyfRjozs4vn4AAP4qKyVp6XJYFb25S63T8M71legi+fZy7eWVkIRm1Lfn0oKOyUJZ2qoD682ZZkj2tzTednEOuyvQeDE+zO43YYnnxSGtGVlQ6p74XUZB9d3xLq/hC9Ip5STMI2cWFoudCx1icG2v+8tDBWxPw7CoKw52+AlmYgHUtJ9gyli1zbqmoYQvn3IvOaF4s3QWDiAfANpzR+Yq61Uq9dSBGeKnubRkDTmQWOIPTuidGxc326xd0kloG72a6pzJuOIxPLJ/xuHSUdnxSD+AnBb84AVGYoub10HZpHsnjd9spNPlx6FviiSzUZB27za/u63X/R5NpBPjSk5IHZeNxGlqIcQHrAAVpKN+W6SuFd7SnftRtA89q8NhF9oPiTAz+TjvvdIg1PN/z910lTuH0a59vOVaRHOichRzRSQTFolOrZq3yhtA1cGVURv0M5y558rTDsbAIVGhAc3b/5lVl9CKGKU8tqPP56JatJxcqhVESeCsCOZtYw3jGkH94BUDfrE0KTIy6Z4xa6poAmpJR9qJw2YWBtWXckCcLNrFvONTd6O5iKa3IGIKOLINQA2Z7IYtN8wMxH8tDGeAMalqZvpC1nWSBADASgXsNBnSIgq5NEO1a5Eku+Y3I14n46WzUIVb2a42VrXiSQA1NmFWOMmaI8Al7sHpB0mlb1iR4SRo/qiCLa7UuTpBnNfAyP2XCzBsFMYljKStCyRzZRvFidWiMc2XjwC+6cJBnRL5shqYHpo+qUw17DLvikHWudKWGtwcrVPwKacPcSfCSzBKDuv4xKiPh6orJHAYtssC88GWfn6VkUfelKUfCEYwIIktsUS3l1kKBrkGGMA6qo474xDH0uumrSwlsws1a+Dgl4TAQAs9qZtrXeepUYNXOM4Uu/sRygl9YweKPtMXk0vnSjIcm
 A4aB1Rv2
 4kf7kVwAXO2A5ro2ZOW+rXxyAsImRNn5O4lw8D9jGw0CsIb/FV6aqfyp94ZRlVEoblmrNsRrNEGXzMSaQhh6bvPOFID+ziiZyTEqsQaZY+UusfCaf+OHKdky9e4TrVH/sI2WRs7kqkBjnIGpXhhlKIvCcxJNl2r/1k2NP26s2nN1OeZWorBXod4SbXv9AyAEJlxkTCMvACvMW9NnmaSlsJ9b6/9tWKrqduqssdvnoQDZYfNe7A1Zbp4KGCj0GRcaUHvEzdYN7CDalaNFj3TsEtRIoYIctuWdDQqYs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use __free(kfree) for local buffers in the synchronous CHSC ioctl
handlers and replace their cleanup labels with early returns.

Keep the asynchronous and on-close handlers unchanged.

Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/chsc_sch.c | 272 +++++++++++++++-----------------------------
 1 file changed, 92 insertions(+), 180 deletions(-)

diff --git a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
index c8d6871d1841e..225aaac7dd309 100644
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -15,6 +15,7 @@
 #include <linux/uaccess.h>
 #include <linux/miscdevice.h>
 #include <linux/kernel_stat.h>
+#include <linux/cleanup.h>
 
 #include <asm/cio.h>
 #include <asm/chsc.h>
@@ -389,39 +390,29 @@ static int chsc_ioctl_on_close_remove(void)
 
 static int chsc_ioctl_start_sync(void __user *user_area)
 {
-	struct chsc_sync_area *chsc_area;
-	int ret, ccode;
+	struct chsc_sync_area *chsc_area __free(kfree) = NULL;
+	int ccode;
 
 	chsc_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!chsc_area)
 		return -ENOMEM;
-	if (copy_from_user(chsc_area, user_area, PAGE_SIZE)) {
-		ret = -EFAULT;
-		goto out_free;
-	}
-	if (chsc_area->header.code & 0x4000) {
-		ret = -EINVAL;
-		goto out_free;
-	}
+	if (copy_from_user(chsc_area, user_area, PAGE_SIZE))
+		return -EFAULT;
+	if (chsc_area->header.code & 0x4000)
+		return -EINVAL;
 	chsc_log_command(chsc_area);
 	ccode = chsc(chsc_area);
-	if (ccode != 0) {
-		ret = -EIO;
-		goto out_free;
-	}
+	if (ccode != 0)
+		return -EIO;
 	if (copy_to_user(user_area, chsc_area, PAGE_SIZE))
-		ret = -EFAULT;
-	else
-		ret = 0;
-out_free:
-	kfree(chsc_area);
-	return ret;
+		return -EFAULT;
+	return 0;
 }
 
 static int chsc_ioctl_info_channel_path(void __user *user_cd)
 {
-	struct chsc_chp_cd *cd;
-	int ret, ccode;
+	struct chsc_chp_cd *cd __free(kfree) = NULL;
+	int ccode;
 	struct {
 		struct chsc_header request;
 		u32 : 2;
@@ -436,20 +427,16 @@ static int chsc_ioctl_info_channel_path(void __user *user_cd)
 		u32 : 32;
 		struct chsc_header response;
 		u8 data[PAGE_SIZE - 20];
-	} __attribute__ ((packed)) *scpcd_area;
+	} __attribute__ ((packed)) *scpcd_area __free(kfree) = NULL;
 
 	scpcd_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!scpcd_area)
 		return -ENOMEM;
 	cd = kzalloc_obj(*cd);
-	if (!cd) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-	if (copy_from_user(cd, user_cd, sizeof(*cd))) {
-		ret = -EFAULT;
-		goto out_free;
-	}
+	if (!cd)
+		return -ENOMEM;
+	if (copy_from_user(cd, user_cd, sizeof(*cd)))
+		return -EFAULT;
 	scpcd_area->request.length = 0x0010;
 	scpcd_area->request.code = 0x0028;
 	scpcd_area->m = cd->m;
@@ -459,31 +446,23 @@ static int chsc_ioctl_info_channel_path(void __user *user_cd)
 	scpcd_area->last_chpid = cd->chpid.id;
 
 	ccode = chsc(scpcd_area);
-	if (ccode != 0) {
-		ret = -EIO;
-		goto out_free;
-	}
+	if (ccode != 0)
+		return -EIO;
 	if (scpcd_area->response.code != 0x0001) {
-		ret = -EIO;
 		CHSC_MSG(0, "scpcd: response code=%x\n",
 			 scpcd_area->response.code);
-		goto out_free;
+		return -EIO;
 	}
 	memcpy(&cd->cpcb, &scpcd_area->response, scpcd_area->response.length);
 	if (copy_to_user(user_cd, cd, sizeof(*cd)))
-		ret = -EFAULT;
-	else
-		ret = 0;
-out_free:
-	kfree(cd);
-	kfree(scpcd_area);
-	return ret;
+		return -EFAULT;
+	return 0;
 }
 
 static int chsc_ioctl_info_cu(void __user *user_cd)
 {
-	struct chsc_cu_cd *cd;
-	int ret, ccode;
+	struct chsc_cu_cd *cd __free(kfree) = NULL;
+	int ccode;
 	struct {
 		struct chsc_header request;
 		u32 : 2;
@@ -498,20 +477,16 @@ static int chsc_ioctl_info_cu(void __user *user_cd)
 		u32 : 32;
 		struct chsc_header response;
 		u8 data[PAGE_SIZE - 20];
-	} __attribute__ ((packed)) *scucd_area;
+	} __attribute__ ((packed)) *scucd_area __free(kfree) = NULL;
 
 	scucd_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!scucd_area)
 		return -ENOMEM;
 	cd = kzalloc_obj(*cd);
-	if (!cd) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-	if (copy_from_user(cd, user_cd, sizeof(*cd))) {
-		ret = -EFAULT;
-		goto out_free;
-	}
+	if (!cd)
+		return -ENOMEM;
+	if (copy_from_user(cd, user_cd, sizeof(*cd)))
+		return -EFAULT;
 	scucd_area->request.length = 0x0010;
 	scucd_area->request.code = 0x0026;
 	scucd_area->m = cd->m;
@@ -521,31 +496,23 @@ static int chsc_ioctl_info_cu(void __user *user_cd)
 	scucd_area->last_cun = cd->cun;
 
 	ccode = chsc(scucd_area);
-	if (ccode != 0) {
-		ret = -EIO;
-		goto out_free;
-	}
+	if (ccode != 0)
+		return -EIO;
 	if (scucd_area->response.code != 0x0001) {
-		ret = -EIO;
 		CHSC_MSG(0, "scucd: response code=%x\n",
 			 scucd_area->response.code);
-		goto out_free;
+		return -EIO;
 	}
 	memcpy(&cd->cucb, &scucd_area->response, scucd_area->response.length);
 	if (copy_to_user(user_cd, cd, sizeof(*cd)))
-		ret = -EFAULT;
-	else
-		ret = 0;
-out_free:
-	kfree(cd);
-	kfree(scucd_area);
-	return ret;
+		return -EFAULT;
+	return 0;
 }
 
 static int chsc_ioctl_info_sch_cu(void __user *user_cud)
 {
-	struct chsc_sch_cud *cud;
-	int ret, ccode;
+	struct chsc_sch_cud *cud __free(kfree) = NULL;
+	int ccode;
 	struct {
 		struct chsc_header request;
 		u32 : 2;
@@ -561,20 +528,16 @@ static int chsc_ioctl_info_sch_cu(void __user *user_cud)
 		u32 : 32;
 		struct chsc_header response;
 		u8 data[PAGE_SIZE - 20];
-	} __attribute__ ((packed)) *sscud_area;
+	} __attribute__ ((packed)) *sscud_area __free(kfree) = NULL;
 
 	sscud_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sscud_area)
 		return -ENOMEM;
 	cud = kzalloc_obj(*cud);
-	if (!cud) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-	if (copy_from_user(cud, user_cud, sizeof(*cud))) {
-		ret = -EFAULT;
-		goto out_free;
-	}
+	if (!cud)
+		return -ENOMEM;
+	if (copy_from_user(cud, user_cud, sizeof(*cud)))
+		return -EFAULT;
 	sscud_area->request.length = 0x0010;
 	sscud_area->request.code = 0x0006;
 	sscud_area->m = cud->schid.m;
@@ -585,31 +548,23 @@ static int chsc_ioctl_info_sch_cu(void __user *user_cud)
 	sscud_area->last_sch = cud->schid.sch_no;
 
 	ccode = chsc(sscud_area);
-	if (ccode != 0) {
-		ret = -EIO;
-		goto out_free;
-	}
+	if (ccode != 0)
+		return -EIO;
 	if (sscud_area->response.code != 0x0001) {
-		ret = -EIO;
 		CHSC_MSG(0, "sscud: response code=%x\n",
 			 sscud_area->response.code);
-		goto out_free;
+		return -EIO;
 	}
 	memcpy(&cud->scub, &sscud_area->response, sscud_area->response.length);
 	if (copy_to_user(user_cud, cud, sizeof(*cud)))
-		ret = -EFAULT;
-	else
-		ret = 0;
-out_free:
-	kfree(cud);
-	kfree(sscud_area);
-	return ret;
+		return -EFAULT;
+	return 0;
 }
 
 static int chsc_ioctl_conf_info(void __user *user_ci)
 {
-	struct chsc_conf_info *ci;
-	int ret, ccode;
+	struct chsc_conf_info *ci __free(kfree) = NULL;
+	int ccode;
 	struct {
 		struct chsc_header request;
 		u32 : 2;
@@ -623,20 +578,16 @@ static int chsc_ioctl_conf_info(void __user *user_ci)
 		u64 : 64;
 		struct chsc_header response;
 		u8 data[PAGE_SIZE - 20];
-	} __attribute__ ((packed)) *sci_area;
+	} __attribute__ ((packed)) *sci_area __free(kfree) = NULL;
 
 	sci_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sci_area)
 		return -ENOMEM;
 	ci = kzalloc_obj(*ci);
-	if (!ci) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-	if (copy_from_user(ci, user_ci, sizeof(*ci))) {
-		ret = -EFAULT;
-		goto out_free;
-	}
+	if (!ci)
+		return -ENOMEM;
+	if (copy_from_user(ci, user_ci, sizeof(*ci)))
+		return -EFAULT;
 	sci_area->request.length = 0x0010;
 	sci_area->request.code = 0x0012;
 	sci_area->m = ci->id.m;
@@ -645,31 +596,23 @@ static int chsc_ioctl_conf_info(void __user *user_ci)
 	sci_area->ssid = ci->id.ssid;
 
 	ccode = chsc(sci_area);
-	if (ccode != 0) {
-		ret = -EIO;
-		goto out_free;
-	}
+	if (ccode != 0)
+		return -EIO;
 	if (sci_area->response.code != 0x0001) {
-		ret = -EIO;
 		CHSC_MSG(0, "sci: response code=%x\n",
 			 sci_area->response.code);
-		goto out_free;
+		return -EIO;
 	}
 	memcpy(&ci->scid, &sci_area->response, sci_area->response.length);
 	if (copy_to_user(user_ci, ci, sizeof(*ci)))
-		ret = -EFAULT;
-	else
-		ret = 0;
-out_free:
-	kfree(ci);
-	kfree(sci_area);
-	return ret;
+		return -EFAULT;
+	return 0;
 }
 
 static int chsc_ioctl_conf_comp_list(void __user *user_ccl)
 {
-	struct chsc_comp_list *ccl;
-	int ret, ccode;
+	struct chsc_comp_list *ccl __free(kfree) = NULL;
+	int ccode;
 	struct {
 		struct chsc_header request;
 		u32 ctype : 8;
@@ -681,7 +624,7 @@ static int chsc_ioctl_conf_comp_list(void __user *user_ccl)
 		u64 : 64;
 		struct chsc_header response;
 		u8 data[PAGE_SIZE - 36];
-	} __attribute__ ((packed)) *sccl_area;
+	} __attribute__ ((packed)) *sccl_area __free(kfree) = NULL;
 	struct {
 		u32 m : 1;
 		u32 : 31;
@@ -700,14 +643,10 @@ static int chsc_ioctl_conf_comp_list(void __user *user_ccl)
 	if (!sccl_area)
 		return -ENOMEM;
 	ccl = kzalloc_obj(*ccl);
-	if (!ccl) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-	if (copy_from_user(ccl, user_ccl, sizeof(*ccl))) {
-		ret = -EFAULT;
-		goto out_free;
-	}
+	if (!ccl)
+		return -ENOMEM;
+	if (copy_from_user(ccl, user_ccl, sizeof(*ccl)))
+		return -EFAULT;
 	sccl_area->request.length = 0x0020;
 	sccl_area->request.code = 0x0030;
 	sccl_area->fmt = ccl->req.fmt;
@@ -728,61 +667,46 @@ static int chsc_ioctl_conf_comp_list(void __user *user_ccl)
 		break;
 	}
 	ccode = chsc(sccl_area);
-	if (ccode != 0) {
-		ret = -EIO;
-		goto out_free;
-	}
+	if (ccode != 0)
+		return -EIO;
 	if (sccl_area->response.code != 0x0001) {
-		ret = -EIO;
 		CHSC_MSG(0, "sccl: response code=%x\n",
 			 sccl_area->response.code);
-		goto out_free;
+		return -EIO;
 	}
 	memcpy(&ccl->sccl, &sccl_area->response, sccl_area->response.length);
 	if (copy_to_user(user_ccl, ccl, sizeof(*ccl)))
-		ret = -EFAULT;
-	else
-		ret = 0;
-out_free:
-	kfree(ccl);
-	kfree(sccl_area);
-	return ret;
+		return -EFAULT;
+	return 0;
 }
 
 static int chsc_ioctl_chpd(void __user *user_chpd)
 {
-	struct chsc_scpd *scpd_area;
-	struct chsc_cpd_info *chpd;
+	struct chsc_scpd *scpd_area __free(kfree) = NULL;
+	struct chsc_cpd_info *chpd __free(kfree) = NULL;
 	int ret;
 
 	chpd = kzalloc_obj(*chpd);
 	scpd_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
-	if (!scpd_area || !chpd) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-	if (copy_from_user(chpd, user_chpd, sizeof(*chpd))) {
-		ret = -EFAULT;
-		goto out_free;
-	}
+	if (!scpd_area || !chpd)
+		return -ENOMEM;
+	if (copy_from_user(chpd, user_chpd, sizeof(*chpd)))
+		return -EFAULT;
 	ret = chsc_determine_channel_path_desc(chpd->chpid, chpd->fmt,
 					       chpd->rfmt, chpd->c, chpd->m,
 					       scpd_area);
 	if (ret)
-		goto out_free;
+		return ret;
 	memcpy(&chpd->chpdb, &scpd_area->response, scpd_area->response.length);
 	if (copy_to_user(user_chpd, chpd, sizeof(*chpd)))
-		ret = -EFAULT;
-out_free:
-	kfree(chpd);
-	kfree(scpd_area);
-	return ret;
+		return -EFAULT;
+	return 0;
 }
 
 static int chsc_ioctl_dcal(void __user *user_dcal)
 {
-	struct chsc_dcal *dcal;
-	int ret, ccode;
+	struct chsc_dcal *dcal __free(kfree) = NULL;
+	int ccode;
 	struct {
 		struct chsc_header request;
 		u32 atype : 8;
@@ -794,20 +718,16 @@ static int chsc_ioctl_dcal(void __user *user_dcal)
 		u32 res1[2];
 		struct chsc_header response;
 		u8 data[PAGE_SIZE - 36];
-	} __attribute__ ((packed)) *sdcal_area;
+	} __attribute__ ((packed)) *sdcal_area __free(kfree) = NULL;
 
 	sdcal_area = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sdcal_area)
 		return -ENOMEM;
 	dcal = kzalloc_obj(*dcal);
-	if (!dcal) {
-		ret = -ENOMEM;
-		goto out_free;
-	}
-	if (copy_from_user(dcal, user_dcal, sizeof(*dcal))) {
-		ret = -EFAULT;
-		goto out_free;
-	}
+	if (!dcal)
+		return -ENOMEM;
+	if (copy_from_user(dcal, user_dcal, sizeof(*dcal)))
+		return -EFAULT;
 	sdcal_area->request.length = 0x0020;
 	sdcal_area->request.code = 0x0034;
 	sdcal_area->atype = dcal->req.atype;
@@ -816,26 +736,18 @@ static int chsc_ioctl_dcal(void __user *user_dcal)
 	       sizeof(sdcal_area->list_parm));
 
 	ccode = chsc(sdcal_area);
-	if (ccode != 0) {
-		ret = -EIO;
-		goto out_free;
-	}
+	if (ccode != 0)
+		return -EIO;
 	if (sdcal_area->response.code != 0x0001) {
-		ret = -EIO;
 		CHSC_MSG(0, "sdcal: response code=%x\n",
 			 sdcal_area->response.code);
-		goto out_free;
+		return -EIO;
 	}
 	memcpy(&dcal->sdcal, &sdcal_area->response,
 	       sdcal_area->response.length);
 	if (copy_to_user(user_dcal, dcal, sizeof(*dcal)))
-		ret = -EFAULT;
-	else
-		ret = 0;
-out_free:
-	kfree(dcal);
-	kfree(sdcal_area);
-	return ret;
+		return -EFAULT;
+	return 0;
 }
 
 static long chsc_ioctl(struct file *filp, unsigned int cmd,

-- 
2.53.0


