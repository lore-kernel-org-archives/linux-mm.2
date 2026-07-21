Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70E2EC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 07:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F14C46B007B; Tue, 21 Jul 2026 03:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEF276B008A; Tue, 21 Jul 2026 03:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE296B008C; Tue, 21 Jul 2026 03:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB40C6B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:08:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A5AA1C0405
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:08:35 +0000 (UTC)
X-FDA: 85011905790.23.744077F
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf25.hostedemail.com (Postfix) with ESMTP id 40C5BA0010
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:08:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784617713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=X246P69v5xWIJy99zRjPH1h8+D4BJ7kGk49Ao+NNIT8=;
	b=kFGX00eUHGD/+7pVKK5fUTTiOZ6Pc1KxmSxABlRq3CYg4p5QAtDrirTwDJaCIF9rqg6gnH
	N9Fb14PL2QLeTxXnrzpLEv/QXB9Rt6LIV4iAcl3PvSNmPNh2+goRwWk1yCwXAfoNDBtSpw
	3eTlRZq4ZGniXmrhqyLP48YSrvpmGL4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784617713;
	b=HfKo0My7X72yCBHJMxc9oRFXiMFO/deN5WLWjhBWU19VnvqvaHclJeq5AcPA4F9k3UuPRX
	guGWQyqVlLUKUChmncJmhQpRFQoySlTcyS36e8Mn/k7yC3oihnZJ00UrAvcu8zy4ps2tUx
	Q+kX9zMW01ShZ+AWoy6tZh0mwhuILcA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
X-UUID: f4786c2c84d211f1aa26b74ffac11d73-20260721
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED
	SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:1039956a-eda0-460d-8a04-ce272dcc0a8a,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:1039956a-eda0-460d-8a04-ce272dcc0a8a,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:9de877802313be25eca46f823632e7ba,BulkI
	D:260721150201BMQXQA8Q,BulkQuantity:1,Recheck:0,SF:17|19|66|78|102|127|136
	|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bul
	k:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,
	BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f4786c2c84d211f1aa26b74ffac11d73-20260721
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1449868546; Tue, 21 Jul 2026 15:08:20 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	lienze@kylinos.cn,
	enze.li@gmx.com
Subject: [PATCH] samples/damon/mtier: add comment for struct region_range
Date: Tue, 21 Jul 2026 15:07:56 +0800
Message-ID: <20260721070756.54435-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 40C5BA0010
X-Stat-Signature: stiu6rsjsy937zwh7wmkuzqprux6oy8o
X-HE-Tag: 1784617711-592810
X-HE-Meta: U2FsdGVkX180DItXBFuZrk5/NOxOjJTrey4ldg2LD9Y6d9lvWFKBw3xYCQ1D5/NPzB3UtFjFOV3WdysVGBfoMjakQe1OWXLKJJy5cE9YjrKCfzyLQbQQ4bLi8gi/kkwlalezqSMStn+hqjtrYS/Qxbx4i8BSxSNkCrRe+KGq3leDdjSnetNdDd7i5xw74kPdGDbbxJIYlShbxTkDXOM72kY+E9ve976kyw54YIrOUC2Ct2cpqL6PBtrBpM51JF0Ljem9YHNpx3Y22CGQw4OvoFvsCNWKD1EBbha6RH3H4WAjnEhuQkJxA+HnT9TYbrCiw1GQ9KuF4gtqGNQranVd/xYSWTOfa0pcF/64mbR4xnjUfkjcUjGJCNrno1GSQ4dFqU+NMJ4vwdaUGEigvVCUMWRc5V+ZBNEWirObJnSRP++WErcuZLikTfbVHRLr89J2U7/8hJemkRW5Ns2trZG64hO7wzs7rKsWm9Qnx7aMd3qFzNoiipVYJyGO+TrwR8fcflrzvjNeIGhWoYhwFoaafc2v0IBZSLDi18W2TnlJTtJaL9pnw4FFZeDEsGR8yUSgGLvRXFVKX1u3DG7xv6FbBD16JNsGBUITR3pwfGI1P0C4RyerzP47Q56fBk5QFdqwLkv50VDICsINMTxdX5PapQAa7M1lQmCx+KMzNy7jH6Htv6lNTO9qlxI6ILzSve5+qziiUF1xkSkadEQmrf+907o2mam0ND5eMfU8JKEcE08Nf3Wm9B2PVd2CB93gOSmaxOIH/ywhrsQXS8bt5K9qzA5R7oxNYQzg12G9nOtR0iWEGxUAgV1kvoXjHgKkgfJg+mJRNIy22v5SYsXio9VYg1xsiARhxt2MoZ1YKG4mSnPbdq9dQeyVnHXlT63GBLY+t+eAqO42gV/9qzAThPDb8aEziFejFg6SaxKZ1B+51QJrNnSP//ApoTM98rROf8XXCctqr7dGbPE2oJ11/mf
 nZ4fEuUW
 fpM+9q4ZZOLmvZguDpMdmBwq07lGFrMKK3WuOetIj2x93TU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mtier sample defines a local struct region_range using phys_addr_t
instead of damon_addr_range which uses unsigned long.  Add a comment
explaining the rationale: on 32-bit systems with more than 4GiB memory,
phys_addr_t will be 64-bit while unsigned long is 32-bit.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 samples/damon/mtier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index ac9c24b92ead..27dc88bdf7a0 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -52,6 +52,11 @@ module_param(detect_node_addresses, bool, 0600);
 
 static struct damon_ctx *ctxs[2];
 
+/*
+ * Use phys_addr_t instead of damon_addr_range (unsigned long) for physical
+ * addresses.  On 32-bit systems with more than 4GB memory, phys_addr_t will
+ * be 64-bit while unsigned long is 32-bit.
+ */
 struct region_range {
 	phys_addr_t start;
 	phys_addr_t end;

base-commit: 3d18f3499c48ee94a49589500ce94e41c5acdf4b
-- 
2.55.0


