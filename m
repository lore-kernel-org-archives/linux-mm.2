Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6668DC61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 03:04:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B866B0105; Wed,  2 Sep 2026 23:04:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422D26B0106; Wed,  2 Sep 2026 23:04:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33A646B0107; Wed,  2 Sep 2026 23:04:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 039D36B0105
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:04:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E7E62140400
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:04:42 +0000 (UTC)
X-FDA: 85170958404.13.749E9E3
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1E3D21A0003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:04:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P03P2mbU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788404681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZ5VZbOzOAiIg21alHu3P1D5kKDO/4ea9+shULiGmrs=;
	b=pTJ61hWKZslzBXQ5LSSCps2UWWBgVATrHPVhe0TrF30oLEUZnVG7mkyPaCimrbA5RAzmGj
	8Aj+lt9LtPkP5Kvpj7vpsQp7vmVYwKkuL8hjPCidvNpqf/yZ1cyHu+v71pHzMQalHRs2rh
	bziuv8dfLU1pEb8E4o4R/KNAOQNHxD4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P03P2mbU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788404681;
	b=J9jGwAKRlKtc5iaVAgLThleMzcC4qiU6vt3Nw0SdZtf3u42YGnAwHOPfS38vDlHGLjhtfq
	QasyPGSemAMsRYnRUTldn99m6Vu+WGIKW17pQjQvlJkc0FAKn0320UlEf/HUDwfiei0oq/
	guh6JCXM2HoJVecqb4yXhThZ8+hWO0M=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ce98cb8165so6628335ad.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 20:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788404680; x=1789009480; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PZ5VZbOzOAiIg21alHu3P1D5kKDO/4ea9+shULiGmrs=;
        b=P03P2mbUNKXXYI/RJ5xl1kLi75RoC90rLzxdxZFaikypJpuuIXF9SpvJSbft7OVkvH
         9CVyPQZ+92yxp0142O20NEdjyeQghej9MiF9pTSa/1I7yg29Cd4zUigs6NQP6Dq9468Q
         9vxWQOQjnqhBiU8VqnadpCbeg6T04Z4jH2gumO+NyjJz1XZfJGQNb/sOvX+PM6vRLE1P
         HxcjkM8A4GfYg96J0u45Xrj437vGUMIv7HZSPxe5phZSRJb6nU3y1QfiLZokltoShpxq
         qRb0XlLeeX1CEYRyf9nEnPCxNcjxi9mFxFMfRiGpCpvw2rIemopnKki0mRPnz5od9piu
         EzvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788404680; x=1789009480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PZ5VZbOzOAiIg21alHu3P1D5kKDO/4ea9+shULiGmrs=;
        b=ACM0V6ZpqzI24yKCnEhGQddiftzI9v6sGcfw0iDROxO6xHjC67JD/REqPNtpft2IQ6
         m/OsDDEmUnPg59wc2eAkxn7Yfs4ma3trKRFXRRu2UIrRo1n3ZMDfkOWdaQ4Sa5hDg3LK
         huBL1vmcLGBsfbWRcLCtJxNfU0Sl2N+ZhYmsDSpN6tWekz7oP2/2QXhTBHybLApxAQx+
         F8wmJ9tIiK9ANqvZbyn7lZPPugwKPCbAZ2lBH1bCDxzPiA9Odc2+1sXS5WPVPYSpju7C
         xvywVL9aGrG007BKS5hyt7SA+AsTCfSNDOjb6jIp+LCjD5PK4ujCEgcSQfd6taLQ3tzu
         s7eA==
X-Forwarded-Encrypted: i=1; AKwUvBwTYb1nEU7zSwceVkm6LEY0O+bVk34goimxuPBs5LYBA46bU7vz0wJBtBmMkjkz0BROLb0sK02/bg==@kvack.org
X-Gm-Message-State: AFuF++m99HKpxEpWM/bAlxyhSVoyrrKXg3X36nc+XsGsQEu0WygylCkg
	K9rrCiLTR0zaQ4rWUQUYnDLyhBZDAzq+b2Vg8QU3iFCCIpBYtrujLi1B
X-Gm-Gg: AYBFou1CVJxiZsnBxA7wTTOgdfVFI9H5CeA29ZHOaZ15FgtDqONP6X+4OCwvbcGu0oB
	N1rWuSUwkljIQlFt6fb2xcyYfPxFBdnvEqExwjkoLHmURV8k8dsBHnYvXsZ7qJ/2/qaeYI3pDqq
	OhBZjcy9iQQ57/p+S924qnkErIsUkuJZBgGswwK8lrKS6G7F2OpngrdH+mF57RAiZNDpJX+DVoJ
	stk8YOOyxfd5KYt5N+puLSdkA354B4BCnlMXhgWvcVBXuiZ+UkPyqrIZRSk7vw7fu/THqMQw5la
	DABruPZj7XwFb6nIVj1ff//7aJpSeIitGK3lRS0/UTgOjGmvLqTrBoDBqJqbasl+oakKdqzATBB
	4/JmHWx/gMBezG6s3am6Iw9+0LteUSRxgPnapaGbUa25Xp+rTDWoYDVClt+i46iefUEXXo2aOJN
	ddAPShNL3S1iT8a2YOlZ0Yu5Zc7wtorCnIzcrRc2KXifarVIWY3FDKYcON67swKD2vORnYQA==
