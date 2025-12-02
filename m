Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FBD7CFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 08:24:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3EA86B000A; Tue,  2 Dec 2025 03:24:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0656B000E; Tue,  2 Dec 2025 03:24:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9052B6B0010; Tue,  2 Dec 2025 03:24:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6386B000A
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 03:24:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 281891404B2
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 08:24:20 +0000 (UTC)
X-FDA: 84173843880.09.BC4391F
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1BECB40003
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 08:24:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764663858; a=rsa-sha256;
	cv=none;
	b=21WgD6+SgeX/WsSIAljOVRGEoH0YZY4EAbikdDuTtfOQVH61mhwzLH2zptWgdcnyu0lsuN
	N6BxtHBvZPB0UACwX4ZvJa3sSG3Qv5LxpzeBFixg1YgLHwqGSOMmybynWB0SmTlXCQCFiH
	++HoJY1FijShveP3yyCYY5RipuoqmMQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764663858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=LpeacopDBhPPe5TFvooOpcpYobn5V0UKqujTx++vvdQ=;
	b=HV+obVFjfY6JHhui9W6tjJXBVm+YdfY7GgJz7qhqOPKahvAOmGrWQw6wy78+DavfUxqa/i
	RjzOgdMJNKPHwC07DVXX6H/DOr2Vqpdrqm9k64All+Xcd0CIoRYrE8oIjPscynntQK42Zm
	RlvCqBT0b/D5I3Gx+CwFM6m0hLP6fzk=
X-UUID: 46ca03b8cf5811f0a38c85956e01ac42-20251202
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:5b0a11d2-6636-4121-957c-d19857d13a91,IP:10,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:30
X-CID-INFO: VERSION:1.3.6,REQID:5b0a11d2-6636-4121-957c-d19857d13a91,IP:10,URL
	:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:30
X-CID-META: VersionHash:a9d874c,CLOUDID:ec9fa82b32e5a8364594f7b54fc66544,BulkI
	D:251202162224G2J2RGFC,BulkQuantity:1,Recheck:0,SF:17|19|38|66|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,Q
	S:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,
	ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 46ca03b8cf5811f0a38c85956e01ac42-20251202
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1168385708; Tue, 02 Dec 2025 16:24:10 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] mm/damon/core: fix memory leak of repeat mode damon_call_control objects
Date: Tue,  2 Dec 2025 16:23:40 +0800
Message-ID: <20251202082340.34178-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1BECB40003
X-Stat-Signature: 1m9fidx3cjindhik7me88pyk8iugt4c4
X-Rspam-User: 
X-HE-Tag: 1764663856-75968
X-HE-Meta: U2FsdGVkX19J/gRvVrYYKKhTSYLsAk96HnOVCTSvYJjVc+flkulDwzD5hkcgdTCP/C1eAGVM65TM9CpKYwQk6Tj1y7TDq4CfOIdqabU11+nXDHkE1WRF9Ne8kixpHE7NGeeXVl++axFb09xv1dK9R7lp3gOgImD4ynDxPBOqmykTo5v0R9r/6bM3+//XqIlLVdcutJirDUm564+xnRKM8KTohHOLfEXJGYzKsg4muonTMN/ZimDGsxCsIhbxxM9Vm7V0hxYzHvPSFzSHBLzSGNpyZq0PWnqL42ZXs3wS837jmcL5DPlk/rv07Tryex+keH1Ad6lC7+Ptn5vrTL0Ez9Ao8lQc5lO87yofbpMJoMQaUyJo+uWpYQWn08lyxEgQUwu+Z7CZxqvcCE/0IoGGN4wuO0kTseqitP1R5FTld5aM3ut/Qh+R66v4Xflld+WLvxu8bZgRUXiV6FNnvG17RoPKtK6XbAeStU+rZbwGDROv0rZWMenSJvVGLCbjlQL5pmS9x0e+9dMW0EBzziuRLju+aeWhUJtMVPrbNQmvlR6/UayNMcKXMYg34I4vqUd3grNZnwlz4tYGcpWYR72oF09IVzr/L6OlCQZoP+smuCPt5v1lXBypF8kRxjbEkP2DyXKABpljMkLGZ0TFtAr7vU+JGP0uby2C6AOeq05PXCowL37eFYw5YuHzqB/+Mxerl7uPMit1/Yo2j6/AEkkk9RAXO+UyS8IPOaXySHvoh6Khp/huF4ZhYZCbwRiVbnp1nuFUHyVcZhPGRYCpPhYYI70kD6X1DGW1VGZ0baXaUwJ7PGLN56diDWQ7xpaQa+3n1lJwXxEhm5NY7GXIkhGBtUGHDjAtPYum7GIdQe5wF1n3Akw06ZS3rJE++i5xEg1rZ/XAAB8WL1Blvw9Pbe+O3mVyXtJ7BQ9mBDoCTbcZULBiZyMTcwCMCkV1+cdKqjefnDaDArplcHUvylemRUZ
 HI/RIHan
 96OiFWfKoxh2AF6plfOsFinbOYj8x5LpMPSOImRNs1nIxk+8bbyFFcdfncQGszjbAVVE1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A memory leak exists in the handling of repeat mode damon_call_control
objects by kdamond_call().  While damon_call() correctly allows multiple
repeat mode objects (with ->repeat set to true) to be added to the
per-context list, kdamond_call() incorrectly processes them.

The function moves all repeat mode objects from the context's list to a
temporary list (repeat_controls).  However, it only moves the first
object back to the context's list for future calls, leaving the
remaining objects on the temporary list where they are abandoned and
leaked.

This patch fixes the leak by ensuring all repeat mode objects are
properly re-added to the context's list.

Fixes: 43df7676e550 ("mm/damon/core: introduce repeat mode damon_call()")
Signed-off-by: Enze Li <lienze@kylinos.cn>
Cc: <stable@vger.kernel.org> # 6.17.x
---
 mm/damon/core.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 109b050c795a..66b5bae44f22 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2526,13 +2526,19 @@ static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 			list_add(&control->list, &repeat_controls);
 		}
 	}
-	control = list_first_entry_or_null(&repeat_controls,
-			struct damon_call_control, list);
-	if (!control || cancel)
-		return;
-	mutex_lock(&ctx->call_controls_lock);
-	list_add_tail(&control->list, &ctx->call_controls);
-	mutex_unlock(&ctx->call_controls_lock);
+	while (true) {
+		control = list_first_entry_or_null(&repeat_controls,
+				struct damon_call_control, list);
+		if (!control)
+			break;
+		/* Unlink from the repeate_controls list. */
+		list_del(&control->list);
+		if (cancel)
+			continue;
+		mutex_lock(&ctx->call_controls_lock);
+		list_add(&control->list, &ctx->call_controls);
+		mutex_unlock(&ctx->call_controls_lock);
+	}
 }
 
 /* Returns negative error code if it's not activated but should return */

base-commit: 7d0a66e4bb9081d75c82ec4957c50034cb0ea449
-- 
2.52.0


