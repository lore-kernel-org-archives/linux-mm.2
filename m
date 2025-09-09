Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45C1CCAC589
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 07:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78ACF6B000D; Tue,  9 Sep 2025 03:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7627B6B0010; Tue,  9 Sep 2025 03:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6780D6B0011; Tue,  9 Sep 2025 03:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 56C176B000D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:48:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00172B942C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:48:43 +0000 (UTC)
X-FDA: 83868934926.29.C50DDD3
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf25.hostedemail.com (Postfix) with ESMTP id A45B3A0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:48:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757404121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=uPQPQW0jcMfrooDwDYyPUhxkeqWLLcrqs1cbiarOzBM=;
	b=4tq3pHD/JCV15pzg0ogbMOOEjKGkToxjDKuu9OAS3ZkrQRB00kDubZ30PlaiDcUgCtbhxb
	aAKfmF8R4yFMOo/exirfOj4qdwiV8RKEDUXIoH+ixKt6T83QTnqZ1w1TitFlhB9CQXQ404
	q3rdNNrd9czSlo8dkkU8oxKx8NpBoP4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757404121; a=rsa-sha256;
	cv=none;
	b=TNBxD5AxAon8BMvKWb8JfPt977G0zKahcIOyxb16PQcsQUrp+DvDZJK2VDmklOR56e4nXA
	Mf4iMZbFFHPldvVwyQtB4fHI0zCL7/pdjCEvc8gridSN8AxtLA1FOhug3aSAK3ZdrnWDLV
	1fqNKgh/T1H2T+99lA43aqctn171x4s=
X-UUID: 603b27588d5111f0b29709d653e92f7d-20250909
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:c9d64b59-8547-4850-8971-4da55c312d9f,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.1.45,REQID:c9d64b59-8547-4850-8971-4da55c312d9f,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:6493067,CLOUDID:de6a38db08b61df599d118a345fe75fa,BulkI
	D:250909154831ZXY1HHMU,BulkQuantity:0,Recheck:0,SF:19|24|38|44|66|72|78|10
	2|850,TC:nil,Content:0|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:ni
	l,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:
	0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 603b27588d5111f0b29709d653e92f7d-20250909
X-User: husong@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1128407; Tue, 09 Sep 2025 15:48:29 +0800
From: Hu Song <husong@kylinos.cn>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hu Song <husong@kylinos.cn>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/slub: Use folio_nr_pages() in __free_slab()
Date: Tue,  9 Sep 2025 15:48:11 +0800
Message-Id: <20250909074812.599030-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A45B3A0003
X-Stat-Signature: msr9wsqas5op8yo8jpgpwno48nky1ozc
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757404119-889124
X-HE-Meta: U2FsdGVkX18jK02+heHBnLJM92Rl+z0aG6sh28HvAPczHDw/MriIZ3XXzMGPEKCJcSY3NeKNmOeBt9fjsS/jNu1iPJVz0dCiyUkSXJI2LN59itigOonM2avAGdDnvPamTxm1LjCsjt9dOQ7V1IET/v8l7RVavwkLvH6HUqN+YXkb5PSaV0vPGNkyDTHYgMwmEETaD54rN4fwQ8gsJMYSopxWnWU9tpevCiic26KMOkBo//QL/sssCal6auUDCUYzm1CWF5ONYBWeXylvcCNZAyY7WSIf6F9g4eBcz/06H9bimJhMmHSuB2hbuvSQ/I+iFuOcG4XOqTM9Vr/qE2LcidwhNzbXSBos7DhAAhYmwDIsE+D97lDbJBTXlOKc/Jxo4z5jKpr03UBiZlc24EbUHkcm4ErgwgggU7pugQ2c6uTFSqk9YAEJ3mHhI7keAOiLwe/MimpYn2oNzJQRE9LpU3xBn4Acrledu171RWIMlGyuPSvpYn2LFz4rJAy2soMuM6sQRsJkpT1T1lIpnGh+j+LdPCBc8uCLCaHtdXU6AlT5ufAI6GuSXoQeBUhUG8CVL2cwHxq0c1FtpJxwS8SqxaNIcoyI5ZECxPDniNUcYgCk+aMu+yLhygmU+W+aUdJYg0h9CXQJi2fLT+2sJ+eU1esHLl8pZPAteW7+/rvrjYZT90yvnNN2hwSansVquDgxC7NqarQCTWNAsK+wx6G7KnZO6GrPV6VU4Bh6FlVt2xFJpufhKiIbCTNZdkTv5sIiJvWXav4TjsTCwWeA4wKaPV0zQGZCn0jO6dGJKYYhMjC1ggIynT5RJRQFDX2NnKXBPTjLAVeAGqVeXac0qmFPgsl5EQGArNcWHoFvXmGrhVirTw4XcoxluWecPoLlMVzS/4lbDQbL9vB7HOX85qlhE7+1HMQBbsKb5znFKOPY6SGp5MABvEgfCHSRvr1+7nEYESrgYcjcGZwZRSAhMLe
 TwvEVwPB
 iOmlzMT5X5BeD/iG4ABE5kyqQMEXdxKkU6twEGvhCLm9H0zXXlrjTW/8+TyJYnP/gAki1Z45t/CD37+axTjBuDDdHlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use folio_nr_pages() helper instead of manual calculation (1 << order)
for better code readability and maintainability.

Signed-off-by: Hu Song <husong@kylinos.cn>
---
 mm/slub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index d257141896c9..eba25461641a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2719,7 +2719,7 @@ static void __free_slab(struct kmem_cache *s, struct slab *slab)
 {
 	struct folio *folio = slab_folio(slab);
 	int order = folio_order(folio);
-	int pages = 1 << order;
+	int pages = folio_nr_pages(folio);
 
 	__slab_clear_pfmemalloc(slab);
 	folio->mapping = NULL;
-- 
2.25.1


