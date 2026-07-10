Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04C93C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 04:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F30E96B008A; Fri, 10 Jul 2026 00:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08676B008C; Fri, 10 Jul 2026 00:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1E646B0092; Fri, 10 Jul 2026 00:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C318F6B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:48:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BBA0168B9A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:48:08 +0000 (UTC)
X-FDA: 84971635056.12.2B98167
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf12.hostedemail.com (Postfix) with ESMTP id 63B4A40004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:48:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783658885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ge+W6TWrI3hOXJt7AuoH7kT7DoF7dk5WA+l5LE54fk=;
	b=bGZ+ezL10bjTs8Um53d0g8f0LME5d1XrIKE7gBDqr0EuaXnCnbPs3r6QBjPw/gV5GO0zjM
	WXOMIhX/gqM/1MlPnnBbOzRTj+RSABnLWXgORNge5MY/GhluGcoSKIDaki/F3ZihpqsxkE
	SdvRI+4dZx+BTm45LUTNbJ5trs1o/UA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783658885;
	b=IyzwpVlu0JC9Ze8UspcxGADxYy4TJs6zSeIrbF2SrB8v+rLd9NhsuY+qCfaJejXrefan7o
	slvP3/qO9x7t5N4ezZt8L9EijlQYeUETN5nr+7yo8fhyq6SyHO8XlOIu35E5oQZkQeE2Je
	HL9BmPtMCZMjAXnOkGQTxWVL++DgiZY=
X-UUID: 845d487e7c1a11f1aa26b74ffac11d73-20260710
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_UNTRUSTED, SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:9e76af51-41de-4cfc-aed2-34454bb41822,IP:20,
	URL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:20
X-CID-INFO: VERSION:1.3.12,REQID:9e76af51-41de-4cfc-aed2-34454bb41822,IP:20,UR
	L:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:819c28c2fb3c78a1d9ad3cdf9a1536f3,BulkI
	D:260710124757WD3NRJHV,BulkQuantity:0,Recheck:0,SF:17|19|66|78|81|82|102|1
	27|865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:n
	il,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BR
	E:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 845d487e7c1a11f1aa26b74ffac11d73-20260710
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1617764414; Fri, 10 Jul 2026 12:47:55 +0800
From: Song Hu <husong@kylinos.cn>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Song Hu <husong@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH 1/4] Docs/ABI/damon: fix typo in intervals_goal sysfs path
Date: Fri, 10 Jul 2026 12:47:34 +0800
Message-ID: <20260710044737.561102-2-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710044737.561102-1-husong@kylinos.cn>
References: <20260710044737.561102-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 44rir7ak3xyugbqw8bz39g6s5ixy1xdi
X-Rspamd-Queue-Id: 63B4A40004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783658884-378550
X-HE-Meta: U2FsdGVkX1+iSLfxoHUZGD8hQATJF6CHEvgtlXVqy0rVfPhDSIiX/O4BhLnsDou11kTYIhck2fJKhJVj47HxtwYJ4PsTVLM5sIaWbV1MUKFgiLiuRTwKv6Y2eek/SsSKpbWT/JAfgS94e2GVvUa231SkhxTW7RHzt5y8TN72Zb9cpDESmqFpTWaKTCwuuTbP9MQucCmjqawzq6nEg8I2+tdYX9h/A9axaYqe2A6Lcxm4sQWr2i4450wefwVKKGhwK3H5ShbVJRVX+3yQl7BiSLl0/n2SjZNIdT8JydITnsy7BFNFEQBbVKfHbTeI9xTtHFBQPiEpm/xaCVjr42dsmVNEszkxfr2sEYe/7W10j0LLGdQsZh+ai/c8gMHQ76yQznDpAmD+x5ueUAEXzvJuqZBj9R2KskNTl87qIksMU8bKyQr5360KC5cH+qL7xT4RylK84HL/0PRGZYOUQ6mq0poNes5zDs3iybHxMjJPh6WRQGwj+ofvM/OjhwczFJ/jzIMcntE2QWYzLip3BIh5RATN1D0bXIZV4LOfEGDYe3+yu7NK3YKaET7/6i+9DASwbj7KPLzPcRqMGJI1p8Iu7NYjpYjO2/Iz6+OL4rvHLU7O4+mq1Y6mZBbi+N6pLiRQyZZVk2JMhro4LW6hwtyL8wDF0G+/WypCNVcawJ97GS8mQm7eEk19NRXa03qZR8WdZUyftKpG+5GoiXktUDb7DC3uS+J1z8Fi/gTonbXwItdzdt2pAzWVP9yB26mp3z4xOUG8UhgLG9fKBXF1wvcsE7T07Gb/gVEn79WhPdvOBnL/7XLdocLToQY/nrZP7lR/TaWeJTrMGYq4s/vbrORDHqU3+rh5TbzaNkO0GdLpH+3yC7qQmp+ytYoXnoncbFFLGZpCSUsJAB1CYI0fS1UY12K+0Rr9mr3wPQK6VcquVVR+rllVPozhUcnzEw4s0wrRLjhieZV5daJSrxReflt
 dRUnIZTK
 KpwPfWM5XY3oW7yGGlzXNVxz7o9ft0XbCzi1M/xT6O2loi+JeuUYSMK7Qh7yje6eQxMYR7SbVoXZsVXM9bQ+At3fdsiVh6VcSIteMu5EKA2Hf0Rw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ABI document spells the DAMON sysfs directory as "intrvals_goal"
(missing 'e') in four What: entries, but the kernel creates it as
"intervals_goal" (mm/damon/sysfs.c).  Following the documented path
therefore yields a non-existent directory.

Fixes: e2b23dc62369 ("Docs/ABI/damon: document intervals auto-tuning ABI")
Cc: stable@vger.kernel.org
Signed-off-by: Song Hu <husong@kylinos.cn>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index dd6b5bd76e11..885409a26786 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -112,7 +112,7 @@ Description:	Writing a value to this file sets the update interval of the
 		DAMON context in microseconds as the value.  Reading this file
 		returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/access_bp
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/access_bp
 Date:		Feb 2025
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the monitoring intervals
@@ -120,7 +120,7 @@ Description:	Writing a value to this file sets the monitoring intervals
 		the given time interval (aggrs in same directory), in bp
 		(1/10,000).  Reading this file returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/aggrs
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/aggrs
 Date:		Feb 2025
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the time interval to achieve
@@ -128,14 +128,14 @@ Description:	Writing a value to this file sets the time interval to achieve
 		access events ratio (access_bp in same directory) within.
 		Reading this file returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/min_sample_us
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/min_sample_us
 Date:		Feb 2025
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the minimum value of
 		auto-tuned sampling interval in microseconds.  Reading this
 		file returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/max_sample_us
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/max_sample_us
 Date:		Feb 2025
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the maximum value of
-- 
2.43.0


