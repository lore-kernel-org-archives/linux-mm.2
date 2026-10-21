Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1BD6606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB90F6B063D; Wed, 21 Oct 2026 02:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D694A6B063E; Wed, 21 Oct 2026 02:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7FB66B063F; Wed, 21 Oct 2026 02:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A49ED6B063D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:19:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 392991C1CC8
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:19:39 +0000 (UTC)
X-FDA: 85345632078.27.0E21E84
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0D9F040002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:19:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792563577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=cpHXeRbYtmY7QVTasS67Q8Gf+JBFujVzzDvd9PA9m8A=;
	b=ViFKKWMFIxDoxyKgcZ09I5+AkzTm0IstnwimGXAqfFwe2pCmBzKoywOOjdPkGPrEIMNUdP
	W5G9ZhnOwjN4v+62LHbrmXe/IwJSNYCAg+aF90AedW1PoxLzSWXIDWJLZzG8c7PxoB3Bn6
	217W9cgNwkuAlZtu45kgmh40a8iuLrI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792563577;
	b=6HA5oQffO0cVTigNDgClPrbEggBkCPUIPI8dI6lqYXue0zKO/Q4PTrKee91oXzugqKlbD+
	COojKzb0DPLn8dPwZEeC20tiJIzQ6kzfna2nq2rLfDdRGz0Z6dABfAPNLxAOiAg/swNIHi
	34lRNYAczWsT7hLL73h3T+ZspIhlE3I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
X-UUID: 5d70c2b0cd1711f19a56ed5b684f684d-20261021
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:67ee19da-1e98-4545-acfd-405dc8519dea,IP:10,
	URL:0,TC:0,Content:-5,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:-15
X-CID-INFO: VERSION:1.3.19,REQID:67ee19da-1e98-4545-acfd-405dc8519dea,IP:10,UR
	L:0,TC:0,Content:-5,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:EDM_GE969F26,ACTI
	ON:release,TS:-15
X-CID-META: VersionHash:7db8b62,CLOUDID:a760125a2979ff63ae592147f35b4f28,BulkI
	D:2610211419310H89ZZ5K,BulkQuantity:0,SF:17|19|38|66|78|102|127|850|865|89
	8,TC:nil,Content:0|15|50|99,EDM:1|-100,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_AEC,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5d70c2b0cd1711f19a56ed5b684f684d-20261021
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 504103098; Wed, 21 Oct 2026 14:19:26 +0800
From: Enze Li <lienze@kylinos.cn>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] mm/hugetlb: drop unused mm parameter from unmap_ref_private()
Date: Wed, 21 Oct 2026 14:19:01 +0800
Message-ID: <20261021061901.376104-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0D9F040002
X-Stat-Signature: umq1m8z18eigmi77us7df4adefrstqxw
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792563574-959544
X-HE-Meta: U2FsdGVkX18FqTsYF2tj+Wo4W+4URXUiM7zmq3ycnU5laQTi03j92eUjYCSpkPvb4fk7dWzOoXMu+6uO0u/BwhwHmSMAXIBRE1VcsksuMG1JGaYvKBj6yoCnNUMCdFWvt72SWLOapqgb9lw2WCNwGCSGvLAogsWROpEdAorxm06mFtTBhf2HVrcUUr9KqXEkyJAb30rGcuX/RwwKIoMTBePCU7Hf1HZEXLCErSeSMJw6ilBdUPRgOmqX0651lANpTai1e5mS9ZkGOPU/6r5SioyrnzwKRfpsJuzfd1oEFu9urdwiw6KIWKBf/BgPVCFzgNlxND8y4Pm9KWzizbniO4PGEoaI058Folf+v2/Dt07U7/6Mrv10jC/dS4Zv5q7ZH0Q7nq5QKbOq+K2iGN4/bkQvLlPCYiP7Q7WDx3AxWMfsjXf8O00bzJWqjc6ALM9uN2aMbTlu1yaO/05buD9BhZ+IrLn7NZMRQbWzqaO2+9bPfN9qPiT1jydJ6fWMs2yiqktATB0iJgZBrvQiYIxLf0RWeS1ZGAh05e82sW/edvralgZVxovcl+wq5LXhUMAmFTQbDrNxBksDI1buzFMafSMsdYDZxOyfzo92vVyaMpRbu2OC9IC1sUtGsL37uzB1j31TMw4fRcPY+p6q88yX2jtvuCziIlBUCNtm4/OqESXjDEeIaEYSV96WHIIMKEDDCy+Z0xQC46SDBhKWT0JPhvZrE2NN5klkj8hFvwGK4DG4Mzkv6BRp6/wggkgHZRx0TR2gE7UqGRoajB2p+dHSypdXMwebkuPlcmx3kHrlhvtQ3bPXDbOg2HiBsEI0J+LmOCmCuS1/rJGCYyoDEvq/hwVNFh/m1AP3IUcHRj+K4sFfueiPJB0R2DgWO1NIY/A04Ji44ToLI8lYf0wIp/QtrhKQGesC2A0S4FfyCwqocmRKctOPHKwhNrNjvZn/QI2bklucCn8Wds+b5crKsJk
 WU7bbKs9
 V0+EC8n2NZ8KPu6J9KcrIw9SIrWndKbaO4C4BeB0pBaEAfZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The mm parameter has never been used since the helper was introduced in
commit 04f2cbe35699 ("hugetlb: guarantee that COW faults for a process that
called mmap(MAP_PRIVATE) on hugetlbfs will succeed").  Remove it and drop
it at the sole call site.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 mm/hugetlb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b37d7d0db7fc..394c306e6d96 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5504,8 +5504,8 @@ void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
  * from other VMAs and let the children be SIGKILLed if they are faulting the
  * same region.
  */
-static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
-			      struct folio *folio, unsigned long address)
+static void unmap_ref_private(struct vm_area_struct *vma, struct folio *folio,
+			      unsigned long address)
 {
 	struct hstate *h = hstate_vma(vma);
 	struct vm_area_struct *iter_vma;
@@ -5681,7 +5681,7 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 			hugetlb_vma_unlock_read(vma);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 
-			unmap_ref_private(mm, vma, old_folio, vmf->address);
+			unmap_ref_private(vma, old_folio, vmf->address);
 
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 			hugetlb_vma_lock_read(vma);

base-commit: adccb2dfbbc10fab73d6f1b8724c003ef9e65773
-- 
2.56.0


