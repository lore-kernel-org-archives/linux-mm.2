Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 103001088E5E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 01:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461E86B039B; Wed, 18 Mar 2026 21:29:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411AB6B039C; Wed, 18 Mar 2026 21:29:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327386B039D; Wed, 18 Mar 2026 21:29:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 203FB6B039B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:29:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C80CA160235
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:29:05 +0000 (UTC)
X-FDA: 84561079050.20.921D8B0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5A999140002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:29:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773883743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=BQrFDy75JdV56vg++9PCPxX4locbCqledehyaverSP4=;
	b=Jiyn5Lvnlxj6nc8/udbs3jzOa/JZwjbySwIkiQ/1eRiN6R9jsTddh22VkbtEv4LUmXFfLX
	WHKBXo0CTDNfKR7fWI01rJLp2dCQtw8Cyy864sta5jXTWt7sjRx0Bv6avgjhNOZaipyjEV
	4zlwG5GO0aKC++x04KcoEfpQEKg1fWM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773883743; a=rsa-sha256;
	cv=none;
	b=rxVSJ0rNkNsTrwtZmaFiqf/wksZ7lgbWwbEW2IEV0HWHHYwiLPDKVryVO4DQ8dvuaNWyAl
	a2GSVB7n6y5xoxzZKRStzywcrAQI8qNgdHQd2E52c06JeeUsyUHfMhyTPbdUvXHhhlEGP3
	K/0oLqHZhhCbwCgKwMGLezVJJruAa20=
X-UUID: fc35e2f2233211f1a21c59e7364eecb8-20260319
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:d57214ee-254d-4f48-a086-f99dc2228606,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.11,REQID:d57214ee-254d-4f48-a086-f99dc2228606,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:89c9d04,CLOUDID:14cc55a267e35d5a0d5e93862a8a1213,BulkI
	D:26031909285431CHAXEQ,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fc35e2f2233211f1a21c59e7364eecb8-20260319
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.22)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 995069587; Thu, 19 Mar 2026 09:28:51 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: duanchenghao@kylinos.cn,
	jianghaoran@kylinos.cn
Subject: [PATCH v1 0/3] Modify memfd_luo code
Date: Thu, 19 Mar 2026 09:28:42 +0800
Message-Id: <20260319012845.29570-1-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5A999140002
X-Stat-Signature: bay1wt1anftioc9awdkottcfwgguzuzx
X-Rspam-User: 
X-HE-Tag: 1773883741-900466
X-HE-Meta: U2FsdGVkX19FPoPSdF78cktLoRzFoxbZMRXK/N1CiXUfNT6XsYQXcakfkDtQMdH6TtXCufjUaDsUw/nXZTWVRiSt+AAQTDQ/QJEfpwbyxdteAAzz1IjWNQ5PlYw/Bgc4CuR6gVcINx3trofyrb6iO5FCSyW83ANbR/w/kyRZygLgvzwOor2neCSEqptQsAZyewFDMdWpr414HeiBiuoDXvQpWWaJ/WeOe7kVjjgYFI6IPyBvUvMpZBBkPTDwmsx+lZE/o03G4HakEpprBcA/SRnOrZ6IthSuyNY06sjQ45wlhfCE9yeBfqy7Kq/vZhSIQYXgJtC05DqmwFwNGBa/oYp+/HGgDxnr2LXYJ4YvitFKs3jFT0cDy6+r4QOxSL/1Rr7GcP+8GYE8qCSt2WJPLJghqoAArJ+hfJzqKROqTZmTyzc+9P5FmPE/MY4QYU10xHqkleWGagNDNj5ATfdKtBLv87RO2Y7CWa1OkSFPNXj2vNjcBGI/4Eh9GjUGyYr8/2R3qII8Dp64IZP2cudbK9WSaNOXk16mH6g72eWHWrHMDS8JtTV1q9QvZOct4MhBuJw4glIl1/dIdE3jJiZldOMNDHipWUKo5t1S8fO/e2awxcT1W5XAJaevkGNKKRB0dWUDcPmWqqbu08y+vmBNGsnWZINDkv44o9k8zsa3FY+R1yqTn51To6UTun3OSqG06ekYjQIFrwoStSOoAnMRd3gCk2p9IXMPtQtVUmUf+6VG3X56rx4DRIdO3nVrImP4UrZre5av78rfQJd4fprJLPCUPpme741E67VMN1R5TjSAbuO/wdI6P1pTRD3wFtwK30FNp/Bz+cJn3OxbGxGabbqTvztdWISU/kp03+v/ZTojzYxQDOw1iq2HnPdWsaLuOIXdNHGthjHOLHykSwJbb0T4+H/RV7H95D6t4LzvA2kH/jw2gGNvdCTkDozjBrYcOWWjoU3x5LmdhuBmwfR
 DcKRanXs
 rkP0TV6F8N9nfs3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I found several modifiable points while reading the code. Please review.

Chenghao Duan (3):
  mm/memfd_luo: optimize shmem_recalc_inode calls in retrieve path
  mm/memfd_luo: remove unnecessary memset in zero-size memfd path
  mm/memfd_luo: use i_size_write() to set inode size during retrieve

 mm/memfd_luo.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

-- 
2.25.1


