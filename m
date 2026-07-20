Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 297F6C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED86B6B0093; Mon, 20 Jul 2026 05:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E88796B0095; Mon, 20 Jul 2026 05:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC4F36B0096; Mon, 20 Jul 2026 05:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B329E6B0093
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:24:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27528C077B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:24:42 +0000 (UTC)
X-FDA: 85008620004.01.32798A5
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf03.hostedemail.com (Postfix) with ESMTP id AB4AC20009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:24:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=R0zr1bqamzT2qGYmUL4eh2Pe+oPLRxJPpQlwDfLCMUQ=;
	b=cXl6lqDaDHEgYiFzUgbqFIct6Tu7e2GyaPzTZhySuZ5BgFJzTXCcYAlypiSp/rrDVvrD1E
	uPQr1drPoZ2WSqlwdKKvwROPP6zghvB04mynApuzAARUGSVxYXVj5UmJsfLkuyPIOuCtez
	KKZf35zRxH2FwXiXUvh81t1KpEGs0EU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539480;
	b=egwnsvy+be3xPK8fFAq+VvsyijkF7fYZMSkoyn+r0zVQQngLxTgsCLhhMjdwFBZOGrY845
	ZhD7jJpN96Tw2IRLc+8U358gUmFCIvBRZcSlaa2kBZGHoPNM2Or7mSYS7dzJGvoMfKaiHJ
	J7ViVN5QE320HF6On6QM/VavvXZsRfw=
X-UUID: c762971e841c11f1aa26b74ffac11d73-20260720
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:067bea3c-795b-47d9-b4ee-297a79d01cc8,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:067bea3c-795b-47d9-b4ee-297a79d01cc8,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:be2d59487f0c83131b6ccef6496139c7,BulkI
	D:260720172146CJUOA45I,BulkQuantity:1,Recheck:0,SF:17|19|66|78|102|127|850
	|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c762971e841c11f1aa26b74ffac11d73-20260720
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(39.156.73.11)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1126628943; Mon, 20 Jul 2026 17:24:16 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] samples/damon/mtier: use damon_addr_range consistently
Date: Mon, 20 Jul 2026 17:23:55 +0800
Message-ID: <20260720092355.237599-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rmz4wmazjngwf46z7g9ke1y8kgffaekj
X-Rspamd-Queue-Id: AB4AC20009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784539470-248546
X-HE-Meta: U2FsdGVkX1/x0It4E5+5C/1FmIE+cKjZKyGukV3Am1ni5pPmRigy1ajSkY6k7Vjhg5X49VKnNxsx97p5HT/cPFlvKToWsWzsqWtDuB+zFRvT8lv1ueO+VOxjse6a8UYVrONpHfo50qGJLDAlQrMo3noBh0+dezUBSasfBmaCysn4KSn8HA/X5IFEWrQ8ePmFA1a1nll1OrmAQBs5i1drAws0i/vhPW9Fw0+J3tCNHNp9BlkhIfO1le6Kn3CJQrGsAUAc9dfOh26H3rPCteN1zBbJJQ7S3sJb3MwkqkZDCmk9n0dugpYbwfsRnWoK1DavCmsJMZR2huH1fnN1ZZMkTgBcvb2xm7QN4ajCYUwAbxjI/on4TU6QoVp8UwtlTvk0rMNhyqpnvcatMSDDxyWHlFAw0vXX9Rbg6sV4ErQ9KJzipuL7cIcU1pCzyKfbgbA86DqQf5f0A5m852kQNaO9swhLzOWmwdonmT7ob8y5GcsClGQi2u61tgVHxjubiHEtzrKFMSSr0IcXZYqEDYWZr2rBRumoy/GvI6FDRe7SJfV/MOZuezb+dkWkait+pVkSiZiZCDSAq2/H55dvF9LrSkicp6mO9GFTyULeY0RUYh9CbY6tkpH3d5xf7awf4HrUl8nxMWoXQLvrdStlbmx+gSdi/v8g233WaYvreK7f1W/j4gQG+0linLxx2sDVuka356Oe32X2T/n4SzI7gyC4SuuRXhwYJTqU2hnF8DpqUyhkWf9hppw9OUrBuNfr339CeQ76VuPxWx/U2YYRmD9idaMtX4FujknkIRRVp687DISQTuFQk4lMZpSxZLdMQUAyywmKenm2m7zQFm347GDFfj27CF4LfXm5zhtsiVHEjoLQ0vCjnEOv8FflUMtpmGLEbgM68kfm5ciEs6ybz3wzPtCsrd0L/HZ+ZzsaCcMUSzXnLBlKE0cGcyCpNdJmU7PdL5y3A2FW/TDz3EfM7W8
 DeN7uivK
 2XlmTkAYBGpHBUmSoVDuNqxefOmiytQ2L6rcpaQQOZ2MFunk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The DAMON provides struct damon_addr_range for unified address range
management.  However, the mtier sample still defines a local struct
region_range with an identical layout (start and end as phys_addr_t) and
mixes its usage with struct damon_addr_range in
damon_sample_mtier_build_ctx().

This patch removes the local struct region_range and changes the
parameter type of nid_to_phys() to struct damon_addr_range.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 samples/damon/mtier.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index ac9c24b92ead..67f20b52dc7b 100644
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
+	struct damon_addr_range range, addr;
 	int ret;
 
 	ctx = damon_new_ctx();

base-commit: c872b70f5d6c742ad34b8e838c92af81c8920b3e
-- 
2.47.3


