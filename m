Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E33B2CA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 14:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDAD16B0092; Fri,  9 Oct 2026 10:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8C646B0093; Fri,  9 Oct 2026 10:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1C76B0095; Fri,  9 Oct 2026 10:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 825976B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:20:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 813E91403CD
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:20:40 +0000 (UTC)
X-FDA: 85303298640.06.2778DB3
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf30.hostedemail.com (Postfix) with ESMTP id C14BD8000F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:20:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791555638;
	b=brj+P20rG4yiH21w1cHqPOeJQ6n5aAS/g3yhXQBWmpTvb5wJAOcjkMLeQjAU+kcbLsBLK2
	9CB7lBB4Ysrcu0/eLruOkF8asf5L3KG7sM+++G1PMyZW6cuU2YjsWhDK1ddzV8SD3/doSo
	UcWshkAarZf8foS2blXvGj1fP+TXMN0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791555638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=hH7I8gtb1e1zz61Br1Ir9AOK4GDElaDHov+FK2EDCIk=;
	b=PEV/mPWZ8NvFPdK15nMjEz98/Y0xtv2rZ4JWucx9m1qe6T6OxJ2E8HK6iegJSxGxStWQcn
	yjNT8n8T2itMGc8UsC/1zFW6TglG02VvoSGZLYknifnjJmzDIVFRbPPOu/oe+jMS1izcJJ
	FrS1AaQNWLCGq16xKsZZ+lwjgLjgT4Y=
X-UUID: 91c6cab6c3ec11f19a56ed5b684f684d-20261009
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP
	SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:bca760ea-43ff-4cb0-9df1-58c3382393ec,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:bca760ea-43ff-4cb0-9df1-58c3382393ec,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:a7107ce9e167de322dd354e3cae3a928,BulkI
	D:261009222027IEVFJTE7,BulkQuantity:0,SF:17|19|38|66|78|102|127|865|898,TC
	:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil
	,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 91c6cab6c3ec11f19a56ed5b684f684d-20261009
X-User: lienze@kylinos.cn
Received: from ubuntu.. [(111.193.136.161)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 101760413; Fri, 09 Oct 2026 22:20:25 +0800
From: Enze Li <lienze@kylinos.cn>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH v2] mm/hugetlb: move hugetlb_sysfs_initialized into hugetlb_register_all_nodes()
Date: Fri,  9 Oct 2026 22:20:10 +0800
Message-ID: <20261009142010.552614-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ebbwkkcwkms87qrs1icznu7t1qzy7u7y
X-Rspamd-Queue-Id: C14BD8000F
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791555636-45394
X-HE-Meta: U2FsdGVkX1/6OQUmgvDBx3Pgtpildl9hXArFxu2cwAVdRVWONb0CTL0VwN6S6FOQMNyNteBV/Jbk7gcISS51Zhpub8M6SxtCOGp/tdHkw0N5DdFWIFXH5a2KtV84xCiKJG/GjGFpu4g8RoqzCUzKQxKBjjtKxkRnt12nhyJGQHj4bqwxI8s1TdIZ1KQZhrh29X3pgRbORsbwjknRwCmqLvImkBW+bO1Y0QjbYC3uZWlFz49FS56rIp/tcaea/vh0gogzuL/+WW4akXPSWHfwzzAklUb0z2vAbNqyTOJJxxlYRF/y9+zX96QA3Tmz7FxieBhCB1njeC+zc5XM5K5cibSYb9zeVEDtoUiHNC3xDseAJUhvE3tOwWWi0P5Gr9g01rXmubaV1VucWDzRoaAKnuMfszKjUIMXMXGEEVQCIIa5AGZeiL7HXU1oy48b9ijRrtTN7NFprybOMDDVpwrSqMNvdU9+dM4Gd68vS8Utxlu2U19QH55j44fp8Fdh3jzldGP5J1v/OcyeuCiY8ZWLTTLYrF5Pt8gkMzn1dMCV3maKLuhfa8tLoOTtT0rFNOBP8SgqwgAiSZ569RX46ykhoVMnWY5afS7FBw4+vR3m7YZXDTj8POF0GYhSfhkAFld/qmHLzPHGYkYM/CKUD+pJZaV3+6pZFCipWozTpmGkbmhXhaH1iCYe9EVxE+w/Vz1eL3M915OgYHScNGqGh1Hl+Fx7jGvJ0MqpC2S2MivF6jVVhnYw1MJa8ltwRsJeV0d/cgW63ht0lHRqq58/rLtrGW3b7epRJuErO+xKR8V/Tl3Gmaz2z4ou5YTe9nRDLSCKyPd824TEznVkEhfcfmkliV4FJ713hI2teiUwr0nPkqSq3cAj5U4/4k4iLRtpEJRLmKdet6VKABt8AGlFaZPczJVF1/0mJeLfFy0z96jbFcQQaef829fwK90sV+fI+j3Nbao+NwLwSPTpApoU8OQ
 e8FWmKvE
 75OQfQvoT8fBenfoKXynVA1rpSsjkWUXOfRE/8tyeuBtwtdg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_sysfs_init() guards the "hugetlb_sysfs_initialized = true"
assignment with an #ifdef CONFIG_NUMA block, while the following
hugetlb_register_all_nodes() call is left unguarded and relies on the empty
!CONFIG_NUMA stub.

Move the assignment into the NUMA version of hugetlb_register_all_nodes(),
before it registers the online nodes, so the #ifdef in hugetlb_sysfs_init()
can go away.  Keep the !CONFIG_NUMA stub, so the call site is unconditional
in both configurations.

Suggested-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Enze Li <lienze@kylinos.cn>
---
v2:
  - Keep the !CONFIG_NUMA stub and move "hugetlb_sysfs_initialized = true"
    into hugetlb_register_all_nodes() instead, so the #ifdef in
    hugetlb_sysfs_init() can be dropped, as suggested by Muchun Song.

 mm/hugetlb_sysfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index 326a54b4d991..c89e4c847575 100644
--- a/mm/hugetlb_sysfs.c
+++ b/mm/hugetlb_sysfs.c
@@ -462,6 +462,8 @@ static void __init hugetlb_register_all_nodes(void)
 {
 	int nid;
 
+	hugetlb_sysfs_initialized = true;
+
 	for_each_online_node(nid)
 		hugetlb_register_node(node_devices[nid]);
 }
@@ -495,8 +497,5 @@ void __init hugetlb_sysfs_init(void)
 			pr_err("HugeTLB: Unable to add hstate %s\n", h->name);
 	}
 
-#ifdef CONFIG_NUMA
-	hugetlb_sysfs_initialized = true;
-#endif
 	hugetlb_register_all_nodes();
 }

base-commit: 8b38ed9ab5b09c8ba168cbcc49524e9b380ee5c4
-- 
2.56.0


