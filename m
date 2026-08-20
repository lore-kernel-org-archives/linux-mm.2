Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42B5EC5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 06:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54E7D6B009D; Thu, 20 Aug 2026 02:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FEC26B009E; Thu, 20 Aug 2026 02:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43C486B009F; Thu, 20 Aug 2026 02:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 22BC66B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:17:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3B08C04F0
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:17:01 +0000 (UTC)
X-FDA: 85120639842.02.D8CBE18
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4F8F21C0005
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:16:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787206619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=96NTti9PVCHIkul1Gb1Ocp4p8fsVJSgQyO35/15T/UY=;
	b=w34zE/2v8OZG3n2G6LWXo1YDOanEwy/J713HWctF6CyvTFaq14V0cl5B8mVvq+rD849DvQ
	spLUZRC0Thbu3HqIugChEcfz5SSgP8qDDJASA6nx9QJK1TRgzRpFEAkw/kSe1uu3O8Mxs6
	KXQnbImEuDC7TcgimN7uBXNTcP8fDBY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787206619;
	b=quRBrG4bndnSubOpfXTHlDd3VjVOPsmzShRSvZ/TEkpAQqE1jC2OQj81WvYykbhUgPGoKc
	AJeRsowWvHNZlY3tb9iyxBsht0urTCS1nVXylGULuehOpZq+P2IXrd2fYRFOZq/Pt3t3ht
	rJdsQlur3QAA9202E1QUU8XyfKGD8Xc=
X-UUID: b9c8d4929c5e11f19a56ed5b684f684d-20260820
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:2556217f-9af6-4e6a-9004-1ed0931e5f95,IP:10,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.3.19,REQID:2556217f-9af6-4e6a-9004-1ed0931e5f95,IP:10,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:7db8b62,CLOUDID:04789f96b10346299d3591742fa2bff9,BulkI
	D:26082014165278OO1KMZ,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|865|
	898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b9c8d4929c5e11f19a56ed5b684f684d-20260820
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1157144219; Thu, 20 Aug 2026 14:16:48 +0800
From: Song Hu <husong@kylinos.cn>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: shuah@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	peterx@redhat.com,
	sarthak.sharma@arm.com,
	usama.anjum@arm.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH v3 1/3] selftests/mm: emit TAP header in uffd-wp-mremap
Date: Thu, 20 Aug 2026 14:14:24 +0800
Message-ID: <20260820061426.356869-2-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260820061426.356869-1-husong@kylinos.cn>
References: <20260820061426.356869-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F8F21C0005
X-Stat-Signature: z4yjkgktnwb1zkirxbz9cfduzqdeb3zc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787206617-322417
X-HE-Meta: U2FsdGVkX18L/VMl6xvWLRGbegc57E59wEDplVwdt7IAkz7uNhrAVJkU4Rs7k7EOAxUZD/C8LRPZfBL/cOTfEJHthFbxddV+ZaywsgapZAdHHtLzRlY9z1kr8bx11Jed+2AUhHDethn3V4sMM5flGymszdPGgJmaYYt8Yzu3dJ4ttqaQdIZPLW6HvVJJZP1e1U/FlncDvCbF8gf0nGSpCK5fy2996CXN51hk7NvnnoASlylhVx3FZA/mq38xR2XLoc5aciaLktzZcmtJWjMey1VTuAzWnZl/cWxWMLsQnCh9injyZBYapMXH+ygjcCG32kAPD5pNKT8T8ohOQKUGHBHwSECIrAMopV68ySUh3Ak9pOGb2+WixAVBg8AqmRb2RZlSHRWXKyTPruN0l6JF98PwK0An0K2XMA+PU8Cgg4KUu1S63KFmtGN4UrHpg0CshVmkikChnamyRRwDKl/2oKH8JibpYmLUv4u6IRuitVsAoPip7JExaX+bkoZf42qyXhUv+o9Nieb1yx6uon5X0iigikQj1akWE4MsuLJbWh3QNVTjTWmYR5WtyW0KdmzHqKLjjfsdLYa3XAf6ag+yynWIBXw3lwYyCJvWzhhil541QoPcd80Y8FBC5uu30LMmk426qSAXiYwzgtCwenid8Hlfq/nQyL2WEVAz1jy3ry/GLn2rEgZRx7pi+pF6Tlq6nBl3WAODN0SzxsP4JesMMIjN4RemnILJ53+ylm1CGXTX1JttTJMfyQ1+h98MSY288ghrcokkt1ImZhTJ0wYZnE/iX53cKVgBDslb/VbF1EGNIKO52hche61kb5GT622Ff2jYEAm6UfE0Lfrx/7luHp3KWKqR/IKl3DyUE8aMgXE81GBCx11CWUjaB9fO7thtO5TYTQwnmffUH7+XK0sMtCldWmcFhPVhkqJsjwpnIlcdIx8nzIAFJHjV3FCVMmkuNA4vFfCiuSbQM6BfDXT
 ayM0hg3g
 B46ikFc8JE1mHyqWziS3aEByj7rSZQpCmeZKno7Va5i3r/w3OUdhSiTjomRn/ZslAGqPTEcWbdUNAqCl15IlCL2lzGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

uffd-wp-mremap calls ksft_set_plan() without ksft_print_header(), so its
output is not valid KTAP.  Add the header, like the sibling uffd tests
(uffd-stress, uffd-unit-tests).

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Song Hu <husong@kylinos.cn>
---
 tools/testing/selftests/mm/uffd-wp-mremap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index c973d6722720..572c2516e874 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -347,6 +347,8 @@ int main(int argc, char **argv)
 	struct thp_settings settings;
 	int i, j, plan = 0;
 
+	ksft_print_header();
+
 	hugepage_save_settings(true, true);
 
 	check_uffd_wp_feature_supported();
-- 
2.43.0


