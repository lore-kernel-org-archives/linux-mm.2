Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68CAED358EE
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 10:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598506B0088; Thu, 29 Jan 2026 05:09:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545ED6B0089; Thu, 29 Jan 2026 05:09:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452A06B008A; Thu, 29 Jan 2026 05:09:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 321F86B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 05:09:18 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9BB71609A4
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 10:09:17 +0000 (UTC)
X-FDA: 84384578754.28.69F5894
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6FFE41C000C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 10:09:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769681355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=uZr8fGxKS01qx6n+DTjmTtIQgB5ogRGe0GId9onw1GM=;
	b=xA1wowj7LQHX2JVDyOoHSoBXN2+e1eByr+BMfQDiMg2WFGGCoUvgmE0um4WQ/ctS/fQrAq
	xroChkhdhkUUiXXvwaW7kzJV7zqQe1j8LfUmHaokiuGk9ht9T3MNaoCaEOp8h/agh2zpBV
	nOOEHBR8OEFk5PpvNzzBsfewfwNOUcE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769681355; a=rsa-sha256;
	cv=none;
	b=t9vm2/hmh9g8KG1wMGAP7ibrrg6ebr9N6BYrb0ZUcNxBDbM4+M4TEEETes2pCyFzZ41PqZ
	xz8TU+2ouQHmIY1BLVxAy8wCZhpDgNuMoUXWt3qlqWz+aJCan0B2TgLHrymh1/J4nsp5Jh
	jBWSpJ6B3+FJ47oxresuzZEf8y6x4yU=
X-UUID: 8b8f8a7afcfa11f0b0f03b4cfa9209d1-20260129
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:2ec3349f-6695-4d8a-89aa-7a815a0d107d,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:2ec3349f-6695-4d8a-89aa-7a815a0d107d,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:19b08d9f6453e99ff74c5d1cf405e70d,BulkI
	D:260129180423GNAAQXYD,BulkQuantity:1,Recheck:0,SF:17|19|38|66|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,
	QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
	,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8b8f8a7afcfa11f0b0f03b4cfa9209d1-20260129
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(183.242.174.23)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1600268495; Thu, 29 Jan 2026 18:09:06 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] mm/damon: unify address range representation with damon_addr_range
Date: Thu, 29 Jan 2026 18:08:45 +0800
Message-ID: <20260129100845.281734-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: embdjeuzksbu1d95y8zmsxhp9zmnuo1o
X-Rspamd-Queue-Id: 6FFE41C000C
X-Rspam-User: 
X-HE-Tag: 1769681353-973884
X-HE-Meta: U2FsdGVkX1+ANSaymBupnRyzWZOZ2qFvAfki7KexKFVQAIlJkMrcIqWzw1oE6uJ6c4ZWsVeXUYt/7Pp6c+DvCj4XXro7dqZWC9yWTW5mEtECfLWFRcBdvN30wTptbOjrcSS90wdsZNJCJ7dU6/7H+p2t3IZ8nc+y4nL/QhZxgRkGOJdmvtf8ynui1MZY8CCHAMBRpQ0F01whzTLT1qzvB4gHTj88i4z7tctBbqu3sfkDTb7G9RSUD/CBqvysIjBBs00Mq820tOYVxaXrZrE6jwm0IUPOVqoZ7F0oJQPCKcOsF6YUugRq8knyl3F2PwJoIH9xT/nOzI7MN47vgBO84IiY1tlHOwv397oQ94LrrHYIQPMMl6QY/G7DMV8C/LOZhw4Ui3/g9IIBcuKwTRcRrhTeKa9ooZYrE2qDScEBRx+3w3sYUE/s5/gvKCLhP01Ht1A1sds88Qw2I7VMYDKBfUdpQr4QbiOMxRJu2qYiYXVep8A/4+OSjF0/sw/vtnaXA9BQam4CknrTE+EyMy7xmfzOUOjv/DhtMidaSdYyTdKrhukoQrcY3zHOeQJ0Dz5EMwNtbxWlNT7bxskl3Y4z91QmGE41ZAOf+J5dGsNfS+CvCel6oKQeMze9w0HciFgAvaYA01X9571R0iYezUA/TgdsoMvkAxeV0hvWHqawhQZ9Ps6P3gmb0pAUlCM1/WjkLaBFDnZrdSlPp5BPZ4FVx9X/xlJq9pbTkYEv0omkS0fhi1PFgWRMKYMSya0CILPukZd6uPxF/pGYH3ZBvm06YUxzUNWpj2ci7dv3sC1NdfLuEcEmevaf1/m6rN/eBETwPooL49zP1k1/AV9rfpkBLdag9yrV3eSXqzN1dOXgj6sRG9vHnDah1nkONBFjeN94yQXz+EUoK0B7LmGyNzvaOsUWP3UrGB00zgoO6ewTxCE3HX0iivP3yAzzZfM0hzH0NiUavVb45nnUP/+UUNW
 RoQakzkk
 WqPkFuYmmT/VXji4Mz2IuyyxlqQxucOAbOjgnUONvtahQWQ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, DAMON defines two identical structures for representing
address ranges: damon_system_ram_region and damon_addr_range.  Both
structures share the same semantic interpretation of a half-open
interval [start, end), where the start address is inclusive and the end
address is exclusive.

This duplication adds unnecessary redundancy and increases maintenance
overhead.  This patch replaces all uses of damon_system_ram_region with
the more generic damon_addr_range structure, ensuring a unified type
representation for address ranges within the DAMON subsystem.  The
change simplifies the codebase, improves readability, and avoids
potential inconsistencies in future modifications.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 mm/damon/core.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 70efbf22a2b4..5e2724a4f285 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2856,20 +2856,9 @@ static int kdamond_fn(void *data)
 	return 0;
 }
 
-/*
- * struct damon_system_ram_region - System RAM resource address region of
- *				    [@start, @end).
- * @start:	Start address of the region (inclusive).
- * @end:	End address of the region (exclusive).
- */
-struct damon_system_ram_region {
-	unsigned long start;
-	unsigned long end;
-};
-
 static int walk_system_ram(struct resource *res, void *arg)
 {
-	struct damon_system_ram_region *a = arg;
+	struct damon_addr_range *a = arg;
 
 	if (a->end - a->start < resource_size(res)) {
 		a->start = res->start;
@@ -2886,7 +2875,7 @@ static bool damon_find_biggest_system_ram(unsigned long *start,
 						unsigned long *end)
 
 {
-	struct damon_system_ram_region arg = {};
+	struct damon_addr_range arg = {};
 
 	walk_system_ram_res(0, ULONG_MAX, &arg, walk_system_ram);
 	if (arg.end <= arg.start)

base-commit: 0241748f8b68fc2bf637f4901b9d7ca660d177ca
-- 
2.52.0


