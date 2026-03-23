Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53E6DEC01CC
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5436B008A; Mon, 23 Mar 2026 07:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA52C6B008C; Mon, 23 Mar 2026 07:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1946B0092; Mon, 23 Mar 2026 07:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F1F36B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:08:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4994CBC9BA
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:08:05 +0000 (UTC)
X-FDA: 84577053330.20.04EB2D5
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6AD3B1C000C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:08:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774264083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8eUS4P1DdGX1ne7SxWPtHJ1SOStAefW8pnHyN9lgvNo=;
	b=SSdf3c5aiH4qLlee8UJHW96GUi4fNMzM3gw74nsrycbEJtL2bqGQ8RKTuLHNt9X4tmf5AH
	R+P4Q5eaLn0aOq6OWQTARljyPgPfDayvaX96ZU1XAW/MN6bdpefATmPswZt8jO6Sn7sVLW
	o/VHNqfQ1BCprpAZr3flfB6cIq9eABI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774264083; a=rsa-sha256;
	cv=none;
	b=QX5iajefAEZ5kP0gTciTg8QKa5b7o9hgu/Z5DAkJRXonnZZLpM20qCwREgcRbwHwpfiCjR
	zDabZHb+t3NbEmN6T83AZ2ZtCIvft0pJMJ0TFFnem75RKAwUYlePjqs6TY9Ugg/DD8QQKK
	hgQv/hZKCXnjpKwmiMhxg9hhof6PrzQ=
X-UUID: 8af4f47426a811f1a21c59e7364eecb8-20260323
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
X-CID-O-INFO: VERSION:1.3.11,REQID:409a51a1-cf5c-4f28-b00c-1f3fb4bec1bb,IP:20,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:10
X-CID-INFO: VERSION:1.3.11,REQID:409a51a1-cf5c-4f28-b00c-1f3fb4bec1bb,IP:20,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-META: VersionHash:89c9d04,CLOUDID:509e87f008c7a3d2379aab5affc109e8,BulkI
	D:260323190756MBG2A585,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8af4f47426a811f1a21c59e7364eecb8-20260323
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.23)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 475137973; Mon, 23 Mar 2026 19:07:55 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: jianghaoran@kylinos.cn,
	Chenghao Duan <duanchenghao@kylinos.cn>
Subject: [PATCH v2 3/4] mm/memfd_luo: remove unnecessary memset in zero-size memfd path
Date: Mon, 23 Mar 2026 19:07:46 +0800
Message-Id: <20260323110747.193569-4-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260323110747.193569-1-duanchenghao@kylinos.cn>
References: <20260323110747.193569-1-duanchenghao@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6AD3B1C000C
X-Stat-Signature: mmdz99g9y161pwmms1gi594da1os7ysw
X-Rspam-User: 
X-HE-Tag: 1774264082-837938
X-HE-Meta: U2FsdGVkX1/w1EbpUBI0exjF5XMSzSHcbQAuz/PXmT6KwHTcEjnWLxIcZy5sPRrO5bP+EXOcGJ8vxJQtYYbY1C6ewYbftyVldCXbREdENLLrnt+4MdOK6/HctGFftCdVaSsZpxTcEZvmVP5VQl66lR8VHpGZBZ/qPH8ACuiMeIMPYFYV9oB6wubpkFQqJBBuM4IINpKl6Am6piO951vP8KPJRLWmaZUhppvNpbZ4BsSMZbhvQFZPmJEedEXHj/VuXWkXeHpg+dH8UqCGTJNca34eqsmPlaJOQsPug3ooUN4b6m8whx6OzSjb2uvPnD5fS9H5PMxnFSoZCJPuXXTW6tqUyXDHgKJgnu/woQuUUnDA+mqzdGCyDZ8qiAy414U5WuLXuAjtOnI3NFAyrm9i7F2vm19HGLVDBjvhBl772hJMitm5LzAOn1AtHIu56jGal1hWtqk/AHgcyuVyvgS9x1a3qo1Bxfoz7lUAec/0af1yx/RPlz7pBpSceXgBgDVGP4GS8s7Xf5ir6GD0ZA958NYKn2kmWI7txR7VtunnpCIwqMZPV+nAnoKMT8Y7INMadd0euFjxGlAinouuLF48hrwn1owYqhuFaPBtC6P3gEqtfqRBHuagvHhwP0eFCjlE800PlZEes9ChQ056kXP0uKRLf3NpVXtAkcxA0OyzcFH0RiZEL0wH0dYxhWf07yQI9AtmJEoAGf4Gy6PjKJEfCKxmlt8CKDPlQtMBwOhVG4L98YJknAokv0cnrDWUjZaEJ8W1e6Do1HYr/P/o+vksnqXGZqcXNgNFRkpQn/fufDDvnkIyF1f2rzfMuyA/bBhzdWtUyIZyrHxL59R4HQ5olm2YrzMgUSz6QO5QSiJKVo0OT0T6sX9msmFWw5Q9j2x5n0Y+CgrOG0yM5AnLWRumk8wM49pyjARmFgfBIPKkw+uh0PUML7TXBG/EbidtTuwKlfLPWsjSkbcpo4emw9a
 ZpCVmVl+
 r8g2p/mDuKlg4OjR1zQkJMG2bhIT/OlNQOhcYSNaueU62HGJHkj5Mj4wXMndtsKYVdtWuJXdlNUOdBe3YcuRZlOr+f4xyZXY4vS3E
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


