Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC051088E5E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 01:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9ADB6B039D; Wed, 18 Mar 2026 21:29:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E78156B03A0; Wed, 18 Mar 2026 21:29:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39DB6B03A1; Wed, 18 Mar 2026 21:29:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B41886B039D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:29:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 469B38992B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:29:06 +0000 (UTC)
X-FDA: 84561079092.04.75057B0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf26.hostedemail.com (Postfix) with ESMTP id 89F9A14000A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:29:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773883744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0lRZEiNdI8hGeIR746xyaRO+/LtP6vF4N7i90g9r+0A=;
	b=NK8g5x7GII1iihdzv9CIrI1wxe590rYrwg7mn3v6y9rQ9GPibQDOUvckGpbouIiRlh8AjS
	ou+RWOqygEQ3UD62KQr9UsrCKXXt/D/w/XKRJNtb9Tzoo7BrpoH7SiouINDzL2ut6R3KwM
	k16GZKg39aWN/+nbDNNmaMmyo3pTGTg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773883744; a=rsa-sha256;
	cv=none;
	b=kr9MLcJyY46lBA0cpQ+on/3qxruemZ510/1UCbnYsM5TbMvoHIdiqXt+n7ka37kl86EjGC
	lWjwL/0mVyv21MaaJUqcA0PjybAg/OJq6yDDiLvNhxhhozJ8OrumkY8r3lYC5mQqfY3sLW
	cV8TH1cY+S3E0JRUM4+FODpSSjajZUo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
X-UUID: fe2642e6233211f1a21c59e7364eecb8-20260319
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:caf5b2b3-d0e6-40c8-b11e-a43a30cf23c2,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.11,REQID:caf5b2b3-d0e6-40c8-b11e-a43a30cf23c2,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:89c9d04,CLOUDID:0ffdf6325e8b88ba6818234b35eb601e,BulkI
	D:260319092857GKQUZZA9,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fe2642e6233211f1a21c59e7364eecb8-20260319
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.22)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 178793136; Thu, 19 Mar 2026 09:28:54 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: duanchenghao@kylinos.cn,
	jianghaoran@kylinos.cn
Subject: [PATCH v1 3/3] mm/memfd_luo: use i_size_write() to set inode size during retrieve
Date: Thu, 19 Mar 2026 09:28:45 +0800
Message-Id: <20260319012845.29570-4-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260319012845.29570-1-duanchenghao@kylinos.cn>
References: <20260319012845.29570-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 89F9A14000A
X-Stat-Signature: ukzi6s1y3gcdmebxrrrk6zgqww5j1a3a
X-Rspam-User: 
X-HE-Tag: 1773883743-733624
X-HE-Meta: U2FsdGVkX1/OtQz+OhZm8Ogi44zSpkeK5HwEBCZGRoDMZ+auEIYYSWIkTmFB9m4yyfqy0kLKllYqr+O7rrp8Qxpz75uIL3Yt6QkFFDD5FE/6hJR0m+B9SUv2DWj8eAtMK1F8l4qdfbz2up9Ltno4qysK37wIu3XmQh+ZSP6uRj7tRbqrYbKzNQS4FyZP6+f0aOFmWfauxRT6FlwCUhUWBDH+aUSrp9eVSd9QHz7Trm6riPZ3wx/IBfvuyC5GSSMqi3cR+h0RTh53kz/KOl5TI/0WMXdkBgLCprrXKW/CH5+E4RgvVewtvpAtxPunVDVDDb2zDgPBH4y2OzC6WiOcyrpNftWpSBVdkkS9agUMNTw4Zx5sjjc7j5017B7YFnxsx10Jtz98m8cyCJV/L78azqkOviSzcKWKw3fH2cXY/L3PRLa7dYe/+kE6N8eh80Ansj9SCGJTbucl+EGguphbvdEzGKgJ3akSiwSFzVVxWii6v3UYUL4H9nldIF4Ia2oHkpUVTa48vQyCIqozzKQaJ+JjDNNAy3Lckr7ADcL8S67F8N9tjK+pJIP4f1AVMohfuuAVgHxneG+klEOO44UkubXn4anwZAfSzOntD+9CW5Im4yIFOrz+v54CXciNJA0mEC2ODDo8fI2ln9oXAA+PXDmUMK11IKyU7pVDJj1p+REfBp3oW8gq1ouVNfEqBXSFaeQBfGr6d09DdRAqi3Iw+5mMdPvp610trMRmSONk5YreRKlaSmTG2NfdIHBLpQXGjiMi8uxIClPMmPOupv/3kM8BacQrnXbnUcDRYty4spSGhDj7DHcIvl0MYuZ4u29KOxo2EpJai9NupEnEuI8pOskNlgyTrA7KNJXU61oR/H3P95m6VyOCrWSKs39tyJMQrc51uWWi43ZEAZDayNysMSi5//KI8hNsl2cJkNIW5qylU32dNUivuT7JlPfOJcDLjkA5EuSIh1PvUo+P708
 qZQjZkvc
 Pz+YynJjAyrB3usP1ImTFpx1Yik5HV0lnkRAkI/UAd5ZQOhQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use i_size_write() instead of directly assigning to inode->i_size
when restoring the memfd size in memfd_luo_retrieve().

No functional change intended.

Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
---
 mm/memfd_luo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 413df8c75c1d..5e5971f25c68 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -500,7 +500,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	}
 
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
-	file->f_inode->i_size = ser->size;
+	i_size_write(file_inode(file), ser->size);
 
 	if (ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
-- 
2.25.1


