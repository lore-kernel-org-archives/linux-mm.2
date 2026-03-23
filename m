Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FE87EC01D0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D1CF6B0093; Mon, 23 Mar 2026 07:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 982CD6B0095; Mon, 23 Mar 2026 07:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C1396B0096; Mon, 23 Mar 2026 07:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74E336B0093
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:08:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 161A7160B15
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:08:08 +0000 (UTC)
X-FDA: 84577053456.12.9AB0541
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id 70DA94000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:08:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774264086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t29zZ0+CFWVTDPzh6ZkgOv2fn8EC/x6SV4CYAbQDX1g=;
	b=6eUzUwOnCQoTxVlwUgtE5/BF91bfhQ2A5G/7YO4PYyxyhDjNZurBjIkF8lJejl2/Z/AUL5
	gONGbvF0qgHnC8BQ3TJFY7yfX+xxylPXU8w1oo0nhSqKpz1IU24K4iAeVZVvHULl9asAlX
	BUQ3aCoM9RZ2CJVgcl9bLuhapAX7zDo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774264086; a=rsa-sha256;
	cv=none;
	b=GrPX04O/V1lQD1txLHUKjn4C/I4ADmeaLrPE1O3Fqskqma5V37gRK1LAmse+l0qJLjD4Ei
	rpjw184IPCtCAEKuxoAVyshilnfBVVcfpLN/RfWNEnedQt1LJFGnDv8Dmqa+H1zsGi4ksn
	C4S0+G3tGUfE4ju5qDwO6r732sTTg5w=
X-UUID: 89aeb99226a811f1a21c59e7364eecb8-20260323
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, UD_TRUSTED
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_BLACK, ABX_EXPLOIT, ABX_HEURISTIC
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:42812116-3904-4384-bae5-e56b318f6d4c,IP:20,
	URL:25,TC:0,Content:-25,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,AC
	TION:release,TS:15
X-CID-INFO: VERSION:1.3.11,REQID:42812116-3904-4384-bae5-e56b318f6d4c,IP:20,UR
	L:25,TC:0,Content:-25,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:15
X-CID-META: VersionHash:89c9d04,CLOUDID:c09e72561b1725f47da42b384561751d,BulkI
	D:260323190756G9L0BELF,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:11|94|81|1,File:nil,
	RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,D
	KP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULN
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 89aeb99226a811f1a21c59e7364eecb8-20260323
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.23)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 2109757586; Mon, 23 Mar 2026 19:07:53 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: jianghaoran@kylinos.cn,
	Chenghao Duan <duanchenghao@kylinos.cn>
Subject: [PATCH v2 1/4] mm/memfd: use folio_nr_pages() for shmem inode accounting
Date: Mon, 23 Mar 2026 19:07:44 +0800
Message-Id: <20260323110747.193569-2-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260323110747.193569-1-duanchenghao@kylinos.cn>
References: <20260323110747.193569-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 70DA94000E
X-Stat-Signature: qwa8a1aqhrcyh3t39ctcszyw5ojcqad1
X-Rspam-User: 
X-HE-Tag: 1774264085-127624
X-HE-Meta: U2FsdGVkX1955KZdCx/NPF4t0ckHNi11vh99LNz+gfFLS4UrsZlUZ/GAnbPuThNVNmI/PYaZ/gpTV883Xr2VEjxouwOC915r0JSdPb4ARq7Sp7sqXN6UN9GJMgmstqVzjiiSpqbhgvovUKt3wqi3zCGqbQeCJ5uPYdDd11njLNYBPmkBZNlXYBS1gXFTTpOfKXOewOkmxAUozT537fDHXQPISpxm60MzFMju4aqpYW5Clm7IGWo0w+COyR5q90MFzKAA+5YMagV4Cp7mzSt0Y66XCk2WNwHO7VUHdCTnN0FQW4E56N0OsTdDFHi0XieTVP/q+CcutpOcjxZp616gRkqGU+GPpD93rvaYLjByrWf9Yt2ccLcC3wY8+U1qkIOujAt+s+mOv7jvIJz22m5XYqRgkKZNshfv/HvKVMhXIL/e0YbvXpHrIw3w9zSuUQUom6VNQ4m5FSpMG1gQ1FgxutRO61tO+Y+aDwgJ32b0r0iZdET5N30UkSYqRZqU6p/L/32/5w+ohnPh3TChPT3NvcDOjvEqpuYes41YR78CwQ5vX/UCKveAlKVJ4FPOwJddTSwFgAXNItZAuMQM3EwkBZrgcKLV6Ah5GrDZZB2+SrqhWYb2b6ZCYZnOzAtquHoG0uilimyt5Wy3MIGbPgDCwAEoD7S+CI8hs/a7kD7JszvIEdRs9vx7nySp4uO9bi51PJXq1jt3lRVXKJa2gaJLvzmRjNGKPPXn+2fcFrQdB4q4Z0VYr1haLPBB1EQaCee3o3w/WNLrl9J2TrMhW+TrcB5fbZPYBGpCkDz48KHm6SC0sBGcySFTMIJ8lPQzSH1Vl+Ens/mYoWQZdXOKCtcpKnn2OP5HSBH4dbfwgRuf77cGdMLReVwRWEA2PQ6526dI2XRZdKxOAx02KY/JDFQzgm44mSyl54vqlkWVlmJO3eBUV/L3q0tgTxB8DqABxgjIggdwfgCGWkENwZiD8Zj
 Zz4aghyC
 /XiqMza1GsZblwQX/r/kOQD0/GL3z9cUv8cwZ4kpKJdDBMUgcWYvUL1AAhciLAVwkiqI/hzGIZAYm7PLrOdLnPd9nJtRgTewqP1a8fGwVWw/NXo8u9gzkg9eeljeeYOuHPmz122TKnJRCzi6+jX81nf9pevaJadLOAVWJnSBiIvjYpms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memfd_luo_retrieve_folios() called shmem_inode_acct_blocks() and
shmem_recalc_inode() with hardcoded 1 instead of the actual folio
page count.  memfd may use large folios (THP/hugepages), causing
quota/limit under-accounting and incorrect stat output.

Fix by using folio_nr_pages(folio) for both functions.

Issue found by AI review and suggested by Pratyush Yadav <pratyush@kernel.org>.
https://sashiko.dev/#/patchset/20260319012845.29570-1-duanchenghao%40kylinos.cn

Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
---
 mm/memfd_luo.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index b8edb9f981d7..953440994ad2 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -395,6 +395,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
 	struct folio *folio;
+	long npages;
 	int err = -EIO;
 	long i;
 
@@ -441,14 +442,15 @@ static int memfd_luo_retrieve_folios(struct file *file,
 		if (flags & MEMFD_LUO_FOLIO_DIRTY)
 			folio_mark_dirty(folio);
 
-		err = shmem_inode_acct_blocks(inode, 1);
+		npages = folio_nr_pages(folio);
+		err = shmem_inode_acct_blocks(inode, npages);
 		if (err) {
-			pr_err("shmem: failed to account folio index %ld: %d\n",
-			       i, err);
+			pr_err("shmem: failed to account folio index %ld(%ld pages): %d\n",
+			       i, npages, err);
 			goto unlock_folio;
 		}
 
-		shmem_recalc_inode(inode, 1, 0);
+		shmem_recalc_inode(inode, npages, 0);
 		folio_add_lru(folio);
 		folio_unlock(folio);
 		folio_put(folio);
-- 
2.25.1


