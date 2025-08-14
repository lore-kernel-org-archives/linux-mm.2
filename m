Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D64A8CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 12:55:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758D190015B; Thu, 14 Aug 2025 08:55:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7023C900023; Thu, 14 Aug 2025 08:55:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F1FE90015A; Thu, 14 Aug 2025 08:55:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4062F900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:55:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1A91BA7C2
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:55:07 +0000 (UTC)
X-FDA: 83775358254.25.720BF3B
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8EF8340006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:55:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755176104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=/LBeC/sFvycLi2ZDPqcMqKehBoPdHJuf4jWos3nFQ2I=;
	b=dL5S9HUm/vNEAa/dIHbRfHLoJ8O3lGW4Zmlcd7/nLdeSNVGcUo8DiRdYuPEtUC8xwGuuX8
	TWPdqSyypIUUPLMDEvA/uXRsHbnc/ngSNro2ks64Tt5ioVALNcftPhfvKzvHqigXQqFS6w
	0+FR8u0wZYE0r+uELzwpMWWpb7x1lc4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755176104; a=rsa-sha256;
	cv=none;
	b=WznC97k7Kn2cJQwX2zJna9gD6JzAqdLxteAeDCntSwEUdKeiZ6GWOXieJ0PCVNuOXFWPtn
	9tRThYPZkV+cUNeGCVG3SUwNwtznPNzKuhUypW3AWRSBp6ImVleM5Ga5HOxGMGlxzUKnmY
	dajPGIynPijdXD/y4UcHCpZzb+8R6rM=
X-UUID: dc868c10790d11f0b29709d653e92f7d-20250814
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	OB_FP, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI
	AMN_C_BU, ABX_MISS_RDNS
X-CID-CACHE: Type:Local,Time:202508142052+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:bb09e0e0-7eae-448c-b7e9-d8971de9dfa2,IP:10,
	URL:0,TC:0,Content:0,EDM:-30,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,AC
	TION:release,TS:-35
X-CID-INFO: VERSION:1.1.45,REQID:bb09e0e0-7eae-448c-b7e9-d8971de9dfa2,IP:10,UR
	L:0,TC:0,Content:0,EDM:-30,RT:0,SF:-15,FILE:0,BULK:0,RULE:EDM_GN8D19FE,ACT
	ION:release,TS:-35
X-CID-META: VersionHash:6493067,CLOUDID:bc6ab4738009c0c691e99aff076c3681,BulkI
	D:250814205233GDSRJBYN,BulkQuantity:0,Recheck:0,SF:17|19|24|44|66|78|102,T
	C:nil,Content:0|50,EDM:2,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:n
	il,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: dc868c10790d11f0b29709d653e92f7d-20250814
X-User: lienze@kylinos.cn
Received: from kylin.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1942505116; Thu, 14 Aug 2025 20:54:48 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	shuah@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] selftests/damon/access_memory_even: remove unused header file
Date: Thu, 14 Aug 2025 20:54:16 +0800
Message-ID: <20250814125417.659937-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8EF8340006
X-Stat-Signature: 5y89bm3sfg6xzqzkeyhcsibqnbib8i7f
X-Rspam-User: 
X-HE-Tag: 1755176102-610526
X-HE-Meta: U2FsdGVkX19okYabxhzG2AkJNKBeYlT5JA9SeNXvqHz0E+Au46N4oAGIoHlfrxUA8dulJSMD4qOizTOJmAttGEPy6HIhWniEJ/waPVE6v2jOq6UHPXBc5CLVLqmQEQUGiFA0dnSMMIysbLWl+boNP60FWdjlFemkhTzK9PPIfJja+8+/K38sca+S8CihtsQJdldEoGKiNBIlEf1cs672wslt+ueET2xo63TVfGILylvhj1Ansg/Qy/yJKHqoWxgo2YxAFn9iMBksk29WNp2SVqwtjdyFmbXZqdIMrxyVdHR8ocLrQq+2+SQYIJGTszOVmAB/MYfnDfh4ZxDIGpav0nzbZSxTs2MdJFL4ujmSb7StPMl6qdVV4WrSoRR5tg968C8k7mUGpwOSFV4SwbAEwxxJvaEnQr+9M88WP+06tUcu0M60VScJFslFPeq9g6vXDe6z4hO/jsFzWR0bdWWF3JNzU4jiUwGC+7EDrcanCe6S/0tg4kWpvlYY0E9Hn0vhlRwr5yGd2H3i/lv+MTzC1g7y10L7bEYKAUR/mCx2+ejgNoaogmKPILld7HeoJ8I1ZDtUkmCVA2ffZBVx/FjJ6b2llX1IsxULPA1XAKyezBSu2iYIA0ETgoEBg+MmE1s5TWu/IdmKjAQ57mNuO1SjYuuShMhQKkxIkIgOMDig19UlMuqbxo2DUzT7cuGc6tAfjrVTktBy6CO6kv7YvKYvJ3HrpIpagT6RaN/yGBXDZUOnAFWJEsqFOAVThYCqIl89SQZZCzyyfG8TnPN11EDkztsC82CmH2OUTj++7z9utSfOl2QNF9jLlbk78VD88RZX8UCRzc6Iik1mDf1HHkN4Pp8vtbjgyI7x4hExNe34D1JWOuNAD9LT/uuIIiKuOaYGTjsIAS4uNKPEypoHu43hCVIrAUR/Q/T95u6FLCI0CXv78Vb2yBHSxQigC9kTurd/UMJBbwlLu8MEncYTOkK
 MWxdBq5s
 y7abriDuhDFGRV8lKFm6ydXtyoaAQgo77MEF1T44fWOl8Zvg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since the time.h header file is not actually needed in this code, we can
safely remove its inclusion.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 tools/testing/selftests/damon/access_memory_even.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/damon/access_memory_even.c b/tools/testing/selftests/damon/access_memory_even.c
index a9f4e9aaf3a9..93f3a71bcfd4 100644
--- a/tools/testing/selftests/damon/access_memory_even.c
+++ b/tools/testing/selftests/damon/access_memory_even.c
@@ -9,7 +9,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <time.h>
 
 int main(int argc, char *argv[])
 {

base-commit: 0cc53520e68bea7fb80fdc6bdf8d226d1b6a98d9
-- 
2.43.0


