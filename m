Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F23D6C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 07:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 877546B008A; Tue, 14 Jul 2026 03:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829CB6B008C; Tue, 14 Jul 2026 03:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73EA46B0092; Tue, 14 Jul 2026 03:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EDD26B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 03:54:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CF24F80168
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:54:34 +0000 (UTC)
X-FDA: 84986620068.03.4090715
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id B8E334000D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:54:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784015672;
	b=LmvLfg0Q7VeGq7y+kWmY4GBi9Nz9JL87x7VL/89k9DgRlDi4DLOJl8usJ93RziMiz0eMCh
	PR6Z2FLhZr6ajiYnzl+8YTJjNknSEEr631RtlIyqXSE8ubGyqaHPNrNFSFJIipQFO4FFxK
	7IbLA/4tsL175QvkpvmnSbj9AS4xS50=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784015672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=muNa2L0Gvr5P+2C4uM3KspCgbioyyBjLnvMIGOkl3Gs=;
	b=6HcbdGx/9aX7BglN8pIRKo2mFrBkyV+6KZvXFr+E8ckBgWrVD1eUNSWUyqbbSQkWmtf1+d
	2Thzux2JYtRpMO0wpZ30fQUCjAkxm1AoIojrgWInFR/qFbJVlpjHSaDKmziIJT7zeeXCpe
	7HT3Laf9mvkgwPpcBVwOReyD/rkWT2Y=
X-UUID: 386c8df27f5911f1aa26b74ffac11d73-20260714
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:05dbf085-a693-45e8-a0b6-84f55bc50ee6,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:05dbf085-a693-45e8-a0b6-84f55bc50ee6,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:40f5943f7a49aee119523de9c1afc868,BulkI
	D:260714155423MQ7OG88W,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk
	:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,
	BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 386c8df27f5911f1aa26b74ffac11d73-20260714
X-User: wangxuewen@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <wangxuewen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1772328423; Tue, 14 Jul 2026 15:54:20 +0800
From: Xuewen Wang <wangxuewen@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH v1] mm/damon: remove trailing semicolons after function definitions
Date: Tue, 14 Jul 2026 15:53:58 +0800
Message-Id: <20260714075358.1592393-1-wangxuewen@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B8E334000D
X-Rspam-User: 
X-Stat-Signature: 88guo8adg9ryoyur67z83jonb54az6eq
X-Rspamd-Server: rspam03
X-HE-Tag: 1784015670-209664
X-HE-Meta: U2FsdGVkX1//QMQO2JvyAIRE5ZHDSK+708tKR/QN90IloNcHYSSZaJC/b01rYiNU0As5DepTkqB3iEO1edSAamv3gCJiYewCiOnkGrpKsqbn4pu6LdP+eCzJ1aUbuJd2oa6gQRMoBRg4tgjf4ETwcgt3uUGRT1WeWg1AIMh0hoHBCakomLnuJehVtbgBHsWdgngxaRyZFq6PoCDYqJF7S2oVhvFlUygd+icVwoDnC3rESrRIrrHw9leGShdbg1Wt9IhKvhn1XS1OFZsfa7ogMOU7xNGHw2woS9iyvOVkrtZuQyUjthx0yD/RfFiR8hY14axN9lt0U6hfLZKfS32raedKKdvxiM2WsZALuKmJR//Gm2eUfRekb+nLZX+FETcb/sJke3Tsp/kYUSmKo8pJwokHx/5EhL3PkJ/saPIKgMO/CnCCA6VFaXq0fsM5wgHaBoJh8v7DV4gy0qCEpOBeHV2S14/qgf8q1KOSWOYTPAJ1J+xhPehOm/zmRmupsnBhY+6fFNmjBh6qZA2AaWDzNmAG428USlKo60oSu1KypKkB6gC6WZe8ITV9F2y80hOVg1yIdzWzEL4g/Er73pGdg5RuIefXCabckvoGL+Z5u4axtOPSF02waBcx/VfJeR5ldCtNY3jxKwB2SaqJK2+pDe/Q+iQO0uiorT4X+eHXA01khT7Q2oTKaSmu0VBFGlvCLEph/M+/By752rLqr/6JQY51XOuYdHEkMiI8iw/LYVGm389zuXB0oELk9VvgKeOUucJlXWmdvzVrY44WiJJLDe+eWgJ/JNVW42xU7iRipuRONZl/BWW4XOLu5m/k8Nc5Dttec147QeILZcPTPC09dZ5O/XZa04ofQMYjOahtNpULXJytpORR16aqxv2An91gNgiFVecLsJ6njyDA2IcM+ERJArSVgwYQkMSY/sQ7AKllN4kjDmALfjwGBU9jJBirxTe0ZkLRl6gbp1FeSHD
 BpX4pE0H
 O/1lA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Three function definitions terminate with '};' instead of '}',
which is unnecessary and inconsistent with kernel coding style:

- damon_pa_initcall() in paddr.c
- damon_va_initcall() in vaddr.c
- damos_get_some_mem_psi_total() in core.c

No functional change intended.

Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
 mm/damon/core.c  | 2 +-
 mm/damon/paddr.c | 2 +-
 mm/damon/vaddr.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7e4b9affc5b0..4197957009aa 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2579,7 +2579,7 @@ static u64 damos_get_some_mem_psi_total(void)
 static inline u64 damos_get_some_mem_psi_total(void)
 {
 	return 0;
-};
+}
 
 #endif	/* CONFIG_PSI */
 
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index d0598f5f2688..17353b14af77 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -453,6 +453,6 @@ static int __init damon_pa_initcall(void)
 	};
 
 	return damon_register_ops(&ops);
-};
+}
 
 subsys_initcall(damon_pa_initcall);
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d27147603564..13f4e05f871b 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -983,7 +983,7 @@ static int __init damon_va_initcall(void)
 	if (err)
 		return err;
 	return damon_register_ops(&ops_fvaddr);
-};
+}
 
 subsys_initcall(damon_va_initcall);
 
-- 
2.25.1


