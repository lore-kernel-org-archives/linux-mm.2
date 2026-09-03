Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 449CAC624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 02:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E7786B00E7; Wed,  2 Sep 2026 22:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 298276B00E8; Wed,  2 Sep 2026 22:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188C46B00E9; Wed,  2 Sep 2026 22:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8E2F6B00E7
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:00:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3933840400
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:00:28 +0000 (UTC)
X-FDA: 85170796536.10.E9CC020
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 55B6FC0004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:00:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KsfsGuCn;
	spf=pass (imf22.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788400826;
	b=M7bRImyl8lh8HPSHTfRpFqW2z/iVKHvT/PT0GXO4sGQT4JN1RorSHaVb4cMKag3UDwHFFj
	42c/tay/0H8YLIgy2Rlirn+gvrVcv2+9bPdroj2UHlr8tWNPb3Qtx4L2Ej5qE4WRTZ2IAM
	Amdthv/17flmuVIEgBM3XIGWjsK+PrY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788400826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ozJ9M4cDK/IvV3gntKv2Fb/293HION6/QD0PdVWp1Zs=;
	b=WR8H4tuUQHxidzrmycA41ra2xMMLRtci3OGWKjA7VH2jRrrZy3KiuY71wQaKbw0RK4wUNA
	yU+Fplf6Z6H1HT7rVYf6s+iFb5lAxNTraZzTGMKU/h4TmIMvYH7pWFHgihQnfVt3psecCi
	UaIKdZ1kvD5aMyvL34VWs0xE7Z6ywvU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KsfsGuCn;
	spf=pass (imf22.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2d9db539a54so16566825ad.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 19:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788400825; x=1789005625; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ozJ9M4cDK/IvV3gntKv2Fb/293HION6/QD0PdVWp1Zs=;
        b=KsfsGuCnuDtHKbEas4JDDO6It4RN+AV1FEoe/eVSSfctT79kTLGQFHSb225rvyg3J/
         z4HBLmyXNNYJg9M7/7wkkdftfsIsXGCjrlXQTmneJZ//aMR4ririCXpsuIqUvHvoMojT
         F0mRoVWpU+KIEz8tog2F7QCQQ02+PlqqzLfTOVIEeJGmWAi1iUVy1XNdoVdTCOgyw5TH
         5wwCDh/3jSIxhz3tGfWFAxDw47kkRApT1xB/+qLLZCG+qBOjch6vJrnUpEYoOV0T9jvk
         0cOU9N69yqpZnKZH4g5cpbKNmjtVrlVnMtpU8QiJICi7xYROMXjIvNdZ+6V8vcJ/VX+J
         FGdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788400825; x=1789005625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ozJ9M4cDK/IvV3gntKv2Fb/293HION6/QD0PdVWp1Zs=;
        b=AG1zjLm/ce1Zrk3OQrvsOEyrWGM/DYOVApZgHDMK5oZAA8lxX3WCb0u19+aum1dlje
         pb6gyV0SmNCaVsY50EbqfMmYgCHQQWe45sijNbLTrfpL/c5zkfL39Ptwso0iVP72jW65
         nITFSl9J6GAZg5jVT0nrw1/jGvIn6qMB0opHa8QwoR9Kc6QyH2p1HPl/q24QHfHWSoSN
         3t30Kg/fbVgH16fIOOD6F21rrvS5IZOYjg5K106KX8G5neRjrUiLU1zPdyH4yUQRS2ae
         7pdXOBDRAPXwZOiiCAd2k8M93mydaej1ZKImApCOFzVU08WK78edfp5WEUaFvjaGQieE
         YjvQ==
X-Forwarded-Encrypted: i=1; AKwUvBzKK4PvZFT4kcX7G9DZAG57L62XmQWYjT+3tvZzb/R4GkxPjSN970m9pXjj49Wlho+uwaeVlzksOg==@kvack.org
X-Gm-Message-State: AFuF++lx9AutJWu7RiwpXuieFvgyLdX8uGufEO+wif+3DUc3ZDuqd/Cq
	HxwfwMuAkA3SrBrVvYX+d0Q4u28rPTxEEl5OmaumhGslVa4d+1HQ9Njy
X-Gm-Gg: AYBFou2aDfyMLjfTSCnnQHWRRStlfFImpE/viRJY++AVZk0PufjwvlSXyvszm52w+fk
	YBmyqyhZnlX8//J19+s4qld/rAZQIZE5uMTpfVaLnVO0a/Dem5BwqddeHhUEPud2yh9nz83l6yU
	eWTcWNRzu4KyPY8Kw4NMxga3xTgKsOk6czKiVvhfd/Fuk4tj/5qS7R/Qf+Qf2OEGgV7/0fEAEAH
	zRTlq16sRXVZJFL/YcY9OEnffS51mczmaFKTBILo6aPKxR72HIdtSU9MWz5CQ6mjmuggvzOEjwy
	JvgeFE7dkFSmGc7RrxDTJ88UW+x8KYHaPmiH7XvUmSFayaxSDc4KJJjttK3YxbvWW7fCPFIryNO
	2pt8iei3Kp4a6kt9TMwwOKZQbtKa8KyuJwB7psHSlkPyk7HMdRtCrPVp/px/xhJ50nzCvdgeE9U
	ND4FysI7MHVKjukkscVS64f3CY0y3CTKtkijr63TxeJ+avtj+mg8QFZDdv9F7AYRpjoZtY8g==
X-Received: by 2002:a17:90b:5107:b0:398:e6b6:acc1 with SMTP id 98e67ed59e1d1-39aee066eaamr13504509a91.15.1788400824555;
        Wed, 02 Sep 2026 19:00:24 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08ce4221sm2179825a91.14.2026.09.02.19.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 19:00:24 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [PATCH 01/12] mm/damon/core: use damon_nr_samples_per_aggr() for max merge threshold
Date: Thu,  3 Sep 2026 10:00:08 +0800
Message-ID: <20260903020012.4160595-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902054747.99370-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 55B6FC0004
X-Stat-Signature: gtbby7cygzsjkidkiur351h5n9zbym8m
X-HE-Tag: 1788400826-793122
X-HE-Meta: U2FsdGVkX1+f5cnoePCBIXuLCpNkEvki/zOM7oPtvIi9B89adUVaDoL3P68PVWpCLjBCVDSdsnbjvHOQ+SgwFPQzP/ft1LGFmA0rszOO9UoR9mD+PKT12zUXKFeQsscpvvXRXq1cX2gpaCt6cl29ioIEF5Sr5224XBtvyoqq7KhyBPudSPhYBxKMVkLjYt1BsgsfE0SpRAaeK+AeDcSXlL8vcsAPClKb88jrPN8YzUdczfhyaqaNmOga2GwHmNWup9RbVnDV4gIX8Evu8zGJr/KXH/tSkkRngYKMzBYePChFH35/8Uc/XvKRL16CpswsMvR4fo9Dqz2QBqWK9ZIwRCUx2EkIPn76PC0Cijl6o4YDI/TJDCjltUQS+FdFua4CEE0YzbORXz8tV9C3G8+jaqyODg7TRdXqYwhO2CcGEXcF2CuySwxrsdNMlXdNPCnGV9C97sjdbJdivwV2hqZuB9GQqk63pjkI6Ez5cz2gftxLIrEmXPNznzHhS6TAJo/MvUnRN3kRaskT0UI8dOL5cxI5D97Pu8CR7w46YWFm0pAN8MIIqNO50FDzi/SbYybgQt5sGyXqYJeRE/0wkrpSpzmLiBKEri54f6sPiIELdRMfcf9EQBEszr42RXN1j0OJfy2Z2ebsouV+McW4DxG+nK4Quxm1btLlZwsMlfhLpSxDNj+Qz3Q0Y0w53EVuECzf01cAOz1qgStECQpL8zRSe9VRw/vUlyF4RluBWYffQSTjjun4wiCAmuLMWuMrmYTm/Sqfzl4X/5LQ7yzef7LDHAnX8dHQkxlzc0NILBiYWU3s6r6Vtr7AUAiL6kXCxCHBGjkSa6EVDXfvPVwCCoyuocnlTDnT/ZQFN5tf2qfGuvXIZC6w0JrOR7XNxh1zvoRUhpH6dm9TLxpi5GPuxeB5rtNPJhqOC7mbNB0iuRUMvsY1K1EwXOwqMJOsh6u33+1LAi0lXIxyK+zbTZGprMp
 AFFdOZ04
 16lcfQs9ZNpd2BUJumSmLHjwbcVbpxBsR1B8PROZ8VkZDFsqr9Tv0Y222uCQQOVra/ZNfHnL8WRXuPqMbmhurpZwUeoWmFtFjOOVNVOzt4s0M8b3Mqqc1N8UqVOL88nP4HhNV03k0+1EGizLOfur265p1wu8CBUnkpy9EEBi85q/50ndcApIz5ibhAYYZ8mBzwlCHbuL5TId6d75cP0TvSZOqkrV642A9ftAm9ZOQQhwovG7qlh7MwuE0NmQnVgffg5pP3e3ZLMBFeWPoUEcUHgKnJ2Fp5rMjPRkf8ZyJw7k9tOKUkLGsvV3aVEKwNoHx7jBbEITK3aeqyQR7bHploDSU2BzCtfLEEwgjZa+3J+H/Vfy3onwuYxC9JcQPx5HeBuMFiyxf8ejMqOhLlwrZyY7Ba/o9QiFI3rD0gm+QZvrJ4CZAZ+HDZE+HscreWeqjjz4Ymr4ztlUiwEHBZSDibE+KVUXcrw9ZGzIHlfWY/NbsWU0WoIkBSj0BzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 22:47:34 -0700 SJ Park <sj@kernel.org> wrote:

> kdamond_merge_regions() open-codes max region merge threshold
> calculation.  What it does is fundamentally the same as
> damon_nr_samples_per_aggr() but missing a few corner cases.  The
> unhandled corner cases should be rare and make only a negligible level
> of monitoring results degradation.  But having the inconsistency could
> increase future maintenance burden.  Use the dedicated function.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index f748acd6bbd5b..846da6df5b552 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -3509,8 +3509,7 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
>  	unsigned int max_thres;
>  	bool count_age = true;
>  
> -	max_thres = c->attrs.aggr_interval /
> -		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
> +	max_thres = damon_nr_samples_per_aggr(&c->attrs);

The helper replacement makes sense to me, and it also keeps 
the corner-case handling centralized.


Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu


>  	while (true) {
>  		nr_regions = 0;
>  		damon_for_each_target(t, c) {
> -- 
> 2.47.3
> 

Sent using hkml (https://github.com/sjp38/hackermail)

