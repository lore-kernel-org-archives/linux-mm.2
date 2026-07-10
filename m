Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DC0FC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 04:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0968D6B0093; Fri, 10 Jul 2026 00:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 020306B0095; Fri, 10 Jul 2026 00:53:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2CB66B0096; Fri, 10 Jul 2026 00:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA29C6B0093
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:53:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BB56168F69
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:53:12 +0000 (UTC)
X-FDA: 84971647824.13.B24D94D
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf09.hostedemail.com (Postfix) with ESMTP id 99A87140005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:53:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783659190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FpZD3/IyXww1cSC08JSY/hupkmNGYpp049TIahvnVLg=;
	b=a+adDJBgFFvIj+8qpA2+EX0MuqASrBSSo7roU72wi1LChJSzdT3K17unLekBUuX1sXrT90
	JiCPzyE41bSBNZv1nDnnzsfo4Lh2smVF/UjmuzhW9dvgun5grM1Jgy+qDlPeiEeJSQxbYx
	aV6Ex5NEk9uT5OtK/8dyvecFWK1PdP8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783659190;
	b=XpnXD1eO5cWnldDedARjdx8ndL2ZRFR8wfp+I67WdrKUAKUFqmOn2GLYGOtRxGSCwbCeNV
	AzxADZCmqRCgEbqhlPGQSyCD8KZzUQtRL4zFHr4tXbzQ7O3uTbjeuD6CDDINcUMZvxLN/Y
	skF5AhpP11GFa1sNWsNF9rRihdLkDK0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
X-UUID: 888efaa07c1a11f1aa26b74ffac11d73-20260710
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
X-CID-O-INFO: VERSION:1.3.12,REQID:df2420dc-be79-4755-81c6-07fe9a878936,IP:20,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:40
X-CID-INFO: VERSION:1.3.12,REQID:df2420dc-be79-4755-81c6-07fe9a878936,IP:20,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:40
X-CID-META: VersionHash:e7bac3a,CLOUDID:6ab51f0f0179adbd7711d247bca93c74,BulkI
	D:260710124803J08ENMYM,BulkQuantity:0,Recheck:0,SF:17|19|66|78|81|82|102|1
	27|136|865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 888efaa07c1a11f1aa26b74ffac11d73-20260710
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2000734830; Fri, 10 Jul 2026 12:48:02 +0800
From: Song Hu <husong@kylinos.cn>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 4/4] Docs/ABI/damon: document tried_regions probe hits
Date: Fri, 10 Jul 2026 12:47:37 +0800
Message-ID: <20260710044737.561102-5-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710044737.561102-1-husong@kylinos.cn>
References: <20260710044737.561102-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 99A87140005
X-Stat-Signature: w7iu7ao7fz3zq38ei1tidajqoybgnqzf
X-HE-Tag: 1783659189-812395
X-HE-Meta: U2FsdGVkX19AXiQXoVf7PA8eR5Rk/YuqWcH/jYefj1M7vuHKvnVerUk5nCnQ+KEppkYT7PYHSf5tu//ceGmWOOXnfnbzFUC/bfPh2bWepY7ahtSKUGL4LHiKo+JG58j85msM/AUJUHb7nkY92aG6BigBuj2qfsfGbEMsPPHpGycG5n0ruThvswzYtDKa2kkkLDQm9jNe1mbo6UudwQyCWceqZ3cIHpPhLnxyGGS1zRxXVXX40A9/b3ElhM9hrWHagPEB47gm2uM244c0QyUWtClxuoehCEnwiGni4Kh6/9UsvmNARUThjKSVp9quaI+76fqHQbKDG6SWISuA3fA6/g/663bGfn5+8CnnkAC08JYPJ4vIpTvzQ4TGYzLgDDBjTHcqqpgPMwr0ghk1OgX56oasIYSBUNUzBVIVDMwHaAnitWn8eXieIX/1CdjonYkErtQCt0zME4bQloNuTZ8YmLZmvMFp3Rt1JuV3cHkf/ltvJmluOH3hpOI3DJPVZjrRz3rq/AdmrpQ+XFau9sU7Mm34ya6Xvg+OqknJBHNey80EJfDAiCjvWQr9Xq74maWXRGitTxEMwW/ID+6yT2IFg021iKPYKQnKqLokWAiuesjj1tNagqrVEckFjOt0bwjePcEB/FYdOKF6mSWwtUbKsboqbSKZtVq/YcFd9XBZpbEnXzOZAN/2zysQ/DPtwWWlkhP6DsSx5yotXnX3cZd8ilBHR/FHU8sgao98oxKI6S46wq3NptZezYUfoBVnk3/pGRXyEa5V5m2Gfgz4757uVStgQka7jLh8UrIUud3EmCXrptXPH48ISVCfS1fsKwB9hqzal/OkjUG47fC4o7VzlpBMcniDfgKS4yj8XGpDutaPq6hxlXoIKXjjVKbeKsO/TBqcd07E4eRSH2wU1WGt2bc9KENdEr8hFtPZ8ka2mf6BHmom9Mm2JxSV8MSoXUotT31PE433UKydnR/uqwH
 qcVwV20C
 VWGEYrZK2gt0067XwaUJnvvok6S+U69vlrDNSfQe+1gaNaI1T4eYbbsk7gVNVSVLbF7X0XORdiUco2tY/paL5uoKlUYJxRCLOWJwrtDxSf3pJ8WM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The 'tried_regions/<R>/probes/<P>/hits' file, added in commit
5b0de1bc3325 ("mm/damon/sysfs-schemes: implement probe/hits file"),
is described in usage.rst but missing from the canonical ABI document.

Document the 'probes/' directory and the 'probes/<P>/hits' file.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 7e8192527191..e8645f987fc3 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -644,3 +644,15 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the size of the memory in the region
 		that passed DAMON operations layer-handled filters of the
 		scheme in bytes.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/probes/
+Date:		May 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Directory for DAMON data-attribute monitoring probes of the
+		region.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/probes/<P>/hits
+Date:		May 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Reading this file returns the number of data-attribute
+		monitoring probe-hit positive samples of the region.
-- 
2.43.0