X-Received: by 2002:a17:902:f545:b0:2d6:dcf3:b754 with SMTP id d9443c01a7336-2db020c9d24mr8716085ad.7.1788404679175;
        Wed, 02 Sep 2026 20:04:39 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dafec286d7sm2793645ad.51.2026.09.02.20.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 20:04:37 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [PATCH 08/12] mm/damon/tests/core-kunit: test overlapping ranges for set_regions()
Date: Thu,  3 Sep 2026 11:04:27 +0800
Message-ID: <20260903030429.309611-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902054747.99370-9-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1E3D21A0003
X-Stat-Signature: edgggdk8qopbjgkgfbinjadz1hf484wd
X-Rspam-User: 
X-HE-Tag: 1788404680-366886
X-HE-Meta: U2FsdGVkX1+PIiEdGR9D3xDOIUbnHhW/nPaaZlWpPcU6kxHTtviZpNZ4YQQpKyaQTkeAu20ifx2h7ssPHKhBLILdYPCTZalCM9OoTNEA5anhwk79WyR3Yc0gso/NvUA2Ui8+9BB+KqwT4VIcv062eXgBcdxhUglQ492JtcC7Vduoo4rDBgH4e4Hl1F6dGPBxi5HMAruMyc+CatKvc/KtKBeYINT1kaeMaETRnfGHV7NXeqXJdZsz8/Ns5I71BKFlcE/PcYYYYPQng5EoF6zB3fCXYGwJ/fc+qVRqDY+txjCWkM/dNGIK0jaKJIAuYUfYoFDQJKUQZUCPIP/9++Ryx0aSqVlwVV0pVh8oQMuW/UEpjGj2dWUrpTrTRry/nGUxVaf3ZTX/wG+/QV9A01AVy8vWpngTfxQV4P8pjgtsNIUU92IcCGD+veDIGclNdXlyOEKITSNzSfz1wgdq2cVAt56So7974F73obitvxpr5fZuPcyN1eetFnj116AkFqDuRK0KdWBiJU/o1yit7TBelm31vi8vJgPHs0+vftu6epSuARf9ixON0Fj25Td3airUNo3p9KnLvdhEd+utc+CHwPS7CGHFgELMa9XTZB30umoSMk2ggLhxLUUSfLuGcB+crzjCZXSwhoV8EM7hTanajt/eLtFkBuNyn/w+uJXamftXnabVzzfxr0hb5vvTtRtXkXDGmxavUuuXCdEg6F6xI5qBPTWiCDd8bw3Qisf7D/08OWqZ0bbUvTGth0h0ZoOTDE3OQ6CgWpHqF6sX0rHame/FFwFX+hLe4bd2xBvLOwzYd+DQj/JuJw0aLGAoi7JwZgYj1mXmNyehqcdSCDm1/Mhxdw711NlK8Y96iOULG+WL0QTXNMj8rJ9wXYpxcxkorGZmB5QH7oDal/6puOp01OU4abz2F2wWlkcD740/beThS3LObaZVLZuspU2LOivMTgZ9fdqcT0neFBbcK2b
 TkNFCNTr
 WyAZvpa/cvb7mMpGBp5ADUlogef3YgzlD9FFKjMUkBxFl6Ww/xZApHjotaayeVGBAy+Z3xpmtC45AlooNSGXfehMcJFixySmhirG1sPTWmC2dTDivHQDC2TbmardNKOMbUkh+TxRZBE/zePp35Je86akZFltcxy+6jxs1K4oWwjpL1qtMC9GNMCZVKlFi9mRnnDyAV6DuVBgJ/uaTPkwN6Bg3/Rk7HqCV82RtEeiGiUiQhUjOKnLn1phaIueyoJeslPM090p3nOsM9//gah15bp1hMrOk8xzRbH/g6OJVkexq8hs5P3Ivzs+pctVsCx8e6SGRbf6m51sfidof4HdlzHWnzdNj66S+nq3YewgYHRBvc7fwD4grVPxO3GH18wQCAKKdiT/oa5+JN+pnFRmYGyfmcEAxYolVDXkKFfeIUIdBXaF94cglvHLJoN2CzQb1YoAwQwmgl8VKXt6o+LseM/RownuB+zUhgWmfs2HQN4X0rh59VtZIGef28g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 22:47:41 -0700 SJ Park <sj@kernel.org> wrote:

> Commit 954157679ec3 ("mm/damon/core: disallow overlapping input ranges
> for damon_set_regions()") disallowed passing overlapping input ranges to
> damon_set_regions().  Add a kunit test case for the overlapping input.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/tests/core-kunit.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index 3cbbbcbfbef8f..a4164ac489a61 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -612,6 +612,17 @@ static void damon_test_set_regions(struct kunit *test)
>  			{.start = 42, .end = 21},
>  			}, 1, 1,
>  			(struct damon_addr_range[]){}, 0, -EINVAL);
> +	/*
> +	 * Regions resulting in same region after alignment should return
> +	 * -EINVAL.
> +	 */
> +	damon_test_set_regions_for(test,
> +			(struct damon_addr_range[]){}, 0,
> +			(struct damon_addr_range[]){
> +			{.start = 10, .end = 20},
> +			{.start = 20, .end = 30},
> +			}, 2, 4096,
> +			(struct damon_addr_range[]){}, 0, -EINVAL);
>  }
>  
>  static void damon_test_update_monitoring_result(struct kunit *test)
> -- 
> 2.47.3
> 

Hi SJ,

I reviewed patches 6-8. The test helper extension and the added
error cases look correct to me, including the overlap case after
range alignment.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu


Sent using hkml (https://github.com/sjp38/hackermail)

