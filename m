Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 980DA1088E58
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 01:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EBFF6B03A0; Wed, 18 Mar 2026 21:29:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34FC56B03A1; Wed, 18 Mar 2026 21:29:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F0686B03A3; Wed, 18 Mar 2026 21:29:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 020E76B03A1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:29:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A91548AC1F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:29:06 +0000 (UTC)
X-FDA: 84561079092.08.7E6159E
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2E2D040006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:29:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773883744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JcLXWuoqZAT2WkPyRZAlHUM2oGDqqks6mmJLDjWKaEY=;
	b=ZXxK0wASiUuyZBQ+q30UMT2QIcWa1ZGfEHgoL2T+ql/rs96KCmw8elPkHV/4gd6y+911u0
	UMwvNqJMDLWz5SLDOl4N2ovVeUgIDPbLCaMi6DmaERAZh3DanIB1JYsucu2lmix0iMP1nF
	GNEdv+0TaMYZ/vFeV3Dei8aGcM1JfgI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773883744; a=rsa-sha256;
	cv=none;
	b=L2rWrMHFvR9tWxHSlbAaaAVka8C143+kT7lfiF+ocUma9ORbKSIIqb3WrFoGb2KQ7vFpP2
	BeLhH/hDFQ9MisjmDmM48XKD0AMjZgqeLpyJZ/GT5cTmzxFb9+fN9xEhaI7sE499M3JTj9
	qV1VndZpJO3iM5qSsK4w0D7cnBzobXM=
X-UUID: fda85ed0233211f1a21c59e7364eecb8-20260319
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:9147934f-8f02-4a83-a50e-d246217fff6b,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-INFO: VERSION:1.3.11,REQID:9147934f-8f02-4a83-a50e-d246217fff6b,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:28b99be89e8f35b1167295f0f5dcc102,BulkI
	D:2603190928549XO2OPA7,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fda85ed0233211f1a21c59e7364eecb8-20260319
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.22)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1976947509; Thu, 19 Mar 2026 09:28:53 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: duanchenghao@kylinos.cn,
	jianghaoran@kylinos.cn
Subject: [PATCH v1 2/3] mm/memfd_luo: remove unnecessary memset in zero-size memfd path
Date: Thu, 19 Mar 2026 09:28:44 +0800
Message-Id: <20260319012845.29570-3-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260319012845.29570-1-duanchenghao@kylinos.cn>
References: <20260319012845.29570-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2E2D040006
X-Stat-Signature: rstadke71dn7hhrsofhgm13xcgd5tf7x
X-Rspam-User: 
X-HE-Tag: 1773883743-111139
X-HE-Meta: U2FsdGVkX1/dE6aTlEHD+b8Xiy90bUU1H+zXQcF71PhB7r1ZQUTnwfTTHZw8Qx/UQj6fyztVAeOcz6+t9uj2/ubXyjt53tsRhEImJJOLaG1y+BOVF4n8dY2bZL1cdd6RBEJlRaR+HNzC0pZUo970xTzgOPSq9PkanSiEgX5vHyJH6jfbvFAMRY/wwNKysRr8S0FyPXuGCKtEpj4qxqDxRiba5t6D+A83bHddxp1FZqv2iBhHDZ6dWAZIpI/iNjRoyx3kCr25hFAovtOSErR+aWoJYPhphG8nUTClrB7zb5OSHFRRHcM+lDLT2XvEQyS26+oDxc33Vi82YmK9b8go6u07HOpT4Jh8oJm8giT1L91Cvc5QT/y/lVuTHY9GYpsOiLE1BIwvEqvnwG1YKdfd6DGuhij/C3gfM14Y1k2riVPQ3yCni/iTq6WwTgLIl+5qmN2sf4NevJdUlwM7qwBBZPz+SFTTJ0aI99OHe1l/RucKkqu602g3gEQ5xsbaMdwzRbAMEmZd35PhfANNfvukhQw7MgET3Wk3zsiQronjIcurTSMHvb7nNrpj/XqIc286dzYOSkZjR5AeGptwF3DtDeh4p9pGmWHifMfUi8jB3St/kIrIgcx/vcOJ0b1db4WtEkZqBelbdJR7HDmow+z47T9pyvysdqe0UczT2SI7MnuAqeACH0lI7fB2BPr9HJu8JLhKnjOsNwNXz8z7Tt/5zc9+u6zE6S3dxRcE+ddKBr4QwYj+sAZ71rDmwWftY30VuJ3GmA4mSa7mm3SpQLUhPhcG5c49PtULBE7VsqqxcAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memset(kho_vmalloc, 0, sizeof(*kho_vmalloc)) call in the zero-size
file handling path is unnecessary because the allocation of the ser
structure already uses the __GFP_ZERO flag, ensuring the memory is
already zero-initialized.

Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
---
 mm/memfd_luo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 5ddd3657d8be..413df8c75c1d 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -103,7 +103,6 @@ static int memfd_luo_preserve_folios(struct file *file,
 	if (!size) {
 		*nr_foliosp = 0;
 		*out_folios_ser = NULL;
-		memset(kho_vmalloc, 0, sizeof(*kho_vmalloc));
 		return 0;
 	}
 
-- 
2.25.1


