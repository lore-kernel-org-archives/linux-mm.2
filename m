Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98E9FD116F1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 02:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B95F06B0005; Mon,  1 Dec 2025 21:14:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6CB56B0024; Mon,  1 Dec 2025 21:14:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA99F6B0026; Mon,  1 Dec 2025 21:14:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 998C56B0005
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:14:32 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 413FA8990A
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 02:14:32 +0000 (UTC)
X-FDA: 84172911984.02.CB1006B
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3242CC000A
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 02:14:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764641670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=fHYKaRWiOsg6+N93I9fww2FsTdZYkZjWIJ0GarPk72Y=;
	b=6NQ1LDRyZw7HsIJexS7SJegcpjIKY+zHr6CzxvyZy2cCjed5g4VbAlyvY9ccXW7mhnjTLD
	WBHpKky6yoYI3bMPyV4Ye8JhAR2xMugjRTmIZMu/6PeWddrcOB08WixkuPVwOP/l8lmJ/b
	ZZ6Fd/VaPu5qRI5bOTLrr5V51vjUUiM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764641670; a=rsa-sha256;
	cv=none;
	b=kZalRcUHOGaJDvvZBQUPXH8NawuDNDzD6X9XBsvkofgjArEWESb96xF5LPhjGOiWl4Pw/P
	s03pFEFd1fQTKMg8zhEmPutfinKp1+s6SVKkYf+fum0oQQM+ziJIlSIIqRxXbNo9Y7FDaL
	ePEQGOc87LwJ9f0OtOdbUzaHPQZbVV4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn;
	dmarc=none
X-UUID: 9dbce656cf2411f0a38c85956e01ac42-20251202
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:a9f3be1f-e302-4a7d-b298-b6189dd2f276,IP:20,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-INFO: VERSION:1.3.6,REQID:a9f3be1f-e302-4a7d-b298-b6189dd2f276,IP:20,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:15
X-CID-META: VersionHash:a9d874c,CLOUDID:1c153c2c6cc70ab6555d3353e4b6db72,BulkI
	D:251202100923MMTR89NJ,BulkQuantity:1,Recheck:0,SF:17|19|38|66|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,
	QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
	,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9dbce656cf2411f0a38c85956e01ac42-20251202
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1943159812; Tue, 02 Dec 2025 10:14:22 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] mm/damon/core: support multiple damon_call_control requests
Date: Tue,  2 Dec 2025 10:14:07 +0800
Message-ID: <20251202021407.11818-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 3242CC000A
X-Stat-Signature: e9b4yf5s73egm78gnb3d1u7znbmt4wao
X-HE-Tag: 1764641668-421905
X-HE-Meta: U2FsdGVkX1+IUrJWEkIA/ZYzf5V//bIHdTqW/gXO/HIOTQg/HaAz8zoo8DVn2f2QV8zL2K+OAmYbUy35FFqhpN411LZfIzj9EyfZPLGZg2lKhuNOdl+60ZAzU2qviHydGkf6LHJqQocBTt5ff+5SpRVpWJd9tqBPGwbUeqmwJnxpJEgXGkGk+hJjVKtHbBq3D2hvVtIRo7WxYDnuzuuUBePH5jPuSxayQx0OxmzBDwu323YsHUZYXkwvdblVofbSWVtKjp5yEaReBwLH/IQxP7lVeyB+gI+uZhB5DzXF+bVhlej8BOvMu1Rs6Fr+DC2NuGSpeYweGlmNMcZOyHRvorVhHN5nXW93sJrqa2aR9/dKrKTFVb4MyRwYT5UDxa+KLvCZfr2VBfvxysWR8rJJsT0qGChE09dlLG/0V8sDC/jxlrubl2Yz/aM2IsIESCcb7Ztrscyl3ht8p5qv0lrPbG/1WOBwlhCog6IW5JM174b/OUckxLIby/tCPeK/8Xw+mJbz3aVXH6O6NiMQNMFfiOuhn9WOhjY49N2xOSvKInF67TIalc1AQaXFyeH70emc6fBJQExYICDGTt51o1SSLW1dKovmHBMYQIYZELds6ADs6c1UC3OCKOnI/pj73DpYoADxBcU1fbgohcSikYWqbuHcCdgCd3gSqfgaHy/LD3k6JmPkVr8wyzI4gFDuCqKw8TmJBovCNHvm3wzFzQFlEDalFTTZXz7KSZzXxrkMTeK7bT/jProqEKJh7THk7xtKUrp7Vf9wQvpMlavPIBBPgGWCH4tCT7dP/XqjVaxrE41n0Kf0voSFkCl1yU8/eMNW0daJvThjU/Dx3Z38W/ciBjgwGlc8eb3PUGVHVOPADMyQ+a3PFa0HOmRvTvZsRAy8OPg2kXb87Q2Wp2SUcFuQAWBWGuV7YbQE4gLVdijpxnNK7NXWsp713h+YFik4gaZyTjocIz0ePDXLkUcYMId
 XKDc2V0R
 lMlCS2m2KINxPHK53utjUY6fLR1odkYIkrAIgS5AMXo51+Wo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current implementation only supports repeated calls to a single
damon_call_control request per context.  This limitation introduces
inefficiencies for scenarios that require registering multiple deferred
operations.

This patch modifies the implementation of kdamond_call() to support
repeated calls to multiple damon_call_control requests.  To demonstrate
the effect of this change, I made minor modifications to
samples/damon/prcl.c by adding a new request alongside the original
damon_call_control request and performed comparative tests.

Before applying the patch, I observed,

[  381.661821] damon_sample_prcl: start
[  381.668199] damon_sample_prcl: repeat_call_v2
[  381.668208] damon_sample_prcl: repeat_call
[  381.668211] damon_sample_prcl: wss: 0
[  381.675194] damon_sample_prcl: repeat_call
[  381.675202] damon_sample_prcl: wss: 0

after applying the patch, I saw,

[   61.750723] damon_sample_prcl: start
[   61.757104] damon_sample_prcl: repeat_call_v2
[   61.757106] damon_sample_prcl: repeat_call
[   61.757107] damon_sample_prcl: wss: 0
[   61.763067] damon_sample_prcl: repeat_call_v2
[   61.763069] damon_sample_prcl: repeat_call
[   61.763070] damon_sample_prcl: wss: 0

Signed-off-by: Enze Li <lienze@kylinos.cn>
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


