Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75E55106F305
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E05936B0092; Thu, 26 Mar 2026 04:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB35A6B0093; Thu, 26 Mar 2026 04:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1366B0096; Thu, 26 Mar 2026 04:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B21AF6B0092
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:48:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78A5D5A75A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:48:08 +0000 (UTC)
X-FDA: 84587587056.09.1826EAA
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf20.hostedemail.com (Postfix) with ESMTP id 098F91C0003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:48:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774514886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8eUS4P1DdGX1ne7SxWPtHJ1SOStAefW8pnHyN9lgvNo=;
	b=CgsGk5J3Wz9zxvVn7obYm4Rp+MknXLOL5EnGSok0+MN+a7QRrtx7PNQUAmyqAtK3WORVMk
	A5uaNJtDK0LgjDdty+NSMghKexAvhKndmqXiGtmT/JGiXlOdUC/ngEJtjCeg9ZZ1eOQyIv
	0xGrSWYmFfeEu0sXRoj5f79nnD4PlCQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774514886; a=rsa-sha256;
	cv=none;
	b=jymCIHpqQUqCDg/CtvK5QZLXoDEKMsMT2Y8fH67d6pvDD8pdN/9A7DG+ufAQUpitBajsJe
	D9P08J26Al5T8mcF+NH3HYWAijUB2OS0n8pSW/I5pcXo00lQNQ8Ny0NzOEi/PHE1jZpptI
	ZiHXE27zN/pAhQsncFBgO3kF7DGY49o=
X-UUID: 7cb80e4c28f011f1a21c59e7364eecb8-20260326
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:0b074cf4-d6f7-4d98-9f07-dcf0e6a6e8b1,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:0
X-CID-INFO: VERSION:1.3.11,REQID:0b074cf4-d6f7-4d98-9f07-dcf0e6a6e8b1,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:4c240a192d90b45019c2cb6f8b32788e,BulkI
	D:260323190756MBG2A585,BulkQuantity:2,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:41,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7cb80e4c28f011f1a21c59e7364eecb8-20260326
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.21)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1835242107; Thu, 26 Mar 2026 16:47:57 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: jianghaoran@kylinos.cn,
	duanchenghao@kylinos.cn
Subject: [PATCH v3 3/7] mm/memfd_luo: remove unnecessary memset in zero-size memfd path
Date: Thu, 26 Mar 2026 16:47:23 +0800
Message-Id: <20260326084727.118437-4-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260326084727.118437-1-duanchenghao@kylinos.cn>
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 098F91C0003
X-Stat-Signature: po31ag9wx6od1yren1p57p3fye78omgo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774514884-239649
X-HE-Meta: U2FsdGVkX1/5iy2YXua42rr0tjr/Jr/fSXKFFvNsxh1IPaJpDV4+5txzQsUoVevoncgC5wH7dsQuoq6fDtEzz8zkUrsys4kNc8B8CvmmyAk7jE5nSyju9694znnFUI1Ug+pF6ELA9CsKTTYKuIHohjEw2+hx0Q/JdwI2h1GGDOpuDMC2I54WVhoYC+1CyS3riDlnSfV6O0kpbFr58S94gWkm0tqrmFEi1ltHdGkHWr0TSQXQZycQ6IsOm36u9QvciqF/R1i1+crT3WFvIXzmmjmIApF4EMlJCOf3Rlu1+4PTbUAceWwvll5ksmL+x94zv+Mf8WjgYUYjZQ7iVqf94zDmH+xIvmMEp2t7660OB2vkESTvySr8ix2pnST9eKNzI23KLEHIS7a+3Mniu+IejculrMZ6GQXJiALJw1Om7c7F8U2e8hvnTF9JtO1PkyBTcjQtqhm0GBoRnUjoD0SsLzQvpFtLkrMuIgSCYKf/6EtzJciXfhSvxIwoyjEybqzugjdu2OPOrqt8bKRLjeTO3KEehQxLuyCAB+nU6D0arHet6g7SgPzyygjFPyzpmD9GvK2iUOn4xAMU/Fbp5ifNgvNSAxWJET2bxXyBn3Mps9nwPG1nQQA/8ecpdEzwtYLVwIwkJA3P98CkefQ5AbWxdUI4TsUX5nw7ojqYazlFxTzI7Jk88RwgVuENngNuz3o0EB7VGAQj5r+u6a5ZgtpPq8wb6ZWV8Q072j/v/tB8gUsXcT1Sp5yEk9Fsm0IDIA7afZyGGI7K2Hm0YdUkYUdQTMHlsKIbS7xej/5ThlA5X4kJHyX0cj12s38+Wnex4Ep+a3iXnxNJrJLBKjRhKWwnhjD3OC0+uavyOvooSOOCQln5+qFQGB/BdtLNVEhULkTYN7wXJigPMKl5JwY+LJHGbVspPlK/mmlnQLdPiCk3ygtZYzr/rBFZkiposJQEG65CRf/JLoRd0XoMdflCux5
 nmMWwMaw
 Wf3uVAuwU+eK6mf6wN7EQ1fCND7YI51uv8PyEInY9b7Tykl5KFGq9yVsLFEcK64u3w/+GQziMAdOd/oW5SG7BixDXmU/W1+H+wAmg7JmJbngWwtrl7cNDMZvFSa8xY7OqlAJ9QJaPKdt2OHBkVXthOqiW4ddizGc54t/oOKW0Qnp2aDU=
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

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
---
 mm/memfd_luo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 2a01eaff03c2..bf827e574bec 100644
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


