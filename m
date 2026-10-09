Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07186CA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 09:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF12E6B0092; Fri,  9 Oct 2026 05:29:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA8626B0093; Fri,  9 Oct 2026 05:29:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9911B6B0095; Fri,  9 Oct 2026 05:29:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7653E6B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 05:29:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D83711602E0
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 09:29:09 +0000 (UTC)
X-FDA: 85302564018.16.9D378C2
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf22.hostedemail.com (Postfix) with ESMTP id F0B19C0007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 09:29:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791538148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=ftBTcDntMpR7N0Xj5Msg1b8TUVy5N19W5t8zELuuGqw=;
	b=aBk0uLP24WgCeHCizG4OfUJDNCOSjycgIBV5+nQPmyd3tBIV21wKYJ59TNz2n2WdmGiW7w
	kdEHdhzNyac9+D2eMmLDCI771PWJeiZrkKzeDH8keTdgGH6/Txw5H3Th3pJjscTW29fA8I
	9nSgB5Q6YH0r4656f0t6KUxVlgTC5v0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791538148;
	b=M2np5Bku4xbgukDr9WVwPU/TZL/gHCh6hKBXffFVrd/WSwwb2Q8UByD1ygzKFR1n3mxZXm
	87S5bUc3IpBoSsxI1OmA65NmOhKRgma7kA2ADd4dtmUBwPnxcdz7DGkU0J011vRSZGE6Ju
	SKZEFrC7fhYVgSv2cXGgy4Zs6zKiUpI=
X-UUID: da7f3c4ec3c311f19a56ed5b684f684d-20261009
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_EXCLAMATION, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:32bbc829-0ff8-47f9-812a-46c3b04d1ebc,IP:10,
	URL:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-10
X-CID-INFO: VERSION:1.3.19,REQID:32bbc829-0ff8-47f9-812a-46c3b04d1ebc,IP:10,UR
	L:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:EDM_GE969F26,ACTIO
	N:release,TS:-10
X-CID-META: VersionHash:7db8b62,CLOUDID:d7c34cc5ba83a2dd7113ad5dab7dbbef,BulkI
	D:2610091729021GSS2XUL,BulkQuantity:0,SF:17|19|38|66|78|102|127|850|865|89
	8,TC:nil,Content:0|15|50|99,EDM:1|-100,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_AEC
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: da7f3c4ec3c311f19a56ed5b684f684d-20261009
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1099070471; Fri, 09 Oct 2026 17:28:57 +0800
From: Enze Li <lienze@kylinos.cn>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] mm/hugetlb: drop the empty register_all_nodes() stub on !NUMA
Date: Fri,  9 Oct 2026 17:28:32 +0800
Message-ID: <20261009092832.393778-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F0B19C0007
X-Stat-Signature: y8bez9uk5o7mpe5wywt5fp6hmt4ztp71
X-HE-Tag: 1791538145-293146
X-HE-Meta: U2FsdGVkX1/57CB4PA3F1usNCQ764Jfp8ycU6qJfX22YHhpF4FcVAR4F3hpjtT9UrEPbjt2M5DiGf22X5I+ohT9/917xlTnLgCWM6nJ9odxXUkgIKKdf6emiXJvmhiqrygvVpdsbT6oMcJrSEbyk7FMb8c4LNSWz7mywDgvx+4mcX8ETF43ARS6e7paADKFE2HeH4lhGB9wKtp+wd7HDV3ID++U9BRHtWS7c3w5VfSWwCFnZbd644cpTFipGFuIgHqWlBizuQw52uz71z7r0P9gsh056XmsoqiHGse+jdI50aPFnbQ43d6LU88ppjVNHCiVM42uVu7s7lajQLPear/alwctRPwVRpSiRSbCsy3CkHFeEiZlCugLo5FgKa4PgZR+kkjBNzSpnqb/cCw7OwkUf3Hxoz8GDAM9+5SSLzCai1wNV3xHSPFjRyXdHPp6Gh5X5Jooqo2ddgnjxpi9UfsDT1BT/Nm6SPKIDC0Q5hUnzeBzxplEreEytD4aWnTHz1RaOZ2IP9On8ixLX37qKG0IcmZ1/V2zMHYg7LQxChtc4xZ+lKWIYCmaCB3bfPELWvfUy92lFtoRqZHuFV6RvOfTrdk2OnKBFY5XgD4i5yMeiv9qvmr5cAcCq9IokWqV8xbkR2dmYaXwwiODC1qU21Z9I0lwB/9eVc2JEwP3VeNTAv5gDx85E7sprx8znpQqnc/TzWvbG4C86HIKTmt4B9L0M+D93tzhGLDrpFNSsd31GRZ5lSNe/iRiw0Qsub7epG1YRpcGk+7Hja/T/u6dO2vZX1wfm1Kqa3D1XJukr1BerAwZ7rgwmxPJ6AMFp3e6MPTBAC+GnPkV8SaCs/D5cyJabkLFF0q1+KWQ7YUx+iT45tvIVhvY3QxJvx50fD87qCU6moayAvOjtwTjOYT+WnNTe6Hk6wnlpYlGSnQMpHAXU1MOGrHKAWgb5Wh0Gsjv5aDYFLcyRtc8SxiJsn78
 iJm3zAlk
 qeB8NqPp1Gz/8u2dCRUKZSZT6rlnhBBS6plrHYP0UIRWePsiFmUc3Ugy2QS7UsdW8ZuvDaQRp8TgK1SnGAYKqzbU0nA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only call site is in hugetlb_sysfs_init() and only matters with NUMA.
Drop the empty !NUMA stub and move the call under the CONFIG_NUMA ifdef
instead, keeping all NUMA-only setup together.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 mm/hugetlb_sysfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index 326a54b4d991..de439b3b7f01 100644
--- a/mm/hugetlb_sysfs.c
+++ b/mm/hugetlb_sysfs.c
@@ -475,8 +475,6 @@ static struct hstate *kobj_to_node_hstate(struct kobject *kobj, int *nidp)
 	return NULL;
 }
 
-static void hugetlb_register_all_nodes(void) { }
-
 #endif
 
 void __init hugetlb_sysfs_init(void)
@@ -497,6 +495,6 @@ void __init hugetlb_sysfs_init(void)
 
 #ifdef CONFIG_NUMA
 	hugetlb_sysfs_initialized = true;
-#endif
 	hugetlb_register_all_nodes();
+#endif
 }

base-commit: 8b38ed9ab5b09c8ba168cbcc49524e9b380ee5c4
-- 
2.55.0


