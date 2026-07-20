Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FB6EC4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 13:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10F5F6B0092; Mon, 20 Jul 2026 09:07:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C05D6B0096; Mon, 20 Jul 2026 09:07:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD0B6B009B; Mon, 20 Jul 2026 09:07:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BED696B0092
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:07:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 550C8120188
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:07:15 +0000 (UTC)
X-FDA: 85009180830.20.4B261D8
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf30.hostedemail.com (Postfix) with ESMTP id 09D9380012
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:07:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784552833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=0kJY7muOD+OALOOAOmMqpvL3t8Yyw3M7anrSxwmFM3E=;
	b=D45NFlI52oRTPgZA8Jewr57Mjb1E38QnOiGGl+D1wjvKZj7yBxip5fhIQiCTeC2nd8FYS5
	SQ+ClBsCi0rFAwUAmmOnZZqQpzqEV0ivyLNoXcMjLnNGLj5fmDPxOYz9H+tiFPhek0q2Aw
	01qHJaZQsqlqM7uZaRi7ERIpEAZvmUk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784552833;
	b=y6kiglLvnkaqQoEsqWuIkTHLX+zdSJwLc+dR9r8dF9YqLP/FD0CiAOyuPWJ2q0Ay+9Cg8r
	YRRH6OxNfmDH3rK72CdqII4AfPZdRtIWcKNTDAXnph+ITuPqFXR6icjAFi0xfGcKwfL+BX
	PO6wCB8ssBELwc9+lfFg+nm0wrvJ4rg=
X-UUID: e4737b38843b11f1aa26b74ffac11d73-20260720
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:a7d9821b-5224-4c18-86eb-e17116515eae,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.12,REQID:a7d9821b-5224-4c18-86eb-e17116515eae,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:e7bac3a,CLOUDID:2100e216361bce3249ee41bc74c42a17,BulkI
	D:260720205347EDB9HWME,BulkQuantity:1,Recheck:0,SF:17|19|66|78|102|127|865
	|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e4737b38843b11f1aa26b74ffac11d73-20260720
X-User: lienze@kylinos.cn
Received: from ubuntu.. [(61.48.211.50)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1692005296; Mon, 20 Jul 2026 21:06:59 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH v2] samples/damon/mtier: use damon_addr_range consistently
Date: Mon, 20 Jul 2026 21:06:42 +0800
Message-ID: <20260720130642.508355-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 09D9380012
X-Stat-Signature: 8dmg8j55zn3of13nr7bn8jqfi65wh5pm
X-HE-Tag: 1784552830-12335
X-HE-Meta: U2FsdGVkX1/s417eKEX0FabrcwiSeoq4kfnVu9fI0XgZDj5NcBgchtxmbGncFFLM7oK5Ljr/ydnxj0vLJHf68KWu+QCKyFGC4losKxxIKZEwMlsn9UG8Cz9Jm+PNM19PqLBaXvkkMfe8mANwkvBK9PXzmqP+ag8Eb9cbzXAJ/8ukcCndeoXa1eNCm1OorMNbh1F1xgx7qeu9kCelZzh/NzibFsKEbDSj7YtxMqXUbM1Z69bQdHF78bh6pqxbezprN/uekv4Ig5yhoLSkqMYxC2C5tnDapVxO1hEEGpC74ykOcxB7ULDc8U3rptX0kDgVJkhw0jWgIf++CQzeiJ9ZxzKvpwqDHF7qEVNa1JmhdjR/EnPDnWOc0IBwuH9cTTks06AJs8KHdEmqxVNZFS1XCOYo46rgcFFoGTjBYocdrsGXJ8dmsYgse2A0oD/YGY+3POUi0x+NAiEwhRX4bdKiCR4+320s3FcuVPajksznbrJtbKToJlFUeBr6FcyUsPqm9egU4Ux9FqpjUgaCk6fi/t66ZW5piulC9tj8wSUhBGFACgG01I0+xJbcty0f4L6/t/E63XwInFjnGv9Ljq5iG7gpWfzs2oT+Ok/GOuRzgWrmf1fiT7l/UYjs0VJbf0rJMuWj1rpiuVOWOTDFDqik5Jn1QQd5BjYXy6nl09Zr8ifFqWC4N37kSHnwp9YxpYcs9q75+vI8UsdUtBMGLccucGP6koxdaqMfqb6Kwn5kYP74pdv7OP5mpx8/yVSinAs/T0R+lp+Y9pFOZ3yMO9IxwCPHtC3C0H696NL0jMHQGHSsivMnzorBK16zp9Je82zcf3CtSYJDx2dvvirf2B6rbt0OKQx74A2d+mpve58IOJuaXc+eIJTXhzkbdu4FB/B1+qlyCPq/gIaMwJUgdewES4zzOguIOIkgrdAgoJ+9EVyyKvPpfkQK5H3aSTNWt3wEwAwVkWde5R7sjIo0NPK
 hphB4U85
 iBHIgLZLUE7/2tfCnpyqCFd5nHyaom+rA+oKzoO/404G6I7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The DAMON provides struct damon_addr_range for unified address range
management.  However, the mtier sample still defines a local struct
region_range and mixes its usage with struct damon_addr_range in
damon_sample_mtier_build_ctx().

This patch removes the local struct region_range and changes the
parameter type of nid_to_phys() to struct damon_addr_range.  It also
gets rid of the now-redundant local variable and pass the address range
directly to damon_set_regions().

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
v2:
- Fix inaccurate "identical layout" claim in commit message
- Remove redundant range variable and pass &addr directly to
  damon_set_regions()

 samples/damon/mtier.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index ac9c24b92ead..3712287f009c 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -52,12 +52,7 @@ module_param(detect_node_addresses, bool, 0600);
 
 static struct damon_ctx *ctxs[2];
 
-struct region_range {
-	phys_addr_t start;
-	phys_addr_t end;
-};
-
-static int nid_to_phys(int target_node, struct region_range *range)
+static int nid_to_phys(int target_node, struct damon_addr_range *range)
 {
 	if (!node_online(target_node)) {
 		pr_err("NUMA node %d is not online\n", target_node);
@@ -78,8 +73,7 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 	struct damos *scheme;
 	struct damos_quota_goal *quota_goal;
 	struct damos_filter *filter;
-	struct region_range addr;
-	struct damon_addr_range range;
+	struct damon_addr_range addr;
 	int ret;
 
 	ctx = damon_new_ctx();
@@ -123,10 +117,7 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 	if (addr.start >= addr.end)
 		goto free_out;
 
-	range.start = addr.start;
-	range.end = addr.end;
-
-	ret = damon_set_regions(target, &range, 1, DAMON_MIN_REGION_SZ);
+	ret = damon_set_regions(target, &addr, 1, DAMON_MIN_REGION_SZ);
 	if (ret)
 		goto free_out;
 

base-commit: c872b70f5d6c742ad34b8e838c92af81c8920b3e
-- 
2.43.0


