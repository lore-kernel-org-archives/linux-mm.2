Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 532A4EC01C9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5ED6B0092; Mon, 23 Mar 2026 07:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D466B0093; Mon, 23 Mar 2026 07:08:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192C66B0095; Mon, 23 Mar 2026 07:08:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 086026B0092
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:08:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 99A228CC5D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:08:06 +0000 (UTC)
X-FDA: 84577053372.16.89DCB25
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf06.hostedemail.com (Postfix) with ESMTP id CF9D218000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:08:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774264084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9n0F7QjTMCW9jVkTXOq71/m0RIbtYl2H6KxOO9UqMNk=;
	b=RCBdbL7bbEbKkGH31BbIKo8eHSHFrj7y0NuFtbJLfH5mc4PTfNqoY21VPQEVHPhQIp+dQj
	XzsNZlkyk57i9VZSTI3/rC+Iv41ogEiwnmqI5Ak6Y8fsQj+8okThfOOV2hn6XbPTL3CVkZ
	syeK+0Bnv/BySsETQ7mElkwgx1nXMfE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774264084; a=rsa-sha256;
	cv=none;
	b=O/et1IlJC6VvBHXR1V53z8pAcQFFPq2g8AxXnf1VfyyKmdlMVpzKvXPE1LpqmxXqJy4dy/
	XAlXCH9s7arBCFjbYJ8W3t47y7zo9NlrkV2khskjgdaB6BiUJVa7PzEIsn9/9DBLdHozmC
	WxwspXIekrah66/yKPQLXjGDLhRMCNw=
X-UUID: 8bcffcd626a811f1a21c59e7364eecb8-20260323
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_BLACK, ABX_EXPLOIT, ABX_HEURISTIC, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:9374473c-5e3a-41fb-b030-7bade1dc767d,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:15
X-CID-INFO: VERSION:1.3.11,REQID:9374473c-5e3a-41fb-b030-7bade1dc767d,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:15
X-CID-META: VersionHash:89c9d04,CLOUDID:35d7d280d89c5fa9f44492b59306af82,BulkI
	D:260323190759QJ8F4FG9,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8bcffcd626a811f1a21c59e7364eecb8-20260323
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.23)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1845427003; Mon, 23 Mar 2026 19:07:56 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: jianghaoran@kylinos.cn,
	Chenghao Duan <duanchenghao@kylinos.cn>
Subject: [PATCH v2 4/4] mm/memfd_luo: use i_size_write() to set inode size during retrieve
Date: Mon, 23 Mar 2026 19:07:47 +0800
Message-Id: <20260323110747.193569-5-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260323110747.193569-1-duanchenghao@kylinos.cn>
References: <20260323110747.193569-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CF9D218000E
X-Stat-Signature: 997o6t1hrpdq8xg8yhfm3d91oyhica1o
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774264083-886892
X-HE-Meta: U2FsdGVkX18/xWUbWzdBsljSdBCo266jTd2OuA9+kgbm6CwQHY/AE+0UYOojFFPmHjjbgGrDPP4d0t9TusuHy8U/0qzD5+hWvMLIdqAygv7ihH5quI4K1pvc3nzN7iDhkB3ly3xuYnHMTkrlzaTPc5D7PLhKgV0a+md/6K8TH/Raoey6jEmjYBEy9wCdoqVc7GZR5yqlTeK7IKwNaJUZ3/pgeRY2e1wbVZUgGJfDHMeDeNWg+hAcpATmXpbNDILbAXzIrKW05bySt5O4ajjfphp27WMUMHGTiMeXrB8SSZSoTfZkHYk9uuCFFtmaVwjGsjDfudDyQVzxIDWs72q06jj8yJjlualcsNxb8JvrKHHAy/V15/GmRKEENdpI2+/8y5JjzAZzEgJCzAW22w0kQkjHHjztPPsa3bDEIZPAdvLq/RXDJrrtz9NkXmyTgt6c3VS5fbUFgAT7MSygMyYYnHfNnIpVMq7Vdt9/VHMRg0WVzcLxG8hS7DeQQD5g94nZyoL8DQvvaJ3C91LPQ8d7gUkmxmTw9+GFTHOy3g55AefcD0ZXHKoAEsfA8CtjHydw4qYVIL4Hh16pUi+X3cVJs9rFeGVD1OY3OwhUSmEyjYKxJ/Lzn3N+paPttlPHn2fw0SxoeX89xghQFPvsLUSwJFIm2MHpixBNBSToVOcoSBwA8L6tfkMsTC5OphB6U1nulKoibcW67UwEBnrlwM10ScwnFDUpLspdoH+2eGYP1LLbM8umPgsjCezHnqLn/6CBeZgYYSgFwpayqH2JGSdBmudH1Z7KL0a+Ihps5IzLN52NPU6ICo1dFr1EXNkrt76sSeI2han3ernaur4ksrFcAv+SmTM5CP/PvkB6BK1+hd5JVdwedhLOYehrBOcSa5F71QC4FEhFM7vx28+oUajnYYR8zPeBxP5N1tcleBMDGlyC+Mc+oFdQLX3HjpBgj6SscPDKMQq7S60ujqx9xLT
 yYWdrHsx
 zBwBSgNAj38WWyoJUNDarhnOhbBz3LzJFDy9U99w0cFrmq/KhHT9wfrlqZjKAT2bKHswEdO/Pj/FGbWGXUkrmMj22KtX/CrArxQJJX1Z2Q/NQGxc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use i_size_write() instead of directly assigning to inode->i_size
when restoring the memfd size in memfd_luo_retrieve(), to keep code
consistency.

No functional change intended.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
---
 mm/memfd_luo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index bf827e574bec..76edf9a3f5b5 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -499,7 +499,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	}
 
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
-	file->f_inode->i_size = ser->size;
+	i_size_write(file_inode(file), ser->size);
 
 	if (ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
-- 
2.25.1


