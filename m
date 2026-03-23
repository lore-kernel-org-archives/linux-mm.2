Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78188EC01CD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:08:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA1606B0089; Mon, 23 Mar 2026 07:08:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D523E6B008A; Mon, 23 Mar 2026 07:08:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68906B008C; Mon, 23 Mar 2026 07:08:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B81C76B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:08:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 596C9C3488
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:08:02 +0000 (UTC)
X-FDA: 84577053204.14.CC051DC
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf28.hostedemail.com (Postfix) with ESMTP id BA2DEC0008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:07:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774264080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=0aNdsj8PaSEniXngWJbx8+5KoHYrzdhnzPiiCGQs3rU=;
	b=I6YpopTOigCDz/6Ig9EGau3bGDRwVqT2AWZXsjyXMmKAOgTfbGRzN8Rv6AiG8acS/WPAqD
	8T4yvAPD9vUgSyOpo+alO3AIEJ97XJ4OcQQOy7DKzcUbnsturN4dlmQQiRoUqhZ38ERhNG
	R0+rAEMsg5F8edrhU48ZHr5E+92GUpg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774264080; a=rsa-sha256;
	cv=none;
	b=5ymUK5bRSz03Nbtyg4du5ZDQ42cKORroUBz/7lvyQSZTUreLGzg9OqUOgROC/JOd8aPeVq
	HpGfbtPhbrC4bQHC/HrN4AQjPa+L9tM5TrjhQIdWgDyNHdBW2jdsO1mKURkgBZfIPTmNMn
	9VuKJ3W8hZgtLoaeVGK271EfPXIcEWI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
X-UUID: 890b5e4626a811f1a21c59e7364eecb8-20260323
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, OB_FP
	OB_IP, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_C_CI, GTI_FG_IT, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_BLACK, ABX_EXPLOIT, ABX_HEURISTIC, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:5b9dc39c-ea2f-4d79-a2f5-ca10e78a276d,IP:20,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:10
X-CID-INFO: VERSION:1.3.11,REQID:5b9dc39c-ea2f-4d79-a2f5-ca10e78a276d,IP:20,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-META: VersionHash:89c9d04,CLOUDID:7ba9168b06ca504ad819c938b622e2a7,BulkI
	D:260323190711XSJ8CHOQ,BulkQuantity:2,Recheck:0,SF:17|19|38|66|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:
	40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BR
	E:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 890b5e4626a811f1a21c59e7364eecb8-20260323
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.23)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1342572768; Mon, 23 Mar 2026 19:07:52 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: jianghaoran@kylinos.cn,
	Chenghao Duan <duanchenghao@kylinos.cn>
Subject: [PATCH v2 0/4] Modify memfd_luo code
Date: Mon, 23 Mar 2026 19:07:43 +0800
Message-Id: <20260323110747.193569-1-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BA2DEC0008
X-Stat-Signature: o7kzwcqxswwq6ppt6ncbezn6t8r9bmo1
X-Rspam-User: 
X-HE-Tag: 1774264079-944328
X-HE-Meta: U2FsdGVkX19036R7uK83Gutb0F0eAkst3SxP657KZ4N3/InKB6vQlkatbLD0yDjbz74t6XML+yxCK23QBjKNNZ4kd0IwZf+Bl368wkyAm1MbJkugBzMp+MkAWJ8S7cwvFEajBaVaO4bcDqD6l/ywdnkV0M3RbMaEIG//eOdVriyXeC5v/A2LT+tzwvbBUEY9ArxdQiljA2x2jKnwGb6G3wDup0/L3LEl8kEFEe0BCTauNX6wg6sw09vUzkciZhIAQ/qxTmYQGRg15PjfCCa1UPaZIodJniKv2qPWVI1PBxKCuKciPcJM1A0Oxe8yFOQ0CkbAKwUO2qcs1Dijb2W1DS2ZERlnL1wZHrt+SZ4/VlcIWOEB8q7wkBT3I9Plu1RhxUfGoZCzk2jUvg7mdJYYgGSp7jryyQh7lfDdB16PDEi/RPl4kdAbtr76UQAL453sclJFdR6GatyK76IYhd0+UCbnkaQq2QZMx0qW0PCiWL44H002GyhAhw9t3bvWTcDeoQ2TcFl4FBFIoLYYLW9uOG+QiR0Z7D7Lmk4Xsr/RcKKqRO6XHAA1ocOaGlTnalnleoAb6CzEZNUACazSEOxn5GTMrlL8EJaK3prDxSXf4KPiCGszoc1/AwL1RM4hT32biChtFa38O2YjkWG9WBzYJR4HJuBSZgwA1ltYNG3iRobxL0PO9tOMnxzl+texnI7Qk+cVkRdwmWBkuHganSlZRNgalnRpTHSqSUZYfu2lFuosX3d4lW2Y9s+kdMbdZZv2sVb6hqnG5eDrj79uxyZGcz8Gp6p7tubjxPVvZE95Fq+sb+xgAkGX5DS/doxwR7taCllAp/TaWh95b2LCrAG90g+ktXTMEGi/qwpZbimjJKMxzkeNN7tj2c5W7z+AcD7ZRn9Gj5PQ/cDeiwMER4ue6B4/1WoE+MHHLBWZ19vDt4a9Q3Wi1X2fcR6TyNgAVfzA7XYzsc0IGymd/AWj7Rx
 AezjplH9
 SeUyi9KsG3h7UKSzWTNC988tm9kQq5sl/2H510tJq8zN/NlKjd8qV4wXia9BxBsQZ2cG5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I found several modifiable points while reading the code. Please review.

v2:
As suggested by Pratyush Yadav, add patch
<mm/memfd: use folio_nr_pages() for shmem inode accounting>.
https://lore.kernel.org/all/2vxzqzpebzi2.fsf@kernel.org/

<mm/memfd_luo: optimize shmem_recalc_inode calls in retrieve path>
Same as V1, no logic changes; depends on patch #1 for modifications.

<mm/memfd_luo: remove unnecessary memset in zero-size memfd path>
No modifications have been made.

<mm/memfd_luo: use i_size_write() to set inode size during retrieve>
Add consistency-related descriptions to the commit log.


v1:
https://lore.kernel.org/all/20260319012845.29570-1-duanchenghao@kylinos.cn/

Chenghao Duan (4):
  mm/memfd: use folio_nr_pages() for shmem inode accounting
  mm/memfd_luo: optimize shmem_recalc_inode calls in retrieve path
  mm/memfd_luo: remove unnecessary memset in zero-size memfd path
  mm/memfd_luo: use i_size_write() to set inode size during retrieve

 mm/memfd_luo.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

-- 
2.25.1


