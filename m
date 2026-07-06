Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BD3FC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCFFE6B00C0; Mon,  6 Jul 2026 10:06:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C82DF6B00C5; Mon,  6 Jul 2026 10:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B94EA6B00C9; Mon,  6 Jul 2026 10:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CDF56B00C5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:06:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 176B11A040B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:41 +0000 (UTC)
X-FDA: 84958527402.18.1DC5F1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6A41840013
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e1pre629;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783346799;
	b=IYf/OhTIMGZO7kjCTOxOYnj+4wdlW7TPb7Q95adEOG/YOyF5b2pzv6txzVJ1duUeY+KhFQ
	Y/8GGCJ7YtdEpDWYWw/n8d2XAVIZjp/8JlmIvqdoNPd5hvmFXOHriTi8lAGYQ8YEUH01d4
	FRbcRouWX1kzcWhcwDEzbVRN6PT8yuU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e1pre629;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783346799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D62Tcr+yrJC0pq2paze4YieMWP4BsC6k5oHO7N7uukw=;
	b=CARTzED4QvgNNIr1+vHMQW3U06m2ipA1syE+ztfYsr5Rsy4Vta9BCwwvFmLHcOTs86P9t7
	MWh7F10g8JEXitf4OwwibxfCd5s19596l4ZEceSB5H0aBhRqn28hFfl3XxADqNNlQQmV04
	Ywg+s/Ksccs2sZdV8TGC6MhTWiwoFbQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C006B4195F;
	Mon,  6 Jul 2026 14:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7571F00A3E;
	Mon,  6 Jul 2026 14:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783346798;
	bh=D62Tcr+yrJC0pq2paze4YieMWP4BsC6k5oHO7N7uukw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e1pre629Abm3Wss18IAovngoVEas4lAgpSXEC7hslJUpIQxq+v0nsDGk+Djmvt6qo
	 4nNwW1K9ONc9yrmK7SqGuVbeophwH2MsOJpikH/EAWdbaxQ9Bqi+GYFgqSFRfNbxhv
	 Z6kmNcgKFtrzQrfNydpo4i/PLvYi7CvcLie8DXtGsgRuuverfxs6hL8kfIbEFSOBzO
	 v+iHpK+5r6m5OOg7DNLGbQYzVK2YHUgIyrfgI1LPYayodihtSFp+CNoP8R5Gfi8N4r
	 iZg29W1l26JDLsR0DecNqzcMrxDuSC7Nthye7IhvIcN+iHIxgnWAdS7vSYMPJ2PT1g
	 WqrZ3byWxaiBQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/11] samples/damon/mtier: do not stop first context for damon_start() failure
Date: Mon,  6 Jul 2026 07:06:17 -0700
Message-ID: <20260706140628.87414-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706140628.87414-1-sj@kernel.org>
References: <20260706140628.87414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6A41840013
X-Stat-Signature: 7yup14udiczdsitkutfecadwdizcukz6
X-HE-Tag: 1783346799-904528
X-HE-Meta: U2FsdGVkX19E1S2cRWuUp2SyclTsESERS0nEmouhfkdVROKn1hV+QQFDmxwSBQd13RuR3mQMSqvpFaSs/wOkLcOsEUSigD2dT9ds7wcbsIiYx/5fx5RRYtIgeAStRCQxDELXTQxx2lveiR2zrgkS+KBat9xRRtTZpI0IRnWVCIlth6deUDcjn+lH/1X5hGfj1EVP4mcqNkvJtqA4E6zjHlY3ER+ZQHJt59ZmUt2xHAAp64ebOfKcU9AZXajQLPZUB+5+8/+6HXxHl99LFsm3odNicnNfRZSKuZ7CzhYCBY447s2Y7Aw66KtBGAANvYLlO1r+cz9cRfuMOGaBqXMBb19vNl4oeZmxGPdIjgP0sxbf2gZ/tp4IZaABOuaj49+fOC8PDUXDBfPOWv55eEfhMUsv3u7sbvXKl0GpoKJOs1AIUe0BDkx8EVFyuo3sFjs6Iu6AM8ghNLhF0ktcFYeR9vTCCUMTObB0kCQLcZm2kYtOH4gI638+mYE94kkK3va3x3dgun1RjQw3+hAERrsmx0zB75VHXNbDdcHhB/y3KuiKd+UjKXLrwep439HOThzerGGJ1n4wkJNPuYsnVMeW0pXr6THCedfvDdGOrpRC/ACdqkdT5bZ1SaN9KoHOeTaM6tx+xC5kxmAiDZUKEtfvVVy+PZW/u//oz2DLA/kPUN/0KFB3UosmqIhbO20U02+LuOQvPkTqCd8rSM34iVHkdBr0Huilc9ZjttZ7o56N76C6Gf9Pti8Rr/439cInRKeEnrU5Axyq0H46g1vLBiK4iZoSNUY48kPXsAMHW7H6GHOUniBXnTFX9zsVHLsywBfD93LltR1hrXScOafqrq8ttFtW+d9TjrNG7ieSvol7eS3IE+1fg4ReH4BOgiaSjaoTdrIv1CTsdwkqj2t91RlmaP0QN0CEA03FdPjrypvppv3K9k/b/EEOz6npv3WHJNhaOaHygVKf5/ySmHIg1tf
 tuPSyQCu
 lqPdiQeHj5yezxUpriLJReR1KgncvPnYxi3PW1RiX9fO2JUKL0sp1bVfqembXlMxOHxskwn/FfDQdoFg0+nW4Jm8vLDtFop5B70NfB3sFm5gBX5Qn6rJjGTSgEjvam55ih/F/E3AbPhg4pWA4OPPZTHL3+ws7tkfPdWgspQ6lEfcbK2XmWGm3fD0uTtklOOq1kdvoyi0rMuvDqtrqf2A3jlwCkMkX9cgudCen1uca7yWOj3fMGTED5PHzZSi3J819xDmS6tHgCwuVI/zaShptU87QqcGiNsRUxhSgxg5T0hB8Gts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_start() was able to fail while keeping the first context running.
mtier hence stops the first context in the case.  damon_start() is
refactored to avoid that.  The error handling is no longer necessary.
Remove it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/mtier.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index e567f4edd80ea..90881e8bd441f 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -193,8 +193,6 @@ static int damon_sample_mtier_start(void)
 	if (!err)
 		return 0;
 
-	if (damon_is_running(ctxs[0]))
-		damon_stop(ctxs, 1);
 	damon_destroy_ctx(ctxs[0]);
 	damon_destroy_ctx(ctxs[1]);
 	return err;
-- 
2.47.3

