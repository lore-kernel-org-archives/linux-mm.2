Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C82D1CDC6
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 05:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 345A36B0005; Tue,  9 Dec 2025 00:57:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F62A6B0007; Tue,  9 Dec 2025 00:57:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20C416B0008; Tue,  9 Dec 2025 00:57:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10C5E6B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 00:57:54 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5A471403F2
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 05:57:53 +0000 (UTC)
X-FDA: 84198876426.03.58DF26B
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9F8CE40008
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 05:57:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765259871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=G9QJUce7C1/hhUjySjfVcnAcCGL4smJfqpSdBq+tWdU=;
	b=HNUksvSdDev2dJaI1bvGx/MXK0BTqd8Uw7A18pGdO+Po5ClB2bCjtUAhG6PcQpWqbWBIPo
	i8Hqly1XBbiCDRGEUOxvperr7EyzqZ8BrsbYUNH6OkRIWkx8FLLMY1nMvJYFnWGmQPIm1O
	npenC57qLt0WjeDl3OYz6ZH3wpak3bY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765259871; a=rsa-sha256;
	cv=none;
	b=XFC9ToxF99fzeDZPW7a8Y/2ePzqy6Bf8xTd5KugspiX1rxVRkMWgOYJ5rD+KwNNoS8uIq6
	ZYvDkWqwZutclC6jxcxdqeWpyCc0ocbL+7SiulaVl5IvXsaszA8WPvJuAYrDkeJB+v3Xiv
	PWaoMEO3pKgoYtFRY9gdzAzTwVSadv8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
X-UUID: f00bc2c0d4c311f0a38c85956e01ac42-20251209
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
X-CID-O-INFO: VERSION:1.3.6,REQID:a4ee5210-558a-4a02-850b-aae16ec0cb53,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:a4ee5210-558a-4a02-850b-aae16ec0cb53,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:e41193994fc12412c7bb15a61e65599b,BulkI
	D:251209135728SMWVWXEJ,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f00bc2c0d4c311f0a38c85956e01ac42-20251209
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.160.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 902813503; Tue, 09 Dec 2025 13:57:25 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] mm/damon/core: delete damon_target when detected invalid
Date: Tue,  9 Dec 2025 13:57:13 +0800
Message-ID: <20251209055713.270737-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9F8CE40008
X-Stat-Signature: tctr1krssx6snp7u3otrks8kyrsqdgep
X-Rspam-User: 
X-HE-Tag: 1765259869-203124
X-HE-Meta: U2FsdGVkX18yxJvP0rRjWEc7EOMj3kDl4Z3G4MMpmh2b3W/FYm9dEQHCos3HTHrjztWF1sbIAEYI7GvOpJTk1pJLGnJ/TGf4/7iQvYZfLnu3bMeEAmhXsB5A38qRSHN3gzahoBnmm+wmxACKB+csCXj6JS2BdaqfuKhM1SoGa6FPijEosO3BQODNeq+6iho98CnRd+Eav6K7rOYEr+QV+z55b5G/5sRxJwgRlW8dOP07hNlhgFtpoH+lv1Ox8B3qbOpiVltxBsHjyzF6jYHmF71uRpDkSahxwrjsmt4qtA62PIWVvXrPOxX+GvuvowIX8vT130VxnXQ72Ev6tF4Fx1GEqAcaW11gGoqTSrSnjH+mcW5DjLiV7mKNgTeNBg2MZWXwL+ZxFQBZpkpzefEbx49q4iYebu4OLrJoe5zYTCgHaALeEbPlR6vYkcbMXFJurPcl0Cpt7su0rlUy6eaTOFpalnLHNM5e8HB1yqp1fb4U8JD7+UV1KIF802CyTII+A9R99keQZG4aRbPFYOLp5mgCsZ2DEO+GasOqNeitsC8xU0L65UQUm/O33AYRcaCsJL6dssQLDf/v+MmFeLdzgZehynSVkd3HLX6+OaY2R4c3FNkiKJg9dHH5YcrALLt6GvpuGrxMiqg4rTaHwv7hyER747gkn+SsdB+xLEXp9GAZyXJL3gKBtswyp1p7Op8SqvHXsWK0AByB/dqmL1O3HhxCIecoojJSANkgVVZkdV8ZuFJiCzWzELFn5QshBeQ85Ik0tpPnLqCLN9n24kMIun+OKBpK7GM1fdk5eL5/ciOtHiLau4gBbotdls/0u+EM3r8ZpRkMUxwmkfDP1Mj5UIhuMFD2ZWKdQL7ZydO/9p/WCNJpYS6TiwkvY3Su+Q5lumtXpCTNldhP74f86Q5/XyZ7DqvaRcJeR7MG2aTXQjR4CB7+qMzlPeelAkSwj0Ox4bCPVLMpM/c2AVjH3G6
 9lVM5/pp
 WrF35MqAU6fsHPli3qLPr3lpmrGemsQaBmOJtHWRNYqHf6v0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, DAMON does not proactively clean up invalid monitoring
targets during its runtime.  When some monitored targets exit, DAMON
still makes the following unnecessary function calls,

  --damon_for_each_target--
  --damon_for_each_region--
      damon_do_apply_schemes
        damos_apply_scheme
          damon_va_apply_scheme
            damos_madvise
              damon_get_mm

and it is only in the damon_get_mm() that it may finally discover that
the monitoring target no longer exists.

To avoid wasting CPU resources, this patch modifies the
kdamond_need_stop() logic to proactively clean up monitoring targets
when they are found to be invalid.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 mm/damon/core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f9fc0375890a..eb5612bfd6bf 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2462,7 +2462,8 @@ static void kdamond_split_regions(struct damon_ctx *ctx)
  */
 static bool kdamond_need_stop(struct damon_ctx *ctx)
 {
-	struct damon_target *t;
+	struct damon_target *t, *next;
+	bool valid_target_exist = false;
 
 	if (kthread_should_stop())
 		return true;
@@ -2470,11 +2471,16 @@ static bool kdamond_need_stop(struct damon_ctx *ctx)
 	if (!ctx->ops.target_valid)
 		return false;
 
-	damon_for_each_target(t, ctx) {
+	damon_for_each_target_safe(t, next, ctx) {
 		if (ctx->ops.target_valid(t))
-			return false;
+			valid_target_exist = true;
+		else
+			damon_destroy_target(t, ctx);
 	}
 
+	if (valid_target_exist)
+		return false;
+
 	return true;
 }
 
-- 
2.52.0


