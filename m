Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E496CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09B166B0005; Mon, 18 May 2026 02:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 073226B0092; Mon, 18 May 2026 02:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2CD6B0093; Mon, 18 May 2026 02:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E03446B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:23:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B6BDA082E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:23:00 +0000 (UTC)
X-FDA: 84779547720.20.6E1F3B9
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf02.hostedemail.com (Postfix) with ESMTP id BF40D80005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:22:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779085378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r43CwBwIi3toJMo/WsNciYWSPCp/NP+V2yhG7/1Nhqk=;
	b=2BPgVv5ULu4qBdgdKJRSxF1ntgjSUCh2whdhK+44Dlqxn6/sxX46rDlOY4t4BVVhFmRA1J
	cHyTuGHlah6i5Qa9IZgS9kywdjj4GKZwcogxzlyXDB8Ia7izRrdZAqZ6br7XnanPYovuQs
	dyvFTTdHzHtl5jjZUhFz20WKXuH+gQc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779085378; a=rsa-sha256;
	cv=none;
	b=Z6z7SiwZho6i5RVoqwfoGwxmMdFD2TbPOvd7/4BIXiuCrR8BxPGEc38qm3pJDKATBhPScS
	N+ds9WIWSQ3sT1ccxLiRTueL87Cz7oYfvBGVrK6VoRj8YbSLFzuR5dzUj9QP26XMt6Qfmk
	DsHOqSQyBnYV2fxT2BdQxhwqrTEF+aQ=
X-UUID: fee33fa8528111f1aa26b74ffac11d73-20260518
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_UNTRUSTED, SA_UNFAMILIAR, SN_UNTRUSTED
	SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:874b9364-7eb1-4e1e-a659-34bd78758c2c,IP:10,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.3.12,REQID:874b9364-7eb1-4e1e-a659-34bd78758c2c,IP:10,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:e7bac3a,CLOUDID:4c9be5e5b8d040b36dd29ab3c86f8fd7,BulkI
	D:26051814171897ZSC5HQ,BulkQuantity:1,Recheck:0,SF:17|19|66|78|81|82|102|1
	27|850|865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fee33fa8528111f1aa26b74ffac11d73-20260518
X-User: wangxuewen@kylinos.cn
Received: from localhost.localdomain [(223.104.40.146)] by mailgw.kylinos.cn
	(envelope-from <wangxuewen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1788346977; Mon, 18 May 2026 14:22:50 +0800
From: Xuewen Wang <wangxuewen@kylinos.cn>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH v2 2/3] tools/mm/slabinfo: remove dead assignment in get_obj_and_str()
Date: Mon, 18 May 2026 14:21:58 +0800
Message-Id: <20260518062159.80664-3-wangxuewen@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260518062159.80664-1-wangxuewen@kylinos.cn>
References: <20260518062159.80664-1-wangxuewen@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BF40D80005
X-Stat-Signature: oh3uzzyxn8f6x8xfn3xjyzxhjywtewd3
X-HE-Tag: 1779085377-4233
X-HE-Meta: U2FsdGVkX19cEuwfTIAPsD9If+0tOA8lV2CPVK8xIneD69labVXO88cJcNAlXCwXCoMmiBVure9Uspj1NHeiW46iY3/UbtQc5mT7A8WVexVJHQYLgpiDWrfPTN/nqF4pGgBoL78M7Cu3SxaHoaWML0tu2scR56G4kMJGHKQ5NEwZslLYWuR66Nf0769ys67cUpUx3NmfYpksMyRHBA62mY5R0CcvHH4B6zOF9A9uGmxPf8vtbSeiLw5PfB4/peRvxEQFo2Tfi3WO+5UFKXoRLfjYGYWIhz7Tzruh45zfG/LVS4ZlZNt4m+RstlaQpY/2bFpEeE/1f9PAkF8KEoFsiEEm6VDqF48Ay5bpCdb/oRNHNoj7gcXUM5vOVXhVNZnDPTZedOw8LdCJ3tpsmFF4URMy1cxZevn/Rg8mm97s45l6n9xsZWrWVKp/zno0djI2kjE/UCT8inXOU5YBL+DUgKwn1SiaQ4eRnOPro/YXlQao0LByMD620O97D2Ao0H75JF2f8c5JbPs7pF06wldUQt0el+Pfvi7ZCuJF0oA72agf8hYmQqXNlaTlbnDnJPQC1qTDpHwAwWaC9dc8/Nc8NducQY0er7EKNRMBIgCFvT+Yr3llYU6GE+tCnbBRjwQdpbKLYEp97T4aH0EimSFr/LW4qoZrp4u3cF2LxklErhdY1CraLtKnVweYdTn/d14NHJR1l1AYu7Wv6GU8x1FbyLOH/OksX8ngT0wqVDDmp9jeEYC/GtuePofUeIO3PzxRSHHgEZ8hN1yn9hQ9AcneOEK1z68lCYs+nZLRobeuScjKVnifewpMUsfy0EjeWdyLy6EBBzLJGBAkSTD5KpTCkmHoWETlStyTrStgstmrI0oZmxkGZEAlSxgcwUNKjGl7AhjoVs4mL6iajH61Ic8JIosZ3HJv/oegIa+CZrKeO0x3xBiU9WZlMdcsF8FN3zQEHUArEFt5kJBeOmqlN2A
 cXX31b9U
 0VUgyG0GSP2bAd4LvNRuxGLRrylkLD23DNcgayGo1nDquJ0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The assignment `x = NULL` sets the local parameter variable instead of
`*x`, which is a no-op since `*x` was already set to NULL on the line
above. Remove the dead assignment.

Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
 tools/mm/slabinfo.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index 39f7eae7eecd..685bcdd03568 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -193,10 +193,9 @@ static unsigned long get_obj_and_str(const char *name, char **x)
 
 	*x = NULL;
 
-	if (!read_obj(name)) {
-		x = NULL;
+	if (!read_obj(name))
 		return 0;
-	}
+
 	result = strtoul(buffer, &p, 10);
 	while (*p == ' ')
 		p++;
-- 
2.25.1


