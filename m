Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85C45C44520
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 00:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553496B00AA; Fri, 17 Jul 2026 20:22:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504A86B00AB; Fri, 17 Jul 2026 20:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A1F6B00AC; Fri, 17 Jul 2026 20:22:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1451D6B00AA
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 20:22:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A34DB1C01C5
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:21:59 +0000 (UTC)
X-FDA: 84999994758.27.333614F
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf28.hostedemail.com (Postfix) with ESMTP id B0101C0003
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:21:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784334117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=QRWM+vXzo+aNWC2yHWozek15z0L/s0h6o9EA3tvNK38=;
	b=CUi3UFLlVJ4DDosaI3TV1Lcay9nKV8Oyi8C+WWs9VgSn68ghu5oSALRTb7oWVyz2S2YDGz
	MEmKch6ulBdwpa1V//WWQIHePX649jNUaGLfWEJdBcArCxM8qscEgy7NU6yo/5FQ4CSn8A
	OZLAkuT0/pEXatc5dfueaV+QLqph+0w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784334117;
	b=M4RJme9q8gc+hn67ePb6Ymtem55M/ujg0/MHa/Qk94jcYzctdB4ZhSWfRbt+UFfP73nVhD
	Om9fpOvzuOerNWFo+vPzN29OtU8uWCViveL7QCcGPkIOnXAGYJ1rDla3SpQ+oXlvzZIbQh
	XG4/JVute0VxFxmK9Jm8YPO0mr6eXF8=
X-UUID: aa19a4de823e11f1aa26b74ffac11d73-20260718
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR, DN_TRUSTED
	SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD_SPF, CIE_UNKNOWN
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:80970e74-c171-4c61-a9d4-aeb85d044d43,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:80970e74-c171-4c61-a9d4-aeb85d044d43,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:b73bf3d1b5b3b8f522fdafe3a7203f49,BulkI
	D:26071717541216H8SQ0C,BulkQuantity:2,Recheck:0,SF:17|19|38|66|78|102|127|
	865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,
	QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
	,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: aa19a4de823e11f1aa26b74ffac11d73-20260718
X-User: lienze@kylinos.cn
Received: from ubuntu.. [(61.48.211.50)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 197839938; Sat, 18 Jul 2026 08:21:47 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] mm/damon/ops-common: remove redundant local variable in damon_migrate_folio_list()
Date: Sat, 18 Jul 2026 08:21:25 +0800
Message-ID: <20260718002125.637104-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xzmbbyjbxjixqmq1tzknj4nerbiegd34
X-Rspamd-Queue-Id: B0101C0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784334116-940487
X-HE-Meta: U2FsdGVkX1+z6vN1G0waeiiOKpmLaeJxDXMvzabfYBK01qIsWnr9hp/kFVZ9RkH+w+YGuVyBGkcnx1raX/KV/LaeX7XVUF1mcKQv3cyjJ7FNm/X4C8j7og4tJGS2I+neOPOIHaBmUBFRHXouo6RiQ4DOBEiv0ADsRFNTJSgzNwxSuMXNgdomB7oLV2skhxbDyOV4q4KuRnunFvnakkphrlg3af8YkpTgcWih2qPytnAjXQqoD5zTcZHmqiTUPf4JFBwEX9Szc70WbR8uemHUiIRzglMiMWwC47jQ88Now+seHCVw5vjVWSdPjjXFBVJrzR1vIZ3tYXuKBHbZcM3TdnQL4VBkW2KKVnyRPuCkSHETXqrSMKuUkJSWsqrRoDH8muBP9CF28LyfIMPwdh7hdRVjhoJVBxW5PPx4JXApKuAbMI23GHt2lytyi97Gq6cTzhVSRquRlgwDJIRFGs831SEyPsaS6oREZrk+hNAOyt17v2FDkI1/v10itdSyhVAy2m+Ci3ZYQflp49oS7oh6VjjDJ9ber9kY3Hz58EvsaRe3z8u2Jrn5KFadUsAqyrtb5i2iWRbFDucn8UcrNxJtur9twBYuIHolZKAEhr9ysc7+8gxD9a0cgG+DMOLdwQ/x9UldQVSiJg7VarbmE2Ew3A0HT+SDNR6GjHV/c1xqpvNWHbOiLRz6plNwi+4rY4aP/ESzRl4f6wtY4+rU7He0x1AOvb2yTj7IvJUHXsljomWWH/tRqgSNOiX0uiYQYW0wrX8McEUV8ChDoOQ8jF60tnFILaF1u64nQrW163K1EAu3Xhiw7QTdRGYr7MgexUnKsd5iqRJndoAOxZiG6nsMJdB/EX2KD+AirgbDt/hraOCX6v9/H8XZmHutC1kJ1eEGVhk58JVVZkhdoQApKT8KaFe29TyLgyk/pZo0CnK6/gUwtRpmyVYF5063aQt2e7h9qvDQi6JIATqxU0TC2hP
 4++aaZ6z
 jOHqmTkSMMiPk4gwga5SOeOXkREGwEtC9uvBXdVJeCF+9p2E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In damon_migrate_folio_list(), we're redeclaring folio inside the first
while loop, but it just shadows the outer one.  Since the second loop
uses the outer folio anyway, the inner declaration is pointless.

Remove it to consistently reuse the same variable throughout the
function and improve readability.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 mm/damon/ops-common.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 89c694f6e4fa..e59f5268d503 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -339,8 +339,6 @@ static unsigned int damon_migrate_folio_list(struct list_head *folio_list,
 	LIST_HEAD(migrate_folios);
 
 	while (!list_empty(folio_list)) {
-		struct folio *folio;
-
 		cond_resched();
 
 		folio = lru_to_folio(folio_list);

base-commit: 5093dba1014c1d7f7e247fd118f0fa8f22136046
-- 
2.43.0


