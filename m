Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E483E606A80D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DBC26B05B3; Tue,  3 Nov 2026 05:07:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08D1F6B05B4; Tue,  3 Nov 2026 05:07:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5306B05B6; Tue,  3 Nov 2026 05:07:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D13B16B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:07:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62F73A037F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:07:52 +0000 (UTC)
X-FDA: 85393381584.24.294BF34
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5684140005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:07:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793700470;
	b=qgxMP47fGPFilbBWWqlsF+q/AGlseKOnoyiJILXWjOrKhX4biomGtaYsdeUqi1VJjROSQk
	fE8ENQEgt89Is4QtCgbbkG4VmMR6WDi5ytfndqza9C6RDQOY9DMJAOcOw9zGITPm6+j1AQ
	nwSuBvwkIjB04fYG66MvsQi5wMc4O+E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793700470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=SJsmFd97LTwyZ96d6CJJUwteWk3GiFywwWpryyUntpQ=;
	b=yklzYcer7fso7+xTONWoK8RI7Mn7BwPejSnuWqg8XdI8xt4zNYTvwlDanr+K3tDRuWZ+jz
	+2+5U4IFLwmIDPGC5a5R6AF1X/ZTq5UFXB8gWGrL0tzXIrwMOenmw9HIVAWsxXyF7HG/1P
	uov22oBq1GZQb7P+VZzrI8E+Al1b1yY=
X-UUID: 654a2600d76e11f19a56ed5b684f684d-20261103
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:65cdc808-a4a7-49c3-92dd-10e53b2f0b2b,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:65cdc808-a4a7-49c3-92dd-10e53b2f0b2b,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:a56069770302e11e76778d73c0ce566d,BulkI
	D:261103180741YRSD4B2I,BulkQuantity:0,SF:17|19|66|78|102|127|153|850|865|8
	98,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,Q
	S:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,
	ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 654a2600d76e11f19a56ed5b684f684d-20261103
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 812115188; Tue, 03 Nov 2026 18:07:37 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	lienze@kylinos.cn,
	enze.li@gmx.com
Subject: [PATCH] mm/damon/core: use list_{next,prev}_entry() in damon_{next,prev}_region()
Date: Tue,  3 Nov 2026 18:07:14 +0800
Message-ID: <20261103100714.70742-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5684140005
X-Stat-Signature: dkpckjwwzsxsxuh8ak3tgh1xi7w9e5pt
X-Rspam-User: 
X-HE-Tag: 1793700467-272761
X-HE-Meta: U2FsdGVkX180iZN8KM38g1iPDl+vUwD8Zbje0ItgXyjOj8UYzVAiK2GZBf3Odt4CpLgDsaiDYZ+KvjtY72SkuAFxneHCBX4PkE41WTTf0R0uRxgO28gruYuacIYwv85QD5A/mlNAMFaAFEsi/LdGNLYzi2sNOvwDQ/Sm3Q9sTGbgTgnf+TpmabGqTUi2d9RVgl4rTug0DT47QaE2A4RfFsI8+RxpBBPmWMjpQwxZxKsCdt4HNdAjUZNPUmpv+xZ+/cZjOd/xvMYyMLjmKoOGB6TjjN4GvEFjHb5rEqvKnQIDc9iNIiNFmYas9ZE8u3xKI9MQqDX7+qKB4XG4jZrZxFnfUvPUr0qvoOkcvuZ2QytYoTUWlwgq4WjvYrfCtWOjjiUNy1YucKHKgT1tsizAm714GiqSbQLrLL6LZRXahLx12xDg2Zx3shP5aRh3FXV7Pxf7/JHs2r+sfRwzlzuZMuHGwCSPrwMPeAYPKIaYD2K/KSS3LD+K5WbDfwxoiKep1dVp6QDl2ZY1SoN99AWyeNxR6AxB2ITH3Ijk7FEvFjWqod+vOm8Ld/2uUkNt8frAwaIl6EfdlZxRw8ER8k3V/bBE0E+o/Q3E0wsQRRmtx9SEi8Ifr9mFK0Oo/0slOtLQ7H+LxTqzj85vf3LGfR23McLU9BsmtwQOyHpDD/tV9x+YkXL4zOiGJ87rpwXiJMhur2qrzQFyHmltjeQoxow6w2TxlTHYlm7plcEN4vEAadPjgaaTeMZmMUNCeb5QqBuXd2JkDqE/MAOu7yx+mD00jDrgmVu7twRoQNS/QjMPfERVzo3eAt5jc22XIlbIBf4rNFMSxXOO1InkakK5bL4mACg6cSsGb8Hmyw4a85Pec0Bc2S2CksvEQ7u2Rofk/iJP+S2LNmQIjK4VK9zyTyXpw+X1jsvm0Iwe/ONb40+ZqVkXOo1+G7vIKmck+V8//9iEhoMEK1GDRHbq3IPjaRJ
 Kqrl4RUM
 4OCxocvHpX/MEr8JoVFC2Gnev1acdRlji7I2R93WcISZwsik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_next_region() and damon_prev_region() manually do container_of()
type casting to fetch the next and previous region from the linked
list.  Use the dedicated list.h helpers, list_next_entry() and
list_prev_entry(), as damon_first_region() and damon_last_region() do.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 include/linux/damon.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 380f9cf6ddd8..2ba43257e043 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -988,12 +988,12 @@ static inline unsigned long damon_rand(struct damon_ctx *ctx,
 
 static inline struct damon_region *damon_next_region(struct damon_region *r)
 {
-	return container_of(r->list.next, struct damon_region, list);
+	return list_next_entry(r, list);
 }
 
 static inline struct damon_region *damon_prev_region(struct damon_region *r)
 {
-	return container_of(r->list.prev, struct damon_region, list);
+	return list_prev_entry(r, list);
 }
 
 static inline struct damon_region *damon_last_region(struct damon_target *t)

base-commit: 74d73ffcffe03804f97e9fb82301dadf75671282
-- 
2.56.0


