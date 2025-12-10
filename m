Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5303D2CE17
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 05:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6F5B6B0006; Wed, 10 Dec 2025 00:26:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8BC6B0007; Wed, 10 Dec 2025 00:26:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7686B0008; Wed, 10 Dec 2025 00:26:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 96F716B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 00:26:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED2935897C
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 05:26:09 +0000 (UTC)
X-FDA: 84202425258.04.EBF30AB
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id E5B9140008
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 05:25:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=temperror reason="query timed out" header.from=kylinos.cn (policy=temperror);
	spf=pass (imf11.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
X-UUID: a67431ead58811f0a38c85956e01ac42-20251210
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
X-CID-O-INFO: VERSION:1.3.6,REQID:3003985e-5f7c-4672-98c6-31e9e248a8cc,IP:20,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-INFO: VERSION:1.3.6,REQID:3003985e-5f7c-4672-98c6-31e9e248a8cc,IP:20,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:15
X-CID-META: VersionHash:a9d874c,CLOUDID:310602fbf03de4f7880188d6a71b941c,BulkI
	D:251210132533GWS883M0,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil
	,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:
	0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a67431ead58811f0a38c85956e01ac42-20251210
X-User: lienze@kylinos.cn
Received: from localhost.localdomain [(223.70.160.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1115932276; Wed, 10 Dec 2025 13:25:33 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH] mm/damon/core: fix wasteful CPU calls by skipping non-existent targets
Date: Wed, 10 Dec 2025 13:25:08 +0800
Message-ID: <20251210052508.264433-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E5B9140008
X-Rspamd-Server: rspam10
X-Stat-Signature: kx5jouuuujmpf5r4rjyoytwxg4x8m745
X-HE-Tag: 1765344358-970033
X-HE-Meta: U2FsdGVkX1+hRQxNQMyafB5O2ydHXDe65xByU20ho7S41lNfM7FSURZbOUlzVX83hdeg+HqLXVeqWf/nxgiXwbrhlKE4NXNHOed3zesQY8pmKGnrikr+34REAKHbxp73+61GxAt0gC1B1FFrfr5TlbCMV00G62DVaGBV3xpO2c5Gfu8UvdqvSWBeZnxknY2qciIuOrXDd3fu+ZybXG2bhiyGHpLS7YesjVQHtPKvFNuMKVvHLmG0jE8zizO+QHAgql+3mZvdy1VmaVt7Wm8NyJsFHhMo99QdtNeM6vyLr7ZtBOD7KeNkxvFEvOLD5TRpbIGH86+7WlNa46Bgc+jdDz1Ey6SmH3oTTPCW7dwsG14Ztwz8wcflkYLzIpJtdcsLHS1XEmBVSoZ8mZ+PKwj3B0iBdir2F4sFRi6w7DdnNxVwNa3LEhUv4Jjd3HGeyZS4BSmSrcZCCRqTRbVxA6pAQOQYRY1n2OZqn/KX/+iprkjrGubSjwaz3gdms30/dT80cnOpkZOpcYXAkahKISCIiQcoE3lya597ljf9vdpCRXaNSiUMyaZBAWxV/oBvQE3fd4gkG21L+eQSFdflNsRXtnX9NkjZsvwf6G0ppXzmKsk2hPrno9i+mSwVGARgDvuf6jWHwF22z+aYM91gtxZUMuN7T6mpIu+FF++Dk7aV/mYi31QaRWXgHDTA3XWC2Ibuj7B9QhgJao5ofN+IfIYqFuHNtcQt5U27kRZV12Y0ALnk8tC116rq13ZH9bIKcEXE643i7TPOnaXIWSrjaxZ8retChFH6OUj/L7OGtil9golV0kdugOicZb0/5LNNEKsNiMAbRJn6mgmbtIO9vqaWmcpDZD+yXxyO/Kb4ArgSsgjv2n+otfIqv8T3j5y1T0WJ+0iUmfWP6rA3wL61dG8lWeML3h/pNXyfD+RKem8zMCvuPDPIDQBFn2x/U29O9KaJ4R4k4i5ZG0Qsi3OZZCm
 d0gSGuid
 exp7pxEFXRC1jbj4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, DAMON does not proactively clean up invalid monitoring
targets during its runtime.  When some monitored processes exit, DAMON
continues to make the following unnecessary function calls,

  --damon_for_each_target--
  --damon_for_each_region--
      damon_do_apply_schemes
        damos_apply_scheme
          damon_va_apply_scheme
            damos_madvise
              damon_get_mm

it is only in the damon_get_mm() function that it may finally discover
the target no longer exists, which wastes CPU resources. A simple idea
is to check for the existence of monitoring targets within the
kdamond_need_stop() function and promptly clean up non-existent targets.

However, SJ pointed out that this approach is problematic because the
online commit logic incorrectly uses list indices to update the
monitoring state.  This can lead to data loss if the target list is
changed concurrently.  Meanwhile, SJ suggests checking for target
existence at the damon_for_each_target level, and if a target does not
exist, simply skip it and proceed to the next one.

Suggested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f9fc0375890a..e43bdf0b41a8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2266,6 +2266,9 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 
 	mutex_lock(&c->walk_control_lock);
 	damon_for_each_target(t, c) {
+		if (c->ops.target_valid && c->ops.target_valid(t) == false)
+			continue;
+
 		damon_for_each_region_safe(r, next_r, t)
 			damon_do_apply_schemes(c, t, r);
 	}

base-commit: c9b47175e9131118e6f221cc8fb81397d62e7c91
-- 
2.52.0


