Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBFACA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 12:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D367900152; Thu, 14 Aug 2025 08:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AB35900023; Thu, 14 Aug 2025 08:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C0FF900152; Thu, 14 Aug 2025 08:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C18E900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:18:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 21ABA1A0694
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:18:18 +0000 (UTC)
X-FDA: 83775265476.19.4D18FF4
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0FD41100006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:18:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755173896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=qjCpj8u9ytlU9t8OCL//hOEkIQoHbgFhL5D35o1dqs0=;
	b=llhEH5z8qt42BsV0WcXl7ZVv3wPVz0HjGfxfq4VBK3kLmEpSoqft4rZ2mYMuxkSUe5OTXI
	7E9uCxT3aFCEhNroESx/KFVa7GjV0UEOI/kqDyv4dVh4ycAMVOwoxb9GtBua/1DMujgaZl
	0ETjGmbWBVClKHRSHrFkwN3PjeHV5z4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755173896; a=rsa-sha256;
	cv=none;
	b=j13NjGBX876LPJUhL+bkt1BUofRvsiiRLuXCwJfQoHBMJwT9pz6mI3vkLjzdmECizZaycn
	o/LIH1Dow+3p4vVWbNYwwTMu3EoRU+UFXk+f8fQ02NwUaPlkcq2HAnBeVX/9dfwlVNg7/M
	7O5SIhZhnyQZPMw2LImn99Xvn8uLK3k=
X-UUID: b863c1ea790811f0b29709d653e92f7d-20250814
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI, AMN_C_BU
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:64577dd8-f7b9-4176-9b57-1fa45a86f7b8,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.1.45,REQID:64577dd8-f7b9-4176-9b57-1fa45a86f7b8,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:6493067,CLOUDID:a33802a226fed93bfa7516bd949f81a1,BulkI
	D:2508142015263G0WGKY2,BulkQuantity:1,Recheck:0,SF:17|19|24|38|44|66|78|10
	2,TC:nil,Content:0|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_FSI,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-UUID: b863c1ea790811f0b29709d653e92f7d-20250814
X-User: lienze@kylinos.cn
Received: from kylin.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2007450188; Thu, 14 Aug 2025 20:18:00 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] mm/damon/Kconfig: enforce DAMON_STAT when DAMON_STAT_ENABLED_DEFAULT is selected
Date: Thu, 14 Aug 2025 20:17:03 +0800
Message-ID: <20250814121703.648925-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0FD41100006
X-Stat-Signature: no661d95f66761gfrcr911tmoidxp7rx
X-Rspam-User: 
X-HE-Tag: 1755173894-488973
X-HE-Meta: U2FsdGVkX195V8ySCbaiGWAkvhBtNRHf6gqenqfgnJOJJ4Y5KzdUXz9TkinzGWHV2x6Zg3ynJuwfGtbc+8lY5dEpU7ChXTz+UUJGkjmSbbTlcQtpZJWyUAKnyGnsAXijX4a/ZSjDWj2FFUsOoI+RGrZtY7giltTILoKSAiWt6QZOEBny2iMKb1WZU8CBvDmzprnjrpEc6wkOLIAeRHtN2qWqVXJgAHLP9XMyjbiUTiZjvOmEyNMQkEI6VocFf6GLlPbNz4ZZI6S+YTKX0+kOdkQacpgBTzkNRPU9N+m5lYtQi0gOCHo6KSN9ZqHEkSovlAsTQbqE1eVJ2sOTkhLQiOP3Af/s04IU/84CxvOadRdUss5iBRINfZ0bGDsxgZEEWnyVuT4EKh7CgoYSqx+tbtRDkmo6WMvkTs2xlbBEKqqRE2eIHeAifLvPKgtO3roo0j+uGxZkhzv6vLqj973bxClGPDOAFhK6mGDSIr8mrvvkdmqD+PNDhg0f+wWU5eE/ZuNMOVyXIE/CstJxXzORjYFpripTQeQlOFTro4y9i4Kj/tGAxcUpcGANCFkoy80jD+yPZQUOZvnl40hn31dcS4LmM98iOOJtlFCG94H0pnkKr/opLiBjSFzg1+Hbwl1D/USUYRb2SnZolsXHaWvI8B3FCw4bS8US4TnhYk00/cmY9f4x781lmg+RkLCWtb8sWiW3NGDaW0ASQ8PYDwZ4ERF9CIrD7SaN5kEmueNmovO7ZZh8usQDw5rIhQIDbCCOn0oadwhJ8iPgzyBFx3RruTEhjEB4bJho46jZkxIJlGKEi9V+Q79IaXRDTUqjE+WNRq/9ja+xF6MlvCiYM5KpJDhjRVa+EXoeWI2CNRBdGA6uTJmyncks2nBd31hSsCk18+meUne9ARiLaE+oV3lXDBAbcWZEFBfnax+AMc2ASLzGrZEW4TTl1piH1VsBR0oSQPIC8c2z2PaTBBO4A8W
 kH9zU0wp
 O9v0iovbxNUXThCo0MpVg+wWIjKETr0g46Leleo3xfpUePF2a/yg4aElzZWbqAZJkZ/c1GC110+KnQgvQkHH1AbGPkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The DAMON_STAT_ENABLED_DEFAULT option is strongly tied to
DAMON_STAT -- enabling it alone is meaningless.  This patch modifies the
logic to automatically enable DAMON_STAT whenever
DAMON_STAT_ENABLED_DEFAULT is selected, ensuring functional consistency.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 mm/damon/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index b3171f9406c1..5bc71354e6f3 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -105,7 +105,7 @@ config DAMON_STAT
 config DAMON_STAT_ENABLED_DEFAULT
 	bool "Enable DAMON_STAT by default"
 	depends on DAMON_PADDR
-	default DAMON_STAT
+	select DAMON_STAT
 	help
 	  Whether to enable DAMON_STAT by default.  Users can disable it in
 	  boot or runtime using its 'enabled' parameter.

base-commit: 0cc53520e68bea7fb80fdc6bdf8d226d1b6a98d9
-- 
2.43.0


