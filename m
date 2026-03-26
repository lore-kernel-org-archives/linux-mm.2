Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6814106F303
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A8866B0089; Thu, 26 Mar 2026 04:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 559BB6B0095; Thu, 26 Mar 2026 04:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449026B0096; Thu, 26 Mar 2026 04:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6156B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:53:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE3DBE0E14
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:53:12 +0000 (UTC)
X-FDA: 84587599824.08.E0A2CD7
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2FCC814000B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:53:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774515190; a=rsa-sha256;
	cv=none;
	b=z/ubRrDPD5hX0v/iNGRLbPbz8aNcC3bPlAfGRJxW1eXbH3PdQ+ZEaoXm6/bLC3bbP5f7Wk
	Uee1skKxADy07ja42qko1fWNLXLhq0xzEnrjuMfDwjjLuZ6o/bBNRirlQzifmbOqPOqMb8
	zelTABe1o+sOXeA8b6TXbJLl7QcIi2c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774515190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C8FR0q25/4EtXxWmcPN7H9L63UyaAKr26NZO73v6oQg=;
	b=EuNAYFZlfW9Dsx3DR8wjbDnMPI0e0dRTwKV21npG5hv4RBrUMV8URHHVgGSsiT498R7sx5
	COZw6Y3K6PYSwNlXekjypNZibsg8KL+DnV9OSNT8KJGQiUUudt2tfqDCRxi6TWljKsblXg
	wD0GMQ/Apr05wa8HQ8O9VVzW70Asm3w=
X-UUID: 7decb7fe28f011f1a21c59e7364eecb8-20260326
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, UD_TRUSTED, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:0149f3de-2b63-4fc2-baed-5df8a04f9f8a,IP:10,
	URL:25,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.3.11,REQID:0149f3de-2b63-4fc2-baed-5df8a04f9f8a,IP:10,UR
	L:25,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:89c9d04,CLOUDID:79d138a8d03187dca63f965297c09dfb,BulkI
	D:260326164801IH4OYY5O,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:11|94|81|1,File:nil,
	RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,D
	KP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_ULN,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7decb7fe28f011f1a21c59e7364eecb8-20260326
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.21)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 2056257955; Thu, 26 Mar 2026 16:47:59 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: jianghaoran@kylinos.cn,
	duanchenghao@kylinos.cn
Subject: [PATCH v3 5/7] mm/memfd_luo: fix physical address conversion in put_folios cleanup
Date: Thu, 26 Mar 2026 16:47:25 +0800
Message-Id: <20260326084727.118437-6-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260326084727.118437-1-duanchenghao@kylinos.cn>
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2FCC814000B
X-Stat-Signature: y6b17fcdkqqxkj4j8gkshmxd1fosxb33
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774515189-363561
X-HE-Meta: U2FsdGVkX1/+JRN58yogFdfp7x9YdRy9ZPnvb3OxEUJLuDs2pyA5/wz7S0/Hd6K1PjYZiyuXNU3Z1mOlsFVGThJgX67AvoLbnHNj6fU/fUhq0RrtUwzsvcJxcXicaMg8Pg1ea2BDyTzxhipry6UvYchP9sd2NfTOczsXAiVZ5DLBSZwH1oFoXU87C0b7a486OJ/HdBtA0qLDln6a5bWbGx3IPYrLi6vYI33eyFLGDcBiJkbz4glUA6I5WrzEE4x1e0JVWCklHfTLgPKmS04H5hDXxLnkup5Sgw3JlGAWawdEw1U6JwsqA3mlgpWQXfglQgQg77PG1TdYuy364olkd8d9Re5p8n/0N8A9LRJAm3wHd6nrgoKy91cbXusVaOfG3pLNAaO0ecYsJxp9ZXJMzvUCgXe/ghPy9kvkVIfD6ynxab/l7d0tHnq1jj0RWLGAen2zENRXMv7svoHaojr2vFqt/zV0jJ/+ZAgM6WdT+4bLaSoxMU/mvknRcXAAL89+dPkrLOf61aFx9v834zOUAvYHSp4xBI3bp/j55qB0ER+h7Oc+M/rFRZUrJ8OpQ6rd8dDLJOPzNTZN6MFmRyVGvMTK0QAxExWjLSK1Ilb8BktIGiH/I2Dw2q6sTAYVHLXHzSAaYmnfze7Ho3KSDlE1A957xM58v1ek++GcQRzQxMmpqUHw+9HKVq3fmxkysWFQc7mKzYbKfBL1K4x9uzrU/SHcFaBe0h9H6Mf1SAV3GBNg9IVZAlzX8CCW7ZHv3WElQ0dZlD1PWQOYX1N61KQHQche083swxaTHBc16t1gIZlHzlw/yHUX0RkOMSGSiQQERCy1nCulVG03vZpGuQyMaRrlbrmfcgm7cNtfm61H4rKy3FWH2L9MV+ya+iz/R0d2yvPuQW29USyq1C9i+IWn4uP3iankGX2LQyolztPtDFPtiYAxvpDEr7N7xwNjsNBIM4vqYtMe6YrHbDYcOGD
 hdlDkaY0
 ZgdO2qhf48UbzNIARRLrImt4V3/lQ35Mnp2oSY8qJby/QJHYz4icGUzICSoBmA2/ARhzn4gLh0EmFMwM8eLo9gQF4eU3nnTAhlj0b8wZ9MiuJKQQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In memfd_luo_retrieve_folios()'s put_folios cleanup path:

1. kho_restore_folio() expects a phys_addr_t (physical address) but
   receives a raw PFN (pfolio->pfn). This causes kho_restore_page() to
   check the wrong physical address (pfn << PAGE_SHIFT instead of the
   actual physical address).

2. This loop lacks the !pfolio->pfn check that exists in the main
   retrieval loop and memfd_luo_discard_folios(), which could
   incorrectly process sparse file holes where pfn=0.

Fix by converting PFN to physical address with PFN_PHYS() and adding
the !pfolio->pfn check, matching the pattern used elsewhere in this file.

This issue was identified by the AI review.
https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn

Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
---
 mm/memfd_luo.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 76edf9a3f5b5..b4cea3670689 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -469,8 +469,13 @@ static int memfd_luo_retrieve_folios(struct file *file,
 	 */
 	for (long j = i + 1; j < nr_folios; j++) {
 		const struct memfd_luo_folio_ser *pfolio = &folios_ser[j];
+		phys_addr_t phys;
+
+		if (!pfolio->pfn)
+			continue;
 
-		folio = kho_restore_folio(pfolio->pfn);
+		phys = PFN_PHYS(pfolio->pfn);
+		folio = kho_restore_folio(phys);
 		if (folio)
 			folio_put(folio);
 	}
-- 
2.25.1


